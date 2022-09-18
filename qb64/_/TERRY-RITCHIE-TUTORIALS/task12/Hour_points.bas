PI2 = 8 * ATN(1) '                        2 * pi
arc! = PI2 / 12 '                         arc interval between hour circles
SCREEN 12
FOR t! = 0 TO PI2 STEP arc!
    cx% = CINT(COS(t!) * 70) '            pixel columns (circular radius = 70)
    cy% = CINT(SIN(t!) * 70) '            pixel rows
    CIRCLE (cx% + 320, cy% + 240), 3, 12
    PAINT STEP(0, 0), 9, 12
NEXT t!

