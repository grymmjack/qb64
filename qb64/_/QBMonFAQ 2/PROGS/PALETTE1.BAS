'*********************************************************************
' PALETTE1.BAS = Palettendemo - demonstriert die Farbmischung
' ============   mit dem PALETTE-Befehl, inklusive Fading
'
' (c) DiabloD, 10.5.02
'*********************************************************************
DECLARE SUB Verbindung ()
'***DiabloD SuperHPMaster*web.de ***
'Hi!
'Ich hab dieses Beispiel geschrieben um zu verdeutlichen wie man den
'Palette-Befehl ausfuehrt.
'Dieses Programm ist Freeware und daher duerfen Teile daraus kopiert
'werden, solange ihr nicht angebt, das es von euch ist.
'Jetzt jeder Schritt mit detaillierter Erlaeuterung:
'
'*** als Erstes muss man in Bildschirm-Modus 13 wechseln ***
SCREEN 13
' dann wie ueblich cls
CLS                     ';)
'so, und jetz Palette:
 '...*************--------Anmerkung--------**************...
 ' wenn man wie hier bei jeder Farbe den gleichen Wert eingibt,
 ' so wie hier wird die Farbe ein Grauton:
  blau = 10
  gruen = 10
  rot = 10
  PALETTE 1, 65536 * blau + 256 * gruen + rot
  COLOR 1: PRINT "Grau"
' wenn man allerdings alle Werte auf 0 setzt, wird die Farbe Schwarz:
  SLEEP 1
  CLS
  blau = 0
  gruen = 0
  rot = 0
  PALETTE 1, 65536 * blau + 256 * gruen + rot
  COLOR 1: PRINT "Schwarz"
'und wenn man alle Werte auf 63 setzt wird die Farbe ganz hellweiss:
  SLEEP 1
  CLS
  blau = 63
  gruen = 63
  rot = 63
  PALETTE 1, 65536 * blau + 256 * gruen + rot
  COLOR 1: PRINT "Weiss"
'aber wenn man einen Wert auf 63 und die andern
'auf 0 setzt wird die auf 63 eine reine Farbe
 'Blau:
  SLEEP 1
  CLS
  blau = 63
  gruen = 0
  rot = 0
  PALETTE 1, 65536 * blau + 256 * gruen + rot
LOCATE 1, 1: COLOR 1: PRINT "Blau"
 'Gruen
  blau = 0
  gruen = 63
  rot = 0
  PALETTE 2, 65536 * blau + 256 * gruen + rot
LOCATE 2, 1: COLOR 2: PRINT "Gruen"
'
'Rot:
  blau = 0
  gruen = 0
  rot = 63
  PALETTE 3, 65536 * blau + 256 * gruen + rot
 LOCATE 3, 1: COLOR 3: PRINT "Rot"
'
'Und wenn man den Effekt erreichen will, dass eine Farbe heller oder dunkler
'wird muss man einen der folgenden Quellcodes benutzen:
 'Ausgabe wird heller:
  SLEEP 1
  CLS
  FOR Farbe = 0 TO 63
   PALETTE 1, 65536 * Farbe + 256 * Farbe + Farbe
   LOCATE 1, 1: COLOR 1: PRINT "Dunkel--->Weiss"
  FOR warteschleife = 1 TO 10000: NEXT
  NEXT
 'Ausgabe wird dunkler:
  CLS
  FOR Farbe = 63 TO 0 STEP -1
  PALETTE 1, 65536 * Farbe + 256 * Farbe + Farbe
   LOCATE 1, 1: COLOR 1: PRINT "Weiss--->Dunkel"
  FOR warteschleife = 1 TO 10000: NEXT
  NEXT
'Wenn man auf eine bestimmte Farbe zusteuert geht das so:
 ' Blau:
  CLS
  FOR Farbe = 0 TO 63 STEP 1
  PALETTE 1, 65536 * Farbe + 256 * 0 + 0
   LOCATE 1, 1: COLOR 1: PRINT "Blau"
  FOR warteschleife = 1 TO 10000: NEXT
  NEXT
