REM Demonstration of the PALETTE and LINE statements
REM \CHAP3\CH3_12.BAS
 
PALETTE 0, 1
SCREEN 1
FOR i% = 0 TO 3: a%(i%) = i%: NEXT i%
LINE (138, 35)-(288, 165), 3, bf
LINE (20, 10)-(160, 100), 2, bf
DO
    FOR i% = 0 TO 3
        a%(i%) = (a%(i%) + 1) MOD 16
    NEXT i%
    LOCATE 1, 16
    PRINT "PALETTE "; a%(0)
    s$ = INPUT$(1)
    PALETTE USING a%(0)
LOOP UNTIL a%(0) = 15
F$ = INPUT$(1)

END