REM Part two of 'direct VRAM access' v 'Built-in commands'
REM \CHAP8\CH8_3.BAS

CLS
t0 = TIMER
FOR A% = 0 TO 1999
    PRINT "H";
NEXT
LOCATE 1, 1: PRINT TIMER - t0; "  ";

