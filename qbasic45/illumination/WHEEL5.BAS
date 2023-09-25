' *********** CHECK README.1ST FIRST *********************

SCREEN 13

s = 0
s1 = 0

DO

  FOR i = 16 TO 31
   s = s + .0666
   x = 95 * COS(s)
   y = 95 * SIN(s)
   LINE (160, 100)-(x + 160, y + 100), 0
  NEXT i

  FOR i = 16 TO 31
   s = s + .0666
   x = 95 * COS(s)
   y = 95 * SIN(s)
   LINE (160, 100)-(x + 160, y + 100), i
  NEXT i

LOOP UNTIL INKEY$ <> ""

