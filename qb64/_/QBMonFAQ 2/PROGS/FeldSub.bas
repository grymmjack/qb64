'*******************************************
' FeldSub.bas = Felduebergabe an eine SUB
' ===========
' Dies Programm demonstriert, wie man auf
' Felder sowohl im aufrufenden Hauptprogramm
' als auch in einer SUB zugreifen kann.
'
' Das Feld a%() hat 3 Felelemenete. Es
' wird mit 3 Eingabewerten gefuellt.
' Diese SUB quadrat quadriert die
' Feldelemente und liefert das Ergebnis
' im Feld b%() zurueck.
'
' (c) Thomas Antoni. 28.7.2003
'*******************************************
DECLARE SUB quadrat ()
'
CLS
DIM SHARED a%(2), b%(2)
'
FOR i% = 0 TO 2
  PRINT "Gib die"; i%; ". Zahl ein";
  INPUT a%(i%)
NEXT i%
'
CALL quadrat
'
FOR i% = 0 TO 2
  PRINT b%(i%)
NEXT i%

SUB quadrat
FOR i% = LBOUND(a%) TO UBOUND(a%)
  b%(i%) = a%(i%) ^ 2
NEXT i%
END SUB

