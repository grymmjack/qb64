'****************************************************************************
' BEHARR.BAS = Ermittlung der "Beharrlichkeit" einer Zahl
' ==========
' Dieses QBasic-Programm ermittelt die Beharrlichkeit einer Zahl, indem
' des die einzelnen Dezimalstellen der Zahl miteinader multipliziert
' und mit der resultierenden Zahl dasselbe tut. Dieser Vorgang wird
' solange fortgesetzt bis das Ergebnis einstellig wird, Die dafuer
' benoetigte Anzahl von Rechenschritten ist die Beharrlichkeit.
'
' (c) Andreas Meile, 12.2004
'****************************************************************************
DO
CLS
INPUT "Startwert (mindestens zweistellig) "; z&
beharr% = 0
DO
  z1& = 1&
  z2& = z&
  WHILE z2& > 0&
    z1& = z1& * (z2& MOD 10&)
    z2& = z2& \ 10&
  WEND
  IF z1& = z& THEN
    EXIT DO
  END IF
  PRINT z1&
  z& = z1&
  beharr% = beharr% + 1
  IF z& = 0 THEN EXIT DO
LOOP
PRINT "Beharrlichkeit:"; beharr%
PRINT
COLOR 0, 15
PRINT "Neue Berechnung...[Beliebige Taste]_____ Beenden...[Esc]"
COLOR 7, 0
DO: Taste$ = INKEY$: LOOP WHILE Taste$ = ""  'Warten auf Tastendruck
IF Taste$ = CHR$(27) THEN END
LOOP

