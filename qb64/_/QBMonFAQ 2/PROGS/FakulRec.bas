'************************************************
' FAKULREC.BAS - Fakultaet n! rekursiv berechnen
' ============
' QBasic-Programm zum Berechnen der Fakultaet n!
' der Zahl n (n!= 1*2*2...*n) . Hierbei wird das
' Prinzip der Rekursion demonstriert: Die
' Funktion ruft sich solange selbst auf bis
' das Ergebnis fertig berechnet ist
'
' Das Programm funktioniert wie folgt:
' - Die Fakultaet von 0 ist eins.
' - Die Fakultaet einer anderen Zahl ist n mal
'   die Fakultaet der naechst kleineren Zahl.
' Oder als Formel formuliert:
' - n! = 1 fuer n = 0
' - n! = n * (n-1)! fuer n <> 0
'
' (c) helium (m.beckah*gmx.de), 20.10.2003
'************************************************
DECLARE FUNCTION fakultaet# (n AS DOUBLE)
CLS
INPUT "n = "; n#
PRINT "n! = "; fakultaet#(n#)

FUNCTION fakultaet# (n#)
IF n# = 0 THEN
  fakultaet# = 1 '0! = 1
ELSE
  fakultaet# = n# * fakultaet#(n# - 1)
END IF
END FUNCTION

