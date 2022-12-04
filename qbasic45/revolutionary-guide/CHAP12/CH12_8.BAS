REM Animation, Collision Detection and Scrolling Demo
REM \CHAP12\CH12_8.BAS


SCREEN 7, 0, 1, 1
CLS

'Define Land Array and Land Variables
DIM height%(232)
chunk% = 10
landwidth% = 100

RANDOMIZE INT(VAL(RIGHT$(TIME$, 2)))
DEF Fnr (x) = INT(RND * x) + 1

'Create Random Array
height%(1) = 120
FOR land% = 2 TO landwidth%
height%(land%) = height%(land% - 1)
randomnumber = RND
IF randomnumber > .5 THEN GOSUB down
IF randomnumber < .5 THEN GOSUB up
NEXT land%
               
'Reverse first array and put on end of it
counter% = 1
FOR land2% = landwidth% * 2 TO landwidth + 1 STEP -1
height%(land2%) = height%(counter%)
counter% = counter% + 1
NEXT land2%

'Take the first 32 values of array and add them to end
counter% = (landwidth% * 2) + 1
FOR land3% = 1 TO 320 / chunk%
height%(counter%) = height%(land3%)
counter% = counter% + 1
NEXT land3%

'Define Ships & Masks
DIM ship1%(74)
DIM ship2%(74)
DIM ship3%(74)
DIM ship1m%(74)
DIM ship2m%(74)
DIM ship3m%(74)

'Read Ship & Mask Data
FOR reads = 0 TO 73
READ ship1%(reads)
NEXT reads
FOR reads = 0 TO 73
READ ship2%(reads)
NEXT reads
FOR reads = 0 TO 73
READ ship3%(reads)
NEXT reads
FOR reads = 0 TO 73
READ ship1m%(reads)
NEXT reads
FOR reads = 0 TO 73
READ ship2m%(reads)
NEXT reads
FOR reads = 0 TO 73
READ ship3m%(reads)
NEXT reads

'Ship & Stars Variables
Ship.X% = 50
Ship.Y% = 30
ticktock% = 0
Active = 0
NumStars% = 300
quickturn% = 1
currentbun% = 1
stopcount% = 0
verspeed% = 2
horspeed% = 2
v% = 0: h% = 0

'Draw Stars
FOR I = 1 TO NumStars%
MCr = Fnr(3)
SELECT CASE MCr
CASE 1
MCol = 8
CASE 2
MCol = 3
CASE 3
MCol = 5
END SELECT
Mx = Fnr(320)
my = Fnr(200)
PSET (Mx, my), MCol
NEXT

LOCATE 12, 14
PRINT "Press a key..."
WHILE INKEY$ = "": WEND
LOCATE 12, 14
PRINT "              "

'Ship Movement
move:
a$ = UCASE$(INKEY$)
SELECT CASE a$
CASE CHR$(0) + CHR$(77)
h% = h% + 1
Ship.X% = Ship.X% + 1
stopcount% = 0
CASE CHR$(0) + CHR$(75)
Ship.X% = Ship.X% - 1
h% = h% - 1
stopcount% = 0
CASE CHR$(0) + CHR$(72)
Ship.Y% = Ship.Y% - 1
v% = v% - 1
stopcount% = 0
CASE CHR$(0) + CHR$(80)
Ship.Y% = Ship.Y% + 1
v% = v% + 1
stopcount% = 0
END SELECT
IF a$ = "X" THEN END
IF Ship.X% > 290 THEN Ship.X% = 290: h% = -1
IF Ship.X% < 10 THEN Ship.X% = 10: h% = 1
IF Ship.Y% < 10 THEN Ship.Y% = 10: v% = 1
IF Ship.Y% > 185 THEN Ship.Y% = 185: v% = -1
IF oldh% < 0 AND h% >= 0 THEN h% = quickturn%
IF oldh% > 0 AND h% <= 0 THEN h% = -quickturn%
IF oldv% < 0 AND v% >= 0 THEN v% = quickturn%
IF oldv% > 0 AND v% <= 0 THEN v% = -quickturn%
IF h% < -horspeed% THEN h% = -horspeed%
IF h% > horspeed% THEN h% = horspeed%
IF v% < -verspeed% THEN v% = -verspeed%
IF v% > verspeed% THEN v% = verspeed%
IF stopcount% = 10 THEN
                IF h% < 0 THEN h% = h% + 1
                IF h% > 0 THEN h% = h% - 1
                IF v% < 0 THEN v% = v% + 1
                IF v% > 0 THEN v% = v% - 1
END IF
IF stopcount% = 25 THEN
                IF h% < 0 THEN h% = h% + 1
                IF h% > 0 THEN h% = h% - 1
                IF v% < 0 THEN v% = v% + 1
                IF v% > 0 THEN v% = v% - 1
