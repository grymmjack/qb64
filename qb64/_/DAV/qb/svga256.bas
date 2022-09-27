'===========
'SVGA256.BAS
'===========
'Small SVGA Library for Qbasic.
'Designed for 256 color SVGA modes only.
'Adapted code by Dav

'NOTE: Requires VESA ready video card to work.

'This simple SVGA Library for Qbasic is very easy to use.
'It's designed for 256 color SVGA modes only (101h, 103h, 105h).
'It's *NOT* fast, so if you want speed go with another library.
'I assume you already know how to use LINE, PSET, GET, PUT, etc.
'These routines work the same way except they're for SVGA modes.
'Each SUB/FUNCTION has using instructions so read them. Enjoy!

'CREDITS: A small portion of this code is adapted from code posted
'years ago on the Quik_Bas echo. I forgot the authors name. (Shea?)
'Anyway, his only worked in QB45 - this one is for Qbasic too.

DEFINT A-Z
DECLARE FUNCTION SVGACARD% ()
DECLARE FUNCTION SVGAPOINT (x%, y%)
DECLARE SUB SVGASCREEN (mode%)
DECLARE SUB SVGAPSET (x%, y%, clr%)
DECLARE SUB SVGALINE (x1%, y1%, x2%, y2%, clr%)
DECLARE SUB SVGABOX (x1%, y1%, x2%, y2%, clr%, filled%)
DECLARE SUB SVGACIRCLE (x%, y%, rad%, clr%)
DECLARE SUB SVGACLS ()
DECLARE SUB SVGAGET (x1%, y1%, x2%, y2%, array%())
DECLARE SUB SVGAPUT (x%, y%, array%(), Style)
DECLARE SUB SVGAPRINT (x%, y%, Text$, clr%)
DECLARE SUB SVGAWINDOW (x1%, y1%, x2%, y2%, clr%, Text$)
DECLARE SUB SVGABANK (NewBank&)

'=== Detect if SVGA is possible first!
IF NOT SVGACARD% THEN
   PRINT "A VESA-ready video card is required."
   PRINT "Crawl out of your cave and go buy one."
   END
END IF

'=== Enter 640x480x256 mode (101h)

SVGASCREEN &H101

'=== Show SVGALINE and SVGAPSET...

clr% = 25
FOR y% = 300 TO 479
    clr% = clr% + 1
    IF clr% = 256 THEN clr% = 0
    SVGALINE 0, y%, 639, y%, clr%
    SVGAPSET RND * 639, RND * 300, RND * 255
NEXT

'=== Get an area for Putting later on...

DIM stuff(8000)
SVGAGET 1, 300, 100, 350, stuff()

'=== Show SVGABOX (filled and hollow)

FOR d% = 1 TO 50
   x1% = RND * 599: x2% = x1% + 50
   y1% = RND * 400: y2% = y1% + 50
   SVGABOX x1%, y1%, x2%, y2%, RND * 255, RND * 1
NEXT

'=== Show SVGACIRCLE...

FOR d% = 1 TO 20
   SVGACIRCLE RND * 500 + 60, RND * 400 + 60, RND * 60, RND * 255
NEXT

'=== Show SVGAPRINT...

FOR d% = 1 TO 15
   SVGAPRINT RND * 500 + 1, RND * 450 + 1, "THE QB CODE POST", RND * 256
NEXT

'=== Show SVGAPUT...

FOR d% = 1 TO 20
   SVGAPUT RND * 500 + 10, RND * 400 + 10, stuff(), RND * 5
NEXT

'=== Show SVGAWINDOW....

SVGAWINDOW 220, 120, 420, 200, 29, "This is the Title bar!"
SVGAPRINT 250, 165, "Is this Qbasic?", 22

a$ = INPUT$(1)

'=== Reset screen to text mode

SCREEN 7
SVGASCREEN &H3

END

SUB SVGABANK (NewBank&)
'=======================================
'This Sub switches banks. It's called on
'by the other routines. Don't call it.
'=======================================

SHARED Bank&
  
a$ = ""
a$ = a$ + CHR$(85) 'push bp
a$ = a$ + CHR$(137) + CHR$(229) 'mov bp, sp
a$ = a$ + CHR$(184) + CHR$(5) + CHR$(79) 'mov ax, 4f05h
a$ = a$ + CHR$(187) + CHR$(0) + CHR$(0) 'mov bx, 0
a$ = a$ + CHR$(139) + CHR$(86) + CHR$(6) 'mov dx, [bp+6]
a$ = a$ + CHR$(205) + CHR$(16) 'int 10h
a$ = a$ + CHR$(93) 'pop bp
a$ = a$ + CHR$(202) + CHR$(2) + CHR$(0) 'retf 2
DEF SEG = VARSEG(a$)
   CALL ABSOLUTE(BYVAL (NewBank& \ 65536), SADD(a$))
DEF SEG = &HA000
Bank& = NewBank&

END SUB

