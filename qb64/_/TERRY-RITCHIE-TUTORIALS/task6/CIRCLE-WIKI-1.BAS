SCREEN 12

r& = 200 'radius    change circle size and position here
cx& = 320 'center x horizontal
cy& = 240 'center y vertical

DO
  i = _MOUSEINPUT
  x& = _MOUSEX
  y& = _MOUSEY
  xy& = ((x& - cx&) ^ 2) + ((y& - cy&) ^ 2) 'Pythagorean theorem
  IF r& ^ 2 >= xy& THEN CIRCLE (cx&, cy&), r&, 10 ELSE CIRCLE (cx&, cy&), r&, 12
LOOP UNTIL INKEY$ = CHR$(27) 'escape key exit