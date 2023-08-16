'******************************************************************************
' Sort_TXT.bas = Sortieren von Texten  mit korrekter Behandlung der Umlaute
' ============
' Die ASCII-odes der Textzeichen sind von Haus aus schon in der richtigen
' alfabetischen Reihenfolge angeordnet. Dadurch ist das Sortieren von
' englischen Texten fast ein Kinderspiel. Bei deutschen Umlauten und "Eszet"
' liegen die Zeichencodes jedoch ganz ausserhalb der Reihenfolge. Das
' vorliegende QBasic-Programm wandelt sie daher vor dem Sortieren zunaechst
' in die entsprechenden Nicht-Umlaut-Buchstaben um; aus a-Umlaut wird z.B. a.
'
' Wird dieses Programm mit einer Windows-Anwendung betrachtet, so ist zu
' beachten, dass die Umlaute im Windows-ANSI-Code anders als im DOS-ASCII-
' Code angezeigt werden.
'
' (c) Peter Vollenweider (peter.vollenweider*gmx.ch), 13.5.02
'     Kommentare von Thomas Antoni, 13.5.02 - 26.2.04
'******************************************************************************
'$DYNAMIC
DEFINT A-Z
CLS
max = 1000
DIM woerter(max) AS STRING
DIM hilfsarray1(max) AS STRING
DIM hilfsarray2(max) AS INTEGER
'
DO
  wort = wort + 1
  INPUT "Gib das naechste Wort ein, leere Eingabe zum Beenden: ", woerter(wort)
  LOOP UNTIL woerter(wort) = ""
    max = wort - 1
    FOR ersetzen = 1 TO max
      hilfsarray1(ersetzen) = woerter(ersetzen)
      WHILE INSTR(hilfsarray1(ersetzen), "Ñ") 'Kleines A-Umlaut
        MID$(hilfsarray1(ersetzen), INSTR(hilfsarray1(ersetzen), "Ñ"), 1) = "a"
      WEND
      WHILE INSTR(hilfsarray1(ersetzen), "î") 'Kleines O-Umlaut
        MID$(hilfsarray1(ersetzen), INSTR(hilfsarray1(ersetzen), "î"), 1) = "o"
      WEND
      WHILE INSTR(hilfsarray1(ersetzen), "Å") 'Kleines U-Umlaut
        MID$(hilfsarray1(ersetzen), INSTR(hilfsarray1(ersetzen), "Å"), 1) = "u"
      WEND
      WHILE INSTR(hilfsarray1(ersetzen), "·")  'EsZet
        MID$(hilfsarray1(ersetzen), INSTR(hilfsarray1(ersetzen), "·"), 1) = "s"
      WEND
      WHILE INSTR(hilfsarray1(ersetzen), "é")  'Grosses A-Umlaut
        MID$(hilfsarray1(ersetzen), INSTR(hilfsarray1(ersetzen), "é"), 1) = "A"
      WEND
      WHILE INSTR(hilfsarray1(ersetzen), "ô")  'Grosses O-Umlaut
        MID$(hilfsarray1(ersetzen), INSTR(hilfsarray1(ersetzen), "ô"), 1) = "O"
      WEND
      WHILE INSTR(hilfsarray1(ersetzen), "ö")  'Grosses U-Umlaut
        MID$(hilfsarray1(ersetzen), INSTR(hilfsarray1(ersetzen), "ö"), 1) = "U"
      WEND
      hilfsarray1(ersetzen) = UCASE$(hilfsarray1(ersetzen))
                                               'Gross fuer keine Unterscheidung
      hilfsarray2(ersetzen) = ersetzen
    NEXT
'Sortieren, nur Hilfsarrays vertauschen!
FOR sort1 = 1 TO max
  FOR sort2 = sort1 TO max
    IF hilfsarray1(sort1) > hilfsarray1(sort2) THEN
      SWAP hilfsarray1(sort1), hilfsarray1(sort2)
      SWAP hilfsarray2(sort1), hilfsarray2(sort2)
    END IF
NEXT sort2, sort1 'Trick fÅr schnellere FOR-Schleife
'
PRINT
PRINT "Die sortierten Wîrter lauten:"
FOR anzeigen = 1 TO max
   PRINT woerter(hilfsarray2(anzeigen))
NEXT
SLEEP
END

