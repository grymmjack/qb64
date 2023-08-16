'*********************************************
' DEC2HEX1.BAS = Dezimal-Hexadezimal-Wandlung
' (c) Thomas Antoni, 25.6.02
'*********************************************
DO
  INPUT "Gib eine Dezimalzahl ein"; dez&
  X$=HEX$(dez&)
  PRINT x$
LOOP
