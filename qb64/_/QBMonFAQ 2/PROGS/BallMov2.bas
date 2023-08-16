'****************************************************************
' BALLMOV2.BAS = Page Flipping Demo - Bouncing Balls with cursor
'                  control
'                Page-Flipping-Demo - Fliegende Baelle mit
'                  Cursorsteuerung
'
' Deutsche Beschreibung
' ---------------------
' Dieses Q(uick)Basic-Programm demonstriert, wie man mehrere
' Bildschirmseiten verwendet ("Page-Flipping"), um sehr
' ansprechende, ruckelfreie und fluessig animierte Grafikzu
' erzeugen. Mehere Baelle fliegen ueber den Bildschirm und stossen
' sich voneiander und von den Bildschirmraendern ab. Ein
' zusaetzlicher weisser ball kann mit den Cursortasten beweg
' werden
'
' English Description
' ---------------------
' This Q(uick)Basic program demonstrates how to use screen pages
' for generatiing flickerfree and smooth graphic animations.
' Arrow keys move a white ball.
'
'******************************************************************
'
'
GOSUB BuildPage2: 'Contains the background. We will PCOPY Page2
'                  to Page0 and Page1 before painting a ball
'                  and swapping pages for animation.
'
GOSUB GameInit: ' Set up to paint and move circle, init
'
DO: GOSUB GameMove: LOOP WHILE k$ <> CHR$(27)
'
SCREEN 0: WIDTH 80, 25: CLS : 'Leave properly
SYSTEM
'
BuildPage2: '================================================
' Set active page to 2 (Leave visualpage as 0)
SCREEN 7, , 2, 0
' Draw a complex background (on Page2 while user sees Page0)
FOR t = 1 TO 100
  LINE (160, 100)-(RND * 320, RND * 200), RND * 14
NEXT t
RETURN
'
'
GameInit: '=======================================
TYPE Ball
  x AS SINGLE
  xi AS SINGLE
  y AS SINGLE
  yi AS SINGLE
  snd AS INTEGER
  clr AS INTEGER
END TYPE
CONST NumBalls = 3
DIM Ball(NumBalls) AS Ball
' Now set active page to 1 (Leave visualpage as 0)
SCREEN 7, , 1, 0
Active = 1: ' A flag to show that Page1 is now active
'Circle definitions
FOR i = 1 TO NumBalls
  READ Ball(i).snd: READ Ball(i).clr
  READ Ball(i).x: READ Ball(i).y
  READ Ball(i).xi: READ Ball(i).yi
NEXT i
'
DATA 350,2,50,50,-.5,1.4
DATA 220,4,150,150,.7,-.95
DATA 290,6,220,175,1.4,.63
DATA 40,8,88,88,.8,-.88
'Radius of circles
r% = 10
px = 100: py = 100: pc = 15: 'Start Paddle
'
GOSUB PaddleMove
RETURN
'
PaddleMove:
k$ = INKEY$: IF k$ = "" THEN RETURN
IF k$ = CHR$(27) THEN RETURN
IF LEN(k$) = 1 THEN k% = ASC(k$) ELSE k% = 300 + ASC(RIGHT$(k$, 1))
SELECT CASE k%
CASE 372, 56: py = py - 1
CASE 377, 54: px = px + 1
CASE 380, 50: py = py + 1
CASE 375, 52: px = px - 1
END SELECT
RETURN
'
GameMove:
GOSUB PaddleMove
GOSUB CircleMove
RETURN
'
CircleMove:
' Copy the background to the activepage.
PCOPY 2, Active
' Determine next circle coordinates
MakeBeep = 0
FOR i = 1 TO NumBalls
Ball(i).x = Ball(i).x + Ball(i).xi
Ball(i).y = Ball(i).y + Ball(i).yi
IF (Ball(i).x < r% OR Ball(i).x > 320 - r%) THEN Ball(i).xi = Ball(i).xi * (-1): MakeBeep = Ball(i).snd
IF (Ball(i).y < r% OR Ball(i).y > 200 - r%) THEN Ball(i).yi = Ball(i).yi * (-1): MakeBeep = Ball(i).snd
q = SQR(((Ball(i).x - px) ^ 2) + ((Ball(i).y - py) ^ 2))
IF q < (2 * r%) THEN
  MakeBeep = Ball(i).snd
  Testx = Ball(i).x - (Ball(i).xi)
  Testy = Ball(i).y + (Ball(i).yi)
  q = SQR(((Testx - px) ^ 2) + ((Testy - py) ^ 2))
  IF q > (2 * r%) THEN
     Ball(i).xi = Ball(i).xi * -1
  ELSE
     Ball(i).yi = Ball(i).yi * -1
  END IF
END IF
'
' Draw the circle in its next position
CIRCLE (Ball(i).x, Ball(i).y), r%, 15
PAINT (Ball(i).x, Ball(i).y), Ball(i).clr, 15
NEXT i
CIRCLE (px, py), r%, 15
PAINT (px, py), pc, 15
'
' Flip the activepage to be the visualpage and vice-versa
IF Active = 1 THEN
  Active = 0: SCREEN 7, , 0, 1
ELSE
  Active = 1: SCREEN 7, , 1, 0
END IF
IF MakeBeep > 0 THEN SOUND MakeBeep, 1
' Delay loop
WAIT &H3DA, 8
WAIT &H3DA, 8, 8
RETURN

