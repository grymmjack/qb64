'***************************************************************************
' CALLREVA.BAS = Unterschied zwischen "Call by Reference" und "by Value"
' ============
' Dieses QBasic-Programm demonstriert anschaulich den Unterschied
' zwischen den beiden Parameteruebergabe-Methoden "Call by Reference" und
' "Call by Value".
'
' An die SUB quadrat wird die Variable a% als Parameter uebergeben. Einmal
' "by reference" und einmal "by Value" (Parameterwert in Klammern).  Die
' SUB quadriert den uebergebenen Parameter und zeigt das Ergebnis an.
' Wie man sieht, veraendert die SUB bei "Call by reference" den Wert der
' Parametervariablen a% des Hauptprogramms von 3 auf 9, waehrend sie bei
' "Call by Value"' unveraendert bleibt.
'
' (c) Thomas Antoni, 23.2.2005  -  www.qbasic.de
'***************************************************************************
'
DECLARE SUB quadrat (b%)
CLS
PRINT "Call by Reference"
PRINT "-----------------"
a% = 3
PRINT "Vor dem Aufruf der Sub hat a% im Hauptprogramm den Wert"; a%
CALL quadrat(a%)
     'Es wird die Adresse von a% an die SUB uebergeben
PRINT "Nach dem Aufruf der Sub hat a% im Hauptprogramm den Wert"; a%
'
PRINT
PRINT "Call by Value"
PRINT "-----------------"
a% = 3
PRINT "Vor dem Aufruf der Sub hat a% im Hauptprogramm den Wert"; a%
CALL quadrat((a%))
     'a% in Klammern => Es wird der Wert von a% uebergeben
PRINT "Nach dem Aufruf der Sub hat a% im Hauptprogramm den Wert"; a%
SLEEP
END

'
SUB quadrat (b%)
b% = b% ^ 2
PRINT b%
END SUB

