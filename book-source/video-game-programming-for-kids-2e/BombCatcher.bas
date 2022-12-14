'************************************
_TITLE "Bomb Catcher"
'************************************

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
DIM SHARED background AS Sprite
DIM SHARED basket AS Sprite
DIM SHARED bomb AS Sprite
DIM SHARED keyLeft, keyRight
DIM SHARED explode_sound&

CALL InitGame
CALL LoadGame

'**************************
' GAME LOOP
'**************************
DO UNTIL gameover = 1
    CALL GetInput
    CALL MoveBasket
    CALL MoveBomb
    CALL CatchBomb
    CALL SpriteDraw(background)
    CALL PrintInfo
    CALL SpriteDraw(bomb)
    CALL SpriteDraw(basket)
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
RANDOMIZE TIMER
score = 0
lives = 3
gameover = 0
END SUB

'********************
' LoadGame Sub
'********************
SUB LoadGame
CALL MakeBackground
CALL LoadBasket
CALL LoadBomb
explode_sound& = _SNDOPEN("explode.wav")
_DEST scrn&
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
    c& = _RGB(0, 256 - y / 4, 0)
    LINE (0, y)-(799, y + 4), c&, BF
NEXT y
END SUB

'********************
' LoadBasket Sub
'********************
SUB LoadBasket
basket.image = _LOADIMAGE("basket.png")
basket.width = _WIDTH(basket.image)
basket.height = _HEIGHT(basket.image)
basket.x = 350
basket.y = 450
END SUB

'********************
' LoadBomb Sub
'********************
SUB LoadBomb
bomb.image = _LOADIMAGE("bomb.png")
bomb.width = _WIDTH(bomb.image)
bomb.height = _HEIGHT(bomb.image)
bomb.x = RND * (800 - bomb.width)
bomb.y = -200
END SUB

'********************
' PrintInfo Sub
'********************
SUB PrintInfo
_PRINTMODE _KEEPBACKGROUND
COLOR _RGB(0, 0, 0), _RGBA(0, 0, 0, 0)
_PRINTSTRING (0, 0), "SCORE " + STR$(score)
_PRINTSTRING (700, 0), "LIVES " + STR$(lives)
_PRINTSTRING (0, 20), STR$(bomb.width) + "," + STR$(bomb.height)
END SUB

'********************
' GetInput Sub
'********************
SUB GetInput
k = _KEYHIT
IF k > 0 THEN 'press
    IF k = 27 THEN gameover = 1
    code = k / 256
    IF code = 75 THEN keyLeft = 1
    IF code = 77 THEN keyRight = 1
ELSEIF k < 0 THEN 'release
    k = -k
    code = k / 256
    IF code = 75 THEN keyLeft = 0
    IF code = 77 THEN keyRight = 0
END IF
END SUB

'********************
' MoveBasket Sub
'********************
SUB MoveBasket
IF keyLeft = 1 THEN basket.x = basket.x - 4
IF keyRight = 1 THEN basket.x = basket.x + 4
IF basket.x < 0 THEN
    basket.x = 0
ELSEIF basket.x > 800 - basket.width THEN
    basket.x = 800 - basket.width
END IF
END SUB

'********************
' MoveBomb Sub
'********************
SUB MoveBomb
bomb.y = bomb.y + 2
IF bomb.y > basket.y + 100 THEN
    _SNDPLAY explode_sound&
    lives = lives - 1
    IF lives <= 0 THEN gameover = 1
    bomb.x = RND * (800 - bomb.width)
    bomb.y = -200
END IF
END SUB

'********************
' CatchBomb Sub
'********************
SUB CatchBomb
c = SpriteCollision(bomb, basket)
IF c = 1 THEN
    bomb.x = RND * (800 - bomb.width)
    bomb.y = -200
    score = score + 10
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


