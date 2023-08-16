'***********************************************************************
' IFTHEN.BAS = QBasic-Demo fuer IF...THEN-Abfragen
' ==========
' (c) Triton, 2002
'***********************************************************************
CLS
start:
INPUT "Welchen Wochentag haben wir heute (1=Montag...7=Sonntag): ", tag%
IF tag% < 1 OR tag% > 7 THEN
  PRINT "Ungueltige Eingabe!"
  GOTO start
END IF
IF tag% > 0 AND tag% < 6 THEN
  PRINT "Werktag!"
ELSE
  PRINT "Wochenende!"
END IF
END

