_TITLE "Mouse Demo"
SCREEN _NEWIMAGE(800, 600, 32)

DO
    mouse = _MOUSEINPUT
    mouse_x = _MOUSEX
    mouse_y = _MOUSEY

    _PRINTSTRING (300, 200), "MOUSE XY = " + STR$(mouse_x) + "," + STR$(mouse_y)


LOOP UNTIL INKEY$ = CHR$(27)
SYSTEM

