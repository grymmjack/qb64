'******************************************************************************
' EASYCHAT.BAS - Chat über Nullmodemkabel
' ============
' Dieses QBasic-Programm funktioniert zwar tadellos. Aber weil ich es in
' meinen Anfaengerjahren geschrieben habe, ist es voll von GOTO- und
' GOSUB-Anweisungen.
'
' *** Funktionsweise:
' Zuerst geht man in die Konfiguration und tippt dort seine Einstellungen
' ein. Dabei muss man beachten, dass beide Chatter denselben COM-Port
' und die selbe Geschwindigkeit benutzen, sonst geht es nicht.
' Danach waehlt man "Chat" an und das Programm "synchronisiert" sich mit
' dem anderen Computer. Es übertraegt dazu einfach den Nickname und die
' Farbe.
' Danach geht es in den eigentlichen Chat ueber. Waehrend der Chat läuft,
' wird ständig geprüft, ob irgendwelche Daten auf dem COM-Port einlaufen.
' Ist dies dann der Fall, wird die entsprechende Nachricht angezeigt.
'
' *** Entstehungsgeschichte:
' Ich habe EasyChat geschrieben, um das Nullmodemkabel zu
' testen, das ich von meinem Onkel geschenkt bekommen hatte und
' um die Funktionsweise des OPEN COM-Befels zu erproben...
' Das Programm ist vor 2 Jahren entstanden. Damals habe ich noch
' mit GOTO und GOSUB gearbeitet und das ist halt lange her...
' Wer Lust hat, kann das Programm ja umschreiben...
'
' (c) Weazel ( weazel77*gmx.de ), 15.5.2003
'******************************************************************************
DECLARE SUB Menue ()
DECLARE SUB Config ()
DECLARE SUB OpenCom ()
DECLARE SUB Init ()
DECLARE SUB Chat ()
DECLARE SUB Syn ()
'
DIM SHARED ComPort$, ComSpeed$, ComOpt$
DIM SHARED ActName$, ActFarbe, OthName$, OthFarbe
'
SCREEN 0
CLS
'
Menue
'
SUB Chat
'
CLS
VIEW PRINT 1 TO 25
'
COLOR 15, 1
PRINT "                                 EASYCHAT 2000                                  "
COLOR 9, 1
PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
'
t = TIMER
'
Zeile = 3: Spalte = 1
'
VIEW PRINT 3 TO 25
LOCATE 24, 1: COLOR 15, 1: PRINT "                                                                                "
LOCATE 24, Spalte: PRINT "_"
'
TastenAbfrage:
VIEW PRINT 1 TO 25
  LOCATE 1, 1: PRINT USING "Chat-Time: ## min"; (TIMER - t) / 60
  LOCATE 1, 62: PRINT "Real-Time: " + TIME$
