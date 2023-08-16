'*****************************************************************************
'   QBASWIN.BAS = Generate Your own pop-up Windows, Demo Program for QBASIC
'   ===========   Erzeugung von Windows-aehnlichen Pop-Up-Fenstern mit QBasic
'
'                               Written by
'
'                              John Strong
'                           3155 SW 178th Avenue
'                             Aloha, OR 97006
'
'                    *This is Public Domain Software*
'
'  To use this routine in your own programs, cut and paste the code between
'  the $$$ bars into your own program.
'*****************************************************************************

'------- Subprocedure declarations --------

DECLARE SUB intro (prog1%())
DECLARE SUB demo1 (prog1%())
DECLARE SUB demo2 (prog1%())
DECLARE SUB tutorial (prog1%())
DECLARE SUB OuttaHere (prog1%())

'                      $$$$$$$$$$$$$$$$$$$$$$$$$
'$$$$$$$$$$$$$$$$$$$$$$$$ Start cutting here! $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'                      $$$$$$$$$$$$$$$$$$$$$$$$$
'
'-------- Define an integer array to hold routine ---------
'
DEFINT A-Z
DIM prog1(270 / 2)
'
'-------- Load the machine language program into an integer array --------
'
DEF SEG = VARSEG(prog1(0))
FOR i = 0 TO 269
        READ D$
        POKE i, VAL("&H" + D$)
NEXT
DEF SEG
'
prog1:
'
DATA 55,8B,EC,83,EC,E,53,51,6,57,B9,7,0,BF,0,0,8B,5B,6,8B,7,48,89,43,F2,47,47
DATA E2,F3,FF,46,F6,FF,46,F4,FF,46,F2,BB,0,B0,A1,10,0,25,30,0,3D,30,0,74,3,BB
DATA 0,B8,8E,C3,8B,5E,FE,B8,A0,0,F7,E3,8B,5E,FC,D1,E3,3,C3,8B,F8,57,8B,46,F8
DATA 8B,5E,FC,2B,C3,40,8B,D8,53,8B,46,FA,8B,56,FE,2B,C2,40,8B,C8,51,BA,0,0,8A
DATA 66,F6,B0,20,83,7E,F4,0,74,5,B0,C4,BA,1,0,51,8B,CB,83,7E,F4,0,74,8,50,B0
DATA B3,AB,83,E9,1,58,F3,AB,83,7E,F4,0,74,8,50,83,EF,2,B0,B3,AB,58,83,FA,0,75
DATA E,83,7E,F2,0,74,8,50,B0,8,47,AA,4F,4F,58,2B,FB,2B,FB,81,C7,A0,0,59,B0,20
DATA 83,7E,F4,0,74,7,83,F9,2,75,2,B0,C4,BA,0,0,E2,AF,83,7E,F2,0,74,B,8B,CB,B0
DATA 8,83,C7,2,47,AA,E2,FC,83,7E,F4,0,74,27,59,5B,5F,B0,DA,AB,3,FB,3,FB,83,EF
DATA 4,B0,BF,AB,50,B8,A0,0,49,F7,E1,3,F8,58,83,EF,2,B0,D9,AB,2B,FB,2B,FB,B0
DATA C0,AB,5F,7,59,5B,8B,E5,5D,CA,E
'
'                      $$$$$$$$$$$$$$$$$$$$$$$$$
'$$$$$$$$$$$$$$$$$$$$$$$$ Stop cutting here! $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'                      $$$$$$$$$$$$$$$$$$$$$$$$$
'
'
'-------- Begin the demo ---------
'
intro prog1()
demo1 prog1()
demo2 prog1()
tutorial prog1()
OuttaHere prog1()
'
END
'
'------------ Data ----------------
'
tutorial:
'
DATA "To create a window, one only needs to use CALL ABSOLUTE."
DATA "The call requires 7 arguments, plus the starting offset,"
DATA "which should always be 0."
DATA ""
DATA "You must first give the routine the coordinates of the upper
DATA "left and lower right corners: ULR, ULC, LRR, LRC (Upper left"
DATA "row, upper left column, etc).  The fifth argument is the attribute,
DATA "a value specifying the foreground color and background color.  It
DATA "is given by the formula: background*16+foreground.  For bright
DATA "white (15) on blue (1), the attribute would be 31.  The sixth and
DATA "seventh arguments are the frame and shadow flags, respectively."
DATA "These flags simply determine whether these features are displayed:
DATA "1 = yes, 0 = no."
DATA ""
DATA "For example, this very window could be created with:"
DATA ""
DATA "DEG SEG = VARSEG(prog1(0))  'address of array holding routine"
DATA "CALL ABSOLUTE(2, 5, 23, 75, 79, 1, 1, 0)
DATA "DEF SEG"

