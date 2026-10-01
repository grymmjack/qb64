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
' Tools - click the toolbar, press the letter (with Caps Lock off),
' Alt+letter (always) or Tab to cycle:
'   D)raw    freehand: every step follows the mouse (sweeps, zaps);
'            Shift+click = straight line from the last point (slides)
'   L)ine    press, drag, release: a straight line of steps (pixel-art
'            style, with a rubber band preview)
'   N)ote    click = a steady note, Len long; drag right = longer
'   W)ave    drag a box = a pitch waveform across it (width = time, height
'            = pitch range). Then, while it is live: 1 square, 2 triangle,
'            3 saw up, 4 saw down, 5 sine; [ ] fewer / more cycles; drag
'            inside the box left/right = duty cycle, up/down = phase. Enter,
'            another tool or a click outside it = done; Esc = cancel
'   E)rase   drag to clear steps
'   S)elect  drag a box around steps
'   M)ove    drag the selection (time and pitch); arrow keys nudge it,
'            Shift+Up/Down = an octave
'   With S)elect or M)ove, drag the selection box's edges to stretch it:
'   left/right = time, top/bottom = pitch range (past the other edge it
'   flips). Ctrl+Up / Ctrl+Down = double / halve the selection's length.
'   Voices: a sound has up to 4 voice lanes (Ctrl+1-4 or the chips above the
'   sound list pick the one you edit; the others show dimmed). Ctrl+J: ARP
'   (voices take turns step by step - the classic fake chord, saves to IFS)
'   or PWM (real simultaneous voices mixed onto the 1-bit speaker; playback
'   and WAV only). In STEP record, notes pressed together become a chord.
'   G (Ctrl+5 or its chip): the tools act on all voices at once - select,
'   move, stretch, clipboard, erase (near the pointer), transpose, steps;
'   the NOTE tool puts each note in a free voice.
'   C)ut / Ctrl+X, Ctrl+C copy, Ctrl+V paste at the cursor, Delete clears
'   the selection, Esc deselects
'   right drag erases with any tool
'   wheel             scroll          Ctrl+wheel     zoom
'   click time ruler  move the cursor
'
' Notes - computer keyboard (two octaves, tracker layout):
'   Z S X D C V G B H N J M ,     lower octave (C to C)
'   Q 2 W 3 E R 5 T 6 Y 7 U I     upper octave
'   CAPS LOCK ON = these keys play notes; CAPS LOCK OFF = letters pick tools
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
'   Ctrl+R         LIVE record from the cursor now, after the count-in
'   Ctrl+M / Ctrl+Shift+M   metronome on/off / its volume
'   Ctrl+U         count-in: off, 1 bar, 2 bars
'   Ctrl+Q         quantize LIVE notes to the grid as you play them
'   A              hear what you draw while the mouse button is down
'   F6 snap (semitones, grid)     F7 MIDI device   F9/F10 octave -/+
'   F11/F12 note length -/+ (in grid cells while the grid is on)
'   Ctrl+G / Ctrl+Shift+G   grid: off, 1/4 ... 1/128, 1/8T, 1/16T
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
$RESIZE:ON
'$INCLUDE:'PCSPKR.BI'

' Window layout. The screen is drawn at a "logical" size (the window size
' divided by the display scale, Ctrl+= / Ctrl+-) and scaled up to the window;
' do_layout fits everything to that size whenever the window or scale changes.
DIM SHARED SCR_W AS LONG
DIM SHARED SCR_H AS LONG
DIM SHARED LIST_ROWS AS LONG
DIM SHARED CANVAS_W AS LONG
DIM SHARED CANVAS_H AS LONG
DIM SHARED SCOPE_Y AS LONG
DIM SHARED PX_SEMI AS LONG ' pixels per semitone row: CANVAS_H = (NOTE_HI - NOTE_LO) * PX_SEMI
DIM SHARED uiScale AS DOUBLE
DIM SHARED uiImg AS LONG ' what is drawn, at the logical size
DIM SHARED scrImg AS LONG ' the window
DIM SHARED physW AS LONG
DIM SHARED physH AS LONG
REDIM SHARED cfgKey(0 TO 0) AS STRING ' settings file, key = value
REDIM SHARED cfgVal(0 TO 0) AS STRING
DIM SHARED cfgN AS LONG
DIM SHARED mlx AS LONG ' the mouse, in logical pixels
DIM SHARED mly AS LONG
CONST MIN_LW = 1000 '                    smallest logical size the layout fits in
CONST MIN_LH = 640
CONST ROW_H = 16
CONST LIST_X = 8
CONST LIST_Y = 144 '                     (the voice chips are on the row above the list)
CONST LIST_W = 200
CONST RULER_X = 224 '                    piano keys
CONST CANVAS_X = 268 '                   piano roll
CONST CANVAS_Y = 120
CONST TIME_Y = 100 '                     time ruler, above the roll
CONST SCOPE_H = 104
CONST SCOPE_SPAN = 2008 '                samples shown by the scope: about 42 ms at 48 kHz
CONST NOTE_LO = 33 '                     A1, 55 Hz at the bottom edge
CONST NOTE_HI = 117 '                    A8, 7040 Hz at the top edge
CONST MAX_SOUNDS = 300
CONST MAX_STEPS = 9000 '                 64 seconds
CONST UNDO_MAX = 100
CONST REC_OFF = 0
CONST REC_STEP = 1
CONST REC_LIVE = 2
' file types the Open dialog lists (the native dialogs on Linux are case
' sensitive, so both cases)
CONST OPEN_FILTER = "*.snd|*.SND|*.dn1|*.DN1|*.dn2|*.DN2|*.dn3|*.DN3|*.ck1|*.CK1|*.wad|*.WAD|*.lmp|*.LMP|*.cmp|*.CMP|*.stn|*.STN|*.ms1|*.MS1|*.ms2|*.MS2|*.ms3|*.MS3|*.hov|*.HOV|*.rov|*.ROV|*.ca2|*.CA2|*.slo|*.SLO|*.8|AUDIOT.*|audiot.*|AUDIOHED.*|audiohed.*"
CONST BEATS_PER_BAR = 4 '                the grid is 4/4
CONST KEYS_NOTES = 0 '                   what notes play: plain tones...
CONST KEYS_SOUND = 1 '                   ...or the instrument sound, transposed
CONST HOLD_GATE = 0
CONST HOLD_ONESHOT = 1
CONST HOLD_LOOP = 2
CONST ROOT_NOTE = 60 '                   C4 plays the instrument as drawn
CONST VOICES = 4 '                       voice lanes per sound
CONST POLY_ARP = 0 '                     voices take turns, one step each
CONST POLY_PWM = 1 '                     voices mixed with pulse-width modulation
CONST PWM_DIV = 76 '                     PWM carrier: PIT clock / 76 = 15.7 kHz
CONST ERASE_REACH = 2 '                  G: the eraser takes notes this many semitones from the pointer
CONST TOOL_DRAW = 0
CONST TOOL_NOTE = 1
CONST TOOL_ERASE = 2
CONST TOOL_SELECT = 3
CONST TOOL_MOVE = 4
CONST TOOL_LINE = 5
CONST TOOL_WAVE = 6
CONST WAVE_SQUARE = 1
CONST WAVE_TRIANGLE = 2
CONST WAVE_SAWUP = 3
CONST WAVE_SAWDOWN = 4
CONST WAVE_SINE = 5
CONST TB_Y = 26 '                        toolbar
CONST TB_H = 20
CONST TB_W = 66
CONST TB_TOOLS = 7 '                     toolbar: 7 tools, then cut / copy / paste
CONST TB_BUTTONS = 11 '                  ...and a Loop toggle

' --- the bank being edited
DIM SHARED sndName(1 TO MAX_SOUNDS) AS STRING
DIM SHARED sndPri(1 TO MAX_SOUNDS) AS LONG
DIM SHARED sndData(1 TO MAX_SOUNDS) AS STRING ' 2 bytes (little endian divisor) per step - the voice being edited
DIM SHARED sndV(1 TO MAX_SOUNDS, 1 TO VOICES) AS STRING ' the other voices (the edited one's slot is empty)
DIM SHARED sndAct(1 TO MAX_SOUNDS) AS INTEGER ' which voice sndData holds
DIM SHARED polyMode AS INTEGER ' POLY_ARP / POLY_PWM
DIM SHARED allVoices AS INTEGER ' G: the editing tools act on every voice at once
DIM SHARED vMask(1 TO VOICES) AS INTEGER ' the voices the edit in progress works on
DIM SHARED noteHome AS LONG ' G + NOTE tool: the voice to go back to after placing a note
DIM SHARED pwmPh(1 TO 8) AS DOUBLE ' PWM: each voice's place in its square wave (PIT clocks)
DIM SHARED spkLast AS LONG ' the divisor the speaker was last set to (see speaker)
DIM SHARED tickN AS LONG ' 140 Hz ticks, for arpeggiating held chords
DIM SHARED chordS0 AS LONG ' STEP record: where the last note went, for chord notes
DIM SHARED chordS1 AS LONG
DIM SHARED chordN AS LONG ' notes in the chord being entered
DIM SHARED recStartLenV(1 TO VOICES) AS LONG ' each voice's length when recording began
DIM SHARED sndCount AS LONG
DIM SHARED cur AS LONG
DIM SHARED listTop AS LONG
DIM SHARED savePath AS STRING ' "" until saved / saved-as in this session
DIM SHARED openedPath AS STRING
DIM SHARED dirty AS INTEGER
DIM SHARED rateHz AS DOUBLE

' --- view and editing
DIM SHARED zoom AS DOUBLE ' pixels per step: 64 down to 1/10 (zoomed out, a pixel covers several steps)
DIM SHARED scrollX AS LONG ' first visible step
DIM SHARED cursorStep AS LONG
DIM SHARED snapOn AS INTEGER
DIM SHARED drawing AS INTEGER ' 0, 1 = drawing, 2 = erasing, 3 = placing a note
DIM SHARED tool AS INTEGER ' TOOL_*
DIM SHARED lineBase AS STRING ' LINE tool: the sound before the line
DIM SHARED lineS AS LONG ' and where the line starts
DIM SHARED lineNt AS DOUBLE
' WAVE tool: shape, cycles, duty (0-1) and phase (0-1) of the live waveform
DIM SHARED waveShape AS INTEGER
DIM SHARED waveCycles AS LONG
DIM SHARED waveDuty AS DOUBLE
DIM SHARED wavePhase AS DOUBLE
DIM SHARED waveLive AS INTEGER ' a waveform is placed and still adjustable
DIM SHARED waveBase AS STRING ' the sound before it
DIM SHARED waveS0 AS LONG ' its box: steps waveS0 to waveS1 - 1...
DIM SHARED waveS1 AS LONG
DIM SHARED waveLo AS DOUBLE ' ...pitch waveLo to waveHi
DIM SHARED waveHi AS DOUBLE
DIM SHARED waveAS AS LONG ' box anchor while dragging it out
DIM SHARED waveAN AS DOUBLE
DIM SHARED adjX AS LONG ' adjusting: where the drag started
DIM SHARED adjY AS LONG
DIM SHARED adjDuty AS DOUBLE
DIM SHARED adjPhase AS DOUBLE
DIM SHARED waveTopIsHi AS INTEGER ' resizing: the top edge is waveHi (not flipped)
DIM SHARED pianoOn AS INTEGER ' computer keyboard plays notes (else letters pick tools)

' selection: steps selS0 to selS1 - 1, pitches selLo to selHi (semitones)
DIM SHARED selOn AS INTEGER
DIM SHARED selS0 AS LONG
DIM SHARED selS1 AS LONG
DIM SHARED selLo AS LONG
DIM SHARED selHi AS LONG
DIM SHARED boxS AS LONG ' marquee anchor while dragging
DIM SHARED boxN AS DOUBLE
REDIM SHARED itemS(0 TO 0) AS LONG ' the selected steps, picked up for a move
REDIM SHARED itemV(0 TO 0) AS LONG
REDIM SHARED itemK(0 TO 0) AS LONG ' and the voice each one is in
DIM SHARED itemN AS LONG
DIM SHARED moveBaseV(1 TO VOICES) AS STRING ' each voice before the move, minus the selection
DIM SHARED moveS AS LONG ' where the move drag started
DIM SHARED moveNt AS DOUBLE
DIM SHARED moveDs AS LONG ' how far it has moved
DIM SHARED moveDn AS LONG
' transform (stretch): the selection as lifted out, and its box before
REDIM SHARED tfV(1 TO VOICES, 0 TO 0) AS LONG ' value per voice and step of the box (-1 = not selected)
DIM SHARED tfBaseV(1 TO VOICES) AS STRING
DIM SHARED tfS0 AS LONG
DIM SHARED tfS1 AS LONG
DIM SHARED tfLo AS LONG
DIM SHARED tfHi AS LONG
REDIM SHARED clipS(0 TO 0) AS LONG ' clipboard: step offsets and divisors
REDIM SHARED clipV(0 TO 0) AS LONG
REDIM SHARED clipK(0 TO 0) AS LONG ' and voices (used when clipAll)
DIM SHARED clipAll AS INTEGER ' copied with G on: paste puts each step back in its voice
DIM SHARED clipN AS LONG
DIM SHARED clipLen AS LONG
DIM SHARED clipLo AS LONG
DIM SHARED clipHi AS LONG
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
DIM SHARED undoVc(1 TO UNDO_MAX) AS INTEGER
DIM SHARED redoVc(1 TO UNDO_MAX) AS INTEGER
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
DIM SHARED gridDiv AS LONG ' 0 = off, else cells per whole note: 4 8 16 32 64 128, 12 = 1/8T, 24 = 1/16T
DIM SHARED bpm AS DOUBLE
DIM SHARED linesOn AS INTEGER ' ' key: lines between note rows and grid cells / steps
DIM SHARED octave AS LONG
DIM SHARED keysMode AS INTEGER
DIM SHARED instIdx AS LONG ' the instrument sound (KEYS_SOUND)
DIM SHARED instLock AS INTEGER ' FALSE = the instrument follows the selected sound
DIM SHARED holdMode AS INTEGER
DIM SHARED voiceOn AS INTEGER ' the instrument is sounding
DIM SHARED voicePos AS LONG ' its step
DIM SHARED voiceNote AS LONG ' at this pitch
DIM SHARED auditionNote AS LONG ' piano key held with the mouse (-1 = none)
DIM SHARED drawAudOn AS INTEGER ' A: hear the step under the pointer while drawing
DIM SHARED drawAud AS LONG ' the divisor to hear right now (0 = nothing)
' metronome / count-in / quantize (LIVE recording)
DIM SHARED metroMode AS INTEGER ' 0 off, 1 while recording, 2 recording + playback
DIM SHARED followOn AS INTEGER ' page the view along with the playhead
DIM SHARED loopA AS LONG ' loop region from the time ruler: steps loopA to loopB - 1
DIM SHARED loopB AS LONG
DIM SHARED loopSet AS INTEGER
DIM SHARED rulerAnchor AS LONG ' where a drag in the ruler began
DIM SHARED rulerPressX AS LONG
DIM SHARED loopSetByDrag AS INTEGER ' this ruler drag has become a loop region
DIM SHARED rulerCursor AS LONG ' the cursor before the press (put back if it becomes a drag)
DIM SHARED metroVol AS SINGLE
DIM SHARED clickHi AS LONG ' QB64 sounds for the clicks (bar / beat), mixed
DIM SHARED clickLo AS LONG ' alongside the speaker, never recorded
DIM SHARED lastBeat AS LONG
DIM SHARED recPos0 AS LONG ' where this recording (or its count-in) began
DIM SHARED countIn AS LONG ' bars of clicks before Ctrl+R recording starts
DIM SHARED recFrom AS LONG ' recording writes from this step on (count-in runs before it)
DIM SHARED quantOn AS INTEGER
' quantize: every note of the take as an event (step heard, note, on/off);
' the take is re-drawn from them with the times snapped to the grid
REDIM SHARED evS(0 TO 255) AS LONG
REDIM SHARED evN(0 TO 255) AS LONG
REDIM SHARED evOn(0 TO 255) AS INTEGER
DIM SHARED evCount AS LONG
DIM SHARED protectUntil AS LONG ' a note quantized longer than played runs to here
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
DIM SHARED midiBusy AS INTEGER ' amidi couldn't open the port

' --- UI
DIM SHARED statusMsg AS STRING
DIM SHARED statusUntil AS DOUBLE
DIM SHARED helpOn AS INTEGER
DIM SHARED errNum AS LONG
DIM SHARED modCtrl AS INTEGER ' modifier keys, tracked from the key events
DIM SHARED modShift AS INTEGER
DIM SHARED modAlt AS INTEGER

DIM k AS LONG, f AS STRING, wheel AS LONG, mx AS LONG, my AS LONG, b1 AS INTEGER, b2 AS INTEGER
DIM ctrl AS INTEGER, shift AS INTEGER, quitNow AS INTEGER, oldScr AS LONG

' Disk and device errors must not stop the program with QB64's "Continue?"
' box: the trap records the error and carries on, and code that touches the
' disk checks errNum.
ON ERROR GOTO trap

' the window as it was last time (settings_save writes it at quit)
cfg_load
uiScale = VAL(cfg_get("scale", "1"))
IF uiScale < 0.5 OR uiScale > 3 THEN uiScale = 1
physW = VAL(cfg_get("width", "1280"))
physH = VAL(cfg_get("height", "800"))
IF physW < 640 OR physW > 16000 THEN physW = 1280
IF physH < 480 OR physH > 16000 THEN physH = 800
scrImg = _NEWIMAGE(physW, physH, 32)
SCREEN scrImg
make_ui
IF VAL(cfg_get("x", "-99999")) > -99999 THEN _SCREENMOVE VAL(cfg_get("x", "0")), VAL(cfg_get("y", "0"))
_TITLE "PCSEDIT - PC speaker sound editor"
_ACCEPTFILEDROP ON

' Trap the window's close button (and Ctrl+Break) so they go through the
' same clean-up as Esc. The first read of _EXIT switches the monitoring
' on; after that the main loop checks it every frame (as DRAW.BAS does).
DIM osExitTrap AS INTEGER
osExitTrap = _EXIT

rateHz = PCSPK_IFS_DEFAULT_HZ
' working preferences, as left last time (defaults the first time)
zoom = VAL(cfg_get("zoom", "6"))
IF zoom < 0.1 OR zoom > 64 THEN zoom = 6
snapOn = VAL(cfg_get("snap", "-1"))
noteLen = VAL(cfg_get("notelen", "4"))
IF noteLen < 1 OR noteLen > 140 THEN noteLen = 4
bpm = VAL(cfg_get("bpm", "120"))
IF bpm < 20 OR bpm > 400 THEN bpm = 120
gridDiv = VAL(cfg_get("grid", "0"))
linesOn = VAL(cfg_get("lines", "-1"))
octave = VAL(cfg_get("octave", "4"))
IF octave < 1 OR octave > 7 THEN octave = 4
heldNote = -1
auditionNote = -1
drawAudOn = VAL(cfg_get("audition", "-1"))
metroMode = VAL(cfg_get("metronome", "1"))
IF metroMode < 0 OR metroMode > 2 THEN metroMode = 1
followOn = VAL(cfg_get("follow", "-1"))
metroVol = VAL(cfg_get("metrovol", "0.5"))
IF metroVol < 0 OR metroVol > 1 THEN metroVol = 0.5
countIn = VAL(cfg_get("countin", "1"))
IF countIn < 0 OR countIn > 2 THEN countIn = 1
quantOn = VAL(cfg_get("quantize", "-1"))
loopOn = VAL(cfg_get("loop", "0"))
polyMode = VAL(cfg_get("poly", "0"))
IF polyMode < 0 OR polyMode > 1 THEN polyMode = POLY_ARP
clickHi = make_click(1760, 0.03)
clickLo = make_click(1175, 0.025)
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
    ' Clear leftovers from older builds (before the watchdog) - but only
    ' orphans. The chain is editor -> forked copy -> sh -> amidi; when the
    ' editor is gone the forked copy is left with a non-PCSEDIT parent. An
    ' amidi whose editor still runs belongs to another PCSEDIT: keep it.
    SHELL _HIDE "for p in $(pgrep -f '^amidi .* -r /tmp/pcsedit-midi-'); do " + _
                "g=$(ps -o ppid= -p $(ps -o ppid= -p $(ps -o ppid= -p $p))); " + _
                "case $(ps -o comm= -p $g 2>/dev/null) in PCSEDIT*) ;; *) " + _
                "f=$(ps -o args= -p $p | sed 's/.* -r //'); kill $p; rm -f $f;; esac; done 2>/dev/null"
$END IF
' PCSEDIT_NOMIDI=1 in the environment leaves the MIDI keyboard alone - for
' test runs, so they don't take the port from an editor you are using
IF ENVIRON$("PCSEDIT_NOMIDI") = "" THEN
    midi_scan
    IF midiDevCount > 0 THEN midi_start 0
END IF
tool = TOOL_NOTE
waveShape = WAVE_SQUARE
waveCycles = 4
waveDuty = 0.5
set_status "Caps Lock ON = computer keyboard plays notes, OFF = letters pick tools (D L N W E S M, C cut)"

