'***************************************************************************
' WORTZAEL.BAS = Ermittelt wie oft ein Wort in einem Text vorkommt
' ============
' Dieses Q(uick)Basic-Programm fragt vom Anwender zunaechst ein Suchwort
' ab und dann einen laengeren Text. Anschliessend ermittelt das Programm.
' wie oft das Suchwort in dem Text vorkommt und zeigt dies an. Zur
' Textsuche wird der ISTR-Befehl verwendet.
'
' (c) Thomas Antoni, 25.3.2005
'**************************************************************************
CLS
'------ Suchwort und Text eingeben
PRINT "Ermittlung wie oft ein Suchwort in einem Text vorkommt"
PRINT "------------------------------------------------------"
PRINT
INPUT "Gib ein Suchwort ein : ", Wort$
PRINT
PRINT "Gib einen mehrzeiligen Text ein. Schliesse die Eingabe am Zeilenende"
PRINT "durch zweimaliges Betaetigen der Eingabetaste ab :"
PRINT
DO
INPUT "", T$                 'Eine Zeile eingeben
Text$ = Text$ + " " + T$
LOOP UNTIL T$ = ""           'Eingabe bei Leerzeile beenden
'
'------ Suchwort im Text suchen
Anzahl% = 0        'Anzahl der Fundstellen vorbesetzen
Textzeiger% = 1    'Textzeiger auf den ersten Buchstaben setzen
'
DO
Fundstelle% = INSTR(Textzeiger%, Text$, Wort$)
IF Fundstelle% > 0 THEN
  Anzahl% = Anzahl% + 1
  Textzeiger% = Fundstelle% + LEN(Wort$)
END IF
LOOP UNTIL Fundstelle% = 0 OR Textzeiger% >= LEN(Text$)
   'Suche beenden, wenn keine (weitere) Fundstelle
   'oder Text bereits fertig durchsucht
'
'------ Anzahl der Fundstellen anzeigen
PRINT "Das Suchwort kommt im Text"; Anzahl%; "mal vor"
SLEEP
END

