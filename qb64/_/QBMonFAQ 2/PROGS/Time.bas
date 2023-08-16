'*************************************
' TIME.BAS = Uhrzeitanzeige in QBasic
' ========
' Die aktuelle Uhrzeit wird solange
' in Zeile 12, Spalte 35 angezeigt,
' bis der Anwender die Esc-Taste
' dueckt (ASCII-Code 27).
'
' (c) Thomas Antoni, 7.1.2004
'*************************************
DO
  LOCATE 12, 35: PRINT TIME$
LOOP UNTIL INKEY$ = CHR$(27)
END

