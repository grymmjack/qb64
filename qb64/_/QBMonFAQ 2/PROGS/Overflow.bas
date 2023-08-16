'******************************************************************
' OVERFLOW.BAS = Abfangen des Programmabbruchs bei Zahlenueberlauf
' ============
' Fehler, die beim Ueberlauf des Zahlenbereiches von Integer- und
' Floating-Point-Berechnungen sowie bei Division durch Null
' zum Programmabbruch fuehren, werden mit Hilfe des Befehls
' ON ERROR GOTO abgefangen
'
' (c) Thomas Antoni, 5.7.2003 - 6.7.2003
'
'******************************************************************
ON ERROR GOTO fehler 'Zahlenueberlauf-Fehler abfangen
                     'Fehlerbearbeitung am Programm-Ende
start:
DO
CLS
PRINT
PRINT "                                     k"
PRINT " Berechnung der Exponentialfunktion n  bis 10^308"
PRINT " ------------------------------------------------"
PRINT
INPUT " Gib n ein :   n = ", n#
INPUT " Gib k ein :   k = ", k#
'
PRINT
PRINT
PRINT "               k"
PRINT "              n  = "; n# ^ k#
'******* Wiederholen/Beenden-Dialog
PRINT
PRINT
PRINT " Wiederholen...[beliebige Taste]   Beenden...[Esc]   ";
'warten auf Tastenbetaetigung"
DO: Taste$ = INKEY$: LOOP WHILE Taste$ = ""
IF Taste$ = CHR$(27) THEN END     'Abbruch mit Esc
LOOP
END
'
'***** Fehler-Routine
fehler:
CLS
LOCATE 13
COLOR 12 'hellrote Schrift
PRINT "             Zahlenbereich von 10^308 ueberschritten !!!"
PRINT
PRINT "                  ...weiter mit beliebiger Taste"
COLOR 15 'wieder weisse Schrift
DO: LOOP WHILE INKEY$ = ""
RESUME start

