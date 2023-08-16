'***************************************************************************
' ASCIANSI.BAS = Umwandlung einer ASCII- in eine ANSI-Textdatei
' ============
' Dieses QBasic-Programm wandelt eine waehlbare DOS-ASCII-Datei ins
' Windows-ANSI-Format um. Die maximale Dateigroesse betraegt 2 GB ! Die
' ASCII- und ANSI-Codes 0 bis 127 stellen dieselben Zeichen dar. Eine
' Konvertierung ist also nur fuer die Codes 128 bis 255 erforderlich. Das
' sind die Zeichencodes fuer die Umlaute, landesspezifischen Zeichen und
' "Kastensymbole". Diese Zeichen werden in der ASII-Datei gemaess der
' unten mit DATA angegebenen Umwandlungstabelle ersetzt. Alle Kastensymbole
' mit einer und zwei Linien werden durch "-" und "+" ersetzt.
'
' Als ANSI-Code wird der in ISO 8859-1 spezifizierte Zeichensatz "Latin 1 /
' Westlich" vorausgesetzt.
'
' Beim ASCII-Code wird die MS-DOS-Codeseite 437 ("Englisch") zugrundegelegt,
' die auf deutschsprachigen PCs mit MS-DOS bis 6.22 und Windows 3.1
' vorkonfiguriert ist.
'
' Windows ab der Version 95 verwendet stattdessen die etwas abweichende
' Codeseite 850 ("Mehrsprachig/Lateinisch") mit weniger Kastensymbolen und
' mehr landesspezifischen Zeichen. Trotzdem sollte das Programm mit fast
' allen ASCII-Texten funktionieren. Das Programm laesst sich leicht fuer
' die Codeseite 850 modifizieren: Es muss dazu lediglich die DATA-Tabelle
' leicht angepasst werden. Auch eine ANSI-ASCII-Wandlung laesst sich durch
' eine entsprechende Belegung der DATA-Tabelle bewerkstelligen.
'
' (c) Thomas Antoni, 28.1.2004 - 16.3.2004
'***************************************************************************
COLOR 0, 15                     'schwarz auf weiss
CLS
DIM t AS STRING * 1             'Zwischenspeicher fuer genau ein Byte
'
'---- Code-Umwandlungstabelle einlesen -------------------------------------
DIM tabelle(128) AS INTEGER
FOR i% = 0 TO 127               'ANSI Codes fuer die ASCII-Zeichen 128-255
  READ tabelle(i%)
NEXT
'
'---- ASCII-Quelldatei und temporaere Datei oeffnen -----------------------
PRINT
PRINT " <-----=====#  ASCII-ANSI-Konvertierung (c)Thomas Antoni  #=====----->"
PRINT
INPUT " Gib das Laufwerk d.ASCII-Datei ein; Beispiel: C ......... "; lw$
INPUT " Gib den Pfad der ASCII-Datei ein;   Beispiel: TEMP ...... "; Pfad$
INPUT " Gib den Namen d. ASCII-Datei ein;   Beispiel: TEST.TXT .. "; datei$
IF Pfad$ <> "" THEN Pfad$ = Pfad$ + "\" 'kein doppelter Backslash bei
                                        'fehlendem Pfad (Stammverzeichnis)
PRINT
PRINT " Soll die Datei ";
COLOR 15, 9                        'weiss auf blau
PRINT " "; lw$; ":\"; Pfad$; datei$; " ";
COLOR 0, 15
PRINT " nach ANSI konvertiert und ueberschrieben werden?"
PRINT
PRINT " ....OK mit beliebiger Taste  ....Abbruch mit Esc"
taste$ = INPUT$(1)                 'Eine Taste von der Tastatur einlesen
IF taste$ = CHR$(27) THEN END      'Programm beenden mit Esc-Taste
PRINT
SHELL lw$ + ":"                    'ins angegebene Laufwerk wechseln
CHDIR "\" + Pfad$                  'ins angegebene Verzeichnis wechseln
OPEN datei$ FOR BINARY AS #1       'ASCII-Quelldatei oeffnen
OPEN "xxx.tmp" FOR BINARY AS #2    'Temporaere Datei
'
'---- Alle Zeichen in ANSI-Code wandeln -----------------------------------
LOCATE 13, 17: PRINT "Zeichen umgewandelt"
anz& = 0
DO UNTIL LOC(1) = LOF(1)        'Schleife ueber alle Bytes der Quelldatei
  GET #1, , t                   'ein ASCII-Zeichen aus Quelldatei lesen
  c% = ASC(t)                   'ASCII-Code als Zahl
  IF c% > 127 THEN              'Codes ueber 127 muessen konvertiert werden
    t = CHR$(tabelle(c% - 128)) 'zugehoeriges ANSI-Zeichen ermitteln
  END IF
  PUT #2, , t                   'ANSI-Zeichen in Temp-Datei schreiben
  anz& = anz& + 1
  LOCATE 13, 5: PRINT anz&      'Anzahl der gewandelten Zeichen anzeigen
LOOP
CLOSE #2
CLOSE #1
'
'---- Ergebnisdatei abspeichern -------------------------------------------
KILL datei$                     'Quelldatei loeschen
NAME "xxx.tmp" AS datei$        'Temp. Datei in Quelldatei umbenennen
BEEP
PRINT : PRINT " Fertig!"
'
'---- Umwandlungstabelle ASCII-ANSI (Codes 128 bis 255) -------------------
'An jedem der ASCII-Code-Plaetze 128...255 ist der dafuer
'einzusetzende ANSI-Code angegeben. Zeichen, fuer die es bei ANSI keine
'Entsprechung gibt, werden durch ein Leerzeichen ersetzt (CHR$(32)).
DATA                                         199, 252: 'ASCII-Codes 128-129
DATA 233, 226, 228, 224, 229, 231, 234, 235, 232, 239: 'ASCII-Codes 130-139
DATA 238, 236, 196, 197, 201, 230, 198, 244, 246, 249: 'ASCII-Codes 140-149
DATA 255, 249, 255, 214, 220, 162, 163, 165, 032, 131: 'ASCII-Codes 150-159
DATA 225, 237, 243, 250, 241, 209, 032, 032, 191, 043: 'ASCII-Codes 160-169
DATA 172, 189, 188, 161, 171, 187, 124, 124, 124, 124: 'ASCII-Codes 170-179
DATA 043, 043, 043, 043, 043, 043, 124, 043, 043, 043: 'ASCII-Codes 180-189
DATA 043, 043, 043, 043, 043, 043, 045, 043, 043, 043: 'ASCII-Codes 190-199
'
DATA 043, 043, 043, 043, 043, 045, 043, 043, 043, 043: 'ASCII-Codes 200-209
DATA 043, 043, 043, 043, 043, 043, 043, 043, 043, 124: 'ASCII-Codes 210-219
DATA 043, 124, 124, 043, 170, 223, 032, 182, 202, 243: 'ASCII-Codes 220-229
DATA 181, 134, 164, 056, 254, 240, 156, 248, 202, 110: 'ASCII-Codes 230-239
DATA 061, 177, 032, 032, 131, 131, 247, 126, 176, 183: 'ASCII-Codes 240-249
DATA 173, 086, 179, 178, 124, 255                    : 'ASCII-Codes 250-255

