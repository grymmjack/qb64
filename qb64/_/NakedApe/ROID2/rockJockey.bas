OPTION _EXPLICIT '                               >>>> ROCK JOCKY 1.0 <<<<
CONST TRUE = -1, FALSE = NOT TRUE '                       6/19/24
CONST SWIDTH = 1280, SHEIGHT = 720 '                   by Ted Kluger
CONST CENTX = SWIDTH / 2, CENTY = SHEIGHT / 2 '
CONST gameSpeed = 60
DIM SHARED mainScreen AS LONG
mainScreen = _NEWIMAGE(SWIDTH, SHEIGHT, 32) '                                       NEXT TIME: a more unified approach to sounds & fading
SCREEN mainScreen
RANDOMIZE TIMER '
_FULLSCREEN _SQUAREPIXELS , _SMOOTH '
'                  ^ causes non-fullscreen on laptop
TYPE hiScore '
    player AS STRING '
    score AS INTEGER '
    kRatio AS INTEGER '
    timeInBox AS INTEGER '
END TYPE '
'
TYPE gridRock '
    x AS SINGLE '
    y AS SINGLE '
    rotAng AS INTEGER '
    col AS _UNSIGNED LONG '
    speed AS SINGLE
    yJiggle AS _BYTE '
    special AS _BYTE '
    rotSign AS _BYTE '                                                              TO DO:
    alive AS _BYTE '
END TYPE '                                                                          A WHOLE NUTHER LEVEL - VARIATIONS ON THE THEMES
'
TYPE comet '                                                                        PIPES STYLE ELECTRIC REPAIR TO SPACE STATION AS NEXT PUZZLE?
    kind AS STRING '
    x AS SINGLE
    y AS SINGLE '
    Vx AS SINGLE
    Vy AS SINGLE
    radius AS SINGLE '
    rotSpeed AS SINGLE
    rotAng AS INTEGER '
    rotSign AS _BYTE ' -1, 0, 1  clockwise, no rotation, C-clockwise
    alive AS _BYTE
    col AS _UNSIGNED LONG
    edge AS _UNSIGNED LONG
END TYPE

TYPE ship
    kind AS STRING '
    x AS SINGLE
    y AS SINGLE '
    Vx AS SINGLE
    Vy AS SINGLE
    speed AS SINGLE
    power AS SINGLE
    chargeDelta AS SINGLE
    course AS INTEGER '         vector angle for ship
    col AS _UNSIGNED LONG '
    radius AS _BYTE
    landed AS _BYTE
    charging AS _BYTE
    charged AS _BYTE
    inventory AS _BYTE
    shields AS SINGLE
END TYPE

TYPE XYPAIR '
    x AS SINGLE '
    y AS SINGLE '
END TYPE

TYPE rock
    kind AS STRING
    x AS SINGLE
    y AS SINGLE
    Vx AS SINGLE '              vector pairs for rocks
    Vy AS SINGLE
    speed AS SINGLE
    size AS _BYTE '
    rotation AS _BYTE
    alive AS _BYTE '
    stayPainted AS _BYTE
    rotDir AS STRING
    radius AS INTEGER
    spinAngle AS INTEGER
    spinSpeed AS INTEGER
    col AS _UNSIGNED LONG
END TYPE

TYPE RECT '                     rectangle definition
    x1 AS INTEGER '             upper left X
    y1 AS INTEGER '             upper left Y
    x2 AS INTEGER '             lower right X
    y2 AS INTEGER '             lower right Y
END TYPE

TYPE SPARK '                    single spark definition
    Location AS XYPAIR '        location of spark
    Vector AS XYPAIR '          spark vector
    Velocity AS SINGLE '        velocity of spark (speed)
    Fade AS INTEGER '           intensity of spark
    Lifespan AS INTEGER '       lifespan of spark
END TYPE

TYPE flag
    doRocks AS _BYTE
    doShip AS _BYTE
    doSparks AS _BYTE
    doComets AS _BYTE
    doGrid AS _BYTE
    doSaucers AS _BYTE
    doFF AS _BYTE '             force field
    doAutoShields AS _BYTE
    doCircle AS _BYTE '         auto-shield circle
    doTruck AS _BYTE
    doFlyBy AS _BYTE
    doDeflect AS _BYTE
    doRockMask AS _BYTE
    doVertGauge AS _BYTE
    doInstructs AS _BYTE
    doSettings AS _BYTE
    doResetFlags AS _BYTE
    doPopUp AS _BYTE
    paintCircles AS _BYTE
    go2Space AS _BYTE
    goDissolveFF AS _BYTE
    trackShields AS _BYTE
    shutBackDoor AS _BYTE
    shutFrontDoor AS _BYTE
    harpooned AS _BYTE
    fadeInComs AS _BYTE '       THESE COULD GO IN A SOUND TYPE
    fadeOutComs AS _BYTE
    fadeInGRID AS _BYTE
    fadeOutGrid AS _BYTE
    startFFloop AS _BYTE ' ................................
    showMoonScape AS _BYTE
    fadeInRocks AS _BYTE
    landingTime AS _BYTE '      aka gravity based flight with main thrusters on
    detachRock AS _BYTE
    fadeOutCharge AS _BYTE
    rockMoving AS _BYTE
    chargeDone AS _BYTE
    reduceGravity AS _BYTE
    regularChecks AS _BYTE '    gravity/landingTime flight vs no gravity/space flight
    showGauges AS _BYTE
    intro AS _BYTE
    checkFSC AS _BYTE '         check For Ship Collision
    checkCometCollisions AS _BYTE
    checkGridCollisions AS _BYTE
    fullScreen AS _BYTE
    fullScreenOff AS _BYTE
    gameOver AS _BYTE
    stopp AS _BYTE
    speedUp AS _BYTE
    shipBoomDone AS _BYTE
END TYPE

TYPE saucer '
    loc AS XYPAIR
    commands AS STRING '
    action AS STRING
    loopNum AS INTEGER '
    charCount AS INTEGER '
    loopCounter AS INTEGER '
    movesNum AS INTEGER
    aspectSign AS _BYTE '
    rotAngSign AS _BYTE '
    getCommand AS _BYTE
    alive AS _BYTE
    shipRadius AS SINGLE '
    rotAngle AS SINGLE '
    aspect AS SINGLE '
    speed AS SINGLE '
    fillColor AS _UNSIGNED LONG
END TYPE

TYPE BULLET '           DEFINE BULLET
    Active AS INTEGER ' bullet active (y/n)
    x AS INTEGER '      center x coordinate of bullet
    y AS INTEGER '      center y coordinate of bullet
    Radius AS INTEGER
    Speed AS SINGLE '   bullet speed
END TYPE

' ***** Saucer Section ******
DIM SHARED AS saucer saucer(12) '
DIM SHARED AS INTEGER toteSaucers, saucerKills ' cumulative score over multiple rounds...
DIM SHARED AS LONG HDWimg(1 TO 9)
DIM AS INTEGER shipNum, limit '
DIM AS STRING moves(18) '
REDIM Bullet(0) AS BULLET '
' ****************************
REDIM Spark(0) AS SPARK '                           dynamic array to hold sparks
DIM SparkNum AS INTEGER: SparkNum = 10 '            number of sparks to create at a time
DIM SparkLife AS INTEGER: SparkLife = 30 '          life span of spark in frames
DIM matrix(1 TO 20, 1 TO 11) AS gridRock
DIM AS RECT cBox, wBox
DIM comet(1 TO 80) AS comet '           was 80
DIM shipType(1 TO 12) AS STRING
DIM rockType(1 TO 13) AS STRING
DIM SHARED AS INTEGER MAXROCKS: MAXROCKS = 12 ' to start   -   increase with each round +4
DIM SHARED AS SINGLE gravityFactor, mouseSens
DIM SHARED I(18) AS LONG '                      image array
DIM SHARED C(16) AS _UNSIGNED LONG '            color array
DIM SHARED S(39) AS LONG '                      sound array
DIM SHARED VO(1 TO 25) AS LONG '                voice-over array
DIM SHARED ship AS ship '                       global ship
DIM SHARED rock(1 TO 24) AS rock '              global rocks - the actual MAXROCKS <
DIM SHARED AS _BYTE target, lapped '            target rock, overlapped scanning flag
DIM SHARED flag AS flag
DIM SHARED hiScore(5) AS hiScore
DIM SHARED AS _BYTE done1, done2, done3, warn, detached, initFF, hold '     a few global flags for sounds, etc.
DIM SHARED AS LONG moonScape, cometTime, warnSnd, viewScreen '              images, timers
DIM SHARED AS LONG modern, menlo, modernBig, modernBigger, menloBig '       fonts
DIM SHARED AS INTEGER coAng, FPS, lineX, oTime, score, gameRound, mX, mY '  lineX = weak wall of FF, oTime = overlapTime during harvest
DIM SHARED AS INTEGER landingSpeed
DIM SHARED AS INTEGER DTW, DTH: DTW = _DESKTOPWIDTH: DTH = _DESKTOPHEIGHT
DIM AS LONG starScape, saucerScape, miniMask, microMask
DIM AS LONG timer1, gridTimer, timer2, shipImg
DIM AS INTEGER redd, gren, blue, killRatio, cageTime, c, aFPS
DIM AS INTEGER rockHeading, lockedAngle, boomNum, spin2
DIM AS INTEGER popCount
DIM AS SINGLE gameTime, sTime
DIM AS _BYTE sparkCycles, played, played2, played3
DIM AS _BYTE doneHere, bounceOffs, killFlyBy, pop
DIM AS _BYTE over(20), chargeScoreDone, fadeIt '                          sound flags
DIM AS _UNSIGNED LONG weakWallColor
DIM AS STRING i, j '

starScape = _NEWIMAGE(1280, 720, 32)
miniMask = _NEWIMAGE(42, 42, 32) ' was 46 square
microMask = _NEWIMAGE(20, 20, 32)
_DEST miniMask: CLS: _DEST microMask: CLS: _DEST 0
startUp '                                                               load assets and values
timer1 = _FREETIMER
ON TIMER(timer1, 2) flipOnShip
timer2 = _FREETIMER
ON TIMER(timer2, 4.2) flipOnSaucers
' ************************************************************************************************************************
splashPage
' flag.doSaucers = TRUE ' saucerControl '       for diagnostics only <<<<
sTime = TIMER '                                 ditto - for FPS tracking
gameTime = TIMER
'                                                       ****** MAIN LOOP ******
DO

    IF flag.speedUp THEN
        IF FPS <= 61 THEN
            FPS = FPS + 2
        ELSE
            IF FPS > 60 THEN flag.speedUp = FALSE
        END IF
    END IF

    IF flag.doPopUp THEN _MOUSESHOW ELSE _MOUSEHIDE

    IF flag.fullScreen THEN '
        _FULLSCREEN _SQUAREPIXELS , _SMOOTH '   ** SETTINGS for FULLSCREEN must be in the main loop or weird mousebutton issues occur IN MACOS **
        flag.fullScreen = FALSE
    END IF
    IF flag.fullScreenOff THEN
        _FULLSCREEN _OFF
        _DELAY .15
        _SCREENMOVE _MIDDLE
        _TITLE "R o c k   J o c k e y" '
        flag.fullScreenOff = FALSE
    END IF

    IF ship.power <= 1 AND ship.inventory = -1 THEN flag.gameOver = TRUE '      ** game over checks **
    IF ship.inventory <= -1 THEN flag.gameOver = TRUE '

    IF ship.power < 1 THEN '
        ship.power = 1
        shipBoom '                              shipBoom tallies the ship.inventory
        score = score - 100 '                   boom penalty
    END IF

    IF NOT hold THEN '                                                              ** game loop **
        CLS
        _LIMIT FPS
        _PUTIMAGE , starScape, 0 '              draw software background first

        IF flag.landingTime THEN '                                                  ** ROCK DROP landing handler **
            IF NOT flag.doPopUp THEN FPS = landingSpeed '                           set user selected landing speed
            IF ship.x > 468 AND ship.x < 506 THEN
                IF ship.y > 565 AND ship.y < 572 THEN '
                    flag.doRockMask = FALSE
                    IF NOT detached THEN _PUTIMAGE (ship.x - 23, 535), miniMask '   block stars around landing zone when rock is still attached to ship
                    IF NOT ship.landed THEN checkLanding: _SNDPLAY S(2)
                ELSE IF NOT detached THEN flag.doRockMask = TRUE
                    ship.landed = FALSE '
                END IF
            ELSE IF NOT detached THEN flag.doRockMask = TRUE
                ship.landed = FALSE
            END IF
            IF NOT played2 AND ship.landed AND ship.Vy = 0 THEN _SNDPLAY VO(12): played2 = TRUE '
        ELSE IF NOT flag.doFF AND NOT flag.doPopUp AND NOT flag.speedUp AND NOT flag.doComets THEN FPS = gameSpeed '      standard speed     <<<<<
        END IF

        IF flag.doRocks THEN
            rockNav '               advance rocks, control edges
            drawRocks '             render rocks, control rotation
            check4RockContact '     check for rock to rock contact
        END IF

        IF NOT flag.gameOver AND NOT flag.doSaucers THEN soundCenter '          sound events to check on
        IF NOT flag.doFlyBy AND NOT flag.doFF AND NOT flag.doDeflect AND NOT killFlyBy AND INT(RND * 135) = 50 THEN flag.doFlyBy = TRUE '   messy flyby conditions
        IF flag.doShip THEN shipControl '                                       draw & maintain ship (and rock when harpooned)
        IF flag.doFF THEN forceFieldControl
        IF flag.doDeflect THEN deflectFF
        IF flag.doGrid AND TIMER - gridTimer > 2 THEN runGRID
        IF flag.checkGridCollisions THEN checkShipGRIDCollision '
        IF flag.showMoonScape THEN _PUTIMAGE (0, 530)-(1280, 720), moonScape '  draw moonscape on top, activate truck
        IF flag.checkFSC THEN check4ShipROCKCollision
        IF flag.doSparks THEN blowUp
        IF flag.doComets THEN runCOMETS
        IF flag.checkCometCollisions THEN checkShipCOMETCollision
        IF flag.trackShields THEN autoShields
        IF NOT flag.harpooned AND rock(target).col = C(3) THEN check4Harpoon '  if ship's green then check for harpoon
        IF ship.charging OR ship.landed THEN redrawShip '                       prevents ship pixel damage from moonscape
        IF flag.go2Space THEN back2Space '                                      leave the moon, no gravity...
        IF flag.rockMoving THEN moveTargetRock
        IF flag.doFlyBy AND flag.landingTime AND NOT flag.doSaucers THEN flyBy
        IF flag.goDissolveFF THEN dissolveFF
        IF flag.doSaucers THEN saucerControl
        IF flag.doResetFlags THEN resetFlags
        IF flag.showMoonScape AND flag.doTruck THEN driveTruck
        IF flag.gameOver THEN endGame
        IF flag.doInstructs THEN instructions
        IF flag.doSettings THEN settings

        IF flag.showGauges THEN '                                       ** GAUGES **
            j = LEFT$(STR$(ship.speed), 4)
            j = _TRIM$(j)
            IF ship.speed > .1 AND NOT flag.landingTime THEN_
                showHorzGauge 20, 30, ship.speed / 6.05, "SPEED  " + j, _RGB32(255, 83, 255)
            showHorzGauge 20, 62, ship.power / 100, "POWER  " + STR$(INT(ship.power)) + "%", _RGB32(61, 255, 78, 220)
            showHorzGauge 20, 94, ship.shields / 100, "SHIELDS  " + STR$(INT(ship.shields)) + "%", C(12)
            _FONT modern: COLOR C(16)
            IF ship.inventory > -1 THEN _PRINTSTRING (36, 130), "SHIPS LEFT:" + STR$(ship.inventory)
        END IF

        COLOR C(14) '                                                   ** SCORE ZONE **
        _FONT modernBigger
        _PRINTSTRING (_WIDTH - 135, 33), "SCORE: " + STR$(score) '      print score
        _FONT 16

        IF flag.landingTime THEN '                                      ** SHIP CHARGING landing handler **
            IF ship.x > 758 AND ship.x < 764 THEN
                IF ship.y > 568 AND ship.y < 573 THEN
                    IF ship.Vy < .5 AND ship.Vy > 0 THEN '              slow down, no landing on upward motion
                        ship.y = 571 '
                        ship.x = 761
                        ship.Vy = 0
                        IF NOT detached THEN shipBoom '
                        IF NOT ship.charged THEN
                            ship.charging = TRUE
                            flag.doVertGauge = TRUE '
                        END IF
                        ship.landed = TRUE '
                    END IF
                END IF
            END IF
        END IF

        IF NOT ship.charging THEN doneHere = FALSE: _SNDVOL S(21), .44 '                                reset charging sound
        IF ship.power < 88 THEN ship.charged = FALSE '   was 94
        IF NOT played3 AND ship.charging AND ship.power >= 98 THEN _SNDPLAY VO(14): played3 = TRUE '    charge complete voice over, done once only

        IF ship.landed THEN '                                           ** SHIP CHARGING CONTROLS **
            _PRINTMODE _KEEPBACKGROUND '                        w/o this, fails in round 2
            postLanding '                                       check conditions - pretty tricky logic and sequencing here...
            IF ship.charging AND NOT ship.charged THEN
                IF flag.doVertGauge THEN showVertGauge 870, 440 '
                _FONT 8: COLOR C(12)
                _PRINTSTRING (751, 591), "CHARGING"
                IF ship.power <= 100 THEN ship.power = ship.power + ship.chargeDelta '     charging speed
                IF ship.shields < 100 THEN ship.shields = ship.shields + .13
                quickSound 21 '                                         charging sounds
                IF ship.power >= 99 AND NOT doneHere THEN
                    played = FALSE '                                    turns back on thruster sounds in shipControl sub and quicksound sub
                    flag.fadeOutCharge = TRUE '
                    doneHere = TRUE '                                   flag for above VO
                    killFlyBy = TRUE '                                  stop flybys after charging done
                    IF NOT chargeScoreDone THEN score = score + 200 '   points for charging up too!
                    chargeScoreDone = TRUE
                END IF
            ELSE
                postLanding
                _FONT 8: COLOR C(3)
                _PRINTSTRING (463, 595), "LANDED"
            END IF
            _FONT 16
        ELSE IF _SNDPLAYING(S(21)) THEN _SNDSTOP S(21): played = FALSE
        END IF

        IF flag.reduceGravity AND gravityFactor > 0 THEN
            gravityFactor = gravityFactor - .0005 '  was .006!          reduce gravity gently
            IF gravityFactor <= 0 THEN
                flag.reduceGravity = FALSE
                gravityFactor = .036 '                                  reset it
            END IF
        END IF

        IF NOT over(19) AND ship.shields < 25 THEN _SNDPLAY VO(24): over(19) = TRUE '   played once only, shields are low <  &&
        IF NOT over(20) AND ship.power < 25 THEN _SNDPLAY VO(25): over(20) = TRUE '                             &&
    END IF '                                                                            BOTTOM OF HOLD IF *******************************************
    ' -------------------------
    c = c + 1
    IF TIMER - sTime >= 1 THEN '                                        calc FPS
        aFPS = c
        c = 0
        sTime = TIMER
    END IF
    COLOR C(16): _FONT modernBig

    '_PRINTSTRING (10, _HEIGHT - 14), "FPS: " + STR$(aFPS) '            FPS tracking   <<<<<<<<<

    i = INKEY$
    IF i = CHR$(27) THEN flag.doPopUp = TRUE '                          this has to be outside the HOLD loop
    i = ""

    IF flag.doPopUp THEN popUp '

    _DISPLAY
    '                                                                   *** USER INPUT ***
    IF _KEYDOWN(115) OR _KEYDOWN(83) THEN hold = TRUE: settings
    IF _KEYDOWN(13) THEN rockScramble '                                 emergency manual reshuffle of all rocks for extreme lockUp situations
    IF _KEYDOWN(113) OR _KEYDOWN(81) THEN wrapUp: SYSTEM '              q for fast quit
    IF _KEYDOWN(112) OR _KEYDOWN(80) THEN SLEEP '                       p to pause
    'IF _KEYDOWN(18432) THEN IF FPS < 400 THEN FPS = FPS + 1 '          up arrow to increase FPS speed  <<<<<<<<<
    'IF _KEYDOWN(20480) THEN IF FPS > 30 THEN FPS = FPS - 1 '           down...
    _FONT 16
LOOP '
END '
' ---------------------**************************************** END MAIN ****************************************************************************

SUB startUp ()

    SHARED AS _BYTE pop

    gameRound = 1
    loadColors: loadSounds: loadRocks: loadImages: loadFonts
    loadShips: loadVOs: loadMoonScape: loadViewScreen
    assignRocks: assignMoves: initCOMETS: initGRID: drawStars
    _PRINTMODE _KEEPBACKGROUND
    flag.doAutoShields = TRUE
    flag.doRockMask = TRUE
    flag.regularChecks = TRUE
    flag.harpooned = FALSE
    flag.fadeInRocks = TRUE '
    flag.showGauges = TRUE
    flag.doTruck = TRUE
    flag.intro = TRUE
    flag.paintCircles = FALSE '
    landingSpeed = 56
    pop = FALSE '                   local popUp flag for saucer sub
    score = 0
    FPS = 60 '                      start speed
    ship.speed = 0
    ship.shields = 100 '
    ship.power = 100
    ship.inventory = 2 '            reserve ships
    ship.chargeDelta = .21
    gravityFactor = .036
    lineX = 160 '                   weak wall of FF
    mouseSens = .4 '               .2 is slow, .5 is medium/good, 1 is pretty fast...
END SUB
' -----------------------------------------

SUB resetFlags () '                 to prepare for a repeat round of play

    DIM c AS INTEGER
    SHARED AS _BYTE killFlyBy, chargeScoreDone
    SHARED AS _BYTE over()

    FOR c = 0 TO 17 '               ** leave 18+ as TRUE to play "AUTOSHIELDS ON" etc only once
        over(c) = FALSE '           reset all background music flags
    NEXT

    gameRound = gameRound + 1
    chargeScoreDone = FALSE
    lapped = FALSE
    detached = FALSE
    oTime = 0 '                     overlap cycles for harvest
    initFF = FALSE '                init flag in FFControl
    done1 = FALSE '                 allows comet timer
    done2 = FALSE '                 turns comets back on
    done3 = FALSE '                 a sound flag
    warn = FALSE '                  turns on comet fuzzy noise
    over(13) = TRUE '               play the valuation VO only once
    killFlyBy = FALSE '             allow flyBys in all rounds
    flag.fadeInComs = FALSE '       reset fader flag
    flag.fadeInGRID = FALSE
    flag.fadeOutGrid = FALSE
    flag.doResetFlags = FALSE
    flag.chargeDone = FALSE
    flag.startFFloop = FALSE
    flag.showGauges = TRUE
    flag.doTruck = TRUE
    flag.detachRock = FALSE '
    flag.doPopUp = FALSE
    flag.doComets = FALSE '        new items after popUp box
    flag.doGrid = FALSE
    flag.landingTime = FALSE
    flag.doSaucers = FALSE
    flag.doFF = FALSE
    flag.doRocks = TRUE
END SUB
' -----------------------------------------

SUB shipControl ()

    STATIC AS LONG pauseTime '
    STATIC AS _BYTE said, said2
    DIM AS INTEGER spin, tempSpin, cX, d, antiHeading, dist, complete
    DIM AS INTEGER xPointEnd, yPointEnd, xPointStart, yPointStart
    DIM AS SINGLE radian, distance, d2
    DIM AS DOUBLE radians
    DIM AS _BYTE leftClick, rightClick, rocket
    SHARED AS STRING shipType(), rockType()
    SHARED AS INTEGER DTW, lockedAngle, spin2
    SHARED AS _BYTE played, target
    SHARED AS LONG miniMask, microMask

    ' -------------------------- target scan zone ---------------------------------
    IF NOT flag.harpooned AND NOT flag.landingTime THEN
        IF ship.x > rock(target).x - 10 AND ship.x < rock(target).x + 10 THEN '         check for ship and target rock overlap
            IF ship.y > rock(target).y - 10 AND ship.y < rock(target).y + 10 THEN
                IF NOT said AND oTime = 16 THEN _SNDPLAY VO(1): said = TRUE '           scanning target, say it once to make it clear, don't drive user crazy
                IF oTime < 400 THEN
                    rock(target).col = C(9) '                                           orange during overlap
                    _SNDPLAY S(12) '                                                    scanning sound
                END IF
                IF oTime = 400 THEN
                    rock(target).col = C(3) '                                           green after sufficient time of overlap
                    IF NOT said2 THEN _SNDPLAY VO(2): said2 = TRUE: pauseTime = TIMER ' done scanning, once
                    _SNDSTOP (S(12))
                END IF
                oTime = oTime + 1
                lapped = TRUE
            END IF
        ELSE lapped = FALSE
            _SNDSTOP (S(12))
        END IF
    END IF
    complete = (oTime / 400) * 100
    IF oTime > 10 AND oTime <= 400 THEN showHorzGauge CENTX - 50, _HEIGHT - 40, oTime / 400, STR$(complete) + "%  SCANNED", _RGB32(255, 116, 6)
    IF NOT lapped AND oTime < 400 THEN rock(target).col = C(10) ' back to purple
    ' -------------------------------------------- ---------------------------------
    IF said2 AND TIMER - pauseTime > 2.5 AND rock(target).col = C(3) AND NOT flag.harpooned AND NOT flag.chargeDone THEN '     VO after done scanning, HowToCapture...
        _SNDPLAY VO(5)
        said2 = FALSE '     to turn this off
    END IF
    ' --------------------------
IF NOT leftClick AND NOT rightClick AND NOT _MOUSEMOVEMENTX AND_
(NOT _KEYDOWN(19200) OR NOT _KEYDOWN(19712)) THEN ship.kind = shipType(4) '     back to normal ship
    ' --------------------------
    IF _KEYDOWN(19200) OR _KEYDOWN(97) OR _KEYDOWN(65) THEN '                   side thruster right
        played = FALSE: quickSound 10 '             turn on the sub so side thrusters and front/rear thrusters can all play at the same time
        ship.kind = shipType(12)
        tempSpin = coAng - 90 '
        d2 = d2 + .7
        radian = _D2R(tempSpin) '
        ship.x = COS(radian) * d2 + ship.x '
        ship.y = SIN(radian) * d2 + ship.y
    END IF

    IF _KEYDOWN(19712) OR _KEYDOWN(100) OR _KEYDOWN(68) THEN '      side thruster left
        played = FALSE: quickSound 10 '
        ship.kind = shipType(11)
        tempSpin = coAng + 90 '
        d2 = d2 + .7 '                              add .7 pixels of distance each cycle
        radian = _D2R(tempSpin)
        ship.x = COS(radian) * d2 + ship.x '        get coordinates from vectors
        ship.y = SIN(radian) * d2 + ship.y
    END IF
