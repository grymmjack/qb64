' *********** CHECK README.1ST FIRST *********************

SCREEN 13

  RANDOMIZE TIMER

  b = 63: c = 63

  FOR i = 1 TO 52
    b = b - 1
    OUT (&H3C8), i
    OUT (&H3C9), 0
    OUT (&H3C9), b
    OUT (&H3C9), b
  NEXT i
 
  FOR i = 52 TO 104
    b = b + 1
    OUT (&H3C8), i
    OUT (&H3C9), 0
    OUT (&H3C9), b
    OUT (&H3C9), b
  NEXT i

  col = 1

 x1 = 0: x2 = 319
 y1 = 0: y2 = 199

 FOR i = 1 TO 320
   x1 = x1 + 1
   x2 = x2 - 1
   col = col + 1
   IF col > 104 THEN col = 1
   LINE (x1, y1)-(x2, y2), col
 NEXT i

 FOR i = 1 TO 200
   y1 = y1 + 1
   y2 = y2 - 1
   col = col + 1
   IF col > 104 THEN col = 1
   LINE (x1, y1)-(x2, y2), col
 NEXT i

k = 0
r = RND
g = RND
b = RND
dd = 1
DO
 k = k + 3.1415926525# / 100

 IF k > 3.1415926525# THEN
   k = 0
   r = RND
   g = RND
   b = RND
 END IF

 z$ = INKEY$
 IF INP(&H60) = 75 THEN dd = dd - .1
 IF INP(&H60) = 77 THEN dd = dd + .1

 s = ABS(SIN(k))
 d = d + dd
 IF d > 52 THEN d = -51
 f = d
 FOR i = 1 TO 104
  f = f + 1
  IF f > 52 THEN f = -51
  OUT (&H3C8), i
  OUT (&H3C9), ABS(f) * s * r
  OUT (&H3C9), ABS(f) * s * g
  OUT (&H3C9), ABS(f) * s * b
 NEXT i

LOOP UNTIL INP(&H60) = 1




