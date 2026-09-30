_TITLE "Fast Zap'em : Berzerkotron v0.46 by Softintheheadware, 2026 (Made with QB64PE!)"
' -----------------------------------------------------------------------------------------
' BERZERKOTRON by Softintheheadware (2026)
' -----------------------------------------------------------------------------------------
' About this game
' * An extensive mod of QBzerk by Terry Ritchie
' * Created with help from Google Gemini

' -----------------------------------------------------------------------------------------
' Notes
' -----------------------------------------------------------------------------------------
' * This version should fix a bug where if you map game controllers and start a game,
'   sometimes the game crashed with an Illegal Function Call at line 859.
' * In "Robotron" firing mode, you map a 2nd controller to use for firing.
'   Shoot by aiming the stick in whichever direction.
' * In "Robotron" firing mode, if anyone DOESN'T want "robotron" style firing,
'   pressing Shift+{1-8} to map their controller will make it map "Berzerk" style controls.

' #############################################################################
' GLOBAL DECLARATIONS
' #############################################################################
DEFINT A-Z

' =============================================================================
' GLOBAL CONSTANTS
' =============================================================================
CONST MAZE_START    = -1
CONST AFTERLIFE     = -2
CONST NORTH         = 0
CONST SOUTH         = 1
CONST EAST          = 2
CONST WEST          = 3
CONST LOAD          = 0
CONST SAVE          = 1
CONST NORMAL        = 0
CONST TRANSITIONING = 1
CONST ZAPPED        = 2
CONST FIRING        = 3

' Resource files
CONST CSOUNDFOLDER = "sounds"
CONST CIMAGEFOLDER = "images"

' Input Mapper Constants
CONST CINPUTNONE   = 0
CONST CINPUTKEY    = 1
CONST CINPUTBUTTON = 2
CONST CINPUTAXIS   = 3

CONST CMAXBUTTONS     = 12
CONST CMAXAXIS        = 8
CONST CMAXCONTROLLERS = 8
CONST CMAXPLAYERS     = 8

CONST CINPUTUP        = 1
CONST CINPUTDOWN      = 2
CONST CINPUTLEFT      = 3
CONST CINPUTRIGHT     = 4
CONST CINPUTBUTTON1   = 5
CONST CINPUTFIREUP    = 6
CONST CINPUTFIREDOWN  = 7
CONST CINPUTFIRELEFT  = 8
CONST CINPUTFIRERIGHT = 9

' =============================================================================
' USER-DEFINED DATA TYPES (UDTs)
' =============================================================================
TYPE OTTO
    x       AS INTEGER
    y       AS INTEGER
    xdir    AS INTEGER
    ydir    AS INTEGER
    yoffset AS INTEGER
    yvel    AS INTEGER
    fcount  AS INTEGER
    acount  AS INTEGER
    alive   AS INTEGER
    cell    AS INTEGER
    bounce  AS INTEGER
END TYPE

TYPE LEVEL
    points   AS INTEGER
    rcolor   AS _UNSIGNED LONG
    bullets  AS INTEGER
    rbullets AS INTEGER
    bspeed   AS INTEGER
END TYPE

TYPE SETTINGS
    size             AS INTEGER
    full             AS INTEGER
    extra            AS INTEGER
    iddqd            AS INTEGER
    god              AS INTEGER
    eye              AS INTEGER
    eyedir           AS INTEGER
    numPlayers       AS INTEGER ' 1 TO 8
    hasRobots        AS INTEGER ' 1 = Robots On, 0 = No Robots(Shootout)
    maxPlayerBullets AS INTEGER
    maxRobots        AS INTEGER
    maxRobotBullets  AS INTEGER
    fireStyle        AS INTEGER ' 0 = BERZERK, 1 = ROBOTRON
    wallsDeadly      AS INTEGER ' 1 = DEADLY, 0 = SAFE
END TYPE

TYPE LAWS
    text1 AS STRING * 32
    text2 AS STRING * 32
    text3 AS STRING * 32
    text4 AS STRING * 32
    y     AS INTEGER
    r     AS INTEGER
    g     AS INTEGER
    b     AS INTEGER
    m     AS INTEGER
    s     AS LONG
END TYPE

TYPE PIECES
    image AS LONG
    x     AS SINGLE
    y     AS SINGLE
    xdir  AS SINGLE
    ydir  AS SINGLE
END TYPE

TYPE bullets
    x     AS INTEGER
    y     AS INTEGER
    oldx  AS INTEGER
    oldy  AS INTEGER
    xdir  AS INTEGER
    ydir  AS INTEGER
    alive AS INTEGER
    who   AS INTEGER '-1 TO - 8 = Player 1..8, > 0 = Robot Index 1..15
END TYPE

TYPE PILLARS
    x AS INTEGER
    y AS INTEGER
END TYPE

TYPE Player
    x       AS INTEGER
    y       AS INTEGER
    xdir    AS SINGLE
    ydir    AS SINGLE
    cell    AS INTEGER
    dir     AS INTEGER
    alive   AS INTEGER
    zcolor  AS INTEGER
    zcount  AS INTEGER
    chicken AS INTEGER
    ccount  AS INTEGER
    score   AS LONG
    lives   AS INTEGER
    tcount  AS INTEGER
    taunt   AS INTEGER
    bullets AS INTEGER
    bcount  AS INTEGER
    mode    AS INTEGER
    awarded AS INTEGER
    FIX     AS INTEGER

    ' Controls state
    moveUp    AS INTEGER
    moveDown  AS INTEGER
    moveLeft  AS INTEGER
    moveRight AS INTEGER
    button1   AS INTEGER
    fireUp    AS INTEGER
    fireDown  AS INTEGER
    fireLeft  AS INTEGER
    fireRight AS INTEGER
END TYPE

TYPE Robots
    x        AS INTEGER
    y        AS INTEGER
    zx       AS INTEGER
    zy       AS INTEGER
    xdir     AS INTEGER
    ydir     AS INTEGER
    cell     AS INTEGER
    dir      AS INTEGER
    alive    AS INTEGER
    hit      AS INTEGER
    eye      AS INTEGER
    eyedir   AS INTEGER
    ecount   AS INTEGER
    fcount   AS INTEGER
    bullets  AS INTEGER
    bcount   AS INTEGER
    xmode    AS INTEGER
    ymode    AS INTEGER
    xmcount  AS INTEGER
    ymcount  AS INTEGER
    distance AS INTEGER
END TYPE

TYPE HIGH
    n AS STRING * 3
    s AS LONG
END TYPE

TYPE ROOM
    x         AS INTEGER
    y         AS INTEGER
    LEVEL     AS INTEGER
    reallevel AS INTEGER
    bonus     AS INTEGER
    Robots    AS INTEGER
    killed    AS INTEGER
    bullets   AS INTEGER
    DELAY     AS INTEGER
    BLINK     AS INTEGER
    entryDoor AS INTEGER
END TYPE

TYPE ControlInputType
    device AS INTEGER
    typ    AS INTEGER
    code   AS INTEGER
    value  AS INTEGER
    repeat AS INTEGER
END TYPE

TYPE ControllerType
    buttonCount AS INTEGER
    axisCount   AS INTEGER
END TYPE

