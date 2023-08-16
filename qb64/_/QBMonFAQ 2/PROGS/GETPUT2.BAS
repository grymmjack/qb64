'****************************************************************************
' GETPUT2.BAS - Demo der Modi PSET/PRESET/AND/OR/XOR des Grafik-PUT-Befehls
' ===========
' Bei diesem Q(uick)Basic-Programm wird ein Ein auf dem Bildschirm
' angezeigtes Linienbild mit einem in einem Bildfeld gespeicherten
' Bildschirmausschnitt (Kreisbild) ueberlagert; nach einem Programmvorschlag
' im Buch "Das QBasic 1.1 Buch" von H.-G. Schumann
'
' Zunaechst werden 18 konzentrische Kreise in einen Mittelausschnitt des
' Bildschirms gezeichnet. Dieser Mittelausschnitt wird dann per
' GET ins Feld bit% abgespeichert.
'
' Anschliessend erfolgt 5 mal ein Aufruf der Subroutine ZeigeBild mit den
' unterschiedlichen PUT-Modi (Fortschaltung jeweils mit beliebiger Taste):
' Die SUBroutine l”scht zun„chst den Bildschirm und zeichnet 10 Linien gleich-
' m„ssig verteilt quer ueber den Gesamtbildschirm. Anschlieáend berlagert
' ZeigeBild diesem angezeigten Bildschirminhalt per PUT-Befehl den in bild%
' gespeicherten Mittelausschnitt mit den konzentrischen Kreisen gem„á dem
' aktuellen PUT-Modus:
'
'  - kein PUT ==> es wird nur das Linienbild gezeigt
'  - PSET     ==> Mittelausschnitt geloescht und Kreisbild eingefuegt
'  - PRESET   ==> dito, jedoch Kreisbild invertiert dargestellt
'  - AND      ==> nur gemeinsame Pixel des alten u.neuen Bildes werden
'                 dargestellt
'  - OR       ==> alle Pixel des neuem und des alten Bild werden dargestellt
'  - XOR      ==> dito, jedoch werden gemeinsame Pixel dunkelgetastet
'
' Mit den letzten 3 Modi lassen sich z.B. 'transparente Sprites' darstellen.
'
' Der Name des aktuellen PUT-Modus wird jeweils oben auf dem Bildschirm ange-
' zeigt.
'
' (c) Thomas Antoni, Rosieres, Frankreich, 26.8.99 - 27.8.99
'****************************************************************************
'
DECLARE SUB ZeigeBild (i%)
'
SCREEN 2   '640x200 Grafik, 2 von 16 Farben
CLS
'
'--- Speicherplatz fuer Bildfeld ermitteln ------------
ebenen% = 1   'Farbebenen bei Screen 2
bits% = 1     'Gesamt-Bits pro Pixel bei Screen 2
breite% = 450
hoehe% = 180
laenge& = (4 + hoehe% * ebenen% * INT((breite% * bits% / ebenen% + 7) / 8)) \ 2 + 1
DIM bild%(laenge&)
'
'--- Bild zeichnen u. in Bildfeld abspeichern --------
FOR x% = 10 TO 180 STEP 10
  CIRCLE (320, 90), x%
NEXT x%
'
GET (101, 1)-(100 + breite%, hoehe%), bild%
'
'--- Bild in verschiedenen Modi anzeigen -------------
FOR i% = 0 TO 5
  CALL ZeigeBild((i%))  'Doppelklammer ==> Call by Value, damit i% von der
                        'SUBroutine nicht veraendert werden kann, ansonsten
                        'gibt es eine Fehlfunktion !!!
NEXT i%
'
SCREEN 0
CLS
END

'
SUB ZeigeBild (i%)
SHARED bild%()
'
'--- Unterlage (Linienbild) zeichnen -----
CLS
FOR y% = 10 TO 190 STEP 10
  LINE (10, y%)-(630, y%)
NEXT y%
'
'--- Kreis-Bild auftragen ----------------
SELECT CASE i%
  CASE 1
    PRINT "PSET";
    PUT (100, 10), bild%, PSET
  CASE 2
    PRINT "PRESET";
    PUT (100, 10), bild%, PRESET
  CASE 3
    PRINT "AND";
    PUT (100, 10), bild%, AND
  CASE 4
    PRINT "OR";
    PUT (100, 10), bild%, OR
  CASE 5
    PRINT "XOR";
    PUT (100, 10), bild%, XOR
  CASE ELSE
    PRINT "NULL";
END SELECT
'
PRINT "-Modus.... Weiter mit beliebiger Taste"
DO: LOOP WHILE INKEY$ = ""
'
END SUB

