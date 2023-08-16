'*********************************************************
' FloatFix.bas = Gleitpunkt- in Festpunktwert wandeln
' ============
' ... mit PRINT USING
' Dieses QBasic-Programm wandelt eine SINGLE- oder DOUBLE-
' Gleitpunktzahl in eine Festpunktzahl mit 6 Vor- und 18
' Nachkommastellen um. Die Festpunktzahl wird id der
' Stringvariablen t$ hinterlegt
'
' (c) Thomas Antoni, 22.10.2003
'*********************************************************
a# = 1 / 30
'--- Wert in Datei schreiben ---
OPEN "c:\tmp.txt" FOR OUTPUT AS #1
PRINT #1, USING "######.#################"; a#;
CLOSE #1
'
'--- Wert aus Datei lesen ---
OPEN "c:\tmp.txt" FOR INPUT AS #1
INPUT #1, t$ 'in Festpunktdarstellung umgewandelter Wert
CLOSE #1
PRINT
KILL "c:\tmp.txt"
PRINT "Der umgewandelte Zahlenwert lautet  "; t$
SLEEP
END