'
SUB demo1 (prog1())
'
        RANDOMIZE TIMER
        ulr = 14
        ulc = 54
        lrr = 22
        lrc = 78
        frame = 1
        shadow = 1
        DEF SEG = VARSEG(prog1(0))
        FOR i = 1 TO 7
                bg = INT(RND * 8)
                fg = INT(RND * 16)
                attr = bg * 16 + fg
                CALL absolute(ulr, ulc, lrr, lrc, attr, frame, shadow, 0)
                ulr = ulr - 2
                lrr = lrr - 2
                ulc = ulc - 8
                lrc = lrc - 8
                SOUND 880, .1
                x! = TIMER
                WHILE TIMER = x!: WEND
        NEXT
        DEF SEG
        COLOR 15, bg
        LOCATE 4, 8
        PRINT "QBWINDOWS are instant,"
        LOCATE 5, 8
        PRINT "featuring transparent"
        LOCATE 6, 8
        PRINT "shadows and a frame!"
        LOCATE 9, 8
        PRINT "Hit any key..."
        SLEEP
        COLOR 7, 1
        CLS
        EXIT SUB
'
END SUB

'
SUB demo2 (prog1())
'      
        WHILE INKEY$ <> "": WEND
        DEF SEG = VARSEG(prog1(0))
        x! = TIMER
        FOR i = 1 TO 100
                ulr = INT(RND * 10) + 2
                lrr = ulr + INT(RND * 9) + 3
                ulc = INT(RND * 40) + 2
                lrc = ulc + INT(RND * 19) + 20
                bg = INT(RND * 8)
                fg = INT(RND * 16)
                attr = bg * 16 + fg
                frame = 1
                shadow = 1
                CALL absolute(ulr, ulc, lrr, lrc, attr, frame, shadow, 0)
                SOUND 400 + i * 10, .1
                SOUND 0, .1
        NEXT
        period! = TIMER - x!
        ulr = 8
        ulc = 25
        lrr = 17
        lrc = 55
        attr = 31
        CALL absolute(ulr, ulc, lrr, lrc, attr, frame, shadow, 0)
        DEF SEG
        LOCATE 10, 27
        PRINT "Phew!  That was one hundred"
        LOCATE 11, 27
        PRINT "windows in only "; period!
        LOCATE 12, 27
        PRINT "seconds! "
        LOCATE 14, 27
        PRINT "Hit any key..."
        SLEEP
'
END SUB

'
SUB intro (prog1())
'      
        'Set background color so that shadow is visible.
        COLOR 7, 1      'white on blue
        CLS
'      
        LOCATE 2, 5: PRINT "Get ready for..."
        SLEEP 1

        ulr = 5
        ulc = 10
        lrr = 20
        lrc = 70
        attr = 64 + 15
        frame = 1
        shadow = 1
        DEF SEG = VARSEG(prog1(0))
        CALL absolute(ulr, ulc, lrr, lrc, attr, frame, shadow, 0)
        DEF SEG
        COLOR 15, 4
        LOCATE 8, 28: PRINT "Pop-up windows in QBASIC!"
        LOCATE 16, 28: PRINT "Written by John C. Strong"
        COLOR 4, 7
        LOCATE 19, 32: PRINT " Hit any key..."
        SLEEP
        COLOR 7, 1
        CLS
'
END SUB

'
SUB OuttaHere (prog1())
       
        COLOR 7, 1
        ulr = 14
        ulc = 48
        lrr = 18
        lrc = 72
        attr = 2 * 16 + 15
        frame = 1
        shadow = 1
        DEF SEG = VARSEG(prog1(0))
        CALL absolute(ulr, ulc, lrr, lrc, attr, frame, shadow, 0)
        DEF SEG
        COLOR 15, 2
        LOCATE 16, 50: PRINT "Hit any key to quit"
        SLEEP
        COLOR 7, 0
        CLS
'
END SUB

'
SUB tutorial (prog1())
'
        COLOR 7, 1
        CLS
        ulr = 2
        ulc = 5
        lrr = 23
        lrc = 75
        attr = 64 + 15
        frame = 1
        shadow = 1
        DEF SEG = VARSEG(prog1(0))
        CALL absolute(ulr, ulc, lrr, lrc, attr, frame, shadow, 0)
        DEF SEG
        COLOR 4, 7
        LOCATE 2, 35
        PRINT " Tutorial "
        RESTORE tutorial
        COLOR 14, 4
        FOR i = 1 TO 19
                READ lin$
                LOCATE i + 2, 7
                PRINT lin$
        NEXT
        COLOR 4, 7
        LOCATE 23, 34
        PRINT " Hit any key "
        SLEEP
END SUB

