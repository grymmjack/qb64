REM Character functions (example 1)
REM \CHAP4\CH4_6.BAS

CLS
y$ = STR$(123)
PRINT y$
x = VAL(y$)
PRINT x
c$ = CHR$(65)
PRINT c$
PRINT ASC(c$)
PRINT LEN("Qwerty")

END  