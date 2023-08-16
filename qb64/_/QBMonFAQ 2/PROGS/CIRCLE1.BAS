'******************************************************
' CIRCLE1.BAS = Einen Kreis zeichnen ohne CIRCLE
' ===========   Bresenham Circle Drawing Algorithm
'
' Dieses QBasic-Programm zeichnet einen Kreis mit
' dem Bresenham-Algorithmus.
'
' (c) by Kurt Kuzba
'     Adapted from BRESNHAM.C in Bob Stout's SNIPPETS.
'******************************************************
DECLARE SUB BCircle (xc%, yc%, r%, c%)
SCREEN 9
CLS
wide% = 2   'Breite 200% (gestreckter Kreis)
high% = 1   'H”he 100%
CALL BCircle(320, 175, 80, 14)
 'Kreis um den Mittelpunkt (320,175) mit dem Radius 80
 'und der Randfarbe gelb=14
SLEEP

'
SUB BCircle (xc%, yc%, r%, c%)
SHARED wide%, high%
x% = 0: d% = 2 * (1 - r%): W% = 2 * wide% \ high%
WHILE r% >= 0
  PSET (xc% + x%, yc% + r%), c%
  PSET (xc% + x%, yc% - r%), c%
  PSET (xc% - x%, yc% + r%), c%
  PSET (xc% - x%, yc% - r%), c%
  IF (d% + r%) > 0 THEN r% = r% - 1: d% = d% - W% * r% - 1
  IF x% > d% THEN x% = x% + 1: d% = d% + 2 * x% + 1
WEND
END SUB

