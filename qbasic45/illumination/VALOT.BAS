' *********** CHECK README.1ST FIRST *********************

SCREEN 12
CLS
RANDOMIZE TIMER

r1 = 60
g1 = 20
b1 = 10
rr1 = -1
gg1 = -1
bb1 = 1

r2 = 20
g2 = 2
b2 = 50
rr2 = 1
gg2 = 1
bb2 = 1

r3 = 60
g3 = 10
b3 = 60
rr3 = -1
gg3 = 1
bb3 = -1

OUT (&H3C8), 12
OUT (&H3C9), r1
OUT (&H3C9), g1
OUT (&H3C9), b1

OUT (&H3C8), 14
OUT (&H3C9), r2
OUT (&H3C9), g2
OUT (&H3C9), b2

OUT (&H3C8), 10
OUT (&H3C9), r3
OUT (&H3C9), g3
OUT (&H3C9), b3


CIRCLE (120, 120), 120, 12
PAINT (120, 120), 12, 12

CIRCLE (310, 330), 120, 14
PAINT (310, 330), 14, 14

CIRCLE (640 - 140, 120), 120, 10
PAINT (640 - 140, 120), 10, 10

DO

  OUT (&H3C8), 12
  OUT (&H3C9), r1
  OUT (&H3C9), g1
  OUT (&H3C9), b1

  OUT (&H3C8), 14
  OUT (&H3C9), r2
  OUT (&H3C9), g2
  OUT (&H3C9), b2

  OUT (&H3C8), 10
  OUT (&H3C9), r3
  OUT (&H3C9), g3
  OUT (&H3C9), b3

  r1 = r1 + rr1
  g1 = g1 + gg1
  b1 = b1 + bb1

  r2 = r2 + rr2
  g2 = g2 + gg2
  b2 = b2 + bb2

  r3 = r3 + rr3
  g3 = g3 + gg3
  b3 = b3 + bb3

  IF r1 = 63 THEN rr1 = INT((RND * 2) - 2)
  IF g1 = 63 THEN gg1 = INT((RND * 2) - 2)
  IF b1 = 63 THEN bb1 = INT((RND * 2) - 2)
  IF r1 = 1 THEN rr1 = INT((RND * 2)) + 1
  IF g1 = 1 THEN gg1 = INT((RND * 2)) + 1
  IF b1 = 1 THEN bb1 = INT((RND * 2)) + 1

  IF r2 = 63 THEN rr2 = -1
  IF g2 = 63 THEN gg2 = -1
  IF b2 = 63 THEN bb2 = -1
  IF r2 = 1 THEN rr2 = 1
  IF g2 = 1 THEN gg2 = 1
  IF b2 = 1 THEN bb2 = 1

  IF r3 = 63 THEN rr3 = INT((RND * 2) - 2)
  IF g3 = 63 THEN gg3 = INT((RND * 2) - 2)
  IF b3 = 63 THEN bb3 = INT((RND * 2) - 2)
  IF r3 = 1 THEN rr3 = INT((RND * 2)) + 1
  IF g3 = 1 THEN gg3 = INT((RND * 2)) + 1
  IF b3 = 1 THEN bb3 = INT((RND * 2)) + 1

  FOR i = 1 TO 1000: NEXT i

LOOP UNTIL INKEY$ <> ""

