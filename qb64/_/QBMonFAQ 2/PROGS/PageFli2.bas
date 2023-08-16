'*********************************************************
' PAGEFLI2.BAS = Page flipping demo for Screen 9
' ============   Demo fuer Page-Flipping in SCREEN 9
'
' Deutsche Beschreibung
' ---------------------
' (von Thomas Antoni)
' Dieses Q(uick)Basic-Programm demonstriert die Verwendung
' zweier Bildschirmseiten im Grafik-SCREEN 9 zum Erzeugen
' flimmerfreier und fluessiger Animationen. Ein aufwaendig
' gestaltetes Raumschiff fliegt ueber den Bildschirm durch
' Meteor-Explosionen hindurch
'
' English Description
' ---------------------
' (by Thomas Antoni)
' This Q(uick)Basic programm demonstrates how to use
' two screen pages in gephic SREEN 9 tu generate flicker-
' free and smooth animations. A nicely designed space ship
' flies over the screen through meteor explosions.
'
'
'*********************************************************
'---------------- P A G I N G . B A S -----------------
'------------- SCREEN 9 PAGING EXAMPLE ----------------
'--------- Uses compressed DATA to draw Ship ----------
'-------- By Bob Seguin: BOBSEG*sympatico.ca ----------
'*********************************************************
'
'
' There are two pages: Page0 and Page1
' SCREEN 9,,0,1 Displays Page1 while you write Page0
ActivePAGE = 0 'All screen write commands will goto Page0
VisualPAGE = 1 'The page to be viewed is Page1
SCREEN 9, , ActivePAGE, VisualPAGE '(Makes the above true)
' We are now looking at Page1 while working on Page0
' This program demonstrates how swapping pages improves animation
'
GOSUB InitProgram 'Prepare icons, etc.
'
FOR x = 6 TO 546 STEP 2 'main loop wherein ship will
'                        travel 540 pixels in steps
'                        of two
  IF INKEY$ = " " THEN EXIT FOR
  GOSUB WriteActive
  SWAP ActivePAGE, VisualPAGE '          <-- NOW YOU SEE HOW
  SCREEN 9, , ActivePAGE, VisualPAGE '   <-- THIS WORKS
'  WAIT &H3DA, 8 (may need these commands on some systems)
'  WAIT &H3DA, 8, 8
NEXT x
SCREEN 0, 0, 0, 0: CLS
SYSTEM
'
'====================================================

' Declaration of variables
DIM ShipBOX(6000)
TYPE RockTYPE ' Establish data TYPE for meteors
  Mx AS INTEGER 'meteor x coordinate
  My AS INTEGER 'meteor y coordinate
  Mr AS INTEGER 'meteor radius (fixed)
  Ms AS INTEGER 'meteor speed (fixed)
END TYPE
DIM Rocks(1 TO 100) AS RockTYPE 'holds the location, size
'                                and speed of 100 meteors
'
WriteActive: '====================================================
'Clear active screen (On some systems this can be replaced by CLS)
LOCATE 1, 1: FOR i = 1 TO 24: PRINT SPACE$(80); : NEXT i
LOCATE 25, 1: PRINT SPACE$(79);
LOCATE 25, 80: PRINT " ";
'
OUT &H3C8, 0 'background color reestablished
OUT &H3C9, 0 'in case "space lightning" has
OUT &H3C9, 0 'flashed
OUT &H3C9, 12
'
'The following loop draws/updates x/y's of first 80 meteors
FOR n = 1 TO 80
  GOSUB DrawMETEORS 'see DrawMETEORS subroutine
NEXT n
'
'Variable (Swerve) which causes ship to drift left and right
'is established and directional rockets are fired accordingly
SELECT CASE Switch 'both Swerve and Switch = 0 initially
CASE 0
  Swerve = Swerve + 1
  IF Swerve > 24 AND Swerve < 30 THEN 'directional rocket fired
    LINE (x + 14, 171 + Swerve)-(x + 18, 173 + Swerve), 4, B
    LINE (x + 10, 172 + Swerve)-(x + 18, 172 + Swerve), 14
    LINE (x + 17, 172 + Swerve)-(x + 18, 172 + Swerve), 15
  END IF
  IF Swerve = 30 THEN Switch = 1 'pass to CASE 1
