'*******************************************************
' FREQUENZ.BAS = Frequenzbereich des PC-Speakers messen
' ============
' Dieses QBasic-Programm gibt Toene verschiedener
' Frequenzen je 1 sec lang auf den PC-Speaker mit dem
' SOUND-Befehls aus. Durch eine Hoerprobe laesst
' sich der Frequenzbereich ermitteln, den der
' Speaker abbilden kann.
'
' (c) Thomas Antoni, 8.4.2004
'******************************************************
'
'---- tiefe Toene
FOR i = 40 TO 300 STEP 10
 PRINT "Frequenz = "; i; " Hz"
 SOUND i, 18.2
 SLEEP 1
 IF INKEY$ <> "" THEN EXIT FOR
NEXT i
'
'---- hohe Toene
FOR i = 1000 TO 30000 STEP 1000
 PRINT "Frequenz = "; i; " Hz"
 SOUND i, 18.2
 SLEEP 1
 IF INKEY$ <> "" THEN END
NEXT i

