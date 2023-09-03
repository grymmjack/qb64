DEFLNG A-Z
DECLARE DYNAMIC LIBRARY "winmm"
    FUNCTION midiOutGetNumDevs (numdevs AS INTEGER)
    FUNCTION midiOutOpen (lphMidiOut AS LONG, BYVAL uDeviceID AS LONG, BYVAL dwCallback AS LONG, BYVAL dwInstance AS LONG, BYVAL dwFlags AS LONG)
    FUNCTION midiOutClose (BYVAL hMidiOut AS LONG)
    FUNCTION midiOutShortMsg (BYVAL hMidiOut AS LONG, BYVAL dwMsg AS LONG)
END DECLARE



'----------------------------------------------------------------------------------------------------------------------------------
key_c = 4




REDIM key_name$(199), midi$(174), colors(19) AS _INTEGER64, fnt(5), key_dat(199, 9), send AS LONG
REDIM painter(199, 9) AS _INTEGER64, i_button(127, 9), d_buff(46)
fnt(1) = _LOADFONT("cyberbit.ttf", 20)
fnt(3) = _LOADFONT("cyberbit.ttf", 18)
fnt(4) = _LOADFONT("cyberbit.ttf", 68)
fnt(5) = _LOADFONT("cyberbit.ttf", 40)
colors(0) = _RGB32(120, 0, 0): colors(1) = _RGB32(255, 255, 255): colors(2) = _RGB32(0, 0, 0)
colors(18) = _RGB32(0, 0, 255)
colors(16) = _RGB32(0, 0, 255) 'piano active key color
'midi install
OPEN "midi_instrumentals_name.dat" FOR INPUT AS 1: FOR t = 0 TO 174: INPUT #1, midi$(t): NEXT t: CLOSE 1
q$ = "c-c#d-d#e-f-f#g-g#a-a#h-": FOR t2 = 0 TO 2: FOR t1 = 0 TO 11: key_name$(pn) = MID$(q$, t1 * 2 + 1, 2) + LTRIM$(STR$(t2)): pn = pn + 1: NEXT t1, t2
FOR t1 = 0 TO 45: key_name$(pn) = midi$(128 + t1): pn = pn + 1: NEXT t1

IF _FILEEXISTS("using.kcl") = 0 THEN GOSUB standard2using
GOSUB open_using


'midi open
hmidiout = 0: q = midiOutGetNumDevs(0): PRINT "MIDI-devices :"; q: IF q = 0 THEN PRINT "no midi device": END
SLEEP 1
q = midiOutOpen(hmidiout, 0, 0, 0, 0): IF q THEN PRINT "can't open midi": END
PRINT "First MIDI device is open"

GOSUB display_loader: _DEST act_display: SCREEN act_display: _FULLSCREEN: CLS

buffsize = 20: DIM buff(buffsize - 1, 5) '0-keycode

ch = 8
IF _FILEEXISTS("last.dat") = 0 THEN inst = 0: pitch = 20: transpose = 30: GOSUB save_last
OPEN "last.dat" FOR INPUT AS 1: INPUT #1, inst: INPUT #1, pitch: INPUT #1, transpose: CLOSE 1


GOSUB set_instr

