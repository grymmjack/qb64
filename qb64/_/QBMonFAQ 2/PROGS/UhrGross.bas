'***************************************************************************
' UHRGROSS.BAS = Digitaluhr mit grossen Ziffern
' ============
' Dieses QBasic-Programm zeigt die Uhrzeit auf einer grossen Digitalanzeige
' mit 7*5-Matrix-Ziffern an
'
' (c) Thomas Antoni, 21.2.2005  --  www.qbasic.de
'***************************************************************************
DIM Z$(10, 7)          'Feld fur die je 7 Anzeige-Zeilen der Ziffern 0...9
'
FOR Zeile% = 1 TO 7
  FOR Ziffer% = 0 TO 4         'Fuer Ziffern 0...4 ...
     READ Z$(Ziffer%, Zeile%)  'Anzeigezeilen ins Feld einlesen
  NEXT
NEXT
'
FOR Zeile% = 1 TO 7
  FOR Ziffer% = 5 TO 9         'Fuer Ziffern 5...9 ...
     READ Z$(Ziffer%, Zeile%)  'Anzeigezeilen ins Feld einlesen
  NEXT
NEXT
'
COLOR 1, 7                     'Blau auf Hellgrau
CLS
LOCATE 24, 25
PRINT "Abbruch mit beliebiger Taste"
'
DO
T$ = TIME$                'Uhrzeit zwischenspeichern
H1% = VAL(MID$(T$, 1, 1)) 'Stunden Zehnerstelle
H2% = VAL(MID$(T$, 2, 1)) 'Stunden Einerstelle
M1% = VAL(MID$(T$, 4, 1)) 'Minuten Zehnerstelle
M2% = VAL(MID$(T$, 5, 1)) 'Minuten Einerstelle
S1% = VAL(MID$(T$, 7, 1)) 'Sekunden Zehnerstelle
S2% = VAL(MID$(T$, 8, 1)) 'Sekunden Einerstelle
'
FOR Zeile% = 1 TO 7
  LOCATE 6 + Zeile%, 12
  PRINT Z$(H1%, Zeile%); "  "; Z$(H2%, Zeile%); SPACE$(8); 'Stunden anzeigen
  PRINT Z$(M1%, Zeile%); "  "; Z$(M2%, Zeile%); SPACE$(8); 'Minuten anzeigen
  PRINT Z$(S1%, Zeile%); "  "; Z$(S2%, Zeile%);            'Sekunden anzeigen
NEXT
'
LOCATE 18, 30
PRINT "Datum: ";
PRINT MID$(DATE$, 4, 2); "."; MID$(DATE$, 1, 2); "."; MID$(DATE$, 7, 4)
'
Taste$ = INKEY$
LOOP WHILE Taste$ = ""    'Beenden bei beliebigem Tastendruck
END
'
'****** Punktmatrix fuer Ziffern 0...4
DATA " *** ", "  *  ", " *** ", " *** ", "    *"
DATA "*   *", " **  ", "*   *", "*   *", "   **"
DATA "*   *", "* *  ", "*   *", "    *", "  * *"
DATA "*   *", "  *  ", "   * ", " *** ", " *  *"
DATA "*   *", "  *  ", "  *  ", "    *", "*****"
DATA "*   *", "  *  ", " *   ", "*   *", "   * "
DATA " *** ", " *** ", "*****", " *** ", "   * "
'
'****** Punktmatrix fuer Ziffern 5...9
DATA "*****", " *   ", "*****", " *** ", " *** "
DATA "*    ", "*    ", "    *", "*   *", "*   *"
DATA "**** ", "*    ", "    *", "*   *", "*   *"
DATA "    *", "**** ", "   * ", " *** ", " ****"
DATA "    *", "*   *", "  *  ", "*   *", "    *"
DATA "    *", "*   *", " *   ", "*   *", "    *"
DATA "**** ", " *** ", "*    ", " *** ", "    *"

 

