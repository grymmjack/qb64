REM Plotting Ellipses
REM\CHAP9\CHAP9_7.BAS

SCREEN 1: KEY OFF: CLS
Q = 45: R = 60: KR = 2 * R
C = COS(Q): S = SIN(Q): F = 1.745329E-02

FOR W = 0 TO 360
  A = W * F
  X = R * COS(A)
  Y = KR * SIN(A)
  X1 = X * C + Y * S
  Y1 = S * X - C * Y

  IF W = 0 THEN
    PSET (120 + X1, 100 + Y1)
  ELSE
    LINE -(120 + X1, 100 + Y1)
  END IF
NEXT W

LOCATE 1, 15
PRINT "Ellipse"
A$ = INPUT$(1)
