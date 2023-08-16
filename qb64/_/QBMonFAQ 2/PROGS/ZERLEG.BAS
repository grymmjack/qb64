'******************************************************************
' ZERLEG.BAS - Zerlegen einer Zahl in die einzelnen Dezimalstellen
' ==========
' Dieses QBasic-Programm zerlegt eine Zahl in die Tausender-,
' Einer- und die Nachkommastellen
'
' (c) Thomas Antoni, 21.10.2002 - 5.3.2004
'******************************************************************
CLS
INPUT "gib eine Zahl mit Dezimalpunkt ein"; z#
PRINT "Tausender-Stellen......."; INT(z# \ 1000)
PRINT "Einerstellen............"; INT(z#) - (INT(z# \ 1000) * 1000)
PRINT "Zwei Nachkommastellen..."; INT(z# * 100 - INT(z#) * 100)
SLEEP


