'*************************************************************
' VZANZEIG.BAS = Vorzeichenrichtige Anzeige von Formel-Termen
' ============
' Dieses Programm zeigt am Beispiel der Quadratischen
' Gleichung y = x^2 + px + q , wie man das negative Vorzeichen
' von Formel-Termen (hier P und Q) mit QBasic richtig anzeigt.
'
' (c) Thomas Antoni, 2.6.2003 - 3.6.2003
'*************************************************************
CLS
DO
INPUT "Gib P ein"; P!
INPUT "Gib Q ein"; Q!
IF P! >= 0 THEN VZP$ = "+" ELSE VZP$ = ""   'Vorzeichen von P ermitteln
IF Q! >= 0 THEN VZQ$ = "+" ELSE VZQ$ = ""   'Vozeichen von Q ermitteln
PRINT "Die Gleichung lautet y = x^2 "; VZP$; P!; "* x "; VZQ$; Q!
'
'***** Wiederholen/Beenden-Dialog ****************************
PRINT "Wiederholen...[Beliebige Taste]  Beenden...[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = "" ' Warten auf Tastenbeätigung
IF taste$ = CHR$(27) THEN END'Beenden mit Esc
LOOP