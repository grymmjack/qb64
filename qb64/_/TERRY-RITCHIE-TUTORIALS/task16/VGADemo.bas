DIM c% ' current color
DIM x% ' x location of color box
DIM y% ' y location of color box

SCREEN _NEWIMAGE(640, 480, 256) '                   256 color VGA screen
CLS '                                               clear the screen
c% = 0 '                                            reset color
FOR y% = 0 TO 479 STEP 30 '                         16 boxes vertical
    FOR x% = 0 TO 639 STEP 40 '                     16 boxes horizontal
        LINE (x%, y%)-(x% + 39, y% + 29), c%, BF '  draw color box
        LOCATE 2, 1 '                               place text cursor
        PRINT c%; '                                 print color value
        c% = c% + 1 '                               increment color value
        _DELAY .0125 '                              short pause
    NEXT x%
NEXT y%
SLEEP '                                             wait for key stroke
SYSTEM '                                            return to operating system

