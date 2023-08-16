'**************************************************************************
' HexDecRe.bas = Reelle Hexzahl (mit "Komma") in Dezimalzahl wandeln
' ============
' Auch eine Hexadezimalzahl kann natuerlich Nachkommastellen haben.
' Dabei hat die erste Nachkommastelle die Wertigkeit 1/16, die zweite
' Nachkommastelle die Wertigkeit 1/256 usw. Dieses QBasic-Programm
' wandelt eine derartige hexadezimale Kommazahl in eine Dezimalzahl um.
' Dabei wird das Komma wie in QBasic gewohnt als Dezimalpunkt eingegeben
' und angezeigt.
'
'  (c) Stefan (stef_0815*web.de), 23.2.2004
'**************************************************************************
DECLARE FUNCTION HexInDez# (hexZahl AS STRING)
CLS
DO
INPUT "Gib eine hexadezimale Zahl mit Dezimalpunkt ein:  ", hexa$
PRINT "Die Dezimalzahl lautet.........................: "; HexInDez#(hexa$)
PRINT " ...Wiederholen mit beliebiger Taste ...Beenden mit Esc"
taste$ = INPUT$(1)             'auf Tastenbetaetigung warten
IF taste$ = CHR$(27) THEN END  'Beenden mit Esc
PRINT
LOOP

'
'
FUNCTION HexInDez# (hexZahl AS STRING)
DIM Ziffer AS STRING * 1
DIM DezZahl AS DOUBLE
DIM Faktor AS DOUBLE
Faktor = 1
FOR i% = LEN(hexZahl) TO 1 STEP -1
Ziffer = MID$(hexZahl, i%, 1)
'
SELECT CASE Ziffer
  CASE "."
    DezZahl = DezZahl / Faktor
    Faktor = 1
  CASE "0" TO "9"
    DezZahl = DezZahl + VAL(Ziffer) * Faktor
  CASE "A", "a"
    DezZahl = DezZahl + 10 * Faktor
  CASE "B", "b"
    DezZahl = DezZahl + 11 * Faktor
  CASE "C", "c"
    DezZahl = DezZahl + 12 * Faktor
  CASE "D", "d"
    DezZahl = DezZahl + 13 * Faktor
  CASE "E", "e"
    DezZahl = DezZahl + 14 * Faktor
  CASE "F", "f"
    DezZahl = DezZahl + 15 * Faktor
  CASE ELSE
    PRINT "Fehler: "; hexZahl; " ist nicht vom Format Hex-Zahl"
    END
END SELECT
'
IF Ziffer <> "." THEN Faktor = Faktor * 16
NEXT i%
'
HexInDez# = DezZahl
END FUNCTION

