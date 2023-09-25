' *********** CHECK README.1ST FIRST *********************

DECLARE SUB Palet1 ()
DECLARE SUB Alus1 ()
DECLARE SUB Keys1 ()

COMMON SHARED x, y, xa1, ya1, d, turn1, turn2, forw, fire, xx, yy
COMMON SHARED a, kerta, padit

CONST pi = 3.1415

SCREEN 13
padit = 5
DIM SHARED a1(400), x1(padit), y1(padit), p1(padit), xs1(padit), ys1(padit)

Palet1
Alus1

CLS

LINE (0, 0)-(319, 199), 15, B

x = 101
xa1 = 50
ya1 = 50
d = 0
turn1 = 0
turn2 = 0
forw = 2
fire = 2

xx = COS(d)
yy = SIN(d)

PUT (xa1, ya1), a1(x)

DO
  Keys1
LOOP UNTIL INP(&H60) = 1

10                                      'punainen alus

DATA 00,00,00,38,42,42,39,00,00,00
DATA 00,37,77,42,42,42,42,77,37,00
DATA 00,42,42,42,59,57,42,41,40,00
DATA 38,42,42,60,56,56,55,41,40,37
DATA 42,42,58,56,56,56,56,53,40,39
DATA 42,42,58,56,56,56,55,53,40,39
DATA 38,42,42,55,56,56,53,41,40,37
DATA 00,42,42,42,53,53,42,41,40,00
DATA 00,37,42,41,41,41,40,40,37,00
DATA 00,00,00,38,41,40,37,00,00,00

20

DATA 00,00,00,38,42,42,77,00,00,00
DATA 00,37,42,42,42,42,41,40,37,00
DATA 00,42,42,42,60,60,42,41,40,00
DATA 38,42,42,60,56,56,59,41,40,37
DATA 42,42,57,56,56,56,56,57,40,77
DATA 42,42,55,56,56,56,55,53,41,40
DATA 38,42,42,53,56,56,53,41,40,37
DATA 00,42,42,42,53,53,42,41,40,00
DATA 00,37,42,41,41,41,40,40,37,00
DATA 00,00,00,38,41,40,37,00,00,00

DATA 00,00,00,38,42,42,39,00,00,00
DATA 00,37,41,42,42,42,41,40,37,00
DATA 00,42,42,42,59,57,42,40,77,00
DATA 38,42,42,60,56,56,55,41,40,37
DATA 42,42,58,56,56,56,56,53,40,39
DATA 42,42,58,56,56,56,55,53,40,39
DATA 38,42,42,55,56,56,53,41,40,37
DATA 00,42,42,42,53,53,42,41,77,00
DATA 00,37,42,41,41,41,40,40,37,00
DATA 00,00,00,38,41,40,37,00,00,00

'------------------

30                                      'vihree alus

DATA 00,00,00,85,89,89,86,00,00,00
DATA 00,84,77,89,89,89,89,77,84,00
DATA 00,89,89,89,59,57,89,88,87,00
DATA 85,89,89,60,56,56,55,88,87,84
DATA 89,89,58,56,56,56,56,53,87,86
DATA 89,89,58,56,56,56,55,53,87,86
DATA 85,89,89,55,56,56,53,88,87,84
DATA 00,89,89,89,53,53,89,88,87,00
DATA 00,84,89,88,88,88,87,87,84,00
DATA 00,00,00,85,88,87,84,00,00,00

40

DATA 00,00,00,85,89,89,77,00,00,00
DATA 00,84,89,89,89,89,88,87,84,00
DATA 00,89,89,89,60,60,89,88,87,00
DATA 85,89,89,60,56,56,59,88,87,84
DATA 89,89,57,56,56,56,56,57,87,77
DATA 89,89,55,56,56,56,55,53,88,87
DATA 85,89,89,53,56,56,53,88,87,84
DATA 00,89,89,89,53,53,89,88,87,00
DATA 00,84,89,88,88,88,87,87,84,00
DATA 00,00,00,85,88,87,84,00,00,00

DATA 00,00,00,85,89,89,86,00,00,00
DATA 00,84,88,89,89,89,88,87,84,00
DATA 00,89,89,89,59,57,89,87,77,00
DATA 85,89,89,60,56,56,55,88,87,84
DATA 89,89,58,56,56,56,56,53,87,86
DATA 89,89,58,56,56,56,55,53,87,86
DATA 85,89,89,55,56,56,53,88,87,84
DATA 00,89,89,89,53,53,89,88,77,00
DATA 00,84,89,88,88,88,87,87,84,00
DATA 00,00,00,85,88,87,84,00,00,00

SUB Alus1

 FOR y = 1 TO 30
  FOR x = 1 TO 10
   READ a
   PSET (x, y), a
  NEXT x
 NEXT y

 RESTORE 10
 FOR y = 50 TO 30 STEP -1
  FOR x = 1 TO 10
   READ a
   PSET (x, y), a
  NEXT x
 NEXT y

 RESTORE 20
 FOR y = 60 TO 51 STEP -1
  FOR x = 10 TO 1 STEP -1
   READ a
   PSET (x, y), a
  NEXT x
 NEXT y

 RESTORE 20
 FOR y = 80 TO 61 STEP -1
  FOR x = 10 TO 1 STEP -1
   READ a
   PSET (x, y), a
  NEXT x
 NEXT y

 RESTORE 20
 FOR y = 71 TO 80
  FOR x = 10 TO 1 STEP -1
   READ a
   PSET (x, y), a
  NEXT x
 NEXT y

