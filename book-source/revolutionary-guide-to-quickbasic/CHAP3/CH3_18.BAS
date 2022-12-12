REM Demonstration of the WINDOW statement
REM \CHAP3\CH3_18.BAS

SCREEN 1: CLS : KEY OFF
WINDOW SCREEN (0, 2)-(2, 0)
FOR r = .05 to .65 STEP .05
    CIRCLE (1, 1), r, , , , r
NEXT r
LOCATE 3, 9
PRINT "Drawing in mathematical"
LOCATE 4, 12
PRINT "coordinate system"
f$ = INPUT$(1)

END 
