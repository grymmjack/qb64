'*******************************************************
' pqFormel.bas - Loesung der quadratischen pq-Gleichung
' ============
'
' (c) Thomas Antoni, 8.7.2003
'*******************************************************
DO
CLS
PRINT
PRINT " Loesung der quadratischen Gleichung x^2+px+q=0"
PRINT " ----------------------------------------------"
PRINT
INPUT " Gib p ein: ", p
INPUT " Gib q ein: ", q
PRINT
d = (p / 2) ^ 2 - q 'Diskriminannte
IF d < 0 THEN
  PRINT "L = { } ; keine reelle Loesung"
ELSEIF d = 0 THEN
  PRINT "L = {"; -p / 2; " }"
ELSE ' d > 0
  x1 = -(p / 2) + SQR(d)
  x2 = -(p / 2) - SQR(d)
  PRINT " L {"; x1; " ; "; x2; "}"
END IF
PRINT
PRINT " Wiederholen...[beliebige Taste]   Beenden...[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
 'Warten auf Tastenbetaetigung
IF taste$ = CHR$(27) THEN END'Beenden mit Esc
LOOP

