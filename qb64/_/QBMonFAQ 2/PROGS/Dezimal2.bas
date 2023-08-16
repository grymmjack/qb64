'****************************************************************************
' DEZIMAL2.BAS =  Zerlegung einer Zahl in ihre Dezimalstellen (mit STR$)
' ============
' Dieses QBasic-Programm zerlegt eine lange Ganzzahl (Typkennzeichen "&")
' in ihre einzelnen Dezimalstellen und zeigt diese an.
' Das Programm wandelt die Zahl zunaechst in einen String um und isoliert
' dann die einzelnen Ziffernzeichen mit Hilfe des MID$ Befehls. Wer die
' einzelnen Ziffern als numerische Werte und nicht als Textzeichen benoetigt,
' kann sie mit dem VAL-Befehl wieder in Zahlenwerte zurueckwandeln.
'
' (c) Thomas Antoni, 7.1.2005
'****************************************************************************
CLS
INPUT "Gib die zu zerlegende Zahl an (max 2 Milliarden): ", z&
PRINT "Die Zahl hat folgende Dezimalstellen (von hinten nach vorne):"
Zahl$ = STR$(z&)            'Zahl in Zeichenkette (String) umwandeln
FOR i% = 1 TO LEN(Zahl$)    'Schleife ueber alle Ziffern-Zeichen
  PRINT MID$(Zahl$, i%, 1); " "; 'aktuelles Zeichen isolieren und anzeigen
NEXT i%


