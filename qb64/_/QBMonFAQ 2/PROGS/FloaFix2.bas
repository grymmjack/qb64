'********************************************************
' FloaFix2.bas = Gleitpunktzahl in Festpunktzahl wandeln
' ============
' ... durch Zerlegen der Gleitpunktzahl
'
' (c) sm (stef_0815*web.de),   23.10.2003
'*********************************************************
'
DECLARE FUNCTION Ausgabe$ (a AS DOUBLE)
a# = 1 / 30
PRINT "Aus"; a#; "wird"; Ausgabe(a#)
a# = 17 ^ 25
PRINT "Aus"; a#; "wird"; Ausgabe(a#)
END
'

FUNCTION Ausgabe$ (a AS DOUBLE)
' Funktion zum Ausgeben von Zahlen in exponentialfreier Form
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
t$ = STR$(a)
'
'--- Nach 'E' oder 'D' suchen ---
Posi% = INSTR(t$, "E")
IF Posi% = 0 THEN Posi% = INSTR(t$, "D")
'
'----- Exponentialdarstellung erkannt -----
IF Posi% THEN
'
'--- Exponenten abspeichern ---
  Exponent% = VAL(MID$(t$, Posi% + 1))
'
'--- Zahl abspeichern ---
  IF INSTR(t$, ".") THEN
    Zahl$ = LEFT$(t$, 2) + MID$(t$, 4, Posi% - 4)
  ELSE
    Zahl$ = LEFT$(t$, Posi% - 1)
  END IF
'
'--- Komma nach links verschieben (Exponent negativ) ---
  IF Exponent% < 0 THEN
    Ausgabe$ = LEFT$(Zahl$, 1) + "0." + STRING$(-(Exponent% + 1), "0") + MID$(Zahl$, 2)
'--- Komma nach rechts verschieben (Exponent positiv) ---
  ELSE
    Ausgabe$ = LEFT$(Zahl$, 1) + MID$(Zahl$, 2) + STRING$(Exponent% - LEN(Zahl$) + 2, "0")
  END IF
'
'----- exponentialfreie Darstellung erkannt -----
  ELSE
    Ausgabe$ = t$
END IF
END FUNCTION

