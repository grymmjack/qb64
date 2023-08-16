'******************************************************
' TASTMITT.BAS - Tastatureingabe mitten im Text
' ============
' (c) Thomas Antoni, 25.8.02
'******************************************************
CLS
PRINT "Abbruch mit Strg+C"
PRINT "Also, wie ->_____________<- heisst du?"
LOCATE CSRLIN - 1, 13
INPUT "", name$
'das "", unterdrueckt das Fragezeichen vor der Eingabe
 

