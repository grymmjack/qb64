' Program : QBMissle
' Version : Unfinished
' Author  : Tim Truman
' Date    : 7/5/97
' Type    : Freeware
' Copyright (c) Tim Truman 1997
' Feel free to use any routines or code found this program in your own.
' I just ask that you do not distribute this source code program modified
' and/or recompile the program for reasons other than personal use.
'
' About :
'  Graphics made with Sprite 2.0
'  FM Sounds made with FX. (requires soundcard for playback)
'  ( Programs available at my FTP : http://members.aol.com/TimTruman )
'
' Author :
'  Qbmissle is unfinished. I wanted to add smart bombs and a high score
'  screen but i just haven't had the time. I don't plan on finishing it
'  but I though Qbasic fans would like it anyway. It's still a playable
'  game and shows that Qbasic is capable gaming platform.
'
' To play :
'  Move the targeting cursor with the mouse and press a mouse button to
'  fire an antiballistic missle. Progressive levels will get harder.
'
' Comments:
' AOL - TimTruman
' NET - TimTruman@aol.com
' CS  - 74734,2203


DEFINT A-Z

TYPE HUES                                'type for palette
	red AS INTEGER
	grn AS INTEGER
	blu AS INTEGER
END TYPE

TYPE sprite
	x       AS INTEGER     'screen location
	y       AS INTEGER     'ditto
	sx      AS INTEGER    'start vector
	sy      AS INTEGER    'ditto
	ex      AS INTEGER    'end  vector
	ey      AS INTEGER    'ditto
	tl      AS INTEGER     'vector length
	tw      AS SINGLE      'vector position
	lx      AS INTEGER     'old location for erase
	ly      AS INTEGER     '
	fc      AS INTEGER     'frame counter
	gc      AS INTEGER     'general counter
	vx      AS INTEGER     'velocity
	vy      AS INTEGER     '
	h       AS INTEGER     'hight
	w       AS INTEGER     'width
	epi     AS INTEGER     'elements per image
	noi     AS INTEGER     'number of images
	active  AS INTEGER
	remove  AS INTEGER
	max     AS INTEGER      'max number of sprites allowed
	mem1    AS INTEGER      'misc storage
	mem2    AS INTEGER      'misc storage
	swc    AS INTEGER       'num of missles in sub wave
	swd    AS INTEGER
	used AS INTEGER
END TYPE


TYPE linepoints              'type for line vectors
		ax AS INTEGER
		Ay AS INTEGER
		bx AS INTEGER
		By AS INTEGER
		colour  AS INTEGER
END TYPE

TYPE targetdata
		x AS INTEGER
		y AS INTEGER
		c AS INTEGER
END TYPE


DECLARE SUB Drawsprites ()
DECLARE SUB erasesprites ()
DECLARE SUB movesprites ()
DECLARE SUB getinput ()
DECLARE SUB InitGame ()
DECLARE SUB WaitForRelase ()
DECLARE SUB LoadPal ()
DECLARE SUB stay (Millisecs!)
DECLARE SUB DoWave ()
DECLARE SUB createmissles ()
DECLARE SUB DetectCollide ()
DECLARE SUB doscore ()
DECLARE SUB misslecount ()
DECLARE SUB setupwave ()
DECLARE SUB mouse (func)
DECLARE SUB playsfx (sfx$)
DECLARE SUB scorewhatsleft ()
DECLARE SUB resetcitys ()
DECLARE SUB gameover ()
DECLARE SUB titlescreen ()
DECLARE FUNCTION TimePassed (n, tsecs!)

COMMON SHARED gamescore&
COMMON SHARED DIGNUMi(), DIGNUMwidth, DIGNUMheight, ElmPerDIGNUM
COMMON SHARED waveinprogress, wave, misslesperwave, emisslesperwave
COMMON SHARED sendsubwave, destroybeforenext, gameplay
COMMON SHARED mousex, mousey, mouseb
COMMON SHARED Mousemaxx, Mousemaxy, Mouseminx, Mouseminy

'max screen
CONST maxx = 319 - 24
CONST maxy = 199 - 24 - 4
CONST minx = 0 + 24
CONST miny = 0 + 24

'mapped key values
CONST up = -72
CONST down = -80
CONST left = -75
CONST Right = -77
CONST Eight = 56
CONST Two = 50
CONST Four = 52
CONST Five = 53
CONST Six = 54
CONST enter = 13
CONST Esc = 27
CONST space = 32
CONST F1 = -59
CONST Insert = -82
CONST delete = -83
'mouse
CONST leftclick = 1
CONST rightclick = 2
'other
CONST true = 1
CONST false = 0


DIM SHARED endvector(263) AS linepoints               'for line vectors
DIM SHARED startvector(263) AS linepoints             'ditto

SCREEN 13                                'change mode

DIM SHARED c$(8)   'FM register information for 9 channels
c$(0) = "&hB0&h20&h23&h40&h43&h60&h63&h80&h83&hA0&HBD&HC0&HE0&HE3&hB0"
c$(1) = "&hB1&h21&h24&h41&h44&h61&h64&h81&h84&hA1&HBD&HC1&HE1&HE4&hB1"
c$(2) = "&hB2&h22&h25&h42&h45&h62&h65&h82&h85&hA2&HBD&HC2&HE2&HE5&hB2"
c$(3) = "&hB3&h28&h2B&h48&h4B&h68&h6B&h88&h8B&hA3&HBD&HC3&HE8&HEB&hB3"
c$(4) = "&hB4&h29&h2C&h49&h4C&h69&h6C&h89&h8C&hA4&HBD&HC4&HE9&HEC&hB4"
c$(5) = "&hB5&h2A&h2D&h4A&h4D&h6A&h6D&h8A&h8D&hA5&HBD&HC5&HEA&HED&hB5"
c$(6) = "&hB6&h30&h33&h50&h53&h70&h73&h90&h93&hA6&HBD&HC6&HF0&HF3&hB6"
c$(7) = "&hB7&h31&h34&h51&h54&h71&h74&h91&h94&hA7&HBD&HC7&HF1&HF4&hB7"
c$(8) = "&hB8&h32&h35&h52&h55&h72&h75&h92&h95&hA8&HBD&HC8&HF2&HF5&hB8"

