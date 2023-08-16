'*******************************************************************
' ZAHL2ZIF.BAS = Ziffern einer Ganzzahl isoliert abspeichern
' ============
' Dieses QBasic-Programm fragt vom Anwender eine doppelt lange
' Ganzzahl ab und wandelt sie in einen Textstring um. Dieser
' Textstring wird nun Zeichen fuer Zeichen zerlegt, um die einzelnen
' Buchstaben und damit die einzelnen Dezimalziffern zu isolieren.
' Die Ziffern werden als Textzeichen in einem Feld abgelegt und
' auf dem Bildschirm zeilenweise angezeigt.
'
' (c) Thomas Antoni, 11.10.2005
'********************************************************************
DIM Ziffern$(10) 'Textfeld fÅr max.10 isolierte Einzelziffern
INPUT "Gib eine Ganzzahl ein (maximal 2 Milliarden): ", Zahl#
Zahltext$ = STR$(Zahl#) 'Zahl in Textstring umwandeln
FOR Stelle% = 1 TO LEN(Zahltext$)
    Ziffern$(Stelle%) = MID$(Zahltext$, Stelle%, 1)
    PRINT Ziffern$(Stelle%)
NEXT Stelle%

