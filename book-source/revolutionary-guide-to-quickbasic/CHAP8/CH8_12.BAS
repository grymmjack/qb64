REM Sprite (rotation of a little line) demonstration
REM \CHAP8\CH8_12.BAS

CLS : LOCATE 8, 32: PRINT "Press E for end! "
DO
  LOCATE 10, 40: PRINT "-": GOSUB PAUSE  'Sprite element 1
  LOCATE 10, 40: PRINT "\": GOSUB PAUSE  'Sprite element 2
  LOCATE 10, 40: PRINT "|": GOSUB PAUSE  'Sprite elememt 3
  LOCATE 10, 40: PRINT "/": GOSUB PAUSE  'Sprite element 4
  F$ = INKEY$
  IF F$ = "E" OR F$ = "e" THEN END
LOOP

PAUSE:
  FOR i = 1 TO 1000: NEXT
RETURN

