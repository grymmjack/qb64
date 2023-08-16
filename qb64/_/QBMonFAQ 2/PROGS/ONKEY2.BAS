'**************************************************************
' ONKEY2.BAS = Ereignisgesteuerte Abfrage der F1 Taste
' ==========
' (c) TT-Soft, 25.8.02  - www.east-power-soft.de
'**************************************************************
ON KEY(1) GOSUB Marke
KEY(1) ON
PRINT "Druecke F1"
WHILE INKEY$ <> CHR$(27): WEND '<-- dies ist das Hauptprogramm
KEY(1) OFF
END
'
Marke:
CLS
PRINT "Du hast die  F1-Taste betaetigt" '<-- Tastenroutine
SLEEP 1
CLS
RETURN

