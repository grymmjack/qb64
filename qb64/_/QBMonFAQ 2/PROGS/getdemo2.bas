'****************************************************************************
' GETDEMO2.BAS = Demonstration 2 fuer den GET-Befehl
' ============
' Dieses QBasic-Programm demonstriert den GET-befehl. Es zeichnet ein
' aus vier Punkten bestehendes Rechteck und liest dieses mit dem
' GET-befehl aus. Die Groesse des Rechtecks kann geaendert werden.
' In diesem Fall muss eventuell auch die  Dimensionierung des Feldes a
' angepasst werden.
'
' (c) Karl Pircher ("Ch@rly" karl.pircher*gmx.net), 24.03.2004
'****************************************************************************
'
DEFINT A-Z
DIM a(0 TO 6) AS INTEGER             'Dimensionieren fÅr das Einlesen der
                                     'Daten
SCREEN 13                            'Umschalten auf Screen 13
PSET (1, 1), 1                       'Setzen Punkt 1 Zeile 1 auf Farbe 1
PSET (2, 1), 3                       'Setzen Punkt 2 Zeile 1 auf Farbe 3
PSET (1, 2), 4                       'Setzen Punkt 1 Zeile 2 auf Farbe 1
PSET (2, 2), 14                      'Setzen Punkt 2 Zeile 2 auf Farbe 3
GET (1, 1)-(2, 2), a                 'Grafik (2 x 2 Pixel) in Feld einlesen
'
Breite = a(0) / 8
Hoehe = a(1)
'
PRINT
PRINT "Breite: "; Breite
PRINT "Hoehe : "; Hoehe
'
'-------------------------------------Alle Punkte auslesen und anzeigen
FOR y = 0 TO Hoehe - 1               'Schleife pro Zeile
   FOR x = 0 TO Breite - 1           'Schleife pro Spalte
      t = 4 + y * Breite + x         'Element berechnen: 4 Byte fuer Header
                                     'Multiplizieren Zeile mal Breite plus
                                     'Spalte.
      Element = t \ 2                'Dividiert durch 2, da das Feld als
                                     'Integer dimensioniert ist.
      byte = t MOD 2                 'Byte bestimmen. Wenn das Pixel an
                                     'einer ungeraden Stelle ist, dann ist
                                     'es das niederwertige Byte, ansonsten
                                     'das hoeherwertige.
      IF byte = 0 THEN
         Farbe = a(Element) MOD 256  'Niederwertiges Byte
      ELSE
         Farbe = a(Element) \ 256    'Hoeherwertiges Byte
      END IF
   PRINT "X:"; x; " Y:"; y; " Farbe:"; Farbe
   NEXT
NEXT

