'***************************************************
' DEC2BIN3.BAS - Dezimalzahl in Binaerzahl wandeln
' ============
'***************************************************
CLS
DO
bin$ = ""
PRINT "Gib die in den Dualcode zu wandelnde ";
PRINT "Dezimalzahl ein"
PRINT "(max 32767, 0 zum Beenden): "
INPUT zahl%
IF zahl% = 0 THEN END'Beenden bei "0"
z% = 2 ^ 14
FOR x% = 0 TO 14
  IF zahl% - z% >= 0 THEN
    bin$ = bin$ + "1"
    zahl% = zahl% - z%
  ELSE
    bin$ = bin$ + "0"
  END IF
  z% = z% / 2
NEXT
PRINT bin$
PRINT
LOOP




