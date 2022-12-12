REM Demonstration of the SCREEN statement
REM \CHAP3\CH3_6.BAS
 
SCREEN 0, 1, 1, 0
CLS
PRINT "Hello!"
f$ = INPUT$(1)
SCREEN 0, 1, 0, 1
f$ = INPUT$(1)

END