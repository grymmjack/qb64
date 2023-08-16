'***************************************************************************
' ZAHLRAT.BAS = Zahlenraten in einem w„hlbaren Zahlenbereich
' ===========
' Alle Zahlenvariablen sind vom Typ LONG (Typbezeichner "&"). Damit koennen
' Zahlen bis zu ca. 2 Milliarden bearbeitet werden.
' (c) Thomas Antoni, 5.1.2005
'***************************************************************************
Anfang:
CLS
INPUT "Wie gross soll der Zahlenbereich sein? 1...", max&
RANDOMIZE TIMER                       'Zufallsgenerator initialisieren
zahl& = INT(RND * max&) + 1           'Zufallszahl zw. 1 und max erzeugen
PRINT "Ich habe mir jetzt eine Zahl zwischen 1 und"; max%; "ueberlegt"
PRINT zahl&
DO
INPUT "Was denkst Du, wie die Zahl lautet?", geraten&
IF geraten& < zahl& THEN
  PRINT "Die Zahl ist zu klein! Rate erneut"
ELSEIF geraten& > zahl& THEN
  PRINT "Die Zahl ist zu gross! Rate erneut"
ELSE
  PRINT "Gratulation, Du hast richtig geraten"
  PRINT "[Beliebige Taste]...noch ein Zahlenraten   [Esc]...beenden"
  DO: taste$ = INKEY$: LOOP WHILE taste$ = ""  'warten auf Tastenbetaetigung
  IF taste$ = CHR$(27) THEN END ELSE GOTO Anfang
END IF
LOOP

