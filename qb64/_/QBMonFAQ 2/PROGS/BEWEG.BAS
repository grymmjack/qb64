'************************************************************
' BEWEG.BAS = Ein Textzeichen mit den Cursortasten bewegen
' =========
' Dies QBasic-Programm bewegt ein Textzeichen mit Hilfe der
' Cursortasten ueber den Text-Bildschirm (SCREEN 0). Die
' Esc-Taste bricht das Programm ab.
'
' (c) Thomas Antoni, 14.2.2004 - 26.2.2004
'************************************************************
CLS
b$ = "A"  'zu bewegendes Zeichen
x% = 40   'Startwert fuer X-Koordinate
y% = 12   'Startwert fuer Y-Koordinate
'
DO
SELECT CASE INKEY$
  CASE CHR$(0) + "K" 'Cursor links betaetigt
    IF x% > 1 THEN   'linker Rand noch nicht erreicht?
      LOCATE y%, x%
      PRINT " ";     'altes Zeichen loeschen
      x% = x% - 1
    END IF
  CASE CHR$(0) + "M" 'Cursor rechts betaetigt
    IF x% < 80 THEN  'rechter Rand noch nicht erreicht?
      LOCATE y%, x%
      PRINT " ";     'altes Zeichen loeschen
      x% = x% + 1
    END IF
  CASE CHR$(0) + "H" 'Cursor hoch betaetigt
    IF y% > 1 THEN   'oberer Rand noch nicht erreicht
      LOCATE y%, x%
      PRINT " ";     'altes Zeichen loeschen
      y% = y% - 1
    END IF
  CASE CHR$(0) + "P" 'Cursor tief betaetigt
    IF y% < 25 THEN
      LOCATE y%, x%
      PRINT " ";     'altes Zeichen loeschen
      y% = y% + 1
    END IF
  CASE CHR$(27): END 'Programm beenden mit Esc
END SELECT
LOCATE y%, x%        'Cursor positionieren
PRINT b$;            'Zeichen anzeigen
LOOP

