'**********************************************************
' GGTeil.BAS = Berechnung des groessten gemeinsamen Teilers
' ==========
' Nach der Eingabe zweier Zahlen wir deren groesster
' gemeinsamer Teiler nach dem Euklidschen Algorithmus
' berechnet. Dieser Algorithmus arbeitet iterativ
'
' (c) Thomas Antoni, 30.1.2004
' auf Grundlage eines Programms von Stefan Meesters, 1998
'**********************************************************
DECLARE FUNCTION ggT& (a&, b&)
'
DO
CLS
INPUT " gib die erste Zahl ein: a = ", a&
INPUT " gib die zeite Zahl ein: b = ", b&
PRINT
PRINT " Ergebnis: ggT (a,b) = "; ggT&(a&, b&)
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

