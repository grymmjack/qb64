'*******************************************************
' GetPoint.bas = Farbe eines Bildschirmpixels ermitteln
' ============   ohne POINT
' Dieses QBasic-Programm ermittelt die Farbe eines
' Bildschirmpixels ohne den POINT-Befejl. Die
' Information wird direkt aus dem Bildschirmspeicher
' der Grafikkarte gelesen.
'
' (c) Ch@rly (karl.pircher*gmx.net), 30.8.2002 
'*******************************************************
DECLARE SUB GetPoint (x%, y%, f%)
SCREEN 12
DEFINT A-Z
x = 50
y = 150
LINE (0, 150)-(300, 150), 3
PRINT "Weiter mit beliebiger Taste"
SLEEP
CALL GetPoint(x, y, f)
PRINT "Der Punkt (x=50 | y=150) hat die Farbe "; f

'
SUB GetPoint (x, y, f)
'
adr = y * 80
Byte = x \ 8
bit = x - Byte * 8
m = 2 ^ bit
'
adr = adr + Byte
'
DEF SEG = &HA000
OUT &H3CE, 4: OUT &H3CF, 0
b = SGN(PEEK(adr) AND m)
'
OUT &H3CE, 4: OUT &H3CF, 1
g = SGN(PEEK(adr) AND m)
'
OUT &H3CE, 4: OUT &H3CF, 2
r = SGN(PEEK(adr) AND m)
'
OUT &H3CE, 4: OUT &H3CF, 3
i = SGN(PEEK(adr) AND m)
'
f = b + g * 2 + r * 4 + i * 8
'
END SUB

