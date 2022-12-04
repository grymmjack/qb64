REM Demonstration of textual SELECT CASE expressions
REM PROGRAMS\CHAP_2\CH2_9.BAS
 
CLS
INPUT "Enter the name of an integer between 0 and 3 inclusive : "; n$
SELECT CASE n$
    CASE "Zero": PRINT "0"
    CASE "One": PRINT "1"
    CASE "Two": PRINT "2"
    CASE "Three": PRINT "3"
END SELECT

END  