DO
    ' ------------------------------------------------------------ audio
    IF pwm_needed THEN
        pump_pwm
    ELSE
        DO WHILE PCSPK_Tick
            on_tick
        LOOP
    END IF

    ' ------------------------------------------------------------ MIDI
    midi_poll
    metronome

    ' ------------------------------------------------------------ mouse
    wheel = 0
    DO WHILE _MOUSEINPUT
        wheel = wheel + _MOUSEWHEEL
        mlx = INT(_MOUSEX / uiScale): mly = INT(_MOUSEY / uiScale)
        handle_mouse mlx, mly, _MOUSEBUTTON(1), _MOUSEBUTTON(2)
    LOOP
    ctrl = _KEYDOWN(100305) OR _KEYDOWN(100306)
    shift = _KEYDOWN(100303) OR _KEYDOWN(100304)
    IF wheel THEN
        IF ctrl THEN
            ' about a quarter per click, so 1 to 64 is a quick spin, not 60 clicks
            IF wheel < 0 THEN
                set_zoom_at zoom_step(1), mlx
            ELSE
                set_zoom_at zoom_step(-1), mlx
            END IF
        ELSEIF mlx < RULER_X THEN
            user_select cur + wheel
        ELSE
            scroll_to scrollX + wheel * (INT(60 / zoom) + 1)
        END IF
    END IF

    ' ------------------------------------------------------------ keys
    ' Caps Lock is the switch: on = the keyboard is a piano, off = letters
    ' pick tools. Let go of any keyboard notes when it goes off.
    pianoOn = _CAPSLOCK
    IF NOT pianoOn THEN poll_piano -1

    ' Every key waiting is handled in order. Ctrl / Shift / Alt come from
    ' the same stream (their press and release events), so a quick Ctrl+C
    ' is still Ctrl+C even if Ctrl is already up by the time we get here.
    poll_piano ctrl
    k = _KEYHIT
    DO WHILE k <> 0
        SELECT CASE ABS(k)
            CASE 100305, 100306: modCtrl = (k > 0)
            CASE 100303, 100304: modShift = (k > 0)
            CASE 100307, 100308: modAlt = (k > 0)
            CASE ELSE
                IF k > 0 THEN
                    quitNow = handle_key(k, modCtrl, modShift)
                    IF quitNow THEN EXIT DO
                END IF
        END SELECT
        k = _KEYHIT
    LOOP
    IF quitNow THEN EXIT DO

    ' ------------------------------------------------------------ close box
    ' Handled here instead of letting QB64 end the program: that would skip
    ' midi_stop, leave amidi running, and the program would then hang at
    ' exit waiting for it - keeping the MIDI port busy with no window open.
    osExitTrap = _EXIT
    IF osExitTrap THEN
        IF ok_to_lose("Quit") THEN EXIT DO
    END IF

    ' ------------------------------------------------------------ drops
    IF _TOTALDROPPEDFILES THEN
        f = _DROPPEDFILE
        _FINISHDROP
        IF ok_to_lose("Open " + PCSPK_FilePart(f)) THEN open_bank f
    END IF

    ' follow playback: page the view along so the playhead stays on screen
    IF playing AND followOn THEN follow_page heard_pos(playPos)

    ' window resized (or maximised): new window image, re-fit the layout
    IF _RESIZE THEN
        physW = _RESIZEWIDTH: physH = _RESIZEHEIGHT
        IF physW < 320 THEN physW = 320
        IF physH < 240 THEN physH = 240
        oldScr = scrImg ' free the old window image once the new one is up
        scrImg = _NEWIMAGE(physW, physH, 32)
        SCREEN scrImg
        _FREEIMAGE oldScr
        make_ui
    END IF

    _DEST uiImg
    draw_ui
    _DEST scrImg
    _PUTIMAGE (0, 0)-(physW - 1, physH - 1), uiImg, scrImg
    _DISPLAY
    _LIMIT 60
LOOP

settings_save
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
    DIM v AS LONG, vp AS LONG
    tickN = tickN + 1
    vp = -1
    IF playing THEN
        IF playPos >= loop_end THEN
            IF loopOn AND snd_len(cur) > 0 THEN
                playPos = loop_start
                lastBeat = -999999 ' the metronome starts over with the loop
            ELSE
                playing = 0
                speaker 0
                EXIT SUB
            END IF
        END IF
        speaker mix_step(cur, playPos)
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
                vp = voicePos
                voicePos = voicePos + 1
            END IF
        END IF
    ELSEIF held_count >= 2 AND NOT recording THEN
        v = note_div(held_note(tickN MOD held_count)) ' a chord: take turns (ARP)
    ELSEIF heldNote >= 0 THEN
        v = note_div(heldNote)
    ELSEIF auditionNote >= 0 THEN
        v = note_div(auditionNote)
    END IF
    ' drawing audition (A): the step under the pointer, when no key is down
    IF v = 0 AND drawAud > 0 AND NOT recording THEN v = drawAud

    IF recording THEN rec_tick v, vp

    speaker v
END SUB


''
' One 140 Hz tick of LIVE recording: v is what sounded (the ARP mix), vp the
' instrument step that played (-1: none).
'
SUB rec_tick (v AS LONG, vp AS LONG)
    IF recPos < recFrom THEN
        recPos = recPos + 1 ' counting in: clicks only, nothing written
    ELSEIF recPos < MAX_STEPS THEN
        ' a key already down when the count-in ends is a note from step one
        IF recPos = recFrom AND evCount = 0 AND heldNote >= 0 THEN add_event recFrom, heldNote, -1
        ' silence must not cut a note that was quantized longer than played
        IF NOT (v = 0 AND recPos < protectUntil) THEN rec_write recPos, v, vp, voiceNote
        IF v <> 0 OR (keysMode = KEYS_SOUND AND voiceOn <> 0) THEN recLastNote = recPos
        recPos = recPos + 1
        cursorStep = recPos
        follow cursorStep
    ELSE
        stop_recording
    END IF
END SUB


''
' Recording with an instrument that has several voices: each of its voices
' goes into the same voice of the sound being recorded, so the chords keep
' their voices (and play back with PWM).
'
FUNCTION rec_multi%
    rec_multi = keysMode = KEYS_SOUND AND instIdx <> cur AND voices_used(instIdx) > 1
END FUNCTION


''
' Write recorded step s: v (one voice), or with a multi-voice instrument its
' voices at step vp (-1 = silence) played at note nt.
'
SUB rec_write (s AS LONG, v AS LONG, vp AS LONG, nt AS LONG)
    DIM k AS LONG, vk AS LONG
    IF NOT rec_multi THEN set_step cur, s, v: EXIT SUB
    FOR k = 1 TO VOICES
        vk = 0
        IF vp >= 0 THEN vk = inst_voice_div(k, vp, nt)
        IF vk < 0 THEN vk = 0
        ' (a rest in a voice that has nothing yet doesn't start it)
        IF vk <> 0 OR k = sndAct(cur) OR s * 2 < LEN(voice_data(cur, k)) THEN set_voice_step cur, k, s, vk
    NEXT
END SUB


''
' Voice k of the instrument at its step pos, played at note nt: the
' divisor, 0 for a rest, -1 once the instrument has finished.
'
FUNCTION inst_voice_div& (k AS LONG, stepPos AS LONG, nt AS LONG)
    DIM ln AS LONG, p AS LONG, v AS LONG
    ln = snd_len(instIdx)
    p = stepPos
    IF ln = 0 THEN inst_voice_div = -1: EXIT FUNCTION
    IF p >= ln THEN
        IF holdMode = HOLD_LOOP THEN p = p MOD ln ELSE inst_voice_div = -1: EXIT FUNCTION
    END IF
    v = voice_step(instIdx, k, p)
    IF v THEN
        v = CLNG(v / 2 ^ ((nt - ROOT_NOTE) / 12))
        IF v < 1 THEN v = 1
        IF v > 65534 THEN v = 65534
    END IF
    inst_voice_div = v
END FUNCTION


''
' Set the speaker's pitch, but only when it changes. Writing the PIT restarts
' its square wave, so writing the same divisor every 1/140 s would chop a
' steady note into uneven cycles - flat and buzzy instead of a clean tone.
' (The games' sound code and PCSPK_IFSRenderInto do the same.)
'
SUB speaker (v AS LONG)
    IF v = spkLast THEN EXIT SUB
    spkLast = v
    PCSPK_SetDivisor v
END SUB


''
' Step pos of the instrument played at note nt (-1 once it has finished).
' Transposing divides the divisor: an octave up halves it.
'
FUNCTION voice_div& (stepPos AS LONG, nt AS LONG)
    DIM ln AS LONG, p AS LONG, v AS LONG
    ln = snd_len(instIdx)
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
    v = mix_step(instIdx, p)
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
    instLock = -1 ' keep playing the instrument while you work in the tune
    set_status "Recording " + sndName(instIdx) + " into a new sound, " + sndName(cur) + " (instrument locked; Ctrl+Shift+K unlocks)"
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


'-----------------------------------------------------------------------------
' Voices and polyphony
'-----------------------------------------------------------------------------

FUNCTION voice_data$ (i AS LONG, k AS LONG)
    IF k = sndAct(i) THEN voice_data = sndData(i) ELSE voice_data = sndV(i, k)
END FUNCTION


FUNCTION voice_step& (i AS LONG, k AS LONG, s AS LONG)
    DIM d AS STRING
    IF k = sndAct(i) THEN voice_step = get_step(i, s): EXIT FUNCTION
    d = sndV(i, k)
    IF s < 0 OR s * 2 + 2 > LEN(d) THEN EXIT FUNCTION
    voice_step = ASC(d, s * 2 + 1) + ASC(d, s * 2 + 2) * 256&
END FUNCTION


FUNCTION voices_used& (i AS LONG)
    DIM k AS LONG, n AS LONG
    FOR k = 1 TO VOICES
        IF LEN(voice_data(i, k)) THEN n = n + 1
    NEXT
    voices_used = n
END FUNCTION


''
' The sound's length: its longest voice.
'
FUNCTION snd_len& (i AS LONG)
    DIM k AS LONG, n AS LONG
    IF i < 1 OR i > sndCount THEN EXIT FUNCTION
    FOR k = 1 TO VOICES
        IF LEN(voice_data(i, k)) \ 2 > n THEN n = LEN(voice_data(i, k)) \ 2
    NEXT
    snd_len = n
END FUNCTION


''
' Step s of sound i with its voices combined the ARP way: the notes sounding
' at that step take turns, one per step (a lone note just plays).
'
FUNCTION mix_step& (i AS LONG, s AS LONG)
    DIM k AS LONG, n AS LONG, v AS LONG, notes(1 TO VOICES) AS LONG
    IF i < 1 OR i > sndCount THEN EXIT FUNCTION
    FOR k = 1 TO VOICES
        v = voice_step(i, k, s)
        IF v THEN n = n + 1: notes(n) = v
    NEXT
    IF n THEN mix_step = notes((s MOD n) + 1)
END FUNCTION


''
' Edit voice k of the current sound: swap it into sndData, so every tool,
' recording and selection work on it unchanged.
'
SUB switch_voice (k AS LONG)
    IF k < 1 OR k > VOICES THEN EXIT SUB
    IF allVoices THEN allVoices = 0 ' picking one voice leaves G
    IF k = sndAct(cur) THEN set_status "Editing voice" + STR$(k) + " only": EXIT SUB
    stop_recording
    selOn = 0
    sndV(cur, sndAct(cur)) = sndData(cur)
    sndData(cur) = sndV(cur, k)
    sndV(cur, k) = ""
    sndAct(cur) = k
    set_status "Editing voice" + STR$(k) + "  (" + LTRIM$(STR$(voices_used(cur))) + " voice(s) in this sound; Ctrl+J " + poly_name + ")"
END SUB


''
' G: the tools work on all voices at once (or back to just the one picked).
'
SUB toggle_all
    allVoices = NOT allVoices
    IF allVoices THEN
        set_status "G: select / move / stretch / cut / copy / paste / erase / transpose hit every voice; NOTE fills a free voice; Draw/Line/Wave go in voice" + STR$(sndAct(cur))
    ELSE
        set_status "Editing voice" + STR$(sndAct(cur)) + " only"
    END IF
END SUB


''
' Put voice k in sndData without any of switch_voice's side effects, so an
' edit can visit every voice in turn. A voice left with nothing but rests
' becomes empty.
'
SUB vswap (k AS LONG)
    DIM h AS LONG
    IF k < 1 OR k > VOICES OR k = sndAct(cur) THEN EXIT SUB
    h = sndAct(cur)
    IF sndData(cur) = STRING$(LEN(sndData(cur)), 0) THEN sndData(cur) = ""
    sndV(cur, h) = sndData(cur)
    sndData(cur) = sndV(cur, k)
    sndV(cur, k) = ""
    sndAct(cur) = k
END SUB


''
' Which voices an edit works on: the edited one, plus every voice that has
' something in it when G is on.
'
SUB set_vmask
    DIM k AS LONG
    FOR k = 1 TO VOICES
        vMask(k) = (k = sndAct(cur)) OR (allVoices AND LEN(voice_data(cur, k)) > 0)
    NEXT
END SUB


''
' G + NOTE tool: a voice with nothing between steps a and b-1 (the edited
' one if it is free), so clicked notes stack up into chords.
'
FUNCTION free_voice& (a AS LONG, b AS LONG)
    DIM k AS LONG, t AS LONG, i AS LONG, ok AS INTEGER
    FOR t = 0 TO VOICES
        IF t = 0 THEN k = sndAct(cur) ELSE k = t
        ok = -1
        FOR i = a TO b - 1
            IF voice_step(cur, k, i) THEN ok = 0: EXIT FOR
        NEXT
        IF ok THEN free_voice = k: EXIT FUNCTION
    NEXT
    free_voice = sndAct(cur) ' all full: draw over the edited voice
END FUNCTION


''
' Erasing at step s near pitch nt: with G, only notes near the pointer (in
' any voice), so one note of a chord can go; otherwise the whole step.
'
SUB erase_at (s AS LONG, nt AS DOUBLE)
    DIM k AS LONG, v AS LONG
    IF NOT allVoices THEN
        IF s < steps_of(cur) THEN set_step cur, s, 0
        EXIT SUB
    END IF
    FOR k = 1 TO VOICES
        v = voice_step(cur, k, s)
        IF v THEN
            IF ABS(div_note(v) - nt) <= ERASE_REACH THEN set_voice_step cur, k, s, 0
        END IF
    NEXT
END SUB


SUB toggle_poly
    polyMode = 1 - polyMode
    IF polyMode = POLY_PWM THEN
        set_status "PWM: voices sound together (mixed onto the 1-bit speaker). Banks still save the ARP version for games"
    ELSE
        set_status "ARP: voices take turns step by step - the way the games play it"
    END IF
END SUB


FUNCTION poly_name$
    IF polyMode = POLY_PWM THEN poly_name = "PWM" ELSE poly_name = "ARP"
END FUNCTION


FUNCTION voice_col~& (k AS LONG)
    SELECT CASE k
        CASE 1: voice_col = _RGB32(255, 170, 40)
        CASE 2: voice_col = _RGB32(110, 230, 120)
        CASE 3: voice_col = _RGB32(240, 110, 210)
        CASE ELSE: voice_col = _RGB32(120, 170, 255)
    END SELECT
END FUNCTION


FUNCTION held_count&
    DIM i AS LONG, n AS LONG
    FOR i = 0 TO 127
        IF noteStamp(i) THEN n = n + 1
    NEXT
    held_count = n
END FUNCTION


''
' The n-th held note (0 based, lowest first).
'
FUNCTION held_note& (n AS LONG)
    DIM i AS LONG, c AS LONG
    FOR i = 0 TO 127
        IF noteStamp(i) THEN
            IF c = n THEN held_note = i: EXIT FUNCTION
            c = c + 1
        END IF
    NEXT
END FUNCTION


''
' PWM is used when its mode is on and there is more than one voice to hear:
' a multi-voice sound playing, or a chord held on the keys.
'
FUNCTION pwm_needed%
    IF polyMode <> POLY_PWM THEN EXIT FUNCTION
    IF playing THEN
        pwm_needed = voices_used(cur) > 1
    ELSEIF keysMode = KEYS_SOUND THEN
        ' Ctrl+K: an instrument with several voices
        pwm_needed = voiceOn <> 0 AND voices_used(instIdx) > 1 ' (recording too: see pump_pwm)
    ELSE
        pwm_needed = held_count >= 2 AND NOT recording
    END IF
END FUNCTION


''
' The instrument's voices at its step pos, played at note nt (for PWM):
' how many sound, or -1 once it has finished (see voice_div).
'
FUNCTION inst_divs& (stepPos AS LONG, nt AS LONG, d() AS LONG)
    DIM ln AS LONG, p AS LONG, n AS LONG, k AS LONG, v AS LONG
    ln = snd_len(instIdx)
    p = stepPos
    IF ln = 0 THEN inst_divs = -1: EXIT FUNCTION
    IF p >= ln THEN
        IF holdMode = HOLD_LOOP THEN p = p MOD ln ELSE inst_divs = -1: EXIT FUNCTION
    END IF
    FOR k = 1 TO VOICES
        v = voice_step(instIdx, k, p)
        IF v THEN
            v = CLNG(v / 2 ^ ((nt - ROOT_NOTE) / 12))
            IF v < 1 THEN v = 1
            IF v > 65534 THEN v = 65534
            n = n + 1: d(n) = v
        END IF
    NEXT
    inst_divs = n
END FUNCTION


''
' Render one 140 Hz tick with PWM: every carrier period (PWM_DIV clocks) the
' speaker gets one pulse whose width is how many of the voices' square waves
' are high right now - the same trick WAV.BAS uses for recorded sound.
'
SUB render_pwm_tick (d() AS LONG, n AS LONG)
    DIM p AS LONG, periods AS LONG, k AS LONG, hi AS LONG, cnt AS LONG, clk AS DOUBLE
    clk = pcspk.tickClk
    IF n = 0 THEN
        PCSPK_SpeakerOff
        PCSPK_AdvanceClocks clk
        EXIT SUB
    END IF
    PCSPK_SpeakerOn
    periods = INT(clk / PWM_DIV)
    FOR p = 1 TO periods
        hi = 0
        FOR k = 1 TO n
            pwmPh(k) = pwmPh(k) + PWM_DIV
            IF pwmPh(k) >= d(k) THEN pwmPh(k) = pwmPh(k) - d(k) * INT(pwmPh(k) / d(k))
            IF pwmPh(k) < d(k) / 2 THEN hi = hi + 1
        NEXT
        cnt = 1 + CLNG(hi * (PWM_DIV - 2) / n)
        PCSPK_PitWrite PCSPK_MODE_ONESHOT, cnt
        PCSPK_AdvanceClocks PWM_DIV
    NEXT
    PCSPK_AdvanceClocks clk - periods * PWM_DIV
END SUB


''
' The divisors sounding at step s of sound i (for PWM).
'
FUNCTION step_divs& (i AS LONG, s AS LONG, d() AS LONG)
    DIM k AS LONG, n AS LONG, v AS LONG
    FOR k = 1 TO VOICES
        v = voice_step(i, k, s)
        IF v THEN n = n + 1: d(n) = v
    NEXT
    step_divs = n
END FUNCTION


''
' Keep the audio stream fed in PWM mode (instead of PCSPK_Tick / on_tick).
'
SUB pump_pwm
    DIM d(1 TO 8) AS LONG, n AS LONG, k AS LONG, vp AS LONG, v AS LONG
    IF pcspk.sink <> PCSPK_SINK_STREAM THEN PCSPK_StreamOpen
    spkLast = -1 ' the PIT is in one-shot mode now: the next tone must be written
    DO WHILE PCSPK_Buffered < pcspk.lead
        tickN = tickN + 1
        IF playing THEN
            IF playPos >= loop_end THEN
                IF loopOn AND snd_len(cur) > 0 THEN
                    playPos = loop_start
                    lastBeat = -999999
                ELSE
                    playing = 0
                    PCSPK_Off
                    EXIT DO
                END IF
            END IF
            n = step_divs(cur, playPos, d())
            playPos = playPos + 1
        ELSEIF keysMode = KEYS_SOUND THEN
            IF voiceOn = 0 THEN EXIT DO ' let go: back to the normal path
            vp = voicePos
            n = inst_divs(vp, voiceNote, d())
            IF n < 0 THEN voiceOn = 0: EXIT DO ' the instrument has finished
            voicePos = voicePos + 1
            IF recording THEN
                v = voice_div(vp, voiceNote)
                IF v < 0 THEN v = 0
                rec_tick v, vp
            END IF
        ELSE
            n = held_count
            IF n > 8 THEN n = 8
            FOR k = 1 TO n
                d(k) = note_div(held_note(k - 1))
            NEXT
            IF n < 2 THEN EXIT DO ' chord let go: back to the normal path
        END IF
        render_pwm_tick d(), n
    LOOP
    PCSPK_StreamFlush
END SUB


SUB play_from (s AS LONG)
    DIM spkI AS LONG
    stop_recording
    IF snd_len(cur) = 0 THEN set_status "Nothing to play - draw or play some notes first": EXIT SUB
    playPos = s
    ' looping a selection: start inside it
    IF loopOn AND (selOn OR loopSet) THEN
        IF playPos < loop_start OR playPos >= loop_end THEN playPos = loop_start
    ELSEIF playPos >= snd_len(cur) THEN
        playPos = 0
    END IF
    FOR spkI = 1 TO 8: pwmPh(spkI) = 0: NEXT
    lastBeat = -999999
    playing = -1
END SUB


''
' What Loop repeats: the selection's time span, or the whole sound.
'
''
' What Loop repeats: the selection if there is one, else the loop region
' dragged in the time ruler, else the whole sound.
'
FUNCTION loop_start&
    IF loopOn AND selOn THEN
        loop_start = selS0
    ELSEIF loopOn AND loopSet THEN
        loop_start = loopA
    END IF
END FUNCTION


FUNCTION loop_end&
    loop_end = snd_len(cur)
    IF loopOn AND selOn THEN
        IF selS1 < snd_len(cur) THEN loop_end = selS1
    ELSEIF loopOn AND loopSet THEN
        loop_end = loopB ' may run past the end of the sound: silence until it loops
    END IF
END FUNCTION


