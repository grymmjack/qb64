'******************************************************************
' ShowTXT2.bas - Textviewer mit seitenweiser Anzeige
' ============
' nach einem Vorschlag von NetZman
'
' von Thomas Antoni, 10.7.02
'******************************************************************
CLS
INPUT "Gib Pfad- und Dateinamen ein "; Datei$
OPEN Datei$ FOR INPUT AS #1
DO WHILE NOT EOF(1)
  LINE INPUT #1, Text$
  count% = count% + 1
  IF count% = 23 THEN   'Bildschirm-Ende erreicht?
    LOCATE 25, 12: COLOR 11
    PRINT " <weiter mit beliebiger Taste >   < abbrechen mit Esc >";
    DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
    IF taste$ = CHR$(27) THEN
      END               'Programmabbruch bei Esc
    ELSE                'beliebige Taste -> naechster Bildschirm
      count% = 0
      COLOR 7: CLS
    END IF
  END IF
  PRINT Text$
LOOP
CLOSE #1

