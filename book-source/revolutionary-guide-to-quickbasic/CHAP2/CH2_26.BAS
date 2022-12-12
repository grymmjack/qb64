REM Combined Application of Functions and Procedures
REM PROGRAMS\CHAP_2\CH2_26.BAS

DECLARE SUB InpPrt ()
DECLARE FUNCTION GAMMA! (x!)
CLS
PRINT "CALCULATION OF GAMMA-FUNCTION"
CALL InpPrt

END

FUNCTION GAMMA (x)
    CONST Pi = 3.141592654#
    z = x
    FOR i = 1 TO 20
        z = z * (x + i)
    NEXT i
    b = x + 21: b1 = EXP(b * (LOG(b) - 1) + 1 / 12 / b)
    GAMMA = b1 * SQR(2 * pi / b) / z
END FUNCTION

SUB InpPrt
    DO
        INPUT "INPUT X ="; x
        PRINT "g(x)="; GAMMA(x)
        INPUT "REPEAT (y/n)"; m$
    LOOP UNTIL m$ = "n" OR m$ = "n"
END SUB

 
