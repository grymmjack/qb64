'***********************************************************************
' BUTTON.BAS - QBasic-Programm zum Erstellen eines Klickbuttons
' ==========
' (c) Tobias Oelschlaeger und Thomas Antoni, 10.10.02 - 2.5.03
'
'***********************************************************************
DECLARE SUB DrawButton (x%, y%, Breite%, Laenge%)

CLS
SCREEN 12
CALL DrawButton(100, 100, 16, 32)
SLEEP

SUB DrawButton (x%, y%, Breite%, Laenge%)
FOR a% = y% TO y% + Breite%
LINE (x% + 1, a%)-(x% + Laenge% - 1, a%), 7
NEXT a%
LINE (x% + 1, y%)-(x% + Laenge% - 1, y%), 0
LINE (x% + 1, y% + Breite%)-(x% + Laenge% - 1, y% + Breite%), 0
LINE (x%, y% + 1)-(x%, y% + Breite% - 1), 0
LINE (x% + Laenge%, y% + 1)-(x% + Laenge%, y% + Breite% - 1), 0
LINE (x% + 1, y% + 1)-(x% + Laenge% - 1, y% + 1), 15
LINE (x% + 1, y% + 1)-(x% + 1, y% + Breite% - 2), 15
LINE (x% + 1, y% + Breite% - 1)-(x% + Laenge% - 1, y% + Breite% - 1), 8
LINE (x% + 2, y% + Breite% - 2)-(x% + Laenge% - 1, y% + Breite% - 2), 8
LINE (x% + Laenge% - 1, y% + Breite% - 1)-(x% + Laenge% - 1, y% + 1), 8
LINE (x% + Laenge% - 2, y% + Breite% - 1)-(x% + Laenge% - 2, y% + 2), 8
END SUB

