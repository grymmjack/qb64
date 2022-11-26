
DIM SHARED Button AS LONG    'share variable value with Sub

t1 = _FREETIMER              'get a timer number from _FREETIMER ONLY!
ON TIMER(t1, .01) MouseClick
TIMER(t1) ON

DO
  LOCATE 1, 1
  _LIMIT 60
  IF Button THEN
    PRINT "Mouse button"; Button; "is pressed.";
  ELSE PRINT SPACE$(70)
  END IF
  _DISPLAY
LOOP UNTIL INKEY$ = CHR$(27)
TIMER(t1) OFF
TIMER(t1) FREE 'release timer
END

SUB MouseClick
DO WHILE _MOUSEINPUT
  IF _MOUSEBUTTON(1) THEN
    COLOR 10: Button = 1
  ELSEIF _MOUSEBUTTON(2) THEN
    COLOR 12: Button = 2
  ELSE Button = 0
  END IF
LOOP
END SUB 
