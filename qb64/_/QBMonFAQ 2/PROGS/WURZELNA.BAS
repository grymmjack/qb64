'*******************************************************************
' WURZELNA.BAS = Wurzelberechnung ueber ein Naeherungsverfahren
' ============
' Die Wurzel aus 2 wird ueber ein einfaches Naeherungsverfahren
' auf viele dutzend Stellen genau berechnet.
'
' Zunaechst definieren wir einen Anfangswert (hier 1.4).
' Diesen quadrieren wir. Ist das Ergebnis zu gross, also ueber 2,
' korrigieren wir den Wert etwas nach unten, ist er zu klein,
' korrigieren wir ihn nach oben. Dieses Spiel wird so lange
' wiederholt bis wir die richtige Ziffer haben.
'
' Die Berechnet geht relativ langsam vonstatten und kann jederzeit
' mit der Esc-Taste abgebrochen werden.
'
' (c) 2002 nach einer Programmidee von Wolfgang Lentner
'     wolfganglentner*web.de
'     http://wthlentner.cablenet.de/mathematik/rumpf.html
'*******************************************************************
DIM SHARED ziffer(1000), vielfaches(10, 1000), l(10), ergebnis(1000)
DIM SHARED laenge, endlaenge
ziffer(1) = 4
ziffer(2) = 1
laenge = 2
CLS
PRINT "Berechne die Wurzel aus 2 ...Abbruch mit Esc"
DO
  IF ziffer(laenge) = 1 THEN
    PRINT "NAEHERUNG: 1,";
  ELSE
   PRINT "NAEHERUNG: 2,";
  END IF
  FOR s = laenge - 1 TO 1 STEP -1
    PRINT LTRIM$(RTRIM$(STR$(ziffer(s))));
  NEXT s
  PRINT
'
'Vielfache berechnen
  FOR i = 1 TO 9
    uebertrag = 0
    FOR s = 1 TO laenge
      e = uebertrag + ziffer(s) * i
      vielfaches(i, s) = e MOD 10
      uebertrag = e \ 10
    NEXT s
    IF uebertrag > 0 THEN
      vielfaches(i, laenge + 1) = uebertrag
      l(i) = laenge + 1
    ELSE
      l(i) = laenge
    END IF
    FOR j = l(i) + 1 TO 1000
      vielfaches(i, j) = 0
    NEXT j
  NEXT i
'
'Einerziffer
  FOR i = 1 TO l(ziffer(1))
    ergebnis(i) = vielfaches(ziffer(1), i)
  NEXT i
  endlaenge = l(ziffer(1))
  FOR j = endlaenge + 1 TO 1000
    ergebnis(j) = 0
  NEXT j
'
'Restliche zu Ergebnis addieren
  FOR s = 2 TO laenge
    uebertrag = 0
    FOR i = 1 TO l(ziffer(s))
      e = ergebnis(s - 1 + i) + vielfaches(ziffer(s), i) + uebertrag
      ergebnis(s - 1 + i) = e MOD 10
      uebertrag = e \ 10
    NEXT i
    IF uebertrag = 0 THEN
      endlaenge = l(ziffer(s)) + s - 1
    ELSE
      endlaenge = l(ziffer(s)) + s
      ergebnis(l(ziffer(s)) + s) = uebertrag
    END IF
  NEXT s
'
'Ergebnis ausdrucken
  IF ergebnis(endlaenge) = 1 THEN
    PRINT "QUADRAT  : 1,";
  ELSE
    PRINT "QUADRAT  : 2,";
  END IF
  FOR s = endlaenge - 1 TO 1 STEP -1
    PRINT LTRIM$(RTRIM$(STR$(ergebnis(s))));
  NEXT s
  PRINT
  PRINT
'
'Naechste Naeherung
  IF ergebnis(endlaenge) = 1 THEN
    IF ziffer(1) < 9 THEN
      ziffer(1) = ziffer(1) + 1
    ELSE
      laenge = laenge + 1
      FOR i = laenge TO 2 STEP -1
        ziffer(i) = ziffer(i - 1)
      NEXT i
      ziffer(1) = 0
    END IF
  ELSE
    ziffer(1) = ziffer(1) - 1
    laenge = laenge + 1
    FOR i = laenge TO 2 STEP -1
      ziffer(i) = ziffer(i - 1)
    NEXT i
    ziffer(1) = 0
  END IF
LOOP UNTIL INKEY$ = CHR$(27)
END

