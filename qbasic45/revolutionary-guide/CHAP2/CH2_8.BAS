REM Application of the TO statement for range testing
REM PROGRAMS\CHAP_2\CH2_8.BAS
 
CLS
INPUT "Enter the number of a month (1 to 12) : "; CHOICE
SELECT CASE CHOICE
    CASE 1 TO 3: PRINT "First quarter"
    CASE 4 TO 6: PRINT "Second quarter"
    CASE 7 TO 9: PRINT "Third quarter"
    CASE 10 TO 12: PRINT "Fourth quarter"
END SELECT

END  
