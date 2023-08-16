'************************************************************
' RECURSE.BAS - Eine SUB ruft sich selbst auf ("Rekursion")
' ===========
' Dieses Q(uick)Basic-Programm demonstriert die rekursive
' Technik durch Addition aller Zahlen von 1 bis k%
' in der sich selbst aufrufenden Subroutine "recurse"
'
' (c) Thomas Antoni, 5.3.2004 - 8.2.2006
'************************************************************
'
DECLARE SUB recurse ()
'
COMMON SHARED k%, l%
'In Hauptprogramm UND in der SUB bekannte Variablen
CLS
INPUT "Gib k ein"; k%
CALL recurse
PRINT "Die Summe der Zahlen von 1 bis"; k%; " betraegt"; l%
SLEEP

SUB recurse STATIC
n% = n% + 1
l% = l% + n%
IF n% < k% THEN CALL recurse
END SUB

