'******************************************************************
' BIN2ASC.BAS = Binaerzahlen in ASCII-Zeichen umwandeln
' ============
' Dieses QBasic-Programm liest 8 Binaerziffer 0 oder 1) von der
' Tastatur ein, rechnet die resultierende Binaerzahl in eine
' Dezimalzahl und zeigt das dadurch codierte ASCII-Zeichen an.
'
' Dieser Ablauf wird so lange wiederholt bis der Anwender "x"
' eintippt. Zeichen ungleich "0", "1" und "x" werden nicht
' angenommen.
'
' (c) Thomas Antoni, 5.4.2004
'******************************************************************
'
CLS
DO
PRINT "Gib eine 8-stellige Binaerzahl ein (x zum Beenden)......: ";
LOCATE , , 1  'Cursor anzeigen
stelle% = 7
code% = 0
DO
  taste$ = INPUT$(1)  'warten bis 1 Zeichen von Tastatur eingelesen
  IF taste$ = "x" THEN END
  IF taste$ = "1" THEN
    PRINT taste$;
    code% = code% + 2 ^ stelle%
    stelle% = stelle% - 1
  END IF
  IF taste$ = "0" THEN
    PRINT taste$;
    stelle% = stelle% - 1
  END IF
LOOP WHILE stelle% >= 0
PRINT
PRINT "Der ASCII-Code lautet...................................:";
PRINT code%
PRINT "Die Binaerzahl entspricht dem folgenden ASCII-Zeichen...: ";
PRINT CHR$(code%)
PRINT
LOOP