''
' Dragging in the time ruler (drawing 17 = new: a click moves the cursor, a
' drag makes a loop region; 18 / 19 = the region's start / end). Edges snap
' to grid cells with the grid on, to whole bars with Shift.
'
SUB ruler_drag (which AS INTEGER, s AS LONG, mx AS LONG)
    DIM a AS LONG, b AS LONG
    SELECT CASE which
        CASE 17
            IF ABS(mx - rulerPressX) <= 3 AND NOT loopSetByDrag THEN
                cursorStep = s
                IF grid_snap THEN cursorStep = snap_cell(s)
                EXIT SUB
            END IF
            IF NOT loopSetByDrag THEN cursorStep = rulerCursor ' a drag, not a click
            loopSetByDrag = -1
            a = rulerAnchor: b = s
            IF a > b THEN SWAP a, b
            loopA = ruler_snap(a, 0)
            loopB = ruler_snap(b + 1, 1)
            loopSet = -1
            loopOn = -1
        CASE 18
            loopA = ruler_snap(s, 0)
            IF loopA >= loopB THEN loopA = loopB - 1
        CASE 19
            loopB = ruler_snap(s + 1, 1)
            IF loopB <= loopA THEN loopB = loopA + 1
    END SELECT
    IF loopA < 0 THEN loopA = 0
END SUB


''
' Snap a loop edge: whole bars with Shift, grid cells with the grid on,
' otherwise the step itself. isEnd rounds ends up so a region is never empty.
'
FUNCTION ruler_snap& (s AS LONG, isEnd AS INTEGER)
    DIM barLen AS DOUBLE, b AS LONG
    IF modShift OR _KEYDOWN(100303) OR _KEYDOWN(100304) THEN
        barLen = BEATS_PER_BAR * 60 * rateHz / bpm
        b = INT(s / barLen + 0.5)
        IF isEnd AND b < 1 THEN b = 1
        ruler_snap = INT(b * barLen + 0.5)
    ELSEIF grid_snap THEN
        ruler_snap = snap_cell(s)
    ELSE
        ruler_snap = s
    END IF
END FUNCTION


SUB toggle_loop
    loopOn = NOT loopOn
    IF loopOn AND selOn THEN
        set_status "Loop ON - repeating the selection (steps" + STR$(selS0) + " -" + STR$(selS1 - 1) + ")"
    ELSEIF loopOn THEN
        set_status "Loop ON - repeating the whole sound (select a part to loop just that)"
    ELSE
        set_status "Loop OFF"
    END IF
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
    ' just after a loop jumped back, what you hear is still the loop's end
    IF playing AND loopOn AND h < loop_start AND p >= loop_start THEN h = loop_end - (loop_start - h)
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
        IF ctrl OR NOT pianoOn OR _KEYDOWN(100307) OR _KEYDOWN(100308) THEN
            isDown = 0 ' Ctrl/Alt+letter is a command, and with the piano off letters pick tools
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
                begin_live cursorStep, 0
            END IF
    END SELECT
    start_voice n ' after ensure_target, which may switch sounds
    IF recMode = REC_LIVE THEN rec_event n, -1
END SUB


SUB note_off (n AS LONG)
    DIM i AS LONG, best AS LONG
    IF n < 0 OR n > 127 THEN EXIT SUB
    IF noteStamp(n) <> 0 THEN rec_event n, 0
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
    DIM i AS LONG, c AS LONG, s0 AS LONG, s1 AS LONG, last AS LONG, v AS LONG, k AS LONG
    push_undo
    ' a key pressed while another is still down: a chord note, in the next
    ' voice at the same steps (plain notes only)
    IF held_count >= 2 AND keysMode = KEYS_NOTES AND chordS1 > chordS0 THEN
        chordN = chordN + 1
        k = chord_voice(chordN)
        IF k = 0 THEN set_status "Only" + STR$(VOICES) + " voices - that note was left out": EXIT SUB
        FOR i = chordS0 TO chordS1 - 1
            set_voice_step cur, k, i, note_div(n)
        NEXT
        set_status "Chord: " + note_name(n) + " in voice" + STR$(k)
        EXIT SUB
    END IF
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
        IF s0 + snd_len(instIdx) - 1 > last THEN last = s0 + snd_len(instIdx) - 1
    END IF
    FOR i = s0 TO last
        IF i >= MAX_STEPS THEN EXIT FOR
        IF keysMode = KEYS_SOUND THEN
            v = voice_div(i - s0, n)
            IF v < 0 THEN v = 0
            rec_write i, v, i - s0, n
        ELSE
            v = note_div(n)
            set_step cur, i, v
        END IF
    NEXT
    ' the other voices are cleared here, so a new chord doesn't mix with old
    ' notes (not when a multi-voice instrument has just written them)
    FOR k = 1 TO VOICES
        IF k <> sndAct(cur) AND LEN(sndV(cur, k)) > 0 AND NOT rec_multi THEN
            FOR i = s0 TO s1 - 1
                IF i * 2 + 2 <= LEN(sndV(cur, k)) THEN set_voice_step cur, k, i, 0
            NEXT
        END IF
    NEXT
    chordS0 = s0: chordS1 = s1: chordN = 1
    cursorStep = s1
    IF cursorStep > MAX_STEPS THEN cursorStep = MAX_STEPS
    follow cursorStep
END SUB


''
' The voice the n-th note of a chord goes to: the edited voice takes the
' first, the others follow in order.
'
FUNCTION chord_voice& (n AS LONG)
    DIM k AS LONG, c AS LONG
    IF n <= 1 THEN chord_voice = sndAct(cur): EXIT FUNCTION
    c = 1
    FOR k = 1 TO VOICES
        IF k <> sndAct(cur) THEN
            c = c + 1
            IF c = n THEN chord_voice = k: EXIT FUNCTION
        END IF
    NEXT
END FUNCTION


SUB set_voice_step (i AS LONG, k AS LONG, s AS LONG, v AS LONG)
    DIM need AS LONG, d AS LONG
    IF k = sndAct(i) THEN set_step i, s, v: EXIT SUB
    IF s < 0 OR s >= MAX_STEPS THEN EXIT SUB
    d = v
    IF d < 0 THEN d = 0
    IF d > 65534 THEN d = 65534
    need = s * 2 + 2
    IF LEN(sndV(i, k)) < need THEN sndV(i, k) = sndV(i, k) + STRING$(need - LEN(sndV(i, k)), 0)
    MID$(sndV(i, k), s * 2 + 1, 2) = CHR$(d AND 255) + CHR$(d \ 256)
    ' a voice of nothing but rests is no voice
    IF sndV(i, k) = STRING$(LEN(sndV(i, k)), 0) THEN sndV(i, k) = ""
    dirty = -1
END SUB


''
' Start LIVE recording at step at, after countBars bars of count-in.
'
SUB begin_live (at AS LONG, countBars AS LONG)
    DIM k AS LONG
    recording = -1
    recFrom = at
    recPos = at - CLNG(countBars * BEATS_PER_BAR * 60 * rateHz / bpm)
    recPos0 = recPos
    recStartLen = steps_of(cur)
    FOR k = 1 TO VOICES: recStartLenV(k) = LEN(voice_data(cur, k)) \ 2: NEXT
    recLastNote = -1
    evCount = 0: protectUntil = 0
    lastBeat = -999999
    IF quantOn AND gridDiv = 0 THEN
        gridDiv = 16
        set_status "Quantize needs a grid - set to 1/16 (Ctrl+G changes it, Ctrl+Q turns quantize off)"
    END IF
END SUB


''
' Ctrl+R: record now from the cursor, with the count-in.
'
SUB record_now
    IF recording THEN stop_recording: EXIT SUB
    IF playing THEN stop_playing
    recMode = REC_LIVE
    ensure_target
    push_undo
    begin_live cursorStep, countIn
    IF countIn THEN set_status "Count-in..." ELSE set_status "Recording - Space or F5 stops"
END SUB


''
' Note on / off while recording: remember it (timed by what you heard, not
' by what is queued ahead) and, with quantize on, re-draw the take.
'
SUB rec_event (n AS LONG, isOn AS INTEGER)
    DIM t AS LONG
    IF NOT recording OR recPos < recFrom THEN EXIT SUB
    t = recPos - CLNG(PCSPK_Buffered * rateHz)
    IF t < recFrom THEN t = recFrom
    add_event t, n, isOn
    IF quantOn AND gridDiv <> 0 THEN render_take 0
END SUB


SUB add_event (t AS LONG, n AS LONG, isOn AS INTEGER)
    IF evCount > UBOUND(evS) THEN
        REDIM _PRESERVE evS(0 TO evCount * 2) AS LONG
        REDIM _PRESERVE evN(0 TO evCount * 2) AS LONG
        REDIM _PRESERVE evOn(0 TO evCount * 2) AS INTEGER
    END IF
    evS(evCount) = t: evN(evCount) = n: evOn(evCount) = isOn
    evCount = evCount + 1
END SUB


''
' Snap a step to the nearest grid cell edge.
'
FUNCTION snap_cell& (t AS LONG)
    DIM c AS LONG
    c = cell_of(t)
    IF t - cell_start(c) >= cell_start(c + 1) - t THEN c = c + 1
    snap_cell = cell_start(c)
END FUNCTION


''
' Re-draw the take from its events with every note snapped to the grid:
' start to the nearest cell, end to the nearest cell edge (at least a cell).
' Plain notes write their pitch; with the instrument (Ctrl+K) each note plays
' the instrument from its own start. Notes still held run to recPos
' (unfinished = FALSE) or end there (final = TRUE, when recording stops).
'
SUB render_take (final AS INTEGER)
    DIM i AS LONG, j AS LONG, k AS LONG, nn AS LONG, s AS LONG, e AS LONG, v AS LONG
    DIM best AS LONG, endS AS LONG
    IF evCount = 0 THEN EXIT SUB
    REDIM ns(0 TO evCount) AS LONG ' note start, end, number (quantized)
    REDIM ne(0 TO evCount) AS LONG
    REDIM nk(0 TO evCount) AS LONG
    REDIM held(0 TO evCount) AS INTEGER

    ' pair each note-on with its note-off
    FOR i = 0 TO evCount - 1
        IF evOn(i) THEN
            e = -1
            FOR j = i + 1 TO evCount - 1
                IF evN(j) = evN(i) THEN e = evS(j): EXIT FOR
            NEXT
            ns(nn) = snap_cell(evS(i))
            IF ns(nn) < recFrom THEN ns(nn) = recFrom
            nk(nn) = evN(i)
            IF e < 0 THEN
                held(nn) = -1
                e = recPos
                IF final THEN e = snap_cell(e)
            ELSE
                e = snap_cell(e)
            END IF
            IF e <= ns(nn) THEN e = cell_start(cell_of(ns(nn)) + 1)
            IF keysMode = KEYS_SOUND AND holdMode = HOLD_ONESHOT THEN e = ns(nn) + snd_len(instIdx)
            ne(nn) = e
            nn = nn + 1
        END IF
    NEXT
    IF nn = 0 THEN EXIT SUB

    endS = recPos
    protectUntil = 0
    FOR i = 0 TO nn - 1
        IF ne(i) > endS THEN endS = ne(i)
        IF NOT held(i) AND ne(i) > protectUntil THEN protectUntil = ne(i)
    NEXT
    IF endS > MAX_STEPS THEN endS = MAX_STEPS

    ' each step plays the most recently started note that is still sounding
    FOR s = recFrom TO endS - 1
        best = -1
        FOR k = 0 TO nn - 1
            IF s >= ns(k) AND s < ne(k) THEN
                IF best < 0 THEN
                    best = k
                ELSEIF ns(k) >= ns(best) THEN
                    best = k
                END IF
            END IF
        NEXT
        v = 0
        IF best >= 0 THEN
            IF keysMode = KEYS_SOUND THEN
                v = voice_div(s - ns(best), nk(best))
                IF v < 0 THEN v = 0
            ELSE
                v = note_div(nk(best))
            END IF
        END IF
        IF best >= 0 AND rec_multi THEN
            rec_write s, v, s - ns(best), nk(best)
        ELSE
            rec_write s, v, -1, 0
        END IF
        IF v <> 0 AND s > recLastNote THEN recLastNote = s
    NEXT
END SUB


''
' Clicks on every beat while recording (higher on the first beat of a bar),
' timed by what you hear, not by what is queued.
'
SUB metronome
    DIM hp AS LONG, beatLen AS DOUBLE, b AS LONG
    ' clicks line up with the grid's bars: beat 1 of bar 1 is step 0
    beatLen = 60 * rateHz / bpm
    IF recording AND metroMode >= 1 THEN
        hp = recPos - CLNG(PCSPK_Buffered * rateHz)
        IF hp < recPos0 THEN EXIT SUB ' the start isn't heard yet (no click "before" beat one)
    ELSEIF playing AND metroMode = 2 THEN
        hp = playPos - CLNG(PCSPK_Buffered * rateHz)
        IF hp < 0 THEN EXIT SUB
    ELSE
        lastBeat = -999999
        EXIT SUB
    END IF
    b = INT(hp / beatLen + 0.000001)
    IF hp < 0 THEN b = -INT(-hp / beatLen + 0.999999)
    IF b = lastBeat THEN EXIT SUB
    lastBeat = b
    IF ((b MOD BEATS_PER_BAR) + BEATS_PER_BAR) MOD BEATS_PER_BAR = 0 THEN
        IF clickHi > 0 THEN _SNDVOL clickHi, metroVol: _SNDPLAY clickHi
    ELSE
        IF clickLo > 0 THEN _SNDVOL clickLo, metroVol: _SNDPLAY clickLo
    END IF
    IF recording AND hp < recFrom THEN set_status "Count-in..."
    IF recording AND hp >= recFrom AND hp - beatLen < recFrom THEN set_status "Recording - Space or F5 stops"
END SUB


''
' A short decaying sine blip, for the metronome.
'
FUNCTION make_click& (hz AS DOUBLE, secs AS DOUBLE)
    DIM h AS LONG, m AS _MEM, n AS LONG, i AS LONG, t AS DOUBLE, sr AS LONG, v AS SINGLE
    sr = _SNDRATE
    IF sr <= 0 THEN EXIT FUNCTION
    n = CLNG(sr * secs)
    h = _SNDNEW(n, 1, 32)
    IF h < 1 THEN EXIT FUNCTION
    m = _MEMSOUND(h, 0)
    FOR i = 0 TO n - 1
        t = i / sr
        v = SIN(2 * _PI * hz * t) * EXP(-t * 140) * 0.9
        _MEMPUT m, m.OFFSET + i * 4, v
    NEXT
    _MEMFREE m
    make_click = h
END FUNCTION


SUB stop_recording
    DIM keepLen AS LONG, k AS LONG
    IF NOT recording THEN EXIT SUB
    recording = 0
    IF quantOn AND gridDiv <> 0 AND evCount > 0 THEN
        render_take -1
        ' re-find the last note: quantizing may have moved it either way
        recLastNote = -1
        FOR keepLen = snd_len(cur) - 1 TO recFrom STEP -1
            IF mix_step(cur, keepLen) THEN recLastNote = keepLen: EXIT FOR
        NEXT
    END IF
    ' drop the silence recorded after the last note (but never cut what was
    ' there before recording started)
    keepLen = recLastNote + 1
    IF keepLen < recStartLen THEN keepLen = recStartLen
    IF keepLen < steps_of(cur) THEN sndData(cur) = LEFT$(sndData(cur), keepLen * 2)
    FOR k = 1 TO VOICES ' the other voices' recorded silence too
        IF k <> sndAct(cur) THEN
            IF LEN(sndV(cur, k)) > keepLen * 2 AND LEN(sndV(cur, k)) > recStartLenV(k) * 2 THEN
                sndV(cur, k) = LEFT$(sndV(cur, k), _MAX(keepLen, recStartLenV(k)) * 2)
            END IF
        END IF
    NEXT
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
        ' The sh stays behind as a watchdog: if PCSEDIT itself disappears
        ' (killed, crashed, stopped from the IDE) it stops amidi and deletes
        ' the temp file, so the MIDI port never stays taken. It also ends as
        ' soon as amidi does (midi_stop, or a busy port).
        ' SHELL _DONTWAIT runs the command from a forked copy of PCSEDIT, so
        ' the editor itself is the sh's grandparent (e) - that is what to watch.
        SHELL _HIDE _DONTWAIT "amidi -p " + midiDevs(idx) + " -r '" + midiFile + "' 2>/dev/null & a=$!; " + _
            "e=$(ps -o ppid= -p $PPID); " + _
            "while kill -0 $e 2>/dev/null && kill -0 $a 2>/dev/null; do sleep 0.5; done; " + _
            "kill $a 2>/dev/null; rm -f '" + midiFile + "'"
        midiFF = FREEFILE
        OPEN midiFile FOR BINARY ACCESS READ AS #midiFF
        IF errNum THEN midiFF = 0: set_status "Can't start MIDI input": EXIT SUB
        midiPos = 0
        midiStatus = 0
        midiCnt = 0
        midiDevIdx = idx
        midiBusy = 0

        ' amidi quits at once if it can't open the port - usually because
        ' another program (another PCSEDIT, a DAW, Komplete Kontrol) has it
        _DELAY 0.4
        IF NOT amidi_alive THEN
            midiBusy = -1
            set_status "MIDI port " + midiDevs(idx) + " is busy - close any other PCSEDIT / DAW using it, then press F7"
        ELSE
            set_status "MIDI input: " + midiDevName(idx) + " (" + midiDevs(idx) + ")"
        END IF
    $END IF
END SUB


''
' Is our amidi still running?
'
FUNCTION amidi_alive%
    DIM tmp AS STRING
    $IF WIN THEN
    $ELSE
        tmp = midiFile + ".pid"
        SHELL _HIDE "pgrep -f '^amidi .* -r " + midiFile + "' > '" + tmp + "' 2>/dev/null"
        IF _FILEEXISTS(tmp) THEN
            amidi_alive = LEN(PCSPK_ReadFile(tmp)) > 0
            KILL tmp
        END IF
    $END IF
