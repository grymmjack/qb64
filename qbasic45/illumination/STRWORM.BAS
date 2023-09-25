' *********** CHECK README.1ST FIRST *********************

'                      Very strange worm!

SCREEN 13

DEF SEG = &HA000

DIM x(10), y(10), t(10)

FOR i = 1 TO 10
 t(i) = i / 20
NEXT i

DO
_LIMIT 30
  
  FOR i = 1 TO 10
   xx = 150 * COS(t(i) * 2.32) + 160
   yy = 90 * SIN(t(i) * 3.432) + 100
   FOR a = 5 TO 7
     CIRCLE (xx, yy), a, 0
   NEXT
   t(i) = t(i) + .01
   xx = 150 * COS(t(i) * 2.32) + 160
   yy = 90 * SIN(t(i) * 3.432) + 100
   FOR a = 5 TO 7
     CIRCLE (xx, yy), a, i + 17 - (a - 5)
   NEXT
  NEXT
  
  PALETTE 0, 0
  
LOOP UNTIL INKEY$ <> ""



