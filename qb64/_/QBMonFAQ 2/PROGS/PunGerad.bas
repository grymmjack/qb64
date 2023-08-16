'*******************************************************************
' PUNGERAD.BAS = Abstand eines Punktes von einer Geraden berechnen
' ============
' Dieses Q(uick)Basic-Programm berechnet den Abstand eines Punktes
' P1(x1|y1) von der Geraden y = mx + t (m ist die Steigung und t
' der Y-Achsenabschnitt)
'
' (c) stef und MisterD, 18.3.2005
'*******************************************************************
DECLARE FUNCTION Abstand (x1, y1, m, t)
DO
CLS
PRINT "Punkt P1(x1y1) eingeben"
PRINT
INPUT " Gib die x-Koordinate des Punktes ein:.....x1 = ", x1
INPUT " Gib die y-Koordinate des Punktes ein:.....y1 = ", y1
PRINT
PRINT
PRINT "Gerade y=mx+t eingeben"
PRINT
INPUT " Gib die Steigung m ein:...................m = ", m
INPUT " Gib den y-Achsenabschnitt t ein:..........t = ", t
PRINT
PRINT
PRINT "Der Abstand des Punktes P1 von der Geraden g betraegt a =";
PRINT Abstand(x1, y1, m, t)
PRINT
PRINT
PRINT "Neue Berechnung...[Beliebige Taste] ______ Beenden...[Esc] "
DO: Taste$ = INKEY$: LOOP UNTIL Taste$ <> "" 'Warten auf Tastendruck
IF Taste$ = CHR$(27) THEN END
LOOP

'
FUNCTION Abstand (x1, y1, m, t)
'*******************************************************************
'Abstandes des Punktes P1(x1|y) von der Geraden g (y=mx+t) berechnen
   IF m <> 0 THEN
      m2 = -1 / m              'Steigung der "Lotgeraden" von P1 auf g
      t2 = y1 - m2 * x1        'y-Achsenabschnitt der Lotgeraden
      x2 = (t2 - t) / (m - m2) 'x- und y-Koordinaten des...
      y2 = m * x2 + t          '...Lotfusspunktes
      Abstand = SQR((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
   ELSE                 'Sonderfall: g ist eine Parallele zur x-Achse 
      Abstand = ABS(y1 - t)
   END IF
END FUNCTION

