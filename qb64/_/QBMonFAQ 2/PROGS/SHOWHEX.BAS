'SHOWHEX.BAS
'===========
'Hex-Viewer - Den Inhalt einer waehlbaren Datei im
'Hexadezimalcode anzeigen.
'nach einer Idee von NicTheQuick (NicolasG*web.de)
'von Thomas Antoni, 19.7.02
'==========================================================
WIDTH 80, 50  'VGA-Auflösung mit 50 Zeilen a 80 Spalten
COLOR 0, 7: CLS 'Schwarz auf Hellgrau
Block% = 768 '48 Zeilen a 16 Bytes je Bildschirm anzeigen
adresse& = -16
text$ = ""
INPUT "Gib den Pfad und Namen der Datei ein "; Datei$
OPEN Datei$ FOR BINARY AS #1
DO UNTIL LOC(1) = LOF(1)
  IF LOF(1) - LOC(1) < Block% THEN
    Block% = LOF(1) - LOC(1)
    ende% = 1                      'Merker "letzter Block"
  END IF
  Bytes$ = SPACE$(Block%)
  GET #1, , Bytes$  'Block einlesen
  FOR Bytenummer& = 1 TO Block%
    IF Bytenummer& MOD 16 = 1 THEN 'Zeilenanfang erreicht?
      adresse& = adresse& + 16     'Adresse aktualisieren
      a$ = HEX$(adresse&)          'Adresse Hex-Wandeln
      LOCATE , 9 - LEN(a$): PRINT a$ + ":   ";  '.. und anzeigen
    END IF
    zeichen$ = MID$(Bytes$, Bytenummer&, 1)
    byte% = ASC(zeichen$)
    IF byte% < 32 THEN zeichen$ = CHR$(254) 'nicht abdruckbares Zeich.
    text$ = text$ + zeichen$
    hexa$ = HEX$(byte%)
    IF LEN(hexa$) = 1 THEN hexa$ = "0" + hexa$ 'führende 0 anhaengen
    PRINT hexa$;                   'aktuelles Byte im Hex-Code anzeigen
    IF Bytenummer& MOD 16 <> 0 THEN
      PRINT " ";
    ELSE
      PRINT "   " + text$: text$ = ""    'ASCII-Text anzeigen
    END IF
  NEXT Bytenummer&
  IF ende% = 1 THEN
    LOCATE , 63
    PRINT text$
    PRINT : PRINT ">> Dateiende erreicht, Abbruch mit beliebiger Taste <<";
  ELSE
    COLOR 1
    LOCATE 50, 15
    PRINT "<weiter mit beliebiger Taste>  <Abbruch mit Esc>";
    COLOR 0
  END IF
  DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
  IF taste$ = CHR$(27) THEN END
  CLS
LOOP
CLOSE #1

