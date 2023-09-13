SCREEN 0 'I'm going to use a text only screen
tempHWscreen = _NEWIMAGE(64, 40, 32)
_DEST tempHWscreen
CLS , &HFFFF0000 'just color that little 64x40 block of screen RED
HWscreen = _COPYIMAGE(tempHWscreen, 33)
_FREEIMAGE tempHWscreen

xdirection = 1: ydirection = 1
DO
    CLS
    FOR i = 0 TO 16
        COLOR i, 8 - INT(i / 2)
        PRINT "Screen 0 Colors!  This is COLOR "; i, 8 - INT(i / 2)
    NEXT
    x = x + xdirection: y = y + ydirection
    IF x < 0 OR x > 640 THEN xdirection = -xdirection
    IF y < 0 OR y > 400 THEN ydirection = -ydirection
    _PUTIMAGE (x, y), HWscreen
    _DISPLAY
    _LIMIT 100
LOOP UNTIL _KEYHIT
SYSTEM
