'****************************************************
' FILL.BAS = Fuellen eines Dreiecks mit blauer Farbe
' ========
'
' (c) Thomas Antoni, Nimes 20.8.2003
'****************************************************
'
SCREEN 12
CLS
'
'--- ganzen Bildschirm rot einfaerben (Farbcode 4) ---
PAINT (1, 1), 4
'
'--- Dreieck zeichnen --------------------------------
LINE (100, 150)-(200, 300), 14
LINE (200, 300)-(550, 100), 14
LINE (550, 100)-(100, 150), 14
  'Zwischen den Punkten (100|150, (200|300) und
  '(550|100) wird das Dreieck mit gelben Linien
  '(Farbcode 14) gezeichnet
'
'--- Dreieck mit blauer Farbe fuellen (Farbcode 1):
PAINT (200, 200), 1, 14
  'Ausgehend von dem im Dreieck liegenden Punkt
  '(200|200) wird die gesamte Flaeche bis zum
  'Erreichen der mit gelb (Farbcode 14) gefaerbten
  'Randlinien engefaerbt.
SLEEP

