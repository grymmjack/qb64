' *********** CHECK README.1ST FIRST *********************

CLS
SCREEN 13
RANDOMIZE TIMER
DIM x(100), y(100), z(100)

 red = 63
 green = 63
 blue = 63

FOR i = 1 TO 100
  red = red - .6
  green = green - .6
  blue = blue - .6
  OUT (&H3C8), i
  OUT (&H3C9), red
  OUT (&H3C9), green
  OUT (&H3C9), blue
NEXT i

FOR i = 1 TO 100
  x(i) = INT(RND * 10000) - 5000
  y(i) = INT(RND * 10000) - 5000
  z(i) = INT(RND * 100) + 1
NEXT i

DO
_LIMIT 30
  FOR i = 1 TO 100
    xx = x(i) \ z(i) + 160
    yy = y(i) \ z(i) + 100
    IF POINT(xx, yy) < 101 THEN PSET (xx, yy), 0
    z(i) = z(i) - 3
    IF z(i) < 1 THEN z(i) = INT(RND * 20) + 80
    xx = x(i) \ z(i) + 160
    yy = y(i) \ z(i) + 100
    IF POINT(xx, yy) < 101 THEN PSET (xx, yy), z(i)
  NEXT i
LOOP UNTIL INKEY$ <> ""

