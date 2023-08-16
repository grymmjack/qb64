'**************************************************************
' VAR2FILE.BAS = Variable in eine Datei schreiben u.ruecklesen
' ============
' Dieses Q(uick)Basic-Programm demonstriert, wie man ganz
' einfach 2 Variablen Variable1$ und Variable2% in eine
' Datei c:\temp.txt schreibt und wieder rueckliest .
'
' Nach Ablauf des Programms kannst Du Dich mit einem Editor
' vom korrekten Inhalt der Datei ueberzeugen. Loesche diese
' anschließend von Hand (per Programm ginge dies mit
' KILL "c:\tmp.txt" .
'
' Die Verwendung von PRINT statt dem sonst üblichen WRITE
' bewirkt, dass die Variablen nicht in Anfuehrungszeichen
' "..." abgespeichert werden.
'
' (c) Arenil (Aneril*freesurf.ch ) und T.Antoni, 6.6.2003
'**************************************************************
'
'----- Zwei Variablen in die Datei c:\tmp.txt schreiben
Variable1$ = "Hallo ich bin ein Text"
Variable2% = 4711
'
OPEN "c:\tmp.txt" FOR OUTPUT AS #1 'Datei oeffnen
PRINT #1, Variable1$               'in Datei schreiben
PRINT #1, Variable2%
CLOSE #1                           'Datei schliessen
'
'----- Variablen wieder aus Datei lesen und anzeigen
OPEN "c:\tmp.txt" FOR INPUT AS #1 'Datei oeffnen
INPUT #1, Variable3$              'aus Datei lesen
INPUT #1, Variable4%
CLOSE #1                          'Datei schliessen
PRINT Variable3$, Variable4%