END FUNCTION


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

    shift = _KEYDOWN(100303) OR _KEYDOWN(100304) OR modShift
    inCanvas = mx >= CANVAS_X AND mx < CANVAS_X + CANVAS_W AND my >= CANVAS_Y AND my < CANVAS_Y + CANVAS_H
    mouseIn = inCanvas
    s = scrollX + INT((mx - CANVAS_X) / zoom)
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
            IF noteHome THEN
                IF sndAct(cur) <> noteHome THEN set_status "Note in voice" + STR$(sndAct(cur))
                vswap noteHome
                noteHome = 0
            END IF
        ELSEIF drawing = 4 THEN ' marquee
            IF b1 THEN
                set_box boxS, boxN, s, nt, shift
            ELSE
                drawing = 0
                set_box boxS, boxN, s, nt, shift
                IF sel_count = 0 THEN selOn = 0: set_status "Nothing in that box" ELSE set_status LTRIM$(STR$(sel_count)) + " steps selected - M to move, arrows to nudge, Ctrl+X/C/V"
            END IF
        ELSEIF drawing = 6 THEN ' dragging out a waveform box
            IF b1 THEN
                wave_box waveAS, waveAN, s, nt
            ELSE
                drawing = 0
                wave_box waveAS, waveAN, s, nt
                set_status wave_info + "   - drag inside: duty / phase, 1-5 shape, [ ] cycles, Enter = done"
            END IF
        ELSEIF drawing >= 13 AND drawing <= 16 THEN ' resizing the live waveform's box
            IF b1 THEN
                wave_resize drawing, s, nt
            ELSE
                drawing = 0
                set_status wave_info + "  - steps" + STR$(waveS0) + " -" + STR$(waveS1 - 1) + ", " + note_name(wave_min) + " - " + note_name(wave_max)
            END IF
        ELSEIF drawing = 7 THEN ' adjusting duty / phase inside the live box
            IF b1 THEN
                waveDuty = adjDuty + (mx - adjX) / 400
                IF waveDuty < 0.02 THEN waveDuty = 0.02
                IF waveDuty > 1 THEN waveDuty = 1
                wavePhase = adjPhase + (adjY - my) / 300
                wavePhase = wavePhase - INT(wavePhase)
                wave_render
            ELSE
                drawing = 0
            END IF
        ELSEIF drawing = 8 THEN ' rubber band line
            IF b1 THEN
                sndData(cur) = lineBase
                draw_line lineS, lineNt, s, nt, 0
            ELSE
                drawing = 0
                lastStep = s: lastNote = nt
                haveAnchor = -1
            END IF
        ELSEIF drawing >= 17 AND drawing <= 19 THEN ' time ruler: cursor / loop region
            IF b1 THEN
                ruler_drag drawing, s, mx
            ELSE
                drawing = 0
                IF loopSet THEN set_status "Loop region: steps" + STR$(loopA) + " -" + STR$(loopB - 1) + "  (drag its ends, right-click the ruler clears it, Ctrl+L loop on/off)"
            END IF
        ELSEIF drawing >= 9 AND drawing <= 12 THEN ' stretching the selection
            IF b1 THEN
                tf_drag drawing, s, nt
            ELSE
                drawing = 0
                set_status "Stretched: steps" + STR$(selS0) + " -" + STR$(selS1 - 1) + ", " + note_name(selLo) + " - " + note_name(selHi) + " (Ctrl+Z undoes)"
            END IF
        ELSEIF drawing = 5 THEN ' moving the selection
            IF b1 THEN
                drag_move s, nt
            ELSE
                drawing = 0
                end_move
            END IF
        ELSEIF drawing = 1 AND b1 THEN
            draw_line lastStep, lastNote, s, nt, 0
            lastStep = s: lastNote = nt
        ELSEIF drawing = 2 AND (b1 OR b2) THEN
            draw_line lastStep, lastNote, s, nt, -1
            lastStep = s: lastNote = nt
        ELSE
            drawing = 0
            haveAnchor = -1
        END IF
    ELSEIF inCanvas AND b1 AND NOT wasDown AND tool = TOOL_WAVE THEN
        IF waveLive AND wave_edge(mx, my) > 0 THEN
            drawing = 12 + wave_edge(mx, my) ' 13 left, 14 right, 15 top, 16 bottom
            waveTopIsHi = (waveHi >= waveLo)
        ELSEIF waveLive AND s >= waveS0 AND s < waveS1 AND nt >= wave_min - 0.5 AND nt <= wave_max + 0.5 THEN
            drawing = 7 ' inside the live box: adjust it
            adjX = mx: adjY = my: adjDuty = waveDuty: adjPhase = wavePhase
        ELSE
            wave_done
            IF playing THEN stop_playing
            push_undo
            waveBase = sndData(cur)
            waveLive = -1
            waveAS = s: waveAN = nt
            wave_box s, nt, s, nt
            drawing = 6
        END IF
    ELSEIF inCanvas AND b1 AND NOT wasDown AND tool = TOOL_LINE THEN
        IF playing THEN stop_playing
        push_undo
        lineBase = sndData(cur)
        lineS = s: lineNt = nt
        IF snapOn THEN lineNt = INT(nt + 0.5)
        draw_line s, lineNt, s, lineNt, 0
        drawing = 8
    ELSEIF inCanvas AND b1 AND NOT wasDown AND (tool = TOOL_SELECT OR tool = TOOL_MOVE) AND sel_edge(mx, my) > 0 THEN
        IF playing THEN stop_playing
        drawing = 8 + sel_edge(mx, my) ' 9 left, 10 right, 11 top, 12 bottom
        tf_begin
    ELSEIF inCanvas AND b1 AND NOT wasDown AND tool = TOOL_SELECT THEN
        drawing = 4
        boxS = s: boxN = nt
        set_box s, nt, s, nt, shift
    ELSEIF inCanvas AND b1 AND NOT wasDown AND tool = TOOL_MOVE THEN
        IF selOn AND in_box(s, nt) THEN
            IF playing THEN stop_playing
            begin_move
            moveS = s: moveNt = nt
            drawing = 5
        ELSE
            set_status "Select something first: S tool, drag a box (then M, or drag inside it)"
        END IF
    ELSEIF inCanvas AND (b1 OR b2) AND NOT wasDown THEN
        push_undo
        IF playing THEN stop_playing
        IF b1 AND tool <> TOOL_ERASE THEN drawing = 1 ELSE drawing = 2
        IF b1 AND tool = TOOL_NOTE THEN
            ' NOTE tool: the pitch is fixed where you click
            drawing = 3
            noteNt = nt
            IF snapOn THEN noteNt = INT(nt + 0.5)
            noteS0 = s
            IF grid_snap THEN noteS0 = cell_start(cell_of(s))
            ' G: into a voice that is free there, so notes stack into chords
            noteHome = 0
            IF allVoices THEN
                noteHome = sndAct(cur)
                vswap free_voice(noteS0, note_tool_end(noteS0))
            END IF
            noteBase = sndData(cur)
            place_note s
        ELSEIF b1 AND shift AND haveAnchor THEN
            draw_line lastStep, lastNote, s, nt, 0
        ELSE
            draw_line s, nt, s, nt, (drawing = 2)
        END IF
        lastStep = s: lastNote = nt
    ELSEIF b1 AND NOT wasDown THEN
        ' --- toolbar
        IF my >= TB_Y AND my < TB_Y + TB_H AND mx >= RULER_X AND mx < RULER_X + TB_BUTTONS * TB_W THEN
            toolbar_click (mx - RULER_X) \ TB_W
        ' --- time ruler: click = cursor, drag = loop region (or drag its ends)
        ELSEIF my >= TIME_Y AND my < CANVAS_Y AND mx >= CANVAS_X THEN
            rulerPressX = mx
            rulerAnchor = s
            loopSetByDrag = 0
            rulerCursor = cursorStep
            drawing = 17
            IF loopSet THEN
                IF ABS(mx - (CANVAS_X + (loopA - scrollX) * zoom)) <= 4 THEN drawing = 18
                IF ABS(mx - (CANVAS_X + (loopB - scrollX) * zoom)) <= 4 THEN drawing = 19
            END IF
            IF drawing = 17 THEN
                cursorStep = s
                IF grid_snap THEN cursorStep = snap_cell(s)
            END IF
        ' --- voice chips
        ELSEIF voice_chip_hit(mx, my) THEN
            SELECT CASE voice_chip_hit(mx, my)
                CASE 5: toggle_all
                CASE 6: toggle_poly
                CASE ELSE: switch_voice voice_chip_hit(mx, my)
            END SELECT
        ' --- sound list
        ELSEIF mx >= LIST_X AND mx < LIST_X + LIST_W AND my >= LIST_Y AND my < LIST_Y + LIST_ROWS * ROW_H THEN
            row = listTop + (my - LIST_Y) \ ROW_H + 1
            IF row <= sndCount THEN user_select row
        END IF
    ELSEIF b2 AND NOT wasDown AND my >= TIME_Y AND my < CANVAS_Y AND mx >= CANVAS_X THEN
        IF loopSet THEN loopSet = 0: set_status "Loop region cleared"
    END IF
    wasDown = b1 OR b2

    ' drawing audition: while drawing / placing / moving, hear the step under
    ' the pointer (not while erasing or dragging a selection box)
    drawAud = 0
    IF drawAudOn AND b1 THEN
        SELECT CASE drawing
            CASE 1, 3, 5, 6, 7, 8: drawAud = get_step(cur, s)
        END SELECT
    END IF
END SUB


'-----------------------------------------------------------------------------
' Tools, toolbar, selection, moving, clipboard
'-----------------------------------------------------------------------------

SUB set_tool (t AS INTEGER)
    IF t <> TOOL_WAVE THEN wave_done
    tool = t
    drawing = 0
    set_status tool_help
END SUB


''
' The tools in toolbar (and Tab) order.
'
FUNCTION tb_tool% (i AS LONG)
    tb_tool = VAL(MID$("0516234", i + 1, 1)) ' DRAW LINE NOTE WAVE ERASE SELECT MOVE
END FUNCTION


FUNCTION tb_index& (t AS INTEGER)
    tb_index = INSTR("0516234", LTRIM$(STR$(t))) - 1
END FUNCTION


FUNCTION tool_name$ (t AS INTEGER)
    SELECT CASE t
        CASE TOOL_DRAW: tool_name = "D)raw"
        CASE TOOL_LINE: tool_name = "L)ine"
        CASE TOOL_NOTE: tool_name = "N)ote"
        CASE TOOL_WAVE: tool_name = "W)ave"
        CASE TOOL_ERASE: tool_name = "E)rase"
        CASE TOOL_SELECT: tool_name = "S)elect"
        CASE TOOL_MOVE: tool_name = "M)ove"
    END SELECT
END FUNCTION


FUNCTION tool_help$
    SELECT CASE tool
        CASE TOOL_DRAW: tool_help = "DRAW: drag draws freehand, one step at a time (sweeps); Shift+click = straight line"
        CASE TOOL_LINE: tool_help = "LINE: press, drag, release = a straight line of steps"
        CASE TOOL_WAVE
            IF waveLive THEN
                tool_help = wave_info + "  drag inside: <> duty, ^v phase   1-5 shape  [ ] cycles  Enter done"
            ELSE
                tool_help = "WAVE: drag a box (width = time, height = pitch range)   " + wave_info
            END IF
        CASE TOOL_NOTE: tool_help = "NOTE: click = steady note Len long (F11/F12), drag right = longer"
        CASE TOOL_ERASE: tool_help = "ERASE: drag to clear steps"
        CASE TOOL_SELECT: tool_help = "SELECT: drag a box (snaps to the grid; Alt = free, Shift = beats); rests inside count; Ctrl+A all"
        CASE TOOL_MOVE: tool_help = "MOVE: drag the selection (by grid cells; Alt = by steps); arrows nudge it (Shift+Up/Down = octave)"
    END SELECT
END FUNCTION


''
' Toolbar buttons: the tools first (tb_tool order), then cut / copy / paste.
'
SUB toolbar_click (i AS LONG)
    SELECT CASE i
        CASE 0 TO TB_TOOLS - 1: set_tool tb_tool(i)
        CASE TB_TOOLS: sel_cut
        CASE TB_TOOLS + 1: sel_copy
        CASE TB_TOOLS + 2: sel_paste
        CASE TB_TOOLS + 3: toggle_loop
    END SELECT
END SUB


'--- WAVE tool ------------------------------------------------------------------

''
' 0-1 at position t (0-1) of one cycle. duty is where the shape turns:
' square - time spent high; triangle / sine - where the peak is; saws -
' how much of the cycle the ramp takes (1 = a plain saw).
'
FUNCTION wave_at# (t AS DOUBLE)
    DIM d AS DOUBLE
    d = waveDuty
    SELECT CASE waveShape
        CASE WAVE_SQUARE
            IF t < d THEN wave_at = 1 ELSE wave_at = 0
        CASE WAVE_TRIANGLE
            IF d >= 1 THEN d = 0.999
            IF t < d THEN wave_at = t / d ELSE wave_at = (1 - t) / (1 - d)
        CASE WAVE_SAWUP
            IF t < d THEN wave_at = t / d ELSE wave_at = 1
        CASE WAVE_SAWDOWN
            IF t < d THEN wave_at = 1 - t / d ELSE wave_at = 0
        CASE WAVE_SINE
            IF d >= 1 THEN d = 0.999
            IF t < d THEN
                wave_at = 0.5 - 0.5 * COS(_PI * t / d)
            ELSE
                wave_at = 0.5 + 0.5 * COS(_PI * (t - d) / (1 - d))
            END IF
    END SELECT
END FUNCTION


FUNCTION wave_name$
    SELECT CASE waveShape
        CASE WAVE_SQUARE: wave_name = "1 SQUARE"
        CASE WAVE_TRIANGLE: wave_name = "2 TRIANGLE"
        CASE WAVE_SAWUP: wave_name = "3 SAW UP"
        CASE WAVE_SAWDOWN: wave_name = "4 SAW DOWN"
        CASE WAVE_SINE: wave_name = "5 SINE"
    END SELECT
END FUNCTION


FUNCTION wave_info$
    wave_info = wave_name + "  cycles" + STR$(waveCycles) + "  duty" + STR$(CLNG(waveDuty * 100)) + "%  phase" + STR$(CLNG(wavePhase * 100)) + "%"
END FUNCTION


''
' Set the live waveform's box from two corners and draw it.
'
SUB wave_box (sa AS LONG, na AS DOUBLE, sb AS LONG, nb AS DOUBLE)
    DIM a AS LONG, b AS LONG
    IF sa <= sb THEN a = sa: b = sb ELSE a = sb: b = sa
    IF grid_snap THEN
        waveS0 = cell_start(cell_of(a))
        waveS1 = cell_start(cell_of(b) + 1)
    ELSE
        waveS0 = a
        waveS1 = b + 1
    END IF
    waveLo = na: waveHi = nb
    IF waveLo > waveHi THEN SWAP waveLo, waveHi
    IF snapOn THEN waveLo = INT(waveLo + 0.5): waveHi = INT(waveHi + 0.5)
    wave_render
END SUB


FUNCTION wave_min#
    IF waveLo <= waveHi THEN wave_min = waveLo ELSE wave_min = waveHi
END FUNCTION


FUNCTION wave_max#
    IF waveLo <= waveHi THEN wave_max = waveHi ELSE wave_max = waveLo
END FUNCTION


''
' Which edge of the live waveform's box is under x, y (as sel_edge).
'
FUNCTION wave_edge% (x AS LONG, y AS LONG)
    DIM xl AS LONG, xr AS LONG, yt AS LONG, yb AS LONG
    IF NOT waveLive THEN EXIT FUNCTION
    xl = CANVAS_X + (waveS0 - scrollX) * zoom
    xr = CANVAS_X + (waveS1 - scrollX) * zoom
    yt = clip_y(note_y(wave_max) - PX_SEMI \ 2)
    yb = clip_y(note_y(wave_min) + PX_SEMI \ 2)
    IF y >= yt - 4 AND y <= yb + 4 THEN
        IF ABS(x - xl) <= 4 THEN wave_edge = 1: EXIT FUNCTION
        IF ABS(x - xr) <= 4 THEN wave_edge = 2: EXIT FUNCTION
    END IF
    IF x > xl + 4 AND x < xr - 4 THEN
        IF ABS(y - yt) <= 4 THEN wave_edge = 3: EXIT FUNCTION
        IF ABS(y - yb) <= 4 THEN wave_edge = 4: EXIT FUNCTION
    END IF
END FUNCTION


''
' Drag an edge of the live waveform's box (drawing 13-16). Time edges keep
' the number of cycles, so each cycle stretches; pitch edges move the top or
' bottom of its swing, and past the other edge the shape turns upside down.
'
SUB wave_resize (which AS INTEGER, s AS LONG, nt AS DOUBLE)
    DIM e AS LONG, p AS DOUBLE
    SELECT CASE which
        CASE 13
            e = s
            IF grid_snap THEN e = snap_cell(e)
            IF e > waveS1 - 1 THEN e = waveS1 - 1
            IF e < 0 THEN e = 0
            waveS0 = e
        CASE 14
            e = s + 1
            IF grid_snap THEN e = snap_cell(e)
            IF e < waveS0 + 1 THEN e = waveS0 + 1
            waveS1 = e
        CASE 15, 16
            p = nt
            IF snapOn THEN p = INT(p + 0.5)
            ' top edge = the higher end of the swing (as it was when the drag began)
            IF (which = 15) = (waveTopIsHi <> 0) THEN waveHi = p ELSE waveLo = p
    END SELECT
    wave_render
END SUB


''
' Put the sound back as it was, then write the waveform into the box.
'
SUB wave_render
    DIM s AS LONG, ln AS LONG, t AS DOUBLE, nt AS DOUBLE
    IF NOT waveLive THEN EXIT SUB
    sndData(cur) = waveBase
    ln = waveS1 - waveS0
    IF ln < 1 THEN EXIT SUB
    FOR s = waveS0 TO waveS1 - 1
        t = (s - waveS0) * waveCycles / ln + wavePhase
        t = t - INT(t)
        nt = waveLo + wave_at(t) * (waveHi - waveLo)
        IF snapOn THEN nt = INT(nt + 0.5)
        set_step cur, s, note_div(nt)
    NEXT
END SUB


''
' Finish the live waveform: it stays as drawn and stops being adjustable.
'
SUB wave_done
    IF NOT waveLive THEN EXIT SUB
    waveLive = 0
    IF drawing = 6 OR drawing = 7 THEN drawing = 0
END SUB


SUB wave_cancel
    IF NOT waveLive THEN EXIT SUB
    sndData(cur) = waveBase
    waveLive = 0
    IF undoN > 0 THEN undoN = undoN - 1
    set_status "Waveform cancelled"
END SUB


''
' 1-5 and [ ] while the WAVE tool is active (re-draws a live waveform).
'
SUB wave_key (c AS STRING)
    SELECT CASE c
        CASE "1" TO "5"
            waveShape = VAL(c)
            ' sensible duty for each shape: saws ramp the whole cycle
            IF waveShape = WAVE_SAWUP OR waveShape = WAVE_SAWDOWN THEN waveDuty = 1 ELSE IF waveDuty >= 1 THEN waveDuty = 0.5
        CASE "["
            IF waveCycles > 1 THEN waveCycles = waveCycles - 1
        CASE "]"
            IF waveCycles < 128 THEN waveCycles = waveCycles + 1
        CASE ELSE
            EXIT SUB
    END SELECT
    wave_render
    set_status wave_info
END SUB


''
' The selection box from two corners (step, pitch). With the grid and snap
' on its ends snap to whole cells (Alt: not).
'
FUNCTION free_hand%
    free_hand = _KEYDOWN(100307) OR _KEYDOWN(100308) OR modAlt
END FUNCTION


''
' Grid snap: the grid is on, snap (F6) is on and Alt isn't held. Every tool
' that places things in time asks this.
'
FUNCTION grid_snap%
    grid_snap = gridDiv <> 0 AND snapOn <> 0 AND NOT free_hand
END FUNCTION


''
SUB set_box (sa AS LONG, na AS DOUBLE, sb AS LONG, nb AS DOUBLE, snapIt AS INTEGER)
    DIM a AS LONG, b AS LONG, beatLen AS DOUBLE
    IF sa <= sb THEN a = sa: b = sb ELSE a = sb: b = sa
    ' Snap on (F6) with the grid on, or Shift: whole grid cells; Shift with
    ' the grid off: whole beats - so a selection is a clean musical chunk.
    ' Alt held: exact steps whatever the snap.
    IF grid_snap OR (snapIt AND gridDiv <> 0 AND NOT free_hand) THEN
        selS0 = cell_start(cell_of(a))
        selS1 = cell_start(cell_of(b) + 1)
    ELSEIF snapIt AND NOT free_hand THEN
        beatLen = 60 * rateHz / bpm
        selS0 = INT(INT(a / beatLen) * beatLen + 0.5)
        selS1 = INT((INT(b / beatLen) + 1) * beatLen + 0.5)
    ELSE
        selS0 = a
        selS1 = b + 1
    END IF
    selLo = INT(na + 0.5): selHi = INT(nb + 0.5)
    IF selLo > selHi THEN SWAP selLo, selHi
    selOn = -1
END SUB


FUNCTION in_box% (s AS LONG, nt AS DOUBLE)
    in_box = selOn AND s >= selS0 AND s < selS1 AND nt >= selLo - 0.5 AND nt < selHi + 0.5
END FUNCTION


''
' Is step s (with value v) part of the selection?
'
''
' Is step s (with value v) part of the selection? Rests (v = 0) in the
' box's time span are too, so a selection is a whole chunk of music:
' moving, cutting, copying and pasting it keeps its silences.
'
FUNCTION in_sel% (s AS LONG, v AS LONG)
    IF NOT selOn THEN EXIT FUNCTION
    IF v = 0 THEN
        in_sel = (s >= selS0 AND s < selS1)
    ELSE
        in_sel = in_box(s, div_note(v))
    END IF
END FUNCTION


FUNCTION sel_count&
    DIM s AS LONG, n AS LONG, k AS LONG, v AS LONG
    FOR s = selS0 TO selS1 - 1
        IF in_sel(s, get_step(cur, s)) THEN n = n + 1
    NEXT
    IF allVoices THEN ' and the other voices' notes
        FOR k = 1 TO VOICES
            IF k <> sndAct(cur) THEN
                FOR s = selS0 TO selS1 - 1
                    v = voice_step(cur, k, s)
                    IF v THEN
                        IF in_sel(s, v) THEN n = n + 1
                    END IF
                NEXT
            END IF
        NEXT
    END IF
    sel_count = n
END FUNCTION


SUB select_all
    DIM s AS LONG, v AS LONG, n AS LONG, lo AS LONG, hi AS LONG, k AS LONG
    set_vmask
    selS1 = steps_of(cur)
    IF allVoices THEN selS1 = snd_len(cur)
    IF selS1 = 0 THEN EXIT SUB
    selS0 = 0
    ' the box spans the notes the sound actually uses (so its top / bottom
    ' stretch handles sit on the music, inside the roll)
    lo = 999: hi = -999
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            FOR s = 0 TO selS1 - 1
                v = voice_step(cur, k, s)
                IF v THEN
                    n = INT(div_note(v) + 0.5)
                    IF n < lo THEN lo = n
                    IF n > hi THEN hi = n
                END IF
            NEXT
        END IF
    NEXT
    IF hi < lo THEN lo = NOTE_LO: hi = NOTE_HI - 1
    selLo = lo: selHi = hi
    selOn = -1
    set_tool TOOL_MOVE
    set_status "All" + STR$(sel_count) + " steps selected - drag or use the arrows to move them"
END SUB


''
' Lift the selected steps out of the sound: remember them in item*, and keep
' each voice without them in moveBaseV.
'
SUB begin_move
    DIM s AS LONG, v AS LONG, k AS LONG, home AS LONG
    push_undo
    itemN = 0
    REDIM itemS(0 TO (selS1 - selS0) * VOICES) AS LONG
    REDIM itemV(0 TO (selS1 - selS0) * VOICES) AS LONG
    REDIM itemK(0 TO (selS1 - selS0) * VOICES) AS LONG
    set_vmask
    home = sndAct(cur)
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            vswap k
            FOR s = selS0 TO selS1 - 1
                ' the other voices: only notes and rests inside the voice
                IF k = home OR s < steps_of(cur) THEN
                    v = get_step(cur, s)
                    IF in_sel(s, v) THEN
                        itemS(itemN) = s: itemV(itemN) = v: itemK(itemN) = k: itemN = itemN + 1
                        set_step cur, s, 0
                    END IF
                END IF
            NEXT
            moveBaseV(k) = sndData(cur)
        END IF
    NEXT
    vswap home
    moveDs = 0: moveDn = 0
END SUB


''
' Put the lifted steps back, moved ds steps and dn semitones.
'
SUB put_moved (ds AS LONG, dn AS LONG)
    DIM i AS LONG, s AS LONG, v AS LONG, k AS LONG, home AS LONG
    home = sndAct(cur)
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            vswap k
            sndData(cur) = moveBaseV(k)
            FOR i = 0 TO itemN - 1
                s = itemS(i) + ds
                IF itemK(i) = k AND s >= 0 AND s < MAX_STEPS THEN
                    v = itemV(i)
                    IF v THEN ' rests stay rests
                        v = CLNG(v / 2 ^ (dn / 12))
                        IF v < 1 THEN v = 1
                    END IF
                    set_step cur, s, v
                END IF
            NEXT
        END IF
    NEXT
    vswap home
    moveDs = ds: moveDn = dn
END SUB


