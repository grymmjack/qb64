SCREEN _NEWIMAGE(640, 480, 32)
x1! = 320
y1! = 240
DO
    PRESET (x1!, y1!), _RGB(255, 255, 255)
    dummy% = _MOUSEINPUT
    x2! = _MOUSEX
    y2! = _MOUSEY
    LINE (x1, y1)-(x2, y2), _RGB(255, 0, 0)
    LOCATE 1, 1: PRINT getangle(x1!, y1!, x2!, y2!)
    _DISPLAY
    _LIMIT 200
    CLS
LOOP UNTIL INKEY$ <> ""
END

FUNCTION getangle# (x1#, y1#, x2#, y2#) 'returns 0-359.99...
    IF y2# = y1# THEN
        IF x1# = x2# THEN EXIT FUNCTION
        IF x2# > x1# THEN getangle# = 90 ELSE getangle# = 270
        EXIT FUNCTION
    END IF
    IF x2# = x1# THEN
        IF y2# > y1# THEN getangle# = 180
        EXIT FUNCTION
    END IF
    IF y2# < y1# THEN
        IF x2# > x1# THEN
            getangle# = ATN((x2# - x1#) / (y2# - y1#)) * -57.2957795131
        ELSE
            getangle# = ATN((x2# - x1#) / (y2# - y1#)) * -57.2957795131 + 360
        END IF
    ELSE
        getangle# = ATN((x2# - x1#) / (y2# - y1#)) * -57.2957795131 + 180
    END IF
END FUNCTION

