' *********** CHECK README.1ST FIRST *********************

SCREEN 13

  X = 160
  y = 100
  xx = 160
  yy = 100

FOR a = 1 TO 100

  PALETTE a, INT(B * .63) + INT(C * .63) * 256 + INT(D * .63) * 65536

  B = B + 1: C = C + .7: D = D + 0

NEXT a

LINE (X, y)-(xx, yy)

RANDOMIZE TIMER

DO
   IF INKEY$ <> "" THEN END
  LINE (X, y)-(xx, yy), 14
   X = X - 1: xx = xx + 1
   y = y - 1: yy = yy + 1

LOOP UNTIL y = 0

DO
 
a = 0: aa = 1
 
  DO
 
   IF INKEY$ <> "" THEN END
   a = a + aa
 
   LINE (X, y)-(xx, yy), a
    X = X + 1: xx = xx - 1

   IF xx < 162 THEN aa = -1
   FOR i = 1 TO 300: NEXT i

  LOOP UNTIL xx = 80
 
  DO
  
   IF INKEY$ <> "" THEN END
   LINE (X, y)-(xx, yy), 0
    X = X - 1
    xx = xx + 1

   FOR i = 1 TO 300: NEXT i
 
  LOOP UNTIL xx = 260

   a = 0: aa = 1

  DO
  
   IF INKEY$ <> "" THEN END
   a = a + aa

   LINE (X, y)-(xx, yy), a
    y = y + 1: yy = yy - 1

   IF yy < 102 THEN aa = -1
  
   FOR i = 1 TO 300: NEXT i

  LOOP UNTIL yy = 0

  DO
   
   IF INKEY$ <> "" THEN END
   col = 0

   LINE (X, y)-(xx, yy), col
    y = y - 1: yy = yy + 1

   FOR i = 1 TO 300: NEXT i
 
  LOOP UNTIL yy = 200
_LIMIT 30

LOOP UNTIL INKEY$ <> ""




