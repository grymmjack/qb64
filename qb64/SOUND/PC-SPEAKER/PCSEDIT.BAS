''
' PCSEDIT.BAS - PC speaker sound effect editor
'
' Draw sounds with the mouse on a piano roll, or play them in on the
' computer keyboard or a MIDI keyboard, then save them as an IFS sound bank
' (the Duke Nukem 1 / Commander Keen format) that DN1PLAY and PCSPKR.BM play.
' It opens every format PCSPKR.BM can load and saves as IFS.
'
' A sound is a list of steps, 140 per second. Each step is a PIT divisor (a
' pitch) or 0 (silence) - exactly what the games stored.
'
' Native QB64PE. MIDI input (Linux) runs ALSA's amidi tool in the background;
' it writes the keyboard's bytes to a temp file that the editor reads every
' frame - no C, no DECLARE LIBRARY.
'
' Mouse (piano roll) - Tab switches the drawing tool:
'   NOTE tool (default)  click = a steady note, Len long, at that pitch;
'                        drag right = a longer note (the pitch stays put)
'   FREE tool            left drag draws freehand, every step following
'                        the mouse (sweeps); Shift+click = straight line
'                        from the last point (slides)
'   right drag        erase (both tools)
'   wheel             scroll          Ctrl+wheel     zoom
'   click time ruler  move the cursor
'
' Notes - computer keyboard (two octaves, tracker layout):
'   Z S X D C V G B H N J M ,     lower octave (C to C)
'   Q 2 W 3 E R 5 T 6 Y 7 U I     upper octave
'   ...or any MIDI keyboard (F7 picks the device), or click and hold the
'   piano keys left of the roll to audition a pitch (drag to slide)
'
' What the notes play (Ctrl+K):
'   NOTES   plain tones - for writing a sound note by note
'   SOUND   the selected sound becomes an instrument: every note plays the
'           whole sound, transposed (C4 plays it as drawn). STEP / LIVE
'           record what you play into another sound - a new one is made if
'           the instrument itself is selected. Ctrl+H: GATE (plays while
'           held), ONE-SHOT (always plays to the end), LOOP (repeats while
'           held)
'
' Keys:
'   Space          play / stop            Enter        play from the cursor
'   Left / Right   move the cursor (a grid cell; Ctrl = a beat, or 0.1 s
'                  with the grid off)     Home / End   start / end of sound
'   Up / Down      previous / next sound
'   F5             record mode: OFF, STEP (each note = Len steps at the
'                  cursor), LIVE (records what you play, 140 steps/sec,
'                  starting with the first note; F5 / Space stops)
'   F6 snap to semitones on/off   F7 MIDI device   F9/F10 octave -/+
'   F11/F12 note length -/+ (in grid cells while the grid is on)
'   Ctrl+G / Ctrl+Shift+G   grid: off, 1/4, 1/8, 1/16, 1/32, 1/8T, 1/16T
'   Ctrl+B                  tempo (BPM) for the grid
'   Ctrl+L                  loop on/off
'   Ctrl+K                  keys play NOTES / play the selected SOUND
'   Ctrl+H                  instrument: GATE / ONE-SHOT / LOOP
'   Insert / Delete   insert / delete a step at the cursor
'   Backspace         delete the step before the cursor
'   Ctrl+Up/Down      transpose the sound a semitone (with Shift: an octave)
'   Ctrl+T            trim silence off the end
'   Ctrl+Z / Ctrl+Y   undo / redo
'   F2 rename   F3 new sound   F4 duplicate   F8 delete sound   Ctrl+P priority
'   Ctrl+N new bank   Ctrl+O open   Ctrl+S save   Ctrl+Shift+S save as
'   Ctrl+E export the sound as a .wav in EXPORT/
'   F1 help   Esc stop / cancel / quit
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'

CONST SCR_W = 1280
CONST SCR_H = 720
CONST ROW_H = 16
CONST LIST_X = 8
CONST LIST_Y = 120
CONST LIST_W = 200
CONST LIST_ROWS = 31
CONST RULER_X = 224 '                    piano keys
CONST CANVAS_X = 268 '                   piano roll
CONST CANVAS_Y = 120
CONST CANVAS_W = 1004
CONST CANVAS_H = 504
CONST TIME_Y = 100 '                     time ruler, above the roll
CONST NOTE_LO = 33 '                     A1, 55 Hz at the bottom edge
CONST NOTE_HI = 117 '                    A8, 7040 Hz at the top edge
CONST PX_SEMI = 6 '                      (NOTE_HI - NOTE_LO) * PX_SEMI = CANVAS_H
CONST MAX_SOUNDS = 300
CONST MAX_STEPS = 9000 '                 64 seconds
CONST UNDO_MAX = 100
CONST REC_OFF = 0
CONST REC_STEP = 1
CONST REC_LIVE = 2
CONST PROMPT_NONE = 0
CONST PROMPT_RENAME = 1
CONST PROMPT_PRIORITY = 2
CONST PROMPT_OPEN = 3
CONST PROMPT_SAVEAS = 4
CONST PROMPT_BPM = 5
CONST BEATS_PER_BAR = 4 '                the grid is 4/4
CONST KEYS_NOTES = 0 '                   what notes play: plain tones...
CONST KEYS_SOUND = 1 '                   ...or the instrument sound, transposed
CONST HOLD_GATE = 0
CONST HOLD_ONESHOT = 1
CONST HOLD_LOOP = 2
CONST ROOT_NOTE = 60 '                   C4 plays the instrument as drawn

' --- the bank being edited
DIM SHARED sndName(1 TO MAX_SOUNDS) AS STRING
DIM SHARED sndPri(1 TO MAX_SOUNDS) AS LONG
DIM SHARED sndData(1 TO MAX_SOUNDS) AS STRING ' 2 bytes (little endian divisor) per step
DIM SHARED sndCount AS LONG
DIM SHARED cur AS LONG
DIM SHARED listTop AS LONG
DIM SHARED savePath AS STRING ' "" until saved / saved-as in this session
DIM SHARED openedPath AS STRING
DIM SHARED dirty AS INTEGER
DIM SHARED rateHz AS DOUBLE

' --- view and editing
DIM SHARED zoom AS LONG ' pixels per step
DIM SHARED scrollX AS LONG ' first visible step
DIM SHARED cursorStep AS LONG
DIM SHARED snapOn AS INTEGER
DIM SHARED drawing AS INTEGER ' 0, 1 = drawing, 2 = erasing, 3 = placing a note
DIM SHARED freeTool AS INTEGER ' FALSE = NOTE tool, TRUE = FREE (freehand) tool
DIM SHARED noteBase AS STRING ' the sound before the note being placed
DIM SHARED noteS0 AS LONG ' where the note being placed starts
DIM SHARED noteNt AS DOUBLE ' and its pitch
DIM SHARED lastStep AS LONG
DIM SHARED lastNote AS DOUBLE
DIM SHARED haveAnchor AS INTEGER
DIM SHARED mouseStep AS LONG
DIM SHARED mouseNote AS DOUBLE
DIM SHARED mouseIn AS INTEGER
DIM SHARED undoSnd(1 TO UNDO_MAX) AS LONG
DIM SHARED undoData(1 TO UNDO_MAX) AS STRING
DIM SHARED undoN AS LONG
DIM SHARED redoSnd(1 TO UNDO_MAX) AS LONG
DIM SHARED redoData(1 TO UNDO_MAX) AS STRING
DIM SHARED redoN AS LONG

' --- playing and recording
DIM SHARED playing AS INTEGER
DIM SHARED playPos AS LONG
DIM SHARED loopOn AS INTEGER
DIM SHARED recMode AS INTEGER
DIM SHARED recording AS INTEGER
DIM SHARED recPos AS LONG
DIM SHARED recStartLen AS LONG
DIM SHARED recLastNote AS LONG
DIM SHARED noteLen AS LONG
DIM SHARED gridDiv AS LONG ' 0 = off, else cells per whole note: 4 8 16 32, 12 = 1/8T, 24 = 1/16T
DIM SHARED bpm AS DOUBLE
DIM SHARED octave AS LONG
DIM SHARED keysMode AS INTEGER
DIM SHARED instIdx AS LONG ' the instrument sound (KEYS_SOUND)
DIM SHARED holdMode AS INTEGER
DIM SHARED voiceOn AS INTEGER ' the instrument is sounding
DIM SHARED voicePos AS LONG ' its step
DIM SHARED voiceNote AS LONG ' at this pitch
DIM SHARED auditionNote AS LONG ' piano key held with the mouse (-1 = none)
DIM SHARED heldNote AS LONG ' the note sounding now (-1 = none); last pressed wins
DIM SHARED noteStamp(0 TO 127) AS LONG ' when each note went down (0 = up)
DIM SHARED stampCount AS LONG
DIM SHARED kbDown(0 TO 25) AS INTEGER ' computer keyboard piano keys held
DIM SHARED pianoKey(0 TO 25) AS STRING
DIM SHARED pianoNote(0 TO 25) AS LONG

' --- MIDI (amidi -> temp file)
DIM SHARED midiDevs(0 TO 15) AS STRING
DIM SHARED midiDevName(0 TO 15) AS STRING
DIM SHARED midiDevCount AS LONG
DIM SHARED midiDevIdx AS LONG ' -1 = off
DIM SHARED midiFile AS STRING
DIM SHARED midiFF AS LONG
DIM SHARED midiPos AS LONG
DIM SHARED midiStatus AS LONG
DIM SHARED midiD(0 TO 1) AS LONG
DIM SHARED midiCnt AS LONG
DIM SHARED midiSysex AS INTEGER

' --- UI
DIM SHARED promptKind AS INTEGER
DIM SHARED promptLabel AS STRING
DIM SHARED promptText AS STRING
DIM SHARED promptConfirm AS STRING ' Save As: path waiting for "overwrite?"
DIM SHARED confirmWhat AS STRING ' "press again to ..." guard
DIM SHARED confirmUntil AS DOUBLE
DIM SHARED statusMsg AS STRING
DIM SHARED statusUntil AS DOUBLE
DIM SHARED helpOn AS INTEGER
DIM SHARED errNum AS LONG

DIM k AS LONG, f AS STRING, wheel AS LONG, mx AS LONG, my AS LONG, b1 AS INTEGER, b2 AS INTEGER
DIM ctrl AS INTEGER, shift AS INTEGER, quitNow AS INTEGER

SCREEN _NEWIMAGE(SCR_W, SCR_H, 32)
_TITLE "PCSEDIT - PC speaker sound editor"
_ACCEPTFILEDROP ON
_PRINTMODE _KEEPBACKGROUND

' Disk and device errors must not stop the program with QB64's "Continue?"
' box: the trap records the error and carries on, and code that touches the
' disk checks errNum.
ON ERROR GOTO trap

rateHz = PCSPK_IFS_DEFAULT_HZ
zoom = 6
snapOn = -1
noteLen = 4
bpm = 120
octave = 4
heldNote = -1
auditionNote = -1
midiDevIdx = -1
init_piano

PCSPK_SetTickRate rateHz
PCSPK_SetLead 0.05

