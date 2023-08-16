'*********************************************************
' BINOMI.BAS = Berechnung des Binominalkoeffizienten
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
' Dieser Zahlenbereich ermoeglicht normalerweise Bereiche
' fuer k und n bis jeweils 170. Die meisten Taschenrechner
' gehen nur bis maximal 69. Ab n = 60 erhaelt man eine
' Ergebnisanzeige in Exponentialdarstellung.
'
' Durch folgenden Trick wurde der Bereich fuer k und n
' deutlich erhoeht:
' Der Bruch (k aus n) = n! / ((n-k)! * k!) wird vor der
' weiteren Berechnung durch den groesseren der beiden
' Nennerfaktoren gekuerzt wird. Dadurch ergibt sich eine
' wesentliche Vergroesserung des Wertebereiches fuer n
' und k eber 170 hinaus. Mit dieser Methode ist z.B.
' (124 aus 250) berechenbar, w„hrend bei der "konventio-
' nellen" Methode schon bei (124 aus 170) ein
' Zahlenueberlauf auftritt.
'
' (c) Marc Antoni, 8.7.2003 - 25.8.2003
'*********************************************************
DECLARE FUNCTION Fak# (m#)
'
ON ERROR GOTO fehler 'Sprung zur Fehler-Routine bei
 'Zahlenueberlauf
anfang:
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
'Fallunterscheidung: n!/(n-k)! * k! erst durch den groesseren
'der beiden Nennerfaktoren (n-k)! bzw. k! kuerzen
IF k# > n# / 2 THEN 'k! > (n-k)! -> gedanklich durch k! kuerzen
  nk# = 1
    FOR i# = k# + 1 TO n#
      nk# = nk# * i#
    NEXT i#
  biko# = nk# / Fak#(n# - k#)
ELSE                'k! <= (n-k)! -> gedanklich durch (n-k! kuerzen
  nk# = 1
    FOR i# = n# - k# + 1 TO n#
      nk# = nk# * i#
    NEXT i#
  biko# = nk# / Fak#(k#)
END IF
PRINT " Binominalkoeffizient (k aus n) ="; biko#
'
'******* Wiederholen/Beenden-Dialog
PRINT
PRINT " Wiederholen...[beliebige Taste]   Beenden...[Esc]"
'warten auf Tastenbetaetigung"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END             'Beenden bei Esc
PRINT
LOOP
END
'
'****** Fehler-Routine (bei Zahlenueberlauf)
fehler:
CLS
LOCATE 12
PRINT "   Zahlenbereich von 10^308 Ueberschritten !!!"
PRINT "   ...weiter mit beliebiger Taste ";
DO: LOOP WHILE INKEY$ = "" 'Warten auf Tastenbetaetigung
RESUME anfang     'Ruecksprung z.Beginn des Hauptprogramms

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

