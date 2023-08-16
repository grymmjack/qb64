'****************************************************************************
' SREENRD.BAS - QBASIC-Programm zum Auslesen des Text-Bildschirms mit SCREEN
' ===========
' Mit Hilfe der SCREEN-Funktion werden die ersten 40 Zeichen der ersten
' Bildschirmzeile ausgelesen und in die Variable text$ eingetragen.
' text$ wird anschlieáend wieder in die 24. Bildschirmzeile ausgegeben.
'
' Verwendete Befehle: SCREEN-Funktion
'
'
'
'   \         (c) Thomas Antoni, 16.09.99 - 04.03.00
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************
CLS
PRINT "Thomas Antoni"
FOR spalte% = 1 TO 40
  text$ = text$ + CHR$(SCREEN(1, spalte%))
NEXT spalte%
CLS
LOCATE 24, 1
PRINT text$
SLEEP