DIM SHARED sfx$(25)                   'dim array hold to 26 sounds
OPEN "missle.sfx" FOR INPUT AS #1     'open the .SFX file
FOR sfxnum% = 0 TO 25                 'load all sounds
	INPUT #1, sfx$(sfxnum%)             'load sound into string
NEXT                                  'next
CLOSE #1                              'close the file


DIM SHARED Mcode%(0 TO 56)           'array for machine code
DEF SEG = VARSEG(Mcode%(0))          'set array segment
offset% = VARPTR(Mcode%(0))          'set array address
FOR i% = 0 TO 56                     'read in machine code
	READ byte%
	POKE offset% + i%, byte%           'poke byte into array
NEXT


'-----load digital number fonts
'--------------------------
Filename$ = "8X7DIG.SPR"                 'load target graphics
OPEN Filename$ FOR BINARY AS #1          'open file
filesize& = LOF(1)                       'get file size
CLOSE #1                                 'close the file
bytes = (filesize& - 7) \ 2 - 1          'BSAVE & BLOAD use 7 bytes
DIM DIGNUMi(bytes)                       'dim the sprite array
DEF SEG = VARSEG(DIGNUMi(0))             'point to it
BLOAD Filename$, 0                       'load the sprite file
DIGNUMwidth = DIGNUMi(0) \ 8             'calc Image width
DIGNUMheight = DIGNUMi(1)                'calc Image height
ElmPerDIGNUM = ((DIGNUMwidth * DIGNUMheight) \ 2) + 3  'calc elements per image
'NumOfImages = (bytes / ElmPerDIGNUM)                'calc number of images
'set up sprite array


'-----load targeting images
'--------------------------
Filename$ = "target.spr"                 'load target graphics
OPEN Filename$ FOR BINARY AS #1          'open file
filesize& = LOF(1)                       'get file size
CLOSE #1                                 'close the file
bytes = (filesize& - 7) \ 2 - 1          'BSAVE & BLOAD use 7 bytes
DIM SHARED targeti(bytes)                'dim the sprite array
DEF SEG = VARSEG(targeti(0))             'point to it
BLOAD Filename$, 0                       'load the sprite file
Imagewidth = targeti(0) \ 8              'calc Image width
Imageheight = targeti(1)                 'calc Image height
ElmPerImage = ((Imagewidth * Imageheight) \ 2) + 3  'calc elements per image
NumOfImages = (bytes / ElmPerImage)                'calc number of images
'set up sprite array
DIM SHARED targets AS sprite     'Dim sprite array for target
targets.w = Imagewidth
targets.h = Imageheight
targets.epi = ElmPerImage
targets.noi = NumOfImages
DIM SHARED targetb(ElmPerImage)


'-----load missle explosion images
'---------------------------------

Filename$ = "misexp.spr"              'load Missle explosions graphics
OPEN Filename$ FOR BINARY AS #1         'open file
filesize& = LOF(1)                      'get file size
CLOSE #1                                'close the file
bytes = (filesize& - 7) \ 2 - 1         'BSAVE & BLOAD use 7 bytes
DIM SHARED mei(bytes)                   'dim the sprite array
DEF SEG = VARSEG(mei(0))                'point to it
BLOAD Filename$, 0                      'load the sprite file
Imagewidth = mei(0) \ 8                 'calc Image width
Imageheight = mei(1)                    'calc Image height
ElmPerImage = ((Imagewidth * Imageheight) \ 2) + 3  'calc elements per image
NumOfImages = (bytes / ElmPerImage)  'calc number of images
'set up sprite array
DIM SHARED mes(0 TO 5) AS sprite     'Dim sprite array for missle explosions
FOR i = 0 TO 5
	mes(i).w = Imagewidth
	mes(i).h = Imageheight
	mes(i).epi = ElmPerImage
	mes(i).noi = NumOfImages
	mes(i).max = 3
NEXT

'-----set up missle images
'---------------------------------
DIM SHARED missles(0 TO 5) AS sprite   'Dim sprite type for missle
FOR i = 0 TO 5
	missles(i).w = 1
	missles(i).h = 1
	missles(i).max = 3
	missles(i).epi = 15
NEXT
bytes = (missles(0).epi * (missles(0).max + 1))
DIM SHARED missleb(bytes)                      'to restore background

'-----set up citys
'-----------------
Filename$ = "citys.spr"              'load Missle explosions graphics
OPEN Filename$ FOR BINARY AS #1         'open file
filesize& = LOF(1)                      'get file size
CLOSE #1                                'close the file
bytes = (filesize& - 7) \ 2 - 1         'BSAVE & BLOAD use 7 bytes
DIM SHARED cityi(bytes)                   'dim the sprite array
DEF SEG = VARSEG(cityi(0))                'point to it
BLOAD Filename$, 0                      'load the sprite file
Imagewidth = cityi(0) \ 8                 'calc Image width
Imageheight = cityi(1)                    'calc Image height
ElmPerImage = ((Imagewidth * Imageheight) \ 2) + 3  'calc elements per image
NumOfImages = (bytes / ElmPerImage)  'calc number of images

'set up sprite array
DIM SHARED citys(0 TO 5) AS sprite     'Dim sprite array for missle explosions
FOR i = 0 TO 5
	citys(i).w = Imagewidth
	citys(i).h = Imageheight
	citys(i).noi = NumOfImages - 1
	citys(i).epi = ElmPerImage
	citys(i).max = 5
NEXT

Filename$ = "cityexp.spr"
OPEN Filename$ FOR BINARY AS #1          'open file
filesize& = LOF(1)                       'get file size
CLOSE #1                                 'close the file
bytes = (filesize& - 7) \ 2 - 1          'BSAVE & BLOAD use 7 bytes
DIM SHARED cityexp(bytes)                  'dim the image array
DEF SEG = VARSEG(cityexp(0))               'point to it
BLOAD Filename$, 0                       'load the sprite file
Imagewidth = cityexp(0) \ 8                'calc Image width
Imageheight = cityexp(1)                   'calc Image height
ElmPerImage = ((Imagewidth * Imageheight) \ 2) + 3  'calc elements per image
NumOfImages = (bytes / ElmPerImage)      'calc number of images

