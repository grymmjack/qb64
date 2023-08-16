'**************************************************
' SMALFONT.BAS = Kleine Schrift in SCREEN 12/13
' ============
' Dieses Q(uick)Basic-Programm erzeugt eine halb
' grosse Schrift im Grafikmodus 12 und zeigt die
' aktuelle Uhrzeit in dieser Schrift alle sec an.
'
' (c) Peter Vollenweider, 23.12.2002 - 26.2.2003
'     (peter.vollenweider*gmx.ch)
'**************************************************
SCREEN 12 'SCREEN 13 geht genausogut
FOR x = 1 TO 14
  OUT 968, x
  OUT 969, x * 4
  OUT 969, x * 4
  OUT 969, x * 4
NEXT
DIM buffer(31, 7)
COLOR 15
ON TIMER(1) GOSUB printtime
TIMER ON
WHILE INKEY$ = ""
WEND
SCREEN 0
END
'
printtime:
LOCATE 1, 1, 0
PRINT TIME$
ERASE buffer
'
FOR y = 0 TO 15
  FOR x = 0 TO 63
    x. = INT(x / 2)
    y. = INT(y / 2)
    buffer(x., y.) = buffer(x., y.) + POINT(x, y)
  NEXT x
NEXT y
'
FOR y = 0 TO 7
  FOR x = 0 TO 31
    PSET (x, y + 16), buffer(x, y) \ 4
  NEXT x
NEXT y
RETURN

