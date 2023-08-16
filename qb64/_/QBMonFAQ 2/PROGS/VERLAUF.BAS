'************************************************************
' VERLAUF.BAS - Farbverlaeufe mit QBasic realisieren
' ===========
' Dieses QBasic-Programm fragt erst die Anfangs- und dann
' die Endfarbe vom Anwender ab, und zwar jeweils als
' RGB-Farbkombination der Farben Rot, Gruen und Blau .
' Anschliessend wird auf dem gesamten Bildschirn ein
' weich uebergeblendeter Farbverlauf von der Anfangs-
' zur Endfarbe angezeigt.
'
' (c) Peter Vollenweider (peter.vollenweider*gmx.ch)
'     26.2.2003
'************************************************************
DECLARE SUB getnum (text$, var%)
DECLARE SUB setpal (num%, r%, g%, b%)
DEFINT A-Z
SCREEN 12: maxscreenx = 639: maxscreeny = 479: farben = 15
PRINT "Farbe 1"
getnum " Rot:   (0-63) ", r1
getnum " Gruen: (0-63) ", g1
getnum " Blau:  (0-63) ", b1
PRINT
PRINT "Farbe 2"
getnum " Rot:   (0-63) ", r2
getnum " Gruen: (0-63) ", g2
getnum " Blau:  (0-63) ", b2
farbe2 = farben
'
FOR farbe = 0 TO farben
  r = (r2 * farbe + r1 * farbe2) / farben
  g = (g2 * farbe + g1 * farbe2) / farben
  b = (b2 * farbe + b1 * farbe2) / farben
  farbe2 = farbe2 - 1
  setpal farbe, r, g, b
NEXT
'
FOR farbe = 0 TO farben
  x1 = maxscreenx * farbe / farben
  x2 = maxscreenx * (farbe + 1) / farben - 1
  deltax = x2 - x1
  FOR x = x1 TO x2
    count = INT(RND * deltax)
    FOR y = 0 TO maxscreeny
      count = count + x - x1
      IF count > x2 - x1 THEN
        a& = a& + 1
        count = count + x1 - x2
        farb = farbe + 1
      ELSE farb = farbe: b& = b& + 1
      END IF
      PSET (x, y), farb
    NEXT y
  NEXT x
NEXT farbe

'
SUB getnum (text$, var)
zeile = CSRLIN
DO
LOCATE zeile: PRINT text$; : INPUT "", var
LOOP UNTIL var >= 0 AND var < 64
END SUB

'
SUB setpal (num, r, g, b)
OUT 968, num
OUT 969, r
OUT 969, g
OUT 969, b
END SUB

