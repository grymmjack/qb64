'===============
'ANIMATEDWIN.BAS
'===============
'Opens and closes QB64 window with animated effect. 
'Coded By Dav for QB64


'=== stretch across screen
FOR x% = 1 to 640 STEP 20
    SCREEN _NEWIMAGE(x%,1,256)
    _LIMIT 15
NEXT

'=== Now roll down window
FOR y% = 1 to 480 STEP 20
    SCREEN _NEWIMAGE(640,y%,256)
    _LIMIT 15
NEXT

'=== make sure 640, 480 shown
SCREEN _NEWIMAGE(640,480, 256)

'=== draw stuff to look at
FOR a% = 1 TO 1000
    c% = 16
    X% = RND * 800
    y% = RND * 600
    FOR z% = (RND * 16) TO 1 STEP -1
        CIRCLE (x%, y%), z%, c%
        PAINT (x%, y%), c%
        c% = c% + 1
    NEXT
NEXT

'=== pause for the cause
LOCATE 12, 24
PRINT "PRESS ANY KEY TO CLOSE"
SLEEP

'=== shrink window to top left
y% = 480
FOR x% = 640 to 1 STEP -20
    y% = y% - 15: IF y% < 1 then y% = 1
    SCREEN _NEWIMAGE(x%,y%,256)
    _LIMIT 15
NEXT

'=== all gone...
SYSTEM