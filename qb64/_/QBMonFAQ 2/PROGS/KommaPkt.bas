'**************************************************************
' KommaPkt.bas - Zahlenanzeige mit Komma statt Dezimalpunkten
' ============   und Trennpunkten nach je 3 Stellen
'
' Anzeige einer Zahl mit Komma statt Dezimalpunkt
' und Punkten zur Abtrennung von je 3 Vorkommaziffern
' zur besseren Lesbarkeit. Die Nachkommastellen
' werden kaufmaennisch korrekt gerundet
'
' (c) "Frank the Man" und Thomas Antoni, 22.10.02 - 22.2.06
'**************************************************************
DO
CLS
INPUT "Gib eine Zahl mit Dezimalpunkt ein"; z#
OPEN "c:\tmp.txt" FOR OUTPUT AS #1
PRINT USING "###,###,###,###,###.##"; z#
   'Zahl formatiert mit Komma zwischen den
   'Tausendergruppen anzeigen
PRINT #1, USING "###,###,###,###,###.##"; z#
   'Zahl in dieser Form in Datei schreiben
CLOSE #1
'
OPEN "c:\tmp.txt" FOR INPUT AS #2
LINE INPUT #2, zahl2$
   'Zahl wieder einlesen
FOR a% = 1 TO LEN(zahl2$)     'Schleife ueber alle Zeichen
  IF MID$(zahl2$, a%, 1) = "," THEN
    MID$(zahl2$, a%, 1) = "." 'Komma durch Punkt ersetzen
  ELSEIF MID$(zahl2$, a%, 1) = "." THEN
    MID$(zahl2$, a%, 1) = "," 'Punkt durch Komma ersetzen
  END IF
NEXT a%
CLOSE #2
KILL "c:\tmp.txt"                'Zwischendatei loeschen
PRINT zahl2$
PRINT
COLOR , 10
PRINT " Neue Eingabe = <Beliebige Taste> .... Beenden = <Esc> "
COLOR , 0
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END
LOOP

