DEFINT A-Z

REM  Mole 1.1
REM  Copyright 1995 Whizbang Productions
REM  email to gregorfa@delphi.com
REM  To run - save this as mole.bas and type qbasic /run mole

DIM face(2000)
DIM star(2000)
DIM dot(2000)
DIM black(2000)
DIM xc(9)
DIM yc(9)

SCREEN 12
WIDTH 80, 60

REM  find out how many times we have to loop for one second...

TIMER ON

ON TIMER(1) GOSUB PrintCount
k = 1
FOR i = 1 TO 10000
k = 1
FOR j = 1 TO 1000
k = k + 1
NEXT j
NEXT i

GOSUB LoadMouse

GOSUB MouseInit

x1 = 0
x2 = 679
y1 = 26
y2 = 479
GOSUB MouseRange

PI = 3

CIRCLE (320, 240), 30, 1
PAINT (320, 240), 2, 1
CIRCLE (332, 230), 3, 1
PAINT (332, 230), 8, 1
CIRCLE (308, 230), 3, 1
PAINT (308, 230), 8, 1
CIRCLE (320, 240), 3, 1
CIRCLE (320, 255), 10, 1, PI, 0, .75
   
GET (290, 270)-(350, 210), face
   
CIRCLE (100, 100), 2, 11
PAINT (100, 100), 11
GET (98, 102)-(102, 98), dot
PAINT (100, 100), 0


PAINT (320, 240), 0
   
GET (290, 280)-(350, 210), black
  
LINE (320, 240)-(340, 220), 4
LINE (340, 220)-(330, 260), 4
LINE (330, 260)-(340, 280), 4
LINE (340, 280)-(320, 260), 4
LINE (320, 260)-(300, 280), 4
LINE (300, 280)-(310, 250), 4
LINE (310, 250)-(290, 210), 4
LINE (290, 210)-(320, 240), 4
PAINT (325, 245), 4
GET (290, 210)-(350, 280), star
CLS


   xc(1) = 60
   xc(2) = 290
   xc(3) = 520
   yc(1) = 30
   yc(2) = 220
   yc(3) = 400
   FOR i = 1 TO 3
     FOR j = 1 TO 3
       PUT (xc(i), yc(j)), face
       NEXT j
     NEXT i
CLS
COLOR 15
LOCATE 25, 15
PRINT "W E L C O M E    to     MMM   OOO   LLL   EEE   !!!"
LOCATE 30, 15
PRINT "        Copyright 1995 Whizbang Productions"
 
PRINT
LOCATE 35, 15

PRINT "          Use your mouse to WHACK the MOLE"
SLEEP 5
CLS


level = 1

startup:
GOSUB moleup
SLEEP 1
timeleft = 60
hitcol = 10
COLOR 14
hits = 0
LOCATE 1, 1
PRINT "HITS:"
PRINT "LEVEL:"
PRINT "TIME:"
LOCATE 1, 7
PRINT hits
LOCATE 2, 7
PRINT level

starttime& = TIMER
lasttime& = starttime&
GOSUB Mouseshow
LOCATE 4, 1

REM  set time bar......
timecol = 11
FOR i = 1 TO 60
COLOR 4
LOCATE 3, timecol
PRINT CHR$(219)
timecol = timecol + 1
NEXT i

LOCATE 3, 7
PRINT timeleft

MainLoop:

DO UNTIL INKEY$ <> ""

currtime& = TIMER

GOSUB MouseStatus

IF lb THEN
  x = xMouse
  y = yMouse
  GOSUB button
  END IF

REM   change every second.....

GOSUB DelayLoop

 IF currtime& > lasttime& THEN

   COLOR 0
   LOCATE 3, timecol
   GOSUB MouseHide
   PRINT CHR$(219)
   COLOR 4
   LOCATE 3, 7
   PRINT timeleft
   GOSUB Mouseshow
   timecol = timecol - 1
   timeleft = timeleft - 1
  
   lasttime& = currtime&
  END IF
IF timecol = 10 THEN
   GOSUB GameOver
  
END IF

GOSUB moleup

LOOP

END

button:
LOCATE 4, 1
REM  x; y
x1 = x
y1 = y
GOSUB MouseHide

z = POINT(x, y)

GOSUB Mouseshow

 FOR i = 1 TO 1000
 NEXT

GOSUB MouseHide

GOSUB Mouseshow
 IF z > 0 THEN

    hitcol = hitcol + 1
 PLAY "mf t100 l64 o5 c"
    COLOR 14
    LOCATE 1, hitcol
    PRINT CHR$(1)
   
    LOCATE 1, 7
    hits = hits + 1
    PRINT hits
    IF hits = 50 THEN
       GOSUB GameOver
       END IF



IF (x1 < 120) THEN
      x3 = 60
      ELSE
      IF (x1 > 500) THEN
      x3 = 520
      ELSE
      x3 = 290
      END IF
    END IF
    IF (y1 < 100) THEN
      y3 = 30
      ELSE
      IF (y1 > 300) THEN
      y3 = 400
      ELSE
      y3 = 220
      END IF
     END IF
