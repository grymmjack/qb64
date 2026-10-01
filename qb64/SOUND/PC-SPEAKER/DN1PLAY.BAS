''
' DN1PLAY.BAS - PC speaker sound effect player for Apogee, id Software and
'               DOOM engine games
'
' Native QB64PE - no C, no DECLARE LIBRARY. Loads:
'   - Inverse Frequency Sound banks: Duke Nukem 1 (DUKE1*.DN?), Commander
'     Keen 1 (SOUNDS.CK1), Hovertank, Rescue Rover, Catacomb II, Slordax,
'     Math Rescue, and the banks inside Cosmo's COSMO?.STN and Major
'     Stryker's VOLUME?A.MS?
'   - id AUDIOHED/AUDIOT pairs: Wolfenstein 3D, Spear of Destiny, Blake
'     Stone, Corridor 7, Operation Body Count, Bio Menace, ...
'   - Duke Nukem II's NUKEM2.CMP
'   - DOOM engine .WADs (Doom, Doom II, Final Doom, Chex Quest, Freedoom,
'     Strife, Rise of the Triad) and single DP*.LMP lumps
'   - Crystal Caves CC?-?.SND
' ...then runs every sound through the
' emulated PC speaker (PIT channel 2 square wave, 140 samples/sec - the way
' the games' own sound service did it) and plays it with QB64PE's audio.
'
' Usage:  DN1PLAY [bankfile]      (default ASSETS/duke1-b.dn1)
'         ...or drag and drop a bank file onto the window.
'
' The left panel is a file browser, like an old DOS "open file" box. It
' starts in the loaded bank's folder and lists sub folders and every file
' DN1PLAY can load.
'
' Keys:
'   Left / Right                  move between the browser and the sound list
'   Up/Down PgUp/PgDn Home/End   move in the active panel (mouse wheel too)
'   Enter / click                 browser: open folder / load bank
'                                 sound list: play selected sound
'   Space                         play selected sound
'   Backspace                     browser: up one folder
'   A                             play all from selected (A again to stop)
'   S                             stop
'   + / -                         playback rate +/- 5 Hz     R  reset (140 Hz)
'   L                             speaker low-pass on/off
'   W / E                         export selected / all to EXPORT/*.wav
'   Tab / Shift+Tab               load the next / previous bank in the browser
'   Esc                           quit
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'

CONST SCR_W = 1280
CONST SCR_H = 640
CONST ROW_H = 16
CONST BR_X = 8 '                    file browser
CONST BR_W = 232
CONST LIST_X = 264 '                sound list
CONST LIST_Y = 56
CONST LIST_W = 392
CONST LIST_ROWS = 34
CONST PANEL_X = 672
CONST PLOT_X = 728
CONST PLOT_Y = 230
CONST PLOT_W = 536
CONST PLOT_H = 300
CONST F_LO = 20
CONST F_HI = 20000

DIM SHARED bankFile AS STRING
DIM SHARED bankDir AS STRING
DIM SHARED rateHz AS DOUBLE
DIM SHARED lowPass AS INTEGER
REDIM SHARED snd(0 TO 0) AS LONG
DIM SHARED sndCount AS LONG
DIM SHARED sel AS LONG
DIM SHARED topRow AS LONG
DIM SHARED playingIdx AS LONG
DIM SHARED playAll AS INTEGER
DIM SHARED gapUntil AS DOUBLE
DIM SHARED statusMsg AS STRING
DIM SHARED statusUntil AS DOUBLE
DIM SHARED audioOK AS INTEGER
DIM SHARED gridFreq(0 TO 7) AS DOUBLE
DIM SHARED focus AS INTEGER ' 0 = sound list, 1 = file browser
DIM SHARED errNum AS LONG ' set by the error trap, cleared before risky calls

' file browser
DIM SHARED brDir AS STRING ' absolute, ends with a path separator
REDIM SHARED brName(0 TO 0) AS STRING
REDIM SHARED brIsDir(0 TO 0) AS _BYTE
DIM SHARED brCount AS LONG
DIM SHARED brSel AS LONG
DIM SHARED brTop AS LONG

DIM k AS LONG, f AS STRING, wheel AS LONG, row AS LONG

SCREEN _NEWIMAGE(SCR_W, SCR_H, 32)
_TITLE "DN1PLAY - PC speaker sound player"
_ACCEPTFILEDROP ON
_PRINTMODE _KEEPBACKGROUND

' Disk errors (an unreadable folder or file, a vanished drive...) must not
' stop the program with QB64's "Continue?" box: the trap records the error
' and carries on, and the code that touches the disk checks errNum.
ON ERROR GOTO trap

