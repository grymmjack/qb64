'********************************************************
' LINIE2P.BAS = Geradengleichung aus 2 Punkten berechnen
' ===========
' Der Anwender gibt die Koordinaten zweier Punkte ein.
' Daraus berechnet das Programm die Gleichung y = mx + t
' der Geraden durch diese beiden Punkte und zeigt sie
' als Graphen auf dem Bildschirm an. Die y-Werte muessen
' von 201 abgezogen werden, weil bei den QBasic-Grafik-
' Kordinatensystem die Y-Achse von oben nach unten zaehlt
' (in SCREEN 1 von 1 (oben) nach 200 (unten)).
' Die zwei eingegebenen Punkte sind im Graphen markiert.
' Der Graph kann nur dann korrekt angezeigt werden,
' wenn die beiden Punkte im SCREEN 1 darstellbar sind,
' also wenn x1,x2 zwischen 1 und 320 und y1,y2 zwischen
' 1 und 200 liegen.
'
' (c) Andreas Meile & Thomas Antoni, 19.1.04 - 21.1.04
'********************************************************
'
'----- Koordinate fuer die beiden Punkte eingeben
INPUT "Startpunkt, X-Kordinate (1...320)"; x1!
INPUT "Startpunkt, Y-Kordinate (1...200)"; y1!
PRINT
INPUT "Endpunkt,   X-Kordinate (1...320)"; x2!
INPUT "Endpunkt,   Y-Kordinate (1...200)"; y2!
'
'Sonderfall x1=x2 behandeln (senkrechte Gerade)
IF x1! = x2! THEN
  PRINT
  PRINT "Die Gerade ist eine Parallele zur y-Achse.";
  PRINT " Daher existiert die Normalform nicht."
  PRINT "Die Geradengleichung lautet x ="; x1!
  END  'Programm abbrechen
END IF
'
'----- Normalform ermitteln
m! = (y2! - y1!) / (x2! - x1!)
t! = y1! - m! * x1!
PRINT
PRINT "Die Geradengleichung lautet:"
PRINT "y ="; m!; "* x + "; t!
'
PRINT
PRINT "... Weiter mit beliebiger Taste"
d$ = INPUT$(1) 'Warten auf beliebige Taste
'
'----- Graph der Geraden anzeigen
SCREEN 1
FOR x% = CINT(x1!) TO CINT(x2!)
  y! = m! * CSNG(x%) + t!
  PSET (x%, CINT(201 - y!)), 2
NEXT x%
'   
PSET (x1!, 201 - y1!), 1
PSET (x2!, 201 - y2!), 1
d$ = INPUT$(1) 'Warten auf beliebige Taste
SCREEN 0
WIDTH 80, 25

