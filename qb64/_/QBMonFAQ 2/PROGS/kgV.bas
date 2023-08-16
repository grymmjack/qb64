'**********************************************************
' kgV.BAS = Berechnung des kleinsten gemeinsamen Vielfachen
' ==========
' Nach der Eingabe der beiden Zahlen a und b wird deren
' kleinstes gemeinsames Vielfaches kgV(a,b) gemaess der
' Gleichung
'   kgV(a,b) = a*b / ggT(a,b)
' berechnet.Der groesste gemeinsame Teiler ggT(a,b) wird
' in der FUNCTION ggT& nach dem Euklidschen Algorithmus
' ermittelt. Dieser Algorithmus arbeitet iterativ
'
' (c) Thomas Antoni, 30.1.2004
'**********************************************************
DECLARE FUNCTION ggT& (a&, b&)
'
DO
CLS
INPUT " gib die erste Zahl ein: a = ", a&
INPUT " gib die zeite Zahl ein: b = ", b&
PRINT
PRINT " Ergebnis: kgV (a,b) = "; a& * b& / ggT&(a&, b&)
PRINT
PRINT " ...Wiederholen mit beliebiger Taste...Ende mit Esc"
t$ = INPUT$(1)           '1 Zeichen von Tastatur lesen
LOOP UNTIL t$ = CHR$(27) 'Abbruch mit Exc-Taste

'
FUNCTION ggT& (a&, b&)
'Euklidscher Algorithmus
IF b& = 0 THEN
  ggT& = a&
ELSE ggT& = ggT&(b&, a& MOD b&)
END IF
END FUNCTION