IF NOT _KEYDOWN(19200) AND NOT _KEYDOWN(97) AND NOT _KEYDOWN(19712)_
AND NOT _KEYDOWN(100) AND NOT _KEYDOWN(68) AND NOT _KEYDOWN(65) THEN
        IF _SNDPLAYING(S(10)) THEN
            _SNDSTOP S(10)
            played = FALSE '     kill side thruster loop, reset quickSound
        END IF
    END IF

    ' --------------------------
    DO WHILE _MOUSEINPUT '                                      ** MOUSE INPUT **
        IF _MOUSEMOVEMENTX THEN
            IF NOT ship.landed AND NOT ship.charging THEN cX = cX - _MOUSEMOVEMENTX '
            IF cX < 0 THEN ship.kind = shipType(9) '            left side jet
            IF cX > 0 THEN ship.kind = shipType(10) '           right side jet
            ship.course = ship.course + cX * mouseSens '        mouse movement multiplier
            IF ship.course >= -1 THEN ship.course = -1080 '     prevents lockups
        END IF
    LOOP
    ' --------------------------
    mX = _MOUSEX '              monitor mouse
    mY = _MOUSEY
    '                           mousekeeping chores - for WINDOWS only, QB64PE still has mousemove issues for MacOS: 1/4 sec delay
    $IF WIN THEN
        If mX > _Width - 100 Or mX < 100 Then _MouseMove _Width / 2, _Height / 2
        If mY > _Height - 100 Or mY < 100 Then _MouseMove _Width / 2, _Height / 2
        _MouseHide
    $END IF
    ' -------------------------

    IF ship.course < 0 THEN coAng = -ship.course '          fix angles
    IF ship.course < -360 THEN coAng = -ship.course - 360
    coAng = coAng - 90 '                                    corrected CourseAngle: 0 is really 90 degrees (east)

    IF NOT flag.landingTime THEN '                          ** NON-LANDING NAVIGATION ***** vector angle (theta) only
        distance = distance + ship.speed '                  move the ship forward & backwards     ** SHIP NAVIGATION **
        radian = _D2R(coAng)
        ship.x = COS(radian) * distance + ship.x '          get coordinates from angle vector
        ship.y = SIN(radian) * distance + ship.y
        Deg2Vec2 coAng '                                    get last known vectors from corrected course - for use at landing time
    END IF
    ' --------------------------
    IF flag.chargeDone AND flag.landingTime THEN
        IF ship.y < 0 THEN '                                break thru top border to go back to space
            flag.showMoonScape = FALSE
            flag.go2Space = TRUE
            flag.reduceGravity = TRUE
        END IF
    END IF

    IF flag.landingTime THEN '                              ** LANDING NAV - MOVE SHIP with real vectors for landing time
        ship.x = ship.x + ship.Vx * ship.speed
        ship.y = ship.y + ship.Vy * ship.speed
        IF ship.speed > 1 THEN ship.speed = ship.speed - .02 '          get speed to 1, let the vectors do the work...
        IF ship.speed < 1 THEN ship.speed = ship.speed + .02
        IF ship.Vy < 3.5 AND NOT ship.landed AND NOT flag.doFF THEN ship.Vy = ship.Vy + gravityFactor '     gravity factor  ********
    END IF
    ' --------------------------
    leftClick = _MOUSEBUTTON(1) '
    rightClick = _MOUSEBUTTON(2) '
    ' --------------------------
    IF leftClick AND NOT flag.doPopUp THEN '                            LEFT CLICK - speed up -
        ship.kind = shipType(2) '                                       main ship thruster
        ship.power = ship.power - .022 '
        played = FALSE
        IF NOT flag.landingTime THEN quickSound 11 ELSE quickSound 8
        IF NOT flag.landingTime AND ship.speed < 6 THEN ship.speed = ship.speed + .02

        IF flag.landingTime THEN '
            d = -getCourse(ship.course) '                               get actual corrected course

            SELECT CASE d '                                             adjust y vectors
                CASE 0 TO 45: ship.Vy = ship.Vy - .085
                CASE 46 TO 84: ship.Vy = ship.Vy - .06
                CASE 96 TO 135: ship.Vy = ship.Vy + .06
                CASE 136 TO 225: ship.Vy = ship.Vy + .085
                CASE 226 TO 264: ship.Vy = ship.Vy + .06
                CASE 276 TO 315: ship.Vy = ship.Vy - .06
                CASE 316 TO 360: ship.Vy = ship.Vy - .085
            END SELECT

            ship.power = ship.power - .036 '                                    burning up power

            SELECT CASE d
                CASE 3 TO 22: ship.Vx = ship.Vx + .007 '                        adjust x vectors
                CASE 23 TO 45: ship.Vx = ship.Vx + .02
                CASE 46 TO 67: ship.Vx = ship.Vx + .035 '                       more sideways thrust, more vector change
                CASE 68 TO 113: ship.Vx = ship.Vx + .055
                CASE 114 TO 135: ship.Vx = ship.Vx + .035
                CASE 136 TO 160: ship.Vx = ship.Vx + .02
                CASE 161 TO 178: ship.Vx = ship.Vx + .007
                CASE 182 TO 200: ship.Vx = ship.Vx - .007
                CASE 201 TO 225: ship.Vx = ship.Vx - .02
                CASE 226 TO 241: ship.Vx = ship.Vx - .035
                CASE 242 TO 292: ship.Vx = ship.Vx - .055
                CASE 293 TO 315: ship.Vx = ship.Vx - .035
                CASE 316 TO 337: ship.Vx = ship.Vx - .02
                CASE 338 TO 357: ship.Vx = ship.Vx - .007
            END SELECT
            '                                                                   ** FLAME ZONE **
            antiHeading = d + 90 '                                              adjust for QB64
            IF antiHeading > 360 THEN antiHeading = antiHeading - 360
            radians = _D2R(antiHeading)
            dist = INT(RND * 20 + 11) '                                         distance for end of flames
            xPointEnd = dist * COS(radians) + ship.x
            yPointEnd = dist * SIN(radians) + ship.y
            xPointStart = 6 * COS(radians) + ship.x '                           6 is dist from center of ship
            yPointStart = 6 * SIN(radians) + ship.y
            rocket = TRUE
        END IF
    ELSE IF NOT flag.landingTime AND rightClick THEN '                          RIGHT CLICK - slow down - retro thruster at nose
            IF ship.speed > -1 THEN ship.speed = ship.speed - .03 '             **********************************
            ship.kind = shipType(1) '                                           Non-landing situation
            ship.power = ship.power - .009
            played = FALSE: quickSound 9
        END IF
    END IF

    IF rightClick AND flag.landingTime AND NOT ship.charging THEN '             landing scenario RETRO THRUSTER
        ship.kind = shipType(1) '                                               *******************************
        ship.power = ship.power - .028
        played = FALSE: quickSound 9
        d = -getCourse(ship.course) '
        SELECT CASE d '                                                         simpler x/y vector adjusts for nose thruster during landingTime
            CASE 0 TO 45: ship.Vy = ship.Vy + .08: ship.Vx = ship.Vx - .02
            CASE 46 TO 77: ship.Vy = ship.Vy + .05: ship.Vx = ship.Vx - .05
            CASE 78 TO 113: ship.Vx = ship.Vx - .08:
            CASE 114 TO 135: ship.Vy = ship.Vy - .05: ship.Vx = ship.Vx - .05
            CASE 136 TO 225: ship.Vy = ship.Vy - .08
            CASE 226 TO 247: ship.Vy = ship.Vy - .05: ship.Vx = ship.Vx + .05
            CASE 248 TO 293: ship.Vx = ship.Vx + .08
            CASE 294 TO 315: ship.Vy = ship.Vy + .05: ship.Vx = ship.Vx + .05
            CASE 316 TO 359: ship.Vy = ship.Vy + .08: ship.Vx = ship.Vx + .02
        END SELECT
        IF d < 193 AND d > 167 THEN ship.Vx = 0 '                               line up the rocket, kill x motion
    END IF

    IF NOT _MOUSEBUTTON(1) THEN
        IF _SNDPLAYING(S(11)) THEN _SNDSTOP S(11): played = FALSE '             kill thruster sounds, reset quickSound
        IF _SNDPLAYING(S(8)) THEN _SNDSTOP S(8): played = FALSE
    END IF
    IF NOT _MOUSEBUTTON(2) THEN IF _SNDPLAYING(S(9)) THEN _SNDSTOP S(9): played = FALSE
    ' --------------------------
    spin = ship.course '                                                        VARPRT$ command doesn't like array or UDT use ...dummy var spin
    PRESET (ship.x, ship.y), ship.col
    DRAW "TA=" + VARPTR$(spin) + ship.kind '                                    draw the ship with rotation
    PAINT (ship.x, ship.y - 1), C(3), ship.col '                                paint ship green inside - can't be exactly in the middle

    IF flag.harpooned THEN
        IF flag.doRockMask THEN _PUTIMAGE (ship.x - 23, ship.y - 23), miniMask 'blocks the starscape from inside the rock
        IF NOT flag.detachRock THEN
            rock(target).x = ship.x '                                           same xy locations for ship & rock
            rock(target).y = ship.y
            d = getCourse(ship.course) '                                        d = corrected ship course
            spin2 = rock(target).spinAngle + (d - lockedAngle) '                keep rock at same angle but change with ship now!
        END IF

        IF detached THEN _PUTIMAGE (rock(target).x - 22, rock(target).y - 22), miniMask '
        PRESET (rock(target).x, rock(target).y), rock(target).col
        IF NOT flag.rockMoving AND NOT rock(target).stayPainted THEN DRAW "TA=" + VARPTR$(spin2) + rock(target).kind '  draw rock with ship or without and target(rock).alive
        PSET (rock(target).x, rock(target).y), C(0) '                           erase center dot

        IF rock(target).stayPainted THEN _PUTIMAGE (rock(target).x - 20, rock(target).y - 20), I(0) '   rock's outline turns into 3D-ish rock image

        PRESET (ship.x, ship.y), ship.col
        DRAW "TA=" + VARPTR$(spin) + ship.kind '                                draw ship with rock
        PAINT (ship.x, ship.y - 1), C(3), ship.col
        PSET (ship.x, ship.y), C(0) '                                           erase the center dot in ship
    END IF

    IF rocket THEN '                                                            flame draw after ship & rock
        LINE (xPointStart, yPointStart)-(xPointEnd, yPointEnd), C(12) '         center flame line
        LINE (xPointStart + 1, yPointStart + 2)-(xPointEnd, yPointEnd), C(9) '  two V shaping lines
        LINE (xPointStart - 1, yPointStart + 2)-(xPointEnd, yPointEnd), C(9)
        rocket = FALSE
    END IF
    ' --------------------------
    IF flag.regularChecks THEN '                                                ** on-screen / off-screen behavior **
        IF ship.x < -5 AND NOT flag.shutFrontDoor THEN ship.x = _WIDTH + 5 '                                normal behavior
        IF ship.x < -5 AND flag.shutFrontDoor THEN ship.x = 20: _SNDPLAYCOPY S(2), .5 '                     bounce off left side during comets
        IF ship.x > _WIDTH + 5 AND flag.shutBackDoor THEN ship.x = _WIDTH - 20: _SNDPLAYCOPY S(2), .5 '     bounce off right side, round 2
        IF ship.x > _WIDTH + 5 THEN ship.x = -4 '                                                           normal
        ' *************
        IF ship.y < -5 AND NOT flag.landingTime THEN ship.y = _HEIGHT + 5 '                                 normal behavior
        IF ship.y < -5 AND flag.landingTime AND NOT ship.charged AND NOT flag.go2Space THEN ship.y = 50: ship.Vy = 0 '  can't fly off screen going up during landing
        IF ship.y < -5 AND ship.charged THEN ship.y = _HEIGHT + 5 '                                         special normal...
        ' *************
        IF ship.y > _HEIGHT + 5 AND NOT flag.landingTime THEN ship.y = -4 '                                 normal
        IF ship.y > _HEIGHT - 117 AND flag.landingTime AND NOT flag.go2Space AND NOT flag.doFF THEN shipBoom '      crash on moon surface
    ELSE '                                                                      ** during force field challenge **
        forceFieldControl
    END IF '
END SUB
' -----------------------------------------

SUB saucerControl () '      a separate loop for drone battle

    DIM AS INTEGER a, c, i, targetX, targetY, cSx, cSy '  corrected Saucer X & Y
    DIM AS _BYTE leftClick, rndDone '
    DIM AS LONG outImg
    SHARED AS INTEGER toteSaucers, saucerKills
    SHARED AS INTEGER shipNum, limit, boomNum, redd, gren, blue, killRatio
    SHARED AS LONG saucerScape, starScape
    SHARED AS _BYTE sparkCycles, over(), pop
    SHARED Spark() AS SPARK
    STATIC AS XYPAIR lo(1 TO 4) '   gun locations
    STATIC AS INTEGER angle(1 TO 4), wide, high, numWaves, hitX, hitY
    STATIC AS _BYTE initd, doBoom, playing, cycleCount

    IF NOT initd THEN '
        wide = 1600: high = 900 '                   new rez 1600x900
        lo(1).x = 30: lo(1).y = 30 '                upper left          set gun locations
        lo(2).x = wide - 30: lo(2).y = 30 '         upper right
        lo(3).x = 30: lo(3).y = high - 30 '         lower left
        lo(4).x = wide - 30: lo(4).y = high - 30 '  lower right
        SCREEN _NEWIMAGE(wide, high, 32) '          ** higher resolution **
        IF _FULLSCREEN = 0 THEN _SCREENMOVE DTW / 2 - _WIDTH / 2, DTH / 2 - _HEIGHT / 2
        killNoises '                                takes care of stuck thruster sound
        initd = TRUE
        FOR i = 255 TO 0 STEP -4 '                                  fade in scene
            _LIMIT 120 '                                            control fade speed
            _PUTIMAGE , saucerScape
            _PUTIMAGE , viewScreen
            LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, i), BF '  increase black box transparency
            _DISPLAY
        NEXT
    END IF

    _KEYCLEAR
    _PRINTMODE _KEEPBACKGROUND
    _MOUSEMOVE _WIDTH / 2, _HEIGHT / 2

    start: '                                        beginning point after all saucers destroyed or offscreen

    IF NOT doBoom THEN '                            assign saucers, advamce wave count, up limit when done with explosions only
        assignSaucers
        numWaves = numWaves + 1
        limit = limit + killRatio * .1 '  + numWaves '   speed up a bit each wave based on performance
        toteSaucers = toteSaucers + shipNum '       total saucers in this round
    END IF
    ' -----------------------------------------------------
    DO
        _LIMIT limit '                                  limit set in assignSaucers

        IF _KEYDOWN(115) OR _KEYDOWN(83) THEN hold = TRUE: settings

        IF NOT hold THEN '                              pause execution during a call to settings sub

            WHILE _MOUSEINPUT: WEND
            targetX = _MOUSEX
            targetY = _MOUSEY
            leftClick = _MOUSEBUTTON(1)

            '
            CLS
            _PUTIMAGE , saucerScape '                                                   stars
            CIRCLE (targetX, targetY), 20, C(9) '                                       target circle - gotta add 20 both ways for image corner vs, mouse x,y issue
            LINE (targetX, targetY - 15)-(targetX, targetY + 15), C(4) '                crosshairs
            LINE (targetX - 15, targetY)-(targetX + 15, targetY), C(4)

            COLOR C(14) '                                                               ** SCORE ZONE **
            _FONT modernBigger
            _PRINTSTRING (_WIDTH - 240, 53), "SCORE:  " + STR$(score) '                 print score
            _PRINTSTRING (140, 53), "TOTAL SAUCERS: " + STR$(toteSaucers)
            _PRINTSTRING (140, 73), "DESTROYED:     " + STR$(saucerKills)
            killRatio = INT(saucerKills / toteSaucers * 100)
            _PRINTSTRING (140, 93), "KILL RATIO:    " + STR$(killRatio) + "%"
            ' ----------------------------
            c = 0
            DO '                                                                        ** GUN ZONE **
                c = c + 1
                angle(c) = GETANGLE(lo(c).x, lo(c).y, targetX, targetY) '               get all four angles
                RotateImage angle(c), I(1), outImg '                                    rotate and render all guns
                _PUTIMAGE (lo(c).x - _WIDTH(outImg) \ 2, lo(c).y - _HEIGHT(outImg) \ 2), outImg, 0
            LOOP UNTIL c = UBOUND(lo)
            ' -----------------------
            a = 0 '                                                                     command string parse
            DO
                a = a + 1 '                                                             increments thru saucers up to shipNum
                IF saucer(a).alive THEN '                                               skip dead saucers
                    IF saucer(a).getCommand THEN
                        getNextCommand a '                                              grab action letter and loopNum from command line
                        saucer(a).getCommand = FALSE
                    END IF
                    IF saucer(a).loopCounter = saucer(a).loopNum THEN '                 if still churning thru single command don't reassign new command yet
                        saucer(a).getCommand = TRUE
                        _CONTINUE '                                                     skip this cycle till new command retrieved
                    END IF
                    saucer(a).loopCounter = saucer(a).loopCounter + 1 '                 increment action counter up to loopNum
                    renderSaucer a
                END IF
            LOOP UNTIL a = shipNum '
            ' ----------------------------
            a = 0
            DO '                                                                        display saucers
                a = a + 1
                IF saucer(a).alive THEN
                    _PUTIMAGE (saucer(a).loc.x, saucer(a).loc.y), HDWimg(a), 0
                END IF
            LOOP UNTIL a = shipNum
            ' *******************************************
            IF leftClick THEN '                                                         ** MOUSE ACTION **
                IF cycleCount < 14 THEN
                    cycleCount = cycleCount + 1

                    IF NOT playing THEN _SNDPLAYCOPY S(27), .12: playing = TRUE '       laser blasts

                    a = 0 '
                    DO '                                4 laser positions wuth 3 beams each
                        a = a + 1
                        LINE (lo(a).x, lo(a).y)-(targetX, targetY), C(4) '              middle beam green
                        LINE (lo(a).x + 2, lo(a).y + 2)-(targetX, targetY), C(14) '     side 1 yellow
                        LINE (lo(a).x - 2, lo(a).y - 2)-(targetX, targetY), C(12) '     side 2 red
                    LOOP UNTIL a = 4

                    a = 0
                    DO '                                check for hit...
                        a = a + 1
                        IF saucer(a).alive THEN
                            '   correct saucer location onscreen with cursor/target - as saucer image grows - upper right corner steps back
                            cSx = saucer(a).loc.x + 30 '
                            cSy = saucer(a).loc.y + 30 '
                            IF targetX > cSx - 15 AND targetX < cSx + 15 THEN
                                IF targetY > cSy - 15 AND targetY < cSy + 15 THEN '
                                    _SNDPLAY S(INT(RND * 3 + 4)) '                  boom
                                    score = score + 75 '                            SCORE
                                    saucerKills = saucerKills + 1 '                 track kills
                                    saucer(a).alive = FALSE
                                    hitX = saucer(a).loc.x
                                    hitY = saucer(a).loc.y
                                    doBoom = TRUE
                                    EXIT DO '
                                END IF
                            END IF
                        END IF
                    LOOP UNTIL a = shipNum
                END IF
            END IF
            ' *******************************************
            IF NOT leftClick THEN
                playing = FALSE '           kill sound
                cycleCount = 0 '            reset laser fire time
            END IF
            ' *******************************************
            IF doBoom THEN
                boomNum = 20 '
                redd = 200 '
                gren = 220
                blue = 110 '
                sparkCycles = sparkCycles + 1
                IF sparkCycles < boomNum THEN
                    MakeSparks hitX + 28, hitY + 28
                    UpdateSparks '
                END IF
                IF sparkCycles >= boomNum THEN
                    doBoom = FALSE
                    sparkCycles = 0
                    REDIM Spark(0) AS SPARK '           took a while to figure out to put this here! <<<<
                END IF
            END IF
            ' ----------------------------

            ManageBullets

            _PUTIMAGE , viewScreen '                    window border for cockpit view
            _DISPLAY
            IF _KEYDOWN(27) THEN pop = TRUE: _MOUSESHOW: hold = TRUE '

            ' ************************      local sound events
            IF NOT over(9) THEN _SNDLOOP S(31): over(9) = TRUE '        loop saucer bg
            IF NOT over(10) THEN SndFade2 S(31), .001, .05, 0, 10 '     turn up saucer loop
            ' ************************

            IF numWaves = 4 THEN _SNDPLAY VO(20): _SNDPLAY S(35) '          unusual energy reading   ** SAUCER ROUNDS **
            IF numWaves = 6 THEN
                flag.doFF = TRUE '                      turn on force field sub
                flag.doSaucers = FALSE
                flag.doRocks = FALSE
                numWaves = 0 '                          reset static variables for next round
                ship.speed = 0
                SCREEN _NEWIMAGE(1280, 720, 32) '       back to lower resolution
                IF _FULLSCREEN = 0 THEN _SCREENMOVE DTW / 2 - _WIDTH / 2, DTH / 2 - _HEIGHT / 2
                _PUTIMAGE , starScape '                                       <<<< made starscape <<<<
                initd = FALSE '                         reset initialize flag
                _FONT 16
                _FREEIMAGE outImg '
                EXIT SUB
            END IF

            c = 0
            rndDone = TRUE '                            check for done
            DO
                c = c + 1
                IF saucer(c).alive THEN
                    rndDone = FALSE
                    EXIT DO
                END IF
            LOOP UNTIL c = shipNum

        END IF '                   -------- BOTTOM OF HOLD POINT --------

        IF pop THEN popUp

    LOOP UNTIL rndDone

    GOTO start '                                        closed loop
END SUB
' -----------------------------------------

SUB forceFieldControl () '                              ship behavior and rendering cage

    DIM AS INTEGER b1, b2, i
    STATIC AS SINGLE c1, c2, a, b, FPS, ffTime
    STATIC AS XYPAIR alien
    SHARED AS _UNSIGNED LONG weakWallColor
    STATIC AS _BYTE play2
    SHARED AS _BYTE bounceOffs, over()
    STATIC AS INTEGER c, cycles
    DIM AS LONG img, outimg
    SHARED AS LONG starScape, shipImg
    SHARED AS STRING shipType()
    SHARED AS INTEGER cageTime

    IF NOT over(17) THEN _SNDPLAY S(34): over(17) = TRUE '          resetting scary noise

    IF NOT initFF THEN '                                            big opener
        bounceOffs = 0
        FOR i = 255 TO 0 STEP -3 '                                  fade in scene
            _LIMIT 130 '                                            control fade speed
            _PUTIMAGE , starScape
            _PUTIMAGE (CENTX - 20, CENTY + 50), shipImg
            LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, i), BF '  increase black box transparency
            _DISPLAY
        NEXT

        killChecks
        killNoises
        alien.x = _WIDTH + 50 '             put alien offstage right
        alien.y = _HEIGHT \ 2 - 25
        _SNDSTOP S(31)

        DO '                                alien zooms in
            CLS
            _LIMIT 90
            alien.x = alien.x - 3
            _PUTIMAGE , starScape
            _PUTIMAGE (CENTX - 20, CENTY + 50), shipImg
            _PUTIMAGE (alien.x, alien.y), I(2) '
            _DISPLAY
        LOOP UNTIL alien.x <= _WIDTH \ 2 - 60

        _SNDPLAY S(33) '                    shoot sound
        _SNDPLAY S(26) '                    swooping in sound
        a = 4: b = 2.58 '
        c = 0: FPS = 6
        DO '                                spinning force field animation
            CLS
            _LIMIT FPS
            _PUTIMAGE , starScape
            _PUTIMAGE (CENTX - 20, CENTY + 50), shipImg
            alien.x = alien.x + 5
            _PUTIMAGE (alien.x, alien.y), I(2) '
            a = a * 1.019
            b = b * 1.019
            c = c + 5
            IF FPS < 105 THEN FPS = FPS + 2
            img = _NEWIMAGE(a, b, 32)
            outimg = _NEWIMAGE(a, b, 32)
            _DEST img
            LINE (1, 1)-(_WIDTH - 1, _HEIGHT - 1), C(14), B
            IF c > 30 THEN PAINT (_WIDTH / 2, _HEIGHT / 2), _RGB32(255, 0, 0, 132), C(14)
            _DEST 0
            RotateImage c, img, outimg
            _PUTIMAGE (CENTX - _WIDTH(outimg) / 2, CENTY - _HEIGHT(outimg) / 2), outimg
            _DISPLAY
        LOOP UNTIL c = 1445 '

        _FREEIMAGE img
        _FREEIMAGE outimg
        IF NOT over(15) THEN flag.startFFloop = TRUE: over(15) = TRUE

        weakWallColor = C(14) '         reset WeakWallColor here <<
        initFF = TRUE
        _SNDPLAY S(13) '                warning beeps (4)
        ship.x = CENTX: ship.y = CENTY + 69: ship.speed = 0: ship.course = 359 '   ship settings <<
        ffTime = TIMER
    END IF

    COLOR C(9)
    _FONT menlo
    cageTime = INT(TIMER - ffTime)
    _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH("XXXXX SECONDS") \ 2, _HEIGHT - 30), STR$(cageTime) + " SECONDS" '      show a timer - to put the heat on the player

    cycles = cycles + 1 '

    SELECT CASE cycles '                sound events
        CASE 40: _SNDPLAY S(13)
        CASE 98: play2 = TRUE
        CASE 100: _SNDPLAY VO(17)
        CASE 340: play2 = FALSE
        CASE 350: _SNDPLAY VO(18)
        CASE 450: _SNDPLAY VO(16)
        CASE 750: _SNDPLAY S(3) '
            flag.landingTime = TRUE '  also true (main thrusters ON) if weak wall is hit
    END SELECT

    IF play2 THEN _SNDPLAY S(12)

    '
    IF ship.x > _WIDTH - lineX THEN ship.x = _WIDTH - (lineX + 10): ship.Vx = 0: ship.Vy = 0: _SNDPLAY S(2) '   force field cage rules
    IF ship.y < 50 THEN ship.y = 60: ship.Vy = 0: ship.Vx = 0: _SNDPLAY S(2) '
    IF ship.y > _HEIGHT - 50 THEN ship.y = _HEIGHT - 60: ship.Vy = 0: ship.Vx = 0: _SNDPLAY S(2)

    IF NOT flag.doDeflect THEN LINE (lineX, 50)-(lineX, _HEIGHT - 50), weakWallColor ' draw left cage side   ** WEAK WALL <<<<<  draw box
    LINE (lineX, 50)-(_WIDTH - lineX, 50), C(14) '      top line      ** draw FF cage **
    LINE -(_WIDTH - lineX, _HEIGHT - 50), C(14) '       right side
    LINE -(lineX, _HEIGHT - 50), C(14) '                bottom line
    '                                                   line effects
    IF c1 < _WIDTH - 320 THEN c1 = c1 + 9 ELSE c1 = 0 '
    IF c2 < _HEIGHT - 100 THEN c2 = c2 + 5.82 ELSE c2 = 0 '     moving green balls over yellow lines
    IF b2 < _HEIGHT - 100 THEN b2 = b2 + c2
    IF b1 < _WIDTH - 50 THEN b1 = b1 + c1

    CIRCLE (lineX + b1, 50), 3, C(4) '                      top
    CIRCLE (lineX + b1, _HEIGHT - 50), 3, C(4) '            bot
    CIRCLE (_WIDTH - lineX - b1, 50), 3, C(4) '             top
    CIRCLE (_WIDTH - lineX - b1, _HEIGHT - 50), 3, C(4) '   bot
    CIRCLE (_WIDTH - lineX, _HEIGHT - 50 - b2), 3, C(4) '   right bot
    CIRCLE (_WIDTH - lineX, 50 + b2), 3, C(4) '             right top
    IF bounceOffs < 3 THEN
        CIRCLE (lineX, 50 + b2), 3, C(4) '                      left top  ** WEAK WALL <<<<< moving balls
        CIRCLE (lineX, _HEIGHT - 50 - b2), 3, C(4) '            left bot  **
    ELSE
        IF NOT over(16) THEN _SNDPLAYCOPY S(20), .2: over(16) = TRUE
    END IF

    IF ship.x < lineX THEN '            ** CONTACT with Weak Wall **
        flag.doFF = FALSE
        flag.landingTime = TRUE
        flag.doDeflect = TRUE '
        flag.regularChecks = FALSE '
    END IF

    _FONT 16
