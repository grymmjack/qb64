'**************************************************************************
' QUADRAT.BAS - Loesung der Quadratischen Gleichung mit
' ===========   der "Mitternachtsformel"
'
' Dieses Q(uick)Basic-Programm loest die Quadratische Gleichung
'  ax^2 + bx + c = 0 mit Hilfe der "Mitternachtsformel".
'
' (c) Thomas Antoni, 22.1.2003 - 12.2.2006
'**************************************************************************
DO
CLS
PRINT "Gib die Konstanten der Quadratischen Gleichung ax^2 + bx + c = 0 ein"
INPUT "a......."; a
INPUT "b......."; b
INPUT "c......."; c
PRINT
PRINT
PRINT "Die Quadratische Gleichung lautet:"; a; "x^2 + ("; b; ")x + ("; c; ")"
PRINT
d = b ^ 2 - 4 * a * c  'Berechnung der so genannten Diskriminante
IF d = 0 THEN          'Diskriminante = 0
  PRINT "Es gibt nur eine Loesung: x1 = "; -b / (2 * a)
ELSEIF d > 0 THEN      'Diskriminante > 0
  PRINT "Es gibt zwei Loesungen:"
  PRINT "x1 = "; (SQR(d) - b) / (2 * a)
  PRINT "x2 = "; (-SQR(d) - b) / (2 * a)
ELSE                   'Diskriminante < 0
  PRINT "Es gibt keine reelle Loesung"
END IF
LOCATE 22
PRINT "         Wiederholen....[beliebige Taste]      Beenden....[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = "" 'Warten auf Tastenbetaetigung
IF taste$ = CHR$(27) THEN END               'Programm beenden mit Esc
LOOP