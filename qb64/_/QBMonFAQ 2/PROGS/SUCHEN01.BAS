'**************************************************************
' SUCHEN01.BAS - Suchen in einem Text mit dem INSTR-Befehl
' ============
' Der Anwender gibt einen Namen mit der Anrede "Herr",
' "Frau" oder "Frl." ein. Das Programm sucht im eingegebenen
' Text nach der Anrede, traegt diese in die Variable
' Geschl$ ein und zeigt sie an.
'
' (c) 25.5.2003 von Surfer87 (surfer87*web.de)
'**************************************************************
'
DO
CLS
gefunden% = 1
DO
 INPUT "Geben Sie den Namen mit Herr, Frau oder Frl. ein: "; Nm$
LOOP UNTIL LEN(Nm$) >= 3
Nm$ = UCASE$(Nm$) 'in Grossbuchstaben umwandeln
'
'********* Such-Operation
IF INSTR(Nm$, "FRL") > 0 OR INSTR(Nm$, "FRAU") > 0 THEN
  Geschl$ = "W"
ELSEIF INSTR(Nm$, "HERR") > 0 THEN
  Geschl$ = "M"
ELSE
  gefunden% = 0
  PRINT "Es wurde keine gueltige Anrede eingegeben."
  PRINT "Bitte Namen erneut eingeben"
END IF
'
'******** Anzeige des gefundenen Begriffs
IF gefunden% = 1 THEN PRINT "Geschlecht ist "; Geschl$
'
'******** Wiederholen/Beenden-Dialog
PRINT
PRINT "Neue Eingabe...[Beliebige Taste]   Beenden...[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END 'Programmabbruch mit Esc
LOOP

