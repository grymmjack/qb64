'***************************************************************
' ERASE1.BAS = Bildschirmelement loeschen und alten
' ==========   Hintergrund wieder herstellen
'
' (c) Clocksoft, 2001 --- www.freenet.de/Clocksoft
'***************************************************************
SCREEN 13  'Grafikmodus 13 aktivieren, Aufloesung 320x200 Pixel
DEFINT A-Z 'Beschleunigung des Programmes
CLS        'Bildschirm löschen
DIM OldGraphic(26 * 26)
           'Eine Variable deklarieren, Arraygroesse ist gleich
           'Höhe * Breite des gewuenschten Bilds
CLS
FOR X = 0 TO 320      'Hier wird eine Zufallsbild erzeugt
  FOR y = 0 TO 240
    PSET (X, y), INT(RND * 15)
  NEXT y
NEXT X

PRINT "Jetzt wird ein Teil gespeichert !"
          'Hier wird ein Beispieltext ausgegeben
DO: LOOP UNTIL INKEY$ <> ""  'Warten auf Tastendruck
GET (1, 1)-(26, 26), OldGraphic'Bild speichern
CLS
PUT (0, 0), OldGraphic'Gespeicherte Bildinformationen ausgeben

