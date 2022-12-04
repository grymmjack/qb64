REM Bouncing a ball
REM \CHAP8\CH8_16.BAS

 SCREEN 2: CIRCLE (20, 20), 4, , , , .5
 PAINT (20, 20), 3: DIM ball%(10)
 GET (16, 16)-(24, 24), ball%
 'Set starting coordinates and their increments
 Xcor = 16: Ycor = 16
 dX = 1: dY = 1
 'Drawing frame and screen text
 LINE (0, 0)-(639, 199), , B
 LOCATE 8, 26: PRINT "Move a ball around the screen"
 LOCATE 12, 30: PRINT " Press any key to quit"
 'Move a ball around the screen
 DO WHILE INKEY$ = ""
     IF Ycor > 190 OR Ycor < 1 THEN dY = -dY 'Reflection of X
     IF Xcor > 630 OR Xcor < 1 THEN dX = -dX 'Reflection of Y
     oldXcor = Xcor: oldYcor = Ycor
     Ycor = Ycor + dY: Xcor = Xcor + dX
     PUT (oldXcor, oldYcor), ball% 	   'Put 1
     PUT (Xcor, Ycor), ball%		   'Put 2
     FOR i = 1 TO 10: NEXT i		   'Pause
 LOOP
 CLS : END