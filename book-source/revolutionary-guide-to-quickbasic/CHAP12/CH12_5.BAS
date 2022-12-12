 REM Joystick tester in graphics mode
 REM \CHAP12\CH12_5.BAS

 SCREEN 12
 CLS
 X = 320: Y = 175
 WHILE INKEY$ <> "X"
     DX = X: DY = Y
     COLOR 11: LOCATE 1, 1: PRINT "HORIZONTAL : "; STICK(0)
     LOCATE 2, 1: PRINT "VERTICAL : "; STICK(1)
     LOCATE 3, 1: PRINT "Button One : ";
     IF STRIG(0) = -1 THEN PRINT "Down" ELSE PRINT "Up"
     COLOR 10: LOCATE 1, 74: PRINT "e(X)it";
     IF STICK(0) < 120 AND X > 1 THEN X = X - 1
     IF STICK(0) > 150 AND X < 639 THEN X = X + 1
     IF STICK(1) < 70 AND Y > 1 THEN Y = Y - 1
     IF STICK(1) > 130 AND Y < 349 THEN Y = Y + 1
     PSET (DX, DY), 0
     PSET (X, Y), 14
 WEND

