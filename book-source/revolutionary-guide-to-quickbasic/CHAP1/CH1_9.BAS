REM Demonstration of LSET and RSET
REM \CHAP1\CH1_9.BAS
 
CLS
a$ = "OneTwoThree"
b$ = "Qwerty"
LSET a$ = b$
PRINT a$; "*"
PRINT b$

a$ = "OneTwoThree"
b$ = "Qwerty"
RSET a$ = b$
PRINT a$; "*"
PRINT b$

END  
