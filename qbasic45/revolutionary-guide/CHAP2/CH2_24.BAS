REM External program to demo passed variables
REM PROGRAMS\CHAP_2\CH2_24.BAS

COMMON SHARED x, y
DECLARE SUB CalcSin (x)

CALL CalcSin(x)
PRINT "External:"
PRINT "y("; x; ")="; y

END

SUB CalcSin (x)
    y = SIN(x)
END SUB 

 
