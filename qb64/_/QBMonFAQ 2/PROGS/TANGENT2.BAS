'**************************************************************************
' TANGENT2.BAS - Ermittelt alle max. 4 moeglichen Tangenten an 2 Kreise
' ============
' Dieses QBasic-Programm erfragt die Mittelpunkte und Radien von 2 Kreisen
' und ermittelt alle maximal 4 Tangenten, die die Kreise miteinander
' verbinden. Dabei wird der Satz des Thales verwendet.
'
' (c) Andreas Meile ("Dreael") , 15.2.2004
'         http://dreael.catty.ch/Deutsch/BASIC-Knowhow-Ecke/
'**************************************************************************
'
DECLARE SUB SchKreiKrei (xm1#, ym1#, r1#, xm2#, ym2#, r2#, xs1#, ys1#, xs2#, ys2#, m%)
DECLARE SUB VerschiebeParallel (x1#, y1#, x2#, y2#, a#, xp1#, yp1#, xp2#, yp2#)
DEFDBL A-Z
SCREEN 12
CLS
'
PRINT "Erster Kreis"
INPUT "  Mittelpunkt...(x1,y2) : "; x1, y1
INPUT "  Radius...........(r1) : "; r1
PRINT "Zweiter Kreis"
INPUT "  Mittelpunkt...(x2,y2) : "; x2, y2
INPUT "  Radius...........(r2) : "; r2
'
IF r1 < r2 THEN SWAP x1, x2: SWAP y1, y2: SWAP r1, r2
'
xThales = (x1 + x2) / 2#
yThales = (y1 + y2) / 2#
dx = x2 - x1: dy = y2 - y1
rThales = SQR(dx * dx + dy * dy) / 2#
'
IF r1 = r2 THEN
  xh1 = x1
  yh1 = y1
  xh2 = x1
  yh2 = y1
  m1% = -1
ELSE
  SchKreiKrei x1, y1, r1 - r2, xThales, yThales, rThales, xh1, yh1, xh2, yh2, m1%
END IF
'
IF m1% = -1 THEN
  VerschiebeParallel xh1, yh1, x2, y2, r2, xt1, yt1, xt2, yt2
  VerschiebeParallel x2, y2, xh2, yh2, r2, xt3, yt3, xt4, yt4
END IF
SchKreiKrei x1, y1, r1 + r2, xThales, yThales, rThales, xh3, yh3, xh2, yh2, m2%
IF m2% = -1 THEN
  VerschiebeParallel x2, y2, xh3, yh3, r2, xt5, yt5, xt6, yt6
  VerschiebeParallel xh2, yh2, x2, y2, r2, xt7, yt7, xt8, yt8
END IF
'
PRINT "Aeussere Tangenten"
IF m1% = 1 THEN
  PRINT "  Die Kreise weisen keine Tangenten auf."
ELSEIF m1% = 0 THEN
  PRINT "  Es existiert nur eine Tangente, die die beiden Kreise"
  PRINT "  auf Punkt ("; xh1; ","; yh1; ") beruehrt."
ELSE
  PRINT "  Die 1. Tangente geht von ("; xt1; ","; yt1; ")"
  PRINT "    bis ("; xt2; ","; yt2; ")."
  PRINT "  Die 2. Tangente geht von ("; xt3; ","; yt3; ")"
  PRINT "    bis ("; xt4; ","; yt4; "),"
END IF
'
PRINT "Innere Tangenten"
IF m2% = 1 THEN
  PRINT "  Die Kreise weisen keine Tangenten auf."
ELSEIF m2% = 0 THEN
  PRINT "  Es existiert nur eine Tangente, die die beiden Kreise"
  PRINT "  auf Punkt ("; xh3; ","; yh3; ") beruehrt."
ELSE
  PRINT "  Die 1. Tangente geht von ("; xt5; ","; yt5; ")"
  PRINT "    bis ("; xt6; ","; yt6; ")."
  PRINT "  Die 2. Tangente geht von ("; xt7; ","; yt7; ")"
  PRINT "    bis ("; xt8; ","; yt8; "),"
END IF
'
CIRCLE (x1, y1), r1, 12, , , 1
CIRCLE (x2, y2), r2, 12, , , 1
'
IF m1% = -1 THEN
  LINE (xt1, yt1)-(xt2, yt2), 11
  LINE (xt1 - 4, yt1)-(xt1 + 4, yt1), 11
  LINE (xt1, yt1 - 2)-(xt1, yt1 + 2), 11
  LINE (xt2 - 4, yt2)-(xt2 + 4, yt2), 11
  LINE (xt2, yt2 - 2)-(xt2, yt2 + 2), 11
  LINE (xt3, yt3)-(xt4, yt4), 11
  LINE (xt3 - 4, yt3)-(xt3 + 4, yt3), 11
  LINE (xt3, yt3 - 2)-(xt3, yt3 + 2), 11
  LINE (xt4 - 4, yt4)-(xt4 + 4, yt4), 11
  LINE (xt4, yt4 - 2)-(xt4, yt4 + 2), 11
END IF
'
IF m2% = -1 THEN
  LINE (xt5, yt5)-(xt6, yt6), 11
  LINE (xt5 - 4, yt5)-(xt5 + 4, yt5), 11
  LINE (xt5, yt5 - 2)-(xt5, yt5 + 2), 11
  LINE (xt6 - 4, yt6)-(xt6 + 4, yt6), 11
  LINE (xt6, yt6 - 2)-(xt6, yt6 + 2), 11
  LINE (xt7, yt7)-(xt8, yt8), 11
  LINE (xt7 - 4, yt7)-(xt7 + 4, yt7), 11
  LINE (xt7, yt7 - 2)-(xt7, yt7 + 2), 11
  LINE (xt8 - 4, yt8)-(xt8 + 4, yt8), 11
  LINE (xt8, yt8 - 2)-(xt8, yt8 + 2), 11
END IF
SLEEP
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

'
SUB VerschiebeParallel (x1, y1, x2, y2, a, xp1, yp1, xp2, yp2) STATIC
'**********************************************************************
dx = x2 - x1
  dy = y2 - y1
  a1 = SQR(dx * dx + dy * dy)
  w1 = dy * a / a1
  w2 = dx * a / a1
  xp1 = x1 - w1
  yp1 = y1 + w2
  xp2 = x2 - w1
  yp2 = y2 + w2
END SUB