CASE 1
  Swerve = Swerve - 1
  IF Swerve > -30 AND Swerve < -26 THEN 'directional rocket fired
    LINE (x + 14, 143 + Swerve)-(x + 18, 145 + Swerve), 4, B
    LINE (x + 10, 144 + Swerve)-(x + 18, 144 + Swerve), 14
    LINE (x + 17, 144 + Swerve)-(x + 18, 144 + Swerve), 15
  END IF
  IF Swerve = -30 THEN Switch = 0 'pass to CASE 0
END SELECT
'
'Ship masks/sprites PUT, variable "Count" toggling two sprites with
'differing degrees of rocket blast (to create sense of active rockets)
IF Flop = 0 THEN
  Flop = 1
  PUT (x, 128 + Swerve), ShipBOX(1500), AND 'mask
  PUT (x, 128 + Swerve), ShipBOX 'sprite
ELSE
  Flop = 0
  PUT (x, 128 + Swerve), ShipBOX(4500), AND 'mask
  PUT (x, 128 + Swerve), ShipBOX(3000) 'sprite
END IF

'Second meteor-drawing loop draws last 20 meteors so that they *may*
'overdraw the ship (creating sense of its 'involvement' in meteor storm)
FOR n = 81 TO 100
  GOSUB DrawMETEORS 'see DrawMETEORS subroutine
NEXT n
'
'PRINT section -------------------------------------
COLOR 8: LOCATE 24, 32: PRINT "Press SPACE to end...";

'Blurbs are printed (with gaps) based on the ship's x location
COLOR 13
SELECT CASE x
CASE IS < 150
  LOCATE 21, 20: PRINT "The mission so far had been free of incident..."
CASE 161 TO 300
  LOCATE 21, 20: PRINT "But on the seventeenth day, we encountered"
  LOCATE 22, 20: PRINT "a meteor storm..."
CASE 311 TO 440
  LOCATE 21, 20: PRINT "With every moment, we came closer to almost"
  LOCATE 22, 20: PRINT "certain destruction..."
END SELECT
'
'Border line
LINE (0, 0)-(639, 349), 8, B

'"Space lightning" flash (1 chance in 25)
Flash = FIX(RND * 25)
IF Flash = 0 THEN
  OUT &H3C8, 0
  OUT &H3C9, 63 'set background (briefly) to bright red
  OUT &H3C9, 0
  OUT &H3C9, 0
END IF
RETURN
'
'
DrawMETEORS: '==============================================
'
'If the meteor's x coordinate has moved off-screen to the left, it is as-
'signed a new random y coordinate, then reset to the right of the screen
IF Rocks(n).Mx < 0 THEN
  Rocks(n).My = FIX(RND * 350)
  Rocks(n).Mx = 642
END IF
'
'Meteors are drawn with lighter highlight circle offset +1/-1 pixel
CIRCLE (Rocks(n).Mx, Rocks(n).My), Rocks(n).Mr, 1
PAINT STEP(0, 0), 1
CIRCLE (Rocks(n).Mx + 1, Rocks(n).My - 1), Rocks(n).Mr - 2, 3
PAINT STEP(0, 0), 3
'
'Establish new location for each meteor by subtracting their
'individual speed (Ms) from their current x coordinate (Mx) ...
Rocks(n).Mx = Rocks(n).Mx - Rocks(n).Ms
'
RETURN

DrawSHIP: '==============================================
DO
  READ Count, Colr
  FOR Reps = 1 TO Count
    PSET (x, y), Colr
    x = x + 1
    IF x > MaxWIDTH THEN
      x = 0
      y = y + 1
    END IF
  NEXT Reps
