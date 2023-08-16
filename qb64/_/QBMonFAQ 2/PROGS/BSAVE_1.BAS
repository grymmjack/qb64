'**********************************************************************
' BSAVE_1.BAS = Autodemo for BSAVE and BLOAD
' ===========
' BSAVEing arrays and BLOADing to arrays in QBasic/QuickBASIC
' (c)Jesse Dorland
'**********************************************************************
SCREEN 13
RANDOMIZE TIMER
'$DYNAMIC
'Now we dimension the array we're going to be using.  For this
'code, we're only going to be saving a 50x50 square.
DIM Array%(1252)
'In order to BSAVE our array, we have to tell QBasic/QuickBASIC where
'the array is in memory.  This next line will set the memory segment
'to the beginning of where Array%() is in memory
DEF SEG = VARSEG(Array%(1))
'Now we want to draw something on the screen.  Since we're only saving
'a 50x50 square, we won't draw on the whole screen.
PRINT "Press any key to stop drawing"
DO UNTIL LEN(INKEY$)
'Draw a pixel within a 50x50 box
PSET (50 * RND + 50, 50 * RND + 50), 255 * RND + 1
LOOP
'Make our doodle a box
LINE (50, 50)-(99, 99), 15, B
'Get our box into an array
GET (50, 50)-(99, 99), Array%(1)
'Now comes the BSAVE part.  Here, we're going to save the
'entire array to a file called "BOX.SAV."  We've already told QBasic/
'QB where in memory Array%() starts.  Now we've got to tell BSAVE how
'many bytes after that we want to skip before starting to save.  We'll
'use VARPTR for that.  The reason you see "1252*2" below is because
'an integer is two bytes.  Array% is an integer array, which means each
'element holds two bytes.  Without the * 2, only half the box would be
'saved.
BSAVE "BOX.SAV", VARPTR(Array%(1)), 1252 * 2
'Reset the memory segment.
DEF SEG
'
'Great!  Now the box is saved to disk.  A loading routine follows.
CLS
'Erase Array%() just to show that the box is on disk and we're not
'using the copy that's in memory anymore.
ERASE Array%'Dimension the array we'll use to hold the box.
DIM Box%(1252)
'
'We have to tell QBasic/QB where to start loading
DEF SEG = VARSEG(Box%(1))
'
'Now we BLOAD the box into the array.  Ag          SOUND 880, .1
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
        PRI