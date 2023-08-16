'********************************************************************
' PIXCOLOR.BAS = Farbe eines Bildschirm-Pixels abfragen
' ============
' (c) Pawel, 1999
'********************************************************************
SCREEN 9
COLOR , 1         'Blauer Bildschirmhintergrund
PSET (10, 10), 12 'einen hellroten (12) Punkt an der Position
                  ' (10, 10) setzen
LOCATE 2: PRINT POINT(10, 10) ' die Farbnummer des Bildschirmpunktes
                  ' an der Position (10, 10) ausdrucken
PRINT POINT(1, 1) ' wenn man einen Punkt in einer von Grafik freien
                  ' Bildschirmposition ausliest, liefert die Funktion
                  ' den Wert 0, unabhaengig von der Farbe des
                  ' Bildschirmhintergrunds