LOOP UNTIL y > MaxDEPTH
RETURN
'
Mask: '==============================================
FOR xx = 0 TO 83
FOR yy = 0 TO 60
IF POINT(xx, yy) = 0 THEN PSET (xx, yy), 15 ELSE PSET (xx, yy), 0
NEXT yy
NEXT xx
RETURN
'
ShipDATA:
DATA 34,0,1,5,73,0,7,5,4,7,1,15,73,0,6,5,1,7,77,0,6,5,1,7,77,0,6,5,1,7
DATA 77,0,5,5,2,7,77,0,4,5,3,7,77,0,3,5,5,7,76,0,8,7,76,0,9,7,75,0,10,7
DATA 74,0,11,7,73,0,12,7,69,0,2,5,1,2,7,7,3,5,3,7,3,5,2,7,61,0,1,8,3,5
DATA 1,2,6,7,1,5,3,7,1,5,3,7,10,5,55,0,1,8,2,7,2,2,6,7,1,2,3,7,1,2
DATA 4,7,7,5,2,2,1,15,54,0,1,8,2,7,2,2,6,7,1,2,3,7,1,2,5,7,6,5,2,2
DATA 1,15,54,0,1,8,1,7,3,2,7,7,3,2,12,7,2,2,1,5,46,0,1,8,7,5,1,8,4,2
DATA 22,7,2,2,1,5,46,0,1,8,7,5,1,8,4,2,22,7,2,2,47,0,1,8,12,5,22,7,44,0
DATA 4,4,2,8,6,7,8,5,2,7,11,2,7,7,1,5,41,0,2,4,4,14,2,8,6,7,6,2,3,5
DATA 1,7,1,2,9,7,1,2,8,7,1,5,39,0,1,4,2,14,4,15,2,8,6,7,9,2,1,5,1,2
DATA 9,7,1,2,8,7,2,5,37,0,1,4,1,14,6,15,2,8,6,7,21,2,7,7,5,5,2,9,1,15
DATA 1,4,1,15,2,9,1,7,1,5,27,0,1,4,2,14,4,15,2,8,6,7,13,2,13,7,10,5,8,7
DATA 1,15,25,0,2,4,4,14,2,8,7,7,15,2,9,7,13,5,6,7,1,5,27,0,4,4,2,8,25,2
DATA 36,5,21,0,2,8,10,2,36,5,2,10,4,9,1,15,2,9,2,7,6,5,1,15,18,0,2,8,8,7
DATA 2,2,36,7,4,10,2,9,1,5,4,9,1,5,6,12,1,5,17,0,2,8,8,7,2,2,36,7,4,10
DATA 2,9,1,7,4,9,1,5,6,12,1,5,6,15,11,0,2,8,8,7,2,2,36,7,4,10,2,9,1,7
DATA 4,9,1,5,6,12,1,5,17,0,2,8,8,5,38,2,2,10,4,9,1,2,2,9,8,7,1,5,14,0
DATA 4,4,2,8,25,5,36,2,15,0,2,4,4,14,2,8,7,7,15,5,12,7,10,5,6,7,1,5,24,0
DATA 1,4,2,14,4,15,2,8,6,7,13,5,13,7,10,5,8,7,1,15,23,0,1,4,1,14,6,15,2,8
DATA 5,7,1,2,11,5,10,2,2,7,10,5,2,9,1,15,1,4,1,15,2,9,1,7,1,5,27,0,1,4
DATA 2,14,4,15,2,8,4,7,2,2,9,5,2,2,9,7,1,2,1,7,9,5,39,0,2,4,4,14,2,8
DATA 3,7,3,2,6,5,3,2,1,7,1,2,9,7,1,2,9,5,42,0,4,4,2,8,2,7,12,2,2,7
DATA 11,2,8,5,48,0,1,8,14,2,8,7,12,5,49,0,1,8,7,2,1,8,3,5,1,2,9,7,15,5
DATA 47,0,1,8,7,2,1,8,3,5,1,2,8,7,10,5,1,7,3,5,2,2,1,15,54,0,1,8,3,5
DATA 1,2,6,7,1,5,1,7,2,15,7,5,1,7,4,5,2,2,1,15,54,0,1,8,8,7,2,5,1,7
DATA 3,5,1,15,5,5,2,7,4,5,2,2,1,5,54,0,1,8,2,7,2,2,4,7,2,5,1,7,3,5
DATA 1,7,4,5,2,7,5,5,2,2,1,5,54,0,1,8,1,7,3,2,3,7,3,5,1,7,3,5,1,7
DATA 3,5,3,7,5,5,2,2,57,0,3,2,3,7,4,5,3,7,3,5,5,2,66,0,4,7,8,5,72,0
DATA 6,7,5,5,73,0,5,7,5,5,74,0,5,7,4,5,75,0,5,7,3,5,76,0,6,7,2,5,76,0
DATA 7,7,77,0,7,7,77,0,7,7,77,0,7,7,77,0,7,7,76,0,11,7,1,15,82,0,1,5,49,0
DATA 16,0,6,4,3,0,3,4,5,14,2,0,2,4,2,14,5,15,1,0,2,4,1,14,7,15,2,0,2,4
DATA 2,14,5,15,3,0,3,4,5,14,5,0,6,4,60,0,6,4,3,0,3,4,5,14,2,0,2,4,2,14
DATA 5,15,1,0,2,4,1,14,7,15,2,0,2,4,2,14,5,15,3,0,3,4,5,14,5,0,6,4,11,0
'
InitProgram: '==============================================
'Set all attributes to black to hide draw/GET process
FOR n = 1 TO 15
PALETTE n, 0
NEXT n
'
'Ships differ in that the ship 2 rocket blasts are slightly larger
'Draw and GET ship 1 and mask
x = 0: y = 0
MaxWIDTH = 83
MaxDEPTH = 60
GOSUB DrawSHIP
GET (0, 0)-(MaxWIDTH, MaxDEPTH), ShipBOX
GOSUB Mask
GET (0, 0)-(MaxWIDTH, MaxDEPTH), ShipBOX(1500)
'
'Redraw ship, add different rocket blasts,GET ship/mask
RESTORE ShipDATA
LINE (0, 0)-(83, 60), 0, BF
x = 0: y = 0
GOSUB DrawSHIP
'Draw different rocket blasts
x = 0: y = 20
MaxWIDTH = 10
MaxDEPTH = 40
GOSUB DrawSHIP
GET (0, 0)-(83, 60), ShipBOX(3000)
GOSUB Mask
GET (0, 0)-(83, 60), ShipBOX(4500)

