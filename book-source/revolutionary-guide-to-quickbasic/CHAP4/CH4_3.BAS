REM Defining and rededining a dynamic array
REM \CHAP4\CH4_3.BAS

'$DYNAMIC
CLS
DIM A(80 TO 90, 10) AS INTEGER, B(20)
PRINT "Defining array A"
A(89, 5) = 123.456
PRINT B(12), A(89, 5)
ERASE A
REDIM A(80 TO 90, 10)
PRINT "Redefining array A"
A(85, 5) = 456.78
PRINT A(89, 5), A(85, 5)

END 
