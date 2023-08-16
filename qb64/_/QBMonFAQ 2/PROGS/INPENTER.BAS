'****************************************************************************
' INPENTER.BAS = QBasic-Function zur Tasteneingabe inkl. Enter-Taste
' =====================================================================
' Die Funktion INPENTER ersetzt den INPUT-Befehl und ermoeglicht Tastenein-
' gaben, in denen auch die Eingabetaste (Enter) vorkommen kann, ohne dass
' dadurch die Eingabe abgebrochen wird. Esc beendet die Eingabe und uebergibt
' den String.
'
' Dies Programm ist fast ein kleiner Editor. An Editier- und Navigations-
' Funktionen wird aber lediglich die Zurueck-Taste ausgewertet (Backspace)
'
'   \         (c) Thomas Antoni, 30.12.2002
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de  
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************
DECLARE FUNCTION inpenter$ ()
DO
CLS
PRINT "Gib einen beliebig langen mehrzeiligen Text  ein :"
PRINT "  ......... Beenden mit Esc-Taste"
PRINT
COLOR 11
t$ = inpenter$
COLOR 7
CLS
PRINT
PRINT "Du hast folgenden Text eingegeben"
PRINT
PRINT t$
PRINT : PRINT " <wiederholen mit beliebiger Taste  | Abbruch mit Esc >"
DO: key$ = INKEY$: LOOP WHILE key$ = ""
IF key$ = CHR$(27) THEN END
LOOP

FUNCTION inpenter$
spalte% = POS(0) 'Cursor-Spaltenposition sichern
zeile% = CSRLIN  'Cursor-Zeilenposition sichern
text$ = "": key$ = ""
DO
  SELECT CASE key$
    CASE CHR$(27): EXIT DO                     'Escape-Taste -> Ende der Eingabe
    CASE CHR$(8)                               'Backspace-Taste
      IF LEN(text$) > 0 THEN                   'Falls Textlaenge > 0 ...
        text$ = LEFT$(text$, LEN(text$) - 1)   '... Text um 1 Zeichen kuerzen
      END IF
    CASE CHR$(29) TO CHR$(255)                 'alfanumerisches Zeichen?
      text$ = text$ + key$                     'ansonsten Tastenzeichen anfuegen
    CASE CHR$(13)                              'Enter-Taste (Eingabe)
      text$ = text$ + key$                     'Zeilenvorschub anfuegen
  END SELECT
  LOCATE zeile%, spalte%                       'Cursor wiederherstellen
  FOR i% = spalte% TO 80: PRINT " "; : NEXT    'Rest der ersten Zeile loeschen
  FOR i% = zeile% + 1 TO 24: PRINT SPACE$(80); : NEXT
                                               'Restl. Zeilen loesch.
  LOCATE zeile%, spalte%                       'Cursor wiederherstellen
  PRINT text$;                                 'bisher eingegeb. Text anzeigen
  LOCATE , , 1                                 'Cursor anzeigen
  DO: key$ = INKEY$: LOOP WHILE key$ = ""      'Warten bis Taste betaetigt
LOOP
inpenter$ = text$
END FUNCTION

