'********************************************************
' ODER.BAS = Veranschaulichung der OR-Funktion
' ========
' Bei QBasic wird die OR-Funktion als bitweise
' "VerODERung" durchgefuehrt.
'
' (c) Thomas Antoni, 14.08.02 -23.2.04
'********************************************************
a% = &H2C00     'Binaerwert 0010 1100 0000 0000
b% = &H53FE     'Binaerwert 0101 0011 1111 1110
c% = a% OR b%   'ODER-Verknuepfung
                'Ergebnis:  0111 1111 1111 1110
PRINT "2C00 OR 53FE = "; HEX$(c%) 'Verknuepfungsergebnis
                'in Hex wandeln ((7FFE_hex)) und anzeigen
SLEEP

