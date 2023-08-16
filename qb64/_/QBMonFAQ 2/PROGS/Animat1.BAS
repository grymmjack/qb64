'*****************************************************************************
' ANIMAT1.BAS - Ein Radfahrer faehrt animiert ueber den Bildschirm
' ===========
' Dieses QBasic-Programm laesst einen Radfahrer butterweich ueber den
' Bildschirm fahren. Es demonstriert die Verwendung der Grafik-PUT/GET-
' Befehle. 
' Es wird ein Fahrrad mit 2 unterschiedlichen Pedalstellungen gezeichnet
' und per GET-Befehl in je einem Bild-Feld abgelegt. Per PUT-Befehl werden
' anschliessend die Bilder an versetzten Stellen des Bildschirms ausgegeben,
' sodass der Eindruck eines ueber den Bildschirm fahrenden Fahrrads entsteht.
'
' Verwendte Befehle: VIEW, GET, PUT
'
' (c) Thomas Antoni, 28.8.05
'     nach einem Programmvorschlag in "Das QBasic 1.1 Buch" von H.-G. Schumann  
'*****************************************************************************
DECLARE SUB VeloZeigen ()

SCREEN 12                  'VGA-Modus 640*480*16
VIEW (20, 200)-(200, 300)  'Bildschirmausschnitt definieren, auf den sich die
                           'Kordinaten der nachfolgenden Zeichenbefehle sowie
                           'der CLS-Befehl bezieht
ebenen% = 4
bits% = 4
breite% = 151
hoehe% = 101

'--- Fl„che berechnen, Platz fuer Bild-Felder reservieren ----------
zeile% = INT((breite% * bits% / ebenen% + 7) / 8)
flaeche% = 4 + hoehe% * ebenen% * zeile%

DIM bild1%(flaeche% \ 2 + 1)
DIM bild2%(flaeche% \ 2 + 1)

'--- Bilder zeichen und in Bild-Feldern abspeichern ----------------
CALL VeloZeigen
GET (1, 1)-(breite%, hoehe%), bild1%
CLS
CALL VeloZeigen
GET (1, 1)-(breite%, hoehe%), bild2%
VIEW

'--- Radfahr-Animation
DO
PRINT "Abbruch mit beliebiger Taste, erfolgt am Bildschirm-Ende"
  FOR x% = 20 TO 480 STEP 10
    PUT (x%, 200), bild1%, PSET
    FOR y% = 1 TO 30000: NEXT y%   'kleine Pause
    PUT (x% + 5, 200), bild2%, PSET
    FOR y% = 1 TO 30000: NEXT y%   'kleine Pause
  NEXT x%
  CLS
  taste$ = INKEY$
LOOP WHILE taste$ = ""

SCREEN 0
CLS
END

SUB VeloZeigen
STATIC pedal% 'Variable soll zwischen 2 Aufrufen gespeichert bleiben

'----------- R„der zeichnen ---------------
CIRCLE (40, 70), 20
CIRCLE (110, 70), 20

'----------- Rahmen zeichnen --------------
LINE (40, 70)-(60, 40) 'Strebe
LINE -(95, 40)         'Oberrohr
LINE -(110, 70)        'Gabel
LINE (40, 70)-(70, 75) 'Strebe
LINE -(60, 35)         'Sitzrohr
LINE (70, 75)-(98, 47) 'Unterrohr

'----------- Sattel + Lenker zeichnen -----
CIRCLE (60, 30), 10, , , , .3     'Sattel = Ellipse mit Hoehe:Breite = 3:10
CIRCLE (102, 37), 8, , 5, 3.5, .6 'Lenker = Ellipsenbogen von 5 bis 3.5 Radian
                                  'im Uhrzeigersinn (oben=0 Grad)
                                  'Hoehe:Breite = 6:10

'----------- Pedale "treten" --------------
IF pedal% = 0 THEN
  LINE (72, 65)-(68, 85)
  CIRCLE (72, 65), 5, , , , .3    'Ellipse, Breite.Hoehe = 10:3
  CIRCLE (68, 85), 5, , , , .3
  pedal% = 1
ELSE
  LINE (60, 70)-(80, 80)
  CIRCLE (60, 70), 5, , , , .3   'Ellipse, Breite.Hoehe = 10:3
  CIRCLE (80, 80), 5, , , , .3
  pedal% = 0

END IF

END SUB

