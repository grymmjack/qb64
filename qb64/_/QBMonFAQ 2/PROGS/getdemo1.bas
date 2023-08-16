'***************************************************************************
' GETDEMO1.BAS = Demonstration 1 des GET-Befehls
' ============
' Dieses QBasic-Programm demonstriert das Funktionsprinzip des GET-Befehls.
' Es malt mit PSET 2 Punkte auf den Bildschirm, liest diese mit dem GET-
' Befehl aus und zeigt das Ergebnis an.
'
' (c) Karl Pircher ("Ch@rly" karl.pircher*gmx.net), 24.03.2004
'***************************************************************************
DEFINT A-Z
DIM a(0 TO 2) AS INTEGER             'Dimensionieren fÅr das Einlesen der
                                     'Seiten
SCREEN 13                            'Umschalten auf Screen 13
PSET (1, 1), 1                       'Setzen Punkt 1 auf Farbe 1
PSET (2, 1), 3                       'Setzen Punkt 2 auf Farbe 2
GET (1, 1)-(2, 1), a                 'Einlesen Grafik (Punkt 1 und 2) in
                                     'Feld a.
'
PRINT "Breite in Pixel: "; a(0) / 8  'Breite steht in Byte 0 und 1
                                     'dividiert durch 8
PRINT "Hoehe in Pixel : "; a(1)      'Hoehe steht in Byte 2 und 3
punkt1 = a(2) MOD 256                'Hoeherwertiges Byte aus Integer
                                     'extrahieren
punkt2 = a(2) \ 256                  'Niederwertiges Byte aus Integer
                                     'extrahieren
PRINT "Farbe Punkt 1  : "; punkt1
PRINT "Farbe Punkt 2  : "; punkt2

