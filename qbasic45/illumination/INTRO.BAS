' *********** CHECK README.1ST FIRST *********************

DECLARE SUB ShadeBob ()
DECLARE SUB ShadeBob2 ()
DECLARE SUB Zoomer ()
DECLARE SUB Stars ()
DECLARE SUB Wheel ()
DECLARE SUB GetPut ()
DECLARE SUB Strange ()
DECLARE SUB Laineet ()
DECLARE SUB Worm ()
DECLARE SUB FadeOut ()
DECLARE SUB BlackPal ()

DEF SEG = &HA000
SCREEN 13

ShadeBob
CLS
ShadeBob2
CLS
Zoomer
Stars
Wheel
GetPut
Strange
Laineet
Worm
CLS

OUT &H3C8, 15
OUT &H3C9, 63
OUT &H3C9, 63
OUT &H3C9, 63

END

SBpal:

DATA 0,0,0    , 4,4,4
DATA 8,8,8    , 12,12,12
DATA 16,16,16 , 20,20,20
DATA 24,24,24 , 28,28,28
DATA 32,32,32 , 36,36,36
DATA 40,40,40 , 44,44,44
DATA 48,48,48 , 52,52,52
DATA 56,56,56 , 60,60,60
DATA 63,63,63 , 63,60,60
DATA 63,56,56 , 63,52,52
DATA 63,48,48 , 63,44,44
DATA 63,40,40 , 63,36,36
DATA 63,32,32 , 63,28,28
DATA 63,24,24 , 63,20,20
DATA 63,16,16 , 63,12,12
DATA 63,8,8   , 63,4,4
DATA 63,0,0   , 60,0,4
DATA 56,0,8   , 52,0,12
DATA 48,0,16  , 44,0,20
DATA 40,0,24  , 36,0,28
DATA 32,0,32  , 28,0,36
DATA 24,0,40  , 20,0,44
DATA 16,0,48  , 12,0,52
DATA 8,0,56   , 4,0,60
DATA 0,0,63   , 0,0,60
DATA 0,0,56   , 0,0,52
DATA 0,0,48   , 0,0,44
DATA 0,0,40   , 0,0,36
DATA 0,0,32   , 0,0,28
DATA 0,0,24   , 0,0,20
DATA 0,0,16   , 0,0,12
DATA 0,0,8

Zoom:

DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,126,126,126,126,00,95,126,95,00,95,126,95,00,126,95,126,00,126,126,126,00,126,126,95,00,00
DATA 00,00,95,126,95,00,126,95,126,00,126,95,126,00,126,126,126,00,126,126,95,00,126,95,126,00,00
DATA 00,95,126,95,00,00,126,95,126,00,126,95,126,00,126,126,126,00,126,95,00,00,126,126,95,00,00
DATA 00,126,126,126,126,00,126,126,126,00,126,126,126,00,126,95,126,00,126,126,126,00,126,95,126,00,00
DATA 00,126,126,126,126,00,95,126,95,00,95,126,95,00,126,00,126,00,126,126,126,00,126,00,126,00,00
DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,126,126,126,95,00,126,00,126,00,126,00,00,00,126,126,126,00,95,126,126,00,100,126,100,00,00
DATA 00,126,95,95,126,00,126,00,126,00,126,00,00,00,126,95,00,00,126,95,00,00,126,126,126,00,00
DATA 00,126,126,126,95,00,126,95,126,00,126,00,00,00,126,126,00,00,95,126,95,00,126,126,126,00,00
DATA 00,126,95,126,126,00,126,95,126,00,126,95,00,00,126,95,00,00,00,95,126,00,95,126,95,00,00
DATA 00,126,00,126,126,00,126,126,126,00,126,126,126,00,126,126,126,00,126,126,126,00,00,95,00,00,00
DATA 00,126,00,126,126,00,95,126,95,00,126,126,126,00,126,126,126,00,126,126,95,00,00,126,00,00,00
DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

GetImg:

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










SUB BlackPal

 FOR i = 0 TO 255
  OUT &H3C8, i
  OUT &H3C9, 0
  OUT &H3C9, 0
  OUT &H3C9, 0
 NEXT
 
END SUB

SUB FadeOut

FOR i = 1 TO 63
  FOR ii = 1 TO 189
     OUT (&H3C7), ii
     r = INP(&H3C9)
     g = INP(&H3C9)
     b = INP(&H3C9)
     r = r - .5
     g = g - .5
     b = b - .5
     r = ABS(r - .5)
     g = ABS(g - .5)
     b = ABS(b - .5)
     OUT (&H3C8), ii
     OUT (&H3C9), r
     OUT (&H3C9), g
     OUT (&H3C9), b
  NEXT ii
  PALETTE 0, 0
