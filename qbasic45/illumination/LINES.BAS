' *********** CHECK README.1ST FIRST *********************

SCREEN 12

   X1 = 2: Y1 = 2
   X2 = 100: Y2 = 80
   X1S = 3: Y1S = 3
   X2S = 3: Y2S = 3
  
   X3 = 2: Y3 = 2
   X4 = 100: Y4 = 80
   X3S = 0: Y3S = 0
   X4S = 0: Y4S = 0

FOR a = 1 TO 15

  PALETTE a, INT(B * .63) + INT(C * .63) * 256 + INT(D * .63) * 65536
  B = B + 2: C = C + 7: D = D + 7

NEXT a

  a = 1: aa = 1
  Lisays = 1

DO
   a = a + aa
   IF a < 1 THEN aa = 1
   IF a > 15 THEN aa = -1

   Lisays = Lisays + 1
   IF Lisays > 200 AND Lisays < 202 THEN
     X3S = 3: Y3S = 3
     X4S = 3: Y4S = 3
   END IF

   LINE (X1, Y1)-(X2, Y2), a
   LINE (X3, Y3)-(X4, Y4), 0
  
   X1 = X1 + X1S: Y1 = Y1 + Y1S
   X2 = X2 + X2S: Y2 = Y2 + Y2S

   X3 = X3 + X3S: Y3 = Y3 + Y3S
   X4 = X4 + X4S: Y4 = Y4 + Y4S


   IF X1 > 640 THEN X1S = -5
   IF X1 < 1 THEN X1S = 2
   IF Y1 > 480 THEN Y1S = -1
   IF Y1 < 1 THEN Y1S = 3

   IF X2 > 640 THEN X2S = -7
   IF X2 < 1 THEN X2S = 3
   IF Y2 > 480 THEN Y2S = -2
   IF Y2 < 1 THEN Y2S = 5

   IF X3 > 640 THEN X3S = -5
   IF X3 < 1 THEN X3S = 2
   IF Y3 > 480 THEN Y3S = -1
   IF Y3 < 1 THEN Y3S = 3

   IF X4 > 640 THEN X4S = -7
   IF X4 < 1 THEN X4S = 3
   IF Y4 > 480 THEN Y4S = -2
   IF Y4 < 1 THEN Y4S = 5
  
  
   'FOR i = 1 TO 1000: NEXT i

LOOP UNTIL INKEY$ <> ""