key_del
DO: _LIMIT 150
    ak = _KEYHIT: IF ak < 0 THEN GOTO skip
    IF ak = 27 THEN GOSUB save_last: SYSTEM
    IF ak = 48 THEN GOSUB save_last: GOTO calibration

    'poly instrumental controls
    FOR ab = 0 TO buffsize - 1: IF buff(ab, 0) = ak THEN GOTO skip
    NEXT ab
    FOR t1 = 0 TO 32: FOR t2 = 0 TO key_c - 1: IF key_dat(t1, t2) <> ak THEN _CONTINUE
            FOR t = 0 TO buffsize - 1
                IF buff(t, 0) = 0 THEN
                    send = &H7F0090 + ch + 256 * (t1 + transpose): q = midiOutShortMsg(hmidiout, send): buff(t, 0) = ak: buff(t, 1) = 256 * (t1 + transpose)
                    painter(t1, 3) = 1: buff(t, 5) = t1: EXIT FOR
                END IF
            NEXT t
    NEXT t2, t1
    skip:
    IF ak < 0 THEN
        FOR ab = 0 TO buffsize - 1
            IF ABS(ak) = ABS(buff(ab, 0)) THEN
                buff(ab, 0) = 0: send = &HFF0080 + ch + buff(ab, 1): q = midiOutShortMsg(hmidiout, send)
                painter(buff(ab, 5), 3) = 0
            END IF
        NEXT ab
    END IF

    'drum instrumental controls
    IF ak <> 0 THEN
        FOR t1 = 0 TO 45: FOR t2 = 0 TO key_c - 1
                IF key_dat(t1 + 33, t2) = ak THEN

                    IF d_buff(t1) = 0 THEN send = &H7F0090 + 9 + (t1 + 32) * 256: q = midiOutShortMsg(hmidiout, send): d_buff(t1) = 1
                END IF

                IF -key_dat(t1 + 33, t2) = ak THEN d_buff(t1) = 0

        NEXT t2, t1
    END IF



    'display
    _PUTIMAGE , ori_display, act_display: _DEST act_display: FOR t = 0 TO 99: IF painter(t, 3) THEN PAINT (painter(t, 0), painter(t, 1)), colors(16), _RGB32(0, 0, 0)
    NEXT t

    'mouse command
    mw = 0: DO: mw = mw + _MOUSEWHEEL: LOOP WHILE _MOUSEINPUT: act_mc = -1: transpose = transpose - INT(mw)
    FOR t = 0 TO 127
        IF _MOUSEX > i_button(t, 0) AND _MOUSEX < i_button(t, 2) AND _MOUSEY > i_button(t, 1) AND _MOUSEY < i_button(t, 3) THEN act_mc = t: EXIT FOR
    NEXT t

    IF act_mc > -1 THEN FOR t = 2 TO 3: LINE (i_button(act_mc, 0) - t, i_button(act_mc, 1) - t)-(i_button(act_mc, 2) + t, i_button(act_mc, 3) + t), colors(1), B: NEXT t
    freq = 2 ^ ((transpose - 69 + 2) / 12) * 440
    COLOR colors(1), colors(0):
    _FONT fnt(4): _PRINTSTRING (20, 540), midi$(inst)
    _FONT fnt(5): _PRINTSTRING (20, 610), "(+" + LTRIM$(STR$(INT(transpose))) + " pitch / C-0 is " + LTRIM$(STR$(INT(freq))) + "hz)"

    _DISPLAY

    'change instrumentaé
    IF act_mc > -1 AND _MOUSEBUTTON(1) THEN
        FOR ab = 0 TO buffsize - 1
            IF (buff(ab, 0)) THEN
                buff(ab, 0) = 0: send = &HFF0080 + ch + buff(ab, 1): q = midiOutShortMsg(hmidiout, send): painter(buff(ab, 5), 3) = 0
            END IF
        NEXT ab
        inst = act_mc: GOSUB set_instr
    END IF

LOOP



set_instr: send = &H7F00C0 + ch + 256 * inst: q = midiOutShortMsg(hmidiout, send): RETURN








calibration: 'keyboard-action
monx = 900: mony = 520: mon = _NEWIMAGE(monx, mony, 32): SCREEN mon: _AUTODISPLAY
starty = 50: cols = 3: blockx_d = monx / cols: blocky_d = 16: blockx = blockx_d * .95: blocky = blocky_d * .8: block_name = .3
block_fnty = .9: block_fmax = 10: sel = 0: fnt(0) = _LOADFONT("cyberbit.ttf", blocky * block_fnty)