NEXT i

END SUB

SUB GetPut

DIM kuva1(25), kuva2(40)

BlackPal

RESTORE GetImg
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
NEXT

col = 63

FOR y = 100 TO 162
 col = col - 1
 LINE (0, y)-(399, y), col
NEXT y

s = 0
GET (x, y)-(x + 10, y + 10), kuva2
PUT (x, y), kuva1, PSET

FOR i = 1 TO 600
  PUT (x, y), kuva2, PSET
  s = s + .05
  x = 100 * COS(s * 1.12) * SIN(s / 1.63) * COS(SIN(s * 1.321)) + 160
  y = 100 * SIN(s * 1.32) * (COS(s / 3.12) * SIN(SIN(SIN(s + 1.42 / 2.3223)))) + 100
  GET (x, y)-(x + 10, y + 10), kuva2
  PUT (x, y), kuva1, PSET
  PALETTE 0, 0
NEXT

FOR i = 1 TO 63
 FOR a = 1 TO 63
  OUT &H3C7, a
  r = INP(&H3C9) - 1
  g = INP(&H3C9) - 1
  b = INP(&H3C9) - 1
  IF r < 0 THEN r = 0
  IF g < 0 THEN g = 0
  IF b < 0 THEN b = 0
  OUT &H3C8, a
  OUT &H3C9, r
  OUT &H3C9, g
  OUT &H3C9, b
 NEXT
 PUT (x, y), kuva2, PSET
 s = s + .05
 x = 100 * COS(s * 1.12) * SIN(s / 1.63) * COS(SIN(s * 1.321)) + 160
 y = 100 * SIN(s * 1.32) * (COS(s / 3.12) * SIN(SIN(SIN(s + 1.42 / 2.3223)))) + 100
 GET (x, y)-(x + 10, y + 10), kuva2
 PUT (x, y), kuva1, PSET
 PALETTE 0, 0
 PALETTE 0, 0
NEXT


END SUB

SUB Laineet

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

pequ = 250

FOR a = 250 TO -30 STEP -1
  PCOPY 2, 1
  pequ = pequ - 1
  FOR i = 0 TO 199
   t(i) = t(i) + .2
   x = koko(i) * SIN(t(i))
   LINE (-1, i)-(x + a, i), 15
   PSET (x + a, i), 7
  NEXT i
  PCOPY 1, 0
NEXT

SLEEP 2
CLS

END SUB





SUB ShadeBob

size = 20: s = 0

DIM kuv(size, size)

RESTORE SBpal

FOR i = 1 TO 63
 READ r, g, b
 OUT (&H3C8), i
 OUT (&H3C9), r
 OUT (&H3C9), g
 OUT (&H3C9), b
NEXT i
      
CIRCLE (size / 2, size / 2), size / 2 - 1, 1
PAINT (size / 2, size / 2), 1, 1

FOR y = 1 TO size
 FOR x = 1 TO size
  kuv(x, y) = PEEK(x + (y * 320))
 NEXT
NEXT

LINE (0, 0)-(size, size), 0, BF

FOR i = 1 TO 672
  s = s + .1
  x = INT(60 * SIN(s * 1.23) + 160)
  y = INT(60 * SIN(s * 1.123) + 100)
  FOR yy = 1 TO size
   FOR xx = 1 TO size
    IF kuv(xx, yy) = 1 THEN POKE ((xx + x) + ((yy + y) * 320)), PEEK((xx + x) + ((yy + y) * 320)) + 1
   NEXT
  NEXT
  IF INP(&H60) = 1 THEN END
NEXT

FOR i = 0 TO 63
 OUT (&H3C8), i
 OUT (&H3C9), 0
 OUT (&H3C9), 0
 OUT (&H3C9), 0
 FOR a = 1 TO 5
  PALETTE 0, 0
 NEXT
NEXT

END SUB

SUB ShadeBob2

size = 20: s = 0

DIM kuv(size, size)

RESTORE SBpal
FOR i = 1 TO 63
 READ r, g, b
 OUT (&H3C8), i
 OUT (&H3C9), r
 OUT (&H3C9), g
 OUT (&H3C9), b
NEXT i

CIRCLE (size / 2, size / 2), size / 2 - 1, 1
PAINT (size / 2, size / 2), 1, 1

FOR y = 1 TO size
 FOR x = 1 TO size
  kuv(x, y) = PEEK(x + (y * 320))
 NEXT
NEXT

