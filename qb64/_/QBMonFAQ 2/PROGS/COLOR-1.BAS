'*****************************************************
' COLOR-1.BAS = Einsatz von Farben im QBasic-Textmodus
' ===========
' Thomas Antoni, 6.1.2004
'*****************************************************
COLOR 12, 1   'hellrote Schrift auf blauem Hintergrund
CLS           'Bildschirm loeschen d.h. in der
              'Hintergrundfarbe blau einfaerben
LOCATE 12, 30 'Cursor auf Zeile 12, Spalte 30
PRINT "Die Welt ist farbig!"
PRINT
LOCATE , 25   'Cursor auf Spalte 30
COLOR 14, 2   'gelbe Schrift auf gruenem Hintergrund
PRINT " Und hier gelb auf gruen :) "
COLOR 13       'braune Schrift
LOCATE 20, 26 'Cursor auf Zeile 20, Spalte 22
PRINT "Rosa passt zu gruen ~(ø;ø)~"
COLOR 15, 0   'normale Farben: weiss auf schwarz

