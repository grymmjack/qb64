'***********************************************************
' DISKCOP1.BAS = Kopieren einer Diskette mit SHELL
' =================================================
' Geetestet unter Windows 95. Fuer andere Windows-Versionen
' gibt es keine Funktionsgarantie, weil einzelne DOS-
' Kommandos wie XCOPY, DELTREE und DEL unterschiedlich
' implementiert sind.
' Unter Windows 2000/XP muss z.B. statt DELTREE der
' Befehl RMDIR /S verwendet werden.
'
' von Thomas Antoni, 5.5.2003 - 14.5.2003
'
'***********************************************************
CLS
PRINT "Lege die zu kopierende Diskette in Laufwerk A: ein"
PRINT "Weiter mit beliebiger Taste"
DO: LOOP WHILE INKEY$ = ""
SHELL "MD c:\diskcop1.tmp"
SHELL "xcopy a:\ c:\diskcop1.tmp /s /v /c /i /f /h /k"
' Gib an der Eingabeaufforderung "HELP XCOPY |MORE" ein, um
' die Bedeutung der Optionsparameter /x zu erfahren
PRINT
PRINT "Lege eine formatierte neue Diskette in Laufwerk A: ein"
PRINT "Weiter mit beliebiger Taste"
DO: LOOP WHILE INKEY$ = ""
SHELL "xcopy c:\diskcop1.tmp a:\ /m /s /v /c /i /f /h /k"
SHELL "C:"
SHELL "\"
PRINT
PRINT "Das Kopieren ist fertig"
PRINT
PRINT "Die folgende Frage bitte mit [j Enter] beantworten,"
PRINT "um die Diskettenkopie auf der Festplatte zu loeschen"
PRINT
SHELL "deltree diskcop1.tmp /y"
' DELTREE loescht einen ganzes Verzeichnis inklusive
' Unterverzeichnissen. Gib an der Eingabeaufforderung
' "HELP DELTREE |more" ein, um dich Åber die Funktionsweise
' von DELTREE zu informieren.
' Bei einigen Windows-Versionen steht DELTREE nicht zur
' Verfuegung und es muss DEL mit entsprechenden Optionen
' verwendet werden. Ueber HELP DEL |MORE erhaeltst Du
' Hilfe zu DEL
' Unter Windows 2000/XP muss statt DELTREE der folgende
' Befehl verwendet werden:
' SHELL "RMDIR diskcop1.tmp /S /Q"
PRINT
PRINT "Programm beenden mit beliebiger Taste"
DO: LOOP WHILE INKEY$ = ""
END





