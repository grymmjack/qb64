REM Spirals
REM \CHAP9\CHAP9_8.BAS

SCREEN 1: CLS
LOCATE 1, 8
Kx = 1.2
X0 = 120: Y0 = 100
PSET (X0, Y0)
FOR W = .2 TO 40 STEP .2
  X = Kx * SIN(W)
  Y = COS(W)
  R = 2 * W
  LINE -(X0 + R * X, Y0 - R * Y)
NEXT W
PRINT "Spiral (normal)"
A$ = INPUT$(1)
