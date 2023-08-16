'************************************************
' DATEI.BAS = Dateibearbeitung mit QBasic
' =========
' Dieses Programm demonstriert, wie man einen
' kleinen Text in die Datei c:\tmp.txt
' hineinschreibt und wieder ausliest. Diese
' Datei muss nach Beendigung des Programms
' von Hand geloescht werden.
'
' (c) Thomas Antoni, 4.11.2003
'************************************************
'
'-- Datei schreiben --
CLS
OPEN "c:\tmp.txt" FOR OUTPUT AS #1
INPUT "Gib Deinen Namen ein "; name$
WRITE #1, name$
CLOSE #1
'
'--- Datei lesen ---
OPEN "c:\tmp.txt" FOR INPUT AS #1
INPUT #1, t$
CLOSE #1
PRINT
PRINT "Du hast Folgendes eingegeben: "; t$
SLEEP
END