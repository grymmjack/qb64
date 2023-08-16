'************************************************************************
' KEYSTAT.BAS - Zustandsanzeige der Sondertasten Shift, NumLock usw.
' ============
' Jedes Bit im Tastatur-Statuswort 00:417 zeigt den Zustand einer
' der Sondertasten an. Mehrfachanzeigen sind moeglich. Im naechsten
' Statusbyte werden Zusatzinformationen hinterlegt, die in diesem
' Programm jedoch nicht ausgewertet werden (Alt Gr usw.)
'
' (c)  A.K. & Thomas Antoni, 24.6.2003 - 10.11.2003
'************************************************************************
DO
DEF SEG = &H40       'BIOS-Datensegment
status% = PEEK(&H17) '&H17 = StatusByteOffset
'
'** Anzeige nur, wenn sich was geaendert hat
IF status% <> statusalt% THEN
  statusalt% = status%
  FOR i% = 1 TO 8 'Anzeige loeschen (mit Blanks ueberschreiben)
    LOCATE i%, 1
    PRINT SPACE$(20)
  NEXT i%
'
  IF (status% AND 1) THEN LOCATE 1, 1: PRINT "Shift rechts"
  IF (status% AND 2) THEN LOCATE 2, 1: PRINT "Shift links"
  IF (status% AND 4) THEN LOCATE 3, 1: PRINT "STRG"
  IF (status% AND 8) THEN LOCATE 4, 1: PRINT "ALT oder Alt Gr"
  IF (status% AND 16) THEN LOCATE 5, 1: PRINT "Rollen"
  IF (status% AND 32) THEN LOCATE 6, 1: PRINT "NumLock"
  IF (status% AND 64) THEN LOCATE 7, 1: PRINT "ShiftLock"
  IF (status% AND 128) THEN LOCATE 8, 1: PRINT "Einfuegen"
END IF
LOOP WHILE INKEY$ <> CHR$(27) 'Beenden mit Esc
DEF SEG 'Segment zuruecksetzen
END



 

