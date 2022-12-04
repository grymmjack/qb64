REM Specifying and calling a procedure
REM PROGRAMS\CHAP_2\CH2_22.BAS

DECLARE SUB CalcSin (x)
COMMON SHARED x, y
x = 0: y = 0
CLS
INPUT "Input x ="; x
CALL CalcSin(X)
PRINT "y("; x; ")="; y

END

SUB CalcSin (x)
    y = SIN(x)
END SUB

 
