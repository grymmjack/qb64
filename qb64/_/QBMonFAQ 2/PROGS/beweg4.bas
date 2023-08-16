'**************************************************************************
' BEWEG4.BAS = Spielfigur mit d.Cursor-Tasten ueber den Bildschirm bewegen
' ==========
' Dieses Q(uick)Basic-Programm demonstriert, wie man eine kleine Spielfigur
' mit den Cursortasten ueber den Bildschirm bewegen kann.
'
' (c) Ferdinand Wirth, 10.09.2003
'**************************************************************************
REM -beginn-
10
SCREEN 12
SCREEN 0
'
PRINT "Gib exit ein um das Spiel zu beenden"
LINE INPUT "Bitte wÑhle die Spielgeschwindigkeit. (1 - 300): "; eingabe$
IF eingabe$ = "exit" THEN END
'
s = VAL(eingabe$)
s = s / 7000
'
REM -start position / start richtung (b) -
'
x = 10: y = 48: b = 6
'
REM - schleife beginn -
CLS
SCREEN 13
COLOR 12
SLEEP 1
'
DO
'
REM - Level -
IF levelwirdgeladen = 0 THEN
  LINE (100, 50)-(150, 50)
  levelwirdgeladen = 1
END IF
'
IF x > 98 AND x < 152 AND y > 48 AND y < 52 THEN z = 2
'
REM ///////////////// Figur bewgen ///////////////
o$ = INKEY$
CIRCLE (x, y), 1, 15
IF o$ = CHR$(0) + CHR$(77) THEN b = 6
IF b = 6 THEN
  x = x + s: xx = x - s
  CIRCLE (xx, y), 2, 0
END IF
'
IF o$ = CHR$(0) + CHR$(75) THEN b = 4
IF b = 4 THEN
  x = x - s: xx = x + s
  CIRCLE (xx, y), 2, 0
END IF
'
IF o$ = CHR$(0) + CHR$(72) THEN b = 8
IF b = 8 THEN
y = y - s: yy = y + s
CIRCLE (x, yy), 2, 0
END IF
'
IF o$ = CHR$(0) + CHR$(80) THEN b = 2
IF b = 2 THEN
  y = y + s: yy = y - s
  CIRCLE (x, yy), 2, 0
END IF
'
IF o$ = CHR$(27) THEN GOTO 10
'
LOOP UNTIL z > 0
'
REM /////////////////////////// verloren //////////////////////
100
SCREEN 12
SCREEN 0
'
PRINT "Leider Du bist in eine rote Linie hineingefahren."
PRINT
PRINT "DrÅcke eine Taste um das Spiel zu beenden."
SLEEP
END

