'***************************************************************
' MaTrain1.bas = Einfacher Mathetrainer fuer das Addieren
' ============
' Dieses Q(uick)Basic-Programm trainiert das Addieren von
' zwei Zahlen zwischen 1 und 99.
'
' (c) Thomas Antoni, 03.07.2005
'***************************************************************
'
CLS
DO
RANDOMIZE TIMER         'Zufallsgenerator initialisieren
z1% = INT(RND * 99) + 1 'Zufallszahl zwischen 1 und 99
z2% = INT(RND * 99) + 1
PRINT "Wieviel ist"; z1%; " + "; z2%;
INPUT erg%
'
IF erg% = z1% + z2% THEN
  PRINT "Richtig!"
ELSE
  PRINT "Falsch!"
  PRINT "Das Ergebnis lautet "; z1% + z2%
END IF
'
PRINT
PRINT "___Neue Aufgabe...[beliebige Taste]___Beenden...[Esc]___"
PRINT
DO: t$ = INKEY$: LOOP UNTIL t$ <> ""  'Warten auf Tastendruck
LOOP UNTIL t$ = CHR$(27)              'Programmende bei Esc
END

