'**********************************************************
' MULTITAS.BAS = Erfassen von Mehrfachstastenbetaetigungen
' ============
'
' (c) Breeze, 29.7.2003 - 3.9.2003
'     (Vereinfachungen von Thomas Antoni)
'**********************************************************
'
DIM Tasten%(1 TO 128)
'Tastenpuffer. Hier ist jedem der Tastencodes 1-128 ein
'Feldelement zugeordnet. Das Feldelement wird auf 1 gesetzt,
'wenn die Taste gerade gedrueckt ist und auf 0 gesetzt, wenn
'sie losgelassen ist.
'
CLS
Alttast% = 256    'Vorbesetzung fuer gemerkte Taste
DEF SEG = 0
'
'--- Tastenpuffer updaten -------------------------------------
DO
  POKE &H41A, PEEK(&H41C)
  Tastcode% = INP(&H60)            'Keyboard-Statuswort einlesen
  IF Tastcode% <> Alttast% THEN
      'Es wird nur was getan bei Aenderung des Tastenstatus
      Alttast% = Tastcode%
    IF Tastcode% > 128 THEN
      Tasten%(Tastcode% - 128) = 0 'Taste losgelassen
    ELSE
      Tasten%(Tastcode%) = 1       'Taste gedrueckt
    END IF
'
'--- Codes aller gedrueckten Tasten im Tastenpuffer anzeigen ---
  FOR i% = 1 TO 128
    IF Tasten%(i%) = 1 THEN PRINT i%;
  NEXT i%
  PRINT " "                        'Zeilenvorschub  erzwingen
END IF
LOOP UNTIL Tasten%(1) = 1           'Beenden mit Esc-Taste
DEF SEG
END

