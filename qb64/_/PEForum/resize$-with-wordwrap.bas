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
ml = 0: mr = ml
w = _WIDTH - (ml + mr)
DO
    _LIMIT 30
    x$ = "In West          Los      Angeles born    and raised,    at                    the yacht club is where I spent most of my days, 'til a couple of coders who were up to no good, started making trouble in my neighborhood. I got booted off Discord and my vids wouldn't play, so I moved to the hills in the State of VA. I pulled up to the forum 'bout a week into April and I yelled to the browser, 'Save password log in later!' Now I'm able to post and my speech is still free as I sit on my throne as the Prince of P.E."
    x$ = "In West Los Angeles born and raised, at the yacht club is where I spent most of my days, 'til a couple of coders who were up to no good, started making trouble in my neighborhood. I got booted off Discord and my vids wouldn't play, so I moved to the hills in the State of VA. I pulled up to the forum 'bout a week into April and I yelled to the browser, 'Save password log in later!' Now I'm able to post and my speech is still free as I sit on my throne as the Prince of P.E."
    w2 = w - (ml + mr)
    CLS
    LOCATE 2
    DO
        WHILE -1
            t$ = MID$(x$, 1, w2)
            chop = 1
            IF w2 <> 1 THEN
                DO
                    IF LEFT$(t$, 1) = " " THEN
                        ' Only happens with more than 1 space between characters.
                        IF LTRIM$(t$) = "" THEN EXIT DO ELSE x$ = LTRIM$(x$): EXIT WHILE
                    END IF

                    IF MID$(x$, w2 + 1, 1) <> " " AND LTRIM$(t$) <> "" THEN ' Now we have to chop it.
                        IF INSTR(x$, " ") > 1 AND INSTR(t$, " ") <> 0 AND LEN(x$) > w2 THEN
                            t$ = MID$(t$, 1, _INSTRREV(t$, " ") - 1)
                            chop = 2
                        END IF
                    ELSE
                        chop = 2
                    END IF
                    EXIT DO
                LOOP
                x$ = MID$(x$, LEN(t$) + chop)
            ELSE
                x$ = MID$(x$, LEN(t$) + 1)
            END IF
            IF LEN(t$) AND CSRLIN < _HEIGHT - 1 THEN LOCATE , ml + 1: PRINT LTRIM$(t$)
            EXIT WHILE
        WEND
    LOOP UNTIL LEN(t$) AND LEN(LTRIM$(x$)) = 0
    oldsw = Sw: oldsh = Sh
    IF _RESIZE THEN
        Sw = _RESIZEWIDTH \ _FONTWIDTH
        Sh = _RESIZEHEIGHT \ _FONTHEIGHT
        IF oldsw <> Sw OR oldsh <> Sh THEN
            w = Sw
            S& = _NEWIMAGE(Sw, Sh, 0)
            SCREEN S&
            _FONT font&
            PALETTE 0, 8
        END IF
    ELSE
        DO
            _LIMIT 30
            IF _RESIZE THEN EXIT DO
            b$ = INKEY$
            IF LEN(b$) THEN
                IF b$ = CHR$(27) THEN SYSTEM
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