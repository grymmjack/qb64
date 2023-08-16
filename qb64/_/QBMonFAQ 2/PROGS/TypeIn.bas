'******************************************************************
' TypeIn.bas - Texteingabe mit Schreibmaschinengeraeusch
' ==========
' (c) Thomas Antoni, 25.8.02 - 26.2.04
'******************************************************************
DECLARE FUNCTION typein$ ()
DO
CLS
PRINT "Gib Text ein :"
t$ = typein$
PRINT
PRINT
PRINT "Der Eingabetext war ..."
PRINT t$
PRINT
PRINT " ...Wiederholen mit beliebiger Taste ... Abbruch mit Esc"
DO: key$ = INKEY$: LOOP WHILE key$ = ""
IF key$ = CHR$(27) THEN END
LOOP

'
FUNCTION typein$
COLOR 11
DO
  LOCATE , , 1   'Cursor anzeigen
  key$ = INPUT$(1)            'Warten bis 1 Tastenzeichen gelesen
  SELECT CASE key$
    CASE CHR$(13): EXIT DO    'Eingabe beenden bei Eingabetaste
    CASE CHR$(27): END        'Programmabbruch bei Esc
    CASE CHR$(8)
      IF LEN(text$) > 0 THEN  'Backspace und Textlaenge > 0 ?
        text$ = LEFT$(intext$, LEN(text$) - 1)
                              'Text um 1 Zeichen kuerzen
      END IF
    CASE CHR$(29) TO CHR$(255) 'alfanumerisches Zeichen?
      SOUND 150, 1             'Tastenton 150 Hz fuer 1 Systemtakt
      text$ = text$ + key$
      CLS : PRINT text$;
  END SELECT
LOOP
typein$ = text$
COLOR 7
END FUNCTION

