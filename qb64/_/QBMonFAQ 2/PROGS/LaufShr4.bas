'****************************************************************************
' LAUFSHR4.BAS = Laufschrift im Grafikmodus
' ===========
' Dieses Q(uick)BASIC-Programm zeigt eine Laufschrift auf dem Grafik-
' Bildschirm an, die aus mehreren Saetzen (Zeilen) besteht. Nach jedem Satz
' wird eine groessere Pause eingelegt. Die Text-Laufrichtung ist mit den
' Plus/Minus-Tasten umkehrbar. Dieses Programm ist fuer Messe- und
' Schaufenster-Zwecke bestens geeignet.
' Die Anregung zu diesem Programm gab mir das sehr gute Buch "Das grosse
' GW -BASIC Buch" von Heinz-Josef Bomanns.
'
' (c) Thomas Antoni, 11.3.05 - 12.3.05  -  www.qbasic.de - thomas*antonis.de
'****************************************************************************
'
'---- Text und Bildschirm festlegen sowie Bedienhinweise anzeigen
SCREEN 1               'Aufloesung 320x200 Bildpunkte
COLOR 14, 1            'gelber Hintergrund
CLS
X.Max% = 319           'Maximale Koordinaten
Y.Max% = 199
Anzahl.Zeilen% = 3     'Anzahl der auszugebenden Textzeilen bzw. Saetze
DIM T$(Anzahl.Zeilen%) 'Fuer den auszugebenden text
FOR i% = 1 TO Anzahl.Zeilen%
  READ T$(i%)          'Text einlesen
NEXT
LOCATE 5, 5: PRINT "Laufschrift "
LOCATE 7, 7: PRINT "auf dem"
LOCATE 9, 9: PRINT "PC....."
LOCATE 23:
PRINT " [-]...........rueckwaerts"
PRINT " [+]...........vorwaerts"
PRINT " [Esc-Taste]...beenden";
LINE (0, 108)-(X.Max%, 110), 1, BF  'Farbige dicke Linien ober- und ...
LINE (0, 120)-(X.Max%, 122), 1, BF  'unterhalb der Laufschrift-Zeile
'
'---- Text vorwaerts laufen lassen
Vorwaerts% = 1
'
DO
IF Vorwaerts% = 1 THEN
'
  FOR Zeile% = 1 TO Anzahl.Zeilen%
    LOCATE 15, 1: PRINT SPACE$(40);   'Zeile loeschen
    FOR Zeichen% = 1 TO LEN(T$(Zeile%))
      IF Zeichen% < 40 THEN spalte% = Zeichen% ELSE spalte% = 39
                                      'Zeichenposition ermitteln
      LOCATE 15, 40 - spalte%
      PRINT RIGHT$(LEFT$(T$(Zeile%), Zeichen%), 40)
      Zeit = TIMER: DO: LOOP UNTIL TIMER > Zeit + .1  '0,1 sec Pause
      Taste$ = INKEY$
      IF Taste$ = CHR$(27) THEN END
      IF Taste$ = "-" THEN Vorwaerts% = 0: EXIT FOR
    NEXT Zeichen%
    IF Taste$ = "-" THEN EXIT FOR     'beide FOR-Schleifen verlassen
                                      'bei Richtungswechsel
    Zeit = TIMER: DO: LOOP UNTIL TIMER > Zeit + .5
                                      '0,5 sec Pause nach jedem Satz
  NEXT Zeile%
'
'---- Text rueckwaerts laufen lassen
ELSE
'
  FOR Zeile% = Anzahl.Zeilen% TO 1 STEP -1
    LOCATE 15, 1: PRINT SPACE$(40);                   'Zeile loeschen
    FOR Zeichen% = 1 TO LEN(T$(Zeile%))
      LOCATE 15, 1
      PRINT LEFT$(RIGHT$(T$(Zeile%), Zeichen%), 40)
      Zeit = TIMER: DO: LOOP UNTIL TIMER > Zeit + .1  '0,1 sec Pause
      Taste$ = INKEY$
      IF Taste$ = CHR$(27) THEN END
      IF Taste$ = "+" THEN Vorwaerts% = 1: EXIT FOR
    NEXT Zeichen%
    IF Taste$ = "+" THEN EXIT FOR
  NEXT Zeile%
'
END IF
LOOP
'
'----Texte in DATA-Zeilen hinterlegen (fuer leichte Aenderbarkeit)
DATA " Dies ist ein Testtext fuer die Demonstration einer Laufschrift. "
DATA " Dieser Text wird solange ausgegeben, bis Sie die Nase voll haben ... "
DATA " und die Escape-Taste druecken. "