f = COMMAND$(1)
IF LEN(f) THEN
    open_bank PCSPK_FindFile(f)
END IF
IF sndCount = 0 THEN new_bank

$IF WIN THEN
$ELSE
    ' an editor that was killed can't stop its amidi; clear any leftovers
    ' (the ^amidi anchor keeps pkill to amidi itself, not shells or editors
    ' that happen to mention the path)
    SHELL _HIDE "pkill -f '^amidi .* -r /tmp/pcsedit-midi-' 2>/dev/null; rm -f /tmp/pcsedit-midi-*.raw"
$END IF
midi_scan
IF midiDevCount > 0 THEN midi_start 0

DO
    ' ------------------------------------------------------------ audio
    DO WHILE PCSPK_Tick
        on_tick
    LOOP

    ' ------------------------------------------------------------ MIDI
    midi_poll

    ' ------------------------------------------------------------ mouse
    wheel = 0
    DO WHILE _MOUSEINPUT
        wheel = wheel + _MOUSEWHEEL
        IF promptKind = PROMPT_NONE THEN handle_mouse _MOUSEX, _MOUSEY, _MOUSEBUTTON(1), _MOUSEBUTTON(2)
    LOOP
    ctrl = _KEYDOWN(100305) OR _KEYDOWN(100306)
    shift = _KEYDOWN(100303) OR _KEYDOWN(100304)
    IF wheel AND promptKind = PROMPT_NONE THEN
        IF ctrl THEN
            set_zoom zoom - SGN(wheel)
        ELSEIF _MOUSEX < RULER_X THEN
            select_sound cur + wheel
        ELSE
            scroll_to scrollX + wheel * (60 \ zoom + 1)
        END IF
    END IF

    ' ------------------------------------------------------------ keys
    k = _KEYHIT
    IF promptKind THEN
        ' take every key waiting, so pasted or fast typing shows up at once
        DO WHILE k <> 0 AND promptKind <> PROMPT_NONE
            prompt_key k
            k = _KEYHIT
        LOOP
    ELSE
        poll_piano ctrl
        IF k THEN quitNow = handle_key(k, ctrl, shift)
        IF quitNow THEN EXIT DO
    END IF

    ' ------------------------------------------------------------ drops
    IF _TOTALDROPPEDFILES THEN
        f = _DROPPEDFILE
        _FINISHDROP
        IF confirm_ok("drop") THEN open_bank f
    END IF

    draw_ui
    _DISPLAY
    _LIMIT 60
LOOP

midi_stop
PCSPK_Off
PCSPK_StreamClose
SYSTEM

trap:
errNum = ERR
RESUME NEXT


'=============================================================================
' Audio: one call per 1/140 second step, right after that step is rendered
'=============================================================================

SUB on_tick
    DIM v AS LONG
    IF playing THEN
        IF playPos >= steps_of(cur) THEN
            IF loopOn AND steps_of(cur) > 0 THEN
                playPos = 0
            ELSE
                playing = 0
                speaker 0
                EXIT SUB
            END IF
        END IF
        speaker get_step(cur, playPos)
        playPos = playPos + 1
        EXIT SUB
    END IF

    ' what the keys are playing right now
    IF keysMode = KEYS_SOUND THEN
        IF voiceOn THEN
            v = voice_div(voicePos, voiceNote)
            IF v < 0 THEN
                voiceOn = 0
                v = 0
            ELSE
                voicePos = voicePos + 1
            END IF
        END IF
    ELSEIF heldNote >= 0 THEN
        v = note_div(heldNote)
    ELSEIF auditionNote >= 0 THEN
        v = note_div(auditionNote)
    END IF

    IF recording THEN
        IF recPos < MAX_STEPS THEN
            set_step cur, recPos, v
            IF v <> 0 OR (keysMode = KEYS_SOUND AND voiceOn <> 0) THEN recLastNote = recPos
            recPos = recPos + 1
            cursorStep = recPos
            follow cursorStep
        ELSE
            stop_recording
        END IF
    END IF

    speaker v
END SUB


''
' Set the speaker's pitch, but only when it changes. Writing the PIT restarts
' its square wave, so writing the same divisor every 1/140 s would chop a
' steady note into uneven cycles - flat and buzzy instead of a clean tone.
' (The games' sound code and PCSPK_IFSRenderInto do the same.)
'
SUB speaker (v AS LONG)
    STATIC lastV AS LONG
    IF v = lastV THEN EXIT SUB
    lastV = v
    PCSPK_SetDivisor v
END SUB


''
' Step pos of the instrument played at note nt (-1 once it has finished).
' Transposing divides the divisor: an octave up halves it.
'
FUNCTION voice_div& (stepPos AS LONG, nt AS LONG)
    DIM ln AS LONG, p AS LONG, v AS LONG
    ln = steps_of(instIdx)
    p = stepPos
    IF ln = 0 THEN voice_div = -1: EXIT FUNCTION
    IF p >= ln THEN
        IF holdMode = HOLD_LOOP THEN
            p = p MOD ln
        ELSE
            voice_div = -1
            EXIT FUNCTION
        END IF
    END IF
    v = get_step(instIdx, p)
    IF v THEN
        v = CLNG(v / 2 ^ ((nt - ROOT_NOTE) / 12))
        IF v < 1 THEN v = 1
        IF v > 65534 THEN v = 65534
    END IF
    voice_div = v
END FUNCTION


SUB start_voice (n AS LONG)
    IF keysMode <> KEYS_SOUND THEN EXIT SUB
    voiceOn = -1
    voicePos = 0
    voiceNote = n
END SUB


''
' Recording with the instrument goes into another sound, never into the
' instrument itself: if it is selected, make a new sound to record into.
'
SUB ensure_target
    IF keysMode <> KEYS_SOUND OR cur <> instIdx THEN EXIT SUB
    add_sound "", ""
    sndName(cur) = LEFT$(sndName(instIdx), 7) + "_TUNE"
    set_status "Recording " + sndName(instIdx) + " into a new sound, " + sndName(cur)
END SUB


''
' Piano keys clicked with the mouse: hear the pitch, never record it.
'
SUB audition_start (n AS LONG)
    IF recording OR n < 0 OR n > 127 THEN EXIT SUB
    IF playing THEN stop_playing
    auditionNote = n
    start_voice n
END SUB


SUB audition_stop
    auditionNote = -1
    IF keysMode = KEYS_SOUND AND holdMode <> HOLD_ONESHOT AND heldNote < 0 THEN voiceOn = 0
END SUB


SUB play_from (s AS LONG)
    stop_recording
    IF steps_of(cur) = 0 THEN set_status "Nothing to play - draw or play some notes first": EXIT SUB
    playPos = s
    IF playPos >= steps_of(cur) THEN playPos = 0
    playing = -1
END SUB


SUB stop_playing
    playing = 0
    speaker 0
END SUB


''
' The step you can hear right now (the audio runs a little ahead).
'
FUNCTION heard_pos& (p AS LONG)
    DIM h AS LONG
    h = p - CLNG(PCSPK_Buffered * rateHz)
    IF h < 0 THEN h = 0
    heard_pos = h
END FUNCTION


'=============================================================================
' Notes in: computer keyboard and MIDI
'=============================================================================

SUB init_piano
    DIM lower AS STRING, upper AS STRING, i AS LONG
    lower = "zsxdcvgbhnjm,"
    upper = "q2w3er5t6y7ui"
    FOR i = 0 TO 12
        pianoKey(i) = MID$(lower, i + 1, 1): pianoNote(i) = i
        pianoKey(13 + i) = MID$(upper, i + 1, 1): pianoNote(13 + i) = 12 + i
    NEXT
END SUB


''
' Note number for a computer keyboard key: Z is C in the current octave.
'
FUNCTION kb_note& (i AS LONG)
    kb_note = (octave + 1) * 12 + pianoNote(i)
END FUNCTION


SUB poll_piano (ctrl AS INTEGER)
    DIM i AS LONG, isDown AS INTEGER, c AS STRING
    FOR i = 0 TO 25
        c = pianoKey(i)
        IF ctrl THEN
            isDown = 0 ' Ctrl+letter is a command, not a note
        ELSE
            isDown = _KEYDOWN(ASC(c)) OR _KEYDOWN(ASC(UCASE$(c)))
        END IF
        ' kbDown holds note + 1, so compare with 0 (NOT 61 is -62, still true)
        IF isDown AND kbDown(i) = 0 THEN
            kbDown(i) = kb_note(i) + 1 ' remember which note, in case the octave changes
            note_on kbDown(i) - 1
        ELSEIF NOT isDown AND kbDown(i) <> 0 THEN
            note_off kbDown(i) - 1
            kbDown(i) = 0
        END IF
    NEXT
END SUB


SUB note_on (n AS LONG)
    IF n < 0 OR n > 127 THEN EXIT SUB
    stampCount = stampCount + 1
    noteStamp(n) = stampCount
    heldNote = n
    IF playing THEN stop_playing

    SELECT CASE recMode
        CASE REC_STEP
            ensure_target
            step_enter n
        CASE REC_LIVE
            IF NOT recording THEN
                ensure_target
                push_undo
                recording = -1
                recPos = cursorStep
                recStartLen = steps_of(cur)
                recLastNote = -1
            END IF
    END SELECT
    start_voice n ' after ensure_target, which may switch sounds
END SUB


SUB note_off (n AS LONG)
    DIM i AS LONG, best AS LONG
    IF n < 0 OR n > 127 THEN EXIT SUB
    noteStamp(n) = 0
    heldNote = -1
    FOR i = 0 TO 127
        IF noteStamp(i) > best THEN best = noteStamp(i): heldNote = i
    NEXT
    ' the instrument: let go of the last key = stop (unless ONE-SHOT); with
    ' another key still down, carry on at its pitch (legato)
    IF keysMode = KEYS_SOUND AND holdMode <> HOLD_ONESHOT THEN
        IF heldNote >= 0 THEN
            voiceNote = heldNote
        ELSEIF auditionNote < 0 THEN
            voiceOn = 0
        END IF
    END IF
END SUB


''
' STEP record: write the note for noteLen steps at the cursor and move on.
'
SUB step_enter (n AS LONG)
    DIM i AS LONG, c AS LONG, s0 AS LONG, s1 AS LONG, last AS LONG, v AS LONG
    push_undo
    IF gridDiv THEN
        ' whole cells: noteLen of them, from the cell the cursor is at the
        ' start of (or the next one, if it is part way into a cell)
        c = cell_of(cursorStep)
        IF cell_start(c) < cursorStep THEN c = c + 1
        s0 = cell_start(c)
        s1 = cell_start(c + noteLen)
    ELSE
        s0 = cursorStep
        s1 = cursorStep + noteLen
    END IF

    ' the note as if held for s1 - s0 steps; a ONE-SHOT instrument always
    ' writes the whole sound (the next note may cover its tail)
    last = s1 - 1
    IF keysMode = KEYS_SOUND AND holdMode = HOLD_ONESHOT THEN
        IF s0 + steps_of(instIdx) - 1 > last THEN last = s0 + steps_of(instIdx) - 1
    END IF
    FOR i = s0 TO last
        IF i >= MAX_STEPS THEN EXIT FOR
        IF keysMode = KEYS_SOUND THEN
            v = voice_div(i - s0, n)
            IF v < 0 THEN v = 0
        ELSE
            v = note_div(n)
        END IF
        set_step cur, i, v
    NEXT
    cursorStep = s1
    IF cursorStep > MAX_STEPS THEN cursorStep = MAX_STEPS
    follow cursorStep
