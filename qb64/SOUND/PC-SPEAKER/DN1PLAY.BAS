''
' DN1PLAY.BAS - Duke Nukem 1 (and Commander Keen 1-3) PC speaker sound player
'
' Native QB64PE - no C, no DECLARE LIBRARY. Loads an Inverse Frequency Sound
' bank (DUKE1*.DN1/.DN2/.DN3, SOUNDS.CK1/2/3), runs every sound through the
' emulated PC speaker (PIT channel 2 square wave, 140 samples/sec - the way
' the games' own sound service did it) and plays it with QB64PE's audio.
'
' Usage:  DN1PLAY [bankfile]      (default ASSETS/duke1-b.dn1)
'         ...or drag and drop a bank file onto the window.
'
' Keys:
'   Up/Down PgUp/PgDn Home/End   select sound (mouse wheel / click work too)
'   Enter / Space / click         play selected sound
'   A                             play all from selected (A again to stop)
'   S                             stop
'   + / -                         playback rate +/- 5 Hz     R  reset (140 Hz)
'   L                             speaker low-pass on/off
'   W / E                         export selected / all to EXPORT/*.wav
'   Tab                           next sound bank in the same folder
'   Esc                           quit
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'

CONST SCR_W = 1024
CONST SCR_H = 640
CONST ROW_H = 16
CONST LIST_X = 8
CONST LIST_Y = 56
CONST LIST_W = 392
CONST LIST_ROWS = 34
CONST PANEL_X = 416
CONST PLOT_X = 472
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

DIM k AS LONG, f AS STRING, wheel AS LONG, row AS LONG

SCREEN _NEWIMAGE(SCR_W, SCR_H, 32)
_TITLE "DN1PLAY - PC speaker sound player"
_ACCEPTFILEDROP ON
_PRINTMODE _KEEPBACKGROUND

rateHz = PCSPK_IFS_DEFAULT_HZ
playingIdx = -1
gridFreq(0) = 50: gridFreq(1) = 100: gridFreq(2) = 200: gridFreq(3) = 500
gridFreq(4) = 1000: gridFreq(5) = 2000: gridFreq(6) = 5000: gridFreq(7) = 10000

f = COMMAND$(1)
IF f = "" THEN f = "ASSETS/duke1-b.dn1"
load_bank PCSPK_FindFile(f)

DO
    ' ---------------------------------------------------------------- mouse
    wheel = 0
    DO WHILE _MOUSEINPUT
        wheel = wheel + _MOUSEWHEEL
    LOOP
    IF wheel THEN move_sel sel + wheel * 3
    IF _MOUSEBUTTON(1) THEN
        IF _MOUSEX >= LIST_X AND _MOUSEX < LIST_X + LIST_W AND _MOUSEY >= LIST_Y AND _MOUSEY < LIST_Y + LIST_ROWS * ROW_H THEN
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
        CASE 18432: move_sel sel - 1 '                 up
        CASE 20480: move_sel sel + 1 '                 down
        CASE 18688: move_sel sel - LIST_ROWS '         page up
        CASE 20736: move_sel sel + LIST_ROWS '         page down
        CASE 18176: move_sel 0 '                       home
        CASE 20224: move_sel sndCount - 1 '            end
        CASE 13, 32
            playAll = 0
            play_sound sel
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
            next_bank
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


'-----------------------------------------------------------------------------
' Bank handling
'-----------------------------------------------------------------------------

