'****************************************************************************
' INTEXT2.BAS = QBasic-Function zur Tasteneingabe definierter Laenge
' =====================================================================
' Ersetzt den INPUT-Befehl. An die FUNCTION intext$() wird die Laenge
' des Eingabefeldes uebergeben. intext$() realisiert dann eine auf diese
' Laenge begrenzte Tastatureingabe. Mit der Backspace-Taste laesst sich der
' Eingabtext editieren. Esc loescht das Eingabefenster.
'
'   \         (c) Thomas Antoni, 4.5.02 - 5.11.02
'    \ /\           Mailto:thomas*antonis.de
'    ( )            www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************
DECLARE FUNCTION intext$ (length%)
DO
CLS
PRINT "Gib einen max. 12 Zeichen langen Text ein :": PRINT
COLOR 11
t$ = intext$(12)
COLOR 7
LOCATE 5: PRINT "Du hast " + t$ + " eingegeben"
PRINT : PRINT " <wiederholen mit beliebiger Taste  | Abbruch mit Esc >"
DO: key$ = INKEY$: LOOP WHILE key$ = ""
IF key$ = CHR$(27) THEN END
LOOP

'
FUNCTION intext$ (length%)
column% = POS(0) 'Cursor-Spaltenposition sichern
text$ = "": key$ = ""
PRINT "[" + SPACE$(length%) + "]";             'Eingabefeld anzeigen
DO
  SELECT CASE key$
    CASE CHR$(13): EXIT DO                     'Eingabetaste -> Ende der Eingabe
    CASE CHR$(27): text$ = ""                  'Esc -> Text loeschen
    CASE CHR$(8)                               'Backspace-Taste
      IF LEN(text$) > 0 THEN                   'Falls Textlaenge > 0 ...
        text$ = LEFT$(text$, LEN(text$) - 1)   '... Text um 1 Zeichen kuerzen
      END IF
    CASE CHR$(29) TO CHR$(255)                 'alfanumerisches Zeichen?
      IF LEN(text$) = length% THEN             'hat Text schon die volle Laenge
        text$ = LEFT$(text$, LEN(text$) - 1) + key$ 'letztes Zeichen austauschen
      ELSE
        text$ = text$ + key$                   'ansonsten Tastenzeichen anfuegen
      END IF
  END SELECT
  LOCATE , column% + 1: PRINT SPACE$(length%); 'altem Text loeschen
  LOCATE , column% + 1: PRINT text$;           'Neuen Text anzeigen
  x% = LEN(text$)                              'relative Cursorposition
  IF x% = length% THEN x% = x% - 1 'Eingabefeld voll-> Cursor aufs letzte Zeichen
  LOCATE , column% + x% + 1, 1                 'Cursor anzeigen
  DO: key$ = INKEY$: LOOP WHILE key$ = ""      'Warten bis Taste betaetigt
LOOP
intext$ = text$
END FUNCTION

