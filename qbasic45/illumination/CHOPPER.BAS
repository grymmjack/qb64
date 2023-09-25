' *********** CHECK README.1ST FIRST *********************

DECLARE SUB Draw.Picts ()
DECLARE SUB Palet1 ()
DECLARE SUB Palet2 ()
DECLARE SUB Land ()
DECLARE SUB Keys ()

COMMON SHARED x1, y1, xs1, ys1, turn, left, right, up, fire, kudit, b, maa

SCREEN 13
kudit = 5
DIM SHARED Chop1(100), Chop2(100), base1(50), px(kudit), py(kudit), l(kudit)
DIM SHARED pxx(kudit)

FOR i = 1 TO 6
 READ yy, kaa, koo
 KEY yy, CHR$(kaa) + CHR$(koo)
 ON KEY(yy) GOSUB 1
 KEY(yy) ON
NEXT

' KEY 16, CHR$(128) + CHR$(203)
' ON KEY(16) GOSUB 2
' KEY(16) ON

DATA 15,128,75 , 16,128,203
DATA 17,128,77 , 18,128,205
DATA 19,128,72 , 20,128,200

Palet2
Draw.Picts
Palet1
Land

col = 0
x1 = 28: y1 = 187 - 10
xs1 = 0: ys1 = 0: turn = 1
up = 0: maa = 0
left = 2
right = 2
fire = 0

PUT (x1, y1), Chop2(1)

DO
_LIMIT 30
 
  col = col - 2
  IF col < -60 THEN col = 0
 
  FOR i = 65 TO 76
   OUT (&H3C8), i
   OUT (&H3C9), i
   OUT (&H3C9), i * 4 + col
   OUT (&H3C9), i * 4 + col
  NEXT i
 
  PALETTE 0, 0
 
  Keys

  IF y1 > 180 THEN
    PUT (x1, y1), Chop2(turn)
    y1 = 180: ys1 = -(ys1 / 3)
    PUT (x1, y1), Chop2(turn)
  END IF
 
  IF y1 > 176 THEN
    maa = 0
  ELSEIF y1 < 177 THEN
    maa = 1
  END IF

  IF y1 > 177 AND x1 > 15 AND x1 < 43 THEN PUT (x1, y1), Chop2(turn): y1 = 177: ys1 = 0: PUT (x1, y1), Chop2(turn)

LOOP UNTIL INP(&H60) = 1

END

10

DATA 00,00,00,00,00,00,00,38,00,00,00,00
DATA 00,00,00,40,43,46,46,48,46,46,43,40
DATA 16,10,00,00,00,00,06,25,25,00,00,00
DATA 16,16,10,00,00,10,14,28,28,25,00,00
DATA 10,16,15,14,14,15,16,27,29,28,25,00
DATA 00,00,10,16,16,16,16,16,27,27,16,12
DATA 00,00,00,00,10,16,16,16,16,16,14,10
DATA 00,00,00,00,00,06,10,14,14,14,10,00
DATA 00,00,00,00,00,00,38,00,38,00,00,38
DATA 00,00,00,38,40,42,42,42,40,40,38,35

20

DATA 00,00,00,00,00,00,00,38,00,00,00,00
DATA 00,00,00,40,43,46,46,48,46,46,43,40
DATA 63,58,00,00,00,00,54,25,25,00,00,00
DATA 63,63,58,00,00,58,62,28,28,25,00,00
DATA 58,63,63,62,62,63,63,27,29,28,25,00
DATA 00,00,58,63,63,63,63,63,27,27,63,60
DATA 00,00,00,00,58,63,63,63,63,63,62,58
DATA 00,00,00,00,00,54,58,62,62,62,58,00
DATA 00,00,00,00,00,00,38,00,38,00,00,38
DATA 00,00,00,38,40,42,42,42,40,40,38,35

DATA 00,00,00,38,48,47,47,47,46,46,46,46,45,45,44,44,38,00,00,00
DATA 00,00,48,47,65,66,67,68,69,70,71,72,73,74,75,76,43,42,00,00
DATA 00,48,47,47,47,46,46,46,46,45,45,44,44,44,44,43,43,43,42,00

1
 IF INP(&H60) = 75 THEN left = 1: RETURN
 IF INP(&H60) = 75 + 128 THEN left = 0: RETURN

 IF INP(&H60) = 77 THEN right = 1: RETURN
 IF INP(&H60) = 77 + 128 THEN right = 0: RETURN

 IF INP(&H60) = 72 THEN up = 1: RETURN
 IF INP(&H60) = 72 + 128 THEN up = 0: RETURN

SUB Draw.Picts
                               'Green Chopper
  FOR y = 1 TO 10
   FOR x = 1 TO 12
    READ a
    PSET (x, y), a
   NEXT
  NEXT
  RESTORE 10
  FOR y = 1 TO 10
   FOR x = 12 TO 1 STEP -1
    READ a
    PSET (x, y + 10), a
   NEXT
  NEXT
                               'Red Chopper
  FOR y = 1 TO 10
   FOR x = 1 TO 12
    READ a
    PSET (x, y + 20), a
   NEXT
  NEXT
  RESTORE 20
  FOR y = 1 TO 10
   FOR x = 12 TO 1 STEP -1
    READ a
    PSET (x, y + 30), a
   NEXT
  NEXT
                               'Bases
  FOR y = 1 TO 3
   FOR x = 1 TO 20
    READ a
    PSET (x, y + 40), a
   NEXT
  NEXT

  GET (1, 1)-(12, 10), Chop2(1)
  GET (1, 11)-(12, 20), Chop2(50)

  GET (1, 21)-(12, 30), Chop2(1)
  GET (1, 31)-(12, 40), Chop2(50)

  GET (1, 41)-(20, 44), base1
  CLS

