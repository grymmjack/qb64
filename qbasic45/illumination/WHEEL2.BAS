' *********** CHECK README.1ST FIRST *********************

SCREEN 13

  b = 63: c = 63

  FOR i = 1 TO 63
    b = b - 1
    OUT (&H3C8), i
    OUT (&H3C9), 0
    OUT (&H3C9), b
    OUT (&H3C9), b
  NEXT i
 
  FOR i = 63 TO 126
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
 dd = 1
DO
 z$ = INKEY$
 IF INP(&H60) = 75 THEN dd = dd - .1
 IF INP(&H60) = 77 THEN dd = dd + .1
 d = d + dd
 IF d > 52 THEN d = -51
 r = d
 FOR i = 1 TO 126
  r = r + 1
  IF r > 52 THEN r = -51
  OUT (&H3C8), i
  OUT (&H3C9), 0
  OUT (&H3C9), ABS(r)
  OUT (&H3C9), ABS(r)
 NEXT i

LOOP UNTIL INP(&H60) = 1