DIM SHARED cityexps(0 TO 5) AS sprite
cityexps(0).max = 5
cityexps(0).noi = NumOfImages
cityexps(0).epi = ElmPerImage


'-----set up enemy missles arrays
emisslesperwave = 50
DIM SHARED ems(0 TO emisslesperwave)   AS sprite
ems(0).tl = 580                            'number of points per vector
ems(0).max = emisslesperwave
DIM SHARED emxp(ems(0).max, ems(0).tl)     'to hold pre calced vector data
DIM SHARED emyp(ems(0).max, ems(0).tl)     'ditto

'-----store target data for enemy missle
DIM SHARED NumEnemyTar: NumEnemyTar = 14
DIM SHARED etd(NumEnemyTar)  AS targetdata
DIM SHARED esd(NumEnemyTar)  AS targetdata

DIM SHARED wavedata(65, 15)
FOR r = 0 TO 63
	READ send
	wavedata(r, 0) = send
	FOR s = 1 TO send * 2
		READ d
		wavedata(r, s) = d
	NEXT
NEXT


mouse (0)           'intialize mouse
mousex = 38
mousey = 38
mouse 26
stay (1)
bitbucket = TimePassed(100, -1)            'set up timers
RANDOMIZE TIMER

LoadPal
LOCATE 4, 15: PRINT "QBMissle "
LOCATE 5, 10: PRINT "Version unfinished "
LOCATE 6, 7: PRINT "Copyright (c) Tim Truman "
LOCATE 10, 7: PRINT "Press space bar to start "


DO
a$ = INKEY$
LOOP UNTIL a$ = CHR$(32)
CLS

InitGame
titlescreen
gameplay = true

setupwave
misslecount
doscore

DO
	DoWave
	getinput
	erasesprites
	movesprites
	Drawsprites
	DetectCollide
	DO: LOOP UNTIL INP(&H3DA) AND 8
	stay (15)
LOOP UNTIL gameplay = false

gameover


'machine language for mouse
DATA &H55,&H89,&HE5,&H8B,&H5E,&H0C,&H8B,&H07,&H50,&H8B
DATA &H5E,&H0A,&H8B,&H07,&H50,&H8B,&H5E,&H08,&H8B,&H0F
DATA &H8B,&H5E,&H06,&H8B,&H17,&H5B,&H58,&H1E,&H07,&HCD
DATA &H33,&H53,&H8B,&H5E,&H0C,&H89,&H07,&H58,&H8B,&H5E
DATA &H0A,&H89,&H07,&H8B,&H5E,&H08,&H89,&H0F,&H8B,&H5E
DATA &H06,&H89,&H17,&H5D,&HCA,&H08,&H00


DATA 2, 0,0,6,6
DATA 2, 1,1,5,5
DATA 2, 2,2,4,4
DATA 2, 3,3,0,6
DATA 2, 3,3,3,6
DATA 2, 2,4,3,5
DATA 2, 6,4,5,2
DATA 2, 14,14,7,7
DATA 2, 8,8,9,9
DATA 2, 11,11,12,12
DATA 2, 2,4,3,5
DATA 2, 11,7,7,11
DATA 2, 14,3,3,0
DATA 2, 9,1,9,2
DATA 2, 4,4,10,3
DATA 3, 0,0,3,3,6,6
DATA 3, 0,0,1,1,2,2
DATA 3, 4,4,5,5,6,6
DATA 3, 1,1,3,3,5,5
DATA 3, 2,2,4,4,6,6
DATA 3, 0,0,2,2,4,4
DATA 3, 7,1,1,2,10,3
DATA 3, 14,5,5,4,11,3
DATA 3, 0,1,8,2,9,3
DATA 3, 6,5,13,4,12,3
DATA 3, 8,4,9,5,10,6
DATA 3, 13,2,12,1,11,0
DATA 3, 1,0,2,3,5,6
DATA 3, 2,0,4,3,5,2
DATA 3, 9,2,11,3,14,6
DATA 3, 2,1,3,1,5,4
DATA 3, 10,2,3,2,11,4
DATA 3, 11,0,13,3,7,6
DATA 3, 12,1,13,1,8,5
DATA 3, 13,6,11,1,7,0
DATA 3, 14,6,8,0,10,5
DATA 3, 7,4,8,5,9,3
DATA 3, 1,3,2,5,3,6
DATA 3, 2,3,3,5,4,6
DATA 3, 10,3,11,4,12,6
DATA 3, 11,5,12,6,14,3
DATA 3, 8,0,8,3,8,5
DATA 3, 8,1,8,2,8,3
DATA 3, 8,3,8,4,8,6
DATA 3, 10,3,10,5,10,6
DATA 3, 10,0,10,3,10,4
DATA 3, 10,1,10,2,10,3
DATA 3, 11,4,11,5,11,6
DATA 3, 11,0,11,1,11,2
DATA 3, 11,2,11,3,11,4
DATA 3, 12,0,12,3,12,6
DATA 3, 12,4,12,5,12,6
DATA 3, 12,0,12,1,12,2
DATA 3, 13,3,13,5,13,6
DATA 3, 13,0,13,2,13,4
DATA 3, 13,1,13,3,13,6
DATA 3, 14,5,14,4,14,3
DATA 4, 0,1,0,2,0,3,14,6
DATA 4, 4,3,9,4,7,5,12,0
DATA 4, 7,3,14,3,13,11,9,2
DATA 4, 13,13,8,8,11,3,7,3
DATA 4, 12,7,2,2,11,6,8,11
DATA 5,1,1,2,2,3,3,4,4,5,5
DATA 6,0,1,1,2,2,3,3,4,4,5,5,6

SUB DetectCollide

