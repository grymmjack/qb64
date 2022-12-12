REM A demonstration of string filling
REM \CHAP1\CH1_6.BAS
  
CLS
A$ = "Q"
B$ = STRING$(5, A$) + "*"
PRINT A$
PRINT B$
C$ = SPACE$(5) + "*"
PRINT C$

END  