END SUB


SUB stop_recording
    DIM keepLen AS LONG
    IF NOT recording THEN EXIT SUB
    recording = 0
    ' drop the silence recorded after the last note (but never cut what was
    ' there before recording started)
    keepLen = recLastNote + 1
    IF keepLen < recStartLen THEN keepLen = recStartLen
    IF keepLen < steps_of(cur) THEN sndData(cur) = LEFT$(sndData(cur), keepLen * 2)
    IF recLastNote >= 0 THEN cursorStep = recLastNote + 1
    set_status "Recorded up to step" + STR$(recLastNote + 1)
END SUB


'--- MIDI ---------------------------------------------------------------------

''
' Ask amidi which MIDI inputs there are (lines like "IO  hw:4,0,0  name").
'
SUB midi_scan
    DIM tmp AS STRING, ff AS LONG, ln AS STRING, p AS LONG, dev AS STRING
    midiDevCount = 0
    $IF WIN THEN
        EXIT SUB
    $ELSE
        tmp = "/tmp/pcsedit-mididevs-" + HEX$(CLNG(TIMER(0.001) * 1000)) + ".txt"
        SHELL _HIDE "amidi -l > '" + tmp + "' 2>/dev/null"
        IF NOT _FILEEXISTS(tmp) THEN EXIT SUB
        errNum = 0
        ff = FREEFILE
        OPEN tmp FOR INPUT AS #ff
        IF errNum THEN EXIT SUB
        DO UNTIL EOF(ff) OR errNum <> 0 OR midiDevCount > 15
            LINE INPUT #ff, ln
            IF LEFT$(ln, 1) = "I" AND INSTR(ln, "hw:") THEN
                p = INSTR(ln, "hw:")
                dev = MID$(ln, p)
                dev = LEFT$(dev, INSTR(dev + " ", " ") - 1)
                midiDevs(midiDevCount) = dev
                midiDevName(midiDevCount) = _TRIM$(MID$(ln, p + LEN(dev)))
                midiDevCount = midiDevCount + 1
            END IF
        LOOP
        CLOSE #ff
        KILL tmp
    $END IF
END SUB


SUB midi_start (idx AS LONG)
    DIM ff AS LONG
    midi_stop
    IF idx < 0 OR idx >= midiDevCount THEN midiDevIdx = -1: EXIT SUB
    $IF WIN THEN
        EXIT SUB
    $ELSE
        midiFile = "/tmp/pcsedit-midi-" + HEX$(CLNG(TIMER(0.001) * 1000)) + ".raw"
        errNum = 0
        ff = FREEFILE
        OPEN midiFile FOR OUTPUT AS #ff: CLOSE #ff
        SHELL _HIDE _DONTWAIT "amidi -p " + midiDevs(idx) + " -r '" + midiFile + "' 2>/dev/null"
        midiFF = FREEFILE
        OPEN midiFile FOR BINARY ACCESS READ AS #midiFF
        IF errNum THEN midiFF = 0: set_status "Can't start MIDI input": EXIT SUB
        midiPos = 0
        midiStatus = 0
        midiCnt = 0
        midiDevIdx = idx
        set_status "MIDI input: " + midiDevName(idx) + " (" + midiDevs(idx) + ")"
    $END IF
END SUB


SUB midi_stop
    IF midiDevIdx < 0 THEN EXIT SUB
    $IF WIN THEN
    $ELSE
        SHELL _HIDE "pkill -f '^amidi .* -r " + midiFile + "' 2>/dev/null"
        IF midiFF THEN CLOSE #midiFF
        midiFF = 0
        IF _FILEEXISTS(midiFile) THEN KILL midiFile
    $END IF
    midiDevIdx = -1
END SUB


''
' Read whatever amidi has written since last time.
'
SUB midi_poll
    DIM n AS LONG, buf AS STRING, i AS LONG
    IF midiDevIdx < 0 OR midiFF = 0 THEN EXIT SUB
    errNum = 0
    n = LOF(midiFF)
    IF errNum THEN EXIT SUB
    IF n > midiPos THEN
        buf = SPACE$(n - midiPos)
        GET #midiFF, midiPos + 1, buf
        midiPos = n
        FOR i = 1 TO LEN(buf)
            midi_byte ASC(buf, i)
        NEXT
    END IF
END SUB


''
' A tiny MIDI parser: note on / note off, with running status. Everything
' else (controllers, pitch bend, clock, SysEx) is skipped.
'
SUB midi_byte (b AS LONG)
    DIM hi AS LONG, need AS LONG
    IF b >= &HF8 THEN EXIT SUB ' real-time bytes can turn up anywhere
    IF b >= &H80 THEN
        IF b = &HF0 THEN midiSysex = -1: EXIT SUB
        midiSysex = 0
        IF b >= &HF0 THEN midiStatus = 0: EXIT SUB
        midiStatus = b
        midiCnt = 0
        EXIT SUB
    END IF
    IF midiSysex OR midiStatus = 0 THEN EXIT SUB

    hi = midiStatus AND &HF0
    need = 2
    IF hi = &HC0 OR hi = &HD0 THEN need = 1
    midiD(midiCnt) = b
    midiCnt = midiCnt + 1
    IF midiCnt < need THEN EXIT SUB
    midiCnt = 0 ' running status: the next data bytes reuse midiStatus
    IF hi = &H90 AND midiD(1) > 0 THEN
        note_on midiD(0)
    ELSEIF hi = &H80 OR hi = &H90 THEN
        note_off midiD(0)
    END IF
END SUB


'=============================================================================
' Mouse
'=============================================================================

SUB handle_mouse (mx AS LONG, my AS LONG, b1 AS INTEGER, b2 AS INTEGER)
    STATIC wasDown AS INTEGER
    DIM s AS LONG, nt AS DOUBLE, shift AS INTEGER, inCanvas AS INTEGER, row AS LONG

    shift = _KEYDOWN(100303) OR _KEYDOWN(100304)
    inCanvas = mx >= CANVAS_X AND mx < CANVAS_X + CANVAS_W AND my >= CANVAS_Y AND my < CANVAS_Y + CANVAS_H
    mouseIn = inCanvas
    s = scrollX + (mx - CANVAS_X) \ zoom
    IF mx < CANVAS_X THEN s = scrollX
    IF s < 0 THEN s = 0
    IF s >= MAX_STEPS THEN s = MAX_STEPS - 1
    nt = y_note(my)
    mouseStep = s
    mouseNote = nt

    ' --- piano keys: hold to hear the pitch, drag to slide
    IF auditionNote >= 0 THEN
        IF b1 THEN
            IF INT(nt + 0.5) <> auditionNote AND my >= CANVAS_Y AND my < CANVAS_Y + CANVAS_H THEN audition_start INT(nt + 0.5)
        ELSE
            audition_stop
        END IF
        wasDown = b1 OR b2
        EXIT SUB
    END IF
    IF b1 AND NOT wasDown AND mx >= RULER_X - 30 AND mx < CANVAS_X AND my >= CANVAS_Y AND my < CANVAS_Y + CANVAS_H THEN
        audition_start INT(nt + 0.5)
        wasDown = -1
        EXIT SUB
    END IF

    ' --- drawing / erasing in the roll
    IF drawing THEN
        IF drawing = 3 AND b1 THEN
            place_note s
        ELSEIF drawing = 3 THEN
            drawing = 0
        ELSEIF drawing = 1 AND b1 THEN
            draw_line lastStep, lastNote, s, nt, 0
            lastStep = s: lastNote = nt
        ELSEIF drawing = 2 AND b2 THEN
            draw_line lastStep, lastNote, s, nt, -1
            lastStep = s: lastNote = nt
        ELSE
            drawing = 0
            haveAnchor = -1
        END IF
    ELSEIF inCanvas AND (b1 OR b2) AND NOT wasDown THEN
        push_undo
        IF playing THEN stop_playing
        IF b1 THEN drawing = 1 ELSE drawing = 2
        IF b1 AND NOT freeTool THEN
            ' NOTE tool: the pitch is fixed where you click
            drawing = 3
            noteBase = sndData(cur)
            noteNt = nt
            IF snapOn THEN noteNt = INT(nt + 0.5)
            noteS0 = s
            IF gridDiv THEN noteS0 = cell_start(cell_of(s))
            place_note s
        ELSEIF b1 AND shift AND haveAnchor THEN
            draw_line lastStep, lastNote, s, nt, 0
        ELSE
            draw_line s, nt, s, nt, (drawing = 2)
        END IF
        lastStep = s: lastNote = nt
    ELSEIF b1 AND NOT wasDown THEN
        ' --- time ruler: move the cursor
        IF my >= TIME_Y AND my < CANVAS_Y AND mx >= CANVAS_X THEN
            cursorStep = s
        ' --- sound list
        ELSEIF mx >= LIST_X AND mx < LIST_X + LIST_W AND my >= LIST_Y AND my < LIST_Y + LIST_ROWS * ROW_H THEN
            row = listTop + (my - LIST_Y) \ ROW_H + 1
            IF row <= sndCount THEN select_sound row
        END IF
    ELSEIF b1 AND my >= TIME_Y AND my < CANVAS_Y AND mx >= CANVAS_X THEN
        cursorStep = s ' drag along the ruler
    END IF
    wasDown = b1 OR b2
END SUB


''
' NOTE tool: put back the sound as it was when the button went down, then
' write one steady note from noteS0 to wherever the mouse is now - at least
' Len long (Len counts grid cells while the grid is on).
'
SUB place_note (mouseS AS LONG)
    DIM e AS LONG, i AS LONG, v AS LONG
    e = note_tool_end(noteS0)
    IF gridDiv THEN
        IF cell_start(cell_of(mouseS) + 1) > e THEN e = cell_start(cell_of(mouseS) + 1)
    ELSE
        IF mouseS + 1 > e THEN e = mouseS + 1
    END IF
    IF e > MAX_STEPS THEN e = MAX_STEPS
    sndData(cur) = noteBase
    v = note_div(noteNt)
    FOR i = noteS0 TO e - 1
        set_step cur, i, v
    NEXT
    cursorStep = e
    lastStep = e - 1: lastNote = noteNt
END SUB


''
' Where a Len-long note starting at s0 ends.
'
FUNCTION note_tool_end& (s0 AS LONG)
    IF gridDiv THEN
        note_tool_end = cell_start(cell_of(s0) + noteLen)
    ELSE
        note_tool_end = s0 + noteLen
    END IF
END FUNCTION