FOR i = 0 TO ems(0).max                  'first enemy missle to last
	IF ems(i).active THEN                  'check active only
		pix = POINT(ems(i).x, ems(i).y)      'check for color change
		'LOCATE 1, 1: PRINT pix '47
		IF pix = 34 THEN                     'encounter anti ballistic ?
			ems(i).remove = true               'set remove flag for erase
			ems(i).active = false              'deactivate this missle
			ems(i).tw = 0
			gamescore& = gamescore& + 25
			playsfx (sfx$((i MOD 4) + 3))
		END IF
	END IF
NEXT
etd(3).x = 160: etd(3).y = 180   'missle launcher
doscore

SELECT CASE citys(0).mem1    'which one ?
CASE 48    '1st city
	cityexps(0).active = true
CASE 78    '2nd
	cityexps(1).active = true
CASE 109   '3rd
	cityexps(2).active = true
CASE 206   '4th
	cityexps(3).active = true
CASE 238   '5th
	cityexps(4).active = true
CASE 271   '6th
	cityexps(5).active = true
CASE 160  'launcher hit
	
		misslesleft = ABS(missles(0).gc - misslesperwave)
		IF misslesleft > 0 THEN
			silo = misslesleft MOD 10
			IF silo = 0 THEN silo = 10
			missles(0).gc = missles(0).gc + silo
			misslecount
		END IF

END SELECT

citys(0).mem1 = false

END SUB

SUB doscore
'
LOCATE 1, 20: PRINT wave

onedigit = (gamescore& \ 1) MOD 10
tendigit = (gamescore& \ 10) MOD 10
hdigit = (gamescore& \ 100) MOD 10
tdigit = (gamescore& \ 1000) MOD 10
ttdigit = (gamescore& \ 10000) MOD 10
mdigit = (gamescore& \ 100000) MOD 10

PUT (xscore, yscore), DIGNUMi(mdigit * ElmPerDIGNUM), PSET
PUT (xscore + DIGNUMwidth, yscore), DIGNUMi(ttdigit * ElmPerDIGNUM), PSET
PUT (xscore + DIGNUMwidth * 2, yscore), DIGNUMi(tdigit * ElmPerDIGNUM), PSET
PUT (xscore + (DIGNUMwidth * 3), yscore), DIGNUMi(hdigit * ElmPerDIGNUM), PSET
PUT (xscore + (DIGNUMwidth * 4), yscore), DIGNUMi(tendigit * ElmPerDIGNUM), PSET
PUT (xscore + (DIGNUMwidth * 5), yscore), DIGNUMi(onedigit * ElmPerDIGNUM), PSET


END SUB

SUB DoWave

STATIC endofwave, lsend, send, fm


IF (ems(0).mem2 >= ems(0).mem1) AND (endofwave = false) THEN
 
	ems(0).mem2 = 0                        'reset destroyed count
	ems(0).gc = ems(0).gc + ems(fm).swc
 
	IF ems(0).gc >= emisslesperwave THEN
			endofwave = true
			ems(0).gc = 0
	ELSE
	
	ems(0).mem1 = ems(fm).swc - INT(RND * 3)
	IF ems(0).mem1 > ems(fm).swc THEN ems(0).mem1 = ems(fm).swc
	FOR i = fm TO ems(0).gc - 1
	 IF ems(0).gc > emisslesperwave THEN EXIT FOR
		ems(i).active = true                'activate missles
		NEXT
		fm = ems(0).gc
	END IF
	

ELSEIF endofwave THEN                     'end of wave ?
		
		flag1 = true                           'assume no enemy missles active
		FOR i = 0 TO ems(0).max                'first enemy missle to last
			IF ems(i).active OR ems(i).remove THEN flag1 = false ' still active ?
		NEXT
		IF flag1 = true THEN                    'no enemy missles active
			flag2 = true                          'assume no explosion activity
			FOR i = 0 TO mes(0).max               'first missle explosion to last
				IF mes(i).active THEN flag2 = false 'still active ?
			NEXT
			IF flag2 = true AND TimePassed(100, 2) THEN  'no explosions active
			scorewhatsleft
			IF gameplay = fasle THEN EXIT SUB
			wave = wave + 1                             'increment the wave level
			setupwave
			endofwave = false
			ems(0).gc = 0
			ems(0).mem1 = 0
			ems(0).mem2 = 0
			fm = 0
			missles(0).gc = 0
			misslecount
			END IF
		END IF
END IF


END SUB

SUB Drawsprites


'-----Missle site
'----------------
missles(0).fc = (missles(0).fc + 1) MOD 16
PSET (160, 180), missles(0).fc + 192

'-----enemy missle
'-----------------

FOR i = 0 TO ems(0).max
	IF ems(i).active THEN
		FOR n = ems(i).tw TO ems(i).tw
			ems(i).x = emxp(i, n)
			ems(i).y = emyp(i, n)
			
			IF ems(i).y < 100 THEN
				DEF SEG = &HA000
				POKE ((ems(i).y * 320) + ems(i).x), 45
			ELSE
				DEF SEG = &HA7D0
				POKE (((ems(i).y - 100) * 320) + ems(i).x), 45
			END IF
			
			IF emxp(i, n + 1) < ems(0).tl - 1 THEN PSET (emxp(i, n + 1), emyp(i, n + 1)), missles(0).fc + 128 + 16

		NEXT
	END IF
NEXT

'-----Target
'-----------
IF TimePassed(0, .1) THEN targets.fc = (targets.fc + 1) MOD targets.noi
GET (targets.x, targets.y)-(targets.x + targets.w - 1, targets.y + targets.h - 1), targetb(0)
PUT (targets.x, targets.y), targeti(targets.fc * targets.epi), XOR


'-----Missle explosion
'---------------------

FOR i = mes(0).max TO 0 STEP -1              'check for active explosion
	IF mes(i).active = true THEN
		PUT (mes(i).x, mes(i).y), mei(mes(i).fc * mes(i).epi), XOR
	END IF
NEXT

'-----Missle
'-----------
FOR i = 0 TO missles(0).max            'check for active missle
	IF missles(i).active THEN
		PSET (missles(i).x, missles(i).y), 14
	END IF
