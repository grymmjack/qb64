'*************************************************************
' Word2Byt.bas = Die beiden Bytes aus e. 16-Bit-Wort auslesen
' ============
' Dieses QBasic-Programm liest aus einem 16-Bit Wort das
' niederwertige Byte (Low Byte) und das hoeherwertige Byte
'(High Byte) aus.
'
' (c) Thomas Antoni, 12.5.02 - 27.2.04
'*************************************************************
DO
PRINT "Gib eine Zahl bis 65535 ein (0 zum Beenden)"
INPUT dword&
IF dword& = 0 THEN END      'Beenden wenn "0" eingegeben
MSB% = dword& MOD 256       'Low-Byte
LSB% = dword& \ 256         'High-Byte
PRINT "Das High Byte hat den Wert...: "; LSB%
PRINT "Das Low Byte hat den Wert....: "; MSB%
PRINT
LOOP

