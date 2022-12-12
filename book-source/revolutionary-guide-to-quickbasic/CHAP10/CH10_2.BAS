REM Elementary 3-D figures
REM \CHAP10\CH10_2.BAS

CONST PI = 3.141
SCREEN 2: CLS
'Cylinder
FOR W = 0 TO PI STEP .04 * PI
  X = 20 * SIN(W): Y = 35 * COS(W)
  LINE (X + 50, Y + 52)-(X + 200, Y + 52)
NEXT
FOR W = 0 TO 2 * PI STEP .02 * PI
  X = 20 * SIN(W): Y = 35 * COS(W)
  PSET (X + 50, Y + 52)
  IF W < PI THEN PSET (X + 200, Y + 52)
NEXT

'Paraboloid
FOR Z = -3 TO 3 STEP .1
  A = .5 * Z: Z2 = Z * Z
  FOR X = -3 TO 3.2 STEP .2
    Y = .5 * (Z2 + X * X)
    PSET (430 + 30 * (X + A), 90 - 8 * (Y - A))
  NEXT
NEXT

'Pyramide
N = 5
X = 130: Y = 97: D = 2 * PI / N
FOR W = 0 TO 2 * PI STEP D
  X1 = 130 + 80 * COS(W)
  Y1 = 72 + 15 * SIN(W)
  IF W = 0 THEN PSET (210, Y + 72) ELSE LINE -(X1, Y + Y1)
  PSET (X, Y): LINE -(X1, Y + Y1)
NEXT

'Sinusoid
LINE (380, 190)-(580, 190)
LINE (380, 190)-(380, 110)
LINE (380, 190)-(550, 135)
LOCATE 24, 45: PRINT "0";
LOCATE 24, 76: PRINT "X";
LOCATE 14, 45: PRINT "Y"
LOCATE 17, 71: PRINT "Z"
FOR W = 0 TO 4 * PI STEP PI / 5
  Z = 6 * W: X = 80 * SIN(W)
  IF W = 0 THEN
     PSET (380 + 2.2 * Z, 190 - .707 * Z)
     ELSE
     LINE -(380 + X + 2.2 * Z, 190 - .707 * Z)
  END IF
NEXT
SLEEP









