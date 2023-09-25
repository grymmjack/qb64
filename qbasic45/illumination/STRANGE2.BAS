' *********** CHECK README.1ST FIRST *********************

kuvat = 65

DIM kuv(50 * kuvat), x(kuvat), y(kuvat), t(kuvat)

SCREEN 13

col = 16
coll = 3

FOR i = 1 TO 10
 col = col + coll
 IF i = 4 THEN coll = -2
 LINE (i * 5 + 25, 5)-(i * 5 + 5 + 25, 7), col, BF
NEXT i

GET (0, 5)-(100, 7), kuv
CLS

FOR i = 1 TO kuvat
  y(i) = i * 3
  t(i) = SIN(i / 7.23) 't(i) + i / 5
NEXT i

s = 0

DO
  r = r + .05
  FOR i = 1 TO kuvat
    t(i) = t(i) + .1
    xx = 50 * SIN(t(i) / 2.875)
    x = xx * COS(t(i) / 2.3)
    PUT (x + 100, i * ABS(3 * SIN(r)) - (ABS(3 * SIN(r)))), kuv, PSET
  NEXT i
  LINE (0, i * ABS(3 * SIN(r)))-(319, i * ABS(3 * SIN(r)) + 10), 0, BF
LOOP UNTIL INKEY$ <> ""

