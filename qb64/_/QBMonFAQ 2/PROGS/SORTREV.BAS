'***********************************************************
' SORTREV.BAS = Zahlen in abfallender Reihenfolge sortieren
' ===========
'
' Dieses QBasic-Programm sortiert ein paar Zahlen in
' Rueckwaerts-Reihenfolge mit dem primitiven Bubblesort-
' Algorithmus unter Verwendung des SWAP-Befehls
'
' (c) ToPo ( Timo_Poppinga*web.de ) , 17.6.2003
'
'**********************************************************
'
CLS
anz = 11        'Anzahl der zu sortieren Zahlen
DIM a(1 TO anz) 'Feld fuer die zu sortierenden Zahlen
'
a(1) = 152
a(2) = 32
a(3) = 695
a(4) = 2
a(5) = 15
a(6) = 986
a(7) = 20
a(8) = 14
a(9) = 365
a(10) = 21
a(11) = 13
'
'anz = 11
'
DO
  t = 0
  FOR b = 1 TO anz - 1
    IF a(b) < a(b + 1) THEN
      'fuer aufsteigende Reihenfolge > statt < verwenden
      SWAP a(b), a(b + 1)
      t = 1
    END IF
  NEXT b
LOOP UNTIL t = 0 OR INKEY$ = CHR$(27)
'
FOR b = 1 TO anz
  PRINT a(b)
NEXT b

