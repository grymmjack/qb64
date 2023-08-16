'******************************************************************
' BALLMOVE.BAS = Page Flipping Demo - Bouncing Ball while
' ============     preserving background
'                 Page-Flipping-Demo - Fliegender Ball, der den
'                  Hintergrund nicht zerstoert
'
' Deutsche Beschreibung
' ---------------------
' Dieses Q(uick)Basic-Programm demonstriert, wie man mehrere
' Bildschirmseiten verwendet ("Page-Flipping"), um ruckelfreie
' und fluessig animierte Grafik zu erzeugen.
'
' English Description
' ---------------------
' This Q(uick)Basic program demonstrates how to use screen pages
' for generatiing flickerfree and smooth graphic animations.
'
'******************************************************************
'
GOSUB BuildPage2: 'Contains the background. We will PCOPY Page2
'                  to Page0 and Page1 before painting a ball
'                  and swapping pages for animation.
'
GOSUB CircleInit: ' Set up to paint and move circle
'
DO: GOSUB CircleMove: LOOP WHILE INKEY$ <> CHR$(27)
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
CircleInit: '=======================================
' Now set active page to 1 (Leave visualpage as 0)
SCREEN 7, , 1, 0
Active = 1: ' A flag to show that Page1 is now active
'Circle start position and direction
x = 50: y = 50: xi = -1: yi = 1
'Radius of circle
r% = 10
RETURN
'
CircleMove:
' Copy the background to the activepage.
PCOPY 2, Active
' Determine next circle coordinates
x = x + xi: IF (x < r% OR x > 320 - r%) THEN xi = xi * (-1): SOUND 350, 2
y = y + yi: IF (y < r% OR y > 200 - r%) THEN yi = yi * (-1): SOUND 350, 2
' Draw the circle in its next position
CIRCLE (x, y), r%, 15
PAINT (x, y), 15, 15
' Flip the activepage to be the visualpage and vice-versa
IF Active = 1 THEN
  Active = 0: SCREEN 7, , 0, 1
ELSE
  Active = 1: SCREEN 7, , 1, 0
END IF
' Delay loop
WAIT &H3DA, 8
WAIT &H3DA, 8, 8
't = TIMER + .01: DO: LOOP UNTIL t <= TIMER
RETURN

