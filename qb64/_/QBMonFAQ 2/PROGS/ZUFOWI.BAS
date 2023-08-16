'***********************************************************
' ZUFOWI.BAS = ZUFallszahlen Ohne Wiederholung erzeugen
' ==========
'
' (c) qstyle 4/09/2003
'***********************************************************
CLS
PRINT "Zufallszahlen vom Bereich 1 bis n ohne Wiederholungen"
INPUT "Zahlenbereich: n = "; n
IF n = 0 THEN END
PRINT
DIM Zahlen%(n)
DIM Feld%(n)
CONST BELEGT = -1
'
'------------ Feld fuellen
FOR i = 1 TO n
  Zahlen%(i) = i
NEXT i
FOR i = 1 TO n
  RANDOMIZE TIMER
  Zufall = INT((RND(1) * n) + 1)
  IF Zahlen%(Zufall) <> BELEGT THEN
    Feld%(i) = Zahlen%(Zufall)
    Zahlen%(Zufall) = BELEGT
  ELSE
    i = i - 1
  END IF
NEXT i
'
PRINT "Feld%() mit Zufallswerten"
PRINT "-------------------------"
FOR i = 1 TO n
PRINT Feld%(i);
NEXT i
PRINT
'
'------------- Feld sortieren
FOR i = 1 TO n
  FOR j = i TO n
    IF Feld%(i) > Feld%(j) THEN
      SWAP Feld%(i), Feld%(j)
     END IF
  NEXT j
NEXT i
'
PRINT
PRINT "Feld%() sortiert"
PRINT "------------------"
'
'-------------- Zahlen sortiert ausgeben
FOR i = 1 TO n
  PRINT Feld%(i);
NEXT i
END

