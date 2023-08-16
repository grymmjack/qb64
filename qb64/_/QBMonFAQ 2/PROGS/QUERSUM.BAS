'**********************************************************
' QUERSUM.BAS - Die Quersumme einer Zahl berechnen
' ===========
' Dieses QBasic-Programm berechnet die Quersumme
' der vom Anwender eingebenen Zahl. Die Quersumme
' ist die Summe der einzelnen Dezimalstellen.
'
' ...::: Beispiel
' Quersumme von 324 = 3 + 2 + 4 = 9
'
' ...::: Realisierung
' Die Programm wandelt erst mit STR$ die Eingabezahl in
' einen String um. Diesen zerlegt es dann mit MID$ in
' die einzelnen Dezimalstellen. Die Dezimalstellen werden
' dann wiederum mit VAL in Zahlen von 0...9 umgewandelt,
' welche zur Bildung der Quersumme miteinander addiert
' werden.
'
' (c) Thomas Antoni, 16.3.2004
'***********************************************************
CLS
DO
quersumme% = 0
INPUT " Gib eine ganze Zahl ein....: ", z&
zs$ = STR$(z&)         'Zahl in String umwandeln
FOR i% = 1 TO LEN(zs$)
  dezi$ = MID$(zs$, i%, 1)
  quersumme% = quersumme% + VAL(dezi$)
                       'VAL wandelt Dezimalstelle in Zahl um
NEXT
PRINT " Die Quersumme ist..........:"; quersumme%
PRINT
PRINT " ....neue Eingabe mit beliebiger Taste ";
PRINT " ....beenden mit ESC"
PRINT
taste$ = INPUT$(1)     'Warten bis 1 Taste eingelesen
LOOP UNTIL taste$ = CHR$(27)
                       'Abbruch mit Esc
END

