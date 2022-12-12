REM Specifying and calling a procedure
REM PROGRAMS\CHAP_2\CH2_25.BAS

DECLARE SUB CalcSin (x, y AS DOUBLE)
CLS
INPUT "Enter x ="; x
CALL CalcSin(x, y#)
PRINT "y("; x; ")="; y#

END

SUB CalcSin (x, y AS DOUBLE)
    y = SIN(x)
END SUB 

 
