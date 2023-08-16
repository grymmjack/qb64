'**************************************************************************
' KREISNIT.BAS - Berechnet die Schnittpunkte zweier Kreise
' ============
' Dieses QBasic-Programm erfragt die Mittelpunkte P1 und P2 sowie die
' Radien r1 und r2 zweier Kreise.
'
' Anschliessend berechnet das Programm die maximal 2 Schnittpunkte H1 und
' H2 der beiden Kreise.
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
PRINT "Kreis 1"
INPUT "  Mittelpunkt...(x1,y1) : "; x1, y1
INPUT "  Radius...........(r1) : "; r1
PRINT "Kreis 2"
INPUT "  Mittelpunkt...(x2,y2) : "; x2, y2
INPUT "  Radius...........(r2) : "; r2
'
IF r1 < r2 THEN  'der erste Radius muss groesser als der 2. sein
  SWAP x1, x2
  SWAP y1, y2
  SWAP r1, r2
END IF
'
'**** Ermittlung der Schnittpunkte H1 und H2
SchKreiKrei x1, y1, r1, x2, y2, r2, xh1, yh1, xh2, yh2, m1%
'
'**** Fallunterscheidung, Tangenten zeichnen
CIRCLE (x1, y1), r1, 12             'Kreis 1 hellrot zeichnen
CIRCLE (x2, y2), r2, 12             'Kreis 2 hellrot einzeichnen
SELECT CASE m1%
  CASE -1
    PRINT "Es gibt 2 Schnittpunkte:"
    PRINT "  H1("; xh1; "|"; yh1; ") und"
    PRINT "  H2("; xh2; "|"; yh2; ")"
    CIRCLE (xh1, yh1), 2, 9         'Ersten Schnittpunkt hellblau einzeichnen
    CIRCLE (xh2, yh2), 2, 9         'Ersten Schnittpunkt hellblau einzeichnen
  CASE 0
    PRINT "Die Kreise beruehren sich => Es gibt nur den Beruehrpunkt"
    PRINT "  ("; xh1; "|"; yh1; ")"
    CIRCLE (xh1, yh1), 2, 9         'Beruehrpunkt hellblau einzeichnen
  CASE 1
    PRINT "Die Kreis haben keinen Schnittpunkt"
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
' SchKreiKrei
' ------------
' Diese Subroutine ermittelt die maximal 2 Schnittpunkte S1 (xs1|ys1) und
' S2 (xs2|ys2) der beiden Kreise mit den Mittelpunkten P1 (x1|y1) und
' P2 (x2|y2) sowie den Radien r1 und r2.
'
' r1 muss immer groesser als r2 sein.
' Es wird folgende Fallunterscheidung getroffen:
' . m% = -1 ==> Die Kreise schneiden sich. Es gibt zwei Schnittpunkte
' . m% = 0  ==> Die Kreise beruehren sich im Punkt (xs1|ys1)
' . m% = 1  ==> die Kreise haben keinen Schnittpunkt
'***************************************************************************
'
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

