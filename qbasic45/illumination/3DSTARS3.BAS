' *********** CHECK README.1ST FIRST *********************

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
  y(i) = INT(RND * 7000) - 3500
  z(i) = INT(RND * 100) + 1
NEXT i

f = 0

DO
_LIMIT 30
sf = SIN(f)
sf2 = SIN(f - .05)
cf = COS(f)
cf2 = COS(f - .05)

f = f + .05
  FOR i = 1 TO 100
    xxx = x(i) * sf2 + y(i) * cf2
    yyy = x(i) * cf2 - y(i) * sf2
    xx = xxx / z(i)
    yy = yyy / z(i)
    PSET (xx + 160, yy + 100), 0
    z(i) = z(i) - 3
    IF z(i) < 1 THEN
      x(i) = INT(RND * 10000) - 5000
      y(i) = INT(RND * 10000) - 5000
      z(i) = INT(RND * 20) + 80
    END IF
    xxx = x(i) * sf + y(i) * cf
    yyy = x(i) * cf - y(i) * sf
    xx = xxx / z(i)
    yy = yyy / z(i)
    PSET (xx + 160, yy + 100), z(i)
  NEXT i
LOOP UNTIL INKEY$ <> ""

