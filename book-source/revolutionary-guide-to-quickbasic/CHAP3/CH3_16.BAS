REM Application of the VIEW statement
REM \CHAP3\CH3_16.BAS
 
SCREEN 1: CLS : KEY OFF
GOSUB Figure
LOCATE 1, 1: PRINT "Drawing circles"
VIEW (140, 50)-(240, 150)
GOSUB Figure
LOCATE 7, 15: PRINT "Drawing after VIEW"
f$ = INPUT$(1)
 
END

Figure:
FOR r = 5 to 45 STEP 5
    CIRCLE (55, 50), r
NEXT r
RETURN