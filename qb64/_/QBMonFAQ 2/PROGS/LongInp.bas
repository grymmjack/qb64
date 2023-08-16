'*******************************************************************************
' LongInp.BAS  - INPUT-Ersatz fuer mehrzeilige Text-Eingabe - fast ein Editor!
' ===========
' Dies Programm ersetzt den INPUT-Befehl und ermoeglicht im Gegensatz zu
' diesem die Eingabe eines mehrzeiligen Textes. Die Texteingabe wird mit der
' Esc-Taste beendet.
'
' (c) Thomas Antoni, 18.08.02 - 19.02.04
'*******************************************************************************
text$ = "": key$ = ""
DO
  SELECT CASE key$
    CASE CHR$(27): EXIT DO                   'Esc-Taste -> Ende der Eingabe
    CASE CHR$(8)                             'Backspace-Taste
      IF LEN(text$) > 0 THEN                 'Falls Textlaenge > 0 ...
        text$ = LEFT$(text$, LEN(text$) - 1) '... Text um 1 Zeichen kuerzen
      END IF
    CASE CHR$(13)                            'Enter-Taste
      text$ = text$ + CHR$(13)
    CASE CHR$(29) TO CHR$(255)               'alfanumerisches Zeichen?
      text$ = text$ + key$                   'ansonsten Tastenzeichen anfuegen
  END SELECT
  CLS
  PRINT text$;                               'Eingegebenen Text anzeigen
  LOCATE , , 1                               'Dahinter den Cursor anzeigen
  key$ = INPUT$(1)                           'Warten bis 1 Taste betaetigt
LOOP
'
PRINT : PRINT "-----": PRINT
PRINT "Du hast Folgendes eingegeben:"
PRINT text$
SLEEP

