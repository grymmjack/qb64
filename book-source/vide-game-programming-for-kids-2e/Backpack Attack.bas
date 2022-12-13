_TITLE "Backpack Attack"

scrn& = _NEWIMAGE(800, 600, 32)
SCREEN scrn&
green& = _RGB(20, 220, 20)
blue& = _RGB(20, 20, 230)
ltblue& = _RGB(30, 30, 250)
red& = _RGB(220, 20, 20)
yellow& = _RGB(220, 220, 20)
wood& = _RGB(133, 94, 66)
orange& = _RGB(255, 127, 0)
white& = _RGB(255, 255, 255)

'make the kid
kid& = _NEWIMAGE(40, 60, 32)
_DEST kid&
CIRCLE (20, 12), 7, blue&
LINE (20, 20)-(20, 40), blue&
LINE (20, 20)-(10, 40), blue&
LINE (20, 20)-(30, 40), blue&
LINE (20, 40)-(10, 60), blue&
LINE (20, 40)-(30, 60), blue&
kid_x = 100
kid_y = 340
die$ = "false"
gameover$ = "false"
kid_score = 0

'make the muscle man
muscle& = _NEWIMAGE(80, 80, 32)
_DEST muscle&
CIRCLE (40, 12), 8, red&
LINE (40, 20)-(40, 40), red&
LINE (40, 25)-(25, 25), red&
LINE (28, 22)-(33, 26), red&, BF
LINE (25, 25)-(15, 15), red&
LINE (40, 25)-(55, 25), red&
LINE (48, 22)-(53, 26), red&, BF
LINE (55, 25)-(65, 15), red&
LINE (40, 40)-(30, 60), red&
LINE (40, 40)-(50, 60), red&
muscle_x = 600
muscle_y = 340
stunned = 0
muscle_score = 0

'make the backpack
backpack& = _NEWIMAGE(40, 40, 32)
_DEST backpack&
LINE (5, 0)-(35, 39), yellow&, B
LINE (10, 0)-(14, 39), yellow&, BF
LINE (30, 0)-(26, 39), yellow&, BF
bp_x = 300
bp_y = 10

'make the "apple"
apple& = _NEWIMAGE(10, 10, 32)
_DEST apple&
CIRCLE (5, 5), 4, orange&
PAINT (5, 5), orange&
apple_x = 0
apple_y = 0
throwing$ = "false"
apple_dir = 0

_DEST scrn&
DO
    CLS

    'draw the level
    LINE (50, 400)-(750, 430), green&, BF

    'draw the kid
    IF kid_x < 50 OR kid_x > 750 THEN die$ = "true"
    IF die$ = "true" THEN
        _PRINTSTRING (kid_x, 350), "AHHH!!!"
        kid_y = kid_y + 0.5
        IF kid_y > 600 THEN gameover$ = "true"
    END IF
    _PUTIMAGE (kid_x, kid_y), kid&

    'draw muscle man
    _PUTIMAGE (muscle_x, muscle_y), muscle&
    IF stunned > 0 THEN
        _PRINTSTRING (muscle_x + 25, muscle_y - 20), "OUCH!"
        stunned = stunned + 1
        IF stunned > 1000 THEN stunned = 0
    ELSE
        IF muscle_x < bp_x THEN
            muscle_x = muscle_x + 0.2
        ELSEIF muscle_x > bp_x THEN
            muscle_x = muscle_x - 0.2
        END IF
    END IF

    'draw backpack
    bp_y = bp_y + 1
    IF bp_y >= 360 THEN
        bp_y = 360
        'see if kid got it
        IF kid_x > bp_x AND kid_x < bp_x + 30 THEN
            bp_x = 50 + RND * 700
            bp_y = 0
            kid_score = kid_score + 1
        END IF
        'see if muscle man got it
        IF muscle_x > bp_x AND muscle_x < bp_x + 30 THEN
            bp_x = 50 + RND * 700
            bp_y = 0
            muscle_score = muscle_score + 1
        END IF
    END IF
    _PUTIMAGE (bp_x, bp_y), backpack&

    'draw the apple
    IF throwing$ = "true" THEN
        apple_x = apple_x + apple_dir
        IF apple_x < 0 OR apple_x > 800 THEN throwing$ = "false"
        IF apple_x > muscle_x AND apple_x < muscle_x + 40 THEN
            throwing$ = "false"
            stunned = 1
        END IF
        _PUTIMAGE (apple_x, apple_y), apple&
    END IF

    IF gameover$ = "true" THEN
        _PRINTSTRING (350, 200), "G A M E  O V E R"
    END IF

    _PRINTSTRING (10, 10), "KID:" + STR$(kid_score)
    _PRINTSTRING (670, 10), "MUSCLE MAN:" + STR$(muscle_score)

    k$ = INKEY$
    IF k$ <> "" THEN
        code = ASC(k$)
        IF code = 120 THEN 'x
            IF throwing$ = "false" THEN
                throwing$ = "true"
                apple_x = kid_x + 30
                apple_y = kid_y + 20
                apple_dir = 1
            END IF
        ELSEIF code = 122 THEN 'z
            IF throwing$ = "false" THEN
                throwing$ = "true"
                apple_x = kid_x + 30
                apple_y = kid_y + 20
                apple_dir = -1
            END IF
        ELSEIF code = 0 THEN 'special key
            code = ASC(k$, 2)
            IF code = 72 THEN 'up
            ELSEIF code = 80 THEN 'down
            ELSEIF code = 75 THEN 'left
                kid_x = kid_x - 4
            ELSEIF code = 77 THEN 'right
                kid_x = kid_x + 4
            END IF
        END IF
    END IF
    _DISPLAY
LOOP UNTIL k$ = CHR$(27)
END

