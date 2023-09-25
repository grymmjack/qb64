' *********** CHECK README.1ST FIRST *********************

DIM t(200), koko(200)

SCREEN 7, , 1, 0

e = INT(RND * 50)
r = 10: rs = 1
FOR i = 0 TO 199
 t(i) = i / 10
 r = r + rs
 IF r > e THEN rs = -1: e = INT(RND * r)
 IF r < e THEN rs = 1: e = INT(RND * (50 - r)) + r
 koko(i) = r
NEXT

FOR i = 1 TO 1000
 LINE (RND * 320, RND * 200)-(RND * 320, RND * 200), (RND * 15) + 1
NEXT i
PCOPY 1, 2
CLS

FOR a = 250 TO -30 STEP -1
  PCOPY 2, 1
  FOR i = 0 TO 199
   t(i) = t(i) + .2
   x = koko(i) * SIN(t(i))
   LINE (-1, i)-(x + a, i), 15
   PSET (x + a, i), 7
  NEXT i
  PCOPY 1, 0
NEXT

