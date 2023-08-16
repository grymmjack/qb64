'***************************************************************************
' MUSIK.BAS = Diverse QBASIC-Musikstuecke u.Soundeffekte fuer den PC-Speaker
' ==========================================================================
'
' PLAY "MF..." = Sound wird im Vordergrund gespielt (warten bis Musik zuen-
'                de ist)
' PLAY "MB..." = bewirkt Spielen im Hintergrund (Background) ohne Warten
'
'
'   \         (c) Thomas Antoni, 2.6.99 - 4.3.05
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de 
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'***************************************************************************
'
DECLARE SUB AutoRennen ()
DECLARE SUB Heller ()
'
DO
CLS
PRINT "---------========= Waehle das Musikstueck ==========----------"
PRINT "1  = lange Fanfare aus Nibbles"
PRINT "2  = kurze Fanfare aus Nibbles"
PRINT "3  = kurzer Jubel  aus Nibbles"
PRINT "4  = Sterbe-Seufzer/Furz aus Nibbles"
PRINT "5  = Alle meine Entchen"
PRINT "6  = Big Ben Gongschlag I"
PRINT "7  = Big Ben Gongschlag II"
PRINT "8  = Polizeisirene"
PRINT "9  = Autorennen"
PRINT "a  = Mini-Sirene, ideal als Ende-Sound"
PRINT "b  = Ein Heller und ein Batzen (Volkslied)"
PRINT
PRINT "Esc= Beenden"

DO
  taste$ = INKEY$
LOOP WHILE taste$ = ""

SELECT CASE taste$
  CASE "1": PLAY "MFT160O1L8CDEDCDL4ECC"
  CASE "2": PLAY "MFT160O1>L20CDEDCDL10ECC"
  CASE "3": PLAY "MFO0L16>CCCE"
  CASE "4": PLAY "MFO0L32EFGEFDC"
  CASE "5": PLAY "MFT160O3L8cdefL4ggL8aaaaL2gL8aaaaL2gL8ffffL4eeL8ggggL4c"
  CASE "6": PLAY "MFMLT160O1L2cdecP2fedc"
  CASE "7": PLAY "MFMLT160O1L2gdecP2fedc"
  CASE "8"
    ton = 780
    bereich = 650
    FOR zaehler1 = 0 TO 1
      FOR zaehler2 = bereich TO -bereich STEP -4
        SOUND ton - ABS(zaehler2), .3
        zaehler2 = zaehler2 - 2 / bereich
      NEXT zaehler2
    NEXT zaehler1
  CASE "9": CALL AutoRennen
  CASE "a"
    FOR C% = 1 TO 5
      FOR i% = 550 TO 660 STEP 5
        SOUND i%, i% / 4000
      NEXT
    NEXT
  CASE "b": CALL Heller
  CASE CHR$(27): END  'Beenden mit Esc-Taste
END SELECT
LOOP
END

'
SUB AutoRennen
'****************************************************************************
' AutoRennen = QBasic Subroutine, erzeugt Motorengeraeusch und Cockpit-Anzeige
' ===========================================================================
' Verwendete Befehle: VIEW, SOUND
'
' (c) Thomas Antoni, 31.08.99  (nach einem Programmvorschlag von H.Schumann
'*****************************************************************************

SCREEN 11                  'VGA 640*480*2

'--- Tachoskala ---------------------------------------
FOR i% = 0 TO 4            'Anzeige bis 200 kmh in 50-kmh- Schritten
  LOCATE 18, i% * 15 + 1
  PRINT i% * 50;
NEXT i%
PRINT SPC(8); "kmh"        '8 Blanks und kmh anzeigen

'--- GÑnge 1 bis 5 durchschalten ----------------------
FOR gang% = 1 TO 5

'--- Beschleunigen ------------------------------------
  FOR upm% = 40 TO 90
    frequenz% = upm% + gang% * 20
    SOUND frequenz% + 2, .5
    SOUND frequenz% - 2, .5

'--- Geschwindigkeit als Balken anzeigen --------------
    LINE (10, 300)-(tacho% + upm% * 2, 310), , BF
    LOCATE 22, 26
    PRINT gang%; ". Gang  :"; frequenz% * 40; "UpM"
  NEXT upm%
  tacho% = tacho% + upm%
  SOUND frequenz% - 10, 2
NEXT gang%
LOCATE 28, 5: PRINT "Anhalten mit beliebiger Taste"
DO
  SOUND frequenz% + 2, .5
  SOUND frequenz% - 2, .5
LOOP UNTIL INKEY$ <> ""

'--- Bremsen und Anhalten -----------------------------
VIEW (10, 300)-(550, 400)    'Bildschirmausschnitt fÅr kmh-Balken definieren
FOR i% = 55 TO 0 STEP -1
  SOUND 5000, .5
  SOUND i% * 10 + 150, .2
  CLS                        'Bildschirmausschnitt fÅr kmh-Balken lîschen
  LINE (0, 0)-(i% * 10, 10), , BF    'neuer kmh-Balken
  SOUND 500, .2
  LOCATE 22, 26
  gang% = 0
  PRINT gang%; ". Gang  :"; i% * 100; "  UpM"
NEXT i%
'
'--- Beenden-Dialog -----------------------------------
LOCATE 28, 5: PRINT "Beenden mit beliebiger Taste"
DO: LOOP UNTIL INKEY$ <> ""
SCREEN 0
CLS
END SUB

'
SUB Heller
'****************************************************************************
' Heller = Subroutine, spielt das Volkslied "Ein Heller und ein Batzen" ab
' ======
' Verwendete Befehle: Play
'
' (c) Thomas Antoni, 4.5.05  (nach einem Programmvorschlag von H.Mathias
'*****************************************************************************
A$ = "O2 T140 L4 CCGEC<B>GG P8 L8 G L2 G P16 L8 AGF L4 EAG"
 ' "Ein Heller und ein Batzen, die waren beide mein"
B$ = "EFA>CC L2 C L4 <G>C L2 <B P16 L8 AGF"
 ' "Der Heller ward zu Wasser, der Batzen ward zu Wein"
C$ = "L4 EAG"
 ' "ja Wein"
D$ = "L2 E P4"
 ' Pause bis zum Refrain
E$ = "L2 G L4 AGE. L8E L4 E P4 L2 >C L4 DC<A. L8 A L4 A P8. L8 >C"
E$ = E$ + "L4 <B. L8 G L4 >E. L8 D"
 ' Refrain: "Heidi heido heida, heidi heido heida, heido heido hei-"
F$ = "L8 C. L16 C L8 <B AGFED"
 ' da haha haha hahaha"
G$ = "L2 C"
 ' "da"
PLAY A$ + B$ + C$ + B$ + D$ 'Alles in richtiger Reihenfolge...
PLAY E$ + F$ + E$ + G$      '... und mit Wiederholungen abspielen
END SUB

