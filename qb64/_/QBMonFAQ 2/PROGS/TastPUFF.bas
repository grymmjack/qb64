'*********************************************************
' TASTPUFF.BAS = FÅllstand des Tastaturpuffers ermitteln
' ============
' Dieses Q(uick)Basic-Programm wartet auf
' Tastenbetaetigungen und zeigt jeweils den aktuellen
' FÅllstand des Tastaturpuffers an, der maximal 15 Tasten
' betaetigungen enthalten kann, bevor er sein Ueberlaufen
' durch einen ekelhaften Piepston signalisiert.
'
' (c) pinkpanther, 6.11.2005
'**********************************************************
DEFINT A-Z
DECLARE FUNCTION FuellstandTastaturPuffer% ()
'
CLS
LOCATE 3, 1
PRINT "FUELLSTAND TASTATURPUFFER ERMITTELN"
'Tastaturpuffer leeren
WHILE LEN(INKEY$)
WEND
'
LOCATE 5, 1
PRINT "Druecke ein paar beliebige Tasten..."
PRINT "(Abbruch mit Escape-Taste)"
'
COLOR 15
LOCATE 8, 1
PRINT "Der Tastaturpuffer enthaelt derzeit ";
DO
  Zeichen = FuellstandTastaturPuffer%
  LOCATE , 36
  PRINT Zeichen; "Zeichen";
  IF Zeichen = 15 THEN
    PRINT " und ist damit ";
    COLOR 23
    PRINT "VOLL!";
    COLOR 15
  END IF
' Eingabeschleife verlassen, wenn die Escape-Taste
' gedrueckt wurde
' (Escape-Taste = Scancode 1;
'  die Abfrage mit INKEY$ wuerde den Tastaturpuffer
'  leeren)
LOOP UNTIL INP(&H60) = 1
'
COLOR 7
END

FUNCTION FuellstandTastaturPuffer%
  DEF SEG = 0
    PufferKopf& = PEEK(&H41A) + PEEK(&H41B) * 256&
    PufferEnde& = PEEK(&H41C) + PEEK(&H41D) * 256&
    Zeichen = (PufferEnde& - PufferKopf&) \ 2
    ' Kopf und Ende des Zirkularpuffers rotieren,
    ' Ergebnis kann daher negativ sein und muss
    ' ggf. korrigiert werden
    IF Zeichen < 0 THEN Zeichen = Zeichen + 16
    FuellstandTastaturPuffer = Zeichen
  DEF SEG
END FUNCTION

