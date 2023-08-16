'*****************************************************************************
' LANGRECH.BAS = Taschenrechner fuer riesenlange Zahlen
' ============
' Dieses QBasic-Programm realisiert einen Taschenrechner fuer die 4 Grund-
' rechenarten, der die normalen Zahlenbereichsgrenzen der QBasic-Datentypen
' sprengt. Alle Operanden und Ergebnisse werden als positive Ganzzahlen
' dargestellt.
'
' Die Routinen arbeiten aehnlich, wie man schriftlich mit Bleistift und
' Papier rechnet, also stellenweise. Die Riesenzahlen liegen als
' Textstings vor, wie bei fast allen anderen vergleichbaren Programmen.
'
' Bei der Addition und Subtraktion können beliebig lange Zahlen eingegeben
' werden. Bei Multiplikationen und Divisionen ist ein Faktor bzw. der
' Divisor (Nenner) eine Ganzzahl bis maximal 200 Millionen.
'
' (c) Thomas Antoni, 19.2.2005 - 20.2.2005  --  www.qbasic.de
'       nach Programmideen von H.J.Sacht
'***************************************************************************
'
DECLARE SUB Addition ()
DECLARE SUB Subtraktion ()
DECLARE SUB Multiplikation ()
DECLARE SUB Division ()
'
CLS
DO
'****** Startmenue
PRINT
PRINT "Welche Operation willst Du durchfuehren?"
PRINT "   1   = Addition"
PRINT "   2   = Subtraktion"
PRINT "   3   = Multiplikation"
PRINT "   4   = Division"
PRINT "   Esc = Programm beenden"
PRINT "Waehle die gewuenschte Operation (1...4 oder Esc) : ";
LOCATE , , 1          'Cursor einschalten
taste$ = INPUT$(1)    'Warten auf beliebige Tastenbetaetigung
LOCATE , , 0          'Cursor ausschalten
CLS : PRINT
'
'***** zur gewuenschten Operation springen
SELECT CASE taste$
  CASE "1": CALL Addition
  CASE "2": CALL Subtraktion
  CASE "3": CALL Multiplikation
  CASE "4": CALL Division
  CASE CHR$(27): END  'Beenden bei Esc-Taste
END SELECT
LOOP

SUB Addition
'***************************************************************************
' Addition
' --------
' Diese Subroutine addiert zwei beliebig lange positive Ganzzahlen. Die
' einzelnen Stellen der Zahlen-Zeichenketten werden in die numerischen
' Felder A(x) und B(x) eingetragen. In den Feldern stehen die
' niederwertigsten Stellen jeweils im 1. Feldelement. Um einen Übertrag
' erfassen zu koennen, wurden die Felder um ein Element grösser
' dimensioniert, als es der Stellenzahl der Zahlen entspricht.
' Das Rechnen und Zusammensetzen des Ergebnisses erfolgt in der letzten
' FOR...NEXT-Schleife stellenweise. Die Schleife laeuft einmal mehr, als
' die groessere Zahl Stellen hat.
' Ein Uebertrag entsteht nur, wenn das Additionsergebnis in einer Stelle
' zweistellig ist. Durch den INT-befehl wird die zweite Stelle
' abgeschnitten und in der Zeile darunter das Stellenadditionsergebnis
' um den Uebertrag vermindert. Im Ausgabestring wird jedes neue
' Stellenergebnis vor die schon ermittelten Ergebniszahlen gesetzt.
'***************************************************************************
DEFINT A-Z
PRINT "A D D I T I O N"
PRINT "---------------"
INPUT "Gib die 1. Zahl ein: Z1 = ", A$
INPUT "Gib die 2. Zahl ein: Z2 = ", B$
LA = LEN(A$)
LB = LEN(B$)
IF LA > LB THEN L = LA ELSE L = LB
DIM A(L + 1), B(L + 1)
'
FOR K = 1 TO LA
  A(K) = VAL(MID$(A$, LA - K + 1, 1))
NEXT
'
FOR K = 1 TO LB
  B(K) = VAL(MID$(B$, LB - K + 1, 1))
NEXT
'
U = 0: E$ = ""                         'Uebertrag u.Ergebnis vorbesetzen
FOR K = 1 TO L + 1
  Z = A(K) + B(K) + U
  U = INT(Z / 10)                      'Uebertrag
  Z = Z - U * 10
  E$ = RIGHT$(STR$(Z), 1) + E$
NEXT
'
PRINT "Ergebnis......: Z1 + Z2 ="; E$
END SUB

SUB Division
'***************************************************************************
' Division
' =========
' Diese Subroutine dividiert eine beliebig lange positive Ganzzahl durch
' eine lange Ganzzahl zwischen 1 und 200 Millionen. Die lange Ganzzahl
' wird als numerische Variable eingegeben, waehrend der erste Wert (der
' Dividend oder Zaehler) als Zeichenkette hinterlegt und stellenweise in
' das numerische Feld A() eingelesen wird.
' Wie bei der schriftlichen Division wird hier bei der hoechstwertigen
' Stelle des Dividenden (Zaehler) begonnen. Da die Ablage im Feld mit
' der niederwertigsten Stelle begonnen hat, muss die Berechnung in der
' zweiten FOR..NEXT-Schleife das Feld von hinten her bearbeiten. Dies
' geschieht, um alle 4 Subroutinen einheitlich im Aufbau zu halten. Die
' Variable Z& erhaelt hier immer den Stellenwert des Dividenden (Zaehlers)
' zuzueglich des mit 10 multiplizierten Rests der letzten Division.
' Beim Divisionsergebnis in der Variablen H& werden durch die INT-
' Anweisung die Nachkommastellen abgeschnitten und dieses fuer den
' Ausgabestring verwendet. Danach wird noch der Rest fuer den naechsten
' Schleifendurchlauf berechnet
'***************************************************************************
DEFINT A-Z
PRINT "D I V I S I O N"
PRINT "---------------"
INPUT "Gib den Dividenden (Zaehler) ein..........: Z1 = ", A$
INPUT "Gib den Divisor (Nenner) ein (1...200 Mio): Z2 = ", F&
LA = LEN(A$)
DIM A(LA)
'
FOR K = 1 TO LA
  A(K) = VAL(MID$(A$, LA - K + 1, 1))
