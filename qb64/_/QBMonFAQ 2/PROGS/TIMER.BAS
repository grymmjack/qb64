'***************************************************************
' TIMER.BAS = Erzeugung von Wartezeiten
' =========
' Der Anwender gibt eine Wartezeit in sec ein.
' Anschliessend wird die TIMER-Funktion
' verwendet, um den Programmablauf fuer diese
' Zeit anzuhalten. Wenn die Zeit abgelaufen
' ist, ertoent ein Piepston.
'
' (c) Thomas Antoni, 12.11.2003
'****************************************************************
CLS
PRINT "Gib eine Wartezeit in [sec] ein; ";
PRINT "Nachkommastellen erlaubt....t = ";
INPUT t!
starttime! = TIMER                  'Startzeit merken
'
DO
  PRINT TIMER - starttime!          'abgelaufene Zeit anzeigen
LOOP UNTIL TIMER > starttime! + t!  'Warteschleife
'
PRINT "Wartezeit ist abgelaufen"
BEEP
END

