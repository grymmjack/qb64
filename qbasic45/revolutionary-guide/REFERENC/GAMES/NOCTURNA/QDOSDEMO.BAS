'Show Sprites  - version for Qbasic users.
'Displays .spr files made with Sprite.
'Copyright(c) 1995 Nocturnal Creations
'Tim Truman  11/28/95

DEFINT A-Z

TYPE HUES
  red AS INTEGER
  grn AS INTEGER
  blu AS INTEGER
END TYPE

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


'Select file to view

'Filename$ = "Examples.spr"
Filename$ = "Dungen.spr"
'FileName$ = "Space.spr"


OPEN Filename$ FOR BINARY AS #1
filesize& = LOF(1)
CLOSE #1


bytes = (filesize& - 7) \ 2 - 1        'BSAVE & BLOAD use 7 bytes
REDIM sprites(bytes)                   'redim the sprite array
DEF SEG = VARSEG(sprites(0))           'point to it
BLOAD Filename$, 0                     'load the sprite file
spritewidth = sprites(0) \ 8           'get sprite width
spriteheight = sprites(1)              'get sprite height

 
xsprites = 319 \ (spritewidth + 1)  'calc number of sprites across
xend = spritewidth * (xsprites - 1) + xsprites   'last one
ElmPerSprite = ((spritewidth * spriteheight) \ 2) + 3  'elements per image
 

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

DO: LOOP UNTIL LEN(INKEY$)

WIDTH 80                               'reset screen
SCREEN 0

