'***********************************************************
' Sort_1.bas - Einfaches Beispiel zum Sortieren von Zahlen
' ==========   mit "Bubble-Sort"
' Sortieren von 4 eingegebenen Zahlen nach dem
' "Bubble Sort" Algorithmus, bei dem die kleineren
' Zahlen allmählich wie die Blasen (Bubbles) im
' Wasser nach oben steigen. Es wird im jede Zahl
' mit jeder anderen verglichen und bei falscher
' Reihenfolge durch den SWAP-Befehl miteinander
' ausgetauscht.
'
' (c) Thomas Antoni, 12.5.02
'***********************************************************
CLS
DIM Feld%(3)    'Feld mit 4 Elementen dimensionieren
INPUT "Gib die erste  Zahl ein"; Feld%(0)
INPUT "Gib die zweite Zahl ein"; Feld%(1)
INPUT "Gib die dritte Zahl ein"; Feld%(2)
INPUT "Gib die vierte Zahl ein"; Feld%(3)
'
FOR x% = 0 TO 3 'Schleife ueber alle Feldelemente
  FOR y% = 3 TO x% + 1 STEP -1
    IF Feld%(y%) < Feld%(x%) THEN SWAP Feld%(y%), Feld%(x%)
  NEXT y%
NEXT x%
'
PRINT
PRINT "Die sortierten Zahlen lauten:"
PRINT Feld%(0)
PRINT Feld%(1)
PRINT Feld%(2)
PRINT Feld%(3)
SLEEP
END