SUB drag_move (s AS LONG, nt AS DOUBLE)
    DIM ds AS LONG, dn AS LONG
    IF grid_snap THEN ' Alt: by steps
        ds = cell_start(cell_of(moveS) + (cell_of(s) - cell_of(moveS))) - cell_start(cell_of(moveS))
    ELSE
        ds = s - moveS
    END IF
    IF selS0 + ds < 0 THEN ds = -selS0
    dn = INT(nt - moveNt + 0.5 * SGN(nt - moveNt))
    IF ds <> moveDs OR dn <> moveDn THEN put_moved ds, dn
END SUB


''
' After a move the box follows what was moved.
'
SUB end_move
    selS0 = selS0 + moveDs: selS1 = selS1 + moveDs
    selLo = selLo + moveDn: selHi = selHi + moveDn
    IF moveDs = 0 AND moveDn = 0 THEN
        IF undoN > 0 THEN undoN = undoN - 1 ' nothing changed: drop the undo step
    ELSE
        set_status "Moved" + STR$(moveDs) + " steps," + STR$(moveDn) + " semitones"
    END IF
END SUB


''
' Arrow keys with a selection: move it by ds steps / dn semitones.
'
SUB nudge (ds AS LONG, dn AS LONG)
    DIM d AS LONG
    d = ds
    IF selS0 + d < 0 THEN d = -selS0
    IF d = 0 AND dn = 0 THEN EXIT SUB
    begin_move
    put_moved d, dn
    end_move
END SUB


''
' Alt+Up/Down: change every selected step's PIT divisor by one - the
' finest pitch change the file (and the real hardware) can make.
'
SUB fine_pitch (dv AS LONG)
    DIM s AS LONG, v AS LONG, n AS LONG, k AS LONG
    IF NOT selOn THEN EXIT SUB
    push_undo
    set_vmask
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            FOR s = selS0 TO selS1 - 1
                v = voice_step(cur, k, s)
                IF v <> 0 AND in_sel(s, v) THEN
                    v = v + dv
                    IF v >= 1 AND v <= 65534 THEN set_voice_step cur, k, s, v: n = n + 1
                END IF
            NEXT
        END IF
    NEXT
    IF n THEN
        set_status "Fine pitch: divisors " + MID$("+-", 1 - (dv < 0), 1) + "1 on" + STR$(n) + " steps (Alt+Up/Down)"
    END IF
END SUB


''
' How far Left / Right nudge a selection: to the next grid line with grid
' snap (Alt: one step).
'
FUNCTION nudge_step& (dirn AS LONG)
    IF NOT grid_snap THEN nudge_step = dirn: EXIT FUNCTION
    IF dirn > 0 THEN nudge_step = grid_next(selS0, 1) - selS0 ELSE nudge_step = grid_prev(selS0, 1) - selS0
END FUNCTION


SUB sel_copy
    DIM s AS LONG, v AS LONG, k AS LONG
    IF NOT selOn THEN set_status "Nothing selected - use the S tool to drag a box": EXIT SUB
    clipN = 0
    REDIM clipS(0 TO (selS1 - selS0) * VOICES) AS LONG
    REDIM clipV(0 TO (selS1 - selS0) * VOICES) AS LONG
    REDIM clipK(0 TO (selS1 - selS0) * VOICES) AS LONG
    set_vmask
    clipAll = allVoices
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            FOR s = selS0 TO selS1 - 1
                v = voice_step(cur, k, s)
                ' rests: the edited voice's (it is the timing); notes: all
                IF in_sel(s, v) AND (v <> 0 OR k = sndAct(cur)) THEN
                    clipS(clipN) = s - selS0: clipV(clipN) = v: clipK(clipN) = k: clipN = clipN + 1
                END IF
            NEXT
        END IF
    NEXT
    clipLen = selS1 - selS0
    clipLo = selLo: clipHi = selHi
    set_status "Copied" + STR$(clipN) + " steps - Ctrl+V pastes them at the cursor"
END SUB


''
' Clear the selected steps (Delete), or copy them first (cut).
'
SUB sel_clear (announce AS INTEGER)
    DIM s AS LONG, k AS LONG, v AS LONG
    IF NOT selOn THEN set_status "Nothing selected": EXIT SUB
    push_undo
    set_vmask
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            FOR s = selS0 TO selS1 - 1
                v = voice_step(cur, k, s)
                IF v <> 0 OR k = sndAct(cur) THEN
                    IF in_sel(s, v) THEN set_voice_step cur, k, s, 0
                END IF
            NEXT
        END IF
    NEXT
    IF announce THEN set_status "Cleared the selection"
END SUB


SUB sel_cut
    IF NOT selOn THEN set_status "Nothing selected - use the S tool to drag a box": EXIT SUB
    sel_copy
    sel_clear 0
    set_status "Cut" + STR$(clipN) + " steps - Ctrl+V pastes them at the cursor"
END SUB


''
' Paste at the cursor (on top of what is there); the pasted steps become
' the selection, ready to move.
'
SUB sel_paste
    DIM i AS LONG
    IF clipN = 0 THEN set_status "The clipboard is empty - Ctrl+C or cut a selection first": EXIT SUB
    IF grid_snap THEN cursorStep = snap_cell(cursorStep) ' on a grid line (Ctrl+Alt+V: exactly at the cursor)
    push_undo
    FOR i = 0 TO clipN - 1
        IF cursorStep + clipS(i) < MAX_STEPS THEN
            IF clipAll THEN
                set_voice_step cur, clipK(i), cursorStep + clipS(i), clipV(i)
            ELSE
                set_step cur, cursorStep + clipS(i), clipV(i)
            END IF
        END IF
    NEXT
    selS0 = cursorStep: selS1 = cursorStep + clipLen
    selLo = clipLo: selHi = clipHi
    selOn = -1
    set_status "Pasted" + STR$(clipN) + " steps - they are selected: drag (M) or nudge with the arrows"
END SUB


'--- transform: stretch the selection in time and pitch ------------------------

''
' Which edge of the selection box (if any) is under screen point x, y:
' 1 left, 2 right, 3 top, 4 bottom.
'
FUNCTION sel_edge% (x AS LONG, y AS LONG)
    DIM xl AS LONG, xr AS LONG, yt AS LONG, yb AS LONG
    IF NOT selOn THEN EXIT FUNCTION
    xl = CANVAS_X + (selS0 - scrollX) * zoom
    xr = CANVAS_X + (selS1 - scrollX) * zoom
    yt = clip_y(note_y(selHi) - PX_SEMI \ 2)
    yb = clip_y(note_y(selLo) + PX_SEMI \ 2)
    IF y >= yt - 4 AND y <= yb + 4 THEN
        IF ABS(x - xl) <= 4 THEN sel_edge = 1: EXIT FUNCTION
        IF ABS(x - xr) <= 4 THEN sel_edge = 2: EXIT FUNCTION
    END IF
    IF x > xl + 4 AND x < xr - 4 THEN
        IF ABS(y - yt) <= 4 THEN sel_edge = 3: EXIT FUNCTION
        IF ABS(y - yb) <= 4 THEN sel_edge = 4: EXIT FUNCTION
    END IF
END FUNCTION


''
' Lift the selection out (rests too) and remember the box, for stretching.
'
SUB tf_begin
    DIM s AS LONG, v AS LONG, k AS LONG, home AS LONG
    push_undo
    tfS0 = selS0: tfS1 = selS1: tfLo = selLo: tfHi = selHi
    REDIM tfV(1 TO VOICES, 0 TO tfS1 - tfS0) AS LONG
    set_vmask
    home = sndAct(cur)
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            vswap k
            FOR s = tfS0 TO tfS1 - 1
                v = get_step(cur, s)
                IF in_sel(s, v) AND (k = home OR s < steps_of(cur)) THEN
                    tfV(k, s - tfS0) = v
                    set_step cur, s, 0
                ELSE
                    tfV(k, s - tfS0) = -1
                END IF
            NEXT
            tfBaseV(k) = sndData(cur)
        END IF
    NEXT
    vswap home
END SUB


''
' Put the lifted selection back stretched to steps n0..n1-1 and to the pitch
' range pLo..pHi (each pitch keeps its place within the range; pLo above pHi
' turns it upside down). The selection box follows.
'
SUB tf_apply (n0 AS LONG, n1 AS LONG, pLo AS DOUBLE, pHi AS DOUBLE)
    DIM t AS LONG, oldLen AS LONG, newLen AS LONG, v AS LONG, nt AS DOUBLE, k AS LONG, home AS LONG
    oldLen = tfS1 - tfS0
    newLen = n1 - n0
    IF newLen < 1 OR oldLen < 1 THEN EXIT SUB
    home = sndAct(cur)
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            vswap k
            sndData(cur) = tfBaseV(k)
            FOR t = n0 TO n1 - 1
                IF t >= 0 AND t < MAX_STEPS THEN
                    v = tfV(k, INT((t - n0) * oldLen / newLen))
                    IF v > 0 AND (pLo <> tfLo OR pHi <> tfHi) THEN
                        nt = div_note(v)
                        IF tfHi = tfLo THEN
                            nt = nt + (pLo - tfLo)
                        ELSE
                            nt = pLo + (nt - tfLo) * (pHi - pLo) / (tfHi - tfLo)
                        END IF
                        IF snapOn THEN nt = INT(nt + 0.5)
                        v = note_div(nt)
                    END IF
                    IF v >= 0 THEN set_step cur, t, v
                END IF
            NEXT
        END IF
    NEXT
    vswap home
    selS0 = n0: selS1 = n1
    selLo = INT(pLo + 0.5): selHi = INT(pHi + 0.5)
    IF selLo > selHi THEN SWAP selLo, selHi
END SUB


''
' Dragging an edge of the box (drawing 9-12) to step s / pitch nt.
'
SUB tf_drag (which AS INTEGER, s AS LONG, nt AS DOUBLE)
    DIM e AS LONG, p AS DOUBLE
    SELECT CASE which
        CASE 9, 10 ' time: the edge snaps to grid cells with grid and snap on (Alt: not)
            e = s
            IF which = 10 THEN e = s + 1
            IF grid_snap THEN e = snap_cell(e)
            IF which = 9 THEN
                IF e > tfS1 - 1 THEN e = tfS1 - 1
                IF e < 0 THEN e = 0
                tf_apply e, tfS1, tfLo, tfHi
            ELSE
                IF e < tfS0 + 1 THEN e = tfS0 + 1
                tf_apply tfS0, e, tfLo, tfHi
            END IF
        CASE 11 ' top edge: the bottom stays put
            p = nt
            IF snapOn THEN p = INT(p + 0.5)
            tf_apply tfS0, tfS1, tfLo, p
        CASE 12 ' bottom edge: the top stays put
            p = nt
            IF snapOn THEN p = INT(p + 0.5)
            tf_apply tfS0, tfS1, p, tfHi
    END SELECT
END SUB


''
' Ctrl+Up / Ctrl+Down: the selection twice / half as long (from its start).
'
SUB tf_time (f AS DOUBLE)
    DIM n1 AS LONG
    IF NOT selOn THEN EXIT SUB
    IF playing THEN stop_playing
    tf_begin
    n1 = tfS0 + CLNG((tfS1 - tfS0) * f)
    IF n1 < tfS0 + 1 THEN n1 = tfS0 + 1
    IF n1 > MAX_STEPS THEN n1 = MAX_STEPS
    tf_apply tfS0, n1, tfLo, tfHi
    set_status "Selection" + MID$(" twice as long", 1, -14 * (f > 1)) + MID$(" half as long", 1, -13 * (f < 1)) + ":" + STR$(n1 - tfS0) + " steps (Ctrl+Z undoes)"
END SUB


''
' NOTE tool: put back the sound as it was when the button went down, then
' write one steady note from noteS0 to wherever the mouse is now - at least
' Len long (Len counts grid cells while the grid is on).
'
SUB place_note (mouseS AS LONG)
    DIM e AS LONG, i AS LONG, v AS LONG
    e = note_tool_end(noteS0)
    IF grid_snap THEN
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
    IF grid_snap THEN
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

    ' grid snap: whole cells, one pitch per cell
    IF grid_snap THEN
        ca = cell_of(a)
        cb = cell_of(b)
        FOR c = ca TO cb
            IF cb > ca THEN nt = na + (nb - na) * (c - ca) / (cb - ca) ELSE nt = na
            IF snapOn THEN nt = INT(nt + 0.5)
            v = note_div(nt)
            FOR s = cell_start(c) TO cell_start(c + 1) - 1
                IF erasing THEN
                    erase_at s, nt
                ELSE
                    set_step cur, s, v
                END IF
            NEXT
        NEXT
        EXIT SUB
    END IF

    FOR s = a TO b
        IF b > a THEN nt = na + (nb - na) * (s - a) / (b - a) ELSE nt = na
        IF erasing THEN
            erase_at s, nt
        ELSE
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
            ELSEIF waveLive THEN
                wave_cancel
            ELSEIF selOn THEN
                selOn = 0
                set_status "Selection cleared"
            ELSEIF recording THEN
                stop_recording
            ELSEIF playing THEN
                stop_playing
            ELSEIF ok_to_lose("Quit") THEN
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
        CASE 13 '                                              Enter
            IF waveLive THEN
                wave_done
                set_status "Waveform done - drag another box, or pick another tool"
            ELSE
                play_from cursorStep
            END IF
        CASE 19200 '                                           Left
            IF selOn AND NOT ctrl THEN
                nudge nudge_step(-1), 0
            ELSEIF gridDiv THEN
                IF ctrl THEN move_cursor grid_prev(cursorStep, beat_cells) ELSE move_cursor grid_prev(cursorStep, 1)
            ELSE
                IF ctrl THEN move_cursor cursorStep - 14 ELSE move_cursor cursorStep - 1
            END IF
        CASE 19712 '                                           Right
            IF selOn AND NOT ctrl THEN
                nudge nudge_step(1), 0
            ELSEIF gridDiv THEN
                IF ctrl THEN move_cursor grid_next(cursorStep, beat_cells) ELSE move_cursor grid_next(cursorStep, 1)
            ELSE
                IF ctrl THEN move_cursor cursorStep + 14 ELSE move_cursor cursorStep + 1
            END IF
        CASE 18176: move_cursor 0 '                            Home
        CASE 20224: move_cursor snd_len(cur) '                End
        CASE 18432 '                                           Up
            IF selOn AND modAlt THEN
                fine_pitch -1 ' smaller divisor = higher pitch
            ELSEIF selOn AND NOT ctrl THEN
                IF shift THEN nudge 0, 12 ELSE nudge 0, 1
            ELSEIF selOn THEN
                tf_time 2 ' Ctrl+Up: twice as long
            ELSEIF ctrl THEN
                IF shift THEN transpose 12 ELSE transpose 1
            ELSE
                user_select cur - 1
            END IF
        CASE 20480 '                                           Down
            IF selOn AND modAlt THEN
                fine_pitch 1
            ELSEIF selOn AND NOT ctrl THEN
                IF shift THEN nudge 0, -12 ELSE nudge 0, -1
            ELSEIF selOn THEN
                tf_time 0.5 ' Ctrl+Down: half as long
            ELSEIF ctrl THEN
                IF shift THEN transpose -12 ELSE transpose -1
            ELSE
                user_select cur + 1
            END IF
        CASE 18688 '                                           PgUp
            IF ctrl THEN user_select cur - 1 ELSE jump_mark -1
        CASE 20736 '                                           PgDn
            IF ctrl THEN user_select cur + 1 ELSE jump_mark 1
        CASE 20992: insert_step '                              Insert
        CASE 21248 '                                           Delete
            IF selOn THEN sel_clear -1 ELSE delete_step cursorStep
        CASE 8 '                                               Backspace
            IF cursorStep > 0 THEN
                cursorStep = cursorStep - 1
                delete_step cursorStep
            END IF
        CASE 15104: helpOn = NOT helpOn '                      F1
        CASE 9 '                                               Tab
            IF shift THEN
                set_tool tb_tool((tb_index(tool) + TB_TOOLS - 1) MOD TB_TOOLS)
            ELSE
                set_tool tb_tool((tb_index(tool) + 1) MOD TB_TOOLS)
            END IF
        CASE 15360: rename_sound '                             F2
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
            ELSEIF midiBusy THEN
                midi_start midiDevIdx ' try the same port again
            ELSEIF midiDevIdx + 1 >= midiDevCount THEN
                midi_stop
                set_status "MIDI input off"
            ELSE
                midi_start midiDevIdx + 1
            END IF
        CASE 16896 '                                           F8
            IF ask("Delete " + sndName(cur) + "?", "yesno", "question", 0) = 1 THEN delete_sound
        CASE 17152: set_octave octave - 1 '                    F9
        CASE 17408: set_octave octave + 1 '                    F10
        CASE 34048: set_note_len noteLen - 1 '                 F11
        CASE 34304: set_note_len noteLen + 1 '                 F12
        CASE 65, 97 '                                          A: audition while drawing
            IF ctrl THEN
                select_all
            ELSE
                drawAudOn = NOT drawAudOn
                IF drawAudOn THEN set_status "Audition ON - you hear what you draw while the button is down" ELSE set_status "Audition OFF - drawing is silent"
            END IF
        CASE 39 '                                              ' (apostrophe)
            linesOn = NOT linesOn
            IF linesOn THEN
                set_status "Grid lines ON - between note rows and every cell (or step, zoomed in)"
            ELSE
                set_status "Grid lines OFF - just beats and bars"
            END IF
        CASE ELSE
            ' tool letters: always with Alt, and plain while the piano is off
            IF NOT ctrl AND (NOT pianoOn OR modAlt) THEN
                SELECT CASE UCASE$(CHR$(k AND 255))
                    CASE "D": set_tool TOOL_DRAW
                    CASE "N": set_tool TOOL_NOTE
                    CASE "E": set_tool TOOL_ERASE
                    CASE "S": set_tool TOOL_SELECT
                    CASE "M": set_tool TOOL_MOVE
                    CASE "L": set_tool TOOL_LINE
                    CASE "W": set_tool TOOL_WAVE
                    CASE "C": sel_cut
                    CASE "1" TO "5", "[", "]"
                        IF tool = TOOL_WAVE THEN wave_key CHR$(k AND 255)
                END SELECT
            END IF
            IF ctrl THEN
                SELECT CASE k
                    CASE 61, 43: set_ui_scale 1 '                   Ctrl+= / Ctrl++
                    CASE 45, 95: set_ui_scale -1 '                  Ctrl+- / Ctrl+_
                    CASE 48, 41: set_ui_scale 0 '                   Ctrl+0
                    CASE 49 TO 52: switch_voice k - 48 '            Ctrl+1-4: voice
                    CASE 53, 37: toggle_all '                       Ctrl+5: G, all voices
                END SELECT
                SELECT CASE ctrl_letter$(k)
                    CASE "Z": undo
                    CASE "Y": redo
                    CASE "L": toggle_loop
                    CASE "J": toggle_poly
                    CASE "T": trim_end
                    CASE "P": ask_priority
                    CASE "N"
                        IF ok_to_lose("New bank") THEN new_bank: set_status "New bank"
                    CASE "O"
                        IF ok_to_lose("Open") THEN open_dialog
                    CASE "S"
                        IF shift THEN save_as ELSE save_now
                    CASE "E": export_wav
                    CASE "K": toggle_keys_mode shift
                    CASE "R": record_now
                    CASE "F"
                        followOn = NOT followOn
                        IF followOn THEN set_status "Follow ON - the view pages along with the playhead" ELSE set_status "Follow OFF"
                    CASE "M"
                        IF shift THEN
                            ask_metro_vol
                        ELSE
                            metroMode = (metroMode + 1) MOD 3
                            SELECT CASE metroMode
                                CASE 0: set_status "Metronome OFF"
                                CASE 1: set_status "Metronome while recording (Ctrl+Shift+M volume)"
                                CASE 2: set_status "Metronome while recording and playing back (Ctrl+Shift+M volume)"
                            END SELECT
                        END IF
                    CASE "U"
                        countIn = (countIn + 1) MOD 3
                        IF countIn THEN set_status "Count-in" + STR$(countIn) + " bar(s) before Ctrl+R recording" ELSE set_status "No count-in: Ctrl+R records at once"
                    CASE "Q"
                        quantOn = NOT quantOn
                        IF quantOn THEN
                            set_status "Quantize ON - LIVE notes snap to the grid as you play" + MID$(" (turn the grid on: Ctrl+G)", 1, -28 * (gridDiv = 0))
                        ELSE
                            set_status "Quantize OFF - LIVE notes recorded as played"
                        END IF
                    CASE "X": sel_cut
                    CASE "C": sel_copy
                    CASE "V": sel_paste
                    CASE "A": select_all

                    CASE "H"
                        holdMode = (holdMode + 1) MOD 3
                        set_status "Instrument plays " + hold_name + " - " + hold_help
                    CASE "G"
                        IF shift THEN cycle_grid -1 ELSE cycle_grid 1
                    CASE "B": ask_bpm
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


'-----------------------------------------------------------------------------
' Native dialogs (QB64-PE: _MESSAGEBOX, _INPUTBOX$, _OPENFILEDIALOG$,
' _SAVEFILEDIALOG$ - zenity / kdialog on Linux)
'-----------------------------------------------------------------------------

''
' A modal dialog swallows keys and button releases, so afterwards forget the
' modifier and mouse state and drop any keys that piled up.
'
SUB after_dialog
    modCtrl = 0: modShift = 0: modAlt = 0
    drawing = 0
    _KEYCLEAR
END SUB


FUNCTION ask& (msg AS STRING, kind AS STRING, icon AS STRING, defaultBtn AS LONG)
    ask = _MESSAGEBOX("PCSEDIT", msg, kind, icon, defaultBtn)
    after_dialog
END FUNCTION


