REM Parametric Figure 1
REM \CHAP9\CH9_11.BAS

SCREEN 1: CLS
Kx = 1.2
N = 5
X0 = 120: Y0 = 100
FOR W = 0 TO 6.3 STEP .1
  R = 60 + 30 * SIN(N * W)
  X = X0 + R * COS(W)
  Y = Y0 - R * SIN(W)
  IF W = 0 THEN PSET (X, Y) ELSE LINE -(X, Y)
NEXT W
LOCATE 1, 13
PRINT "Figure 1"
A$ = INPUT$(1)
