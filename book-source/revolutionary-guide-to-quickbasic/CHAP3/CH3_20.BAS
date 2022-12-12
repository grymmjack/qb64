REM Demonstration of VIEW and WINDOW
REM \CHAP3\CH3_20.BAS

SCREEN 1: CLS : KEY OFF
LINE (9, 9)-(161, 161), , b 'Drawing a box
VIEW (10, 10)-(160, 160)
WINDOW (-15.7, -1)-(15.7, 1)
'Drawing function SIN(x)/x
PSET (-15.7, 0)
FOR x = -15.7 TO 15.7 Step .1
    LINE -(x, SIN(x)/x)
NEXT x
LOCATE 7, 23: PRINT "Plotting"
LOCATE 9, 23: PRINT "function"
LOCATE 11, 23: PRINT "SIN(x)/x "
f$ = INPUT$(1)

END 