''
' Before something that throws the bank away (quit, new, open): with
' unsaved changes ask Save / Don't save / Cancel. TRUE = go ahead.
'
FUNCTION ok_to_lose% (what AS STRING)
    DIM nm AS STRING
    IF NOT dirty THEN ok_to_lose = -1: EXIT FUNCTION
    nm = "this bank"
    IF LEN(savePath) THEN nm = PCSPK_FilePart(savePath) ELSE IF LEN(openedPath) THEN nm = PCSPK_FilePart(openedPath)
    SELECT CASE ask(what + ": save the changes to " + nm + " first?", "yesnocancel", "warning", 1)
        CASE 1 '                                       Yes: save, then go on if it saved
            save_now
            ok_to_lose = NOT dirty
        CASE 2 '                                       No: throw the changes away
            ok_to_lose = -1
    END SELECT '                                       Cancel (0): stay
END FUNCTION


''
' Ctrl+S: save to the file saved before, or ask where (Save As).
'
SUB save_now
    IF LEN(savePath) THEN save_bank savePath ELSE save_as
END SUB


SUB save_as
    DIM f AS STRING
    f = _SAVEFILEDIALOG$("Save IFS sound bank", suggest_save, "*.snd|*.SND", "IFS sound bank (Duke Nukem / Keen format)")
    after_dialog
    IF f = "" THEN set_status "Save cancelled": EXIT SUB
    IF INSTR(PCSPK_FilePart(f), ".") = 0 THEN f = f + ".SND" ' the dialog doesn't add one
    save_bank f
END SUB


SUB open_dialog
    DIM f AS STRING
    f = _OPENFILEDIALOG$("Open a PC speaker sound bank", default_dir, OPEN_FILTER, "Sound banks DN1PLAY can play")
    after_dialog
    IF LEN(f) THEN open_bank f
END SUB


SUB rename_sound
    DIM t AS STRING
    t = _TRIM$(_INPUTBOX$("Rename sound", "Name (up to 12 characters):", sndName(cur)))
    after_dialog
    IF LEN(t) THEN sndName(cur) = LEFT$(t, 12): dirty = -1
END SUB


SUB ask_priority
    DIM t AS STRING, v AS LONG
    t = _INPUTBOX$("Priority", "Priority of " + sndName(cur) + " (0-255, higher wins in the game):", LTRIM$(STR$(sndPri(cur))))
    after_dialog
    IF t = "" THEN EXIT SUB
    v = VAL(t)
    IF v < 0 THEN v = 0
    IF v > 255 THEN v = 255
    sndPri(cur) = v
    dirty = -1
END SUB


SUB ask_metro_vol
    DIM t AS STRING
    t = _INPUTBOX$("Metronome", "Click volume (0-100):", LTRIM$(STR$(CLNG(metroVol * 100))))
    after_dialog
    IF t = "" THEN EXIT SUB
    metroVol = VAL(t) / 100
    IF metroVol < 0 THEN metroVol = 0
    IF metroVol > 1 THEN metroVol = 1
    set_status "Metronome volume" + STR$(CLNG(metroVol * 100)) + "%"
    IF clickHi > 0 THEN _SNDVOL clickHi, metroVol: _SNDPLAY clickHi
END SUB


SUB ask_bpm
    DIM t AS STRING
    t = _INPUTBOX$("Tempo", "Tempo for the grid, in BPM (20-400):", LTRIM$(STR$(bpm)))
    after_dialog
    IF t = "" THEN EXIT SUB
    IF VAL(t) >= 20 AND VAL(t) <= 400 THEN
        bpm = VAL(t)
        set_status "Tempo" + STR$(bpm) + " BPM" + grid_info
    ELSE
        set_status "Tempo has to be between 20 and 400 BPM"
    END IF
END SUB


''
' Ctrl+K: plain notes <-> the selected sound as an instrument. With a
' different sound selected than the instrument, it becomes the instrument.
'
SUB toggle_keys_mode (lockIt AS INTEGER)
    voiceOn = 0
    stop_recording
    ' Ctrl+Shift+K: lock / unlock the instrument to the sound it is now
    IF lockIt THEN
        IF keysMode <> KEYS_SOUND THEN set_status "Ctrl+K first - then Ctrl+Shift+K locks the instrument": EXIT SUB
        instLock = NOT instLock
        IF instLock THEN
            set_status "Instrument locked to " + sndName(instIdx) + " - pick other sounds freely (Ctrl+Shift+K unlocks)"
        ELSE
            instIdx = cur
            set_status "Instrument follows the selected sound again: " + sndName(cur)
        END IF
        EXIT SUB
    END IF
    IF keysMode = KEYS_SOUND THEN
        keysMode = KEYS_NOTES
        set_status "Keys play plain NOTES"
        EXIT SUB
    END IF
    IF snd_len(cur) = 0 THEN set_status "This sound is empty - draw something first, then Ctrl+K": EXIT SUB
    keysMode = KEYS_SOUND
    instIdx = cur
    instLock = 0
    set_status "Keys play " + sndName(cur) + " (C4 = as drawn), " + hold_name + " - it follows the sound you pick (Ctrl+Shift+K locks)"
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
    DIM divs(0 TO 8) AS LONG
    divs(0) = 0: divs(1) = 4: divs(2) = 8: divs(3) = 16: divs(4) = 32: divs(5) = 64: divs(6) = 128: divs(7) = 12: divs(8) = 24
    FOR i = 0 TO 8
        IF divs(i) = gridDiv THEN n = i
    NEXT
    n = (n + dirn + 9) MOD 9
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


SUB set_zoom (z AS DOUBLE)
    set_zoom_at z, CANVAS_X + CANVAS_W \ 2
END SUB


''
' Zoom keeping the step under screen x (the mouse) where it is.
'
''
' The zoom ladder: whole pixels per step down to 1, then whole steps per
' pixel (1/2 ... 1/10), so steps never straddle pixels unevenly. 1/10 fits
' the longest sound (64 s) on screen; 1/4 fits 16 bars at 120 BPM.
'
FUNCTION zoom_step# (dirn AS LONG)
    DIM lv AS STRING, i AS LONG, n AS LONG, z(0 TO 30) AS DOUBLE, best AS LONG, p AS LONG, q AS LONG
    lv = "64 48 32 24 16 12 10 8 6 5 4 3 2 1 -2 -3 -4 -5 -6 -8 -10 "
    p = 1
    DO
        q = INSTR(p, lv, " ")
        IF q = 0 THEN EXIT DO
        z(n) = VAL(MID$(lv, p, q - p))
        IF z(n) < 0 THEN z(n) = 1 / -z(n)
        n = n + 1
        p = q + 1
    LOOP
    ' the level nearest the zoom now, then one along (in = bigger)
    best = 0
    FOR i = 1 TO n - 1
        IF ABS(LOG(z(i) / zoom)) < ABS(LOG(z(best) / zoom)) THEN best = i
    NEXT
    best = best - dirn
    IF best < 0 THEN best = 0
    IF best > n - 1 THEN best = n - 1
    zoom_step = z(best)
END FUNCTION


FUNCTION zoom_name$
    IF zoom >= 1 THEN zoom_name = LTRIM$(STR$(CLNG(zoom))) ELSE zoom_name = "1/" + LTRIM$(STR$(CLNG(1 / zoom)))
END FUNCTION


SUB set_zoom_at (z AS DOUBLE, x AS LONG)
    DIM px AS LONG, at AS DOUBLE
    px = x - CANVAS_X
    IF px < 0 OR px >= CANVAS_W THEN px = CANVAS_W \ 2
    at = scrollX + px / zoom ' the step under x, before zooming
    zoom = z
    IF zoom < 0.1 THEN zoom = 0.1 ' 1/10: about 10,000 steps (71 s) on screen
    IF zoom > 64 THEN zoom = 64 ' 64 px a step: about 15 steps (0.1 s) on screen
    scroll_to CLNG(at - px / zoom)
END SUB


SUB scroll_to (s AS LONG)
    scrollX = s
    IF scrollX > MAX_STEPS - INT(CANVAS_W / zoom) THEN scrollX = MAX_STEPS - INT(CANVAS_W / zoom)
    IF scrollX < 0 THEN scrollX = 0
END SUB


''
' Scroll so that step s is on screen.
'
SUB follow (s AS LONG)
    DIM vis AS LONG
    vis = INT(CANVAS_W / zoom)
    IF s < scrollX THEN scroll_to s - vis \ 4
    IF s >= scrollX + vis THEN scroll_to s - vis \ 4
END SUB


''
' PageUp / PageDown: with the NOTE tool, the previous / next bar line;
' with the other tools, the previous / next dot - a step where a new
' pitch starts.
'
SUB jump_mark (dirn AS LONG)
    DIM s AS LONG, barLen AS DOUBLE, b AS LONG, n AS LONG
    IF tool = TOOL_NOTE THEN
        barLen = BEATS_PER_BAR * 60 * rateHz / bpm
        b = INT(cursorStep / barLen + 0.000001)
        IF dirn > 0 THEN
            b = b + 1
        ELSEIF INT(b * barLen + 0.5) >= cursorStep THEN
            b = b - 1 ' already on a bar line: go to the one before
        END IF
        IF b < 0 THEN b = 0
        move_cursor INT(b * barLen + 0.5)
        set_status "Bar" + STR$(b + 1)
        EXIT SUB
    END IF

    n = steps_of(cur)
    s = cursorStep
    DO
        s = s + dirn
        IF s <= 0 THEN s = 0: EXIT DO
        IF s >= n THEN s = n: EXIT DO
        IF get_step(cur, s) <> 0 AND get_step(cur, s) <> get_step(cur, s - 1) THEN EXIT DO
    LOOP
    move_cursor s
END SUB


SUB follow_page (s AS LONG)
    DIM vis AS LONG
    vis = INT(CANVAS_W / zoom)
    IF s < scrollX OR s >= scrollX + vis - vis \ 50 THEN scroll_to s - vis \ 50
END SUB


SUB move_cursor (s AS LONG)
    cursorStep = s
    IF cursorStep < 0 THEN cursorStep = 0
    IF cursorStep > MAX_STEPS THEN cursorStep = MAX_STEPS
    follow cursorStep
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
    DIM i AS LONG, at AS LONG, k AS LONG, src AS LONG
    IF sndCount >= MAX_SOUNDS THEN set_status "The bank is full (" + LTRIM$(STR$(MAX_SOUNDS)) + " sounds)": EXIT SUB
    at = cur + 1
    IF at < 1 THEN at = 1
    IF at > sndCount + 1 THEN at = sndCount + 1
    FOR i = sndCount TO at STEP -1
        sndName(i + 1) = sndName(i): sndPri(i + 1) = sndPri(i): sndData(i + 1) = sndData(i)
        sndAct(i + 1) = sndAct(i)
        FOR k = 1 TO VOICES: sndV(i + 1, k) = sndV(i, k): NEXT
    NEXT
    sndCount = sndCount + 1
    IF nam = "" THEN
        sndName(at) = "SOUND" + LTRIM$(STR$(sndCount))
        sndPri(at) = 10
        sndData(at) = ""
        sndAct(at) = 1
        FOR k = 1 TO VOICES: sndV(at, k) = "": NEXT
    ELSE
        ' a copy (F4): all its voices come along
        src = cur
        IF src >= at THEN src = src + 1
        sndName(at) = LEFT$(nam, 10) + "_2"
        sndPri(at) = sndPri(src)
        sndData(at) = dat
        sndAct(at) = sndAct(src)
        FOR k = 1 TO VOICES: sndV(at, k) = sndV(src, k): NEXT
    END IF
    fix_undo_after_insert at
    IF at <= instIdx THEN instIdx = instIdx + 1
    select_sound at
    dirty = -1
END SUB


SUB delete_sound
    DIM i AS LONG, k AS LONG
    stop_playing
    stop_recording
    IF sndCount <= 1 THEN
        sndData(1) = ""
        sndAct(1) = 1
        FOR k = 1 TO VOICES: sndV(1, k) = "": NEXT
        set_status "Cleared the only sound"
    ELSE
        set_status "Deleted " + sndName(cur)
        IF cur = instIdx THEN keysMode = KEYS_NOTES: voiceOn = 0
        IF cur < instIdx THEN instIdx = instIdx - 1
        FOR i = cur TO sndCount - 1
            sndName(i) = sndName(i + 1): sndPri(i) = sndPri(i + 1): sndData(i) = sndData(i + 1)
            sndAct(i) = sndAct(i + 1)
            FOR k = 1 TO VOICES: sndV(i, k) = sndV(i + 1, k): NEXT
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


''
' A sound picked by you (keys, list, wheel). In SOUND keys mode the
' instrument follows it - unless it is locked (Ctrl+Shift+K, or a recording
' into another sound locked it).
'
SUB user_select (i AS LONG)
    select_sound i
    IF keysMode = KEYS_SOUND AND NOT instLock AND instIdx <> cur THEN
        IF snd_len(cur) > 0 THEN
            instIdx = cur
            set_status "Keys play " + sndName(cur) + " (C4 = as drawn)"
        ELSE
            set_status sndName(cur) + " is empty - the keys still play " + sndName(instIdx)
        END IF
    END IF
END SUB


SUB select_sound (i AS LONG)
    IF playing THEN stop_playing
    stop_recording
    selOn = 0
    wave_done
    cur = i
    IF cur > sndCount THEN cur = sndCount
    IF cur < 1 THEN cur = 1
    IF cur - 1 < listTop THEN listTop = cur - 1
    IF cur - 1 >= listTop + LIST_ROWS THEN listTop = cur - LIST_ROWS
    IF cursorStep > snd_len(cur) THEN cursorStep = snd_len(cur)
    haveAnchor = 0
    follow cursorStep
END SUB


' (With G these work on every voice, so chords stay lined up.)

SUB insert_step
    DIM p AS LONG, k AS LONG, home AS LONG
    IF snd_len(cur) >= MAX_STEPS THEN EXIT SUB
    push_undo
    set_vmask
    home = sndAct(cur)
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            vswap k
            IF k = home AND cursorStep > steps_of(cur) THEN set_step cur, cursorStep - 1, 0
            IF cursorStep <= steps_of(cur) THEN
                p = cursorStep * 2
                sndData(cur) = LEFT$(sndData(cur), p) + STRING$(2, 0) + MID$(sndData(cur), p + 1)
            END IF
        END IF
    NEXT
    vswap home
    dirty = -1
END SUB


SUB delete_step (s AS LONG)
    DIM k AS LONG, home AS LONG
    IF s < 0 OR s >= snd_len(cur) THEN EXIT SUB
    push_undo
    set_vmask
    home = sndAct(cur)
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            vswap k
            IF s < steps_of(cur) THEN sndData(cur) = LEFT$(sndData(cur), s * 2) + MID$(sndData(cur), s * 2 + 3)
        END IF
    NEXT
    vswap home
    dirty = -1
END SUB


SUB transpose (semis AS LONG)
    DIM s AS LONG, v AS LONG, f AS DOUBLE, k AS LONG
    IF snd_len(cur) = 0 THEN EXIT SUB
    push_undo
    set_vmask
    f = 2 ^ (-semis / 12)
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            FOR s = 0 TO LEN(voice_data(cur, k)) \ 2 - 1
                v = voice_step(cur, k, s)
                IF v THEN
                    v = CLNG(v * f)
                    IF v < 1 THEN v = 1
                    set_voice_step cur, k, s, v
                END IF
            NEXT
        END IF
    NEXT
    set_status "Transposed" + STR$(semis) + " semitone(s)"
END SUB


SUB trim_end
    DIM n AS LONG, k AS LONG, home AS LONG, was AS STRING
    was = pack_voices(cur)
    push_undo
    set_vmask
    home = sndAct(cur)
    FOR k = 1 TO VOICES
        IF vMask(k) THEN
            vswap k
            n = steps_of(cur)
            DO WHILE n > 0
                IF get_step(cur, n - 1) THEN EXIT DO
                n = n - 1
            LOOP
            sndData(cur) = LEFT$(sndData(cur), n * 2)
        END IF
    NEXT
    vswap home
    IF pack_voices(cur) = was THEN
        IF undoN > 0 THEN undoN = undoN - 1
        set_status "No silence at the end": EXIT SUB
    END IF
    IF cursorStep > snd_len(cur) THEN cursorStep = snd_len(cur)
    dirty = -1
    set_status "Trimmed to" + STR$(snd_len(cur)) + " steps"
END SUB


'--- undo / redo ----------------------------------------------------------------

''
' A sound's voices as one string (for undo): the edited voice, then each
' voice's length and data.
'
FUNCTION pack_voices$ (i AS LONG)
    DIM k AS LONG, r AS STRING
    r = MKI$(sndAct(i))
    FOR k = 1 TO VOICES
        r = r + MKL$(LEN(voice_data(i, k))) + voice_data(i, k)
    NEXT
    pack_voices = r
END FUNCTION


SUB unpack_voices (i AS LONG, p AS STRING)
    DIM k AS LONG, n AS LONG, o AS LONG
    sndAct(i) = CVI(LEFT$(p, 2))
    o = 3
    FOR k = 1 TO VOICES
        n = CVL(MID$(p, o, 4))
        sndV(i, k) = MID$(p, o + 4, n)
        o = o + 4 + n
    NEXT
    sndData(i) = sndV(i, sndAct(i))
    sndV(i, sndAct(i)) = ""
END SUB


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
    undoData(undoN) = pack_voices(cur)
    redoN = 0
END SUB


SUB undo
    DIM s AS LONG
    IF undoN = 0 THEN set_status "Nothing to undo": EXIT SUB
    stop_playing
    drawing = 0
    waveLive = 0
    s = undoSnd(undoN)
    IF redoN < UNDO_MAX THEN redoN = redoN + 1
    redoSnd(redoN) = s: redoData(redoN) = pack_voices(s)
    unpack_voices s, undoData(undoN)
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
    undoSnd(undoN) = s: undoData(undoN) = pack_voices(s)
    unpack_voices s, redoData(redoN)
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
    DIM i AS LONG, n AS LONG, ok AS INTEGER, full AS STRING, d AS STRING, v AS LONG, k AS LONG

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
        sndAct(sndCount) = 1
        FOR k = 1 TO VOICES: sndV(sndCount, k) = "": NEXT
    NEXT
    attach_voices
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
    DIM ff AS LONG, nm AS STRING, entries AS LONG, d AS STRING, s AS LONG, v AS LONG, k AS LONG

    ' A sound with several voices is saved as its ARP mix (what any IFS
    ' player can play) plus one NAME~k entry per voice, so PCSEDIT can take
    ' them apart again when the bank is opened.
    entries = 0
    FOR i = 1 TO sndCount
        entries = entries + 1
        IF voices_used(i) > 1 THEN entries = entries + voices_used(i)
    NEXT
    ofs = 16 + entries * 16
    FOR i = 1 TO sndCount
        IF voices_used(i) > 1 THEN
            d = SPACE$(snd_len(i) * 2)
            FOR s = 0 TO snd_len(i) - 1
                v = mix_step(i, s)
                MID$(d, s * 2 + 1, 2) = CHR$(v AND 255) + CHR$(v \ 256)
            NEXT
        ELSE
            d = sndData(i)
            FOR k = 1 TO VOICES ' a lone voice that isn't the one being edited
                IF LEN(voice_data(i, k)) THEN d = voice_data(i, k)
            NEXT
        END IF
        nm = LEFT$(sndName(i) + STRING$(12, 0), 12)
        tbl = tbl + u16$(ofs + LEN(body)) + CHR$(sndPri(i) AND 255) + CHR$(8) + nm
        body = body + d + CHR$(255) + CHR$(255)
        IF voices_used(i) > 1 THEN
            FOR k = 1 TO VOICES
                IF LEN(voice_data(i, k)) THEN
                    nm = LEFT$(LEFT$(sndName(i), 10) + "~" + LTRIM$(STR$(k)) + STRING$(12, 0), 12)
                    tbl = tbl + u16$(ofs + LEN(body)) + CHR$(sndPri(i) AND 255) + CHR$(8) + nm
                    body = body + voice_data(i, k) + CHR$(255) + CHR$(255)
                END IF
            NEXT
        END IF
    NEXT
    total = ofs + LEN(body)
    IF total > 65535 THEN
        set_status "Too big for an IFS bank (" + LTRIM$(STR$(total)) + " bytes, the limit is 65535) - shorten or split it"
        EXIT SUB
    END IF
    hdr = "SND" + CHR$(0) + u16$(total) + u16$(entries) + u16$(0) + STRING$(6, 0)

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


''
' After opening: NAME~1 ... NAME~4 entries become the voices of the sound
' NAME before them (saved by PCSEDIT for multi-voice sounds).
'
SUB attach_voices
    DIM i AS LONG, j AS LONG, bnm AS STRING, k AS LONG, t AS LONG, nm AS STRING, p AS LONG
    i = 1
    DO WHILE i <= sndCount
        nm = sndName(i)
        p = INSTR(nm, "~")
        k = 0
        IF p > 1 AND p = LEN(nm) - 1 THEN k = VAL(MID$(nm, p + 1))
        IF k >= 1 AND k <= VOICES THEN
            bnm = LEFT$(nm, p - 1)
            t = 0
            FOR j = i - 1 TO 1 STEP -1 ' the sound it belongs to
                IF LEFT$(sndName(j), 10) = bnm AND INSTR(sndName(j), "~") = 0 THEN t = j: EXIT FOR
            NEXT
            IF t THEN
                IF k = 1 THEN sndData(t) = sndData(i) ELSE sndV(t, k) = sndData(i)
                ' drop the entry
                FOR j = i TO sndCount - 1
                    sndName(j) = sndName(j + 1): sndPri(j) = sndPri(j + 1): sndData(j) = sndData(j + 1)
                    sndAct(j) = sndAct(j + 1)
                    FOR p = 1 TO VOICES: sndV(j, p) = sndV(j + 1, p): NEXT
                NEXT
                sndCount = sndCount - 1
                i = i - 1
            END IF
        END IF
        i = i + 1
    LOOP