NEXT


'----city explosions
'-------------------

FOR i = 0 TO cityexps(0).max
	IF cityexps(i).active AND TimePassed(90 + i, .09) THEN
		IF citys(i).active = true THEN
		PUT (citys(i).x, citys(i).y), cityexp(cityexps(i).fc * cityexps(0).epi), PSET
		cityexps(i).fc = cityexps(i).fc + 1
			IF cityexps(i).fc = 1 THEN playsfx (sfx$(7))
			IF cityexps(i).fc = cityexps(0).noi THEN
			citys(i).active = false
			cityexps(i).active = false
			cityexps(i).fc = cityexps(0).noi - 1
			END IF
	ELSE
		IF cityexps(i).mem1 = 0 THEN
			PUT (citys(i).x, citys(i).y), cityexp(cityexps(i).fc * cityexps(0).epi), PSET
			cityexps(i).fc = cityexps(i).fc - 1
			IF cityexps(i).fc = cityexps(0).noi - 7 THEN cityexps(i).mem1 = 1
		ELSE
			PUT (citys(i).x, citys(i).y), cityexp(cityexps(i).fc * cityexps(0).epi), PSET
			cityexps(i).fc = cityexps(i).fc + 1
			IF cityexps(i).fc = cityexps(0).noi THEN
				cityexps(i).active = false
				cityexps(i).fc = cityexps(0).noi - 1
				cityexps(i).mem1 = 0
			END IF
		END IF
	END IF
	END IF
NEXT
 

END SUB

SUB erasesprites



'-----missle explosion
'---------------------
FOR i = 0 TO mes(0).max
	IF mes(i).active THEN
		'PUT (mes(i).x, mes(i).y), mei((mes(0).noi - 1) * mes(0).epi), PSET' restore background
		PUT (mes(i).x, mes(i).y), mei(mes(i).fc * mes(i).epi), XOR
	END IF
NEXT


'-----missle
'-----------
FOR s = 0 TO missles(s).max
	IF missles(s).active OR missles(s).remove THEN
		PUT (missles(s).x, missles(s).y), missleb(s * missles(s).epi), PSET  ' restore background
		missles(s).remove = false
	END IF
NEXT


'-----target
'-----------
PUT (targets.x, targets.y), targetb(0), PSET    ' restore background
'PUT (targets.x, targets.y), targeti(targets.fc * targets.epi), XOR


'-----enemy missle
'-----------------


FOR i = 0 TO ems(0).max
		IF ems(i).remove = true THEN
		ems(0).mem2 = ems(0).mem2 + 1
		ems(i).tw = 0
		DO
			ems(i).tw = (ems(i).tw + 1) MOD ems(0).tl      'generate next point
			ems(i).x = emxp(i, ems(i).tw)
			ems(i).y = emyp(i, ems(i).tw)
			IF ems(i).y < 100 THEN
				DEF SEG = &HA000
				POKE ((ems(i).y * 320) + ems(i).x), 0
			ELSE
				DEF SEG = &HA7D0
				POKE (((ems(i).y - 100) * 320) + ems(i).x), 0
			END IF
		LOOP UNTIL ems(i).tw = 0
		ems(i).remove = false                 'done with erase
		END IF
	
NEXT
'LOCATE 3, 1: PRINT ems(0).mem2

END SUB

SUB gameover

playsfx (sfx$(14))

LOCATE 12, 14: PRINT " Game over."
LOCATE 13, 12: PRINT " Press any key. "

DO: LOOP UNTIL LEN(INKEY$)

WIDTH 80                               'reset screen
SCREEN 0

END


END SUB

SUB getinput

STATIC mousehold, n


IF gameplay THEN mouse (3)                                'get mouse stats

'-----fire missle
'----------------
IF mouseb AND leftclick THEN             'fire missle
	IF mousehold = false THEN
		mousehold = true
		FOR i = 0 TO missles(i).max          'check for open sprite
			IF missles(i).active = false AND mes(i).active = false THEN 'found one ?
			IF missles(0).gc < misslesperwave THEN
				missles(i).active = true          'make it active
				missles(i).sx = 160               'set launch start
				missles(i).sy = 180               'ditto
				missles(i).ex = targets.x + 5
				missles(i).ey = targets.y + 5
				xt = (missles(i).sx - missles(i).ex)
				yt = (missles(i).sy - missles(i).ey)
				missles(i).tl = SQR(xt ^ 2 + yt ^ 2) / 6
				missles(0).gc = missles(0).gc + 1
				misslecount
				n = (n + 1) MOD 3
				playsfx (sfx$(i MOD 3))
				EXIT SUB
				END IF
			END IF
		NEXT
		playsfx (sfx$(9))
	END IF
ELSE
	mousehold = false
END IF



END SUB

SUB InitGame


'FOR x = 1 TO 319
'LINE (x, y)-(x, y + 199), x
'NEXT

mousex = 160
mousey = 100
mouse (4)                                 'set mouse position


'-----Init target sprite
targets.x = mousex: targets.y = mousey              'set target position
targets.lx = targets.x: targets.ly = targets.y      'save old position
GET (targets.x, targets.y)-(targets.x + targets.w - 1, targets.y + targets.h - 1), targetb(0)

'----- Missle sprite
GET (missles(i).x, missles(i).y)-(missles(i).x + missles(i).w, missles(i).y + missles(i).h), missleb(i * missles(i).epi)

'-----City locations
citys(0).x = 38
citys(0).y = 181
citys(1).x = 70
citys(1).y = 181
citys(2).x = 102
citys(2).y = 181
citys(3).x = 198
citys(3).y = 181
citys(4).x = 230
citys(4).y = 181
citys(5).x = 262
citys(5).y = 181

FOR i = 0 TO citys(0).noi
	PUT (citys(i).x, citys(i).y), cityi(i * citys(i).epi), PSET
	citys(i).active = true
	cityexps(i).used = false
	cityexps(i).fc = 0
NEXT

