'****************************************************************************
' TAB2SPC.BAS = Tabulatoren durch Leerzeichen ersetzen oder loeschen
' ===========
' Dieses Q(uick)Basic-Programm entfernt alle Tabulatorzeichen (ASCII-Code=9)
' aus einer beliebigen Textzeile und ersetzt sie durch eine waehlbare Anzahl
' von Leerzeichen.
' Gibt der Anwender "0" als Anzahl der Leerzeichen ein, so werden alle
' Tabulatoren ersatzlos geloescht.
'
' (c) Thomas Antoni, 3.3.2006
'****************************************************************************
'
'----- Textvorgabe
CLS
PRINT "Dies ist ein Text mit 2 Tabulatoren:"
line$ = "Die" + CHR$(9) + "Sonne" + CHR$(9) + "scheint"
COLOR 14                       'gelbe Textfarbe
PRINT line$                    'Text mit TABs anzeigen
COLOR 7                        'wieder hellgraue Textfarbe
PRINT
PRINT "Durch wieviele Leerzeichen soll jeder TAB ersetzt werden?"
PRINT "(0 fuer ersatzloses Loeschen der TABs)"
INPUT "", leerz%
leerz$ = SPACE$(leerz%) 'String mit der gewuenschten Anzahl von Leerzeichen
'
'----- Tabulatoren ersetzen
lineptr% = 1                                  'Zeilenzeiger initialisieren
'
DO                                            'Schleife ueber alle Zeichen
  foundptr% = INSTR(lineptr%, line$, CHR$(9)) 'TAB suchen
  IF foundptr% > 0 THEN                       'TAB gefunden?
    line$ = LEFT$(line$, foundptr% - 1) + leerz$ + MID$(line$, foundptr% + 1)
                                  'TAB ersetzen
    lineptr% = foundptr% + leerz% 'Zeilenzeiger hinter Ersetzungsstelle setzen
    IF lineptr% > LEN(line$) THEN EXIT DO     'Zeile fertig bearbeitet
  ELSE EXIT DO                                'keine TABs gefunden
  END IF
LOOP
'
'----- Geaenderten Text anzeigen
PRINT
PRINT "Hier sind die TABs durch"; leerz%; "Leerzeichen ersetzt:"
COLOR 14
PRINT line$
COLOR 7