END SUB


FUNCTION u16$ (v AS LONG)
    u16 = CHR$(v AND 255) + CHR$((v \ 256) AND 255)
END FUNCTION


''
' The folder PCSEDIT was started from, ending with a separator.
'
FUNCTION start_dir$
    DIM d AS STRING
    d = _STARTDIR$
    IF RIGHT$(d, 1) <> "/" AND RIGHT$(d, 1) <> "\" THEN d = d + "/"
    start_dir = d
END FUNCTION


FUNCTION default_dir$
    DIM d AS STRING
    d = start_dir
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
    DIM d(1 TO 8) AS LONG, n AS LONG
    IF snd_len(cur) = 0 THEN set_status "Nothing to export": EXIT SUB
    stop_playing
    errNum = 0
    IF NOT _DIREXISTS(start_dir + "EXPORT") THEN MKDIR start_dir + "EXPORT" ' the dialog starts there
    bankName = "NEW"
    IF LEN(savePath) THEN
        bankName = PCSPK_FilePart(savePath)
    ELSEIF LEN(openedPath) THEN
        bankName = PCSPK_FilePart(openedPath)
    END IF
    outName = _SAVEFILEDIALOG$("Export " + sndName(cur) + " as .wav", start_dir + "EXPORT/" + safe_name(bankName) + "_" + safe_name(sndName(cur)) + ".wav", "*.wav|*.WAV", "WAV audio")
    after_dialog
    IF outName = "" THEN set_status "Export cancelled": EXIT SUB
    IF INSTR(PCSPK_FilePart(outName), ".") = 0 THEN outName = outName + ".wav"
    PCSPK_CaptureBegin
    lastV = -1
    FOR s = 1 TO 8: pwmPh(s) = 0: NEXT
    FOR s = 0 TO snd_len(cur) - 1
        IF polyMode = POLY_PWM AND voices_used(cur) > 1 THEN
            n = step_divs(cur, s, d())
            render_pwm_tick d(), n
            lastV = -1
        ELSE
            v = mix_step(cur, s)
            IF v <> lastV THEN PCSPK_SetDivisor v: lastV = v ' only on a change, see speaker
            PCSPK_AdvanceClocks PCSPK_PIT_HZ / rateHz
        END IF
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
    draw_scope

    ' status line
    IF LEN(statusMsg) THEN
        IF TIMER(0.001) < statusUntil AND TIMER(0.001) > statusUntil - 10 THEN
            COLOR _RGB32(140, 230, 140)
            _PRINTSTRING (8, SCR_H - 20), statusMsg
        ELSE
            statusMsg = ""
        END IF
    END IF
    IF LEN(statusMsg) = 0 THEN
        COLOR _RGB32(100, 115, 140)
        _PRINTSTRING (8, SCR_H - 20), tool_help + "   right drag erases   Space play"
    END IF

    IF helpOn THEN draw_help
END SUB


''
' The toolbar: the five tools (the active one lit up) and cut / copy / paste.
'
SUB draw_toolbar
    DIM i AS LONG, x AS LONG, lbl AS STRING, active AS INTEGER
    FOR i = 0 TO TB_BUTTONS - 1
        x = RULER_X + i * TB_W
        SELECT CASE i
            CASE 0 TO TB_TOOLS - 1: lbl = tool_name(tb_tool(i)): active = (tool = tb_tool(i))
            CASE TB_TOOLS: lbl = "C)ut": active = 0
            CASE TB_TOOLS + 1: lbl = "Copy": active = 0
            CASE TB_TOOLS + 2: lbl = "Paste": active = 0
            CASE TB_TOOLS + 3: lbl = "Loop": active = loopOn
        END SELECT
        IF active THEN
            LINE (x, TB_Y)-(x + TB_W - 4, TB_Y + TB_H - 1), _RGB32(255, 200, 60), BF
            COLOR _RGB32(20, 20, 20)
        ELSEIF i >= TB_TOOLS AND i < TB_TOOLS + 3 THEN
            LINE (x, TB_Y)-(x + TB_W - 4, TB_Y + TB_H - 1), _RGB32(34, 40, 56), BF
            LINE (x, TB_Y)-(x + TB_W - 4, TB_Y + TB_H - 1), _RGB32(70, 80, 100), B
            IF (i = TB_TOOLS + 2 AND clipN = 0) OR (i < TB_TOOLS + 2 AND NOT selOn) THEN COLOR _RGB32(90, 100, 120) ELSE COLOR _RGB32(210, 220, 235)
        ELSE
            LINE (x, TB_Y)-(x + TB_W - 4, TB_Y + TB_H - 1), _RGB32(40, 48, 66), BF
            COLOR _RGB32(210, 220, 235)
        END IF
        _PRINTSTRING (x + (TB_W - 4 - 8 * LEN(lbl)) \ 2, TB_Y + 2), lbl
    NEXT
END SUB


SUB draw_info
    DIM s AS STRING, v AS LONG, x AS LONG
    x = RULER_X
    COLOR _RGB32(255, 200, 60)
    _PRINTSTRING (LIST_X, 36), sndName(cur)
    COLOR _RGB32(190, 200, 215)
    _PRINTSTRING (LIST_X, 52), "Priority" + STR$(sndPri(cur))
    _PRINTSTRING (LIST_X, 68), LTRIM$(STR$(snd_len(cur))) + " steps, " + fmt2(snd_len(cur) / rateHz) + " s"
    IF keysMode = KEYS_SOUND THEN
        COLOR _RGB32(120, 230, 160)
        s = "Keys: " + CHR$(14) + " " + LEFT$(sndName(instIdx), 8)
        IF instLock THEN s = s + " LOCK" ELSE s = s + " " + LEFT$(hold_name, 4)
        _PRINTSTRING (LIST_X, 84), s
    ELSE
        COLOR _RGB32(150, 160, 180)
        _PRINTSTRING (LIST_X, 84), "Keys: notes (Ctrl+K)"
    END IF
    COLOR _RGB32(190, 200, 215)

    draw_toolbar
    COLOR _RGB32(190, 200, 215) ' the toolbar leaves its last button's colour set

    s = "Cursor" + STR$(cursorStep) + " (" + fmt2(cursorStep / rateHz) + " s)"
    IF gridDiv THEN s = s + "  bar " + bar_beat(cursorStep)
    IF selOn THEN s = s + "  Sel" + STR$(selS0) + "-" + LTRIM$(STR$(selS1 - 1)) + " " + note_name(selLo) + "-" + note_name(selHi)
    _PRINTSTRING (x, 52), s
    COLOR _RGB32(150, 200, 255)
    IF gridDiv THEN
        _PRINTSTRING (RULER_X + TB_BUTTONS * TB_W + 12, TB_Y + 3), "Grid " + grid_name + " @" + STR$(bpm) + " BPM" + MID$(" #", 1 - linesOn, 1)
    ELSE
        _PRINTSTRING (RULER_X + TB_BUTTONS * TB_W + 12, TB_Y + 3), "Grid off (Ctrl+G)" + MID$(" #", 1 - linesOn, 1)
    END IF
    COLOR _RGB32(190, 200, 215)
    IF mouseIn THEN
        v = get_step(cur, mouseStep)
        s = "Mouse" + STR$(mouseStep) + " " + note_name(mouseNote)
        s = s + " " + LTRIM$(STR$(CLNG(note_hz(mouseNote)))) + "Hz"
        IF v THEN s = s + "  here " + note_name(div_note(v)) + " (div" + STR$(v) + ")"
        _PRINTSTRING (x + 520, 52), s
    END IF

    ' mode line
    s = ""
    SELECT CASE recMode
        CASE REC_OFF: s = "REC off"
        CASE REC_STEP: s = "REC STEP"
        CASE REC_LIVE
            IF recording AND recPos < recFrom THEN
                s = "REC LIVE count-in"
            ELSEIF recording THEN
                s = "REC LIVE *rec*"
            ELSE
                s = "REC LIVE (waiting)"
            END IF
    END SELECT
    IF recMode <> REC_OFF THEN
        COLOR _RGB32(255, 90, 80)
    ELSE
        COLOR _RGB32(150, 160, 180)
    END IF
    _PRINTSTRING (x, 76), s
    COLOR _RGB32(150, 160, 180)
    IF pianoOn THEN s = "Caps:piano" ELSE s = "Caps:tools"
    s = s + "  Aud " + on_off(drawAudOn) + "  Snap " + on_off(snapOn) + "  Oct" + LTRIM$(STR$(octave)) + "  Len" + LTRIM$(STR$(noteLen)) + "  Loop " + on_off(loopOn) + "  Z" + zoom_name
    s = s + "  Met " + MID$("offRECR+P", metroMode * 3 + 1, 3) + "  In" + STR$(countIn) + "  Q " + on_off(quantOn) + "  Fol " + on_off(followOn)
    s = s + "  MIDI: "
    IF midiDevIdx >= 0 AND midiBusy THEN
        s = s + "BUSY (F7)"
    ELSEIF midiDevIdx >= 0 THEN
        s = s + LEFT$(midiDevName(midiDevIdx), 12)
    ELSE
        s = s + "off"
    END IF
    _PRINTSTRING (x + 176, 76), s
    IF heldNote >= 0 OR auditionNote >= 0 THEN
        IF heldNote >= 0 THEN v = heldNote ELSE v = auditionNote
        s = " KEY " + note_name(v) + "  " + LTRIM$(STR$(CLNG(note_hz(v)))) + " Hz  div" + STR$(note_div(v)) + " "
        LINE (SCR_W - 8 * LEN(s) - 8, 2)-(SCR_W - 4, 21), _RGB32(255, 200, 60), BF
        COLOR _RGB32(20, 20, 20)
        _PRINTSTRING (SCR_W - 8 * LEN(s) - 6, 4), s
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
    draw_voice_chips
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
        s = RIGHT$("  " + LTRIM$(STR$(n)), 3) + " " + LEFT$(sndName(n) + SPACE$(12), 12) + RIGHT$(SPACE$(6) + STR$(snd_len(n)), 6)
        IF keysMode = KEYS_SOUND AND n = instIdx THEN s = s + " " + CHR$(14) ' the instrument
        IF voices_used(n) > 1 THEN s = s + " " + LTRIM$(STR$(voices_used(n))) + "v"
        _PRINTSTRING (LIST_X, y), s
    NEXT
    IF sndCount > LIST_ROWS THEN
        LINE (LIST_X + LIST_W + 4, LIST_Y)-(LIST_X + LIST_W + 7, LIST_Y + LIST_ROWS * ROW_H), _RGB32(40, 48, 64), BF
        y = LIST_Y + (listTop * LIST_ROWS * ROW_H) \ sndCount
        LINE (LIST_X + LIST_W + 4, y)-(LIST_X + LIST_W + 7, y + (LIST_ROWS * LIST_ROWS * ROW_H) \ sndCount), _RGB32(120, 140, 180), BF
    END IF
END SUB


''
' "Voice 1 2 3 4 G  ARP" above the sound list: the voice being edited, which
' voices have notes, and the mode. All clickable (see voice_chip_hit).
'
SUB draw_voice_chips
    DIM k AS LONG, x AS LONG, y AS LONG, c AS _UNSIGNED LONG
    y = LIST_Y - 40
    COLOR _RGB32(120, 140, 170)
    _PRINTSTRING (LIST_X, y), "Voice"
    FOR k = 1 TO VOICES
        x = LIST_X + 48 + (k - 1) * 22
        c = voice_col(k)
        IF k = sndAct(cur) OR (allVoices AND LEN(voice_data(cur, k)) > 0) THEN
            LINE (x - 3, y - 2)-(x + 12, y + 15), c, BF
            IF k = sndAct(cur) THEN LINE (x - 3, y + 15)-(x + 12, y + 15), _RGB32(255, 255, 255)
            COLOR _RGB32(0, 0, 0)
        ELSE
            LINE (x - 3, y - 2)-(x + 12, y + 15), c, B
            IF LEN(voice_data(cur, k)) THEN COLOR c ELSE COLOR _RGB32(90, 100, 120)
        END IF
        _PRINTSTRING (x + 1, y), LTRIM$(STR$(k))
    NEXT
    x = LIST_X + 48 + VOICES * 22 ' G: all voices
    IF allVoices THEN
        LINE (x - 3, y - 2)-(x + 12, y + 15), _RGB32(235, 235, 235), BF
        COLOR _RGB32(0, 0, 0)
    ELSE
        LINE (x - 3, y - 2)-(x + 12, y + 15), _RGB32(150, 150, 160), B
        COLOR _RGB32(190, 190, 200)
    END IF
    _PRINTSTRING (x + 1, y), "G"
    x = LIST_X + 48 + (VOICES + 1) * 22 + 6
    LINE (x - 3, y - 2)-(x + 28, y + 15), _RGB32(120, 140, 180), B
    IF polyMode = POLY_PWM THEN COLOR _RGB32(120, 230, 255) ELSE COLOR _RGB32(255, 200, 60)
    _PRINTSTRING (x + 1, y), poly_name
END SUB


''
' A click at (mx, my) on the voice chips: 1-4 picks a voice, 5 is G (all
' voices), 6 the ARP / PWM mode.
'
FUNCTION voice_chip_hit& (mx AS LONG, my AS LONG)
    DIM k AS LONG, x AS LONG, y AS LONG
    y = LIST_Y - 40
    IF my < y - 2 OR my > y + 15 THEN EXIT FUNCTION
    FOR k = 1 TO VOICES + 1 ' the voices, then G
        x = LIST_X + 48 + (k - 1) * 22
        IF mx >= x - 3 AND mx <= x + 12 THEN voice_chip_hit = k: EXIT FUNCTION
    NEXT
    x = LIST_X + 48 + (VOICES + 1) * 22 + 6
    IF mx >= x - 3 AND mx <= x + 28 THEN voice_chip_hit = 6
END FUNCTION


