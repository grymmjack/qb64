'**********************************************************************
' DAT2TAG.BAS = Tage und Datum ineinander umrechnen
' ===========
'
' Dieses QBasic-Programm beinhaltet 2 Funktionen zum Umrechnen eines
' Kalenderdatums in die Anzahl von Tagen seit 1.1.1990 und umgekehrt
' - TageDatum$ - Rechnet die Anzahl Tage seit 1990 in das Datum um
' - Tage!      - Berechnet aus einem Datum die Anzahl der Tage seit
'                1.1.1990
'
' Das Hauptprogramm demonstriert diese beiden FUNCTIONs, indem es
' das Datum berechnet, das in 10 Tagen vorliegen wird. Dazu wird mit
' Tage! die Anzahl der seit 1.1.1990 bis heute vergangenen Tage
' ermittelt. Dazu wird dann 10 hinzuaddiert und mit TageDatum$ das
' zugehoerige Datum berechnet und angezeigt. Das Monatsende und
' Schaltjahre werden dabei berÅcksichtigt.
'
' (c) Ch@rly ( karl.pircher*gmx.net ). 11.9.2003
'**********************************************************************
'
DECLARE FUNCTION TageDatum$ (day&, Par AS INTEGER)
DECLARE FUNCTION Tage! (Datum AS STRING, Par%)
DIM t AS LONG
'
t = Tage!(DATE$, 1)' Anzahl der vergangene Tage seit 1.1.1900
t = t + 10 ' 10 Tage zum heutigen Datum dazuzÑhlen
CLS
PRINT TageDatum$(t, 0)

DEFINT A-Z
'
'
FUNCTION Tage! (Datum AS STRING, Par)
'----------------------------------------------------------------------
' Berechnen Anzahl vergangener Tage seit 01-01-1900
' oder des laufenden Jahres
'
' Version 2.0 12/1/1999 by PeKa Soft Autor : Pircher Karl
'
' datum$ : Datum in der Form MM-TT-JJJJ
' Die Trennzeichen werden nicht beachtet
' Schaltjahre werden beruecksichtigt
' par = 0 Berechnung der Tage im laufenden Jahr
' = 1 Berechnung der Tage seit 01-01-1900
' Rueckgabe: Anzahl der vergangenen Tage
' 0 bei Fehler
'----------------------------------------------------------------------
'
'------ Dimensionierungen
DIM monate(12)
DIM a AS LONG
DIM b AS LONG
DIM c AS LONG
DIM aa AS STRING
DIM bb AS STRING
DIM cc AS STRING
DIM Jahr AS LONG
DIM monat AS INTEGER
DIM tag AS INTEGER
DIM i AS INTEGER
'
'------ Variablen
fehler = 0
monate(1) = 31
monate(2) = 28
monate(3) = 31
monate(4) = 30
monate(5) = 31
monate(6) = 30
monate(7) = 31
monate(8) = 31
monate(9) = 30
monate(10) = 31
monate(11) = 30
monate(12) = 31
'
'------ Datum abpruefen
aa = Datum
bb = MID$(aa, 7, 4)
Jahr = VAL(bb)
Jahr = Jahr - 1900
a = Jahr MOD 4 ' Schaltjahr ???
IF a = 0 THEN monate(2) = 29
bb = LEFT$(aa, 2)
cc = MID$(aa, 4, 2)
monat = VAL(bb)
tag = VAL(cc)
'
IF monat < 1 OR monat > 12 THEN
  fehler = 1
ELSE
  IF tag < 1 OR tag > monate(monat) THEN
    fehler = 1
  ELSE
    a = 0
    FOR i = 1 TO monat - 1
      a = a + monate(i)
    NEXT
    a = a + tag
    Tage = a
  END IF
END IF
'
IF Jahr < 0 THEN
  fehler = 0
ELSE
  IF Par = 1 THEN
    IF Jahr <> 0 THEN b = INT((Jahr - 1) / 4) + 1
    c = Jahr * 365 + b + a
    Tage = c
  END IF
END IF
'
IF fehler = 1 THEN Tage = 0
END FUNCTION

DEFLNG A-Z
'
'
FUNCTION TageDatum$ (day, Par AS INTEGER)
'----------------------------------------------------------------------
' Berechnen des Datums anhand der Anzahl vergangener Tage
' seit 1 - 1 - 1900
'
' Version 1.01 vom 26/11/2001
'
' Tage : Anzahl der vergangenen Tage seit 1-1-1990
' Die Trennzeichen werden nicht beachtet
' Schaltjahre werden beruecksichtigt
' par : Momentan nicht benutzt
' Rueckgabe: Datum in der Form MM-TT-JJJJ
' 0 bei Fehler
'
' énderung von Version 1.0 auf Version 1.01:
' Alle Variablen auf Long umgestellt.
'----------------------------------------------------------------------
'
'------ Variablen
DIM monat(12)
fehler = 0
monat(1) = 31
monat(2) = 28
monat(3) = 31
monat(4) = 30
monat(5) = 31
monat(6) = 30
monat(7) = 31
monat(8) = 31
monat(9) = 30
monat(10) = 31
monat(11) = 30
monat(12) = 31
'
'----- Jahr berechnen
j = INT((day - 1) / 365.25) + 1900
Jahr$ = STR$(j)
Jahr$ = RIGHT$(Jahr$, LEN(Jahr$) - 1)
Jahr$ = RIGHT$("0000" + Jahr$, 4)
'
'------ Schaltjahr ???
a = j MOD 4
IF a = 0 THEN
monat(2) = 29
END IF
'
'------ Monat
a = INT((j - 1900) * 365.25)
t = day - a
IF monat(2) = 28 THEN t = t - 1
m = 1
'
FOR i = 1 TO 12
  IF t > monat(i) THEN
    t = t - monat(i)
    m = m + 1
  ELSE
    i = 12
  END IF
NEXT
'
tag$ = STR$(t)
tag$ = RIGHT$(tag$, LEN(tag$) - 1)
tag$ = RIGHT$("00" + tag$, 2)
mon$ = STR$(m)
mon$ = RIGHT$(mon$, LEN(mon$) - 1)
mon$ = RIGHT$("00" + mon$, 2)
'
TageDatum$ = mon$ + "-" + tag$ + "-" + Jahr$
END FUNCTION

