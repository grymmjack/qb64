'Show Sprites  - version for QuickBasic users.
'Displays .spr files made with Sprite.
'Copyright(c) 1995 Nocturnal Creations
'Tim Truman  11/28/95
'
' [][] Note :
' Start QuickBASIC with the l option and the QB.QLB library

DEFINT A-Z

'$INCLUDE: 'qb.bi'

TYPE DTA                        'type for DTA
   Reserved   AS STRING * 21
   Attribute  AS STRING * 1
   FileTime   AS STRING * 2
   FileDate   AS STRING * 2
   Filesize   AS LONG
   filename   AS STRING * 13
END TYPE

TYPE HUES                       'type for palette
  red AS INTEGER
  grn AS INTEGER
  blu AS INTEGER
END TYPE


DECLARE SUB pfont (text$, x, y, colour)
DECLARE SUB mouse (argument)
DECLARE SUB WaitForRelease ()
DECLARE FUNCTION dropfilelist (filespec$)
DECLARE FUNCTION ReturnEvent ()

'global variables
COMMON SHARED filename$(), Filesize&()
COMMON SHARED mousex, mousey, mouseb

'mapped key values
CONST up = -72
CONST down = -80
CONST Left = -75
CONST Right = -54
CONST Eight = 56
CONST Two = 50
CONST Enter = 13
CONST Esc = 27
'mouse
CONST leftclick = 1
CONST rightclick = 2
'other
CONST True = 1
CONST False = 0

DIM SHARED inregs  AS RegType, outregs AS RegType

mouse 0                                  'initialize mouse
mouse 7                                  'set x limits
mouse 8                                  'set y limits

SCREEN 13                                'change mode


DIM Pal(255) AS HUES                     'dim array for palette
DEF SEG = VARSEG(Pal(0))                 'point to it
BLOAD "default.pal", 0                   'load the goods
OUT &H3C8, 0                             'inform vga
FOR atrib = 0 TO 255                     'entire palette
 OUT &H3C9, Pal(atrib).red               'send red component
 OUT &H3C9, Pal(atrib).grn               'send grn component
 OUT &H3C9, Pal(atrib).blu               'send blu component
NEXT atrib                               'next attribute

     

DO

mouse 1                                  'mouse cursor on
file = dropfilelist("*.spr")             'show file list

IF file THEN                             'did one get picked ?

  filename$ = filename$(file)            'get name
  Filesize& = Filesize&(file)            'get size
  bytes = (Filesize& - 7) \ 2 - 1        'BSAVE & BLOAD use 7 bytes
  REDIM sprites(bytes)                   'redim the sprite array
  DEF SEG = VARSEG(sprites(0))           'point to it
  BLOAD filename$, 0                     'load the sprite file
  spritewidth = sprites(0) \ 8           'get sprite width
  spriteheight = sprites(1)              'get sprite height

 
  xsprites = 319 \ (spritewidth + 1)  'calc number of sprites across
  xend = spritewidth * (xsprites - 1) + xsprites   'last one
  ElmPerSprite = ((spritewidth * spriteheight) \ 2) + 3  'elements per image
 
   
  mouse 2                                'mouse cursor off
  CLS                                    'clear the screen
  
  x = 0: y = 0                           'first sprite location
  offset = 0                             'point to sprite

  DO
    PUT (x, y), sprites(offset), PSET    'PUT image
    x = x + spritewidth                  'next column
    IF x > xend THEN                     'end of row?
      x = 0                              'restart
      y = y + spriteheight               'next row
    END IF
    offset = offset + ElmPerSprite       'point to next sprite
  LOOP WHILE offset < bytes              'do all the images
   mouse 1                               'mouse cursor on
   ERASE sprites                         'done with array
END IF

mouse 1                                  'mouse cursor on


DO: event = ReturnEvent: LOOP UNTIL event


LOOP UNTIL event = Esc

WIDTH 40
SCREEN 0

FUNCTION dropfilelist (filespec$)


DIM inreg AS RegTypeX, outreg AS RegTypeX   'Holds cpu registers
DIM Filedata AS DTA                         'Holds file data

inreg.Ax = &H1A00                           'Set DTA Address
inreg.ds = VARSEG(Filedata)                 'point to DTA
inreg.Dx = VARPTR(Filedata)                 'dit
INTERRUPTX &H21, inreg, outreg              'execute DOS function

filespec$ = filespec$ + CHR$(0)             'make an ASCIIZ
inreg.Ax = &H4E00                           'search for first match
inreg.Cx = 0                                'file atribute
inreg.ds = VARSEG(filespec$)                'point to File specification
inreg.Dx = SADD(filespec$)                  'get offset
DO
  INTERRUPTX &H21, inreg, outreg            'call DOS function
  IF outreg.flags AND 1 THEN EXIT DO        'all done
  filesfound = filesfound + 1               'increment
  inreg.Ax = &H4F00                         'next match
