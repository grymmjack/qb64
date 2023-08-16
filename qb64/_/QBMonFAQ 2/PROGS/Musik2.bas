'***********************************************************************
' MUSIK2.BAS = Diverse QBasic-Musikstuecke mit PLAY und SOUND
' ==========
' Aus diversen Quellen zusammengestellt
'  (c) Thomas Antoni, 28.9.2005 - 9.2.2006
'***********************************************************************
DO
CLS
PRINT
PRINT "    M U S I K - E F F E K T E  M I T  PLAY  U N D  SOUND"
PRINT "--------------------------------------------------------------"
PRINT
PRINT "---------========= Waehle das Musikstueck ==========----------"
PRINT "1  = Das Mainzelmaennchenlied des Fernsehsenders ZDF"
PRINT "2  = Der erste Satz aus Beethovens fuenfter Symphonie"
PRINT "3  = Beethovens Menuett in G-Dur"
PRINT "4  = Trillern mit steigender Tonhoehe (hochbeamen)"
PRINT "5  = Trillern mit fallender Tonhoehe (herunterbeamen)"
PRINT "6  = Computer-Sirren (Die Systeme spiel'n verrueckt)"
PRINT "7  = Herabfallender Koerper"
PRINT "8 =  Lied Red River Valley"
PRINT "9  = Here Comes The Sun von den Beatles"
PRINT "Esc= Beenden"
'
DO
  Taste$ = INKEY$
LOOP WHILE Taste$ = ""  'Warten auf Tastenbetaetigung
'
SELECT CASE Taste$
CASE "1"
'--------------- Das Mainzelmaennchenlied des Fernsehsenders ZDF
Mainzel$ = "o2 L8 C F G A A o3 C o2 A G A+ A G L4 F P8 o3 L16 C D E F"
PLAY Mainzel$
'
CASE "2"
'-------------- Der erste Satz aus Beethovens fuenfter Symphonie,
'-------------- Ihr wisst schon:  Dieses Ta Ta Ta Taaaaa:
PLAY "T180 o2 P2 P8 L8 GGG L2 E- P24 P8 L8 FFF L2 D"
'
CASE "3"
'--------------- Beethovens Menuett in G-Dur
PLAY "L16<B.>C D.C# D.C# L4 D L16"
PLAY "E.<B>L4 C L16 D.<A L4 B"
PLAY "L16 G. A B. A# B. A# B. A# L4"
PLAY "B L16 A. G G. F# F# A G. E L4 D"
'
CASE "4"
'------------- Trillern mit steigender Tonhoehe ("hochbeamen")
FOR freq = 450 TO 750 STEP 7
  SOUND freq, 1
  SOUND 800 - freq, 1
NEXT freq
'
CASE "5"
'------------- Trillern mit fallender Tonhoehe ("herunterbeamen")
FOR freq = 750 TO 450 STEP -7
  SOUND freq, 1
  SOUND 787 - freq, 1
NEXT freq
'
CASE "6"
'------------- Computer-Sirren (Die Systeme spiel'n verueckt)
FOR i = 1 TO 50
  freq = INT(RND * 2700) + 500
  laenge = INT(RND * 3) + 1
  SOUND freq, laenge
NEXT i
'
CASE "7"
'------------- herabfallender Koerper
freq = 2000
DO
  SOUND freq, 1.1
  freq = freq / 1.1
LOOP UNTIL freq < 400
'
CASE "8"
'-------------- Lied "Red River Valley"
PLAY "O3"   '3.Oktace, mittleres C
PLAY "T255" 'Doppelt schnelles Tempo
PLAY "L2 N0 < L4 G > C"
PLAY "L2 E L4 E D"
PLAY "L2 C L4 D C"
PLAY "< L2 A > L1 C L4 < G > C"
PLAY "L2 E L4 E E"
PLAY "L2 G L4 F E"
PLAY "L1 D. > < L4 G > C"
PLAY "L2 E L4 E D"
PLAY "L2 D L4 D E"
PLAY "L2 G L1 F < L4 A A"
PLAY "L2 G L4 > C D"
PLAY "L2 E L4 D D"
PLAY "L1 C. L2 N0"
'
CASE "9"
'-------------- "Here Comes The Sun" von den Beatles
'-------------- (c)Harrisongs, Ltd, 1969
PLAY "T255" 'Tempo auf 255 Viertelnoten/min setzen
PLAY "O3"
PLAY "< < L2 A > > > L4 C# < A B > L2 C#."
PLAY "L2 N0 L4 C# < L2 B A F#"
PLAY "A B A F# L1 E."
PLAY "< < L2 A > > > L4 C# < A B > L2 C#."
PLAY "L2 N0 L4 C# < L2 B A L2 F#."
PLAY "> L4 C# < L2 B A L1 B B L1 N0"
PLAY "< < L2 A > > > L4 C# < L2 B > L2 C# < L2 A."
PLAY "> L4 C# < A B > L2 C#."
PLAY "< < L2 A > > > L4 C# < L2 B > C# < L2 A."
PLAY "L4 N0 A L2 B A"
PLAY "L2 N0 > L2 C# < B A N0"
PLAY "L4 F# A B E A B D A B A G# F# E"
'
'------------- Beenden mit Esc-Teste
CASE CHR$(27): END
END SELECT
LOOP

