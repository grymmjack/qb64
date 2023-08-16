'***************************************************************
' WUERFEL2.BAS = Wuerfelspiel mit ASCII-Grafik im Textbildschirm
' ============
' Dieses Q(uick)Basic-Programm fordert den Anwender auf, mit
' einer beliebigen Taste den Wuerfel zu werfen und zeigt dann
' einen mit ASCII-Textzeichen gezeichneten grafisch
' ansprechenden Wuerfel mit zufaelliger Auganzahl an. Mit der
' Esc-Taste laesst sich das Programm beenden.
'
' (c) Thomas Antoni, 12.4.2005
'***************************************************************
'
'***** Bedienhinweise anzeigen *********************************
COLOR 0, 7
CLS
LOCATE 3, 28: PRINT "W U E R F E L S P I E L"
LOCATE , 28: PRINT STRING$(23, CHR$(205))        'Doppelstrich
LOCATE 23, 22
PRINT "Nochmal Wuerfeln...[Beliebige Taste]"
LOCATE , 22
PRINT "Beenden............[Esc]"
'
'***** Zufallszahl 1...6 erzeugen ******************************
RANDOMIZE TIMER           'Zufallsgenerator initialisieren
'
DO
Zahl% = INT(RND * 6 + 1)
BEEP
'
'***** Wuerfel anzeigen ****************************************
COLOR 15, 5
LOCATE 8
SELECT CASE Zahl%
  CASE 1
    LOCATE , 35: PRINT "зддддд©"
    LOCATE , 35: PRINT "Ё     Ё"
    LOCATE , 35: PRINT "Ё  Ч  Ё"
    LOCATE , 35: PRINT "Ё     Ё"
    LOCATE , 35: PRINT "юддддды"
 
  CASE 2
    LOCATE , 35: PRINT "зддддд©"
    LOCATE , 35: PRINT "Ё  Ч  Ё"
    LOCATE , 35: PRINT "Ё     Ё"
    LOCATE , 35: PRINT "Ё  Ч  Ё"
    LOCATE , 35: PRINT "юддддды"
 
  CASE 3
    LOCATE , 35: PRINT "зддддд©"
    LOCATE , 35: PRINT "Ё  Ч  Ё"
    LOCATE , 35: PRINT "Ё  Ч  Ё"
    LOCATE , 35: PRINT "Ё  Ч  Ё"
    LOCATE , 35: PRINT "юддддды"

  CASE 4
    LOCATE , 35: PRINT "зддддд©"
    LOCATE , 35: PRINT "Ё Ч Ч Ё"
    LOCATE , 35: PRINT "Ё     Ё"
    LOCATE , 35: PRINT "Ё Ч Ч Ё"
    LOCATE , 35: PRINT "юддддды"

  CASE 5
    LOCATE , 35: PRINT "зддддд©"
    LOCATE , 35: PRINT "Ё Ч Ч Ё"
    LOCATE , 35: PRINT "Ё  Ч  Ё"
    LOCATE , 35: PRINT "Ё Ч Ч Ё"
    LOCATE , 35: PRINT "юддддды"

  CASE 6
    LOCATE , 35: PRINT "зддддд©"
    LOCATE , 35: PRINT "Ё Ч Ч Ё"
    LOCATE , 35: PRINT "Ё Ч Ч Ё"
    LOCATE , 35: PRINT "Ё Ч Ч Ё"
    LOCATE , 35: PRINT "юддддды"
END SELECT
LOCATE 15, 37
PRINT Zahl%
'
'****** Wiederholen/Beenden-Dialog *****************************
Taste$ = INPUT$(1) 'Warten bis 1 Taste betaetigt
IF Taste$ = CHR$(27) THEN END 'Beenden bei Esc-Taste
LOOP

