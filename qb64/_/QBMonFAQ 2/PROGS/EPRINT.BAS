'****************************************************************
' EPRINT.BAS = Anzeige von ASCII-Steuerzeichen auf dem Bildschirm
' ==========
' (c) Pawel, 1999
'****************************************************************
DECLARE SUB EPRINT (xp$, x, y, fc, hc, b)
DECLARE SUB EPRINT2 (zch, x, y, fc, hc, b)
'
EPRINT "Text", x, y, VordergrundFarbe, HGFarbe, Blinkend
EPRINT2 ASCII, x, y, VordergrundFarbe, HGFarbe, Blinkend
' Blinkend ist hierbei eine boolsche Zahl (0/1)
' EPRINT2 zeigt nur ein einzelnes Zeichen, EPRINT eine
' ganze Zeichenkette.
CLS
'*** Demonstration . . . ***
EPRINT "*** EPRINT und EPRINT2 ***", 21, 3, 5, 0, 0
FOR i = 1 TO 31
EPRINT2 i, 22 + i, 5, i, 1, 0
NEXT i
'*** ... fertig ***
'
SUB EPRINT (xp$, x, y, fc, hc, b)
IF xp$ = "" THEN GOTO endsub
xpos = 160 * (y - 1) + (x - 2) * 2  'Rechne Koordinaten um
c = fc + (hc * 16) + (b * 128)      'Berechne Farbcode
DEF SEG = &HB800
FOR i = 1 TO LEN(xp$)
 xp = ASC(MID$(xp$, i, 1))
 POKE xpos + i * 2, xp
 POKE xpos + i * 2 + 1, c
NEXT i
endsub:
END SUB
'
SUB EPRINT2 (zch, x, y, fc, hc, b)
IF zch <= 0 THEN GOTO endsub2
xpos = 160 * (y - 1) + (x - 2) * 2
c = fc + (hc * 16) + (b * 128)
DEF SEG = &HB800
POKE xpos + i * 2, zch
POKE xpos + i * 2 + 1, c
endsub2:
END SUB