SUB load_bank (fileName AS STRING)
    DIM p AS LONG
    stop_all
    playAll = 0
    IF NOT PCSPK_IFSLoad(fileName) THEN
        set_status "Not an IFS sound bank: " + fileName
        EXIT SUB
    END IF
    close_sounds
    bankFile = fileName
    p = _INSTRREV(bankFile, "/")
    IF _INSTRREV(bankFile, "\") > p THEN p = _INSTRREV(bankFile, "\")
    bankDir = LEFT$(bankFile, p)
    sndCount = PCSPK_IFSCount
    sel = 0
    topRow = 0
    render_all
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


''
' Cycle to the next *.DN? / *.CK? file in the bank's folder.
'
SUB next_bank
    DIM f AS STRING, e AS STRING, n AS LONG, i AS LONG, j AS LONG, cur AS LONG, t AS STRING
    REDIM bankNames(0 TO 63) AS STRING

    IF LEN(bankDir) THEN f = _FILES$(bankDir + "*") ELSE f = _FILES$("*")
    DO WHILE LEN(f)
        e = UCASE$(RIGHT$(f, 4))
        IF LEFT$(e, 3) = ".DN" OR LEFT$(e, 3) = ".CK" THEN
            IF n > UBOUND(bankNames) THEN REDIM _PRESERVE bankNames(0 TO n * 2) AS STRING
            bankNames(n) = f
            n = n + 1
        END IF
        f = _FILES$
    LOOP
    IF n = 0 THEN EXIT SUB

    FOR i = 0 TO n - 2 ' tiny sort, the list is short
        FOR j = i + 1 TO n - 1
            IF UCASE$(bankNames(j)) < UCASE$(bankNames(i)) THEN t = bankNames(i): bankNames(i) = bankNames(j): bankNames(j) = t
        NEXT
    NEXT

    cur = -1
    FOR i = 0 TO n - 1
        IF bankNames(i) = base_name(bankFile) THEN cur = i
    NEXT
    load_bank bankDir + bankNames((cur + 1) MOD n)
END SUB


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
    DIM h AS LONG, outName AS STRING
    IF index < 0 OR index >= sndCount THEN EXIT SUB
    IF NOT _DIREXISTS("EXPORT") THEN MKDIR "EXPORT"
    outName = "EXPORT/" + safe_name(base_name(bankFile)) + "_" + RIGHT$("0" + LTRIM$(STR$(index)), 2) + "_" + safe_name(PCSPK_IFSName(index)) + ".wav"
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

    ' list header
    COLOR _RGB32(120, 140, 170)
    _PRINTSTRING (LIST_X, LIST_Y - 20), " #  NAME          SAMPLES   SECS  PRI"

    ' list
    FOR i = 0 TO LIST_ROWS - 1
        n = topRow + i
        IF n >= sndCount THEN EXIT FOR
        y = LIST_Y + i * ROW_H
        IF n = sel THEN LINE (LIST_X - 2, y - 1)-(LIST_X + LIST_W, y + ROW_H - 2), _RGB32(50, 70, 110), BF
        IF n = playingIdx THEN
            COLOR _RGB32(255, 200, 60)
        ELSEIF n = sel THEN
            COLOR _RGB32(255, 255, 255)
        ELSE
            COLOR _RGB32(190, 200, 215)
        END IF
        s = RIGHT$(" " + LTRIM$(STR$(n)), 2) + "  " + LEFT$(PCSPK_IFSName(n) + SPACE$(12), 12)
        s = s + RIGHT$(SPACE$(10) + STR$(PCSPK_IFSSamples(n)), 10)
        s = s + RIGHT$(SPACE$(7) + fmt2(PCSPK_IFSSamples(n) / rateHz), 7)
        s = s + RIGHT$(SPACE$(5) + STR$(PCSPK_IFSPriority(n)), 5)
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
    _PRINTSTRING (PANEL_X, 80), "Offset      : $" + RIGHT$("000" + HEX$(PCSPK_IFSOffset(sel)), 4)
    _PRINTSTRING (PANEL_X, 96), "Priority    :" + STR$(PCSPK_IFSPriority(sel))
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
    _PRINTSTRING (PANEL_X, SCR_H - 72), "Enter/Space/click play   A play all   S stop   Tab next bank"
    _PRINTSTRING (PANEL_X, SCR_H - 56), "+/- rate   R reset rate   L low-pass   W/E export wav   Esc quit"
    _PRINTSTRING (PANEL_X, SCR_H - 40), "Drop a .DN1/.DN2/.DN3/.CK1/.CK2/.CK3 file on the window to load it"
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
