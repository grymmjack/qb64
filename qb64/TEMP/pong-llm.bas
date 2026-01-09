'$CONSOLE 'Enable console output for debugging

_TITLE("QB64-PE Pong") 'Set window title

'**Screen setup**
_SCREENWIDTH = 640
_SCREENHEIGHT = 480
SCREEN _SCREENWIDTH, _SCREENHEIGHT, 32 'Set 32 bit screen mode

'**Paddle dimensions and starting positions**
paddleWidth = 10
paddleHeight = 60
player1X = 20
player1Y = _SCREENHEIGHT / 2 - paddleHeight / 2
player2X = _SCREENWIDTH - 20 - paddleWidth
player2Y = _SCREENHEIGHT / 2 - paddleHeight / 2
paddleSpeed = 5

'**Ball dimensions and starting position**
ballSize = 10
ballX = _SCREENWIDTH / 2 - ballSize / 2
ballY = _SCREENHEIGHT / 2 - ballSize / 2
ballSpeedX = 3
ballSpeedY = 3

'**Score**
player1Score = 0
player2Score = 0

'**Main game loop**
DO
    '**Input**
    _LIMIT 60 'Limit frame rate to 60 FPS
    _KEYCLEAR 'Clear the keyboard buffer

    '**Player 1 controls (W and S keys)**
    IF _KEYDOWN(17) THEN 'W key
        player1Y = player1Y - paddleSpeed
    END IF
    IF _KEYDOWN(31) THEN 'S key
        player1Y = player1Y + paddleSpeed
    END IF

    '**Player 2 controls (Up and Down arrow keys)**
    IF _KEYDOWN(200) THEN 'Up arrow
        player2Y = player2Y - paddleSpeed
    END IF
    IF _KEYDOWN(208) THEN 'Down arrow
        player2Y = player2Y + paddleSpeed
    END IF

    '**Keep paddles within screen bounds**
    player1Y = CLIP(player1Y, 0, _SCREENHEIGHT - paddleHeight)
    player2Y = CLIP(player2Y, 0, _SCREENHEIGHT - paddleHeight)

    '**Ball movement**
    ballX = ballX + ballSpeedX
    ballY = ballY + ballSpeedY

    '**Ball collision with top and bottom walls**
    IF ballY <= 0 OR ballY >= _SCREENHEIGHT - ballSize THEN
        ballSpeedY = -ballSpeedY
    END IF

    '**Ball collision with paddles**
    IF ballX <= player1X + paddleWidth AND ballX + ballSize >= player1X AND ballY + ballSize >= player1Y AND ballY <= player1Y + paddleHeight THEN
        ballSpeedX = -ballSpeedX
    END IF

    IF ballX + ballSize >= player2X AND ballX <= player2X + paddleWidth AND ballY + ballSize >= player2Y AND ballY <= player2Y + paddleHeight THEN
        ballSpeedX = -ballSpeedX
    END IF

    '**Score and ball reset**
    IF ballX < 0 THEN
        player2Score = player2Score + 1
        ballX = _SCREENWIDTH / 2 - ballSize / 2
        ballY = _SCREENHEIGHT / 2 - ballSize / 2
        ballSpeedX = ABS(ballSpeedX) 'Ball goes to the other player
    END IF

    IF ballX > _SCREENWIDTH - ballSize THEN
        player1Score = player1Score + 1
        ballX = _SCREENWIDTH / 2 - ballSize / 2
        ballY = _SCREENHEIGHT / 2 - ballSize / 2
        ballSpeedX = -ABS(ballSpeedX) 'Ball goes to the other player
    END IF

    '**Drawing**
    _CLEARCOLOR = _RGB(0, 0, 0) 'Black background
    _CLS

    '**Draw paddles**
    _COLOR32 _RGB(255, 255, 255) 'White paddles
    _FILLRECT player1X, player1Y, player1X + paddleWidth, player1Y + paddleHeight
    _FILLRECT player2X, player2Y, player2X + paddleWidth, player2Y + paddleHeight

    '**Draw ball**
    _FILLCIRCLE ballX + ballSize / 2, ballY + ballSize / 2, ballSize / 2, _RGB(255, 255, 255)

    '**Draw score**
    _PRINTSTRING 10, 10, "Player 1: " + LTRIM$(STR$(player1Score))
    _PRINTSTRING _SCREENWIDTH - 100, 10, "Player 2: " + LTRIM$(STR$(player2Score))

    _DISPLAY 'Update the screen

    '**Check for game over (optional)**
    IF player1Score >= 10 OR player2Score >= 10 THEN
        EXIT DO
    END IF
LOOP

'**Game over message**
_CLS
IF player1Score > player2Score THEN
    _PRINTSTRING _SCREENWIDTH / 2 - 50, _SCREENHEIGHT / 2, "Player 1 Wins!"
ELSE
    _PRINTSTRING _SCREENWIDTH / 2 - 50, _SCREENHEIGHT / 2, "Player 2 Wins!"
END IF
_DISPLAY
SLEEP 3 'Pause to show result
SYSTEM

'**Keeps value between minimum and maximum**
FUNCTION CLIP (value, minimum, maximum)
    IF value < minimum THEN
        CLIP = minimum
    ELSEIF value > maximum THEN
        CLIP = maximum
    ELSE
        CLIP = value
    END IF
END FUNCTION