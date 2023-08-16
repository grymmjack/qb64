'*************************************************************************
' EXPOANZ.BAS = Demonstration der Exponentialanzeige bei Gleitpunktzahlen
' ===========
' Dies QBasic-Programm zeigt die Zahlenwerte 10^-20...10^20 jeweils als
' Einfach und Doppelt lange Gleitpunktzahlen an.
'
' (c) Thomas Antoni, 19.2.2005  -- www.qbasic.de
'*************************************************************************
CLS
WIDTH , 50          'VGA-Bildschirm mit 50 Zeilen
PRINT "SINGLE", , "DOUBLE"
PRINT "------", , "------"
FOR i% = -20 TO 20
a! = 10 ^ i%        'Einfach lange Gleitpunktzahl
a# = 10 ^ i%        'Doppelt lange Gleitpunktzahl
PRINT a!, , a#
NEXT