DO: _LIMIT 30: CLS: PAINT (0, 0), colors(0)
    _FONT fnt(1): COLOR colors(1), colors(0): _PRINTSTRING (10, (starty - _FONTHEIGHT) / 2), "Keyboard-command-editor   F2-reset,F3-save,ESC-exit": _FONT fnt(0)
    DO WHILE _MOUSEINPUT: LOOP: ax = 0: ay = 0: act_key = -1: fnt_marg = (blocky - block_fnty * blocky) / 2: COLOR colors(2), colors(1)
    FOR t1 = 0 TO 199: IF LEN(key_name$(t1)) = 0 THEN EXIT FOR
        y1 = ay * blocky_d + (blocky_d - blocky) / 2 + starty: y2 = (ay + 1) * blocky_d - (blocky_d - blocky) / 2 + starty
        x1 = ax * blockx_d + (blockx_d - blockx) / 2: x2 = (ax + 1) * blockx_d - (blockx_d - blockx) / 2: LINE (x1, y1)-(x2, y2), colors(1), BF
        x3 = x1 + blockx * block_name: LINE (x3, y1)-(x3, y2), colors(0)
        FOR x4 = 1 TO key_c - 0: psx1 = x3 + (x2 - x3) / key_c * x4: psx2 = x3 + (x2 - x3) / key_c * (x4 - 1)
            IF x4 <> key_c THEN LINE (psx1, y1)-(psx1, y2), colors(0)
            ifp = psx2 < _MOUSEX AND psx1 > _MOUSEX AND y1 < _MOUSEY AND y2 > _MOUSEY
            IF ifp THEN LINE (psx1 - sel, y1 - sel)-(psx2 + sel, y2 + sel), _RGB32(256 * RND(1), 256 * RND(1), 256 * RND(1)), B: act_key = t1: act_param = x4 - 1
            value = key_dat(t1, x4 - 1): IF value = 0 THEN value$ = "-" ELSE value$ = LTRIM$(STR$(value))
            _PRINTSTRING (psx2 + 10, y1 + fnt_marg), value$
        NEXT x4: y3 = y1 + fnt_marg: x4 = x1 + fnt_marg: _PRINTSTRING (x4, y3), LEFT$(key_name$(t1), block_fmax): ax = ax + 1: IF ax = cols THEN ax = 0: ay = ay + 1
    NEXT t1: _FONT fnt(1): COLOR colors(0), colors(1)

    IF _MOUSEBUTTON(1) = 0 THEN
        SELECT CASE ABS(_KEYHIT)

            CASE 27: q = midiOutClose(hmidiout): RUN
            CASE 15360: GOSUB standard2using: GOSUB open_using: key_del
            CASE 15616: GOSUB save_using: key_del
        END SELECT
    END IF

    IF act_key <> -1 AND _MOUSEBUTTON(1) = 0 THEN
        a$ = "Keep Left-Mouse to change !": _PRINTSTRING (monx - 20 - _PRINTWIDTH(a$), (starty - _FONTHEIGHT) / 2), a$: key_del
    END IF

    IF act_key <> -1 AND _MOUSEBUTTON(1) THEN
        a$ = "Press the appropriate key (or delete)!": _PRINTSTRING (monx - 20 - _PRINTWIDTH(a$), (starty - _FONTHEIGHT) / 2), a$
        act_keyhit = ABS(_KEYHIT): IF act_keyhit = 21248 THEN act_keyhit = 0: key_dat(act_key, act_param) = 0
        IF act_keyhit <> 0 THEN key_dat(act_key, act_param) = act_keyhit
    END IF


    _DISPLAY
LOOP

END




open_using: OPEN "using.kcl" FOR INPUT AS 1
FOR t1 = 0 TO 199: FOR t2 = 0 TO 9: INPUT #1, key_dat(t1, t2): NEXT t2, t1: CLOSE 1
RETURN

save_using:
OPEN "using.kcl" FOR OUTPUT AS 1: FOR t1 = 0 TO 199: FOR t2 = 0 TO 9: PRINT #1, key_dat(t1, t2): NEXT t2, t1: CLOSE 1: RETURN



display_loader:
ori_display = _LOADIMAGE("bord07.bmp", 32)
act_display = _NEWIMAGE(_WIDTH(ori_display), _HEIGHT(ori_display), 32)
_SOURCE ori_display: _DEST ori_display
FOR ax = 0 TO _WIDTH(ori_display) - 1
    FOR ay = 0 TO _HEIGHT(ori_display) - 1
        colors(19) = POINT(ax, ay)
        IF colors(19) = colors(18) THEN

            painter(p_c, 0) = ax
            painter(p_c, 1) = ay
            painter(p_c, 2) = POINT(ax + 1, ay + 1)
            PSET (ax, ay), painter(p_c, 2)
            p_c = p_c + 1
        END IF
NEXT ay, ax

_FONT fnt(3)
startx = 20
starty = 20
disx = 100
disy = 50
COLOR _RGB32(255, 255, 255), colors(0)
FOR t1 = 0 TO 7: FOR t2 = 0 TO 7: FOR t3 = 0 TO 1
            px = startx + t1 * 140: py = starty + t2 * (_FONTHEIGHT + 10) + t3 * 260
            a_butt = 64 * t3 + 8 * t1 + t2: i$ = LEFT$(midi$(a_butt), 12): _PRINTSTRING (px, py), i$
            i_button(a_butt, 0) = px: i_button(a_butt, 1) = py
            i_button(a_butt, 2) = px + _PRINTWIDTH(i$): i_button(a_butt, 3) = py + _FONTHEIGHT
NEXT t3, t2, t1
RETURN

standard2using:
OPEN "standard.kcl" FOR INPUT AS 1: OPEN "using.kcl" FOR OUTPUT AS 2
FOR t1 = 0 TO 199: FOR t2 = 0 TO 9: INPUT #1, value: PRINT #2, value: NEXT t2, t1: CLOSE 1, 2
RETURN


save_last:
OPEN "last.dat" FOR OUTPUT AS 1: PRINT #1, inst: PRINT #1, pitch: PRINT #1, transpose: CLOSE 1: RETURN


SUB key_del: DO WHILE _KEYHIT: LOOP: END SUB











