'*************************************************
' HERON.BAS = Wurzelberechnung nach Heron
' ==========
' Dieses QBasic-Programm berechnet die Quadrat-
' wurzel einer Zahl mit des Heron-Verfahrens
' ohne Verwendung des SQR-Befehls
'
' (c) greenbit, 23.1.04
'*************************************************
CLS
INPUT "Gib die Zahl ein: a = ", n#
a# = 1
b# = n
DO UNTIL STR$(a#) = STR$(b#)
  a# = (a# + b#) / 2#
  b# = n# / a#
LOOP
PRINT "Wurzel aus a        = "; a#
PRINT "Tatsaechlicher Wert = "; SQR(n#) 'Kontrolle