''
' Set every step from s0 to s1 along a straight line in pitch (or to
' silence when erasing).
'
SUB draw_line (s0 AS LONG, n0 AS DOUBLE, s1 AS LONG, n1 AS DOUBLE, erasing AS INTEGER)
    DIM a AS LONG, b AS LONG, na AS DOUBLE, nb AS DOUBLE, s AS LONG, nt AS DOUBLE
    DIM ca AS LONG, cb AS LONG, c AS LONG, v AS LONG
    IF s0 <= s1 THEN
        a = s0: b = s1: na = n0: nb = n1
    ELSE
        a = s1: b = s0: na = n1: nb = n0
    END IF

    ' grid on: whole cells, one pitch per cell
    IF gridDiv THEN
        ca = cell_of(a)
        cb = cell_of(b)
        FOR c = ca TO cb
            IF cb > ca THEN nt = na + (nb - na) * (c - ca) / (cb - ca) ELSE nt = na
            IF snapOn THEN nt = INT(nt + 0.5)
            v = note_div(nt)
            FOR s = cell_start(c) TO cell_start(c + 1) - 1
                IF erasing THEN
                    IF s < steps_of(cur) THEN set_step cur, s, 0
                ELSE
                    set_step cur, s, v
                END IF
            NEXT
        NEXT
        EXIT SUB
    END IF

    FOR s = a TO b
        IF erasing THEN
            IF s < steps_of(cur) THEN set_step cur, s, 0
        ELSE
            IF b > a THEN nt = na + (nb - na) * (s - a) / (b - a) ELSE nt = na
            IF snapOn THEN nt = INT(nt + 0.5)
            set_step cur, s, note_div(nt)
        END IF
    NEXT
END SUB


'=============================================================================
' Keyboard commands
'=============================================================================

FUNCTION handle_key% (k AS LONG, ctrl AS INTEGER, shift AS INTEGER)
    SELECT CASE k
        CASE 27 '                                              Esc
            IF helpOn THEN
                helpOn = 0
            ELSEIF recording THEN
                stop_recording
            ELSEIF playing THEN
                stop_playing
            ELSEIF confirm_ok("quit") THEN
                handle_key = -1
            END IF
        CASE 32 '                                              Space
            IF recording THEN
                stop_recording
            ELSEIF playing THEN
                stop_playing
            ELSE
                play_from 0
            END IF
        CASE 13: play_from cursorStep '                        Enter
        CASE 19200 '                                           Left
            IF gridDiv THEN
                IF ctrl THEN move_cursor grid_prev(cursorStep, beat_cells) ELSE move_cursor grid_prev(cursorStep, 1)
            ELSE
                IF ctrl THEN move_cursor cursorStep - 14 ELSE move_cursor cursorStep - 1
            END IF
        CASE 19712 '                                           Right
            IF gridDiv THEN
                IF ctrl THEN move_cursor grid_next(cursorStep, beat_cells) ELSE move_cursor grid_next(cursorStep, 1)
            ELSE
                IF ctrl THEN move_cursor cursorStep + 14 ELSE move_cursor cursorStep + 1
            END IF
        CASE 18176: move_cursor 0 '                            Home
        CASE 20224: move_cursor steps_of(cur) '                End
        CASE 18432 '                                           Up
            IF ctrl THEN
                IF shift THEN transpose 12 ELSE transpose 1
            ELSE
                select_sound cur - 1
            END IF
        CASE 20480 '                                           Down
            IF ctrl THEN
                IF shift THEN transpose -12 ELSE transpose -1
            ELSE
                select_sound cur + 1
            END IF
        CASE 18688: select_sound cur - LIST_ROWS '             PgUp
        CASE 20736: select_sound cur + LIST_ROWS '             PgDn
        CASE 20992: insert_step '                              Insert
        CASE 21248: delete_step cursorStep '                   Delete
        CASE 8 '                                               Backspace
            IF cursorStep > 0 THEN
                cursorStep = cursorStep - 1
                delete_step cursorStep
            END IF
        CASE 15104: helpOn = NOT helpOn '                      F1
        CASE 9 '                                               Tab
            freeTool = NOT freeTool
            IF freeTool THEN
                set_status "FREE tool: drag to draw freehand (sweeps), Shift+click for a straight line"
            ELSE
                set_status "NOTE tool: click = a steady note Len long, drag right = longer"
            END IF
        CASE 15360: start_prompt PROMPT_RENAME, "Name (up to 12 characters):", sndName(cur) ' F2
        CASE 15616: add_sound "", "" '                         F3
        CASE 15872: add_sound sndName(cur), sndData(cur) '     F4
        CASE 16128 '                                           F5
            stop_recording
            recMode = (recMode + 1) MOD 3
            SELECT CASE recMode
                CASE REC_OFF: set_status "Record OFF - notes only preview"
                CASE REC_STEP: set_status "STEP record: each note writes" + STR$(noteLen) + " steps at the cursor"
                CASE REC_LIVE: set_status "LIVE record: starts with your first note, F5 or Space stops"
            END SELECT
        CASE 16384 '                                           F6
            snapOn = NOT snapOn
            IF snapOn THEN set_status "Snap to semitones ON" ELSE set_status "Snap OFF - free pitch"
        CASE 16640 '                                           F7
            IF midiDevCount = 0 THEN midi_scan
            IF midiDevCount = 0 THEN
                set_status "No MIDI inputs found (needs amidi from alsa-utils)"
            ELSEIF midiDevIdx + 1 >= midiDevCount THEN
                midi_stop
                set_status "MIDI input off"
            ELSE
                midi_start midiDevIdx + 1
            END IF
        CASE 16896 '                                           F8
            IF confirm_ok("delete") THEN delete_sound
        CASE 17152: set_octave octave - 1 '                    F9
        CASE 17408: set_octave octave + 1 '                    F10
        CASE 34048: set_note_len noteLen - 1 '                 F11
        CASE 34304: set_note_len noteLen + 1 '                 F12
        CASE ELSE
            IF ctrl THEN
                SELECT CASE ctrl_letter$(k)
                    CASE "Z": undo
                    CASE "Y": redo
                    CASE "L"
                        loopOn = NOT loopOn
                        IF loopOn THEN set_status "Loop ON" ELSE set_status "Loop OFF"
                    CASE "T": trim_end
                    CASE "P": start_prompt PROMPT_PRIORITY, "Priority (0-255, higher wins in the game):", LTRIM$(STR$(sndPri(cur)))
                    CASE "N"
                        IF confirm_ok("new") THEN new_bank: set_status "New bank"
                    CASE "O"
                        IF confirm_ok("open") THEN start_prompt PROMPT_OPEN, "Open (any bank DN1PLAY can play):", default_dir
                    CASE "S"
                        IF shift OR savePath = "" THEN
                            start_prompt PROMPT_SAVEAS, "Save as IFS bank:", suggest_save
                        ELSE
                            save_bank savePath
                        END IF
                    CASE "E": export_wav
                    CASE "K": toggle_keys_mode
                    CASE "H"
                        holdMode = (holdMode + 1) MOD 3
                        set_status "Instrument plays " + hold_name + " - " + hold_help
                    CASE "G"
                        IF shift THEN cycle_grid -1 ELSE cycle_grid 1
                    CASE "B": start_prompt PROMPT_BPM, "Tempo in BPM (20-400):", LTRIM$(STR$(bpm))
                END SELECT
            END IF
    END SELECT
END FUNCTION


''
' The letter of a Ctrl+letter key, whether _KEYHIT reports the letter or
' the control character.
'
FUNCTION ctrl_letter$ (k AS LONG)
    IF k >= 1 AND k <= 26 THEN
        ctrl_letter = CHR$(64 + k)
    ELSEIF (k >= 65 AND k <= 90) OR (k >= 97 AND k <= 122) THEN
        ctrl_letter = UCASE$(CHR$(k))
    END IF
END FUNCTION


''
' Guard for actions that throw work away: with unsaved changes the first
' press only warns, a second press within 3 seconds goes ahead.
'
FUNCTION confirm_ok% (what AS STRING)
    IF NOT dirty AND what <> "delete" THEN confirm_ok = -1: EXIT FUNCTION
    IF confirmWhat = what AND TIMER(0.001) < confirmUntil AND TIMER(0.001) > confirmUntil - 10 THEN
        confirmWhat = ""
        confirm_ok = -1
        EXIT FUNCTION
    END IF
    confirmWhat = what
    confirmUntil = TIMER(0.001) + 3
    SELECT CASE what
        CASE "delete": set_status "Delete " + sndName(cur) + "? Press F8 again to delete it"
        CASE "drop": set_status "Unsaved changes - drop the file again to open it anyway"
        CASE ELSE: set_status "Unsaved changes - press again to " + what + " anyway"
    END SELECT
END FUNCTION


''
' Ctrl+K: plain notes <-> the selected sound as an instrument. With a
' different sound selected than the instrument, it becomes the instrument.
'
SUB toggle_keys_mode
    voiceOn = 0
    stop_recording
    IF keysMode = KEYS_SOUND AND cur = instIdx THEN
        keysMode = KEYS_NOTES
        set_status "Keys play plain NOTES"
        EXIT SUB
    END IF
    IF steps_of(cur) = 0 THEN set_status "This sound is empty - draw something first, then Ctrl+K": EXIT SUB
    keysMode = KEYS_SOUND
    instIdx = cur
    set_status "Keys play " + sndName(cur) + " (C4 = as drawn), " + hold_name + ". Recording goes into another sound."
END SUB


FUNCTION hold_name$
    SELECT CASE holdMode
        CASE HOLD_GATE: hold_name = "GATE"
        CASE HOLD_ONESHOT: hold_name = "ONE-SHOT"
        CASE HOLD_LOOP: hold_name = "LOOP"
    END SELECT
END FUNCTION


FUNCTION hold_help$
    SELECT CASE holdMode
        CASE HOLD_GATE: hold_help = "sounds while the key is held"
        CASE HOLD_ONESHOT: hold_help = "always plays to the end"
        CASE HOLD_LOOP: hold_help = "repeats while the key is held"
    END SELECT
END FUNCTION


SUB set_octave (o AS LONG)
    octave = o
    IF octave < 1 THEN octave = 1
    IF octave > 7 THEN octave = 7
    set_status "Keyboard octave" + STR$(octave) + " (Z = C" + LTRIM$(STR$(octave)) + ")"
END SUB


'-----------------------------------------------------------------------------
' Musical grid
'
' gridDiv cells per whole note (4 = quarter notes, 16 = sixteenths, 12 and
' 24 = eighth and sixteenth triplets) at bpm beats per minute, 4/4 time.
' A cell is rarely a whole number of steps (1/16 at 120 BPM = 17.5 steps),
' so cell k starts at step ROUND(k * cell_steps): cells come out 17 and 18
' steps long in turn and never drift from the tempo.
'-----------------------------------------------------------------------------

FUNCTION cell_steps#
    IF gridDiv = 0 THEN cell_steps = 1: EXIT FUNCTION
    cell_steps = 4 * 60 * rateHz / (bpm * gridDiv)
END FUNCTION


FUNCTION cell_start& (c AS LONG)
    cell_start = INT(c * cell_steps + 0.5)
END FUNCTION