END SUB
' -----------------------------------------

SUB deflectFF () '                      draw lines (2), determine how much to spring

    STATIC AS SINGLE oldVx, decel '
    STATIC AS _BYTE initd, started
    STATIC AS INTEGER redd, gren, busted
    SHARED AS _UNSIGNED LONG weakWallColor
    SHARED AS _BYTE bounceOffs
    DIM AS _UNSIGNED LONG WWCol

    IF NOT started THEN
        redd = 225
        gren = 255
        started = TRUE
        killChecks '                    prevents boom sounds @ escaping...
    END IF

    IF NOT initd THEN '
        oldVx = ship.Vx
        initd = TRUE
    END IF

    IF ship.x > lineX - 10 AND ship.x < lineX AND ship.Vx < 0 THEN _SNDPLAY S(1) '      impact thump

    IF ship.x < 40 THEN busted = busted + 1 '   track cycles in stretch zone
    IF busted > 50 THEN '                       FF broken!
        busted = 0 '                            CLEANUP on the ** way out **
        decel = 0
        bounceOffs = 0
        flag.landingTime = FALSE '
        flag.goDissolveFF = TRUE
        flag.regularChecks = TRUE '
        flag.doDeflect = FALSE
        initd = FALSE
        started = FALSE
        _SNDPLAY S(24) '                        whip sound for breaking FF
        ship.speed = 5 '                        zoom away
        oldVx = 0
        score = score + 350 '                   SCORE
    END IF

    IF ship.x > lineX - 30 THEN WWCol = weakWallColor ELSE WWCol = C(12) '      weakened FF color vs. bright red when stretched tight
    LINE (lineX, 50)-(ship.x, ship.y + 2), WWCol '              draw 2-part FF line bent around ship deflection
    LINE (lineX, _HEIGHT - 50)-(ship.x, ship.y), WWCol
    IF ship.x < lineX THEN ship.Vx = ship.Vx + 2 - decel '      quick deceleration

    IF ship.Vx < .5 AND ship.Vx > -.5 THEN '                    spring back!
        ship.Vx = -oldVx * 1.3 '
        IF bounceOffs > 2 THEN _SNDPLAY S(25) '                 do zoom sound
    END IF

    IF ship.x > lineX THEN '                                    bounce back reset
        IF decel < 1.8 THEN decel = decel + .2 '                greater stretchiness each bounce-off by increasing Vx reduction
        bounceOffs = bounceOffs + 1
        IF redd < 256 THEN redd = redd + 4 ' WAS 6
        IF gren > 0 THEN gren = gren - 11 ' WAS 16
        weakWallColor = _RGB32(redd, gren, 0)
        flag.doDeflect = FALSE
        flag.doFF = TRUE
        initd = FALSE
    END IF
END SUB
' -----------------------------------------

SUB dissolveFF () '     this fades the force field and returns to the beginning - after increasing the # of rocks

    STATIC AS SINGLE fader
    STATIC AS _BYTE initd
    STATIC AS INTEGER c, adjuster, upperX, lowerX

    IF NOT initd THEN
        fader = 255
        _SNDPLAY S(23) '                        heaven sound
        c = 0
        initd = TRUE
        adjuster = CENTY - ship.y '             adjust line segment lengths of broken FF acc. to ship.y position
        IF SGN(adjuster) = 1 THEN
            adjuster = (-CENTY + ship.y) \ 5
            upperX = adjuster
            lowerX = -adjuster
        END IF

        IF SGN(adjuster) = -1 THEN
            adjuster = (ship.y - CENTY) \ 5
            lowerX = adjuster
            upperX = -adjuster
        END IF
    END IF

    c = c + 1 '
    LINE (lineX, 50)-(_WIDTH - lineX, 50), _RGB32(255, 190, 0, fader) '     top line        ** draw FF cage **
    LINE -(_WIDTH - lineX, _HEIGHT - 50), _RGB32(255, 190, 0, fader) '      right side
    LINE -(lineX, _HEIGHT - 50), _RGB32(255, 255, 0, fader) '               bottom line

    LINE (lineX, 50)-(36 + upperX, 205 - c), _RGB32(255, 0, 0, fader) '                     broken weak wall segments
    LINE (lineX, _HEIGHT - 50)-(48 + lowerX, _HEIGHT - 210 + c), _RGB32(255, 0, 0, fader)
    fader = fader - 1.65 ' was 1.4
    IF fader < 30 THEN '                    reset lotsa flags
        flag.goDissolveFF = FALSE
        initd = FALSE '                     reset init
        MAXROCKS = MAXROCKS + 4 '                                                       MAKE THIS 6? 8?
        assignRocks '                       this turns on flag.doRocks
        flag.fadeInRocks = TRUE
        flag.doAutoShields = TRUE
        flag.doResetFlags = TRUE
        flag.doRockMask = FALSE
        flag.checkFSC = TRUE '
        flag.harpooned = FALSE
        flag.landingTime = FALSE
        rock(target).stayPainted = FALSE
        _SNDSTOP S(32)
    END IF
END SUB
' -----------------------------------------

SUB postLanding ()

    SHARED AS _BYTE played

    IF _KEYDOWN(32) AND ship.charging THEN '                    blast off from charging station
        ship.charging = FALSE
        ship.landed = FALSE
        flag.chargeDone = TRUE
        ship.x = 761
        ship.y = 530
        _SNDPLAY S(20) '            zap sound
        _SNDPLAY VO(23) '           leave orbit...
        EXIT SUB
    END IF

    IF _KEYDOWN(32) AND ship.x < 700 AND NOT detached THEN '    detach rock in drop zone (if the ship isn't at the charging station - x check)
        flag.detachRock = TRUE '
        flag.doRockMask = FALSE
        flag.rockMoving = TRUE
        detached = TRUE
        _SNDPLAY S(19) '            hydraulic sound
    END IF
END SUB
' -----------------------------------------

SUB moveTargetRock ()

    STATIC AS INTEGER c
    STATIC AS SINGLE d, e, gren, alpha
    STATIC AS _BYTE played
    SHARED AS INTEGER spin2
    DIM AS INTEGER xStart, yStart

    xStart = 326: yStart = 644: gren = 127 '                        location of laser station, green start color
    c = c + 1
    IF c = 99 THEN _SNDPLAY S(22) '                                 tractor beam sound
    IF c > 105 AND c < 205 THEN
        rock(target).y = rock(target).y - .48 '                     pick up rock, heat it up
        IF d < 127 THEN d = d + .88
        rock(target).col = _RGB32(0, INT(gren + d), 0) '            change rock edge color dark green to bright green
    END IF
    IF c > 205 AND c <= 500 THEN
        rock(target).col = C(4)
        rock(target).x = rock(target).x - .67 '                     slide over and fade in dark green body fill color, bake it
        PRESET (rock(target).x, rock(target).y), rock(target).col
        DRAW "TA=" + VARPTR$(spin2) + rock(target).kind '           draw rock - gotta draw the rock before painting it
        PSET (rock(target).x, rock(target).y), C(0) '               erase center dot
        IF e < 255 THEN e = e + 1.1
        PAINT (rock(target).x, rock(target).y), _RGB32(0, 106, 0, INT(alpha + e)), C(4) ' fill rock w/ green
    END IF
    IF c > 500 AND c < 642 THEN '                                   place rock and magically crystalize it
        rock(target).y = rock(target).y + .5
        PSET (rock(target).x + INT((RND - RND) * 35), rock(target).y + INT((RND - RND) * 33)), C(14) '      yellow fairy dust
        PSET (rock(target).x + INT((RND - RND) * 35), rock(target).y + INT((RND - RND) * 33)), C(16) '      brightwhite
        CIRCLE (rock(target).x + INT((RND - RND) * 30), rock(target).y + INT((RND - RND) * 33)), 3, C(4) '  bright green circle
        CIRCLE (rock(target).x + INT((RND - RND) * 30), rock(target).y + INT((RND - RND) * 33)), 3, C(3) '  dark green circle
        IF NOT played THEN
            _SNDPLAY VO(13) '                                       recharge and instructions, played once only
            _SNDPLAY VO(15)
            played = TRUE
        END IF
    END IF
    PRESET (rock(target).x, rock(target).y), rock(target).col
    DRAW "TA=" + VARPTR$(spin2) + rock(target).kind '               draw rock
    PSET (rock(target).x, rock(target).y), C(0) '                   erase center dot
    IF c >= 500 THEN PAINT (rock(target).x, rock(target).y), _RGB32(0, 98, 0), C(4)
    IF c > 600 THEN
        _PUTIMAGE (rock(target).x - 20, rock(target).y - 20), I(0) '    final rock overlay?
        CIRCLE (rock(target).x + INT((RND - RND) * 20), rock(target).y + INT((RND - RND) * 23)), 3, C(4) '  bright green circle
        CIRCLE (rock(target).x + INT((RND - RND) * 20), rock(target).y + INT((RND - RND) * 23)), 3, C(3) '  dark green circle
    END IF
    _PUTIMAGE (0, 530)-(1280, 720), moonScape '                                     draw moonscape again to cover the rock edges upon landing
    IF c > 99 THEN
        LINE (xStart, yStart)-(rock(target).x - 15, rock(target).y), C(14) '        lasers move rock
        LINE (xStart, yStart)-(rock(target).x + 15, rock(target).y), C(14)
    END IF
    IF c > 642 THEN '                                               done, reset
        c = 0: d = 0: e = 0: alpha = 0
        flag.rockMoving = FALSE
        rock(target).stayPainted = TRUE '                           triggers the new 3D rock image in shipControl
        _SNDSTOP S(22) '                                            kill tractor beam sound
    END IF
END SUB
' -----------------------------------------

SUB checkLanding () '           rock drop checking

    DIM d AS INTEGER '
    SHARED AS STRING shipType()
    SHARED AS _BYTE chargeScoreDone

    d = -getCourse(ship.course) '                                                           x and y position already checked in main loop
    IF ship.Vy < .85 AND ship.Vy > 0 AND ABS(ship.Vx) < .5 AND (d > 356 OR d < 4) THEN '    check y vector, x vector, ship orientation (upright)
        killNoises
        _SNDPLAY S(3)
        ship.kind = shipType(4)
        ship.landed = TRUE
        ship.Vx = 0
        ship.Vy = 0
        ship.speed = 0
        IF NOT chargeScoreDone THEN score = score + 250 '
    END IF
END SUB
' -----------------------------------------

SUB check4Harpoon ()

    SHARED AS STRING shipType()
    SHARED AS INTEGER lockedAngle
    DIM spin AS INTEGER

    IF NOT flag.harpooned AND ship.x > rock(target).x - 10 AND ship.x < rock(target).x + 10 THEN '  check for ship and target rock overlap
        IF ship.y > rock(target).y - 10 AND ship.y < rock(target).y + 10 THEN
            IF _KEYDOWN(32) THEN
                _SNDPLAY S(14)
                ' make the ship controls work on the rock, turn off drawRocks on target only
                rock(target).rotation = FALSE
                spin = rock(target).spinAngle
                DRAW "TA=" + VARPTR$(spin) + rock(target).kind
                lockedAngle = getCourse(ship.course)
                flag.harpooned = TRUE
                flag.shutBackDoor = TRUE
                score = score + 500
            END IF
        END IF
    END IF
END SUB
' -----------------------------------------

SUB check4RockContact () '          Thanks, Terry Ritchie!
    '                               circle proximity - collision detection
    SHARED AS RECT cBox, wBox
    DIM AS _BYTE c, w

    w = 0: c = 0 '                                              compare rock(c) to others, rocks (w)
    DO
        c = c + 1
        w = c
        DO
            w = w + 1
            cBox.x1 = rock(c).x - rock(c).radius '              calculate rectangular coordinates
            cBox.y1 = rock(c).y - rock(c).radius '              for rock c and rock w
            cBox.x2 = rock(c).x + rock(c).radius '
            cBox.y2 = rock(c).y + rock(c).radius
            wBox.x1 = rock(w).x - rock(w).radius
            wBox.y1 = rock(w).y - rock(w).radius
            wBox.x2 = rock(w).x + rock(w).radius
            wBox.y2 = rock(w).y + rock(w).radius
            IF RectCollide(cBox, wBox) THEN '                   rectangular collision?
                IF CircCollide(rock(c), rock(w)) THEN '         circle collision?
                    checkRockCollision c, w '                   collision happened!
                    checkFor3WayLockUp c, w
                END IF
            END IF
        LOOP UNTIL w = MAXROCKS
    LOOP UNTIL c = MAXROCKS - 1
END SUB
'------------------------------------------------------------------------------------------------------------

SUB checkFor3WayLockUp (c AS _BYTE, w AS _BYTE) '   rocks c & w are now possibly stuck, check for another culprit

    DIM AS _BYTE a, b, dummy

    a = 0
    dummy = c
    DO
        a = a + 1
        IF a = 2 THEN dummy = w ' on second run thru check the w rock
        b = 0
        DO
            b = b + 1
            IF b <> c AND b <> w THEN '
                IF CircCollide(rock(dummy), rock(b)) THEN '

                    ' make all three vectors opposite vectors

                    _SNDPLAY S(2)
                    repel3 b, c, w '        push the three apart
                END IF
            END IF
        LOOP UNTIL b = MAXROCKS - 1
    LOOP UNTIL a = 2
END SUB
' -----------------------------------------

SUB check4ShipROCKCollision () '

    SHARED AS RECT cBox, wBox
    DIM AS INTEGER w
    SHARED AS INTEGER rockHeading, oTime
    SHARED AS INTEGER redd, gren, blue, boomNum
    SHARED AS LONG timer1
    SHARED AS _BYTE played, target

    w = 0
    DO
        w = w + 1
        cBox.x1 = ship.x - ship.radius '                    calculate rectangular coordinates
        cBox.y1 = ship.y - ship.radius '                    for rock c and rock w
        cBox.x2 = ship.x + ship.radius '
        cBox.y2 = ship.y + ship.radius
        wBox.x1 = rock(w).x - rock(w).radius
        wBox.y1 = rock(w).y - rock(w).radius
        wBox.x2 = rock(w).x + rock(w).radius
        wBox.y2 = rock(w).y + rock(w).radius

        IF w <> target THEN '                               exclude the purple rock
            IF RectCollide(cBox, wBox) THEN '               rectangular collision?
                IF CircCollide2(ship, rock(w)) THEN '       circle collision?
                    IF ship.shields <= 0 THEN '        ship explode - when doAutoShields is OFF - BOOOM! -
                        shipBoom
                        score = score - 100 '               boom penalty
                        oTime = 0 '                         reset overlap cycles
                        EXIT SUB
                    ELSE '                                  bounce off if auto shields are on
                        _SNDPLAYCOPY S(7), .27 '                                deflection sound
                        rockHeading = (Vec2Deg(rock(w).Vx, rock(w).Vy)) '       both are in negative degrees
                        ship.course = rockHeading - 45 '    course change
                        IF ship.speed < 1 THEN ship.speed = 1.1
                        flag.doCircle = TRUE
                        flag.trackShields = TRUE
                        ship.shields = ship.shields - .54 ' SHIELDS
                        score = score - 2 '                 SCORE
                        ship.power = ship.power - .34
                    END IF
                END IF
            END IF
        END IF
    LOOP UNTIL w = MAXROCKS
END SUB
' -----------------------------------------

SUB checkRockCollision (c AS INTEGER, w AS INTEGER) '    collisions between rock(c) & rock(w)

    STATIC AS INTEGER oldC, oldW
    DIM AS INTEGER hypot, overlap, push '

    SWAP rock(c).Vx, rock(w).Vx '                       Thanks to ** Will Kluger ** for help with this routine
    SWAP rock(c).Vy, rock(w).Vy '                       always swap colliding rocks vectors upon collision
    IF NOT _SNDPLAYING(S(1)) THEN _SNDPLAYCOPY S(1), .13 '                   thump

    IF c = oldC AND w = oldW THEN '            ****** TROUBLE > if it's the same two rocks again, then push them apart
        hypot = findHypot(rock(c), rock(w)) '                   calculate how far to push them, uses slow SQR() but only a little
        overlap = (rock(c).radius + rock(w).radius) - hypot
        push = overlap / 2 + 4 ' 3                              # of pixels needed each way (x, y) to achieve separation (and a bit more)
        ' *******************************************************
        ' counter measures for pushing 2 rocks out of a stuck state  '    ** TROUBLESHOOTING ** OVERLAP BUZZER goes here **
        IF rock(c).x > rock(w).x THEN '             push locations apart based on relative position
            rock(c).x = rock(c).x + push
            rock(w).x = rock(w).x - push
        ELSE IF rock(c).x <= rock(w).x THEN
                rock(w).x = rock(w).x + push
                rock(c).x = rock(c).x - push
            END IF
        END IF
        IF rock(c).y > rock(w).y THEN
            rock(c).y = rock(c).y + push '
            rock(w).y = rock(w).y - push
        ELSE IF rock(c).y <= rock(w).y THEN
                rock(w).y = rock(w).y + push
                rock(c).y = rock(c).y - push
            END IF
        END IF
        oldC = 0 '                  reset rocks to compare - forgot this!
        oldW = 0
        EXIT SUB '                  don't save old rock pair below, skip rotation change
    END IF
    oldC = c: oldW = w '            save collision pair to compare to next cycle's pair
    ' ***********************************************************
    IF rock(c).rotation THEN '                                                                          flip rotation randomly
        IF rock(c).rotDir = "clock" THEN rock(c).rotDir = "cClock" ELSE rock(c).rotDir = "clock" '      rocks initially are 1 or 2 spinspeed
        IF rock(c).spinSpeed = 2 THEN rock(c).spinSpeed = 1
    END IF
    IF rock(w).rotation THEN
        IF rock(w).rotDir = "clock" THEN rock(w).rotDir = "cClock" ELSE rock(w).rotDir = "clock"
        IF rock(w).spinSpeed = 1 THEN rock(w).spinSpeed = 2 ELSE rock(w).spinSpeed = 1 ' 2, 3
    END IF
END SUB
' -----------------------------------------

SUB checkShipCOMETCollision () '

    SHARED AS RECT cBox, wBox
    DIM AS INTEGER w
    SHARED AS INTEGER redd, gren, blue, boomNum
    SHARED AS _BYTE played, target
    SHARED comet() AS comet
    SHARED ship AS ship

    w = 0
    DO
        w = w + 1
        IF comet(w).alive THEN
            cBox.x1 = ship.x - ship.radius '                calculate rectangular coordinates
            cBox.y1 = ship.y - ship.radius '                for rock c and rock w
            cBox.x2 = ship.x + ship.radius '
            cBox.y2 = ship.y + ship.radius
            wBox.x1 = comet(w).x - comet(w).radius
            wBox.y1 = comet(w).y - comet(w).radius
            wBox.x2 = comet(w).x + comet(w).radius
            wBox.y2 = comet(w).y + comet(w).radius

            IF RectCollide(cBox, wBox) THEN '               rectangular collision?
                IF CircCollide3(ship, comet(w)) THEN '      circle collision?
                    ship.shields = ship.shields - 3.8 '     shields
                    score = score - 25 '                    score
                    ship.power = ship.power - 1.6 '         power
                    flag.doSparks = TRUE: boomNum = 6: redd = 218: gren = 85: blue = 6 '    do comet explosion only
                    comet(w).alive = FALSE
                    _SNDPLAY S(INT(RND * 3 + 4))

                    IF ship.shields > 14 THEN
                        flag.doCircle = TRUE '              show shield
                        flag.trackShields = TRUE
                    END IF

                    IF ship.shields <= 0 THEN '
                        flag.doCircle = FALSE
                        flag.trackShields = FALSE
                        flag.checkCometCollisions = FALSE
                        shipBoom '                                  ship explodes too
                        CIRCLE (ship.x, ship.y - 1), 18, C(0) '     erase circle - neeed?   PROB NO
                        score = score - 100
                    END IF
                END IF
            END IF
        END IF
    LOOP UNTIL w = UBOUND(comet)
END SUB
' -----------------------------------------

SUB checkShipGRIDCollision () '

    SHARED AS RECT cBox, wBox
    DIM AS INTEGER row, column
    SHARED AS INTEGER redd, gren, blue, boomNum
    SHARED AS LONG timer1
    SHARED AS _BYTE played, target
    SHARED comet() AS comet
    SHARED AS gridRock matrix()
    SHARED ship AS ship

    row = 0
    DO
        row = row + 1
        column = 0
        DO
            column = column + 1
            IF matrix(column, row).alive THEN
                cBox.x1 = ship.x - ship.radius '        calculate rectangular coordinates
                cBox.y1 = ship.y - ship.radius '        for rock c and rock w
                cBox.x2 = ship.x + ship.radius '
                cBox.y2 = ship.y + ship.radius
                wBox.x1 = matrix(column, row).x - 10 '  the radius of the tiny rocks?
                wBox.y1 = matrix(column, row).y - 10
                wBox.x2 = matrix(column, row).x + 10
                wBox.y2 = matrix(column, row).y + 10

                IF RectCollide(cBox, wBox) THEN '                           rectangular collision?
                    IF CircCollide4(ship, matrix(column, row)) THEN '       circle collision?
                        IF matrix(column, row).col <> _RGB32(215, 165, 89, 110) THEN '      if not bonus rocks then

                            score = score - 15
                            ship.shields = ship.shields - 2.5
                            ship.power = ship.power - .7

                            IF ship.shields <= 0 THEN '
                                flag.doCircle = FALSE
                                flag.trackShields = FALSE
                                flag.checkGridCollisions = FALSE
                                shipBoom '                                  ship explodes too
                                CIRCLE (ship.x, ship.y - 1), 18, C(0) '     erase circle - needed?
                                score = score - 100
                            END IF

                            flag.doSparks = TRUE
                            boomNum = 7
                            redd = 160
                            gren = 160
                            blue = 160 '
                            _SNDPLAY S(INT(RND * 3 + 4))

                            IF ship.shields > 14 AND flag.showGauges THEN '         gauges turn off when moonscape rolls in, no more shields circle artifacts
                                flag.doCircle = TRUE '                              show shield
                                flag.trackShields = TRUE
                            END IF

                        ELSE '                                                      if bonus rocks then
                            _SNDPLAYCOPY S(18), .15
                            IF ship.shields < 97 THEN
                                ship.shields = ship.shields + 1.8 '
                                score = score + 50
                                IF ship.power < 98 THEN ship.power = ship.power + 1
                            ELSE IF ship.power < 97 THEN ship.power = ship.power + 1.2
                            END IF
                            flag.doCircle = FALSE
                        END IF
                        matrix(column, row).alive = FALSE
                        flag.trackShields = TRUE
                    END IF
                END IF
            END IF
        LOOP UNTIL column = 20
    LOOP UNTIL row = 11
END SUB
' -----------------------------------------

