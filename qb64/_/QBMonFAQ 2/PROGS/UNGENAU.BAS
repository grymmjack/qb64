'****************************************************
' UNGENAU.BAS - Beispiel fuer Rundungsfehler bei
' ===========   Gleitpunktverarbeitung
'
' Dieses QBasic-Programm demonstriert die bei Gleit-
' punkt-Arithmetik unvermeidlichen Rundungsfehler.
' Statt des erwarteten ganzzahligen Ergebnisses
' "1.0" wird "0.9999999" ausgegeben.
'
' Eine Verbesserung ist in vielen Faellen durch
' die Verwendung von Doppelt langen Gleitpunkt-
' zahlen (DOUBLE) moeglich; dazu muessen aber auch
' die konstanten Zahlenwerte durch ein nachfolgendes
' "#" zu DOUBLE-Zahlen gemacht werden. Den dadurch
' erzielten Effekt demonstriert die zweite Anzeige.
'
' (c) Thomas Antoni, 29.8.02 - 27.2.04
'****************************************************
a! = 1.3 ^ 3 / (.9 + .4) ^ 3
PRINT "Ergebnis bei SINGLE-Format"; a!
a# = 1.3# ^ 3# / (.9# + .4#) ^ 3#
PRINT "Ergebnis bei DOUBLE-Format"; a#

