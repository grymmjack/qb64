'***************************************************************************
' SHARE.BAS = Demo des SHARED-Befehls zur gemeinsamen Verwendung von
' =========   Variablen in Hauptprogramm und SUB/FUNCTION
'
' (c) Thomas Antoni 13.2.2004
'***************************************************************************
DECLARE SUB Multipl ()
COMMON SHARED a!, b!, c!
INPUT "gib 3 Zahlen ein (durch  Kommas voneinander getrennt) : ", a!, b!, c!
CALL Multipl
SLEEP
'
SUB Multipl
PRINT a * b * c
END SUB