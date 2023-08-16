'***************************************************************************
' PARALEL2.BAS = Parallele zu einer Geraden bei gegebenen Abstand bestimmen
' ============
'
' (c) Andreas Meile, 15.2.2005
'****************************************************************************
'
DECLARE SUB VerschiebeParallel (x1#, y1#, x2#, y2#, a#, xp1#, yp1#, xp2#, yp2#)
'
DEFDBL A-Z
SCREEN 12
CLS
INPUT "Erster  Punkt der Geraden (x1,y1) : "; x1, y1
INPUT "Zweiter Punkt der Geraden (x2,y2) : "; x2, y2
INPUT "Abstand der Parallele"; a
PRINT "Gerade in blau, Parallele in gruen dargestellt"
'
CALL VerschiebeParallel(x1, y1, x2, y2, a, xp1, yp1, xp2, yp2)
'
LINE (x1, y1)-(x2, y2), 1        'Gerade in blau
LINE (xp1, yp1)-(xp2, yp2), 2    'Parallele in grÅn
'
SLEEP
END

SUB VerschiebeParallel (x1, y1, x2, y2, a, xp1, yp1, xp2, yp2) STATIC
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

