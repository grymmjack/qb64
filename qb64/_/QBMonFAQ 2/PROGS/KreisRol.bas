'**************************************************************
' KREISROL.BAS = Ein Kreis rollt diagonal ueber den Bildschirm
' ============
' Dieses Q(uick)Basic-Programm laesst einen Kreis diagonal
' ueber den Bildschirm rollen. Er stoesst sich an den
' Bildschirm-Raendern ab.
' Die Betaetigung einer beliebigen Taste beendet das Programm.
'
' (c) Mecki, 14.5.2003
'**************************************************************
radius = 20
x = radius + 10  'Startkoordinaten
y = radius + 10
xrichtung = 2   'Schrittweite
yrichtung = 2
SCREEN 12
'
DO
  IF x > 639 - radius THEN xrichtung = -xrichtung
  IF y > 479 - radius THEN yrichtung = -yrichtung
  IF x < radius THEN xrichtung = -xrichtung
  IF y < radius THEN yrichtung = -yrichtung
  CIRCLE (x, y), radius, 0  'Alten Kreis in Schwarz uebermalen
  x = x + xrichtung
  y = y + yrichtung
  CIRCLE (x, y), radius, 15 'Kreis in Weiss (Farbe 15) zeichnen
  t = TIMER: DO: LOOP UNTIL TIMER <> t 'Zeitverzoegerung 0.056 s
LOOP UNTIL INKEY$ <> ""
END

