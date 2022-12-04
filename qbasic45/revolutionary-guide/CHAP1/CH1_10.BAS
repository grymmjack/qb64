REM Demonstrates substring searching
REM \CHAP1\CH1_10.BAS 

CLS
b$ = "Two"
a$ = "OneTwoThreeOneTwoThree"
y1 = INSTR(1, a$, b$)
y2 = INSTR(7, a$, b$)
PRINT y1, y2

END  
