_CONTROLCHR OFF
$RESIZE:SMOOTH
Sw = 60
Sh = 25
S& = _NEWIMAGE(Sw, Sh, 0)
SCREEN S&
DO: LOOP UNTIL _SCREENEXISTS
font& = _LOADFONT(ENVIRON$("SYSTEMROOT") + "\fonts\lucon.ttf", 18, "MONOSPACE")
_FONT font&
PALETTE 0, 8
COLOR 15, 0
_SCREENMOVE 10, 10
_DELAY .2
ml = 2: mr = ml
w = _WIDTH - (ml + mr)
DIM cnt(1000), ls(1000), ts(1000), cc(1000), cline(1000)
DO
    _LIMIT 30
    z$ = "In West          Los Angeles born        and raised, at the                  yacht club is where I spent most of my days, 'til a couple of coders who were up to no good, started making trouble in my neighborhood. I got booted off Discord and my vids wouldn't play, so I moved to the hills in the State of VA. I pulled up to the forum 'bout a week into April and I yelled to the browser, 'Save password log in later!' Now I'm able to post and my speech is still  free as I sit on my  throne as the Prince of P.E."
    ''z$ = "In West Los Angeles born and raised, at the yacht club is where I spent most of my days, 'til a couple of coders who were up to no good, started making trouble in my neighborhood. I got booted off Discord and my vids wouldn't play, so I moved to the hills in the State of VA. I pulled up to the forum 'bout a week into April and I yelled to the browser, 'Save password log in later!' Now I'm able to post and my speech is still free as I sit on my throne as the Prince of P.E."
    x$ = z$
    i = w - (ml + mr)
    IF i > 0 THEN w2 = w - (ml + mr)
    ERASE ls, ts, cc, cline
    CLS
    LOCATE 2
    cnt = 0: lspace = 0: tspace = 0: cc = 0
    COLOR 15, 0
    DO
        WHILE -1
            t$ = MID$(x$, 1, w2)
            cnt = cnt + 1: cc(cnt) = cc
            chop = 1: addon = 0
            IF w2 <> 1 THEN ' All instances except single column vertical printing.
                IF LEFT$(t$, 1) = " " THEN ' Only happens with more than 1 space between characters.
                    IF LTRIM$(t$) = "" THEN ' All spaces so print a blank line.
                        addon = LEN(t$)
                    ELSE ' Push back leading spaces.
                        lspace = LEN(t$) - LEN(LTRIM$(t$)): x$ = LTRIM$(x$): cnt = cnt - 1
                        EXIT WHILE '  This will now redo the outer loop.
                    END IF
                ELSEIF MID$(x$, w2 + 1, 1) <> " " AND LTRIM$(t$) <> "" THEN ' Now we have to chop it.
                    IF INSTR(x$, " ") > 1 AND INSTR(t$, " ") <> 0 AND LEN(x$) > w2 THEN
                        t$ = MID$(t$, 1, _INSTRREV(t$, " ")) ' Preserves the in-margin trailing space.
                    END IF
                ELSE
                    chop = 2: tspace = 1
                END IF
                x$ = MID$(x$, LEN(t$) + chop)
            ELSE
                x$ = MID$(x$, LEN(t$) + 1)
                IF t$ = " " THEN cc = cc + 1 ' Compensate for LEN(LTRIM$(t$)) = 0 a few lines below.
            END IF
            ls(cnt) = ls(cnt - 1) + lspace: lspace = 0
            cc(cnt) = cc: cline(cnt) = LEN(t$)
            ts(cnt) = ts(cnt - 1) + tspace: tspace = 0
            IF LEN(t$) AND CSRLIN < _HEIGHT - 1 THEN
                REM LOCATE , 1: PRINT cc(cnt); ls(cnt); ts(cnt - 1); cline(cnt);
                LOCATE , ml + 1: PRINT LTRIM$(t$) '<----------------------------------- PRINT TO SCREEN.
            END IF
            cc = cc + lspace + tsapce + LEN(LTRIM$(t$)) + addon
            EXIT WHILE
        WEND
    LOOP UNTIL LEN(LTRIM$(x$)) = 0
    oldsw = Sw: oldsh = Sh
    IF _RESIZE THEN
        oldmy = 0: oldmx = 0: oldmy2 = 0: oldmx2 = 0: oldm$ = ""
        Sw = _RESIZEWIDTH \ _FONTWIDTH
        Sh = _RESIZEHEIGHT \ _FONTHEIGHT
        IF oldsw <> Sw OR oldsh <> Sh THEN
            w = Sw
            S_old& = S&
            S& = _NEWIMAGE(Sw, Sh, 0)
            SCREEN S&
            _FREEIMAGE S_old&
            _FONT font&
            PALETTE 0, 8
        END IF
    ELSE
        DO
            _LIMIT 30
            IF _RESIZE THEN EXIT DO
            WHILE _MOUSEINPUT: WEND
            mx = _MOUSEX
            my = _MOUSEY
            m$ = CHR$(SCREEN(my, mx)): hl = 0
            IF my > 1 AND my <= cnt + 1 THEN
                IF my <> oldmy2 OR mx <> oldmx2 THEN
                    IF mx > ml AND mx <= ml + cline(my - 1) THEN
                        IF oldmy2 THEN LOCATE oldmy2, oldmx2: COLOR 15, 0: PRINT oldm$;
                        LOCATE my, mx: COLOR 0, 15: PRINT m$;: COLOR 15, 0
                        LOCATE _HEIGHT - 1, 2: PRINT "Row"; my - 1; " Col"; mx - ml; " #"; LTRIM$(STR$(cc(my - 1) + (mx - ml) + ls(my - 1) + ts(my - 2))); " "; MID$(z$, cc(my - 1) + (mx - ml) + ls(my - 1) + ts(my - 2), 1); "    ";
                        oldmy2 = my: oldmx2 = mx: oldm$ = m$: hl = -1
                    END IF
                END IF
            END IF
            IF hl THEN IF my <> oldmy2 OR mx <> oldmx2 THEN COLOR 15, 0: LOCATE oldmy2, oldmx2: PRINT oldm$;
            oldmy = my: oldmx = mx
            b$ = INKEY$
            IF LEN(b$) THEN
                IF b$ = CHR$(27) THEN SYSTEM
                oldmy = 0: oldmx = 0: oldmy2 = 0: oldmx2 = 0: oldm$ = ""
                SELECT CASE MID$(b$, 2, 1)
                    CASE "M"
                        IF ml < _WIDTH \ 2 THEN ml = ml + 1: mr = mr + 1
                        EXIT DO
                    CASE "K"
                        IF ml > 0 THEN ml = ml - 1: mr = mr - 1
                        EXIT DO
                END SELECT
            END IF
        LOOP
    END IF
LOOP