' =============================================================================
' GLOBAL VARS
' =============================================================================
DIM SHARED m_ProgramPath$         : m_ProgramPath$ = LEFT$(COMMAND$(0), _INSTRREV(COMMAND$(0), "\"))    ' executable path
DIM SHARED m_ProgramName$         : m_ProgramName$ = MID$(COMMAND$(0), _INSTRREV(COMMAND$(0), "\") + 1) ' executable filename
DIM SHARED m_sDebugFile AS STRING : m_sDebugFile = m_ProgramPath$ + m_ProgramName$ + ".txt"

DIM SHARED Robot(256) AS Robots
DIM SHARED P(35) AS PILLARS
DIM SHARED Player(1 TO 8) AS Player
DIM SHARED HIGH(10) AS HIGH
DIM SHARED ROOM    AS ROOM
DIM SHARED Bullet(512) AS bullets
DIM SHARED Piece(256, 13) AS PIECES
DIM SHARED Law(4) AS LAWS
DIM SHARED Setting AS SETTINGS
DIM SHARED LEVEL(14) AS LEVEL
DIM SHARED OTTO    AS OTTO

DIM SHARED VisitedRooms(255, 255) AS INTEGER
DIM SHARED ForcedExit   AS INTEGER
DIM SHARED GamePaused   AS INTEGER
DIM SHARED KeySpaceHeld AS INTEGER

' Input Mapper Globals
DIM SHARED m_arrControlMap(1 TO 8, 1 TO 9) AS ControlInputType
DIM SHARED m_arrController(1 TO 8) AS ControllerType
DIM SHARED m_arrButtonCode(1 TO 99) AS INTEGER
DIM SHARED m_arrButtonKey(1 TO 99) AS STRING
DIM SHARED m_arrButtonKeyDesc(0 TO 512) AS STRING
DIM SHARED m_bHaveMapping    AS INTEGER
DIM SHARED m_ControlMapFileName$
DIM SHARED ExitGameLoop      AS INTEGER
DIM SHARED m_MenuSelectIndex AS INTEGER

' Graphics & Fonts
DIM SHARED MainScreen&
DIM SHARED Font72&, Font48&, Font36&, Font24&, Font14&, Font12&, Font10&
DIM SHARED Pimage&(1 TO 8, 9, -1 TO 1)                                                                  ' Player 1..8 Tinted Sprites
DIM SHARED Pmask&(1 TO 8, 9, -1 TO 1)
DIM SHARED PmaskTest&
DIM SHARED Rimage&(7, -1 TO 1)
DIM SHARED Rmask&
DIM SHARED BigRobot&(4)
DIM SHARED Boom&(3)
DIM SHARED BoomMask&
DIM SHARED Flash&(4)
DIM SHARED FlashMask&
DIM SHARED BlankRoom&
DIM SHARED WorkRoom&
DIM SHARED Maze&
DIM SHARED Maze3D&
DIM SHARED Life&
DIM SHARED Font&(62)
DIM SHARED Otto&(5)
DIM SHARED QBZerk64l&
DIM SHARED QBzerk64s&
DIM SHARED ICON&
DIM SHARED IconOtto&
DIM SHARED OttoMask&

' Sounds
DIM SHARED Taunt&(7, 5, 3)
DIM SHARED Ctaunt&
DIM SHARED MustNotEscape&(3, 3)
DIM SHARED CoinDetected&(3)
DIM SHARED FightLikeRobot&(3)
DIM SHARED Rshoot&
DIM SHARED Pshoot&
DIM SHARED Killed&
DIM SHARED GotTheHumanoid&
DIM SHARED IntruderAlert&
DIM SHARED FootStep&
DIM SHARED IntroMusic&
DIM SHARED Coin&
DIM SHARED Extra&
DIM SHARED Credits%
DIM SHARED Cheat$

' Player Palette Colors
DIM SHARED PlayerColor&(1 TO 8)

' #############################################################################
' MAIN PROGRAM BEGINS
' #############################################################################
SETSCREENMODE
INITDEFAULTS
InitKeyboardButtonCodes
SETUPDEFAULTCONTROLS
LOADSETTINGS
LOADASSETS

' =============================================================================
' MAIN LOOP
' =============================================================================
DO
    ExitGameLoop = _FALSE

    ' The INTRO screen handles its own configuration loops and only exits when PLAY is pressed or ESC is pressed
    INTRO
    IF ExitGameLoop THEN EXIT DO

    RESETGAME
    ExitGameLoop = _FALSE
    GamePaused   = _FALSE

    DO
        DO
            _LIMIT 30
            _DEST WorkRoom&
            _PUTIMAGE(0, 0), Maze&

            ' Pause Toggle via ASCII 32 (Spacebar)
            IF _KEYDOWN(32) THEN
                IF NOT KeySpaceHeld THEN
                    GamePaused   = NOT GamePaused
                    KeySpaceHeld = _TRUE
                    _KEYCLEAR ' CLEAR buffer TO prevent instant TOGGLE loops
                END IF
            ELSE
                KeySpaceHeld = _FALSE
            END IF

            IF NOT GamePaused THEN
                ' Input and updates for active players
                FOR p% = 1 TO Setting.numPlayers
                    IF Player(p%).alive THEN
                        READPLAYERINPUT p%
                        UPDATEPLAYER p%
                    END IF
                NEXT p%

                IF Setting.hasRobots = 1 THEN UPDATEROBOTS
                UPDATEBULLETS
            END IF

            ' EXIT
            IF _KEYDOWN(27) THEN
                ExitGameLoop = _TRUE
                EXIT DO
            END IF

            ' TOGGLE FULLSCREEN / WINDOWED
            IF _KEYDOWN(18176) THEN ' HOME
                IF NOT _FULLSCREEN THEN _FULLSCREEN _SQUAREPIXELS
            END IF
            IF _KEYDOWN(20224) THEN ' END
                IF _FULLSCREEN THEN _FULLSCREEN _OFF
            END IF

            ' Draw robots
            IF Setting.hasRobots = 1 THEN DRAWROBOTS

            ' Draw players
            FOR p% = 1 TO Setting.numPlayers
                IF Player(p%).alive OR Player(p%).mode = ZAPPED THEN
                    DRAWPLAYER p%, Player(p%).mode
                END IF
            NEXT p%

            IF NOT GamePaused THEN CHECKFORTRANSITION
            IF NOT GamePaused AND Setting.hasRobots = 1 THEN RANDOMTAUNT

            _DEST MainScreen&
            CLS
            ' Display unscaled 736x616 rendering onto Main Screen 1024x768
            _PUTIMAGE(144, 76) -(879, 691), WorkRoom&

            UPDATESCORE
            _DISPLAY

            ' Check round state
            DIM aliveCount%, targetCount%
            aliveCount% = 0
            FOR p% = 1 TO Setting.numPlayers
                IF Player(p%).alive THEN aliveCount% = aliveCount% + 1
            NEXT p%

            targetCount% = 0
            ' Only end the round on a single survivor if we are in Shootout mode (no robots)
            IF Setting.hasRobots = 0 AND Setting.numPlayers > 1 THEN targetCount% = 1
        LOOP UNTIL aliveCount% <= targetCount%

        IF ExitGameLoop THEN EXIT DO

        _DELAY 1
        IF Setting.hasRobots = 0 AND Setting.numPlayers > 1 THEN
            ' Announce Winner in Shootout mode
            DIM winner%
            FOR p% = 1 TO Setting.numPlayers
                IF Player(p%).alive THEN winner% = p%
            NEXT p%
            _DEST MainScreen&
            _FONT Font36&
            IF winner% > 0 THEN
                COLOR PlayerColor&(winner%) : _PRINTSTRING(280, 360), "PLAYER " + LTrim$(Str$(winner%)) + " WINS!"
            ELSE
                COLOR _RGB32(255, 255, 255) : _PRINTSTRING(400, 360), "DRAW!"
            END IF
            _DISPLAY
            _DELAY 3
        END IF

        CALL RESETROUND
    LOOP UNTIL ALLPLAYERSOUT

    IF ExitGameLoop THEN
        _KEYCLEAR
        _DELAY 1
    END IF
LOOP

' #############################################################################
' SUBROUTINES
' #############################################################################

SUB POSITIONPLAYERS(Heading%, TriggerPlayer%)
    DIM arrPlayerMap(1 TO 8) AS INTEGER
    DIM i%, r%, c%, px%, py%, pIdx%
    FOR i% = 1 TO 8 : arrPlayerMap(i%) = i% : NEXT i%

    IF TriggerPlayer% > 4 AND TriggerPlayer% <= 8 THEN
        arrPlayerMap(1)              = TriggerPlayer%
        arrPlayerMap(TriggerPlayer%) = 1
    END IF

    FOR i% = 1 TO Setting.numPlayers
        pIdx% = arrPlayerMap(i%)
        r%    = (i% - 1) \ 4
        c%    = (i% - 1) MOD 4

        IF Setting.hasRobots = 1 THEN
            SELECT CASE Heading%
                CASE AFTERLIFE, MAZE_START, NORTH ' Enter from SOUTH
                    px% = 324 + c% * 24
                    py% = 538 + r% * 36
                CASE SOUTH                        ' Enter from NORTH
                    px% = 324 + c% * 24
                    py% = 46 - r% * 36
                CASE EAST                         ' Enter from WEST
                    px% = 36 - r% * 24
                    py% = 238 + c% * 36
                CASE WEST                         ' Enter from EAST
                    px% = 684 + r% * 24
                    py% = 238 + c% * 36
            END SELECT
        ELSE
            ' Shootout mode specific individual door spawns
            SELECT CASE pIdx%
                CASE 1 : px% = 12  : py% = 130
                CASE 2 : px% = 708 : py% = 130
                CASE 3 : px% = 214 : py% = 10
                CASE 4 : px% = 214 : py% = 570
                CASE 5 : px% = 12  : py% = 480
                CASE 6 : px% = 708 : py% = 480
                CASE 7 : px% = 510 : py% = 10
                CASE 8 : px% = 510 : py% = 570
            END SELECT
        END IF

        IF Player(pIdx%).alive THEN
            Player(pIdx%).x = px%
            Player(pIdx%).y = py%
            IF Setting.hasRobots = 1 THEN
                IF Heading% = EAST THEN Player(pIdx%).dir = 1
                IF Heading% = WEST THEN Player(pIdx%).dir = -1
                IF Heading% = NORTH OR Heading% = SOUTH OR Heading% = MAZE_START OR Heading% = AFTERLIFE THEN Player(pIdx%).dir = 1
            ELSE
                IF px% < 368 THEN Player(pIdx%).dir = 1 ELSE Player(pIdx%).dir = -1
            END IF
        END IF
    NEXT i%
END SUB

SUB INITDEFAULTS()
    PlayerColor&(1) = _RGB32(0, 255, 0)
    PlayerColor&(2) = _RGB32(255, 255, 0)
    PlayerColor&(3) = _RGB32(255, 128, 0)
    PlayerColor&(4) = _RGB32(255, 0, 0)
    PlayerColor&(5) = _RGB32(255, 0, 255)
    PlayerColor&(6) = _RGB32(128, 0, 255)
    PlayerColor&(7) = _RGB32(0, 100, 255)
    PlayerColor&(8) = _RGB32(0, 255, 255)

    Setting.numPlayers       = 8
    Setting.hasRobots        = 1
    Setting.size             = 3
    Setting.maxPlayerBullets = 2
    Setting.maxRobots        = 7
    Setting.maxRobotBullets  = 7
    Setting.fireStyle        = 0
    Setting.wallsDeadly      = 1

    LEVEL(1).points  = 250
    LEVEL(2).points  = 500
    LEVEL(3).points  = 1500
    LEVEL(4).points  = 3000
    LEVEL(5).points  = 4500
    LEVEL(6).points  = 6000
    LEVEL(7).points  = 7500
    LEVEL(8).points  = 10000
    LEVEL(9).points  = 12000
    LEVEL(10).points = 14000
    LEVEL(11).points = 16000
    LEVEL(12).points = 18000
    LEVEL(13).points = 20000
    LEVEL(14).points = 20000

    LEVEL(1).rcolor  = _RGB32(191, 191, 0)
    LEVEL(2).rcolor  = _RGB32(255, 0, 0)
    LEVEL(3).rcolor  = _RGB32(0, 191, 191)
    LEVEL(4).rcolor  = _RGB32(0, 255, 0)
    LEVEL(5).rcolor  = _RGB32(191, 0, 191)
    LEVEL(6).rcolor  = _RGB32(255, 255, 0)
    LEVEL(7).rcolor  = _RGB32(255, 255, 255)
    LEVEL(8).rcolor  = _RGB32(0, 191, 191)
    LEVEL(9).rcolor  = _RGB32(255, 0, 255)
    LEVEL(10).rcolor = _RGB32(191, 191, 191)
    LEVEL(11).rcolor = _RGB32(191, 191, 0)
    LEVEL(12).rcolor = _RGB32(255, 0, 0)
    LEVEL(13).rcolor = _RGB32(0, 255, 255)
    LEVEL(14).rcolor = _RGB32(0, 255, 255)

    LEVEL(1).bullets  = 0 : LEVEL(1).rbullets = 0  : LEVEL(1).bspeed = 0
    LEVEL(2).bullets  = 1 : LEVEL(2).rbullets = 1  : LEVEL(2).bspeed = 2
    LEVEL(3).bullets  = 2 : LEVEL(3).rbullets = 2  : LEVEL(3).bspeed = 2
    LEVEL(4).bullets  = 3 : LEVEL(4).rbullets = 3  : LEVEL(4).bspeed = 3
    LEVEL(5).bullets  = 4 : LEVEL(5).rbullets = 4  : LEVEL(5).bspeed = 3
    LEVEL(6).bullets  = 5 : LEVEL(6).rbullets = 5  : LEVEL(6).bspeed = 3
    LEVEL(7).bullets  = 1 : LEVEL(7).rbullets = 1  : LEVEL(7).bspeed = 5
    LEVEL(8).bullets  = 2 : LEVEL(8).rbullets = 2  : LEVEL(8).bspeed = 5
    LEVEL(9).bullets  = 3 : LEVEL(9).rbullets = 3  : LEVEL(9).bspeed = 5
    LEVEL(10).bullets = 4 : LEVEL(10).rbullets = 4 : LEVEL(10).bspeed = 5
    LEVEL(11).bullets = 5 : LEVEL(11).rbullets = 5 : LEVEL(11).bspeed = 6
    LEVEL(12).bullets = 5 : LEVEL(12).rbullets = 5 : LEVEL(12).bspeed = 6
    LEVEL(13).bullets = 8 : LEVEL(13).rbullets = 8 : LEVEL(13).bspeed = 6
    LEVEL(14).bullets = 8 : LEVEL(14).rbullets = 8 : LEVEL(14).bspeed = 6
END SUB

FUNCTION HexColor$(c AS _UNSIGNED LONG)
    DIM r$, g$, b$
    r$ = HEX$(_RED32(c))
    g$ = HEX$(_GREEN32(c))
    b$ = HEX$(_BLUE32(c))
    IF LEN(r$) = 1 THEN r$ = "0" + r$
    IF LEN(g$) = 1 THEN g$ = "0" + g$
    IF LEN(b$) = 1 THEN b$ = "0" + b$
    HexColor$ = "#" + r$ + g$ + b$
END FUNCTION

FUNCTION ParseHexColor~&(h$)
    DIM r%, g%, b%
    h$ = _TRIM$(h$)
    IF LEFT$(h$, 1) = "#" Then h$ = Mid$(h$, 2)
    IF LEN(h$) >= 6 THEN
        r%              = VAL("&H" + Mid$(h$, 1, 2))
        g%              = VAL("&H" + Mid$(h$, 3, 2))
        b%              = VAL("&H" + Mid$(h$, 5, 2))
        ParseHexColor~& = _RGB32(r%, g%, b%)
    ELSE
        ParseHexColor~& = _RGB32(255, 255, 255)
    END IF
END FUNCTION

SUB SAVESETTINGS()
    DIM ff%, p%, c%, dotPos%
    DIM iniFile$
    dotPos% = _INSTRREV(m_ProgramName$, ".")
    IF dotPos% > 0 THEN
        iniFile$ = m_ProgramPath$ + LEFT$(m_ProgramName$, dotPos% - 1) + ".ini"
    ELSE
        iniFile$ = m_ProgramPath$ + m_ProgramName$ + ".ini"
    END IF

    ff% = FREEFILE
    OPEN iniFile$ FOR OUTPUT AS #ff%

    PRINT #ff%, "[Settings]"
    PRINT #ff%, "numPlayers=" + LTrim$(Str$(Setting.numPlayers))
    PRINT #ff%, "hasRobots=" + LTrim$(Str$(Setting.hasRobots))
    PRINT #ff%, "maxPlayerBullets=" + LTrim$(Str$(Setting.maxPlayerBullets))
    PRINT #ff%, "maxRobots=" + LTrim$(Str$(Setting.maxRobots))
    PRINT #ff%, "maxRobotBullets=" + LTrim$(Str$(Setting.maxRobotBullets))
    PRINT #ff%, "fireStyle=" + LTrim$(Str$(Setting.fireStyle))
    PRINT #ff%, "wallsDeadly=" + LTrim$(Str$(Setting.wallsDeadly))
    PRINT #ff%, ""

    PRINT #ff%, "[PlayerColors]"
    FOR p% = 1 TO 8
        PRINT #ff%, "Player" + LTrim$(Str$(p%)) + "=" + HexColor$(PlayerColor&(p%))
    NEXT p%
    PRINT #ff%, ""

    PRINT #ff%, "[RobotColors]"
    FOR c% = 1 TO 14
        PRINT #ff%, "Robot" + LTrim$(Str$(c%)) + "=" + HexColor$(Level(c%).rcolor)
    NEXT c%
    PRINT #ff%, ""

    PRINT #ff%, "[Controls]"
    FOR p% = 1 TO 8
        PRINT #ff%, "P" + LTrim$(Str$(p%)) + "_UP=" + LTrim$(Str$(m_arrControlMap(p%, cInputUp).device)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputUp).typ)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputUp).code)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputUp).value))
        PRINT #ff%, "P" + LTrim$(Str$(p%)) + "_DOWN=" + LTrim$(Str$(m_arrControlMap(p%, cInputDown).device)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputDown).typ)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputDown).code)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputDown).value))
        PRINT #ff%, "P" + LTrim$(Str$(p%)) + "_LEFT=" + LTrim$(Str$(m_arrControlMap(p%, cInputLeft).device)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputLeft).typ)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputLeft).code)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputLeft).value))
        PRINT #ff%, "P" + LTrim$(Str$(p%)) + "_RIGHT=" + LTrim$(Str$(m_arrControlMap(p%, cInputRight).device)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputRight).typ)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputRight).code)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputRight).value))
        PRINT #ff%, "P" + LTrim$(Str$(p%)) + "_FIRE=" + LTrim$(Str$(m_arrControlMap(p%, cInputButton1).device)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputButton1).typ)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputButton1).code)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputButton1).value))
        PRINT #ff%, "P" + LTrim$(Str$(p%)) + "_FIREUP=" + LTrim$(Str$(m_arrControlMap(p%, cInputFireUp).device)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireUp).typ)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireUp).code)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireUp).value))
        PRINT #ff%, "P" + LTrim$(Str$(p%)) + "_FIREDOWN=" + LTrim$(Str$(m_arrControlMap(p%, cInputFireDown).device)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireDown).typ)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireDown).code)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireDown).value))
        PRINT #ff%, "P" + LTrim$(Str$(p%)) + "_FIRELEFT=" + LTrim$(Str$(m_arrControlMap(p%, cInputFireLeft).device)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireLeft).typ)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireLeft).code)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireLeft).value))
        PRINT #ff%, "P" + LTrim$(Str$(p%)) + "_FIRERIGHT=" + LTrim$(Str$(m_arrControlMap(p%, cInputFireRight).device)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireRight).typ)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireRight).code)) + "," + LTrim$(Str$(m_arrControlMap(p%, cInputFireRight).value))
    NEXT p%

    CLOSE #ff%
END SUB

SUB LOADSETTINGS()
    DIM ff%, dotPos%, eqPos%, comma1%, comma2%, comma3%
    DIM pNum%, ctrlType%
    DIM iniFile$, ln$, key$, VAL$

    dotPos% = _INSTRREV(m_ProgramName$, ".")
    IF dotPos% > 0 THEN
        iniFile$ = m_ProgramPath$ + LEFT$(m_ProgramName$, dotPos% - 1) + ".ini"
    ELSE
        iniFile$ = m_ProgramPath$ + m_ProgramName$ + ".ini"
    END IF

    IF NOT _FILEEXISTS(iniFile$) THEN EXIT SUB

    ff% = FREEFILE
    OPEN iniFile$ FOR INPUT AS #ff%
    WHILE NOT EOF(ff%)
        LINE INPUT #ff%, ln$
        ln$ = _TRIM$(ln$)
        IF LEFT$(ln$, 1) <> "[" And Len(ln$) > 0 Then
            eqPos% = INSTR(ln$, "=")
            IF eqPos% > 0 THEN
                KEY$ = UCASE$(_TRIM$(LEFT$(ln$, eqPos% - 1)))
                VAL$ = UCASE$(_TRIM$(MID$(ln$, eqPos% + 1)))

                SELECT CASE KEY$
                    CASE "NUMPLAYERS"       : Setting.numPlayers       = Val(val$)
                    CASE "HASROBOTS"        : Setting.hasRobots        = Val(val$)
                    CASE "MAXPLAYERBULLETS" : Setting.maxPlayerBullets = Val(val$)
                    CASE "MAXROBOTS"        : Setting.maxRobots        = Val(val$)
                    CASE "MAXROBOTBULLETS"  : Setting.maxRobotBullets  = Val(val$)
                    CASE "FIRESTYLE"        : Setting.fireStyle        = Val(val$)
                    CASE "WALLSDEADLY"      : Setting.wallsDeadly      = Val(val$)

                    CASE "PLAYER1" : PlayerColor&(1) = ParseHexColor~&(val$)
                    CASE "PLAYER2" : PlayerColor&(2) = ParseHexColor~&(val$)
                    CASE "PLAYER3" : PlayerColor&(3) = ParseHexColor~&(val$)
                    CASE "PLAYER4" : PlayerColor&(4) = ParseHexColor~&(val$)
                    CASE "PLAYER5" : PlayerColor&(5) = ParseHexColor~&(val$)
                    CASE "PLAYER6" : PlayerColor&(6) = ParseHexColor~&(val$)
                    CASE "PLAYER7" : PlayerColor&(7) = ParseHexColor~&(val$)
                    CASE "PLAYER8" : PlayerColor&(8) = ParseHexColor~&(val$)

                    CASE "ROBOT1"  : Level(1).rcolor  = ParseHexColor~&(val$)
                    CASE "ROBOT2"  : Level(2).rcolor  = ParseHexColor~&(val$)
                    CASE "ROBOT3"  : Level(3).rcolor  = ParseHexColor~&(val$)
                    CASE "ROBOT4"  : Level(4).rcolor  = ParseHexColor~&(val$)
                    CASE "ROBOT5"  : Level(5).rcolor  = ParseHexColor~&(val$)
                    CASE "ROBOT6"  : Level(6).rcolor  = ParseHexColor~&(val$)
                    CASE "ROBOT7"  : Level(7).rcolor  = ParseHexColor~&(val$)
                    CASE "ROBOT8"  : Level(8).rcolor  = ParseHexColor~&(val$)
                    CASE "ROBOT9"  : Level(9).rcolor  = ParseHexColor~&(val$)
                    CASE "ROBOT10" : Level(10).rcolor = ParseHexColor~&(val$)
                    CASE "ROBOT11" : Level(11).rcolor = ParseHexColor~&(val$)
                    CASE "ROBOT12" : Level(12).rcolor = ParseHexColor~&(val$)
                    CASE "ROBOT13" : Level(13).rcolor = ParseHexColor~&(val$)
                    CASE "ROBOT14" : Level(14).rcolor = ParseHexColor~&(val$)
                END SELECT

                ' Parse controls
                IF LEFT$(key$, 1) = "P" And Mid$(key$, 2, 1) >= "1" And Mid$(key$, 2, 1) <= "8" Then
                    pNum%     = VAL(MID$(key$, 2, 1))
                    ctrlType% = 0

                    IF INSTR(key$, "_UP") And Not InStr(key$, "FIRE") Then ctrlType% = cInputUp
                    IF INSTR(key$, "_DOWN") And Not InStr(key$, "FIRE") Then ctrlType% = cInputDown
                    IF INSTR(key$, "_LEFT") And Not InStr(key$, "FIRE") Then ctrlType% = cInputLeft
                    IF INSTR(key$, "_RIGHT") And Not InStr(key$, "FIRE") Then ctrlType% = cInputRight
                    IF INSTR(key$, "_FIRE") And Not InStr(key$, "FIREU") And Not InStr(key$, "FIRED") And Not InStr(key$, "FIREL") And Not InStr(key$, "FIRER") Then ctrlType% = cInputButton1
                    IF INSTR(key$, "_FIREUP") Then ctrlType% = cInputFireUp
                    IF INSTR(key$, "_FIREDOWN") Then ctrlType% = cInputFireDown
                    IF INSTR(key$, "_FIRELEFT") Then ctrlType% = cInputFireLeft
                    IF INSTR(key$, "_FIRERIGHT") Then ctrlType% = cInputFireRight

                    IF ctrlType% > 0 THEN
                        comma1% = INSTR(val$, ",")
                        comma2% = INSTR(comma1% + 1, val$, ",")
                        comma3% = INSTR(comma2% + 1, val$, ",")
                        IF comma1% > 0 AND comma2% > 0 THEN
                            m_arrControlMap(pNum%, ctrlType%).device = VAL(LEFT$(val$, comma1% - 1))
                            m_arrControlMap(pNum%, ctrlType%).typ    = VAL(MID$(val$, comma1% + 1, comma2% - comma1%-1))
                            IF comma3% > 0 THEN
                                m_arrControlMap(pNum%, ctrlType%).code  = VAL(MID$(val$, comma2% + 1, comma3% - comma2%-1))
                                m_arrControlMap(pNum%, ctrlType%).value = VAL(MID$(val$, comma3% + 1))
                            ELSE
                                m_arrControlMap(pNum%, ctrlType%).code  = VAL(MID$(val$, comma2% + 1))
                                m_arrControlMap(pNum%, ctrlType%).value = 0
                            END IF
                            m_bHaveMapping = _TRUE
                        END IF
                    END IF
                END IF
            END IF
        END IF
    WEND
    CLOSE #ff%
END SUB

FUNCTION IIF%(cond%, ifTrue%, ifFalse%)
    IF cond% THEN IIF% = ifTrue% ELSE IIF% = ifFalse%
END FUNCTION

FUNCTION ALLPLAYERSOUT%()
    DIM tot%, p%
    tot% = 0
    FOR p% = 1 TO Setting.numPlayers
        tot% = tot% + Player(p%).lives
    NEXT p%
    ALLPLAYERSOUT% = (tot% <= 0)
END FUNCTION

SUB RESETGAME()
    DIM p%, x%, y%
    FOR p% = 1 TO Setting.numPlayers
        Player(p%).lives   = 3
        Player(p%).score   = 0
        Player(p%).awarded = 0
    NEXT p%
    Room.level     = 1
    Room.reallevel = 1
    Setting.iddqd  = _FALSE
    Setting.god    = _FALSE

    FOR x% = 0 TO 255
        FOR y% = 0 TO 255
            VisitedRooms(x%, y%) = 0
        NEXT y%
    NEXT x%

    Room.entryDoor = MAZE_START
    RESETROUND
END SUB

SUB RESETROUND()
    DIM c%, p%
    ' Spawn players
    FOR p% = 1 TO Setting.numPlayers
        IF Player(p%).lives > 0 THEN Player(p%).alive = _TRUE ELSE Player(p%).alive = _FALSE
        Player(p%).bullets = 0
        Player(p%).mode    = NORMAL
        Player(p%).xdir    = 0
        Player(p%).ydir    = 0
        Player(p%).fix     = 0
    NEXT p%

    POSITIONPLAYERS Room.entryDoor, 1

    Otto.alive   = _FALSE
    Room.killed  = 0
    Room.bullets = 0
    Room.delay   = 30
    FOR c% = 1 TO 512
        Bullet(c%).alive = _FALSE
    NEXT c%

    ForcedExit = -1
    MAKEMAZE Room.entryDoor
    IF Setting.hasRobots = 1 THEN
        GENERATEROBOTS Room.entryDoor
    ELSE
        Room.robots = 0
    END IF
END SUB

FUNCTION ANGLE!(r%, targetP%)
    DIM px%, py%, Rx%, Ry%
    px% = Player(targetP%).x + 7
    py% = Player(targetP%).y + 15
    Rx% = Robot(r%).x + 7
    Ry% = Robot(r%).y + 11

    IF py% = Ry% THEN
        IF px% = Rx% THEN EXIT FUNCTION
        IF px% > Rx% THEN ANGLE! = 90 ELSE ANGLE! = 270
        EXIT FUNCTION
    END IF
    IF px% = Rx% THEN
        IF py% > Ry% THEN ANGLE! = 180
        EXIT FUNCTION
    END IF
    IF py% < Ry% THEN
        IF px% > Rx% THEN
            ANGLE! = ATN((px% - Rx%) /(py%-Ry%)) * -57.2957795131
        ELSE
            ANGLE! = ATN((px% - Rx%) /(py%-Ry%)) * -57.2957795131 + 360
        END IF
    ELSE
        ANGLE! = ATN((px% - Rx%) /(py%-Ry%)) * -57.2957795131 + 180
    END IF
END FUNCTION

SUB READPLAYERINPUT(p%)
    DIM inputType%, mDevice%, mType%, mCode%, mVal%, act%, axVal!
    Player(p%).moveUp    = _FALSE
    Player(p%).moveDown  = _FALSE
    Player(p%).moveLeft  = _FALSE
    Player(p%).moveRight = _FALSE
    Player(p%).button1   = _FALSE
    Player(p%).fireUp    = _FALSE
    Player(p%).fireDown  = _FALSE
    Player(p%).fireLeft  = _FALSE
    Player(p%).fireRight = _FALSE

    FOR inputType% = 1 TO 9
        mDevice% = m_arrControlMap(p%, inputType%).device
        mType%   = m_arrControlMap(p%, inputType%).typ
        mCode%   = m_arrControlMap(p%, inputType%).code
        mVal%    = m_arrControlMap(p%, inputType%).value

        IF mDevice% > 0 AND mDevice% <= _DEVICES THEN
            WHILE _DEVICEINPUT(mDevice%) : WEND
            act% = _FALSE
            IF mType% = CINPUTKEY THEN
                IF _BUTTON(mCode%) THEN act% = _TRUE
            ELSEIF mType% = CINPUTBUTTON THEN
                IF mCode% > 0 AND mCode% <= _LASTBUTTON(mDevice%) THEN
                    IF _BUTTON(mCode%) THEN act% = _TRUE
                END IF
            ELSEIF mType% = CINPUTAXIS THEN
                IF mCode% > 0 AND mCode% <= _LASTAXIS(mDevice%) THEN
                    axVal! = _AXIS(mCode%)
                    IF SGN(axVal!) = SGN(mVal%) AND ABS(axVal!) > 0.5 THEN act% = _TRUE
                END IF
            END IF

            IF act% THEN
                SELECT CASE inputType%
                    CASE CINPUTUP        : Player(p%).moveUp = _TRUE
                    CASE CINPUTDOWN      : Player(p%).moveDown = _TRUE
                    CASE CINPUTLEFT      : Player(p%).moveLeft = _TRUE
                    CASE CINPUTRIGHT     : Player(p%).moveRight = _TRUE
                    CASE CINPUTBUTTON1   : Player(p%).button1 = _TRUE
                    CASE CINPUTFIREUP    : Player(p%).fireUp = _TRUE
                    CASE CINPUTFIREDOWN  : Player(p%).fireDown = _TRUE
                    CASE CINPUTFIRELEFT  : Player(p%).fireLeft = _TRUE
                    CASE CINPUTFIRERIGHT : Player(p%).fireRight = _TRUE
                END SELECT
            END IF
        END IF
    NEXT inputType%
END SUB

SUB UPDATEPLAYER(p%)
    DIM c%, newX%, newY%, collide%, p2%, distOld%, distNew%, i%, firstAlive%
    DIM isFiring AS Integer, fireDx AS Integer, fireDy AS INTEGER

    ' Handle room delay countdown
    IF Room.delay THEN
        firstAlive% = 0
        FOR i% = 1 TO Setting.numPlayers
            IF Player(i%).alive THEN firstAlive% = i% : EXIT FOR
        NEXT i%

        IF p% = firstAlive% THEN
            Room.delay = Room.delay - 1
            IF Room.delay MOD 5 = 0 THEN Room.blink = NOT Room.blink
            IF Room.delay = 0 THEN Room.blink = _FALSE
        END IF
        EXIT SUB
    END IF

    IF Player(p%).mode = ZAPPED THEN EXIT SUB

    Player(p%).xdir = 0
    Player(p%).ydir = 0
    Player(p%).mode = NORMAL

    IF Player(p%).moveUp THEN Player(p%).ydir = -1
    IF Player(p%).moveDown THEN Player(p%).ydir = 1
    IF Player(p%).moveLeft THEN Player(p%).xdir = -1
    IF Player(p%).moveRight THEN Player(p%).xdir = 1

    ' Check if movement intersects another alive player, but allow escaping out
    newX%    = Player(p%).x + Player(p%).xdir
    newY%    = Player(p%).y + Player(p%).ydir
    collide% = _FALSE
    FOR p2% = 1 TO Setting.numPlayers
        IF p% <> p2% AND Player(p2%).alive THEN
            IF newX% < Player(p2%).x + 16 AND newX% + 15 > Player(p2%).x THEN
                IF newY% < Player(p2%).y + 32 AND newY% + 31 > Player(p2%).y THEN
                    ' Only block if we are moving CLOSER to the player we are intersecting
                    distOld% = ABS(Player(p%).x - Player(p2%).x) + ABS(Player(p%).y - Player(p2%).y)
                    distNew% = ABS(newX% - Player(p2%).x) + ABS(newY%-Player(p2%).y)
                    IF distNew% < distOld% THEN collide% = _TRUE
                END IF
            END IF
        END IF
    NEXT p2%
    IF collide% THEN
        Player(p%).xdir = 0
        Player(p%).ydir = 0
    END IF

    ' Firing Logic
    isFiring = _FALSE
    fireDx   = 0
    fireDy   = 0

    IF Setting.fireStyle = 0 THEN
        ' BERZERK mode logic
        IF Player(p%).button1 THEN
            Player(p%).mode = FIRING
            IF Player(p%).xdir <> 0 OR Player(p%).ydir <> 0 THEN
                isFiring = _TRUE
                fireDx   = Player(p%).xdir
                fireDy   = Player(p%).ydir
            END IF
            Player(p%).xdir = 0
            Player(p%).ydir = 0
        END IF
    ELSE
        ' ROBOTRON mode logic
        IF Player(p%).fireUp THEN isFiring = _TRUE    : fireDy = -1
        IF Player(p%).fireDown THEN isFiring = _TRUE  : fireDy = 1
        IF Player(p%).fireLeft THEN isFiring = _TRUE  : fireDx = -1
        IF Player(p%).fireRight THEN isFiring = _TRUE : fireDx = 1

        ' Allow button1 in Robotron mode to fire in current moving/facing direction without stopping
        IF NOT isFiring AND Player(p%).button1 THEN
            IF Player(p%).xdir <> 0 OR Player(p%).ydir <> 0 THEN
                isFiring = _TRUE
                fireDx   = Player(p%).xdir
                fireDy   = Player(p%).ydir
            ELSE
                isFiring = _TRUE
                fireDx   = Player(p%).dir
                fireDy   = 0
            END IF
        END IF
    END IF

    IF isFiring THEN
        IF fireDx <> 0 OR fireDy <> 0 THEN
            IF Player(p%).bullets < Setting.maxPlayerBullets AND Player(p%).bcount = 0 THEN
                c% = 0
                FOR i% = 1 TO 512
                    IF NOT Bullet(i%).alive THEN c% = i% : EXIT FOR
                NEXT i%

                IF c% > 0 THEN
                    IF fireDx <> 0 THEN
                        Player(p%).dir = fireDx
                        IF fireDx = -1 THEN Bullet(c%).x = Player(p%).x - 2 ELSE Bullet(c%).x = Player(p%).x + 17
                        SELECT CASE fireDy
                            CASE - 1 : Player(p%).cell = 6 : Bullet(c%).y = Player(p%).y-2
                            CASE 0   : Player(p%).cell = 7 : Bullet(c%).y = Player(p%).y + 6
                            CASE 1   : Player(p%).cell = 8 : Bullet(c%).y = Player(p%).y + 33
                        END SELECT
                    ELSE
                        Player(p%).dir = 1
                        IF fireDy = -1 THEN
                            Player(p%).cell = 5 : Bullet(c%).x = Player(p%).x + 15 : Bullet(c%).y = Player(p%).y - 2
                        ELSE
                            Player(p%).cell = 9 : Bullet(c%).x = Player(p%).x + 12 : Bullet(c%).y = Player(p%).y + 33
                        END IF
                    END IF
                    Bullet(c%).xdir  = fireDx * 12
                    Bullet(c%).ydir  = fireDy * 12
                    Bullet(c%).who   = - p%
                    Bullet(c%).alive = _TRUE
                    Player(p%).bullets = Player(p%).bullets + 1
                    Player(p%).bcount = 12

                    Player(p%).fix = 4
                    IF Setting.fireStyle = 1 THEN
                        Player(p%).mode = NORMAL
                    END IF

                    SafeSndPlay Pshoot&
                END IF
            END IF
        END IF
    END IF

    IF Player(p%).bcount > 0 THEN Player(p%).bcount = Player(p%).bcount - 1
END SUB

SUB UPDATEBULLETS()
    DIM c%, s%, newX%, newY%, Oldx%, Oldy%, Cdest&, Bhit%, p%, shooter%
    IF Room.delay THEN EXIT SUB
    Cdest& = _DEST

    FOR c% = 1 TO 256
        IF Robot(c%).bcount THEN Robot(c%).bcount = Robot(c%).bcount - 1
    NEXT c%

    FOR p% = 1 TO Setting.numPlayers
        IF Player(p%).bcount THEN Player(p%).bcount = Player(p%).bcount - 1
    NEXT p%

    FOR c% = 1 TO 512
        _SOURCE Maze&
        IF Bullet(c%).alive THEN
            Bullet(c%).oldx = Bullet(c%).x + SGN(Bullet(c%).xdir)
            Bullet(c%).oldy = Bullet(c%).y + SGN(Bullet(c%).ydir)
            s%              = 0
            DO
                s% = s% + 1
                newX% = Bullet(c%).x + (s% * SGN(Bullet(c%).xdir))
                newY% = Bullet(c%).y + (s% * SGN(Bullet(c%).ydir))

                ' Maze Wall Collision
                IF POINT(newX%, newY%) = _RGB32(0, 0, 255) OR POINT(newX%, newY%) = LEVEL(Room.level).rcolor THEN
                    IF s% = 1 THEN
                        Bullet(c%).alive = _FALSE
                    ELSE
                        newX% = Oldx%
                        newY% = Oldy%
                    END IF
                    EXIT DO
                END IF
                _SOURCE Cdest&
                IF POINT(newX%, newY%) = LEVEL(Room.level).rcolor THEN Bhit% = _TRUE
                IF newX% <= 3 OR newX% >= 732 OR newY% <= -1 OR newY% >= 612 THEN
                    IF s% = 1 THEN
                        Bullet(c%).alive = _FALSE
                    ELSE
                        newX% = Oldx%
                        newY% = Oldy%
                    END IF
                    EXIT DO
                END IF
                Oldx% = Bullet(c%).x + (s% * SGN(Bullet(c%).xdir))
                Oldy% = Bullet(c%).y + (s% * SGN(Bullet(c%).ydir))
            LOOP UNTIL s% = ABS(Bullet(c%).xdir) OR s% = ABS(Bullet(c%).ydir)

            Bullet(c%).x = newX%
            Bullet(c%).y = newY%

            IF Bullet(c%).alive THEN
                _DEST Cdest&
                LINE(Bullet(c%).oldx, Bullet(c%).oldy) -(newX%, newY%), _RGB32(255, 255, 255)
                LINE(Bullet(c%).oldx + 1, Bullet(c%).oldy) -(newX% + 1, newY%), _RGB32(255, 255, 255)
                LINE(Bullet(c%).oldx, Bullet(c%).oldy + 1) -(newX%, newY% + 1), _RGB32(255, 255, 255)
                LINE(Bullet(c%).oldx + 1, Bullet(c%).oldy + 1) -(newX% + 1, newY% + 1), _RGB32(255, 255, 255)
                IF Bhit% THEN
                    Bhit%            = _FALSE
                    Bullet(c%).alive = _FALSE
                END IF

                ' Check Bullet Hitting Players
                FOR p% = 1 TO Setting.numPlayers
                    IF Player(p%).alive AND Bullet(c%).who <> - p% THEN
                        IF Bullet(c%).x >= Player(p%).x AND Bullet(c%).x <= Player(p%).x + 15 THEN
                            IF Bullet(c%).y >= Player(p%).y AND Bullet(c%).y <= Player(p%).y + 31 THEN
                                Player(p%).zcolor = 1
                                Player(p%).cell   = 1
                                Player(p%).mode   = ZAPPED
                                Player(p%).zcount = 30
                                Bullet(c%).alive  = _FALSE
                                SafeSndPlay Killed&
                                SafeSndPlay GotTheHumanoid&

                                ' Reward Shooter (+10 pts)
                                IF Bullet(c%).who < 0 THEN
                                    shooter% = ABS(Bullet(c%).who)
                                    Player(shooter%).score = Player(shooter%).score + 10
                                END IF
                            END IF
                        END IF
                    END IF
                NEXT p%
            END IF

            IF NOT Bullet(c%).alive THEN
                IF Bullet(c%).who < 0 THEN
                    p% = ABS(Bullet(c%).who)
                    Player(p%).bullets = Player(p%).bullets - 1
                ELSEIF Bullet(c%).who > 0 THEN
                    Robot(Bullet(c%).who).bullets = Robot(Bullet(c%).who).bullets - 1
                    Room.bullets = Room.bullets - 1
                END IF
            END IF
        END IF
    NEXT c%
END SUB

SUB DRAWPLAYER(p%, Mode%)
    DIM Cdest&, x%, y%, Bounce%, pixelColor~&, isPlayerColor%, p3%, relX%, relY%
    DIM hitSafeWall AS INTEGER
    Cdest&      = _DEST
    hitSafeWall = _FALSE

    IF Mode% = ZAPPED THEN
        IF Player(p%).zcount THEN
            Player(p%).zcount = Player(p%).zcount - 1
            Player(p%).cell = Player(p%).cell + 1
            IF Player(p%).cell = 5 THEN Player(p%).cell = 1
            Player(p%).zcolor = Player(p%).zcolor + 1
            IF Player(p%).zcolor = 14 THEN Player(p%).zcolor = 1
            _DEST FlashMask&
            Cls, LEVEL(Player(p%).zcolor).rcolor
            _PUTIMAGE(0, 0), Flash&(Player(p%).cell)
            _CLEARCOLOR _RGB32(0, 0, 0), FlashMask&
            _PUTIMAGE(Player(p%).x, Player(p%).y - 1), FlashMask&, Cdest&
        ELSE
            Player(p%).alive = _FALSE
            Player(p%).lives = Player(p%).lives - 1
            Player(p%).mode = NORMAL
        END IF
    ELSE
        IF Mode% <> FIRING THEN
            IF Player(p%).fix THEN Player(p%).fix = Player(p%).fix - 1
            IF Player(p%).ydir = 0 AND Player(p%).xdir = 0 AND Player(p%).fix = 0 THEN
                Player(p%).cell = 1
            ELSE
                IF Mode% = NORMAL THEN
                    IF Player(p%).xdir <> 0 THEN Player(p%).dir = SGN(Player(p%).xdir)
                    Player(p%).x = Player(p%).x + Player(p%).xdir
                    Player(p%).y = Player(p%).y + Player(p%).ydir
                END IF
                IF Player(p%).fix = 0 THEN
                    Player(p%).cell = Player(p%).cell + 1
                    IF Player(p%).cell > 4 THEN Player(p%).cell = 2
                    IF Player(p%).cell = 3 THEN Bounce% = 1
                END IF
            END IF
        END IF

        ' Wall / Laser Mask Collisions
        IF NOT Setting.iddqd AND Mode% <> TRANSITIONING THEN
            IF Player(p%).x >= 0 AND Player(p%).x <= 720 AND Player(p%).y >= 0 AND Player(p%).y <= 584 THEN
                _SOURCE PmaskTest&
                _DEST PmaskTest&
                _PUTIMAGE(0, 0), Cdest&, PmaskTest&,(Player(p%).x, Player(p%).y) -(Player(p%).x + 15, Player(p%).y + 31)

                ' Erase other player pixels from collision testing so players don't zank each other
                FOR p3% = 1 TO Setting.numPlayers
                    IF p% <> p3% AND Player(p3%).alive THEN
                        relX% = Player(p3%).x - Player(p%).x
                        relY% = Player(p3%).y - Player(p%).y
                        LINE(relX%, relY%) -(relX% + 15, relY% + 31), _RGB32(0, 0, 0), BF
                    END IF
                NEXT p3%

                _PUTIMAGE(0, 0), Pmask&(p%, Player(p%).cell, Player(p%).dir)
                FOR x% = 0 TO 15
                    FOR y% = 0 TO 31
                        pixelColor~& = POINT(x%, y%)
                        IF pixelColor~& <> _RGB32(0, 0, 0) THEN
                            isPlayerColor% = _FALSE
                            FOR p3% = 1 TO Setting.numPlayers
                                IF pixelColor~& = PlayerColor&(p3%) THEN isPlayerColor% = _TRUE : EXIT FOR
                            NEXT p3%

                            IF NOT isPlayerColor% THEN
                                IF Setting.wallsDeadly = 0 AND pixelColor~& = _RGB32(0, 0, 255) THEN
                                    hitSafeWall = _TRUE
                                ELSE
                                    Player(p%).zcolor = 1
                                    Player(p%).cell   = 1
                                    Player(p%).mode   = ZAPPED
                                    Player(p%).zcount = 30
                                    SafeSndPlay GotTheHumanoid&
                                    EXIT FOR
                                END IF
                            END IF
                        END IF
                    NEXT y%
                    IF Player(p%).mode = ZAPPED THEN EXIT FOR
                NEXT x%

                ' If we hit a safe wall, revert x/y so the player is blocked but alive
                IF hitSafeWall AND Player(p%).mode <> ZAPPED THEN
                    Player(p%).x = Player(p%).x - Player(p%).xdir
                    Player(p%).y = Player(p%).y - Player(p%).ydir
                END IF
            END IF
        END IF

        _SOURCE Cdest&
        _DEST Cdest&
        IF NOT Room.blink THEN
            _PUTIMAGE(Player(p%).x, Player(p%).y + Bounce%), Pimage&(p%, Player(p%).cell, Player(p%).dir)
        END IF
    END IF
    _DEST Cdest&
END SUB

SUB CHECKFORTRANSITION()
    DIM p%, op%, othersAlive%, currentExit%, rExit%, exitClear%, attempts%, p2%
    DIM exitsX(8) AS Integer, exitsY(8) AS Integer, exitsDir(8) AS INTEGER
    DIM dHeading%, blockClosed%, perturb AS SINGLE

    IF Setting.hasRobots = 1 THEN
        ' 4 Doors
        exitsX(1) = 368 : exitsY(1) = 10  : exitsDir(1) = 1  ' n
        exitsX(2) = 368 : exitsY(2) = 590 : exitsDir(2) = 1  ' s
        exitsX(3) = 710 : exitsY(3) = 308 : exitsDir(3) = -1 ' E
        exitsX(4) = 12  : exitsY(4) = 308 : exitsDir(4) = 1  ' W
    ELSE
        ' 8 Doors shootout
        exitsX(1) = 12  : exitsY(1) = 130 : exitsDir(1) = 1
        exitsX(2) = 716 : exitsY(2) = 130 : exitsDir(2) = -1
        exitsX(3) = 214 : exitsY(3) = 12  : exitsDir(3) = 1
        exitsX(4) = 214 : exitsY(4) = 588 : exitsDir(4) = 1
        exitsX(5) = 12  : exitsY(5) = 480 : exitsDir(5) = 1
        exitsX(6) = 716 : exitsY(6) = 480 : exitsDir(6) = -1
        exitsX(7) = 510 : exitsY(7) = 12  : exitsDir(7) = 1
        exitsX(8) = 510 : exitsY(8) = 588 : exitsDir(8) = 1
    END IF

    FOR p% = 1 TO Setting.numPlayers
        IF Player(p%).alive THEN
            IF Player(p%).x <= 4 OR Player(p%).x >= 724 OR Player(p%).y <= 0 OR Player(p%).y >= 600 THEN
                IF Setting.hasRobots = 1 THEN
                    IF Room.killed = Room.robots THEN
                        ' Arcade Robot Mode: Transition if all robots dead!
                        othersAlive% = 0
                        FOR op% = 1 TO Setting.numPlayers
                            IF op% <> p% AND Player(op%).alive THEN othersAlive% = othersAlive% + 1
                        NEXT op%

                        IF Player(p%).x <= 4 THEN dHeading% = WEST
                        IF Player(p%).x >= 724 THEN dHeading% = EAST
                        IF Player(p%).y <= 0 THEN dHeading% = NORTH
                        IF Player(p%).y >= 600 THEN dHeading% = SOUTH

                        IF Room.entryDoor <> MAZE_START AND dHeading% = ForcedExit THEN
                            ' Bounce player back if they try to exit the closed door they entered from
                            Player(p%).xdir = 0
                            Player(p%).ydir = 0
                            IF dHeading% = WEST THEN Player(p%).x = 6
                            IF dHeading% = EAST THEN Player(p%).x = 708
                            IF dHeading% = NORTH THEN Player(p%).y = 6
                            IF dHeading% = SOUTH THEN Player(p%).y = 570
                        ELSE
                            ' Valid transition!
                            TRANSITION dHeading%, p%
                            EXIT SUB
                        END IF
                    ELSE
                        ' Teleporting behavior while robots are alive
                        IF Player(p%).x <= 4 THEN currentExit% = 4
                        IF Player(p%).x >= 724 THEN currentExit% = 3
                        IF Player(p%).y <= 0 THEN currentExit% = 1
                        IF Player(p%).y >= 600 THEN currentExit% = 2

                        ' Block if entering closed door
                        blockClosed% = _FALSE
                        IF Room.entryDoor = NORTH AND currentExit% = 2 THEN blockClosed% = _TRUE ' Entered n door, s door IS where they came from
                        IF Room.entryDoor = SOUTH AND currentExit% = 1 THEN blockClosed% = _TRUE
                        IF Room.entryDoor = EAST AND currentExit% = 4 THEN blockClosed% = _TRUE
                        IF Room.entryDoor = WEST AND currentExit% = 3 THEN blockClosed% = _TRUE

                        IF blockClosed% THEN
                            Player(p%).xdir = 0 : Player(p%).ydir = 0
                            IF currentExit% = 4 THEN Player(p%).x = 6
                            IF currentExit% = 3 THEN Player(p%).x = 708
                            IF currentExit% = 1 THEN Player(p%).y = 6
                            IF currentExit% = 2 THEN Player(p%).y = 570
                        ELSE
                            ' Random teleport
                            attempts% = 0
                            DO
                                rExit%     = INT(RND * 4) + 1
                                exitClear% = _TRUE

                                ' Ensure not teleporting into the closed door
                                IF Room.entryDoor = NORTH AND rExit% = 2 THEN exitClear% = _FALSE
                                IF Room.entryDoor = SOUTH AND rExit% = 1 THEN exitClear% = _FALSE
                                IF Room.entryDoor = EAST AND rExit% = 4 THEN exitClear% = _FALSE
                                IF Room.entryDoor = WEST AND rExit% = 3 THEN exitClear% = _FALSE

                                FOR p2% = 1 TO Setting.numPlayers
                                    IF p2% <> p% AND Player(p2%).alive THEN
                                        IF ABS(Player(p2%).x - exitsX(rExit%)) < 32 AND ABS(Player(p2%).y - exitsY(rExit%)) < 48 THEN
                                            exitClear% = _FALSE
                                        END IF
                                    END IF
                                NEXT p2%
                                attempts% = attempts% + 1
                                IF attempts% > 20 THEN exitClear% = _TRUE ' Fallback
                            LOOP UNTIL(rExit% <> currentExit% AND exitClear%)

                            Player(p%).x    = exitsX(rExit%)
                            Player(p%).y    = exitsY(rExit%)
                            Player(p%).dir  = exitsDir(rExit%)
                            Player(p%).xdir = 0
                            Player(p%).ydir = 0

                            DIM sndIdx% : sndIdx% = INT(RND(1) * 3) + 1
                            SafeSndPlay FightLikeRobot&(sndIdx%)
                        END IF
                    END IF
                ELSE
                    ' Shootout Mode: 8 door random teleports
                    currentExit% = 1
                    IF Player(p%).x <= 4 AND Player(p%).y < 308 THEN currentExit% = 1
                    IF Player(p%).x >= 724 AND Player(p%).y < 308 THEN currentExit% = 2
                    IF Player(p%).y <= 0 AND Player(p%).x < 368 THEN currentExit% = 3
                    IF Player(p%).y >= 600 AND Player(p%).x < 368 THEN currentExit% = 4
                    IF Player(p%).x <= 4 AND Player(p%).y >= 308 THEN currentExit% = 5
                    IF Player(p%).x >= 724 AND Player(p%).y >= 308 THEN currentExit% = 6
                    IF Player(p%).y <= 0 AND Player(p%).x >= 368 THEN currentExit% = 7
                    IF Player(p%).y >= 600 AND Player(p%).x >= 368 THEN currentExit% = 8

                    attempts% = 0
                    DO
                        rExit%     = INT(RND * 8) + 1
                        exitClear% = _TRUE
                        FOR p2% = 1 TO Setting.numPlayers
                            IF p2% <> p% AND Player(p2%).alive THEN
                                IF ABS(Player(p2%).x - exitsX(rExit%)) < 32 AND ABS(Player(p2%).y - exitsY(rExit%)) < 48 THEN
                                    exitClear% = _FALSE
                                END IF
                            END IF
                        NEXT p2%
                        attempts% = attempts% + 1
                        IF attempts% > 20 THEN exitClear% = _TRUE
                    LOOP UNTIL(rExit% <> currentExit% AND exitClear%)

                    Player(p%).x    = exitsX(rExit%)
                    Player(p%).y    = exitsY(rExit%)
                    Player(p%).dir  = exitsDir(rExit%)
                    Player(p%).xdir = 0
                    Player(p%).ydir = 0
                END IF
            END IF
        END IF
    NEXT p%
END SUB

SUB TRANSITION(Heading%, TriggerPlayer%)
    DIM ThisRoom&, ScrollRoom&, m%, Move%, Cdest&, t%, p%
    DIM sndIdx1%, sndIdx2%

    VisitedRooms(Room.x, Room.y) = 1

    Cdest&    = _DEST
    ThisRoom& = _COPYIMAGE(WorkRoom&)

    SafeSndStop Ctaunt&
    SafeSndStop IntruderAlert&

    IF Room.killed <> Room.robots THEN
        sndIdx1% = INT(RND(1) * 3) + 1
        SafeSndPlay FightLikeRobot&(sndIdx1%)
    ELSE
        sndIdx1% = INT(RND(1) * 2) + 1
        sndIdx2% = INT(RND(1) * 3) + 1
        SafeSndPlay MustNotEscape&(sndIdx1%, sndIdx2%)
        Room.bonus = Room.robots * 10
        IF NOT Otto.alive THEN Room.bonus = Room.bonus + 50
        ' Award bonus only to living players
        FOR p% = 1 TO Setting.numPlayers
            IF Player(p%).alive THEN Player(p%).score = Player(p%).score + Room.bonus
        NEXT p%
    END IF

    Room.killed  = 0
    Room.bullets = 0
    FOR t% = 1 TO 512
        Bullet(t%).alive = _FALSE
    NEXT t%
    FOR p% = 1 TO Setting.numPlayers
        Player(p%).bullets = 0
    NEXT p%

    ' Update Robot Progression parameters every 2 screens
    Room.reallevel = Room.reallevel + 1
    IF Room.reallevel MOD 2 = 1 THEN
        Room.level = Room.level + 1
        IF Room.level > 14 THEN Room.level = 14
    END IF

    IF Heading% < EAST THEN
        t%          = 20
        Move%       = 615
        ScrollRoom& = _NEWIMAGE(736, 1232, 32)
    ELSE
        t%          = 16
        Move%       = 735
        ScrollRoom& = _NEWIMAGE(1472, 616, 32)
    END IF

    ' The new door they enter from depends on heading
    Room.entryDoor = Heading%
    SELECT CASE Heading%
        CASE NORTH : ForcedExit = SOUTH
        CASE SOUTH : ForcedExit = NORTH
        CASE EAST  : ForcedExit = WEST
        CASE WEST  : ForcedExit = EAST
    END SELECT

    _DEST Maze&
    DRAWROBOTS
    _DEST Cdest&
    GENERATEROBOTS Heading%

    SELECT CASE Heading%
        CASE NORTH
            _PUTIMAGE(0, 616), Maze&, ScrollRoom&
            MAKEMAZE NORTH
            DRAWROBOTS
            _PUTIMAGE(0, 0), WorkRoom&, ScrollRoom&
        CASE SOUTH
            _PUTIMAGE(0, 0), Maze&, ScrollRoom&
            MAKEMAZE SOUTH
            DRAWROBOTS
            _PUTIMAGE(0, 616), WorkRoom&, ScrollRoom&
        CASE EAST
            _PUTIMAGE(0, 0), Maze&, ScrollRoom&
            MAKEMAZE EAST
            DRAWROBOTS
            _PUTIMAGE(736, 0), WorkRoom&, ScrollRoom&
        CASE WEST
            _PUTIMAGE(736, 0), Maze&, ScrollRoom&
            MAKEMAZE WEST
            DRAWROBOTS
            _PUTIMAGE(0, 0), WorkRoom&, ScrollRoom&
    END SELECT

    m% = -1
    DO
        _LIMIT 60
        m% = m% + 4 ' Speed up scroll slightly due TO higher res
        _DEST ThisRoom&
        SELECT CASE Heading%
            CASE NORTH : _PUTIMAGE(0, 0), ScrollRoom&, ThisRoom&,(0, 616 - m%) -(735, 616 - m% + 615)
            CASE SOUTH : _PUTIMAGE(0, 0), ScrollRoom&, ThisRoom&,(0, m%) -(735, m% + 615)
            CASE EAST  : _PUTIMAGE(0, 0), ScrollRoom&, ThisRoom&,(m%, 0) -(m% + 735, 615)
            CASE WEST  : _PUTIMAGE(0, 0), ScrollRoom&, ThisRoom&,(736 - m%, 0) -(736 - m% + 735, 615)
        END SELECT

        IF m% < t% THEN
            FOR p% = 1 TO Setting.numPlayers
                IF Player(p%).alive THEN DRAWPLAYER p%, TRANSITIONING
            NEXT p%
        ELSEIF m% >= t% AND m% < t% + 5 THEN
            FOR p% = 1 TO Setting.numPlayers
                ' Resurrect dead players if they have remaining lives
                IF Player(p%).lives > 0 AND NOT Player(p%).alive THEN
                    Player(p%).alive  = _TRUE
                    Player(p%).mode   = NORMAL
                    Player(p%).zcount = 0
                END IF

                IF Player(p%).alive THEN
                    Player(p%).xdir = 0
                    Player(p%).ydir = 0
                END IF
            NEXT p%

            POSITIONPLAYERS Heading%, TriggerPlayer%

            _DEST WorkRoom&
            FOR p% = 1 TO Setting.numPlayers
                IF Player(p%).alive THEN DRAWPLAYER p%, NORMAL
            NEXT p%
            SELECT CASE Heading%
                CASE NORTH : _PUTIMAGE(0, 0), WorkRoom&, ScrollRoom&,(0, 0) -(735, 615)
                CASE SOUTH : _PUTIMAGE(0, 616), WorkRoom&, ScrollRoom&,(0, 0) -(735, 615)
                CASE EAST  : _PUTIMAGE(736, 0), WorkRoom&, ScrollRoom&,(0, 0) -(735, 615)
                CASE WEST  : _PUTIMAGE(0, 0), WorkRoom&, ScrollRoom&,(0, 0) -(735, 615)
            END SELECT
        END IF

        _DEST MainScreen&
        CLS
        _PUTIMAGE(144, 76) -(879, 691), ThisRoom&
        UPDATESCORE
        _DISPLAY
    LOOP UNTIL m% >= Move%

    Room.bonus = 0
    _DEST Maze&
    IF Setting.hasRobots = 1 THEN
        SELECT CASE Heading%
            CASE NORTH : LINE(328, 611) -(408, 615), LEVEL(Room.level).rcolor, BF
            CASE SOUTH : LINE(328, 0) -(408, 4), LEVEL(Room.level).rcolor, BF
            CASE EAST  : LINE(0, 268) -(4, 348), LEVEL(Room.level).rcolor, BF
            CASE WEST  : LINE(731, 268) -(735, 348), LEVEL(Room.level).rcolor, BF
        END SELECT
    END IF

    _FREEIMAGE ThisRoom&
    _FREEIMAGE ScrollRoom&
    _DEST Cdest&
END SUB

SUB UPDATESCORE()
    DIM p%, xPos%, yPos%, s$, Cdest&, boxH%, pulseColor&
    DIM kU$, kD$, kL$, kR$, kF$
    DIM ALPHA AS LONG
    DIM redX  AS INTEGER
    DIM pR    AS Integer, pG AS Integer, pB AS Integer, pC AS _UNSIGNED Long, wC AS _UNSIGNED LONG
    DIM iLine AS INTEGER

    Cdest& = _DEST
    _DEST MainScreen&

    _PRINTMODE _KEEPBACKGROUND

    ' Draw Top Headers
    _FONT Font48&
    COLOR _RGB32(255, 216, 0) : _PRINTSTRING(10, 6), "Fast Zap'em "
    COLOR _RGB32(0, 255, 0)   : _PRINTSTRING(310, 6), "Berzerkotron"

    _FONT Font24&
    COLOR _RGB32(255, 255, 255) : _PRINTSTRING(620, 20), "by Softintheheadware"

    _FONT Font12&
    COLOR _RGB32(128, 128, 128)
    _PRINTSTRING(10, 60), "based on QBZerk by Terry Ritchie based on Berzerk by Alan McNeil / Stern Electronics"

    ' Top Right UI Panel
    _FONT Font12&
    IF _FULLSCREEN THEN
        COLOR _RGB32(128, 128, 128) : _PRINTSTRING(888, 3), "[HOME] FULLSCREEN"
        COLOR _RGB32(255, 255, 255) : _PRINTSTRING(888, 23), "[END] WINDOWED"
    ELSE
        COLOR _RGB32(255, 255, 255) : _PRINTSTRING(888, 3), "[HOME] FULLSCREEN"
        COLOR _RGB32(128, 128, 128) : _PRINTSTRING(888, 23), "[END] WINDOWED"
    END IF

    IF GamePaused THEN
        DIM flashClr AS _UNSIGNED LONG
        DIM flashInt AS LONG
        flashInt = 128 + 127 * SIN(TIMER * 5)
        flashClr = _RGB32(flashInt, flashInt, flashInt)
        COLOR flashClr : _PRINTSTRING(888, 43), "[SPACEBAR] RESUME"
    ELSE
        COLOR _RGB32(255, 255, 255) : _PRINTSTRING(888, 43), "[SPACEBAR] PAUSE"
    END IF
    COLOR _RGB32(255, 255, 255) : _PRINTSTRING(888, 63), "[ESC] QUIT GAME"

    ' Bottom left/right info text
    _FONT Font10&
    COLOR _RGB32(128, 128, 128)
    _PRINTSTRING(20, 750), "REPLACE WAR"
    _PRINTSTRING(900, 750), "WITH GAMES"

    ' Draw Player Boxes
    boxH% = 150
    FOR p% = 1 TO Setting.numPlayers
        IF p% <= 4 THEN
            xPos% = 10
            yPos% = 76 + (p% - 1) * boxH%
        ELSE
            xPos% = 886
            yPos% = 76 + (p% - 5) * boxH%
        END IF

        ALPHA = 255
        redX  = _FALSE

        IF NOT Player(p%).alive THEN
            ALPHA = 100 ' DIM text mapping value directly proportional TO 255 scale
            IF Player(p%).lives <= 0 THEN redX = _TRUE
        END IF

        pR = _RED32(PlayerColor&(p%))
        pG = _GREEN32(PlayerColor&(p%))
        pB = _BLUE32(PlayerColor&(p%))

        pC = _RGB32((pR * ALPHA) \ 255,(pG * ALPHA) \ 255,(pB * ALPHA) \ 255)
        wC = _RGB32(alpha, alpha, ALPHA)

        LINE(xPos%, yPos%) -(xPos% + 128, yPos% + 140), pC, b

        s$ = LTRIM$(STR$(Player(p%).score))

        kU$ = GetKeyDesc$(m_arrControlMap(p%, CINPUTUP).device, m_arrControlMap(p%, CINPUTUP).typ, m_arrControlMap(p%, CINPUTUP).code)
        kD$ = GetKeyDesc$(m_arrControlMap(p%, CINPUTDOWN).device, m_arrControlMap(p%, CINPUTDOWN).typ, m_arrControlMap(p%, CINPUTDOWN).code)
        kL$ = GetKeyDesc$(m_arrControlMap(p%, CINPUTLEFT).device, m_arrControlMap(p%, CINPUTLEFT).typ, m_arrControlMap(p%, CINPUTLEFT).code)
        kR$ = GetKeyDesc$(m_arrControlMap(p%, CINPUTRIGHT).device, m_arrControlMap(p%, CINPUTRIGHT).typ, m_arrControlMap(p%, CINPUTRIGHT).code)
        kF$ = GetKeyDesc$(m_arrControlMap(p%, CINPUTBUTTON1).device, m_arrControlMap(p%, CINPUTBUTTON1).typ, m_arrControlMap(p%, CINPUTBUTTON1).code)

        IF kU$ = "UNBOUND" Then kU$ = "NONE"
        IF kD$ = "UNBOUND" Then kD$ = "NONE"
        IF kL$ = "UNBOUND" Then kL$ = "NONE"
        IF kR$ = "UNBOUND" Then kR$ = "NONE"
        IF kF$ = "UNBOUND" Then kF$ = "NONE"

        _FONT Font24&
        COLOR pC : _PRINTSTRING(xPos% + 5, yPos% + 5), "PLAYER " + LTrim$(Str$(p%))
        _FONT Font12&
        COLOR pC : _PRINTSTRING(xPos% + 5, yPos% + 40), "SCORE..."
        COLOR wC : _PRINTSTRING(xPos% + 65, yPos% + 40), s$

        COLOR pC : _PRINTSTRING(xPos% + 5, yPos% + 55), "LIVES..."
        COLOR wC : _PRINTSTRING(xPos% + 65, yPos% + 55), LTRIM$(STR$(Player(p%).lives))

        COLOR pC : _PRINTSTRING(xPos% + 5, yPos% + 75), "FIRE...."
        COLOR wC : _PRINTSTRING(xPos% + 65, yPos% + 75), LEFT$(kF$, 10)

        COLOR wC
        _PRINTSTRING(xPos% + 55, yPos% + 95), LEFT$(kU$, 4)
        _PRINTSTRING(xPos% + 15, yPos% + 110), LEFT$(kL$, 4)
        _PRINTSTRING(xPos% + 95, yPos% + 110), LEFT$(kR$, 4)
        _PRINTSTRING(xPos% + 50, yPos% + 125), LEFT$(kD$, 4)

        COLOR pC
        _PRINTSTRING(xPos% + 60, yPos% + 105), CHR$(24)
        _PRINTSTRING(xPos% + 40, yPos% + 110), CHR$(27)
        _PRINTSTRING(xPos% + 80, yPos% + 110), CHR$(26)
        _PRINTSTRING(xPos% + 60, yPos% + 115), CHR$(25)

        COLOR pC : _PRINTSTRING(xPos% + 5, yPos% + 125), LTRIM$(STR$(Room.y)) + "," + LTrim$(Str$(Room.x))

        IF redX THEN
            FOR iLine = -1 TO 1
                LINE(xPos% + 5, yPos% + 15 + iLine) -(xPos% + 120, yPos% + 35 + iLine), _RGB32(255, 0, 0)
                LINE(xPos% + 5, yPos% + 35 + iLine) -(xPos% + 120, yPos% + 15 + iLine), _RGB32(255, 0, 0)
            NEXT iLine
        END IF
    NEXT p%

    _DEST Cdest&
END SUB

SUB DRAWTEXT2X(x%, y%, t$, c~&)
    DIM temp&, l%, a%, Cdest&
    Cdest& = _DEST
    temp&  = _NEWIMAGE(LEN(t$) * 8, 12, 32)
    _DEST temp&
    Cls, c~&
    FOR l% = 1 TO LEN(t$)
        a% = ASC(MID$(t$, l%, 1))
        SELECT CASE a%
            CASE 32        : a% = 0 ' Space
            CASE 48 TO 57  : a% = a%-47
            CASE 65 TO 90  : a% = a%-54
            CASE 97 TO 122 : a% = a%-60
        END SELECT
        IF a% = 0 THEN
            LINE((l% - 1) * 8, 0) -((l%-1) * 8 + 7, 11), _RGB32(0, 0, 0), BF
        ELSE
            _PUTIMAGE((l% - 1) * 8, 0), Font&(a%)
        END IF
    NEXT l%
    _CLEARCOLOR _RGB32(0, 0, 0)
    _DEST Cdest&
    _PUTIMAGE(x%, y%) -(x% + (LEN(t$) * 16) -1, y% + 23), temp&
    _FREEIMAGE temp&
END SUB

SUB UPDATEBLANKROOM()
    DIM Cdest&
    Cdest& = _DEST
    _DEST BlankRoom&
    CLS
    ' 4px outer borders
    LINE(0, 0) -(735, 615), _RGB32(0, 0, 255), BF
    LINE(4, 4) -(731, 611), _RGB32(0, 0, 0), BF

    IF Setting.hasRobots = 1 THEN
        LINE(0, 268) -(735, 348), _RGB32(0, 0, 0), BF
        LINE(328, 0) -(408, 615), _RGB32(0, 0, 0), BF
    ELSE
        LINE(0, 90) -(735, 170), _RGB32(0, 0, 0), BF
        LINE(0, 440) -(735, 520), _RGB32(0, 0, 0), BF
        LINE(184, 0) -(244, 615), _RGB32(0, 0, 0), BF
        LINE(480, 0) -(540, 615), _RGB32(0, 0, 0), BF
    END IF
    _DEST Cdest&
END SUB

' =============================================================================
' ROBOTS & OTTO AI
' =============================================================================
SUB UPDATEROBOTS()
    DIM c%, targetP%, minDist%, dx%, dy%, x%, y%, Xdir%, Ydir%, a%, Fire%, Dpm%, b%, speedDelay AS INTEGER
    DIM sndIdx%

    IF Room.killed = Room.robots THEN EXIT SUB
    IF Room.delay THEN EXIT SUB

    FOR c% = 1 TO 256
        IF Robot(c%).alive THEN
            ' Find nearest player
            targetP% = 0
            minDist% = 32000
            FOR p% = 1 TO Setting.numPlayers
                IF Player(p%).alive THEN
                    dx% = ABS(Robot(c%).x + 7 - (Player(p%).x + 7))
                    dy% = ABS(Robot(c%).y + 11 - (Player(p%).y + 15))
                    d%  = dx% * dx% + dy% * dy%
                    IF d% < minDist% THEN minDist% = d% : targetP% = p%
                END IF
            NEXT p%
            IF targetP% = 0 THEN targetP% = 1

            dx% = ABS(Robot(c%).x + 7 - (Player(targetP%).x + 7))
            dy% = ABS(Robot(c%).y + 11 - (Player(targetP%).y + 15))

            IF Robot(c%).bullets = 0 THEN
                Robot(c%).fcount = Robot(c%).fcount + 1
                IF Robot(c%).xmcount THEN
                    Robot(c%).xmcount = Robot(c%).xmcount - 1
                    IF Robot(c%).xmcount = 0 THEN
                        Robot(c%).xmcount = INT(RND(1) * 150) + 150
                        Robot(c%).xmode   = INT(RND(1) * 2)
                    END IF
                END IF
                IF Robot(c%).ymcount THEN
                    Robot(c%).ymcount = Robot(c%).ymcount - 1
                    IF Robot(c%).ymcount = 0 THEN
                        Robot(c%).ymcount = INT(RND(1) * 150) + 150
                        Robot(c%).ymode   = INT(RND(1) * 2)
                    END IF
                END IF

                speedDelay = 15 - Room.level
                IF speedDelay < 0 THEN speedDelay = 0

                IF Robot(c%).fcount >= (Room.robots - Room.killed) + speedDelay THEN
                    Robot(c%).fcount = 0
                    Robot(c%).xdir   = SGN(Player(targetP%).x - Robot(c%).x)
                    Robot(c%).ydir   = SGN(Player(targetP%).y - Robot(c%).y)

                    _SOURCE Maze&
                    y% = Robot(c%).y + 4
                    DO
                        y% = y% + 1
                        IF POINT(Robot(c%).x + 7 + (Robot(c%).xdir * 6), y%) = _RGB32(0, 0, 255) THEN
                            Robot(c%).xdir = 0
                            EXIT DO
                        END IF
                    LOOP UNTIL y% = Robot(c%).y + 16
                    x% = Robot(c%).x + 4
                    DO
                        x% = x% + 1
                        IF POINT(x%, Robot(c%).y + 11 + (Robot(c%).ydir * 7)) = _RGB32(0, 0, 255) THEN
                            Robot(c%).ydir = 0
                            EXIT DO
                        END IF
                    LOOP UNTIL x% = Robot(c%).x + 8
                    _SOURCE _DEST

                    IF SQR(dx% * dx% + dy% * dy%) > Robot(c%).distance THEN
                        IF Robot(c%).xmode = 0 THEN Robot(c%).xdir = 0
                        IF Robot(c%).ymode = 0 THEN Robot(c%).ydir = 0
                    END IF
                    Robot(c%).x = Robot(c%).x + Robot(c%).xdir
                    Robot(c%).y = Robot(c%).y + Robot(c%).ydir
                END IF
            END IF

            IF Room.level > 1 THEN
                IF Robot(c%).bullets < Setting.maxRobotBullets THEN
                    IF Robot(c%).bcount = 0 THEN
                        IF INT(RND(1) * (Room.robots - Room.killed)) = 0 THEN
                            b% = 0
                            FOR i% = 1 TO 512
                                IF NOT Bullet(i%).alive THEN b% = i% : EXIT FOR
                            NEXT i%
                            IF b% > 0 THEN
                                Bullet(b%).y = Robot(c%).y + 11
                                a%           = INT(ANGLE!(c%, targetP%))
                                Fire%        = _TRUE
                                SELECT CASE INT(SQR(dx% * dx% + dy% * dy%))
                                    CASE IS > 200   : Dpm% = 2
                                    CASE 151 TO 200 : Dpm% = 3
                                    CASE 101 TO 150 : Dpm% = 4
                                    CASE 51 TO 100  : Dpm% = 5
                                    CASE IS < 51    : Dpm% = 10
                                END SELECT
                                SELECT CASE a%
                                    CASE 359 - Dpm% + 1 TO 359
                                        Xdir% = 0 : Ydir% = -1
                                        IF Room.level > 6 THEN Bullet(b%).x = Robot(c%).x - 2 ELSE Bullet(b%).x = Robot(c%).x + 16
                                    CASE 0
                                        Xdir% = 0 : Ydir% = -1
                                        IF Room.level > 6 THEN
                                            IF INT(RND(1) * 2) = 0 THEN Bullet(b%).x = Robot(c%).x - 2 ELSE Bullet(b%).x = Robot(c%).x + 16
                                        ELSE
                                            Bullet(b%).x = Robot(c%).x + 16
                                        END IF
                                    CASE 1 TO Dpm%                : Xdir% = 0 : Ydir% = -1 : Bullet(b%).x = Robot(c%).x + 16
                                    CASE 45 - Dpm% TO 45 + Dpm%   : Xdir% = 1 : Ydir% = -1 : Bullet(b%).x = Robot(c%).x + 16
                                    CASE 90 - Dpm% TO 90 + Dpm%   : Xdir% = 1 : Ydir% = 0  : Bullet(b%).x = Robot(c%).x + 16
                                    CASE 135 - Dpm% TO 135 + Dpm% : Xdir% = 1 : Ydir% = 1  : Bullet(b%).x = Robot(c%).x + 16
                                    CASE 180 - Dpm% TO 179        : Xdir% = 0 : Ydir% = 1  : Bullet(b%).x = Robot(c%).x + 16
                                    CASE 180
                                        Xdir% = 0 : Ydir% = 1
                                        IF Room.level > 6 THEN
                                            IF INT(RND(1) * 2) = 0 THEN Bullet(b%).x = Robot(c%).x + 16 ELSE Bullet(b%).x = Robot(c%).x - 2
                                        ELSE
                                            Bullet(b%).x = Robot(c%).x + 16
                                        END IF
                                    CASE 181 TO 180 + Dpm%
                                        Xdir% = 0 : Ydir% = 1
                                        IF Room.level > 6 THEN Bullet(b%).x = Robot(c%).x - 2 ELSE Bullet(b%).x = Robot(c%).x + 16
                                    CASE 225 - Dpm% TO 225 + Dpm% : Xdir% = -1 : Ydir% = 1  : Bullet(b%).x = Robot(c%).x - 2
                                    CASE 270 - Dpm% TO 270 + Dpm% : Xdir% = -1 : Ydir% = 0  : Bullet(b%).x = Robot(c%).x - 2
                                    CASE 315 - Dpm% TO 315 + Dpm% : Xdir% = -1 : Ydir% = -1 : Bullet(b%).x = Robot(c%).x - 2
                                    CASE ELSE                     : Fire% = _FALSE
                                END SELECT
                                IF Fire% THEN
                                    Bullet(b%).xdir  = Xdir% * LEVEL(Room.level).bspeed * 2
                                    Bullet(b%).ydir  = Ydir% * LEVEL(Room.level).bspeed * 2
                                    Bullet(b%).who   = c%
                                    Bullet(b%).alive = _TRUE
                                    Room.bullets = Room.bullets + 1
                                    Robot(c%).bullets = Robot(c%).bullets + 1
                                    Robot(c%).bcount = 15
                                    Robot(c%).xdir   = 0
                                    Robot(c%).ydir   = 0
                                    SafeSndPlay Rshoot&
                                END IF
                            END IF
                        END IF
                    END IF
                END IF
            END IF
        END IF
    NEXT c%
END SUB

SUB DRAWROBOTS()
    DIM Cdest&, c%, x%, y%, b%, bx%, by%, killer%, targetP%, minDist%, dx%, dy%, d%
    DIM p_shooter%
    Cdest& = _DEST

    IF NOT Setting.iddqd THEN
        IF Otto.acount THEN
            Otto.acount = Otto.acount - 1
            IF Otto.acount = 0 THEN
                Otto.alive  = _TRUE
                Otto.fcount = 0
                Otto.cell   = 0
                Otto.bounce = _FALSE
                SafeSndStop Ctaunt&
                SafeSndPlay IntruderAlert&
            END IF
        END IF
    END IF

    IF Otto.alive THEN
        IF Otto.bounce THEN
            Otto.fcount = Otto.fcount + 1
            IF Otto.fcount > Room.robots - Room.killed THEN
                Otto.fcount = 0
                Otto.yoffset = Otto.yoffset + Otto.yvel
                Otto.yvel = Otto.yvel - 2
                IF Otto.yoffset = 0 THEN
                    Otto.yvel = 7
                    Otto.cell = 3
                ELSE
                    Otto.cell = 5
                END IF

                targetP% = 0
                minDist% = 32000
                FOR p% = 1 TO Setting.numPlayers
                    IF Player(p%).alive THEN
                        dx% = ABS(Otto.x - Player(p%).x)
                        dy% = ABS(Otto.y - Player(p%).y)
                        d%  = dx% * dx% + dy% * dy%
                        IF d% < minDist% THEN minDist% = d% : targetP% = p%
                    END IF
                NEXT p%
                IF targetP% = 0 THEN targetP% = 1

                Otto.xdir = SGN(Player(targetP%).x - Otto.x)
                Otto.ydir = SGN(Player(targetP%).y + 7 - Otto.y)
                Otto.x = Otto.x + Otto.xdir
                Otto.y = Otto.y + Otto.ydir
            END IF
        ELSE
            IF Otto.fcount THEN Otto.fcount = Otto.fcount - 1
            IF Otto.fcount = 0 THEN
                Otto.cell = Otto.cell + 1
                IF Otto.cell = 4 THEN
                    Otto.bounce = _TRUE
                    Otto.fcount = 0
                ELSE
                    Otto.fcount = 5
                END IF
            END IF
        END IF
        _DEST OttoMask&
        Cls, LEVEL(Room.level).rcolor
        _PUTIMAGE(0, 0), Otto&(Otto.cell), OttoMask&
        _CLEARCOLOR _RGB32(0, 0, 0), OttoMask&
        _DEST Cdest&
        _PUTIMAGE(Otto.x, Otto.y - Otto.yoffset), OttoMask&
    END IF

    IF Room.killed = Room.robots THEN EXIT SUB

    FOR c% = 1 TO 256
        IF Robot(c%).hit THEN
            _DEST BoomMask&
            Cls, LEVEL(Room.level).rcolor
            _PUTIMAGE(0, 0), Boom&(Robot(c%).cell)
            _CLEARCOLOR _RGB32(0, 0, 0), BoomMask&
            _PUTIMAGE(Robot(c%).x - 8, Robot(c%).y - 6), BoomMask&, Cdest&
            Robot(c%).fcount = Robot(c%).fcount - 1
            IF Robot(c%).fcount% = 0 THEN
                Robot(c%).fcount = 5
                Robot(c%).cell = Robot(c%).cell + 1
                IF Robot(c%).cell = 4 THEN
                    Robot(c%).hit = _FALSE
                    Room.killed = Room.killed + 1
                END IF
            END IF
        END IF
    NEXT c%

    FOR c% = 1 TO 256
        IF Robot(c%).alive THEN
            _SOURCE Rmask&
            _DEST Rmask&
            _PUTIMAGE(0, 0), Cdest&, Rmask&,(Robot(c%).x, Robot(c%).y) -(Robot(c%).x + 15, Robot(c%).y + 23)
            _PUTIMAGE(0, 0), Rimage&(Robot(c%).cell, Robot(c%).dir)
            x%      = -1
            killer% = 0
            DO
                x% = x% + 1
                y% = -1
                DO
                    y% = y% + 1
                    IF POINT(x%, y%) <> _RGB32(0, 0, 0) THEN
                        IF Setting.wallsDeadly = 0 AND POINT(x%, y%) = _RGB32(0, 0, 255) THEN
                            ' Do nothing if walls are safe and it touches a blue pixel
                        ELSE
                            Robot(c%).hit    = _TRUE
                            Robot(c%).alive  = _FALSE
                            Robot(c%).cell   = 1
                            Robot(c%).fcount = 5
                            b%               = 0
                            DO
                                b% = b% + 1
                                IF Bullet(b%).alive THEN
                                    IF Bullet(b%).x <= Bullet(b%).oldx THEN bx% = Bullet(b%).x ELSE bx% = Bullet(b%).oldx
                                    IF Bullet(b%).y <= Bullet(b%).oldy THEN by% = Bullet(b%).y ELSE by% = Bullet(b%).oldy
                                    IF bx% <= Robot(c%).x + 15 THEN
                                        IF bx% + ABS(Bullet(b%).x - Bullet(b%).oldx) >= Robot(c%).x THEN
                                            IF by% <= Robot(c%).y + 23 THEN
                                                IF by% + ABS(Bullet(b%).y - Bullet(b%).oldy) >= Robot(c%).y THEN
                                                    Bullet(b%).alive = _FALSE
                                                    IF Bullet(b%).who < 0 THEN
                                                        p_shooter% = ABS(Bullet(b%).who)
                                                        Player(p_shooter%).bullets = Player(p_shooter%).bullets - 1
                                                        killer% = p_shooter%
                                                    ELSE
                                                        Robot(Bullet(b%).who).bullets = Robot(Bullet(b%).who).bullets - 1
                                                        Room.bullets = Room.bullets - 1
                                                    END IF
                                                END IF
                                            END IF
                                        END IF
                                    END IF
                                END IF
                            LOOP UNTIL b% = 512
                        END IF
                    END IF
                LOOP UNTIL y% = 23 OR Robot(c%).hit
            LOOP UNTIL x% = 15 OR Robot(c%).hit

            IF Robot(c%).hit THEN
                IF killer% > 0 THEN Player(killer%).score = Player(killer%).score + 50
                SafeSndPlay Killed&
            ELSE
                IF Robot(c%).xdir THEN
                    Robot(c%).dir = SGN(Robot(c%).xdir)
                    IF Robot(c%).fcount = 0 THEN
                        Robot(c%).cell = Robot(c%).cell - 1
                        IF Robot(c%).cell < 6 THEN Robot(c%).cell = 7
                    END IF
                ELSEIF Robot(c%).ydir THEN
                    IF Robot(c%).fcount = 0 THEN
                        Robot(c%).cell = Robot(c%).cell + 1
                        IF Robot(c%).cell > 5 THEN Robot(c%).cell = 2
                    END IF
                ELSE
                    Robot(c%).cell = 1
                END IF
            END IF
            Cls, LEVEL(Room.level).rcolor
            _PUTIMAGE(0, 0), Rimage&(Robot(c%).cell, Robot(c%).dir)
            IF Robot(c%).cell = 1 OR Robot(c%).ydir = 1 THEN
                IF Robot(c%).xdir = 0 THEN
                    Robot(c%).ecount = Robot(c%).ecount + 1
                    IF Robot(c%).ecount = 5 THEN
                        Robot(c%).ecount = 0
                        Robot(c%).eye = Robot(c%).eye + Robot(c%).eyedir
                        IF Robot(c%).eye <= 2 OR Robot(c%).eye >= 10 THEN
                            Robot(c%).eyedir = - Robot(c%).eyedir
                        END IF
                    END IF
                    LINE(Robot(c%).eye, 2) -(Robot(c%).eye + 1, 3), _RGB32(0, 0, 0), BF
                END IF
            END IF
            _CLEARCOLOR _RGB32(0, 0, 0), Rmask&
            _PUTIMAGE(Robot(c%).x, Robot(c%).y), Rmask&, Cdest&
        END IF
    NEXT c%
    _DEST Cdest&
END SUB

SUB GENERATEROBOTS(Heading%)
    DIM c%, zoneOk%, pl%, rCenterX%, rCenterY%
    DIM numDoors%
    DIM doorX(8) AS Integer, doorY(8) AS INTEGER
    DIM SlotID%, CellID%, SubSlot%, RCol%, RRow%, SubCol%, SubRow%
    DIM usedSlots(767) AS INTEGER
    DIM i%

    IF Setting.maxRobots > 0 THEN
        Room.robots = INT(RND(1) * 6) + 3
        IF Room.robots > Setting.maxRobots THEN Room.robots = Setting.maxRobots
        IF Room.robots < 1 THEN Room.robots = 1
    ELSE
        Room.robots = 0
    END IF

    FOR i% = 0 TO 767
        usedSlots(i%) = 0
    NEXT i%

    FOR c% = 1 TO 256
        Robot(c%).alive = _FALSE
        Robot(c%).hit   = _FALSE
    NEXT c%

    IF Setting.hasRobots = 1 THEN
        numDoors% = 4
        doorX(1)  = 368 : doorY(1) = 0
        doorX(2)  = 368 : doorY(2) = 615
        doorX(3)  = 0   : doorY(3) = 308
        doorX(4)  = 735 : doorY(4) = 308
    ELSE
        numDoors% = 8
        doorX(1)  = 0   : doorY(1) = 130
        doorX(2)  = 735 : doorY(2) = 130
        doorX(3)  = 214 : doorY(3) = 0
        doorX(4)  = 214 : doorY(4) = 615
        doorX(5)  = 0   : doorY(5) = 480
        doorX(6)  = 735 : doorY(6) = 480
        doorX(7)  = 510 : doorY(7) = 0
        doorX(8)  = 510 : doorY(8) = 615
    END IF

    IF Room.robots > 0 THEN
        FOR c% = 1 TO Room.robots
            DO
                zoneOk% = _TRUE
                SlotID% = INT(RND(1) * 768)

                IF usedSlots(SlotID%) = 1 THEN
                    zoneOk% = _FALSE
                ELSE
                    CellID%  = SlotID% \ 16
                    SubSlot% = SlotID% MOD 16
                    RCol%    = CellID% MOD 8
                    RRow%    = CellID% \ 8
                    SubCol%  = SubSlot% MOD 4
                    SubRow%  = SubSlot% \ 4

                    ' Generate mapped coordinates safely centered within cell parameters (8x6 subgrid cell dimensions)
                    Robot(c%).x = RCol% * 92 + 10 + (SubCol% * 20)
                    Robot(c%).y = RRow% * 102 + 10 + (SubRow% * 20)

                    ' Verify robots are not spawned within 90x90 exclusion zone around ANY door
                    rCenterX% = Robot(c%).x + 8
                    rCenterY% = Robot(c%).y + 12

                    FOR pl% = 1 TO numDoors%
                        IF rCenterX% <= doorX(pl%) + 45 AND rCenterX% >= doorX(pl%) -45 THEN
                            IF rCenterY% <= doorY(pl%) + 45 AND rCenterY% >= doorY(pl%) -45 THEN
                                zoneOk% = _FALSE
                            END IF
                        END IF
                    NEXT pl%

                    ' Verify robots are not spawned within 90x90 exclusion zone around ANY active player
                    IF zoneOk% THEN
                        FOR pl% = 1 TO Setting.numPlayers
                            IF Player(pl%).alive THEN
                                IF ABS(rCenterX%-(Player(pl%).x + 8)) <= 45 AND ABS(rCenterY%-(Player(pl%).y + 16)) <= 45 THEN
                                    zoneOk% = _FALSE
                                    EXIT FOR
                                END IF
                            END IF
                        NEXT pl%
                    END IF
                END IF
            LOOP UNTIL zoneOk%

            usedSlots(SlotID%) = 1
            Robot(c%).alive    = _TRUE
            Robot(c%).cell     = 1
            Robot(c%).dir      = 1
            Robot(c%).xdir     = 0
            Robot(c%).ydir     = 0
            Robot(c%).eye      = 6
            DO
                Robot(c%).eyedir = INT(RND(1) * 2) - INT(RND(1) * 2)
            LOOP UNTIL Robot(c%).eyedir <> 0
            Robot(c%).ecount   = 0
            Robot(c%).fcount   = INT(RND(1) * Room.robots)
            Robot(c%).bullets  = 0
            Robot(c%).bcount   = 0
            Robot(c%).xmode    = INT(RND(1) * 2)
            Robot(c%).ymode    = INT(RND(1) * 2)
            Robot(c%).xmcount  = INT(RND(1) * 150) + 150
            Robot(c%).ymcount  = INT(RND(1) * 150) + 150
            Robot(c%).distance = INT(RND(1) * 75) + 25
        NEXT c%
    END IF
END SUB

SUB RANDOMTAUNT()
END SUB

' =============================================================================
' ASSET LOAD & RECOLORING
' =============================================================================
SUB LOADASSETS()
    DIM Sheet&, c%, x%, y%, p%, d%

    Sheet&     = _LOADIMAGE(m_ProgramPath$ + CIMAGEFOLDER + "\" + "QBzerkSH.png", 32)
    QBZerk64l& = _LOADIMAGE(m_ProgramPath$ + CIMAGEFOLDER + "\" + "QBzerk64.png", 32)
    Maze3D&    = _LOADIMAGE(m_ProgramPath$ + CIMAGEFOLDER + "\" + "QBzerk3D.png", 32)

    PmaskTest& = _NEWIMAGE(16, 32, 32)
    Rmask&     = _NEWIMAGE(16, 24, 32)
    OttoMask&  = _NEWIMAGE(16, 16, 32)
    BoomMask&  = _NEWIMAGE(32, 36, 32)
    FlashMask& = _NEWIMAGE(16, 34, 32)
    Maze&      = _NEWIMAGE(736, 616, 32)
    WorkRoom&  = _NEWIMAGE(736, 616, 32)
    BlankRoom& = _NEWIMAGE(736, 616, 32)

    Font72& = _LOADFONT("verdana.ttf", 72)
    Font48& = _LOADFONT("verdana.ttf", 48)
    Font36& = _LOADFONT("verdana.ttf", 36)
    Font24& = _LOADFONT("verdana.ttf", 24)
    Font14& = _LOADFONT("verdana.ttf", 14)
    Font12& = _LOADFONT("verdana.ttf", 12)
    Font10& = _LOADFONT("verdana.ttf", 10)

    UPDATEBLANKROOM

    ' Pillar Coordinates (7 Columns x 5 Rows = 35 Pillars)
    FOR y% = 0 TO 4
        FOR x% = 0 TO 6
            P(y% * 7 + x% + 1).x = 92 + (x% * 92)
            P(y% * 7 + x% + 1).y = 102 + (y% * 102)
        NEXT x%
    NEXT y%

    ' Robot Generation Anchor Zones mapped natively to expanded arrays
    FOR c% = 1 TO 256
        Robot(c%).zx = 30 + ((c% MOD 4) * 150)
        Robot(c%).zy = 30 + (((c% \ 4) MOD 4) * 110)
    NEXT c%

    ' Load Player 1 Green Base Sprites & Mask (Upscaled to 2x)
    FOR c% = 0 TO 8
        Pimage&(1, c% + 1, 1)   = _NEWIMAGE(16, 32, 32)
        Pimage&(1, c% + 1, - 1) = _NEWIMAGE(16, 32, 32)
        Pmask&(1, c% + 1, 1)    = _NEWIMAGE(16, 32, 32)
        Pmask&(1, c% + 1, - 1)  = _NEWIMAGE(16, 32, 32)
        _PUTIMAGE(0, 0) -(15, 31), Sheet&, Pimage&(1, c% + 1, 1),(c% * 8, 36) -(c% * 8 + 7, 51)
        _PUTIMAGE(0, 0), Pimage&(1, c% + 1, 1), Pimage&(1, c% + 1, - 1),(15, 0) -(0, 31)
        Pmask&(1, c% + 1, - 1) = _COPYIMAGE(Pimage&(1, c% + 1, -1))
        Pmask&(1, c% + 1, 1)   = _COPYIMAGE(Pimage&(1, c% + 1, 1))
        _CLEARCOLOR _RGB32(0, 0, 0), Pimage&(1, c% + 1, - 1)
        _CLEARCOLOR _RGB32(0, 0, 0), Pimage&(1, c% + 1, 1)
        _CLEARCOLOR _RGB32(0, 255, 0), Pmask&(1, c% + 1, - 1)
        _CLEARCOLOR _RGB32(0, 255, 0), Pmask&(1, c% + 1, 1)
    NEXT c%

    ' Generate Tinted Sprites & Correct Masks for Players 2..8
    FOR p% = 2 TO 8
        FOR c% = 1 TO 9
            FOR d% = -1 TO 1 STEP 2
                Pimage&(p%, c%, d%) = _COPYIMAGE(Pimage&(1, c%, d%))
                Pmask&(p%, c%, d%)  = _COPYIMAGE(Pmask&(1, c%, d%))
                _SOURCE Pimage&(p%, c%, d%)
                _DEST Pimage&(p%, c%, d%)
                FOR x% = 0 TO 15
                    FOR y% = 0 TO 31
                        IF POINT(x%, y%) = _RGB32(0, 255, 0) THEN
                            PSET(x%, y%), PlayerColor&(p%)
                        END IF
                    NEXT y%
                NEXT x%
                _CLEARCOLOR _RGB32(0, 0, 0), Pimage&(p%, c%, d%)

                ' Recolor collision mask and set transparent color to Player's tint!
                _SOURCE Pmask&(p%, c%, d%)
                _DEST Pmask&(p%, c%, d%)
                FOR x% = 0 TO 15
                    FOR y% = 0 TO 31
                        IF POINT(x%, y%) = _RGB32(0, 255, 0) THEN
                            PSET(x%, y%), PlayerColor&(p%)
                        END IF
                    NEXT y%
                NEXT x%
                _CLEARCOLOR PlayerColor&(p%), Pmask&(p%, c%, d%)
            NEXT d%
        NEXT c%
    NEXT p%

    ' Font and Robot Sprites (Upscaled logic included)
    FOR c% = 0 TO 25
        Font&(c% + 11) = _NEWIMAGE(8, 12, 32)
        Font&(c% + 37) = _NEWIMAGE(8, 12, 32)
        _PUTIMAGE(0, 0), Sheet&, Font&(c% + 11),(c% * 8, 12) -(c% * 8 + 7, 23)
        _PUTIMAGE(0, 0), Sheet&, Font&(c% + 37),(c% * 8, 24) -(c% * 8 + 7, 35)

        IF c% < 3 THEN
            Boom&(c% + 1) = _NEWIMAGE(32, 36, 32)
            _PUTIMAGE(0, 0) -(31, 35), Sheet&, Boom&(c% + 1),(144 + c% * 16, 36) -(159 + c% * 18, 53)
        END IF
        IF c% < 4 THEN
            Flash&(c% + 1) = _NEWIMAGE(16, 34, 32)
            _PUTIMAGE(0, 0) -(15, 33), Sheet&, Flash&(c% + 1),(72 + c% * 8, 36) -(79 + c% * 8, 52)
        END IF
        IF c% < 5 THEN
            Rimage&(c% + 1, - 1) = _NEWIMAGE(16, 24, 32)
            Rimage&(c% + 1, 1)   = _NEWIMAGE(16, 24, 32)
            _PUTIMAGE(0, 0) -(15, 23), Sheet&, Rimage&(c% + 1, 1),(104 + c% * 8, 36) -(111 + c% * 8, 47)
            _PUTIMAGE(0, 0), Rimage&(c% + 1, 1), Rimage&(c% + 1, - 1),(15, 0) -(0, 23)
        END IF
        IF c% < 10 THEN
            Font&(c% + 1) = _NEWIMAGE(8, 12, 32)
            _PUTIMAGE(0, 0), Sheet&, Font&(c% + 1),(c% * 8, 0) -(c% * 8 + 7, 11)
        END IF
    NEXT c%

    ' FIX: Arrange robot walking sequences so horizontal animations map properly
    Rimage&(7, - 1) = _COPYIMAGE(Rimage&(5, -1))
    Rimage&(6, - 1) = _COPYIMAGE(Rimage&(4, -1))
    Rimage&(5, - 1) = _COPYIMAGE(Rimage&(1, -1))
    Rimage&(4, - 1) = _COPYIMAGE(Rimage&(3, -1))
    Rimage&(3, - 1) = _COPYIMAGE(Rimage&(1, -1))
    Rimage&(7, 1)   = _COPYIMAGE(Rimage&(5, 1))
    Rimage&(6, 1)   = _COPYIMAGE(Rimage&(4, 1))
    Rimage&(5, 1)   = _COPYIMAGE(Rimage&(1, 1))
    Rimage&(4, 1)   = _COPYIMAGE(Rimage&(3, 1))
    Rimage&(3, 1)   = _COPYIMAGE(Rimage&(1, 1))

    Pshoot&         = _SNDOPEN(m_ProgramPath$ + CSOUNDFOLDER + "\" + "QBzerkPS.ogg", "VOL,SYNC")
    Killed&         = _SNDOPEN(m_ProgramPath$ + CSOUNDFOLDER + "\" + "QBzerkRD.ogg", "VOL,SYNC")
    GotTheHumanoid& = _SNDOPEN(m_ProgramPath$ + CSOUNDFOLDER + "\" + "QBzerkGI.ogg", "VOL,SYNC")
    _FREEIMAGE Sheet&
END SUB

SUB SETUPDEFAULTCONTROLS()
    ' Standard DirectInput keyboard scancodes shifted exactly to align with native device mappings

    ' Player 1: Arrow Keys + R Ctrl
    m_arrControlMap(1, CINPUTUP).device        = 1 : m_arrControlMap(1, CINPUTUP).typ = CINPUTKEY      : m_arrControlMap(1, CINPUTUP).code = 329      : m_arrControlMap(1, CINPUTUP).value = -1
    m_arrControlMap(1, CINPUTDOWN).device      = 1 : m_arrControlMap(1, CINPUTDOWN).typ = CINPUTKEY    : m_arrControlMap(1, CINPUTDOWN).code = 337    : m_arrControlMap(1, CINPUTDOWN).value = 1
    m_arrControlMap(1, CINPUTLEFT).device      = 1 : m_arrControlMap(1, CINPUTLEFT).typ = CINPUTKEY    : m_arrControlMap(1, CINPUTLEFT).code = 332    : m_arrControlMap(1, CINPUTLEFT).value = -1
    m_arrControlMap(1, CINPUTRIGHT).device     = 1 : m_arrControlMap(1, CINPUTRIGHT).typ = CINPUTKEY   : m_arrControlMap(1, CINPUTRIGHT).code = 334   : m_arrControlMap(1, CINPUTRIGHT).value = 1
    m_arrControlMap(1, CINPUTBUTTON1).device   = 1 : m_arrControlMap(1, CINPUTBUTTON1).typ = CINPUTKEY : m_arrControlMap(1, CINPUTBUTTON1).code = 286 : m_arrControlMap(1, CINPUTBUTTON1).value = -1
    m_arrControlMap(1, CINPUTFIREUP).device    = 0
    m_arrControlMap(1, CINPUTFIREDOWN).device  = 0
    m_arrControlMap(1, CINPUTFIRELEFT).device  = 0
    m_arrControlMap(1, CINPUTFIRERIGHT).device = 0

    ' Player 2: Numpad 5,2,1,3 + 6
    m_arrControlMap(2, CINPUTUP).device      = 1 : m_arrControlMap(2, CINPUTUP).typ = CINPUTKEY      : m_arrControlMap(2, CINPUTUP).code = 77      : m_arrControlMap(2, CINPUTUP).value = -1
    m_arrControlMap(2, CINPUTDOWN).device    = 1 : m_arrControlMap(2, CINPUTDOWN).typ = CINPUTKEY    : m_arrControlMap(2, CINPUTDOWN).code = 81    : m_arrControlMap(2, CINPUTDOWN).value = 1
    m_arrControlMap(2, CINPUTLEFT).device    = 1 : m_arrControlMap(2, CINPUTLEFT).typ = CINPUTKEY    : m_arrControlMap(2, CINPUTLEFT).code = 80    : m_arrControlMap(2, CINPUTLEFT).value = -1
    m_arrControlMap(2, CINPUTRIGHT).device   = 1 : m_arrControlMap(2, CINPUTRIGHT).typ = CINPUTKEY   : m_arrControlMap(2, CINPUTRIGHT).code = 82   : m_arrControlMap(2, CINPUTRIGHT).value = 1
    m_arrControlMap(2, CINPUTBUTTON1).device = 1 : m_arrControlMap(2, CINPUTBUTTON1).typ = CINPUTKEY : m_arrControlMap(2, CINPUTBUTTON1).code = 78 : m_arrControlMap(2, CINPUTBUTTON1).value = -1

    ' Player 3: 1, Q, Tab, W, 2
    m_arrControlMap(3, CINPUTUP).device      = 1 : m_arrControlMap(3, CINPUTUP).typ = CINPUTKEY      : m_arrControlMap(3, CINPUTUP).code = 3      : m_arrControlMap(3, CINPUTUP).value = -1
    m_arrControlMap(3, CINPUTDOWN).device    = 1 : m_arrControlMap(3, CINPUTDOWN).typ = CINPUTKEY    : m_arrControlMap(3, CINPUTDOWN).code = 17   : m_arrControlMap(3, CINPUTDOWN).value = 1
    m_arrControlMap(3, CINPUTLEFT).device    = 1 : m_arrControlMap(3, CINPUTLEFT).typ = CINPUTKEY    : m_arrControlMap(3, CINPUTLEFT).code = 16   : m_arrControlMap(3, CINPUTLEFT).value = -1
    m_arrControlMap(3, CINPUTRIGHT).device   = 1 : m_arrControlMap(3, CINPUTRIGHT).typ = CINPUTKEY   : m_arrControlMap(3, CINPUTRIGHT).code = 18  : m_arrControlMap(3, CINPUTRIGHT).value = 1
    m_arrControlMap(3, CINPUTBUTTON1).device = 1 : m_arrControlMap(3, CINPUTBUTTON1).typ = CINPUTKEY : m_arrControlMap(3, CINPUTBUTTON1).code = 4 : m_arrControlMap(3, CINPUTBUTTON1).value = -1

    ' Player 4: E, D, S, F, R
    m_arrControlMap(4, CINPUTUP).device      = 1 : m_arrControlMap(4, CINPUTUP).typ = CINPUTKEY      : m_arrControlMap(4, CINPUTUP).code = 19      : m_arrControlMap(4, CINPUTUP).value = -1
    m_arrControlMap(4, CINPUTDOWN).device    = 1 : m_arrControlMap(4, CINPUTDOWN).typ = CINPUTKEY    : m_arrControlMap(4, CINPUTDOWN).code = 33    : m_arrControlMap(4, CINPUTDOWN).value = 1
    m_arrControlMap(4, CINPUTLEFT).device    = 1 : m_arrControlMap(4, CINPUTLEFT).typ = CINPUTKEY    : m_arrControlMap(4, CINPUTLEFT).code = 32    : m_arrControlMap(4, CINPUTLEFT).value = -1
    m_arrControlMap(4, CINPUTRIGHT).device   = 1 : m_arrControlMap(4, CINPUTRIGHT).typ = CINPUTKEY   : m_arrControlMap(4, CINPUTRIGHT).code = 34   : m_arrControlMap(4, CINPUTRIGHT).value = 1
    m_arrControlMap(4, CINPUTBUTTON1).device = 1 : m_arrControlMap(4, CINPUTBUTTON1).typ = CINPUTKEY : m_arrControlMap(4, CINPUTBUTTON1).code = 20 : m_arrControlMap(4, CINPUTBUTTON1).value = -1

    ' Player 5: G, B, V, N, H
    m_arrControlMap(5, CINPUTUP).device      = 1 : m_arrControlMap(5, CINPUTUP).typ = CINPUTKEY      : m_arrControlMap(5, CINPUTUP).code = 35      : m_arrControlMap(5, CINPUTUP).value = -1
    m_arrControlMap(5, CINPUTDOWN).device    = 1 : m_arrControlMap(5, CINPUTDOWN).typ = CINPUTKEY    : m_arrControlMap(5, CINPUTDOWN).code = 49    : m_arrControlMap(5, CINPUTDOWN).value = 1
    m_arrControlMap(5, CINPUTLEFT).device    = 1 : m_arrControlMap(5, CINPUTLEFT).typ = CINPUTKEY    : m_arrControlMap(5, CINPUTLEFT).code = 48    : m_arrControlMap(5, CINPUTLEFT).value = -1
    m_arrControlMap(5, CINPUTRIGHT).device   = 1 : m_arrControlMap(5, CINPUTRIGHT).typ = CINPUTKEY   : m_arrControlMap(5, CINPUTRIGHT).code = 50   : m_arrControlMap(5, CINPUTRIGHT).value = 1
    m_arrControlMap(5, CINPUTBUTTON1).device = 1 : m_arrControlMap(5, CINPUTBUTTON1).typ = CINPUTKEY : m_arrControlMap(5, CINPUTBUTTON1).code = 36 : m_arrControlMap(5, CINPUTBUTTON1).value = -1

    ' Player 6: 8, I, U, O, 9
    m_arrControlMap(6, CINPUTUP).device      = 1 : m_arrControlMap(6, CINPUTUP).typ = CINPUTKEY      : m_arrControlMap(6, CINPUTUP).code = 10      : m_arrControlMap(6, CINPUTUP).value = -1
    m_arrControlMap(6, CINPUTDOWN).device    = 1 : m_arrControlMap(6, CINPUTDOWN).typ = CINPUTKEY    : m_arrControlMap(6, CINPUTDOWN).code = 24    : m_arrControlMap(6, CINPUTDOWN).value = 1
    m_arrControlMap(6, CINPUTLEFT).device    = 1 : m_arrControlMap(6, CINPUTLEFT).typ = CINPUTKEY    : m_arrControlMap(6, CINPUTLEFT).code = 23    : m_arrControlMap(6, CINPUTLEFT).value = -1
    m_arrControlMap(6, CINPUTRIGHT).device   = 1 : m_arrControlMap(6, CINPUTRIGHT).typ = CINPUTKEY   : m_arrControlMap(6, CINPUTRIGHT).code = 25   : m_arrControlMap(6, CINPUTRIGHT).value = 1
    m_arrControlMap(6, CINPUTBUTTON1).device = 1 : m_arrControlMap(6, CINPUTBUTTON1).typ = CINPUTKEY : m_arrControlMap(6, CINPUTBUTTON1).code = 11 : m_arrControlMap(6, CINPUTBUTTON1).value = -1

    ' Player 7: P, SemiC, L, APOS, [
    m_arrControlMap(7, CINPUTUP).device      = 1 : m_arrControlMap(7, CINPUTUP).typ = CINPUTKEY      : m_arrControlMap(7, CINPUTUP).code = 26      : m_arrControlMap(7, CINPUTUP).value = -1
    m_arrControlMap(7, CINPUTDOWN).device    = 1 : m_arrControlMap(7, CINPUTDOWN).typ = CINPUTKEY    : m_arrControlMap(7, CINPUTDOWN).code = 40    : m_arrControlMap(7, CINPUTDOWN).value = 1
    m_arrControlMap(7, CINPUTLEFT).device    = 1 : m_arrControlMap(7, CINPUTLEFT).typ = CINPUTKEY    : m_arrControlMap(7, CINPUTLEFT).code = 39    : m_arrControlMap(7, CINPUTLEFT).value = -1
    m_arrControlMap(7, CINPUTRIGHT).device   = 1 : m_arrControlMap(7, CINPUTRIGHT).typ = CINPUTKEY   : m_arrControlMap(7, CINPUTRIGHT).code = 41   : m_arrControlMap(7, CINPUTRIGHT).value = 1
    m_arrControlMap(7, CINPUTBUTTON1).device = 1 : m_arrControlMap(7, CINPUTBUTTON1).typ = CINPUTKEY : m_arrControlMap(7, CINPUTBUTTON1).code = 27 : m_arrControlMap(7, CINPUTBUTTON1).value = -1

    ' Player 8: NK *, NK 9, NK 8, NK +, NK -
    m_arrControlMap(8, CINPUTUP).device      = 1 : m_arrControlMap(8, CINPUTUP).typ = CINPUTKEY      : m_arrControlMap(8, CINPUTUP).code = 56      : m_arrControlMap(8, CINPUTUP).value = -1
    m_arrControlMap(8, CINPUTDOWN).device    = 1 : m_arrControlMap(8, CINPUTDOWN).typ = CINPUTKEY    : m_arrControlMap(8, CINPUTDOWN).code = 74    : m_arrControlMap(8, CINPUTDOWN).value = 1
    m_arrControlMap(8, CINPUTLEFT).device    = 1 : m_arrControlMap(8, CINPUTLEFT).typ = CINPUTKEY    : m_arrControlMap(8, CINPUTLEFT).code = 73    : m_arrControlMap(8, CINPUTLEFT).value = -1
    m_arrControlMap(8, CINPUTRIGHT).device   = 1 : m_arrControlMap(8, CINPUTRIGHT).typ = CINPUTKEY   : m_arrControlMap(8, CINPUTRIGHT).code = 79   : m_arrControlMap(8, CINPUTRIGHT).value = 1
    m_arrControlMap(8, CINPUTBUTTON1).device = 1 : m_arrControlMap(8, CINPUTBUTTON1).typ = CINPUTKEY : m_arrControlMap(8, CINPUTBUTTON1).code = 75 : m_arrControlMap(8, CINPUTBUTTON1).value = -1

    m_bHaveMapping = _TRUE
END SUB

SUB InitKeyboardButtonCodes()
    DIM i%
    FOR i% = 0 TO 512 : m_arrButtonKeyDesc(i%) = "": Next i%

    m_arrButtonKeyDesc(329) = "Up"
    m_arrButtonKeyDesc(337) = "Down"
    m_arrButtonKeyDesc(332) = "Left"
    m_arrButtonKeyDesc(334) = "Right"
    m_arrButtonKeyDesc(286) = "CtrlR"

    m_arrButtonKeyDesc(77) = "NK5"
    m_arrButtonKeyDesc(81) = "NK2"
    m_arrButtonKeyDesc(80) = "NK1"
    m_arrButtonKeyDesc(82) = "NK3"
    m_arrButtonKeyDesc(78) = "NK6"

    m_arrButtonKeyDesc(3)  = "1"
    m_arrButtonKeyDesc(17) = "Q"
    m_arrButtonKeyDesc(16) = "Tab"
    m_arrButtonKeyDesc(18) = "W"
    m_arrButtonKeyDesc(4)  = "2"

    m_arrButtonKeyDesc(19) = "E"
    m_arrButtonKeyDesc(33) = "D"
    m_arrButtonKeyDesc(32) = "S"
    m_arrButtonKeyDesc(34) = "F"
    m_arrButtonKeyDesc(20) = "R"

    m_arrButtonKeyDesc(35) = "G"
    m_arrButtonKeyDesc(49) = "B"
    m_arrButtonKeyDesc(48) = "V"
    m_arrButtonKeyDesc(50) = "N"
    m_arrButtonKeyDesc(36) = "H"

    m_arrButtonKeyDesc(10) = "8"
    m_arrButtonKeyDesc(24) = "i"
    m_arrButtonKeyDesc(23) = "U"
    m_arrButtonKeyDesc(25) = "o"
    m_arrButtonKeyDesc(11) = "9"

    m_arrButtonKeyDesc(26) = "P"
    m_arrButtonKeyDesc(40) = "SemiC"
    m_arrButtonKeyDesc(39) = "L"
    m_arrButtonKeyDesc(41) = "Apos"
    m_arrButtonKeyDesc(27) = "["

    m_arrButtonKeyDesc(56) = "NK*"
    m_arrButtonKeyDesc(74) = "NK9"
    m_arrButtonKeyDesc(73) = "NK8"
    m_arrButtonKeyDesc(79) = "NK+"
    m_arrButtonKeyDesc(75) = "NK-"
END SUB

FUNCTION GetKeyDesc$(d%, t%, c%)
    IF d% = 0 THEN
        GetKeyDesc$ = "UNBOUND"
    ELSEIF t% = CINPUTKEY THEN
        IF c% >= 0 AND c% <= 512 THEN
            IF m_arrButtonKeyDesc(c%) <> "" Then
                GetKeyDesc$ = m_arrButtonKeyDesc(c%)
            ELSE
                GetKeyDesc$ = "KEY " + LTrim$(Str$(c%))
            END IF
        ELSE
            GetKeyDesc$ = "UNKNOWN"
        END IF
    ELSEIF t% = CINPUTBUTTON THEN
        GetKeyDesc$ = "BTN " + LTrim$(Str$(c%))
    ELSEIF t% = CINPUTAXIS THEN
        GetKeyDesc$ = "AXIS " + LTrim$(Str$(c%))
    ELSE
        GetKeyDesc$ = "ERR"
    END IF
END FUNCTION

SUB HIGHSCORES(Mode%)
END SUB

' =============================================================================
' SCREEN & DISPLAY
' =============================================================================
SUB SETSCREENMODE()
    MainScreen& = _NEWIMAGE(1024, 768, 32)
    SCREEN MainScreen&
    '_ScreenMove _Middle
    _DEST WorkRoom&
END SUB

SUB DRAWTEXT(x%, y%, t$, c~&)
    DIM temp&, l%, a%, Cdest&
    Cdest& = _DEST
    temp&  = _NEWIMAGE(LEN(t$) * 8, 12, 32)
    _DEST temp&
    Cls, c~&
    FOR l% = 1 TO LEN(t$)
        a% = ASC(MID$(t$, l%, 1))
        SELECT CASE a%
            CASE 32        : a% = 0 ' Space
            CASE 48 TO 57  : a% = a%-47
            CASE 65 TO 90  : a% = a%-54
            CASE 97 TO 122 : a% = a%-60
        END SELECT
        IF a% = 0 THEN
            LINE((l% - 1) * 8, 0) -((l%-1) * 8 + 7, 11), _RGB32(0, 0, 0), BF
        ELSE
            _PUTIMAGE((l% - 1) * 8, 0), Font&(a%)
        END IF
    NEXT l%
    _CLEARCOLOR _RGB32(0, 0, 0)
    _DEST Cdest&
    _PUTIMAGE(x%, y%), temp&
    _FREEIMAGE temp&
END SUB

SUB CONFIGCONTROLS_INLINE(targetP%, forceBerzerk%)
    DIM CurrentControl%, KeyPress$, bound%, code%, d%
    DIM promptStr$, actionName$
    DIM controlList(1 TO 9) AS INTEGER
    DIM numControls AS INTEGER
    DIM i           AS INTEGER

    IF Setting.fireStyle = 0 OR forceBerzerk% THEN
        ' BERZERK: Up, Down, Left, Right, FireButton
        controlList(1) = 1
        controlList(2) = 2
        controlList(3) = 3
        controlList(4) = 4
        controlList(5) = 5
        numControls    = 5
    ELSE
        ' ROBOTRON: Up, Down, Left, Right, FireUp, FireDown, FireLeft, FireRight
        controlList(1) = 1
        controlList(2) = 2
        controlList(3) = 3
        controlList(4) = 4
        controlList(5) = 6
        controlList(6) = 7
        controlList(7) = 8
        controlList(8) = 9
        numControls    = 8
    END IF

    FOR i = 1 TO numControls
        CurrentControl% = controlList(i)

        SELECT CASE CurrentControl%
            CASE 1 : actionName$ = "UP"
            CASE 2 : actionName$ = "DOWN"
            CASE 3 : actionName$ = "LEFT"
            CASE 4 : actionName$ = "RIGHT"
            CASE 5 : actionName$ = "FIRE"
            CASE 6 : actionName$ = "FIRE UP"
            CASE 7 : actionName$ = "FIRE DOWN"
            CASE 8 : actionName$ = "FIRE LEFT"
            CASE 9 : actionName$ = "FIRE RIGHT"
        END SELECT

        _KEYCLEAR
        bound% = _FALSE
        DO
            _LIMIT 30

            ' Clear prompt line area above table (same coordinates as header)
            LINE(100, 390) -(930, 420), _RGB32(0, 0, 0), BF

            DIM flashClr AS _UNSIGNED LONG
            DIM flashInt AS LONG
            flashInt = 128 + 127 * SIN(TIMER * 8)
            flashClr = _RGB32(0, flashInt, 0)

            _FONT Font24&
            COLOR flashClr
            promptStr$ = "PRESS KEY OR MOVE CONTROLLER FOR P" + LTrim$(Str$(targetP%)) + " " + actionName$
            _PRINTSTRING(105, 395), promptStr$
            _PRINTSTRING(925 - _PRINTWIDTH("(ESC TO EXIT)"), 395), "(ESC TO EXIT)"
            _DISPLAY

            KeyPress$ = INKEY$
            IF KeyPress$ = CHR$(27) THEN EXIT SUB

            WHILE _DEVICEINPUT(1) : WEND
            FOR code% = 1 TO 512
                IF _BUTTON(code%) AND code% <> 27 AND code% <> 13 AND code% <> 9 THEN
                    m_arrControlMap(targetP%, CurrentControl%).device = 1
                    m_arrControlMap(targetP%, CurrentControl%).typ    = CINPUTKEY
                    m_arrControlMap(targetP%, CurrentControl%).code   = code%
                    m_arrControlMap(targetP%, CurrentControl%).value  = _TRUE
                    bound%                                            = _TRUE
                    EXIT FOR
                END IF
            NEXT code%
            IF bound% THEN EXIT DO

            FOR d% = 3 TO _DEVICES
                WHILE _DEVICEINPUT(d%) : WEND
                FOR code% = 1 TO _LASTBUTTON(d%)
                    IF _BUTTON(code%) THEN
                        m_arrControlMap(targetP%, CurrentControl%).device = d%
                        m_arrControlMap(targetP%, CurrentControl%).typ    = CINPUTBUTTON
                        m_arrControlMap(targetP%, CurrentControl%).code   = code%
                        m_arrControlMap(targetP%, CurrentControl%).value  = _TRUE
                        bound%                                            = _TRUE : EXIT FOR
                    END IF
                NEXT code%
                IF bound% THEN EXIT DO

                FOR code% = 1 TO _LASTAXIS(d%)
                    IF ABS(_AXIS(code%)) > 0.5 THEN
                        m_arrControlMap(targetP%, CurrentControl%).device = d%
                        m_arrControlMap(targetP%, CurrentControl%).typ    = CINPUTAXIS
                        m_arrControlMap(targetP%, CurrentControl%).code   = code%
                        m_arrControlMap(targetP%, CurrentControl%).value  = SGN(_AXIS(code%))
                        bound%                                            = _TRUE : EXIT FOR
                    END IF
                NEXT code%
                IF bound% THEN EXIT DO
            NEXT d%
        LOOP UNTIL bound%

        _KEYCLEAR
        _DELAY 0.2
    NEXT i

    ' Clear prompt area after completion
    LINE(100, 390) -(930, 420), _RGB32(0, 0, 0), BF
    _KEYCLEAR : _DELAY 0.5
END SUB

SUB INTRO()
    DIM k$
    DIM borderLeft%, borderRight%, borderTop%, borderBottom%
    DIM txX%, txY%, rowH%, tcX%, p%
    DIM   colW(1 TO 10) AS INTEGER
    DIM rowY%
    DIM kU$, kD$, kL$, kR$, kF$, kFU$, kFD$, kFL$, kFR$
    DIM s$

    borderLeft%   = 11
    borderRight%  = 1024 - 11
    borderTop%    = 104
    borderBottom% = 768 - 28

    DO
        _DEST MainScreen&
        CLS

        ' Draw Top Headers
        _FONT Font48&
        COLOR _RGB32(255, 216, 0) : _PRINTSTRING(10, 6), "Fast Zap'em "
        COLOR _RGB32(0, 255, 0)   : _PRINTSTRING(310, 6), "Berzerkotron"

        _FONT Font24&
         COLOR _RGB32(255, 255, 255) : _PRINTSTRING(620, 20), "by Softintheheadware"

        _FONT Font12&
        COLOR _RGB32(128, 128, 128)
        _PRINTSTRING(10, 60), "based on QBZerk by Terry Ritchie based on Berzerk by Alan McNeil / Stern Electronics"

        ' Top Right UI Panel
        IF _FULLSCREEN THEN
            COLOR _RGB32(128, 128, 128) : _PRINTSTRING(888, 3), "[HOME] FULLSCREEN"
            COLOR _RGB32(255, 255, 255) : _PRINTSTRING(888, 23), "[END] WINDOWED"
        ELSE
            COLOR _RGB32(255, 255, 255) : _PRINTSTRING(888, 3), "[HOME] FULLSCREEN"
            COLOR _RGB32(128, 128, 128) : _PRINTSTRING(888, 23), "[END] WINDOWED"
        END IF
         COLOR _RGB32(255, 255, 255) : _PRINTSTRING(888, 43), "[ESC] QUIT GAME"

        ' Bottom left/right info text
        _FONT Font10&
        COLOR _RGB32(128, 128, 128)
        _PRINTSTRING(20, 750), "REPLACE WAR"
        _PRINTSTRING(900, 750), "WITH GAMES"

        ' Blackout the center area inside the blue border
        LINE(borderLeft%, borderTop%) -(borderRight%, borderBottom%), _RGB32(0, 0, 0), BF

        ' Draw wide blue border
        LINE(borderLeft%, borderTop%) -(borderRight%, borderBottom%), _RGB32(0, 0, 255), b
        LINE(borderLeft% + 1, borderTop% + 1) -(borderRight%-1, borderBottom% - 1), _RGB32(0, 0, 255), b
        LINE(borderLeft% + 2, borderTop% + 2) -(borderRight%-2, borderBottom% - 2), _RGB32(0, 0, 255), b
        LINE(borderLeft% + 3, borderTop% + 3) -(borderRight%-3, borderBottom% - 3), _RGB32(0, 0, 255), b

        ' Draw Menu Text Hierarchy
        _FONT Font24&

        DIM startY%, gap%
        startY% = 125
        gap%    = 32

        COLOR _RGB32(255, 255, 0)
        _PRINTSTRING(130, startY%), "ENTER............................................."
        COLOR _RGB32(0, 255, 0)
        _PRINTSTRING(555, startY%), "START GAME"

        COLOR _RGB32(255, 255, 0)
        _PRINTSTRING(130, startY% + gap%), "LEFT/RIGHT ARROW......................"
        COLOR _RGB32(0, 255, 0)
        _PRINTSTRING(555, startY% + gap%), LTRIM$(STR$(Setting.numPlayers)) + " PLAYERS"

         COLOR _RGB32(255, 255, 0)
         _PRINTSTRING(130, startY% + gap% * 2), "UP/DOWN SELECTS GAME.........."
         COLOR _RGB32(0, 255, 0)
        IF Setting.hasRobots = 1 THEN
            _PRINTSTRING(555, startY% + gap% * 2), "HUMANS VS ROBOTS"
        ELSE
            _PRINTSTRING(555, startY% + gap% * 2), "HUMANS VS HUMANS"
        END IF

        COLOR _RGB32(255, 255, 0)
        s$ = "A/Z  INCREASE / DECREASE........"
        _PRINTSTRING(130, startY% + gap% * 3), s$
        COLOR _RGB32(0, 255, 0)
        _PRINTSTRING(130 + _PRINTWIDTH(s$), startY% + gap% * 3), LTRIM$(STR$(Setting.maxPlayerBullets)) + " MAX BULLETS PER PLAYER"

        COLOR _RGB32(255, 255, 0)
         s$ = "S/X  INCREASE / DECREASE........"
        _PRINTSTRING(130, startY% + gap% * 4), s$
        COLOR _RGB32(0, 255, 0)
        _PRINTSTRING(130 + _PRINTWIDTH(s$), startY% + gap% * 4), LTRIM$(STR$(Setting.maxRobots)) + " MAX # OF ROBOTS"

        COLOR _RGB32(255, 255, 0)
        s$ = "D/C  INCREASE / DECREASE........"
        _PRINTSTRING(130, startY% + gap% * 5), s$
        COLOR _RGB32(0, 255, 0)
        _PRINTSTRING(130 + _PRINTWIDTH(s$), startY% + gap% * 5), LTRIM$(STR$(Setting.maxRobotBullets)) + " MAX BULLETS PER ROBOT"

        COLOR _RGB32(255, 255, 0)
        _PRINTSTRING(130, startY% + gap% * 6), "W - WALLS........................................"
        COLOR _RGB32(0, 255, 0)
        IF Setting.wallsDeadly = 1 THEN
            _PRINTSTRING(555, startY% + gap% * 6), "DEADLY TO TOUCH"
        ELSE
            _PRINTSTRING(555, startY% + gap% * 6), "SAFE TO TOUCH"
        END IF

        COLOR _RGB32(255, 255, 0)
        _PRINTSTRING(130, startY% + gap% * 7), "F - FIRING CONTROL STYLE......"
        COLOR _RGB32(0, 255, 0)
        IF Setting.fireStyle = 1 THEN
            _PRINTSTRING(555, startY% + gap% * 7), "ROBOTRON"
        ELSE
            _PRINTSTRING(555, startY% + gap% * 7), "BERZERK"
        END IF

        ' Draw Dynamic Key Mapping Table
        txX%  = 100
        txY%  = 425
        rowH% = 26

        colW(1)  = 55 ' Player
        colW(2)  = 85 ' up
        colW(3)  = 85 ' DOWN
        colW(4)  = 85 ' LEFT
        colW(5)  = 85 ' RIGHT
        colW(6)  = 85 ' FIRE(Btn)
        colW(7)  = 85 ' F up
        colW(8)  = 85 ' F DOWN
        colW(9)  = 85 ' F LEFT
        colW(10) = 85 ' F RIGHT

        ' Draw Prompt above table
         COLOR _RGB32(0, 255, 0)
        _PRINTSTRING(105, 395), "CONFIGURE CONTROLS............PRESS 1-8 TO SELECT PLAYER"

        ' Draw Header Row Background and Grid
        LINE(txX%, txY%) -(txX% + 820, txY% + rowH%), _RGB32(64, 64, 64), BF

        _FONT Font12&
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING(txX% + 5, txY% + 6), "PLAYER"
        _PRINTSTRING(txX% + colW(1) + 5, txY% + 6), "MOVE UP"
        _PRINTSTRING(txX% + colW(1) + colW(2) + 5, txY% + 6), "MOVE DOWN"
        _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + 5, txY% + 6), "MOVE LEFT"
        _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + 5, txY% + 6), "MOVE RIGHT"
        _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + 5, txY% + 6), "FIRE BUTTON"
        _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + colW(6) + 5, txY% + 6), "FIRE UP"
        _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + colW(6) + colW(7) + 5, txY% + 6), "FIRE DOWN"
        _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + colW(6) + colW(7) + colW(8) + 5, txY% + 6), "FIRE LEFT"
        _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + colW(6) + colW(7) + colW(8) + colW(9) + 5, txY% + 6), "FIRE RIGHT"

        FOR p% = 1 TO 8
            rowY% = txY% + (p% * rowH%)

            ' Draw alternating row backgrounds
            IF p% MOD 2 = 1 THEN
                LINE(txX%, rowY%) -(txX% + 820, rowY% + rowH%), _RGB32(32, 32, 32), BF
            ELSE
                LINE(txX%, rowY%) -(txX% + 820, rowY% + rowH%), _RGB32(48, 48, 48), BF
            END IF

            COLOR PlayerColor&(p%)
            _PUTIMAGE(txX% + 15, rowY% + 2), Pimage&(p%, 1, 1)
            _PRINTSTRING(txX% + 30, rowY% + 6), LTRIM$(STR$(p%))

            kU$  = GetKeyDesc$(m_arrControlMap(p%, CINPUTUP).device, m_arrControlMap(p%, CINPUTUP).typ, m_arrControlMap(p%, CINPUTUP).code)
            kD$  = GetKeyDesc$(m_arrControlMap(p%, CINPUTDOWN).device, m_arrControlMap(p%, CINPUTDOWN).typ, m_arrControlMap(p%, CINPUTDOWN).code)
            kL$  = GetKeyDesc$(m_arrControlMap(p%, CINPUTLEFT).device, m_arrControlMap(p%, CINPUTLEFT).typ, m_arrControlMap(p%, CINPUTLEFT).code)
            kR$  = GetKeyDesc$(m_arrControlMap(p%, CINPUTRIGHT).device, m_arrControlMap(p%, CINPUTRIGHT).typ, m_arrControlMap(p%, CINPUTRIGHT).code)
            kF$  = GetKeyDesc$(m_arrControlMap(p%, CINPUTBUTTON1).device, m_arrControlMap(p%, CINPUTBUTTON1).typ, m_arrControlMap(p%, CINPUTBUTTON1).code)
            kFU$ = GetKeyDesc$(m_arrControlMap(p%, CINPUTFIREUP).device, m_arrControlMap(p%, CINPUTFIREUP).typ, m_arrControlMap(p%, CINPUTFIREUP).code)
            kFD$ = GetKeyDesc$(m_arrControlMap(p%, CINPUTFIREDOWN).device, m_arrControlMap(p%, CINPUTFIREDOWN).typ, m_arrControlMap(p%, CINPUTFIREDOWN).code)
            kFL$ = GetKeyDesc$(m_arrControlMap(p%, CINPUTFIRELEFT).device, m_arrControlMap(p%, CINPUTFIRELEFT).typ, m_arrControlMap(p%, CINPUTFIRELEFT).code)
            kFR$ = GetKeyDesc$(m_arrControlMap(p%, CINPUTFIRERIGHT).device, m_arrControlMap(p%, CINPUTFIRERIGHT).typ, m_arrControlMap(p%, CINPUTFIRERIGHT).code)

            IF kU$ = "UNBOUND" Then kU$ = ""
            IF kD$ = "UNBOUND" Then kD$ = ""
            IF kL$ = "UNBOUND" Then kL$ = ""
            IF kR$ = "UNBOUND" Then kR$ = ""
            IF kF$ = "UNBOUND" Then kF$ = ""
            IF kFU$ = "UNBOUND" Then kFU$ = ""
            IF kFD$ = "UNBOUND" Then kFD$ = ""
            IF kFL$ = "UNBOUND" Then kFL$ = ""
            IF kFR$ = "UNBOUND" Then kFR$ = ""

            _PRINTSTRING(txX% + colW(1) + 5, rowY% + 6), LEFT$(kU$, 8)
            _PRINTSTRING(txX% + colW(1) + colW(2) + 5, rowY% + 6), LEFT$(kD$, 8)
            _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + 5, rowY% + 6), LEFT$(kL$, 8)
            _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + 5, rowY% + 6), LEFT$(kR$, 8)
            _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + 5, rowY% + 6), LEFT$(kF$, 8)
            _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + colW(6) + 5, rowY% + 6), LEFT$(kFU$, 8)
            _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + colW(6) + colW(7) + 5, rowY% + 6), LEFT$(kFD$, 8)
            _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + colW(6) + colW(7) + colW(8) + 5, rowY% + 6), LEFT$(kFL$, 8)
            _PRINTSTRING(txX% + colW(1) + colW(2) + colW(3) + colW(4) + colW(5) + colW(6) + colW(7) + colW(8) + colW(9) + 5, rowY% + 6), LEFT$(kFR$, 8)
        NEXT p%

        ' Draw Grid Lines Over Table
        FOR p% = 0 TO 9
            LINE(txX%, txY% + (p% * rowH%)) -(txX% + 820, txY% + (p% * rowH%)), _RGB32(128, 128, 128)
        NEXT p%
        tcX% = txX%
        LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(1)  : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(2)  : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(3)  : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(4)  : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(5)  : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(6)  : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(7)  : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(8)  : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(9)  : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)
        tcX% = tcX% + colW(10) : LINE(tcX%, txY%) -(tcX%, txY% + (9 * rowH%)), _RGB32(128, 128, 128)

        _FONT Font24&
        COLOR _RGB32(255, 255, 0)
        _PRINTSTRING(105, 680), "REVERT TO DEFAULT CONTROLS............................."
        COLOR _RGB32(0, 255, 0)
        _PRINTSTRING(785, 680), "PRESS 0"

        _DISPLAY

        DO
            _LIMIT 30
            k$ = UCASE$(INKEY$)
            IF k$ = CHR$(27) THEN
                ExitGameLoop = _TRUE
                _KEYCLEAR : _DELAY 1
                EXIT SUB
            END IF

            DIM pSelect%, isShift%
            pSelect% = 0
            isShift% = _FALSE

            IF k$ >= "1" And k$ <= "8" Then pSelect% = Val(k$)
            IF k$ = "!" Then pSelect% = 1 : isShift% = _TRUE
            IF k$ = "@" Then pSelect% = 2 : isShift% = _TRUE
            IF k$ = "#" Then pSelect% = 3 : isShift% = _TRUE
            IF k$ = "$" Then pSelect% = 4 : isShift% = _TRUE
            IF k$ = "%" Then pSelect% = 5 : isShift% = _TRUE
            IF k$ = "^" Then pSelect% = 6 : isShift% = _TRUE
            IF k$ = "&" Then pSelect% = 7 : isShift% = _TRUE
            IF k$ = "*" Then pSelect% = 8 : isShift% = _TRUE

            ' Config player input maps directly from menu
            IF pSelect% > 0 THEN
                _KEYCLEAR : _DELAY 1
                CONFIGCONTROLS_INLINE pSelect%, isShift%
                SAVESETTINGS
                EXIT DO         ' trigger redraw LOOP
            END IF

            IF k$ = "0" Then
                SETUPDEFAULTCONTROLS
                SAVESETTINGS
                EXIT DO
            END IF

            IF k$ = CHR$(0) + "K" Then ' Left Arrow
                Setting.numPlayers = Setting.numPlayers - 1
                IF Setting.numPlayers < 1 THEN Setting.numPlayers = 8
                SAVESETTINGS
                EXIT DO
            END IF

            IF k$ = CHR$(0) + "M" Then ' Right Arrow
                Setting.numPlayers = Setting.numPlayers + 1
                IF Setting.numPlayers > 8 THEN Setting.numPlayers = 1
                SAVESETTINGS
                EXIT DO
            END IF

            IF k$ = CHR$(0) + "H" Or k$ = Chr$(0) + "P" Then ' Up/Down Arrow
                Setting.hasRobots = IIF%(Setting.hasRobots = 1, 0, 1)
                UPDATEBLANKROOM ' Recalc maze bounds in BG based ON new Setting
                SAVESETTINGS
                EXIT DO
            END IF

            IF k$ = "A" Then
                Setting.maxPlayerBullets = Setting.maxPlayerBullets - 1
                IF Setting.maxPlayerBullets < 1 THEN Setting.maxPlayerBullets = 1
                SAVESETTINGS
                EXIT DO
            END IF
            IF k$ = "Z" Then
                Setting.maxPlayerBullets = Setting.maxPlayerBullets + 1
                IF Setting.maxPlayerBullets > 16 THEN Setting.maxPlayerBullets = 16
                SAVESETTINGS
                EXIT DO
            END IF

            IF k$ = "S" Then
                Setting.maxRobots = Setting.maxRobots - 1
                IF Setting.maxRobots < 0 THEN Setting.maxRobots = 0
                SAVESETTINGS
                EXIT DO
            END IF
            IF k$ = "X" Then
                Setting.maxRobots = Setting.maxRobots + 1
                IF Setting.maxRobots > 256 THEN Setting.maxRobots = 256
                SAVESETTINGS
                EXIT DO
            END IF

            IF k$ = "D" Then
                Setting.maxRobotBullets = Setting.maxRobotBullets - 1
                IF Setting.maxRobotBullets < 1 THEN Setting.maxRobotBullets = 1
                SAVESETTINGS
                EXIT DO
            END IF
            IF k$ = "C" Then
                Setting.maxRobotBullets = Setting.maxRobotBullets + 1
                IF Setting.maxRobotBullets > 16 THEN Setting.maxRobotBullets = 16
                SAVESETTINGS
                EXIT DO
            END IF

            IF k$ = "F" Then
                Setting.fireStyle = 1 - Setting.fireStyle
                SAVESETTINGS
                EXIT DO
            END IF

            IF k$ = "W" Then
                Setting.wallsDeadly = 1 - Setting.wallsDeadly
                SAVESETTINGS
                EXIT DO
            END IF

            IF k$ = CHR$(0) + CHR$(71) THEN ' HOME
                IF NOT _FULLSCREEN THEN _FULLSCREEN _SQUAREPIXELS
            ELSEIF k$ = CHR$(0) + CHR$(79) THEN ' END
                IF _FULLSCREEN THEN _FULLSCREEN _OFF
            END IF

        LOOP UNTIL k$ = CHR$(13)

        IF k$ = CHR$(13) OR ExitGameLoop THEN
            _KEYCLEAR : _DELAY 1
            EXIT SUB
        END IF
    LOOP
