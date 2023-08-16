'**************************************************************
' HEX2DEC2.BAS = Dezimal-Hexadezimal-Wandlung ohne Verwendung
' ============   des VAL-Befehls
' (c) Thomas Antoni, 25.6.02 - 17.2.04
'**************************************************************
DO
  INPUT "Gib eine Hex-Zahl ein (Abbrechen mit 0) "; Hexa$
  IF Hexa$ = "0" THEN END 'Abbruch mit "0"
  Hexa$ = UCASE$(Hexa$) 'Buchstaben in Grossbuchstaben wandeln
  Dezi& = 0
  Z% = 0
  FOR I% = LEN(Hexa$) TO 1 STEP -1
    Stelle% = ASC(MID$(Hexa$, I%, 1))
    SELECT CASE Stelle%
      CASE 48 TO 57: Stelle% = Stelle% - 48 'Ziffer 0...9
      CASE 65 TO 70: Stelle% = Stelle% - 55 'Buchstabe A...F
      CASE ELSE
        PRINT "Falsche Hex-Zahlen-Eingabe"
        SLEEP
        END
    END SELECT
    Dezi& = Dezi& + (Stelle% * 16 ^ Z%)
    Z% = Z% + 1
  NEXT
  PRINT "Die Dezimalzahl lautet.................. "; Dezi&
  PRINT
LOOP

