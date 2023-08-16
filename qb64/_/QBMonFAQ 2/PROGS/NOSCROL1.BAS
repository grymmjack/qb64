'*******************************************************
' NOSCROLL1.BAS = Ausgabe in die 25. Zeile ohne Scrollen
' =============
' (c) Pawel, 2000 - www.pkworld.de
'*******************************************************
CLS
LOCATE 1, 1
PRINT "Text in der 1. Zeile. "
PRINT "Text in der 2. Zeile. "
LOCATE 25, 1
'
PRINT "Text in der 25. Zeile";
'das Semikolon ";" bewirkt, dass kein Zeilenvorschub
'zur "26" Zeile eingefuegt wird. Daher scrollt der
'Bildschirminhalt nicht nach oben
'
SLEEP
'Auf Taste warten, damit der Text in der 25. Zeile nicht
' von [Beliebige Taste zum Fortsetzen druecken]
' ueberschrieben wird

