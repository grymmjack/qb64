REM Conversion functions (example 1)
REM \CHAP4\CH4_5.BAS

CLS
n$ = MKI$(10000)
PRINT CVI(n$)
dn$ = MKL$(1000000)
PRINT CVL(dn$)
x$ = MKS$(123.456)
PRINT CVS(x$)
dx$ = MKD$(.123456789#)
PRINT CVD(dx$)

END 