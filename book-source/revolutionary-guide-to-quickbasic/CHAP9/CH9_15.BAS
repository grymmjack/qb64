REM Parametric Figure 5
REM \CHAP9\CH9_15.BAS

SCREEN 1: CLS
X0 = 160: Y0 = 30: T = 85: F = 0
FOR W = 0 TO 15.75 STEP .05
  R = T * (SIN(W + F) + SIN(W))
  X = X0 + R * COS(W)
  Y = Y0 + R * SIN(W)
  IF W = 0 THEN PSET (X, Y) ELSE LINE -(X, Y)
  F = F + .02
NEXT W
LOCATE 1, 10
PRINT "Figure 5"
A$ = INPUT$(1)



