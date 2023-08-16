'*******************************************
' Feld2Sub.bas = Felduebergabe an eine SUB
' ============
' Dies Programm demonstriert, wie man ein
' Feld an eine SUB uebergibt und wie
' diese wiederum ein Feld ans aufrufende
' Programm zurueckliefert.
'
' Das Feld a%() hat 3 Felelemenete. Es
' wird mit 3 Eingabewerten gefuellt und
' an die SUB quadrat uebergeben. Diese
' quadriert die Feldelemente und liefert
' das Ergebnis im Feld b%() zurueck.
'
' (c) Thomas Antoni. 28.7.2003
'*******************************************
DECLARE SUB quadrat (d%(), e%())
'
CLS
DIM a%(2), b%(2)
'
FOR i% = 0 TO 2
  PRINT "Gib die"; i%; ". Zahl ein";
  INPUT a%(i%)
NEXT i%
'
CALL quadrat(a%(), b%())
'
FOR i% = 0 TO 2
  PRINT b%(i%)
NEXT i%

SUB quadrat (d%(), e%())
FOR i% = LBOUND(d%) TO UBOUND(d%)
  e%(i%) = d%(i%) ^ 2
NEXT i%
END SUB

