REM Untwisting Spiral
REM \CHAP9\CHAP9_9.BAS

'Spiral (exp)
SCREEN 1: CLS
Kx = 1.2
X0 = 120: Y0 = 100
FOR W = 1 TO 60 STEP .1
  R = 5 * EXP(W / 20)
  X = X0 + R * COS(W)
  Y = Y0 - R * SIN(W)
  IF W = 1 THEN PSET (X, Y) ELSE LINE -(X, Y)
NEXT W
LOCATE 1, 10
PRINT "Spiral (exp)"
A$ = INPUT$(1)
