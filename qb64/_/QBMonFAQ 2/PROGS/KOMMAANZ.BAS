'************************************************************
' KOMMAANZ.BAS - Zahlenanzeige mit Komma statt Dezimalpunkt
' ============
' (c) Thomas Antoni, 21.10.2002
'************************************************************
DO
CLS
INPUT "Gib eine Zahl mit Dezimalpunkt ein"; z#
s$ = STR$(z#)        'Zahl in String umwandeln
p! = INSTR(s$, ".")  'Position des Dezimalpunkts ermitteln
IF p! > 0 THEN       'Dezimalpunkt vorhanden?
  s$ = LEFT$(s$, p! - 1) + "," + RIGHT$(s$, LEN(s$) - p!)
                     'Punkt durch Komma ersetzen
END IF
PRINT "Die Zahl mit Komma lautet ........."; s$
PRINT
PRINT " Neue Eingabe = <Beliebige Taste>      Beenden = <Esc>"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END
LOOP






