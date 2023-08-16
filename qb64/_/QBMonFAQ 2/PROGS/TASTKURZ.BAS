'***********************************************************
' TASTKURZ.BAS = Zeitlich auf 5 sec begrenzte Tasteneingabe
' ============
' (c) Thomas Antoni, 25.8.02 - 26.2.04
'***********************************************************
CLS
PRINT "Auf 5 sec je Tastenbetaetigung begrenzte Eingabe"
PRINT "Gib Text ein; Abschluss mit Eingabe-Taste:"
starttime! = TIMER
DO
  LOCATE , , 1                  'display cursor
  x$ = INKEY$
  IF x$ = CHR$(13) THEN EXIT DO 'Exit with Enter Key
  IF x$ <> "" THEN
    y$ = y$ + x$
    LOCATE , 1
    PRINT y$;
    starttime! = TIMER          'restart timer
  END IF
LOOP UNTIL TIMER > starttime! + 5
'
PRINT
PRINT "Du hast Folgendes eingegeben.... "; y$