END IF
IF stopcount% = 30 THEN
                IF h% < 0 THEN h% = h% + 1
                IF h% > 0 THEN h% = h% - 1
                IF v% < 0 THEN v% = v% + 1
                IF v% > 0 THEN v% = v% - 1
END IF
oldh% = h%: oldv% = v%
Ship.X% = Ship.X% + h%: Ship.Y% = Ship.Y% + v%

SCREEN 7, 0, 2, 0: PCOPY 1, 2

'Ship Animation
IF ticktock% = 20 THEN ticktock% = 0
IF ticktock% < 20 THEN ticktock% = ticktock% + 1
IF ticktock% > 0 AND ticktock% < 6 THEN
PUT (Ship.X%, Ship.Y%), ship1m%, AND
PUT (Ship.X%, Ship.Y%), ship1%, XOR
GOTO Finishdraw
END IF
IF ticktock% > 5 AND ticktock% < 11 THEN
PUT ((Ship.X% - 2), Ship.Y%), ship2m%, AND
PUT ((Ship.X% - 2), Ship.Y%), ship2%, XOR
GOTO Finishdraw
END IF
IF ticktock% > 10 AND ticktock% < 16 THEN
PUT ((Ship.X% - 4), Ship.Y%), ship3m%, AND
PUT ((Ship.X% - 4), Ship.Y%), ship3%, XOR
GOTO Finishdraw
END IF
IF ticktock% > 15 AND ticktock% < 21 THEN
PUT ((Ship.X% - 2), Ship.Y%), ship2m%, AND
PUT ((Ship.X% - 2), Ship.Y%), ship2%, XOR
GOTO Finishdraw
END IF
Finishdraw:

'Draw Landscape
FOR pixel% = 0 TO 320 STEP chunk%
LINE (pixel%, height%(currentbun%))-(pixel% + chunk%, height%(currentbun% + 1)), 6
LINE (pixel%, height%(currentbun%) + 1)-(pixel% + chunk%, height%(currentbun% + 1) + 1), 6
currentbun% = currentbun% + 1
NEXT pixel%
PAINT (319, 199), 6
currentbun% = (currentbun% - (320 / chunk%)) + 1
IF currentbun% > 200 THEN currentbun% = 1

'Collision Detection
FOR loopy% = Ship.X% - 2 TO Ship.X% + 20
collide% = POINT(loopy%, (Ship.Y% + 12))
NEXT loopy%
IF collide% = 6 THEN
LOCATE 1, 10
PRINT "You've crashed!"
END IF

SCREEN 7, 0, 0, 0: PCOPY 2, 0: PCOPY 1, 2
stopcount% = stopcount% + 1
GOTO move

'ship1
DATA &H0019,&H0009,&HF001,&H0000,&HF001,&H0000,&HF001,&H0000
DATA &H0008,&H0000,&HFE07,&H0000,&HFE03,&H0000,&HF07B,&H0000
DATA &H1E74,&H0000,&H3F06,&H0090,&H3F60,&H0090,&H20F8,&H0010
DATA &HFFF7,&H00E0,&H0007,&H0004,&H0000,&H8007,&H0078,&H0004
DATA &HFF77,&H80FB,&H3705,&H001E,&H1504,&H001E,&H1504,&H001E
DATA &HEA0B,&H00E0,&H8006,&H0060,&H0006,&H0060,&H0006,&H0060
DATA &HFF01,&H0080,&H4003,&H0000,&H0003,&H0000,&H0003,&H0000
DATA &HFC00,&H0000,&HBF00,&H0000,&H8700,&H0000,&H8700,&H0000
DATA &H7800,&H0000,&H4000,&H0000,&H4000,&H0060,&H4000,&H0000
DATA &H3F00,&H00E0

'ship2
DATA &H001B,&H0009,&H7C00,&H0000,&H7C00,&H0000,&H7C00,&H0000
DATA &H0002,&H0000,&HFF01,&H0080,&HFF00,&H0080,&HFC3E,&H0000
DATA &H073D,&H0080,&H8F01,&H00E4,&H0F38,&H00E4,&H08FE,&H0004
DATA &HFFFD,&H00F8,&HC001,&H0001,&H0000,&HE001,&H003E,&H0001
DATA &HFF3D,&HE0FE,&H4D01,&H80C7,&H0501,&H8047,&H0501,&H8047
DATA &HFA02,&H00B8,&HA001,&H0018,&H8001,&H0018,&H8001,&H0018
DATA &H7F00,&H00E0,&HD000,&H0000,&HC000,&H0000,&HC000,&H0000
DATA &H3F00,&H0000,&H2F00,&H00C0,&H2100,&H00C0,&H2100,&H00C0
DATA &H1E00,&H0000,&H1000,&H0000,&H1000,&H0018,&H1000,&H0000
DATA &H0F00,&H00F8

