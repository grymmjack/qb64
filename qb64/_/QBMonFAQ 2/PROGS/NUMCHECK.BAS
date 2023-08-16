'*****************************************************************
' NUMCHECK.BAS = Prueft, ob ein Eingabewert eine Zahl ist
' ============
'
' (c)Thomas Antoni, 1.2.2005
'*****************************************************************
DO
INPUT "Gib eine Zahl ein (Dezimalpunkt erlaubt)"; zahl$
IF zahl$ = "" THEN END   'Beenden mit Eingabe-Taste
'
ok$ = "0123456789."      'zugelassene Zeichen
numerisch% = 1           'Vorbesetzung: korrekter numerischer wert
'
FOR i% = 1 TO LEN(zahl$)
  IF INSTR(ok$, MID$(zahl$, i%, 1)) = 0 THEN numerisch% = 0
NEXT
'
IF numerisch% = 1 THEN PRINT "richtig" ELSE PRINT "falsch"
LOOP