'-----base
'bases.x = 140
'bases.y = 180
'PUT (bases.x, bases.y), basei(1 * bases.EPI), PSET

'-----load missle target data           'direct hits
etd(0).x = 48: etd(0).y = 180    '1st city
etd(1).x = 78: etd(1).y = 180    '2nd city
etd(2).x = 109: etd(2).y = 180   '3rd city
etd(3).x = 160: etd(3).y = 180   'missle launcher
etd(4).x = 206: etd(4).y = 180   '4th city
etd(5).x = 238: etd(5).y = 180   '5th city
etd(6).x = 271: etd(6).y = 180   '5th city
'misses
etd(7).x = 32: etd(7).y = 180      '1st city
etd(8).x = 64: etd(8).y = 180      '2nd city
etd(9).x = 96: etd(9).y = 180     '3rd city
etd(10).x = 128: etd(10).y = 180   'missle launcher
etd(11).x = 192: etd(11).y = 180   'missle launcher
etd(12).x = 224: etd(12).y = 180   '4th city
etd(13).x = 256: etd(13).y = 180   '4th city
etd(14).x = 288: etd(14).y = 180   '6th city


'-----load missle start data
esd(0).x = 48: esd(0).y = 20
esd(1).x = 78: esd(1).y = 20
esd(2).x = 109: esd(2).y = 20
esd(3).x = 160: esd(3).y = 20
esd(4).x = 206: esd(4).y = 20
esd(5).x = 238: esd(5).y = 20
esd(6).x = 271: esd(6).y = 20

esd(7).x = 32: esd(7).y = 20
esd(8).x = 64: esd(8).y = 20
esd(9).x = 96: esd(9).y = 20
esd(10).x = 128: esd(10).y = 20
esd(11).x = 192: esd(11).y = 20
esd(12).x = 224: esd(12).y = 20
esd(13).x = 256: esd(13).y = 20
esd(14).x = 288: esd(14).y = 20


'-----draw terrain
LINE (0, 190)-(20, 190), 206: LINE -(30, 190), 206
LINE -(35, 188), 206: LINE -(36, 188), 206: LINE -(38, 190), 206
LINE -(58, 190), 206: LINE -(63, 188), 206: LINE -(63, 188), 206
LINE -(66, 190), 206: LINE -(68, 189), 206: LINE -(69, 190), 206
LINE -(90, 190), 206: LINE -(92, 188), 206: LINE -(96, 190), 206
LINE -(99, 190), 206: LINE -(100, 189), 206: LINE -(101, 190), 206
LINE -(121, 190), 206: LINE -(124, 188), 206: LINE -(125, 188), 206
LINE -(129, 190), 206: LINE -(191, 190), 206: LINE -(195, 188), 206
LINE -(196, 188), 206: LINE -(199, 190), 206: LINE -(218, 190), 206
LINE -(219, 189), 206: LINE -(220, 190), 206: LINE -(224, 190), 206
LINE -(228, 188), 206: LINE -(229, 190), 206: LINE -(250, 190), 206
LINE -(252, 189), 206: LINE -(254, 190), 206: LINE -(256, 188), 206
LINE -(257, 188), 206: LINE -(261, 189), 206: LINE -(261, 190), 206
LINE -(281, 190), 206: LINE -(284, 188), 206: LINE -(285, 188), 206
LINE -(289, 190), 206: LINE -(319, 190), 206: PAINT (65, 196), 206
'----draw launcher
LINE (160, 181)-(151, 181), 206
LINE -(146, 178), 206
LINE -(130, 190), 206
LINE (160, 181)-(170, 181), 206
LINE -(175, 178), 206
LINE -(190, 190), 206
PAINT (160, 185), 206


wave = 1
gamescore& = 0
misslesperwave = 30


END SUB

SUB LoadPal

DIM Pal(255) AS HUES                     'dim array for palette
DEF SEG = VARSEG(Pal(0))                 'point to it
BLOAD "default.pal", 0                  'load the goods
OUT &H3C8, 0                             'inform vga
FOR atrib = 0 TO 255                     'entire palette
	OUT &H3C9, Pal(atrib).red               'send red component
	OUT &H3C9, Pal(atrib).grn               'send grn component
	OUT &H3C9, Pal(atrib).blu               'send blu component
NEXT atrib                               'next attribute


END SUB

SUB misslecount

misslesleft = ABS(missles(0).gc - misslesperwave)

IF misslesleft > 20 THEN
	LINE (20, 192)-(30, 194), 0, BF
	LINE (40, 192)-(50, 194), 0, BF
ELSEIF misslesleft > 10 THEN
	LINE (20, 192)-(30, 194), 0, BF
	LINE (40, 192)-(50, 194), 206, BF
ELSEIF misslesleft > 0 THEN
	LINE (20, 192)-(30, 194), 206, BF
	LINE (40, 192)-(50, 194), 206, BF
END IF

silo = misslesleft MOD 10
IF missles(0).gc < misslesperwave THEN
	IF silo = 0 THEN silo = 10
ELSEIF missles(0).gc = misslesperwave THEN
		silo = 0
END IF

LINE (158, 183)-(162, 184), 206, BF
LINE (154, 185)-(158, 186), 206, BF
LINE (162, 185)-(166, 186), 206, BF
LINE (150, 187)-(154, 188), 206, BF
LINE (158, 187)-(162, 188), 206, BF
LINE (166, 187)-(170, 188), 206, BF
LINE (146, 189)-(150, 190), 206, BF
LINE (154, 189)-(158, 190), 206, BF
LINE (162, 189)-(166, 190), 206, BF
LINE (170, 189)-(174, 190), 206, BF

IF silo > 0 THEN
	LINE (158, 183)-(162, 184), 0, BF
END IF

IF silo > 1 THEN
	LINE (154, 185)-(158, 186), 0, BF
END IF

IF silo > 2 THEN
	LINE (162, 185)-(166, 186), 0, BF
END IF

IF silo > 3 THEN
	LINE (150, 187)-(154, 188), 0, BF
END IF

IF silo > 4 THEN
	LINE (158, 187)-(162, 188), 0, BF
