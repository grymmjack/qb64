'************************************************************
' RUNDUNG2.BAS - Wissenschaftliche Rundung in QBasic
' =====================================================
' Wissenschaftliche Rundung von Dezimalzahlen auf 2
' Nachkommastellen. Bei Werten, die genau in der Mitte
' zwischen zwei darstellbaren Werten liegen, wird auf die
' naechste gerade Zahl gerundet.
'
' Hierzu stellt QBasic die Befehle CINT und CLNG zur
' Verfuegung.
'
' Von Thomas Antoni, 5.5.2003 - 7.5.2003
'************************************************************
CLS
DO
PRINT "Gibt eine pos. oder neg. Zahl mit Dezimalpunkt ein"
INPUT z#
PRINT CLNG(z# * 100) / 100
PRINT "Abbrechen...{[Esc]   Wiederholen...[beliebige Taste]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
LOOP UNTIL taste$ = CHR$(27)
END

