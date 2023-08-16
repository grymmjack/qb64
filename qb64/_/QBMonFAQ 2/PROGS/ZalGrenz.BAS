'*********************************************************
' ZALGRENZ.BAS = Begrenzte Zahleneingabe
' ============
' Der Anwender wird aufgeforder, eine Zahl zwischen
' 0 und +10000 einzugeben. Liegt der Eingabewert
' ausserhalb dieses Bereiches, so erfolgt eine Neueingabe.
'
' (c) Thomas Antoni, 12.11.2003
'*********************************************************
CLS
DO
  CLS
  LOCATE 2, 1
  PRINT SPACE$(70)
    'alten Eingabewert loeschen
    '(mit 70 Leerzeichen ueberschreiben)
  LOCATE 2, 1
  INPUT "Gib eine Zahl zwischen 0 und 10000 ein: "; z%
  IF z% <= 10000 AND z% >= 0 THEN
    EXIT DO 'fertig! -> Schleife verlassen
  ELSE
    PRINT
    PRINT "Fehler! Die Zahl muss zw. 0 u. 10000 liegen!"
    PRINT " ... zur Neueingabe mit beliebiger Taste"
    DO: LOOP UNTIL INKEY$ <> ""
  END IF
LOOP
PRINT
PRINT "Die Zahl wurde korrekt eingegeben: Sie lautet "; z%
SLEEP
END

