REM Demonstration of an asterisk rotating around text
REM \CHAP8\CH8_14.BAS

CLS
 DO
     LOCATE 10, 30: PRINT "Press key E for end!"
     FOR W = .2 TO 6 STEP .24
         X = 40 + 15 * COS(W)
         Y = 10 + 6 * SIN(W)
         LOCATE Y, X: PRINT "*"
         GOSUB PAUSE
         LOCATE Y, X: PRINT " "
     NEXT W
     GOSUB PAUSE
 LOOP

 PAUSE:
 FOR i = 1 TO 1000: NEXT
 X$ = INKEY$
 IF X$ = "E" OR X$ = "e" THEN END
 RETURN