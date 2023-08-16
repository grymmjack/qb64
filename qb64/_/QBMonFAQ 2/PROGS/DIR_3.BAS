'*********************************************************************
' DIR_3.BAS = Inhalt eines Verzeichnisses auflisten
' =========
' Dieses Q(uick)Basic-Programm listet alle Dateien eines waehlbaren
' Verzeichnisses auf
'
' (c) jb, 16.12.2005 (mit Ergaenzungen von Thomas Antoni)
'**********************************************************************
CLS
INPUT "Verzeichnis (ohne \): "; Verzeichnis$
'
'------ Dateiliste erstellen in temporaerer Datei DIR.TMP
'Alle Dateien auflisten und in DIR.TMP im temporaeren Verzeichnis
'abspeichern:
'Erlaeuterung:
'  - "CMD /C DIR" oeffnet den DOS-Kommadointerpreter CMD.COM, startet
'     das DIR-Kommando und schliesst anschliessend CMD.COM wieder
'  - /B listet die Dateinamen zeilenweise ohne Kopfinformation auf
'  - Bei Windows 9x heisst der Kommandointerpreter nicht CMD.EXE,
'    sondern COMMAND.COM.
'
SHELL "CMD /C DIR " + Verzeichnis$ + "\*.* /B > " + "dir.tmp"
'
'------ Dateiliste aus DIR.TMP auslesen und Dateien mit angehaengtem
'------ Datum mit COPY-Befehl zusaetzlich anlegen
F = FREEFILE
OPEN "dir.tmp" FOR INPUT AS #F
DO UNTIL EOF(F)
 LINE INPUT #F, Datei$
  PRINT Datei$
  LOOP
CLOSE #F
PRINT "Beenden mit beliebiger Taste"
'
'------ Temporaere Datei wieder loeschen
KILL "dir.tmp"
SLEEP
END

