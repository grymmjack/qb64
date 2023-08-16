
'********************************************************************
' GRAPMOVE.BAS = Moves a graphic symbol over the screen with cursor keys
' ============   Ein Grafikelement mit den Cursortasten ueber den
'                  Bildschirm bewegen
'
' Deutschen Beschreibung
' ----------------------
' (von Thomas Antoni)
' Dieses Q(uick)Basic-Programm demonstriert, wie man ein kleines
' Mondgesicht mit den Cursortatsen fluessig und flimmerfrei ueber
' den Bildschirm bewegen kann. Dabei werden die befehle GET und
' PUT verwendet.
'
' English Description
' -------------------
' (by Thomas Antoni)
' This Q(uick)Basic programm demonstrates how to move a little
' smiley over the screen by using the cursor keys. The movement
' is smooth and flickerfree. The program utilizes the GET and PUT
' statements.
'********************************************************************
'
SCREEN 12
CLS
'
'---- Paint a smiley
CIRCLE (10, 10), 10, 10
PAINT (10, 10), 6 'this is what I modified, it was 10, not 6
CIRCLE (5, 5), 2, 0 'and this
PAINT (5, 5), 0
CIRCLE (15, 5), 2, 0
PAINT (15, 5), 0
LINE (5, 15)-(15, 15), 4
LINE (10, 10)-(10, 7), 4
'
'--- Get it into an array
DIM graphic(63)
GET (0, 0)-(20, 20), graphic
posx = 320
posy = 200
oposx = posx
oposy = posy
CLS
'
'--- Move it with cursor keys
DO
LINE (oposx, oposy)-(oposx + 20, oposy + 20), 0, BF
PUT (posx, posy), graphic
'Set oposx and oposy to current position
oposx = posx: oposy = posy
'
DO
  cmd$ = INKEY$
LOOP UNTIL cmd$ <> ""
'
SELECT CASE cmd$
CASE CHR$(0) + "H"
  posy = posy - 5
CASE CHR$(0) + "P"
  posy = posy + 5
CASE CHR$(0) + "K"
  posx = posx - 5
CASE CHR$(0) + "M"
  posx = posx + 5
CASE CHR$(27)
  END
CASE "X"
  posx = INT((RND * 520) + 1)
CASE "x"
  posx = INT((RND * 520) + 1)
CASE "Y"
  posy = INT((RND * 440) + 1)
CASE "y"
  posy = INT((RND * 440) + 1)
END SELECT
'
IF posx < 0 THEN posx = 0
IF posx > 600 THEN posx = 600
IF posy < 0 THEN posy = 0
IF posy > 420 THEN posy = 420
LOOP

