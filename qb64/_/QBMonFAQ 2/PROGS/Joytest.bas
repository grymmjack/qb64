'****************************************************************************
' JOSTEST.BAS - Joystick-Testprogramm fuer QBASIC
' ============================================================
'
' Es werden, X/Y-Koordinate, Schubregler und die Feuerknoepfe angezeigt
'
'
'   \         (c) Thomas Antoni, 11.3.99 - 12.03.99
'    \ /\           Mailto:thomas*antonis.de
'    ( )            www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'
'***************************************************************************
COLOR 14, 1          'Bildschirmfarben: gelbe Schrift auf blauem Hintergrund
CLS
PRINT
PRINT
PRINT
PRINT
PRINT "    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
PRINT "    ³                                                                 ³±±"
PRINT "    ³    Willkommen zum Joystick-Test                                 ³±±"
PRINT "    ³    ============================                                 ³±±"
PRINT "    ³                                                                 ³±±"
PRINT "    ³    Angezeigt wird: - X- und Y-Achse                             ³±±"
PRINT "    ³                    - Schubregler                                ³±±"
PRINT "    ³                    - unterer/ oberer Feuerknopf                 ³±±"
PRINT "    ³                                                                 ³±±"
PRINT "    ³                                                                 ³±±"
PRINT "    ³     ........ weiter mit beliebiger Taste                        ³±±"
PRINT "    ³                                                                 ³±±"
PRINT "    ³                                                                 ³±±"
PRINT "    ³                                                                 ³±±"
PRINT "    ³                                              (c)Thomas Antoni   ³±±"
PRINT "    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±"
PRINT "      ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
PRINT
WHILE INKEY$ = ""               'warten bis eine beliebige Taste betaetigt
WEND
CLS
PRINT
PRINT "                 ........  Abbruch mit Esc-Taste"
PRINT
PRINT " X-Achse", "Y-Achse", "Schub", "Knopf A", "Knopf B"
VIEW PRINT 5 TO 24             'Ausgabefenster Zeile 5 bis 24 fuer die folgen-
                               'den PRINT-Anweisungen festlegen
WHILE INKEY$ <> CHR$(27)       'Dauerschleife bis Esc-Taste bet„tigt
PRINT "  "; STICK(0), STICK(1), STICK(3), -STRIG(1), -STRIG(5)
                               'X-Koordinate, Y-Koordinate, Schubregler
                               'und Feuerkn”pfe unten/ oben anzeigen (1/0=
                               'Feuerknopf gedrueckt/ nicht gedrueckt)
WEND
COLOR 15, 0                    'Wieder Weiss/Schwarz-Bildschirm setzen
CLS
SYSTEM                         'Ausprung zum Betriebssystem

