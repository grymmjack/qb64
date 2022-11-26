SCREEN 12
d = _DEVICES
PRINT "Number of input devices found ="; d
FOR i = 1 TO d
  PRINT _DEVICE$(i)
  buttons = _LASTBUTTON(i)
  PRINT "Buttons:"; buttons
NEXT

DO: _LIMIT 50
  LOCATE 10, 1
  PRINT "   X    Main    Y          Slider         Z-axis           POV"
  PRINT STICK(0, 1), STICK(1, 1), STICK(0, 2), STICK(1, 2), STICK(0, 3); STICK(1, 3); "   "
  PRINT "                   Buttons"
  FOR i = 0 TO 4 * buttons - 1 STEP 4
    PRINT STRIG(i); STRIG(i + 1); CHR$(219);
  NEXT
  PRINT
LOOP UNTIL INKEY$ <> "" 
