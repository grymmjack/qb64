'*********************************************************
' MENUUPDN.BAS - Kleines Menue-Programm mt Up/Down-Tasten
' ============
' (c) Thomas Antoni, 13.6.2002  - thomas*antonis.de
'*********************************************************
DO
CLS
max% = 5               'Anzahl der Menuepunkte
'
'***** Menueabfrage (i%=aktuelle Menuenummer -1)
DO
  taste$ = INKEY$
  SELECT CASE taste$
    CASE CHR$(0) + "P" 'Tiefer-Taste -> i% hochzählen
      IF i% < max% - 1 THEN i% = i% + 1
    CASE CHR$(0) + "H" 'Hoeher-Taste -> i% herunterzählen
      IF i% > 0 THEN i% = i% - 1
    CASE CHR$(27)      'Esc-Taste    -> Programm Beenden
      END
    CASE CHR$(13)      'Eing.-Taste  -> Menue verlassen
      EXIT DO          
  END SELECT
  LOCATE 2
  FOR h% = 0 TO max% - 1
    IF h% = i% THEN COLOR 15, 3 ELSE COLOR 0, 7
    LOCATE ,4: PRINT "   Menuepunkt "; h% + 1; "   "
  NEXT h%
LOOP
'
'*** Menue-Aktion (hier die Menue-Aktion einfuegen)
CLS                        
COLOR 15, 0
PRINT "Du hast den Menuepunkt "; i% + 1; "gewaehlt";
PRINT " --- Weiter mit beliebiger Taste"
DO: LOOP WHILE INKEY$ = ""  'Warten auf Tastenbetaetigung
LOOP

