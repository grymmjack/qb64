 
'===============
'GOOGLYEYES4.BAS
'===============
'Blinking Eyes drift around, looking in direction they go.
'Shows how to create images off screen to use with _PUTIMAGE.
'Demo also shows how to move the images in interesting ways.
'Has a scrolling background image.
 
'Coded by Dav, JULY/2023
 
'V4 - Clicking eyes make them go googly and run off screen.
'    Added a sound effect when clicking on them.
'    Added a rotating background image.
'    Added press ESC to quit
 
'=== First, create 4 eye images to use....
 
'=== Create image of eyes looking left
eyeleft& = _NEWIMAGE(230, 200, 32)
_DEST eyeleft& 'point to above image so we can draw to it
ball 50, 50, 50, 255, 255, 255 'left eye
ball 30, 50, 20, 0, 0, 128 'left pupil
ball 150, 50, 50, 255, 255, 255 'right eye
ball 130, 50, 20, 0, 0, 128 'right pupil
CIRCLE (50, 50), 50, _RGB(0, 0, 0)
CIRCLE (150, 50), 50, _RGB(0, 0, 0)
CIRCLE (30, 50), 20, _RGB(0, 0, 0)
CIRCLE (130, 50), 20, _RGB(0, 0, 0)
 
'=== Create image of eyes looking right
eyeright& = _NEWIMAGE(230, 200, 32)
_DEST eyeright& 'point to above image so we can draw to it
ball 50, 50, 50, 255, 255, 255
ball 70, 50, 20, 0, 0, 128
ball 150, 50, 50, 255, 255, 255
ball 170, 50, 20, 0, 0, 128
CIRCLE (50, 50), 50, _RGB(0, 0, 0)
CIRCLE (150, 50), 50, _RGB(0, 0, 0)
CIRCLE (70, 50), 20, _RGB(0, 0, 0)
CIRCLE (170, 50), 20, _RGB(0, 0, 0)
 
'=== Create an image of eyes looking up
eyeup& = _NEWIMAGE(230, 200, 32)
_DEST eyeup& 'point to above image so we can draw to it
ball 50, 50, 50, 255, 255, 255
ball 50, 30, 20, 0, 0, 128
ball 150, 50, 50, 255, 255, 255
ball 150, 30, 20, 0, 0, 128
CIRCLE (50, 50), 50, _RGB(0, 0, 0)
CIRCLE (150, 50), 50, _RGB(0, 0, 0)
CIRCLE (50, 30), 20, _RGB(0, 0, 0)
CIRCLE (150, 30), 20, _RGB(0, 0, 0)
 
'=== Create an image of eyes looking down
eyedown& = _NEWIMAGE(230, 200, 32)
_DEST eyedown& 'point to above image so we can draw to it
ball 50, 50, 50, 255, 255, 255
ball 50, 70, 20, 0, 0, 128
ball 150, 50, 50, 255, 255, 255
ball 150, 70, 20, 0, 0, 128
CIRCLE (50, 50), 50, _RGB(0, 0, 0)
CIRCLE (150, 50), 50, _RGB(0, 0, 0)
CIRCLE (50, 70), 20, _RGB(0, 0, 0)
CIRCLE (150, 70), 20, _RGB(0, 0, 0)
 
'=== Create an image of eyes blinking
eyeblink& = _NEWIMAGE(200, 800, 32)
_DEST eyeblink& 'point to above image so we can draw to it
ball 50, 150, 50, 196, 196, 196
ball 150, 150, 50, 196, 196, 196
ball 50, 150, 20, 64, 64, 128
ball 150, 150, 29, 64, 64, 128
CIRCLE (50, 150), 50, _RGB(0, 0, 0)
CIRCLE (150, 150), 50, _RGB(0, 0, 0)
 
'=== Create a background image to use
back& = _NEWIMAGE(200, 150, 32)
_DEST back&
FOR x = -1 TO 200
    FOR y = -1 TO 150
        LINE (x, y)-(x + RND * 10, y + RND * 10), _RGBA(RND * 32, RND * 32, 25 + RND * 200, 25 + RND * 200), BF
    NEXT
NEXT
 
'=== smooth out the background image...
 
