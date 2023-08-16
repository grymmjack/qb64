'****************************************************************
' VZLOSINT.BAS = Vorzeichenlose 16-Bit INTEGER-Zahl erzeugen
' ============
' Dieses QBasic-Programm wandelt eine LONG-Zahl in eine
' vorzeichenlose 16-Bit INTEGER-Zahl um.
'
' Zahlen, die groesser als 2^15 - 1 sind werden als negative
' Zahlen im "Zweierkomplement", aber mit dem korrekten Bitmuster
' dargestellt. Aus + 40000 wird beispielsweise - 25536.
'
' (c) Thomas Antoni, 29.6.02
'===============================================================
DO
INPUT "Gib eine Ganzzahl bis 65536 ein (0 zum Beenden)"; z&
IF z& = 0 THEN END
IF z& > &H7FFF THEN 'Ganzzahl > 2^15 - 1 ?
  z& = -(&H10000 - z&)
END IF
a% = z&
PRINT a%
LOOP