'----------------------------------------------
 RESTORE 30
 FOR y = 1 TO 30
  FOR x = 1 TO 10
   READ a
   PSET (x, y + 85), a
  NEXT x
 NEXT y

 RESTORE 30
 FOR y = 50 TO 30 STEP -1
  FOR x = 1 TO 10
   READ a
   PSET (x, y + 85), a
  NEXT x
 NEXT y

 RESTORE 40
 FOR y = 60 TO 51 STEP -1
  FOR x = 10 TO 1 STEP -1
   READ a
   PSET (x, y + 85), a
  NEXT x
 NEXT y

 RESTORE 40
 FOR y = 80 TO 61 STEP -1
  FOR x = 10 TO 1 STEP -1
   READ a
   PSET (x, y + 85), a
  NEXT x
 NEXT y

 RESTORE 40
 FOR y = 71 TO 80
  FOR x = 10 TO 1 STEP -1
   READ a
   PSET (x, y + 85), a
  NEXT x
 NEXT y
 'END

'----------------------------------------------


 B = 1

 FOR i = 1 TO 80 STEP 10
  GET (1, i + 85)-(10, i + 9 + 85), a1(B)
  B = B + 50
 NEXT i

END SUB

SUB Keys1
 
  z$ = INKEY$
  a = a + 1
  PALETTE 1, 1
  'PALETTE 1, 1

  IF INP(&H60) = 77 AND a > 7 THEN turn1 = 1
  IF INP(&H60) = 77 + 128 THEN turn1 = 2

  IF INP(&H60) = 75 AND a > 7 THEN turn2 = 1
  IF INP(&H60) = 75 + 128 THEN turn2 = 2

  IF INP(&H60) = 72 THEN forw = 1
  IF INP(&H60) = 72 + 128 THEN forw = 2

  IF INP(&H60) = 57 THEN fire = 1
  IF INP(&H60) = 57 + 128 THEN fire = 2
'----------------------------------------TURNING------------------------------
  SELECT CASE turn1
   CASE 1
    IF a > 7 THEN
     turn = 0
     PUT (xa1, ya1), a1(x)
     a = 1
     d = d + ((pi / 180) * 45)
     xx = COS(d)
     yy = SIN(d)
     x = x + 50
     IF x > 400 THEN x = 1
     PUT (xa1, ya1), a1(x)
    END IF
  END SELECT

  SELECT CASE turn2
   CASE 1
    IF a > 7 THEN
     turn = 0
     PUT (xa1, ya1), a1(x)
     a = 1
     d = d - ((pi / 180) * 45)
     xx = COS(d)
     yy = SIN(d)
     x = x - 50
     IF x < 1 THEN x = 351
     PUT (xa1, ya1), a1(x)
    END IF
  END SELECT
'----------------------------------------FORWARD------------------------------
  SELECT CASE forw
   CASE 1
     PUT (xa1, ya1), a1(x)
     xa1 = xa1 + xx
     ya1 = ya1 + yy
     PUT (xa1, ya1), a1(x)
   CASE 2
     PUT (xa1, ya1), a1(x)
     xxx = xx / 2
     yyy = yy / 2
     xa1 = xa1 + xxx
     ya1 = ya1 + yyy
     PUT (xa1, ya1), a1(x)
  END SELECT
'----------------------------------------FIRE---------------------------------
  SELECT CASE fire
   CASE 1
     kerta = kerta + 1
     FOR i = 1 TO padit
       IF p1(i) = 0 AND kerta > 10 THEN
         kerta = 1
         j1 = xa1 + 5
         j2 = ya1 + 5
         x1(i) = j1 + (xx * 11)
         y1(i) = j2 + (yy * 11)
         p1(i) = 1
         xs1(i) = xx * 2
         ys1(i) = yy * 2
         EXIT FOR
       END IF
       PSET (x1(i), y1(i)), 0
       x1(i) = x1(i) + xs1(i)
       y1(i) = y1(i) + ys1(i)
       IF x1(i) < 3 OR x1(i) > 316 OR y1(i) < 3 OR y1(i) > 196 THEN
         p1(i) = 0
         PSET (x1(i), y1(i)), 0
         x1(i) = -5
         y1(i) = -5
       END IF
       PSET (x1(i), y1(i)), 15
     NEXT
   CASE 2
     FOR i = 1 TO padit
      PSET (x1(i), y1(i)), 0
      x1(i) = x1(i) + xs1(i)
      y1(i) = y1(i) + ys1(i)
      IF x1(i) < 3 OR x1(i) > 316 OR y1(i) < 3 OR y1(i) > 196 THEN
        p1(i) = 0
        
        PSET (x1(i), y1(i)), 0
        x1(i) = -5
        y1(i) = -5
      END IF
      PSET (x1(i), y1(i)), 15
     NEXT
  END SELECT

END SUB

SUB Palet1

  FOR i = 1 TO 16               'Punainen
   OUT (&H3C8), i + 31
   OUT (&H3C9), i * 4 - 1
   OUT (&H3C9), i * 3 - 1
   OUT (&H3C9), i * 2 - 1
  NEXT
 
  FOR i = 1 TO 16               'Sininen
   OUT (&H3C8), i + 47
   OUT (&H3C9), i
   OUT (&H3C9), i * 3.5 - 1
   OUT (&H3C9), i * 4 - 1
  NEXT

  FOR i = 1 TO 16               'Keltainen
   OUT (&H3C8), i + 63
   OUT (&H3C9), i * 4 - 1
   OUT (&H3C9), i * 3.5 - 1
   OUT (&H3C9), i
  NEXT

  FOR i = 1 TO 16               'Vihree
   OUT (&H3C8), i + 79
   OUT (&H3C9), i * 2 - 1
   OUT (&H3C9), i * 4 - 1
   OUT (&H3C9), i * 2 - 1
  NEXT

END SUB

