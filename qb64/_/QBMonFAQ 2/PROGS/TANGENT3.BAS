'**************************************************************************
' TANGENT3.BAS - Berechnet die Tangenten von einem Punkt an einen Kreis
' ============
' Dieses QBasic-Programm erfragt den Mittelpunkt P1 (x1|y1) und den
' Radius r1 eines Kreises sowie die Koordinaten (x2|y2) eines Punktes P2.
'
' Anschliessend berechnet das Programm die Beruehrungspunkte H1 und H2 der
' maximal 2 Tangenten von P2 an den Kreis.
'
' (c) Thomas Antoni, 22.2.2004  ---  www.qbasic.de
'       nach einer Programmidee von Andreas Meile ("Dreael")
'         http://dreael.catty.ch/Deutsch/BASIC-Knowhow-Ecke/
'**************************************************************************
'
DECLARE SUB SchKreiKrei (xm1#, ym1#, r1#, xm2#, ym2#, r2#, xs1#, ys1#, xs2#, ys2#, m%)
DEFDBL A-Z
SCREEN 12
DO
CLS
PRINT "Kreis"
INPUT "  Mittelpunkt...(x1,y1) : "; x1, y1
INPUT "  Radius...........(r1) : "; r1
PRINT "Ausgangspunkt P2 der Tangente"
INPUT "  Koordinaten...(x2,y2) : "; x2, y2
'
'**** Ermittlung des Thaleskreises ueber P1-P2
xThales = (x1 + x2) / 2#
yThales = (y1 + y2) / 2#
dx = x2 - x1
dy = y2 - y1
rThales = SQR(dx * dx + dy * dy) / 2#
'
'**** Schnittpunkte des Thaleskreises mit dem Kreis (P1 |r1) ermitteln
'**** Dies sind die Tangentenberuehrpunkte H1(xh1|yh1) und H2(xh1|xh2)
SchKreiKrei x1, y1, r1, xThales, yThales, rThales, xh1, yh1, xh2, yh2, m1%
'
'**** Fallunterscheidung, Tangenten zeichnen
CIRCLE (x1, y1), r1, 12             'Kreis hellrot zeichnen
CIRCLE (x2, y2), 2, 9               'P2 hellblau einzeichnen
SELECT CASE m1%
  CASE -1
    PRINT "Es gibt 2 Tangenten mit den Beruehrpunkten:"
    PRINT "H1("; xh1; "|"; yh1; ") und"
    PRINT "H2("; xh2; "|"; yh2; ")"
    LINE (x1, y1)-(x2, y2), 12      'Linie P1-P2 hellrot zeichnen
    LINE (x2, y2)-(xh1, yh1), 9     '1. Tangente hellblau zeichnen
    LINE (x2, y2)-(xh2, yh2), 9     '2. Tangente hellblau zeichnen
    LINE (x1, y1)-(xh1, yh1), 9     'Radius z.1.Beruehrpunkt hellblau zeichnen
    LINE (x1, y1)-(xh2, yh2), 9     'Radius z.1.Beruehrpunkt hellblau zeichnen
  CASE 0
    PRINT "P2 liegt auf dem Kreis => Es gibt nur eine Tangente";
    PRINT " am Punkt P2"
  CASE 1
    PRINT "P2 liegt im Kreis => Es gibt keine Tangente"
END SELECT
'
LOCATE 30
PRINT "Neue Berechnung...[Beliebige Taste]_____Beenden...[Esc]";
Taste$ = INPUT$(1)                  'Warten auf beliebige Tastenbetaetigung
LOOP WHILE Taste$ <> CHR$(27)       'Beenden bei Esc-Teste
END

'
SUB SchKreiKrei (xm1, ym1, r1, xm2, ym2, r2, xs1, ys1, xs2, ys2, m%) STATIC
'**************************************************************************
dx = xm2 - xm1
  dy = ym2 - ym1
  a2 = dx * dx + dy * dy
  r12 = r1 * r1
  r22 = r2 * r2
  h = -4 * a2
  IF h = 0 THEN m% = 1: EXIT SUB
  hi = r12 - r22 - a2
  b2 = hi * hi / h + r22
  IF b2 < 0 THEN m% = 1: EXIT SUB
  b = SQR(b2)
  y = SQR(r12 - b2)
  a = SQR(a2)
  xk = dx / a
  yk = dy / a
  xh = xm1 + xk * y
  yh = ym1 + yk * y
  IF b2 = 0 THEN m% = 0: xs1 = xh: ys1 = yh: EXIT SUB
  xl = xk * b
  yl = yk * b
  xs1 = xh - yl
  ys1 = yh + xl
  xs2 = xh + yl
  ys2 = yh - xl
  m% = -1
END SUB