SUB runCOMETS ()

    DIM AS INTEGER c, d, spin, antiHeading, dist
    DIM AS INTEGER xPointEnd, yPointEnd, xPointStart, yPointStart
    DIM AS DOUBLE radians
    DIM AS _BYTE done
    SHARED AS comet comet()
    SHARED AS LONG microMask, gridTimer
    STATIC AS _BYTE cometRounds, initd

    IF NOT initd THEN FPS = 58: initd = TRUE

    c = 0
    DO
        c = c + 1
        IF comet(c).alive THEN '                                                        draw comets
            _PUTIMAGE (comet(c).x - 10, comet(c).y - 10), microMask
            PRESET (comet(c).x, comet(c).y), comet(c).edge '                            outside of comet
            spin = INT(comet(c).rotAng)
            DRAW "TA=" + VARPTR$(spin) + comet(c).kind
            PSET (comet(c).x, comet(c).y), _RGB32(0)
            PAINT (comet(c).x + 1, comet(c).y + 1), comet(c).col, comet(c).edge '       translucent dark red inside
            ' ------------------------------------------                                opposite heading for flames
            antiHeading = (-Vec2Deg(comet(c).Vx, -comet(c).Vy)) '  ** FLAME ZONE **     negative Vy here    <<<<<<<<<<<<
            antiHeading = antiHeading + 90 '                                            adjust for QB64
            radians = _D2R(antiHeading)
            dist = INT(RND * 56 + 15) '                                                 distance for end of flames
            IF c MOD 2 = 0 THEN '                                                       half the comets have a tail
                xPointEnd = dist * COS(radians) + comet(c).x
                yPointEnd = dist * SIN(radians) + comet(c).y
                xPointStart = 13 * COS(radians) + comet(c).x '                          13 is dist from center of comet
                yPointStart = 13 * SIN(radians) + comet(c).y
                LINE (xPointStart - 1, yPointStart)-(xPointEnd, yPointEnd), _RGB32(255, 0, 0) '         center flame line
                LINE (xPointStart - 1, yPointStart - 2)-(xPointEnd, yPointEnd), comet(c).edge '         two V shaping lines
                LINE (xPointStart - 1, yPointStart + 2)-(xPointEnd, yPointEnd), _RGB32(255, 194, 94)
            END IF
            xPointStart = 7 * COS(radians) + comet(c).x '                               side flames
            yPointStart = 7 * SIN(radians) + comet(c).y '                               rework points for side flames
            xPointEnd = (dist / 2.2) * COS(radians) + comet(c).x
            yPointEnd = (dist / 2.2) * SIN(radians) + comet(c).y
            d = INT(RND * 3 + 1)
            IF d = 1 THEN
                LINE (xPointStart, yPointStart - 8)-(xPointEnd, yPointEnd - 8), _RGB32(255, 210, 102) '     outer flame lines
            ELSE LINE (xPointStart, yPointStart - 8)-(xPointEnd, yPointEnd - 8), _RGB32(255, 150, 132)
                IF d = 2 THEN
                    LINE (xPointStart, yPointStart - 6)-(xPointEnd, yPointEnd - 6), _RGB32(255, 210, 102)
                    LINE (xPointStart, yPointStart + 6)-(xPointEnd, yPointEnd + 6), _RGB32(255, 180, 142)
                END IF
            END IF
            LINE (xPointStart, yPointStart + 8)-(xPointEnd, yPointEnd + 8), _RGB32(255, 132, 98)
        END IF
    LOOP UNTIL c = UBOUND(comet) ' -----------------

    c = 0
    DO '                                        move comets
        c = c + 1
        comet(c).x = comet(c).x + comet(c).Vx
        comet(c).y = comet(c).y + comet(c).Vy
        comet(c).rotAng = comet(c).rotAng + comet(c).rotSpeed * comet(c).rotSign

        ' ****************************************
        '   rules for comet runs
        IF gameRound = 1 THEN
            IF comet(c).x > _WIDTH + 50 THEN comet(c).alive = FALSE '
        ELSE
            IF comet(c).x < -50 THEN comet(c).alive = FALSE '
        END IF
        IF comet(c).y > _HEIGHT + 40 OR comet(c).y < -30 THEN comet(c).alive = FALSE
        ' ****************************************

    LOOP UNTIL c = UBOUND(comet)

    done = TRUE '                               assume done
    c = 0
    DO
        c = c + 1
        IF comet(c).alive THEN done = FALSE '   check for done
    LOOP UNTIL c = UBOUND(comet)

    IF done THEN
        cometRounds = cometRounds + 1
        IF cometRounds < 3 THEN FPS = FPS + 4 '
        initCOMETS '                            reset comets

        IF gameRound = 1 THEN
            IF cometRounds = 3 THEN
                flag.doComets = FALSE
                flag.checkCometCollisions = FALSE
                flag.fadeOutComs = TRUE
                flag.shutBackDoor = FALSE
                flag.shutFrontDoor = FALSE
                flag.doGrid = TRUE
                flag.checkGridCollisions = TRUE
                gridTimer = TIMER
                cometRounds = 0
                initd = FALSE
                _SNDPLAY VO(11) '                   incoming rocks
            END IF
        ELSE
            IF gameRound > 1 THEN '                 this ALL here may change soon..... < MAKING PLANS FOR GAMEROUND 2! <<<<<<<<
                IF cometRounds = 4 THEN
                    flag.doComets = FALSE
                    flag.checkCometCollisions = FALSE
                    flag.fadeOutComs = TRUE
                    flag.shutBackDoor = FALSE
                    flag.shutFrontDoor = FALSE
                    flag.doGrid = TRUE
                    flag.checkGridCollisions = TRUE
                    gridTimer = TIMER
                    cometRounds = 0
                    initd = FALSE
                    _SNDPLAY VO(11) '               incoming rocks
                END IF
            END IF
        END IF
    END IF
END SUB
' -----------------------------------------

SUB runGRID ()

    SHARED AS LONG microMask
    SHARED AS gridRock matrix()
    SHARED AS STRING rockType()
    DIM AS _BYTE row, column, doneGrid
    DIM AS INTEGER spin
    STATIC AS SINGLE count, up, killSub
    '                                   ** matrix loops **
    row = 0 '
    DO
        row = row + 1 '                 draw matrix
        column = 0
        DO
            column = column + 1
            IF matrix(column, row).alive THEN
                spin = matrix(column, row).rotAng
                _PUTIMAGE (matrix(column, row).x - 10, matrix(column, row).y - 10), microMask '      block the background stars
                PRESET (matrix(column, row).x, matrix(column, row).y), _RGB32(130) '
                DRAW "TA=" + VARPTR$(spin) + rockType(1)
                IF matrix(column, row).col = _RGB32(215, 165, 89, 110) OR matrix(column, row).col <> _RGB32(0) THEN '   only paint speeders and non-black gridrocks
                    PAINT (matrix(column, row).x + 1, matrix(column, row).y + 1), matrix(column, row).col, _RGB32(130) '    painting all slows performance big time
                END IF
                PSET (matrix(column, row).x, matrix(column, row).y), _RGB32(0) '                     kill middle pixel
            END IF
        LOOP UNTIL column = 20
    LOOP UNTIL row = 11

    row = 0 '                           move matrix
    DO
        row = row + 1
        column = 0
        DO
            column = column + 1
            IF matrix(column, row).alive THEN
                IF INT(RND * 3 + 1) = 2 THEN
                    matrix(column, row).x = matrix(column, row).x + matrix(column, row).speed + (RND - RND) '           wiggly X
                ELSE matrix(column, row).x = matrix(column, row).x + matrix(column, row).speed '
                END IF
                IF matrix(column, row).special THEN matrix(column, row).x = matrix(column, row).x + .31 '               speeders
                IF matrix(column, row).yJiggle THEN matrix(column, row).y = matrix(column, row).y + (RND - RND) '       wiggly Y
                matrix(column, row).rotAng = matrix(column, row).rotAng + (RND * 2 + 1) * matrix(column, row).rotSign ' spin the rocks
                IF matrix(column, row).x > _WIDTH + 30 THEN matrix(column, row).alive = FALSE '                         assign as dead when offscreen - ONE WAY ONLY CHECK <<<<
            END IF
        LOOP UNTIL column = 20
    LOOP UNTIL row = 11
    ' ------------------
    IF matrix(20, 1).x > 2 THEN '                               move moonScape to the right onto screen
        IF count < 1281 THEN
            count = count + 1.65
            _PUTIMAGE (-1280 + count, 633), moonScape '         start it lower then move it up when done sliding over
        END IF
        IF count > 600 AND count < 604 THEN _SNDPLAY VO(9) '    gravity warning
        IF count >= 1280 AND up < 104 THEN '   '
            up = up + .75
            _PUTIMAGE (1280 - count, 633 - up), moonScape '     move moonscape up into position
        END IF
        IF up > 20 AND up < 22.2 THEN _SNDPLAY VO(10) '         landing mode
        IF up >= 101 THEN '                                     if moonscape set then kill it
            flag.showMoonScape = TRUE
            flag.landingTime = TRUE

            FPS = landingSpeed '                                user determined landing speed, default is slow **
            killSub = TRUE '
        END IF
    END IF
    ' -----------------                                         check for done
    IF matrix(20, 1).x > 100 THEN '
        doneGrid = TRUE '                                       assume done
        row = 0 '
        DO
            row = row + 1
            column = 0
            DO
                column = column + 1
                IF matrix(column, row).alive THEN
                    IF ship.x < matrix(20, 1).x THEN matrix(column, row).speed = 2.2
                    IF matrix(column, row).alive THEN doneGrid = FALSE '   if one's alive then not done yet
                END IF
            LOOP UNTIL column = 20
        LOOP UNTIL row = 11
        IF doneGrid AND killSub THEN
            flag.doGrid = FALSE '
            flag.checkGridCollisions = FALSE
            flag.fadeOutGrid = TRUE
            killSub = FALSE '                                   reset this all on the way out
            count = 0
            up = 0
            initGRID '                                          reset grid
        END IF
    END IF
END SUB
' -----------------------------------------

SUB flyBy ()

    STATIC AS INTEGER flyX, flyY, rand, rand2 '
    STATIC AS _BYTE initd
    STATIC AS SINGLE adder, rotAng
    STATIC AS _UNSIGNED LONG shipCol
    SHARED AS STRING shipType()

    IF NOT initd THEN
        rand = INT(RND * 2 + 1) '               50/50 right/left
        rand2 = INT(RND * 2 + 1)
        flyY = INT(RND * 230 + 30) '            start em a little lower
        initd = TRUE
        IF rand2 = 1 THEN shipCol = C(3) ELSE shipCol = C(10)
        IF rand = 1 THEN '                      leftward
            rotAng = INT(RND * 42 + 35)
            adder = -3
            flyX = _WIDTH + 10
        ELSE
            rotAng = INT(RND * -42 - 35) '      rightward
            adder = 3.1
            flyX = -10
        END IF
    END IF

    IF rand = 1 THEN
        rotAng = rotAng - .095 '
    ELSE rotAng = rotAng + .095
    END IF

    flyX = flyX + adder
    flyY = flyY + (RND - RND) * .7
    IF rotAng < 42 AND rotAng > -42 THEN ' was 41 not 61
        flyY = flyY - 1
        IF rand = 1 THEN
            adder = -2.4
        ELSE adder = 2.4
        END IF
    END IF

    PSET (flyX, flyY), C(14)
    DRAW "TA=" + VARPTR$(rotAng) + shipType(2)
    PAINT (flyX, flyY - 1), shipCol, C(14)
    IF flyX > _WIDTH + 10 OR flyX < -10 THEN
        flag.doFlyBy = FALSE
        initd = FALSE
    END IF

    IF flyX >= ship.x - 10 AND flyX <= ship.x + 10 THEN '           ** quick BA-BOOM CHECK **
        IF flyY >= ship.y - 10 AND flyY <= ship.y + 10 THEN
            shipBoom
        END IF
    END IF
END SUB
' -----------------------------------------

SUB soundCenter () '

    SHARED AS _BYTE over() '
    SHARED AS SINGLE gameTime

    ' self-terminating sound events                                                                     SndFade2 = snd, changeAmnt, goal, presVol, over(#) to kill
    IF NOT over(0) AND flag.doRocks THEN _SNDLOOP S(28): over(0) = TRUE '                               loop harvest background
    IF NOT over(1) AND flag.doRocks THEN SndFade2 S(28), .0002, .052, .001, 1 '                         turn up harvest loop
    IF NOT over(2) AND flag.doComets THEN SndFade2 S(28), -.009, 0, .052, 2 '                           turn off harvest loop

    IF NOT over(3) AND flag.doComets THEN _SNDLOOP S(29): over(3) = TRUE '                              loop comet background
    IF NOT over(4) AND flag.doComets AND NOT _SNDPLAYING(S(28)) THEN SndFade2 S(29), .004, .4, 0, 4 '   turn up comet loop
    IF NOT over(5) AND flag.doGrid THEN SndFade2 S(29), -.006, 0, .4, 5 '                               turn off cl

    IF NOT over(6) AND flag.landingTime THEN _SNDLOOP S(30): over(6) = TRUE '                           loop landing background
    IF NOT over(7) AND flag.landingTime AND NOT _SNDPLAYING(S(29)) THEN SndFade2 S(30), .001, .006, 0, 7 '  turn up drop rock loop
    IF NOT over(8) AND flag.go2Space THEN SndFade2 S(30), -.00011, 0, .009, 8 '                          turn off drl

    ' had to put these 2 statements inside the independent saucer loop
    IF NOT over(11) AND flag.doFF THEN SndFade2 S(31), -.003, 0, .05, 11 '                              turn off saucer loop
    IF NOT over(12) AND flag.startFFloop THEN _SNDLOOP S(32): _SNDVOL S(32), .007: over(12) = TRUE '    loop FF bg
    IF NOT over(13) AND flag.landingTime THEN _SNDPLAY VO(7): over(13) = TRUE '                         asteroid worth big bucks

    IF NOT over(18) THEN IF TIMER - gameTime > 2 THEN _SNDPLAY VO(3): over(18) = TRUE '                 auto-Shields ON in beginning  &&
    ' ***********************************
    IF flag.fadeOutCharge THEN SndFade S(21), -.004, 0, .45 '                                           MESSY sound checks
    IF NOT done1 AND flag.harpooned AND NOT flag.doPopUp THEN '                                         ADDED POPUP PROTECTION
        cometTime = TIMER '                                                 CRITICAL TIMER <<<< ********** <<<<<<<<<
        done1 = TRUE
        IF _SNDPLAYING(VO(5)) THEN _SNDSTOP VO(5) '                                                     howToCapture
        _SNDPLAY (VO(8)) '                                                                              nice job and WARNING
        warnSnd = TIMER
        warn = TRUE
    END IF
    IF NOT flag.gameOver AND warn AND TIMER - warnSnd > 6 THEN _SNDPLAY S(16): warn = FALSE '           warning beeper
    IF _SNDPLAYING(S(16)) AND NOT flag.gameOver THEN
        _SNDLOOP S(15): _SNDVOL S(15), .001 '                               start comet sound low
        flag.fadeInComs = TRUE '
    END IF
IF NOT done2 AND TIMER - cometTime > 7 AND flag.harpooned_
AND NOT flag.doRocks AND not flag.dopopup THEN
        flag.doComets = TRUE '                                              release the hounds
        flag.checkCometCollisions = TRUE
        done2 = TRUE
    END IF
    IF flag.fadeInComs AND NOT flag.gameOver THEN SndFade S(15), .001, .32, .001 '  sound, changeAmount, goal, presentVolume
    IF flag.fadeOutComs THEN SndFade S(15), -.003, 0, .31
    IF NOT done3 AND flag.doGrid AND NOT _SNDPLAYING(S(15)) THEN
        _SNDLOOP S(17): done3 = TRUE ' then
        flag.fadeInGRID = TRUE '
    END IF
    IF flag.fadeInGRID THEN SndFade S(17), .001, .035, 0 '
    IF flag.fadeOutGrid THEN SndFade S(17), -.003, 0, .035
END SUB
' -----------------------------------------

SUB SndFade2 (snd AS LONG, amount AS SINGLE, goal AS SINGLE, presVol AS SINGLE, a AS _BYTE)

    SHARED AS _BYTE over(), fadeIt
    STATIC AS _BYTE loaded
    STATIC AS SINGLE volume

    IF NOT loaded THEN volume = presVol: loaded = TRUE
    volume = volume + amount
    _SNDVOL snd, volume

    IF SGN(amount) = 1 AND volume >= goal THEN
        over(a) = TRUE
        IF NOT flag.gameOver THEN loaded = FALSE
        IF flag.gameOver THEN flag.stopp = TRUE
    END IF

    IF SGN(amount) = -1 AND volume <= 0.001 THEN
        over(a) = TRUE
        loaded = FALSE
        fadeIt = FALSE
        _SNDSTOP snd
    END IF
END SUB
' -----------------------------------------

SUB SndFade (snd AS LONG, amount AS SINGLE, goal AS SINGLE, presVol AS SINGLE)

    STATIC AS SINGLE volume
    STATIC AS _BYTE loaded
    SHARED AS _BYTE played, doneHere

    IF NOT loaded THEN volume = presVol: loaded = TRUE
    volume = volume + amount
    _SNDVOL snd, volume
    IF flag.fadeInComs AND volume >= goal THEN
        flag.fadeInComs = FALSE
        loaded = FALSE
    END IF
    IF flag.fadeInGRID AND volume >= goal THEN
        flag.fadeInGRID = FALSE
        loaded = FALSE
    END IF

    IF flag.intro AND volume >= goal THEN
        loaded = FALSE
        flag.intro = FALSE
    END IF

    IF volume <= 0 THEN
        _SNDSTOP snd
        flag.fadeOutComs = FALSE
        loaded = FALSE
        flag.fadeOutGrid = FALSE
        flag.fadeOutCharge = FALSE
        played = FALSE '                    a global, vague flag - naughty
    END IF
END SUB
' -----------------------------------------

SUB drawRocks () '              spin and draw

    DIM AS INTEGER c, spin
    STATIC AS SINGLE d
    SHARED AS LONG miniMask
    SHARED AS _BYTE over()

    c = 0
    DO
        c = c + 1
        IF flag.harpooned THEN IF c = target THEN _CONTINUE '       drawing the target rock is done in shipControl sub

        IF flag.fadeInRocks THEN '                                  fade in from dissolve sub
            IF d < 171 THEN d = d + .15
            IF c <> target THEN
                rock(c).col = _RGB32(d)
            ELSE rock(c).col = _RGB32(205, 122, 255, d + 50)
            END IF
            IF d > 90 THEN flag.doRockMask = TRUE
            IF d > 169 THEN flag.fadeInRocks = FALSE: d = 0 '       turn off, reset
        END IF

        IF rock(c).rotation THEN
            IF rock(c).rotDir = "cClock" THEN rock(c).spinAngle = rock(c).spinAngle + rock(c).spinSpeed
        ELSE rock(c).spinAngle = rock(c).spinAngle - rock(c).spinSpeed
        END IF

        IF rock(c).spinAngle > 359 OR rock(c).spinAngle < -359 THEN rock(c).spinAngle = 0
        IF flag.doRockMask THEN _PUTIMAGE (rock(c).x - rock(c).radius + 1, rock(c).y - rock(c).radius + 1), miniMask '      blocks the starscape from inside the rocks
        PRESET (rock(c).x, rock(c).y), rock(c).col '
        spin = rock(c).spinAngle
        IF rock(c).alive THEN DRAW "TA=" + VARPTR$(spin) + rock(c).kind '   only draw living rocks
        PSET (rock(c).x, rock(c).y), C(0) '                                 erase the center dot in rocks
    LOOP UNTIL c = MAXROCKS
END SUB
' -----------------------------------------

SUB rockNav () '            advance rocks and off-screen / on-screen controls

    DIM AS INTEGER c

    flag.doRocks = FALSE '                                      assume rocks are done
    c = 0
    DO
        c = c + 1
        IF flag.harpooned THEN IF c = target THEN _CONTINUE
        rock(c).x = rock(c).x + rock(c).Vx * rock(c).speed '    advance rocks
        rock(c).y = rock(c).y - rock(c).Vy * rock(c).speed '
        IF NOT flag.harpooned THEN
            IF rock(c).x < -rock(c).radius * .7 THEN rock(c).x = _WIDTH + rock(c).radius * .7 - 1 '     on-screen / off-screen behavior
            IF rock(c).x > _WIDTH + rock(c).radius * .7 THEN rock(c).x = -rock(c).radius * .7 + 1 '
            IF rock(c).y < -rock(c).radius * .7 THEN rock(c).y = _HEIGHT + rock(c).radius * .7 - 1 '
            IF rock(c).y > _HEIGHT + rock(c).radius * .7 THEN rock(c).y = -rock(c).radius * .7 + 1
        ELSE
            IF rock(c).x < -rock(c).radius * .7 THEN rock(c).alive = FALSE '                            on-screen / off-screen behavior AFTER HARPOONING
            IF rock(c).x > _WIDTH + rock(c).radius * .7 THEN rock(c).alive = FALSE '
            IF rock(c).y < -rock(c).radius * .7 THEN rock(c).alive = FALSE '
            IF rock(c).y > _HEIGHT + rock(c).radius * .7 THEN rock(c).alive = FALSE
        END IF
        IF rock(c).alive THEN flag.doRocks = TRUE '             keep rocks going

        IF flag.harpooned THEN rock(c).speed = 2.2 '            speed up rocks after harpooning rock
    LOOP UNTIL c = MAXROCKS

    IF NOT flag.doRocks THEN '                                  toggle post rock-bounce flags
        flag.checkFSC = FALSE
    END IF
END SUB
' -----------------------------------------
SUB back2Space ()
    STATIC AS INTEGER d
    SHARED AS LONG timer2
    d = d + 2
    rock(target).x = -40 '                      hide the target rock when the moon lowers
    _PUTIMAGE (0, 533 + d), moonScape '         move moonscape down
    IF d > 141 THEN '                           moonscape out of scene
        flag.landingTime = FALSE
        rock(target).stayPainted = FALSE '      MAY BE REDUNDANT
        flag.go2Space = FALSE
        flag.harpooned = FALSE
        rock(target).stayPainted = FALSE
        TIMER(timer2) ON
        _SNDPLAY VO(19)
        _SNDSTOP S(30)
        d = 0
    END IF
END SUB
' -----------------------------------------
FUNCTION findHypot (circ1 AS rock, circ2 AS rock)
    DIM SideA% ' side A length of right triangle
    DIM SideB% ' side B length of right triangle
    SideA% = circ1.x - circ2.x '                                    calculate length of side A
    SideB% = circ1.y - circ2.y '                                    calculate length of side B
    findHypot = INT(SQR(SideA% * SideA% + SideB% * SideB%)) '       calculate hypotenuse
END FUNCTION
' -----------------------------------------
FUNCTION Vec2Deg (Vx AS SINGLE, Vy AS SINGLE) '
    '-  Turns rock vector pairs into negative degrees to work with program
    DIM radian AS DOUBLE
    DIM AS SINGLE Xdegrees
    radian = _ATAN2(Vx, Vy) '               this var must be a DOUBLE
    Xdegrees = CINT(_R2D(radian)) '         this can be a _BYTE
    IF Xdegrees < 0 THEN Xdegrees = 360 + Xdegrees '
    Vec2Deg = -Xdegrees '
END FUNCTION
' -----------------------------------------
SUB Deg2Vec (angle AS INTEGER, target AS _BYTE) '
    ' - Turns degree angle to vector pairs for the rocks
    DIM radian AS DOUBLE
    radian = _D2R(angle)
    rock(target).Vx = COS(radian)
    rock(target).Vy = SIN(radian)
END SUB
' -----------------------------------------
SUB Deg2Vec2 (angle AS INTEGER) '
    ' - Turns degree angle to vector pairs for the ship
    DIM radian AS DOUBLE
    radian = _D2R(angle)
    ship.Vx = COS(radian)
    ship.Vy = SIN(radian)
END SUB
' -----------------------------------------
FUNCTION getCourse (a AS INTEGER)
    '- Determines ship's course in degrees based on ship.course negative numbers
    DIM AS SINGLE reduced, result, result2
    DIM AS INTEGER three60s
    reduced = a / 360 '                                 = for example 3.765 circles
    three60s = CINT(a / 360) '                          get just the whole number of rots and make negative
    result = reduced - three60s '                       leave only the decimal portion (adding the 360s to a neg # kills the whole num)
    result2 = CINT(result * 360) '                      the decimal portion x 360 = degrees
    IF result2 > 0 THEN result2 = result2 - 360 '       adjust for negativity
    getCourse = result2
END FUNCTION
' -----------------------------------------
SUB flipOnShip '                    turn on ship after explosion
    SHARED AS LONG timer1 '
    '
    flag.doShip = TRUE
    flag.shipBoomDone = FALSE
    IF flag.doRocks THEN flag.checkFSC = TRUE '
    flag.doAutoShields = TRUE
    ship.shields = 100
    ship.power = 100
    TIMER(timer1) OFF
    IF flag.doComets THEN flag.checkCometCollisions = TRUE
    IF flag.doGrid THEN flag.checkGridCollisions = TRUE
END SUB
' -----------------------------------------
SUB flipOnSaucers ()
    SHARED AS LONG timer2
    TIMER(timer2) OFF
    flag.doSaucers = TRUE
END SUB
' -----------------------------------------
SUB redrawShip ()
    DIM spin AS INTEGER
    spin = ship.course
    PRESET (ship.x, ship.y), ship.col
    DRAW "TA=" + VARPTR$(spin) + ship.kind '
    PAINT (ship.x, ship.y - 1), C(3), ship.col
    PSET (ship.x, ship.y), C(0) '                   erase the center dot in ship
END SUB
' -----------------------------------------
SUB rockScramble '                  manually spread the rocks apart by hitting <ENTER>
    DIM AS _BYTE c, sign
    c = 0
    DO
        c = c + 1
        IF c MOD 2 = 0 THEN sign = -1 ELSE sign = 1
        rock(c).x = rock(c).x + INT(RND * 9 + 3) * sign '
        rock(c).y = rock(c).y + INT(RND * 8 + 3) * sign '
    LOOP UNTIL c = MAXROCKS
END SUB
' -----------------------------------------
SUB killNoises () '                 after ship explodes, etc, stop all thruster noises
    SHARED played AS _BYTE
    IF _SNDPLAYING(S(8)) OR _SNDPLAYING(S(9)) OR _SNDPLAYING(S(10)) OR _SNDPLAYING(S(11)) THEN
        _SNDSTOP S(8): _SNDSTOP S(9): _SNDSTOP S(10): _SNDSTOP S(11)
        played = FALSE
    END IF
END SUB
' -----------------------------------------
SUB autoShields () '               activated by flag.trackShields after a collision with autoShields turned ON
    STATIC AS _BYTE shieldCount
    shieldCount = shieldCount + 1
    IF flag.doCircle THEN CIRCLE (ship.x, ship.y - 1), 18, C(14)
    IF shieldCount > 110 THEN
        flag.trackShields = FALSE
        shieldCount = 0
        flag.doCircle = FALSE '
    END IF
END SUB
' -----------------------------------------
SUB blowUp '                        tracks the sparks generation
    SHARED sparkCycles AS _BYTE
    SHARED AS INTEGER boomNum
    sparkCycles = sparkCycles + 1
    IF sparkCycles < boomNum THEN MakeSparks ship.x, ship.y '       15 for ship/rocks collision
    UpdateSparks
END SUB
' -----------------------------------------
SUB showHorzGauge (x AS INTEGER, y AS INTEGER, amtDone AS SINGLE, gaugeLabel AS STRING, col AS _UNSIGNED LONG) '

    STATIC AS _BYTE shieldDot, powerDot, toggle, toggle2, initd, initd2
    STATIC AS INTEGER count, count2

    LINE (x, y)-(x + 100, y + 4), _RGB32(200, 200, 0), B ' yellow box
    LINE (x + 50, y)-(x + 50, y - 5), C(14) ' mid box line
    LINE (x + 1, y + 1)-(x + 1 + (amtDone * 98), y + 3), col, BF '  filler color varies
    _FONT modern
    COLOR C(16)
    _PRINTSTRING (x + 50 - _PRINTWIDTH(gaugeLabel) \ 2, y + 11), gaugeLabel

    IF NOT initd AND ship.shields < 30 THEN
        shieldDot = TRUE
        toggle = 1
        initd = TRUE
    END IF

    IF NOT initd2 AND ship.power < 30 THEN
        powerDot = TRUE
        toggle2 = 1
        initd2 = TRUE
    END IF

    IF shieldDot THEN
        count = count + 1
        IF count MOD 100 = 0 THEN toggle = -toggle
        IF toggle = 1 THEN
            CIRCLE (135, 97), 5, C(12)
            PAINT (135, 97), C(12), C(12)
        END IF
        IF ship.shields > 29 THEN
            shieldDot = FALSE
            initd = FALSE
            count = 0
        END IF
    END IF

    IF powerDot THEN
        count2 = count2 + 1
        IF count2 MOD 100 = 0 THEN toggle2 = -toggle2
        IF toggle2 = 1 THEN
            CIRCLE (135, 65), 5, C(12) ' update
            PAINT (135, 65), C(12), C(12)
        END IF
        IF ship.power > 29 THEN
            powerDot = FALSE
            initd2 = FALSE
            count2 = 0
        END IF
    END IF
    _FONT 16
