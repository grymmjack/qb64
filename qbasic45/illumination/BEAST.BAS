' *********** CHECK README.1ST FIRST *********************

DECLARE SUB GameScreen ()

DIM SHARED Mesta(1 TO 40, 1 TO 20), xb(50), yb(50), xi(50)

RANDOMIZE TIMER
PLAY "mb"
CLS

GameScreen

x = 2
y = 2

Mesta(2, 2) = 2
b = 0: c = 0
Tapot = 6

FOR i = 0 TO 5
 xi(i) = 1
NEXT

COLOR 10

LOCATE y, x: PRINT CHR$(2)

DO
_LIMIT 30

 a = INP(&H60)
 z$ = INKEY$
 PALETTE 0, 0
 b = b + 1
                                  ' right arrow-key
 IF (a = 77) AND (b > 5) THEN
   LOCATE y, x: PRINT " "
   Mesta(x, y) = 0
   x = x + 1
   IF Mesta(x, y) = 3 THEN GOTO Loppu
   IF Mesta(x, y) = 1 THEN
     FOR i = x + 1 TO 40
      
      IF Mesta(i, y) = 3 THEN
        IF Mesta(i + 1, y) = 0 OR Mesta(i + 1, y) = 3 THEN
          x = x - 1
          GOSUB 13
        END IF
        IF Mesta(i + 1, y) = 1 OR i = 39 THEN
          PLAY "L6 o0 c"
          Tapot = Tapot - 1
          FOR al = 1 TO 5
            IF xb(al) = i AND yb(al) = y THEN xi(al) = 0: LOCATE yb(al), xb(al): COLOR 2: PRINT "�": Mesta(i, y) = 1: GOSUB 13
          NEXT
        END IF
      END IF
      IF i = 40 THEN
        x = x - 1
        GOSUB 13
      END IF
      IF Mesta(i, y) = 0 THEN
        Mesta(i, y) = 1
        COLOR 2
        LOCATE y, i
        PRINT "�"
        EXIT FOR
      END IF
     NEXT
   END IF
13
   IF x > 39 THEN x = 39
   Mesta(x, y) = 2
   COLOR 10
   LOCATE y, x: PRINT CHR$(2)
   b = 0
 END IF

                                  ' left arrow-key
 IF (a = 75) AND (b > 5) THEN
   LOCATE y, x: PRINT " "
   Mesta(x, y) = 0
   COLOR 2
   x = x - 1
   IF Mesta(x, y) = 3 THEN GOTO Loppu
   IF Mesta(x, y) = 1 THEN
     FOR i = x - 1 TO 1 STEP -1
     
      IF Mesta(i, y) = 3 THEN
        IF Mesta(i - 1, y) = 0 OR Mesta(i - 1, y) = 3 THEN
          x = x + 1
          GOSUB 13
        END IF
        IF Mesta(i - 1, y) = 1 OR i = 2 THEN
          Tapot = Tapot - 1
          PLAY "L6 o0 c"
          FOR al = 1 TO 5
            IF xb(al) = i AND yb(al) = y THEN xi(al) = 0: LOCATE yb(al), xb(al): COLOR 2: PRINT "�": Mesta(i, y) = 1: GOSUB 13
          NEXT
        END IF

      END IF
      IF i = 1 THEN
        x = x + 1
        GOSUB 13
      END IF
      IF Mesta(i, y) = 0 THEN
        Mesta(i, y) = 1
        COLOR 2
        LOCATE y, i
        PRINT "�"
        EXIT FOR
      END IF
     NEXT
   END IF
