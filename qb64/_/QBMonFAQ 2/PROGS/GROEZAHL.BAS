'***************************************************************************
' GROEZAHL.BAS = Ermittlung der groessten aus einer Reihe von Zahlen
' ===========
' Dieses QBasic-Programm erfragt vom Anwender 10 Zahlen, die in das Feld
' ZahlFeld eingetragen werden. Nach der Eingabe einer Zahl vergleicht das
' Programm den Eingabewert mit dem vorherigen. Ist der neue Wert groesser
' als der Alte, wird er zur aktuell groessten zahl erklaert.
'
' (c) Thomas Antoni, 6.1.2005
'***************************************************************************
DIM ZahlFeld(9)  'Zahlenfeld mit 10 Feldelementen deklarieren
                 '(Feldelement-Nummern 0...9)
DO
CLS
FOR i% = 0 TO 9  'Schleife ber alle Feldelemente
  PRINT "Gib die "; i% + 1; ". Zahl ein";
  INPUT ZahlFeld(i)
  IF i% = 0 THEN
    GroeZahl = ZahlFeld(0) 'Vorbesetzung: Groesste Zahl = erste Zahl
  ELSE
    IF ZahlFeld(i%) > ZahlFeld(i% - 1) THEN GroeZahl = ZahlFeld(i%)
  END IF
NEXT i%
PRINT "Die groesste Zahl ist "; GroeZahl
PRINT "[Beliebige Taste]...noch einmal   [Esc]...beenden"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""  'warten auf Tastenbetaetigung
IF taste$ = CHR$(27) THEN END
LOOP

