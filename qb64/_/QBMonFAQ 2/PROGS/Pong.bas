'*************************************************************
' PONG.BAS = Tennisspiel (Pong-Clone)
' ========
' This Q(uick)Basic programm is a simple Pong game. Move the
' racket with the , and . key. Adjust the speed by modifying
' the setting of the delay variable. Press q for terminating
' the game.
'
' Dieses Q(uick)Basic-Programm ist ein einfaches Pong-Spiel.
' Bewege den Schlaeger mit den Tasten "." und ".". Die
' Spielgeschwindigkeit kannst Du durch Setzen der Variablen
' delay auf einen anderen Wert beeinflussen. Die Taste "q"
' beendet das Spiel
'
' (c) Vic Luce, 1999
'**************************************************************
SCREEN 7, 0, 1, 0
x = 50: y = 50
x2 = 130: y2 = 150
pspeed = 5
xadj = 1: yadj = 1
delay = 1
DO
  press$ = INKEY$
  LINE (0, 0)-(320, 200), 0, BF
  CIRCLE (x, y), 7
  PAINT (x, y), 4, 15
  LINE (x2, y2)-(x2 + 30, y2 + 7), 1, BF
  LINE (x2, y2)-(x2 + 30, y2 + 7), 8, B
  LOCATE 1, 1: PRINT score
  PCOPY 1, 0
  IF y <= 20 THEN yadj = 1
  IF y >= 180 THEN yadj = -1
  IF x >= 300 THEN xadj = -1
  IF x <= 20 THEN xadj = 1
'
  IF press$ = "," AND x2 > 1 THEN x2 = x2 - pspeed
  IF press$ = "." AND x2 < 290 THEN x2 = x2 + pspeed
  x = x + xadj
  y = y + yadj
  IF y > y2 - 7 AND y2 < y2 + 2 AND x < x2 + 30 AND x > x2 THEN
     yadj = -1: score = score + 1
  END IF
'
  IF y > y2 + 10 THEN
    FOR i = 1 TO 100
      PRINT "GAME OVER!!"
      PCOPY 1, 0
    NEXT
    END
  END IF
  FOR i = 1 TO delay: NEXT
LOOP UNTIL press$ = "q"
 

