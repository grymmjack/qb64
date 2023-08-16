'****************************************************
' HEX2DEC1.BAS = Hexadezimal-Dezimal-Wandlung
' ============   mit Verwendung des VAL-Befehls
' (c) Thomas Antoni, 25.6.02
'****************************************************
DO
  INPUT "Gib Hex-Zahl ein (0 zum Beenden)"; hexzahl$
  IF hexzahl$ = "0" THEN END 'Abbruch mit 0
  deczahl% = VAL("&H" + hexzahl$)
  PRINT "Die Dezimalzahl lautet:......... "; deczahl%
  PRINT
LOOP

