 REM Joystick button beep 
 REM \CHAP12\CH12_3.BAS
 
 CLS
 PRINT "Press Esc or joystick button to exit"
 DO
     IF STRIG(0) OR INKEY$ = CHR$(27) THEN EXIT DO
 LOOP
 DO
     BEEP 'Generates a sound signal (BEEP) when trigger A is  pressed
 LOOP WHILE STRIG(1) 