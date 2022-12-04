REM Parametric Figure 4
REM \CHAP9\CH9_14.BAS

SCREEN 1: CLS
X0 = 160: Y0 = 100: R = 60: B = 0
FOR A = 0 TO 80 STEP .05
  X = R * COS(A)
  Y = 1.5 * R * SIN(A)
  SB = SIN(B): CB = COS(B)
  X1 = X * CB - Y * SB
  Y1 = X * SB + Y * CB
  IF A = 0 THEN
    PSET (X0 + X1, Y0 + Y1)
  ELSE
    LINE -(X0 + X1, Y0 + Y1)
  END IF
  B = B + .002
NEXT A
LOCATE 1, 16
PRINT "Figure 4"
A$ = INPUT$(1)


