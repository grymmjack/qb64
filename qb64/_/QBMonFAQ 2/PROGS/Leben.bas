'******************************************************
' LEBEN.BAS = Das Spiel des Lebens
' =========
' Dieses QBasic-Programm simuliert das Zellwachstum.
' Die Regeln hierfÅr wurden 1970 vom britischen
' Mathematiker Conway festgelegt und lassen sich durch
' zwei einfache Vorschriften definieren:
'  - Besetze synchron alle leeren Zellen, die genau
'    drei Nachbarn haben.
'  - Lîsche gleichzeitig (!) alle Zellen, die weniger
'    als zwei oder mehr als drei Nachbarn haben.
'
' (c) Skilltronic (skillfinger*gmx.de), 18.6.2004
'******************************************************
SCREEN 0
CLS
zeichen$(0) = CHR$(32)
zeichen$(1) = CHR$(2)
breite = 30
hoehe = 20
DIM vg(breite - 1, hoehe - 1)
DIM hg(breite - 1, hoehe - 1)
Zellen = FIX(breite * hoehe / 3)
RANDOMIZE TIMER
'
FOR a = 1 TO Zellen
zufall:
  r = FIX(RND * breite * hoehe)
  x = FIX(r / hoehe)
  y = r - x * hoehe
  IF vg(x, y) = 1 THEN GOTO zufall
  vg(x, y) = 1
  hg(x, y) = 1
  LOCATE y + 1, x + 1
  PRINT zeichen$(vg(x, y))
NEXT
'
DO
FOR x = 0 TO breite - 1
  FOR y = 0 TO hoehe - 1
    Nachbarn = 0 - vg(x, y)
    FOR m = -1 TO 1
      xt = x + m
      IF xt = -1 THEN xt = xt + breite
      IF xt = breite THEN xt = xt - breite
      FOR n = -1 TO 1
        yt = y + n
        IF yt = -1 THEN yt = yt + hoehe
        IF yt = hoehe THEN yt = yt - hoehe
        Nachbarn = Nachbarn + vg(xt, yt)
      NEXT
    NEXT
    IF Nachbarn < 2 OR Nachbarn > 3 THEN hg(x, y) = 0
   IF Nachbarn = 3 THEN hg(x, y) = 1
  NEXT
NEXT
'
FOR x = 0 TO breite - 1
  FOR y = 0 TO hoehe - 1
    LOCATE y + 1, x + 1
    IF vg(x, y) <> hg(x, y) THEN PRINT zeichen$(hg(x, y))
    vg(x, y) = hg(x, y)
  NEXT
NEXT
'
zeit = TIMER + .2
DO: LOOP UNTIL TIMER > zeit 'Wartezeit .2 sec
LOOP WHILE INKEY$ = ""      'Abbruch mit belieb.Taste
END

