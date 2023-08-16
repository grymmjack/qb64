'****************************************************
'*
'* WAYFIND.BAS - Wayfinder - Wegfinde-Routine
'* ===========
'* Dieses QBasic-Programm zur Wegfindung verwendet
'* den Dijkstra-Algorithmus. Das Programm verteilt
'* zunaechst nach dem Zufallsprinzip Hindernisse
'* auf dem Bildschirm, die nach dem Zufallsprinzip
'* verteilt und jeweils durch einen Buchstaben "H"
'* gekennzeichnet sind. Das Programm findet immer
'* den kuerzesten Weg vom Start ("S") zum Ziel ("Z")
'* und zeigt diesen durch gruene Sternchen an.
'* Existiert kein Weg, weil dieser komplett durch
'* Hindernisse versperrt ist, so erfolgt eine
'* entsprechende Fehlermeldung.
'*
'* (c) Soeren Dressler (soeren*web.de)
'*
'****************************************************
DECLARE SUB showground ()
DECLARE SUB showpix (p AS INTEGER, Z AS ANY)
' loesche Bildschirm; der Einfachheit halber wird
' der Textbildschirm verwendet
SCREEN 12
' das 2D-Feld wird als 1D-Feld verarbeitet
' d.h. Wert bezeichnet die Position
' y = wert MOD dy
' x = wert / dy
' bzw. Wert = y * dy + x
'
CONST anz = 2211
CONST dy = 28
'
' anzahl der hindernisse
CONST hinder = 1000
'
' Suchliste
DIM SHARED qsuche(0 TO anz) AS INTEGER
' distanzliste
DIM SHARED qdist(0 TO anz) AS INTEGER
' vorg„ngerliste
DIM SHARED qvor(0 TO anz) AS INTEGER
' hindernisliste
DIM SHARED h(0 TO anz) AS INTEGER
'
DO
'
FOR i% = 0 TO anz
        qsuche(i%) = 0
        qdist(i%) = 0
        qvor(i%) = 0
        h(i%) = 0
NEXT
'
' erzeuge Hindernisse
RANDOMIZE TIMER
FOR i% = 1 TO hinder
        h(RND * (anz - 1) + 1) = 1
NEXT
' fuege Wand ein
FOR i% = 0 TO anz
        IF i% MOD dy = 0 THEN h(i%) = 1
        IF i% MOD dy = dy - 1 THEN h(i%) = 1
NEXT
'
' setze Start und Ziel zufaellig
Start% = RND * (anz - 1) + 1
Ziel% = RND * (anz - 1) + 1
'
' falls Hindernisse an diesen Stellen sind
' diese loeschen
h(Start%) = 0
h(Ziel%) = 0
'
'
' Bewegungsmoeglichkeiten
' im 1D Feld
' ri zur Berechnung
' rd entsprechende Distanz
'
DIM ri(8) AS INTEGER
DIM rd(8) AS INTEGER
ri(1) = -1
ri(2) = 1
ri(3) = -dy
ri(4) = dy
ri(5) = -1 - dy
ri(6) = 1 - dy
ri(7) = 1 + dy
ri(8) = -1 + dy
'
rd(1) = 3
rd(2) = 3
rd(3) = 3
rd(4) = 3
rd(5) = 4
rd(6) = 4
rd(7) = 4
rd(8) = 4
'
' Vorbereitung
FOR i% = 0 TO anz
  qdist(i%) = 32000
  qvor(i%) = -1
  IF h(i%) = 0 THEN qsuche(i%) = 1
NEXT
'
' zeige Start , Ziel und Feld
COLOR 4
showpix Start%, "S"
showpix Ziel%, "Z"
COLOR 7
showground
'
ti! = TIMER
'
qsuche(Ziel%) = 0
qdist(Start%) = 0
'
' solange noch Elemente in der Suchliste sind
nichtleer% = 0
DO UNTIL nichtleer%
' 
'
  'suche kleinste Distanz
  kdist% = 32000
  k% = -1
  FOR i% = 0 TO anz
        IF qsuche(i%) <> 0 THEN
                IF kdist% > qdist(i%) THEN
                        kdist% = qdist(i%)
                        k% = i%
                END IF
        END IF
  NEXT
  '
  'fall kein Kleinstes gefunden wurde, existiert keine weiterer Weg
  IF k% = -1 THEN
     EXIT DO
  END IF
  '
  ' loesche k aus der Suchliste
  qsuche(k%) = 0
  '
  ' fuer jeden von k aus erreichbaren Knoten
  FOR i% = 1 TO 8
        v% = k% + ri(i%)
        IF v% <= anz AND v% >= 0 THEN
              IF h(v%) = 0 THEN
                        IF qdist(v%) > qdist(k%) + rd(i%) THEN
                                qdist(v%) = qdist(k%) + rd(i%)
                                qvor(v%) = k%
                                IF v% = Ziel% THEN EXIT DO
                        END IF
              END IF
        END IF
  NEXT
'
  ' sind noch Elemente zum suchen?
  nichtleer% = 1
  FOR i% = 0 TO anz
        IF qsuche(i%) <> 0 THEN nichtleer% = 0
  NEXT
LOOP
'
' zeige gefundenen Pfad an
' rueckwaerts
COLOR 2
c% = Ziel%
DO
c% = qvor(c%)
' im Fehlerfall
  IF c% = -1 THEN
        PRINT "kein Weg"
        EXIT DO
  END IF
'
' angekommen
IF c% = Start% THEN EXIT DO
showpix c%, "*"
'
LOOP
'
ti2! = TIMER
LOCATE 1, 1
PRINT ti2! - ti!
'
SLEEP 3
CLS
LOOP UNTIL INKEY$ <> ""
'
'
SUB showground
FOR i% = 0 TO anz
        'showpix i%, " "
        'hindernis
        IF h(i%) = 1 THEN showpix i%, "H"
NEXT
END SUB
'
SUB showpix (p AS INTEGER, Z AS STRING)
y% = p MOD dy + 1
x% = p \ dy + 1
LOCATE y%, x%
PRINT Z
END SUB