''
' The cell that step s is in.
'
FUNCTION cell_of& (s AS LONG)
    DIM c AS LONG
    c = INT(s / cell_steps)
    DO WHILE cell_start(c + 1) <= s: c = c + 1: LOOP
    DO WHILE c > 0 AND cell_start(c) > s: c = c - 1: LOOP
    cell_of = c
END FUNCTION


''
' Cells in one beat (a quarter note).
'
FUNCTION beat_cells&
    beat_cells = gridDiv \ 4
    IF gridDiv \ 4 < 1 THEN beat_cells = 1
END FUNCTION


''
' The start of the n-th cell after / before step s.
'
FUNCTION grid_next& (s AS LONG, n AS LONG)
    grid_next = cell_start(cell_of(s) + n)
END FUNCTION


FUNCTION grid_prev& (s AS LONG, n AS LONG)
    DIM c AS LONG
    c = cell_of(s)
    IF cell_start(c) < s THEN c = c + 1 ' part way into a cell: count from its start
    c = c - n
    IF c < 0 THEN c = 0
    grid_prev = cell_start(c)
END FUNCTION


FUNCTION grid_name$
    SELECT CASE gridDiv
        CASE 0: grid_name = "off"
        CASE 12: grid_name = "1/8T"
        CASE 24: grid_name = "1/16T"
        CASE ELSE: grid_name = "1/" + LTRIM$(STR$(gridDiv))
    END SELECT
END FUNCTION


FUNCTION grid_info$
    IF gridDiv = 0 THEN grid_info = "": EXIT FUNCTION
    grid_info = " - grid " + grid_name + ", " + fmt2(cell_steps) + " steps a cell"
END FUNCTION


SUB cycle_grid (dirn AS LONG)
    DIM order AS STRING, i AS LONG, n AS LONG
    DIM divs(0 TO 6) AS LONG
    divs(0) = 0: divs(1) = 4: divs(2) = 8: divs(3) = 16: divs(4) = 32: divs(5) = 12: divs(6) = 24
    FOR i = 0 TO 6
        IF divs(i) = gridDiv THEN n = i
    NEXT
    n = (n + dirn + 7) MOD 7
    gridDiv = divs(n)
    IF gridDiv THEN
        set_status "Grid " + grid_name + " at" + STR$(bpm) + " BPM = " + fmt2(cell_steps) + " steps a cell (Ctrl+B tempo)"
        IF cell_steps < 2 THEN set_status "Grid " + grid_name + " is finer than 2 steps at" + STR$(bpm) + " BPM - try a slower tempo"
    ELSE
        set_status "Grid off - free drawing, step by step"
    END IF
END SUB


SUB set_note_len (n AS LONG)
    noteLen = n
    IF noteLen < 1 THEN noteLen = 1
    IF noteLen > 140 THEN noteLen = 140
    IF gridDiv THEN
        set_status "Note length" + STR$(noteLen) + " grid cell(s) of " + grid_name
    ELSE
        set_status "Note length" + STR$(noteLen) + " steps (" + fmt2(noteLen / rateHz) + " s)"
    END IF
END SUB


SUB set_zoom (z AS LONG)
    DIM centre AS LONG
    centre = scrollX + (CANVAS_W \ zoom) \ 2
    zoom = z
    IF zoom < 1 THEN zoom = 1
    IF zoom > 24 THEN zoom = 24
    scroll_to centre - (CANVAS_W \ zoom) \ 2
END SUB


SUB scroll_to (s AS LONG)
    scrollX = s
    IF scrollX > MAX_STEPS - CANVAS_W \ zoom THEN scrollX = MAX_STEPS - CANVAS_W \ zoom
    IF scrollX < 0 THEN scrollX = 0
END SUB


''
' Scroll so that step s is on screen.
'
SUB follow (s AS LONG)
    DIM vis AS LONG
    vis = CANVAS_W \ zoom
    IF s < scrollX THEN scroll_to s - vis \ 4
    IF s >= scrollX + vis THEN scroll_to s - vis \ 4
END SUB


SUB move_cursor (s AS LONG)
    cursorStep = s
    IF cursorStep < 0 THEN cursorStep = 0
    IF cursorStep > MAX_STEPS THEN cursorStep = MAX_STEPS
    follow cursorStep
END SUB


'=============================================================================
' Prompts (rename, priority, open, save as)
'=============================================================================

SUB start_prompt (kind AS INTEGER, label AS STRING, text AS STRING)
    promptKind = kind
    promptLabel = label
    promptText = text
    promptConfirm = ""
END SUB


SUB prompt_key (k AS LONG)
    DIM t AS STRING, v AS LONG
    SELECT CASE k
        CASE 27
            promptKind = PROMPT_NONE
        CASE 8
            IF LEN(promptText) THEN promptText = LEFT$(promptText, LEN(promptText) - 1)
            promptConfirm = ""
        CASE 21248 '                                   Delete clears the field
            promptText = ""
            promptConfirm = ""
        CASE 13
            t = _TRIM$(promptText)
            SELECT CASE promptKind
                CASE PROMPT_RENAME
                    IF LEN(t) THEN
                        sndName(cur) = LEFT$(t, 12)
                        dirty = -1
                    END IF
                    promptKind = PROMPT_NONE
                CASE PROMPT_PRIORITY
                    v = VAL(t)
                    IF v < 0 THEN v = 0
                    IF v > 255 THEN v = 255
                    sndPri(cur) = v
                    dirty = -1
                    promptKind = PROMPT_NONE
                CASE PROMPT_BPM
                    IF VAL(t) >= 20 AND VAL(t) <= 400 THEN
                        bpm = VAL(t)
                        set_status "Tempo" + STR$(bpm) + " BPM" + grid_info
                    ELSE
                        set_status "Tempo has to be between 20 and 400 BPM"
                    END IF
                    promptKind = PROMPT_NONE
                CASE PROMPT_OPEN
                    promptKind = PROMPT_NONE
                    IF LEN(t) THEN open_bank t
                CASE PROMPT_SAVEAS
                    IF LEN(t) = 0 THEN EXIT SUB
                    IF _FILEEXISTS(t) AND promptConfirm <> t THEN
                        promptConfirm = t
                        set_status "That file exists - press Enter again to replace it"
                        EXIT SUB
                    END IF
                    promptKind = PROMPT_NONE
                    save_bank t
            END SELECT
        CASE 32 TO 126
            IF LEN(promptText) < 200 THEN promptText = promptText + CHR$(k)
            promptConfirm = ""
    END SELECT
END SUB


'=============================================================================
' The bank: sounds and steps
'=============================================================================

FUNCTION steps_of& (i AS LONG)
    IF i < 1 OR i > sndCount THEN EXIT FUNCTION
    steps_of = LEN(sndData(i)) \ 2
END FUNCTION


FUNCTION get_step& (i AS LONG, s AS LONG)
    IF s < 0 OR s >= steps_of(i) THEN EXIT FUNCTION
    get_step = ASC(sndData(i), s * 2 + 1) + ASC(sndData(i), s * 2 + 2) * 256&
END FUNCTION


''
' Set step s of sound i, growing the sound with silence if needed.
'
SUB set_step (i AS LONG, s AS LONG, v AS LONG)
    DIM need AS LONG, d AS LONG
    IF i < 1 OR i > sndCount OR s < 0 OR s >= MAX_STEPS THEN EXIT SUB
    d = v
    IF d < 0 THEN d = 0
    IF d > 65534 THEN d = 65534 ' 65535 ($FFFF) marks the end of a sound
    need = s * 2 + 2
    IF LEN(sndData(i)) < need THEN sndData(i) = sndData(i) + STRING$(need - LEN(sndData(i)), 0)
    MID$(sndData(i), s * 2 + 1, 2) = CHR$(d AND 255) + CHR$(d \ 256)
    dirty = -1
END SUB


FUNCTION note_div& (nt AS DOUBLE)
    note_div = CLNG(PCSPK_PIT_HZ / note_hz(nt))
END FUNCTION


FUNCTION note_hz# (nt AS DOUBLE)
    note_hz = 440 * 2 ^ ((nt - 69) / 12)
END FUNCTION


FUNCTION div_note# (d AS LONG)
    IF d <= 0 THEN EXIT FUNCTION
    div_note = 69 + 12 * LOG(PCSPK_PIT_HZ / d / 440) / LOG(2)
END FUNCTION


FUNCTION note_name$ (nt AS DOUBLE)
    DIM n AS LONG
    n = INT(nt + 0.5)
    note_name = _TRIM$(MID$("C C#D D#E F F#G G#A A#B ", (n MOD 12) * 2 + 1, 2)) + LTRIM$(STR$(n \ 12 - 1))
END FUNCTION


SUB new_bank
    stop_playing
    stop_recording
    sndCount = 0
    keysMode = KEYS_NOTES
    voiceOn = 0
    instIdx = 0
    add_sound "", ""
    savePath = ""
    openedPath = ""
    undoN = 0
    redoN = 0
    dirty = 0
END SUB


''
' Add a sound after the current one. A blank name makes a new empty sound;
' otherwise it is a copy (F4).
'
SUB add_sound (nam AS STRING, dat AS STRING)
    DIM i AS LONG, at AS LONG
    IF sndCount >= MAX_SOUNDS THEN set_status "The bank is full (" + LTRIM$(STR$(MAX_SOUNDS)) + " sounds)": EXIT SUB
    at = cur + 1
    IF at < 1 THEN at = 1
    IF at > sndCount + 1 THEN at = sndCount + 1
    FOR i = sndCount TO at STEP -1
        sndName(i + 1) = sndName(i): sndPri(i + 1) = sndPri(i): sndData(i + 1) = sndData(i)
    NEXT
    sndCount = sndCount + 1
    IF nam = "" THEN
        sndName(at) = "SOUND" + LTRIM$(STR$(sndCount))
        sndPri(at) = 10
        sndData(at) = ""
    ELSE
        sndName(at) = LEFT$(nam, 10) + "_2"
        sndPri(at) = sndPri(cur)
        sndData(at) = dat
    END IF
    fix_undo_after_insert at
    IF at <= instIdx THEN instIdx = instIdx + 1
    select_sound at
    dirty = -1
END SUB


SUB delete_sound
    DIM i AS LONG
    stop_playing
    stop_recording
    IF sndCount <= 1 THEN
        sndData(1) = ""
        set_status "Cleared the only sound"
    ELSE
        set_status "Deleted " + sndName(cur)
        IF cur = instIdx THEN keysMode = KEYS_NOTES: voiceOn = 0
        IF cur < instIdx THEN instIdx = instIdx - 1
        FOR i = cur TO sndCount - 1
            sndName(i) = sndName(i + 1): sndPri(i) = sndPri(i + 1): sndData(i) = sndData(i + 1)
        NEXT
        sndCount = sndCount - 1
    END IF
    undoN = 0 ' snapshots point at sound numbers that just moved
    redoN = 0
    select_sound cur
    dirty = -1
END SUB


