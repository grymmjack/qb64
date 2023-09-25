' *********** CHECK README.1ST FIRST *********************

DIM kuva1(25), kuva2(40)

SCREEN 13

FOR y = 1 TO 10
 FOR x = 1 TO 10
  READ a
  PSET (x, y), a
 NEXT x
NEXT y

GET (1, 1)-(10, 10), kuva1
CLS

FOR col = 0 TO 62
 OUT (&H3C8), col
 OUT (&H3C9), col
 OUT (&H3C9), 0
 OUT (&H3C9), 0
 LINE (0, col + 37)-(399, col + 37), col
NEXT col

col = 63

FOR y = 100 TO 162
 col = col - 1
 LINE (0, y)-(399, y), col
NEXT y

s = 0
GET (x, y)-(x + 10, y + 10), kuva2
PUT (x, y), kuva1, PSET

DO
_LIMIT 30
 
  PUT (x, y), kuva2, PSET
  s = s + .05
  x = 100 * COS(s * 1.12) * SIN(s / 1.63) * COS(SIN(s * 1.321)) + 160
  y = 100 * SIN(s * 1.32) * (COS(s / 3.12) * SIN(SIN(SIN(s + 1.42 / 2.3223)))) + 100
  GET (x, y)-(x + 10, y + 10), kuva2
  PUT (x, y), kuva1, PSET

  PALETTE 0, 0
 
LOOP UNTIL INKEY$ <> ""


DATA 30,30,30,30,35,35,30,30,30,30
DATA 30,30,35,35,35,35,35,35,30,30
DATA 30,35,35,40,40,40,40,35,35,30
DATA 30,35,40,40,45,45,40,40,35,30
DATA 35,35,40,45,50,50,45,40,35,35
DATA 35,35,40,45,50,50,45,40,35,35
DATA 30,35,40,40,45,45,40,40,35,30
DATA 30,35,35,40,40,40,40,35,35,30
DATA 30,30,35,35,35,35,35,35,30,30
DATA 30,30,30,30,35,35,30,30,30,30