LOOP

REDIM filename$(1 TO filesfound)              'array for file list
REDIM Filesize&(1 TO filesfound)

inreg.Ax = &H4E00                           'search for first match
inreg.Cx = 0                                'file atribute
inreg.ds = VARSEG(filespec$)                'point to file specification
inreg.Dx = SADD(filespec$)                  'get offset
Filedata.filename = SPACE$(13)              'clear filename area
FOR i = 1 TO filesfound                     'get all filenames
  INTERRUPTX &H21, inreg, outreg            'call DOS function
  IF outreg.flags AND 1 THEN EXIT FOR       'all Done
  filename$(i) = Filedata.filename          'get filename from DTA
  Filesize&(i) = Filedata.Filesize          'get size
  Filedata.filename = SPACE$(13)            'clear filename area
 
  inreg.Ax = &H4F00                         'next match
NEXT
					   
FOR i = 1 TO filesfound                     'clean filename
  clean$ = ""                               'start fresh
  FOR l = 1 TO 13                           'step through string
   char$ = MID$(filename$(i), l, 1)         'get charater
   IF char$ = CHR$(0) THEN EXIT FOR         'outa here
   clean$ = clean$ + char$                  'add char to string
  NEXT                                      'next charactor
  filename$(i) = clean$                     'cleaned filename
NEXT                                        'next filename

IF filesfound > 16 THEN                   'window displays 16
 maxinwindow = 16                         'keep in bounds
ELSE                                      'less then max
 maxinwindow = filesfound                 'just set
END IF

mouse 2                                   'mouse cursor off

Bc = 7: Sc = 8: hc = 15                   'define colors
x1 = 10                                   'set location
y1 = 10                                   'ditto

x2 = ((8 * 18) - x1) + 1                  'calc plate dimesions
y2 = ((8 * (maxinwindow + 5)) - y1) + 1   'dit
DIM background(((x2 * y2) \ 2) + 2)       'dim array
GET (x1, y1)-(x2, y2), background         'GET the background


xbar1 = x1: xbar2 = ((8 * 15) - xbar1) - 1
ybar1 = y1: ybar2 = ((8) + ybar1)
LINE (xbar1, ybar1)-(xbar2, ybar2), 6, BF     'draw highlight bar
DIM hbar(((xbar2 * ybar2) \ 2) + 2)           'dim array
GET (xbar1, ybar1)-(xbar2, ybar2), hbar       'save it
xbar1 = x1 + 6: ybar1 = y1 + 16               'position it


LINE (x1, y1)-(x2, y2), Bc, BF             'draw plate
pfont filespec$, x1 + 8, y1 + 5, 4         'print filespec
LINE (x1, y1)-(x2, y1), hc                 'top
LINE (x2, y1)-(x2, y2), hc                 'right
LINE (x1, y1)-(x1, y2), Sc                 'left
LINE (x1, y2)-(x2, y2), Sc                 'bottom

xfw1 = x1 + 5: xfw2 = x2 - 19             'define filename window
yfw1 = y1 + 15: yfw2 = y2 - 4             'dit
LINE (xfw1, yfw1)-(xfw2, yfw1), Sc        'top
LINE (xfw2, yfw1)-(xfw2, yfw2), Sc        'right
LINE (xfw1, yfw1)-(xfw1, yfw2), hc        'left
LINE (xfw1, yfw2)-(xfw2, yfw2), hc        'bottom


firstfile = 1                                        'first file in window
IF filesfound < maxinwindow THEN                     'all names fit  ?
  lastfile = firstfile + filesfound - 1              'calc last file
ELSE                                                 'window maxed ?
  lastfile = maxinwindow                             'keep in window
END IF

FOR i = firstfile TO lastfile                        'first to last
   kerny = (i - firstfile) * 8                       'adjust y
   pfont filename$(i), xfw1 + 2, yfw1 + kerny + 2, 1 'print filename
NEXT                                                 'next filename


mouse 3                                              'get position
setx = (x1 + x2) / 2                                 'calc mouse position
sety = (y1 + y2) / 2                                 'ditto
mousex = setx: mousey = sety                         'set mouse position
mouse 4                                              'ditto
lpick = 1: pick = 1                                  'first file

