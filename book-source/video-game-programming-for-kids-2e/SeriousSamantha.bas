_TITLE "Serious Samantha"
RANDOMIZE TIMER
scrn& = _NEWIMAGE(800, 600, 32)
SCREEN scrn&

TYPE Sprite
    alive AS INTEGER
    x AS INTEGER
    y AS INTEGER
    width AS INTEGER
    height AS INTEGER
END TYPE

DIM sam AS Sprite
DIM zombie_frame&
DIM zombie&(2)
DIM zombie_mob(100) AS Sprite
DIM survivor_group(20) AS Sprite
DIM bullets(20) AS Sprite

green& = _RGB(30, 255, 30)
black& = _RGB(0, 0, 0)
gunmetal& = _RGB(120, 120, 144)
orange& = _RGB(255, 140, 0)
red& = _RGB(255, 20, 20)

'make the player
samantha& = _NEWIMAGE(60, 60, 32)
_DEST samantha&
CIRCLE (20, 15), 8, green&
PAINT (20, 15), green&
CIRCLE (20, 17), 6, black&
PAINT (20, 17), black&
CIRCLE (20, 17), 6, green&
PSET (18, 15), green&
PSET (22, 15), green&
LINE (18, 19)-(22, 19), green&
LINE (18, 19)-(20, 21), green&
LINE (20, 21)-(22, 19), green&
LINE (20, 24)-(20, 38), green&
LINE (20, 28)-(13, 32), green&
LINE (20, 28)-(27, 32), green&
LINE (20, 38)-(15, 50), green&
LINE (20, 38)-(25, 50), green&
LINE (13, 33)-(37, 36), gunmetal&, BF
sam.x = 150
sam.y = 350
sam.width = 60
sam.height = 60

'make a survivor
survivor& = _NEWIMAGE(60, 60, 32)
_DEST survivor&
CIRCLE (20, 17), 6, green&
PSET (18, 15), green&
PSET (22, 15), green&
LINE (18, 19)-(22, 19), green&
LINE (20, 24)-(20, 38), green&
LINE (20, 30)-(13, 26), green&
LINE (20, 30)-(27, 26), green&
LINE (20, 38)-(15, 50), green&
LINE (20, 38)-(25, 50), green&

FOR n = 1 TO 20
    survivor_group(n).alive = 1
    survivor_group(n).x = RND * 80
    survivor_group(n).y = RND * 540
    survivor_group(n).width = 60
    survivor_group(n).height = 60
NEXT n


'make a zombie
zombie&(1) = _NEWIMAGE(60, 60, 32)
_DEST zombie&(1)
CIRCLE (20, 17), 7, orange&
CIRCLE (18, 16), 1, orange&
CIRCLE (22, 16), 1, orange&
LINE (21, 14)-(24, 15), orange&
LINE (17, 20)-(23, 20), orange&
LINE (20, 24)-(20, 38), orange&
LINE (20, 28)-(10, 26), orange&
LINE (20, 28)-(10, 34), orange&
LINE (20, 38)-(15, 50), orange&
LINE (20, 38)-(25, 50), orange&

zombie&(2) = _NEWIMAGE(60, 60, 32)
_DEST zombie&(2)
CIRCLE (20, 17), 7, orange&
CIRCLE (18, 16), 1, orange&
CIRCLE (22, 16), 1, orange&
LINE (21, 14)-(24, 15), orange&
LINE (17, 20)-(23, 20), orange&
LINE (20, 24)-(20, 38), orange&
LINE (20, 28)-(10, 26), orange&
LINE (20, 28)-(10, 34), orange&
LINE (20, 38)-(18, 50), orange&
LINE (20, 38)-(22, 50), orange&
zombie_frame = 1

FOR n = 1 TO 100
    zombie_mob(n).alive = 1
    zombie_mob(n).x = 400 + RND * 400
    zombie_mob(n).y = RND * 540
    zombie_mob(n).width = 60
    zombie_mob(n).height = 60
