'************************************************
' SCREENR4.BAS = Textzeichencode und -Farbe vom
' ============   Bildschirm SCREEN 0 auslesen
' Hierzu wird der SCREEN-Befehl verwendet.
'
' (c) Pawel 1999
'================================================
CLS
COLOR 12 'Vordergrundfarbe Hellrot
LOCATE 1, 1
PRINT "X"
  'Hellrotes X in Zeile 1, Spalte 1 ausgeben
Zeichenfarbe% = SCREEN(1, 1, 1)
  'Die Farbe des Zeichens in Zeile 1, Spalte 1
  'in der Variable Zeichenfarbe speichern
Zeichencode% = SCREEN(1, 1)
  'Den ASCII-Code des Zeichens in Zeile 1,
  'Spalte 1 in der Variable Zeichennummer speichern
LOCATE 12
COLOR 7 'Vordergrundfarbe hellgrau
PRINT "Zeichenfarbe: "; Zeichenfarbe%
PRINT "Zeichencode : "; Zeichencode%
  'Eingelesene Werte auf dem Bildschirm ausgeben
PRINT "Zeichen.....:  "; CHR$(Zeichencode%)
  'Das eingelesene Zeichen ausgeben