END SUB
' -----------------------------------------

SUB showVertGauge (locX AS INTEGER, locY AS INTEGER)

    STATIC AS _BYTE initDone
    STATIC AS SINGLE startY, alphaDelta, yDelta
    STATIC AS INTEGER botY, alpha '
    DIM AS SINGLE startPower
    DIM AS INTEGER maxPower, duration, numSteps, alphaChange

    IF NOT initDone THEN
        botY = locY + 100 '                     physical screen location -  gauge height = 100
        startPower = ship.power '               exisiting power level**
        maxPower = 100 '                        ship's max allowable power
        alpha = 10 '                            beginning alpha level
        startY = botY - startPower '            start Y for moving line - top of red fill
        duration = maxPower - startPower '      total power change
        numSteps = duration / ship.chargeDelta 'total cycles to full power
        alphaChange = 255 - alpha '             total alpha change
        alphaDelta = alphaChange / numSteps '   amount to change alpha level each cycle
        yDelta = duration / numSteps '          amount to change fill height
        initDone = TRUE
    END IF

    CIRCLE (locX, locY), 6, _RGB32(205, 227, 122, alpha), _D2R(360), _D2R(180) '        top         YELLOW SHELL
    CIRCLE (locX, botY), 6, _RGB32(205, 227, 122, alpha), _D2R(180), _D2R(0) '          bottom
    LINE (locX - 6, locY)-(locX - 6, botY), _RGB32(205, 227, 122, alpha) '              sides
    LINE (locX + 6, locY)-(locX + 6, botY), _RGB32(205, 227, 122, alpha)
    CIRCLE (locX, locY), 5, _RGB32(2), _D2R(360), _D2R(180) '                           top         INVIZZO SHELL
    CIRCLE (locX, botY), 5, _RGB32(2), _D2R(180), _D2R(0) '                             bottom
    LINE (locX - 5, locY)-(locX - 5, botY), _RGB32(2) '                                 sides
    LINE (locX + 5, locY)-(locX + 5, botY), _RGB32(2)
    startY = startY - yDelta '                                                          rising factor
    IF alpha < 254 THEN alpha = alpha + alphaDelta '                                    increase/decrease alpha
    LINE (locX - 5, startY)-(locX + 5, startY), _RGB32(2) '                             moving line
    PAINT (locX, botY - 3), _RGB32(255, 0, 0, alpha), _RGB32(2) '                       fill red

    IF startY < locY - 20 THEN '                                                        if done, then get this to run backwards to fade out
        alpha = 252
        alphaDelta = -alphaDelta * 2.7 '                                                fade out faster than fade in
        startY = startY + 200 '                                                         make startY well below "locY - 20" IF statement above
    END IF

    IF alpha < 10 THEN
        initDone = FALSE '                                                              finish, reset for next charge
        flag.doVertGauge = FALSE
        ship.charged = TRUE '
    END IF
END SUB
' -----------------------------------------
SUB drawStars () '                              starscape backdrop
    DIM c AS INTEGER
    DIM AS LONG virtual
    SHARED AS LONG starScape, saucerScape
    virtual = _NEWIMAGE(1280, 720, 32) '        SMALLER starscape
    _DEST virtual
    c = 0
    DO
        c = c + 1
        PSET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), C(15) '                     whites
    LOOP UNTIL c = 3000 ' was 3600
    c = 0
    DO
        c = c + 1
        PSET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), C(1) '                      grays
    LOOP UNTIL c = 2000 ' was 3600
    c = 0
    DO
        c = c + 1
        PSET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), _RGB32(255, 67, 55, 124) '  reddies
        DRAW "S2U1R1D1L1"
    LOOP UNTIL c = 16
    c = 0
    DO
        c = c + 1
        PSET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), _RGB32(0, 255, 0, 116) '    greenies
        DRAW "S2U1R1D1L1"
    LOOP UNTIL c = 46
    c = 0
    DO
        c = c + 1
        PRESET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), _RGB32(255, 255, 183, 120) '  big yellows
        DRAW "S4U1R1D1L1"
    LOOP UNTIL c = 330
    starScape = _COPYIMAGE(virtual, 32) ' software image
    ' ------------------------
    virtual = _NEWIMAGE(1600, 900, 32) '        BIGGER saucerScape
    _DEST virtual
    DO
        c = c + 1
        PSET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), C(15) '                     whites
    LOOP UNTIL c = 5400
    c = 0
    DO
        c = c + 1
        PSET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), C(1) '                      grays
    LOOP UNTIL c = 2500 ' was 3600
    c = 0
    DO
        c = c + 1
        PSET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), _RGB32(255, 67, 55, 124) '  reds
        DRAW "S2U1R1D1L1"
    LOOP UNTIL c = 30
    c = 0
    DO
        c = c + 1
        PSET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), _RGB32(0, 255, 0, 116) '    greens
        DRAW "S2U1R1D1L1"
    LOOP UNTIL c = 100
    c = 0
    DO
        c = c + 1
        PRESET ((INT(RND * _WIDTH)), INT(RND * _HEIGHT)), _RGB32(255, 255, 183, 120) ' yellows
        DRAW "S4U1R1D1L1"
    LOOP UNTIL c = 500
    saucerScape = _COPYIMAGE(virtual, 32) ' software image
    _FONT 16 '
    _DEST 0
    _FREEIMAGE virtual
END SUB
' -----------------------------------------
SUB quickSound (c AS INTEGER) '     how to play a sound properly inside a loop - isolate it as needed
    SHARED AS _BYTE played
    IF NOT played THEN
        _SNDLOOP S(c)
        played = TRUE
    END IF
END SUB
' -----------------------------------------
SUB repel3 (b AS _BYTE, c AS _BYTE, w AS _BYTE) '   pushes the rocks apart - in theory
    DIM AS _BYTE count, g, rockAngle
    count = 0
    DO
        count = count + 1
        IF count = 1 THEN g = b '
        IF count = 2 THEN g = c
        IF count = 3 THEN g = w
        rockAngle = Vec2Deg(rock(g).Vx, rock(g).Vy) '           get corrected course of rock
        rockAngle = rockAngle + 180 '                           give it opposite angle vector
        IF rockAngle > 359 THEN rockAngle = rockAngle - 360 '   correct the angle as needed
        Deg2Vec rockAngle, g '                                  set the rock's vector pair to new heading
        rock(g).x = rock(g).x + rock(g).Vx * 3 '                bump the rock on its way
        rock(g).y = rock(g).y + rock(g).Vy * 3
    LOOP UNTIL count = 3
END SUB
' -----------------------------------------
SUB loadImages ()
    DIM c AS INTEGER
    DIM col AS _UNSIGNED LONG

    I(0) = _LOADIMAGE("rock1.jpg")
    I(1) = _LOADIMAGE("gun1.jpg")
    I(2) = _LOADIMAGE("alien.jpg")
    I(3) = _LOADIMAGE("moontruck.jpg")
    I(4) = _LOADIMAGE("mouseDemo.jpg") ' ------ intro images
    I(5) = _LOADIMAGE("keyDemo.jpg")
    I(6) = _LOADIMAGE("rocksDemo.jpg")
    I(7) = _LOADIMAGE("scanDemo.jpg")
    I(8) = _LOADIMAGE("chargeDemo.jpg")
    I(9) = _LOADIMAGE("landingDemo.jpg") ' -----------------
    I(10) = _LOADIMAGE("coolRocket.jpg")
    I(11) = _LOADIMAGE("galaxy1.jpg")
    I(12) = _LOADIMAGE("galaxy2.jpg")
    I(13) = _LOADIMAGE("aster2.jpeg")
    I(14) = _LOADIMAGE("aster4.jpeg")
    I(15) = _LOADIMAGE("aster1.jpeg")
    I(16) = _LOADIMAGE("aster3.jpeg")
    I(17) = _LOADIMAGE("quasar1.jpg")
    I(18) = _LOADIMAGE("saucer.jpeg")

    FOR c = 0 TO UBOUND(I) '                                check for bad image handles
        IF I(c) >= -1 THEN '
            BEEP
            CLS: PRINT "Image File Error - on File #"; c '  terminate on error
            _DELAY 2.3
            SYSTEM
        END IF
    NEXT

    FOR c = 0 TO UBOUND(I) '                                make all image backgrounds transparent
        _SOURCE I(c)
        col = POINT(0, 0)
        _CLEARCOLOR col, I(c)
    NEXT c
END SUB
' --------------------------------
SUB loadSounds ()

    DIM c AS INTEGER

    S(0) = _SNDOPEN("chirp.ogg")
    S(1) = _SNDOPEN("epicthump.mp3"): _SNDVOL S(1), .7
    S(2) = _SNDOPEN("click.ogg")
    S(3) = _SNDOPEN("beeboop.ogg"): _SNDVOL S(3), .65
    S(4) = _SNDOPEN("boom1.ogg"): _SNDVOL S(4), .64
    S(5) = _SNDOPEN("boom2.ogg"): _SNDVOL S(5), .3
    S(6) = _SNDOPEN("boom3.ogg"): _SNDVOL S(6), .3
    S(7) = _SNDOPEN("deflect.ogg"): _SNDVOL S(7), .4
    S(8) = _SNDOPEN("rocket.wav"): _SNDVOL S(8), .1 '               MAIN THRUSTERS FOR LANDINGTIME
    S(9) = _SNDOPEN("quickburst.wav"): _SNDVOL S(9), .3 '
    S(10) = _SNDOPEN("shortair.wav"): _SNDVOL S(10), .4 '           SIDE THRUSTERS
    S(11) = _SNDOPEN("air.wav"): _SNDVOL S(11), .15 '               OPEN SPACE THRUSTER SOUND
    S(12) = _SNDOPEN("insectyShort.wav"): _SNDVOL S(12), .15
    S(13) = _SNDOPEN("BBBB.mp3"): _SNDVOL S(13), .5
    S(14) = _SNDOPEN("spaceHarpoon.wav"): _SNDVOL S(14), .25
    S(15) = _SNDOPEN("comets.wav"): _SNDVOL S(15), .24
    S(16) = _SNDOPEN("warning.wav"): _SNDVOL S(16), .075
    S(17) = _SNDOPEN("mysterio.wav"): _SNDVOL S(17), 0
    S(18) = _SNDOPEN("bonus.mp3"): _SNDVOL S(18), .2
    S(19) = _SNDOPEN("hydraulic.mp3"): _SNDVOL S(19), .25
    S(20) = _SNDOPEN("zap.wav"): _SNDVOL S(20), .25
    S(21) = _SNDOPEN("charging.wav"): _SNDVOL S(21), .44
    S(22) = _SNDOPEN("fuzzyNoise.wav"): _SNDVOL S(22), .25
    S(23) = _SNDOPEN("heaven.mp3"): _SNDVOL S(23), .2
    S(24) = _SNDOPEN("whip1.mp3"): _SNDVOL S(24), .2
    S(25) = _SNDOPEN("zoom.mp3"): _SNDVOL S(25), .12
    S(26) = _SNDOPEN("incoming.mp3"): _SNDVOL S(26), .4
    S(27) = _SNDOPEN("laser.wav"): _SNDVOL S(27), .3 '  ------------- loops
    S(28) = _SNDOPEN("harvestloop.mp3"): _SNDVOL S(28), .001
    S(29) = _SNDOPEN("cometloop.mp3"): _SNDVOL S(29), .001
    S(30) = _SNDOPEN("happy.mp3"): _SNDVOL S(30), 0
    S(31) = _SNDOPEN("saucerloop.mp3"): _SNDVOL S(31), .001
    S(32) = _SNDOPEN("ffloop.mp3"): _SNDVOL S(32), .0001 ' ----------
    S(33) = _SNDOPEN("flash.wav"): _SNDVOL S(33), .25
    S(34) = _SNDOPEN("ominous.mp3"): _SNDVOL S(34), .36
    S(35) = _SNDOPEN("funkyAlarm2.mp3"): _SNDVOL S(35), .38
    S(36) = _SNDOPEN("blast.mp3")
    S(37) = _SNDOPEN("impact.mp3")
    S(38) = _SNDOPEN("splashLoop.mp3"): _SNDVOL S(38), .25
    S(39) = _SNDOPEN("controlRoom.mp3"): _SNDVOL S(39), .21
    FOR c = 0 TO UBOUND(S) '                                    check for bad sound handles
        IF S(c) <= 0 THEN '
            BEEP
            CLS: PRINT "Sound Load Error - on File #"; c '      terminate on error
            _DELAY 2.3
            SYSTEM
        END IF
    NEXT
END SUB
' -----------------------------------------
SUB loadVOs ()
    DIM c AS INTEGER
    VO(1) = _SNDOPEN("scanning.mp3"): _SNDVOL VO(1), .15
    VO(2) = _SNDOPEN("doneScanning.mp3"): _SNDVOL VO(2), .15
    VO(3) = _SNDOPEN("shieldsOn.mp3"): _SNDVOL VO(3), .13 '     ditto
    VO(4) = _SNDOPEN("shieldsOff.mp3"): _SNDVOL VO(4), .15 '    use at some point - for loss of shields...
    VO(5) = _SNDOPEN("howToCapture.mp3"): _SNDVOL VO(5), .15
    VO(6) = _SNDOPEN("proceed.mp3"): _SNDVOL VO(6), .15
    VO(7) = _SNDOPEN("worth.mp3"): _SNDVOL VO(7), .15
    VO(8) = _SNDOPEN("meteorites.mp3"): _SNDVOL VO(8), .18
    VO(9) = _SNDOPEN("gravity ahead.mp3"): _SNDVOL VO(9), .18
    VO(10) = _SNDOPEN("landingMode.mp3"): _SNDVOL VO(10), .18
    VO(11) = _SNDOPEN("rocks.mp3"): _SNDVOL VO(11), .22
    VO(12) = _SNDOPEN("detach.mp3"): _SNDVOL VO(12), .19
    VO(13) = _SNDOPEN("recharge.mp3"): _SNDVOL VO(13), .18
    VO(14) = _SNDOPEN("chargeDone.mp3"): _SNDVOL VO(14), .15
    VO(15) = _SNDOPEN("chargeAdvice.mp3"): _SNDVOL VO(15), .2
    VO(16) = _SNDOPEN("trapped.mp3"): _SNDVOL VO(16), .22
    VO(17) = _SNDOPEN("scanningUn.mp3"): _SNDVOL VO(17), .15
    VO(18) = _SNDOPEN("analysis.mp3"): _SNDVOL VO(18), .19
    VO(19) = _SNDOPEN("battlemode.mp3"): _SNDVOL VO(19), .18
    VO(20) = _SNDOPEN("unusual.mp3"): _SNDVOL VO(20), .3
    VO(21) = _SNDOPEN("leaving.mp3"): _SNDVOL VO(21), .16
    VO(22) = _SNDOPEN("remoteview.mp3"): _SNDVOL VO(22), .16
    VO(23) = _SNDOPEN("leaveOrbit.mp3"): _SNDVOL VO(23), .15
    VO(24) = _SNDOPEN("shieldsLow.mp3"): _SNDVOL VO(24), .19
    VO(25) = _SNDOPEN("lowPower.mp3"): _SNDVOL VO(25), .19 '

    FOR c = 1 TO UBOUND(VO) '                                    check for bad sound handles
        IF VO(c) <= 0 THEN
            BEEP
            CLS: PRINT "Voice File Error - on File #"; c '      terminate on error
            _DELAY 2.3
            SYSTEM
        END IF
    NEXT
END SUB
' -----------------------------------------
SUB loadFonts
    modern = _LOADFONT("futura.ttc", 10) '          ** GLOBAL FONTS **
    modernBig = _LOADFONT("futura.ttc", 12)
    modernBigger = _LOADFONT("futura.ttc", 15)
    menlo = _LOADFONT("menlo.ttc", 15) ' was 16
    menloBig = _LOADFONT("menlo.ttc", 22)

    IF modern <= 0 OR modernBig <= 0 OR modernBigger <= 0 OR menlo <= 0 OR menloBig <= 0 THEN
        BEEP
        CLS: PRINT "Font Loading Error!" '          terminate on error
        _DELAY 2.3
        SYSTEM
    END IF
END SUB
'------------------------------------------
SUB loadShips ()
    SHARED shipType() AS STRING
    SHARED C() AS _UNSIGNED LONG
    SHARED AS INTEGER DTW
    SHARED shipImg AS LONG
    DIM temp AS _UNSIGNED LONG

    shipType(1) = "BU6 G11 BE11 F11 L8 H3 G3 L7 BE11 BU3 BL1 C" + STR$(C(12)) + "U7" '                   RETRO THRUSTERS
    shipType(2) = "BU6 G11 BE11 F11 L8 H3 G3 L7 BR10 BD2 C" + STR$(C(12)) + "D7" '                       forward thrust ship
    shipType(3) = "BU6 G5 F2 L3 G5 BE11 F4 G1 R2 F4 G3 L3 H3 G3 L3 H1 E1 D2 L5 BR11 BD2 D5" '            thrust damaged ship
    shipType(4) = "BU6 G11 BE11 F11 L8 H3 G3 L7" '                                                       ship1
    shipType(5) = "BU6 BL7 G11 BR8 BE11 BR7 F11 BD11 BL8 L8 H3 G3 L7" '                                  ship4
    shipType(6) = "BU6 BL4 G11 BR5 BE11 BR4 F11 BD7 BL5 L8 H3 G3 L7" '                                   ship3
    shipType(7) = "BU6 BL2 G11 BR2 BE11 BR2 F11 BD3 BL2 L8 H3 G3 L7" '                                   ship2
    shipType(8) = "BU6 G5 F2 L3 G5 BE11 F4 G1 R2 F4 G3 L3 H3 G3 L3 H1 E1 D2 L5 BR11" '                   damaged ship
    shipType(9) = "BU6 G11 BE11 F11 L8 H3 G3 L7 BU11 BR6 C" + STR$(C(9)) + "L5" '                        side jet left
    shipType(10) = "BU6 G11 BE11 F11 L8 H3 G3 L7 BU11 BR14 C" + STR$(C(9)) + "R5" '                       "    "  right
    shipType(11) = "BU6 G11 BE11 F11 L8 H3 G3 L7 BU3 BL2 C" + STR$(C(11)) + "L7" '                           side thruster left
    shipType(12) = "BU6 G11 BE11 F11 L8 H3 G3 L7 BU3 BR22 C" + STR$(C(11)) + "R7" '                       "      "     right

    shipImg = _NEWIMAGE(40, 40, 32) '                                                           create one image of normal ship
    _DEST shipImg
    PRESET (_WIDTH / 2, _HEIGHT / 2), C(14) '
    DRAW shipType(4)
    PAINT (_WIDTH / 2 + 1, _HEIGHT / 2 - 2), C(3), C(14) '
    PSET (_WIDTH / 2, _HEIGHT / 2), C(3)
    _SOURCE shipImg
    temp = POINT(3, 3)
    _CLEARCOLOR temp, shipImg
    _DEST 0

    ship.kind = shipType(4) '                               initial ship assignments
    ship.x = CENTX
    ship.y = CENTY + 50
    ship.course = 359
    ship.col = C(14)
    ship.radius = 8
    flag.doShip = TRUE
    flag.checkFSC = TRUE
END SUB
' -----------------------------------------
SUB loadRocks ()
    SHARED rockType() AS STRING
    rockType(1) = "BU10 L5 G2 L1 D4 F1 D2 G2 D3 F4 R4 E1 F2 R2 E3 U5 R1 U7 H3 L5" '  teeny
    rockType(2) = "BU18 L4 D2 L2 H3 G2 L1 G2 H1 G2 L2 D3 R1 D4 R1 F1 D2 G2 H1 D2 F3 R2 G2 L2 G3 F3 D3 F4 R3 F2 R3 E2 U1 E1 R2 F5 R4 E5 L1 U4 E3 R1 U3 H2 U1 R5 U5 H2 U3 L1 H1 U1 E1 U1 L3 U4 l1 h2 L1 H2 G3 L2 H1 U1" ' Will
    rockType(3) = "BU18 BL13 G6 D14 F4 D2 G4 D3 F6 R3 U2 R2 D1 R2 F3 R2 E3 R4 U1 R5 E7 R1 U12 L2 U3 R1 U3 H2 E2 U3 H5 L12 D2 L3 U1 L2 U1 L9"
    rockType(4) = "BU19 BL14 G6 D14 F4 D2 G4 D3 F6 R5 E2 R4 F2 R6 E6 D2 F5 E2 U7 R2 U6 H3 U4 E5 U6 H7 L12 D2 L8 U2 L8"
    rockType(5) = "BU17 BL20 D11 F6 G5 G4 F3 D9 R32 E8 U31 H7 L26 G7" '
    rockType(6) = "BU12 BL17 E4 R6 E6 R7 F15 R4 D6 G22 D4 L3 H6 L7 H7 U20 E4"
    rockType(7) = "BU22 R6 F17 R4 D6 D3 G17 L7 G6 L3 H9 U12 H13 U6 E6 R7 U2 R14 U1"
    rockType(8) = "BL9 BU14 E7 R7 U5 F12 L5 F13 D12 G7 L17 G11 H14 U12 E15 U2" '                   big rock
    rockType(9) = "BU14 R11 F10 R6 D11 L3 D5 G4 H7 G7 L7 G9 L4 H13 U9 E10 U4 E4 R14" '               big rock 2
    rockType(10) = "BU4 BL22 BU7 E4 R8 E9 R7 F9 D9 F6 D6 G9 L4 D5 G4 L11 H5 U3 L8 U10 L2 U17" '
    rockType(11) = "BU17 BL20 D8 F8 G5 D2 G6 F6 R12 U6 F6 R10 E8 U5 H7 R5 E2 U7 H8 L20 G4 H4 G3"
    rockType(12) = "BU17 BL20 BD4 D8 F4 G6 F3 D9 F3 E4 F4 E6 F6 E3 F3 R3 E7 U4 E3 H4 U12 H7 G10 H9 L9 G3"
    rockType(13) = "BU17 BL20 BD7 D7 F6 G5 F6 L7 F6 R5 E3 R4 U2 F3 R3 F3 R4 E10 H5 E3 U9 E4 H8 L12 D2 L12 G6 L4"
END SUB
' -----------------------------------------
SUB loadColors () '   @
    SHARED C() AS _UNSIGNED LONG
    C(0) = _RGB32(0) '                  black
    C(1) = _RGB32(90) '                 grey
    C(2) = _RGB32(147) '                light grey
    C(3) = _RGB32(0, 127, 0) '          dark green
    C(4) = _RGB32(0, 255, 0) '          green
    C(5) = _RGB32(0, 0, 150) '          blue
    C(6) = _RGB32(128, 183, 233) '      medium blue
    C(7) = _RGB32(105, 172, 222) '      pale blue
    C(8) = _RGB32(0, 133, 255) '        sky blue
    C(9) = _RGB32(255, 161, 72) '       orange
    C(10) = _RGB32(205, 122, 255) '     purple
    C(11) = _RGB32(255, 24, 50) '       red
    C(12) = _RGB32(255, 0, 0) '         bright red
    C(13) = _RGB32(255, 177, 255) '     pink
    C(14) = _RGB32(255, 255, 0) '       yellow
    C(15) = _RGB32(170) '               white
    C(16) = _RGB32(255) '               bright white
END SUB
' -----------------------------------------
SUB loadMoonScape ()
    DIM AS LONG tempImg
    DIM AS _UNSIGNED LONG pix
    moonScape = _NEWIMAGE(1281, 191, 32)
    tempImg = _LOADIMAGE("moonscape.jpg")
    _SOURCE tempImg
    pix = POINT(0, 0)
    _CLEARCOLOR pix, tempImg
    _PUTIMAGE , tempImg, moonScape, (0, 530)-(1280, 720)
    _FREEIMAGE tempImg
END SUB
' -----------------------------------------

SUB assignRocks ()

    DIM AS INTEGER c, rando
    SHARED rockType() AS STRING
    SHARED AS _BYTE target
    DIM Length AS SINGLE
    RANDOMIZE TIMER

    c = 0
    DO '
        c = c + 1
        rock(c).x = c * 60 'INT(RND * 1000 + 80) '          specific x locs to avoid bunching initially
        IF c MOD 2 = 0 THEN
            rock(c).y = c * 30 ' INT(RND * 600 + 45) '      y loc - ditto
        ELSE rock(c).y = c * 10
        END IF
        rock(c).size = 2 '                                  all rocks big to start
        rock(c).alive = TRUE '                              all rocks are alive!
        rock(c).radius = 22 '                               works well enough - sometimes they overlap, sometimes not quite touch...
        rock(c).col = C(15) '                               all rocks start white
        rock(c).speed = 1 '                                 use same rock speed for all or it looks wrong

        rock(c).rotDir = "clock" '                          first 6 rocks clockwise
        IF c > 6 THEN rock(c).rotDir = "cClock" '           next 6 counter-clockwise
        rock(c).spinAngle = 0 '                             zero spin angle at start

        rando = INT(RND * 2 + 1)
        IF rando = 1 THEN rock(c).rotation = TRUE ELSE rock(c).rotation = FALSE '       50/50 chance for rotation
        IF rando = 2 THEN rock(c).spinSpeed = 1 ELSE rock(c).spinSpeed = 2 '            50/50 chance fast/slow spin
        rock(c).Vx = (INT(RND * 5) + 1) * SGN(RND - RND) '                          rnd vector (-5 to 5)
        rock(c).Vy = (INT(RND * 5) + 1) * SGN(RND - RND) '
        Length = SQR(rock(c).Vx * rock(c).Vx + rock(c).Vy * rock(c).Vy) '           length of vector
        rock(c).Vx = rock(c).Vx / Length '                                          normalize vector
        rock(c).Vy = rock(c).Vy / Length
        IF c < 13 THEN rock(c).kind = rockType(c + 1) ELSE rock(c).kind = rockType(INT(RND * 11 + 2)) '  rnd rock assignment - 10 different rocks
    LOOP UNTIL c = MAXROCKS

    target = INT(RND * MAXROCKS + 1)
    rock(target).col = C(10)
    flag.doRocks = TRUE
    flag.harpooned = FALSE
    flag.landingTime = FALSE
