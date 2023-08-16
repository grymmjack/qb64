'*********************************************************
' BINOMKO.BAS = Berechnung des Binominalkoeffizienten
' ===========
' Dieses Programm berechnet de Binominalkoeffizienten
' k aus n (manchmal auch "n ueber k" genannt).
'
' In der Wahrscheinlichkeitsrechnung wird der
' Binominalkoeffizient verwendet, um die Anzahl der
' Moeglichkeiten zu ermitteln, k aus insgesamt n unter-
' schiedlichen Elementen zu kombinieren. Dabei wird die
' Reihenfolge nicht beruecksichtigt, und die Elemente
' werden nach dem "Ziehen" nicht zurueckgelegt.
' Beispiel: Beim Lotto "6 aus 49" gibt es 6 aus 49
' Moeglichkeiten, den Lottoschein auszufuellen.
'
' Es wird der Datentyp DOUBLE verwendet (Doppelt lange
' 64-Bit-Gleitpunktzahl). Damit sind Zahlen bis ca.
' 1,8 * 10^308 darstellbar.
'
' Dieser Zahlenbereich ermoeglicht Zahlenbereiche
' fuer k und n bis jeweils 170. Die meisten Taschenrechner
' gehen nur bis maximal 69. Ab n = 60 erhaelt man eine
' Ergebnisanzeige in Exponentialdarstellung.
'
' (c)Marc Antoni, 29.6.2003 - 25.8.2003
'*********************************************************
DECLARE FUNCTION Fak# (m#)
'
CLS
PRINT
PRINT " Berechnung des Binominalkoeffizienten k aus n"
PRINT " ---------------------------------------------"
PRINT
PRINT SPACE$(20); "( n )"
PRINT SPACE$(20); "( k )"
PRINT
DO
INPUT " Gib k ein: ", k#
INPUT " Gib n ein: ", n#
'
biko# = Fak#(n#) / (Fak#(k#) * Fak#(n# - k#))
PRINT " Binominalkoeffizient (k aus n) ="; biko#
'
'*******Wiederholen/Beenden-Dialog
PRINT
PRINT " Wiederholen...[beliebige Taste]   Beenden...[Esc]"
'warten auf Tastenbetaetigung"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END             'Beenden bei Esc
PRINT
LOOP

'
'***** FUNCTION zur Berechnung der Fakultaet aus einer Zahl m
'***** maximal ohne Zahlenüberlauf darstellbar: 170!
FUNCTION Fak# (m#)
fakultaet# = 1
FOR i# = 1 TO m#
  fakultaet# = fakultaet# * i#
NEXT i#
Fak# = fakultaet#
END FUNCTION

