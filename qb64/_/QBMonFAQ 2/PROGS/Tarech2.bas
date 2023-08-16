'**********************************
' TARECH2.BAS = Taschenrechner
' ===========
' (c) Aduin u. T. Antoni 2002
'**********************************
CLS
PRINT "Waehle die Rechenoperation:"
PRINT " *   Multiplikation"
PRINT " /   Division"
PRINT " -   Subtraktion"
PRINT " +   Addition"
INPUT "Operation          = ", op$
INPUT "Erster  Operand: x = ", x
INPUT "Zweiter Operand: y = ", y
PRINT "Ergebnis:      x"; op$; "y =";
SELECT CASE op$
  CASE "+": PRINT x + y
  CASE "-": PRINT x - y
  CASE "*": PRINT x * y
  CASE "/": PRINT x / y
  CASE ELSE: PRINT " Falsche Operation"
END SELECT

