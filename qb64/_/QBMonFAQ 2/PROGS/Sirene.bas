'********************************************
' SIRENE.BAS = Demo des QBasic-Befehls SOUND
' ==========
' Dieses Programm erzeugt einen Sirenenklang
' (c) Winfried Furrer, 2000
'********************************************
ton = 780
bereich = 650
FOR zaehler1 = 1 TO 6
  FOR zaehler2 = bereich TO -bereich STEP -4
    SOUND ton - ABS(zaehler2), .3
    zaehler2 = zaehler2 - 2 / bereich
  NEXT zaehler2
NEXT zaehler1