'
 ' Gruen:
  CLS
  FOR Farbe = 0 TO 63 STEP 1
  PALETTE 1, 65536 * 0 + 256 * Farbe + 0
   LOCATE 1, 1: COLOR 1: PRINT "Gruen"
  FOR warteschleife = 1 TO 10000: NEXT
  NEXT
'
 ' Rot:
  CLS
  FOR Farbe = 0 TO 63 STEP 1
  PALETTE 1, 65536 * 0 + 256 * 0 + Farbe
   LOCATE 1, 1: COLOR 1: PRINT "Rot"
  FOR warteschleife = 1 TO 10000: NEXT
  NEXT
'Farbuebergänge kann man so gestalten:
 'zuerst von Schwarz nach Weiss, dann von Weiss nach Blau und dann von Blau nach
 'Gruen, dann von Gruen zu Rot, und dann von Rot wieder Schwarz:
  'Schwarz--->Weiss
  CALL Verbindung

'
SUB Verbindung
  SCREEN 13
  CLS
  blau = 0
  gruen = 0
  rot = 0
'
'Schwarz--->Weiss
 FOR Farbe = 0 TO 63
  blau = Farbe
  gruen = Farbe
  rot = Farbe
  PALETTE 3, 65536 * blau + 256 * gruen + rot
 LOCATE 1, 1: COLOR 3: PRINT "Schwarz--->Weiss"
  FOR warteschleife = 1 TO 10000: NEXT
 NEXT
'Weiss--->Blau
'
   rotalt = rot
   gruenalt = gruen
'
  FOR GR = 63 TO 0 STEP -1
   rot = GR
   gruen = GR
   PALETTE 3, 65536 * blau + 256 * gruen + rot
  LOCATE 1, 1: COLOR 3: PRINT "Weiss--->Blau   "
   FOR warteschleife = 1 TO 10000: NEXT
  NEXT
'
  rot = 0
  gruen = 0
'Blau--->Tuerkies
  FOR gruen = 0 TO 63
   PALETTE 3, 65536 * blau + 256 * gruen + rot
  LOCATE 1, 1: COLOR 3: PRINT "Blau--->Tuerkis"
   FOR warteschleife = 1 TO 10000: NEXT
  NEXT
'
'Tuerkies--->Gruen
  rot = 0
  gruen = 63
  FOR blau = 63 TO 0 STEP -1
   PALETTE 3, 65536 * blau + 256 * gruen + rot
  LOCATE 1, 1: COLOR 3: PRINT "Tuerkies--->Gruen"
   FOR warteschleife = 1 TO 10000: NEXT
  NEXT
'
'Gruen--->Gelb

  blau = 0
  gruen = 63
  FOR rot = 0 TO 63 STEP 1
   PALETTE 3, 65536 * blau + 256 * gruen + rot
  LOCATE 1, 1: COLOR 3: PRINT "Gruen--->Gelb   "
   FOR warteschleife = 1 TO 10000: NEXT
  NEXT
'
'Gelb--->Rot
'
  rot = 63
  blau = 0
  FOR gruen = 63 TO 0 STEP -1
   PALETTE 3, 65536 * blau + 256 * gruen + rot
  LOCATE 1, 1: COLOR 3: PRINT "Gelb--->Rot    "
   FOR warteschleife = 1 TO 10000: NEXT
  NEXT
'
'Rot--->Schwarz
'
  gruen = 0
  blau = 0
  FOR rot = 63 TO 0 STEP -1
   PALETTE 3, 65536 * blau + 256 * gruen + rot
  LOCATE 1, 1: COLOR 3: PRINT "Rot--->Schwarz "
   FOR warteschleife = 1 TO 10000: NEXT
  NEXT
PALETTE 1, 65536 * 63 + 256 * 63 + 63
COLOR 1: PRINT "Na, hats dir gefallen?"
END SUB

