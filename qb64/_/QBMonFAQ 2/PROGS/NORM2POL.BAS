'****************************************************************************
' NORM2POL.BAS - Komplexe Zahl von der Normal- in die Polarform umwandeln
' ============
' Dieses QBasic-Programm rechnet eine komplexe Zahl, die in der Normalform
'   z = a + b * i
' vorliegt, gemÑss der folgenden Formeln in die Polardarstellung um:
'   |z| = Wurzel aus (a˝ + b˝) ; Betrag von z
'   phi = arctan (b/a)         ; Winkel des Vektors von z gegenueber
'                              ; der positiven Realachse
' arctan ist die Umkehrfunktion des Tangens, auf vielen Taschenrechnern
' ueber (Shift + tan), (Inv + tan) oder (F^-1 + tan) erreichbar. In QBasic
' steht dafÅr die ATN-Funktion zur Verfuegung, die zu einem Tangenswert den
' dazugehoerigen Winkel im Bogenmass liefert.
'
' (c) Thomas Antoni, 10.5.2003 - 21.6.2003
'****************************************************************************
'
CLS
DO
'******* Real- und Imaginaerteil eingeben
INPUT "Gib den Realanteil ein               : ", a
INPUT "Gib den Imaginaeranteil ein (ohne i) : ", b
'
'******* Betrag von z berechnen und anzeigen
PRINT
PRINT "Betrag von z: |z|                   = "; SQR(a ^ 2 + b ^ 2)
'
'******* Winkel phi zur positiven Realachse berechnen und anzeigen
PRINT "Winkel zur positiven Realachse: phi = ";
PRINT ATN(b / a) * 360 / (2 * 3.1416); "¯"
'Der Faktor 360 / 2*Pi sorgt fÅr die Umrechnung vom Bogen ins Gradmass
'
'*******Wiederholen/Beenden-Dialog
PRINT
PRINT "Wiederholen...[Beliebige Taste]   Beenden...[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = "" 'warten auf Tastenbetaetigung
IF taste$ = CHR$(27) THEN END               'beenden mit Esc-Taste
PRINT
LOOP

