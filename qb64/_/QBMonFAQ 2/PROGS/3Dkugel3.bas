'*******************************************************
' 3DKugel3.BAS = Einfache dreidimenionale Kugelgrafik
' ============
' (c) Andreas Meile, 5.3.2005
'     http://dreael.catty.ch/Deutsch/BASIC-Knowhow-Ecke/
'*******************************************************
DIM SHARED Ht%(127)
DIM farbenKugel%(3), farbenHintergrund%(3)
DECLARE SUB SetzePunkt (x%, y%, FTon&, skala%())
'
' Hilfstabelle fuer Dithering-Algorithmus vorbereiten
h1% = 1
h2% = 128
FOR i% = 0 TO 6
  h2% = h2% \ 2
  FOR j% = 0 TO 127
    IF j% AND h2% THEN
      Ht%(j%) = Ht%(j%) + h1%
    END IF
  NEXT j%
  h1% = 4 * h1%
NEXT i%
'
FOR i% = 0 TO 3
  READ farbenKugel%(i%)
NEXT i%
DATA 15, 12, 4, 0
FOR i% = 0 TO 3
  READ farbenHintergrund%(i%)
NEXT i%
DATA 11, 3, 9, 1
'
SCREEN 7
'
FOR y% = 0 TO 199
  y1! = CSNG(y%) - 99.5
  FOR x% = 0 TO 319
    x1! = (CSNG(x%) - 159.5) / 1.2
    IF y1! * y1! + x1! * x1! < 98! * 98! THEN
      ' Kugelinneres
      x2! = x1! - 40!
      y2! = y1! + 30!
      r! = SQR(x2! * x2! + y2! * y2!)
      SetzePunkt x%, y%, CLNG(332! * r!), farbenKugel%()
    ELSE
      ' Hintergrund
      s! = 132! + x1! * .2 - y1!
      SetzePunkt x%, y%, CLNG(187! * s!), farbenHintergrund%()
    END IF
  NEXT x%
NEXT y%
'
d$ = INPUT$(1)
SCREEN 0
WIDTH 80, 25
'
SUB SetzePunkt (x%, y%, FTon&, skala%())
  fa% = CINT(FTon& \ 16384&)
  FTon% = CINT(FTon& AND 16383&)
  IF FTon% > 2 * Ht%(x% + y% AND 127) + Ht%(x% AND 127) THEN
    PSET (x%, y%), skala%(fa% + 1)
  ELSE
    PSET (x%, y%), skala%(fa%)
  END IF
END SUB

