DIM AS LONG HWscreen, SWscreen, DisplayScreen, TempScreen
DisplayScreen = _NEWIMAGE(1280, 720, 32)
SWscreen = _NEWIMAGE(64, 8, 32)
TempScreen = _NEWIMAGE(64, 8, 32)

'draw a few characters for screen display
_DEST TempScreen 'make a temp software screen to print on
_FONT 8 'size 8 font
_PRINTSTRING (0, 0), "Hardware" 'print the word "Hardware"
HWscreen = _COPYIMAGE(TempScreen, 33) 'make a copy of that temp screen as a hardware screen
_FREEIMAGE TempScreen 'free the temp screen


_DEST SWscreen 'Draw on a software screen
_FONT 8 'same size font 8
_PRINTSTRING (0, 0), "Software" 'And print the word Software on this screen
_DEST DisplayScreen
SCREEN DisplayScreen

HardwareMode = 0 'let's start out in software mode


xdirection = 1: ydirection = 1

DO

    IF TIMER > t# THEN
        IF FPS > maxFPS THEN maxFPS = FPS
        _TITLE "FPS:" + STR$(FPS) + " -- MaxFPS:" + STR$(maxFPS)
        t# = TIMER
        FPS = 0
    ELSE
        FPS = FPS + 1
    END IF

    x = x + xdirection
    y = y + ydirection
    IF x < 0 OR x > _WIDTH THEN xdirection = -xdirection
    IF y < 0 OR y > _HEIGHT THEN ydirection = -ydirection


    IF HardwareMode THEN
        _DISPLAYORDER _HARDWARE
        _PUTIMAGE (x, y), HWscreen
    ELSE
        _DISPLAYORDER _SOFTWARE
        CLS
        _PUTIMAGE (x, y), SWscreen, DisplayScreen
    END IF
    k = _KEYHIT
    SELECT CASE k
        CASE 27: SYSTEM
        CASE ASC("H"), ASC("h"): HardwareMode = -1: maxFPS = 0: FPS = 0
        CASE ASC("S"), ASC("s"): HardwareMode = 0: maxFPS = 0: FPS = 0
    END SELECT
    _DISPLAY
LOOP
