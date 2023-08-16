'*******************************************************
' DEC2HEX2.BAS = Dezimal-Hexadezimal-Wandlung
' ============
' ... ohne Verwendung des HEX$-Befehls
' (c) Thomas Antoni, 25.6.02
'*******************************************************

DO
temp$=""
hx$=""
INPUT "Gib die Dezimalzahl ein"; decimal&
  DO
  div& = decimal& \ 16
  remainder = decimal& MOD 16
  IF remainder > 9 THEN
    remainder = remainder - 9
    temp$ = MID$("ABCDEF", remainder, 1)
  ELSE
    temp$ = LTRIM$(STR$(remainder))
  END IF
  hx$ = temp$ + hx$
  decimal& = div&
  LOOP UNTIL decimal& < 16
    IF decimal& > 9 THEN
      decimal& = decimal& - 9
      temp$ = MID$("ABCDEF", decimal&, 1)
    ELSE
      IF decimal& <> 0 THEN temp$ = LTRIM$(STR$(decimal&)) ELSE temp$ = ""
    END IF
  dec2hex$ = temp$ + hx$
PRINT dec2hex$
LOOP

