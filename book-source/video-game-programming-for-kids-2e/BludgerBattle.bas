'********************
' Bludger Battle Game
'********************

_TITLE "Bludger Battle"

TYPE Sprite
    alive AS INTEGER
    x AS INTEGER
    y AS INTEGER
    width AS INTEGER
    height AS INTEGER
    speed_x AS SINGLE
    speed_y AS SINGLE
    image AS LONG
END TYPE

DIM SHARED scrn&
DIM SHARED paddle AS Sprite
DIM SHARED ball AS Sprite
DIM SHARED block_count, block_image&
DIM SHARED level(13, 5) AS INTEGER
DIM SHARED blocks(120) AS Sprite
DIM SHARED background AS Sprite
DIM score, gameover, waiting, lives


CALL InitGame
CALL MakeBackground
CALL MakePaddle
CALL MakeBlock
CALL MakeBall
CALL BuildLevel

'********************
' GAME LOOP
'********************
_DEST scrn&
score = 0
waiting = 1
lives = 3
gameover = 0
DO UNTIL gameover = 1
    CALL SpriteDraw(background) 'draw background
    CALL SpriteDraw(paddle) 'draw paddle
    CALL SpriteDraw(ball) 'draw ball

    'draw the blocks
    total = 0
    FOR n = 1 TO block_count
        IF blocks(n).alive = 1 THEN
            total = total + 1
            CALL SpriteDraw(blocks(n))
        END IF
    NEXT n

    'see if level is cleared
    IF total = 0 THEN
        _PRINTSTRING (350, 350), "GAME OVER"
        _DISPLAY
        SLEEP
        gameover = 1
    END IF

    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING (0, 0), "SCORE:" + STR$(score)
    _PRINTSTRING (650, 0), "LIVES:" + STR$(lives)

    'finish doing graphics
    _DISPLAY

    'move the ball
    IF waiting = 0 THEN 'wait for player to start
        CALL SpriteMove(ball)
        CALL SpriteBounce(ball, 0, 0, 780, 580)
    ELSE
        ball.x = paddle.x + paddle.width / 2
        ball.y = paddle.y - 20
    END IF

    'check for ball-paddle collision
    IF SpriteCollision(ball, paddle) = 1 THEN
        ball.y = paddle.y - ball.height
        ball.speed_y = -ball.speed_y
    END IF

    'check for ball-block collisions
    FOR n = 1 TO block_count
        IF blocks(n).alive = 1 THEN
            IF SpriteCollision(blocks(n), ball) = 1 THEN
                score = score + 10
                blocks(n).alive = 0
                ball.speed_y = ABS(ball.speed_y)
            END IF
        END IF
    NEXT n

    'check whether player lost the ball
    IF ball.y > paddle.y + paddle.height THEN
        waiting = 1
        lives = lives - 1
        IF lives = 0 THEN gameover = 1
    END IF

    'check mouse movement
    mouse = _MOUSEINPUT
    paddle.x = _MOUSEX
    IF paddle.x < 10 THEN paddle.x = 10
    IF paddle.x > 700 THEN paddle.x = 700

    'check mouse buttons
    IF _MOUSEBUTTON(1) <> 0 THEN
        waiting = 0
    END IF

    'check keys
    k$ = INKEY$
    IF k$ <> "" THEN
        IF k$ = CHR$(27) THEN gameover = 1
    END IF
LOOP
END

'********************
' InitGame Sub
'********************
SUB InitGame
scrn& = _NEWIMAGE(800, 600, 32)
SCREEN scrn&
RANDOMIZE TIMER
_MOUSEHIDE
END SUB

'********************
' BuildLevel Sub
'********************
DATA 1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,0,1,0,1,0,0,0,1,0,1,1
DATA 1,0,1,0,1,0,1,0,1,0,1,1
DATA 1,0,0,0,1,0,0,0,1,0,1,1
DATA 1,0,1,0,1,0,1,0,1,1,1,1
DATA 1,0,1,0,1,0,1,0,1,0,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1
DATA 1,1,1,1,1,1,1,1,1,1,1,1

SUB BuildLevel ()
block_count = 1
FOR row = 0 TO 8
    FOR col = 0 TO 11
        READ block_data
        i = block_count
        blocks(i).alive = block_data
        blocks(i).x = 34 + col * 61
        blocks(i).y = 40 + row * 31
        blocks(i).width = 60
        blocks(i).height = 30
        blocks(i).image = block_image&
        block_count = block_count + 1
    NEXT col
NEXT row

END SUB


'********************
' MakeBackground Sub
'********************
SUB MakeBackground
background.x = 0
background.y = 0
background.width = 800
background.height = 600
background.image = _NEWIMAGE(800, 600, 32)
_DEST background.image
FOR y = 0 TO 599 STEP 4
    c& = _RGB(y / 10, y / 10, 256 - y / 10 * 3)
    LINE (0, y)-(799, y + 4), c&, BF
NEXT y
END SUB

'********************
' MakePaddle Sub
'********************
SUB MakePaddle
paddle.image = _NEWIMAGE(90, 24, 32)
_DEST paddle.image
LINE (0, 0)-(89, 23), _RGB(20, 90, 90), BF
LINE (2, 2)-(87, 21), _RGB(20, 220, 220), BF
paddle.x = 350
paddle.y = 520
paddle.width = 90
paddle.height = 24
END SUB

'********************
' MakeBlock Sub
'********************
SUB MakeBlock
block_image& = _NEWIMAGE(60, 30, 32)
_DEST block_image&
LINE (0, 0)-(59, 29), _RGB(90, 20, 90), BF
LINE (4, 4)-(55, 25), _RGB(220, 20, 220), BF
END SUB

'********************
' MakeBall Sub
'********************
SUB MakeBall
white& = _RGB(255, 255, 255)
ball.image = _NEWIMAGE(12, 12, 32)
_DEST ball.image
CIRCLE (6, 6), 5, white&
PAINT (6, 6), white&
ball.x = 350
ball.y = 500
ball.width = 24
ball.height = 24
ball.speed_x = 0.7
ball.speed_y = 1.4
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

'********************
' SpriteBounce Sub
'********************
SUB SpriteBounce (spr AS Sprite, minx, miny, maxx, maxy)
IF spr.x < minx THEN
    spr.x = minx
    spr.speed_x = -spr.speed_x
ELSEIF spr.x > maxx THEN
    spr.x = maxx
    spr.speed_x = -spr.speed_x
END IF
IF spr.y < miny THEN
    spr.y = miny
    spr.speed_y = -spr.speed_y
ELSEIF spr.y > maxy THEN
    spr.y = maxy
    spr.speed_y = -spr.speed_y
END IF

END SUB

