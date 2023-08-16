'****************************************************************************
' AUTORENN.BAS = Ein einfaches Autorenn-Spiel im Textmodus
' ============
' (c) Thomas Antoni, 3.3.2005  -  www.qbasic.de
'     nach einer Programmidee von A. Matthias, gefunden im
'     "Franzis-Arbeitsbuch GW-BASIC / BASIC A"
'****************************************************************************
'
'------ Spiel vorbereiten
COLOR 12, 1                     'rot auf blau
CLS
PRINT
PRINT " Steuere Dein Auto (*) mit den Cursortasten"
PRINT "   (keine Dauerbetaetigung der Tasten)"
DO
PRINT
PRINT " Start mit Eingabetaste......Abbruch mit Esc"
DO                              'Warten bis Eingabe oder Esc betaetigt
 T$ = INKEY$                    'Taste einlesen
 IF T$ = CHR$(27) THEN END      'Abbruch mit ESC
 IF T$ = CHR$(13) THEN EXIT DO  'Warteschleife verlassen bei Eingabetaste
LOOP
S% = 30'Anfangsposition der Strasse
B% = 14'Endposition der Strasse
P% = 37'Anfangsposition des Autos
RANDOMIZE TIMER           'Zufallsgenerator starten
'
'----- Auto und Strassenraender anzeigen
DO
PRINT TAB(S%); "|"; TAB(P%); "*"; TAB(S% + B%); "|"
                           'Ausgabe der Strassenraender "|" und des Autos "*"
                           'Die Spaltenpositionen werden mit TAB() erreicht
'
'------ Cursortasten auswerten
T$ = INKEY$                'Taste einlesen
IF T$ = CHR$(0) + "K" THEN 'Cursor links betaetigt
  P% = P% - 1              'Autoposition 1 Spalte nach links
ELSEIF T$ = CHR$(0) + "M" THEN  'Cursor rechts betaetigt
  P% = P% + 1              'Autoposition 1 Spalte nach rechts
END IF
'
'------ Strassenverlauf mit Zufallsgenerator aendern
RANDOMIZE TIMER
Z% = 3 * RND - 1.5         'Zufallszahl -1, 0 oder 1 erzeugen
S% = S% + Z%               'Strassen-Anfangsposition entsprechnd aendern
IF S% < 1 THEN             'linker Bildschirmrand überschritten?
  S% = 1                   'Strasse auf linken Rand zuruecksetzen
ELSEIF S% + B% > 79 THEN   'rechter Bildschirmrand ueberschritten?
  S% = 79 - B%             'Strasse auf rechten Bildschirnrand zuruecksetzen
END IF
'
'------ Wartezeit 0,05 sec einfuegen
Zeit = TIMER: DO: LOOP UNTIL TIMER > Zeit + .05
'
'------- Kollision auswerten
LOOP WHILE P% > S% AND P% < S% + B%
PRINT " >>> B U M M M --- GAME OVER <<<": BEEP 'Spielende
LOOP

