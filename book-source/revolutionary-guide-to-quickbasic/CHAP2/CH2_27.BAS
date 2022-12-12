REM Calculating the Array of Values
REM PROGRAMS\CHAP_2\CH2_27.BAS

DECLARE SUB EvalProgram (f$, Maxx)
COMMON flag%, x(), y(), f$     
MaxX = 20                      
IF flag% = 0 THEN
    CLS
    DIM x(0 TO Maxx): DIM y(0 TO Maxx)
    INPUT "Input function: y = ", f$
    INPUT "Input Xmin = ", x(0)
    INPUT "Input Xmax = ", x(Maxx)
    increment = (X(Maxx) - x(0)) / Maxx
    FOR i% = 1 TO Maxx          
        x(i%) = x(i% - 1) + increment
    NEXT i%
    CALL EvalProgram(f$, MaxX)
    flag% = -1
    PRINT : PRINT "Loading EVALUATE.BAS. Please wait!"
    CHAIN "EVAL"            
ELSE
    CLS : PRINT "Array X  and", " y="; f$
    FOR i% = 0 TO (MaxX)
        PRINT x(i%), y(i%)
    NEXT
    p$ = INPUT$(1)
END IF

END

SUB EvalProgram (f$, Maxx)
    OPEN "EVAL.BAS" FOR OUTPUT AS #1 
    PRINT #1, "COMMON flag%, x(), y(), f$" 
    PRINT #1, "FOR i% = 0 TO " + STR$(Maxx)
    PRINT #1, "  x = x(i%)"
    PRINT #1, "  y(i%) = " + f$
    PRINT #1, "NEXT i%"
    PRINT #1, "CHAIN " + CHR$(34) + "a:\PROGRAMS\EVAL.BAS " + CHR$(34)
    CLOSE #1
END SUB