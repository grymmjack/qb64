'************************************
_TITLE "Attack of the Alien Beetles"
'************************************

TYPE Star
    x AS SINGLE
    y AS SINGLE
    brightness AS INTEGER
    speed AS SINGLE
END TYPE

TYPE Sprite
    alive AS INTEGER
    x AS SINGLE
    y AS SINGLE
    width AS INTEGER
    height AS INTEGER
    speed_x AS SINGLE
    speed_y AS SINGLE
    image AS LONG
END TYPE

DIM SHARED scrn&
DIM SHARED lives, score, gameover
DIM SHARED stars(100) AS Star
DIM SHARED ship AS Sprite
DIM SHARED aliens(20) AS Sprite
DIM SHARED bullets(20) AS Sprite

CALL InitGame
CALL MakeStars
CALL MakeShip
CALL MakeAliens
CALL MakeBullets

'**************************
' GAME LOOP
'**************************
DO WHILE gameover = 0
    CLS
    CALL DrawStars
    CALL SpriteDraw(ship)
    CALL DrawAliens
    CALL DrawBullets
    CALL PrintInfo
    CALL MoveShip
    CALL CheckCollisions
    CALL GetInput
    _DISPLAY
LOOP
END

'********************
' InitGame Sub
'********************
SUB InitGame
scrn& = _NEWIMAGE(800, 600, 32)
SCREEN scrn&
_SCREENMOVE _MIDDLE
lives = 3
score = 0
gameover = 0
END SUB

'********************
' MakeStars Sub
'********************
SUB MakeStars
DIM b AS SINGLE
FOR n = 1 TO 100
    stars(n).x = RND * 800
    stars(n).y = RND * 600
    b = 50 + RND * 200
    stars(n).brightness = b
    stars(n).speed = b / 1000.0
NEXT n
END SUB

'********************
' DrawStars Sub
'********************
SUB DrawStars
FOR n = 1 TO 100
    b = stars(n).brightness
    x = stars(n).x
    y = stars(n).y
    LINE (x - 1, y - 1)-(x + 1, y + 1), _RGB(b, b, b), BF
    stars(n).x = stars(n).x - stars(n).speed
    IF stars(n).x < 0 THEN stars(n).x = 800
NEXT n
END SUB

'********************
' MakeShip Sub
'********************
SUB MakeShip
ship.image = _LOADIMAGE("ship_side.png")
ship.x = 0
ship.y = 280
ship.width = _WIDTH(ship.image)
ship.height = _HEIGHT(ship.image)
END SUB


'********************
' MoveShip Sub
'********************
SUB MoveShip
CALL SpriteMove(ship)
IF ship.y < 0 THEN
    ship.y = 0
ELSEIF ship.y > 520 THEN
    ship.y = 520
END IF
END SUB



'********************
' MakeAliens Sub
'********************
SUB MakeAliens
image& = _LOADIMAGE("beetle.png")
FOR n = 1 TO 20
    aliens(n).image = image&
    aliens(n).x = 800 + RND * 800
    aliens(n).y = RND * 530
    aliens(n).speed_x = -RND / 3
    aliens(n).speed_y = 0
    aliens(n).width = _WIDTH(image&)
    aliens(n).height = _WIDTH(image&)
NEXT n
END SUB

'********************
' DrawAliens Sub
'********************
SUB DrawAliens
FOR n = 1 TO 20
    CALL SpriteDraw(aliens(n))
    CALL SpriteMove(aliens(n))
    IF aliens(n).x < -64 THEN aliens(n).x = 800
NEXT n
END SUB


'********************
' MakeBullets Sub
'********************
SUB MakeBullets
image& = _LOADIMAGE("bullet.png")
FOR n = 1 TO 20
    bullets(n).image = image&
    bullets(n).alive = 0
    bullets(n).x = 0
    bullets(n).y = 0
    bullets(n).width = _WIDTH(image&)
    bullets(n).height = _HEIGHT(image&)