DO

 
 
  ybar1 = ((pick - 1) * 8) + yfw1 + 1              'calculate row position
  PUT (xbar1, ybar1), hbar                         'PUT highlight bar
 
  mouse 1                                          'mouse cursor on
  DO: event = ReturnEvent: LOOP UNTIL event        'wait for an event
  mouse 2                                          'mouse cursor off

  PUT (xbar1, ybar1), hbar                         'remove

  IF event = leftclick THEN                        'mouse button
    
     IF mousex > xfw1 AND mousex < xfw2 THEN       'is it in file window ?
       IF mousey > yfw1 AND mousey < yfw2 - 1 THEN 'ditto
	 pick = ((mousey - yfw1 - 1) \ 8) + 1      'calc the selection number
	 IF pick = lpick THEN                      'clicked twice ?
	   event = Enter                           'force leave
	 ELSE                                      'one click
	   lpick = pick                            'set last pick
	   WaitForRelease                          'wait for button release
	 END IF
       END IF
    END IF
  

  END IF


  SELECT CASE event                                'what has happend ?

  CASE up
			    
       IF pick > 1 THEN                            'can highlight move up ?
	  pick = pick - 1                          'adjust
       END IF

  CASE down
     
      IF pick < maxinwindow THEN                   'can highlight move down
	 pick = pick + 1                           'adjust
      END IF

  CASE Enter
     done = True                                   'user picked file

  CASE Esc
     pick = 0                                      'no file picked
     done = True                                   'flag for leave
  END SELECT
 
   
 IF scroll = True THEN                                  'scroll bar active ?
   IF reprint THEN                                      'reduce flicker
      LINE (xfw1 + 1, yfw1 + 1)-(xfw2 - 1, yfw2 - 1), 7, BF   'erase last
      lastfile = firstfile + 15                               'adjust
      FOR i = firstfile TO lastfile                           'reprint list
	kerny = (i - firstfile) * 8                           'adjust kern
	pfont filename$(i), xfw1 + 2, yfw1 + kerny + 2, 1     'print filename
      NEXT                                                    'next name
      reprint = False                                         'did the list
  END IF
 END IF



LOOP UNTIL done


WaitForRelease                                  'wait for button release
PUT (x1, y1), background, PSET                  'restore background
mouse 1                                         'mouse on
dropfilelist = pick + firstfile - 1             'return the pick


END FUNCTION

SUB mouse (argument)

SELECT CASE argument

CASE 0                                    'initialize mouse

 inregs.Ax = &H0                          'Mouse present ?
 INTERRUPT &H33, inregs, outregs          'ax = 0 if not installed
 param1 = outregs.Ax                      'ax = -1 if installed
 param2 = outregs.bx                      'bx = number of buttons

 IF param1 = 0 THEN
   PRINT "No mouse detected"
   END
 END IF

CASE 1                                    'mouse cursor on

 inregs.Ax = &H1
 INTERRUPT &H33, inregs, outregs


CASE 2                                   'mouse cursor off

 inregs.Ax = &H2
 INTERRUPT &H33, inregs, outregs

CASE 3                                   'get mouse stats
			    
 inregs.Ax = &H3
 INTERRUPT &H33, inregs, outregs
 mouseb = outregs.bx
 mousex = outregs.Cx / 2
 mousey = outregs.Dx

CASE 4                                   'set mouse position

 inregs.Ax = &H4
 inregs.Cx = mousex
 inregs.Dx = mousey
 INTERRUPT &H33, inregs, outregs

CASE 7                                   'set mouse x limits

 MouseMinx = 0
 MouseMaxx = 640
 inregs.Ax = &H7
 inregs.Cx = MouseMinx
 inregs.Dx = MouseMaxx
 INTERRUPT &H33, inregs, outregs

CASE 8                                   'set mouse y limits
	  
 MouseMiny = 0
 MouseMaxy = 199
 inregs.Ax = &H8
 inregs.Cx = MouseMiny
 inregs.Dx = MouseMaxy
 INTERRUPT &H33, inregs, outregs

END SELECT



END SUB

SUB pfont (text$, x, y, colour)

DEF SEG = &HFFA6
FOR piece = 1 TO LEN(text$)
  address = (8 * ASC(MID$(text$, piece))) + 14
  FOR hl = 0 TO 7
    mask = PEEK(address + hl) * 128
    LINE (x + kernx, y + hl)-(x + 8 + kernx, y + hl), colour, , mask
  NEXT
 kernx = kernx + 8
NEXT
'x = 0
DEF SEG

END SUB

FUNCTION ReturnEvent


kee$ = INKEY$
IF kee$ <> "" THEN
  IF LEN(kee$) = 1 THEN
   keycode = ASC(kee$)
  ELSE
   keycode = -ASC(RIGHT$(kee$, 1))
  END IF
END IF

mouse 3
 IF mouseb THEN keycode = mouseb

ReturnEvent = keycode

END FUNCTION

SUB WaitForRelease
DO
  lmouseb = mouseb
  mouse 3
LOOP WHILE mouseb
END SUB

