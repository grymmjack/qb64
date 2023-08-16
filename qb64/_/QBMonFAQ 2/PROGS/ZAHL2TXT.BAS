'*******************************************************************
' ZAHL2TXT.BAS = Wandelt eine Zahl in einen Text um
' ============
' (c) Thomas Antoni, 27.4.2004
'*******************************************************************
CLS
PRINT "Gib eine Zahl mit Dezimalpunkt ein (max +/- 2 Milliarden): "
INPUT "", zahl#
zahltext$ = STR$(zahl#)             'Zahl in String wandeln
FOR i% = 1 TO LEN(zahltext$)        'Schleife ueber alle Zeichen
  zeichen$ = MID$(zahltext$, i%, 1) 'Zeichen isolieren
  SELECT CASE zeichen$
    CASE "1": PRINT "eins ";
    CASE "2": PRINT "zwei ";
    CASE "3": PRINT "drei ";
    CASE "4": PRINT "vier ";
    CASE "5": PRINT "fuenf ";
    CASE "6": PRINT "sechs ";
    CASE "7": PRINT "sieben ";
    CASE "8": PRINT "acht ";
    CASE "9": PRINT "neun ";
    CASE "0": PRINT "null ";
    CASE ".": PRINT "komma ";
    CASE "+": PRINT "plus ";
    CASE "-": PRINT "minus ";
    CASE "D": PRINT "mal zehn hoch ";
  END SELECT
NEXT
SLEEP
END
  