END SUB
' -----------------------------------------
SUB initCOMETS ()

    DIM AS INTEGER c
    SHARED AS comet comet()
    SHARED rockType() AS STRING
    STATIC AS _BYTE numInits '                      sub odometer

    numInits = numInits + 1
    c = 0
    DO '
        c = c + 1 '                                 left to right comets
        IF numInits < 4 THEN '      go other way for two and, hah, switch back
            comet(c).Vx = RND + 3 '                 only positive x vectors - go right!
            comet(c).x = INT(RND * -750 - 30)
        ELSE
            comet(c).Vx = RND - 4 '                 right to left comets
            comet(c).x = INT(RND * 750 + _WIDTH) '
            flag.shutFrontDoor = TRUE
        END IF
        comet(c).Vy = (RND * SGN(RND - RND)) '      pos and neg y vectors
        comet(c).y = INT(RND * 680 + 35)
        comet(c).kind = rockType(1)
        comet(c).rotAng = INT(RND * 359 + 1)
        comet(c).rotSign = -1
        comet(c).radius = 10
        comet(c).rotSpeed = 7 + (RND * 9)
        comet(c).col = _RGB32(41, 30, 0) '      fill color
        IF c MOD 3 = 0 THEN comet(c).col = _RGB32(82, 58, 0)
        comet(c).edge = _RGB32(218, 85, 6) '    outer color
        comet(c).alive = TRUE
    LOOP UNTIL c = UBOUND(comet) ' --------------------
END SUB
' -----------------------------------------

SUB initGRID ()

    DIM AS _BYTE row, column
    DIM AS INTEGER rand, rand2
    SHARED matrix() AS gridRock

    row = 0 '                               initialize matrix
    DO
        row = row + 1
        column = 0
        DO
            column = column + 1
            matrix(column, row).x = column * -80 - 80 ' was 65      X spacing
            IF column MOD 2 = 0 THEN
                matrix(column, row).y = (30 + 65 * row) - 50 '      even Y num columns staggered down 30
            ELSE matrix(column, row).y = (65 * row) - 50 '           odd Y spacing
            END IF

            IF gameRound = 1 THEN
                matrix(column, row).speed = 1
            ELSE matrix(column, row).speed = 1.85 '                 speed up grid for round 2
            END IF

            matrix(column, row).rotAng = INT(RND * 358 + 1) '       initial rotation
            rand = INT(RND * 4 + 1): rand2 = INT(RND * 42 + 1) '

            IF rand2 MOD 6 = 0 THEN matrix(column, row).special = TRUE '  speeders

            IF rand2 MOD 2 = 0 THEN
                matrix(column, row).col = _RGB32(RND * 36 + 18) '   fill color / light grays
            ELSE matrix(column, row).col = _RGB32(0)
            END IF

            IF rand2 = 22 OR rand2 = 16 THEN matrix(column, row).col = _RGB32(215, 165, 89, 110) '  bonus orangy rocks <<
            matrix(column, row).alive = TRUE

            SELECT CASE rand '                                      half the rocks spin
                CASE 1: matrix(column, row).rotSign = 1 '           some clockwise, some counter
                CASE 2: matrix(column, row).rotSign = -1
                CASE 3: matrix(column, row).rotSign = 0: matrix(column, row).yJiggle = -1 '     25% jiggle vertically
                CASE 4: matrix(column, row).rotSign = 0
            END SELECT
            SELECT CASE column
                CASE 1: matrix(column, row).x = column * INT(RND * -120 + 40) - 80 '        spread out first couple / last couple columns
                CASE 2: matrix(column, row).x = column * -80 + INT(RND * -90 + 65) - 80
                CASE 19: matrix(column, row).x = column * -80 + INT(RND * -90) - 80
                CASE 20: matrix(column, row).x = 20 * -80 + INT(RND * -120) - 80
            END SELECT
        LOOP UNTIL column = 20
    LOOP UNTIL row = 11
    matrix(20, 1).special = FALSE '             this rock is used to track the end of the grid and can't be a speeder
END SUB
' -----------------------------------------
SUB MakeSparks (x AS INTEGER, y AS INTEGER) ' spark initiator       Thanks Terry Ritchie for these routines
    '                                                               Note: DO...LOOPs used for speed. Much faster than FOR ... NEXT.
    SHARED Spark() AS SPARK '     dynamic array to hold sparks
    SHARED SparkNum AS INTEGER '  number of sparks to create at a time
    SHARED SparkLife AS INTEGER ' life span of spark in frames
    DIM CleanUp AS INTEGER '      TRUE is no life left in array
    DIM Count AS LONG '           spark counter
    DIM TopSpark AS LONG '        highest index in array
    DIM NewSpark AS LONG '        index in array to start adding new sparks

    CleanUp = TRUE '                                          assume no life left in array
    DO '                                                      begin spark life check
        IF Spark(Count).Lifespan <> 0 THEN '                  is this spark alive?
            CleanUp = FALSE '                                 yes, array still has life
        END IF
        Count = Count + 1 '                                   increment spark counter
    LOOP UNTIL Count > UBOUND(Spark) OR CleanUp = FALSE '     leave when life found or end of array reached
    IF CleanUp THEN REDIM Spark(0) AS SPARK '                 if no life found then reset dynamic array
    TopSpark = UBOUND(Spark) '                                identify array index starting point
    REDIM _PRESERVE Spark(TopSpark + SparkNum + 1) AS SPARK ' increase array while saving living sparks
    Count = 0 '                                               reset spark counter
    RANDOMIZE TIMER '                                         seed RND generator
    DO '                                                      begin add spark loop
        Count = Count + 1 '                                   increment spark counter
        NewSpark = TopSpark + Count '                         next array index to use
        Spark(NewSpark).Lifespan = SparkLife '                set spark life span
        Spark(NewSpark).Location.x = x '                      set spark location
        Spark(NewSpark).Location.y = y
        Spark(NewSpark).Fade = 255 '                          set spark intensity
        Spark(NewSpark).Velocity = INT(RND * 6) + 6 '         set random spark velocity
        Spark(NewSpark).Vector.x = RND - RND '                set random spark vector
        Spark(NewSpark).Vector.y = RND - RND
    LOOP UNTIL Count = SparkNum '                             leave when all sparks added
END SUB
'------------------------------------------------------------------------------------------------------------
SUB UpdateSparks () ' spark maintainer          by Terry Ritchie

    '* Maintains any live sparks containied in the dynamic array
    SHARED Spark() AS SPARK '     dynamic array to hold sparks
    SHARED sparkCycles AS _BYTE
    SHARED AS INTEGER redd, gren, blue
    SHARED AS LONG timer1
    DIM Count AS LONG '           spark counter
    DIM FC0 AS _UNSIGNED LONG '   spark fade colors
    DIM FC1 AS _UNSIGNED LONG
    DIM FC2 AS _UNSIGNED LONG
    DIM Fade0 AS INTEGER '        spark fade color values
    DIM Fade1 AS INTEGER
    DIM Fade2 AS INTEGER
    DIM CleanUp AS INTEGER '      TRUE if no life left in array

    IF UBOUND(Spark) = 0 THEN EXIT SUB '                                          leave if array cleared
    CleanUp = TRUE '                                                              assume no life left in array
    DO '                                                                          begin spark maintenance loop
        Count = Count + 1 '                                                       increment spark counter
        IF Spark(Count).Lifespan THEN '                                           is this spark alive?
            CleanUp = FALSE '                                                     yes, array still has life
            Fade0 = Spark(Count).Fade '                                           set the intensity values
            Fade1 = Spark(Count).Fade \ 2
            Fade2 = Spark(Count).Fade \ 4
            FC0 = _RGB32(redd, gren, blue, Fade0) '                                   create the intensity colors
            FC1 = _RGB32(redd, gren, blue, Fade1)
            FC2 = _RGB32(redd, gren, blue, Fade2)
            PSET (Spark(Count).Location.x, Spark(Count).Location.y), FC0 '        create pixels with intensities
            PSET (Spark(Count).Location.x + 1, Spark(Count).Location.y), FC1
            PSET (Spark(Count).Location.x - 1, Spark(Count).Location.y), FC1
            PSET (Spark(Count).Location.x, Spark(Count).Location.y + 1), FC1
            PSET (Spark(Count).Location.x, Spark(Count).Location.y - 1), FC1
            PSET (Spark(Count).Location.x + 1, Spark(Count).Location.y + 1), FC2
            PSET (Spark(Count).Location.x - 1, Spark(Count).Location.y - 1), FC2
            PSET (Spark(Count).Location.x - 1, Spark(Count).Location.y + 1), FC2
            PSET (Spark(Count).Location.x + 1, Spark(Count).Location.y - 1), FC2
            Spark(Count).Fade = Spark(Count).Fade - 128 / Spark(Count).Lifespan ' decrease spark intensity
            '* update spark location
            Spark(Count).Location.x = Spark(Count).Location.x + Spark(Count).Vector.x * Spark(Count).Velocity
            Spark(Count).Location.y = Spark(Count).Location.y + Spark(Count).Vector.y * Spark(Count).Velocity
            Spark(Count).Velocity = Spark(Count).Velocity * .9 '                  decrease spark velocity
            Spark(Count).Lifespan = Spark(Count).Lifespan - 1 '                   decrese spark life span
        END IF
    LOOP UNTIL Count = UBOUND(Spark) '                                            leave when last index reached
    IF CleanUp THEN '                                                             reset dynamic array if no life
        REDIM Spark(0) AS SPARK
        flag.doSparks = FALSE

        IF flag.doRocks THEN
            ship.x = CENTX
            ship.y = CENTY
            ship.speed = 0
        END IF

        IF flag.landingTime THEN
            ship.y = 20 '           consistant with popUp ship reset during landing time
            ship.Vx = 0
            ship.Vy = 0
            ' ship.course = 359
        END IF

        IF ship.inventory = -1 THEN flag.gameOver = TRUE '                              THIS MAY BE UNNECESSARY/redundant? TRY WITHOUT... <<<<<

        sparkCycles = 0
    END IF
END SUB
'------------------------------------------------------------------------------------------------------------
FUNCTION CircCollide (Circ1 AS rock, Circ2 AS rock) '               Thanks, Terry Ritchie for these!
    '- Checks for the collision between two circular areas.         this is for rock to rock collisions
    DIM SideA% ' side A length of right triangle
    DIM SideB% ' side B length of right triangle
    DIM Hypot& ' hypotenuse squared length of right triangle (side C)
    CircCollide = 0 '                                       assume no collision
    SideA% = Circ1.x - Circ2.x '                            calculate length of side A
    SideB% = Circ1.y - Circ2.y '                            calculate length of side B
    Hypot& = SideA% * SideA% + SideB% * SideB% '            calculate hypotenuse squared
    IF Hypot& <= (Circ1.radius + Circ2.radius) * (Circ1.radius + Circ2.radius) THEN CircCollide = -1
END FUNCTION
' -----------------------------------------
FUNCTION CircCollide2 (Circ1 AS ship, Circ2 AS rock) '      for ship to ROCK collisions
    '- Checks for the collision between two circular areas.
    DIM SideA% ' side A length of right triangle
    DIM SideB% ' side B length of right triangle
    DIM Hypot& ' hypotenuse squared length of right triangle (side C)
    CircCollide2 = 0 '                                      assume no collision
    SideA% = Circ1.x - Circ2.x '                            calculate length of side A
    SideB% = Circ1.y - Circ2.y '                            calculate length of side B
    Hypot& = SideA% * SideA% + SideB% * SideB% '            calculate hypotenuse squared
    IF Hypot& <= (Circ1.radius + Circ2.radius) * (Circ1.radius + Circ2.radius) THEN CircCollide2 = -1
END FUNCTION
' -----------------------------------------
FUNCTION CircCollide3 (Circ1 AS ship, Circ2 AS comet) '      for ship to COMET collisions
    '- Checks for the collision between two circular areas.
    DIM SideA% ' side A length of right triangle
    DIM SideB% ' side B length of right triangle
    DIM Hypot& ' hypotenuse squared length of right triangle (side C)
    CircCollide3 = 0 '                                      assume no collision
    SideA% = Circ1.x - Circ2.x '                            calculate length of side A
    SideB% = Circ1.y - Circ2.y '                            calculate length of side B
    Hypot& = SideA% * SideA% + SideB% * SideB% '            calculate hypotenuse squared
    IF Hypot& <= (Circ1.radius + Circ2.radius) * (Circ1.radius + Circ2.radius) THEN CircCollide3 = -1
END FUNCTION
' -----------------------------------------
FUNCTION CircCollide4 (Circ1 AS ship, Circ2 AS gridRock) '      for ship to GRID collisions
    DIM SideA% ' side A length of right triangle
    DIM SideB% ' side B length of right triangle
    DIM Hypot& ' hypotenuse squared length of right triangle (side C)
    CircCollide4 = 0 '                                      assume no collision
    SideA% = Circ1.x - Circ2.x '                            calculate length of side A
    SideB% = Circ1.y - Circ2.y '                            calculate length of side B
    Hypot& = SideA% * SideA% + SideB% * SideB% '            calculate hypotenuse squared
    IF Hypot& <= (Circ1.radius + 10) * (Circ1.radius + 10) THEN CircCollide4 = -1 '
END FUNCTION
' -----------------------------------------
FUNCTION RectCollide (Rect1 AS RECT, Rect2 AS RECT) '               Thanks, Terry Ritchie for this!
    '- Checks for the collision between two rectangular areas.
    RectCollide = 0 '                           assume no collision
    IF Rect1.x2 >= Rect2.x1 THEN '              rect 1 lower right X >= rect 2 upper left  X ?
        IF Rect1.x1 <= Rect2.x2 THEN '          rect 1 upper left  X <= rect 2 lower right X ?
            IF Rect1.y2 >= Rect2.y1 THEN '      rect 1 lower right Y >= rect 2 upper left  Y ?
                IF Rect1.y1 <= Rect2.y2 THEN '  rect 1 upper left  Y <= rect 2 lower right Y ?
                    RectCollide = -1 '          if all 4 IFs true then a collision must be happening
                END IF
            END IF
        END IF
    END IF
END FUNCTION
' -----------------------------------------
SUB RotateImage (Degree AS SINGLE, InImg AS LONG, OutImg AS LONG)

    '** This subroutine based on code provided by Rob (Galleon) on the QB64.NET website in 2009.
    '** Special thanks to Luke for explaining the matrix rotation formula used in this routine.

    DIM px(3) AS INTEGER '     x vector values of four corners of image
    DIM py(3) AS INTEGER '     saucer(c).loc.y vector values of four corners of image
    DIM Left AS INTEGER '      left-most value seen when calculating rotated image size
    DIM Right AS INTEGER '     right-most value seen when calculating rotated image size
    DIM Top AS INTEGER '       top-most value seen when calculating rotated image size
    DIM Bottom AS INTEGER '    bottom-most value seen when calculating rotated image size
    DIM RotWidth AS INTEGER '  width of rotated image
    DIM RotHeight AS INTEGER ' height of rotated image
    DIM WInImg AS INTEGER '    width of original image
    DIM HInImg AS INTEGER '    height of original image
    DIM Xoffset AS INTEGER '   offsets used to move (0,0) back to upper left corner of image
    DIM Yoffset AS INTEGER
    DIM COSr AS SINGLE '       cosine of radian calculation for matrix rotation
    DIM SINr AS SINGLE '       sine of radian calculation for matrix rotation
    DIM x AS SINGLE '          new x vector of rotated point
    DIM y AS SINGLE '          new saucer(c).loc.y vector of rotated point
    DIM v AS INTEGER '         vector counter

    IF OutImg THEN _FREEIMAGE OutImg '              free any existing image
    WInImg = _WIDTH(InImg) '                        width of original image
    HInImg = _HEIGHT(InImg) '                       height of original image
    px(0) = -WInImg / 2 '                                                  -x,-saucer(c).loc.y ------------------- x,-saucer(c).loc.y
    py(0) = -HInImg / 2 '             Create points around (0,0)     px(0),py(0) |                 | px(3),py(3)
    px(1) = px(0) '                   that match the size of the                 |                 |
    py(1) = HInImg / 2 '              original image. This                       |        .        |
    px(2) = WInImg / 2 '              creates four vector                        |       0,0       |
    py(2) = py(1) '                   quantities to work with.                   |                 |
    px(3) = px(2) '                                                  px(1),py(1) |                 | px(2),py(2)
    py(3) = py(0) '                                                         -x,saucer(c).loc.y ------------------- x,saucer(c).loc.y
    SINr = SIN(-Degree / 57.2957795131) '           sine and cosine calculation for rotation matrix below
    COSr = COS(-Degree / 57.2957795131) '           degree converted to radian, -Degree for clockwise rotation
    DO '                                            cycle through vectors
        x = px(v) * COSr + SINr * py(v) '           perform 2D rotation matrix on vector
        y = py(v) * COSr - px(v) * SINr '           https://en.wikipedia.org/wiki/Rotation_matrix
        px(v) = x '                                 save new x vector
        py(v) = y '                                 save new saucer(c).loc.y vector
        IF px(v) < Left THEN Left = px(v) '         keep track of new rotated image size
        IF px(v) > Right THEN Right = px(v)
        IF py(v) < Top THEN Top = py(v)
        IF py(v) > Bottom THEN Bottom = py(v)
        v = v + 1 '                                 increment vector counter
    LOOP UNTIL v = 4 '                              leave when all vectors processed
    RotWidth = Right - Left + 1 '                   calculate width of rotated image
    RotHeight = Bottom - Top + 1 '                  calculate height of rotated image
    Xoffset = RotWidth \ 2 '                        place (0,0) in upper left corner of rotated image
    Yoffset = RotHeight \ 2
    v = 0 '                                         reset corner counter
    DO '                                            cycle through rotated image coordinates
        px(v) = px(v) + Xoffset '                   move image coordinates so (0,0) in upper left corner
        py(v) = py(v) + Yoffset
        v = v + 1 '                                 increment corner counter
    LOOP UNTIL v = 4 '                              leave when all four corners of image moved
    OutImg = _NEWIMAGE(RotWidth, RotHeight, 32) '   create rotated image canvas
    '                                               map triangles onto new rotated image canvas
_MAPTRIANGLE (0, 0)-(0, HInImg - 1)-(WInImg - 1, HInImg - 1), InImg TO _
(px(0), py(0))-(px(1), py(1))-(px(2), py(2)), OutImg
_MAPTRIANGLE (0, 0)-(WInImg - 1, 0)-(WInImg - 1, HInImg - 1), InImg TO _
(px(0), py(0))-(px(3), py(3))-(px(2), py(2)), OutImg
END SUB
' -----------------------------------------

FUNCTION GETANGLE# (x1#, y1#, x2#, y2#)

    '* Returns the angle in degrees from 0 to 359.9999.... between 2 given coordinate pairs.
    '* Adapted from a function by Rob, aka Galleon, located in the QB64 Wiki

    IF y2# = y1# THEN '                                       both Y values same?
        IF x1# = x2# THEN '                                   yes, both X values same?
            EXIT FUNCTION '                                   yes, points are same, no angle
        END IF
        IF x2# > x1# THEN '                                   second X value greater?
            GETANGLE# = 90 '                                  yes, then must be 90 degrees
        ELSE '                                                no, second X value is less
            GETANGLE# = 270 '                                 then must be 270 degrees
        END IF
        EXIT FUNCTION '                                       leave function
    END IF
    IF x2# = x1# THEN '                                       both X values same?
        IF y2# > y1# THEN '                                   second Y value greater?
            GETANGLE# = 180 '                                 yes, then must be 180 degrees
        END IF
        EXIT FUNCTION '                                       leave function
    END IF
    IF y2# < y1# THEN '                                       second Y value less?
        IF x2# > x1# THEN '                                   yes, second X value greater?
            GETANGLE# = ATN((x2# - x1#) / (y2# - y1#)) * -57.2957795131 ' yes, compute angle
        ELSE '                                                no, second X value less
            GETANGLE# = ATN((x2# - x1#) / (y2# - y1#)) * -57.2957795131 + 360 ' compute angle
        END IF
    ELSE '                                                    no, second Y value greater
        GETANGLE# = ATN((x2# - x1#) / (y2# - y1#)) * -57.2957795131 + 180 ' compute angle
    END IF

END FUNCTION
' -----------------------------------------

SUB getNextCommand (c AS INTEGER)

    saucer(c).loopCounter = 0
    saucer(c).loopNum = 0
    saucer(c).action = ""

    IF saucer(c).charCount >= LEN(saucer(c).commands) THEN '    if at end of command line then that saucer is done
        saucer(c).alive = FALSE '                               kind of a fail safe cuz render sub also kills saucer if ship is offscreen
        EXIT SUB
    END IF
    ' assign each separate command in command line
    saucer(c).charCount = saucer(c).charCount + 2 '                                     increment character counter  (skip space)
    saucer(c).action = LCASE$(MID$(saucer(c).commands, saucer(c).charCount, 1)) '       get the first char, the command letter: 'd,u,l,r' or 'c' for coast
    saucer(c).charCount = saucer(c).charCount + 1 '                                     move to next pair of chars - number of actions: loopNum
    saucer(c).loopNum = VAL(MID$(saucer(c).commands, saucer(c).charCount, 1)) * 10 '    turn the next char into tens column
    saucer(c).charCount = saucer(c).charCount + 1 '                                     skip the space in the string
    saucer(c).loopNum = saucer(c).loopNum + VAL(MID$(saucer(c).commands, saucer(c).charCount, 1)) '  turn this char into the ones value

    IF saucer(c).action = "c" AND (saucer(c).loopNum > 58 AND saucer(c).loopNum < 90) THEN
        FireBullet saucer(c).loc.x + 8, saucer(c).loc.y + 10 '       drone fire at c60s and higher
    END IF
END SUB
' -----------------------------------------

SUB comeBack (action AS STRING, c AS SINGLE) '                                  move saucer(s) toward viewer

    SHARED shipNum AS INTEGER

    SELECT CASE action '                                                        run action scripting
        CASE "u": '                                                 UP
            saucer(c).aspect = saucer(c).aspect - .012 * saucer(c).aspectSign
            IF saucer(c).aspect > .9 THEN saucer(c).aspect = .9 ' WAS .9, .9    nearly vertical
            IF saucer(c).aspect <= .0000002 THEN
                saucer(c).aspectSign = -saucer(c).aspectSign '                  switch up / down for continuity illusion
                saucer(c).aspect = .0000002 '                                   don't let the saucer(c).aspect get to zero - it goes haywire
                saucer(c).fillColor = C(10) ' was red
            END IF
            ' ---------------------
        CASE "d": '                                                 DOWN
            saucer(c).aspect = saucer(c).aspect + .012 * saucer(c).aspectSign
            IF saucer(c).aspect > .9 THEN saucer(c).aspect = .9 ' same as above
            IF saucer(c).aspect <= .0000002 THEN
                saucer(c).aspectSign = -saucer(c).aspectSign
                saucer(c).aspect = .0000002
                saucer(c).fillColor = C(4)
            END IF
            ' ---------------------
        CASE "r": '                                                 RIGHT
            saucer(c).rotAngle = saucer(c).rotAngle + 1.3
            IF saucer(c).rotAngle > 80 THEN saucer(c).rotAngle = 80
            ' ---------------------
        CASE "l": '                                                 LEFT
            saucer(c).rotAngle = saucer(c).rotAngle - 1.3
            IF saucer(c).rotAngle < -80 THEN saucer(c).rotAngle = -80
    END SELECT
    ' ---------------------
    IF saucer(c).aspect <= 0 THEN saucer(c).aspect = .0000001
    ' -------------------------------------
    SELECT CASE ABS(saucer(c).rotAngle) '                                   >>> SIZE, SPEED CONTROLS VIA ROTANGLE <<<
        CASE 0 TO 5: saucer(c).speed = .3 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .035 ' was .07
        CASE 5.00001 TO 10: saucer(c).speed = .6 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .035
        CASE 10.00001 TO 15: saucer(c).speed = .9 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .033
        CASE 15.00001 TO 20: saucer(c).speed = 1.2 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .033
        CASE 20.00001 TO 26: saucer(c).speed = 1.6 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .028
        CASE 26.00001 TO 32: saucer(c).speed = 2.0 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .028
        CASE 32.00001 TO 38: saucer(c).speed = 2.4 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .025
        CASE 38.00001 TO 44: saucer(c).speed = 2.8 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .025
        CASE 44.00001 TO 50: saucer(c).speed = 3.0 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .02
        CASE 50.00001 TO 56: saucer(c).speed = 3.2 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .02
        CASE 56.00001 TO 62: saucer(c).speed = 3.4 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .017
        CASE 62.00001 TO 68: saucer(c).speed = 3.6 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .017
        CASE 68.00001 TO 74: saucer(c).speed = 4.0 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .015
        CASE 74.00001 TO 80: saucer(c).speed = 4.4 * saucer(c).rotAngSign
            saucer(c).shipRadius = saucer(c).shipRadius + .014
    END SELECT
    saucer(c).loc.x = saucer(c).loc.x + saucer(c).speed '                                   ** speed control **
    '                                                                                       EXCEPTIONS:
    IF saucer(c).shipRadius < 1.15 THEN saucer(c).shipRadius = saucer(c).shipRadius - .02 ' .02  NEW slow saucer growth initially
END SUB
' --------------------------------------------------------
SUB yControl (c AS INTEGER) '                                                               used by away & return subs
    '                                                                                       ** UP / DOWN CONTROLS **
    IF saucer(c).aspect > .029 THEN '                                                       if the saucer(c).aspect angle is more than flat
        SELECT CASE saucer(c).aspect '                                                      saucer ascends & descends faster at steeper angles
            CASE .03 TO .05: saucer(c).loc.y = saucer(c).loc.y + .3 * saucer(c).aspectSign '        once tilted, saucer keeps going
            CASE .0500001 TO .09: saucer(c).loc.y = saucer(c).loc.y + .6 * saucer(c).aspectSign
            CASE .0900001 TO .15: saucer(c).loc.y = saucer(c).loc.y + .9 * saucer(c).aspectSign
            CASE .1500001 TO .2: saucer(c).loc.y = saucer(c).loc.y + 1.5 * saucer(c).aspectSign
            CASE .2000001 TO .3: saucer(c).loc.y = saucer(c).loc.y + 2.3 * saucer(c).aspectSign
            CASE .3000001 TO .4: saucer(c).loc.y = saucer(c).loc.y + 3.0 * saucer(c).aspectSign
            CASE .4000001 TO .5: saucer(c).loc.y = saucer(c).loc.y + 3.8 * saucer(c).aspectSign
            CASE .5000001 TO .6: saucer(c).loc.y = saucer(c).loc.y + 4.2 * saucer(c).aspectSign
            CASE .6000001 TO .7: saucer(c).loc.y = saucer(c).loc.y + 4.6 * saucer(c).aspectSign
            CASE .7000001 TO .8: saucer(c).loc.y = saucer(c).loc.y + 5.2 * saucer(c).aspectSign
            CASE .8000001 TO .9: saucer(c).loc.y = saucer(c).loc.y + 5.8 * saucer(c).aspectSign
        END SELECT
    END IF