_SOURCE back&
FOR u = 1 TO 3 'do it 3 times for extra smooth
    FOR x = 1 TO 199
        FOR y = 1 TO 149
            p1~& = POINT(x, y)
            p2~& = POINT(x + 1, y)
            p3~& = POINT(x, y + 1)
            p4~& = POINT(x + 1, y + 1)
            p5~& = POINT(x - 1, y)
            p6~& = POINT(x, y - 1)
            p7~& = POINT(x - 1, y - 1)
            p8~& = POINT(x - 1, y + 1)
            p9~& = POINT(x + 1, y - 1)
            IF x + 1 > 200 THEN p2~& = p1~&: p4~& = p1~&: p9~& = p1~&
            IF x - 1 < 0 THEN p5~& = p1~&: p7~& = p1~&: p8~& = p1~&
            IF y + 1 > 150 THEN p3~& = p1~&: p4~& = p1~&: p8~& = p1~&
            IF y - 1 < 0 THEN p6~& = p1~&: p7~& = p1~&: p9~& = p1~&
            r = _RED32(p1~&) + _RED32(p2~&) + _RED32(p3~&) + _RED32(p4~&) + _RED32(p5~&) + _RED32(p6~&) + _RED32(p7~&) + _RED32(p8~&) + _RED32(p9~&)
            g = _GREEN32(p1~&) + _GREEN32(p2~&) + _GREEN32(p3~&) + _GREEN32(p4~&) + _GREEN32(p5~&) + _GREEN32(p6~&) + _GREEN32(p7~&) + _GREEN32(p8~&) + _GREEN32(p9~&)
            b = _BLUE32(p1~&) + _BLUE32(p2~&) + _BLUE32(p3~&) + _BLUE32(p4~&) + _BLUE32(p5~&) + _BLUE32(p6~&) + _BLUE32(p7~&) + _BLUE32(p8~&) + _BLUE32(p9~&)
            PSET (x, y), _RGB(r / 9, g / 9, b / 9)
        NEXT
    NEXT
NEXT
 
'=== Now we point to main screen
 
_SOURCE 0
_DEST 0 'set destination to draw to main screen
SCREEN _NEWIMAGE(1000, 800, 32) 'main screen size
 
RANDOMIZE TIMER 'do this so the RND call is different everytime
 
Eyes = 50 'the number of eyes on screen
EyeSizeMax = 250 'largest size eyes can be
 
DIM EyeX(Eyes), EyeY(Eyes) 'x/y position of the eye
DIM EyeSize(Eyes) ' size of eye
DIM EyeGrowth(Eyes) 'eye growing or shrinking on screen
DIM EyeDrift(Eyes) 'direction eye drifts across screen
DIM EyeDriftSpeed(Eyes) 'speed for the drift
DIM EyeBlinkFlag(Eyes) 'eyes blinking flag
DIM EyeBlinkCount(Eyes)
DIM EyeGoogly(Eyes)
 
'generate eye values
FOR d = 1 TO Eyes
    EyeX(d) = RND * _WIDTH 'make random x position
    EyeY(d) = RND * _HEIGHT 'make random y position
    EyeSize(d) = (RND * EyeSizeMax) 'random eye size, up to EyeSizeMax
    EyeGrowth(d) = INT(RND * 2) 'make way eye size is changing, 0=shrinking, 1=growing
    EyeDrift(d) = INT(RND * 4) 'make random direction a eye can drift (4 different ways)
    EyeDriftSpeed(d) = INT(RND * 3) + 2 'speed eyes will be drifting
    EyeBlinkFlag(d) = 0 'if eye is blinking or not
    EyeBlinkCount(d) = 0
    EyeGoogly(d) = 0
