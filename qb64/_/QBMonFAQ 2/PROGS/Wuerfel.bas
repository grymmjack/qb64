'************************************************************************
' WUERFEL.BAS = Elektronischer Wuerfel
' ===========
' Bei jeder Tastenbetaetigung wird eine Zufallszahl zwischen 1 und 6
' erzeugt und angezeigt.
' (c) Thomas Antoni, 28.10.2003 - 7.11.2003
'************************************************************************
CLS                               'Bildschirm loeschen
DO
  RANDOMIZE TIMER                 'Zufallszahlengenerator initialisieren
  Wuerfelzahl% = INT(RND * 6) + 1 'ganzzahlige Zufallszahl zwischen 1 u.6
  PRINT Wuerfelzahl%
  DO
    taste$ = INKEY$
  LOOP WHILE taste$ = ""          'Warten auf Tastenbetaetigung
LOOP UNTIL taste$ = CHR$(27)      'Wiederholung bis Esc-Taste betaetigt
END

