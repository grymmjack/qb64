REM Use of STATIC keyword
REM PROGRAMS\CHAP_2\CH2_21.BAS

DECLARE FUNCTION ADDITION (X)
 
total = 0
CLS
x = 2
FOR n = 1 TO 10
    y = ADDITION(x)
    PRINT "ADDITION("; x; ")="; y; "  "; "TOTAL (Mainbody) = "; total
NEXT n

END

FUNCTION ADDITION (x) STATIC
    total = total + x
    ADDITION = total
END FUNCTION 
 
