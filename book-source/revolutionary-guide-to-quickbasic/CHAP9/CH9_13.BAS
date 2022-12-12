REM Parametric Figure 3
REM \CHAP9\CH9_13.BAS

SCREEN 1: CLS
X0 = 160: Y0 = 90
M = 5: R = 90: F = 0: A = 0
K = 1.745329E-02: S = 360 / M
WHILE R > 0
  AK = (A + F) * K
  X = R * COS(AK)
  Y = R * SIN(AK)
  IF A = 0 THEN
     PSET (X0 + X, Y0 + Y)
  ELSE
     LINE -(X0 + X, Y0 + Y)
  END IF
  R = R - 1: F = F + 1: A = A + S
WEND
LOCATE 1, 16
PRINT "Figure 3"
A$ = INPUT$(1)