rateHz = PCSPK_IFS_DEFAULT_HZ
playingIdx = -1
gridFreq(0) = 50: gridFreq(1) = 100: gridFreq(2) = 200: gridFreq(3) = 500
gridFreq(4) = 1000: gridFreq(5) = 2000: gridFreq(6) = 5000: gridFreq(7) = 10000

f = COMMAND$(1)
IF f = "" THEN f = "ASSETS/duke1-b.dn1"
load_bank PCSPK_FindFile(f)
IF brDir = "" THEN browse_dir _STARTDIR$

DO
    ' ---------------------------------------------------------------- mouse
    wheel = 0
    DO WHILE _MOUSEINPUT
        wheel = wheel + _MOUSEWHEEL
    LOOP
    IF wheel THEN
        IF _MOUSEX < LIST_X - 8 THEN move_br brSel + wheel * 3 ELSE move_sel sel + wheel * 3
    END IF
    IF _MOUSEBUTTON(1) THEN
        IF _MOUSEX >= BR_X AND _MOUSEX < BR_X + BR_W AND _MOUSEY >= LIST_Y AND _MOUSEY < LIST_Y + LIST_ROWS * ROW_H THEN
            focus = 1
            row = brTop + (_MOUSEY - LIST_Y) \ ROW_H
            IF row < brCount THEN
                brSel = row
                browse_open brSel
            END IF
            DO WHILE _MOUSEBUTTON(1) ' wait for release
                DO WHILE _MOUSEINPUT: LOOP
                _LIMIT 100
            LOOP
        END IF
        IF _MOUSEX >= LIST_X AND _MOUSEX < LIST_X + LIST_W AND _MOUSEY >= LIST_Y AND _MOUSEY < LIST_Y + LIST_ROWS * ROW_H THEN
            focus = 0
            row = topRow + (_MOUSEY - LIST_Y) \ ROW_H
            IF row < sndCount THEN
                sel = row
                play_sound sel
            END IF
            DO WHILE _MOUSEBUTTON(1) ' wait for release
                DO WHILE _MOUSEINPUT: LOOP
                _LIMIT 100
            LOOP
        END IF
    END IF

    ' ------------------------------------------------------------- keyboard
    k = _KEYHIT
    SELECT CASE k
        CASE 19200: focus = 1 '                        left: browser
        CASE 19712: focus = 0 '                        right: sound list
        CASE 18432, 20480, 18688, 20736, 18176, 20224 'up down pgup pgdn home end
            IF focus THEN
                SELECT CASE k
                    CASE 18432: move_br brSel - 1
                    CASE 20480: move_br brSel + 1
                    CASE 18688: move_br brSel - LIST_ROWS
                    CASE 20736: move_br brSel + LIST_ROWS
                    CASE 18176: move_br 0
                    CASE 20224: move_br brCount - 1
                END SELECT
            ELSE
                SELECT CASE k
                    CASE 18432: move_sel sel - 1
                    CASE 20480: move_sel sel + 1
                    CASE 18688: move_sel sel - LIST_ROWS
                    CASE 20736: move_sel sel + LIST_ROWS
                    CASE 18176: move_sel 0
                    CASE 20224: move_sel sndCount - 1
                END SELECT
            END IF
        CASE 13
            IF focus THEN
                browse_open brSel
            ELSE
                playAll = 0
                play_sound sel
            END IF
        CASE 32
            playAll = 0
            play_sound sel
        CASE 8 '                                       Backspace
            browse_up
        CASE 65, 97 '                                  A
            playAll = NOT playAll
            IF playAll THEN play_sound sel ELSE stop_all
        CASE 83, 115 '                                 S
            playAll = 0
            stop_all
        CASE 43, 61 '                                  + =
            set_rate rateHz + 5
        CASE 45, 95 '                                  - _
            set_rate rateHz - 5
        CASE 82, 114 '                                 R
            set_rate PCSPK_IFS_DEFAULT_HZ
        CASE 76, 108 '                                 L
            lowPass = NOT lowPass
            IF lowPass THEN PCSPK_SetLowPass 5000 ELSE PCSPK_SetLowPass 0
            render_all
            IF lowPass THEN set_status "Speaker low-pass ON" ELSE set_status "Speaker low-pass OFF"
        CASE 87, 119 '                                 W
            export_sound sel, -1
        CASE 69, 101 '                                 E
            export_all
        CASE 9 '                                       Tab
            step_bank 1
        CASE 3840 '                                    Shift+Tab
            step_bank -1
        CASE 27
            EXIT DO
    END SELECT

    ' ------------------------------------------------------ drag and drop
    IF _TOTALDROPPEDFILES THEN
        f = _DROPPEDFILE
        _FINISHDROP
        load_bank f
    END IF

    ' --------------------------------------------------- play all sequencer
    IF playAll AND playingIdx >= 0 THEN
        IF NOT is_playing(playingIdx) THEN
            IF gapUntil = 0 THEN
                gapUntil = TIMER(0.001) + 0.35
            ELSEIF TIMER(0.001) >= gapUntil OR TIMER(0.001) < gapUntil - 10 THEN
                IF playingIdx + 1 < sndCount THEN
                    move_sel playingIdx + 1
                    play_sound sel
                ELSE
                    playAll = 0
                    playingIdx = -1
                END IF
            END IF
        END IF
    END IF

    draw_ui
    _DISPLAY
    _LIMIT 60
