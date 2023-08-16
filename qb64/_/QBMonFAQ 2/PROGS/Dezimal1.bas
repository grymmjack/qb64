'****************************************************************************
' DEZIMAL1.BAS =  Zerlegung einer Zahl in ihre Dezimalstellen (mit MOD)
' ============
' Dieses QBasic-Programm zerlegt eine lange Ganzzahl (Typkennzeichen "&")
' in ihre einzelnen Dezimalstellen und zeigt diese an.
' Das Programm verwendet die Modulo-Division "MOD" und die Ganzzahldivision
' "\".
'
' (c) Thomas Antoni, 7.1.2005
'****************************************************************************
CLS
INPUT "Gib die zu zerlegende Zahl an (max 2 Milliarden): ", z&
PRINT "Die Zahl hat folgende Dezimalstellen (von hinten nach vorne):"
DO
  z1& = z& MOD 10  'Modulo-Division, liefert den Rest der Division z/10
  PRINT z1&; " ";
  z& = z& \ 10     'Ganzzahldivision, liefert d.ganzzahligen Anteil von z/10
LOOP UNTIL z& = 0


