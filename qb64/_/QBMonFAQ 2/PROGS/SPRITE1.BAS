'*******************************************************'****
' SPRITE1.BAS = Sprite writing example
' ===========
' Dieses QBasic-Prgramm zeigt, wie man einen Sprite
' erzeugen und anzeigen kann.
'
' Zunaechst wird ein Sprite (eine kleine Figur) auf den
' Bildschirm gezeichnet, in diesem Falle ein Kreis. Dann
' wird der Sprite mit dem GET-befehl in das Feld test
' tzransferiert. Ein PUT-Befehl zeigt diesen
' gespeicherten Sprite dann an einer anderen Stelle wieder
' an. Ein PUT auf die alte Stelle l”scht den alten Kreis
'
' (c) by an unknown program autor
'     German-language comment by Thomas Antoni, Feb 26, 2004
'*******************************************************'****
'Set screen mode
SCREEN 7
' Ok, First, we'll draw a circle...
CIRCLE (5, 5), 5
'Next we set our array up by dimensioning lots of numbers
'to one variable:
DIM test(10 * 10)  'or 10 by 10 graphic
' then we put the graphic into the array we just made:
GET (0, 0)-(10, 10), test
' ok, its that simple, TEST is now a sprite and we can put
' it anywhere:
PUT (100, 100), test
LOCATE , 15
PRINT "... Hit any key"
SLEEP
PUT (0, 0), test  'delete old circle