LOOP

stop_all
close_sounds
SYSTEM

trap:
errNum = ERR
RESUME NEXT


'-----------------------------------------------------------------------------
' Bank handling
'-----------------------------------------------------------------------------

SUB load_bank (fileName AS STRING)
    DIM p AS LONG, full AS STRING, ok AS INTEGER

    stop_all
    playAll = 0
    errNum = 0
    full = _FULLPATH$(fileName)
    IF errNum OR full = "" THEN full = fileName

    errNum = 0
    ok = PCSPK_IFSLoad(full)
    IF errNum <> 0 OR NOT ok THEN
        IF errNum THEN
            set_status "Can't read " + base_name(full) + " (error" + STR$(errNum) + ")"
        ELSE
            set_status "No PC speaker sounds in " + base_name(full)
        END IF
        ' the failed load emptied the library's bank: put the old one back
        ' (its rendered sounds are still open, so nothing else changes)
        IF LEN(bankFile) THEN
            errNum = 0
            ok = PCSPK_IFSLoad(bankFile)
        END IF
        EXIT SUB
    END IF

    close_sounds
    bankFile = full
    p = _INSTRREV(bankFile, "/")
    IF _INSTRREV(bankFile, "\") > p THEN p = _INSTRREV(bankFile, "\")
    bankDir = LEFT$(bankFile, p)
    sndCount = PCSPK_IFSCount
    sel = 0
    topRow = 0
    render_all

    ' keep the browser on the bank's folder, with the bank selected
    IF bankDir <> brDir THEN browse_dir bankDir
    browse_select base_name(bankFile)
    set_status "Loaded " + base_name(bankFile) + " -" + STR$(sndCount) + " sounds"
END SUB


SUB render_all
    DIM i AS LONG
    stop_all
    close_sounds
    REDIM snd(0 TO sndCount) AS LONG
    audioOK = 0
    FOR i = 0 TO sndCount - 1
        snd(i) = PCSPK_IFSRender(i, rateHz)
        IF snd(i) > 0 THEN audioOK = -1
    NEXT
END SUB


SUB close_sounds
    DIM i AS LONG
    FOR i = 0 TO UBOUND(snd)
        IF snd(i) > 0 THEN _SNDCLOSE snd(i)
        snd(i) = 0
    NEXT
END SUB


SUB set_rate (hz AS DOUBLE)
    rateHz = hz
    IF rateHz < 20 THEN rateHz = 20
    IF rateHz > 1000 THEN rateHz = 1000
    render_all
    set_status "Playback rate" + STR$(rateHz) + " Hz"
END SUB


'-----------------------------------------------------------------------------
' File browser
'-----------------------------------------------------------------------------

''
' List a folder in the browser: ".." first, then sub folders, then the files
' DN1PLAY can load, each group A-Z. Hidden (dot) folders are left out.
'
SUB browse_dir (d AS STRING)
    DIM full AS STRING, f AS STRING, nm AS STRING, n AS LONG, i AS LONG, j AS LONG
    DIM t AS STRING, tb AS _BYTE, isRoot AS INTEGER
    REDIM nms(0 TO 63) AS STRING
    REDIM dirs(0 TO 63) AS _BYTE

    errNum = 0
    full = _FULLPATH$(d)
    IF errNum OR full = "" THEN set_status "Can't open folder " + d: EXIT SUB
    IF RIGHT$(full, 1) <> "/" AND RIGHT$(full, 1) <> "\" THEN full = full + path_sep
    isRoot = (full = "/") OR (LEN(full) = 3 AND MID$(full, 2, 2) = ":\")

    ' a readable folder always lists at least "./"; nothing at all means we
    ' may not look inside it
    f = _FILES$(full + "*")
    IF errNum <> 0 OR f = "" THEN set_status "Can't read folder " + full: EXIT SUB
    IF NOT isRoot THEN nms(0) = "..": dirs(0) = -1: n = 1
    DO WHILE LEN(f) AND errNum = 0
        IF RIGHT$(f, 1) = "/" OR RIGHT$(f, 1) = "\" THEN
            nm = LEFT$(f, LEN(f) - 1)
            IF LEFT$(nm, 1) <> "." THEN
                IF n > UBOUND(nms) THEN REDIM _PRESERVE nms(0 TO n * 2) AS STRING: REDIM _PRESERVE dirs(0 TO n * 2) AS _BYTE
                nms(n) = nm: dirs(n) = -1: n = n + 1
            END IF
        ELSEIF is_bank_name(f) THEN
            IF n > UBOUND(nms) THEN REDIM _PRESERVE nms(0 TO n * 2) AS STRING: REDIM _PRESERVE dirs(0 TO n * 2) AS _BYTE
            nms(n) = f: dirs(n) = 0: n = n + 1
        END IF
        f = _FILES$
    LOOP

    ' sort: "..", folders, files; A-Z inside each group
    FOR i = 0 TO n - 2
        FOR j = i + 1 TO n - 1
            IF br_key(nms(j), dirs(j)) < br_key(nms(i), dirs(i)) THEN
                t = nms(i): nms(i) = nms(j): nms(j) = t
                tb = dirs(i): dirs(i) = dirs(j): dirs(j) = tb
            END IF
        NEXT
    NEXT

    brDir = full
    brCount = n
    REDIM brName(0 TO n) AS STRING
    REDIM brIsDir(0 TO n) AS _BYTE
    FOR i = 0 TO n - 1
        brName(i) = nms(i)
        brIsDir(i) = dirs(i)
    NEXT
    brSel = 0
    brTop = 0
END SUB


FUNCTION br_key$ (nm AS STRING, isDir AS _BYTE)
    IF nm = ".." THEN
        br_key = "0"
    ELSEIF isDir THEN
        br_key = "1" + UCASE$(nm)
    ELSE
        br_key = "2" + UCASE$(nm)
    END IF
END FUNCTION


FUNCTION path_sep$
    $IF WIN THEN
        path_sep = "\"
    $ELSE
        path_sep = "/"
    $END IF
END FUNCTION


''
' Enter / click on a browser row: open the folder or load the bank.
'
SUB browse_open (i AS LONG)
    IF i < 0 OR i >= brCount THEN EXIT SUB
    IF brIsDir(i) THEN
        IF brName(i) = ".." THEN browse_up ELSE browse_dir brDir + brName(i)
    ELSE
        load_bank brDir + brName(i)
    END IF
END SUB


''
' Go up one folder and put the cursor on the folder we came from.
'
SUB browse_up
    DIM came AS STRING, p AS LONG
    IF brDir = "" THEN EXIT SUB
    came = LEFT$(brDir, LEN(brDir) - 1)
    p = _INSTRREV(came, "/")
    IF _INSTRREV(came, "\") > p THEN p = _INSTRREV(came, "\")
    IF p = 0 THEN EXIT SUB
    IF p = LEN(came) OR RIGHT$(came, 1) = ":" THEN EXIT SUB ' already at the top
    ' cut the last folder off the path rather than asking the OS about
    ' brDir + "..": that would fail inside a folder we can't read
    browse_dir LEFT$(came, p)
    browse_select MID$(came, p + 1)
END SUB


SUB browse_select (nm AS STRING)
    DIM i AS LONG
    FOR i = 0 TO brCount - 1
        IF brName(i) = nm THEN move_br i: EXIT SUB
    NEXT
END SUB


SUB move_br (newSel AS LONG)
    brSel = newSel
    IF brSel >= brCount THEN brSel = brCount - 1
    IF brSel < 0 THEN brSel = 0
    IF brSel < brTop THEN brTop = brSel
    IF brSel >= brTop + LIST_ROWS THEN brTop = brSel - LIST_ROWS + 1
END SUB


''
' Tab / Shift+Tab: load the next / previous bank file in the browser's
' folder, starting from the loaded bank (or the cursor, if the loaded bank
' is somewhere else). Folders are skipped; the list wraps around.
'
SUB step_bank (stepDir AS LONG)
    DIM i AS LONG, start AS LONG, tries AS LONG
    IF brCount = 0 THEN EXIT SUB
    start = brSel
    FOR i = 0 TO brCount - 1
        IF NOT brIsDir(i) AND brDir + brName(i) = bankFile THEN start = i
    NEXT
    i = start
    FOR tries = 1 TO brCount
        i = (i + stepDir + brCount) MOD brCount
        IF NOT brIsDir(i) THEN
            move_br i
            load_bank brDir + brName(i)
            EXIT SUB
        END IF
    NEXT
END SUB


''
' TRUE for file names Tab should stop at. AUDIOHED.* is left out because
' its AUDIOT.* partner already stands for the pair.
'
FUNCTION is_bank_name% (f AS STRING)
    DIM u AS STRING, e AS STRING, p AS LONG
    u = UCASE$(f)
    p = _INSTRREV(u, ".")
    IF p THEN e = MID$(u, p)
    IF LEFT$(u, 7) = "AUDIOT." THEN is_bank_name = -1: EXIT FUNCTION
    IF LEFT$(e, 3) = ".DN" OR LEFT$(e, 3) = ".CK" OR LEFT$(e, 3) = ".MS" THEN is_bank_name = -1: EXIT FUNCTION
    SELECT CASE e
        CASE ".WAD", ".LMP", ".CMP", ".SND", ".STN", ".HOV", ".ROV", ".CA2", ".SLO", ".8"
            is_bank_name = -1
    END SELECT
END FUNCTION


'-----------------------------------------------------------------------------
' Playback
'-----------------------------------------------------------------------------

SUB play_sound (index AS LONG)
    IF index < 0 OR index >= sndCount THEN EXIT SUB
    stop_all
    playingIdx = index
    gapUntil = 0
    IF snd(index) > 0 THEN _SNDPLAY snd(index)
END SUB


SUB stop_all
    DIM i AS LONG
    FOR i = 0 TO UBOUND(snd)
        IF snd(i) > 0 THEN _SNDSTOP snd(i)
    NEXT
    playingIdx = -1
END SUB


FUNCTION is_playing% (index AS LONG)
    IF index < 0 OR index >= sndCount THEN EXIT FUNCTION
    IF snd(index) > 0 THEN is_playing = _SNDPLAYING(snd(index))
END FUNCTION


FUNCTION play_pos# (index AS LONG)
    IF index < 0 OR index >= sndCount THEN EXIT FUNCTION
    IF snd(index) > 0 THEN play_pos = _SNDGETPOS(snd(index))
END FUNCTION


SUB move_sel (newSel AS LONG)
    sel = newSel
    IF sel >= sndCount THEN sel = sndCount - 1
    IF sel < 0 THEN sel = 0
    IF sel < topRow THEN topRow = sel
    IF sel >= topRow + LIST_ROWS THEN topRow = sel - LIST_ROWS + 1
END SUB


'-----------------------------------------------------------------------------
' Export
'-----------------------------------------------------------------------------

SUB export_sound (index AS LONG, announce AS INTEGER)
    DIM h AS LONG, outName AS STRING, digits AS LONG
    IF index < 0 OR index >= sndCount THEN EXIT SUB
    IF NOT _DIREXISTS("EXPORT") THEN MKDIR "EXPORT"
    IF sndCount > 100 THEN digits = 3 ELSE digits = 2
    outName = "EXPORT/" + safe_name(base_name(bankFile)) + "_" + RIGHT$("00" + LTRIM$(STR$(index)), digits) + "_" + safe_name(PCSPK_IFSName(index)) + ".wav"
    h = PCSPK_IFSRender(index, rateHz)
    PCSPK_SaveWAV outName
    IF h > 0 THEN _SNDCLOSE h
    IF announce THEN set_status "Saved " + outName
END SUB


SUB export_all
    DIM i AS LONG
    FOR i = 0 TO sndCount - 1
        export_sound i, 0
    NEXT
    set_status "Saved" + STR$(sndCount) + " sounds to EXPORT/"
END SUB


'-----------------------------------------------------------------------------
' Drawing
'-----------------------------------------------------------------------------

''
' The file browser panel: folder path, then one row per entry, DOS DIR style.
'
SUB draw_browser
    DIM i AS LONG, n AS LONG, y AS LONG, s AS STRING, w AS LONG

    w = BR_W \ 8
    IF focus THEN COLOR _RGB32(200, 215, 240) ELSE COLOR _RGB32(120, 140, 170)
    s = brDir
    IF LEN(s) > w THEN s = "..." + RIGHT$(s, w - 3)
    _PRINTSTRING (BR_X, LIST_Y - 20), s
    LINE (BR_X + BR_W + 10, LIST_Y - 24)-(BR_X + BR_W + 10, LIST_Y + LIST_ROWS * ROW_H), _RGB32(40, 48, 64)

    FOR i = 0 TO LIST_ROWS - 1
        n = brTop + i
        IF n >= brCount THEN EXIT FOR
        y = LIST_Y + i * ROW_H
        IF n = brSel THEN
            IF focus THEN
                LINE (BR_X - 2, y - 1)-(BR_X + BR_W, y + ROW_H - 2), _RGB32(50, 70, 110), BF
            ELSE
                LINE (BR_X - 2, y - 1)-(BR_X + BR_W, y + ROW_H - 2), _RGB32(36, 44, 62), BF
            END IF
        END IF
        IF brIsDir(n) THEN
            COLOR _RGB32(120, 190, 255)
            s = LEFT$(brName(n), w - 6)
            s = s + SPACE$(w - LEN(s) - 5) + "<DIR>"
        ELSE
            IF brDir + brName(n) = bankFile THEN COLOR _RGB32(255, 200, 60) ELSE COLOR _RGB32(190, 200, 215)
            s = LEFT$(brName(n), w)
        END IF
        _PRINTSTRING (BR_X, y), s
    NEXT

    IF brCount > LIST_ROWS THEN
        LINE (BR_X + BR_W + 4, LIST_Y)-(BR_X + BR_W + 7, LIST_Y + LIST_ROWS * ROW_H), _RGB32(40, 48, 64), BF
        y = LIST_Y + (brTop * LIST_ROWS * ROW_H) \ brCount
        LINE (BR_X + BR_W + 4, y)-(BR_X + BR_W + 7, y + (LIST_ROWS * LIST_ROWS * ROW_H) \ brCount), _RGB32(120, 140, 180), BF
    END IF
END SUB


SUB draw_ui
    DIM i AS LONG, y AS LONG, n AS LONG, v AS LONG, samples AS LONG
    DIM x0 AS LONG, x1 AS LONG, fy AS LONG, prevY AS LONG, lo AS DOUBLE, hi AS DOUBLE
    DIM secs AS DOUBLE, fq AS DOUBLE, ppos AS DOUBLE, nowV AS LONG, s AS STRING
    DIM gridF AS DOUBLE

    CLS , _RGB32(16, 20, 28)

    ' title bar
    LINE (0, 0)-(SCR_W - 1, 23), _RGB32(170, 40, 30), BF
    COLOR _RGB32(255, 240, 200)
    s = " DN1PLAY  -  " + base_name(bankFile) + "  -" + STR$(sndCount) + " sounds  -" + STR$(rateHz) + " Hz"
    IF lowPass THEN s = s + "  -  low-pass"
    IF NOT audioOK THEN s = s + "  -  (NO AUDIO DEVICE)"
    _PRINTSTRING (4, 4), s

    draw_browser

    ' list header
    IF focus = 0 THEN COLOR _RGB32(200, 215, 240) ELSE COLOR _RGB32(120, 140, 170)
    _PRINTSTRING (LIST_X, LIST_Y - 20), " #  NAME          SAMPLES   SECS  PRI"

    ' list
    FOR i = 0 TO LIST_ROWS - 1
        n = topRow + i
        IF n >= sndCount THEN EXIT FOR
        y = LIST_Y + i * ROW_H
        IF n = sel THEN
            IF focus = 0 THEN
                LINE (LIST_X - 2, y - 1)-(LIST_X + LIST_W, y + ROW_H - 2), _RGB32(50, 70, 110), BF
            ELSE
                LINE (LIST_X - 2, y - 1)-(LIST_X + LIST_W, y + ROW_H - 2), _RGB32(36, 44, 62), BF
            END IF
        END IF
        IF n = playingIdx THEN
            COLOR _RGB32(255, 200, 60)
        ELSEIF n = sel THEN
            COLOR _RGB32(255, 255, 255)
        ELSE
            COLOR _RGB32(190, 200, 215)
        END IF
        s = RIGHT$("  " + LTRIM$(STR$(n)), 3) + " " + LEFT$(PCSPK_IFSName(n) + SPACE$(12), 12)
        s = s + RIGHT$(SPACE$(10) + STR$(PCSPK_IFSSamples(n)), 10)
        s = s + RIGHT$(SPACE$(7) + fmt2(PCSPK_IFSSamples(n) / rateHz), 7)
        IF has_priority(n) THEN s = s + RIGHT$(SPACE$(5) + STR$(PCSPK_IFSPriority(n)), 5) ELSE s = s + "    -"
        IF n = playingIdx THEN s = s + " " + CHR$(16)
        _PRINTSTRING (LIST_X, y), s
    NEXT

    ' scrollbar
    IF sndCount > LIST_ROWS THEN
        LINE (LIST_X + LIST_W + 4, LIST_Y)-(LIST_X + LIST_W + 8, LIST_Y + LIST_ROWS * ROW_H), _RGB32(40, 48, 64), BF
        y = LIST_Y + (topRow * LIST_ROWS * ROW_H) \ sndCount
        LINE (LIST_X + LIST_W + 4, y)-(LIST_X + LIST_W + 8, y + (LIST_ROWS * LIST_ROWS * ROW_H) \ sndCount), _RGB32(120, 140, 180), BF
    END IF

    IF sndCount = 0 THEN EXIT SUB

    ' info panel
    samples = PCSPK_IFSSamples(sel)
    secs = samples / rateHz
    lo = 0: hi = 0
    FOR n = 0 TO samples - 1
        v = PCSPK_IFSValue(sel, n)
        IF v > 0 THEN
            fq = PCSPK_DivisorToFreq(v)
            IF lo = 0 OR fq < lo THEN lo = fq
            IF fq > hi THEN hi = fq
        END IF
    NEXT

    COLOR _RGB32(255, 200, 60)
    _PRINTSTRING (PANEL_X, 40), PCSPK_IFSName(sel)
    COLOR _RGB32(190, 200, 215)
    _PRINTSTRING (PANEL_X, 64), "Sound       :" + STR$(sel) + " of" + STR$(sndCount)
    _PRINTSTRING (PANEL_X, 80), "Offset      : $" + hex4(PCSPK_IFSOffset(sel))
    s = "Format      : " + PCSPK_IFSFormatName(sel)
    IF has_priority(sel) THEN s = s + ", priority" + STR$(PCSPK_IFSPriority(sel))
    _PRINTSTRING (PANEL_X, 96), s
    _PRINTSTRING (PANEL_X, 112), "Samples     :" + STR$(samples) + "  (" + fmt2(secs) + " sec @" + STR$(rateHz) + " Hz)"
    IF hi > 0 THEN
        _PRINTSTRING (PANEL_X, 128), "Freq range  :" + STR$(CLNG(lo)) + " -" + STR$(CLNG(hi)) + " Hz"
    ELSE
        _PRINTSTRING (PANEL_X, 128), "Freq range  : (silent)"
    END IF

    ' now playing readout
    IF playingIdx = sel AND is_playing(sel) THEN
        ppos = play_pos(sel)
        n = INT(ppos * rateHz)
        IF n >= 0 AND n < samples THEN
            nowV = PCSPK_IFSValue(sel, n)
            COLOR _RGB32(255, 255, 255)
            IF nowV > 0 THEN
                _PRINTSTRING (PANEL_X, 160), "Now         : divisor" + STR$(nowV) + " =" + STR$(CLNG(PCSPK_DivisorToFreq(nowV))) + " Hz"
            ELSE
                _PRINTSTRING (PANEL_X, 160), "Now         : (silence)"
            END IF
        END IF
    END IF

    ' plot frame + octave grid
    LINE (PLOT_X, PLOT_Y)-(PLOT_X + PLOT_W, PLOT_Y + PLOT_H), _RGB32(10, 12, 18), BF
    FOR i = 0 TO UBOUND(gridFreq)
        gridF = gridFreq(i)
        fy = freq_y(gridF)
        LINE (PLOT_X, fy)-(PLOT_X + PLOT_W, fy), _RGB32(36, 44, 60)
        COLOR _RGB32(110, 120, 140)
        IF gridF >= 1000 THEN s = LTRIM$(STR$(gridF / 1000)) + "k" ELSE s = LTRIM$(STR$(gridF))
        _PRINTSTRING (PLOT_X - 8 * LEN(s) - 6, fy - 8), s
    NEXT
    LINE (PLOT_X, PLOT_Y)-(PLOT_X + PLOT_W, PLOT_Y + PLOT_H), _RGB32(70, 80, 100), B
    COLOR _RGB32(110, 120, 140)
    _PRINTSTRING (PLOT_X, PLOT_Y + PLOT_H + 6), "0"
    s = fmt2(secs) + " s"
    _PRINTSTRING (PLOT_X + PLOT_W - 8 * LEN(s), PLOT_Y + PLOT_H + 6), s
    _PRINTSTRING (PLOT_X + PLOT_W \ 2 - 64, PLOT_Y + PLOT_H + 6), "frequency / time"

    ' the sound, one step per sample
    IF samples > 0 THEN
        prevY = -1
        FOR n = 0 TO samples - 1
            x0 = PLOT_X + (n * PLOT_W) \ samples
            x1 = PLOT_X + ((n + 1) * PLOT_W) \ samples
            IF x1 <= x0 THEN x1 = x0 + 1
            v = PCSPK_IFSValue(sel, n)
            IF v > 0 THEN
                fy = freq_y(PCSPK_DivisorToFreq(v))
                IF prevY >= 0 THEN LINE (x0, prevY)-(x0, fy), _RGB32(120, 80, 20)
                LINE (x0, fy - 1)-(x1, fy + 1), _RGB32(255, 170, 40), BF
                prevY = fy
            ELSE
                LINE (x0, PLOT_Y + PLOT_H - 3)-(x1, PLOT_Y + PLOT_H - 1), _RGB32(70, 80, 100), BF
                prevY = -1
            END IF
        NEXT

        ' playhead
        IF playingIdx = sel AND is_playing(sel) THEN
            x0 = PLOT_X + CLNG(play_pos(sel) * rateHz * PLOT_W / samples)
            IF x0 > PLOT_X + PLOT_W THEN x0 = PLOT_X + PLOT_W
            LINE (x0, PLOT_Y + 1)-(x0, PLOT_Y + PLOT_H - 1), _RGB32(255, 255, 255)
        END IF
    END IF

    ' help
    COLOR _RGB32(120, 140, 170)
    _PRINTSTRING (PANEL_X, SCR_H - 88), "Left/Right panel   Enter open/play   Backspace up   Tab/Shift+Tab bank"
    _PRINTSTRING (PANEL_X, SCR_H - 72), "Space play   A play all   S stop"
    _PRINTSTRING (PANEL_X, SCR_H - 56), "+/- rate   R reset rate   L low-pass   W/E export wav   Esc quit"
    _PRINTSTRING (PANEL_X, SCR_H - 40), "Drop a sound bank, AUDIOT.*, .WAD, .CMP or .SND on the window"
    IF playAll THEN
        COLOR _RGB32(255, 200, 60)
        _PRINTSTRING (PANEL_X, 192), "[ PLAY ALL ]"
    END IF

    ' status line
    IF LEN(statusMsg) THEN
        IF TIMER(0.001) < statusUntil AND TIMER(0.001) > statusUntil - 10 THEN
            COLOR _RGB32(140, 230, 140)
            _PRINTSTRING (LIST_X, SCR_H - 20), statusMsg
        ELSE
            statusMsg = ""
        END IF
    END IF
END SUB


FUNCTION freq_y& (hz AS DOUBLE)
    DIM f AS DOUBLE, t AS DOUBLE
    f = hz
    IF f < F_LO THEN f = F_LO
    IF f > F_HI THEN f = F_HI
    t = LOG(f / F_LO) / LOG(F_HI / F_LO)
    freq_y = PLOT_Y + PLOT_H - 2 - CLNG(t * (PLOT_H - 4))
END FUNCTION


SUB set_status (msg AS STRING)
    statusMsg = msg
    statusUntil = TIMER(0.001) + 4
END SUB


FUNCTION fmt2$ (x AS DOUBLE)
    DIM cents AS LONG
    cents = INT(x * 100 + 0.5)
    fmt2 = LTRIM$(STR$(cents \ 100)) + "." + RIGHT$("0" + LTRIM$(STR$(cents MOD 100)), 2)
END FUNCTION


''
' DOOM lumps and raw lists carry no priority; IFS banks and id chunks do.
'
FUNCTION has_priority% (index AS LONG)
    SELECT CASE PCSPK_IFSFormat(index)
        CASE PCSPK_FMT_IFS, PCSPK_FMT_ID: has_priority = -1
    END SELECT
END FUNCTION


FUNCTION hex4$ (v AS LONG)
    hex4 = HEX$(v)
    IF LEN(HEX$(v)) < 4 THEN hex4 = RIGHT$("000" + HEX$(v), 4)
END FUNCTION


FUNCTION base_name$ (path AS STRING)
    DIM p AS LONG
    p = _INSTRREV(path, "/")
    IF _INSTRREV(path, "\") > p THEN p = _INSTRREV(path, "\")
    base_name = MID$(path, p + 1)
END FUNCTION


FUNCTION safe_name$ (s AS STRING)
    DIM i AS LONG, c AS STRING, r AS STRING
    FOR i = 1 TO LEN(s)
        c = MID$(s, i, 1)
        IF INSTR("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_", c) THEN r = r + c ELSE r = r + "_"
    NEXT
    safe_name = r
END FUNCTION


'$INCLUDE:'PCSPKR.BM'
