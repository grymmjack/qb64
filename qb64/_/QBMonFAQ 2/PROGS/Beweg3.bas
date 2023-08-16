'****************************************************************
' BEWEG3.BAS = Einen Kreis mit den Cursortasten bewegen
' ==========
' Dies QBasic-Programm bewegt einen Kreis mit Hilfe der
' Cursortasten ueber den Grafik-Bildschirm SCREEN 12.
' Soll der Kreis bewegt werden, so wird er vorher an der
' alten Position geloescht, indem man ihn mit der Hintergrund-
' Farbe uebermalt. Die  Esc-Taste bricht das Programm ab.
'
' (c) Thomas Antoni, 15.2.2004 - 5.3.2004
'****************************************************************
r% = 20   'Kreisradius
x% = 320  'Startwert fuer X-Koordinate
y% = 240  'Startwert fuer Y-Koordinate
kf% = 12  'Kreisfarbe 12=hellrot
hf% = 0   'Hintergrundfarbe 0=schwarz
'
SCREEN 12
COLOR hf%
CLS
DO
SELECT CASE INKEY$
  CASE CHR$(0) + "K"            'Cursor links betaetigt
    IF x% > 0 THEN              'linker Rand noch nicht erreicht?
      CIRCLE (x%, y%), r%, hf%  'alten Kreis loeschen
      x% = x% - 1
    END IF
  CASE CHR$(0) + "M"           'Cursor rechts betaetigt
    IF x% < 639 THEN           'rechter Rand noch nicht erreicht?
      CIRCLE (x%, y%), r%, hf% 'alten Kreis loeschen
      x% = x% + 1
    END IF
  CASE CHR$(0) + "H"           'Cursor hoch betaetigt
    IF y% > 0 THEN             'oberer Rand noch nicht erreicht
      CIRCLE (x%, y%), r%, hf% 'alten Kreis loeschen
      y% = y% - 1
    END IF
  CASE CHR$(0) + "P"           'Cursor tief betaetigt
    IF y% < 479 THEN
      CIRCLE (x%, y%), r%, hf% 'alten Kreis loeschen
      y% = y% + 1
    END IF
  CASE CHR$(27): END           'Programm beenden mit Esc
END SELECT
CIRCLE (x%, y%), r%, kf%       'Kreis zeichnen
LOOP