NEXT
 
 
DO
 
    WHILE _MOUSEINPUT: WEND
 
    'Bubble sort through eyesize, putting smallest size first so..
    '..they will be _PUTIMAGE'd first, putting them in the background.
    FOR b = 1 TO Eyes
        FOR b2 = 1 TO Eyes
            IF EyeSize(b2) > EyeSize(b) THEN
                SWAP EyeX(b), EyeX(b2)
                SWAP EyeY(b), EyeY(b2)
                SWAP EyeSize(b), EyeSize(b2)
                SWAP EyeGrowth(b), EyeGrowth(b2)
                SWAP EyeDrift(b), EyeDrift(b2)
                SWAP EyeDriftSpeed(b), EyeDriftSpeed(b2)
                SWAP EyeBlinkFlag(b), EyeBlinkFlag(b2)
                SWAP EyeBlinkCount(b), EyeBlinkCount(b2)
            END IF
        NEXT
    NEXT
 
    'CLS 'I don't think CLS is needed now, the back& image clears screen
 
    '=== rotozoom background image
 
    RotoZoom3 _WIDTH / 2, _HEIGHT / 2, back&, 30, 8, a
    a = a + .01: IF a >= 360 THEN a = a - 360
 
    '=== step through each eye
    FOR d = 1 TO Eyes
 
        'if eye is shrinking, subtract eyesize, else add to it
        IF EyeGrowth(d) = 0 THEN
            EyeSize(d) = EyeSize(d) - 1
        ELSE
            EyeSize(d) = EyeSize(d) + 1
        END IF
 
        'if eyesize reaches max size, switch growth to 0 start shrinking instead
        IF EyeSize(d) >= EyeSizeMax THEN EyeGrowth(d) = 0
 
        'if if reaches smallest eyesize, switch growth to 1 to start growing now
        IF EyeSize(d) <= 20 THEN EyeGrowth(d) = 1
 
        'drift eye in  1 of 4 directions we generated, and do +x,-x,+y,-y to it.
        IF EyeDrift(d) = 0 THEN EyeX(d) = EyeX(d) + EyeDriftSpeed(d) 'drift right
        IF EyeDrift(d) = 1 THEN EyeX(d) = EyeX(d) - EyeDriftSpeed(d) 'drift left
        IF EyeDrift(d) = 2 THEN EyeY(d) = EyeY(d) + EyeDriftSpeed(d) 'drift down
        IF EyeDrift(d) = 3 THEN EyeY(d) = EyeY(d) - EyeDriftSpeed(d) 'drift up
 
        'this creates the shakiness. randomly adjust x/y positions by +/-2 each step
        IF INT(RND * 2) = 0 THEN EyeX(d) = EyeX(d) + 2 ELSE EyeX(d) = EyeX(d) - 2
        IF INT(RND * 2) = 0 THEN EyeY(d) = EyeY(d) + 2 ELSE EyeY(d) = EyeY(d) - 2
 
        'below handles if eye goes off screen, let it dissapear completely.
        'If it had been clicked and Gone Googly, then reset speed afterwards
        IF EyeX(d) > _WIDTH + EyeSize(d) THEN EyeX(d) = -EyeSize(d): EyeDriftSpeed(d) = INT(RND * 3) + 2
        IF EyeX(d) < -EyeSize(d) THEN EyeX(d) = _WIDTH + EyeSize(d): EyeDriftSpeed(d) = INT(RND * 3) + 2
        IF EyeY(d) > _HEIGHT + EyeSize(d) THEN EyeY(d) = -EyeSize(d): EyeDriftSpeed(d) = INT(RND * 3) + 2
        IF EyeY(d) < -EyeSize(d) THEN EyeY(d) = _HEIGHT + EyeSize(d): EyeDriftSpeed(d) = INT(RND * 3) + 2
 
        'drift eye in  1 of 4 directions we generated, and +x,-x,+y,-y to it.
 
        'If blinking flag on...
        IF EyeBlinkFlag(d) = 1 THEN
 
            SELECT CASE EyeBlinkCount(d)
                CASE 0 TO 3
                    _PUTIMAGE (EyeX(d), EyeY(d))-(EyeX(d) + EyeSize(d), EyeY(d) + EyeSize(d)), eyeblink&
                CASE 4 TO 8
                    LINE (EyeX(d), EyeY(d) + (EyeSize(d) / 6))-(EyeX(d) + EyeSize(d), EyeY(d) + (EyeSize(d) / 6) + 3), _RGB(64, 64, 64), BF
                CASE 9 TO 12
                    _PUTIMAGE (EyeX(d), EyeY(d))-(EyeX(d) + EyeSize(d), EyeY(d) + EyeSize(d)), eyeblink&
            END SELECT
 
            EyeBlinkCount(d) = EyeBlinkCount(d) + 1
            IF EyeBlinkCount(d) > 12 THEN
                EyeBlinkCount(d) = 0
                EyeBlinkFlag(d) = 0
            END IF
 
        ELSE
            'showing normal eyes
            IF EyeDrift(d) = 0 THEN _PUTIMAGE (EyeX(d), EyeY(d))-(EyeX(d) + EyeSize(d), EyeY(d) + EyeSize(d)), eyeright& 'drift right
            IF EyeDrift(d) = 1 THEN _PUTIMAGE (EyeX(d), EyeY(d))-(EyeX(d) + EyeSize(d), EyeY(d) + EyeSize(d)), eyeleft& 'drift left
            IF EyeDrift(d) = 2 THEN _PUTIMAGE (EyeX(d), EyeY(d))-(EyeX(d) + EyeSize(d), EyeY(d) + EyeSize(d)), eyedown& 'drift down
            IF EyeDrift(d) = 3 THEN _PUTIMAGE (EyeX(d), EyeY(d))-(EyeX(d) + EyeSize(d), EyeY(d) + EyeSize(d)), eyeup& 'drift up
        END IF
 
 
        'Add code here to add nose and mouth to the here (next version...)
 
 
        'get random direction change,growth and blinking once in a while
        SELECT CASE INT(RND * 300)
            CASE 1: EyeDrift(d) = 0: EyeDriftSpeed(d) = INT(RND * 3) + 2
            CASE 2: EyeDrift(d) = 1: EyeDriftSpeed(d) = INT(RND * 3) + 2
            CASE 3: EyeDrift(d) = 2: EyeDriftSpeed(d) = INT(RND * 3) + 2
            CASE 4: EyeDrift(d) = 3: EyeDriftSpeed(d) = INT(RND * 3) + 2
            CASE 5: EyeGrowth(d) = 0
            CASE 6: EyeGrowth(d) = 1
            CASE 7: IF EyeBlinkFlag(d) = 0 THEN EyeBlinkFlag(d) = 1
        END SELECT
 
        IF _MOUSEBUTTON(1) THEN
            mx = _MOUSEX: my = _MOUSEY
            IF mx > EyeX(d) AND mx < EyeX(d) + EyeSize(d) AND my > EyeY(d) AND my < EyeY(d) + EyeSize(d) THEN
                EyeGrowth(d) = INT(RND * 2)
                EyeDrift(d) = INT(RND * 4)
                EyeDriftSpeed(d) = EyeDriftSpeed(d) + 4
                SOUND 7000 + (RND * 3000), .1
            END IF
        END IF
 
    NEXT
 
    _DISPLAY
    _LIMIT 30
 