'ship3
DATA &H001D,&H0009,&H1F00,&H0000,&H1F00,&H0000,&H1F00,&H0000
DATA &H8000,&H0000,&H7F00,&H00E0,&H3F00,&H00E0,&HBF1F,&H0000
DATA &H411F,&H00E0,&H6300,&H00F9,&H031E,&H00F9,&H82FF,&H0001
DATA &H7FFF,&H00FE,&H7000,&H4000,&H0000,&H7800,&H801F,&H4000
DATA &H7F1F,&HB8FF,&H5300,&HE071,&H4100,&HE051,&H4100,&HE051
DATA &HBE00,&H00AE,&H6800,&H0006,&H6000,&H0006,&H6000,&H0006
DATA &H1F00,&H00F8,&H3400,&H0000,&H3000,&H0000,&H3000,&H0000
DATA &H0F00,&H00C0,&H0B00,&H00F0,&H0800,&H0070,&H0800,&H0070
DATA &H0700,&H0080,&H0400,&H0000,&H0400,&H0006,&H0400,&H0000
DATA &H0300,&H00FE

'ship1mask
DATA &H0019,&H0009,&H0FF6,&H80FF,&H0FF6,&H80FF,&H0FF6,&H80FF
DATA &H0FF6,&H80FF,&H0180,&H80FF,&H0180,&H80FF,&H0180,&H80FF
DATA &H0180,&H80FF,&H0000,&H801F,&H0000,&H801F,&H0000,&H801F
DATA &H0000,&H801F,&H0080,&H0000,&H0080,&H0000,&H0080,&H0000
DATA &H0080,&H0000,&H00F0,&H8001,&H00F0,&H8001,&H00F0,&H8001
DATA &H00F0,&H8001,&H00F8,&H801F,&H00F8,&H801F,&H00F8,&H801F
DATA &H00F8,&H801F,&H03FC,&H80FF,&H03FC,&H80FF,&H03FC,&H80FF
DATA &H03FC,&H80FF,&H00FF,&H80FF,&H00FF,&H80FF,&H00FF,&H80FF
DATA &H00FF,&H80FF,&H80FF,&H801F,&H80FF,&H801F,&H80FF,&H801F
DATA &H80FF,&H801F

'ship2mask
DATA &H001B,&H0009,&H83FD,&HE0FF,&H83FD,&HE0FF,&H83FD,&HE0FF
DATA &H83FD,&HE0FF,&H00C0,&HE07F,&H00C0,&HE07F,&H00C0,&HE07F
DATA &H00C0,&HE07F,&H0000,&HE007,&H0000,&HE007,&H0000,&HE007
DATA &H0000,&HE007,&H00C0,&H0000,&H00C0,&H0000,&H00C0,&H0000
DATA &H00C0,&H0000,&H00FC,&H6000,&H00FC,&H6000,&H00FC,&H6000
DATA &H00FC,&H6000,&H00FE,&HE007,&H00FE,&HE007,&H00FE,&HE007
DATA &H00FE,&HE007,&H00FF,&HE0FF,&H00FF,&HE0FF,&H00FF,&HE0FF
DATA &H00FF,&HE0FF,&HC0FF,&HE03F,&HC0FF,&HE03F,&HC0FF,&HE03F
DATA &HC0FF,&HE03F,&HE0FF,&HE007,&HE0FF,&HE007,&HE0FF,&HE007
DATA &HE0FF,&HE007

'ship3mask
DATA &H001D,&H0009,&H60FF,&HF8FF,&H60FF,&HF8FF,&H60FF,&HF8FF
DATA &H60FF,&HF8FF,&H00E0,&HF81F,&H00E0,&HF81F,&H00E0,&HF81F
DATA &H00E0,&HF81F,&H0000,&HF801,&H0000,&HF801,&H0000,&HF801
DATA &H0000,&HF801,&H00E0,&H0000,&H00E0,&H0000,&H00E0,&H0000
DATA &H00E0,&H0000,&H00FF,&H1800,&H00FF,&H1800,&H00FF,&H1800
DATA &H00FF,&H1800,&H80FF,&HF801,&H80FF,&HF801,&H80FF,&HF801
DATA &H80FF,&HF801,&HC0FF,&HF83F,&HC0FF,&HF83F,&HC0FF,&HF83F
DATA &HC0FF,&HF83F,&HF0FF,&HF80F,&HF0FF,&HF80F,&HF0FF,&HF80F
DATA &HF0FF,&HF80F,&HF8FF,&HF801,&HF8FF,&HF801,&HF8FF,&HF801
DATA &HF8FF,&HF801

'Bullet
DATA &H0015,&H0001,&HFFFF,&HFFF8,&HF8FF,&HFFFF,&HFFF8,&HF8FF

'Generate \ Land In Array
down:
IF height%(land%) > 180 THEN
        height%(land%) = 190
ELSE
        height%(land%) = height%(land%) + chunk%
END IF
RETURN

'Generate / Land In Array
up:
IF height%(land%) < 120 THEN
        height%(land%) = 120
ELSE
        height%(land%) = height%(land%) - chunk%
END IF
RETURN

