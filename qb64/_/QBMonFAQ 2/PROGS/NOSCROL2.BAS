'**************************************************************************
' NOSCROLL2.BAS = Textausgabe in Zeile 25 ohne zu schrollen
' =============
' (c) Thomas Antoni, 5.5.02 - 23.2.04
'**************************************************************************
WIDTH 80, 25               'Bildschirm mit 80 Spalten und 25 Zeilen
CLS
PRINT "Zeile 1"
LOCATE 25, 1               'Cursor auf den Beginn d.letzten Bildschirmzeile
PRINT SPC(72); "Zeile 25"; '72 Blanks u.8 Zeichen Text in Zeile 25 ausgeben
SLEEP
END