SUB SVGABOX (x1%, y1%, x2%, y2%, clr%, filled%)
'==================================
'Draws a box (filled or hollow)
'x1%, y1% = Upper Left Corner
'x2%, y2% = Lower Right Corner
'clr% = color of box
'filled% = tells if box is filled.
' 1 = filled box, 0 = hollow box.
'==================================

IF filled% THEN
   FOR x% = x1% TO x2%
     FOR y% = y1% TO y2%
       SVGAPSET x%, y%, clr%
     NEXT
   NEXT
ELSE
   SVGALINE x1%, y1%, x1%, y2%, clr%
   SVGALINE x1%, y1%, x2%, y1%, clr%
   SVGALINE x1%, y2%, x2%, y2%, clr%
   SVGALINE x2%, y1%, x2%, y2%, clr%
END IF

END SUB

FUNCTION SVGACARD%
'======================================
'Returns TRUE if VESA extensions found.
'======================================

a$ = ""
a$ = a$ + CHR$(85) 'push bp
a$ = a$ + CHR$(137) + CHR$(229) 'mov bp, sp
a$ = a$ + CHR$(184) + CHR$(3) + CHR$(79) 'mov ax, 4f03h
a$ = a$ + CHR$(205) + CHR$(16) 'int 10h
a$ = a$ + CHR$(139) + CHR$(94) + CHR$(6) 'mov bx, [bp+06]
a$ = a$ + CHR$(137) + CHR$(7) 'mov [bx], ax
a$ = a$ + CHR$(93) 'pop bp
a$ = a$ + CHR$(202) + CHR$(2) + CHR$(0) 'retf 2

DEF SEG = VARSEG(a$)
    CALL ABSOLUTE(a%, SADD(a$))
DEF SEG

SVGACARD% = 0
IF a% MOD 256 = 79 THEN SVGACARD% = -1

END FUNCTION

SUB SVGACIRCLE (x%, y%, rad%, clr%)
'========================
'x%, y% = center of circle
'rad% = circle radius
'clr% = circle color
'========================

FOR c! = 0 TO 6.283186 STEP .01
   x2% = INT(rad% * COS(c!)) + x%
   y2% = INT(rad% * SIN(c!)) + y%
   SVGAPSET x2%, y2%, clr%
NEXT

END SUB

SUB SVGACLS
'=============================
'Simply clears the SVGA screen
'by resetting it. (faster than
'plotting every pixel clear)
'=============================

DEF SEG = &H40
   currentmode% = PEEK(&H49)
DEF SEG

SVGASCREEN &H3
SVGASCREEN currentmode%

END SUB

SUB SVGAGET (x1%, y1%, x2%, y2%, array%())
'===========================================
'GET's an area of screen for PUTting later.
'x1%, y1% = Upper left corner coordinates
'x2%, y2% = lower right corner coordinates
'array%() = Array to hold sprite.
'===========================================

SHARED Bank&, SvgaSize&

array%(1) = x2% - x1%
array%(2) = y2% - y1%

DEF SEG = &HA000

a% = 2
FOR y% = y1% TO y2%
   FOR x% = x1% TO x2%: a% = a% + 1
     Offset& = y% * SvgaSize& + x%
     NewBank& = Offset& AND -65536
     IF NewBank& <> Bank& THEN SVGABANK NewBank&
     array%(a%) = PEEK(Offset& AND 65535)
   NEXT
NEXT

END SUB

SUB SVGALINE (x1%, y1%, x2%, y2%, clr%)
'===============================
'Draws a Line from point A to B.
'x1%, y1% = Starting point
'x2%, y2% = Ending point
'clr% = Line color
'===============================

r% = x2% - x1% 'length
a% = y2% - y1% 'rise

IF a% = 0 THEN
   FOR x% = x1% TO x2% STEP SGN(r%)
     SVGAPSET x%, y1%, clr%
   NEXT
ELSEIF r% = 0 THEN
   FOR y% = y1% TO y2% STEP SGN(a%)
     SVGAPSET x1%, y%, clr%
   NEXT
ELSE
   IF ABS(r%) >= ABS(a%) THEN
     s! = a% / r% 'slope
     FOR x% = x1% TO x2% STEP SGN(r%)
       y% = y1% + CINT(s! * (x% - x1%))
       SVGAPSET x%, y%, clr%
     NEXT
   ELSE
     s! = r% / a%
     FOR y% = y1% TO y2% STEP SGN(a%)
       x% = x1% + CINT(s! * (y% - y1%))
       SVGAPSET x%, y%, clr%
     NEXT
   END IF
END IF

END SUB

FUNCTION SVGAPOINT (x%, y%)
'============================
'Gets color value of pixel.
'x%, y% = Pixel to be read
'============================

SHARED Bank&, SvgaSize&

DEF SEG = &HA000 'point here for pokeing pixels
Offset& = y% * SvgaSize& + x%
NewBank& = Offset& AND -65536
IF NewBank& <> Bank& THEN SVGABANK NewBank&
SVGAPOINT = PEEK(Offset& AND 65535)

END FUNCTION

