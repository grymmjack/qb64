 REM Joystick button detection
 REM \CHAP12\CH12_2.BAS

 CLS
 ON STRIG(0) GOSUB Handler
 STRIG(0) ON
 PRINT "Press Esc to exit"
 DO UNTIL INKEY$ = CHR$(27): LOOP
 END

 Handler:
   PRINT "Joystick Trigger is Pressed "
 RETURN