NEXT n


'make a bullet
bullet& = _NEWIMAGE(8, 8, 32)
_DEST bullet&
CIRCLE (4, 4), 3, red&
PAINT (4, 4), red&

FOR n = 1 TO 20
    bullets(n).alive = 0
    bullets(n).x = 0
    bullets(n).y = 0
    bullets(n).width = 8
    bullets(n).height = 8
NEXT n

score = 0
gameover = 0

_DEST scrn&
DO
    CLS

    'draw the player
    _PUTIMAGE (sam.x, sam.y), samantha&

    'draw survivors
    FOR n = 1 TO 20
        _PUTIMAGE (survivor_group(n).x, survivor_group(n).y), survivor&
    NEXT n

    'draw zombies
    FOR n = 1 TO 100
        _PUTIMAGE (zombie_mob(n).x, zombie_mob(n).y), zombie&(zombie_frame)
    NEXT n

    'animate and move zombies
    IF TIMER - anim_timer >= 0.5 THEN
        zombie_frame = zombie_frame + 1
        IF zombie_frame > 2 THEN zombie_frame = 1
        anim_timer = TIMER
        FOR n = 1 TO 100
            zombie_mob(n).x = zombie_mob(n).x - 4
            IF zombie_mob(n).x < 100 THEN gameover = 1
        NEXT n
    END IF

    'draw and move bullets
    FOR n = 1 TO 20
        IF bullets(n).alive = 1 THEN
            _PUTIMAGE (bullets(n).x, bullets(n).y), bullet&
            bullets(n).x = bullets(n).x + 2
            IF bullets(n).x > 800 THEN bullets(n).alive = 0
        END IF
    NEXT n

    'show the score
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING (0, 0), "SCORE " + STR$(score)

    _DISPLAY

    'see if bullets hit any zombies
    FOR b = 1 TO 20
        IF bullets(b).alive = 1 THEN
            FOR z = 1 TO 100
                c = Collision(bullets(b), zombie_mob(z))
                IF c = 1 THEN
                    score = score + 1
                    bullets(b).alive = 0
                    zombie_mob(z).x = zombie_mob(z).x + 400
                END IF
            NEXT z
        END IF
    NEXT b


    k$ = INKEY$
    IF k$ <> "" THEN
        code = ASC(k$)
        IF code = 0 THEN
            'detect arrow keys
            code = ASC(k$, 2)
            IF code = 72 THEN 'up
                sam.y = sam.y - 8
                IF sam.y < 0 THEN sam.y = 0
            ELSEIF code = 80 THEN 'down
                sam.y = sam.y + 8
                IF sam.y > 540 THEN sam.y = 540
            END IF
        ELSEIF code = 32 THEN 'space
            FOR n = 1 TO 20
                IF bullets(n).alive = 0 THEN
                    bullets(n).alive = 1
                    bullets(n).x = sam.x + sam.width / 2
                    bullets(n).y = sam.y + sam.height / 2
                    EXIT FOR
                END IF
            NEXT n
        ELSEIF code = 27 THEN 'escape
            gameover = 1
        END IF
    END IF
LOOP UNTIL gameover = 1
_PRINTSTRING (350, 0), "OH NO, THE ZOMBIES GOT THROUGH!"
_PRINTSTRING (350, 20), "GAME OVER, MAN! GAME OVER!"
_DISPLAY
END

FUNCTION Collision (sprite1 AS Sprite, sprite2 AS Sprite)
Collision = 0
cx = sprite1.x + sprite1.width / 2
cy = sprite1.y + sprite1.height / 2
IF cx > sprite2.x AND cx < sprite2.x + sprite2.width THEN
    IF cy > sprite2.y AND cy < sprite2.y + sprite2.height THEN
        Collision = 1
        EXIT FUNCTION
    END IF
END IF
END FUNCTION

