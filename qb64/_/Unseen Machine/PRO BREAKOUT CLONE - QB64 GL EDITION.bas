' PRO BREAKOUT CLONE - QB64 GL EDITION
_TITLE "NEON BREAKOUT ULTRA"
SCREEN _NEWIMAGE(800, 600, 32)
RANDOMIZE TIMER
 
' Constants and Types
TYPE GameObject
  x AS SINGLE
  y AS SINGLE
  w AS SINGLE
  h AS SINGLE
  dx AS SINGLE
  dy AS SINGLE
  hp AS INTEGER
  c AS _UNSIGNED LONG
END TYPE
 
' Game State Variables
DIM SHARED p AS GameObject, b AS GameObject
DIM SHARED brick(1 TO 10, 1 TO 8) AS GameObject
DIM SHARED score&, lives%, level%, gameState%, ballActive%
DIM SHARED brickCount%, baseSpeed AS SINGLE
 
' Initialize Game
level% = 1: lives% = 3: score& = 0: baseSpeed = 4
InitLevel
 
' Main Game Loop
DO
  _LIMIT 60
  CLS
 
  SELECT CASE gameState%
    CASE 0: DrawMenu
    CASE 1: PlayGame
    CASE 2: GameOver
  END SELECT
 
  _DISPLAY
LOOP
 
SUB InitLevel
  ' Reset Paddle
  p.w = 100: p.h = 15: p.x = 400 - p.w / 2: p.y = 550
  ' Reset Ball
  ResetBall
  ' Build Bricks
  brickCount% = 0
  FOR row = 1 TO 8
    FOR col = 1 TO 10
      brick(col, row).w = 70
      brick(col, row).h = 25
      brick(col, row).x = 15 + (col - 1) * 78
      brick(col, row).y = 50 + (row - 1) * 30
      ' Difficulty: Bricks get more HP every 2 levels
      brick(col, row).hp = 1 + INT(level% / 3)
      brick(col, row).c = _RGB32(row * 30, 255 - (row * 20), 200 + col * 5)
      brickCount% = brickCount% + 1
    NEXT
  NEXT
END SUB
 
SUB ResetBall
  ballActive% = 0
  b.w = 12: b.h = 12
  b.x = p.x + p.w / 2 - 6
  b.y = p.y - 15
  ' Ball speed increases with level
  b.dx = (baseSpeed + level%) * .7
  b.dy = -(baseSpeed + level%)
END SUB
 
SUB PlayGame
  ' Movement Input (A and D)
  IF _KEYDOWN(97) OR _KEYDOWN(65) THEN p.x = p.x - 8 ' A
  IF _KEYDOWN(100) OR _KEYDOWN(68) THEN p.x = p.x + 8 ' D
  IF p.x < 0 THEN p.x = 0
  IF p.x > 800 - p.w THEN p.x = 800 - p.w
 
  ' Space to start ball
  IF ballActive% = 0 THEN
    b.x = p.x + p.w / 2 - 6
    COLOR _RGB32(255, 255, 255)
    _PRINTSTRING (300, 400), "PRESS [SPACE] TO LAUNCH BALL"
    IF _KEYDOWN(32) THEN ballActive% = 1
  ELSE
    ' Physics
    b.x = b.x + b.dx
    b.y = b.y + b.dy
 
    ' Wall Bounce
    IF b.x < 0 OR b.x > 788 THEN b.dx = -b.dx
    IF b.y < 0 THEN b.dy = -b.dy
 
    ' Paddle Bounce
    IF b.y + b.h > p.y AND b.x + b.w > p.x AND b.x < p.x + p.w THEN
      b.dy = -ABS(b.dy)
      ' Dynamic bounce based on where it hits paddle
      b.dx = (b.x - (p.x + p.w / 2)) / 5
    END IF
 
    ' Brick Collision
    FOR r = 1 TO 8
      FOR c = 1 TO 10
        IF brick(c, r).hp > 0 THEN
                    IF b.x + b.w > brick(c, r).x AND b.x < brick(c, r).x + brick(c, r).w AND _
                      b.y + b.h > brick(c, r).y AND b.y < brick(c, r).y + brick(c, r).h THEN
            b.dy = -b.dy
            brick(c, r).hp = brick(c, r).hp - 1
            score& = score& + 10
            IF brick(c, r).hp = 0 THEN brickCount% = brickCount% - 1
          END IF
        END IF
      NEXT
    NEXT
 
    ' Death
    IF b.y > 600 THEN
      lives% = lives% - 1
      IF lives% <= 0 THEN gameState% = 2 ELSE ResetBall
    END IF
 
    ' Level Win
    IF brickCount% <= 0 THEN
      level% = level% + 1
      InitLevel
    END IF
  END IF
 
  ' Rendering (Flamboyant Glow Effect)
  LINE (p.x, p.y)-(p.x + p.w, p.y + p.h), _RGB32(0, 255, 255), BF
  CIRCLE (b.x + 6, b.y + 6), 8, _RGB32(255, 255, 0)
  PAINT (b.x + 6, b.y + 6), _RGB32(255, 100, 0), _RGB32(255, 255, 0)
 
  FOR r = 1 TO 8
    FOR c = 1 TO 10
      IF brick(c, r).hp > 0 THEN
        LINE (brick(c, r).x, brick(c, r).y)-(brick(c, r).x + 68, brick(c, r).y + 23), brick(c, r).c, BF
        ' HP Indicator
        _PRINTSTRING (brick(c, r).x + 30, brick(c, r).y + 5), LTRIM$(STR$(brick(c, r).hp))
      END IF
    NEXT
  NEXT
 
  COLOR _RGB32(255, 255, 255)
  _PRINTSTRING (10, 10), "SCORE:" + STR$(score&) + "  LIVES:" + STR$(lives%) + "  LEVEL:" + STR$(level%)
END SUB
 
SUB DrawMenu
  COLOR _RGB32(255, 200, 0)
  _PRINTSTRING (330, 250), "NEON BREAKOUT ULTRA"
  COLOR _RGB32(255, 255, 255)
  _PRINTSTRING (320, 300), "PRESS [S] TO START GAME"
  _PRINTSTRING (320, 330), "PRESS [Q] TO QUIT"
  IF UCASE$(INKEY$) = "S" THEN gameState% = 1
  IF UCASE$(INKEY$) = "Q" THEN SYSTEM
END SUB
 
SUB GameOver
  COLOR _RGB32(255, 0, 0)
  _PRINTSTRING (350, 250), "GAME OVER!"
  _PRINTSTRING (320, 280), "FINAL SCORE:" + STR$(score&)
  _PRINTSTRING (310, 320), "PRESS [R] TO RESTART"
  IF UCASE$(INKEY$) = "R" THEN
    level% = 1: lives% = 3: score& = 0: InitLevel: gameState% = 1
  END IF
END SUB
