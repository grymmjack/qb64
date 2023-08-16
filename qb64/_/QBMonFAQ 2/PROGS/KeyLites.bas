'*******************************************************
' KeyLites.bas = Num-LED an der Tastatur blinken lassen
' ============
'
' (c) A.K., 23.6.2003 - 2.7.2003
'*******************************************************
DEF SEG = &H40
DO
  starttime! = TIMER
  DO: LOOP UNTIL TIMER > starttime! + .3 '0,3 sec Wartezeit
  POKE (&H17), 0
  starttime! = TIMER
  DO: LOOP UNTIL TIMER > starttime! + .3 '0,3 sec Wartezeit
  POKE (&H17), 32
LOOP UNTIL INKEY$ = CHR$(27) 'Abbruch mit Esc
DEF SEG

