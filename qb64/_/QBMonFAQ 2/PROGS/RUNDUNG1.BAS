'************************************************************
' RUNDUNG1.BAS - Kaufmaennische Rundung in QBasic
' =====================================================
' Kaufmaennische Rundung von Dezimalzahlen auf 2
' Nachkommastellen. Bei Zahlen, die genau in der Mitte
' zwischen zwei darstellbaren Werten liegen, wird auf die
' naechstgroessere Zahl gerundet.
'
' Hierzu stellt QBasic die Befehle INT und PRINT USING
' zur Verfuegung. Dieses Programm demonstriert beide
' Befehle, wobei PRINT USING in vielen Fällen exakter
' arbeitet (z.B. beim Runden der Zahl 2.445 zu 2.45)
'
' Von Thomas Antoni, 5.5.2003 - 7.5.2003
'************************************************************
CLS
DO
PRINT "Gibt eine pos. oder neg. Zahl mit Dezimalpunkt ein"
INPUT z#
PRINT INT(z# * 100 + .5) / 100
LOCATE , 10: PRINT "...gerundet mit Methode INT"
PRINT USING "######.##"; z#
LOCATE , 10: PRINT "...gerundet mit Methode USING"
PRINT "Abbrechen...{[Esc]   Wiederholen...[beliebige Taste]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
LOOP UNTIL taste$ = CHR$(27)
END

