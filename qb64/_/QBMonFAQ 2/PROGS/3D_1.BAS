'****************************************************************************
' 3D_1.BAS - Kleine 3D-Grafikdemo
' ========
' Es wird ein in der X/Y/Z-Ebene liegendes Quadrat in eine 2D-Darstellung
' umgewandelt und angezeigt. Das Quadrat laesst sich mit den Cursortasten
' ueber den Bildschirm bewegen.
'
' (c) Ingmar Stotz (iNGY!), 29.7.2002
'****************************************************************************
SCREEN 7                    'Bildschirmmodus auf 320*200
CLS                         'Bildschirm loeschen
Points = 5                  'Anzahl der Polygone
Linien = 4                  'Anzahl der Linien
zoom = 1                    'Zoom setzen
'
GOSUB Read.Points           'SUB zum Einlesen der Punkte aufrufen
DO                          'Hauptschleife starten
  GOSUB Make.3d.To.2d       'SUB zum Umwandeln von 3d in 2d aufrufen                 
  GOSUB Draw.Lines          'SUB zum Zeichnen der Linien in 2d aufrufen                                    
  GOSUB Steuerung           'SUB zum "Steuern" der Fantasiefigur aufrufen
  k = INP(96)               'Auf Tasteneingabe warten
  SCREEN 7, 0, (scr + 1) MOD 3, scr
  scr = (scr + 1) MOD 3                   'Flimmerunterdruekung
  DEF SEG = 0: POKE &H41A, PEEK(&H41C)    'Unterdrueckt das Piepsen
  LINE (0, 0)-(320, 200), 0, BF           'Loescht den Bildschirm
  LOCATE 1, 1: COLOR 14
  PRINT "Programm von Ingmar Stotz (iNGY!) am 29.7.2002"
  COLOR 15
LOOP
'
Read.Points:                'SUB zum Einlesen der Punkte aus den DATA-Zeilen
FOR z = 1 TO Points         'Schleife zum Einlesen der Punkte
READ x3d(z), y3d(z), z3d(z) 'Liest die x,y,z-Koordinaten ein
NEXT                        'Schleife schliessen
RETURN                      'Zum Hauptprogramm zurueck

Make.3d.To.2d:              'SUB zum umwandeln von 3d in 2d                    
FOR z = 1 TO Points         'Schleife zum umwandeln aller Punkte von 3d in 2d
x2d(z) = (x3d(z) / z3d(z)) * zoom  'Formel zum Umwandeln v. 3d in 2d mit Zoom
y2d(z) = (y3d(z) / z3d(z)) * zoom  'Formel zum Umwandeln v. 3d in 2d mit Zoom
NEXT                        'Schliesst die Schleife
RETURN                      'Kehrt zum Hauptprogramm zurueck
'
Draw.Lines:                 'SUB zum Linien zeichnen
FOR z = 1 TO Points
  x2d(z) = x2d(z) + 160     'Fluchtpunkt in der Bildschirmmitte festlegen
  y2d(z) = y2d(z) + 100     'Fluchtpunkt in der Bildschirmmitte festlegen
NEXT
FOR z = 1 TO Linien         'Schleife zum Linien in 2d zeichnen
  LINE (x2d(z), y2d(z))-(x2d(z + 1), y2d(z + 1))    'Zeichnet die Linien
NEXT                        'Schliesst die Schleife
RETURN                      'Kehrt zum Hauptprogramm zurueck
'
Steuerung:                  'SUB zur Steuerung der Fantasiefigur
                            'abhaengig vom Tastatur-Abfragecode
IF k = 77 THEN              'WENN Cursor-Rechts, DANN
  FOR z = 1 TO Points       'Alle Punkte
    x3d(z) = x3d(z) + 1     'um 1 in x-Richtung erhoehen
  NEXT                      'Schliesst die Schleife
END IF                      'Schliesst die IF..THEN..
IF k = 72 THEN              'WENN Cursor-Links,DANN
  FOR z = 1 TO Points       'Alle Punkte
    y3d(z) = y3d(z) - 1     'um 1 in y-Richtung erniedrigen
  NEXT                      'Schliesst die Schleife
END IF                      'Schliesst die IF...THEN..
IF k = 80 THEN              '...
  FOR z = 1 TO Points
    y3d(z) = y3d(z) + 1
  NEXT
END IF
IF k = 75 THEN
  FOR z = 1 TO Points
    x3d(z) = x3d(z) - 1
  NEXT
END IF
IF k = 1 THEN END           'Programm beenden mit Esc    
RETURN                      'Kehrt zum Hauptprogramm zurueck
'---------- Hier sind die Punkte gespeichert in
'     x    y   z
DATA -200,-50, 4
DATA -200, 50, 3
DATA  200, 50, 3
DATA  200,-50, 4
DATA -200,-50, 4

