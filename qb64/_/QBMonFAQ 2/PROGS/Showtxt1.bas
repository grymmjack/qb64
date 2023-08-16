'*******************************************
' ShowTXT1.bas - Einfacher Textviewer
' ============
' (c) Thomas Antoni, 10.7.02
'*******************************************
DECLARE SUB LoadTXTFile (FileName$)
CLS
INPUT "Gib Pfad und Dateinamen ein "; Datei$
CALL LoadTXTFile(Datei$)
SLEEP

'
SUB LoadTXTFile (FileName$)
  FF = FREEFILE
  OPEN FileName$ FOR INPUT AS #FF
  DO UNTIL EOF(1)
    LINE INPUT #FF, Text$
    PRINT Text$
  LOOP
  CLOSE #FF
END SUB