SUB SVGAPRINT (x%, y%, Text$, clr%)
'================================
'A PRINT routine for SVGA modes.
'x%, y% = location to print.
'Text$ = Text to print
'clr% = Color of text
'================================

FOR d% = 1 TO LEN(Text$)
   FOR c% = 0 TO 7
     DEF SEG = -90
     l% = PEEK(14 + 8 * ASC(MID$(Text$, d%, 1)) + c%)
     x1% = x% + d% * 8 - 1
     x2% = x% + d% * 8 + 15: a% = 7
     FOR b% = x1% TO x2%
       IF l% AND 2 ^ a% THEN
         SVGAPSET b%, c% + y%, clr%
       END IF: a% = a% - 1
     NEXT
   NEXT
NEXT

DEF SEG

END SUB

SUB SVGAPSET (x%, y%, clr%)
'=======================
'A PSET routine for SVGA
'x%, y% = Pixel location
'clr% = Pixel color
'=======================

SHARED Bank&, SvgaSize&
  
DEF SEG = &HA000
Offset& = y% * SvgaSize& + x%
NewBank& = Offset& AND &HFFFF0000
IF NewBank& <> Bank& THEN SVGABANK NewBank&
POKE Offset& AND 65535, clr%
DEF SEG

END SUB

SUB SVGAPUT (x%, y%, array%(), Style)
'=====================================
'PUT routine for 256 color SVGA modes.
'array%() = The Array to PUT on screen.
'x%, y% = Upper left location of array.
'"Style" is one of several ways to PUT:
'(just like with Qbasic's PUT routine)
'Style = 1 (PSET array)
'Style = 2 (XOR array)
'Style = 3 (OR array)
'Style = 4 (AND array)
'=====================================

SHARED Bank&, SvgaSize&

x2% = array%(1)
y2% = array%(2)

DEF SEG = &HA000

a% = 2

FOR y1% = y% TO (y% + y2%)
   FOR x1% = x% TO (x% + x2%)
     a% = a% + 1
     Offset& = y1% * SvgaSize& + x1%
     NewBank& = Offset& AND -65536
     IF NewBank& <> Bank& THEN SVGABANK NewBank&
     o% = PEEK(Offset& AND 65535)
     IF Style <> 0 THEN
       IF Style = 1 THEN POKE Offset& AND 65535, array%(a%)
       IF Style = 2 THEN POKE Offset& AND 65535, (o% XOR array%(a%))
       IF Style = 3 THEN POKE Offset& AND 65535, (array%(a%) OR o%)
       IF Style = 4 THEN POKE Offset& AND 65535, (array%(a%) AND o%)
     ELSE
       POKE Offset& AND 65535, (array%(a%) XOR o%)
     END IF
   NEXT
NEXT

END SUB

SUB SVGASCREEN (mode%)
'======================================
' Sets 256 color SVGA mode or Text mode
' mode% = the screen mode to enter
' (only use these below)
' &H3 = Text
' &H101 = 640x480x256
' &H103 = 800x600x256
' &H105 = 1024x768x256
'====================================

SHARED SvgaSize&

a$ = ""
a$ = a$ + CHR$(184) + CHR$(2) + CHR$(79) 'mov ax, 4f02h
a$ = a$ + CHR$(187) + MKI$(mode%) 'mov bx, mode%
a$ = a$ + CHR$(205) + CHR$(16) 'int 10h
a$ = a$ + CHR$(203) 'retf

DEF SEG = VARSEG(a$)
   CALL ABSOLUTE(SADD(a$))
DEF SEG

DEF SEG = 0
   SvgaSize& = PEEK(1098) * 8
DEF SEG

END SUB

SUB SVGAWINDOW (x1%, y1%, x2%, y2%, clr%, Text$)
'======================================
'Draws a nice looking window with title
'Text$ = Title in windows top bar
'clr% = color of window
'======================================

'Draw Main Box
SVGABOX x1%, y1%, x2%, y2%, clr%, 1
SVGABOX x1%, y1%, x2%, y2%, clr% - 4, 0
SVGALINE x1% + 1, y1% + 1, x1% + 1, y2% - 1, clr% - 14
SVGALINE x1% + 1, y1% + 1, x2% - 1, y1% + 1, clr% - 14
SVGALINE x2% + 1, y1%, x2% + 1, y2% + 1, clr% - 21
SVGALINE x1%, y2% + 1, x2% + 1, y2% + 1, clr% - 21

'Title bar
SVGABOX x1% + 4, y1% + 4, x2% - 4, y1% + 22, clr% - 21, 1
SVGABOX x1% + 4, y1% + 4, x2% - 4, y1% + 22, clr% - 4, 0
SVGALINE x2% - 3, y1% + 4, x2% - 3, y1% + 22, clr% - 14
SVGALINE x1% + 4, y1% + 23, x2% - 3, y1% + 23, clr% - 14

'Print the message$
SVGAPRINT x1% + 7, y1% + 10, Text$, clr% - 4 '(shadow first)
SVGAPRINT x1% + 6, y1% + 9, Text$, clr%

END SUB

