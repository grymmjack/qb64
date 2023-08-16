'*****************************************************
' FELD.BAS - Felder bearbeiten in QBasic
' ========
' Dies Programm demonstriert die Bearbeitung
' von Feldern in QBasic. Der Anwender wird
' aufgefordert, 3 Zahlen einzugeben. Diese werden
' im Feld z%(2) abgelegt. Anschliessend
' berechnet das Programm die Quadratwerte der
' Zahlen und zeigt sie an
'
' (c) Thomas Antoni, 4.11.2003 - 8.1.2004
'*****************************************************
DIM z%(2)  'Feld mit den 3 Feldelementen z%(0)...z%(2)
           'deklarieren bzw. "dimensionieren"
CLS
PRINT "Gib drei Zahlen von 1 bis 100 ein"
'
'*** Zahlen eingeben *********************************
FOR i% = 0 TO 2  'Schleife ueber alle Feldelemente
  PRINT "Gib die "; i%; ". Zahl ein: ";
  INPUT z%(i%)
NEXT
'
'*** Quadratzahlen berechnen und anzeigen ************
FOR i% = 0 TO 2
  PRINT "z("; i%; ") ^2 = "; z%(i%) ^ 2
NEXT
SLEEP
END