NEXT
'
R& = 0: E$ = ""                          'Rest u.Ergebnis vorbesetzen
FOR K = LA TO 1 STEP -1
  Z& = A(K) + R& * 10
  H& = INT(Z& / F&)
  E$ = E$ + RIGHT$(STR$(H&), 1)
  R& = INT(Z& - F& * H&)
NEXT
'
PRINT "Ergebnis (ganzzahliger Anteil).......: Z1 \ Z2 = "; E$
PRINT "Rest...............................: Z1 MOD Z2 ="; R&
END SUB

SUB Multiplikation
'***************************************************************************
' Multiplikation
' --------------
' Diese Subroutine multipliziert eine beliebig lange positive Ganzzahl mit
' einer langen Ganzzahl zwischen 1 und 200 Millionen. Die lange Ganzzahl
' wird als numerische Variable eingegeben, waehrend der erste Faktor als
' Zeichenkette hinterlegt und stellenweise in das numerische Feld A()
' eingelesen wird.
' Multipliziert wird dann jedes Feldelement einzeln mit dem zweiten
' Faktor. Dazu wird das Ergebnis der vorherigen Multiplikation wie ein
' Übertrag hinzuaddiert.
'***************************************************************************
DEFINT A-Z
PRINT "M U L T I P L I K A T I O N"
PRINT "---------------------------"
INPUT "Gib die 1. Zahl ein:.............: Z1 = ", A$
INPUT "Gib die 2. Zahl ein (1...200 Mio): Z2 = ", F&
LA = LEN(A$)
LF = LEN(STR$(F&))
DIM A(LA + LF)
'
FOR K = 1 TO LA
  A(K) = VAL(MID$(A$, LA - K + 1, 1))
NEXT
'
U& = 0: E$ = ""                          'Uebertrag u.Ergebnis vorbesetzen
FOR K = 1 TO LA + LF - 1
  Z& = A(K) * F& + U&
  U& = INT(Z& / 10)
  E$ = RIGHT$(STR$(Z&), 1) + E$
NEXT
'
PRINT "Ergebnis....................: Z1 * Z2 = "; E$
END SUB

SUB Subtraktion
'***************************************************************************
' Subtraktion
' --------
' Diese Subroutine subtrahiert zwei beliebig lange positive Ganzzahlen
' voneinander. Die abzuziehende Zahl muss kleiner sein als die erste
' Zahl.
' Die einzelnen Stellen der Zahlen-Zeichenketten werden in die numerischen
' Felder A(x) und B(x) eingetragen. In den Feldern stehen die
' niederwertigsten Stellen jeweils im 1. Feldelement. Um einen Übertrag
' erfassen zu koennen, wurden die Felder um ein Element grösser
' dimensioniert, als es der Stellenzahl der Zahlen entspricht.
' Das Rechnen und Zusammensetzen des Ergebnisses erfolgt in der letzten
' FOR...NEXT-Schleife stellenweise. Die Schleife laeuft einmal mehr, als
' die groessere Zahl Stellen hat. Bei der Subtraktion wird immer 10
' addiert, damit niemals ein negatives Ergebnis erscheinen kann. Ist das
' Ergebnis der Stellensubtraktion dann kleiner als 10, muss von der
' naechsthoeheren Stelle "geborgt", d.h. dort zusaetzlich 1 abgezogen
' werden. Im anderen Fall, wenn kein Borgen notwendig ist, muss das
' Subtraktionsergebnis vor der Ausgabe wieder um 10 vermindert werden.
' Im Ausgabestring wird jedes neue Stellenergebnis vor die schon
' ermittelten Ergebniszahlen gesetzt.
'***************************************************************************
DEFINT K, U, Z
PRINT "S U B T R A K T I O N"
PRINT "---------------------"
INPUT "Gib die 1. Zahl ein...........: Z1 = ", A$
INPUT "Gib die 2. Zahl ein (< 1.Zahl): Z2 = ", B$
LA = LEN(A$)
LB = LEN(B$)
IF LA > LB THEN L = LA ELSE L = LB
DIM A(L + 1), B(L + 1)
'
FOR K = 1 TO LA
  A(K) = VAL(MID$(A$, LA - K + 1, 1))
NEXT
'
FOR K = 1 TO LB
  B(K) = VAL(MID$(B$, LB - K + 1, 1))
NEXT
'
U = 0: E$ = ""                       'Uebertrag u.Ergebnis vorbesetzen
FOR K = 1 TO L + 1
  Z = A(K) - B(K) - U + 10
IF Z < 10 THEN U = 1 ELSE U = 0      'Uebertrag ermitteln
  Z = Z - 10
  E$ = RIGHT$(STR$(Z), 1) + E$
NEXT
'
PRINT "Ergebnis.................: Z1 - Z2 ="; E$
END SUB