14
   IF x < 2 THEN x = 2
   Mesta(x, y) = 2
   COLOR 10
   LOCATE y, x: PRINT CHR$(2)
   b = 0
 END IF

                                  ' down arrow-key
 IF (a = 80) AND (b > 5) THEN
   LOCATE y, x: PRINT " "
   Mesta(x, y) = 0
   COLOR 2
   y = y + 1
   IF Mesta(x, y) = 3 THEN GOTO Loppu
   IF Mesta(x, y) = 1 THEN
     FOR i = y + 1 TO 20
     
      IF Mesta(x, i) = 3 THEN
        IF Mesta(x, i + 1) = 0 OR Mesta(x, i + 1) = 3 THEN
          y = y - 1
          GOSUB 13
        END IF
        IF Mesta(x, i + 1) = 1 OR i = 19 THEN
          Tapot = Tapot - 1
          PLAY "L6 o0 c"
          FOR al = 1 TO 5
            IF xb(al) = x AND yb(al) = i THEN xi(al) = 0: LOCATE yb(al), xb(al): COLOR 2: PRINT "�": Mesta(x, i) = 1: GOSUB 13
          NEXT
        END IF
      END IF
      IF i = 20 THEN
        y = y - 1
        GOSUB 13
      END IF
      IF Mesta(x, i) = 0 THEN
        Mesta(x, i) = 1
        COLOR 2
        LOCATE i, x
        PRINT "�"
        EXIT FOR
      END IF
     NEXT
   END IF
15
   IF y > 19 THEN y = 19
   Mesta(x, y) = 2
   COLOR 10
   LOCATE y, x: PRINT CHR$(2)
   b = 0
 END IF

                                  ' up arrow-key
 IF (a = 72) AND (b > 5) THEN
   LOCATE y, x: PRINT " "
   Mesta(x, y) = 0
   y = y - 1
   IF Mesta(x, y) = 3 THEN GOTO Loppu
   IF Mesta(x, y) = 1 THEN
     FOR i = y - 1 TO 1 STEP -1
     
      IF Mesta(x, i) = 3 THEN
        IF Mesta(x, i - 1) = 0 OR Mesta(x, i - 1) = 3 THEN
          y = y + 1
          GOSUB 13
        END IF
        IF Mesta(x, i - 1) = 1 OR i = 2 THEN
          Tapot = Tapot - 1
          PLAY "L6 o0 c"
          FOR al = 1 TO 5
            IF xb(al) = x AND yb(al) = i THEN xi(al) = 0: LOCATE yb(al), xb(al): COLOR 2: PRINT "�": Mesta(x, i) = 1: GOSUB 13
          NEXT
        END IF
      END IF
      IF i = 1 THEN
        y = y + 1
        GOSUB 13
      END IF
      IF Mesta(x, i) = 0 THEN
        Mesta(x, i) = 1
        COLOR 2
        LOCATE i, x
        PRINT "�"
        EXIT FOR
      END IF
     NEXT
   END IF
16
   IF y < 2 THEN y = 2
   Mesta(x, y) = 2
   COLOR 10
   LOCATE y, x: PRINT CHR$(2)
   b = 0
 END IF

                                  ' Beast's moving
 IF c > 70 THEN
  
  FOR i = 1 TO 5
   IF xi(i) = 1 THEN
    LOCATE yb(i), xb(i): PRINT " "
    Mesta(xb(i), yb(i)) = 0
    IF xb(i) < x THEN xu = xb(i) + 1
    IF yb(i) < y THEN yu = yb(i) + 1
    IF xb(i) > x THEN xu = xb(i) - 1
    IF yb(i) > y THEN yu = yb(i) - 1
    IF xb(i) = x THEN xu = x
    IF yb(i) = y THEN yu = y
   
    IF Mesta(xu, yu) = 2 THEN
      LOCATE yu, xu:
      COLOR 14
      PRINT "H"
      GOTO Loppu
    END IF

    FOR yyy = yb(i) - 1 TO yb(i) + 1
     FOR xxx = xb(i) - 1 TO xb(i) + 1
      IF Mesta(xxx, yyy) = 0 THEN GOSUB 141
     NEXT
    NEXT
    Mesta(xb(i), yb(i)) = 0
    xi(i) = 0
    LOCATE yb(i), xb(i)
    PRINT " "
    GOSUB 35
141
    IF Mesta(xu, yu) > 0 THEN
      xu = xb(i) + INT(RND * 3) - 1
      yu = yb(i) + INT(RND * 3) - 1
      IF Mesta(xu, yu) > 0 THEN
        LOCATE yb(i), xb(i):
        COLOR 14
        PRINT "H"
        GOSUB 12
      END IF
    END IF
    xb(i) = xu: yb(i) = yu
    Mesta(xb(i), yb(i)) = 3
    COLOR 14
    LOCATE yb(i), xb(i): PRINT "H"
