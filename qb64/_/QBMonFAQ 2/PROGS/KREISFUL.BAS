'*************************************************************
' KREISFUL.BAS = Kreis mit Farbe fuellen ohne PAINT und DRAW
' ============
' Dieses Q(uick)Basic-Programm fuellt einen Kreis mit Farbe
' ohne den naheliegenden PAINT oder DRAW-Befehl zu verwenden.
' Das Faellen wird durch das Ziehen waagerechter farbiger
' Linien bewerkstelligt. Ein Zeichnen des Kreises selbst
' mit dem CIRCLE-Befehl ist nicht erforderlich
'
' (c) Helium, 14.10.2005 ]
'*************************************************************
'
SCREEN 12
mx = 100     'x-Koordinate des Kreis-Mittelpunkts
my = 150     'y-Koordinate des Kreis-Mittelpunkts
radius = 80
farbe = 4    'rot
radiusSqr = radius * radius
FOR y = my - radius TO my + radius
   x = SQR(radiusSqr - (y - my) * (y - my))
   LINE (mx - x, y)-(mx + x, y), farbe
NEXT
SLEEP

