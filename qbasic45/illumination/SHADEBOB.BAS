' *********** CHECK README.1ST FIRST *********************

SCREEN 13

size = 10

DIM SHARED kuv(size, size)

FOR i = 1 TO 63
 OUT (&H3C8), i
 OUT (&H3C9), i
 OUT (&H3C9), i
 OUT (&H3C9), 0
NEXT i
FOR i = 1 TO 63
 OUT (&H3C8), i + 63
 OUT (&H3C9), 63
 OUT (&H3C9), 63 - i
 OUT (&H3C9), i
NEXT i
FOR i = 1 TO 63
 OUT (&H3C8), i + 128
 OUT (&H3C9), 63 - i
 OUT (&H3C9), i
 OUT (&H3C9), 63 - i
NEXT i
FOR i = 1 TO 63
 OUT (&H3C8), i + 191
 OUT (&H3C9), 0
 OUT (&H3C9), 63 - i
 OUT (&H3C9), 0
NEXT i
       
CIRCLE (size / 2, size / 2), size / 2 - 1, 1
PAINT (size / 2, size / 2), 1, 1

FOR y = 0 TO size
 FOR x = 0 TO size
  kuv(x, y) = POINT(x, y)
 NEXT x
NEXT y

DO
  s = s + .1
  x = 75 * (COS(s) * SIN(s * .1)) + 160
  y = 75 * (SIN(s) * SIN(s * .1)) + 100

  FOR yy = 1 TO size
   FOR xx = 1 TO size
    IF kuv(xx, yy) = 1 THEN PSET (xx + x, yy + y), POINT(xx + x, yy + y) + 4
   NEXT xx
  NEXT yy

LOOP UNTIL INKEY$ <> ""

