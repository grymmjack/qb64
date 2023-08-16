'********************************************************
' GRAFIK.BAS = Kleine Demo der wichtigsten Grafikbefehle
' ==========
' Dieses QBasic-Programm zeigt ein Mondgesicht auf dem
' Bildschirm an und demonstriert damit die folgenden
' Grafikbefehle:
' - CIRCLE = Kreis zeichnen
' - PAINT  = Flaeche ausfuellen
' - LINE   = Linie zeichnen
' - PSET   = Bildpunkt zeichnen
'
' (c) Thomas Antoni, 31.10.2003 - 8.1.2004
'********************************************************
SCREEN 9 'VGA-Grafikbildschirm mit 640x350 Pixeln
COLOR 1  'Blauer Bildschirmhintergrund
CLS      'Bildschirm ruecksetzen und blau einfaerben
CIRCLE (320, 175), 150, 14  'Kopf malen
 'Kreis um Mittelpunkt M=(320|175) mit Radius r=150 Pixel
 'und der Randfarbe 14=gelb zeichnen
PAINT (320, 175), 4, 14      'Kopf rot fuellen
 'Kreis ab Mittelpunkt mit der Farbe 4 (=rot) ausmalen
 'bis die gelbe Randfarbe (14) erreicht wird
LINE (260, 130)-(290, 130), 14
 'Linke Augenbraue als Linie von (260|130) nach (290|130)
 'mit Linienfarbe gelb (14) zeichnen
LINE (350, 130)-(380, 130), 14
 'rechte Augenbraue
LINE (320, 150)-(320, 200), 14
 'Nase
LINE (270, 235)-(370, 235), 14
 'Mund
PSET (275, 140), 14
 'linkes Auge als Bildpunkt (275|140) mit der Farbe
 'gelb (14) zeichnen
PSET (365, 140), 14
 'rechtes Auge
SLEEP
END