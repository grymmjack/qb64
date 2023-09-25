' *********** CHECK README.1ST FIRST *********************

SCREEN 7, , 1, 0

ss = 7

FOR i = 1 TO ss
 READ a
 t(i) = a
NEXT i

DO
  PCOPY 2, 1
  FOR i = 1 TO ss - 1
   x = 75 * COS(t(i)) + 160
   y = 75 * SIN(t(i)) + 100
   x2 = 75 * COS(t(i + 1)) + 160
   y2 = 75 * SIN(t(i + 1)) + 100
   LINE (x, y)-(x2, y2), 0
  NEXT i
  FOR i = 1 TO ss
   t(i) = t(i) + .05
  NEXT i
  FOR i = 1 TO ss - 1
   x = 75 * COS(t(i)) + 160
   y = 75 * SIN(t(i)) + 100
   x2 = 75 * COS(t(i + 1)) + 160
   y2 = 75 * SIN(t(i + 1)) + 100
   LINE (x, y)-(x2, y2), 7
  NEXT i
  PAINT (160, 100), 15, 7
  PCOPY 1, 0
  z$ = INKEY$
LOOP UNTIL z$ = CHR$(27)

DATA 0,1.1,2.1,3.2,4.2,5.2,6.3

