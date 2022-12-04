REM Demonstration of mid-string case conversion
REM \CHAP1\CH1_8.BAS
 
CLS
a$ = "aaaaaaaaaaaaaa"
MID$(a$, 4, 3) = UCASE$(MID$(a$, 4, 3))
PRINT a$

END 
