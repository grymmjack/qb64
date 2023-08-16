'*************************************************************************
' KALWOCHE.BAS = Berechnung der aktuellen Kalenderwoche KW1...KW52
' ============
' Dieses Q(uick)Basic-Programm ermittelt die zum aktuellen Datum
' gehoerende Kalenderwoche und Zeigt sie an.
'
' (c) Ch@rly ( karl.pircher*gmx.net ), 12.9.2003
'************************************************************************
'
DECLARE FUNCTION Tage! (Datum AS STRING, Par%)
DECLARE FUNCTION KalenderWoche% (Datum AS STRING, mode AS INTEGER)
'
CLS
PRINT KalenderWoche(DATE$, 0)

DEFINT A-Z
FUNCTION KalenderWoche (Datum AS STRING, mode AS INTEGER)
'
' Berechnung der Kalenderwoche
'
' Version 2.01 29/3/2001 by PeKa Soft Autor : Pircher Karl
'
' Parameter:
' datum$ = Zu berechnedes Datum in der Form MM-TT-JJJJ
' mode = 0 : Erechnet die Kalenderwoche
' 1 : Erechnet den Tag der Woche
'
' Rueckgabe
' mode 0 : Kalenderwoche
' mode 1 : Tage der Woche. 0 = Sonntag, 1 = Montag, ... 6 = Samstag
' Bei Fehler Wert -1
'
' Beschreibung : Die Kalenderwoche wird wie folgt berechnet.
' Die erste Woche im Jahr, welche 4 Tage enthält,
' wird als Kalenderwoche 1 definiert.
' Die Woche beginnt immer mit dem Montag
'
' A C H T U N G
' Die Routine benoetigt zum Funktionieren die Routine TAGE
'
'
'------------------------------------------------Dimensionierungen
DIM tmp AS STRING
DIM aa AS STRING
DIM a AS LONG
DIM b AS LONG
'
'------------------------------------------------Tage seit 1.1.1900
tmp = Datum
a = Tage(tmp, 0)
IF a <> 0 THEN
IF mode = 0 THEN
aa = "01-01-" + RIGHT$(Datum, 4)
a = Tage(aa, 1)
b = (a + 6) MOD 7 ' b = Wochentag
tmp = Datum
a = Tage(tmp, 0) ' a = vergangene Tage im Jahr
a = INT((a + b - 2) / 7) + 1
IF b > 4 THEN ' Wenn größer 4 (Donnerstag)
a = a - 1 ' dann hat die Woche ab 1. Januar
END IF ' weniger als 4 Tage,
IF a = 0 THEN ' Wenn Woche 0 dann
a = 53 ' Woche 53
END IF
KalenderWoche = a
ELSEIF mode = 1 THEN
tmp = Datum
a = Tage(tmp, 1)
a = (a + 6) MOD 7 ' Bezugspunkt 1.1.1900
KalenderWoche = a
ELSE
KalenderWoche = -1
END IF
ELSE
KalenderWoche = -1
END IF
'
END FUNCTION

FUNCTION Tage! (Datum AS STRING, Par)
'
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
'

'--------------------------------------Dimensionierungen
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

'--------------------------------------Variablen
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

'--------------------------------------Datum abpruefen
aa = Datum
bb = MID$(aa, 7, 4)
Jahr = VAL(bb)
Jahr = Jahr - 1900
a = Jahr MOD 4 ' Schaltjahr ???
IF a = 0 THEN
monate(2) = 29
END IF
bb = LEFT$(aa, 2)
cc = MID$(aa, 4, 2)
monat = VAL(bb)
tag = VAL(cc)
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
IF Jahr < 0 THEN
fehler = 0
ELSE
IF Par = 1 THEN
IF Jahr <> 0 THEN
b = INT((Jahr - 1) / 4) + 1
END IF
c = Jahr * 365 + b + a
Tage = c
END IF
END IF
IF fehler = 1 THEN
Tage = 0
END IF

END FUNCTION

