'***********************************************************
' BIN2DEC3.BAS = Binaerzahl in Dezimalzahl wandeln
' ============
'***********************************************************
CLS
DO
  INPUT "Gib die Binaerzahl ein oder q z.Abbrechen"; Binary$
  IF Binary$ = "q" THEN END
  decimal& = 0: power% = 0
  Binary$ = UCASE$(Binary$)
  FOR i% = LEN(Binary$) TO 1 STEP -1
    digit% = ASC(MID$(Binary$, i%, 1)) - 48
    IF digit% < 0 OR digit% > 1 THEN decimal& = 0: EXIT FOR
    decimal& = decimal& + digit% * 2 ^ (power%)
    power% = power% + 1
  NEXT i%
PRINT decimal&
LOOP


