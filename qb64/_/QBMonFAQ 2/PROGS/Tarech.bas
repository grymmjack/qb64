'**************************************************
' TARECH.BAS = Taschenrechner
' ==========
' Einfacher Taschenrechner fuer
' die 4 Grundrechenarten
' (c) Thomas Antoni, 21.1.2004
'**************************************************
DO
anfang:
CLS
PRINT "Waehle die Rechenoperation:"
PRINT " +   Addition"
PRINT " -   Subtraktion"
PRINT " *   Multiplikation"
PRINT " +   Division"
PRINT "Esc  Beenden"
LOCATE , 2, 1         'in Spalte 2 blinkender Cursor
op$ = INPUT$(1)            '1 Zeich.v.Tastatur lesen
PRINT op$
IF op$ = CHR$(27) THEN END 'Beenden mit esc
LOCATE , 1
INPUT "Erster  Operand: x = ", x
INPUT "Zweiter Operand: y = ", y
PRINT "Ergebnis:      x"; op$; "y = ";
SELECT CASE op$
  CASE "+": PRINT x + y
  CASE "-": PRINT x - y
  CASE "*": PRINT x * y
  CASE "/": PRINT x / y
  CASE ELSE: PRINT " Falsche Operation"
END SELECT
PRINT "... neue Berechnung mit beliebiger Taste";
PRINT "... Beenden mit Esc"
t$ = INPUT$(1)
IF t$ = CHR$(27) THEN END
LOOP

