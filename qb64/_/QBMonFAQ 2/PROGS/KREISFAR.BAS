'******************************************************************************
' KREISFAR.BAS = Einen Kreis mit Farbe füllen
' ============
' Dieses Q(uick)Basic-Programm zeichnet einen Kreis mit dem Mittelpunkt
' M(100,100) und dem Radius r=50 mit roter Randlinie (Farbcode 4).
' Anschließend wird der Kreis mit einem PAINT-Befehl rot "'ausgemalt"
'
' (c) Thomas Antoni, 15.10.2005
'******************************************************************************
SCREEN 12
CIRCLE (100, 100), 50, 4
  'Kreis mit den Mittelpunkt (100), Radius 50 und Randfarbe rot (=4)
PAINT (100, 100), 4
  'Flaeche ausgehend vom Mittelpunkt rot ausmalen bis die
  'Randlinie erreicht wird
SLEEP