FOR i = 1 TO 920
  s = s + .1
  x = INT(80 * (COS(s) * SIN(s * .1)) + 160)
  y = INT(80 * (SIN(s) * SIN(s * .1)) + 100)
  FOR yy = 1 TO size
   FOR xx = 1 TO size
    IF kuv(xx, yy) = 1 THEN POKE ((xx + x) + ((yy + y) * 320)), PEEK((xx + x) + ((yy + y) * 320)) + 1
   NEXT xx
  NEXT yy
  IF INP(&H60) = 1 THEN END
NEXT

FOR i = 0 TO 63
 OUT (&H3C8), i
 OUT (&H3C9), 0
 OUT (&H3C9), 0
 OUT (&H3C9), 0
 FOR a = 1 TO 5
  PALETTE 0, 0
 NEXT
NEXT

END SUB

SUB Stars

Star = 250

DIM x(Star), y(Star), z(Star), r(63), g(63), b(63)

FOR i = 1 TO 63
  OUT &H3C8, i
  OUT &H3C9, 63 - i
  OUT &H3C9, 63 - i
  OUT &H3C9, 63 - i
NEXT i

FOR i = 1 TO 63
  OUT &H3C7, i + 64
  r(i) = INP(&H3C9)
  g(i) = INP(&H3C9)
  b(i) = INP(&H3C9)
NEXT

FOR i = 1 TO Star
  x(i) = INT(RND * 10000) - 5000
  y(i) = INT(RND * 10000) - 5000
  z(i) = INT(RND * 63) + 1
NEXT i

FOR kerta = 1 TO 150
  FOR i = 1 TO Star
    xx = x(i) \ z(i) + 160
    yy = y(i) \ z(i) + 100
    IF POINT(xx, yy) < 64 THEN PSET (xx, yy), 0
    z(i) = z(i) - 1
    IF z(i) < 1 THEN z(i) = INT(RND * 53) + 10
    xx = x(i) \ z(i) + 160
    yy = y(i) \ z(i) + 100
    IF POINT(xx, yy) < 64 THEN PSET (xx, yy), z(i)
  NEXT i
NEXT

FOR kerta = 1 TO 63
  FOR i = 1 TO Star
    xx = x(i) \ z(i) + 160
    yy = y(i) \ z(i) + 100
    IF POINT(xx, yy) < 64 THEN PSET (xx, yy), 0
    z(i) = z(i) - 1
    IF z(i) < 1 THEN z(i) = INT(RND * 53) + 10
    xx = x(i) \ z(i) + 160
    yy = y(i) \ z(i) + 100
    IF POINT(xx, yy) < 64 THEN PSET (xx, yy), z(i)
  NEXT i
  FOR i = 1 TO 63
   OUT &H3C7, i
   r = INP(&H3C9)
   g = INP(&H3C9)
   b = INP(&H3C9)
   r = ABS(r - 1)
   g = ABS(r - 1)
   b = ABS(r - 1)
   OUT &H3C8, i
   OUT &H3C9, r
   OUT &H3C9, g
   OUT &H3C9, b
  NEXT
NEXT

FOR i = 1 TO 50
 PALETTE 0, 0
NEXT

FadeOut
CLS

FOR i = 1 TO 63
 PALETTE 0, 0
 FOR a = 0 TO 255
  OUT (&H3C8), a
  OUT (&H3C9), 0
  OUT (&H3C9), i
  OUT (&H3C9), i
 NEXT
NEXT

END SUB

SUB Strange

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

 FOR i = 1 TO 16
  OUT &H3C8, i + 16
  OUT &H3C9, i * 4
  OUT &H3C9, i * 4
  OUT &H3C9, i * 4
 NEXT i

s = 0

FOR a = 1 TO 350
  r = r + .05
  FOR i = 1 TO kuvat
    t(i) = t(i) + .1
    xx = 50 * SIN(t(i) / 2.875)
    x = xx * COS(t(i) / 2.3)
    PUT (x + 100, i * ABS(3 * SIN(r)) - (ABS(3 * SIN(r)))), kuv, PSET
  NEXT i
  LINE (0, i * ABS(3 * SIN(r)))-(319, i * ABS(3 * SIN(r)) + 10), 0, BF
NEXT a

FOR i = 0 TO 63
 OUT &H3C8, i
 OUT &H3C9, 63
 OUT &H3C9, 63
 OUT &H3C9, 63
NEXT

CLS

FOR a = 63 TO 0 STEP -1
 OUT &H3C8, 0
 OUT &H3C9, a
 OUT &H3C9, a
 OUT &H3C9, a
 PALETTE 0, 0
NEXT

END SUB