NEXT n
END SUB

'********************
' DrawBullets Sub
'********************
SUB DrawBullets
FOR n = 1 TO 20
    IF bullets(n).alive = 1 THEN
        CALL SpriteDraw(bullets(n))
        bullets(n).x = bullets(n).x + bullets(n).speed_x
        IF bullets(n).x > 800 THEN bullets(n).alive = 0
    END IF
NEXT n
END SUB


'********************
' PrintInfo Sub
'********************
SUB PrintInfo
_PRINTMODE _KEEPBACKGROUND
_PRINTSTRING (0, 0), "SCORE " + STR$(score)
_PRINTSTRING (650, 0), "LIVES " + STR$(lives)
END SUB

'********************
' FireBullet Sub
'********************
SUB FireBullet
FOR n = 1 TO 20
    IF bullets(n).alive = 0 THEN
        bullets(n).alive = 1
        bullets(n).speed_x = 1.5
        bullets(n).speed_y = 0
        bullets(n).x = ship.x + ship.width
        bullets(n).y = ship.y + ship.height / 2 - 4
        EXIT FOR
    END IF
NEXT n
END SUB


'********************
' CheckCollisions Sub
'********************
SUB CheckCollisions
'see if ship crashed into any aliens
FOR n = 1 TO 20
    c = SpriteCollision(ship, aliens(n))
    IF c = 1 THEN
        _PRINTSTRING (ship.x + 100, ship.y), "ACK! WE'VE BEEN HIT!"
        _DISPLAY
        SLEEP
        aliens(n).x = 800 + RND * 400
        lives = lives - 1
        IF lives <= 0 THEN gameover = 1
    END IF
NEXT n

'see if bullets hit any aliens
FOR b = 1 TO 20
    IF bullets(b).alive = 1 THEN
        FOR a = 1 TO 20
            c = SpriteCollision(bullets(b), aliens(a))
            IF c = 1 THEN
                score = score + 1
                bullets(b).alive = 0
                aliens(a).x = 800
            END IF
        NEXT a
    END IF
NEXT b
END SUB

'********************
' GetInput Sub
'********************
SUB GetInput
k$ = INKEY$
IF k$ <> "" THEN
    code = ASC(k$)
    IF code = 0 THEN
        code = ASC(k$, 2)
        IF code = 72 THEN 'Up
            ship.speed_y = -0.5
        ELSEIF code = 80 THEN 'Down
            ship.speed_y = 0.5
        ELSE
            ship.speed_y = 0
        END IF
    ELSEIF code = 32 THEN 'Space
        CALL FireBullet
    ELSEIF code = 27 THEN 'Escape
        gameover = 1
    END IF
END IF

END SUB



'********************
' DrawSprite Sub
'********************
SUB SpriteDraw (spr AS Sprite)
_PUTIMAGE (spr.x, spr.y), spr.image
END SUB

'********************
' MoveSprite Sub
'********************
SUB SpriteMove (spr AS Sprite)
spr.x = spr.x + spr.speed_x
spr.y = spr.y + spr.speed_y
END SUB

'**************************
' SpriteCollision Function
'**************************
FUNCTION SpriteCollision (spr1 AS Sprite, spr2 AS Sprite)
SpriteCollision = 0
'test first sprite
cx = spr1.x + spr1.width / 2
cy = spr1.y + spr1.height / 2
IF cx > spr2.x AND cx < spr2.x + spr2.width THEN
    IF cy > spr2.y AND cy < spr2.y + spr2.height THEN
        SpriteCollision = 1
        EXIT FUNCTION
    END IF
END IF
'test second sprite
cx = spr2.x + spr2.width / 2
cy = spr2.y + spr2.height / 2
IF cx > spr1.x AND cx < spr1.x + spr1.width THEN
    IF cy > spr1.y AND cy < spr1.y + spr1.height THEN
        SpriteCollision = 1
        EXIT FUNCTION
    END IF
END IF

END FUNCTION