LOOP UNTIL INKEY$ = CHR$(27)
SYSTEM
 
 
 
SUB ball (x, y, size, r&, g&, b&)
    'small sub that draws a filled ball with given color.
    FOR s = 1 TO size STEP .4
        CIRCLE (x, y), s, _RGB(r&, g&, b&)
        r& = r& - 1: g& = g& - 1: b& = b& - 1
    NEXT
END SUB
 
SUB RotoZoom3 (X AS LONG, Y AS LONG, Image AS LONG, xScale AS SINGLE, yScale AS SINGLE, radianRotation AS SINGLE)
    DIM px(3) AS SINGLE: DIM py(3) AS SINGLE ' simple arrays for x, y to hold the 4 corners of image
    DIM W&, H&, sinr!, cosr!, i&, x2&, y2& '  variables for image manipulation
    W& = _WIDTH(Image&): H& = _HEIGHT(Image&)
    px(0) = -W& / 2: py(0) = -H& / 2 'left top corner
    px(1) = -W& / 2: py(1) = H& / 2 ' left bottom corner
    px(2) = W& / 2: py(2) = H& / 2 '  right bottom
    px(3) = W& / 2: py(3) = -H& / 2 ' right top
    sinr! = SIN(-radianRotation): cosr! = COS(-radianRotation) ' rotation helpers
    FOR i& = 0 TO 3 ' calc new point locations with rotation and zoom
        x2& = xScale * (px(i&) * cosr! + sinr! * py(i&)) + X: y2& = yScale * (py(i&) * cosr! - px(i&) * sinr!) + Y
        px(i&) = x2&: py(i&) = y2&
    NEXT
    _MAPTRIANGLE _SEAMLESS(0, 0)-(0, H& - 1)-(W& - 1, H& - 1), Image TO(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
    _MAPTRIANGLE _SEAMLESS(0, 0)-(W& - 1, 0)-(W& - 1, H& - 1), Image TO(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
END SUB