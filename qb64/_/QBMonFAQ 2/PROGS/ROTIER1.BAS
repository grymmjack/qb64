'************************************************************
' ROTIER1.BAS - Rotierendes Viereck anzeigen
' ===========
' (c) TomiTom 26.6.2002 (sperlings1*web.de) 
'************************************************************
DIM x(10), y(10)
CLS
SCREEN 12
r = 100 'Radius
x = 300 'X-Koordinate
y = 200 'Y- Koordinate
pi = 4 * ATN(1) 'Kreiskonstante Pi ermitteln
'
DO
z = z + .05
x(1) = r * SIN(z + pi / 2) + x: y(1) = r * COS(z + pi / 2) + y
x(2) = r * SIN(z + pi) + x: y(2) = r * COS(z + pi) + y
x(3) = r * SIN(z - pi / 2) + x: y(3) = r * COS(z - pi / 2) + y
x(4) = r * SIN(z) + x: y(4) = r * COS(z) + y
x(5) = x(1): y(5) = y(1)
x(10) = x(6): y(10) = y(6)
'
FOR i = 6 TO 9 ' Altes Viereck loeschen
LINE (x(i), y(i))-(x(i + 1), y(i + 1)), 0
NEXT
'
FOR i = 1 TO 4 ' Neues Viereck zeichnen
LINE (x(i), y(i))-(x(i + 1), y(i + 1))
x(i + 5) = x(i): y(i + 5) = y(i)
NEXT
'
zeit! = TIMER
DO: LOOP WHILE TIMER = zeit!'0.06 sec warten
'
LOOP WHILE INKEY$ = "" 'Beenden wenn Taste gedrueckt wird
