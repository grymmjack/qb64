'****************************************************************
' ASCI2BIN.BAS = ASCII-Zeichen in Binaerzahl umwandeln
' ============
' Dieses QBasic-Programm liest ein ASCII-Zeichen von der
' Tastatur und wandelt dessen ASCII-Dode in eine Binaerzahl
' um.
'
' Dieser Ablauf wird so lange wiederholt bis der Anwender "0"
' eingibt.
'
' (c) Thomas Antoni, 5.4.2004
'****************************************************************
'
DIM bin$(8)
CLS
DO
PRINT "Gib ein Textzeichen ein (0 zum Beenden).....: ";
LOCATE , , 1          'Cursor anzeigen
zeichen$ = INPUT$(1)  'Warten bis 1 Zeichen v.Tastatur eingelesen
PRINT zeichen$
code% = ASC(zeichen$) 'in ASCII-Code umwandeln
PRINT "Das Zeichen hat den dezimalen ASCII-Code....:"; code%
PRINT "Das Zeichen hat den binaeren ASCII-Code.....: ";
FOR i% = 1 TO 8
  IF code% MOD 2 = 0 THEN bin$(i%) = "0" ELSE bin$(i%) = "1"
  code% = code% \ 2  'Ganzzahl-Division
NEXT i%
FOR i% = 8 TO 1 STEP -1
  PRINT bin$(i%);
NEXT i%
PRINT : PRINT
IF zeichen$ = "0" THEN END
LOOP