END SUB
' --------------------------------------------------------
SUB renderSaucer (c AS INTEGER)

    SHARED AS LONG HDWimg() '      freed
    DIM AS LONG virtual(9), outImg(9)
    DIM AS SINGLE x, y

    virtual(c) = _NEWIMAGE(saucer(c).shipRadius * 2 + 30, saucer(c).shipRadius * 2 + 30, 32) '      size the virtual screens dynamically
    outImg(c) = _NEWIMAGE(saucer(c).shipRadius * 2 + 30, saucer(c).shipRadius * 2 + 30, 32) '       doesn't seem to kill performance
    HDWimg(c) = _NEWIMAGE(saucer(c).shipRadius * 2 + 30, saucer(c).shipRadius * 2 + 30, 32) '       hardware image handle

IF saucer(c).loc.y < -58 OR saucer(c).loc.y > 900 - 8 OR_
saucer(c).loc.x >= 1600 + saucer(c).shipRadius + 20 OR saucer(c).loc.x <= -58 THEN '        off-screen saucer = dead
        saucer(c).alive = FALSE '                                                           turn off this saucer
    END IF
    ' -----------------------------------------
    IF saucer(c).rotAngle > 0 THEN saucer(c).rotAngSign = 1 '                   compensates for left or right turns
    IF saucer(c).rotAngle < 0 THEN saucer(c).rotAngSign = -1 '                  once turned, saucer keeps going
    ' -----------------------------------------
    yControl c
    comeBack saucer(c).action, c '                                              subs for saucer x and y movement, speed & size, aspect controls
    ' -----------------------------------------
    '                                                                           ** RENDERING **
    _DEST virtual(c) '                                                          draw to virtual screen first, then rotate as needed
    x = _WIDTH / 2: y = _HEIGHT / 2
    CIRCLE (x, y), saucer(c).shipRadius, C(14), 0, 6.283, saucer(c).aspect '    draw saucer centered

    IF saucer(c).aspect > .003 THEN ' was 4
        $IF MAC THEN
            PAINT (x, y), saucer(c).fillColor, C(14) '          only paint the inside when the ship's profile is an oval - not a line!
        $END IF
        IF saucer(c).fillColor = C(4) THEN '                                    c(4) is top - ship going down
            CIRCLE (x, y), saucer(c).shipRadius * .8, C(0), 0, 6.283, saucer(c).aspect '    add some top o' saucer details
            CIRCLE (x, y), saucer(c).shipRadius * .2, C(12), 0, 6.283, saucer(c).aspect
            $IF MAC THEN
                PAINT (x, y), C(14), C(12)
            $END IF
            IF saucer(c).shipRadius > 14 THEN
                CIRCLE (x, y), saucer(c).shipRadius * .8, C(12), 0, , saucer(c).aspect '
                PAINT (x, y), C(0), C(12)
            END IF
        ELSE '                                                              bottom o' saucer details - red fillcolor
            CIRCLE (x, y), saucer(c).shipRadius * .8, C(14), 0, 6.283, saucer(c).aspect
            CIRCLE (x, y), saucer(c).shipRadius * .74, C(14), 0, 6.283, saucer(c).aspect
            CIRCLE (x, y), saucer(c).shipRadius * .3, C(4), 0, 6.283, saucer(c).aspect
            PAINT (x, y), C(0), C(4)
        END IF
    END IF
    IF saucer(c).aspect <= .066 THEN '                                      draw arcs for top and bottom of saucer at flat saucer(c).aspect
        CIRCLE (x, y), saucer(c).shipRadius, C(14), 3.14, 6.28, .11
        CIRCLE (x, y), saucer(c).shipRadius, C(14), 6.28, 3.14, .09
        $IF MAC THEN
            PAINT (x, y), C(14), C(14) '
        $END IF
    END IF
    ' -------------------------------------------
    RotateImage saucer(c).rotAngle, virtual(c), outImg(c) '
    HDWimg(c) = _COPYIMAGE(outImg(c), 33) '                                 CONVERT TO HARDWARE IMAGE
    _FREEIMAGE outImg(c) '
    _FREEIMAGE virtual(c)
    _FONT 16 '
    _DEST 0
END SUB
' ----------------------------------------
SUB assignMoves () '

    SHARED AS STRING moves() '                                                                                  scripted saucer runs
    '                                                                                                           leave space at beginning, always use entries of 3 chars!
    moves(1) = " c10 l10 c30 u20 d24 r20 d40 u42 c20 l10 c80 r30 u20 d30 l40 c10 r10 u48 c20 u20 c99 c99 c99" ' leave no space at the end!
    moves(2) = " c20 l16 c10 r20 c50 l30 c60 r30 c20 l30 c20 r90 u15 d25 u60 c99 c99 c99" '
    moves(3) = " c30 r08 c10 l16 c20 r30 d20 u20 c20 l20 d20 c30 u40 d20 c80 l50 r76 l40 u60 c99 c99 c99" '     u=up, d=down, l=left, r=right, c=coast (or any other unassign char)
    moves(4) = " c40 d05 l05 c70 u10 r10 c50 d20 r20 l40 u20 c90 d25 c20 u40 c10 d10 l50 c99 c99 c99"
    moves(5) = " c55 l40 c50 r80 d10 c10 l30 r20 u30 d35 c60 u38 l70 c20 u20 c99 c99 c99"
    moves(6) = " c55 r20 c10 l50 c10 u15 c20 r30 d15 c70 d25 c08 u50 c10 d25 c20 u20 r40 d25 l40 r99 d20 c99 c99 c99"
    moves(7) = " c20 d05 c30 u12 c40 l60 c10 r70 l10 d07 c70 d35 c10 u60 c40 d25 l70 c99 c99 c99 c99"
    moves(8) = " c30 d20 u20 c10 l20 r40 c60 d25 c10 u20 r18 l76 d12 u18 c99 u45 c30 d35 c99 c99 c99"
    moves(9) = " c45 r10 c80 l20 c70 r20 c20 l45 c70 u25 r35 d25 c70 u40 l75 c99 c99 c99 c99" '
    moves(10) = " c25 l30 c60 r50 u30 d60 u30 c50 l40 c20 r40 l20 c60 u25 r08 l36 c10 d25 c10 r20 d40 r99 d20 c99 c99 c99" '
    moves(11) = " c10 r10 c10 l20 r10 c30 d15 u25 r08 l46 d35 u25 r38 c70 u70 c99 c99 c99"
    moves(12) = " c40 l01 u40 d80 u80 d80 u40 l30 r40 u40 d40 l10 c60 d10 l99 c99 c99 c99"
    moves(13) = " c30 r50 c25 l50 d20 l15 c10 u30 r15 l30 r30 l30 r30 d07 c60 u20 l30 r30 d80 c99 c99 c99"
    moves(14) = " c40 u10 c15 d10 c18 l15 c36 r40 c20 u10 l20 d20 c30 u30 d20 c20 l40 r35 c50 l80 d15 c99 c99 c99"
    moves(15) = " c55 r40 l40 c60 u30 d60 u30 c30 l15 r15 c20 u30 d30 l02 c60 d80 c99 c99 c99"
    moves(16) = " c50 l15 c10 r15 u30 r05 d60 c10 l10 u30 c20 l40 r40 r05 c60 r80 u35 c99 c99 c99"
    moves(17) = " c30 u20 l50 d20 r50 c30 d40 c20 u45 c20 r60 l60 d05 c55 l40 u60 r40 c99 c99 c99"
    moves(18) = " c30 r20 c10 l50 c10 u20 c20 r10 d20 r20 c70 u20 c10 d30 c20 u20 r40 d30 l40 u20 r60 d80 c99 c99"
END SUB
' -------------------------------
SUB assignSaucers ()

    SHARED AS INTEGER shipNum, limit
    SHARED moves() AS STRING
    DIM AS INTEGER c, rand

    RANDOMIZE TIMER
    shipNum = INT(RND * 5 + 4) '    set num of ships for attack run
    SELECT CASE shipNum
        CASE 4: limit = 76 '        frame rate adjustments for saucer quantity
        CASE 5: limit = 75
        CASE 6: limit = 74
        CASE 7: limit = 72
        CASE 8: limit = 72
        CASE 9: limit = 74
    END SELECT

    c = 0
    DO
        c = c + 1
        rand = INT(RND * 18 + 1)
        saucer(c).commands = moves(rand)
        saucer(c).movesNum = rand
        saucer(c).loc.x = INT(RND * 400 + 1600 \ 2 - 200) '             fairly random start point near center
        saucer(c).loc.y = INT(RND * 300 + 900 \ 2 - 150) '
        checkSaucerProx c '                                             check if same saucer patterns are too close to one another
        saucer(c).alive = TRUE
        saucer(c).fillColor = C(12)
        saucer(c).aspect = .00001
        saucer(c).rotAngle = 0
        saucer(c).aspectSign = 1
        saucer(c).rotAngSign = 1
        saucer(c).speed = 1
        saucer(c).charCount = 0
        saucer(c).loopCounter = 0
        saucer(c).loopNum = 0
        saucer(c).action = ""
        saucer(c).shipRadius = 0
        saucer(c).getCommand = TRUE
    LOOP UNTIL c = shipNum
END SUB
' -----------------------------------------
SUB checkSaucerProx (c AS INTEGER) '    c represents the current saucer assignment number
    '                                   a is the lower selection number for comparison
    SHARED shipNum AS INTEGER '         this sub checks same-saucer (both/many assigned the same moves(#)) proximity
    DIM AS INTEGER a, count

    a = 0
    count = 0
    DO
        count = count + 1
        a = c - count
        IF a = 0 THEN EXIT SUB

        IF saucer(c).movesNum = saucer(a).movesNum THEN
            IF ABS(saucer(c).loc.x - saucer(a).loc.x) < 90 THEN '       if the current saucer is too close to an older saucer then
                IF SGN(saucer(c).loc.x - saucer(a).loc.x) < 1 THEN '    if the difference is negative or zero then
                    saucer(c).loc.x = saucer(c).loc.x - 100 '
                ELSE
                    saucer(c).loc.x = saucer(c).loc.x + 100
                END IF
            END IF

            IF ABS(saucer(c).loc.y - saucer(a).loc.y) < 80 THEN
                IF SGN(saucer(c).loc.y - saucer(a).loc.y) < 1 THEN
                    saucer(c).loc.y = saucer(c).loc.y - 90
                ELSE
                    saucer(c).loc.y = saucer(c).loc.y + 90
                END IF
            END IF
        END IF
    LOOP
END SUB
' -----------------------------------------
SUB loadViewScreen () '                                     1600 x 900 HDWR view screen for saucerControl sub

    DIM c AS INTEGER
    DIM temp AS LONG
    DIM AS INTEGER wide, high

    wide = 1600
    high = 900
    temp = _NEWIMAGE(wide, high, 32)
    viewScreen = _NEWIMAGE(wide, high, 32)

    _DEST temp
    LINE (0, 0)-(wide - 1, high - 1), C(2), B '             outer border box
    LINE (25, 25)-(wide - 25, high - 25), C(4), B '         inner border box
    PAINT (2, 2), C(1), C(4) '                              fill in the view screen
    c = 0
    DO
        c = c + 1 '                                         rivets for Will! Black circles painted gray inside.
        CIRCLE ((12 * (c * 4)) + 7, 12), 3, C(0) '          top
        PAINT ((12 * (c * 4)) + 7, 12), C(2), C(0) '
        CIRCLE (12, 9 * (c * 4)), 3, C(0) '                 left
        PAINT (12, 9 * (c * 4)), C(2), C(0)
        CIRCLE (wide - 13, 9 * (c * 4)), 3, C(0) '          right
        PAINT (wide - 13, 9 * (c * 4)), C(2), C(0)
        CIRCLE ((12 * (c * 4)) + 7, high - 12), 3, C(0) '   bot
        PAINT ((12 * (c * 4)) + 7, high - 12), C(2), C(0) '
    LOOP UNTIL c = 32

    viewScreen = _COPYIMAGE(temp, 33) '                     hardware image for sitting on top layer
    _FONT 16
    _DEST 0
    _FREEIMAGE temp
END SUB
' -----------------------------------------

SUB ManageBullets () '                    ManageBullets & Star Shaking & Related Sounds & ScoreKeeping Chores

    SHARED Bullet() AS BULLET
    SHARED AS LONG saucerScape
    DIM Index AS INTEGER
    STATIC AS _BYTE wiggle, s, a, adder, initd

    IF NOT initd THEN
        adder = 3
        a = 0
        s = 0
        initd = TRUE
    END IF

    'Scan the bullet array for active bullets

    Index = -1 '                                    reset index counter value
    DO '                                            begin array search loop
        Index = Index + 1 '                         increment array index counter
        IF Bullet(Index).Active THEN '              is this bullet active?

            'This bullet is active, update its location and speed

            IF Bullet(Index).Radius < 360 THEN '    only course adjust smaller circles to prevent wobble
                IF Bullet(Index).x < 800 - 5 THEN ' leave a range of OK centering to avoid over-adjusting center
                    Bullet(Index).x = Bullet(Index).x + Bullet(Index).Speed
                ELSE IF Bullet(Index).x > 800 + 5 THEN Bullet(Index).x = Bullet(Index).x - Bullet(Index).Speed
                END IF

                IF Bullet(Index).y < 450 - 5 THEN
                    Bullet(Index).y = Bullet(Index).y + Bullet(Index).Speed
                ELSE IF Bullet(Index).y > 450 + 5 THEN Bullet(Index).y = Bullet(Index).y - Bullet(Index).Speed
                END IF

            END IF

            IF Bullet(Index).Radius < 60 THEN '                 circle growth
                Bullet(Index).Radius = Bullet(Index).Radius + 3
            ELSE
                IF Bullet(Index).Radius > 59 AND Bullet(Index).Radius < 200 THEN
                    Bullet(Index).Radius = Bullet(Index).Radius + 12
                ELSE
                    IF Bullet(Index).Radius > 199 THEN
                        Bullet(Index).Radius = Bullet(Index).Radius + 40
                    END IF
                END IF
            END IF

            Bullet(Index).Speed = Bullet(Index).Speed * 1.05 '  increase speed slightly

            IF Bullet(Index).Radius > 400 AND Bullet(Index).Radius < 406 THEN
                _SNDPLAYCOPY S(37), .35 '                       impact sound
                score = score - 10 '                                                    ** SCORE **
                IF ship.shields > 8 THEN ship.shields = ship.shields - 1.8 '            ** SHIELDS - cannot blow up during saucer attacks **
                wiggle = TRUE
            END IF

            IF wiggle THEN '                                    shake starScape
                s = s + 1
                a = a + adder ' 3
                _PUTIMAGE (a, 0), saucerScape '                 move stars horizontally 9 pixels each way
                IF a = 9 OR a = -9 THEN adder = -adder
                IF s = 22 THEN
                    a = 0
                    s = 0
                    adder = 3
                    wiggle = FALSE
                END IF
            END IF

            'Check to see if the circle has left the game screen

            IF Bullet(Index).Radius > 700 THEN ' '              has bullet gotten big enough?

                'This circle has gotten big enough, deactivate it

                Bullet(Index).Active = 0 '                      yes, deactivate bullet
            ELSE '                                              no, bullet still on game screen

                'This bullet is still on game screen, draw it

                CIRCLE (Bullet(Index).x, Bullet(Index).y), Bullet(Index).Radius, C(12) '      draw the bullet
                IF flag.paintCircles THEN PAINT (Bullet(Index).x, Bullet(Index).y), _RGB32(227, 50, 55, 34), C(12) '   paint the bullet circle
            END IF
        END IF
    LOOP UNTIL Index = UBOUND(Bullet) '                         leave when all indexes checked

END SUB
' -----------------------------------------

SUB FireBullet (x AS INTEGER, y AS INTEGER) '

    SHARED Bullet() AS BULLET ' need access to player bullet array
    DIM Index AS INTEGER ' array index counter

    'Scan the bullet array for an index that is not active

    Index = -1 '                                    reset index counter
    DO '                                            begin array search loop
        Index = Index + 1 '                         increment array index counter
    LOOP UNTIL Index = UBOUND(Bullet) OR Bullet(Index).Active = 0 '     leave when inactive found or at end of array

    'Test if the index value from the search loop yielded an inactive array index

    IF Bullet(Index).Active THEN '                  was an inactive array index found?

        'No inactive bullets were found in the array so the array size will need to be increased by one. The
        'maximum size of the array will eventually be determined by the speed of the player's button presses.

        Index = Index + 1 '                         no, increase the array index size
        REDIM _PRESERVE Bullet(Index) AS BULLET '   resize the array while preserving exisiting data
    END IF

    'Add the new bullet's information the bullet array

    Bullet(Index).x = x '                           new bullet's x coordinate
    Bullet(Index).y = y '                           new bullet's y coordinate
    Bullet(Index).Speed = 2 '                       new bullet's initial speed
    Bullet(Index).Radius = 3
    Bullet(Index).Active = 1 '                      this array index is active
    _SNDPLAYCOPY S(36), .15 '                       awesome saucer bullet sound

END SUB
' -----------------------------------------
SUB driveTruck ()
    STATIC AS SINGLE c, d

    c = c + .28
    d = d + .006
    _PUTIMAGE (726 - c, 660 + d), I(3), 0
    IF c > 800 THEN
        c = 0
        d = 0
        flag.doTruck = FALSE
    END IF
END SUB
' -----------------------------------------

SUB instructions () '

    DIM AS INTEGER c, d, i '
    DIM a$, b$, c$, d$, e$, f$, g$, h$ '
    SHARED AS LONG starScape

    a$ = "Press any key to continue..."
    b$ = "WELCOME TO ROCK JOCKY 1.0. THIS GAME REQUIRES SKILL, PERSEVERANCE AND NERVES OF STEEL."
    c$ = "YOU'LL BE MANNING THE CONTROLS OF A NIMBLE AND POWERFUL HARVESTER DRONE."
    d$ = "GO SNAG SOME MULTI-MILLION DOLLAR ROCKS THAT ARE HIGHLIGHTED BY THE ONBOARD COMPUTER JUST FOR YOU."
    e$ = "PRESS 'ESC' TO EXIT OR GO TO SETTINGS OR INTRO SCREEN"
    f$ = "'P' TO PAUSE"
    g$ = "'SPACEBAR' TO CAPTURE OR UNLOAD ROCKS"
    h$ = "('RETURN' TO SHUFFLE ROCKS IN CASE OF LOCKUP)"

    _SNDLOOP S(32): _SNDVOL S(32), 0 '      run sound
    DO
        c = c + 1
        _SNDVOL S(32), c * .001 '           turn it up
        _LIMIT 40
    LOOP UNTIL c = 40

    CLS
    _DISPLAY
    _FONT menlo: COLOR C(14)

    FOR i = 255 TO 0 STEP -4 '              fade in scene
        CLS
        _PUTIMAGE , starScape
        COLOR C(14)
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(b$) \ 2, 430), b$
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(c$) \ 2, 465), c$
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(d$) \ 2, 500), d$
        LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, i), BF '  increase black box transparency
        _DISPLAY
        _LIMIT 80 '
    NEXT

    _DELAY 3.7

    FOR d = 4 TO 9 '                        churn through demo images
        CLS
        _PUTIMAGE , starScape
        _PUTIMAGE (_WIDTH \ 2 - _WIDTH(I(d)) \ 2, 50), I(d)
        COLOR C(14)
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(b$) \ 2, 430), b$
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(c$) \ 2, 465), c$
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(d$) \ 2, 500), d$
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(e$) \ 2, 555), e$
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(f$) \ 2, 580), f$
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(g$) \ 2, 605), g$
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(h$) \ 2, 630), h$
        COLOR C(4)
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(a$) \ 2, 685), a$
        _DISPLAY
        SLEEP
    NEXT
    CLS
    d = 0
    DO
        d = d + 1 '                                 d turns down music and changes alpha value
        COLOR _RGB32(255, 255, 140, d * .2) '       was 2 (1.2)
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH("GOOD LUCK!") \ 2, 300), "GOOD LUCK!"
        _SNDVOL S(32), .05 - (d * .0009) '          turn down music loop
        _DISPLAY
        _LIMIT 40
    LOOP UNTIL d >= 55

    _KEYCLEAR
    flag.doInstructs = FALSE
    ship.speed = 0
    _FONT 16
    _DELAY .8
    soundOn
    IF NOT flag.doFF AND NOT flag.doSaucers THEN turnOnChecks
    _SNDSTOP S(32) '
END SUB
' -----------------------------------------

SUB splashPage () '

    DIM AS LONG funFont, splashImg
    DIM AS INTEGER c, i, x, y, adder, spin, b
    DIM AS SINGLE adder3, e, vol, d
    DIM a$, b$, z$
    DIM AS _BYTE done ', killGame
    SHARED AS LONG starScape, shipImg
    SHARED AS STRING rockType()

    _SNDSTOP S(28)
    _SNDLOOP S(38): _SNDVOL S(38), .25: vol = .25
    hold = TRUE

    splashImg = _NEWIMAGE(1280, 720, 32)
    funFont = _LOADFONT("futura.ttc", 38)
    z$ = "Naked Ape Studios Presents"
    a$ = "Rock Jockey"
    b$ = "A c t i o n  &  A d v e n t u r e"
    _DEST splashImg
    _PUTIMAGE (270, 190), I(10)
    _PUTIMAGE (960, 420), I(13)
    _PUTIMAGE (530, 380), I(14)
    _PUTIMAGE (120, 520), I(15)
    _PUTIMAGE (260, 400), I(16)
    _PUTIMAGE (1030, 270), I(18)
    _PUTIMAGE (750, 280), shipImg
    _PUTIMAGE (800, 260), shipImg
    _PUTIMAGE (850, 240), shipImg
    COLOR C(6)
    _FONT modernBig
    _UPRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(z$) \ 2, 52), z$
    COLOR C(14)
    _FONT funFont
    _UPRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(a$) \ 2, 74), a$
    COLOR C(12)
    _FONT menlo
    _UPRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(b$) \ 2, 132), b$
    LINE (0, 0)-(_WIDTH - 1, _HEIGHT - 1), C(3), B
    LINE (30, 30)-(_WIDTH - 31, _HEIGHT - 31), C(3), B
    PAINT (10, 10), C(5), C(3)
    _FONT 16 '                  THIS TOOK FOREVER - GOTTA DO A SYS _FONT INSIDE DIFFERENT _DESTS TO ALLOW FREEING FONTS!
    _DEST 0

    i = 255
    c = 240
    adder = -2 ' -2   increments label fades
    adder3 = .35 '   was .2    "     star movement
    CLS
    _DISPLAY

    DO
        CLS
        _PUTIMAGE (0 + e, 0), starScape
        e = e + adder3
        IF e > 40 OR e < -40 THEN adder3 = -adder3

        IF b < 1 THEN
            d = d + 1.5
            _FONT modernBig: COLOR C(14)
            _UPRINTSTRING (-200 + d, 670), "TURN UP YOUR SPEAKERS"
            IF d > 1450 THEN b = b + 1: d = 0
        END IF

        _PUTIMAGE , splashImg '   backdrop

        WHILE _MOUSEINPUT: WEND '
        x = _MOUSEX
        y = _MOUSEY
        '                                           ** MOUSE CLICKS **
        IF _MOUSEBUTTON(1) THEN '                   box play game
            IF x > 80 AND x < 170 THEN
                IF y > 300 AND y < 320 THEN
                    IF NOT flag.doFF AND NOT flag.doSaucers THEN turnOnChecks
                    soundOn '                       resume sound loops
                    ship.speed = 0 '                reset game
                    ship.x = CENTX
                    ship.y = CENTY
                    ship.course = 359
                    score = 0
                    EXIT DO
                END IF
            END IF

            IF x > 80 AND x < 240 THEN '       box instructions
                IF y > 340 AND y < 360 THEN
                    flag.doInstructs = TRUE
                    EXIT DO '
                END IF
            END IF

            IF x > 80 AND x < 160 THEN '       box settings
                IF y > 380 AND y < 400 THEN
                    flag.doSettings = TRUE '
                    EXIT DO
                END IF
            END IF

            IF x > 80 AND x < 124 THEN '       exit settings
                IF y > 420 AND y < 440 THEN
                    _FONT 16
                    wrapUp
                    SYSTEM
                END IF
            END IF
        END IF

        COLOR _RGB32(0, 255, 0, c)
        _FONT menlo
        _UPRINTSTRING (80, 300), "PLAY GAME" ' WAS 350
        _UPRINTSTRING (80, 340), "INSTRUCTIONS"
        _UPRINTSTRING (80, 380), "SETTINGS"
        _UPRINTSTRING (80, 420), "EXIT"
        c = c + adder
        IF c < 30 OR c > 255 THEN adder = -adder

        PRESET (1130, 120), C(14) '                 spinning rock 1, right
        DRAW "TA=" + VARPTR$(spin) + rockType(10)
        PAINT (1128, 122), _RGB32(0), C(14)
        PSET (1130, 120), C(0)
        spin = spin + 1

        PRESET (140, 120), C(14) '                  rock 2, left
        spin = -spin
        DRAW "TA=" + VARPTR$(spin) + rockType(6) '
        PAINT (141, 122), _RGB32(0), C(14)
        PSET (140, 120), C(0) '                     kill dot in center
        spin = -spin

        _PUTIMAGE (809, 460 + e * 1.5), I(2) '      move alien ship
        _PUTIMAGE (220 + e, 160), I(11) '           and heavenly bodies
        _PUTIMAGE (1000 + e, 160), I(12)
        _PUTIMAGE (600 + e, 260), I(17)

        IF NOT done THEN
            i = i - 4
            LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, i), BF '  increase black box transparency
            IF i < 10 THEN done = TRUE: _MOUSESHOW ': _MOUSEMOVE 267, 402 '           DISABLED MOUSEMOVE <<<<<<<
        END IF

        _DISPLAY
        _LIMIT 44
    LOOP

    _KEYCLEAR '                                                 prevents popUp at start

    FOR i = 0 TO 255 STEP 5
        LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, i), BF '  quick fade out
        vol = vol - .005
        _SNDVOL S(38), vol
        _DISPLAY
        _LIMIT 100 '
    NEXT

    _FONT 16
    _FREEFONT funFont
    _FREEIMAGE splashImg
    _MOUSEHIDE
    _SNDSTOP S(38)
    flag.doPopUp = FALSE
    hold = FALSE
    FPS = 10
    flag.speedUp = TRUE
END SUB
' -----------------------------------------

