' *********** CHECK README.1ST FIRST *********************

DECLARE SUB Pictures ()
DECLARE SUB SetPalette ()
DECLARE SUB ClearPalette ()
DECLARE SUB GameScreen ()
DECLARE SUB Moving ()
COMMON SHARED x, y, a, px, bx, by, bxs, bys, xx, yy, xs, ys

DIM SHARED Paddle(32), Ball(7), WhiteBlock(50), PLACE(-10 TO 50, -10 TO 50)
SCREEN 13

PLAY "mf"

ClearPalette
Pictures
SetPalette
GameScreen

FOR y = 2 TO 10
 FOR x = 0 TO 9
  PLACE(x, y) = 1
  PUT (x * 20 + 2, y * 10 + 2), WhiteBlock
 NEXT
NEXT

px = 88
bx = 20 * 5 + 2: bxs = 0
by = 10 * 12 + 2: bys = 1
xx = 5: yy = 12
xs = 0: ys = 0

PUT (px, 190), Paddle
PUT (bx, by), Ball

DO
  _LIMIT 60
  Moving
LOOP UNTIL a = 1

DATA 00,08,44,40,08,08,08,08,08,08,08,08,08,08,08,08,08,08,08,08,08,44,40,08,00 , 00,11,09,08,00
DATA 08,13,48,44,13,13,13,13,12,12,12,11,11,10,10,10,10,10,09,09,09,48,44,09,08 , 11,13,10,09,07
DATA 08,13,44,40,13,13,12,12,11,11,11,10,10,10,10,09,09,09,09,09,08,44,40,08,08 , 10,11,09,08,06
DATA 08,13,40,38,13,12,11,11,10,10,10,09,09,09,08,08,08,08,07,07,07,40,38,07,08 , 08,08,08,06,05
DATA 00,08,40,38,08,08,08,08,08,08,08,08,08,08,08,08,08,08,08,08,08,40,38,08,00 , 00,07,07,05,00

DATA 00,09,09,09,09,09,09,09,09,09,09,09,09,09,09,09,09,09,09,00
DATA 09,13,14,16,14,14,14,14,14,14,14,13,13,13,13,13,13,13,12,06
DATA 09,14,16,14,14,14,14,13,13,13,13,12,12,12,12,11,11,11,11,06
DATA 09,14,16,14,14,13,13,13,12,12,12,11,11,11,11,11,11,11,11,06                                          
DATA 09,14,14,14,13,13,12,12,11,11,11,11,10,10,10,10,10,11,11,06
DATA 09,13,14,13,13,12,12,11,11,11,10,10,10,10,10,10,10,10,11,06
DATA 09,13,14,13,12,12,11,11,10,10,10,10,10,11,11,11,11,10,11,06
DATA 09,13,13,12,12,11,11,10,10,10,10,11,11,12,12,12,11,10,10,06
DATA 09,12,13,12,12,11,11,10,10,10,11,12,12,12,13,12,11,11,10,06                                            
DATA 00,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,06,00

SUB ClearPalette

  FOR i = 1 TO 255
   OUT (&H3C8), i
   OUT (&H3C9), 0
   OUT (&H3C9), 0
   OUT (&H3C9), 0
  NEXT

END SUB

SUB GameScreen

  FOR i = 1 TO 202
   PSET (i, 1), i / 32
  NEXT i
  FOR i = 1 TO 199
   PSET (202, i), i / 32 + 6.25
  NEXT i
  FOR i = 1 TO 202
   PSET (i, 199), i / 32 + 6.25
  NEXT i
  FOR i = 1 TO 199
   PSET (1, i), i / 32
  NEXT i
 
END SUB

SUB Moving

