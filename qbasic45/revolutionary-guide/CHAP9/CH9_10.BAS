REM Twisting Spiral
REM \CHAP9\CHAP9_10.BAS

'Spiral (log)
SCREEN 1: CLS
Kx = 1.2
X0 = 120: Y0 = 100
FOR W = 1 TO 80 STEP .2
  R = 20 * LOG(W)
  X = X0 + R * COS(W)
  Y = Y0 - R * SIN(W)
  IF W = 1 THEN PSET (X, Y) ELSE LINE -(X, Y)
NEXT W
LOCATE 1, 10
PRINT "Spiral (log)"
A$ = INPUT$(1)
