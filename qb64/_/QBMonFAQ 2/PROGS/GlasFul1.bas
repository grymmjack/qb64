'****************************************************************************
' GLASFUL1.BAS = Animiertes Befuellen eines Glases
' ============
' Dieses QBasic-Programm zeigt ein animiertes Befuellen eines Glases mit
' gelber Apfelsaftschorle an.
'
' (c) und MisterD und Thomas Antoni, 20.12.04 - 8.1.05
'****************************************************************************
SCREEN 9
CLS
FOR fuellstand = 0 TO 1 STEP .01 'Anzeige in 100 Schritten
  LINE (100, 100)-(200, 400), 15, B
  LINE (101, 100)-(199, 398 - fuellstand! * 280), 0, BF
  LINE (101, 398 - fuellstand * 280)-(199, 399), 14, BF
zeit = TIMER: DO: LOOP WHILE TIMER < zeit + .1 '0,1 sec Wartezeit
NEXT
SLEEP

