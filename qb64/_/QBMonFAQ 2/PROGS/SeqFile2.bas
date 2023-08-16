'***********************************************
' SeqFile2.bas = Ein Wort in eine Datei schreiben
' ============   und wieder lesen
'
' Einfaches Lernprogramm zur Demonstration der
' Zugriffs auf eine sequentielle Datei.
' Es wird die Datei "tmp.txt" im Stammverzeichnis
' des Laufwerks C\ angelegt und dort das Wort
' "Hallo" eingetragen.
' Anschliessend wird der Dateiinhalt wieder
' ausgelesen und mit Ergaenzung angezeigt.
'
' (c) Thomas Antoni, 5.11.2002 - 5.3.2004
'***********************************************
OPEN "c:\tmp.txt" FOR OUTPUT AS #1
PRINT #1, "hallo"
CLOSE #1
'
OPEN "c:\tmp.txt" FOR INPUT AS #1
INPUT #1, text$
CLS
PRINT text$ + " Du da!"
CLOSE #1
PRINT
PRINT "Schau Dir mal die Datei c:\tmp.txt mit"
PRINT "einem Editor an und loesche sie dann."
SLEEP
END

