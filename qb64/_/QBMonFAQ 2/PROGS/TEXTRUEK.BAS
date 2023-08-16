'**************************************************************
' TextRuek.bas = Text rueckwaerts anzeigen
' ============
' Dieses QBasic-Programm dreht einen eingegebenen Text um und
' zeigt ihn rueckwaerts an. Wird die Eingabetaste betaetigt,
' ohne einen Text einzugeben, so erfolgt ein Programmabbruch.
'
' (c) Thomas Antoni, 29.4.2004
'**************************************************************
CLS
DO
TextGedreht$ = ""
INPUT "Gib einen Text ein (Eingabetaste zum Beenden): ", Text$
IF Text$ = "" THEN END           'Beenden wenn keine Texteingabe
FOR i% = LEN(Text$) TO 1 STEP -1 'Zeichen von hinten auslesen
  TextGedreht$ = TextGedreht$ + MID$(Text$, i%, 1)
NEXT i%
PRINT "Der gedrehte Text lautet "; TextGedreht$
LOOP

