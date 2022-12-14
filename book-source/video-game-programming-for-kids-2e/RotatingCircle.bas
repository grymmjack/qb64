_TITLE "Rotating Circle"
SCREEN _NEWIMAGE(800, 600, 32)
blue& = _RGB(0, 0, 255)
angle = 0
DO
    CLS
    angle = angle + 0.5
    x = 400 + COS(angle * 3.14 / 180) * 200
    y = 300 + SIN(angle * 3.14 / 180) * 200

    FillCircle x, y, 100, blue&

    _DISPLAY
LOOP UNTIL INKEY$ = CHR$(27)
SYSTEM

SUB FillCircle (X, Y, Rad, Col)
CIRCLE (X, Y), Rad, Col
PAINT (X, Y), Col
END SUB

