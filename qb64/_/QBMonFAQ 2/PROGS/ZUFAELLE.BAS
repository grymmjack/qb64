'*********************************************
' ZUFAELLE.BAS = Zufallszahlen 1..n erzeugen
' ============
' Es werden die Zahlen von 1 bis n in einer
' nach dem Zufallsprinzip sortierten
' Reihenfolge erzeugt und angezeigt.
' Der Zahlenbereich "n" ist waehlbar.
'
' (c) JoePopo, 3.9.2003
'********************************************
CLS
PRINT "Ausgabe der Zahlen von 1 bis n in zufaelliger Reihenfolge"
PRINT
RANDOMIZE TIMER
INPUT "Zahlenbereich: n =  "; n
FOR i = 1 TO n
zuf = INT((RND(1) * n) + 1)
PRINT i; ": "; zuf
NEXT i
SLEEP
END

