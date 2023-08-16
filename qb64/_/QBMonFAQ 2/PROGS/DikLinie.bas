'************************************************************************
' DIKLINIE.BAS = Zeichnen einer dicken Linie (als Rechteck)
' ============
' Dieses Q(uick)Basic-Programm zeichnet eine Linie waehlbarer
' Dicke und Farbe. Die Linie wird durch ein farbig ausgefuelltes
' Rechteck nachgebildet.
'
' (c) Thomas Antoni, 17.7.05  --- www.qbasic.de
'************************************************************************
DECLARE SUB dicklin (x1%, y1%, x2%, y2%, c%, d%)
'
SCREEN 12
'
'---- Zeichne ein rotes Haus (c=12) mit einem blauen Dach (c=9),
'---- Liniendicke d=8
CALL dicklin(20, 200, 20, 460, 12, 8)   'linke Wand
CALL dicklin(20, 460, 619, 460, 12, 8)  'Boden
CALL dicklin(619, 460, 619, 200, 12, 8) 'rechte Wand
CALL dicklin(619, 200, 320, 100, 9, 8)  'rechte Dachschraege
CALL dicklin(320, 100, 20, 200, 9, 8)   'linke Dachschraege
SLEEP

'
SUB dicklin (x1%, y1%, x2%, y2%, c%, d%)
'****************************************************************************
' DICKLIN = SUB zum Zeichnen einer dicken Linie
' =======
' Uebergabeparameter:
' x1%, y1% = Koordinaten des ersten Linien-Endpunktes
' x2%, y2% = Koordinaten des zweiten Linien-Endpunktes
' c%       = Farbe der linie
' d%       = Dicke der Linie in Anzahl Bildschirmpunkte
'
' Die Linie wird durch ein Rechteck mit den Eckpunkten (x11, y11),
' (x12, y12), (x21, y21) und (x22, y22) nachgebildet.
'****************************************************************************
IF x1% = x2% THEN             'Sonderfall: Senkrechte Linie
  dx% = d% / 2
  dy% = 0
ELSEIF y1% = y2% THEN
  dx% = 0
  dy% = d% / 2
ELSE
  alfa! = ATN((y1% - y2%) / (x2% - x1%)) 'Steigungswinkel der Linie
  dx% = (d% / 2) * SIN(alfa!) 'x- und y-Differenz zwischen den Eckpunkten des
  dy% = (d% / 2) * COS(alfa!) 'Rechtecks und dem Endpunkt der normalen Linie
END IF
'
x11% = x1% - dx%              'Berechnung der Eckpunkte des Rechtecks
x12% = x1% + dx%
x21% = x2% - dx%
x22% = x2% + dx%
y11% = y1% - dy%
y12% = y1% + dy%
y21% = y2% - dy%
y22% = y2% + dy%
'
LINE (x11%, y11%)-(x21%, y21%), c%   'Rechteck zeichnen
LINE (x21%, y21%)-(x22%, y22%), c%
LINE (x22%, y22%)-(x12%, y12%), c%
LINE (x12%, y12%)-(x11%, y11%), c%
xm% = x1% + (x2% - x1%) / 2          'Koordinaten des ...
ym% = y2% + (y1% - y2%) / 2          '... Linien-Mittelpunktes
PAINT (xm%, ym%), c%, c%             'Rechteck farbig fuellen
END SUB

