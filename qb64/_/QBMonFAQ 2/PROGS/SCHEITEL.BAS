'************************************************************************
' SCHEITEL.BAS - Berechnung der Scheitelform der Quadratischen Gleichung
' ============
' Die Quadratische Gleichung y = ax^2 + bx + c = 0 wird
' in die Scheitelform        y = f(x-d)² + e umgewandelt
'
' (c) Thomas Antoni, 27.1.2003 - 28.1.2003
'************************************************************************
DO
CLS
PRINT "Gib die Konstanten der Parabelgleichung ax^2 + bx + c = 0 ein"
INPUT "a......."; a
INPUT "b......."; b
INPUT "c......."; c
PRINT
PRINT "Die allgemeine Form der Parabelgleichung lautet:"
PRINT a; "x^2 + ("; b; ")x + ("; c; ")"
PRINT
d = -b / (2 * a)
IF d < 0 THEN VZd$ = "+" ELSE VZd$ = "-" 'inverses Vorzeichen vond ermitteln
db = ABS(d)                              'Betrag von d ermitteln
e = c - (b / 2) ^ 2 / a
IF e < 0 THEN VZe$ = "-" ELSE VZe$ = "+" 'Vorzeichen von e ermitteln
eb = ABS(e)                              'Betrag von e ermitteln
PRINT
PRINT "Die Scheitelform der Parabelgleichung lautet:"
PRINT a; "* (x "; VZd$; db; ")^2 "; VZe$; eb
PRINT
PRINT "Der Scheitelpunkt hat die folgenden Koordinaten:"
PRINT " S = ("; d; "|"; e; ")"
LOCATE 22
PRINT "         Wiederholen....beliebige Taste      Beenden....Esc"
DO: taste$ = INKEY$: LOOP WHILE taste$ = "" 'Warten auf Tastenbetaetigung
IF taste$ = CHR$(27) THEN END               'Programm beenden mit Esc
LOOP