FOR n = 1 TO 100 'loop to initialize meteor array
'
  Rocks(n).Mx = FIX(RND * 640) 'initial x coordinates
  Rocks(n).My = FIX(RND * 350) 'initial y coordinates
  Rocks(n).Mr = FIX(RND * 5) + 2 'permanent radius (2-6 pixels)
'
  SELECT CASE n 'speed variations create perspective
  CASE 1 TO 30: Rocks(n).Ms = 12 'background meteors
  CASE 31 TO 65: Rocks(n).Ms = 18 'midground meteors
  CASE 66 TO 100: Rocks(n).Ms = 24 'foreground meteors
  END SELECT
'
NEXT n
'
Rocks(50).Mr = 10 'meteor 50 specially sized (large)
Rocks(100).Mr = 16 'meteor 100 specially sized (larger)
'
PALETTE
PALETTE 10, 0 'set palette values for attributes
PALETTE 12, 35 'which do not respond to OUT
'
'set palette values for attributes
'that respond to OUT
OUT &H3C8, 0
OUT &H3C9, 0
OUT &H3C9, 0 'background: midnight blue
OUT &H3C9, 12
'
OUT &H3C8, 1
OUT &H3C9, 16
OUT &H3C9, 8 'meteor: dark brown
OUT &H3C9, 2
'
OUT &H3C8, 2
OUT &H3C9, 32
OUT &H3C9, 32 'medium ship gray
OUT &H3C9, 32
'
OUT &H3C8, 3
OUT &H3C9, 22
OUT &H3C9, 12 'meteor highlight brown
OUT &H3C9, 5

OUT &H3C8, 4
OUT &H3C9, 63
OUT &H3C9, 0 'bright red
OUT &H3C9, 0
'
OUT &H3C8, 5
OUT &H3C9, 52
OUT &H3C9, 52 'ship light gray
OUT &H3C9, 52
'
RETURN
 

