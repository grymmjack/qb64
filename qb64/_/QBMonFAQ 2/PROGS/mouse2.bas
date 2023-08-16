'*******************************************************************
' MOUSE2.BAS = Mouse routines for QBasic, works in all SCRREN modes
' ==========   Maus-Routinen fuer QBasic, funktioniert in allen
'                SCREEN-Modi
'
' Deutsche Beschreibung
' ----------------------
' Diese Mausroutinen funktionieren nicht nur unter QuickBASIC,
' sondern auch unter QBasic 1.1, weil der CALL ABSOLUTE statt des
' CALL INTERRUPT-Befehls verwendet wird. Das Demo-Programm arbeitet
' im Grafik-SCREEN 13. Die Routinen sind aber auch in allen anderen
' Bildschirmmodi inkl. SCREEN 0 verwendbar.
'
' English Description
' ----------------------
' This is a collection of subs (and one function) that I wrote so people 
' can easily use the mouse in their program by just adding the subs to 
' their program.
' 
' These don't use CALL INTERRUPT (which is only supported by QuickBASIC, 
' not by asic), but instead uses CALL ABSOLUTE which is compatiable with 
' Qbasic 1.1. (I prefer INTERRUPT, but I wanted compatiablity)
' 
' If you just want the code, copy and paste! heh :)
' 
' The MouseDriver sub is what makes the actual call to interrupt 33, but 
' you don't need to call it directly. Instead, use the other subs I 
' provide.
' 
' The example here demonstrates each of the subs I've created.
' 
' (c)  by /\lipha - aliphax*hotmail.com - www.geocities.com/aliphax
'*********************************************************************
DECLARE SUB MouseDriver (ax AS INTEGER, bx AS INTEGER, cx AS INTEGER, dx AS INTEGER)
DECLARE FUNCTION MouseExists% ()
DECLARE SUB MouseShow ()
DECLARE SUB MouseHide ()
DECLARE SUB MouseStatus (mouseX, mouseY, leftB, rightB, middleB)
DECLARE SUB MousePosition (newX, newY)
DECLARE SUB MouseSetArea (x1, y1, x2, y2)
DECLARE SUB MouseLastPress (button, x, y)

CONST TRUE = -1
CONST FALSE = 0
CONST LEFT = 0    'the buttons (you pass one of these to
CONST RIGHT = 1   'MouseLastPress to find out the location
CONST CENTER = 2  'of the last click of the left, right, or
                  'center button)
'
'the Machine code routine used by MouseDriver
MouseData:
DATA 55,89,E5,8B,76,06,8B,14,8B,76,08,8B,0C,8B,76,0A
DATA 8B,1C,8B,76,0C,8B,04,1E,07,CD,33,8B,76,06,89,14
DATA 8B,76,08,89,0C,8B,76,0A,89,1C,8B,76,0C,89,04,5D
DATA CA,08,00
'
'
'Above code is needed for the mouse routines along with
'the Mouse subs and functions
'
'The below code is a "test frame" to demonstrate the mouse
'routines. You can delete it and add your own code
'(I recommend deleting the below code of the main program
'preserving the SUBs and then save this file.
'Then you can open up this file whenever you want to make
'a program using the mouse)
'
'
'
SCREEN 13
CLS
'set the area of the screen that the mouse can move in
MouseSetArea 300, 50, 639, 199
MouseShow
'
DO
   'get the (x, y) coordinates of the mouse and the left and right
   'button status (can also get the middle button [if you have one]
   'but this call doesn't. To do so, replace 0 with a variable)
   MouseStatus x, y, lb, rb, 0
   '
   LOCATE 1, 1
   PRINT x, y
   PRINT lb, rb
   '
   k$ = INKEY$
   IF k$ = "s" THEN MouseShow
   IF k$ = "h" THEN MouseHide
   '
   'press the "c" key to center the mouse on the screen
   '(at coordinate (320,100))
   IF k$ = "c" THEN MousePosition 320, 100
   '
   'get the location on the screen of where the last time
   'you pressed the left button was (if hasn't been pressed,
   'the x and y = -1)
   IF k$ = "p" THEN
      MouseLastPress LEFT, x, y
      PRINT x, y
   END IF
   '
LOOP UNTIL k$ = CHR$(27) 'press Esc to end
'
MouseHide
'
SCREEN 0
WIDTH 80, 25
END
'
'
SUB MouseDriver (ax AS INTEGER, bx AS INTEGER, cx AS INTEGER, dx AS INTEGER)
   STATIC called AS INTEGER, mouseDrv AS STRING
   DIM mCount AS INTEGER, mData AS STRING
   '
   IF NOT called THEN  'the first time this sub is called, there is some
      called = TRUE    'initialization that needs to be done
      RESTORE MouseData
      '
      FOR mCount = 1 TO 51
         READ mData
         mouseDrv = mouseDrv + CHR$(VAL("&H" + mData))
      NEXT mCount
      '
      'checks for mouse driver
      IF NOT MouseExists THEN PRINT "No Mouse Driver": END
   END IF
   '
   DEF SEG = VARSEG(mouseDrv)
   CALL ABSOLUTE(ax, bx, cx, dx, SADD(mouseDrv))
   DEF SEG
END SUB
'
FUNCTION MouseExists%
   DIM ax AS INTEGER
   ax = 0
   MouseDriver ax, 0, 0, 0
   '
   MouseExists% = ax
END FUNCTION
'
SUB MouseHide
   MouseDriver 2, 0, 0, 0
END SUB
'
SUB MouseLastPress (button, x, y)
   DIM bx AS INTEGER, cx AS INTEGER, dx AS INTEGER
   '
   IF button <> LEFT AND button <> RIGHT AND button <> MIDDLE THEN
      x = -1
      y = -1  'if you passed an invalid parameter
      EXIT SUB
   END IF
   '
   bx = button
   MouseDriver 5, bx, cx, dx
   '
   IF bx = 0 THEN 'if the button hasn't been pressed
      x = -1
      y = -1
   ELSE
      x = cx
      y = dx
   END IF
'
END SUB
'
SUB MousePosition (newX, newY)
   DIM cx AS INTEGER, dx AS INTEGER
   cx = newX
   dx = newY
   MouseDriver 4, 0, cx, dx
END SUB
'
SUB MouseSetArea (x1, y1, x2, y2)
   DIM cx AS INTEGER, dx AS INTEGER
   cx = x1 'set horizontal range
   dx = x2
   MouseDriver 7, 0, cx, dx
   cx = y1 'set vertical range
   dx = y2
   MouseDriver 8, 0, cx, dx
END SUB
'
SUB MouseShow
   MouseDriver 1, 0, 0, 0
END SUB
'
SUB MouseStatus (mouseX, mouseY, leftB, rightB, middleB)
   DIM bx AS INTEGER, cx AS INTEGER, dx AS INTEGER
   MouseDriver 3, bx, cx, dx
   '
   'the bits in bx contain the button status
   'bit 0 = left; bit 1 = right; bit 2 = middle
   IF (bx AND 1) THEN leftB = TRUE ELSE leftB = FALSE
   IF (bx AND 2) THEN rightB = TRUE ELSE rightB = FALSE
   IF (bx AND 4) THEN middleB = TRUE ELSE middleB = FALSE
   '
   mouseX = cx
   mouseY = dx
END SUB

