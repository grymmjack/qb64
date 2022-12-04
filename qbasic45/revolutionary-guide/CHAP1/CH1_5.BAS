REM Demonstration of string trimming
REM \CHAP1\CH1_5.BAS
 
CLS
a$ = "    Qwerty   "
b$ = LTRIM$(a$)
PRINT a$
PRINT b$; "*"
b$ = RTRIM$(a$)
PRINT b$; "*"

END 
