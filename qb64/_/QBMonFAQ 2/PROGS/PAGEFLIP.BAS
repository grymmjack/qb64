'***********************************************************
' PAGEFLIP.BAS = Page Flipping Demo - Bildschirmseiten mit
' ============   SCREEN umschalten
'
' Dieses Q(uick)Basic-Programm demontriert die Verwendung
' mehrer Bildschirmseiten und das schnelle Umschalten
' zwischen diesen - das sogenannte "Page Flipping" - mit
' dem SCREEN-Befehl. Der SCREEN-Befehl hat folgende Syntax:
'
'   SCREEN Bildschirmmodus, , Arbeitsseite, Anzeigeseite
'
' In der Arbeitsseite kann man im Hintergrund unsichtbar
' das naechste Bild aufbauen, indem man in die Seite Texte
' und Grafikelemente einfuegt. In einem Rutsch kann man dann
' mit SCREEN die Arbeitsseite blitzschnell zur Anzeigeseite
' machen. So sind butterweiche Animationen ohne Flimmern
' moeglich.
'
' Das Programm verwendet den Bildschirmmodus SCREEN 8
' (EGA-Bildschirm 640 x 200 Pixel, 16 Farben und 4 Bild-
' schirmseiten Nr. 0...3).
'
' In die Bildschirmseite 1 wird ein violetter Text und ein
' violettes Rechteck eingetragen, in die Bildschirmseite 2
' ein gelber Text und ein gelber Kreis. Mit den Tasten "1"
' und "2" kann der Anwender dann zwischen den beiden
' Bildschirmseiten hin- und herschalten.
'
' (c) Thomas Antoni, 18.2.2006
'       (nach einer Idee von Herbert Hackelsberger)
'************************************************************
'
CLS
'
'------- Arbeitsseite=1 und Anzeigeseite=1
SCREEN 8, , 1, 1
COLOR 5                       'violette Schrift- u.Malfarbe
LOCATE 1, 1
PRINT "Bildschirmseite 1. Umschalten mit Taste 2"
LINE (10, 50)-(150, 120), , B 'gelbes Rechteck (Box) malen
'
'----- Arbeitsseite=2, Anzeigeseite bleibt=1
SCREEN 8, , 2, 1
LOCATE 1, 1
COLOR 14                      'gelbe Schrift- und Malfarbe
PRINT "Bildschirmseite 2. Umschalten mit Taste 1"
CIRCLE (100, 100), 50         'gelben Kreis malen
'
'----- Bildschirmseiten je nach Taste "1" u."2" umschalten
DO
  A$ = INKEY$
  IF A$ = "1" THEN SCREEN 8, , 1, 1   'Umschalt. auf 1. Seite
  IF A$ = "2" THEN SCREEN 8, , 2, 2   'Umschalt. auf 2. Seite
LOOP UNTIL A$ = CHR$(27)              'Beenden mit Esc
SCREEN 0
END



