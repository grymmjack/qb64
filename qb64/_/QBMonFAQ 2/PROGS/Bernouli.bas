'***********************************************************
' BERNOULI.BAS - Berechnung der Bernoulliwahrscheinlichkeit
' ============
' Die Wahrscheinlichkeit, bei einer Kette von n Bernoulli-
' Experimenten genau k Treffer zu erzielen, wobei für jedes
' Berenoulli-Experiment in der Kette die
' Trefferwahrscheinlichkeit p beträgt, berechnet sich wie
' folgt:
' B (n; p; k) = (k aus n) * p^k * (1-p)^(n-k)
'
' Dabei ist (k aus n) der Binominalkoeffizent n!/(n-k)! * k!
'
' (c) Marc Antoni, 9.7.2003
'***********************************************************
DECLARE FUNCTION Fak# (m#)
'
DO
COLOR 0, 15 'schwarz auf weiss
CLS
PRINT
PRINT " Berechnung der Benoulliwahrscheinlichkeit B(n; p; k)"
PRINT " ===================================================="
PRINT
INPUT " Gib die Anzahl d. Bernoulli-Experimente ein (max. 170) : n = ", n#
PRINT
INPUT " Gib die Anzahl der zu erzielenden Treffer ein..........: k = ", k#
PRINT
PRINT " Gib die Wahrscheinlichkeit je Treffer ein"
PRINT " ... als Dezimalzahl mit Dezimalpunkt"
PRINT " ... z.B. 0.16666667 fuer p=1/6"
INPUT " ... oder 0.4 fuer p=40%................................: p = ", p#
'
kausn# = Fak#(n#) / (Fak#(k#) * Fak#(n# - k#))
bp# = kausn# * p# ^ k# * (1 - p#) ^ (n# - k#)
PRINT
PRINT
PRINT " Loesung......................B (n; p; k) = "; bp#
'
'***** Wiederholen/Beenden-Dialog
PRINT
PRINT
PRINT
COLOR 14, 1' gelb auf blau
LOCATE , 3
PRINT " Wiederholen...[beliebige Taste]   Beenden...[Esc] "
'warten auf Tastenbetaetigung"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END             'Beenden bei Esc
PRINT
LOOP

'
'***** FUNCTION zur Berechnung der Fakultaet aus einer Zahl m
'***** maximal ohne Zahlenueberlauf darstellbar: 170!
FUNCTION Fak# (m#)
fakultaet# = 1
FOR i# = 1 TO m#
  fakultaet# = fakultaet# * i#
NEXT i#
Fak# = fakultaet#
END FUNCTION

