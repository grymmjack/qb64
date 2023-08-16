'*****************************************************
' CASE-2.BAS - Beispiel 2 fuer den SELECT CASE Befehl
' ==========
' Dies Beispiel zeigt einige spezielle Moeglickeiten
' des SELECT CASE Befehls
'
' von Thomas Antoni, 6.1.2004 - 1.2.2004
'*****************************************************
CLS 'Bildschirm loeschen
INPUT "Gib eine Zahl zwischen 0 und 10 ein"; z
SELECT CASE z
  CASE 0: PRINT "Eingabewert ist 0"
  CASE 1 TO 8
    PRINT "Eingabewert liegt zwischen 1 und 8"
  CASE 9, 10: PRINT "Eingabewert ist 9 oder 10"
  CASE IS < 0
    PRINT "Falsche Eingabe. Eingabewert ist negativ!"
  CASE ELSE
    PRINT "Falsche Eingabe. Eingabewert zu gross!"
END SELECT
