'***************************************************************************
' PARALLEL.BAS = Zeichnen von parallelen Linien
' ============
'
' (c) Thomas Antoni, 15.2.05 - www.qbasic.de - www.antonis.de
'***************************************************************************
SCREEN 12 'VGA-Farbbildschirm 640x480 Bildschirmpunkte
CLS
'
'****** Strecke P1-P2 und Abstand der Parallen vorgeben
x1 = 100  'Koordinaten des 1. Punktes P1
y1 = 400
x2 = 500  'Koordinaten des 2. Punktes P2
y2 = 150
a = 12    'Abstand der Parallelen zur Strecke P1-P2 in Bildschirmpunkten
          'bei Verschiebung nach unten: negative Werte von a eingeben
'
'****** Strecke P1-P2 zeichnen
LINE (x1, y1)-(x2, y2)            'Strecke P1-P2 in weiss zeichnen
'
'****** X- und Y-Abstand der Parallen berechnen
alfa = ATN((y1 - y2) / (x1 - x2)) 'Steigungswinkel d.Strecke im Bogenmass
dy = a * COS(alfa)                'Y-Abstand der Parallelen (ein Winkel beta
                                  'ist gleich einem Winke alfa, wenn seine
                                  'biden Schenkel mit denjenigen von alfa
                                  'einen rechten Winkel bilden)
dx = SQR(a ^ 2 - dy ^ 2) * SGN(a) 'X-Abstand der Parallelen (Pythagoras)
                                  'mit Vorzeichenumkehr bei negativem a
'
'****** Parallele zeichnen
LINE (x1 - dx, y1 - dy)-(x2 - dx, y2 - dy), 12
                                  'Parallele Strecke in rot zeichnen
SLEEP

