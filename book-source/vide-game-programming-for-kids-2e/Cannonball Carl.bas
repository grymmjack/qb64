_TITLE "Cannonball Carl"

DATA 1,0,1,0,1,0,1,0,1,0,1,0,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1,1

'read castle data
DIM level(13, 5)
FOR a = 0 TO 4
    FOR b = 0 TO 12
        READ level(b, a)
        PRINT level(b, a);
    NEXT b
NEXT a


scrn& = _NEWIMAGE(800, 600, 32)
SCREEN scrn&

blue& = _RGB(30, 30, 200)
ltblue& = _RGB(30, 30, 250)
steel& = _RGB(159, 182, 205)
wood& = _RGB(133, 94, 66)
red& = _RGB(220, 0, 0)

'create castle bricks
brick& = _NEWIMAGE(60, 60, 32)
_DEST brick&
LINE (0, 0)-(59, 59), blue&, BF
LINE (0, 0)-(59, 59), ltblue&, B

'create the cannon
cannon& = _NEWIMAGE(60, 60, 32)
_DEST cannon&
LINE (15, 30)-(45, 55), wood&, BF
LINE (0, 40)-(59, 44), wood&, BF
LINE (0, 30)-(6, 55), steel&, BF
LINE (53, 30)-(59, 55), steel&, BF
LINE (24, 0)-(36, 59), steel&, BF
LINE (22, 35)-(38, 59), steel&, BF
cannon_x = 350
cannon_y = 520

'create the cannonball
cannonball& = _NEWIMAGE(24, 24, 32)
_DEST cannonball&
CIRCLE (10, 10), 10, red&
PAINT (10, 10), red&
cannonball_x = 0
cannonball_y = 0
shooting = 0

_DEST scrn&

DO
    CLS

    'draw the castle
    FOR a = 0 TO 4
        FOR b = 0 TO 12
            IF level(b, a) = 1 THEN
                x = 10 + b * 60
                y = 10 + a * 60
                _PUTIMAGE (x, y), brick&, scrn& 'draw one brick

                'see if cannonball hit a block
                IF shooting = 1 THEN
                    cx = cannonball_x + 10
                    cy = cannonball_y + 10
                    IF cx > x AND cx < x + 60 AND cy > y AND cy < y + 60 THEN
                        shooting = 0
                        level(b, a) = 0 'block hit
                    END IF
                END IF
            END IF
        NEXT b
    NEXT a

    'get mouse position
    mouse = _MOUSEINPUT
    cannon_x = _MOUSEX
    IF cannon_x > 740 THEN cannon_x = 740

    'draw the cannon
    _PUTIMAGE (cannon_x, cannon_y), cannon&, scrn&


    'fire cannon!
    IF _MOUSEBUTTON(1) AND shooting = 0 THEN
        shooting = 1
        cannonball_x = cannon_x + 20
        cannonball_y = cannon_y - 20
    END IF

    'draw cannonball
    IF shooting = 1 THEN
        _PUTIMAGE (cannonball_x, cannonball_y), cannonball&, scrn&
    END IF

    'move cannonball
    cannonball_y = cannonball_y - 2
    IF cannonball_y < 0 THEN
        shooting = 0
    END IF

    'see if the castle is destroyed
    count = 0
    FOR a = 0 TO 4
        FOR b = 0 TO 12
            IF level(b, a) = 1 THEN
                count = count + 1
            END IF
        NEXT b
    NEXT a
    IF count = 0 THEN
        _PRINTSTRING (300, 300), "YOU TOTALLY HOSED THE CASTLE!"
        _PRINTSTRING (350, 350), "Y O U   R U L E ! !"
    END IF



    _DISPLAY

LOOP UNTIL INKEY$ = CHR$(27)
SYSTEM

