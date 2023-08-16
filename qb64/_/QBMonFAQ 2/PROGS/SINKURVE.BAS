'******************************************************
' SINKURVE.BAS = Sinuskurve anzeigen
' ============
'
' (c) Stefan (stef_0815*web.de), 25.1.04 - 30.1.2004
'******************************************************
SCREEN 12
CONST pi# = 3.14159265359#
'
'---- Winkel abfragen u.dessen Sinus anzeigen ----
INPUT "Gib einen Winkel ein (0...360 Grad): a = ", w
PRINT "sin(a) = ", SIN(w * 2 * pi / 360)
xw = w * 640 / 360
yw = SIN(xw / 640 * 2 * pi#)
LINE (xw, 239)-(xw, -yw * 200 + 240), 14
 'Eingegeb. Winkel u. dessen Sinuswert in gelb anzeigen
'
'---- Sinus-Kurve anzeigen ------------------------
LINE (0, 239)-(639, 239), 2  'X-Achse in gruen zeichnen
FOR x% = 0 TO 639
  y = SIN(x% / 639 * 2 * pi#)
  PSET (x%, -y * 200 + 240), 2
NEXT x%
SLEEP
END

