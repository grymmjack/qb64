'***********************************************************
' PULLDOWN.BAS = Pulldown-Menue anzeigen und bearbeiten                                                    
' ============
' Der augenblickliche Bildschirminhalt wird durch ein
' Pulldown-Menue ueberschrieben. Mit den Cursur-Tasten
' laesst sich der gewuenschte Menuepunkt anwaehlen und
' mit der Eingabetaste aktivieren. Anschliessend wird
' der ueberschriebene Bildschirmausschnitt wieder
' hergestellt. Das sich weitgehend selbst erklaerende
' Demoprogramm laesst sich leich an Deine eigenen
' Beduerfnisse anpassen.
'
' 1.7.2005, nach einer Programmidee von Juergen Hueckstaedt
'***********************************************************
DECLARE SUB pulldown (ze%, sp%, br%, anz%, i%, v%, h%, menue$(), retten$())

' Hauptprogramm (Demo fr Pulldown-Menue-SUB)

DEFINT A-Z
CLS
ze = 10: ' Zeile fr Eckpunkt links oben (Rand)
sp = 20: ' dito Spalte
br = 14: ' Breite Menfeld ohne Rand
v = 7: ' Vordergrundfarbe
h = 0: ' Hintergrundfarbe
:
DIM menue$(20), retten$(20)

'Menfelderdaten einlesen
RESTORE daten:
i = 1
DO
  READ m$
  IF m$ = "ende" THEN EXIT DO
  menue$(i) = " " + LEFT$(m$ + SPACE$(br), br - 1)
  i = i + 1
LOOP UNTIL menue$(i - 1) = "ende"
anz = i - 1
:
' Bildschirm probeweise mit Text fllen
text$ = "Diese Fl„che wird durch das Pull-down-Men berschrieben "
   text$ = text$ + "und wiederhergestellt."
   FOR t = 1 TO 22
     PRINT text$
   NEXT t
:
' Aufruf Prozedur
CALL pulldown(ze, sp, br, anz, i, v, h, menue$(), retten$())
:
' Abschluá
LOCATE 24, 1
COLOR v, h
BEEP
PRINT "Sie haben soeben den Menpunkt"; i; " angew„hlt";
END
:
daten:
DATA "Menpunkt  1"
DATA "Menpunkt  2"
DATA "Menpunkt  3"
DATA "Menpunkt  4"
DATA "Menpunkt  5"
DATA "Menpunkt  6"
DATA "Menpunkt  7"
DATA "Menpunkt  8"
DATA "Menpunkt  9"
DATA "Menpunkt 10"
DATA "ende"

SUB pulldown (ze, sp, br, anz, i, v, h, menue$(), retten$())
'***********************************************************
' PULLDOWN = SUB fr Pull-down Men
' -----------------------------------
' Von der Prozedur bernommene Argumente:
' ze  = Zeile obere linke Menecke
' sp  = Spalte obere linke Menecke
' br  = Breite des Mens in Zeichen
' anz = Anzahl der darzustelleneden Menfelder (-punkte)
' i   = Menfeld-Z„hler, wird fr das ausgew„hlte Feld an
'       das aufrufende Programm zurckgegeben
' v   = Vordergrundfarbe
' h   = Hintergrundfarbe
' menue$()  = Array zur Aufnahme der
'             Menfeldbeschriftungen
' retten$() = Array zur Aufnahme des geretteten
'           Bildschirminhaltes.
'************************************************************
'
' Ausschnitt retten
FOR k% = 0 TO anz + 1
retten$(k%) = ""
  FOR l% = 0 TO br + 1
  r% = SCREEN(ze + k%, sp + l%)
  retten$(k%) = retten$(k%) + CHR$(r%)
  NEXT l%
NEXT k%
:
' Rahmen zeichnen
LOCATE ze, sp
PRINT CHR$(201); STRING$(br, CHR$(205)); CHR$(187)
FOR i = 1 TO anz
  LOCATE ze + i, sp
  PRINT CHR$(186); SPACE$(br); CHR$(186);
NEXT i
LOCATE ze + i, sp
PRINT CHR$(200); STRING$(br, CHR$(205)); CHR$(188)
:
' Daten eintragen
spt = sp + 1
COLOR v, h
FOR i = 1 TO anz
  LOCATE ze + i, spt
  PRINT menue$(i)
NEXT i
:
' Mensteuerung
i = 1
DO
LOCATE ze + i, spt
COLOR h, v
PRINT menue$(i)
a$ = ""
DO WHILE a$ = ""
  a$ = INKEY$
LOOP
a = ASC(LEFT$(a$, 1)): b = 0
IF a = 0 THEN b = ASC(RIGHT$(a$, 1))
IF a = 13 THEN
  EXIT DO
:
' Feld abw„rts
ELSEIF b = 80 OR a = 32 THEN
  LOCATE ze + i, spt
  COLOR v, h
  PRINT menue$(i)
  i = i + 1
  IF i > anz THEN i = 1
:
' Feld aufw„rts
ELSEIF b = 72 THEN
  LOCATE ze + i, spt
  COLOR v, h
  PRINT menue$(i)
  i = i - 1
  IF i < 1 THEN i = anz
END IF
LOOP
:
' Ausschnitt wiederherstellen
COLOR v, h
FOR k% = 0 TO anz + 1
  LOCATE ze + k%, sp
  PRINT retten$(k%)
NEXT k%
:
END SUB

