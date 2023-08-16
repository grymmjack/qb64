'***********************************************************
' TRIM_ALL.BAS - Entfernt alle Leerzeichen aus einem String
' ============
' (c) Thomas Antoni, 26.8.02 - 26.2.04
'***********************************************************
CLS
t2$ = ""                'Ergebnisstring ruecksetzen
INPUT "Gib einen String mit Blanks ein:........ ", t1$
FOR i% = 1 TO LEN(t1$)  'Schleife ueber alle Textzeichen
  z$ = MID$(t1$, i%, 1) 'Zeichen isolieren
  IF z$ <> " " THEN t2$ = t2$ + z$
                        'Zeichen anfuegen falls kein Blank
NEXT
PRINT "Der String ohne Leerzeichen lautet:..... "; t2$
SLEEP



