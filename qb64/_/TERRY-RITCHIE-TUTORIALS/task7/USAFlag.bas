'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST RED = _RGB32(127, 0, 0) '     define colors
CONST WHITE = _RGB32(255, 255, 255)
CONST BLUE = _RGB32(0, 0, 127)
DIM x% '                            x location of objects
DIM y% '                            y location of objects

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 467, 32) '                     graphics screen 640 by 467
CLS , WHITE '                                     or LINE (0, 0) - (639, 466), WHITE, BF
FOR y% = 0 TO 467 STEP 72 '                          loop 7 times for red stripes
    LINE (0, y%)-(639, y% + 35), RED, BF '           draw red stripe half the step size
NEXT y%
LINE (0, 0)-(309, 251), BLUE, BF '                   draw blue banner
FOR y% = 25 TO 225 STEP 50 '                         loop in steps of 50
    FOR x% = 30 TO 280 STEP 50 '                     loop in steps of 50
        CIRCLE (x%, y%), 10, WHITE '                 draw outer circle at x,y coordinate
        PAINT (x%, y%), WHITE, WHITE '               paint circle
        IF x% < 280 AND y% < 225 THEN '              will circle be within banner?
            CIRCLE (x% + 25, y% + 25), 10, WHITE '   yes, draw inner circle
            PAINT (x% + 25, y% + 25), WHITE, WHITE ' paint circle
        END IF
    NEXT x%
NEXT y%
SLEEP '                                              wait for key press

'-----------------------------------
'- Function and Subroutine section -
'-----------------------------------

SUB Star (x%, y%)
    '
    '* draws a solid star at x,y coordinate
    '
    LINE (x% - 10, y% - 3)-(x% + 10, y% - 3), 15
    LINE -(x% - 7, y% + 7), 15
    LINE -(x%, y% - 10), 15
    LINE -(x% + 7, y% + 7), 15
    LINE -(x% - 10, y% - 3), 15
    PAINT (x%, y%), 15, 15
    PAINT (x% - 5, y% - 1), 15, 15
    PAINT (x% + 5, y% - 1), 15, 15
    PAINT (x%, y% - 4), 15, 15
    PAINT (x% - 3, y% + 3), 15, 15
    PAINT (x% + 3, y% + 3), 15, 15

END SUB


