'******************************************************
' BLINKTXT.BAS = Blinkenden Text anzeigen
' ============
'
' (c) Thomas Antoni, 10.2.2004
'******************************************************
CLS
DO
  LOCATE 1, 1
  PRINT "Blinkender Text"
  t = TIMER
  DO: LOOP WHILE TIMER < t + .3
  LOCATE 1, 1
  PRINT SPC(15);            'Text loeschen
  t = TIMER
  DO: LOOP WHILE TIMER < t + .3
LOOP UNTIL INKEY$ <> ""     'Abbruch mit beliebig.Taste
END