''
' Undo snapshots name sounds by number; shift them when a sound is inserted.
'
SUB fix_undo_after_insert (at AS LONG)
    DIM i AS LONG
    FOR i = 1 TO undoN
        IF undoSnd(i) >= at THEN undoSnd(i) = undoSnd(i) + 1
    NEXT
    FOR i = 1 TO redoN
        IF redoSnd(i) >= at THEN redoSnd(i) = redoSnd(i) + 1
    NEXT
END SUB


SUB select_sound (i AS LONG)
    IF playing THEN stop_playing
    stop_recording
    cur = i
    IF cur > sndCount THEN cur = sndCount
    IF cur < 1 THEN cur = 1
    IF cur - 1 < listTop THEN listTop = cur - 1
    IF cur - 1 >= listTop + LIST_ROWS THEN listTop = cur - LIST_ROWS
    IF cursorStep > steps_of(cur) THEN cursorStep = steps_of(cur)
    haveAnchor = 0
    follow cursorStep
END SUB


SUB insert_step
    DIM p AS LONG
    IF steps_of(cur) >= MAX_STEPS THEN EXIT SUB
    push_undo
    IF cursorStep > steps_of(cur) THEN set_step cur, cursorStep - 1, 0
    p = cursorStep * 2
    sndData(cur) = LEFT$(sndData(cur), p) + STRING$(2, 0) + MID$(sndData(cur), p + 1)
    dirty = -1
END SUB


SUB delete_step (s AS LONG)
    IF s < 0 OR s >= steps_of(cur) THEN EXIT SUB
    push_undo
    sndData(cur) = LEFT$(sndData(cur), s * 2) + MID$(sndData(cur), s * 2 + 3)
    dirty = -1
END SUB


SUB transpose (semis AS LONG)
    DIM s AS LONG, v AS LONG, f AS DOUBLE
    IF steps_of(cur) = 0 THEN EXIT SUB
    push_undo
    f = 2 ^ (-semis / 12)
    FOR s = 0 TO steps_of(cur) - 1
        v = get_step(cur, s)
        IF v THEN
            v = CLNG(v * f)
            IF v < 1 THEN v = 1
            set_step cur, s, v
        END IF
    NEXT
    set_status "Transposed" + STR$(semis) + " semitone(s)"
END SUB


SUB trim_end
    DIM n AS LONG
    n = steps_of(cur)
    DO WHILE n > 0
        IF get_step(cur, n - 1) THEN EXIT DO
        n = n - 1
    LOOP
    IF n = steps_of(cur) THEN set_status "No silence at the end": EXIT SUB
    push_undo
    sndData(cur) = LEFT$(sndData(cur), n * 2)
    IF cursorStep > n THEN cursorStep = n
    dirty = -1
    set_status "Trimmed to" + STR$(n) + " steps"
END SUB


'--- undo / redo ----------------------------------------------------------------

SUB push_undo
    DIM i AS LONG
    IF undoN = UNDO_MAX THEN
        FOR i = 1 TO UNDO_MAX - 1
            undoSnd(i) = undoSnd(i + 1): undoData(i) = undoData(i + 1)
        NEXT
        undoN = UNDO_MAX - 1
    END IF
    undoN = undoN + 1
    undoSnd(undoN) = cur
    undoData(undoN) = sndData(cur)
    redoN = 0
END SUB


SUB undo
    DIM s AS LONG
    IF undoN = 0 THEN set_status "Nothing to undo": EXIT SUB
    stop_playing
    s = undoSnd(undoN)
    IF redoN < UNDO_MAX THEN redoN = redoN + 1
    redoSnd(redoN) = s: redoData(redoN) = sndData(s)
    sndData(s) = undoData(undoN)
    undoN = undoN - 1
    IF s <> cur THEN select_sound s
    dirty = -1
END SUB


SUB redo
    DIM s AS LONG
    IF redoN = 0 THEN set_status "Nothing to redo": EXIT SUB
    stop_playing
    s = redoSnd(redoN)
    IF undoN < UNDO_MAX THEN undoN = undoN + 1
    undoSnd(undoN) = s: undoData(undoN) = sndData(s)
    sndData(s) = redoData(redoN)
    redoN = redoN - 1
    IF s <> cur THEN select_sound s
    dirty = -1
END SUB


'=============================================================================
' Files
'=============================================================================

''
' Open any bank PCSPKR.BM understands; every sound comes in as divisors.
'
SUB open_bank (fileName AS STRING)
    DIM i AS LONG, n AS LONG, ok AS INTEGER, full AS STRING, d AS STRING, v AS LONG

    errNum = 0
    full = _FULLPATH$(fileName)
    IF errNum OR full = "" THEN full = fileName
    errNum = 0
    ok = PCSPK_IFSLoad(full)
    IF errNum THEN set_status "Can't read " + full: EXIT SUB
    IF NOT ok THEN set_status "No PC speaker sounds in " + full: EXIT SUB

    stop_playing
    stop_recording
    sndCount = 0
    keysMode = KEYS_NOTES
    voiceOn = 0
    instIdx = 0
    FOR i = 0 TO PCSPK_IFSCount - 1
        IF sndCount >= MAX_SOUNDS THEN EXIT FOR
        sndCount = sndCount + 1
        sndName(sndCount) = LEFT$(PCSPK_IFSName(i), 12)
        sndPri(sndCount) = PCSPK_IFSPriority(i)
        d = SPACE$(PCSPK_IFSSamples(i) * 2)
        FOR n = 0 TO PCSPK_IFSSamples(i) - 1
            v = PCSPK_IFSValue(i, n)
            IF v > 65534 THEN v = 65534
            MID$(d, n * 2 + 1, 2) = CHR$(v AND 255) + CHR$(v \ 256)
        NEXT
        sndData(sndCount) = d
    NEXT
    openedPath = full
    savePath = "" ' never overwrite a game's file by accident: first save asks
    undoN = 0
    redoN = 0
    dirty = 0
    cur = 1
    listTop = 0
    cursorStep = 0
    scrollX = 0
    set_status "Opened " + PCSPK_FilePart(full) + " -" + STR$(sndCount) + " sounds (Ctrl+S saves a copy as an IFS bank)"
END SUB


''
' Save as an IFS bank: "SND",0 header, a 16-byte entry per sound, then each
' sound's divisors ending with $FFFF. Offsets are 16-bit, so the whole file
' has to stay under 64 KB.
'
SUB save_bank (fileName AS STRING)
    DIM hdr AS STRING, tbl AS STRING, body AS STRING, i AS LONG, ofs AS LONG, total AS LONG
    DIM ff AS LONG, nm AS STRING

    ofs = 16 + sndCount * 16
    FOR i = 1 TO sndCount
        nm = LEFT$(sndName(i) + STRING$(12, 0), 12)
        tbl = tbl + u16$(ofs + LEN(body)) + CHR$(sndPri(i) AND 255) + CHR$(8) + nm
        body = body + sndData(i) + CHR$(255) + CHR$(255)
    NEXT
    total = ofs + LEN(body)
    IF total > 65535 THEN
        set_status "Too big for an IFS bank (" + LTRIM$(STR$(total)) + " bytes, the limit is 65535) - shorten or split it"
        EXIT SUB
    END IF
    hdr = "SND" + CHR$(0) + u16$(total) + u16$(sndCount) + u16$(0) + STRING$(6, 0)

    errNum = 0
    IF _FILEEXISTS(fileName) THEN KILL fileName
    ff = FREEFILE
    OPEN fileName FOR BINARY AS #ff
    IF errNum = 0 THEN
        hdr = hdr + tbl + body
        PUT #ff, 1, hdr
        CLOSE #ff
    END IF
    IF errNum THEN set_status "Couldn't save " + fileName + " (error" + STR$(errNum) + ")": EXIT SUB
    savePath = fileName
    dirty = 0
    set_status "Saved " + fileName + " -" + STR$(sndCount) + " sounds," + STR$(total) + " bytes"
END SUB


FUNCTION u16$ (v AS LONG)
    u16 = CHR$(v AND 255) + CHR$((v \ 256) AND 255)
END FUNCTION


FUNCTION default_dir$
    DIM d AS STRING
    d = _STARTDIR$
    IF RIGHT$(d, 1) <> "/" AND RIGHT$(d, 1) <> "\" THEN d = d + "/"
    IF _DIREXISTS(d + "ASSETS") THEN d = d + "ASSETS/"
    default_dir = d
END FUNCTION


