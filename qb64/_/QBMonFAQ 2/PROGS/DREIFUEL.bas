'***************************************************************
' DREIFUEL.BAS = Dreieck mit Farbe fuellen ohne PAINT
' ============
' Dieses Q(uick)Basic-Programm zeichnet ein Dreieck mit
' "Zufaelligen" Eckpunkten und fÅllt es mit mit Farbe aus,
' ohne den naheliegenden PAINT-Befehl zu verwenden
'
' (c) G-Man (gaussman*bullen.de), 12.7.2003
'***************************************************************
DIM feld%(0 TO 2)
SCREEN 12
CLS

RANDOMIZE TIMER
i1x = RND * 200
i2x = RND * 200
i3x = RND * 200
i1y = RND * 200
i2y = RND * 200
i3y = RND * 200

feld%(0) = i1x
feld%(1) = i2x
feld%(2) = i3x

FOR x% = 0 TO 2 'Schleife ueber alle Feldelemente
FOR y% = 2 TO x% + 1 STEP -1
IF feld%(y%) < feld%(x%) THEN SWAP feld%(y%), feld%(x%)
NEXT y%
NEXT x%

ax = feld%(0)
ay = i1y
bx = feld%(2)
by = i2y
cx = feld%(1)
cy = i3y
clip = 1
LINE (ax, ay)-(bx, by), 1
LINE (bx, by)-(cx, cy), 1
LINE (ax, ay)-(cx, cy), 1
steigab# = (ay - by) / (bx - ax)
steigac# = (ay - cy) / (cx - ax)
steigcb# = (by - cy) / (bx - cx)
IF steigac# < 0 THEN clip = -1
FOR x = 0 TO (cx - ax) STEP 1
heigth = (steigac# * x) - (steigab# * x)
FOR y = 0 TO heigth STEP clip
PSET (x + ax, ay - y - (steigab# * x))

NEXT y
NEXT x
half = (cx - ax)
FOR x = (bx - ax) TO half STEP -1
heigth = (steigcb# * (bx - x - ax)) + (ay - by - (steigab# * x))
FOR y = 0 TO heigth STEP clip
PSET (x + ax, ay - y - (steigab# * x))
NEXT y
NEXT x

