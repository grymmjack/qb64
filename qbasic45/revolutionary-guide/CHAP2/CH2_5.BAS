REM Application of the IF, ELSEIF and END IF statements
REM PROGRAMS\CHAP_2\CH2_5.BAS
  
CLS
INPUT "Enter a number x="; x
IF x < 0 THEN
    PRINT "The number x is smaller than 0"
     s = -1
ELSEIF x > 0 THEN
    PRINT "The number x is greater than 0"
    s = 1
ELSEIF x = 0 THEN
    PRINT "The number x is equal to 0"
    s = 0
END IF
PRINT "The sign of the number is "; s
 
END  
