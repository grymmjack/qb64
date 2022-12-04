REM Demonstration of SELECT-CASE
REM PROGRAMS\CHAP_2\CH2_7.BAS
 
CLS
PRINT "Please enter a number 1 to 5 :"
INPUT choice

SELECT CASE choice
    CASE 1
        PRINT "One"
    CASE 2
        PRINT "Two"
    CASE 3
        PRINT "Three"
    CASE 4
        PRINT "Four"
    CASE 5
        PRINT "Five"
END SELECT

END  
