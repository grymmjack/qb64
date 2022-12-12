REM The illustration of the LBOUND and UBOUND functions
REM \CHAP4\CH4_2.BAS

CLS
DIM D%(80 TO 90, 1 TO 5)
D%(88, 2) = 2.34
D%(90, 3) = 5.67
PRINT D%(88, 2), D%(90, 3)
PRINT "LBOUND (D%,1)="; LBOUND(D%, 1)
PRINT "UBOUND (D%,1)="; UBOUND(D%, 1)
PRINT "LBOUND (D%,2)="; LBOUND(D%, 2)
PRINT "UBOUND (D%,2)="; UBOUND(D%, 2)

END 
