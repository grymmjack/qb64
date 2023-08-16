'*************************************************
' NEWTON.BAS = Wurzelberechnung nach Newton
' ==========
' Dieses QBasic-Programm berechnet die Quadrat-
' wurzel einer Zahl mit der Newton-Iteration ohne
' Verwendung des SQR-Befehls
'
' (c) Thomas Antoni, 23.1.04
'*************************************************
CLS
INPUT "Gib die Zahl ein: a = ", a#
x# = 1  'Anfangswert fuer die Iteration
DO
  y# = x# + ((a# - x# * x#) / (2 * x#))
  IF x# = y# THEN EXIT DO    'keine Aenderg. mehr?
  x# = y#
LOOP
PRINT "Wurzel aus a        = "; x#
PRINT "Tatsaechlicher Wert = "; SQR(a#) 'Kontrolle