12
    Mesta(xb(i), yb(i)) = 3
35
   END IF
  NEXT
  FOR i = 1 TO 5
    IF xi(i) = 1 THEN PLAY "L18 o0 e": EXIT FOR
  NEXT
  c = 0
 END IF

 IF Tapot = 1 THEN GOTO Jees
 c = c + 1

LOOP UNTIL INP(&H60) = 1

CLS
COLOR 14
PRINT " H I R V I �  Betaversio  -  By Spirit / Illumination"
COLOR 7

END

Jees:

FOR i = 1 TO 50
 PALETTE 0, 0
NEXT
CLS
LOCATE 12, 25
COLOR 14
PRINT "Onnittelut! p��sit pelin l�pi ! ! !"
PLAY "mf"
PLAY "o2 L8 f L16 c L16 c L8 d c P8 e f"
FOR i = 1 TO 50
 PALETTE 0, 0
NEXT
CLS
COLOR 14
PRINT " H I R V I �  Betaversio  -  By Spirit / Illumination"
COLOR 7

END

Loppu:

PLAY "mf"
FOR i = 200 TO 50 STEP -1
 SOUND i, i / 1000
NEXT

CLS

LOCATE 12, 35
COLOR 4
PRINT "KUOLIT!"
FOR i = 1 TO 100
 PALETTE 0, 0
NEXT
CLS
COLOR 14
PRINT
PRINT " H I R V I �  Betaversio  -  By Spirit / Illumination"
COLOR 7

SUB GameScreen

COLOR 4
LOCATE 1
PRINT "                                                                      ۲ ۲"
PRINT "                                              ۲ ۲ ۲ ��۲  ۲ ۲ ۲  �۲� "
PRINT "                                              ۲�۲�۲�۲�۲ ۲�۲�۲�۲�۲�"
PRINT "                                              ���۲�۲���۲��۲�۲�۲�۲�۲�"
PRINT "                                              ۲�۲�۲�۲�۲�۲۲��۲�۲�۲�"
PRINT "                                              ۲�۲�۲�۲�۲� ۲�� ۲� �۲�� �"
PRINT "                                               �� �� �� �� ��  ��   ��  ���  "
PRINT
COLOR 7
PRINT
PRINT "                                                     Nuolet - ohjaa ukkoa"
PRINT "                                             Hirvi�t kuolevat j��dess��n kahden"
PRINT "                                             sein�n v�liin. Tapa kaikki hirvi�t!"
PRINT
PRINT "                                                   "; : COLOR 10: PRINT CHR$(2); : COLOR 7: PRINT " - sin�    "; : COLOR 14: PRINT "H"; : COLOR 7: PRINT " - Hirvi�"
PRINT
PRINT "                                                        Esc - Lopeta"
 COLOR 14

 FOR i = 1 TO 40
  Mesta(i, 1) = 4
  Mesta(i, 20) = 4
  LOCATE 1, i: PRINT "�"
  LOCATE 20, i: PRINT "�"
 NEXT
 FOR i = 1 TO 20
  Mesta(1, i) = 4
  Mesta(40, i) = 4
  LOCATE i, 1: PRINT "�"
  LOCATE i, 40: PRINT "�"
 NEXT

 COLOR 2

 FOR i = 1 TO 200
10
  x = INT(RND * 38) + 2
  y = INT(RND * 18) + 2
  IF Mesta(x, y) = 1 THEN GOSUB 10
  Mesta(x, y) = 1
  LOCATE y, x: PRINT "�"
 NEXT

COLOR 14

 FOR i = 1 TO 5
11
  x = INT(RND * 28) + 12
  y = INT(RND * 10) + 10
  IF Mesta(x, y) = 3 THEN GOSUB 11
  xb(i) = x
  yb(i) = y
  xi(i) = 0
  Mesta(x, y) = 3
  LOCATE y, x: PRINT "H"
 NEXT
 xi(1) = 1

END SUB