SUB Wheel

 b = 63: c = 63

 col = 1

 x1 = 0: x2 = 319
 y1 = 0: y2 = 199
 FOR i = 1 TO 320
   x1 = x1 + 1
   x2 = x2 - 1
   col = col + 1
   IF col > 104 THEN col = 1
   LINE (x1, y1)-(x2, y2), col
 NEXT

 FOR i = 1 TO 200
   y1 = y1 + 1
   y2 = y2 - 1
   col = col + 1
   IF col > 104 THEN col = 1
   LINE (x1, y1)-(x2, y2), col
 NEXT
 
 FOR a = 63 TO 1 STEP -1
  d = d + 1
  IF d > 52 THEN d = -51
  r = d
  FOR i = 1 TO 126
   r = r + 1
   IF r > 52 THEN r = -51
   b = ABS(r) + a
   IF b > 63 THEN b = 63
   OUT (&H3C8), i
   OUT (&H3C9), 0
   OUT (&H3C9), b
   OUT (&H3C9), b
  NEXT
  PALETTE 0, 0
 NEXT

 FOR a = 1 TO 700
  d = d + 1
  IF d > 52 THEN d = -51
  r = d
  FOR i = 1 TO 126
   r = r + 1
   IF r > 52 THEN r = -51
   OUT (&H3C8), i
   OUT (&H3C9), 0
   OUT (&H3C9), ABS(r)
   OUT (&H3C9), ABS(r)
  NEXT
 NEXT

 FOR a = 1 TO 63 STEP .5
  d = d + 1
  IF d > 52 THEN d = -51
  r = d
  FOR i = 1 TO 126
   r = r + 1
   IF r > 52 THEN r = -51
   b = ABS(r) - a
   IF b < 0 THEN b = 0
   OUT (&H3C8), i
   OUT (&H3C9), 0
   OUT (&H3C9), b
   OUT (&H3C9), b
  NEXT
  PALETTE 0, 0
 NEXT

END SUB

SUB Worm

SCREEN 13

jee = 18

DIM t(100), x(100), y(100), z(100)

FOR i = 1 TO jee
 z(i) = i * .09
 t(i) = i * .21
NEXT i

FOR i = 1 TO 100
 OUT (&H3C8), i
 OUT (&H3C9), 0
 OUT (&H3C9), i / 2
 OUT (&H3C9), i / 2
NEXT i


FOR ry = 1 TO 200
 
  d = 100

  FOR i = 1 TO jee
   t(i) = t(i) + .2

   xx = x(i) / z(i)
   yy = y(i) / z(i)
   CIRCLE (xx + 160, yy + 100), d * 1.9, 0
 
   x(i) = (102 - (d)) * SIN(t(i) / 1.24)
   y(i) = (102 - (d)) * SIN(t(i) * 1.21)
 
   xx = x(i) / z(i)
   yy = y(i) / z(i)
   CIRCLE (xx + 160, yy + 100), d * 1.9, d
   d = d - 5: IF d < 0 THEN d = 0
  NEXT i
  
NEXT

FadeOut

END SUB

SUB Zoomer

 sizex = 1: sizey = 1

 DIM Pic(27, 14)

 FOR i = 1 TO 63
  OUT &H3C8, i + 64
  OUT &H3C9, i
  OUT &H3C9, i
  OUT &H3C9, i
 NEXT i

 RESTORE Zoom

 FOR y = 1 TO 14
  FOR x = 1 TO 27
   READ a
   Pic(x, y) = a
  NEXT
 NEXT

FOR kerta = 1 TO 2
 FOR i = 1 TO 50
  sizex = sizex + .1: sizey = sizey + .1
  FOR y = 1 TO 14
   FOR x = 1 TO 27
    LINE (x * sizex - i + 125, y * sizey - i + 100)-(x * sizex + sizex - i + 125, y * sizey + sizey - i + 100), Pic(x, y), BF
   NEXT
  NEXT
 NEXT
 FOR i = 1 TO 50
  sizex = sizex - .1: sizey = sizey - .1
  FOR y = 1 TO 14
   FOR x = 1 TO 27
    LINE (x * sizex + i + 75, y * sizey + i + 49)-(x * sizex + sizex + i + 75, y * sizey + sizey + i + 49), Pic(x, y), BF
   NEXT
  NEXT
 NEXT
NEXT

 FOR i = 1 TO 50
  sizex = sizex + .1: sizey = sizey + .1
  FOR y = 1 TO 14
   FOR x = 1 TO 27
    LINE (x * sizex - i + 125, y * sizey - i + 100)-(x * sizex + sizex - i + 125, y * sizey + sizey - i + 100), Pic(x, y), BF
   NEXT
  NEXT
 NEXT

END SUB

