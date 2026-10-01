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
' Mouse (piano roll):
'   left drag         draw            right drag     erase
'   Shift+left click  straight line from the last point (slides)
'   wheel             scroll          Ctrl+wheel     zoom
'   click time ruler  move the cursor
'
' Notes - computer keyboard (two octaves, tracker layout):
'   Z S X D C V G B H N J M ,     lower octave (C to C)
'   Q 2 W 3 E R 5 T 6 Y 7 U I     upper octave
'   ...or any MIDI keyboard (F7 picks the device)
'
' Keys:
'   Space          play / stop            Enter        play from the cursor
'   Left / Right   move the cursor        Home / End   start / end of sound
'   Up / Down      previous / next sound
'   F5             record mode: OFF, STEP (each note = Len steps at the
'                  cursor), LIVE (records what you play, 140 steps/sec,
'                  starting with the first note; F5 / Space stops)
'   F6 snap to semitones on/off   F7 MIDI device   F9/F10 octave -/+
'   F11/F12 note length -/+       Ctrl+L loop on/off
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
DIM SHARED drawing AS INTEGER ' 0, 1 = drawing, 2 = erasing
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
DIM SHARED octave AS LONG
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
octave = 4
heldNote = -1
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
        prompt_key k
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
                PCSPK_Off
                EXIT SUB
            END IF
        END IF
        PCSPK_SetDivisor get_step(cur, playPos)
        playPos = playPos + 1
        EXIT SUB
    END IF

    IF recording THEN
        IF heldNote >= 0 THEN v = note_div(heldNote) ELSE v = 0
        IF recPos < MAX_STEPS THEN
            set_step cur, recPos, v
            IF v THEN recLastNote = recPos
            recPos = recPos + 1
            cursorStep = recPos
            follow cursorStep
        ELSE
            stop_recording
        END IF
    END IF

    IF heldNote >= 0 THEN PCSPK_SetDivisor note_div(heldNote) ELSE PCSPK_Off
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
    PCSPK_Off
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
            step_enter n
        CASE REC_LIVE
            IF NOT recording THEN
                push_undo
                recording = -1
                recPos = cursorStep
                recStartLen = steps_of(cur)
                recLastNote = -1
            END IF
    END SELECT
END SUB


SUB note_off (n AS LONG)
    DIM i AS LONG, best AS LONG
    IF n < 0 OR n > 127 THEN EXIT SUB
    noteStamp(n) = 0
    heldNote = -1
    FOR i = 0 TO 127
        IF noteStamp(i) > best THEN best = noteStamp(i): heldNote = i
    NEXT
END SUB


''
' STEP record: write the note for noteLen steps at the cursor and move on.
'
SUB step_enter (n AS LONG)
    DIM i AS LONG
    push_undo
    FOR i = 0 TO noteLen - 1
        IF cursorStep + i < MAX_STEPS THEN set_step cur, cursorStep + i, note_div(n)
    NEXT
    cursorStep = cursorStep + noteLen
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

    ' --- drawing / erasing in the roll
    IF drawing THEN
        IF drawing = 1 AND b1 THEN
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
        IF b1 AND shift AND haveAnchor THEN
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
' Set every step from s0 to s1 along a straight line in pitch (or to
' silence when erasing).
'
SUB draw_line (s0 AS LONG, n0 AS DOUBLE, s1 AS LONG, n1 AS DOUBLE, erasing AS INTEGER)
    DIM a AS LONG, b AS LONG, na AS DOUBLE, nb AS DOUBLE, s AS LONG, nt AS DOUBLE
    IF s0 <= s1 THEN
        a = s0: b = s1: na = n0: nb = n1
    ELSE
        a = s1: b = s0: na = n1: nb = n0
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
            IF ctrl THEN move_cursor cursorStep - 14 ELSE move_cursor cursorStep - 1
        CASE 19712 '                                           Right
            IF ctrl THEN move_cursor cursorStep + 14 ELSE move_cursor cursorStep + 1
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


SUB set_octave (o AS LONG)
    octave = o
    IF octave < 1 THEN octave = 1
    IF octave > 7 THEN octave = 7
    set_status "Keyboard octave" + STR$(octave) + " (Z = C" + LTRIM$(STR$(octave)) + ")"
END SUB