GOSUB MouseHide
IF x < 31 THEN
   x = 31
   END IF
IF y > 444 THEN
   y = 444
   END IF

IF y < 35 THEN
   y = 35
   END IF


PUT (x - 30, y - 35), star, XOR
GOSUB Mouseshow

    FOR j = 1 TO 2000
       NEXT j
GOSUB MouseHide
  PUT (x - 30, y - 35), star, XOR
  PUT (x3, y3), black, AND

GOSUB Mouseshow

   
    END IF

RETURN

moleup:
n = INT((9 - 1 + 1) * RND + 1)
FOR i = 1 TO n
i2 = INT(3 * RND + 1)
j2 = INT(3 * RND + 1)
sel = INT(2 * RND)
GOSUB MouseHide
IF (sel = 1) THEN

   PUT (xc(i2), yc(j2)), black, AND
   ELSE
   PUT (xc(i2), yc(j2)), face
   END IF
 GOSUB Mouseshow
 NEXT

RETURN

MouseStatus:
  REM ...ax=3 gives current state....ax=5 gives state at last press
  REM ...ax=6 gives state at last release
  ax = 6
  GOSUB MouseDriver
  lb = ((bx AND 1) <> 0)
  rb = ((bx AND 2) <> 0)
  xMouse = cx
  yMouse = dx
RETURN

MouseHide:
 ax = 2
 bx = 0
 cx = 0
 dx = 0
 
 
GOSUB MouseDriver
RETURN

MousePut:
  ax = 4
  bx = 0
  cx = x
  dx = y
  GOSUB MouseDriver
RETURN


MouseRange:
REM MouseRange: (x1 , y1 , x2 , y2 )
  ax = 7
  bx = 0
  cx = x1
  dx = x2
  GOSUB MouseDriver
  ax = 8
  cx = y1
  dx = y2
  GOSUB MouseDriver
RETURN

Mouseshow:
  ax = 1
  bx = 0
  cx = 0
  dx = 0
  GOSUB MouseDriver
RETURN

MouseInit:

   ax = 0
   bx = 0
   cx = 0
  dx = 0
  GOSUB MouseDriver

IF ax = 0 THEN
   PRINT "You need a mouse installed to play MOLE....sorry...."
   SYSTEM
   END IF
   RETURN

MouseInfo:
ax = 37
bx = 0
cx = 0
dx = 0
GOSUB MouseDriver
RETURN


PrintCount:
LOCATE 4, 1
onesecondi = i
onesecondj = j
delay = onesecondi

PRINT i; j
i = 32001
REM SLEEP 5
TIMER OFF
RETURN

DelayLoop:
GOSUB MouseStatus

IF lb THEN
  x = xMouse
  y = yMouse
  GOSUB button
  END IF


k = 1
FOR ii = 1 TO delay
GOSUB MouseStatus

IF lb THEN
  x = xMouse
  y = yMouse
  GOSUB button
  END IF
k = 1
FOR j = 1 TO 1000
k = k + 1
NEXT j
NEXT ii
RETURN


GameOver:
   keyin$ = ""
   LOCATE 4, 1
   COLOR 13
  
IF hits > 49 THEN
   PRINT "            Y   O  U      W   I   N   !!!!!      C to continue / Q to quit"
   ELSE
   PRINT "             g   a    m   e    o  v  e  r        P to play again / Q to quit"
                          
   END IF
   WHILE keyin$ = ""
   keyin$ = INKEY$
   WEND
IF hits > 49 THEN
level = level + 1
delay = .75 * delay
END IF
IF keyin$ = "q" THEN
   SYSTEM
   END IF
IF keyin$ = "p" OR keyin$ = "c" THEN
   LOCATE 4, 1
   COLOR 0
   PRINT "                                                                             "
   LOCATE 1, 9
   PRINT "                                                               "
   GOTO startup
   END IF
  
  
   END
RETURN

LoadMouse:
DIM Mouseprog(29)
DEF SEG = VARSEG(Mouseprog(0))
FOR i = 0 TO 56
READ j
POKE (VARPTR(Mouseprog(0)) + i), j
NEXT i
DEF SEG
RETURN

MouseDriver:
DEF SEG = VARSEG(Mouseprog(0))
CALL Absolute(ax, bx, cx, dx, VARPTR(Mouseprog(0)))
DEF SEG
RETURN

DATA &H55,&H8B,&HEC,&H8B,&H5E,&H0C,&H8B,&H07
DATA &H50,&H8B,&H5E,&H0A,&H8B,&H07,&H50,&H8B
DATA &H5E,&H08,&H8B,&H0F,&H8B,&H5E,&H06,&H8B
DATA &H17,&H5B,&H58,&H1E,&H07,&HCD,&H33,&H53
DATA &H8B,&H5E,&H0C,&H89,&H07,&H8B,&H5E,&H0A
DATA &H58,&H89,&H07,&H8B,&H5E,&H08,&H89,&H0F
DATA &H8B,&H5E,&H06,&H89,&H17,&H5D,&HCA,&H08
DATA &H00