'-----------------------BALL--------------------------------------------------
  PUT (bx, by), Ball
  PUT (px, 190), Paddle
 
  bx = bx + bxs
  by = by + bys
  xs = xs + bxs
  ys = ys + bys
 
  IF (bx > 197) OR (bx < 2) THEN bxs = 0 - bxs
  IF by < 2 THEN bys = 0 - bys
  IF by > 193 THEN END
 
  IF xs > 19 THEN xx = xx + 1: xs = 0
  IF xs < 0 THEN xx = xx - 1: xs = 19
  IF ys > 9 THEN yy = yy + 1: ys = 0
  IF ys < 0 THEN yy = yy - 1: ys = 9

  IF (PLACE(xx, yy - 1) = 1) AND (ys < 1) THEN
    PLACE(xx, yy - 1) = 0
    bys = 0 - bys
    PUT (xx * 20 + 2, (yy - 1) * 10 + 2), WhiteBlock
  END IF
  IF (PLACE(xx, yy + 1) = 1) AND (ys > 4) THEN
    PLACE(xx, yy + 1) = 0
    bys = 0 - bys
    PUT (xx * 20 + 2, (yy + 1) * 10 + 2), WhiteBlock
  END IF
  IF (PLACE(xx + 1, yy) = 1) AND (xs > 14) THEN
    PLACE(xx + 1, yy) = 0
    bxs = 0 - bxs
    PUT ((xx + 1) * 20 + 2, yy * 10 + 2), WhiteBlock
  END IF
  IF (PLACE(xx - 1, yy) = 1) AND (xs < 1) THEN
    PLACE(xx - 1, yy) = 0
    bxs = 0 - bxs
    PUT ((xx - 1) * 20 + 2, yy * 10 + 2), WhiteBlock
  END IF

'---------------PADDLE & BALL-------------------------------------------------
  
   IF bx + 5 > px AND bx < px + 25 AND by > 184 AND by < 186 THEN
     IF bx + 2.5 > px + 12.5 THEN
       bxs = (bx - (px + 12.5)) / 5
     END IF
     IF bx + 2.5 < px + 12.5 THEN
       bxs = (bx - (px + 12.5)) / 5
     END IF
     bys = -bys
   END IF
 
'-----------------------PADDLE------------------------------------------------
  z$ = INKEY$
  a = INP(&H60)
 
  IF a = 75 THEN px = px - 2: IF px < 2 THEN px = 2
  IF a = 77 THEN px = px + 2: IF px > 175 THEN px = 175
 
  PUT (bx, by), Ball
  PUT (px, 190), Paddle
 
  PALETTE 0, 0
  
END SUB

SUB Pictures

  FOR y = 1 TO 5          'This draws ball & paddle
   FOR x = 1 TO 30
    READ a
    PSET (x, y), a
   NEXT
  NEXT
 
  FOR y = 6 TO 15         'This draws white block
   FOR x = 1 TO 20
    READ a
    PSET (x, y), a
   NEXT
  NEXT

  GET (1, 1)-(25, 5), Paddle     'Let's get pictures!
  GET (26, 1)-(30, 5), Ball
  GET (1, 6)-(20, 15), WhiteBlock

  CLS

END SUB

SUB SetPalette

 FOR i = 1 TO 16           'White : 1
  OUT (&H3C8), i
  OUT (&H3C9), i * 4 - 1
  OUT (&H3C9), i * 4 - 1
  OUT (&H3C9), i * 4 - 1
 NEXT
 FOR i = 1 TO 16           'Red : 16
  OUT (&H3C8), i + 16
  OUT (&H3C9), i * 4 - 1
  OUT (&H3C9), i
  OUT (&H3C9), 0
 NEXT
 FOR i = 1 TO 16           'Yellow : 32
  OUT (&H3C8), i + 32
  OUT (&H3C9), i * 4 - 1
  OUT (&H3C9), i * 4 - 1
  OUT (&H3C9), 0
 NEXT
 FOR i = 1 TO 16           'blue : 48
  OUT (&H3C8), i + 48
  OUT (&H3C9), i * 4 - 1
  OUT (&H3C9), i * 4 - 1
  OUT (&H3C9), 0
 NEXT

END SUB

