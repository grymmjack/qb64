REM Operator CIRCLE - example 1
REM \CHAP3\CH3_13.BAS
 
SCREEN 2: CLS
FOR radius = 1 to 200 STEP 3
    CIRCLE (320, 100), radius
NEXT radius
m$ = INPUT$(1)

END