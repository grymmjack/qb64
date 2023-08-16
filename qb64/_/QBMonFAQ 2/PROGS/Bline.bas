'*******************************************************************************
' BLINE.BAS = Eine Linie mit dem Bresenham-Algorithmus zeichnen ohne LINE
' =========   Bresenham Line Drawing Algorithm 
'
' Dieses QBasic-Programm ersetzt den LINE-Befehl und zeichnet eine Linie vom
' Punkt P1(x%|y%) zum Punkt P2(x2%|y2%) in der Farbe c%. Dazu der
' Bresenham-Algorithmus verwendet.
'
' This QBasic-Program substitutes the LINE statement and draws a line from
' the point P1(x%|y%) to the point P2(x2%|y2%) with the color c%. The
' program uses the Bresenham algorithm.
'
' _|_|_|
' _|_|_| (c) by Kurt Kuzba adapted from BRESNHAM.C in Bob Stout's SNIPPETS.
' _|_|_| Structured by Breeze & Thomas Antoni
'*******************************************************************************
'
DECLARE SUB BLine (X AS INTEGER, Y AS INTEGER, X2 AS INTEGER, Y2 AS INTEGER, C AS INTEGER)
SCREEN 12
CLS
CALL BLine(110, 150, 490, 400, 14)
  'draw line from (x=110|y=150) to (490|400)  with color yellow=14
SLEEP
END

DEFINT A-Z
'----------------- SUB Bline --------------------------
SUB BLine (X AS INTEGER, Y AS INTEGER, X2 AS INTEGER, Y2 AS INTEGER, C AS INTEGER)
DIM I AS INTEGER
DIM Steep AS INTEGER
DIM E AS INTEGER
DIM SX AS INTEGER
DIM SY AS INTEGER
DIM DX AS INTEGER
DIM DY AS INTEGER
'
I = 0
Steep% = 0
E = 0
'
IF (X2 - X) > 0 THEN
  SX = 1
ELSE
  SX = -1
END IF
'
DX = ABS(X2 - X)
'
IF (Y2 - Y) > 0 THEN
  SY = 1
ELSE
  SY = -1
END IF
'
DY = ABS(Y2 - Y)
'
IF (DY > DX) THEN
  Steep = 1
  SWAP X, Y
  SWAP DX, DY
  SWAP SX, SY
END IF
'
E = 2 * DY - DX
'
FOR I = 0 TO DX - 1
  IF Steep% = 1 THEN
    PSET (Y, X), C
  ELSE
    PSET (X, Y), C
  END IF
'
  WHILE E >= 0
    Y = Y + SY
    E = E - 2 * DX
  WEND
'
  X = X + SX
  E = E + 2 * DY
NEXT
'
PSET (X2, Y2), C
END SUB

