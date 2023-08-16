'******************************************************************
' ShowBin.BAS - Binaer-Viewer
' ============
' Dieses QBasic-Programm zeigt den Inhalt einer beliebigen Datei
' im Binaercode an. Die Anzeige des Dateiinhalts erfolgt Seite
' fuer Seite mit Seitenweiterschaltung durch die Betaetigung einer
' beliebigen Taste.
'
' Nach einer Idee von NicTheQuick (NicolasG*web.de)
' von Thomas Antoni, 19.7.02
'******************************************************************
CLS
Block% = 125 'Block * 8 = 1000 Bits je Bildschirm anzeigen
INPUT "Gib Pfad und Namen der Datei ein "; Datei$
OPEN Datei$ FOR BINARY AS #1
DO UNTIL LOC(1) = LOF(1)
  IF LOF(1) - LOC(1) < Block% THEN Block% = LOF(1) - LOC(1)
  Bytes$ = SPACE$(Block%)
  GET #1, , Bytes$
  BinaerBlock$ = ""
  FOR ByteNummer% = 1 TO Block%
    byte% = ASC(MID$(Bytes$, ByteNummer%, 1))
    byte$ = ""
    FOR a% = 0 TO 7
      IF byte% AND 2 ^ a% THEN Bit$ = "1" ELSE Bit$ = "0"
      byte$ = Bit$ + byte$
    NEXT a%
    IF ByteNummer% MOD 9 <> 0 THEN byte$ = byte$ + " "
    BinaerBlock$ = BinaerBlock$ + byte$
  NEXT ByteNummer%
  PRINT BinaerBlock$ 'Anzeige des 1000 Stellen langen Binaer-Strings
  PRINT "   >> weiter mit beliebiger Taste, Abbruch mit Esc <<"
  DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
  IF taste$ = CHR$(27) THEN END
  CLS
LOOP
CLOSE #1