END IF

IF silo > 5 THEN
	LINE (166, 187)-(170, 188), 0, BF
END IF

IF silo > 6 THEN
	LINE (146, 189)-(150, 190), 0, BF
END IF

IF silo > 7 THEN
	LINE (154, 189)-(158, 190), 0, BF
END IF

IF silo > 8 THEN
	LINE (162, 189)-(166, 190), 0, BF
END IF

IF silo > 9 THEN
	LINE (170, 189)-(174, 190), 0, BF
END IF


END SUB

SUB mouse (func)


DEF SEG = VARSEG(Mcode%(0))          'set array segment
offset% = VARPTR(Mcode%(0))          'get array address


SELECT CASE func%

CASE 0  'reset mouse driver

	ax = 0: bx = 0: cx = 0: dx = 0
	CALL Absolute(ax, bx, cx, dx, offset)
	IF ax% = 0 THEN
		' PRINT "No mouse detected!"
		' PRINT "Sorry, this program requires a mouse."
		' END
	ELSE
		'PRINT "Mouse found"
	END IF


CASE 1    'mouse cursor on
	ax = 1: bx = 0: cx = 0: dx = 0
	CALL Absolute(ax, bx, cx, dx, offset)

CASE 2    'mouse cursor off
	ax% = 2: bx% = 0: cx% = 0: dx% = 0
	CALL Absolute(ax, bx, cx, dx, offset)

CASE 3    'get mouse status

	ax = 3: bx = 0: cx = 0: dx = 0
	CALL Absolute(ax, bx, cx, dx, offset)
	mouseb% = bx
	mousex% = cx / 2
	mousey% = dx
CASE 4                               'Set mouse position

	ax = 4: bx = 0: cx = mousex * 2: dx = mousey
	CALL Absolute(ax, bx, cx, dx, offset)


END SELECT

DEF SEG


END SUB

SUB movesprites

'moves sprites and saves backgound information

'-----target
'-----------

targets.x = mousex: targets.y = mousey      'set new position
IF targets.x > maxx - targets.w THEN targets.x = maxx - targets.w 'keep in
IF targets.y > maxy - targets.h THEN targets.y = maxy - targets.h 'bounds
IF targets.x < minx THEN targets.x = minx                         'ditto
IF targets.y < miny THEN targets.y = miny                         'ditto
	'save background behind target
GET (targets.x, targets.y)-(targets.x + targets.w - 1, targets.y + targets.h - 1), targetb(0)

'-----missle
'-----------
FOR i = 0 TO missles(i).max                   'look for active sprite
	IF missles(i).active = true THEN            'found one ?
		missles(i).tw = (missles(i).tw + 1) MOD missles(i).tl 'generate next point
		IF missles(i).tw = 0 THEN                  'last point ?
		mes(i).x = missles(i).ex - 18             'set explosion center to target
		mes(i).y = missles(i).ey - 18             'ditto
		mes(i).active = true                      'make the explosion active
		missles(i).active = false                 'deactivate the missle
		missles(i).remove = true                  'remove missle from screen
		EXIT FOR                                  'done
		END IF
		'generate next missle point
		missles(i).x = missles(i).sx + missles(i).tw * (missles(i).ex - missles(i).sx) / missles(i).tl
		missles(i).y = missles(i).sy + missles(i).tw * (missles(i).ey - missles(i).sy) / missles(i).tl
	END IF
		'save background behind missle
	GET (missles(i).x, missles(i).y)-(missles(i).x + missles(i).w, missles(i).y + missles(i).h), missleb(i * missles(i).epi)
NEXT


'-----missle Explosion
'---------------------
FOR i = 0 TO mes(0).max                 'check for active explosion
	IF mes(i).active = true THEN          'found one ?
		IF TimePassed(1 + i, .05) THEN      'time the animation
			mes(i).fc = mes(i).fc + 1         'next frame
			IF mes(i).fc = mes(i).noi THEN    'reach last frame ?
				mes(i).active = false            'deactivate the explosion
				mes(i).fc = 0                    'reset the frame counter
			END IF
		END IF
	END IF
NEXT


'-----enemy missle
'------------------

FOR i = 0 TO ems(0).max
	IF ems(i).active THEN
			ems(i).tw = (ems(i).tw + 1) MOD ems(0).tl      'generate next point
			IF ems(i).tw = 0 THEN                   'last point ?
				ems(i).active = false                 'deactivate the enemy missle
				ems(i).remove = true                  'remove enmey missle from screen
				citys(0).mem1 = ems(i).ex
				EXIT FOR                              'done
			END IF
			ems(i).x = emxp(i, ems(i).tw)
			ems(i).y = emyp(i, ems(i).tw)
	END IF
NEXT


END SUB

SUB playsfx (sfx$)

'plays an sfx$ that is sent to it.
'sub expects the c$() array (channel info) to be global

chan% = VAL(MID$(sfx$, 61, 4))
FOR in = 1 TO 60 STEP 4
	reg$ = MID$(c$(chan%), in, 4): reg% = VAL(reg$)
	dat$ = MID$(sfx$, in, 4): dat% = VAL(dat$)
	OUT &H388, reg%: FOR d% = 1 TO 6: b% = INP(&H388): NEXT
	OUT &H389, dat%: FOR d% = 1 TO 35: b% = INP(&H388): NEXT
NEXT

END SUB

SUB resetcitys
FOR i = 0 TO citys(0).noi
	IF citys(i).active THEN
	PUT (citys(i).x, citys(i).y), cityi(i * citys(i).epi), PSET
	citys(i).active = true
	cityexps(i).used = false
	cityexps(i).fc = 0
	END IF
NEXT
END SUB

SUB scorewhatsleft

STATIC multi&

'mousexin = mousex: mouseyin = mousey   ' save last mouse position


DO
	IF missles(0).gc = 30 THEN EXIT DO
	IF TimePassed(2, .09) THEN
		missles(0).gc = missles(0).gc + 1
		misslecount
		gamescore& = gamescore& + 10
		doscore
		playsfx (sfx$(10))
	END IF
	GOSUB letcursormove
