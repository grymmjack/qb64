REM Specifying a multi-line user function
REM PROGRAMS\CHAP_2\CH2_20.BAS

CLS
x = 5
e = 2
z = 3

DEF FNHSN (x)
    e = EXP(x)
    z = e - 1 / e
    FNHSN = z / 2
END DEF

y = FNHSN(1)
PRINT "HSN(1)="; y
PRINT "x ="; x
PRINT "e ="; e
PRINT "z ="; z

END 
 