SUB settings () '

    DIM AS INTEGER i, j, x, y
    DIM AS SINGLE vol
    DIM AS _BYTE changeMade
    STATIC AS INTEGER paintX, msX, rezX, diffX '     x value of existing button settings
    STATIC AS _BYTE initd

    IF NOT initd THEN
        paintX = 274
        msX = 220
        rezX = 202
        diffX = 133
        initd = TRUE
    END IF

    hold = TRUE
    CLS , _RGB32(50)
    _MOUSESHOW
    _PRINTMODE _KEEPBACKGROUND
    _SNDPLAY S(39): vol = .25
    COLOR C(14)
    _FONT menlo
    _UPRINTSTRING (50, 16), "SETTINGS"

    COLOR _RGB32(111, 230, 172)
    _UPRINTSTRING (50, 60), "IF YOU HAVE A FAST COMPUTER, YOU COULD SWITCH ON PAINTING THE PIRATE SAUCERS' CANNON FIRE."
    _UPRINTSTRING (50, 90), "TURN ON PAINTING?"
    _UPRINTSTRING (139 + 60, 128), "YES": _UPRINTSTRING (266, 128), "NO"
    LINE (20, 50)-(_WIDTH - 20, 50), C(6)
    FOR j = 1 TO 2
        CIRCLE (150 + j * 62, 160), 7, C(13) '                      yes/no buttons
    NEXT j
    PAINT (paintX, 160), C(12), C(13) '                             paint the existing choice #1
    _UPRINTSTRING (93, 234), "SLOWER" '
    _UPRINTSTRING (413, 234), "FASTER"
    _UPRINTSTRING (50, 200), "SET MOUSE SENSITIVITY"
    LINE (20, 190)-(_WIDTH - 20, 190), C(6)
    FOR j = 1 TO 10
        IF j <> 10 THEN _UPRINTSTRING (46 + j * 40, 290), STR$(j)
        CIRCLE (60 + j * 40, 270), 7, C(13) '                       1 to 10 buttons
    NEXT j
    _UPRINTSTRING (11 + j * 40, 290), "10"
    PAINT (msX, 270), C(12), C(13) '                                paint the existing selection #2

    LINE (20, 340)-(_WIDTH - 20, 340), C(6)
    _UPRINTSTRING (50, 350), "DO YOU WANT FULLSCREEN OR NATIVE RESOLUTION?" '
    CIRCLE (202, 385), 7, C(13) '                                   buttons
    CIRCLE (310, 385), 7, C(13)
    PAINT (rezX, 385), C(12), C(13) '                                paint existing choice #3
    _DISPLAY '

    LINE (20, 430)-(_WIDTH - 20, 430), C(6)
    _UPRINTSTRING (50, 440), "SET LANDING DIFFICULTY"
    _UPRINTSTRING (116, 480), "EASY": _UPRINTSTRING (250, 480), "MEDIUM"
    _UPRINTSTRING (395, 480), "HARD"
    CIRCLE (133, 514), 7, C(13)
    CIRCLE (277, 514), 7, C(13)
    CIRCLE (413, 514), 7, C(13)
    PAINT (diffX, 514), C(12), C(13) '                              paint existing choice #4
    LINE (20, 554)-(_WIDTH - 20, 554), C(6)
    COLOR C(14)
    _UPRINTSTRING (112, 598), "DONE"
    LINE (84, 590)-(172, 620), C(4), B
    PAINT (100, 600), _RGB32(240, 0, 0, 80), C(4)

    DO
        WHILE _MOUSEINPUT: WEND
        x = _MOUSEX
        y = _MOUSEY
        IF _MOUSEBUTTON(1) THEN '                                   yes / no buttons
            IF y >= 153 AND y <= 168 THEN
                IF x >= 208 AND x <= 216 THEN
                    _SNDPLAY S(2)
                    PAINT (213, 160), C(12), C(13)
                    PAINT (274, 160), C(0), C(13) '
                    paintX = 212
                    flag.paintCircles = TRUE
                    changeMade = TRUE
                ELSE
                    IF x >= 267 AND x <= 280 THEN '                 no
                        _SNDPLAY S(2)
                        PAINT (274, 160), C(12), C(13)
                        PAINT (213, 160), C(0), C(13)
                        paintX = 274
                        flag.paintCircles = FALSE
                        changeMade = TRUE
                    END IF
                END IF
            ELSE
                IF y >= 263 AND y <= 277 THEN '                     1 to 10 buttons
                    FOR j = 1 TO 10
                        IF x >= (60 + j * 40) - 8 AND x <= (60 + j * 40) + 8 THEN ' selection made?
                            FOR i = 1 TO 10
                                PAINT (60 + i * 40, 271), C(0), C(13) '         black out all the cells
                            NEXT i
                            _SNDPLAY S(2)
                            PAINT (60 + j * 40, 271), C(12), C(13) '            paint the selected cell
                            mouseSens = j * .1 '                                set mouse multiplier (0.1 to 1)
                            msX = 60 + j * 40
                            changeMade = TRUE
                        END IF
                    NEXT j
                END IF
            END IF

            IF y >= 380 AND y <= 395 THEN
                IF x >= 194 AND x <= 209 THEN
                    _SNDPLAY S(2)
                    PAINT (202, 385), C(12), C(13)
                    PAINT (310, 385), C(0), C(13)
                    rezX = 202
                    flag.fullScreen = TRUE '                    fullscreen on
                    flag.fullScreenOff = FALSE
                    changeMade = TRUE
                ELSE '
                    IF x >= 303 AND x <= 317 THEN '             fullscreen off
                        _SNDPLAY S(2)
                        PAINT (202, 385), C(0), C(13)
                        PAINT (310, 385), C(12), C(13)
                        rezX = 310
                        flag.fullScreenOff = TRUE
                        flag.fullScreen = FALSE
                        changeMade = TRUE
                    END IF
                END IF
            END IF

            IF y >= 507 AND y <= 521 THEN '
                IF x >= 126 AND x <= 140 THEN '                 easy
                    _SNDPLAY S(2)
                    PAINT (133, 514), C(12), C(13)
                    PAINT (277, 514), C(0), C(13)
                    PAINT (413, 514), C(0), C(13)
                    diffX = 133
                    landingSpeed = 56 '
                    changeMade = TRUE
                ELSE '
                    IF x >= 270 AND x <= 285 THEN '             medium
                        _SNDPLAY S(2)
                        PAINT (277, 514), C(12), C(13)
                        PAINT (133, 514), C(0), C(13)
                        PAINT (413, 514), C(0), C(13)
                        diffX = 277
                        landingSpeed = 65
                        changeMade = TRUE
                    ELSE
                        IF x >= 406 AND x <= 420 THEN '         hard
                            _SNDPLAY S(2)
                            PAINT (413, 514), C(12), C(13)
                            PAINT (133, 514), C(0), C(13)
                            PAINT (277, 514), C(0), C(13)
                            diffX = 413
                            landingSpeed = 80
                            changeMade = TRUE
                        END IF
                    END IF
                END IF
            END IF

            IF y >= 588 AND y <= 622 THEN '
                IF x >= 82 AND x <= 174 THEN '                  done
                    PAINT (100, 600), _RGB32(0, 255, 0, 80), C(4)
                    EXIT DO
                END IF
            END IF
            _DELAY .25 '                                        prevents multiple click sounds
        END IF ' - - - - - - - - - - - - - - - - - -            end of click loop checks

        _DISPLAY '
        _LIMIT 20
    LOOP

    IF changeMade THEN
        _SNDPLAY S(3)
        COLOR C(14)
        _FONT menlo
        _UPRINTSTRING (54, 650), "SETTINGS ADJUSTED"
        _DISPLAY
        _DELAY .7
    END IF

    FOR i = 0 TO 255 STEP 4
        vol = vol - .004 '
        _SNDVOL S(39), vol '
        LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, i), BF '  quick fade out
        _DISPLAY
        _LIMIT 100 '
    NEXT

    _KEYCLEAR
    _MOUSEHIDE
    hold = FALSE '      resume main game loop
    FPS = 10
    flag.speedUp = TRUE
    flag.doSettings = FALSE
    flag.doPopUp = FALSE
    _SNDSTOP S(39)
    _SNDVOL S(39), .21 '            reset volume for next time
    soundOn
    IF NOT flag.doFF AND NOT flag.doSaucers THEN turnOnChecks
    _FONT 16
END SUB
' -----------------------------------------

SUB shipBoom ()

    SHARED AS INTEGER redd, gren, blue, boomNum
    SHARED AS LONG timer1

    killNoises
    IF NOT flag.shipBoomDone THEN
        ship.inventory = ship.inventory - 1 '           moved this above the IF below
        flag.shipBoomDone = TRUE
    END IF
    flag.doShip = FALSE
    flag.checkFSC = FALSE '             check for ship collion
    flag.doSparks = TRUE: boomNum = 15: redd = 233: gren = 227: blue = 61 ' 233, 227, 61 yellow
    flag.doCircle = FALSE '             sometimes created an artifact w/o this
    _SNDPLAY S(INT(RND * 3 + 4)) '
    IF ship.inventory > -1 THEN
        TIMER(timer1) ON ' <<<<<<<<<
    END IF
END SUB
' -----------------------------------------

SUB wrapUp () '                     close up shop

    DIM c AS INTEGER
    SHARED AS LONG timer1, timer2, saucerScape, shipImg
    SHARED AS LONG microMask, miniMask, starScape

    FOR c = 0 TO UBOUND(I) '        freeImages
        _FREEIMAGE I(c)
    NEXT c

    FOR c = 1 TO UBOUND(HDWimg) '   free hardware image array
        IF HDWimg(c) <> -1 AND HDWimg(c) <> 0 THEN _FREEIMAGE HDWimg(c) ' needed to add checking or it crashed...
    NEXT c

    FOR c = 0 TO UBOUND(S) '        close sounds
        _SNDCLOSE S(c)
    NEXT c

    FOR c = 1 TO UBOUND(VO) '       close voice-overs
        _SNDCLOSE VO(c)
    NEXT c

    _FREEIMAGE moonScape '          free other images, fonts, timers
    _FREEIMAGE viewScreen
    _FREEIMAGE saucerScape
    _FREEIMAGE shipImg
    _FREEIMAGE starScape
    _FREEIMAGE miniMask
    _FREEIMAGE microMask
    _FONT 16
    IF menlo > 0 THEN _FREEFONT menlo '
    IF menloBig > 0 THEN _FREEFONT menloBig
    IF modern > 0 THEN _FREEFONT modern
    IF modernBig > 0 THEN _FREEFONT modernBig '
    IF modernBigger > 0 THEN _FREEFONT modernBigger
    TIMER(timer1) FREE
    TIMER(timer2) FREE
END SUB
' -----------------------------------------

SUB endGame () '

    STATIC AS INTEGER count, i
    SHARED AS _BYTE fadeIt
    DIM AS INTEGER j, k
    DIM AS SINGLE exVol, changer
    DIM a$

    a$ = "YOU USED UP ALL YOUR DRONES. GAME OVER!"
    _SNDSTOP S(30) '                                        happy keeps playing
    killChecks
    flag.doPopUp = FALSE

    count = count + 1
    _FONT menloBig
    COLOR C(14)
_PRINTSTRING (_WIDTH / 2 - (_PRINTWIDTH(a$) / 2),_
_HEIGHT / 2), a$
    _FONT 16

    IF NOT fadeIt THEN
        FOR i = 15 TO 32
            IF _SNDPLAYING(S(i)) THEN
                fadeIt = TRUE
                EXIT FOR
            END IF
        NEXT i
    END IF

    IF fadeIt THEN
        SELECT CASE i
            CASE 15: exVol = .32: changer = -.003 '         comet fuzz
            CASE 17: exVol = .035: changer = -.00025 '      grid loop
            CASE 28: exVol = .052: changer = -.0003 '       harvest loop
            CASE 29: exVol = .4: changer = -.003 '     /    comet loop
            CASE 30: exVol = .006: changer = -.00004 '      happy landing loop
            CASE 31: exVol = .05: changer = -.0002 '        saucer loop
            CASE 32: exVol = .007: changer = -.00004 '      force field loop
        END SELECT
    END IF

    IF fadeIt THEN SndFade2 S(i), changer, 0, exVol, 0

    FOR j = 1 TO UBOUND(VO)
        IF _SNDPLAYING(VO(j)) THEN _SNDSTOP VO(j) '         fade voice-overs flag
    NEXT j

    IF count > 220 THEN
        FOR k = 0 TO 255 STEP 4
            LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, k), BF '  fade out
            _DISPLAY
            _LIMIT 50 '
        NEXT
        highScore '                                         check for hiScore and/or display it
        wrapUp '                                            close program
        SYSTEM
    END IF

    _FONT 16
END SUB
' -----------------------------------------

SUB highScore () '

    DIM AS _BYTE c, d, addYrName, toggle
    DIM AS INTEGER i, fileScore, fileKillRatio, fileTimeInBox
    DIM AS STRING filePlayer
    SHARED AS INTEGER killRatio, cageTime
    SHARED AS LONG starScape
    DIM a$, b$, c$, d$, newName$
    DIM AS LONG virtual
    DIM AS SINGLE count

    virtual = _NEWIMAGE(1280, 720, 32)
    _MOUSEHIDE

    FOR i = 0 TO UBOUND(S)
        _SNDPAUSE S(i)
    NEXT i

    IF _FILEEXISTS("scores.txt") THEN
        OPEN "scores.txt" FOR INPUT AS #1

        '   read high scores from file to hiScore array

        FOR c = 0 TO 4
            INPUT #1, filePlayer, fileScore, fileKillRatio, fileTimeInBox
            hiScore(c).player = filePlayer
            hiScore(c).score = fileScore
            hiScore(c).kRatio = fileKillRatio
            hiScore(c).timeInBox = fileTimeInBox
        NEXT c
    END IF

    OPEN "temp.txt" FOR OUTPUT AS #2

    a$ = "CONGRATS! YOU MADE IT ONTO THE HIGH SCORE BOARD!"
    b$ = "Enter your name below to commemorate this moment forever"
    c$ = "15 character max - hit 'RETURN' when done"

    '   check for high score

    IF _FILEEXISTS("scores.txt") THEN
        IF score > hiScore(4).score AND score > 0 THEN '            if new score is > lowest HSBoard entry then
            addYrName = TRUE
            _SNDPLAY S(20) '     zap sound
        END IF
    ELSE IF score > 0 THEN
            addYrName = TRUE
            _SNDPLAY S(20)
        END IF
    END IF

    _KEYCLEAR

    IF addYrName THEN '                                             print strings
        CLS
        LINE (0, 0)-(_WIDTH - 1, _HEIGHT - 1), C(3), B
        LINE (30, 30)-(_WIDTH - 31, _HEIGHT - 31), C(3), B
        PAINT (10, 10), C(5), C(3)
        _FONT menloBig
        COLOR C(14)
        _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(a$) / 2, 100), a$
        _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(b$) / 2, 160), b$
        COLOR C(3)
        _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(c$) / 2, 190), c$
        _DISPLAY
        toggle = 1
        i = 0
        DO '                                                        name input loop
            _LIMIT 30
            i = i + 1
            IF i MOD 20 = 0 THEN toggle = -toggle
            d$ = INKEY$
            IF d$ = CHR$(13) THEN EXIT DO '                         return = done
            IF d$ = CHR$(8) THEN '                                  if backspace is pressed...
                newName$ = MID$(newName$, 1, LEN(newName$) - 1)
            ELSE
                newName$ = newName$ + d$
            END IF
            LINE (500, 290)-(800, 340), C(0), BF '                  erasure box for name
            COLOR C(4)
            _FONT menloBig
            _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(newName$) / 2 - 14, 300), newName$ '     display new name
            IF LEN(newName$) < 1 THEN
                COLOR C(14)
                _PRINTSTRING (_WIDTH / 2 - 40, 300), CHR$(62) '       ">"
                IF toggle = 1 THEN LINE (600, 290)-(700, 320), C(0), BF '   flashing prompt
            END IF

            _FONT 16
            _DISPLAY
        LOOP
        newName$ = _TRIM$(MID$(newName$, 1, 15)) '                          limit to 15 characters
    END IF

    '   load latest results from game play to index 6 in array

    hiScore(5).score = score
    hiScore(5).player = newName$
    hiScore(5).kRatio = killRatio
    hiScore(5).timeInBox = cageTime
    d = 5

    '   swap the positions

    IF addYrName THEN
        FOR c = 4 TO 0 STEP -1
            IF hiScore(d).score > hiScore(c).score THEN
                SWAP hiScore(d).score, hiScore(c).score
                SWAP hiScore(d).player, hiScore(c).player
                SWAP hiScore(d).kRatio, hiScore(c).kRatio
                SWAP hiScore(d).timeInBox, hiScore(c).timeInBox
                d = d - 1
            ELSE EXIT FOR
            END IF
        NEXT c
    END IF

    '   write adjusted rankings to file

    IF _FILEEXISTS("scores.txt") THEN CLOSE #1

    IF addYrName THEN
        IF _FILEEXISTS("scores.txt") THEN KILL "scores.txt"
        FOR c = 0 TO 4
            WRITE #2, hiScore(c).player, hiScore(c).score, hiScore(c).kRatio, hiScore(c).timeInBox
        NEXT c
        CLOSE #2
        NAME "temp.txt" AS "scores.txt" '                       tidy up

        IF _FILEEXISTS("temp.txt") THEN KILL "temp.txt"
    END IF

    '   display results to virtual screen for reuse below

    IF hiScore(0).score = 0 THEN EXIT SUB '                     skip displaying of high score if it's all zeros

    _DEST virtual
    CLS
    _PUTIMAGE , starScape

    LINE (350, 150)-(940, 375), C(8), B
    LINE (347, 147)-(943, 378), C(10), B
    LINE (344, 144)-(946, 381), C(9), B
    _FONT menloBig
    COLOR C(9)
    _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH("HIGH SCORE BOARD") / 2, 90), "HIGH SCORE BOARD"
    COLOR C(14)
    _FONT menlo
    _PRINTSTRING (365, 172), "  Player" + SPACE$(11) + "     Score" + "         Kill %       Cage Time"
    COLOR C(4)
    _FONT 16
    '                                 CAN'T USE ANY OLD FONT WITH PRINT USING!! <<<<<<<<<<<<
    FOR c = 0 TO 4
        LOCATE 14 + c * 2, 48
        PRINT c + 1
        LOCATE 14 + c * 2, 50
        PRINT ") "; hiScore(c).player
        LOCATE 14 + c * 2, 74
        PRINT USING "#####"; hiScore(c).score
        LOCATE 14 + c * 2, 91
        PRINT USING "##%"; hiScore(c).kRatio
        LOCATE 14 + c * 2, 105
        PRINT USING "### secs"; hiScore(c).timeInBox
    NEXT c

    _DISPLAY '
    _DEST 0 ' -----------------------------------------------
    CLS '

    FOR i = 255 TO 0 STEP -4 '                                  fade in scene
        _LIMIT 130 '
        _PUTIMAGE , virtual
        LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, i), BF '  increase black box transparency
        _DISPLAY
    NEXT

    _SNDLOOP S(28) '                                            restart harvest loop
    count = -140 '                                              put alien off-left edge
    _KEYCLEAR
    _FONT menlo
    COLOR C(14)

    DO
        CLS
        _PUTIMAGE , virtual
        count = count + 1.35
        IF _KEYHIT THEN EXIT DO
        IF NOT flag.stopp THEN SndFade2 S(28), .00034, .05, 0, 0 '      problematic...
        IF flag.stopp THEN
            IF NOT _SNDPLAYING(S(28)) THEN '                            backup insurance to make it play...
                _SNDLOOP S(28)
                _SNDVOL S(28), .04
            END IF
        END IF
        _PUTIMAGE (-120 + count, 560), I(2) '                           alien ship image
        IF count > 1450 THEN count = -100

        LINE (0, 0)-(_WIDTH - 1, _HEIGHT - 1), C(3), B '                added blue border
        LINE (30, 30)-(_WIDTH - 31, _HEIGHT - 31), C(3), B
        PAINT (10, 10), C(5), C(3)
        _DISPLAY
        _LIMIT 44
    LOOP

    FOR i = 0 TO 255 STEP 4
        LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, i), BF '          quick fade out
        SndFade2 S(28), -.0006, 0, .00034, 0
        _DISPLAY
        _LIMIT 60 '
    NEXT

    _FREEIMAGE virtual
    _FONT 16
END SUB
' -----------------------------------------

SUB popUp ()

    SHARED AS INTEGER popCount
    STATIC AS _BYTE initd, oldFPS, painted, count ' DO I NEED OLDFPS ANYMORE, IT'S REGULATED BY THE MAIN LOOP.. <<<<<<<<<<<<<<<<<<< !!!!
    DIM a$
    SHARED AS _BYTE pop

    IF NOT initd THEN
        oldFPS = FPS
        killChecks '                                collision checks off
        initd = TRUE
    END IF

    _PRINTMODE _KEEPBACKGROUND

    ' slow & stop game play while poppedUp

    IF FPS > 10 THEN FPS = FPS - 1
    IF FPS <= 10 THEN hold = TRUE '

    a$ = "ARE YOU SURE YOU WANT TO EXIT?"

    IF hold THEN
        IF count < 10 THEN count = count + 1 '      use 'count' to track cycles, paint popUp only once after the hold so it's translucent not solid red
        WHILE _MOUSEINPUT: WEND '                   needs mouseinput cuz main loop is on hold
        mX = _MOUSEX
        mY = _MOUSEY
    END IF

    IF count < 2 THEN
        _FONT modernBigger
        IF popCount < 254 THEN popCount = popCount + 6
        LINE (_WIDTH / 2 - 200, _HEIGHT / 2 - 60)-(_WIDTH / 2 + 200, _HEIGHT / 2 + 100), C(15), B
        IF NOT hold THEN PAINT (_WIDTH / 2, _HEIGHT / 2), _RGB32(255, 0, 0, 40), C(15)
        IF hold AND NOT painted THEN PAINT (_WIDTH / 2, _HEIGHT / 2), _RGB32(255, 0, 0, 40), C(15): painted = TRUE

        IF NOT flag.doSaucers THEN
            COLOR _RGB32(190, 255, 0, popCount)
        ELSE COLOR C(4)
        END IF

        _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(a$) / 2, _HEIGHT / 2 - 40), a$

        IF NOT flag.doSaucers THEN
            COLOR _RGB32(0, 255, 0, popCount)
        ELSE COLOR C(4)
        END IF

        LINE (_WIDTH / 2 - 150, _HEIGHT / 2)-(_WIDTH / 2 - 30, _HEIGHT / 2 + 30), C(15), B '        yes / no boxes
        LINE (_WIDTH / 2 + 30, _HEIGHT / 2)-(_WIDTH / 2 + 150, _HEIGHT / 2 + 30), C(15), B '
        LINE (_WIDTH / 2 - 150, _HEIGHT / 2 + 50)-(_WIDTH / 2 - 30, _HEIGHT / 2 + 80), C(15), B '   back 2 intro button
        LINE (_WIDTH / 2 + 30, _HEIGHT / 2 + 50)-(_WIDTH / 2 + 150, _HEIGHT / 2 + 80), C(15), B '   settings button
        _PRINTSTRING (_WIDTH / 2 - 103, _HEIGHT / 2 + 10), "YES"
        _PRINTSTRING (_WIDTH / 2 + 80, _HEIGHT / 2 + 10), "NO"
        _PRINTSTRING (_WIDTH / 2 - 142, _HEIGHT / 2 + 60), "INTRO SCREEN"
        _PRINTSTRING (_WIDTH / 2 + 57, _HEIGHT / 2 + 60), "SETTINGS"
        IF flag.doSaucers THEN _PUTIMAGE , viewScreen
        _DISPLAY
    END IF

    IF _MOUSEBUTTON(1) THEN '                                                   ** MOUSE INPUT **
        IF mY > _HEIGHT / 2 - 2 AND mY < _HEIGHT / 2 + 32 THEN
            IF mX > _WIDTH / 2 - 152 AND mX < _WIDTH / 2 - 28 THEN '            yes button
                PAINT (_WIDTH / 2 - 120, _HEIGHT / 2 + 10), C(3), C(15)
                _DISPLAY
                _DELAY .1
                wrapUp
                SYSTEM
            ELSE IF mX > _WIDTH / 2 + 28 AND mX < _WIDTH / 2 + 152 THEN '  '    no button
                    PAINT (_WIDTH / 2 + 120, _HEIGHT / 2 + 10), C(3), C(15)
                    _DISPLAY
                    _DELAY .1
                    _MOUSEHIDE
                    flag.doPopUp = FALSE
                    IF NOT flag.doFF AND NOT flag.doSaucers THEN turnOnChecks
                    flag.speedUp = TRUE
                    hold = FALSE
                    initd = FALSE
                    painted = FALSE
                    pop = FALSE
                    popCount = 0
                    count = 0
                END IF
            END IF
        END IF

        IF mY > _HEIGHT / 2 + 48 AND mY < _HEIGHT / 2 + 82 THEN
            IF mX > _WIDTH / 2 - 152 AND mX < _WIDTH / 2 - 28 THEN '            back to intro button
                PAINT (_WIDTH / 2 - 100, _HEIGHT / 2 + 60), C(3), C(15)
                _DISPLAY
                _DELAY .1
                FPS = oldFPS
                hold = FALSE
                flag.doPopUp = FALSE
                pop = FALSE
                popCount = 0
                count = 0
                initd = FALSE
                painted = FALSE
                soundsOff
                splashPage
            ELSE
                IF mX > _WIDTH / 2 + 28 AND mX < _WIDTH / 2 + 152 THEN '        settings button
                    PAINT (_WIDTH / 2 + 50, _HEIGHT / 2 + 60), C(3), C(15)
                    _DISPLAY
                    _DELAY .1
                    FPS = oldFPS
                    hold = FALSE '
                    flag.doPopUp = FALSE
                    pop = FALSE
                    popCount = 0
                    count = 0
                    initd = FALSE
                    painted = FALSE
                    soundsOff
                    settings
                END IF
            END IF
        END IF
    END IF

    IF flag.landingTime AND NOT flag.doFF AND NOT flag.doPopUp THEN '   put the ship back at the top
        ship.x = CENTX
        ship.y = 20
        ship.Vx = 0
        ship.Vy = 0
    END IF

    _KEYCLEAR
    _FONT 16
END SUB
' -----------------------------------------
SUB killChecks ()
    flag.checkFSC = FALSE
    flag.checkCometCollisions = FALSE
    flag.checkGridCollisions = FALSE
END SUB
' ---------------------
SUB turnOnChecks ()
    flag.checkFSC = TRUE
    flag.checkCometCollisions = TRUE
    flag.checkGridCollisions = TRUE
END SUB
' -----------------------------------------
SUB soundsOff ()
    DIM AS INTEGER c
    FOR c = 15 TO 38
        _SNDSTOP S(c)
    NEXT c
    FOR c = 1 TO UBOUND(VO)
        _SNDSTOP VO(c)
    NEXT c
END SUB
' -----------------------------------------
SUB soundOn () '
    IF flag.doRocks THEN _SNDLOOP S(28)
    IF flag.doComets THEN
        _SNDLOOP S(15)
        _SNDLOOP S(29)
    END IF
    IF flag.doGrid THEN _SNDLOOP S(17)
    IF flag.landingTime THEN _SNDLOOP S(30)
    IF flag.doSaucers THEN _SNDLOOP S(31)
    IF flag.doFF THEN _SNDLOOP S(32)
END SUB
' -----------------------------------------





