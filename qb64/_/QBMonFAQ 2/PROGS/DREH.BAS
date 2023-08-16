'*********************************************************************
' DREH.BAS - Drehen eines Punktes um einen Symmetriepunkt
' =========
' Der Punkt x,y wird um die Bildschirmmitte (Position 319, 174)
' gedreht und zwar in Schritten von 4 Grad.
'
' Mehr Downloads unter www.laosoft.ch/qbasic-treff
' Dieses Beispiel darf frei kopiert und in deinen Programmen verwendet
' werden.
'
' (c) Urs Langmeier www.laosoft.ch - urs_langmeier*hotmail.com
'     (Modifiziert von Thomas Antoni)
'*********************************************************************
DECLARE SUB Dreh (x!, y!, DpX!, DpY!, Grad!)
SCREEN 9
x = 360                           'Anfangskoordinaten des Punktes
y = 174                           'werden von d.SUB "Dreh" manipuliert
'
DO
PSET (x, y), 15                   'Punkt weiss zeichnen
zeit = TIMER
DO: LOOP UNTIL TIMER > zeit       '0.06 sec warten
PSET (x, y), 12                   'Punkt rot zeichnen
CALL Dreh(x, y, 319, 174, 4)      'Koordinaten um 4 Grad drehen
LOOP UNTIL INKEY$ <> ""           'Beenden mit beliebiger Taste
END

SUB Dreh (x, y, DpX, DpY, Grad)
'----------------------------------------------------------------------
' Dreh - Diese Prozedur dreht x und y um den Drehpunkt DpX, DpY um die
'        Anzahl Grad.
'----------------------------------------------------------------------
'
Drehwinkel = Grad
CONST Pi = 3.141592654#
'
'---- Ermittlung der Seitenlaengen (a, b)
IF DpX > x THEN a = DpX - x ELSE a = x - DpX
IF DpY > y THEN B = DpY - y ELSE B = y - DpY
'
'Ausnahmebehandlung fuer rechte Winkel, welche nicht mit den ATN
'berechnet werden koennen:
IF y = DpY AND x > DpX THEN
 Alfa = 0
        ELSEIF x = DpX AND y < DpY THEN
         Alfa = 90
            ELSEIF y = DpY AND x < DpX THEN
             Alfa = 180
                ELSEIF x = DpX AND y > DpY THEN
                 Alfa = 270
'
ELSE
    'Sonst: ungerader Winkel; Berechnung durch den ATN n”tig:
    'Berechnung des Seitenverheltnisses (Steigung)
        Vh = B / a
    'Umwandlung der Steigung in einen Winkel (*1)
        Alfa = ATN(Vh) * 180 / Pi
    'Winkel veraendern durch die vier gegebenen Geometrischen Richtungen:
    IF x > DpX AND y < DpY THEN
     Alfa = 0 + Alfa
        ELSEIF x < DpX AND y < DpY THEN
         Alfa = 180 - Alfa
            ELSEIF x < DpX AND y > DpY THEN
             Alfa = 180 + Alfa
                ELSEIF x > DpX AND y > DpY THEN
                 Alfa = 360 - Alfa
    END IF
END IF
'
'---- Addieren der Drehsumme zum Winkel
NW = Alfa + Drehwinkel
'
'---- Umwandeln des normalen Winkelsystems in das des Computers:
NW = NW + 90
'IF NW > 360 THEN NW = NW - 360
'
'---- Ermitteln des Radius zur anschliessenden Umwandlung in eine
'---- Koordinate nach dem Satz des Pytagoras:
Radius = (a ^ 2 + B ^ 2) ^ .5
'
'---- Setzen der Argumente x, y auf die ver„nderten Koordinaten
x = DpX + Radius * SIN(NW * Pi / 180)
y = DpY + Radius * COS(NW * Pi / 180)
'
'*1:
'Zur Umrechnung von Grad in das Bogenmaá muá die
'Gradangabe mit Pi/180 multipliziert werden.
'Zur Umrechnung von Bogenmaá in Grad muá das Bogenmaá
'mit 180/Pi multipliziert werden.
END SUB