''
' A name for Save As: the bank you opened with .SND on the end (so a game's
' own file isn't replaced), or ASSETS/MYSOUNDS.SND for a new bank.
'
FUNCTION suggest_save$
    DIM p AS LONG
    IF LEN(savePath) THEN suggest_save = savePath: EXIT FUNCTION
    IF LEN(openedPath) THEN
        p = _INSTRREV(openedPath, ".")
        IF p > _INSTRREV(openedPath, "/") AND p > _INSTRREV(openedPath, "\") THEN
            suggest_save = LEFT$(openedPath, p - 1) + "-EDIT.SND"
        ELSE
            suggest_save = openedPath + "-EDIT.SND"
        END IF
    ELSE
        suggest_save = default_dir + "MYSOUNDS.SND"
    END IF
END FUNCTION


''
' Render the current sound through the emulated speaker into a .wav.
'
SUB export_wav
    DIM s AS LONG, h AS LONG, outName AS STRING, bankName AS STRING, v AS LONG, lastV AS LONG
    IF steps_of(cur) = 0 THEN set_status "Nothing to export": EXIT SUB
    stop_playing
    errNum = 0
    IF NOT _DIREXISTS("EXPORT") THEN MKDIR "EXPORT"
    bankName = "NEW"
    IF LEN(savePath) THEN
        bankName = PCSPK_FilePart(savePath)
    ELSEIF LEN(openedPath) THEN
        bankName = PCSPK_FilePart(openedPath)
    END IF
    outName = "EXPORT/" + safe_name(bankName) + "_" + safe_name(sndName(cur)) + ".wav"
    PCSPK_CaptureBegin
    lastV = -1
    FOR s = 0 TO steps_of(cur) - 1
        v = get_step(cur, s)
        IF v <> lastV THEN PCSPK_SetDivisor v: lastV = v ' only on a change, see speaker
        PCSPK_AdvanceClocks PCSPK_PIT_HZ / rateHz
    NEXT
    PCSPK_Off
    PCSPK_AdvanceSeconds 0.05
    h = PCSPK_CaptureEnd
    PCSPK_SaveWAV outName
    IF h > 0 THEN _SNDCLOSE h
    IF errNum THEN set_status "Couldn't write " + outName ELSE set_status "Saved " + outName
END SUB


FUNCTION safe_name$ (s AS STRING)
    DIM i AS LONG, c AS STRING, r AS STRING
    FOR i = 1 TO LEN(s)
        c = MID$(s, i, 1)
        IF INSTR("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_", c) THEN r = r + c ELSE r = r + "_"
    NEXT
    safe_name = r
END FUNCTION


'=============================================================================
' Drawing
'=============================================================================

FUNCTION note_y& (nt AS DOUBLE)
    note_y = CANVAS_Y + CANVAS_H - CLNG((nt - NOTE_LO + 0.5) * PX_SEMI)
END FUNCTION


FUNCTION y_note# (y AS LONG)
    y_note = NOTE_LO + (CANVAS_Y + CANVAS_H - y) / PX_SEMI - 0.5
END FUNCTION


SUB draw_ui
    DIM s AS STRING, ln AS STRING

    CLS , _RGB32(16, 20, 28)

    ' title bar
    LINE (0, 0)-(SCR_W - 1, 23), _RGB32(40, 110, 60), BF
    COLOR _RGB32(230, 255, 230)
    s = " PCSEDIT  -  "
    IF LEN(savePath) THEN
        s = s + PCSPK_FilePart(savePath)
    ELSEIF LEN(openedPath) THEN
        s = s + PCSPK_FilePart(openedPath) + " (not saved yet)"
    ELSE
        s = s + "new bank"
    END IF
    IF dirty THEN s = s + " *"
    s = s + "  -" + STR$(sndCount) + " sounds   F1 help"
    _PRINTSTRING (4, 4), s

    draw_info
    draw_list
    draw_roll

    ' status / prompt line
    IF promptKind THEN
        LINE (0, SCR_H - 26)-(SCR_W - 1, SCR_H - 1), _RGB32(30, 40, 70), BF
        COLOR _RGB32(255, 255, 255)
        ln = promptLabel + " " + promptText
        IF (TIMER * 2) MOD 2 = 0 THEN ln = ln + "_"
        IF LEN(ln) > SCR_W \ 8 - 42 THEN ln = "..." + RIGHT$(ln, SCR_W \ 8 - 45)
        _PRINTSTRING (8, SCR_H - 20), ln
        COLOR _RGB32(130, 150, 190)
        _PRINTSTRING (SCR_W - 8 * 38, SCR_H - 20), "Enter OK  Esc cancel  Delete clears"
    ELSEIF LEN(statusMsg) THEN
        IF TIMER(0.001) < statusUntil AND TIMER(0.001) > statusUntil - 10 THEN
            COLOR _RGB32(140, 230, 140)
            _PRINTSTRING (8, SCR_H - 20), statusMsg
        ELSE
            statusMsg = ""
        END IF
    END IF
    IF LEN(statusMsg) = 0 AND promptKind = PROMPT_NONE THEN
        COLOR _RGB32(100, 115, 140)
        IF freeTool THEN
            _PRINTSTRING (8, SCR_H - 20), "FREE tool: drag draws freehand, Shift+click straight line, right drag erases   Tab: NOTE tool   Space play"
        ELSE
            _PRINTSTRING (8, SCR_H - 20), "NOTE tool: click = steady note (Len, F11/F12), drag right = longer, right drag erases   Tab: FREE tool   Space play"
        END IF
    END IF

    IF helpOn THEN draw_help
END SUB


SUB draw_info
    DIM s AS STRING, v AS LONG, x AS LONG
    x = RULER_X
    COLOR _RGB32(255, 200, 60)
    _PRINTSTRING (LIST_X, 36), sndName(cur)
    COLOR _RGB32(190, 200, 215)
    _PRINTSTRING (LIST_X, 52), "Priority" + STR$(sndPri(cur))
    _PRINTSTRING (LIST_X, 68), LTRIM$(STR$(steps_of(cur))) + " steps, " + fmt2(steps_of(cur) / rateHz) + " s"
    IF keysMode = KEYS_SOUND THEN
        COLOR _RGB32(120, 230, 160)
        _PRINTSTRING (LIST_X, 84), "Keys: " + CHR$(14) + " " + LEFT$(sndName(instIdx), 8) + " " + hold_name
    ELSE
        COLOR _RGB32(150, 160, 180)
        _PRINTSTRING (LIST_X, 84), "Keys: notes (Ctrl+K)"
    END IF
    COLOR _RGB32(190, 200, 215)

    s = "Cursor" + STR$(cursorStep) + " (" + fmt2(cursorStep / rateHz) + " s)"
    IF gridDiv THEN s = s + "  bar " + bar_beat(cursorStep)
    _PRINTSTRING (x, 36), s
    COLOR _RGB32(150, 200, 255)
    IF gridDiv THEN
        _PRINTSTRING (700, 36), "Grid " + grid_name + " @" + STR$(bpm) + " BPM (" + fmt2(cell_steps) + " steps)"
    ELSE
        _PRINTSTRING (700, 36), "Grid off (Ctrl+G)"
    END IF
    COLOR _RGB32(190, 200, 215)
    IF mouseIn THEN
        v = get_step(cur, mouseStep)
        s = "Mouse: step" + STR$(mouseStep) + "  " + note_name(mouseNote)
        s = s + "  " + LTRIM$(STR$(CLNG(note_hz(mouseNote)))) + " Hz"
        IF v THEN s = s + "   here: divisor" + STR$(v) + " = " + LTRIM$(STR$(CLNG(PCSPK_DivisorToFreq(v)))) + " Hz " + note_name(div_note(v))
        _PRINTSTRING (x, 52), s
    END IF

    ' mode line
    s = ""
    SELECT CASE recMode
        CASE REC_OFF: s = "REC off"
        CASE REC_STEP: s = "REC STEP"
        CASE REC_LIVE
            IF recording THEN s = "REC LIVE *recording*" ELSE s = "REC LIVE (waiting for a note)"
    END SELECT
    IF recMode <> REC_OFF THEN
        COLOR _RGB32(255, 90, 80)
    ELSE
        COLOR _RGB32(150, 160, 180)
    END IF
    _PRINTSTRING (x, 76), s
    COLOR _RGB32(150, 160, 180)
    IF freeTool THEN s = "Tool FREE   " ELSE s = "Tool NOTE   "
    s = s + "Snap " + on_off(snapOn) + "   Octave" + STR$(octave) + "   Len" + STR$(noteLen) + "   Loop " + on_off(loopOn) + "   Zoom" + STR$(zoom)
    s = s + "   MIDI: "
    IF midiDevIdx >= 0 THEN s = s + midiDevName(midiDevIdx) ELSE s = s + "off"
    _PRINTSTRING (x + 176, 76), s
    IF heldNote >= 0 OR auditionNote >= 0 THEN
        COLOR _RGB32(255, 255, 255)
        IF heldNote >= 0 THEN v = heldNote ELSE v = auditionNote
        _PRINTSTRING (SCR_W - 120, 36), "Note " + note_name(v)
    END IF
END SUB


''
' "bar.beat" (both from 1) for a step, while the grid is on.
'
FUNCTION bar_beat$ (s AS LONG)
    DIM beats AS DOUBLE, b AS LONG
    beats = s * bpm / (60 * rateHz)
    b = INT(beats + 0.000001)
    bar_beat = LTRIM$(STR$(b \ BEATS_PER_BAR + 1)) + "." + LTRIM$(STR$(b MOD BEATS_PER_BAR + 1))
END FUNCTION


FUNCTION on_off$ (b AS INTEGER)
    IF b THEN on_off = "on" ELSE on_off = "off"
END FUNCTION


SUB draw_list
    DIM i AS LONG, n AS LONG, y AS LONG, s AS STRING
    COLOR _RGB32(120, 140, 170)
    _PRINTSTRING (LIST_X, LIST_Y - 20), "  # NAME          LEN"
    FOR i = 0 TO LIST_ROWS - 1
        n = listTop + i + 1
        IF n > sndCount THEN EXIT FOR
        y = LIST_Y + i * ROW_H
        IF n = cur THEN
            LINE (LIST_X - 2, y - 1)-(LIST_X + LIST_W, y + ROW_H - 2), _RGB32(50, 70, 110), BF
            COLOR _RGB32(255, 255, 255)
        ELSE
            COLOR _RGB32(190, 200, 215)
        END IF
        s = RIGHT$("  " + LTRIM$(STR$(n)), 3) + " " + LEFT$(sndName(n) + SPACE$(12), 12) + RIGHT$(SPACE$(6) + STR$(steps_of(n)), 6)
        IF keysMode = KEYS_SOUND AND n = instIdx THEN s = s + " " + CHR$(14) ' the instrument
        _PRINTSTRING (LIST_X, y), s
    NEXT
    IF sndCount > LIST_ROWS THEN
        LINE (LIST_X + LIST_W + 4, LIST_Y)-(LIST_X + LIST_W + 7, LIST_Y + LIST_ROWS * ROW_H), _RGB32(40, 48, 64), BF
        y = LIST_Y + (listTop * LIST_ROWS * ROW_H) \ sndCount
        LINE (LIST_X + LIST_W + 4, y)-(LIST_X + LIST_W + 7, y + (LIST_ROWS * LIST_ROWS * ROW_H) \ sndCount), _RGB32(120, 140, 180), BF
    END IF
END SUB


SUB draw_roll
    DIM nt AS LONG, y AS LONG, x AS LONG, s AS LONG, v AS LONG, vis AS LONG, endX AS LONG
    DIM w AS LONG, nn AS DOUBLE, col AS _UNSIGNED LONG, hp AS LONG, isBlack AS INTEGER, prevY AS LONG

    vis = CANVAS_W \ zoom

    ' piano keys + note rows
    LINE (CANVAS_X, CANVAS_Y)-(CANVAS_X + CANVAS_W - 1, CANVAS_Y + CANVAS_H - 1), _RGB32(10, 12, 18), BF
    FOR nt = NOTE_LO TO NOTE_HI - 1
        y = note_y(nt)
        isBlack = MID$("010100101010", (nt MOD 12) + 1, 1) = "1"
        IF isBlack THEN
            LINE (RULER_X, y - PX_SEMI \ 2)-(RULER_X + 26, y + PX_SEMI \ 2 - 1), _RGB32(30, 30, 36), BF
            LINE (CANVAS_X, y - PX_SEMI \ 2)-(CANVAS_X + CANVAS_W - 1, y + PX_SEMI \ 2 - 1), _RGB32(14, 16, 24), BF
        ELSE
            LINE (RULER_X, y - PX_SEMI \ 2)-(RULER_X + 40, y + PX_SEMI \ 2 - 1), _RGB32(200, 200, 205), BF
        END IF
        IF nt MOD 12 = 0 THEN
            LINE (CANVAS_X, y + PX_SEMI \ 2 - 1)-(CANVAS_X + CANVAS_W - 1, y + PX_SEMI \ 2 - 1), _RGB32(40, 48, 66)
            COLOR _RGB32(150, 160, 180)
            _PRINTSTRING (RULER_X - 26, y - 8), "C" + LTRIM$(STR$(nt \ 12 - 1))
        END IF
    NEXT
    nt = heldNote
    IF nt < 0 THEN nt = auditionNote
    IF nt >= NOTE_LO AND nt < NOTE_HI THEN
        y = note_y(nt)
        LINE (RULER_X, y - PX_SEMI \ 2)-(RULER_X + 40, y + PX_SEMI \ 2 - 1), _RGB32(255, 170, 40), BF
    END IF

    ' past the end of the sound
    endX = CANVAS_X + (steps_of(cur) - scrollX) * zoom
    IF endX < CANVAS_X THEN endX = CANVAS_X
    IF endX < CANVAS_X + CANVAS_W THEN
        LINE (endX, CANVAS_Y)-(CANVAS_X + CANVAS_W - 1, CANVAS_Y + CANVAS_H - 1), _RGB32(22, 24, 30), BF
        LINE (endX, CANVAS_Y)-(endX, CANVAS_Y + CANVAS_H - 1), _RGB32(90, 90, 110)
    END IF

    LINE (CANVAS_X, TIME_Y)-(CANVAS_X + CANVAS_W - 1, CANVAS_Y - 2), _RGB32(26, 32, 44), BF
    IF gridDiv THEN
        draw_grid vis
    ELSE
        draw_seconds vis
    END IF

    ' the steps
    w = zoom - 1
    IF w < 1 THEN w = 1
    ' Each step is one pitch (a dot). Like DN1PLAY's graph, a thin line joins
    ' two sounding steps in a row, so jumps and slides read as one shape;
    ' silence breaks the line.
    prevY = -1
    FOR s = scrollX TO scrollX + vis
        IF s >= steps_of(cur) THEN EXIT FOR
        x = CANVAS_X + (s - scrollX) * zoom
        v = get_step(cur, s)
        IF v = 0 THEN prevY = -1
        IF v THEN
            nn = div_note(v)
            col = _RGB32(255, 170, 40)
            IF nn >= NOTE_HI THEN nn = NOTE_HI - 0.5: col = _RGB32(255, 120, 200)
            IF nn < NOTE_LO THEN nn = NOTE_LO: col = _RGB32(255, 120, 200)
            y = note_y(nn)
            IF prevY >= 0 AND prevY <> y THEN LINE (x, prevY)-(x, y), _RGB32(120, 80, 20)
            ' full width, as in DN1PLAY: a run of one pitch reads as one solid
            ' bar instead of a row of dots
            LINE (x, y - 1)-(x + zoom - 1, y + 1), col, BF
            prevY = y
        ELSE
            LINE (x, CANVAS_Y + CANVAS_H - 3)-(x + w - 1, CANVAS_Y + CANVAS_H - 1), _RGB32(70, 80, 100), BF
        END IF
    NEXT

    ' cursor, playhead, record head
    x = CANVAS_X + (cursorStep - scrollX) * zoom
    IF x >= CANVAS_X AND x < CANVAS_X + CANVAS_W THEN
        LINE (x, TIME_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(255, 220, 0)
    END IF
    IF playing THEN
        hp = heard_pos(playPos)
        IF hp > steps_of(cur) THEN hp = steps_of(cur)
        x = CANVAS_X + (hp - scrollX) * zoom
        IF x >= CANVAS_X AND x < CANVAS_X + CANVAS_W THEN LINE (x, CANVAS_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(255, 255, 255)
    END IF
    IF recording THEN
        x = CANVAS_X + (recPos - scrollX) * zoom
        IF x >= CANVAS_X AND x < CANVAS_X + CANVAS_W THEN LINE (x, CANVAS_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(255, 60, 60)
    END IF

    ' mouse preview: the note the NOTE tool would place, or the step / cell
    ' the FREE tool would draw
    IF mouseIn AND drawing = 0 AND NOT freeTool THEN
        y = note_y(INT(mouseNote + 0.5))
        IF NOT snapOn THEN y = note_y(mouseNote)
        s = mouseStep
        IF gridDiv THEN s = cell_start(cell_of(mouseStep))
        x = CANVAS_X + (s - scrollX) * zoom
        LINE (x, y - 2)-(x + (note_tool_end(s) - s) * zoom - 2, y + 2), _RGBA32(255, 255, 255, 110), BF
    END IF
    IF mouseIn AND drawing = 0 AND freeTool THEN
        y = note_y(INT(mouseNote + 0.5))
        IF NOT snapOn THEN y = note_y(mouseNote)
        IF gridDiv THEN
            x = CANVAS_X + (cell_start(cell_of(mouseStep)) - scrollX) * zoom
            LINE (x, y - 2)-(x + (cell_start(cell_of(mouseStep) + 1) - cell_start(cell_of(mouseStep))) * zoom - 2, y + 2), _RGBA32(255, 255, 255, 120), BF
        ELSE
            x = CANVAS_X + (mouseStep - scrollX) * zoom
            LINE (x, y - 2)-(x + w - 1, y + 2), _RGBA32(255, 255, 255, 120), BF
        END IF
    END IF

    LINE (CANVAS_X - 1, CANVAS_Y - 1)-(CANVAS_X + CANVAS_W, CANVAS_Y + CANVAS_H), _RGB32(70, 80, 100), B
    COLOR _RGB32(100, 115, 140)
    _PRINTSTRING (CANVAS_X, CANVAS_Y + CANVAS_H + 6), "Step" + STR$(scrollX) + " -" + STR$(scrollX + vis) + "   (140 steps = 1 second)   wheel scrolls, Ctrl+wheel zooms"
END SUB


''
' Time ruler with the grid off: a tick every 0.1 s, a label every second.
'
SUB draw_seconds (vis AS LONG)
    DIM s AS LONG, x AS LONG
    FOR s = (scrollX \ 14) * 14 TO scrollX + vis STEP 14
        x = CANVAS_X + (s - scrollX) * zoom
        IF x >= CANVAS_X AND x < CANVAS_X + CANVAS_W THEN
            IF s MOD 140 = 0 THEN
                LINE (x, TIME_Y)-(x, CANVAS_Y - 2), _RGB32(150, 160, 180)
                COLOR _RGB32(150, 160, 180)
                _PRINTSTRING (x + 3, TIME_Y + 2), LTRIM$(STR$(s \ 140)) + "s"
            ELSE
                LINE (x, CANVAS_Y - 8)-(x, CANVAS_Y - 2), _RGB32(80, 90, 110)
            END IF
        END IF
    NEXT
END SUB


''
' Time ruler and roll lines with the grid on: every cell, stronger on beats,
' strongest on bars, which are numbered.
'
SUB draw_grid (vis AS LONG)
    DIM c AS LONG, c0 AS LONG, c1 AS LONG, x AS LONG, s AS LONG, bc AS LONG, onBeat AS INTEGER, onBar AS INTEGER
    bc = beat_cells
    c0 = cell_of(scrollX)
    c1 = cell_of(scrollX + vis) + 1
    FOR c = c0 TO c1
        s = cell_start(c)
        x = CANVAS_X + (s - scrollX) * zoom
        IF x >= CANVAS_X AND x < CANVAS_X + CANVAS_W THEN
            onBeat = (c MOD bc = 0) AND (gridDiv MOD 4 = 0 OR gridDiv = 12 OR gridDiv = 24)
            onBar = (c MOD (bc * BEATS_PER_BAR) = 0)
            IF onBar THEN
                LINE (x, TIME_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(110, 130, 170)
                COLOR _RGB32(180, 200, 235)
                _PRINTSTRING (x + 3, TIME_Y + 2), LTRIM$(STR$(c \ (bc * BEATS_PER_BAR) + 1))
            ELSEIF onBeat THEN
                LINE (x, CANVAS_Y - 10)-(x, CANVAS_Y - 2), _RGB32(120, 135, 160)
                LINE (x, CANVAS_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(52, 60, 82)
            ELSEIF (cell_steps * zoom) >= 4 THEN
                LINE (x, CANVAS_Y - 5)-(x, CANVAS_Y - 2), _RGB32(80, 90, 110)
                LINE (x, CANVAS_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(30, 36, 50)
            END IF
        END IF
    NEXT
END SUB


SUB draw_help
    DIM x AS LONG, y AS LONG, i AS LONG, wMax AS LONG
    DIM t(1 TO 28) AS STRING
    t(1) = "PCSEDIT - PC speaker sound editor"
    t(2) = ""
    t(3) = "Mouse   Tab tool: NOTE (click = steady note Len long, drag right = longer)"
    t(4) = "        or FREE (drag draws freehand, Shift+click straight line); right drag erases"
    t(5) = "Notes   Z S X D C V G B H N J M ,   lower octave     F9 / F10 octave"
    t(6) = "        Q 2 W 3 E R 5 T 6 Y 7 U I   upper octave     or a MIDI keyboard"
    t(7) = "        wheel scroll   Ctrl+wheel zoom   click the time ruler: cursor"
    t(8) = "F5      record: OFF / STEP (note = Len steps at cursor) / LIVE"
    t(9) = "F6 snap to semitones  F7 MIDI device  F11/F12 note length  Ctrl+G grid  Ctrl+B BPM"
    t(10) = "Space   play / stop            Enter  play from cursor     Ctrl+L  loop"
    t(11) = "Left/Right  cursor (Ctrl: 0.1 s)   Home/End   Up/Down  choose sound"
    t(12) = "Insert / Delete  step at cursor    Backspace  delete step before cursor"
    t(13) = "Ctrl+Up/Down  transpose semitone (Shift: octave)   Ctrl+T trim silence"
    t(14) = "Ctrl+Z / Ctrl+Y  undo / redo"
    t(15) = ""
    t(16) = "F2 rename   F3 new sound   F4 duplicate   F8 delete   Ctrl+P priority"
    t(17) = "Ctrl+N new bank   Ctrl+O open   Ctrl+S save   Ctrl+Shift+S save as"
    t(18) = "Ctrl+E export the sound as .wav (EXPORT/)     drop a file to open it"
    t(19) = ""
    t(20) = "Saves IFS banks (Duke Nukem / Keen format, 140 steps per second)."
    t(21) = "Opens anything DN1PLAY plays. Saving never replaces the file you"
    t(22) = "opened unless you choose its name in Save As."
    t(23) = ""
    t(24) = "Ctrl+K  keys play the selected SOUND as an instrument (C4 = as drawn)"
    t(25) = "        Ctrl+H GATE / ONE-SHOT / LOOP; recording goes into another sound"
    t(26) = "Click and hold the piano keys to audition a pitch (drag to slide)"
    t(27) = ""
    t(28) = "Esc / F1  close this"
    ' as wide as the longest line, centred
    FOR i = 1 TO 28
        IF LEN(t(i)) > wMax THEN wMax = LEN(t(i))
    NEXT
    wMax = wMax * 8
    x = (SCR_W - wMax) \ 2: y = 120
    LINE (x - 16, y - 16)-(x + wMax + 16, y + 28 * 18), _RGB32(20, 26, 40), BF
    LINE (x - 16, y - 16)-(x + wMax + 16, y + 28 * 18), _RGB32(120, 140, 180), B
    FOR i = 1 TO 28
        IF i = 1 THEN COLOR _RGB32(255, 200, 60) ELSE COLOR _RGB32(210, 220, 235)
        _PRINTSTRING (x, y + (i - 1) * 18), t(i)
    NEXT
END SUB


SUB set_status (msg AS STRING)
    statusMsg = msg
    statusUntil = TIMER(0.001) + 4
END SUB


FUNCTION fmt2$ (x AS DOUBLE)
    DIM cents AS LONG
    cents = INT(x * 100 + 0.5)
    fmt2 = LTRIM$(STR$(cents \ 100)) + "." + RIGHT$("0" + LTRIM$(STR$(cents MOD 100)), 2)
END FUNCTION


'$INCLUDE:'PCSPKR.BM'
