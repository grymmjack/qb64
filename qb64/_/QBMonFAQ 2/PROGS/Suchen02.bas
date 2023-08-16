'*******************************************************
' SUCHEN02.BAS - Textsuche in einem Woerterbuch
' ============
' Dieses Programm demonstriert, wie man Textpassagen
' in einer als Textdatei aufgebauten Datenbank suchen
' kann.
'
' Es handelt sich um ein kleines Woerterbuchprogramm,
' mit dessen Hilfe man die englische Uebersetzung
'
' Nach Eingabe des deutschen Wortes wird die Text-Datei
' XXX.TXT nach diesem Wort durchsucht. Wird das Wort
' nicht gefunden, kann der Anwender die Uebersetzung
' dafuer eingeben und so das neue Wortpaar der
' Woerterbuchdatei hinzufuegen.
'
' (c) 27.5.2002, Frank the Man
'      (frank*headarrangement.com)
'*******************************************************
CLS
DO
INPUT "Bitte geben Sie das deutsche Wort ein: ", Eingabe$
Eingabe$ = LCASE$(Eingabe$)
'
'****** Woerterbuchdatei anlegen falls erforderlich
'****** und zum Lesen oeffnen
TEXTDATEI$ = "xxx.txt"
OPEN TEXTDATEI$ FOR APPEND AS #1
'Datei anlegen falls sie noch nicht existiert
CLOSE #1
OPEN TEXTDATEI$ FOR INPUT AS #1
'
'******* Suchvorgang
gefunden% = 0
DO WHILE NOT EOF(1) 'Suchen bis Dateieende
INPUT #1, Deutsch$, englisch$
'Datensatz einlesen bestehend aus 2 Feldern
IF LCASE$(Deutsch$) = Eingabe$ THEN
  PRINT "Die Uebersetzung lautet: "; englisch$
  gefunden% = 1
  CLOSE #1
  EXIT DO 'Suche abbrechen, wenn Wort gefunden
END IF
LOOP
'
'***** Neuaufnahme des Wortes falls nicht gefunden
IF gefunden% = 0 THEN
  PRINT "Das Wort konnte nicht gefunden werden."
  INPUT "Moechten Sie das neue Wort im Woerterbuch aufnehmen ? (J/N) ", egal$
  IF UCASE$(egal$) = "J" THEN GOSUB WORTHINZUFUEGEN:
END IF
'
'***** Wiederholen oder beenden
PRINT
PRINT "Neue Wortsuche...[beliebige Taste]  Beenden...[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END
PRINT
LOOP
'
'***** Lokale SUB zur Neuaufnahme eines Wortes
WORTHINZUFUEGEN:
PRINT "Wie lautet die korrekte Uebersetzung des Wortes "; Eingabe$ + " ?"
INPUT "Gib die englische Uebersetzung ein: "; WORTENGLISCH$
WORTENGLISCH$ = LCASE$(WORTENGLISCH$)
CLOSE #1
OPEN TEXTDATEI$ FOR APPEND AS #1
PRINT #1, Eingabe$ + ",", WORTENGLISCH$,
PRINT #1, ""
CLOSE #1
RETURN

