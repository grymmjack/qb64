'****************************************************
'DEC2BIN2.BAS = Zahlenkonvertierung Dezimal -> Binaer
'****************************************************
DIM bin%(14) 'Feld zur Ablage der 15 Binaer-Bits
CLS
DO
PRINT "Gib die in den Dualcode zu wandelnde Dezimalzahl";
PRINT "ein (max 32767) oder -1 zum beenden:"
INPUT " ", zahl%
IF zahl% = -1 THEN END 'Programmabbruch mit -1
z% = 2 ^ 14
FOR x% = 0 TO 14
  IF zahl% - z% >= 0 THEN
    bin%(x%) = 1
    zahl% = zahl% - z%
  ELSE
    bin%(x%) = 0
  END IF
  z% = z% / 2
NEXT
PRINT "Die Dualzahl lautet: "
FOR x% = 0 TO 14
  PRINT bin%(x%);
NEXT
PRINT : PRINT
LOOP



