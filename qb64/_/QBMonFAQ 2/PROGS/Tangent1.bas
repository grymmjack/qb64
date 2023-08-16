'*****************************************************
' TANGENT1.BAS = Tangenten an einen Kreis zeichnen
' ============
' Dieses QBasic-Program zeichnet zwei gleich grosse
' Kreise, die durch ihre Tangenten miteinander
' verbunden sind. Also 2 Riemenscheiben, ueber die
' ein Antriebs-Riemen laeuft.
'  (c) Skilltronic, 12.2.2005  -  www.skilltronics.de
'******************************************************
SCREEN 12
CLS
xa = 400
ya = 100
xb = 200
yb = 300
dx = xa - xb
dy = ya - yb
radius = 17
CIRCLE (xa, ya), radius
CIRCLE (xb, yb), radius
l = SQR(dx ^ 2 + dy ^ 2)
xp = -radius * dy / l
yp = radius * dx / l
LINE (xa + xp, ya + yp)-(xb + xp, yb + yp)
xp = radius * dy / l
yp = -radius * dx / l
LINE (xa + xp, ya + yp)-(xb + xp, yb + yp)
SLEEP

