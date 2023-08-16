'*********************************************************************
' SEQERROR.BAS = Stellt fest, ob eine sequentielle Datei vorhanden ist
' ============
' (C) Thomas Antoni, 15.5.2005
'*********************************************************************
ON ERROR GOTO fehler
INPUT "Welche Datei wollen Sie oeffnen "; dateiname$
OPEN dateiname$ FOR INPUT AS #1
GOTO weiter
fehler: PRINT "Datei nicht vorhanden!"
INPUT "Geben Sie den korrekten Dateinamen ein"; dateiname$
RESUME   'Ruecksprung zum fehlerverursachenden Befehl
weiter: PRINT "Datei ist vorhanden"
  '... Hier folgen die weiteren Befehle

