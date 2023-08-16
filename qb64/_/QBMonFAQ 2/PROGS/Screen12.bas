'**************************************************************
' SCREEN12.BAS = Direktzugriff auf das Video-RAM von SCREEN 13
' ============
' Dieses Q(uick)Basic-Programm demonstriert, wie man direkt
' auf den Bildschirmspeicher des Grafikbildschirms SCREEN 12
' zugreifen kann.
'
' Das Programm enthaelt eine SUBroutine, welche einen Punkt vom
' Bildschirm einliest. Dazu wird zuerst die Farbe abgefragt,
' dann wird ein kleines Quadrat in dieser Farbe gezeichnet und
' anschliessend wird die Farbe eines Pixels innerhalb dieses
' Quadrats durch die SUBroutine ermittelt und angezeigt. Das
' Beispiel dient nur zur Demonstration und ist nicht auf
' Geschwindigkeit ausgelegt. Verschiedene Tests von mir haben
' sowieso ergeben, dass die schnellste Methode, einen Pixel in
' SCREEN 12 zu lesen, immer noch die QB-eigene Methode POINT
' ist.
'
' (c) Ch@rly (karl.pircher*gmx.net), 25.5.2003
'**************************************************************
DEFINT A-Z
DECLARE SUB GetPoint (x%, y%, f%)
'
SCREEN 12
DEFINT A-Z
'
PRINT
INPUT "Farbe (0 - 15) ", f
f = f MOD 16
x = 2
y = 0
'
LINE (0, 0)-STEP(7, 7), f, BF
GetPoint x, y, f
PRINT "Die Farbe ="; f

'
SUB GetPoint (x, y, f)
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
END SUB