VIEW PRINT 3 TO 25
'
IF LOC(1) <> 0 THEN GOTO TextEmpfangen
Taste$ = INKEY$
SELECT CASE Taste$
CASE CHR$(8): GOTO TextZeichenLoeschen
CASE CHR$(13): GOTO TextSenden
CASE CHR$(27): GOTO ChatBeenden
CASE IS <> "": GOTO TextErweitern
END SELECT
GOTO TastenAbfrage
'
TextSenden:
IF OutText$ = "" THEN GOTO TastenAbfrage
VIEW PRINT 3 TO 22
IF Zeile > 22 THEN Zeile = 22
LOCATE Zeile, 2: COLOR ActFarbe, 1: PRINT ActName$ + " : "; : COLOR 15, 1: PRINT OutText$
PRINT #1, OutText$
VIEW PRINT 3 TO 25
COLOR 9, 1: LOCATE Zeile, 1: PRINT "³": LOCATE Zeile, 80: PRINT "³"
OutText$ = "": Zeile = Zeile + 1: Spalte = 1
VIEW PRINT 3 TO 25
LOCATE 24, 1: COLOR 15, 1: PRINT "                                                                                "
LOCATE 24, Spalte: PRINT "_"
GOTO TastenAbfrage
'
TextErweitern:
IF ASC(Taste$) < 32 THEN GOTO TastenAbfrage
IF Spalte > 60 THEN GOTO TastenAbfrage
OutText$ = OutText$ + Taste$: LOCATE 24, 1: COLOR 15, 1: PRINT OutText$
Spalte = Spalte + 1
LOCATE 24, Spalte: PRINT "_"
GOTO TastenAbfrage
'
TextZeichenLoeschen:
IF LEN(OutText$) = 0 THEN GOTO TastenAbfrage
OutText$ = MID$(OutText$, 1, LEN(OutText$) - 1)
LOCATE 24, 1: COLOR 15, 1: PRINT "                                                                                "
LOCATE 24, 1: PRINT OutText$
Spalte = Spalte - 1
LOCATE 24, Spalte: PRINT "_"
GOTO TastenAbfrage
'
TextEmpfangen:
INPUT #1, InText$
IF InText$ = "QUITCHAT" THEN GOTO ChatBeenden
VIEW PRINT 3 TO 22
IF Zeile > 22 THEN Zeile = 22
LOCATE Zeile, 2: COLOR OthFarbe, 1: PRINT OthName$ + " : "; : COLOR 15, 1: PRINT InText$
VIEW PRINT 3 TO 25
COLOR 9, 1: LOCATE Zeile, 1: PRINT "³": LOCATE Zeile, 80: PRINT "³"
InText$ = "": Zeile = Zeile + 1
GOTO TastenAbfrage
'
ChatBeenden:
LOCATE 24, 1: COLOR 15, 1: PRINT "Chat beendet."
PRINT #1, "QUITCHAT"
CLOSE #1
SLEEP 2
'
END SUB
'
SUB Config
'
CLS
VIEW PRINT 1 TO 25
'
COLOR 15, 1
PRINT " EasyChat-Konfiguration                                                         "
COLOR 9, 1
PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
PRINT "³                                                                              ³"
PRINT "³ Comport des Computers: (COM1: oder COM2:)                                    ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³ Baudrate der Verbindung: (300, 600, 1200, 2400, 4800, 9600, 19200)           ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³ Nickname dieses Computers:                                                   ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³ Schriftfarbe des Nicknames:                                                  ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
PRINT "                                                                                "
'
LOCATE 22, 2
FOR I = 1 TO 15
COLOR I: PRINT I;
NEXT I
'
LOCATE 5, 3: INPUT "", ComPort$
LOCATE 8, 3: INPUT "", ComSpeed$
LOCATE 11, 3: INPUT "", ActName$
LOCATE 14, 3: INPUT "", ActFarbe
'       
OPEN "EASYCHAT.CFG" FOR OUTPUT AS #1
PRINT #1, ComPort$
PRINT #1, ComSpeed$
PRINT #1, ActName$
PRINT #1, ActFarbe
CLOSE
'
END SUB
'
SUB Delay (Sekunden)
'
Start = TIMER
DO: LOOP UNTIL TIMER - Start >= Sekunden
'
END SUB
'
SUB Init
'
CLOSE
OPEN "EASYCHAT.CFG" FOR INPUT AS #1
INPUT #1, ComPort$
INPUT #1, ComSpeed$
INPUT #1, ActName$
INPUT #1, ActFarbe
CLOSE
'
END SUB
'
SUB Menue
'
MenueStart:
CLS
VIEW PRINT 1 TO 25
'
COLOR 15, 1
PRINT " EasyChat-Men                                                                  "
COLOR 9, 1
PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
PRINT "³                                                                              ³"
PRINT "³ 1. Chat starten                                                              ³"
PRINT "³ 2. Konfiguration                                                             ³"
PRINT "³ 3. Beenden                                                                   ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "³                                                                              ³"
PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
PRINT "                                                                                "
'
MenueAbfrage:
Taste$ = INKEY$
SELECT CASE Taste$
CASE "1": GOTO ChatStarten
CASE "2": GOTO Konfiguration
CASE "3": GOTO Beenden
END SELECT
GOTO MenueAbfrage
'
ChatStarten:
Init
'
OpenCom
 Syn
CLOSE
'
OpenCom
 Chat
CLOSE
GOTO MenueStart
'
Konfiguration:
Config
GOTO MenueStart
'
Beenden:
CLOSE
VIEW PRINT 1 TO 25: COLOR 15, 0
CLS : END
'
END SUB
'
SUB OpenCom
'
CLOSE
OPEN ComPort$ + ComSpeed$ + ",N,8,1,BIN,CD0,CS0,DS0,OP0,RS,TB2048,RB2048" FOR RANDOM AS #1
'
END SUB
'
SUB Syn
'
CLS
PRINT "Synchronisiere Daten..."
'
Daten$ = ActName$ + STR$(ActFarbe)
'
PRINT #1, Daten$
DO
 IF NameFa$ = "" THEN INPUT #1, NameFa$: EXIT DO
LOOP
PRINT #1, Daten$
'
OthName$ = MID$(NameFa$, 1, LEN(NameFa$) - 3)
OthFarbe = VAL(LEFT$(RIGHT$(NameFa$, 2), 2))
'
END SUB