LOOP

DO
	IF TimePassed(2, .2) OR skip THEN
		IF citys(i).active = true THEN
		PUT (citys(i).x, citys(i).y), cityi(i * citys(i).epi), XOR
		playsfx (sfx$(10))
		gamescore& = gamescore& + 100
		doscore
		skip = false
		ELSE
		skip = skip + 1
		END IF
		i = i + 1
	END IF
	GOSUB letcursormove
LOOP UNTIL i > citys(0).noi

DO
	IF TimePassed(3, 2) THEN EXIT DO
	GOSUB letcursormove
LOOP


IF gamescore& \ (5000& * (multi& + 1)) > 0 THEN
		multi& = multi& + 1
		cityup = true
END IF

DIM num(6)
IF cityup THEN
		FOR i = 0 TO citys(0).noi
			IF citys(i).active = false THEN
					n = n + 1
					num(n) = i
				END IF
		NEXT
END IF

IF n THEN
	FOR i = 0 TO 3
			playsfx (sfx$(11))
			stay (100)
	NEXT
	city = INT(RND * n) + 1
	citys(num(city)).active = true
	stay (500)
	skip = 0
END IF

IF skip = 6 THEN
	gameplay = false
ELSE
	resetcitys
END IF

FOR i = 0 TO 6
		playsfx (sfx$(11))
		stay (100)
		GOSUB letcursormove
NEXT

'mousex = mousexin: mousey = mouseyin
'mouse 4

EXIT SUB

letcursormove:
	getinput
	erasesprites
	movesprites
	Drawsprites
	DO: LOOP UNTIL INP(&H3DA) AND 8
RETURN

END SUB

SUB setupwave

IF wave MOD 2 = 0 THEN
	ems(0).tl = ems(0).tl - 10
	IF ems(0).tl < 150 THEN ems(0).tl = 150
END IF

SELECT CASE wave
CASE 1:  emisslesperwave = 35: destroybeforenext = 1
END SELECT



DO
	subwave = (RND * 62) + 1
	'c = (c + 1) MOD (16)
	sendsubwave = wavedata(subwave, 0)    'get number of missles in sub wave
	dp = 1                               'set data pointer
	FOR i = from TO ems(0).max           'from first to last
		ems(i).swc = sendsubwave
		start = wavedata(subwave, dp)      'get start vector
		target = wavedata(subwave, dp + 1) 'get target vector
		'PRINT start, target
		'DO: LOOP UNTIL LEN(INKEY$)
		ems(i).sx = esd(start).x           'get x start for tween generation
		ems(i).sy = esd(start).y           'get y start for tween generation
		ems(i).ex = etd(target).x          'get x end for tween generation
		ems(i).ey = etd(target).y          'get y start for tween generation
		'PRINT ems(i).sx; ems(i).sy
		'PRINT ems(i).ex; ems(i).ey
		'DO: LOOP UNTIL LEN(INKEY$)

		dp = dp + 2                        'advance pointer to start and end data
		IF dp / 2 > sendsubwave THEN EXIT FOR 'exit- vector data has been read
		NEXT
		PRINT
	from = i + 1                        'advance pointer
	GOSUB cursormove
LOOP WHILE from < emisslesperwave     'done when from equals missle per wave



FOR i = 0 TO ems(0).max            'calc all vector tweens
	FOR n! = 1 TO ems(0).tl
		ems(i).x = ems(i).sx + n! * (ems(i).ex - ems(i).sx) / ems(0).tl
		ems(i).y = ems(i).sy + n! * (ems(i).ey - ems(i).sy) / ems(0).tl
		emxp(i, n!) = ems(i).x      'store this tween
		emyp(i, n!) = ems(i).y      'ditto
	NEXT n!
	GOSUB cursormove
NEXT i

EXIT SUB

cursormove:
	getinput
	erasesprites
	movesprites
	Drawsprites
	DO: LOOP UNTIL INP(&H3DA) AND 8
RETURN


END SUB

DEFSNG A-Z
SUB stay (Millisecs!)
STATIC syspeed&, Time2


IF syspeed& THEN                ' First time here -get relative system speed
	IF Millisecs THEN             ' Start Delay loop
		
			factor& = (syspeed& * Millisecs) \ 55          'num of loops needed
			IF factor& < 1 THEN factor& = 1
			DO                                             'delay loop
				factor& = factor& - 1                        'Sub the num of loops
			LOOP UNTIL Time2 = PEEK(&H6C) OR factor& = 0   'make loop same as below

	END IF
ELSE                               ' Relative system speed processed here
	DEF SEG = &H40
	Time1 = PEEK(&H6C)

	DO
		Time2 = PEEK(&H6C)             ' get another
	LOOP UNTIL Time1 <> Time2        ' loop until new clock tick

	DO                               ' start here at new clock tick
		syspeed& = syspeed& - 1        ' Count the number of times looped
	LOOP UNTIL Time2 <> PEEK(&H6C) OR syspeed& = 0  'make same as loop above
		Time2 = 1255
		syspeed& = ABS(syspeed&)        'cant use this neg -reverse it

END IF

END SUB

DEFINT A-Z
FUNCTION TimePassed (n, tsecs!)

STATIC getclock(), oldtsecs!(), Time1!()

IF tsecs! = -1 THEN
	DIM getclock(n)
	DIM oldtsecs!(n)
	DIM Time1!(n)
END IF

IF tsecs! <> oldtsecs!(n) THEN getclock(n) = 0  ' reset

IF getclock(n) = 0 THEN
	Time1!(n) = TIMER
	getclock(n) = 1
	oldtsecs!(n) = tsecs!
ELSE
	IF ABS(TIMER - Time1!(n)) >= tsecs! THEN
		TimePassed = 1
		getclock(n) = 0
	ELSE
		TimePassed = 0
	END IF
END IF


END FUNCTION

SUB titlescreen



END SUB

SUB WaitForRelease
DO
	lmouseb = mouseb
	mouse 3
LOOP WHILE mouseb                    'wait till let go

END SUB

