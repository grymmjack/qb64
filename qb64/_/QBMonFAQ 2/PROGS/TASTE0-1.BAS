'**************************************************************
' TASTE0-1.BAS = Erfasst das Druecken u.Loslassen d.Alt-Taste
' ============
' Dieses QBasic-Programm greift direkt auf das Tastatur-
' Statuswort mit INP(&H60) zu. Dort ist der Scancode der
' zuletzt gedrueckten Taste auslesbar. Die Scan-Codes gehen
' aus der QBasic-Onlinehilfe hervor (Hilfe | Inhalt |
' Tastatur-Abfragecodes). Da INP(&H60) den Tastaturpuffer nicht
' leert, muss dessen Ueberlaufen durch INKEY verhindert werden.
'
' 25.8.02 - 26.02.04
'**************************************************************
PRINT "Druecke Alt-Taste und lasse sie wieder los"
PRINT "....Programmabbruch mit Esc"
DO
  a$ = INKEY$ 'Tastenpuffer leeren,
              'damit es nicht piepst
  Tastaturcode% = INP(&H60)
  IF Tastaturcode% = 56 THEN
    PRINT "Alt Taste gedrueckt !"
  ELSE
   PRINT "Alt-Taste nicht gedrueckt"
 END IF
LOOP UNTIL Tastaturcode% = 1 'Abbruch mit Esc

