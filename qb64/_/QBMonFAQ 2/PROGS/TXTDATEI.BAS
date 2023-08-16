'************************************************************************
' TXTDATEI.BAS = Schreiben von eingegebenem Text in eine Datei
' ============
' Dies QBasic-Programm demonstriert, wie man eine Textpassage in einer
' kleinen Datei abspeichern kann.
' Es fordert den Anwender auf, einen Text einzugeben, der auch
' mehrzeilig sein darf. Dieser Text wird in eine Datei eingetragen.
' Anschliessend liest das Programm den Text aus der Datei zurück und
' zeigt ihn auf dem Bildschirm an.
'************************************************************************
20 :
30 DIM Text$(15) '15 Textzeilen sind genug!
40 :
50 COLOR 7, 0: CLS
60 PRINT "Texteingabe (max 15 Zeilen):"
70 PRINT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
75 PRINT "Bedienungshinweise:"
76 PRINT "- ENTER ........ schaltet zur naechsten Zeile fort"
77 PRINT "- @ + Enter .... beendet die Datei"
80 VIEW PRINT 7 TO 20 'Zeilen 1 bis 6 scrollen nicht!
90 FOR i = 1 TO 15
100 LINE INPUT " > "; Text$(i)
110 IF Text$(i) = "@" THEN GOTO 130 'Ende mit "@"
120 NEXT i
130 a = i 'Anzahl der Zeilen speichern
140 CLS : PRINT "Daten werden gespeichert!"
150 OPEN "TEST.TXT" FOR OUTPUT AS #1
160 : 'Oeffnen einer Datei
170 FOR i = 1 TO a 'Abspeichern von a Testzeilen
180 PRINT #1, Text$(i) 'Daten zur Datei schreiben
190 NEXT i
200 CLOSE 'Datei schliessen
210 :
220 VIEW PRINT: CLS : PRINT "Eintraege in der Datei:"
230 OPEN "TEST.TXT" FOR INPUT AS #1 'Öffnen der Datei zum Einlesen
240 FOR i = 1 TO a 'Laden der abgespeicherten a Testzeilen
250 LINE INPUT #1, Text$ 'Einlesen der Daten zeilenweise
260 PRINT Text$ 'Daten ausgeben
270 NEXT i
280 CLOSE
290 SLEEP
300 END

