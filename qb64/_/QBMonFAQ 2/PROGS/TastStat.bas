'****************************************************************************
' TASTSTAT.BAS = Tastaturstatus fuer Strg,Alt,Shift,Num usw.abfragen/aendern
' ============
' Dieses Q8uick)Basic-Programm demonstriert, wie man den Status der Sonder-
' tasten abfragen und aendern kann. Die Status-LEDs "Num", "ShiftLock" und
' "Rollen" auf der Tastatur werden zum Blibken gebracht.
'
' (c) 23/02/2003 by East-Power-Soft
'
' Tipp 7: Abfrage und Aendern des Tastaturstatus.
'============================================================================
'
'============================================================================
' Bitverteilung im Tastaturstatusbyte.
'============================================================================
'
'---> Bit0 = Rechte Shift (1)
'---> Bit1 = Linke Shift (2)
'---> Bit2 = Strg (4)
'---> Bit3 = Alt (8)
'---> Bit4 = Rollen (16)
'---> Bit5 = Num-Lock (32)
'---> Bit6 = Caps-Lock (64)
'---> Bit7 = Einfügen (128)
'
'****************************************************************************
'
DEF SEG = &H40
ORG = PEEK(&H17): '---> Anfangsstatus merken
DEF SEG
'
'============================================================================
' Beispiel
'============================================================================
CLS
PRINT "Manchmal ist es notwendig, oder wuenschenswert, den Status der"
PRINT "Tastatur abzufragen oder zu aendern. Um dies zu erreichen muss"
PRINT "man lediglich das Tastaturstatusregister mit PEEK(&H17) im Segment"
PRINT "&H40 abfragen bzw. neu beschreiben"
PRINT
PRINT "Wenn Du jetzt auf Deine Tastatur siehst, sollten die LED's"
PRINT "fuer Num-Lock, Caps-Lock und Rollen blinken. So wie die Lampen"
PRINT "blinken, aendert sich auch deren Status. Anders laesst sich dieses"
PRINT "Beispiel leider nicht erklaeren."
PRINT
PRINT "Hier hilft nur ausprobieren. ";
COLOR 14: PRINT "Ende mit RETURN."
'
DEF SEG = &H40
'
DO
  FOR P = 0 TO 80000: NEXT
  POKE &H17, 16 + 32 + 64 '---> Hier wird der neue Status gesetzt
  A$ = INKEY$ '---> damit er wirksam wird, muá die Tastatur
  IF A$ = "" THEN '---> einmal abgefragt werden.
    FOR P = 0 TO 80000: NEXT
    POKE &H17, 0
    A$ = INKEY$
  ELSE
    EXIT DO
  END IF
LOOP
'
POKE &H17, ORG AND NOT (15) '---> Anfangswert wiederherstellen
DEF SEG '---> aber die Bit's 0-3 ausschalten
A$ = INKEY$

