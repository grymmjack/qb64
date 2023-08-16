'****************************************************************
' MaTrain2.bas = Mathetrainer fuer die 4 Grundrechenarten
' ============
' Dieses Q(uick)Basic-Programm trainiert die 4 Grundrechenarten
' mit je zwei ganzen Zahlen. Es gelten folgende Zahlenbereiche:
'
' Operation 1.Operand  2.Operand Ergebnis
' ---------+---------+----------+---------
' Addition  1...499    1...499   2...998
' Subtrakt. 1...499    1...499   0...498  (2.Operand < 1.Operand)
' Multipl.  1...32     1...31    1...991
' Division  1...991    1...31    1...32
'
' Die Zahlenbereiche sind so ausgelegt, dass man sich immer im
' Bereich 1...1000 bewegt. Das Ergebnis ist ebenfalls eine
' ganze Zahl.
'
' Nach jeder Aufgabe wird eine Erfolgsstatistik angezeigt sowie
' ein "Wiederholen/Beenden"-Dialog.
'
' (c) Thomas Antoni, 03.07.2005
'****************************************************************
'
DO
CLS
'
'------ Zufallszahlen erzeugen (Operation + Operanden)
RANDOMIZE TIMER           'Zufallsgenerator initialisieren
op% = INT(RND * 4) + 1    'Rechnoperation zwischen 1 und 4
z1% = INT(RND * 499) + 1  '1. Zufallszahl zwischen 1 und 499
z2% = INT(RND * 499) + 1  '2. Zufallszahl zwischen 1 und 499
z3% = INT(RND * 32) + 1   '3. Zufallszahl zwischen 1 und 32
z4% = INT(RND * 31) + 1   '4. Zufallszahl zwischen 1 und 31
'
'------ Rechenoperation bearbeiten
SELECT CASE op%
  CASE 1
    op$ = " + "
    erg% = z1% + z2%
  CASE 2
    op$ = " - "
    IF z2% > z1% THEN SWAP z1%, z2%   'bei negativem Ergebnis
                     '... Operanden tauschen -->
    erg% = z1% - z2% '--> Ergebnis immer positiv
  CASE 3
    op$ = " x "
    z1% = z3%
    z2% = z4%
    erg% = z1% * z2%
  CASE 4
    op$ = " : "
    z1% = z3% * z4%  'Es wird die Division ...
    z2% = z4%        '... (z3% * z4%) / z4% durchgefuehrt
    erg% = z3%
END SELECT
'
'------ Ergebnis abfragen und pruefen
anzahl% = anzahl% + 1
PRINT "Wieviel ist"; z1%; op$; z2%; " = ";
INPUT eing%
PRINT
'
IF eing% = erg% THEN
  PRINT "RICHTIG!"
  anzahlrichtig% = anzahlrichtig% + 1
ELSE
  PRINT "FALSCH!"
  PRINT "Das Ergebnis lautet "; erg%
END IF
'
'------ Wiederholen / Beenden-Dialog
PRINT
PRINT anzahl%; " Aufgaben gerechnet, davon "
PRINT anzahlrichtig%; " richtig geloest"
PRINT
PRINT "Neue Aufgabe...[beliebige Taste]_____Beenden...[Esc]"
PRINT
DO: t$ = INKEY$: LOOP UNTIL t$ <> ""  'Warten auf Tastendruck
LOOP UNTIL t$ = CHR$(27)              'Programmende bei Esc
END

