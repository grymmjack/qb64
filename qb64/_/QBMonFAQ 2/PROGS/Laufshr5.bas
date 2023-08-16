'*****************************************************************
' LAUFSCR5.BAS = Laufschrift ueber den Bildschirm laufen lassen
' ============
' 1.7.2005, nach einer Programmidee von Juergen Hueckstaedt
'*****************************************************************
'
CLS
a$ = "  *******   Guten Morgen liebe Sorgen, seid ihr auch schon alle wach  *******   "
l = LEN(a$)
IF l <> 80 THEN PRINT "String muss exakt 80 Zeichen lang sein ": BEEP: END
a$ = a$ + a$                        'String verdoppeln
i = 0
'
DO
  i = i + 1: IF i > 80 THEN i = 1
  LOCATE 12, 1
  COLOR 0, 7
  PRINT MID$(a$, i, 80)
  Zeit = TIMER
  DO: LOOP UNTIL TIMER > Zeit + .2  '0,2 s Wartezeit
  IF INKEY$ <> "" THEN EXIT DO      'Abbruch mit beliebiger Taste
LOOP
'
END

