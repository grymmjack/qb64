'***********************************************************************
' STICKMAN.BAS =  Ein Strichmaennchen mit den Cursortasten bewegen
' ============
' Dieses Q(uick)Basic-Programm zeichnet ein farbiges Strichmaennchen
' im Grafikscreen 12, welches man mit den Cursortasten ueber den
' Bildschirm laufen lassen kann.
'
' (c) brÅgge ( neo1337elite*web.de ), 2.2.2005
'***********************************************************************
DECLARE SUB mann (x!, y!)
DECLARE SUB mannweg (x!, y!)
SCREEN 12
CLS
start:
'
DO
taste$ = INKEY$
IF taste$ <> "" THEN GOTO taste
CALL mann(x, y)
LOOP
'
taste:
CALL mannweg(x, y)
IF taste$ = CHR$(0) + "H" THEN y = y - 1
IF taste$ = CHR$(0) + "P" THEN y = y + 1
IF taste$ = CHR$(0) + "K" THEN x = x - 1
IF taste$ = CHR$(0) + "M" THEN x = x + 1
IF taste$ = CHR$(27) THEN END
GOTO start

SUB mann (x, y)
COLOR 5
CIRCLE (x, y), 20
COLOR 4
LINE (x, y + 20)-(x, y + 80)
LINE (x, y + 25)-(x - 20, y + 80)
LINE (x, y + 25)-(x + 20, y + 80)
COLOR 1
LINE (x, y + 80)-(x - 20, y + 120)
LINE (x, y + 80)-(x + 20, y + 120)
END SUB

SUB mannweg (x, y)
COLOR 0
CIRCLE (x, y), 20
COLOR 0
LINE (x, y + 20)-(x, y + 80)
LINE (x, y + 25)-(x - 20, y + 80)
LINE (x, y + 25)-(x + 20, y + 80)
COLOR 0
LINE (x, y + 80)-(x - 20, y + 120)
LINE (x, y + 80)-(x + 20, y + 120)
END SUB

