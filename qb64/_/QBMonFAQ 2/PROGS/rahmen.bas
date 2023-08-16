'*****************************************************************
' RAHMEN.BAS - Zeichnen eines Rahmens aus Textzeichen mit
' ==========   konfigurbarer Groesse und Farben
'                   
' Variables Programm zum Zeichnen eines Rahmens in verschiedenen
' Farben. Anzuwenden in Textmodus Screen 0.
' Die im Kommentar mit ? versehenen Variablen koennen Sie Ihren
' Wuenschen entsprechend anpassen.
'
' (c)  Juergen Schroeder
'*****************************************************************
CLS
Zeile% = 5       ' Beginn des Rahmens ab Zeile    ?
Spalte% = 10     ' Beginn des Rahmens ab Spalte   ?
Breite% = 60     ' Breite des Rahmens             ?
Hoehe% = 3       ' Hoehe des Rahmens              ?
VFarbe% = 14     ' Vordergrundfarbe = gelb        ?
HFarbe% = 0      ' Hintergrundfarbe = schwarz     ?
'
IF Spalte% + Breite% > 79 THEN GOTO FEHLER1
IF Zeile% + Hoehe% > 23 THEN GOTO FEHLER2
'
COLOR VFarbe%, HFarbe%
'
Z1$ = "Ú"   ' linke obere Ecke
Z2$ = "Ä"   ' waagerechter Strich
Z3$ = "¿"   ' rechte obere Ecke
Z4$ = "³"   ' senkrechter Strich
Z5$ = "À"   ' linke untere Ecke
Z6$ = "Ù"   ' rechte untere Ecke
'
'--- Zeichnen des Rahmens ---
LOCATE Zeile%, Spalte%: PRINT Z1$
FOR Zaehler% = 1 TO Breite%
   LOCATE Zeile%, Spalte% + Zaehler%: PRINT Z2$
NEXT Zaehler%
LOCATE Zeile%, Spalte% + Breite% + 1: PRINT Z3$
FOR Zaehler% = 1 TO Hoehe% - 1
   LOCATE Zeile% + Zaehler%, Spalte% + Breite% + 1: PRINT Z4$
NEXT Zaehler%
LOCATE Zeile% + Hoehe%, Spalte% + Breite% + 1: PRINT Z6$
FOR Zaehler% = Breite% TO 1 STEP -1
   LOCATE Zeile% + Hoehe%, Spalte% + Zaehler%: PRINT Z2$
NEXT Zaehler%
LOCATE Zeile% + Hoehe%, Spalte%: PRINT Z5$
FOR Zaehler% = Hoehe% - 1 TO 1 STEP -1
   LOCATE Zeile% + Zaehler%, Spalte%: PRINT Z4$
NEXT Zaehler%
GOTO EOJ
'
FEHLER1:
COLOR 4:
LOCATE 11, 10: PRINT "Fehler-1:":
LOCATE 12, 10: PRINT "Die Breite des Rahmens ist zu lang,":
LOCATE 13, 10: PRINT "bzw. die Startposition (Spalte%) ist falsch":
GOTO EOJ
'
FEHLER2:
COLOR 4:
LOCATE 11, 10: PRINT "Fehler-2:":
LOCATE 12, 10: PRINT "Die Hoehe des Rahmens ist zu lang,":
LOCATE 13, 10: PRINT "bzw. die Startposition (Zeile%) ist falsch":
'
EOJ:
COLOR 7, 0   ' Auf Standardfarben zuruecksetzen
END

