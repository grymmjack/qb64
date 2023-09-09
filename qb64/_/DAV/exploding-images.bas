 
'================
'EXPLODEIMAGE.BAS
'================
'Explodes a small image on the screen, fading out screen.
'It does this loading all image pixel data into arrays,
'and changing the x/y position of pixels on the screen.
'Alpha transparecy is used for screen fading effect.
'Tested & Working under Windows/Linux QB64-PE 3.8.0.
'Coded by Dav, SEP/2023
 
 
_ICON 'NEED THIS. Using Phoenix ICON in this example as the image
 
RANDOMIZE TIMER
 
SCREEN _NEWIMAGE(800, 600, 32)
 
'Get a bird& image from the built-in ICON
bird& = _NEWIMAGE(192, 192, 32): _DEST bird&
_PUTIMAGE (0, 0)-(192, 192), -11: _DEST 0
 
'draw a background for to show fading better
FOR x = 1 TO _WIDTH STEP 20
    FOR y = 1 TO _HEIGHT STEP 20
        LINE (x, y)-STEP(10, 10), _RGBA(RND * 255, RND * 255, RND * 255, RND * 255), BF
    NEXT
NEXT
 
'compute center spot for placing image on screen
cx = _WIDTH / 2 - (_WIDTH(bird&) / 2) 'x center image on screen
cy = _HEIGHT / 2 - (_HEIGHT(bird&) / 2) 'y center image on screen
 
'Show and Explode the image
ExplodeImage bird&, cx, cy
 
END
 
SUB ExplodeImage (image&, x, y)
 
    _PUTIMAGE (x, y), image&
    PRINT "Press any key to Explode the image..."
    _DISPLAY
    SLEEP
 
    pixels& = _WIDTH(image&) * _HEIGHT(image&)
 
    REDIM PixX(pixels&), PixY(pixels&)
    REDIM PixXDir(pixels&), PixYDir(pixels&)
    REDIM PixClr&(pixels&)
 
    'Read all pixels from image& into arrays,
    'and generate x/y movement values
    _SOURCE image&
    pix& = 0
    FOR x2 = 0 TO _WIDTH(image&) - 1
        FOR y2 = 0 TO _HEIGHT(image&) - 1
            PixClr&(pix&) = POINT(x2, y2) 'pixel color
            PixX(pix&) = x + x2 'pixel x pos
            PixY(pix&) = y + y2 'pixel y pos
            'generate random x/y dir movement values
            DO
                'assign a random x/y dir value (from range -8 to 8)
                PixXDir(pix&) = RND * 8 - RND * 8 'go random +/- x pixels
                PixYDir(pix&) = RND * 8 - RND * 8 'go random +/- y pixels
                'Keep looping until both directions have non-zero values
                IF PixXDir(pix&) <> 0 AND PixYDir(pix&) <> 0 THEN EXIT DO
            LOOP
            pix& = pix& + 1 'goto next pixels
        NEXT
    NEXT
    _SOURCE 0
 
    'Explode image and Fade out screen
    FOR alpha = 0 TO 225 STEP .8
        'display all pixels
        FOR pix& = 0 TO pixels& - 1
            'pixel x pos, +/- dir value
            PixX(pix&) = PixX(pix&) + PixXDir(pix&)
            'pixel y pos, +/- dir value
            PixY(pix&) = PixY(pix&) + PixYDir(pix&)
            PSET (PixX(pix&), PixY(pix&)), PixClr&(pix&)
        NEXT
        'the fade out trick
        LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, alpha), BF
        _LIMIT 30
        _DISPLAY
    NEXT
 
END SUB