SUB draw_roll
    DIM nt AS LONG, y AS LONG, x AS LONG, s AS LONG, v AS LONG, vis AS LONG, endX AS LONG
    DIM w AS LONG, nn AS DOUBLE, col AS _UNSIGNED LONG, hp AS LONG, isBlack AS INTEGER, prevY AS LONG, hv AS INTEGER, yb AS LONG
    DIM k AS LONG, vc AS _UNSIGNED LONG

    vis = INT(CANVAS_W / zoom)

    ' piano keys + note rows: white-key rows lighter, black-key rows darker,
    ' like a piano roll, so you can see which row you are on
    FOR nt = NOTE_LO TO NOTE_HI - 1
        y = note_y(nt)
        isBlack = MID$("010100101010", (nt MOD 12) + 1, 1) = "1"
        IF isBlack THEN
            LINE (RULER_X, y - PX_SEMI \ 2)-(RULER_X + 26, y + PX_SEMI \ 2 - 1), _RGB32(30, 30, 36), BF
            LINE (CANVAS_X, y - PX_SEMI \ 2)-(CANVAS_X + CANVAS_W - 1, y + PX_SEMI \ 2 - 1), _RGB32(11, 12, 17), BF
        ELSE
            LINE (RULER_X, y - PX_SEMI \ 2)-(RULER_X + 40, y + PX_SEMI \ 2 - 1), _RGB32(200, 200, 205), BF
            LINE (CANVAS_X, y - PX_SEMI \ 2)-(CANVAS_X + CANVAS_W - 1, y + PX_SEMI \ 2 - 1), _RGB32(26, 30, 42), BF
        END IF
    NEXT

    ' the key being played (keyboard, MIDI or the piano keys): a band across
    ' the grid as well as the lit key
    nt = heldNote
    IF nt < 0 THEN nt = auditionNote
    IF nt >= NOTE_LO AND nt < NOTE_HI THEN
        y = note_y(nt)
        LINE (RULER_X, y - PX_SEMI \ 2)-(RULER_X + 40, y + PX_SEMI \ 2 - 1), _RGB32(255, 170, 40), BF
        LINE (CANVAS_X, y - PX_SEMI \ 2)-(CANVAS_X + CANVAS_W - 1, y + PX_SEMI \ 2 - 1), _RGB32(70, 52, 22), BF
    END IF


    LINE (CANVAS_X, TIME_Y)-(CANVAS_X + CANVAS_W - 1, CANVAS_Y - 2), _RGB32(26, 32, 44), BF

    ' grid lines (' key): one between every note row, and one per step when
    ' the grid is off and there is room (draw_grid does cells when it is on)
    IF linesOn THEN
        FOR nt = NOTE_LO TO NOTE_HI - 1
            y = note_y(nt) - PX_SEMI \ 2 - 1
            IF nt MOD 12 <> 11 THEN LINE (CANVAS_X, y)-(CANVAS_X + CANVAS_W - 1, y), _RGB32(30, 36, 50)
        NEXT
        IF gridDiv = 0 AND zoom >= 4 THEN
            FOR s = scrollX TO scrollX + vis
                x = CANVAS_X + (s - scrollX) * zoom
                LINE (x, CANVAS_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(38, 46, 64)
            NEXT
        END IF
    END IF

    IF gridDiv THEN
        draw_grid vis
    ELSE
        draw_seconds vis
    END IF

    ' the loop region from the time ruler: a band in the ruler, brackets down
    ' the roll (dimmer when Loop is off or a selection is looping instead)
    IF loopSet THEN
        x = CANVAS_X + (loopA - scrollX) * zoom
        endX = CANVAS_X + (loopB - scrollX) * zoom
        IF loopOn AND NOT selOn THEN col = _RGB32(255, 190, 60) ELSE col = _RGB32(120, 100, 60)
        IF endX >= CANVAS_X AND x <= CANVAS_X + CANVAS_W - 1 THEN
            IF x < CANVAS_X THEN x = CANVAS_X
            IF endX > CANVAS_X + CANVAS_W - 1 THEN endX = CANVAS_X + CANVAS_W - 1
            LINE (x, TIME_Y + 12)-(endX, CANVAS_Y - 3), col, BF
            IF x > CANVAS_X THEN LINE (x, TIME_Y)-(x, CANVAS_Y + CANVAS_H - 1), col
            IF endX < CANVAS_X + CANVAS_W - 1 THEN LINE (endX, TIME_Y)-(endX, CANVAS_Y + CANVAS_H - 1), col
        END IF
    END IF

    ' octave markers: a brighter line under every C, labelled at both edges
    ' of the grid (and on the piano keys)
    FOR nt = NOTE_LO TO NOTE_HI - 1
        IF nt MOD 12 = 0 THEN
            y = note_y(nt) + PX_SEMI \ 2 - 1
            LINE (CANVAS_X, y)-(CANVAS_X + CANVAS_W - 1, y), _RGB32(64, 78, 104)
            COLOR _RGB32(150, 160, 180)
            _PRINTSTRING (RULER_X - 26, y - 13), "C" + LTRIM$(STR$(nt \ 12 - 1))
            COLOR _RGB32(90, 104, 132)
            _PRINTSTRING (CANVAS_X + 3, y - 15), "C" + LTRIM$(STR$(nt \ 12 - 1))
            _PRINTSTRING (CANVAS_X + CANVAS_W - 22, y - 15), "C" + LTRIM$(STR$(nt \ 12 - 1))
        END IF
    NEXT

    ' past the end of the sound (over the lines, so it all dims evenly)
    endX = CANVAS_X + (snd_len(cur) - scrollX) * zoom
    IF endX < CANVAS_X THEN endX = CANVAS_X
    IF endX < CANVAS_X + CANVAS_W THEN
        LINE (endX, CANVAS_Y)-(CANVAS_X + CANVAS_W - 1, CANVAS_Y + CANVAS_H - 1), _RGBA32(0, 0, 0, 110), BF
        LINE (endX, CANVAS_Y)-(endX, CANVAS_Y + CANVAS_H - 1), _RGB32(90, 90, 110)
    END IF

    ' the steps
    w = INT(zoom) - 1
    IF w < 1 THEN w = 1

    ' the other voices, dimmed in their own colours, under the edited one
    FOR k = 1 TO VOICES
        IF k <> sndAct(cur) AND LEN(sndV(cur, k)) THEN
            vc = voice_col(k)
            ' dimmed, unless G makes them editable too
            IF NOT allVoices THEN vc = _RGB32(_RED32(vc) * 0.55, _GREEN32(vc) * 0.55, _BLUE32(vc) * 0.55)
            FOR s = scrollX TO scrollX + vis
                v = voice_step(cur, k, s)
                IF v THEN
                    nn = div_note(v)
                    IF nn >= NOTE_HI THEN nn = NOTE_HI - 0.5
                    IF nn < NOTE_LO THEN nn = NOTE_LO
                    y = note_y(nn)
                    x = CANVAS_X + (s - scrollX) * zoom
                    col = vc
                    IF allVoices THEN
                        IF in_sel(s, v) THEN col = _RGB32(90, 220, 255)
                    END IF
                    LINE (x, y - 1)-(x + w, y + 1), col, BF
                END IF
            NEXT
        END IF
    NEXT
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
            IF in_sel(s, v) THEN col = _RGB32(90, 220, 255)
            IF prevY >= 0 AND prevY <> y THEN LINE (x, prevY)-(x, y), _RGB32(120, 80, 20)
            ' full width, as in DN1PLAY: a run of one pitch reads as one solid
            ' bar instead of a row of dots
            LINE (x, y - 1)-(x + w, y + 1), col, BF
            prevY = y
        ELSE
            LINE (x, CANVAS_Y + CANVAS_H - 3)-(x + w - 1, CANVAS_Y + CANVAS_H - 1), _RGB32(70, 80, 100), BF
        END IF
    NEXT

    ' the live waveform's box
    IF waveLive AND tool = TOOL_WAVE THEN
        x = CANVAS_X + (waveS0 - scrollX) * zoom
        endX = CANVAS_X + (waveS1 - scrollX) * zoom
        IF x < CANVAS_X THEN x = CANVAS_X
        IF endX > CANVAS_X + CANVAS_W - 1 THEN endX = CANVAS_X + CANVAS_W - 1
        IF endX > x THEN
            y = clip_y(note_y(wave_max) - PX_SEMI \ 2)
            yb = clip_y(note_y(wave_min) + PX_SEMI \ 2)
            LINE (x, y)-(endX, yb), _RGBA32(255, 120, 220, 30), BF
            LINE (x, y)-(endX, yb), _RGB32(255, 120, 220), B
            hv = wave_edge(mlx, mly)
            IF drawing >= 13 AND drawing <= 16 THEN hv = drawing - 12
            draw_handles x, endX, y, yb, hv, _RGB32(255, 120, 220)
            COLOR _RGB32(255, 160, 230)
            _PRINTSTRING (x + 2, y - 17), wave_name + STR$(waveCycles) + "x duty" + STR$(CLNG(waveDuty * 100)) + "% ph" + STR$(CLNG(wavePhase * 100)) + "%"
        END IF
    END IF

    ' the selection box
    IF selOn THEN
        x = CANVAS_X + (selS0 - scrollX) * zoom
        endX = CANVAS_X + (selS1 - scrollX) * zoom
        IF x < CANVAS_X THEN x = CANVAS_X
        IF endX > CANVAS_X + CANVAS_W - 1 THEN endX = CANVAS_X + CANVAS_W - 1
        IF endX > x THEN
            y = clip_y(note_y(selHi) - PX_SEMI \ 2)
            yb = clip_y(note_y(selLo) + PX_SEMI \ 2)
            LINE (x, y)-(endX, yb), _RGBA32(90, 160, 255, 40), BF
            LINE (x, y)-(endX, yb), _RGB32(90, 180, 255), B
            ' stretch handles (Select / Move tools); the one under the mouse lights up
            IF tool = TOOL_SELECT OR tool = TOOL_MOVE THEN
                hv = sel_edge(mlx, mly)
                IF drawing >= 9 AND drawing <= 12 THEN hv = drawing - 8
                draw_handles x, endX, y, yb, hv, _RGB32(90, 180, 255)
            END IF
        END IF
    END IF

    ' cursor, playhead, record head
    x = CANVAS_X + (cursorStep - scrollX) * zoom
    IF x >= CANVAS_X AND x < CANVAS_X + CANVAS_W THEN
        LINE (x, TIME_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(255, 220, 0)
    END IF
    IF playing THEN
        hp = heard_pos(playPos)
        ' up to the end of what is playing: a loop region may run past the
        ' last note
        IF hp > loop_end AND loop_end >= snd_len(cur) THEN hp = loop_end
        IF hp > snd_len(cur) AND loop_end <= snd_len(cur) THEN hp = snd_len(cur)
        x = CANVAS_X + (hp - scrollX) * zoom
        IF x >= CANVAS_X AND x < CANVAS_X + CANVAS_W THEN LINE (x, CANVAS_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(255, 255, 255)
    END IF
    IF recording THEN
        x = CANVAS_X + (recPos - scrollX) * zoom
        IF x >= CANVAS_X AND x < CANVAS_X + CANVAS_W THEN LINE (x, CANVAS_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(255, 60, 60)
    END IF

    ' mouse preview: the note the NOTE tool would place, or the step / cell
    ' the FREE tool would draw
    IF mouseIn AND drawing = 0 AND tool = TOOL_NOTE THEN
        y = note_y(INT(mouseNote + 0.5))
        IF NOT snapOn THEN y = note_y(mouseNote)
        s = mouseStep
        IF grid_snap THEN s = cell_start(cell_of(mouseStep))
        x = CANVAS_X + (s - scrollX) * zoom
        LINE (x, y - 2)-(x + (note_tool_end(s) - s) * zoom - 2, y + 2), _RGBA32(255, 255, 255, 110), BF
    END IF
    IF mouseIn AND drawing = 0 AND (tool = TOOL_DRAW OR tool = TOOL_ERASE OR tool = TOOL_LINE OR tool = TOOL_WAVE) THEN
        y = note_y(INT(mouseNote + 0.5))
        IF NOT snapOn THEN y = note_y(mouseNote)
        IF grid_snap THEN
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
''
' Keep a y inside the piano roll (boxes for pitches off the roll are cut off
' at its edge instead of drawing over the toolbar or the scope).
'
FUNCTION clip_y& (y AS LONG)
    clip_y = y
    IF y < CANVAS_Y THEN clip_y = CANVAS_Y
    IF y > CANVAS_Y + CANVAS_H - 1 THEN clip_y = CANVAS_Y + CANVAS_H - 1
END FUNCTION


SUB draw_handles (xl AS LONG, xr AS LONG, yt AS LONG, yb AS LONG, hover AS INTEGER, baseCol AS _UNSIGNED LONG)
    DIM ym AS LONG, xm AS LONG, c AS _UNSIGNED LONG, i AS INTEGER
    ym = (yt + yb) \ 2: xm = (xl + xr) \ 2
    FOR i = 1 TO 4
        IF hover = i THEN c = _RGB32(255, 220, 80) ELSE c = baseCol
        SELECT CASE i
            CASE 1: LINE (xl - 3, ym - 6)-(xl + 3, ym + 6), c, BF
            CASE 2: LINE (xr - 3, ym - 6)-(xr + 3, ym + 6), c, BF
            CASE 3: LINE (xm - 6, yt - 3)-(xm + 6, yt + 3), c, BF
            CASE 4: LINE (xm - 6, yb - 3)-(xm + 6, yb + 3), c, BF
        END SELECT
    NEXT
    IF hover = 1 OR hover = 2 THEN LINE (choose_x(hover, xl, xr), yt)-(choose_x(hover, xl, xr), yb), _RGB32(255, 220, 80)
    IF hover = 3 THEN LINE (xl, yt)-(xr, yt), _RGB32(255, 220, 80)
    IF hover = 4 THEN LINE (xl, yb)-(xr, yb), _RGB32(255, 220, 80)
END SUB


FUNCTION choose_x& (h AS INTEGER, a AS LONG, b AS LONG)
    IF h = 1 THEN choose_x = a ELSE choose_x = b
END FUNCTION


SUB draw_seconds (vis AS LONG)
    DIM s AS LONG, x AS LONG, tk AS LONG, lb AS LONG
    ' ticks every 0.1 s, or every second when that would be too tight; a
    ' label every second, or every few seconds when zoomed far out
    tk = 14
    IF 14 * zoom < 4 THEN tk = 140
    lb = 140
    DO WHILE lb * zoom < 40: lb = lb * 2: LOOP
    FOR s = (scrollX \ tk) * tk TO scrollX + vis STEP tk
        x = CANVAS_X + (s - scrollX) * zoom
        IF x >= CANVAS_X AND x < CANVAS_X + CANVAS_W THEN
            IF s MOD lb = 0 THEN
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
    DIM barN AS LONG, barEvery AS LONG
    bc = beat_cells
    barEvery = 1
    DO WHILE barEvery * cell_steps * bc * BEATS_PER_BAR * zoom < 28: barEvery = barEvery * 2: LOOP
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
                ' bar numbers: every bar, or every 2nd / 4th... when bars get narrow
                barN = c \ (bc * BEATS_PER_BAR)
                IF barN MOD barEvery = 0 THEN
                    COLOR _RGB32(180, 200, 235)
                    _PRINTSTRING (x + 3, TIME_Y + 2), LTRIM$(STR$(barN + 1))
                END IF
            ELSEIF onBeat AND cell_steps * bc * zoom >= 4 THEN
                LINE (x, CANVAS_Y - 10)-(x, CANVAS_Y - 2), _RGB32(120, 135, 160)
                LINE (x, CANVAS_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(52, 60, 82)
            ELSEIF linesOn AND (cell_steps * zoom) >= 4 THEN
                LINE (x, CANVAS_Y - 5)-(x, CANVAS_Y - 2), _RGB32(80, 90, 110)
                LINE (x, CANVAS_Y)-(x, CANVAS_Y + CANVAS_H - 1), _RGB32(38, 46, 64)
            END IF
        END IF
    NEXT
END SUB


''
' The oscilloscope: what the emulated speaker is sending out right now,
' after the cone filter - the real 1-bit square wave. It triggers on a
' rising edge, like a real scope, so a steady note holds still.
'
SUB draw_scope
    DIM x AS LONG, y AS LONG, py AS LONG, k AS LONG, start AS LONG, span AS LONG
    DIM heard AS LONG, mid AS LONG, gain AS DOUBLE, v AS SINGLE, ms AS DOUBLE, found AS INTEGER

    mid = SCOPE_Y + SCOPE_H \ 2
    LINE (CANVAS_X, SCOPE_Y)-(CANVAS_X + CANVAS_W - 1, SCOPE_Y + SCOPE_H - 1), _RGB32(6, 14, 10), BF
    FOR x = CANVAS_X TO CANVAS_X + CANVAS_W - 1 STEP 100
        LINE (x, SCOPE_Y)-(x, SCOPE_Y + SCOPE_H - 1), _RGB32(16, 34, 24)
    NEXT
    LINE (CANVAS_X, mid)-(CANVAS_X + CANVAS_W - 1, mid), _RGB32(20, 48, 32)
    LINE (CANVAS_X - 1, SCOPE_Y - 1)-(CANVAS_X + CANVAS_W, SCOPE_Y + SCOPE_H), _RGB32(70, 80, 100), B

    ms = SCOPE_SPAN * 1000 / pcspk.rate
    COLOR _RGB32(110, 200, 140)
    _PRINTSTRING (RULER_X - 26, SCOPE_Y), "SCOPE"
    COLOR _RGB32(80, 130, 100)
    _PRINTSTRING (RULER_X - 26, SCOPE_Y + 18), LTRIM$(STR$(CLNG(ms))) + "ms"
    _PRINTSTRING (RULER_X - 26, SCOPE_Y + 34), "10/div"

    ' skip what is queued but not heard yet, then find a rising edge
    span = SCOPE_SPAN
    heard = CLNG(PCSPK_Buffered * pcspk.rate)
    IF heard < 0 THEN heard = 0
    IF heard + span + 1600 >= PCSPK_SCOPE_N THEN heard = PCSPK_SCOPE_N - span - 1601
    start = heard + span
    FOR k = heard + span + 1600 TO heard + span STEP -1
        IF PCSPK_ScopeSample(k) <= 0 AND PCSPK_ScopeSample(k - 1) > 0 THEN start = k: found = -1: EXIT FOR
    NEXT

    ' a full-scale square from the speaker is about +/- the volume (0.25)
    gain = (SCOPE_H / 2 - 6) / 0.3
    py = -1
    FOR x = 0 TO CANVAS_W - 1
        v = PCSPK_ScopeSample(start - INT(x * span / CANVAS_W))
        y = mid - CLNG(v * gain)
        IF y < SCOPE_Y + 1 THEN y = SCOPE_Y + 1
        IF y > SCOPE_Y + SCOPE_H - 2 THEN y = SCOPE_Y + SCOPE_H - 2
        IF py >= 0 THEN LINE (CANVAS_X + x - 1, py)-(CANVAS_X + x, y), _RGB32(90, 255, 140) ELSE PSET (CANVAS_X + x, y), _RGB32(90, 255, 140)
        py = y
    NEXT
    IF found THEN
        COLOR _RGB32(80, 130, 100)
        _PRINTSTRING (RULER_X - 26, SCOPE_Y + 50), "trig"
    END IF
END SUB


SUB draw_help
    DIM x AS LONG, y AS LONG, i AS LONG, wMax AS LONG
    DIM t(1 TO 28) AS STRING
    t(1) = "PCSEDIT - PC speaker sound editor"
    t(2) = "Selection: arrows nudge (Shift octave, Alt 1 divisor); Ctrl+Up/Down x2 / half; drag edges to stretch"
    t(3) = "Tools   D)raw L)ine N)ote W)ave E)rase S)elect M)ove (letter w/ Caps off, Alt+letter, Tab)"
    t(4) = "        C)ut Ctrl+X  Ctrl+C copy  Ctrl+V paste  Ctrl+A all.  W)ave: 1-5 shape [ ] cycles"
    t(5) = "Notes   Z S X D C V G B H N J M ,   lower octave     F9/F10 octave  (Caps Lock ON)"
    t(6) = "        Q 2 W 3 E R 5 T 6 Y 7 U I   upper octave     or a MIDI keyboard"
    t(7) = "        wheel scroll   Ctrl+wheel zoom   click the time ruler: cursor"
    t(8) = "F5 rec OFF/STEP/LIVE  Ctrl+R rec now (Ctrl+U count-in)  Ctrl+M metronome off/rec/rec+play"
    t(15) = "Ctrl+Q quantize LIVE takes   Ctrl+F follow the playhead   Ctrl+Shift+M click volume"
    t(9) = "F6 snap  F7 MIDI device  F11/F12 note length  Ctrl+G grid  Ctrl+B BPM  ' lines"
    t(10) = "Space   play / stop            Enter  play from cursor     Ctrl+L  loop"
    t(11) = "Left/Right cursor  Home/End  PgUp/PgDn next dot (NOTE tool: bar)  Up/Down sound"
    t(12) = "Insert / Delete  step at cursor    Backspace  delete step before cursor"
    t(13) = "Ctrl+Up/Down  transpose semitone (Shift: octave)   Ctrl+T trim silence"
    t(14) = "Ctrl+Z / Ctrl+Y  undo / redo     A  hear what you draw while drawing (on/off)"
    t(16) = "F2 rename   F3 new sound   F4 duplicate   F8 delete   Ctrl+P priority"
    t(17) = "Ctrl+N new  Ctrl+O open  Ctrl+S save  Ctrl+Shift+S save as  Ctrl+= / - / 0 display scale"
    t(18) = "Ctrl+E export the sound as .wav (EXPORT/)     drop a file to open it"
    t(19) = "Ctrl+1-4 voice 1-4  Ctrl+5 G all voices  Ctrl+J chords ARP / PWM  (STEP rec: hold keys)"
    t(20) = "Saves IFS banks (Duke Nukem / Keen format, 140 steps per second)."
    t(21) = "Opens anything DN1PLAY plays. Saving never replaces the file you"
    t(22) = "opened unless you choose its name in Save As."
    t(23) = ""
    t(24) = "Ctrl+K  keys play the selected SOUND (follows your pick; Ctrl+Shift+K locks it)"
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


''
' (Re)make the logical-size image for the window size and display scale,
' and fit the layout to it. A scale too big for the window is reduced.
'
SUB make_ui
    DIM lw AS LONG, lh AS LONG
    DO
        lw = INT(physW / uiScale): lh = INT(physH / uiScale)
        IF (lw >= MIN_LW AND lh >= MIN_LH) OR uiScale <= 0.5 THEN EXIT DO
        uiScale = uiScale - 0.125 ' the window is too small for this scale
    LOOP
    IF lw < MIN_LW THEN lw = MIN_LW
    IF lh < MIN_LH THEN lh = MIN_LH
    IF uiImg THEN _FREEIMAGE uiImg
    uiImg = _NEWIMAGE(lw, lh, 32)
    _DEST uiImg
    _PRINTMODE _KEEPBACKGROUND
    _DEST scrImg
    do_layout lw, lh
END SUB


''
' Fit the panels to a logical size: the roll takes the spare width; its
' note rows take the spare height (the note range stays C1-A8).
'
SUB do_layout (lw AS LONG, lh AS LONG)
    DIM avail AS LONG
    SCR_W = lw: SCR_H = lh
    CANVAS_W = SCR_W - CANVAS_X - 8
    avail = SCR_H - CANVAS_Y - 28 - (SCOPE_H + 4) - 32 ' footer, scope, status line
    PX_SEMI = avail \ (NOTE_HI - NOTE_LO)
    IF PX_SEMI < 4 THEN PX_SEMI = 4
    CANVAS_H = PX_SEMI * (NOTE_HI - NOTE_LO)
    SCOPE_Y = CANVAS_Y + CANVAS_H + 28
    LIST_ROWS = (CANVAS_Y + CANVAS_H - LIST_Y) \ ROW_H
    IF zoom > 0 THEN scroll_to scrollX ' (not yet set the first time, at start-up)
END SUB


''
' Ctrl+= / Ctrl+- / Ctrl+0: display scale 50% ... 300%.
'
SUB set_ui_scale (dirn AS LONG)
    DIM lv AS STRING, i AS LONG, n AS LONG, sc(0 TO 15) AS DOUBLE, best AS LONG, want AS DOUBLE
    lv = "0.5 0.625 0.75 0.875 1 1.25 1.5 1.75 2 2.5 3 "
    DO WHILE LEN(lv)
        sc(n) = VAL(LEFT$(lv, INSTR(lv, " ") - 1))
        lv = MID$(lv, INSTR(lv, " ") + 1)
        n = n + 1
    LOOP
    IF dirn = 0 THEN
        want = 1
    ELSE
        FOR i = 0 TO n - 1
            IF ABS(sc(i) - uiScale) < ABS(sc(best) - uiScale) THEN best = i
        NEXT
        best = best + dirn
        IF best < 0 THEN best = 0
        IF best > n - 1 THEN best = n - 1
        want = sc(best)
    END IF
    uiScale = want
    make_ui
    IF uiScale < want THEN
        set_status "Display scale" + STR$(CLNG(uiScale * 100)) + "% - make the window bigger for" + STR$(CLNG(want * 100)) + "%"
    ELSE
        set_status "Display scale" + STR$(CLNG(uiScale * 100)) + "%  (Ctrl+= bigger, Ctrl+- smaller, Ctrl+0 100%)"
    END IF
END SUB


'-----------------------------------------------------------------------------
' Settings: ~/.config/pcsedit.ini (Windows: %APPDATA%\PCSEDIT.ini), plain
' "key=value" lines. Read at start-up, written when PCSEDIT quits.
'-----------------------------------------------------------------------------

FUNCTION cfg_path$
    DIM d AS STRING
    $IF WIN THEN
        d = ENVIRON$("APPDATA")
        IF d = "" THEN d = start_dir
        IF RIGHT$(d, 1) <> "\" THEN d = d + "\"
        cfg_path = d + "PCSEDIT.ini"
    $ELSE
        d = ENVIRON$("HOME")
        IF d = "" THEN cfg_path = start_dir + "pcsedit.ini": EXIT FUNCTION
        d = d + "/.config"
        IF NOT _DIREXISTS(d) THEN MKDIR d
        cfg_path = d + "/pcsedit.ini"
    $END IF
END FUNCTION


SUB cfg_load
    DIM ff AS LONG, ln AS STRING, p AS LONG, f AS STRING
    cfgN = 0
    f = cfg_path
    IF NOT _FILEEXISTS(f) THEN EXIT SUB
    errNum = 0
    ff = FREEFILE
    OPEN f FOR INPUT AS #ff
    IF errNum THEN EXIT SUB
    DO UNTIL EOF(ff) OR errNum <> 0
        LINE INPUT #ff, ln
        p = INSTR(ln, "=")
        IF p > 1 AND LEFT$(ln, 1) <> "#" THEN
            IF cfgN > UBOUND(cfgKey) THEN REDIM _PRESERVE cfgKey(0 TO cfgN * 2) AS STRING: REDIM _PRESERVE cfgVal(0 TO cfgN * 2) AS STRING
            cfgKey(cfgN) = LCASE$(_TRIM$(LEFT$(ln, p - 1)))
            cfgVal(cfgN) = _TRIM$(MID$(ln, p + 1))
            cfgN = cfgN + 1
        END IF
    LOOP
    CLOSE #ff
END SUB


FUNCTION cfg_get$ (k AS STRING, dflt AS STRING)
    DIM i AS LONG
    cfg_get = dflt
    FOR i = 0 TO cfgN - 1
        IF cfgKey(i) = k THEN cfg_get = cfgVal(i): EXIT FUNCTION
    NEXT
END FUNCTION


SUB settings_save
    DIM ff AS LONG, f AS STRING
    f = cfg_path
    errNum = 0
    ff = FREEFILE
    OPEN f FOR OUTPUT AS #ff
    IF errNum THEN EXIT SUB
    PRINT #ff, "# PCSEDIT settings - written when PCSEDIT quits"
    PRINT #ff, "width="; LTRIM$(STR$(physW))
    PRINT #ff, "height="; LTRIM$(STR$(physH))
    PRINT #ff, "x="; LTRIM$(STR$(_SCREENX))
    PRINT #ff, "y="; LTRIM$(STR$(_SCREENY))
    PRINT #ff, "scale="; LTRIM$(STR$(uiScale))
    PRINT #ff, "zoom="; LTRIM$(STR$(zoom))
    PRINT #ff, "grid="; LTRIM$(STR$(gridDiv))
    PRINT #ff, "bpm="; LTRIM$(STR$(bpm))
    PRINT #ff, "lines="; LTRIM$(STR$(linesOn))
    PRINT #ff, "snap="; LTRIM$(STR$(snapOn))
    PRINT #ff, "notelen="; LTRIM$(STR$(noteLen))
    PRINT #ff, "octave="; LTRIM$(STR$(octave))
    PRINT #ff, "audition="; LTRIM$(STR$(drawAudOn))
    PRINT #ff, "metronome="; LTRIM$(STR$(metroMode))
    PRINT #ff, "metrovol="; LTRIM$(STR$(metroVol))
    PRINT #ff, "countin="; LTRIM$(STR$(countIn))
    PRINT #ff, "quantize="; LTRIM$(STR$(quantOn))
    PRINT #ff, "follow="; LTRIM$(STR$(followOn))
    PRINT #ff, "loop="; LTRIM$(STR$(loopOn))
    PRINT #ff, "poly="; LTRIM$(STR$(polyMode))
    CLOSE #ff
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
