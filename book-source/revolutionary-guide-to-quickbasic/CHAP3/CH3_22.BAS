REM Using Point for CopyScreen
REM \CHAP3\CH3_22.BAS
  
DEFINT i-j
x = 71: y = 10: m = 2
SCREEN 1: KEY OFF: CLS
FOR r = 1 to 30 STEP 3
    CIRCLE (32, 35), r, 3, , , .65
NEXT r
LOCATE 3, 2: PRINT "Hello!"
FOR i = 0 to 70
    FOR j = 0 to 70
        sp = POINT(i, j)
        x1 = X + i * m: y1 = y + j * m
        LINE (x1, y1)-(x1 + (s - 1), y1 + (s - 1)), sp, bf
    NEXT j
NEXT i
LOCATE 17, 6
PRINT "This is new large figure!"
f$ = INPUT$(1)

END

