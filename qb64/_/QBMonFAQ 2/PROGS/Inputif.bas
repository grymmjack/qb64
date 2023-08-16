'*********************************************************
' INPUTIF.BAS = Demo fuer die Befehle INPUT und IF...THEN
' ===========
' Dieses QBasic-Programm demonstriert
' - Benutzer-Abfragen mit INPUT
' - Verzweigungen mit IF...THEN
'
' (c) Triton, 2002
'*********************************************************
CLS
INPUT "Wie ist Dein Name ?", name$
INPUT "Wie ist das Wetter heute? (gut), oder (schlecht) "; wetter$
'
IF wetter$ = "gut" THEN text$ = ", dann gehen Sie lieber raus an die Luft!"
'
IF wetter$ = "schlecht" THEN text$ = ", dann bleiben Sie lieber hier!"
PRINT "Ok, "; name$; text$
SLEEP

