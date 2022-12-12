REM Version of 5.7, showing COMMON without SHARED
REM PROGRAMS\CHAP_2\CH2_23.BAS

DECLARE SUB CalcSin (x)

COMMON x, y
x = 0
y = 0
CLS
INPUT "Input X="; x
CALL CalcSin(x)
PRINT "Internal:"
PRINT "Y("; x; ")="; y
CHAIN "a:\PROGRAM\CHAP_02\CH2_23.BAS”

END

SUB CalcSin (x)
    y = SIN(x)
END SUB

 
