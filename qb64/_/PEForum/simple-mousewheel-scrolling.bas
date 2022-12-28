FOR i = 1 TO 50
    REDIM _PRESERVE c$(i) 
    c$(i) = LTRIM$(STR$(i))
NEXT
WIDTH 80, 25
idx = -1: GOSUB dsp

DO
    _LIMIT 60
    WHILE _MOUSEINPUT
        mw = mw + _MOUSEWHEEL
    WEND
    IF mw <> oldmw THEN
        adj = SGN(mw - oldmw): mw = 0
        IF idx > 0 AND adj < 0 OR idx <= UBOUND(c$) - (_HEIGHT - 1) AND adj > 0 THEN GOSUB dsp
    END IF
    oldmw = mw
LOOP

dsp:
CLS
IF idx < 0 THEN
    idx = UBOUND(c$) - (_HEIGHT - 2)
    IF idx <= 1 THEN idx = 0
ELSE
    idx = idx + adj
END IF
LOCATE 1, 1
i = idx: j = 0
DO
    i = i + 1
    j = j + 1: LOCATE j, 1
    PRINT c$(i)
LOOP UNTIL CSRLIN = _HEIGHT - 1 OR i = UBOUND(c$)
RETURN