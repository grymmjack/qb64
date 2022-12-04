REM Sprite (rotating figure) demonstration
REM \CHAP8\CH8_13.BAS

CLS : LOCATE 7, 31: PRINT "Press key E for end!"
DO
  F$ = INKEY$
  IF F$ = "E" OR F$ = "e" THEN END

  LOCATE 9, 38:  PRINT "     "   'Sprite element 1
  LOCATE 10, 38: PRINT "*----"
  LOCATE 11, 38: PRINT "     "
  GOSUB PAUSE

  LOCATE 9, 38:  PRINT "*    "   'Sprite element 2
  LOCATE 10, 38: PRINT "  \  "
  LOCATE 11, 38: PRINT "    \"
  GOSUB PAUSE

  LOCATE 9, 38:  PRINT "  *  "   'Sprite element 3
  LOCATE 10, 38: PRINT "  |  "
  LOCATE 11, 38: PRINT "  |  "
  GOSUB PAUSE

  LOCATE 9, 38:  PRINT "    *"   'Sprite element 4
  LOCATE 10, 38: PRINT "  /  "
  LOCATE 11, 38: PRINT "/    "
  GOSUB PAUSE

  LOCATE 9, 38:  PRINT "     "   'Sprite element 5
  LOCATE 10, 38: PRINT "----*"
  LOCATE 11, 38: PRINT "     "
  GOSUB PAUSE

  LOCATE 9, 38:  PRINT "\    "   'Sprite element 6
  LOCATE 10, 38: PRINT "  \  "
  LOCATE 11, 38: PRINT "    *"

  GOSUB PAUSE
  LOCATE 9, 38:  PRINT "  |  "    'Sprite element 7
  LOCATE 10, 38: PRINT "  |  "
  LOCATE 11, 38: PRINT "  *  "
  GOSUB PAUSE

  LOCATE 9, 38:  PRINT "    /"    'Sprite element 8
  LOCATE 10, 38: PRINT "  /  "
  LOCATE 11, 38: PRINT "*    "
  GOSUB PAUSE

LOOP

PAUSE:
  FOR i = 1 TO 1000: NEXT
RETURN

