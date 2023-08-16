'***************************************************************
' RGBfarbe.bas = Beliebige RGB-Farben erzeugen mit PALETTE
' ============
' Dieses QBasic-Programm zeigt am Beispiel des Grafikbildschirms
' SCREEN 13, wie man eigene Farben aus den Bestandteilen Rot,
' Gruen, und Blau zusammenmischen kann, also nach dem
' sogenannten RGB-Verfahren.
'
' Das Programm fragt vom Anwender die RGB-Farbwerte von 2
' Farben ab und definiert mit Hilfe von PALETTE die erste als
' Hintergrundfarbe (Farbcode 0) und die andere als
' Vordergrundfarbe mit dem Farbcode 7. Der Bildschirm wird dann
' mit der Hintergrundfarbe eingefaerbt und das Programm malt
' darauf ein in der Vordergrundfarbe ausgfuelltes Rechteck.
'
' SCREEN 13 hat eine Aufloesung von 320 x 200 Pixeln und 256
' Farben. Jede der 256 Farben kann mit Hilfe des PALETTE-Befehls
' individuell aus 262144 Farbwerten gewaehlt werden, indem man
' je 64 verschiedene Helligkeitsstufen der 3 Grundfarben Rot,
' Gruen und Blau zusammenmischt.
'
' Der PALETTE-Befehl hat die folgende Syntax:
'    PALETTE Farbode%(0...255), (rot + 256*gruen + 65536*blau)
' Die Helligkeitsstufen der 3 Farben rot, gruen und blau gehen
' von 0 bis 63. Beispiel:
'    PALETTE 7, 0 + 256*0 + 65536*63 'Farbcode 7 = blau
'    LINE (0,0)-(100,100), 7         'blaue Linie zeichnen
'
' Der Farbcode 0 ist automatisch fuer den Hintergrund reserviert.
' Die Farbcodes 1...255 lasen sich freizuegig in den Befehlen
' COLOR, LINE, CIRCLE, PSET usw. als Vordergrungdfarben
' verwenden.
'
' Die geschilderte Methode funktioniert bei den anderen
' Grafik-SCREENs sinngemaess genauso wie in SCREEN 13.
'
' (c) Thomas Antoni, 20.2.2004 - 24.2.2004
'***************************************************************
'
'--- RGB-Farben fuer Hinter- und Vordergrund eingeben
DO
PRINT "Gib die RGB-Werte fuer d.Hintergrund ein"
INPUT " Rot   (0-63): ", hrot%
INPUT " Gruen (0-63): ", hgruen%
INPUT " Blau  (0-63): ", hblau%
PRINT
PRINT "Gib die RGB-Werte ein d.Vordergrund ein"
INPUT " Rot   (0-63): ", vrot%
INPUT " Gruen (0-63): ", vgruen%
INPUT " Blau  (0-63): ", vblau%
'
'---- Farbwerte fuer Hinter- und Vordergrund berechnen
hfarbe& = hrot% + 256 * hgruen% + 65536 * hblau%
vfarbe& = vrot% + 256 * vgruen% + 65536 * vblau%
'
'---- Bildschirm mit Hintergrundfarbe (0) einfaerben
SCREEN 13
PALETTE 0, hfarbe&
CLS
'
'---- Rechteck zeichnen, das mit d.Vordergundfarbe gefuellt ist
PALETTE 7, vfarbe&
'dem Farbcode 7 den Vordergrund-Farbwert zuweisen. Die
'Farbcodenummer 7 ist willkuerlich aus dem Bereich 1...255
'gewaehlt
LINE (50, 50)-(270, 150), 7, BF 'Kasten mit Farbe 1 malen
'
'---- Wiederholen-/Beenden-Dialog
PRINT
PRINT " ...Wiederholen mit beliebiger Taste"
PRINT " ...Beenden mit Esc"
taste$ = INPUT$(1)          'Ein Zeichen von der Tastatur einlesen
LOOP UNTIL taste$ = CHR$(27)

