REM Organizing a subroutine using the GOSUB and RETURN statements
REM PROGRAMS\CHAP_2\CH2_18.BAS
 
x = 1: CLS
GOSUB HSN: 
PRINT "HSN("; x; ")="; y: 
PRINT "E ="; e

END

HSN: 
e = EXP(x)
y = (e - 1 / e) / 2
RETURN 
 
