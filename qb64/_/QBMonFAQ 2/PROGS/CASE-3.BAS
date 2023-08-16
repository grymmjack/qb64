'******************************************************
' CASE-3.BAS - Beispiel 3 fuer den SELECT CASE Befehl
' ==========
' Dies Beispiel zeigt, wie man mit Hilfe des SELECT
' CASE Befehls ein Tastenmenue aufbauen kann.
'
' (c) Thomas Antoni, 9.1.2004 - 1.2.2004
'*****************************************************
DO
CLS
PRINT "Was willst Du tun?"
PRINT " (a)   = Schlafen"
PRINT " (b)   = Essen"
PRINT " (c)   = Fernsehen"
PRINT " (Esc) = Abbruch"
PRINT "Waehle die gewuenschte Aktion (Taste a, b, c oder Esc)"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
'Warten auf die Betaetigung einer beliebigen Taste
PRINT
'
SELECT CASE taste$
  CASE "a": PRINT "Du hast Schlafen gewaehlt"
  CASE "b": PRINT "Du hast Essen gewaehlt"
  CASE "c": PRINT "Du hast Fernsehen gewaehlt"
  CASE CHR$(27)   'Esc betaetigt -> Programm beenden
    PRINT " ... und Tschuess!"
    SLEEP 2       '2 sec warten
    END           'Programm beenden bei Esc-Taste
  CASE ELSE
    PRINT "Fehler! Nur die Tasten a, b, c und Esc sind erlaubt!"
    PRINT "Wiederhole bitte die Eingabe"
END SELECT
PRINT
PRINT "... zurueck zum Hauptmenue mit beliebiger Taste";
DO: LOOP WHILE INKEY$ = ""
LOOP