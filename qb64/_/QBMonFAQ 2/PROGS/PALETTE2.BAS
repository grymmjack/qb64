'****************************************************************************
' PALETTE2.BAS = Demonstration des Palette-Befehls in Screen 12
' ============
' Dieses Q(uick)Basic-Programm demonstriert den Palette-Befehl, indem es
' in SCREEN 12 zunaechst 16 Querbalken in den 16 Grundfarben auf den
' Bildschirm ausgibt.
'
' (c) NickTheQuick, 1.3.2002
'****************************************************************************
SCREEN 12
COLOR 0
CLS
'
Farbe = 0
FOR y = 0 TO 479 STEP 480 / 16
  LINE (0, y)-(639, y + (480 / 16)), Farbe, BF
  Farbe = Farbe + 1
NEXT y
'
LOCATE 30: COLOR 15: PRINT "... beliebige Taste! ";
DO: LOOP WHILE INKEY$ = ""           'Warten auf beliebige Taste
'
'Das war die gewohnte Anwendung der 16 Grundfarben und nicht weiter schwer.
'Aber jetzt kommen wir zu unserem PALETTE-Befehl, mit dessen Hilfe
'wir diese Farben durch Mischungen der Farbanteile Rot, Gruen und Blau
'(RGB) darstellen:
'
PALETTE 0, 0                         '0 <- 0% Rot, 0% Gr］, 0% Blau
PALETTE 1, 63 * 65536                '1 <- 0% Rot, 0% Gr］, 100% Blau
PALETTE 2, 63 * 256                  '2 <- 0% Rot, 100% Gr］, 0% Blau
PALETTE 3, (63 * 256) + (63 * 65536) '3 <- 0% Rot, 100% Gr］, 100% Blau
PALETTE 4, 63                        '4 <- 100% Rot, 0% Gr］, 0% Blau
PALETTE 5, 63 + (63 * 65536)         '5 <- 100% Rot, 0% Gr］, 100% Blau
PALETTE 6, 63 + (63 * 256)           '6 <- 100% Rot, 100% Gr］, 0% Blau
PALETTE 7, 63 + (63 * 256) + (63 * 65536) '7 <- 100% Rot, 100% Gr］, 100% Blau