END SUB

SUB Keys

  z$ = INKEY$
  a = INP(&H60)
  b = b + 1

'  IF a = 77 THEN right = 1
'  IF a = 77 + 128 THEN right = 0

'  IF a = 75 THEN left = 1
'  IF a = 75 + 128 THEN left = 0
    
'  IF a = 72 THEN up = 1
'  IF a = 72 + 128 THEN up = 0

  IF a = 57 THEN fire = 1
  IF a = 57 + 128 THEN fire = 0
 
'----------------------------

  IF right = 1 THEN
    PUT (x1, y1), Chop2(turn)
    turn = 1
    left = 2
    xs1 = xs1 + .01
    IF xs1 > .5 THEN xs1 = .5
    x1 = x1 + xs1
    y1 = y1 + ys1
    PUT (x1, y1), Chop2(turn)
  END IF
  IF right = 0 THEN
    PUT (x1, y1), Chop2(turn)
    IF maa = 0 THEN
      xs1 = xs1 - .01
      IF xs1 < 0 THEN xs1 = 0
    END IF
    x1 = x1 + xs1
    y1 = y1 + ys1
    PUT (x1, y1), Chop2(turn)
  END IF


  IF left = 1 THEN
    PUT (x1, y1), Chop2(turn)
    turn = 50
    right = 2
    xs1 = xs1 - .01
    IF xs1 < -.5 THEN xs1 = -.5
    x1 = x1 + xs1
    y1 = y1 + ys1
    PUT (x1, y1), Chop2(turn)
  END IF
  IF left = 0 THEN
    PUT (x1, y1), Chop2(turn)
    IF maa = 0 THEN
     xs1 = xs1 + .01
     IF xs1 > 0 THEN xs1 = 0
    END IF
    x1 = x1 + xs1
    y1 = y1 + ys1
    PUT (x1, y1), Chop2(turn)
  END IF


  IF up = 1 THEN
    PUT (x1, y1), Chop2(turn)
    ys1 = ys1 - .02
    IF ys1 < -.5 THEN ys1 = -.5
    y1 = y1 + ys1
    x1 = x1 + xs1
   PUT (x1, y1), Chop2(turn)
  END IF
  IF up = 0 THEN
    PUT (x1, y1), Chop2(turn)
    ys1 = ys1 + .01
    IF ys1 > .5 THEN ys1 = .5
    x1 = x1 + xs1
    y1 = y1 + ys1
    PUT (x1, y1), Chop2(turn)
  END IF


  IF fire = 1 THEN
    FOR i = 1 TO kudit
       PSET (px(i), py(i)), 0
       px(i) = px(i) + pxx(i)
       PSET (px(i), py(i)), 15
       IF px(i) < -1 OR px(i) > 320 THEN pxx(i) = 0: l(i) = 0
    NEXT
    IF b > 10 THEN
      FOR i = 1 TO kudit
       IF l(i) = 1 THEN GOSUB 50
       IF turn > 1 THEN buu = -9: pox = -2 'ELSE buu = 10: pox = 2
       IF turn = 1 THEN buu = 9: pox = 2 'ELSE buu = 10: pox = 2
       px(i) = x1 + 5 + buu
       py(i) = y1 + 6
       pxx(i) = pox
       l(i) = 1
       b = 0
       EXIT FOR
50
      NEXT
    END IF
  END IF
 
  IF fire = 0 THEN
    FOR i = 1 TO kudit
      PSET (px(i), py(i)), 0
      px(i) = px(i) + pxx(i)
      PSET (px(i), py(i)), 15
      IF px(i) < -1 OR px(i) > 320 THEN pxx(i) = 0: l(i) = 0
    NEXT
  END IF


END SUB

SUB Land

  col = 255
  t = 5

  FOR y = 190 TO 199
   FOR x = 0 TO 319
    col = col - .1
    r = INT(RND * 5) + col
    IF r > 255 THEN r = 255
    IF r < 255 - 63 THEN r = 255 - 63
    PSET (x, y), r
   NEXT
   col = 255 - t
   t = t + 5
  NEXT

  PUT (25, 187), base1
  PUT (275, 187), base1

END SUB

SUB Palet1

  FOR i = 1 TO 16
   OUT (&H3C8), i
   OUT (&H3C9), i
   OUT (&H3C9), i * 4 - 1
   OUT (&H3C9), i
  NEXT i
  FOR i = 1 TO 16
   OUT (&H3C8), i + 16
   OUT (&H3C9), i
   OUT (&H3C9), i * 3
   OUT (&H3C9), i * 4 - 1
  NEXT i
  FOR i = 1 TO 16
   OUT (&H3C8), i + 32
   OUT (&H3C9), i * 4 - 1
   OUT (&H3C9), i * 4 - 1
   OUT (&H3C9), i * 4 - 1
  NEXT i
  FOR i = 1 TO 16
   OUT (&H3C8), i + 48
   OUT (&H3C9), i * 4 - 1
   OUT (&H3C9), i
   OUT (&H3C9), i
  NEXT i
 
  FOR i = 1 TO 63
   OUT (&H3C8), 255 - 63 + i
   OUT (&H3C9), i / 4
   OUT (&H3C9), i
   OUT (&H3C9), i / 4
  NEXT i

END SUB

SUB Palet2
  FOR i = 1 TO 255
   OUT (&H3C8), i
   OUT (&H3C9), 0
   OUT (&H3C9), 0
   OUT (&H3C9), 0
  NEXT i

END SUB