SUB set_note_len (n AS LONG)
    noteLen = n
    IF noteLen < 1 THEN noteLen = 1
    IF noteLen > 140 THEN noteLen = 140
    set_status "Note length" + STR$(noteLen) + " steps (" + fmt2(noteLen / rateHz) + " s)"
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
    DIM s AS LONG, h AS LONG, outName AS STRING, bankName AS STRING
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
    FOR s = 0 TO steps_of(cur) - 1
        PCSPK_SetDivisor get_step(cur, s)
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
        _PRINTSTRING (8, SCR_H - 20), "Draw: left drag  Erase: right drag  Line: Shift+click  Notes: Z-M / Q-I keys or MIDI  Space play  F5 record"
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

    s = "Cursor" + STR$(cursorStep) + " (" + fmt2(cursorStep / rateHz) + " s)"
    _PRINTSTRING (x, 36), s
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
    s = "Snap " + on_off(snapOn) + "   Octave" + STR$(octave) + "   Len" + STR$(noteLen) + "   Loop " + on_off(loopOn) + "   Zoom" + STR$(zoom)
    s = s + "   MIDI: "
    IF midiDevIdx >= 0 THEN s = s + midiDevName(midiDevIdx) ELSE s = s + "off"
    _PRINTSTRING (x + 248, 76), s
    IF heldNote >= 0 THEN
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (SCR_W - 160, 36), "Note " + note_name(heldNote)
    END IF
END SUB


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
    DIM w AS LONG, nn AS DOUBLE, col AS _UNSIGNED LONG, hp AS LONG, isBlack AS INTEGER

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
    IF heldNote >= NOTE_LO AND heldNote < NOTE_HI THEN
        y = note_y(heldNote)
        LINE (RULER_X, y - PX_SEMI \ 2)-(RULER_X + 40, y + PX_SEMI \ 2 - 1), _RGB32(255, 170, 40), BF
    END IF

    ' past the end of the sound
    endX = CANVAS_X + (steps_of(cur) - scrollX) * zoom
    IF endX < CANVAS_X THEN endX = CANVAS_X
    IF endX < CANVAS_X + CANVAS_W THEN
        LINE (endX, CANVAS_Y)-(CANVAS_X + CANVAS_W - 1, CANVAS_Y + CANVAS_H - 1), _RGB32(22, 24, 30), BF
        LINE (endX, CANVAS_Y)-(endX, CANVAS_Y + CANVAS_H - 1), _RGB32(90, 90, 110)
    END IF

    ' time ruler: a tick every 0.1 s, a label every second
    LINE (CANVAS_X, TIME_Y)-(CANVAS_X + CANVAS_W - 1, CANVAS_Y - 2), _RGB32(26, 32, 44), BF
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

    ' the steps
    w = zoom - 1
    IF w < 1 THEN w = 1
    FOR s = scrollX TO scrollX + vis
        IF s >= steps_of(cur) THEN EXIT FOR
        x = CANVAS_X + (s - scrollX) * zoom
        v = get_step(cur, s)
        IF v THEN
            nn = div_note(v)
            col = _RGB32(255, 170, 40)
            IF nn >= NOTE_HI THEN nn = NOTE_HI - 0.5: col = _RGB32(255, 120, 200)
            IF nn < NOTE_LO THEN nn = NOTE_LO: col = _RGB32(255, 120, 200)
            y = note_y(nn)
            LINE (x, y - 2)-(x + w - 1, y + 2), col, BF
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

    ' mouse crosshair note
    IF mouseIn AND drawing = 0 THEN
        y = note_y(INT(mouseNote + 0.5))
        IF NOT snapOn THEN y = note_y(mouseNote)
        x = CANVAS_X + (mouseStep - scrollX) * zoom
        LINE (x, y - 2)-(x + w - 1, y + 2), _RGBA32(255, 255, 255, 120), BF
    END IF

    LINE (CANVAS_X - 1, CANVAS_Y - 1)-(CANVAS_X + CANVAS_W, CANVAS_Y + CANVAS_H), _RGB32(70, 80, 100), B
    COLOR _RGB32(100, 115, 140)
    _PRINTSTRING (CANVAS_X, CANVAS_Y + CANVAS_H + 6), "Step" + STR$(scrollX) + " -" + STR$(scrollX + vis) + "   (140 steps = 1 second)   wheel scrolls, Ctrl+wheel zooms"
END SUB


SUB draw_help
    DIM x AS LONG, y AS LONG, i AS LONG
    DIM t(1 TO 26) AS STRING
    t(1) = "PCSEDIT - PC speaker sound editor"
    t(2) = ""
    t(3) = "Mouse   left drag draw   right drag erase   Shift+click straight line"
    t(4) = "        wheel scroll   Ctrl+wheel zoom   click the time ruler: cursor"
    t(5) = "Notes   Z S X D C V G B H N J M ,   lower octave     F9 / F10 octave"
    t(6) = "        Q 2 W 3 E R 5 T 6 Y 7 U I   upper octave     or a MIDI keyboard"
    t(7) = ""
    t(8) = "F5      record: OFF / STEP (note = Len steps at cursor) / LIVE"
    t(9) = "F6      snap to semitones      F7  MIDI device      F11/F12  note length"
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
    t(24) = "Esc / F1  close this"
    x = 300: y = 140
    LINE (x - 16, y - 16)-(x + 600, y + 24 * 18), _RGB32(20, 26, 40), BF
    LINE (x - 16, y - 16)-(x + 600, y + 24 * 18), _RGB32(120, 140, 180), B
    FOR i = 1 TO 24
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
