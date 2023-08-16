'*****************************************************
' SNOWMAN.BAS = Schneemann-Animation mit GET und PUT
' ===========
' Dieses Q(uick)Basic-Programm zeichnet einen
' Schneemann mit CIRCLE-Befehlen und liesst die
' erstellte Grafik mit GET in ein Feld ein. Durch
' fortgesetzte PUT-Befehle wird der Schneemann
' ueber den Bildschirm gefuehrt.
'
' (c) Dusky_Joe ( dusky_joe*lycos.de ), 19.1.2005
'*****************************************************
SCREEN 12
'
Groesse = (370 - 270) * (190 - 50) / 2
DIM nichts(Groesse)
DIM Schnee(Groesse)
'
GET (370, 190)-(270, 50), nichts
'
CIRCLE (320, 60), 10, 15
CIRCLE (320, 100), 30, 15
CIRCLE (320, 140), 50, 15
GET (370, 190)-(270, 50), Schnee
'
CLS
'
FOR y = 100 TO 300
  PUT (270, y - 1), nichts, PSET
  PUT (270, y), Schnee, PSET
NEXT

