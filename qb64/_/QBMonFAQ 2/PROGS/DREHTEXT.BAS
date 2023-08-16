'***********************************************************
' DREHTEXT.BAS = Drehen von Text
' ============
' Dieses QBasic-Programm dreht Text oder beliebige andere
' Objekte auf dem Grafikbildschirm um 90∞ 180∞ oder 270∞.
' Wenn man noch ein biﬂchen mit t1 und t2 spielt, kann man
' das Ergebnis sicher noch ‰ndern.
'
' (c)  TomiTom, 13.10.2002 
'***********************************************************
DECLARE SUB dreh (x1!, y1!, x2!, y2!, winkel!)
CLS
SCREEN 13
LOCATE 5, 5: PRINT "Hallo"
CALL dreh(32, 32, 69, 38, 90)
'

SUB dreh (x1, y1, x2, y2, winkel)
DIM feld(x1 TO x2, y1 TO y2)  'Feld anlegen
'
FOR i = x1 TO x2
  FOR j = y1 TO y2
    feld(i, j) = POINT(i, j)  'jeden Punkt in Feld speichern
  NEXT j
NEXT i
'
LINE (x1, y1)-(x2, y2), 0, BF 'alten Text ueberzeichnen
t1 = 0: t2 = 0
'
SELECT CASE winkel
  CASE 90: SWAP x1, y1: SWAP x2, y2: t1 = x2 + x1: s = 1
  CASE 180: t1 = x2 + x1: t2 = y2 + y1
  CASE 270: SWAP x1, y1: SWAP x2, y2: t2 = y2 + y1: s = 1
END SELECT
'
FOR i = x1 TO x2
  FOR j = y1 TO y2
    IF s = 1 THEN
      PSET (ABS(t1 - i), ABS(t2 - j)), feld(j, i)
    ELSE
      PSET (ABS(t1 - i), ABS(t2 - j)), feld(i, j)
   END IF
  NEXT j
NEXT i
'
s = 0
END SUB

