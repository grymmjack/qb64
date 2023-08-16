'*********************************************************************
' BIN2DEC1.BAS = Zahlenkonvertierung Binär -> Dezimal
' ============
' Binaerzahl in Dezimalzahl wandeln
' (c) NicTheQuick (NicolasG*web.de)
'*********************************************************************
DO
CLS
PRINT "Gib die Binaerzahl ein (max 31 Bits):"
INPUT "Binaer :  ", Binaer$
Dez& = 0
FOR x% = 1 TO LEN(Binaer$)
  Dez& = Dez& + (VAL(MID$(Binaer$, x%, 1)) * 2 ^ (LEN(Binaer$) - x%))
NEXT x%
PRINT "Dezimal: "; Dez&
PRINT " <Wiederholen mit beliebiger Taste, Abbruch mit Esc>"
taste$ = INPUT$(1)  'Eine Taste von der Tastaur einlesen
IF taste$ = CHR$(27) THEN END
LOOP

