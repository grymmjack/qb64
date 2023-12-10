monx = 600
mony = 600
mon = _NewImage(monx, mony, 32)
Screen mon

'placing balls horizontally
red_ballx = 200
blue_ballx = 400
green_ballx = 300

blue_bally = 1
ballr = 20 'balls radius


gravity = .2



fps = 30
Color _RGB32(150, 150, 150)
Do: _Limit fps

    fps = fps - (_KeyDown(Asc("+")) - _KeyDown(Asc("-"))) * .5
    If fps < 5 Then fps = 5
    If fps > 500 Then fps = 500

    deltatime = 30 / fps


    Cls: Color _RGB32(100, 100, 100)
    Locate 1, 1: Print "+/- FPS setting              SPACE-green ball jump"
    Locate 3, 1: Print "FPS, (_LIMIT value)"; Int(fps), "deltatime:"; deltatime




    legalso_ypozicio = mony - ballr 'this value is the lowest position given by the size of the window and the ball, when the balls are on the ground


    'RED BALL -------------------------------------------------------------------------------------------------------------------------------------
    red_yvec = red_yvec + gravity * deltatime
    red_bally = red_bally + red_yvec * deltatime
    If legalso_ypozicio < red_bally Then red_bally = legalso_ypozicio: red_yvec = -14 'can also be used for jumping, yvec, momentum vector, which gravity tries to pull down in every cycle
    Color _RGB32(255, 20, 20)
    Circle (red_ballx, red_bally), ballr
    Paint (red_ballx, red_bally)


    'GREEN BALL  ------------------------------- same as the red ball, only you jump with SPACE
    green_yvec = green_yvec + gravity * deltatime
    green_bally = green_bally + green_yvec * deltatime
    If legalso_ypozicio < green_bally Then
        green_bally = legalso_ypozicio
        If _KeyDown(Asc(" ")) Then green_yvec = -5 'you jump to SPACE, which you can only do when you are on the ground (you can't jump while falling). it also has the power of jumping
    End If
    Color _RGB32(20, 255, 20)
    Circle (green_ballx, green_bally), ballr
    Paint (green_ballx, green_bally)



    'BLUE BALL
    blue_bally = blue_bally * 1.12 ^ deltatime '<------------------   in such cases deltatime must be increased!
    If legalso_ypozicio < blue_bally Then blue_bally = 1
    Color _RGB32(20, 20, 255)
    Circle (blue_ballx, blue_bally), ballr
    Paint (blue_ballx, blue_bally)


    _Display
Loop