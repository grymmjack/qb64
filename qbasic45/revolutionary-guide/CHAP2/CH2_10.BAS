REM Demonstration of the IS modifier
REM PROGRAMS\CHAP_2\CH2_10.BAS

CLS
INPUT "Enter your decimal fraction (between 0 and 1) : "; entry
SELECT CASE entry
    CASE IS < .5  : PRINT "Round number down"
    CASE IS >= .5 : PRINT "Round number up"       
END SELECT

END  
