REM Specifying a user function
REM PROGRAMS\CHAP_2\CH2_19.BAS

CLS
x = 5

DEF FNS (x) = (EXP(x) - EXP(-x)) / 2

y = FNS(1)
PRINT "HSN(1)="; y
PRINT "x="; x

END 
 
