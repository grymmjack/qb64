'**********************************************************************
' BUCZAEHL.BAS = Zaehlt die Buchstaben in einem Text
' ============
' Dieses Q(uick)Basic-Programm ermittelt, wie oft die Buchstaben
' A...Z bzw. a...z in einem einzugebenden Text vorkommen, Gross-
' und Kleinbuchstaben werden dabei gleich behandelt. "Aas" hat also
' zwei "A". Umlaute, Ziffern und Sonderzeichen werden nicht
' mitgezaehlt. Diese Funktion liesse sich aber leicht ergaenzen.
'
' (c) Sebastian Steiner und Thomas Antoni,  21.10.04 - 18.1.06
'**********************************************************************
'
'---- Fuer jeden Buchstaben das Vorkommen in einem Feld zaehlen -------
DIM BS%(65 TO 90) 'Feld fuer die Buchstaben A...Z (Feldelement-Nummer =
                  'ASCII-Code des jeweiligen Zeichens)
INPUT "Gib einen kleinen Text ein "; MeinString$
MeinString$ = UCASE$(MeinString$)  'Klein- in Grossbuchstaben umwandeln
'
FOR i% = 1 TO LEN(MeinString$)           'Alle Zeichen untersuchen
  Code% = ASC(MID$(MeinString$, i%, 1))  'ASCI-Code des Zeichens
  IF Code% > 64 AND Code% < 91 THEN      'Handelt es sich um A...Z
    BS%(Code%) = BS%(Code%) + 1
  END IF
NEXT i%
'
'---- Anzeige-Schleife; nur vorhandene Buchstaben anzeigen -------------
FOR Code% = 65 TO 90
  Anzahl% = BS%(Code%)
  IF Anzahl% > 0 THEN
      PRINT "Das "; CHR$(Code%); " kommt"; Anzahl%; "x vor."
  END IF
NEXT Code%
SLEEP
END

