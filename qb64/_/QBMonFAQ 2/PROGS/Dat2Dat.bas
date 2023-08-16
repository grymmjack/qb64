'***************************************************************************
' DAT2DAT.BAS = An die Namen aller Dateien eines Ordners das Datum anhaengen
' ===========
' Dieses Q(uick)Basic-Programm erfragt vom Anwender einen Verzeichnisnamen,
' z.B. "C:\uti" (ohne angehaengtes "\" eingeben!). Mit Hilfe des DIR-
' Befehls wird nun eine Dateiliste dieses Verzeichnisses erstellt und in die
' Datei tmp.dat abgelegt. Nun erstellt das Programm von allen Dateien im
' ausgewaehlten Verzeichnis eine Kopie, bei der im vorderen Bestandteil des
' Dateinamens (vor einem eventuellen Punkt) das aktuelle Datum in Format
' MM-TT-JJJJ angehaengt wird. Hierfuer kommt das COPY-Kommando zum Einsatz.
'
' Zum Aufruf der DOS-Kommandos DIR und COPY wird der Windows-Kommandozeilen-
' Interpreter CMD.EXE verwendet (bei Windows 9x muss man stattdessen
' COMMAND.COM verwenden). Daher werden lange Dateinamen unterstuetzt.
'
' (c) jb, 16.12.2005 (mit Ergaenzungen von Thomas Antoni)
'***************************************************************************
'
CLS
INPUT "Verzeichnis (ohne \): "; Verzeichnis$
'
'------ Das temporaere Verzeichnis suchen
RESTORE TMPDATA
FOR i = 1 TO 5
 READ T$
 IF ENVIRON$(T$) <> "" THEN
  tmppfad$ = ENVIRON$(T$)
  EXIT FOR
 END IF
NEXT i
IF tmppfad$ = "" THEN
 LINE INPUT "Bitte geben Sie ein temporaeres Verzeichnis ein: "; tmppfad$
END IF
'
'------ Dateiliste erstellen in temporaerer Datei tmp.dat
'Alle Dateien auflisten und in TMP.DAT im temporaeren Verzeichnis
'abspeichern:
SHELL "CMD /C DIR " + Verzeichnis$ + "\*.* /B > " + tmppfad$ + "\tmp.dat"
'Erlaeuterung:
'"CMD /C DIR" oeffnet den DOS-Kommadointerpreter CMD.COM, startet das
'DIR-Kommando und schliesst anschliessend CMD.COM wieder
'/B listet die Dateinamen zeilenweise ohne Kopfinformation auf
'
'------ Dateiliste aus tmp.dat auslesen und Dateien mit angehaengtem
'------ Datum mit COPY-Befehl zusaetzlich anlegen
F = FREEFILE
OPEN tmppfad$ + "\tmp.dat" FOR INPUT AS #F
DO UNTIL EOF(F)
 LINE INPUT #F, Datei$
 PunktPos% = INSTR(Datei$, ".")   'Position des Punkts vor der Dateiendung
 IF PunktPos% THEN                'Punkt vorhanden?
  DateiEinzeln$ = LEFT$(Datei$, PunktPos% - 1)
  Endung$ = RIGHT$(Datei$, LEN(Datei$) - PunktPos% + 1)  'Dateiendung+Punkt
  SHELL "CMD /C COPY " + Verzeichnis$ + "\" + Datei$ + " " + Verzeichnis$ + "\" + DateiEinzeln$ + "_" + DATE$ + Endung$
 END IF
LOOP
CLOSE #F
PRINT "Alle Dateien kopiert."
'
'------ Temporaere Datei wieder loeschen
KILL tmppfad$ + "\tmp.dat"
END
'
'----- In Frage kommende Dateinamen temporaerer Dateien
TMPDATA:
DATA "TEMP", "temp", "Temp", "TMP", "tmp"