END SUB

SUB MAKEMAZE(Heading%)
    DIM Direction~%, p%, Add%, Cdest&, px%, py%
    DIM wx1%, wy1%, wx2%, wy2%, drawWall%
    DIM numDoors%, pl%
    DIM doorX(8) AS Integer, doorY(8) AS INTEGER
    Cdest& = _DEST
    _DEST Maze&
    _PUTIMAGE(0, 0), BlankRoom&

    ' Track the 256x256 grid position to seed the maze generator
    SELECT CASE Heading%
        CASE AFTERLIFE
            Room.x = INT(RND(1) * 256)
            Room.y = INT(RND(1) * 256)
        CASE MAZE_START
            Room.x = 49
            Room.y = 83
        CASE NORTH
            Room.y = Room.y - 1
            IF Room.y = -1 THEN Room.y = 255
        CASE SOUTH
            Room.y = Room.y + 1
            IF Room.y = 256 THEN Room.y = 0
        CASE EAST
            Room.x = Room.x + 1
            IF Room.x = 256 THEN Room.x = 0
        CASE WEST
            Room.x = Room.x - 1
            IF Room.x = -1 THEN Room.x = 255
    END SELECT

    IF Setting.hasRobots = 1 THEN
        numDoors% = 4
        doorX(1)  = 368 : doorY(1) = 0
        doorX(2)  = 368 : doorY(2) = 615
        doorX(3)  = 0   : doorY(3) = 308
        doorX(4)  = 735 : doorY(4) = 308
    ELSE
        numDoors% = 8
        doorX(1)  = 0   : doorY(1) = 130
        doorX(2)  = 735 : doorY(2) = 130
        doorX(3)  = 214 : doorY(3) = 0
        doorX(4)  = 214 : doorY(4) = 615
        doorX(5)  = 0   : doorY(5) = 480
        doorX(6)  = 735 : doorY(6) = 480
        doorX(7)  = 510 : doorY(7) = 0
        doorX(8)  = 510 : doorY(8) = 615
    END IF

    Direction~% = (Room.x * 256 + Room.y) * 7 + 12627
    FOR p% = 1 TO 35
        Direction~% = (Direction~% * 7 + 12627) * 7 + 12627
        Add%        = 0
        SELECT CASE(Direction~% \ 256) AND 3
            CASE NORTH
                wx1% = P(p%).x : wy1% = P(p%).y - 102 : wx2% = P(p%).x + 3 : wy2% = P(p%).y + 3
            CASE SOUTH
                wx1% = P(p%).x : wy1% = P(p%).y : wx2% = P(p%).x + 3 : wy2% = P(p%).y + 105
            CASE EAST
                wx1% = P(p%).x : wy1% = P(p%).y : wx2% = P(p%).x + 95 : wy2% = P(p%).y + 3
            CASE WEST
                wx1% = P(p%).x - 92 : wy1% = P(p%).y : wx2% = P(p%).x + 3 : wy2% = P(p%).y + 3
        END SELECT

        ' Verify wall doesn't intersect 90x90 exclusion zone around ANY door
        drawWall% = _TRUE
        FOR pl% = 1 TO numDoors%
            IF wx1% <= doorX(pl%) + 45 AND wx2% >= doorX(pl%) -45 THEN
                IF wy1% <= doorY(pl%) + 45 AND wy2% >= doorY(pl%) -45 THEN
                    drawWall% = _FALSE
                END IF
            END IF
        NEXT pl%

        IF drawWall% THEN LINE(wx1%, wy1%) -(wx2%, wy2%), _RGB32(0, 0, 255), BF
    NEXT p%

    ' Render Closed Door (ONLY the entry door to prevent trapping)
    IF Setting.hasRobots = 1 THEN
        IF Room.entryDoor = SOUTH THEN LINE(328, 0) -(408, 4), LEVEL(Room.level).rcolor, BF
        IF Room.entryDoor = NORTH THEN LINE(328, 611) -(408, 615), LEVEL(Room.level).rcolor, BF
        IF Room.entryDoor = EAST THEN LINE(0, 268) -(4, 348), LEVEL(Room.level).rcolor, BF
        IF Room.entryDoor = WEST THEN LINE(731, 268) -(735, 348), LEVEL(Room.level).rcolor, BF
    END IF

    _PUTIMAGE(0, 0), Maze&, WorkRoom&
    _DEST Cdest&
END SUB

' =============================================================================
' SAFE AUDIO WRAPPERS
' =============================================================================
SUB SafeSndPlay(h&)
    IF h& > 0 THEN _SNDPLAY h&
END SUB

SUB SafeSndStop(h&)
    IF h& > 0 THEN
        IF _SNDPLAYING(h&) THEN _SNDSTOP h&
    END IF
END SUB

' =============================================================================
' UNUSED (TBD)
' =============================================================================
SUB ASIMOV()
END SUB

' =============================================================================
' CLEANUP
' =============================================================================
SUB CLEANUP()
    SYSTEM
END SUB