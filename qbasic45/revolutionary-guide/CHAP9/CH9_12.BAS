REM Parametric Figure 2
REM \CHAP9\CH9_12.BAS

SCREEN 1: CLS
X0 = 160: Y0 = 100: T = 85: F = 0
FOR W = -30 TO 30 STEP .095
  R = T * SIN((W + F) / 3)
  X = X0 + 1.3 * R * COS(W)
  Y = Y0 + R * SIN(W)
  IF W = -30 THEN PSET (X, Y) ELSE LINE -(X, Y)
  F = F + .01
NEXT W
LOCATE 1, 16
PRINT "Figure 2"
A$ = INPUT$(1)
