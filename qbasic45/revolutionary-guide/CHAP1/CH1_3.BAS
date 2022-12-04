REM Specifying a data block - record
REM \CHAP_1\CH1_3.BAS

CLS
TYPE vb
s AS STRING * 10
n AS INTEGER
dn AS LONG
xas SINGLE
dx AS DOUBLE
END TYPE

DIM VarBlock AS vb
VarBlock.s = "QWERTY"
vb.n = 3
vb.dn = 123456789
vb.x = VB.DN
vb.dx = 1 / VB.N
PRINT VarBlock.s, vb.n, vb.dn
PRINT vb.x, vb.dx

END 
 