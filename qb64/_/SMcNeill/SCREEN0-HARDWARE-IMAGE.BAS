SCREEN 0 'I'm going to use a text only screen
mode = -1
paused = 0
tempHWscreen = _NEWIMAGE(64*2, 40*2, 32)
_DEST tempHWscreen
CLS , &HCCFF0000 'just color that little 64x40 block of screen RED
_BLEND
COLOR &HFFFFFFFF: _PRINTMODE _KEEPBACKGROUND: _PRINTSTRING (35, 25), "HARDWARE"
_DONTBLEND
COLOR 0: _PRINTMODE _FILLBACKGROUND: _PRINTSTRING (20, 45), CHR$(219) + " HARDWARE " + CHR$(219)
HWscreen = _COPYIMAGE(tempHWscreen, 33)
_FREEIMAGE tempHWscreen
xdirection = 1: ydirection = 1
DO
    k = _KEYHIT
    IF mode THEN
        _DISPLAYORDER _SOFTWARE, _HARDWARE
    ELSE
        _DISPLAYORDER _HARDWARE, _SOFTWARE
    END IF
    CLS
    COLOR 11
    IF paused THEN p$ = "Unpause" ELSE p$ = "Pause"
    PRINT "[SPACE]=Change _DISPLAYORDER, [ENTER]="+p$+", [ESC]=Quit";
    IF paused THEN PRINT "   * PAUSED *";
    PRINT
    FOR i = 0 TO 16
        COLOR i, 8 - INT(i / 2)
        PRINT "Screen 0 Colors!  This is COLOR "; i, 8 - INT(i / 2)
    NEXT
    PRINT
    COLOR 14
    IF mode THEN
        PRINT "_DISPLAYORDER _SOFTWARE, _HARDWARE (DEFAULT hardware on top of software)"
    ELSE
        PRINT "_DISPLAYORDER _HARDWARE, _SOFTWARE (software on top of hardware)"
    END IF
    IF NOT paused THEN
        x = x + xdirection: y = y + ydirection
        IF x < 0 OR x > 640 THEN xdirection = -xdirection
        IF y < 0 OR y > 400 THEN ydirection = -ydirection
    END IF
    _PUTIMAGE (x, y), HWscreen
    _DISPLAY
    _LIMIT 60
    IF k=32 THEN mode = NOT mode
    IF k=13 THEN paused = NOT paused
LOOP UNTIL k=27
SYSTEM