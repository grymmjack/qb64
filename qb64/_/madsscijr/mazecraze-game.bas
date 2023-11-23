'$ dynamic
_Title "Quadventure 1.0 by Softintheheadware"
' ################################################################################################################################################################
' #TOP

' Quadventure
' Version 1.0 by Softintheheadware

' DESCRIPTION:
' Upto 4 players race to get out of their respective maze (split screen).

' LICENSE:
' Open source and free.

' ================================================================================================================================================================
' CHANGE LOG
' ================================================================================================================================================================
' Date         Who                What
' 01/19/2021   MadSciJr           Players can all move around maze, varying difficulty, flip screen + scrolling.
' 11/05/2023   MadSciJr           Store player names, tweaked keymapping.
' 11/12/2023   MadSciJr           Finished v1.0: detect when players finish, keep score, advance to next level.

' ================================================================================================================================================================
' NEXT STEPS (for full list search in this file for "#IDEAS")
' ================================================================================================================================================================
' Allow players to map controls (TODO: finish input mapper v3)

' Friendly menu

' SOUNDS
' * Sound for bumping into wall
' * Tune or sound when player finishes

' Finish line variants
' * random location
' * separate finish location per player
' * multiple goals per player / relay course
' * wandering finish line!

' line of sight (player can't see behind walls)

' Increase resolution + size of world + mazes
' * Expand world from 128x128 to 1024x1024 or more
' * Increase max # of players to 8 (8 windows on screen)

' Oh and clean up this code, oy vey

' ################################################################################################################################################################
' #REFERENCE

' =============================================================================
' SOME USEFUL STUFF FOR REFERENCE:

' Type Name               Type suffix symbol   Minimum value                  Maximum value                Size in Bytes
' ---------------------   ------------------   ----------------------------   --------------------------   -------------
' _BIT                    `                    -1                             0                            1/8
' _BIT * n                `n                   -128                           127                          n/8
' _UNSIGNED _BIT          ~`                   0                              1                            1/8
' _BYTE                   %%                   -128                           127                          1
' _UNSIGNED _BYTE         ~%%                  0                              255                          1
' INTEGER                 %                    -32,768                        32,767                       2
' _UNSIGNED INTEGER       ~%                   0                              65,535                       2
' LONG                    &                    -2,147,483,648                 2,147,483,647                4
' _UNSIGNED LONG          ~&                   0                              4,294,967,295                4
' _INTEGER64              &&                   -9,223,372,036,854,775,808     9,223,372,036,854,775,807    8
' _UNSIGNED _INTEGER64    ~&&                  0                              18,446,744,073,709,551,615   8
' SINGLE                  ! or none            -2.802597E-45                  +3.402823E+38                4
' DOUBLE                  #                    -4.490656458412465E-324        +1.797693134862310E+308      8
' _FLOAT                  ##                   -1.18E-4932                    +1.18E+4932                  32(10 used)
' _OFFSET                 %&                   -9,223,372,036,854,775,808     9,223,372,036,854,775,807    Use LEN
' _UNSIGNED _OFFSET       ~%&                  0                              18,446,744,073,709,551,615   Use LEN
' _MEM                    none                 combined memory variable type  N/A                          Use LEN

' div: int1% = num1% \ den1%
' mod: rem1% = num1% MOD den1%

' =============================================================================
' BEGIN GLOBAL DECLARATIONS #GLOBAL
' =============================================================================

' ================================================================================================================================================================
' BEGIN CONSTANTS #CONST
' ================================================================================================================================================================

' BOOLEAN CONSTANTS
Const FALSE = 0
Const TRUE = Not FALSE

' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
' BEGIN KEYBOARD CODE CONSTANTS FOR _BUTTON #KEYBOARD
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------

' FUNCTION KEYS ROW
Const c_bKey_Esc% = 2
Const c_bKey_F1% = 60
Const c_bKey_F2% = 61
Const c_bKey_F3% = 62
Const c_bKey_F4% = 63
Const c_bKey_F5% = 64
Const c_bKey_F6% = 65
Const c_bKey_F7% = 66
Const c_bKey_F8% = 67
Const c_bKey_F9% = 68
'UNKNOWN: Const c_bKey_F10% = '(_BUTTON code unknown)
Const c_bKey_F11% = 88
Const c_bKey_F12% = 89

' NUMBERIC ROW
Const c_bKey_Tilde% = 42
Const c_bKey_1% = 3
Const c_bKey_2% = 4
Const c_bKey_3% = 5
Const c_bKey_4% = 6
Const c_bKey_5% = 7
Const c_bKey_6% = 8
Const c_bKey_7% = 9
Const c_bKey_8% = 10
Const c_bKey_9% = 11
Const c_bKey_0% = 12
Const c_bKey_Minus% = 13
Const c_bKey_Equal% = 14
Const c_bKey_BkSp% = 15

' QWER ROW
Const c_bKey_Tab% = 16
Const c_bKey_Q% = 17
Const c_bKey_W% = 18
Const c_bKey_E% = 19
Const c_bKey_R% = 20
Const c_bKey_T% = 21
Const c_bKey_Y% = 22
Const c_bKey_U% = 23
Const c_bKey_I% = 24
Const c_bKey_O% = 25
Const c_bKey_P% = 26
Const c_bKey_BracketLeft% = 27
Const c_bKey_BracketRight% = 28
Const c_bKey_Backslash% = 44

' ASDF ROW
Const c_bKey_CapsLock% = 59
Const c_bKey_A% = 31
Const c_bKey_S% = 32
Const c_bKey_D% = 33
Const c_bKey_F% = 34
Const c_bKey_G% = 35
Const c_bKey_H% = 36
Const c_bKey_J% = 37
Const c_bKey_K% = 38
Const c_bKey_L% = 39
Const c_bKey_Semicolon% = 40
Const c_bKey_Apostrophe% = 41
Const c_bKey_Enter% = 29

' ZXCV ROW
Const c_bKey_ShiftLeft% = 43
Const c_bKey_Z% = 45
Const c_bKey_X% = 46
Const c_bKey_C% = 47
Const c_bKey_V% = 48
Const c_bKey_B% = 49
Const c_bKey_N% = 50
Const c_bKey_M% = 51
Const c_bKey_Comma% = 52
Const c_bKey_Period% = 53
Const c_bKey_Slash% = 54
Const c_bKey_ShiftRight% = 55

' SPACEBAR ROW
Const c_bKey_LeftCtrl% = 30
Const c_bKey_WinLeft% = 348
'UNKNOWN: Const c_bKey_AltLeft% = '(_BUTTON code unknown)
Const c_bKey_Spacebar% = 58
'UNKNOWN: Const c_bKey_AltRight% = '(_BUTTON code unknown)
Const c_bKey_WinRight% = 349
Const c_bKey_Menu% = 350
Const c_bKey_RightCtrl% = 286

' NAVIGATION KEYS
Const c_bKey_Ins% = 339
Const c_bKey_Home% = 328
Const c_bKey_PgUp% = 330
Const c_bKey_Del% = 340
Const c_bKey_End% = 336
Const c_bKey_PgDn% = 338

' CURSOR KEYS
Const c_bKey_Up% = 329
Const c_bKey_Left% = 332
Const c_bKey_Down% = 337
Const c_bKey_Right% = 334

' PRINT SCREEN, SCROLL LOCK, PAUSE/BREAK SECTION
'UNKNOWN: Const c_bKey_PrintScreen% = '(_BUTTON code unknown)
Const c_bKey_ScrollLock% = 71
'UNKNOWN: Const c_bKey_PauseBreak% = '(_BUTTON code unknown)

' NUMERIC KEYPAD
Const c_bKey_NumLock% = 326
Const c_bKey_KeypadSlash% = 310
Const c_bKey_KeypadMultiply% = 56
Const c_bKey_KeypadMinus% = 75

Const c_bKey_Keypad7Home% = 72
Const c_bKey_Keypad8Up% = 73
Const c_bKey_Keypad9PgUp% = 74
Const c_bKey_KeypadPlus% = 79

Const c_bKey_Keypad4Left% = 76
Const c_bKey_Keypad5% = 77
Const c_bKey_Keypad6Right% = 78

Const c_bKey_Keypad1End% = 80
Const c_bKey_Keypad2Down% = 81
Const c_bKey_Keypad3PgDn% = 82
Const c_bKey_KeypadEnter% = 285

Const c_bKey_Keypad0Ins% = 83
Const c_bKey_KeypadPeriodDel% = 84

' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
' END KEYBOARD CODE CONSTANTS FOR _BUTTON @KEYBOARD
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------

' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
' BEGIN GAME CONSTANTS
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
' PLAYER KEY MAP CONSTANTS
Const c_Map_Left = 0
Const c_Map_Right = 1
Const c_Map_Up = 2
Const c_Map_Down = 3
Const c_Map_Button = 4
Const c_Map_Quit_Round = 5
Const c_Map_Quit_Game = 6

' USER TYPE CONSTANTS
Const cUnknown = 0
Const cHuman = 1
Const cComputer = 2
Const cNone = 3

' DIRECTION CONSTANTS
Const cN = 1
Const cE = 2
Const cS = 4
Const cW = 8

' GAME CONSTANTS
Const pX = 1
Const pY = 2
Const fX = 3
Const fY = 4

' X/Y PLANE CONSTANTS
Const cX = 0
Const cY = 1

' MISC CONSTANTS
Const pi = 3.1415926
Const cIntDictMax = 255

' TEXT CONSTANTS
'CONST vbCrLf$ = chr$(10) + chr$(13)
'CONST vbCr$ = chr$(13)
'CONST vbLf$ = chr$(10)
'CONST quot$ = chr$(34)

' WORLD DIMENSION 3
Const cGraphicType = 1 ' dimension of world map containing specific tiles, to render different colors
Const cTerrainType = 2 ' dimension of world map containing codes for type of tiles, to quickly check for collisions, behaviors, etc.
Const cPlayersType = 3 ' dimension of world map containing codes for specific players, to quickly render them to player windows

' USED FOR PLAYER SPEED
Const cInitialSpeed = 28
Const cMinSpeed = 1
Const cMaxSpeed = 40

' USED FOR DISPLAY TYPE (ScreenMovement)
'CONST cUnknown = 0
Const cScrolling = 1
Const cFlipScreen = 2

'' PLAYER START / MAZE END ARRAY DIMENSION 2
'CONST cStartPosition = 1
'CONST cEndPosition = 2
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
' END GAME CONSTANTS
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------

' ================================================================================================================================================================
' END CONSTANTS @CONST
' ================================================================================================================================================================

' ================================================================================================================================================================
' BEGIN UDTs #UDT
' ================================================================================================================================================================
Type IntDictionary
    Key As String
    Value As Integer
End Type

Type LongDictionary
    Key As String
    Value As Long
End Type

Type ULDictionary
    Key As String
    Value As _Unsigned Long
End Type

' UDT TO HOLD THE INFO FOR A PLAYER
Type PlayerType
    name As String ' player's name
   
    color As _Unsigned Long ' player's color
    TextColor1 As _Unsigned Long ' color of text on border
    TextColor2 As _Unsigned Long ' color of text on background
   
    x As Integer ' player x position
    y As Integer ' player y position
    hx As Integer ' home base x position
    hy As Integer ' home base y position
    ex As Integer ' exit x position
    ey As Integer ' exit y position
    startx As Integer ' start x position
    starty As Integer ' start y position
   
    bit As Integer ' bit value for masking player in map
    rows As Integer ' # of rows in player's maze
    cols As Integer ' # of columns in player's maze
    Difficulty As Integer ' how detailed player's maze is (ie Level)
   
    InitialSpeed As Integer ' the speed at the beginning of the game/round, (cMinSpeed - cMaxSpeed), the higher the faster
    speed As Integer ' current speed (cMinSpeed - cMaxSpeed), the higher the faster
    delay As Integer ' counter, player can move based on speed
   
    ScreenMovement As Integer ' values: cScrolling, cFlipScreen (0=cUnknown)
    ScreenMoveCanChange As Integer ' if true then ScreenMovement chosen at random
   
    IsDone As Integer ' set to TRUE when player finished round
    GaveUp As Integer ' set to TRUE when player quit
   
    StartTime As String ' start date/time
    EndTime As String ' end date/time
    StartSeconds As _Float ' start date/time in UNIX time
    TotalSeconds As _Float ' # seconds it took to complete maze
   
    Place As Integer ' place player finishes at (last race)
    PlaceText As String ' for displaying place
    OverallPlace As Integer ' overall place player is in
    OverallPlaceText As String ' for displaying overall place
   
    score As Integer ' player's score
    wins As Integer ' counts total # of wins
    Num2nd As Integer ' total # of times player placed 2nd
    Num3rd As Integer ' total # of times player placed 3rd
    Num4th As Integer ' total # of times player placed last
    forfeits As Integer ' total # of times player quit
   
    GameTime As _Float ' total # seconds it has taken player to complete all rounds so far
   
    ConsecWinCount As Integer ' if player is currently in a winning streak, how many
    ConsecWinMax As Integer ' max # of consecutive wins player has had so far
    ConsecLossCount As Integer ' if player is currently in a losing streak, how many
    ConsecLossMax As Integer ' max # of consecutive losses player has had so far
   
    RankScore As Integer ' used to rank player overall, calculated from all other measures: score, wins, num2nd, num3rd, num4th, forfeits, GameTime, ConsecWinMax, ConsecLossMax
   
    ' UNDER CONSTRUCTION:
    UserType As Integer ' values: cHuman, cComputer, cNone (0=cUnknown)
   
End Type ' PlayerType

' UDT TO HOLD THE INFO FOR A MAZE
' (DIMENSIONS FOR EACH LEVEL OF DIFFICULTY, ETC.)
Type MazeType
    makeWidth As Integer
    makeRows As Integer
    makeCols As Integer
    finalRows As Integer
    finalCols As Integer
End Type ' MazeType

' UDT TO HOLD THE INFO FOR AN OBJECT
Type ObjectType
    name As Integer
    x As Integer
    y As Integer
    IsActive As Integer
    IsVisible As Integer
    PicIndex As Integer ' index of graphic in arrPictures
End Type ' ObjectType

'' UDT TO HOLD COORDINATES FOR PLAYER START / MAZE EXIT SEARCH
'TYPE SearchType
'   x1 AS INTEGER ' start x
'   x2 AS INTEGER ' end x
'   y1 AS INTEGER ' start y
'   y2 AS INTEGER ' end y
'END TYPE ' SearchType
' ================================================================================================================================================================
' END UDTs @UDT
' ================================================================================================================================================================

' ================================================================================================================================================================
' BEGIN GLOBAL VARIABLES #VARS
' ================================================================================================================================================================
' BASIC PROGRAM METADATA
Dim Shared m_ProgramPath$: m_ProgramPath$ = Left$(Command$(0), _InStrRev(Command$(0), "\"))
Dim Shared m_ProgramName$: m_ProgramName$ = Mid$(Command$(0), _InStrRev(Command$(0), "\") + 1)
Dim Shared m_VersionInfo$: m_VersionInfo$ = "3.00"

' PLAYER + GAME OPTIONS
Dim Shared m_bFullScreen% ' IF TRUE, DISPLAYS GAME IN FULL SCREEN MODE, ELSE WINDOWED
Dim Shared m_arrPlayer(4) As PlayerType ' holds info + options for each player
' ================================================================================================================================================================
' END GLOBAL VARIABLES @VARS
' ================================================================================================================================================================

' ################################################################################################################################################################
' END GLOBAL DECLARATIONS @GLOBAL
' ################################################################################################################################################################

' =============================================================================
' START THE MAIN ROUTINE
main

' =============================================================================
' FINISH
System ' return control to the operating system
Print m_ProgramName$ + " finished."
End

' /////////////////////////////////////////////////////////////////////////////

Sub main
    'TestPicStringToArray
    'EXIT SUB
   
    Dim in$: in$ = ""
    Dim iPlayerLoop As Integer
    Dim iPlayerCount As Integer
    Dim iValue As Integer
    Dim sPrompt As String
    Dim iNumber As Integer
    Dim sValue As String
    Dim bFound As Integer
    Dim iLoop As Integer
    Dim bReverse As Integer
    Dim bRedisplayMenu As Integer
    Dim Color1 As _Unsigned Long
    Dim Color2 As _Unsigned Long
    Dim sResult As String
   
    ' INITIALIZE OTHER OPTIONS
    m_bFullScreen% = FALSE
   
    ' INITIALIZE PLAYERS
    For iPlayerLoop = 1 To 4
        m_arrPlayer(iPlayerLoop).name = "Player " + cstr$(iPlayerLoop)
        m_arrPlayer(iPlayerLoop).UserType = cHuman ' values: cHuman, cComputer, cNone
        m_arrPlayer(iPlayerLoop).InitialSpeed = cInitialSpeed ' values: cInitialSpeed, cMinSpeed, cMaxSpeed
        m_arrPlayer(iPlayerLoop).Difficulty = 1
       
        m_arrPlayer(iPlayerLoop).ScreenMovement = cScrolling ' cFlipScreen or cScrolling
        m_arrPlayer(iPlayerLoop).ScreenMoveCanChange = TRUE ' value randomly chosen each round
       
        m_arrPlayer(iPlayerLoop).score = 0
        m_arrPlayer(iPlayerLoop).wins = 0
        m_arrPlayer(iPlayerLoop).Num2nd = 0
        m_arrPlayer(iPlayerLoop).Num3rd = 0
        m_arrPlayer(iPlayerLoop).Num4th = 0
        m_arrPlayer(iPlayerLoop).forfeits = 0
       
        m_arrPlayer(iPlayerLoop).GameTime = 0
       
        m_arrPlayer(iPlayerLoop).ConsecWinCount = 0
        m_arrPlayer(iPlayerLoop).ConsecWinMax = 0
        m_arrPlayer(iPlayerLoop).ConsecLossCount = 0
        m_arrPlayer(iPlayerLoop).ConsecLossMax = 0
       
        m_arrPlayer(iPlayerLoop).OverallPlace = 0
        m_arrPlayer(iPlayerLoop).OverallPlaceText = ""
    Next iPlayerLoop
    iPlayerCount = 4
   
    ' INIT SCREEN
    Screen _NewImage(1024, 768, 32)
    _ScreenMove 0, 0
    '_SCREENMOVE _MIDDLE
   
    ' INIT MENU STATUS
    bRedisplayMenu = TRUE
   
    ' MENU LOOP
    Do
        'TODO: USE HIRES SCREEN FOR MENU AS WELL (TO FIT MORE TEXT)
        'TODO: AND CONSOLIDATE THE DISPLAY OF PLAYER CONTROLS = OPTIONS
        'TODO: SHOW PLAYER OPTIONS IN SEPARATE COLORS
       
        If bRedisplayMenu = TRUE Then
            Color cLightGray, cBlack: Cls
           
            'Color cLightGray, cBlack
            'Print m_ProgramName$
           
            'Color cLightGray, cBlack
            'Print "-------------------------------------------------------------------------------------------------------------------------------"
            Color cWhite, cBlue
            Print "Quadventure! by Softintheheadware, version 1.0"
           
            Color cDodgerBlue, cBlack
            Print "Who can get out of their maze first?"
           
            Color cLightGray, cBlack
            Print "-------------------------------------------------------------------------------------------------------------------------------"
            Color cCyan, cBlack
            Print "CONTROLS:"
           
            Color1 = cSilver
            Color2 = cWhiteSmoke
            Color cBlack, Color1: Print "PLAYER      ";
            Color cBlack, Color2: Print "LEFT        ";
            Color cBlack, Color1: Print "RIGHT       ";
            Color cBlack, Color2: Print "UP          ";
            Color cBlack, Color1: Print "DOWN        ";
            Color cBlack, Color2: Print "HONK        ";
            Color cBlack, Color1: Print "GIVE UP     ";
            Color cBlack, Color2: Print "QUIT GAME   "
           
            Color1 = cGold
            Color2 = cYellow
            Color cBlack, Color1: Print "1           ";
            Color cBlack, Color2: Print "A           ";
            Color cBlack, Color1: Print "D           ";
            Color cBlack, Color2: Print "W           ";
            Color cBlack, Color1: Print "S           ";
            Color cBlack, Color2: Print "E           ";
            Color cBlack, Color1: Print "Q           ";
            Color cBlack, Color2: Print "ESC         "
           
            Color1 = cYellow
            Color2 = cGold
            Color cBlack, Color1: Print "2           ";
            Color cBlack, Color2: Print "J           ";
            Color cBlack, Color1: Print "L           ";
            Color cBlack, Color2: Print "I           ";
            Color cBlack, Color1: Print "K           ";
            Color cBlack, Color2: Print "O           ";
            Color cBlack, Color1: Print "U           ";
            Color cBlack, Color2: Print "ESC         "
           
            Color1 = cGold
            Color2 = cYellow
            Color cBlack, Color1: Print "3           ";
            Color cBlack, Color2: Print "CRSR LEFT   ";
            Color cBlack, Color1: Print "CRSR RIGHT  ";
            Color cBlack, Color2: Print "CRSR UP     ";
            Color cBlack, Color1: Print "CRSR DOWN   ";
            Color cBlack, Color2: Print "RIGHT CTRL  ";
            Color cBlack, Color1: Print "RIGHT SHIFT ";
            Color cBlack, Color2: Print "ESC         "
           
            Color1 = cYellow
            Color2 = cGold
            Color cBlack, Color1: Print "4           ";
            Color cBlack, Color2: Print "KEYPAD 4    ";
            Color cBlack, Color1: Print "KEYPAD 6    ";
            Color cBlack, Color2: Print "KEYPAD 8    ";
            Color cBlack, Color1: Print "KEYPAD 5    ";
            Color cBlack, Color2: Print "KEYPAD 9    ";
            Color cBlack, Color1: Print "KEYPAD 7    ";
            Color cBlack, Color2: Print "ESC         "
           
           
            Color cLightGray, cBlack
            Print "-------------------------------------------------------------------------------------------------------------------------------"
            Color cCyan, cBlack
            Print "Current settings:"
           
            Color1 = cSilver
            Color2 = cWhiteSmoke
            Color cBlack, Color1: Print "# ";
            Color cBlack, Color2: Print "Name                     ";
            Color cBlack, Color1: Print "Type     ";
            Color cBlack, Color2: Print "Difficulty ";
            Color cBlack, Color1: Print "Speed ";
            Color cBlack, Color2: Print "Display     "
           
            bReverse = TRUE
            For iPlayerLoop = 1 To 4
                If bReverse = TRUE Then
                    bReverse = FALSE
                    Color1 = cCyan
                    Color2 = cDodgerBlue
                Else
                    bReverse = TRUE
                    Color1 = cDodgerBlue
                    Color2 = cCyan
                End If
               
                ' COLUMN #1
                sValue = cstr$(iPlayerLoop)
                sValue = PadRight$(sValue, 2)
                Color cBlack, Color1: Print sValue;
               
                ' COLUMN #2
                sValue = m_arrPlayer(iPlayerLoop).name
                sValue = PadRight$(sValue, 25)
                Color cBlack, Color2: Print sValue;
               
                ' COLUMN #3
                If m_arrPlayer(iPlayerLoop).UserType = cHuman Then
                    sValue = "Human"
                ElseIf m_arrPlayer(iPlayerLoop).UserType = cComputer Then
                    sValue = "Computer"
                ElseIf m_arrPlayer(iPlayerLoop).UserType = cNone Then
                    sValue = "None"
                Else
                    sValue = "Unknown"
                End If
                sValue = PadRight$(sValue, 9)
                Color cBlack, Color1: Print sValue;
               
                ' COLUMN #4
                sValue = cstr$(m_arrPlayer(iPlayerLoop).Difficulty)
                sValue = PadRight$(sValue, 11)
                Color cBlack, Color2: Print sValue;
               
                ' COLUMN #5
                sValue = cstr$(m_arrPlayer(iPlayerLoop).InitialSpeed)
                sValue = PadRight$(sValue, 6)
                Color cBlack, Color1: Print sValue;
               
                ' COLUMN #6
                If m_arrPlayer(iPlayerLoop).ScreenMoveCanChange = TRUE Then
                    sValue = "Random"
                ElseIf m_arrPlayer(iPlayerLoop).ScreenMovement = cFlipScreen Then
                    sValue = "Flip Screen"
                ElseIf m_arrPlayer(iPlayerLoop).ScreenMovement = cScrolling Then
                    sValue = "Scrolling"
                Else
                    sValue = "Unknown"
                End If
                sValue = PadRight$(sValue, 12)
                Color cBlack, Color2: Print sValue
               
            Next iPlayerLoop
           
            Color cLightGray, cBlack
            Print "-------------------------------------------------------------------------------------------------------------------------------"
            Color cCyan, cBlack
            Print "Options:"
           
            Color cLightGray, cBlack
            Print "0. Start game"
            Color cWhite, cBlack
            Print "1. Select # players [UNDER CONSTRUCTION: CURRENTLY 4 HUMANS]"
            Color cLightGray, cBlack
            Print "2. Select each player's maze difficulty"
            Color cWhite, cBlack
            Print "3. Select each player's speed"
            Color cLightGray, cBlack
            Print "4. Select each player's screen movement (scrolling, flip screen, or randomly chosen)"
            Color cWhite, cBlack
            Print "5. Edit player names"
            If m_bFullScreen% = TRUE Then
                sValue = "FULL SCREEN"
            Else
                sValue = "WINDOWED"
            End If
            Color cLightGray, cBlack
            Print "6. Toggle full screen mode: " + sValue
        Else
            bRedisplayMenu = TRUE
        End If
       
        ' PROMPT USER
        Color cCyan, cBlack
        Print
        Print "Just enter 0 (zero) to play or select an option from the menu."
        Print
        Print "What to do? ('q' to exit)"

        Input in$: in$ = LCase$(Left$(in$, 1))
       
        ' -----------------------------------------------------------------------------
        ' START THE GAME
        If in$ = "0" Then
            If (iPlayerCount > 0) Then
                sResult = game1$
                If Len(sResult) > 0 Then
                    Color cOrangeRed, cBlack
                    Print sResult
                    bRedisplayMenu = FALSE
                End If
            Else
                Color cOrangeRed, cBlack
                Print "Select some players!"
                bRedisplayMenu = FALSE
            End If
           
            ' -----------------------------------------------------------------------------
            ' SELECT PLAYER TYPE
        ElseIf in$ = "1" Then
            Color cOrangeRed, cBlack
            Print "UNDER CONSTRUCTION"
            bRedisplayMenu = FALSE
           
            If TRUE = FALSE Then
                iPlayerCount = 0
                For iPlayerLoop = 1 To 4
                    bFound = FALSE
                    While bFound = FALSE
                        Print "Player " + cstr$(iPlayerLoop) + " - h)uman, c)omputer, or n)one";
                        Input in$
                        in$ = Left$(LCase$(_Trim$(in$)), 1)
                        If (in$ = "h") Then
                            m_arrPlayer(iPlayerLoop).UserType = cHuman
                            iPlayerCount = iPlayerCount + 1
                            bFound = TRUE
                        ElseIf (in$ = "c") Then
                            m_arrPlayer(iPlayerLoop).UserType = cComputer
                            bFound = TRUE
                        ElseIf (in$ = "n") Then
                            m_arrPlayer(iPlayerLoop).UserType = cNone
                            bFound = TRUE
                        Else
                            Color cOrangeRed, cBlack
                            Print
                            Print "*** Please enter h, c, or n. ***"
                            Print
                        End If
                    Wend
                Next iPlayerLoop
            End If
           
            ' -----------------------------------------------------------------------------
            ' SELECT PLAYER MAZE DIFFICULTY
        ElseIf in$ = "2" Then
            For iPlayerLoop = 1 To 4
                iValue = cUnknown
                While iValue = cUnknown
                    Color cCyan, cBlack
                    Print "Player " + cstr$(iPlayerLoop) + " difficulty (1-10) ";
                    Input in$
                    If IsNum%(in$) = TRUE Then
                        iNumber = Val(in$)
                        If iNumber >= 1 And iNumber <= 10 Then
                            iValue = iNumber
                        Else
                            Color cOrangeRed, cBlack
                            Print
                            Print "*** Number must be between 1 and 10. ***"
                            Print
                        End If
                    Else
                        Color cOrangeRed, cBlack
                        Print
                        Print "*** Please enter a number between 1 and 10. ***"
                        Print
                    End If
                Wend
                m_arrPlayer(iPlayerLoop).Difficulty = iValue
            Next iPlayerLoop
           
            ' -----------------------------------------------------------------------------
            ' SELECT PLAYER SPEEDS
        ElseIf in$ = "3" Then
            For iPlayerLoop = 1 To 4
                iValue = cUnknown
                While iValue = cUnknown
                    Color cCyan, cBlack
                    Print "Player " + cstr$(iPlayerLoop) + " speed (" + cstr$(cMinSpeed) + "-" + cstr$(cMaxSpeed) + ")";
                    Input in$
                    If IsNum%(in$) = TRUE Then
                        iNumber = Val(in$)
                        If iNumber >= cMinSpeed And iNumber <= cMaxSpeed Then
                            iValue = iNumber
                        Else
                            Color cOrangeRed, cBlack
                            Print
                            Print "*** Number must be between " + cstr$(cMinSpeed) + " and " + cstr$(cMaxSpeed) + ". ***"
                            Print
                        End If
                    Else
                        Color cOrangeRed, cBlack
                        Print
                        Print "*** Please enter a number between " + cstr$(cMinSpeed) + " and " + cstr$(cMaxSpeed) + ". ***"
                        Print
                    End If
                Wend
                m_arrPlayer(iPlayerLoop).InitialSpeed = iValue
            Next iPlayerLoop
           
            ' -----------------------------------------------------------------------------
            ' SELECT PLAYER SCREEN MOVEMENT TYPE
        ElseIf in$ = "4" Then
            For iPlayerLoop = 1 To 4
                iValue = cUnknown
                While iValue = cUnknown
                    Color cCyan, cBlack
                    Print "Player " + cstr$(iPlayerLoop) + " display type - f)lip screen, s)crolling or r)andom";
                    Input in$
                    in$ = Left$(LCase$(_Trim$(in$)), 1)
                    If (in$ = "f") Then
                        m_arrPlayer(iPlayerLoop).ScreenMovement = cFlipScreen
                        m_arrPlayer(iPlayerLoop).ScreenMoveCanChange = FALSE
                    ElseIf (in$ = "s") Then
                        m_arrPlayer(iPlayerLoop).ScreenMovement = cScrolling
                        m_arrPlayer(iPlayerLoop).ScreenMoveCanChange = FALSE
                    ElseIf (in$ = "r") Then
                        m_arrPlayer(iPlayerLoop).ScreenMovement = cScrolling
                        m_arrPlayer(iPlayerLoop).ScreenMoveCanChange = TRUE
                    Else
                        Color cOrangeRed, cBlack
                        Print
                        Print "*** Please enter f, s or r. ***"
                        Print
                    End If
                Wend
            Next iPlayerLoop
           
            ' -----------------------------------------------------------------------------
            ' ENTER PLAYER NAMES
        ElseIf in$ = "5" Then
            For iPlayerLoop = 1 To 4
                sValue = ""
                While Len(sValue) = 0
                    ' TODO: IF USER TYPES MORE THAN 24 CHARACTERS SHOW SOME VISUAL INDICATOR
                    Color cCyan, cBlack
                    Print "Enter a new name for player #" + cstr$(iPlayerLoop) + " (1-24 characters)"
                    Print "or blank to keep using " + m_arrPlayer(iPlayerLoop).name;
                    Input in$
                    sValue = _Trim$(in$)
                    If Len(in$) > 0 And Len(sValue) = 0 Then
                        Color cOrangeRed, cBlack
                        Print
                        Print "*** Spaces are not valid, try again. ***"
                        Print
                       
                    ElseIf Len(sValue) > 0 Then
                        ' MAKE SURE NAME ISN'T ALREADY TAKEN
                        For iLoop = 1 To 4
                            ' ONLY CHECK OTHER PLAYERS
                            If iLoop <> iPlayerLoop Then
                                If LCase$(m_arrPlayer(iLoop).name) = LCase$(sValue) Then
                                    Color cOrangeRed, cBlack
                                    Print
                                    Print "*** That name is already used by player " + cstr$(iLoop) + " ***"
                                    Print
                                    sValue = "" ' KEEP ASKING
                                    Exit For
                                End If
                            End If
                        Next iLoop
                        If Len(sValue) > 0 Then
                            ' SAVE NAME
                            m_arrPlayer(iPlayerLoop).name = Left$(sValue, 24)
                           
                            ' TODO: WARN USER IF THEIR NAME WAS TRIMMED
                        End If
                    Else
                        ' NAME NOT CHANGED, EXIT LOOP
                        sValue = m_arrPlayer(iPlayerLoop).name
                    End If
                Wend
            Next iPlayerLoop
           
            ' -----------------------------------------------------------------------------
            ' TOGGLE FULL SCREEN MODE
        ElseIf in$ = "6" Then
            If m_bFullScreen% = TRUE Then
                m_bFullScreen% = FALSE
            Else
                m_bFullScreen% = TRUE
            End If
           
        End If
    Loop Until in$ = "q"
End Sub ' main

' ################################################################################################################################################################
' BEGIN GAME LOGIC
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////

Function game1$ ()
    Dim sResult As String
    Dim iScreenWidth As Integer: iScreenWidth = 800 ' 1920
    Dim iScreenHeight As Integer: iScreenHeight = 600 ' 1440
    Dim iTileSize As Integer: iTileSize = 16 '8
    Dim iWindowWidth As Integer: iWindowWidth = 16
    Dim iWindowHeight As Integer: iWindowHeight = 16
    Dim iOffset As Integer: iOffset = iTileSize
    Dim iCols As Integer: iCols = 33
    Dim iRows As Integer: iRows = 33
    Dim iWidth As Integer ' DEPENDS ON DIFFICULTY PER PLAYER :iWidth = 2

    Dim iBgColor As _Unsigned Long: iBgColor = cDarkGray ' 32 ' cBlack
    'DIM iWallColor AS INTEGER: iWallColor = cYellow
    ' 33x33, Width 2 = 100x100
    ' 50x50, Width 1 = 101x101
   
    Dim arrMazeOptions(10) As MazeType ' holds maze dimensions for each difficulty level
    ReDim arrWorld(-1, -1, -1) As Integer ' holds 1 maze for each player + connecting hallways
    ReDim arrNextMaze(-1, -1) As Integer ' holds next maze generated
    Dim arrPictures(104, 16, 16) As Integer ' holds 16x16 pixel arrays (each pixel storees a color, -1 is empty)
    Dim arrObjects(100) As ObjectType ' holds info on non-tile objects in game such as keys, flags
    'Dim arrColorValue(-1) As ULDictionary
    Dim arrColors(32) As _Unsigned Long
   
    ' ARRAY TO COLOR WALLS:
    Dim arrPalette(0 To 46) As _Unsigned Long
    Dim arrGameColorMap(0 To 4, 0 To 8) As Integer
   
    Dim arrOffsetX(4) As Integer
    Dim arrOffsetY(4) As Integer
   
    '' HOLD START/END COORDINATES FOR SEARCHING FOR EACH PLAYER START, MAZE EXIT POSITIONS
    '' DIMENSION   SPECIFIES
    '' 1           player # (1-4)
    '' 2           search for (cStartPosition or cEndPosition)
    '' 3           search # (1-2)
    '' SearchType members: .x1 .x2 .y1 .y2
    'DIM arrSearch(4, 2, 2) AS SearchType
   
    Dim iNumPlayers As Integer: iNumPlayers = 4 ' # OF PLAYERS ACTIVE
    Dim iPlayerLoop As Integer
    Dim iOtherLoop As Integer
    Dim iObjectLoop As Integer
    Dim iLoop As Integer
    Dim iIndex As Integer
    Dim iObject As Integer
    Dim bFound As Integer

    ' TEMP GRAPHIC VARS
    Dim sGraphic As String
    Dim arrTextPics(100) As String
    Dim arrGraphic(16, 16) As Integer

    ' MAZE PROPERTIES
    'PASSED AS PARAMTER: DIM iCols AS INTEGER: iCols = 33
    'PASSED AS PARAMTER: DIM iRows AS INTEGER: iRows = 33
    'PASSED AS PARAMTER: DIM iWidth AS INTEGER: iWidth = 2
    Dim iNextWall As Integer ' THIS IS 1-8 (corresponds to # of player)
    Dim iWall As Integer: iWall = 1
    Dim iEmpty As Integer: iEmpty = 0
    Dim iFinish As Integer: iFinish = 2
    Dim iRowCount As Integer
    Dim iColCount As Integer
    Dim iTemp1 As Integer
    Dim iTemp2 As Integer
    Dim bResult As Integer
    Dim sNextChar As String
    Dim iNextColor1~& ' AS _UNSIGNED LONG
    Dim iNextColor2~& ' AS _UNSIGNED LONG
    Dim sMaze As String
    Dim iDifficulty As Integer
   
    Dim iMakeWidth As Integer
    Dim iMakeRows As Integer
    Dim iMakeCols As Integer
    Dim iFinalRows As Integer
    Dim iFinalCols As Integer

    Dim iMaxRows As Integer: iMaxRows = 45
    Dim iMaxCols As Integer: iMaxCols = 45
    Dim iWorldRows As Integer
    Dim iWorldCols As Integer

    Dim iStartX As Integer
    Dim iStartY As Integer
    Dim iEndX As Integer
    Dim iEndY As Integer
    Dim iOffsetX As Integer
    Dim iOffsetY As Integer
   
    ' GRAPHIC PROPERTIES
    'PASSED AS PARAMTER: DIM iScreenWidth AS INTEGER: iScreenWidth = 1280 ' 1920
    'PASSED AS PARAMTER: DIM iScreenHeight AS INTEGER: iScreenHeight = 1024 ' 1440
    'PASSED AS PARAMTER: DIM iBgColor AS INTEGER: iBgColor = 32 ' cBlack
    'PASSED AS PARAMTER: DIM iWallColor AS INTEGER: iWallColor = cYellow
    'PASSED AS PARAMTER: DIM iTileSize AS INTEGER: iTileSize = 8

    'DEBUG:
    'DIM iOffset AS INTEGER
    'DIM xPos%, yPos%
    'DIM x1%, x2%, y1%, y2%

    ' INPUT VARIABLES
    Dim in$
    Dim arrKeys(512) As Integer ' for tracking keypresses (probably not needed)
    Dim arrKeyMap(0 To 8, 0 To 6) As Integer ' for mapping keys to each player's action
   
    ' SOUND VARIABLES
    ' SOUND
    ' SOUND sets frequency and duration of sounds from the internal PC speaker if the computer has one or the sound card in QB64.
    '
    ' Syntax
    ' SOUND frequency, duration
    '
    ' Description
    ' Frequency is any literal or variable value from 37 to 32767, but 0 is allowed for delays.
    ' Duration is any literal or variable number of TIMER ticks with a duration of 1/18th second. 18 = one second.
    ' In QB64 the sound comes from the soundcard and the volume can be adjusted through the OS.
    '
    ' Errors
    ' Low frequency values between 0 and 37 will create an Illegal Function call error.
    ' Warning: SOUND may not work when the program is not in focus. Use SOUND 0, 0 at sound procedure start to set focus.
    ' Note: SOUND 0, 0 will not stop previous QB64 sounds like it did in Qbasic!
    ' SOUND may have clicks or pauses between the sounds generated. PLAY can be used for musical sounds.
    '
    '                              The Seven Music Octaves
    '
    '          Note     Frequency      Note     Frequency      Note      Frequency
    '        1* D#1 ...... 39           G3 ....... 196          A#5 ...... 932
    '           E1 ....... 41           G#3 ...... 208          B5 ....... 988
    '           F1 ....... 44           A3 ....... 220       6* C6 ....... 1047
    '           F#1 ...... 46           A#3 ...... 233          C#6 ...... 1109
    '           G1 ....... 49           B3 ....... 247          D6 ....... 1175
    '           G#1 ...... 51        4* C4 ....... 262          D#6 ...... 1245
    '           A1 ....... 55           C#4 ...... 277          E6 ....... 1318
    '           A#1 ...... 58           D4 ....... 294          F6 ....... 1397
    '           B1 ....... 62           D#4 ...... 311          F#6 ...... 1480
    '        2* C2 ....... 65           E4 ....... 330          G6 ....... 1568
    '           C#2 ...... 69           F4 ....... 349          G# ....... 1661
    '           D2 ....... 73           F#4 ...... 370          A6 ....... 1760
    '           D#2 ...... 78           G4 ....... 392          A#6 ...... 1865
    '           E2 ....... 82           G#4 ...... 415          B6 ....... 1976
    '           F2 ....... 87           A4 ....... 440       7* C7 ....... 2093
    '           F#2 ...... 92           A# ....... 466          C#7 ...... 2217
    '           G2 ....... 98           B4 ....... 494          D7 ....... 2349
    '           G#2 ...... 104       5* C5 ....... 523          D#7 ...... 2489
    '           A2 ....... 110          C#5 ...... 554          E7 ....... 2637
    '           A#2 ...... 117          D5 ....... 587          F7 ....... 2794
    '           B2 ....... 123          D#5 ...... 622          F#7 ...... 2960
    '        3* C3 ....... 131          E5 ....... 659          G7 ....... 3136
    '           C#3 ...... 139          F5 ....... 698          G#7 ...... 3322
    '           D3 ....... 147          F#5 ...... 740          A7 ....... 3520
    '           D#3 ...... 156          G5 ....... 784          A#7 ...... 3729
    '           E3 ....... 165          G#5 ...... 831          B7 ....... 3951
    '           F3 ....... 175          A5 ....... 880       8* C8 ....... 4186
    '           F#3 ...... 185
    '                                  # denotes sharp
    Dim arrSound(8) As Integer

    ' ****************************************************************************************************************************************************************
    'Dim sFileName As String
    'Dim arrFileName(4) As String
    Dim sError As String
    Dim vbCrLf As String: vbCrLf = Chr$(10) + Chr$(13)
    Dim vbCr As String: vbCr = Chr$(13)
    Dim vbLf As String: vbLf = Chr$(10)
    Dim quot As String: quot = Chr$(34)
    Dim arrDebug$(5)
    Dim sTemp As String
    Dim sTempHR As String: sTempHR = "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    Dim sTemp1 As String
    Dim sTemp2 As String
    Dim sTemp3 As String
    Dim sTemp4 As String
    Dim sTemp5 As String
    Dim sTemp6 As String
    Dim sTemp7 As String
   
    Dim iBlinkCount As Integer
    Dim iBlinkColor As _Unsigned Long
    Dim iDonePlayer As Integer
   
    Dim fRoundStartSeconds As _Float ' start date/time in UNIX time
    Dim fCurrentSeconds As _Float ' current date/time in UNIX time
    Dim sCurrentDateTime As String
    Dim fAdjustedSeconds As _Float ' used for calculating time for players who quit
   
    Dim bGameOver As Integer
    Dim bRoundOver As Integer
    Dim bFinishFlag As Integer
    Dim bGaveUp As Integer
   
    Dim iRoundNumber As Integer
    Dim sRound As String
    Dim iRoundLen As Integer
    Dim iRoundX As Integer
    Dim iRoundY As Integer
   
    Dim sTitle As String
    Dim iTitleX As Integer
    Dim iTitleY As Integer
    Dim iLine As Integer
    Dim Color1 As _Unsigned Long
    Dim Color2 As _Unsigned Long
    Dim iNextPlace As Integer
    Dim bIncreaseLevel As Integer
    Dim sLine As String
   
    ' INITIALIZE
    sResult = ""
    sError = ""
   
    'sFileName = m_ProgramPath$ + Left$(m_ProgramName$, Len(m_ProgramName$) - 4) + ".txt"
    'For iLoop = 1 To 4
    '    arrFileName(iLoop) = m_ProgramPath$ + Left$(m_ProgramName$, Len(m_ProgramName$) - 4) + "." + cstr$(iLoop) + ".txt"
    'Next iLoop
   
   
    ' ****************************************************************************************************************************************************************

    ' -----------------------------------------------------------------------------
    ' SETUP MAZE OPTIONS

    ' Difficulty   Width   RowsIn  ColsIn  RowsOut  ColsOut
    ' 10           1       22      22      45       45
    ' 9            2       14      14      43       43
    ' 8            3       11      11      45       45
    ' 7            4        8       8      41       41
    ' 6            5        7       7      43       43
    ' 5            6        6       6      43       43
    ' 4            7        5       5      41       41
    ' 3            8        4       4      37       37
    ' 2            9        4       4      41       41
    ' 1            10       4       4      45       45
    '                                 Max: 45       45

    arrMazeOptions(10).makeWidth = 1
    arrMazeOptions(10).makeRows = 22
    arrMazeOptions(10).makeCols = 22
    arrMazeOptions(10).finalRows = 45
    arrMazeOptions(10).finalCols = 45

    arrMazeOptions(9).makeWidth = 2
    arrMazeOptions(9).makeRows = 14
    arrMazeOptions(9).makeCols = 14
    arrMazeOptions(9).finalRows = 43
    arrMazeOptions(9).finalCols = 43

    arrMazeOptions(8).makeWidth = 3
    arrMazeOptions(8).makeRows = 11
    arrMazeOptions(8).makeCols = 11
    arrMazeOptions(8).finalRows = 45
    arrMazeOptions(8).finalCols = 45

    arrMazeOptions(7).makeWidth = 4
    arrMazeOptions(7).makeRows = 8
    arrMazeOptions(7).makeCols = 8
    arrMazeOptions(7).finalRows = 41
    arrMazeOptions(7).finalCols = 41

    arrMazeOptions(6).makeWidth = 5
    arrMazeOptions(6).makeRows = 7
    arrMazeOptions(6).makeCols = 7
    arrMazeOptions(6).finalRows = 43
    arrMazeOptions(6).finalCols = 43

    arrMazeOptions(5).makeWidth = 6
    arrMazeOptions(5).makeRows = 6
    arrMazeOptions(5).makeCols = 6
    arrMazeOptions(5).finalRows = 43
    arrMazeOptions(5).finalCols = 43

    arrMazeOptions(4).makeWidth = 7
    arrMazeOptions(4).makeRows = 5
    arrMazeOptions(4).makeCols = 5
    arrMazeOptions(4).finalRows = 41
    arrMazeOptions(4).finalCols = 41

    arrMazeOptions(3).makeWidth = 8
    arrMazeOptions(3).makeRows = 4
    arrMazeOptions(3).makeCols = 4
    arrMazeOptions(3).finalRows = 37
    arrMazeOptions(3).finalCols = 37

    arrMazeOptions(2).makeWidth = 9
    arrMazeOptions(2).makeRows = 4
    arrMazeOptions(2).makeCols = 4
    arrMazeOptions(2).finalRows = 41
    arrMazeOptions(2).finalCols = 41

    arrMazeOptions(1).makeWidth = 10
    arrMazeOptions(1).makeRows = 4
    arrMazeOptions(1).makeCols = 4
    arrMazeOptions(1).finalRows = 45
    arrMazeOptions(1).finalCols = 45

    ' ================================================================================================================================================================
    ' BEGIN INIT COLORS
    ' ================================================================================================================================================================
   
    ''*** COLOR DICTIONARY DOESN'T SEEM TO WORK! ***
    'bResult = GetColorDictionary%(arrColorValue())
   
    ' BACKGROUND
    arrColors(0) = cLightGray
   
    ' TODO: let players choose colors
   
    ' PLAYER 1
    arrColors(1) = cRed
    arrColors(9) = cRed ' cBrickRed
    arrColors(17) = cOrangeRed

    ' PLAYER 2
    arrColors(2) = cYellow
    arrColors(10) = cGold ' cKhaki
    arrColors(18) = cGold

    ' PLAYER 3
    arrColors(3) = cLime
    arrColors(11) = cDarkGreen ' cGreen
    arrColors(19) = cDarkGreen

    ' PLAYER 4
    arrColors(4) = cBlue
    arrColors(12) = cBlue ' cDodgerBlue
    arrColors(20) = cCyan

    ' PLAYER 5
    arrColors(5) = cOrange
    arrColors(13) = cDarkOrange
    arrColors(21) = cDarkBrown

    ' PLAYER 6
    arrColors(6) = cPurple
    arrColors(14) = cPurpleRed
    arrColors(22) = cMagenta

    ' PLAYER 7
    arrColors(7) = cLightPink
    arrColors(15) = cHotPink
    arrColors(23) = cDeepPink

    ' PLAYER 8
    arrColors(8) = cSilver
    arrColors(16) = cLightGray
    arrColors(24) = cGainsboro

    ' OUTER WALL
    arrColors(25) = cDarkGray
   
    ' FINISH LINE
    arrColors(26) = cWhite
   
    ' ================================================================================================================================================================
    ' END INIT COLORS
    ' ================================================================================================================================================================
   
   
    ' ================================================================================================================================================================
    ' BEGIN INIT COLOR PALETTE
    ' ================================================================================================================================================================
    If Len(sError) = 0 Then
        ' EMPTY = 100% TRANSPARENT
        arrPalette(0) = _RGB32(0, 0, 0, 0) ' cEmpty
       
        ' WORLD
        arrPalette(1) = _RGB32(200, 200, 200) ' game background
        arrPalette(2) = _RGB32(164, 164, 164) ' outer wall 1
        arrPalette(3) = _RGB32(148, 148, 148) ' outer wall 2
        arrPalette(4) = _RGB32(132, 132, 132) ' outer wall 3
        arrPalette(5) = _RGB32(116, 116, 116) ' outer wall 4
        arrPalette(6) = _RGB32(100, 100, 100) ' outer wall 5
        arrPalette(7) = _RGB32(116, 116, 116) ' outer wall 6
        arrPalette(8) = _RGB32(132, 132, 132) ' outer wall 7
        arrPalette(9) = _RGB32(148, 148, 148) ' outer wall 8

        ' PLAYER 1 = RED
        arrPalette(10) = _RGB32(168, 0, 0) ' player 1 = RED
        arrPalette(11) = _RGB32(255, 0, 0) ' player 1 wall 1
        arrPalette(12) = _RGB32(255, 48, 0) ' player 1 wall 2
        arrPalette(13) = _RGB32(255, 69, 0) ' player 1 wall 3
        arrPalette(14) = _RGB32(255, 85, 0) ' player 1 wall 4
        arrPalette(15) = _RGB32(255, 110, 0) ' player 1 wall 5
        arrPalette(16) = _RGB32(255, 85, 0) ' player 1 wall 6
        arrPalette(17) = _RGB32(255, 69, 0) ' player 1 wall 7
        arrPalette(18) = _RGB32(255, 48, 0) ' player 1 wall 8
       
        ' PLAYER 2 = YELLOW
        arrPalette(19) = _RGB32(255, 255, 0) ' player 2 = YELLOW
        arrPalette(20) = _RGB32(255, 165, 0) ' player 2 wall 1
        arrPalette(21) = _RGB32(255, 190, 0) ' player 2 wall 2
        arrPalette(22) = _RGB32(255, 204, 0) ' player 2 wall 3
        arrPalette(23) = _RGB32(255, 215, 0) ' player 2 wall 4
        arrPalette(24) = _RGB32(255, 232, 0) ' player 2 wall 5
        arrPalette(25) = _RGB32(255, 215, 0) ' player 2 wall 6
        arrPalette(26) = _RGB32(255, 204, 0) ' player 2 wall 7
        arrPalette(27) = _RGB32(255, 190, 0) ' player 2 wall 8

        ' PLAYER 3 = GREEN
        arrPalette(28) = _RGB32(0, 160, 0) ' player 3 = GREEN
        arrPalette(29) = _RGB32(192, 255, 62) ' player 3 wall 1
        arrPalette(30) = _RGB32(143, 255, 35) ' player 3 wall 2
        arrPalette(31) = _RGB32(100, 255, 20) ' player 3 wall 3
        arrPalette(32) = _RGB32(70, 240, 10) ' player 3 wall 4
        arrPalette(33) = _RGB32(45, 220, 0) ' player 3 wall 5
        arrPalette(34) = _RGB32(70, 240, 10) ' player 3 wall 6
        arrPalette(35) = _RGB32(100, 255, 20) ' player 3 wall 7
        arrPalette(36) = _RGB32(143, 255, 35) ' player 3 wall 8
       
        ' PLAYER 4 = BLUE
        arrPalette(37) = _RGB32(0, 255, 255) ' player 4 = BLUE
        arrPalette(38) = _RGB32(0, 191, 255) ' player 4 wall 1
        arrPalette(39) = _RGB32(30, 144, 255) ' player 4 wall 2
        arrPalette(40) = _RGB32(15, 110, 255) ' player 4 wall 3
        arrPalette(41) = _RGB32(8, 75, 255) ' player 4 wall 4
        arrPalette(42) = _RGB32(3, 40, 255) ' player 4 wall 5
        arrPalette(43) = _RGB32(8, 75, 255) ' player 4 wall 6
        arrPalette(44) = _RGB32(15, 110, 255) ' player 4 wall 7
        arrPalette(45) = _RGB32(30, 144, 255) ' player 4 wall 8
       
        ' FINISH LINE
        arrPalette(46) = _RGB32(255, 255, 255) ' cWhite
    End If
    ' ================================================================================================================================================================
    ' END INIT COLOR PALETTE
    ' ================================================================================================================================================================
   
    ' ================================================================================================================================================================
    ' BEGIN INIT GAME COLOR MAP
    ' ================================================================================================================================================================
    If Len(sError) = 0 Then
        ' BACKGROUND
        arrGameColorMap(0, 0) = 1 ' Background
        arrGameColorMap(0, 1) = 2 ' wall 1
        arrGameColorMap(0, 2) = 3 ' wall 2
        arrGameColorMap(0, 3) = 4 ' wall 3
        arrGameColorMap(0, 4) = 5 ' wall 4
        arrGameColorMap(0, 5) = 6 ' wall 5
        arrGameColorMap(0, 6) = 7 ' wall 6
        arrGameColorMap(0, 7) = 8 ' wall 7
        arrGameColorMap(0, 8) = 9 ' wall 8

        ' PLAYER 1 = RED
        arrGameColorMap(1, 0) = 10 ' player 1
        arrGameColorMap(1, 1) = 11 ' player 1 wall 1
        arrGameColorMap(1, 2) = 12 ' player 1 wall 2
        arrGameColorMap(1, 3) = 13 ' player 1 wall 3
        arrGameColorMap(1, 4) = 14 ' player 1 wall 4
        arrGameColorMap(1, 5) = 15 ' player 1 wall 5
        arrGameColorMap(1, 6) = 16 ' player 1 wall 6
        arrGameColorMap(1, 7) = 17 ' player 1 wall 7
        arrGameColorMap(1, 8) = 18 ' player 1 wall 8

        ' PLAYER 2 = YELLOW
        arrGameColorMap(2, 0) = 19 ' player 2
        arrGameColorMap(2, 1) = 20 ' player 2 wall 1
        arrGameColorMap(2, 2) = 21 ' player 2 wall 2
        arrGameColorMap(2, 3) = 22 ' player 2 wall 3
        arrGameColorMap(2, 4) = 23 ' player 2 wall 4
        arrGameColorMap(2, 5) = 24 ' player 2 wall 5
        arrGameColorMap(2, 6) = 25 ' player 2 wall 6
        arrGameColorMap(2, 7) = 26 ' player 2 wall 7
        arrGameColorMap(2, 8) = 27 ' player 2 wall 8

        ' PLAYER 3 = GREEN
        arrGameColorMap(3, 0) = 28 ' player 3
        arrGameColorMap(3, 1) = 29 ' player 3 wall 1
        arrGameColorMap(3, 2) = 30 ' player 3 wall 2
        arrGameColorMap(3, 3) = 31 ' player 3 wall 3
        arrGameColorMap(3, 4) = 32 ' player 3 wall 4
        arrGameColorMap(3, 5) = 33 ' player 3 wall 5
        arrGameColorMap(3, 6) = 34 ' player 3 wall 6
        arrGameColorMap(3, 7) = 35 ' player 3 wall 7
        arrGameColorMap(3, 8) = 36 ' player 3 wall 8

        ' PLAYER 4 = BLUE
        arrGameColorMap(4, 0) = 37 ' player 4
        arrGameColorMap(4, 1) = 38 ' player 4 wall 1
        arrGameColorMap(4, 2) = 39 ' player 4 wall 2
        arrGameColorMap(4, 3) = 40 ' player 4 wall 3 <-- added
        arrGameColorMap(4, 4) = 41 ' player 4 wall 4
        arrGameColorMap(4, 5) = 42 ' player 4 wall 5
        arrGameColorMap(4, 6) = 43 ' player 4 wall 6
        arrGameColorMap(4, 7) = 44 ' player 4 wall 7
        arrGameColorMap(4, 8) = 45 ' player 4 wall 8
    End If
    ' ================================================================================================================================================================
    ' END INIT GAME COLOR MAP
    ' ================================================================================================================================================================
   
   
    ' -----------------------------------------------------------------------------
    ' INIT SOUNDS
    arrSound(1) = 110
    arrSound(2) = 123
    arrSound(3) = 139
    arrSound(4) = 147
    arrSound(5) = 220
    arrSound(6) = 247
    arrSound(7) = 277
    arrSound(8) = 294

    ' -----------------------------------------------------------------------------
    ' INIT SCREEN POSITIONS FOR EACH PLAYER'S WINDOW
    ' BASED ON 1024X768 RESOLUTION
    ' TODO: support variable screen size and calculate this on the fly
    arrOffsetX(1) = 170
    arrOffsetY(1) = 85
    arrOffsetX(2) = 596
    arrOffsetY(2) = 85
    arrOffsetX(3) = 170
    arrOffsetY(3) = 426
    arrOffsetX(4) = 596
    arrOffsetY(4) = 426

    ' -----------------------------------------------------------------------------
    ' INIT KEY MAPPINGS FOR EACH PLAYER
    ' for now we're only supporting 4 players, but later will be 8

    ' Key                     _BUTTON       Action           Constant
    ' ---------------------   -----------   --------         -------
    ' A                       31            left  player 1   c_bKey_A
    ' D                       33            right player 1   c_bKey_D
    ' W                       18            up    player 1   c_bKey_W
    ' S                       32            down  player 1   c_bKey_S
    ' E                       19            fire  player 1   c_bKey_E

    ' J                       37            left  player 2   c_bKey_J
    ' L                       39            right player 4   c_bKey_L
    ' I                       24            up    player 4   c_bKey_I
    ' K                       38            down  player 2   c_bKey_K
    ' O                       25            fire  player 4   c_bKey_O

    ' Left                    332           left  player 3   c_bKey_Left
    ' Right                   334           right player 3   c_bKey_Right
    ' Up                      329           up    player 3   c_bKey_Up
    ' Down                    337           down  player 3   c_bKey_Down
    ' Right Ctrl              286           fire  player 3   c_bKey_RightCtrl

    ' KEYPAD 4 Left           76            left  player 4   c_bKey_Keypad4Left
    ' KEYPAD 6 Right          78            right player 4   c_bKey_Keypad6Right
    ' KEYPAD 8 Up             73            up    player 4   c_bKey_Keypad8Up
    ' KEYPAD 5 5              77            down  player 4   c_bKey_Keypad5
    ' KEYPAD 9 Page Up        74            fire  player 4   c_bKey_Keypad9PgUp

   
    arrKeyMap(1, c_Map_Left) = c_bKey_A
    arrKeyMap(1, c_Map_Right) = c_bKey_D
    arrKeyMap(1, c_Map_Up) = c_bKey_W
    arrKeyMap(1, c_Map_Down) = c_bKey_S
    arrKeyMap(1, c_Map_Button) = c_bKey_E
    arrKeyMap(1, c_Map_Quit_Round) = c_bKey_Q
    arrKeyMap(1, c_Map_Quit_Game) = c_bKey_Esc
   
    arrKeyMap(2, c_Map_Left) = c_bKey_J
    arrKeyMap(2, c_Map_Right) = c_bKey_L
    arrKeyMap(2, c_Map_Up) = c_bKey_I
    arrKeyMap(2, c_Map_Down) = c_bKey_K
    arrKeyMap(2, c_Map_Button) = c_bKey_O
    arrKeyMap(2, c_Map_Quit_Round) = c_bKey_U
    arrKeyMap(2, c_Map_Quit_Game) = c_bKey_Esc

    arrKeyMap(3, c_Map_Left) = c_bKey_Left
    arrKeyMap(3, c_Map_Right) = c_bKey_Right
    arrKeyMap(3, c_Map_Up) = c_bKey_Up
    arrKeyMap(3, c_Map_Down) = c_bKey_Down
    arrKeyMap(3, c_Map_Button) = c_bKey_RightCtrl
    arrKeyMap(3, c_Map_Quit_Round) = c_bKey_ShiftRight
    arrKeyMap(3, c_Map_Quit_Game) = c_bKey_Esc

    arrKeyMap(4, c_Map_Left) = c_bKey_Keypad4Left
    arrKeyMap(4, c_Map_Right) = c_bKey_Keypad6Right
    arrKeyMap(4, c_Map_Up) = c_bKey_Keypad8Up
    arrKeyMap(4, c_Map_Down) = c_bKey_Keypad5
    arrKeyMap(4, c_Map_Button) = c_bKey_Keypad9PgUp
    arrKeyMap(4, c_Map_Quit_Round) = c_bKey_Keypad7Home
    arrKeyMap(4, c_Map_Quit_Game) = c_bKey_Esc
   
    ' for now just use player 1-4 for players 5-8
    ' TODO: IMPLEMENT PLAYERS 5-8
    arrKeyMap(5, c_Map_Left) = c_bKey_A
    arrKeyMap(5, c_Map_Right) = c_bKey_D
    arrKeyMap(5, c_Map_Up) = c_bKey_W
    arrKeyMap(5, c_Map_Down) = c_bKey_S
    arrKeyMap(5, c_Map_Button) = c_bKey_E
    arrKeyMap(5, c_Map_Quit_Round) = c_bKey_Q
    arrKeyMap(5, c_Map_Quit_Game) = c_bKey_Esc

    arrKeyMap(6, c_Map_Left) = c_bKey_J
    arrKeyMap(6, c_Map_Right) = c_bKey_L
    arrKeyMap(6, c_Map_Up) = c_bKey_I
    arrKeyMap(6, c_Map_Down) = c_bKey_K
    arrKeyMap(6, c_Map_Button) = c_bKey_O
    arrKeyMap(6, c_Map_Quit_Round) = c_bKey_U
    arrKeyMap(6, c_Map_Quit_Game) = c_bKey_Esc

    arrKeyMap(7, c_Map_Left) = c_bKey_CrsrLeft
    arrKeyMap(7, c_Map_Right) = c_bKey_CrsrRight
    arrKeyMap(7, c_Map_Up) = c_bKey_CrsrUp
    arrKeyMap(7, c_Map_Down) = c_bKey_CrsrDown
    arrKeyMap(7, c_Map_Button) = c_bKey_RightCtrl
    arrKeyMap(7, c_Map_Quit_Round) = c_bKey_ShiftRight
    arrKeyMap(7, c_Map_Quit_Game) = c_bKey_Esc

    arrKeyMap(8, c_Map_Left) = c_bKey_Keypad4Left
    arrKeyMap(8, c_Map_Right) = c_bKey_Keypad6Right
    arrKeyMap(8, c_Map_Up) = c_bKey_Keypad8Up
    arrKeyMap(8, c_Map_Down) = c_bKey_Keypad5
    arrKeyMap(8, c_Map_Button) = c_bKey_Keypad9PgUp
    arrKeyMap(8, c_Map_Quit_Round) = c_bKey_Keypad7Home
    arrKeyMap(8, c_Map_Quit_Game) = c_bKey_Esc
   
    ' DEBUG
    'for iPlayerLoop = 1 to 4
    '   PRINT "arrKeyMap(" + cstr$(iPlayerLoop) + ", c_Map_Left)   = " + cstr$(arrKeyMap(iPlayerLoop, c_Map_Left))
    '   PRINT "arrKeyMap(" + cstr$(iPlayerLoop) + ", c_Map_Right)  = " + cstr$(arrKeyMap(iPlayerLoop, c_Map_Right))
    '   PRINT "arrKeyMap(" + cstr$(iPlayerLoop) + ", c_Map_Up)     = " + cstr$(arrKeyMap(iPlayerLoop, c_Map_Up))
    '   PRINT "arrKeyMap(" + cstr$(iPlayerLoop) + ", c_Map_Down)   = " + cstr$(arrKeyMap(iPlayerLoop, c_Map_Down))
    '   PRINT "arrKeyMap(" + cstr$(iPlayerLoop) + ", c_Map_Button) = " + cstr$(arrKeyMap(iPlayerLoop, c_Map_Button))
    'next iPlayerLoop
    'input "PRESS <ENTER> TO CONTINUE...",sTemp
    '_KEYCLEAR: '_DELAY 1
    'exit sub
   
    ' =============================================================================
    ' INIT PLAYERS AT BEGINNING OF GAME
    For iPlayerLoop = 1 To 4
        m_arrPlayer(iPlayerLoop).score = 0
        m_arrPlayer(iPlayerLoop).wins = 0
        m_arrPlayer(iPlayerLoop).color = arrPalette(arrGameColorMap(iPlayerLoop, 0))
    Next iPlayerLoop
    m_arrPlayer(1).TextColor1 = cRed
    m_arrPlayer(2).TextColor1 = cYellow
    m_arrPlayer(3).TextColor1 = cLime
    m_arrPlayer(4).TextColor1 = cCyan
    m_arrPlayer(1).TextColor2 = _RGB32(192, 0, 0)
    m_arrPlayer(2).TextColor2 = _RGB32(192, 192, 0)
    m_arrPlayer(3).TextColor2 = _RGB32(0, 192, 0)
    m_arrPlayer(4).TextColor2 = _RGB32(0, 192, 192)

   
    ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ' GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME
    ' GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME
    ' GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME
    ' BEGIN A SINGLE GAME #GAME
    ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bGameOver = FALSE
    iRoundNumber = 0
    Do
        ' INITIALIZE NEXT ROUND
        bRoundOver = FALSE
        iRoundNumber = iRoundNumber + 1
        sRound = "Round " + cstr$(iRoundNumber)
        'iRoundLen = len(sRound) / 2
        'iRoundX = (iScreenWidth / 2) - (iRoundLen * _FontWidth)
        'iRoundX = (iScreenWidth / 2)
        'iRoundY = (iScreenHeight / 2)
        iRoundX = (_FontWidth * 60) ' 465
        iRoundY = (_FontHeight * 3) ' 40
       
        ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ' ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND
        ' ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND
        ' ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND
        ' BEGIN A SINGLE ROUND #ROUND
        ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Do
            ' =============================================================================
            ' BUILD THE WORLD

            ' GENERATE ONE MAZE PER EACH PLAYER
            ' AND PLACE MAZE IN EACH PLAYER'S QUADRANT OF THE "WORLD"
            ' WITH A "HALLWAY" CONNECTING THE QUADRANTS,
            ' SORT OF LIKE THIS:
            '                                                                                                       11111111111111111111111111111
            '             11111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222
            '    12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
            '   1################################################################################################################################1
            '   2#                                                                                                                              #2
            '   3#                                                                                                                              #3
            '   4#                                                                                                                              #4
            '   5#                                                                                                                              #5
            '   6#                                                                                                                              #6
            '   7#                                                                                                                              #7
            '   8#                                                                                                                              #8
            '   9#                                                                                                                              #9
            '  10#                                                                                                                              #10
            '  11#                                                                                                                              #11
            '  12#                                                                                                                              #12
            '  13#           ########################################################################################################           #13
            '  14#           #                                                                                                      #           #14
            '  15#           #                                                                                                      #           #15
            '  16#           #                                                                                                      #           #16
            '  17#           #                                                                                                      #           #17
            '  18#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #18
            '  19#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #19
            '  20#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #20
            '  21#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #21
            '  22#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #22
            '  23#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #23
            '  24#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #24
            '  25#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #25
            '  26#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #26
            '  27#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #27
            '  28#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #28
            '  29#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #29
            '  30#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #30
            '  31#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #31
            '  32#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #32
            '  33#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #33
            '  34#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #34
            '  35#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #35
            '  36#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #36
            '  37#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #37
            '  38#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #38
            '  39#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #39
            '  40#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #40
            '  41#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #41
            '  42#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #42
            '  43#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #43
            '  44#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #44
            '  45#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #45
            '  46#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #46
            '  47#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #47
            '  48#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #48
            '  49#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #49
            '  50#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #50
            '  51#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #51
            '  52#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #52
            '  53#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #53
            '  54#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #54
            '  55#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #55
            '  56#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #56
            '  57#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #57
            '  58#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #58
            '  59#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #59
            '  60#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #60
            '  61#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #61
            '  62#           #    111111111111111111111111111111111111111111111    222222222222222222222222222222222222222222222    #           #62
            '  63#           #                                                                                                      #           #63
            '  64#           #                                                                                                      #           #64
            '  65#           #                                                                                                      #           #65
            '  66#           #                                                                                                      #           #66
            '  67#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #67
            '  68#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #68
            '  69#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #69
            '  70#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #70
            '  71#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #71
            '  72#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #72
            '  73#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #73
            '  74#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #74
            '  75#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #75
            '  76#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #76
            '  77#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #77
            '  78#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #78
            '  79#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #79
            '  80#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #80
            '  81#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #81
            '  82#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #82
            '  83#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #83
            '  84#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #84
            '  85#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #85
            '  86#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #86
            '  87#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #87
            '  88#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #88
            '  89#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #89
            '  90#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #90
            '  91#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #91
            '  92#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #92
            '  93#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #93
            '  94#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #94
            '  95#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #95
            '  96#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #96
            '  97#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #97
            '  98#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #98
            '  99#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #99
            ' 100#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #100
            ' 101#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #101
            ' 102#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #102
            ' 103#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #103
            ' 104#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #104
            ' 105#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #105
            ' 106#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #106
            ' 107#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #107
            ' 108#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #108
            ' 109#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #109
            ' 110#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #110
            ' 111#           #    333333333333333333333333333333333333333333333    444444444444444444444444444444444444444444444    #           #111
            ' 112#           #                                                                                                      #           #112
            ' 113#           #                                                                                                      #           #113
            ' 114#           #                                                                                                      #           #114
            ' 115#           #                                                                                                      #           #115
            ' 116#           ########################################################################################################           #116
            ' 117#                                                                                                                              #117
            ' 118#                                                                                                                              #118
            ' 119#                                                                                                                              #119
            ' 120#                                                                                                                              #120
            ' 121#                                                                                                                              #121
            ' 122#                                                                                                                              #122
            ' 123#                                                                                                                              #123
            ' 124#                                                                                                                              #124
            ' 125#                                                                                                                              #125
            ' 126#                                                                                                                              #126
            ' 127#                                                                                                                              #127
            ' 128################################################################################################################################128
            '    12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
            '             11111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222
            '                                                                                                       11111111111111111111111111111
           
            ' -----------------------------------------------------------------------------
            ' Make room for mazes, outer walls, central corridors
           
            ' OLD 99x99 VERSION:
            '' * 2x {max height}, 2x {max width} of maze
            '' * 3 tile hall along outer edges
            '' * 3 tile hall down center and through middle
            'iWorldRows = (iMaxRows * 2) + 3 + 3 + 3
            'iWorldCols = (iMaxCols * 2) + 3 + 3 + 3
           
            ' NEW 128x128 VERSION:
            ' * 2x {max height}, 2x {max width} of maze
            ' * 2x 4-tile hall along edges
            ' * 1x 4-tile hall down center and through middle
            ' * 2x 1-tile inner wall around edges
            ' * 2x ?-tile "no-mans-land" outside of inner wall
            ' * 2x 1-tile outer wall around no-mans-land
           
            ' What                              # Tiles  Quantity  Total Size
            ' max height/width of maze          45       2         90
            ' hall around edges                 4        2         8
            ' hall down center                  4        1         4
            ' inner wall around hall            1        2         2
            ' no-man's land around inner wall   11       2         22
            ' outer wall around no-man's land   1        2         2
            ' TOTALS                                               128
           
            ' -----------------------------------------------------------------------------
            ' COORDINATES:
            ' outer walls
            ' 1,1 to 1,128
            ' 1,1 to 128,1
            ' 1,128 to 128,128
            ' 128,1 to 128,128
            '
            ' inner walls
            ' 13,13 to 13,116
            ' 13,13 to 116,13
            ' 13,116 to 116,116
            ' 116,13 to 116,116
            '
            ' realm #1
            ' top left: 18,18
            ' top right: 18,17+width
            ' bottom left: 17+height,18
            ' bottom right: 17+height,17+width
            '     start
            '         19,19 to 19,61
            '         19,19 to 61,19
            '     exit
            '         (17+height)-1,(17+width)-1 to (17+height)-1,19
            '         (17+height)-1,(17+width)-1 to 19,(17+width)-1
            '
            ' realm #2
            ' top left: 18,67
            ' top right: 18,66+width
            ' bottom left: 77+height,67
            ' bottom right: 17+height,66+width
            '     start
            '         19,(66+width)-1 to 19,68
            '         19,(66+width)-1 to (17+height)-1,(66+width)-1
            '     exit
            '         (17+height)-1,(66+width)-1 to (17+height)-1,(66+width)-1
            '         (17+height)-1,(66+width)-1 to 19,68
            '
            ' realm #3
            ' top left: 67,18
            ' top right: 67,17+width
            ' bottom left: 66+height,18
            ' bottom right: 66+height,17+width
            '     start
            '         (66+height)+1,(17+width)+1 to (66+height)+1,(17+width)-1
            '         (66+height)+1,19 to 68,19
            '     exit
            '         68,(17+width)-1 to 68,19
            '         68,(17+width)-1 to (66+height)-1,(17+width)-1
            '
            ' realm #4
            ' top left: 67,67
            ' top right: 67,66+width
            ' bottom left: 66+height,67
            ' bottom right: 66+height,66+width
            '     start
            '         (66+height)-1,(66+width)-1 to (66+height)-1,68
            '         (66+height)-1,(66+width)-1 to 68,(66+width)-1
            '     exit
            '         68,68 to 68,(66+width)-1
            '         68,68 to (66+height)-1,68
            '
           
            iWorldRows = 128
            iWorldCols = 128
           
            ReDim arrWorld(iWorldRows, iWorldCols, 3) As Integer ' holds 1 maze for each player + connecting hallways
           
            ' -----------------------------------------------------------------------------
            ' Initialize world
           
            For iLoopRows = 1 To iWorldRows
                For iLoopCols = 1 To iWorldCols
                    arrWorld(iLoopRows, iLoopCols, cTerrainType) = iEmpty
                    arrWorld(iLoopRows, iLoopCols, cGraphicType) = iEmpty
                    arrWorld(iLoopRows, iLoopCols, cPlayersType) = iEmpty
                Next iLoopCols
            Next iLoopRows
           
            ' -----------------------------------------------------------------------------
            ' Draw outer wall
           
            For iLoopRows = 1 To iWorldRows
                ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' Left wall
                arrWorld(iLoopRows, 1, cTerrainType) = iWall
                'arrWorld(iLoopRows, 1, cGraphicType) = 25 ' arrColors(25)
               
                ' COLOR THE SECTION OF WALL WITH THE COLOR SCHEME
                arrWorld(iLoopRows, 1, cGraphicType) = _
                    arrGameColorMap(0, NextColorIndex%(iLoopRows, 1) )
               
                ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' Right wall
                arrWorld(iLoopRows, iWorldCols, cTerrainType) = iWall
                'arrWorld(iLoopRows, iWorldCols, cGraphicType) = 25 ' arrColors(25)
               
                ' COLOR THE SECTION OF WALL WITH THE COLOR SCHEME
                arrWorld(iLoopRows, iWorldCols, cGraphicType) = _
                    arrGameColorMap(0, NextColorIndex%(iLoopRows, iWorldCols) )
               
               
            Next iLoopRows
            For iLoopCols = 1 To iWorldCols
                ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' Top wall
                arrWorld(1, iLoopCols, cTerrainType) = iWall
                'arrWorld(1, iLoopCols, cGraphicType) = 25 ' arrColors(25)
               
                ' COLOR THE SECTION OF WALL WITH THE COLOR SCHEME
                arrWorld(1, iLoopCols, cGraphicType) = _
                    arrGameColorMap(0, NextColorIndex%(1, iLoopCols) )
               
                ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' Bottom wall
                arrWorld(iWorldRows, iLoopCols, cTerrainType) = iWall
                'arrWorld(iWorldRows, iLoopCols, cGraphicType) = 25 ' arrColors(25)
               
                ' COLOR THE SECTION OF WALL WITH THE COLOR SCHEME
                arrWorld(iWorldRows, iLoopCols, cGraphicType) = _
                    arrGameColorMap(0, NextColorIndex%(iWorldRows, iLoopCols) )
            Next iLoopCols
           
            ' -----------------------------------------------------------------------------
            ' Draw inner wall
            For iLoopRows = 13 To 116
                ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' Left wall
                arrWorld(iLoopRows, 13, cTerrainType) = iWall
                'arrWorld(iLoopRows, 13, cGraphicType) = 25 ' arrColors(25)
               
                ' COLOR THE SECTION OF WALL WITH THE COLOR SCHEME
                arrWorld(iLoopRows, 13, cGraphicType) = _
                    arrGameColorMap(0, NextColorIndex%(iLoopRows, 13) )
               
                ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' Right wall
                arrWorld(iLoopRows, 116, cTerrainType) = iWall
                'arrWorld(iLoopRows, 116, cGraphicType) = 25 ' arrColors(25)
               
                ' COLOR THE SECTION OF WALL WITH THE COLOR SCHEME
                arrWorld(iLoopRows, 116, cGraphicType) = _
                    arrGameColorMap(0, NextColorIndex%(iLoopRows, 116) )
            Next iLoopRows
            For iLoopCols = 13 To 116
                ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' Top wall
                arrWorld(13, iLoopCols, cTerrainType) = iWall
                'arrWorld(13, iLoopCols, cGraphicType) = 25 ' arrColors(25)
               
                ' COLOR THE SECTION OF WALL WITH THE COLOR SCHEME
                arrWorld(13, iLoopCols, cGraphicType) = _
                    arrGameColorMap(0, NextColorIndex%(13, iLoopCols) )
                   
                ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' Bottom wall
                arrWorld(116, iLoopCols, cTerrainType) = iWall
                'arrWorld(116, iLoopCols, cGraphicType) = 25 ' arrColors(25)
               
                ' COLOR THE SECTION OF WALL WITH THE COLOR SCHEME
                arrWorld(116, iLoopCols, cGraphicType) = _
                    arrGameColorMap(0, NextColorIndex%(116, iLoopCols) )
            Next iLoopCols
           
            ' -----------------------------------------------------------------------------
            ' DIMENSIONS:

            ' Difficulty   Width   RowsIn  ColsIn  RowsOut  ColsOut
            ' 10           1       22      22      45       45
            ' 9            2       14      14      43       43
            ' 8            3       11      11      45       45
            ' 7            4        8       8      41       41
            ' 6            5        7       7      43       43
            ' 5            6        6       6      43       43
            ' 4            7        5       5      41       41
            ' 3            8        4       4      37       37
            ' 2            9        4       4      41       41
            ' 1            10       4       4      45       45
            '                                 Max: 45       45

            ' Interconnecting hallway width/height: 3
            ' Each player's sector: 35 rows x 37 columns

            ' World = arrWorld(73 rows, 77 columns, 2 dimensions (1=specific colors, 2=general type)
            ' Height = 2 player sectors + 3 spaces for hallway = (2*35)+3 = 73
            ' Width  = 2 player sectors + 3 spaces for hallway = (2*37)+3 = 77
           
           
           
           
            ' ================================================================================================================================================================
            ' BEGIN GET THE MAZE DATA #MAZE
            ' #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE #MAZE
            ' ================================================================================================================================================================
            iEmpty = 0
            For iPlayerLoop = 1 To 4
               
                ' IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
                ' BEGIN INIT PLAYERS AT BEGINNING OF ROUND #INIT
                ' IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
               
                ' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ' BEGIN CHANGE DIFFICULTY + SETTINGS #DIFF
                ' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                If iRoundNumber = 1 Then
                    ' SET UP PLAYERS FOR FIRST ROUND...
                   
                    ' SET SCREEN MOVEMENT FOR PLAYERS MARKED RANDOM
                    If m_arrPlayer(iPlayerLoop).ScreenMoveCanChange = TRUE Then
                        ' START OUT SCROLLING
                        m_arrPlayer(iPlayerLoop).ScreenMovement = cScrolling
                    End If
                Else
                    ' ADVANCE OR ADJUST PLAYERS FOR NEXT ROUND...
                   
                    If m_arrPlayer(iPlayerLoop).GaveUp = FALSE Then
                        ' PLAYERS WHO FINISHED...
                       
                        ' ADVANCE ALL PLAYERS WHO DIDN'T FINISHED LAST
                        bIncreaseLevel = FALSE
                        If m_arrPlayer(iPlayerLoop).Place < 4 Then
                            If m_arrPlayer(iPlayerLoop).ScreenMoveCanChange = TRUE Then
                                ' TOGGLE SCREEN MOVEMENT FOR PLAYERS THAT FINISHED
                                ' AND ONLY INCREASE LEVEL AFTER FLIP SCREEN
                                If m_arrPlayer(iPlayerLoop).ScreenMovement = cScrolling Then
                                    m_arrPlayer(iPlayerLoop).ScreenMovement = cFlipScreen
                                Else
                                    m_arrPlayer(iPlayerLoop).ScreenMovement = cScrolling
                                    bIncreaseLevel = TRUE
                                End If
                            Else
                                bIncreaseLevel = TRUE
                            End If
                        End If
                       
                        ' INCREASE LEVEL?
                        If bIncreaseLevel = TRUE Then
                            m_arrPlayer(iPlayerLoop).Difficulty = m_arrPlayer(iPlayerLoop).Difficulty + 1
                            If m_arrPlayer(iPlayerLoop).Difficulty > 10 Then
                                ' PLAYERS RANKED HIGHER GET HARDER MAZES
                                Select Case m_arrPlayer(iPlayerLoop).OverallPlace
                                    Case 1:
                                        m_arrPlayer(iPlayerLoop).Difficulty = RandomNumber%(9, 10)
                                    Case 2:
                                        m_arrPlayer(iPlayerLoop).Difficulty = RandomNumber%(7, 10)
                                    Case 3:
                                        m_arrPlayer(iPlayerLoop).Difficulty = RandomNumber%(5, 10)
                                    Case Else:
                                        m_arrPlayer(iPlayerLoop).Difficulty = RandomNumber%(3, 10)
                                End Select
                            End If
                        End If
                       
                        ' MAKE THINGS HARDER FOR PLAYERS WHO KEEP WINNING
                        If m_arrPlayer(iPlayerLoop).ConsecWinCount > 8 Then
                            ' IF PLAYER HAS WON 9 OR MORE TIMES, GIVE THEM INSANE SPEED!
                            m_arrPlayer(iPlayerLoop).InitialSpeed = cMaxSpeed
                        ElseIf m_arrPlayer(iPlayerLoop).ConsecWinCount > 5 Then
                            ' IF PLAYER WON 5-8 TIMES, SLOW DOWN MORE
                            m_arrPlayer(iPlayerLoop).InitialSpeed = m_arrPlayer(iPlayerLoop).InitialSpeed - 2
                            If m_arrPlayer(iPlayerLoop).InitialSpeed < cMinSpeed Then
                                m_arrPlayer(iPlayerLoop).InitialSpeed = RandomNumber%(cMinSpeed, cMaxSpeed)
                            End If
                        ElseIf m_arrPlayer(iPlayerLoop).ConsecWinCount > 2 Then
                            ' IF PLAYER WON 3-5 TIMES, SLOW DOWN A LITTLE
                            m_arrPlayer(iPlayerLoop).InitialSpeed = m_arrPlayer(iPlayerLoop).InitialSpeed - 1
                            If m_arrPlayer(iPlayerLoop).InitialSpeed < cMinSpeed Then
                                m_arrPlayer(iPlayerLoop).InitialSpeed = RandomNumber%(cMinSpeed, cMaxSpeed)
                            End If
                        End If
                       
                        ' MAKE THINGS EASIER FOR PLAYERS WHO KEEP LOSING
                        If m_arrPlayer(iPlayerLoop).ConsecLossCount > 8 Then
                            ' IF PLAYER HAS LOST 9 OR MORE TIMES, MAKE THEM WAY FASTER
                            m_arrPlayer(iPlayerLoop).InitialSpeed = m_arrPlayer(iPlayerLoop).InitialSpeed + 3
                            If m_arrPlayer(iPlayerLoop).InitialSpeed > cMaxSpeed Then
                                m_arrPlayer(iPlayerLoop).InitialSpeed = cInitialSpeed
                            End If
                        ElseIf m_arrPlayer(iPlayerLoop).ConsecLossCount > 5 Then
                            ' IF PLAYER LOST 6-8 TIMES, MAKE THEM EVEN FASTER
                            m_arrPlayer(iPlayerLoop).InitialSpeed = m_arrPlayer(iPlayerLoop).InitialSpeed + 2
                            If m_arrPlayer(iPlayerLoop).InitialSpeed > cMaxSpeed Then
                                m_arrPlayer(iPlayerLoop).InitialSpeed = cInitialSpeed
                            End If
                        ElseIf m_arrPlayer(iPlayerLoop).ConsecLossCount > 2 Then
                            ' IF PLAYER HAS LOST 3-5 TIMES, MAKE THEM FASTER
                            m_arrPlayer(iPlayerLoop).InitialSpeed = m_arrPlayer(iPlayerLoop).InitialSpeed + 1
                            If m_arrPlayer(iPlayerLoop).InitialSpeed > cMaxSpeed Then
                                m_arrPlayer(iPlayerLoop).InitialSpeed = cInitialSpeed
                            End If
                        End If
                       
                    Else
                        ' PLAYERS WHO QUIT...
                    End If
                   
                   
                End If
                ' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ' END CHANGE DIFFICULTY + SETTINGS @DIFF
                ' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
               
               
                ' RESET PLAYER'S PLACE INFO
                m_arrPlayer(iPlayerLoop).IsDone = FALSE
                m_arrPlayer(iPlayerLoop).GaveUp = FALSE
                m_arrPlayer(iPlayerLoop).Place = 0
                m_arrPlayer(iPlayerLoop).PlaceText = ""
               
                ' IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
                ' END INIT PLAYERS AT BEGINNING OF ROUND @INIT
                ' IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
               
                ' GET NEXT PLAYER'S REALM
                iNextWall = iPlayerLoop
               
                ' -----------------------------------------------------------------------------
                ' SETUP MAZE

                ' DETERMINE THE DIMENSIONS:
                ' the harder the difficulty, the narrower the width
                ' (ie the more complex the maze):

                ' Difficulty   Width   RowsIn  ColsIn  RowsOut  ColsOut
                ' 10           1       22      22      45       45
                ' 9            2       14      14      43       43
                ' 8            3       11      11      45       45
                ' 7            4        8       8      41       41
                ' 6            5        7       7      43       43
                ' 5            6        6       6      43       43
                ' 4            7        5       5      41       41
                ' 3            8        4       4      37       37
                ' 2            9        4       4      41       41
                ' 1            10       4       4      45       45
                '                                     ------   ------
                '                                 Max: 45       45

                ' Get the difficulty for the current player
                iDifficulty = m_arrPlayer(iPlayerLoop).Difficulty

                ' Get the next maze dimensions per the difficulty
                iMakeWidth = arrMazeOptions(iDifficulty).makeWidth
                iMakeRows = arrMazeOptions(iDifficulty).makeRows
                iMakeCols = arrMazeOptions(iDifficulty).makeCols
                iFinalRows = arrMazeOptions(iDifficulty).finalRows
                iFinalCols = arrMazeOptions(iDifficulty).finalCols

                ' Resize maze array per the dimensions
                'REDIM arrNextMaze(iFinalRows, iFinalCols) AS INTEGER
                ReDim arrNextMaze(50, 50) As Integer

                ' Setup differently depending on if player is human / computer / none
                If m_arrPlayer(iPlayerLoop).UserType = cHuman Then

                    ' GET NEW MAZE
                    get_random_maze_array arrNextMaze(), iMakeCols, iMakeRows, iMakeWidth, iNextWall, iEmpty, iRowCount, iColCount, sMaze
                    ' function returns
                    ' * arrNextMaze() = the maze
                    ' * iRowCount and iColCount = the final size of the maze

                ElseIf m_arrPlayer(iPlayerLoop).UserType = cComputer Then
                    ' RANDOM RUBBLE
                    iTemp1 = RandomNumber%(1, 20)
                    For iLoopRows = 1 To iMaxRows
                        For iLoopCols = 1 To iMaxCols
                            iTemp2 = RandomNumber%(1, iTemp1)
                            If (iTemp2 = 1) Then
                                arrNextMaze(iLoopRows, iLoopCols) = iNextWall
                            Else
                                arrNextMaze(iLoopRows, iLoopCols) = iEmpty
                            End If
                        Next iLoopCols
                    Next iLoopRows
                    iColCount = iMaxCols
                    iRowCount = iMaxRows

                Else '  m_arrPlayer(iPlayerLoop).UserType = cNone then
                    ' RANDOM RUBBLE
                    iTemp1 = RandomNumber%(1, 20)
                    For iLoopRows = 1 To iMaxRows
                        For iLoopCols = 1 To iMaxCols
                            iTemp2 = RandomNumber%(1, iTemp1)
                            If (iTemp2 = 1) Then
                                arrNextMaze(iLoopRows, iLoopCols) = iNextWall
                            Else
                                arrNextMaze(iLoopRows, iLoopCols) = iEmpty
                            End If
                        Next iLoopCols
                    Next iLoopRows
                    iColCount = iMaxCols
                    iRowCount = iMaxRows
                End If
               
                ' -----------------------------------------------------------------------------
                ' COPY NEXT PLAYER'S MAZE (REALM) TO THE BIG WORLD MAP
               
                ' DETERMINE LOCATION IN WORLD TO COPY MAZE TO
                ' Basically:
                ' player 1 = top    left, player 2 = top    right,
                ' player 3 = bottom left, player 4 = bottom right
                Select Case iPlayerLoop
                    Case 1:
                        ' TOP LEFT STARTING POINT OF MAZE IN WORLD
                        yPos% = 18
                        xPos% = 18
                    Case 2:
                        ' TOP LEFT STARTING POINT OF MAZE IN WORLD
                        yPos% = 18
                        xPos% = 67
                    Case 3:
                        ' TOP LEFT STARTING POINT OF MAZE IN WORLD
                        yPos% = 67
                        xPos% = 18
                    Case Else:
                        ' TOP LEFT STARTING POINT OF MAZE IN WORLD
                        yPos% = 67
                        xPos% = 67
                End Select
               
                ' COPY MAZE TO WORLD
                For iLoopRows = 0 To iMaxRows - 1 ' lbound(arrNextMaze, 1) to ubound(arrNextMaze, 1) ' 1 TO 35
                    For iLoopCols = 1 To iMaxCols ' lbound(arrNextMaze, 2) to ubound(arrNextMaze, 2) ' 1 TO 37
                        If (iLoopRows <= iFinalRows) And (iLoopCols <= iFinalCols) Then
                           
                            ' COLOR THE SECTION OF WALL WITH THE COLOR SCHEME OF THE PLAYER
                            arrWorld(yPos% + iLoopRows, xPos% + iLoopCols, cGraphicType) = _
                                arrGameColorMap(iPlayerLoop, NextColorIndex%(yPos% + iLoopRows, xPos% + iLoopCols) )
                           
                            'OLD COLOR CODE:
                            'arrWorld(yPos% + iLoopRows, xPos% + iLoopCols, cGraphicType) = arrNextMaze(iLoopRows, iLoopCols)
                           
                            If (arrNextMaze(iLoopRows, iLoopCols) = iEmpty) Then
                                arrWorld(yPos% + iLoopRows, xPos% + iLoopCols, cTerrainType) = iEmpty
                            Else
                                arrWorld(yPos% + iLoopRows, xPos% + iLoopCols, cTerrainType) = iWall
                            End If
                        Else
                            arrWorld(yPos% + iLoopRows, xPos% + iLoopCols, cGraphicType) = iEmpty
                            arrWorld(yPos% + iLoopRows, xPos% + iLoopCols, cTerrainType) = iEmpty
                        End If
                    Next iLoopCols
                Next iLoopRows
               
                ' SAVE MAZE DIMENSIONS
                m_arrPlayer(iPlayerLoop).rows = iRowCount
                m_arrPlayer(iPlayerLoop).cols = iColCount
               
                ' -----------------------------------------------------------------------------
                ' SAVE BIT VALUE
                m_arrPlayer(iPlayerLoop).bit = 2 ^ (iPlayerLoop - 1)
               
                ' -----------------------------------------------------------------------------
                ' INITIALIZE PLAYER SPEED
                m_arrPlayer(iPlayerLoop).speed = m_arrPlayer(iPlayerLoop).InitialSpeed ' cInitialSpeed
                m_arrPlayer(iPlayerLoop).delay = cMaxSpeed
               
            Next iPlayerLoop
            ' ================================================================================================================================================================
            ' END GET THE MAZE DATA @MAZE
            ' @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE @MAZE
            ' =============================================================================
           
           
           
            ' =============================================================================
            ' BEGIN START EXIT #FindStart
            ' DETERMINE PLAYER START POSITIONS / MAZE EXITS
            ' =============================================================================
           
            'arrSearch(iPlayerLoop, cStartPosition, 1).y1
            'arrSearch(iPlayerLoop, cStartPosition, 1).x1
            'arrSearch(iPlayerLoop, cStartPosition, 1).y2
            'arrSearch(iPlayerLoop, cStartPosition, 1).x2
            '
            'arrSearch(iPlayerLoop, cEndPosition,   1).y1
            'arrSearch(iPlayerLoop, cEndPosition,   1).x1
            'arrSearch(iPlayerLoop, cEndPosition,   1).y2
            'arrSearch(iPlayerLoop, cEndPosition,   1).x2
           
           
            ' -----------------------------------------------------------------------------
            ' Realm #1
            ' top left: 18,18
            ' top right: 18,17+iColCount
            ' bottom left: 17+iRowCount,18
            ' bottom right: 17+iRowCount,17+iColCount
           
            ' DETERMINE PLAYER 1 START POSITION (BOTTOM RIGHT)
           
            If Len(sError) = 0 Then
                iPlayerLoop = 1
                bFound = FALSE
               
                iRowCount = m_arrPlayer(iPlayerLoop).rows
                iColCount = m_arrPlayer(iPlayerLoop).cols
               
                ' search 1: (17+iRowCount)-1,(17+iColCount)-1 to (17+iRowCount)-1,19
                iStartY = (17 + iRowCount) - 1
                iStartX = (17 + iColCount) '-1
                iEndY = (17 + iRowCount) - 1
                iEndX = 19
               
                For yPos% = iStartY To iEndY
                    For xPos% = iStartX To iEndX Step -1
                        If arrWorld(yPos%, xPos%, cTerrainType) = iEmpty Then
                            ' HOME BASE
                            m_arrPlayer(iPlayerLoop).hy = yPos%
                            m_arrPlayer(iPlayerLoop).hx = xPos%
                           
                            ' CURRENT POSITION
                            m_arrPlayer(iPlayerLoop).y = yPos%
                            m_arrPlayer(iPlayerLoop).x = xPos%
                           
                            ' START POSITION
                            m_arrPlayer(iPlayerLoop).starty = yPos%
                            m_arrPlayer(iPlayerLoop).startx = xPos%
                           
                            bFound = TRUE
                            Exit For
                        End If
                    Next xPos%
                    If bFound Then Exit For
                Next yPos%
                If bFound = FALSE Then
                    sError = "Could not find start position for player " + cstr$(iPlayerLoop) + "."
                    ' TODO: search 2: (17+iRowCount)-1,(17+iColCount)-1 to 19,(17+iColCount)-1
                End If
            End If
           
            ' CREATE PLAYER 1 EXIT (TOP LEFT)
            If Len(sError) = 0 Then
                iPlayerLoop = 1
                bFound = FALSE
               
                ' search 1: 19,19 to 19,61
                iStartY = 19
                iStartX = 19
                iEndY = 19
                iEndX = (17 + iColCount) - 1
               
                For yPos% = iStartY To iEndY
                    For xPos% = iStartX To iEndX
                        If arrWorld(yPos%, xPos%, cTerrainType) = iEmpty Then
                            m_arrPlayer(iPlayerLoop).ey = yPos% - 1
                            m_arrPlayer(iPlayerLoop).ex = xPos%
                            arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cTerrainType) = iEmpty
                            arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cGraphicType) = iEmpty
                            bFound = TRUE
                            Exit For
                        End If
                    Next xPos%
                    If bFound Then Exit For
                Next yPos%
                If bFound = FALSE Then
                    sError = "Could not find exit position for player " + cstr$(iPlayerLoop) + "."
                    ' TODO: search 2: 19,19 to 61,19
                End If
            End If
           
            ' -----------------------------------------------------------------------------
            ' Realm #2
            ' top left: 18,67
            ' top right: 18,66+iColCount
            ' bottom left: 77+iRowCount,67
            ' bottom right: 17+iRowCount,66+iColCount
           
            ' DETERMINE PLAYER 2 START POSITION (BOTTOM LEFT)
            If Len(sError) = 0 Then
                iPlayerLoop = 2
                bFound = FALSE
               
                iRowCount = m_arrPlayer(iPlayerLoop).rows
                iColCount = m_arrPlayer(iPlayerLoop).cols
               
                ' search 1: (17+iRowCount)-1,68 to (17+iRowCount)-1,(66+iColCount)-1
                iStartY = (17 + iRowCount) - 1
                iStartX = 68
                iEndY = (17 + iRowCount) - 1
                iEndX = (66 + iColCount) - 1
               
                For yPos% = iStartY To iEndY
                    For xPos% = iStartX To iEndX
                        If arrWorld(yPos%, xPos%, cTerrainType) = iEmpty Then
                            ' HOME BASE
                            m_arrPlayer(iPlayerLoop).hy = yPos%
                            m_arrPlayer(iPlayerLoop).hx = xPos%
                           
                            ' CURRENT POSITION
                            m_arrPlayer(iPlayerLoop).y = yPos%
                            m_arrPlayer(iPlayerLoop).x = xPos%
                           
                            ' START POSITION
                            m_arrPlayer(iPlayerLoop).starty = yPos%
                            m_arrPlayer(iPlayerLoop).startx = xPos%
                           
                            bFound = TRUE
                            Exit For
                        End If
                    Next xPos%
                    If bFound = TRUE Then Exit For
                Next yPos%
                If bFound = FALSE Then
                    sError = "Could not find start position for player " + cstr$(iPlayerLoop) + "."
                    ' TODO: search 2: (17+iRowCount)-1,68 to 22,68
                End If
            End If
           
            ' CREATE PLAYER 2 EXIT (TOP RIGHT)
            If Len(sError) = 0 Then
                iPlayerLoop = 2
                bFound = FALSE
               
                ' search 1: 19,(66+iColCount)-1 to 19,68
                iStartY = 19
                iStartX = (66 + iColCount) '-1
                iEndY = 19
                iEndX = 68
               
                For yPos% = iStartY To iEndY
                    For xPos% = iStartX To iEndX Step -1
                        If arrWorld(yPos%, xPos%, cTerrainType) = iEmpty Then
                            m_arrPlayer(iPlayerLoop).ey = yPos% - 1
                            m_arrPlayer(iPlayerLoop).ex = xPos%
                            arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cTerrainType) = iEmpty
                            arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cGraphicType) = iEmpty
                            bFound = TRUE
                            Exit For
                        End If
                    Next xPos%
                    If bFound = TRUE Then Exit For
                Next yPos%
                If bFound = FALSE Then
                    sError = "Could not find exit position for player " + cstr$(iPlayerLoop) + "."
                    ' TODO: search 2: 19,(66+iColCount)-1 to (17+iRowCount)-1,(66+iColCount)-1
                End If
            End If
           
            ' -----------------------------------------------------------------------------
            ' Realm #3
            ' top left: 67,18
            ' top right: 67,17+iColCount
            ' bottom left: 66+iRowCount,18
            ' bottom right: 66+iRowCount,17+iColCount
           
            ' DETERMINE PLAYER 3 START POSITION (TOP RIGHT)
            If Len(sError) = 0 Then
                iPlayerLoop = 3
                bFound = FALSE
               
                iRowCount = m_arrPlayer(iPlayerLoop).rows
                iColCount = m_arrPlayer(iPlayerLoop).cols
               
                ' search 1: 68,(17+iColCount)-1 to 68,19
                iStartY = 68
                iStartX = (17 + iColCount) '-1
                iEndY = 68
                iEndX = 19
               
                For yPos% = iStartY To iEndY
                    For xPos% = iStartX To iEndX Step -1
                        If arrWorld(yPos%, xPos%, cTerrainType) = iEmpty Then
                            ' HOME BASE
                            m_arrPlayer(iPlayerLoop).hy = yPos%
                            m_arrPlayer(iPlayerLoop).hx = xPos%
                           
                            ' CURRENT POSITION
                            m_arrPlayer(iPlayerLoop).y = yPos%
                            m_arrPlayer(iPlayerLoop).x = xPos%
                           
                            ' START POSITION
                            m_arrPlayer(iPlayerLoop).starty = yPos%
                            m_arrPlayer(iPlayerLoop).startx = xPos%
                           
                            bFound = TRUE
                            Exit For
                        End If
                    Next xPos%
                    If bFound Then Exit For
                Next yPos%
                If bFound = FALSE Then
                    sError = "Could not find start position for player " + cstr$(iPlayerLoop) + "."
                    ' TODO: search 2: 68,(17+iColCount)-1 to (66+iRowCount)-1,(17+iColCount)-1
                End If
            End If
           
            ' CREATE PLAYER 3 EXIT (BOTTOM LEFT)
            If Len(sError) = 0 Then
                iPlayerLoop = 3
                bFound = FALSE
               
                ' search 1: (66+iRowCount)-1,19 to (66+iRowCount)-1,(17+iColCount)+1
                iStartY = (66 + iRowCount) - 1
                iStartX = 19
                iEndY = (66 + iRowCount) - 1
                iEndX = (17 + iColCount) + 1
               
                For yPos% = iStartY To iEndY
                    For xPos% = iStartX To iEndX
                        If arrWorld(yPos%, xPos%, cTerrainType) = iEmpty Then
                            m_arrPlayer(iPlayerLoop).ey = yPos% + 1
                            m_arrPlayer(iPlayerLoop).ex = xPos%
                            arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cTerrainType) = iEmpty
                            arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cGraphicType) = iEmpty
                            bFound = TRUE
                            Exit For
                        End If
                    Next xPos%
                    If bFound Then Exit For
                Next yPos%
                If bFound = FALSE Then
                    sError = "Could not find exit position for player " + cstr$(iPlayerLoop) + "."
                    ' TODO: search 2: (66+iRowCount)-1,19 to 68,19
                End If
            End If
           
            ' -----------------------------------------------------------------------------
            ' Realm #4
            ' top left: 67,67
            ' top right: 67,66+iColCount
            ' bottom left: 66+iRowCount,67
            ' bottom right: 66+iRowCount,66+iColCount
           
            ' DETERMINE PLAYER 4 START POSITION (TOP LEFT)
            If Len(sError) = 0 Then
                iPlayerLoop = 4
                bFound = FALSE
               
                iRowCount = m_arrPlayer(iPlayerLoop).rows
                iColCount = m_arrPlayer(iPlayerLoop).cols
               
                ' search 1: 68,68 to 68,(66+iColCount)-1
                iStartY = 68
                iStartX = 68
                iEndY = 68
                iEndX = (66 + iColCount) - 1
               
                For yPos% = iStartY To iEndY
                    For xPos% = iStartX To iEndX
                        If arrWorld(yPos%, xPos%, cTerrainType) = iEmpty Then
                            ' HOME BASE
                            m_arrPlayer(iPlayerLoop).hy = yPos%
                            m_arrPlayer(iPlayerLoop).hx = xPos%
                           
                            ' CURRENT POSITION
                            m_arrPlayer(iPlayerLoop).y = yPos%
                            m_arrPlayer(iPlayerLoop).x = xPos%
                           
                            ' START POSITION
                            m_arrPlayer(iPlayerLoop).starty = yPos%
                            m_arrPlayer(iPlayerLoop).startx = xPos%
                           
                            bFound = TRUE
                            Exit For
                        End If
                    Next xPos%
                    If bFound Then Exit For
                Next yPos%
                If bFound = FALSE Then
                    sError = "Could not find start position for player " + cstr$(iPlayerLoop) + "."
                    ' TODO: search 2: 68,68 to (66+iRowCount)-1,68
                End If
            End If
           
            ' CREATE PLAYER 4 EXIT (BOTTOM RIGHT)
            If Len(sError) = 0 Then
                iPlayerLoop = 4
                bFound = FALSE
               
                ' search 1: (66+iRowCount)-1,(66+iColCount)-1 to (66+iRowCount)-1,68
                iStartY = (66 + iRowCount) - 1
                iStartX = (66 + iColCount) '-1
                iEndY = (66 + iRowCount) - 1
                iEndX = 68
               
                For yPos% = iStartY To iEndY
                    For xPos% = iStartX To iEndX Step -1
                        If arrWorld(yPos%, xPos%, cTerrainType) = iEmpty Then
                            m_arrPlayer(iPlayerLoop).ey = yPos% + 1
                            m_arrPlayer(iPlayerLoop).ex = xPos%
                            arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cTerrainType) = iEmpty
                            arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cGraphicType) = iEmpty
                            bFound = TRUE
                            Exit For
                        End If
                    Next xPos%
                    If bFound Then Exit For
                Next yPos%
                If bFound = FALSE Then
                    sError = "Could not find exit position for player " + cstr$(iPlayerLoop) + "."
                    ' TODO: search 2: (66+iRowCount)-1,(66+iColCount)-1 to 68,(66+iColCount)-1
                End If
            End If
           
            ' =============================================================================
            ' END START EXIT @FindStart
            ' DETERMINE PLAYER START POSITIONS / MAZE EXITS
            ' =============================================================================
           
           
           
           
           
            ' =============================================================================
            ' BEGIN TEMPORARILY MARK START POSITIONS AND EXITS
            ' =============================================================================
            If TRUE = FALSE Then
                Print "# .x .y .hx .hy .ex .ey cols rows"
                For iPlayerLoop = 1 To 4
                    Select Case iPlayerLoop
                        Case 1:
                            iNextColor1~& = _RGB32(255, 0, 0)
                            iNextColor2~& = _RGB32(127, 0, 0)
                        Case 2:
                            iNextColor1~& = _RGB32(255, 255, 0)
                            iNextColor2~& = _RGB32(127, 127, 0)
                        Case 3:
                            iNextColor1~& = _RGB32(0, 255, 0)
                            iNextColor2~& = _RGB32(0, 127, 0)
                        Case Else:
                            iNextColor1~& = _RGB32(0, 0, 255)
                            iNextColor2~& = _RGB32(0, 0, 127)
                    End Select
                   
                    ' TEMPORARILY START POSITIONS
                    'iNextColor1~& = arrColors(iPlayerLoop + 8)
                    arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cGraphicType) = iNextColor1~& ' iWall
                   
                    ' TEMPORARILY MARK EXITS
                    'iNextColor1~& = arrColors(iPlayerLoop + 16)
                    arrWorld(m_arrPlayer(iPlayerLoop).ey, m_arrPlayer(iPlayerLoop).ex, cGraphicType) = iNextColor2~& ' iWall
               
               
                    ' DUMP VALUES
                    Print cstr$(iPlayerLoop) + ": ";
                    Print "start=(" + cstr$(m_arrPlayer(iPlayerLoop).x) + ", " + cstr$(m_arrPlayer(iPlayerLoop).y) + ")";
                    Print "home =(" + cstr$(m_arrPlayer(iPlayerLoop).hx) + ", " + cstr$(m_arrPlayer(iPlayerLoop).hy) + ")";
                    Print "end  =(" + cstr$(m_arrPlayer(iPlayerLoop).ex) + ", " + cstr$(m_arrPlayer(iPlayerLoop).ey) + ")";
                    Print "size =(" + cstr$(m_arrPlayer(iPlayerLoop).cols) + ", " + cstr$(m_arrPlayer(iPlayerLoop).rows) + ")"
               
                Next iPlayerLoop
           
                Input "PRESS <ENTER> TO CONTINUE...", sError
            End If
            ' =============================================================================
            ' END TEMPORARILY MARK START POSITIONS AND EXITS
            ' =============================================================================
           
            ' =============================================================================
            ' CREATE FINISH LINE IN CENTER OF WORLD #Finish
            yPos% = iWorldRows / 2
            xPos% = iWorldCols / 2
            arrWorld(yPos%, xPos%, cTerrainType) = iFinish
            arrWorld(yPos%, xPos%, cGraphicType) = 26
           
            ' CREATE BIGGER FINISH TARGET:
            'iStartY = yPos% - 1
            'iStartX = xPos% - 1
            'iEndY = yPos% + 1
            'iEndX = xPos% + 1
            'For yPos% = iStartY To iEndY
            '   For xPos% = iStartX To iEndX
            '       arrWorld(yPos%, xPos%, cTerrainType) = iFinish
            '       arrWorld(yPos%, xPos%, cGraphicType) = 26
            '   Next xPos%
            'Next yPos%
           
            ' =============================================================================
            ' ADD PLAYERS TO "OTHER PLAYER" LAYER OF MAP
            For iPlayerLoop = 1 To 4
                ' Turn on player's bit in the position on the map
                arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) Or m_arrPlayer(iPlayerLoop).bit)
            Next iPlayerLoop
           
            ' =============================================================================
            ' DRAW MAZE ON GRAPHIC SCREEN
            ' =============================================================================
            If Len(sError) = 0 Then
               
               
                ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' BEGIN INITIALIZE SCREEN #SCREEN
                ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               
                'SCREEN _NEWIMAGE(iScreenWidth, iScreenHeight, iBgColor) ' 640x48O graphics screen
                'SCREEN _NEWIMAGE(1280, 1024, iBgColor) ' 1280x1024 graphics screen
                'SCREEN _NEWIMAGE(3480, 2160, iBgColor) ' 3480x216O graphics screen

                'SCREEN _NEWIMAGE(800, 800, iBgColor) ' 800x800 graphics screen
                'iTileSize = 8

                'MOVED TO MENU SCREEN:
                'Screen _NewImage(1024, 768, 32) ' graphics screen
               
                ' CLEAR SCREEN
                Color cLightGray, cBlack: Cls
               
                ' SET UP SCREEN OFFSETS AND SOME DISPLAY VALUES
                iTileSize = 16
                iOffset% = iTileSize

                ' START FILLSCREEN MODE
                ' Syntax: _FULLSCREEN [_STRETCH | _SQUAREPIXELS| _OFF][, _SMOOTH]
                ' Parameters
                ' _STRETCH default first choice attempts to mimic QBasic's full screens if possible. _FULLSCREEN (function) returns 1.
                ' _SQUAREPIXELS alternate choice enlarges the pixels into squares on some monitors. _FULLSCREEN returns 2
                ' _OFF turns _FULLSCREEN off after full screen has been enabled. _FULLSCREEN (function) returns 0.
                ' Second optional parameter _SMOOTH applies antialiasing to the stretched screen.
                '
                ' Description
                ' Set the SCREEN mode and text WIDTH when necessary first. Otherwise there may be desktop view issues.
                ' _FULLSCREEN with no parameters chooses _STRETCH or _SQUAREPIXELS (prioritizes _STRETCH to mimic QBasic if possible)
                ' Check the fullscreen mode with the _FULLSCREEN function in your programs when a method is required.
                ' It is advisable to get input from the user to confirm that fullscreen was completed or there were possible monitor incompatibilities.
                ' If fullscreen is not confirmed with a _FULLSCREEN (function) return greater than 0, then disable with _FULLSCREEN _OFF.
                ' NOTE: _FULLSCREEN can also be affected by custom _FONT size settings and make program screens too large.
               
                If m_bFullScreen% = TRUE Then
                    '_FULLSCREEN _STRETCH
                    _FullScreen _SquarePixels
                Else
                    _FullScreen _Off
                End If
               
                ' check that a full screen mode initialized
                If _FullScreen = 0 Then
                    _FullScreen _Off
                    Sound 100, .75
                End If
                '_SCREENMOVE _MIDDLE
               
                ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' END INITIALIZE SCREEN @SCREEN
                ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               
                ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' BEGIN DISPLAY TITLE + INFO + INSTRUCTIONS #ONSCREEN
                ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                sTitle = "Quadventure"
                iTitleX = (_FontWidth * 58)
                iTitleY = (_FontHeight * 1)
                Color cMagenta, cBlack
                _PrintString (iTitleX, iTitleY), sTitle
               
                sTitle = "by Softintheheadware"
                iTitleX = (_FontWidth * 54)
                iTitleY = (_FontHeight * 2)
                Color cLightPink, cBlack
                _PrintString (iTitleX, iTitleY), sTitle
               
                sTitle = "Race to the flashing dot!"
                iTitleX = (_FontWidth * 51)
                iTitleY = (_FontHeight * 45)
                Color cHotPink, cBlack
                _PrintString (iTitleX, iTitleY), sTitle

                ' DISPLAY INSTRUCTIONS PLAYER 1
                Color m_arrPlayer(1).TextColor1, cBlack
                iTitleX = (_FontWidth * 56)
                iLine = 5
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Left :A"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Right:D"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Up   :W"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Down :S"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Honk :E"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Quit :Q"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Exit :ESC"
                iLine = iLine + 1
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Level:" + cstr$(m_arrPlayer(1).Difficulty)
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Wins :" + cstr$(m_arrPlayer(1).wins)
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Place:" + cstr$(m_arrPlayer(1).OverallPlace)
               
                ' DISPLAY INSTRUCTIONS PLAYER 2
                Color m_arrPlayer(2).TextColor1, cBlack
                iTitleX = (_FontWidth * 110)
                iLine = 5
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Left :J"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Right:L"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Up   :I"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Down :K"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Honk :O"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Quit :U"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Exit :ESC"
                iLine = iLine + 1
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Level:" + cstr$(m_arrPlayer(2).Difficulty)
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Wins :" + cstr$(m_arrPlayer(2).wins)
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Place:" + cstr$(m_arrPlayer(2).OverallPlace)

                ' DISPLAY INSTRUCTIONS PLAYER 3
                Color m_arrPlayer(3).TextColor1, cBlack
                iTitleX = (_FontWidth * 56)
                iLine = 26
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Left :CRSR LEFT"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Right:CRSR RIGHT"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Up   :CRSR UP"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Down :CRSR DOWN"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Honk :RIGHT CTRL"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Quit :RIGHT SHIFT"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Exit :ESC"
                iLine = iLine + 1
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Level:" + cstr$(m_arrPlayer(3).Difficulty)
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Wins :" + cstr$(m_arrPlayer(3).wins)
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Place:" + cstr$(m_arrPlayer(3).OverallPlace)
               
                ' DISPLAY INSTRUCTIONS PLAYER 4
                Color m_arrPlayer(4).TextColor1, cBlack
                iTitleX = (_FontWidth * 110)
                iLine = 26
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Left :KEYPAD 4"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Right:KEYPAD 6"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Up   :KEYPAD 8"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Down :KEYPAD 5"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Honk :KEYPAD 9"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Quit :KEYPAD 7"
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Exit :ESC"
                iLine = iLine + 1
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Level:" + cstr$(m_arrPlayer(4).Difficulty)
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Wins :" + cstr$(m_arrPlayer(4).wins)
                iLine = iLine + 1: iTitleY = (_FontHeight * iLine): _PrintString (iTitleX, iTitleY), "Place:" + cstr$(m_arrPlayer(3).OverallPlace)
               
                ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                ' END DISPLAY TITLE + INFO + INSTRUCTIONS @ONSCREEN
                ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               
                ' DRAW ENTIRE WORLD
                'FOR yPos% = 1 TO iWorldRows ' FOR y% = LBOUND(arrMap, 1) TO UBOUND(arrMap, 1)
                '    FOR xPos% = 1 TO iWorldCols ' FOR x% = LBOUND(arrMap, 2) TO UBOUND(arrMap, 2)
                '        iObject = arrWorld(yPos%, xPos%, cGraphicType)
                '        if iObject > -1 and iObject < 9 then
                '            iNextColor1~& = arrColors(iObject)
                '        else
                '            iNextColor1~& = cDarkGray
                '        end if
                '        x1% = iTileSize * (xPos% - 1)
                '        y1% = iTileSize * (yPos% - 1) + iOffset%
                '        x2% = iTileSize * xPos%
                '        y2% = iTileSize * yPos% + iOffset% ' (iTileSize * yPos%) + iOffset%
                '        LINE (x1%, y1%)-(x2%, y2%), iNextColor1~&, BF ' Draw a solid box
                '    NEXT xPos%
                'NEXT yPos%
                '
                '' DRAW PLAYER'S START POSITIONS
                'FOR iPlayerLoop = 1 TO 4
                '    iNextColor1~& = cBlack ' cWhite
                '
                '    xPos% = m_arrPlayer(iPlayerLoop).hx ' = iMaxCols + 3 + 3 + iMaxCols
                '    yPos% = m_arrPlayer(iPlayerLoop).hy ' = iMaxRows + 4 + 3 + iMaxRows
                '
                '    x1% = iTileSize * (xPos% - 1)
                '    y1% = iTileSize * (yPos% - 1) + iOffset%
                '    x2% = iTileSize * xPos%
                '    y2% = iTileSize * yPos% + iOffset% ' (iTileSize * yPos%) + iOffset%
                '
                '    LINE (x1%, y1%)-(x2%, y2%), iNextColor1~&, BF ' Draw a solid box
                'NEXT iPlayerLoop
               
                ' ****************************************************************************************************************************************************************
                ' ****************************************************************************************************************************************************************
                ' ****************************************************************************************************************************************************************
                ' ****************************************************************************************************************************************************************
                ' BEGIN PLAY LOOP #PLAYLOOP
               
                ' RESET VARIABLES TO BLINK FINISH LINE
                iBlinkCount = 50
                iBlinkColor = arrPalette(1)
               
                ' INITIALIZE TIMERS
                sCurrentDateTime = Date$ + " " + Time$
                fRoundStartSeconds = GetUnixTime##(sCurrentDateTime)
                fCurrentSeconds = fRoundStartSeconds
                For iPlayerLoop = 1 To 4
                    m_arrPlayer(iPlayerLoop).StartTime = GetCurrentDateTime$("{mm}/{dd}/{yyyy} {hh}:{nn}:{ss} {ampm}")
                    m_arrPlayer(iPlayerLoop).EndTime = ""
                    m_arrPlayer(iPlayerLoop).StartSeconds = fRoundStartSeconds
                    m_arrPlayer(iPlayerLoop).TotalSeconds = 0
                Next iPlayerLoop
               
                ' MAIN PLAY LOOP
                Do
                   
                    ' =============================================================================
                    ' RENDER EACH WINDOW
                    ' iWorldRows=128, iWorldCols=128
                    For iPlayerLoop = 1 To 4
                       
                        ' RENDER PLAYER WINDOW IN THE SELECTED DISPLAY STYLE (SCROLLING OR FLIP SCREEN)
                        If m_arrPlayer(iPlayerLoop).ScreenMovement = cScrolling Then
                            ' With the scrolling display,
                            ' the player is usually stationary in the middle of the display window,
                            ' except when they reach the edges of the world,
                            ' where there is no more terrain to scroll into view.
                            ' In that case, the screen stops scrolling in the given direction,
                            ' and the player instead moves.
                           
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' BEGIN DRAW TERRAIN - SCROLLING
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------

                            iStartY = m_arrPlayer(iPlayerLoop).y - 7
                            If iStartY < 1 Then
                                iStartY = 1
                            ElseIf iStartY > 113 Then
                                iStartY = 113
                            End If
                            iEndY = iStartY + 15

                            iStartX = m_arrPlayer(iPlayerLoop).x - 7
                            If iStartX < 1 Then
                                iStartX = 1
                            ElseIf iStartX > 113 Then
                                iStartX = 113
                            End If
                            iEndX = iStartX + 15

                            For yPos% = iStartY To iEndY
                                For xPos% = iStartX To iEndX
                                    ' Reset done player flag
                                    iDonePlayer = 0
                                   
                                    ' Look at next tile
                                    'iObject = arrWorld(yPos%, xPos%, cGraphicType)
                                    iObject = arrWorld(yPos%, xPos%, cTerrainType)
                                   
                                    ' Is tile a recognized value?
                                    'If (iObject > -1 And iObject < 9) Or (iObject >= 25) Then ' was > 25
                                    If (iObject = iWall) Or (iObject = iFinish) Or (iObject = iEmpty) Then
                                        ' Is tile empty?
                                        If iObject = iEmpty Then
                                           
                                            ' Is there a player on this square?
                                            If arrWorld(yPos%, xPos%, cPlayersType) <> iEmpty Then
                                               
                                                ' -----------------------------------------------------------------------------
                                                ' DRAW OTHER PLAYERS
                                                For iOtherLoop = 1 To 4
                                                    If iOtherLoop <> iPlayerLoop Then
                                                        If (arrWorld(yPos%, xPos%, cPlayersType) And m_arrPlayer(iOtherLoop).bit) = m_arrPlayer(iOtherLoop).bit Then
                                                           
                                                            ' IF THIS PLAYER FINISHED, DON'T DRAW THEM SOLID
                                                            If m_arrPlayer(iOtherLoop).IsDone = TRUE Then
                                                                iDonePlayer = iOtherLoop
                                                            End If
                                                           
                                                            ' GET PLAYER'S COLOR
                                                            'iNextColor1~& = arrColors(iOtherLoop + 16)
                                                            'iNextColor1~& = arrPalette(arrGameColorMap(iOtherLoop, 0))
                                                            iNextColor1~& = m_arrPlayer(iOtherLoop).color
                                                            Exit For
                                                        End If
                                                    End If
                                                Next iOtherLoop
                                            Else
                                                ' Draw empty (background)
                                                'iNextColor1~& = arrColors(0) ' cDarkGray
                                                iNextColor1~& = arrPalette(arrGameColorMap(0, 0))
                                            End If
                                        Else
                                            ' Is it exit?
                                            'if iObject = 26 then
                                            If iObject = iFinish Then
                                                ' Draw blinking finish line
                                                iNextColor1~& = iBlinkColor
                                            Else
                                                ' #TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN
                                                ' Draw terrain
                                                iNextColor1~& = arrPalette(arrWorld(yPos%, xPos%, cGraphicType))
                                                'OLD SINGLE COLOR: iNextColor1~& = arrColors(iObject)
                                            End If
                                        End If
                                    Else
                                        ' Not recognized, just draw background
                                        'iNextColor1~& = arrColors(0) ' cDarkGray
                                        iNextColor1~& = arrPalette(arrGameColorMap(0, 0))
                                    End If

                                    ' Plot the actual tile
                                    x1% = iTileSize * (xPos% - iStartX) + arrOffsetX(iPlayerLoop)
                                    y1% = iTileSize * (yPos% - iStartY) + arrOffsetY(iPlayerLoop)
                                   
                                    x2% = x1% + (iTileSize - 1)
                                    y2% = y1% + (iTileSize - 1)
                                   
                                    ' DRAW WALLS AND PLAYERS NOT YET FINISHED AS A SOLID BOX
                                    ' AND PLAYERS THAT FINISHED AS AN OUTLINE
                                    If iDonePlayer = 0 Then
                                        Line (x1%, y1%)-(x2%, y2%), iNextColor1~&, BF ' Draw a solid box
                                    Else
                                        Line (x1%, y1%)-(x2%, y2%), iNextColor1~&, B ' Draw a box outline
                                        'Line (x1% + 1, y1% + 1)-(x2% - 1, y2% - 1), arrColors(0), BF ' Fill in with cDarkGray
                                        Line (x1% + 1, y1% + 1)-(x2% - 1, y2% - 1), arrPalette(arrGameColorMap(0, 0)), BF ' Fill in with cDarkGray
                                    End If

                                Next xPos%
                            Next yPos%

                            ' -----------------------------------------------------------------------------
                            ' DRAW PLAYER - SCROLLING
                           
                            If m_arrPlayer(iPlayerLoop).y > 7 Then
                                'IF m_arrPlayer(iPlayerLoop).y < 92 THEN
                                If m_arrPlayer(iPlayerLoop).y < 121 Then
                                    yPos% = 8
                                Else
                                    'yPos% = m_arrPlayer(iPlayerLoop).y - 83
                                    yPos% = m_arrPlayer(iPlayerLoop).y - 112
                                End If
                            Else
                                yPos% = m_arrPlayer(iPlayerLoop).y
                            End If

                            If m_arrPlayer(iPlayerLoop).x > 7 Then
                                'IF m_arrPlayer(iPlayerLoop).x < 92 THEN
                                If m_arrPlayer(iPlayerLoop).x < 121 Then
                                    xPos% = 8
                                Else
                                    'xPos% = m_arrPlayer(iPlayerLoop).x - 83
                                    xPos% = m_arrPlayer(iPlayerLoop).x - 112
                                End If
                            Else
                                xPos% = m_arrPlayer(iPlayerLoop).x
                            End If

                            x1% = iTileSize * (xPos% - 1) + arrOffsetX(iPlayerLoop)
                            y1% = iTileSize * (yPos% - 1) + arrOffsetY(iPlayerLoop)
                            x2% = x1% + (iTileSize - 1)
                            y2% = y1% + (iTileSize - 1)

                            'iNextColor1~& = arrColors(iPlayerLoop + 16)
                            'iNextColor1~& = arrPalette(arrGameColorMap(iPlayerLoop, 0))
                            iNextColor1~& = m_arrPlayer(iPlayerLoop).color
                           
                            ' DRAW PLAYER AS A SOLID BOX IF NOT YET FINISHED
                            ' ELSE DRAW AS AN OUTLINE
                            If m_arrPlayer(iPlayerLoop).IsDone = FALSE Then
                                Line (x1%, y1%)-(x2%, y2%), iNextColor1~&, BF ' Draw a solid box
                            Else
                                Line (x1%, y1%)-(x2%, y2%), iNextColor1~&, B ' Draw a box outline
                                'Line (x1% + 1, y1% + 1)-(x2% - 1, y2% - 1), arrColors(0), BF ' Fill in with cDarkGray
                                Line (x1% + 1, y1% + 1)-(x2% - 1, y2% - 1), arrPalette(arrGameColorMap(0, 0)), BF ' Fill in with cDarkGray
                            End If
                           
                            '' -----------------------------------------------------------------------------
                            '' DRAW OTHER PLAYERS - SCROLLING
                            'FOR iOtherLoop = 1 TO 4
                            '   if iOtherLoop <> iPlayerLoop then
                            '       if m_arrPlayer(iOtherLoop).x >= iStartX then
                            '           if m_arrPlayer(iOtherLoop).x <= iEndX then
                            '               if m_arrPlayer(iOtherLoop).y >= iStartY then
                            '                   if m_arrPlayer(iOtherLoop).y <= iEndY then
                            '                   end if
                            '               end if
                            '           end if
                            '       end if
                            '   end if
                            'NEXT iOtherLoop

                            ' -----------------------------------------------------------------------------
                            ' DRAW OBJECT(S) - SCROLLING
                            ' (TBD)
                           
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' END DRAW TERRAIN - SCROLLING
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                        ElseIf m_arrPlayer(iPlayerLoop).ScreenMovement = cFlipScreen Then
                            ' With the flip screen display,
                            ' the terrain stays stationary,
                            ' and the player moves around the display window.
                            ' When they move past the edge of the screen,
                            ' a new screen appears, showing the next block of 16x16 tiles.
                            ' Since the world is 99x99 tiles, which doesn't divide evenly into 16,
                            ' we should make the world divide evenly, so we will expand it to 128x128.
                           
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' BEGIN DRAW TERRAIN - FLIP SCREEN
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                           
                            ' FIND WHAT SCREEN USER IS ON, USING INTEGER DIVISION:
                            ' div: int1% = num1% \ den1%
                            ' mod: rem1% = num1% MOD den1%
                           
                            iStartY = (m_arrPlayer(iPlayerLoop).y \ iTileSize) * iTileSize
                            iEndY = iStartY + 15
                           
                            iStartX = (m_arrPlayer(iPlayerLoop).x \ iTileSize) * iTileSize
                            iEndX = iStartX + 15
                           
                            For yPos% = iStartY To iEndY
                                For xPos% = iStartX To iEndX
                                    ' Reset done player flag
                                    iDonePlayer = 0
                                   
                                    ' Look at next tile
                                    'iObject = arrWorld(yPos%, xPos%, cGraphicType)
                                    iObject = arrWorld(yPos%, xPos%, cTerrainType)
                                   
                                    ' Is tile a recognized value?
                                    'If (iObject > -1 And iObject < 9) Or (iObject >= 25) Then ' was =25
                                    If (iObject = iWall) Or (iObject = iFinish) Or (iObject = iEmpty) Then
                                        ' Is tile empty?
                                        If iObject = iEmpty Then
                                           
                                            ' Is there a player on this square?
                                            If arrWorld(yPos%, xPos%, cPlayersType) <> iEmpty Then
                                                ' Is it a different player than current?
                                                'IF arrWorld(yPos%, xPos%, cPlayersType) <> iPlayerLoop THEN
                                                '   ' Draw the other player
                                                '   iNextColor1~& = arrColors(arrWorld(yPos%, xPos%, cPlayersType) + 16)
                                                'END IF
                                               
                                                ' -----------------------------------------------------------------------------
                                                ' DRAW OTHER PLAYERS
                                                For iOtherLoop = 1 To 4
                                                    If iOtherLoop <> iPlayerLoop Then
                                                        If (arrWorld(yPos%, xPos%, cPlayersType) And m_arrPlayer(iOtherLoop).bit) = m_arrPlayer(iOtherLoop).bit Then
                                                            ' IF THIS PLAYER FINISHED, DON'T DRAW THEM SOLID
                                                            If m_arrPlayer(iOtherLoop).IsDone = TRUE Then
                                                                iDonePlayer = iOtherLoop
                                                            End If

                                                            ' GET PLAYER'S COLOR
                                                            'iNextColor1~& = arrColors(iOtherLoop + 16)
                                                            'iNextColor1~& = arrPalette(arrGameColorMap(iOtherLoop, 0))
                                                            iNextColor1~& = m_arrPlayer(iOtherLoop).color
                                                            Exit For
                                                        End If
                                                    End If
                                                Next iOtherLoop
                                               
                                            Else
                                                ' Draw empty (background)
                                                'iNextColor1~& = arrColors(0) ' cDarkGray
                                                iNextColor1~& = arrPalette(arrGameColorMap(0, 0))
                                            End If
                                        Else
                                            ' Is it exit?
                                            'if iObject = 26 then
                                            If iObject = iFinish Then
                                                ' Draw blinking finish line
                                                iNextColor1~& = iBlinkColor
                                            Else
                                                ' #TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN TERRAIN
                                                ' Draw terrain
                                                iNextColor1~& = arrPalette(arrWorld(yPos%, xPos%, cGraphicType))
                                                'OLD SINGLE COLOR: iNextColor1~& = arrColors(iObject)
                                            End If
                                        End If
                                    Else
                                        ' Not recognized, just draw background
                                        'iNextColor1~& = arrColors(0) ' cDarkGray
                                        iNextColor1~& = arrPalette(arrGameColorMap(0, 0))
                                    End If
                                   
                                    ' Plot the actual tile
                                    x1% = iTileSize * (xPos% - iStartX) + arrOffsetX(iPlayerLoop)
                                    y1% = iTileSize * (yPos% - iStartY) + arrOffsetY(iPlayerLoop)
                                   
                                    x2% = x1% + (iTileSize - 1)
                                    y2% = y1% + (iTileSize - 1)
                                   
                                    ' DRAW WALLS AND PLAYERS NOT YET FINISHED AS A SOLID BOX
                                    ' AND PLAYERS THAT FINISHED AS AN OUTLINE
                                    If iDonePlayer = 0 Then
                                        Line (x1%, y1%)-(x2%, y2%), iNextColor1~&, BF ' Draw a solid box
                                    Else
                                        Line (x1%, y1%)-(x2%, y2%), iNextColor1~&, B ' Draw a box outline
                                        'Line (x1% + 1, y1% + 1)-(x2% - 1, y2% - 1), arrColors(0), BF ' Fill in with cDarkGray
                                        Line (x1% + 1, y1% + 1)-(x2% - 1, y2% - 1), arrPalette(arrGameColorMap(0, 0)), BF ' Fill in with cDarkGray
                                    End If
                                   
                                Next xPos%
                            Next yPos%
                           
                            ' -----------------------------------------------------------------------------
                            ' DRAW PLAYER - FLIP SCREEN
                            ' FIND WHERE ON SCREEN TO DRAW PLAYER, USING REMAINDER / MODULO
                            ' mod: rem1% = num1% MOD den1%
                           
                            'iOffsetY =
                            yPos% = (m_arrPlayer(iPlayerLoop).y Mod iTileSize) + 1
                           
                            'iOffsetX =
                            xPos% = (m_arrPlayer(iPlayerLoop).x Mod iTileSize) + 1
                           
                            x1% = iTileSize * (xPos% - 1) + arrOffsetX(iPlayerLoop)
                            y1% = iTileSize * (yPos% - 1) + arrOffsetY(iPlayerLoop)
                            x2% = x1% + (iTileSize - 1)
                            y2% = y1% + (iTileSize - 1)
                           
                            'iNextColor1~& = arrColors(iPlayerLoop + 16)
                            'iNextColor1~& = arrPalette(arrGameColorMap(iPlayerLoop, 0))
                            iNextColor1~& = m_arrPlayer(iPlayerLoop).color
                           
                            ' DRAW PLAYER AS A SOLID BOX IF NOT YET FINISHED
                            ' ELSE DRAW AS AN OUTLINE
                            If m_arrPlayer(iPlayerLoop).IsDone = FALSE Then
                                Line (x1%, y1%)-(x2%, y2%), iNextColor1~&, BF ' Draw a solid box
                            Else
                                Line (x1%, y1%)-(x2%, y2%), iNextColor1~&, B ' Draw a box outline
                                'Line (x1% + 1, y1% + 1)-(x2% - 1, y2% - 1), arrColors(0), BF ' Fill in with cDarkGray
                                Line (x1% + 1, y1% + 1)-(x2% - 1, y2% - 1), arrPalette(arrGameColorMap(0, 0)), BF ' Fill in with cDarkGray
                            End If
                           
                            '' -----------------------------------------------------------------------------
                            '' DRAW OTHER PLAYERS - FLIP SCREEN
                            ' (TBD)
                            'FOR iOtherLoop = 1 TO 4
                            '   if iOtherLoop <> iPlayerLoop then
                            '       if m_arrPlayer(iOtherLoop).x >= iStartX then
                            '           if m_arrPlayer(iOtherLoop).x <= iEndX then
                            '               if m_arrPlayer(iOtherLoop).y >= iStartY then
                            '                   if m_arrPlayer(iOtherLoop).y <= iEndY then
                            '                   end if
                            '               end if
                            '           end if
                            '       end if
                            '   end if
                            'NEXT iOtherLoop
                           
                            ' -----------------------------------------------------------------------------
                            ' DRAW OBJECT(S) - FLIP SCREEN
                            ' (TBD)
                           
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' END DRAW TERRAIN - FLIP SCREEN
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                            ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                           
                        End If
                       
                        ' (OLD DRAW BORDERS AROUND WINDOW)
                       
                    Next iPlayerLoop
                   
                   
                   
                   
                   
                    ' BLINK EXITS ONCE A SECOND
                    ' ALSO UPDATE PLAYER'S TIMERS, ETC.
                    iBlinkCount = iBlinkCount + 1
                    If iBlinkCount > 50 Then
                        If iBlinkColor = arrPalette(46) Then
                            iBlinkColor = arrPalette(1)
                        Else
                            iBlinkColor = arrPalette(46)
                        End If
                       
                        ' GET ELAPSED SECONDS
                        sCurrentDateTime = Date$ + " " + Time$
                        fCurrentSeconds = GetUnixTime##(sCurrentDateTime)
                        'TODO: if maximum hours elapses, quit!
                       
                        ' -----------------------------------------------------------------------------
                        ' DISPLAY ROUND #
                        Color cWhite, cBlack
                        _PrintString (iRoundX, iRoundY), sRound
                       
                        ' -----------------------------------------------------------------------------
                        ' DISPLAY PLAYER'S NAME, SCORE, ETC.
                        For iPlayerLoop = 1 To 4
                            ' -----------------------------------------------------------------------------
                            ' DRAW BORDERS AROUND WINDOW

                            ' TOP
                            x1% = arrOffsetX(iPlayerLoop) - iTileSize
                            y1% = arrOffsetY(iPlayerLoop) - iTileSize
                            x2% = x1% + (iTileSize * 17)
                            y2% = y1% + iTileSize
                            Line (x1%, y1%)-(x2%, y2%), cGray, BF ' Draw a solid box

                            ' BOTTOM
                            x1% = arrOffsetX(iPlayerLoop) - iTileSize
                            y1% = arrOffsetY(iPlayerLoop) + (iTileSize * 16)
                            x2% = x1% + (iTileSize * 18)
                            y2% = y1% + iTileSize
                            Line (x1%, y1%)-(x2%, y2%), cGray, BF ' Draw a solid box

                            ' LEFT
                            x1% = arrOffsetX(iPlayerLoop) - iTileSize
                            y1% = arrOffsetY(iPlayerLoop) - iTileSize
                            x2% = x1% + iTileSize
                            y2% = y1% + (iTileSize * 17)
                            Line (x1%, y1%)-(x2%, y2%), cGray, BF ' Draw a solid box

                            ' RIGHT
                            x1% = arrOffsetX(iPlayerLoop) + (iTileSize * 16)
                            y1% = arrOffsetY(iPlayerLoop) - iTileSize
                            x2% = x1% + iTileSize
                            y2% = y1% + (iTileSize * 18)
                            Line (x1%, y1%)-(x2%, y2%), cGray, BF ' Draw a solid box
                           
                            ' SET PLAYER'S TEXT COLOR
                            iNextColor1~& = m_arrPlayer(iPlayerLoop).TextColor1
                            Color iNextColor1~&, cGray
                           
                            ' DISPLAY NAME
                            x1% = arrOffsetX(iPlayerLoop)
                            y1% = arrOffsetY(iPlayerLoop) - iTileSize
                            _PrintString (x1%, y1%), m_arrPlayer(iPlayerLoop).name
                           
                            ' DISPLAY SCORE
                            x1% = arrOffsetX(iPlayerLoop)
                            y1% = arrOffsetY(iPlayerLoop) + (iTileSize * 16)
                            _PrintString (x1%, y1%), "SCORE:" + cstr$(m_arrPlayer(iPlayerLoop).score)
                           
                            ' DISPLAY SPEED
                            x1% = arrOffsetX(iPlayerLoop) + (iTileSize * 12) + (iTileSize / 2)
                            y1% = arrOffsetY(iPlayerLoop) - iTileSize
                            _PrintString (x1%, y1%), "SPEED:" + cstr$(m_arrPlayer(iPlayerLoop).speed)
                           
                            ' DISPLAY TIME
                            x1% = arrOffsetX(iPlayerLoop) + (iTileSize * 8)
                            y1% = arrOffsetY(iPlayerLoop) + (iTileSize * 16)
                            If m_arrPlayer(iPlayerLoop).IsDone = FALSE Then
                                ' RE-CALCULATE TIME
                                m_arrPlayer(iPlayerLoop).TotalSeconds = fCurrentSeconds - fRoundStartSeconds
                               
                                ' DISPLAY TIME
                                _PrintString (x1%, y1%), "     TIME:" + _
                                    _Trim$(Str$(m_arrPlayer(iPlayerLoop).TotalSeconds))
                            Else
                                If m_arrPlayer(iPlayerLoop).GaveUp = FALSE Then
                                    ' DISPLAY FINAL TIME
                                    _PrintString (x1%, y1%), "FINAL TIME:" + _
                                        _Trim$(Str$(m_arrPlayer(iPlayerLoop).TotalSeconds))
                                Else
                                    ' DISPLAY FINAL TIME
                                    _PrintString (x1%, y1%), "FINAL TIME:NONE"
                                End If
                               
                                ' SHOW PLACE
                                x1% = arrOffsetX(iPlayerLoop) + (iTileSize * 6)
                                y1% = arrOffsetY(iPlayerLoop) - (iTileSize * 2)
                                Color cWhite, cBlack
                                _PrintString (x1%, y1%), m_arrPlayer(iPlayerLoop).PlaceText
                            End If
                           
                        Next iPlayerLoop

                        ' START COUNTING AGAIN
                        iBlinkCount = 0
                    End If
                   
                   
                   
                   
                   
                    ' -----------------------------------------------------------------------------
                    ' update screen with changes
                    _Display
                   
                   
                    ' =============================================================================
                    ' =============================================================================
                    ' =============================================================================
                    ' BEGIN GET INPUT AND MOVE PLAYERS #GetInput
                    ' =============================================================================
                    ' =============================================================================
                    ' =============================================================================

                    While _DeviceInput(1): Wend ' clear and update the keyboard buffer

                    ' Key                     _BUTTON       Action           Constant
                    ' ---------------------   -----------   --------         -------
                    ' A                       31            left  player 1   c_bKey_A
                    ' S                       32            right player 1   c_bKey_S
                    ' W                       18            up    player 1   c_bKey_W
                    ' Z                       45            down  player 1   c_bKey_Z
                    ' Left Ctrl               30            fire  player 1   c_bKey_LeftCtrl

                    ' J                       37            left  player 2   c_bKey_J
                    ' K                       38            right player 2   c_bKey_K
                    ' I                       24            up    player 4   c_bKey_I
                    ' M                       51            down  player 4   c_bKey_M
                    ' SPACE                   58            fire  player 4   c_bKey_Space

                    ' Left                    332           left  player 3   c_bKey_CrsrLeft
                    ' Right                   334           right player 3   c_bKey_CrsrRight
                    ' Up                      329           up    player 3   c_bKey_CrsrUp
                    ' Down                    337           down  player 3   c_bKey_CrsrDown
                    ' Right Ctrl              286           fire  player 3   c_bKey_RightCtrl

                    ' KEYPAD 4 Left           76            left  player 4   c_bKey_Kpad4
                    ' KEYPAD 6 Right          78            right player 4   c_bKey_Kpad6
                    ' KEYPAD 8 Up             73            up    player 4   c_bKey_Kpad8
                    ' KEYPAD 2 Down           81            down  player 4   c_bKey_Kpad2
                    ' KEYPAD 0 Ins            83            fire  player 4   c_bKey_Kpad0

                    For iPlayerLoop = 1 To 4
                        ' introduces a delay to slow player down
                        m_arrPlayer(iPlayerLoop).delay = m_arrPlayer(iPlayerLoop).delay - 1
                       
                        ' SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
                        ' BEGIN SPEED #SPEED
                        ' SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
                        ' the faster the speed the shorter the delay
                        If m_arrPlayer(iPlayerLoop).delay <= m_arrPlayer(iPlayerLoop).speed Then
                            ' reset the delay for next time
                            m_arrPlayer(iPlayerLoop).delay = cMaxSpeed
                           
                           
                            ' BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
                            ' HANDLE BUTTON #Button
                            ' BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
                            If _Button(arrKeyMap(iPlayerLoop, c_Map_Button)) Then ' BUTTON KEY IS CURRENTLY DOWN
                                'arrKeyState(arrKeyMap(iPlayerLoop, c_Map_Button)) = TRUE ' if we want to track state
                                '(player button action)
                                Sound arrSound(iPlayerLoop), .75
                            End If
                           
                            ' MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                            ' BEGIN HANDLE MOVEMENT #Movement
                            ' MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                            bFinishFlag = FALSE
                            bGaveUp = FALSE
                            If _Button(arrKeyMap(iPlayerLoop, c_Map_Left)) Then ' LEFT KEY IS CURRENTLY DOWN
                                'arrKeyState(arrKeyMap(iPlayerLoop, c_Map_Left)) = TRUE ' if we want to track state
                                If m_arrPlayer(iPlayerLoop).x > 1 Then
                                   
                                    ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    ' MOVE INTO AN EMPTY SPACE
                                    ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    If arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x - 1, cTerrainType) = iEmpty Then
                                        ' erase player from map
                                        If (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) And m_arrPlayer(iPlayerLoop).bit) = m_arrPlayer(iPlayerLoop).bit Then
                                            arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) - m_arrPlayer(iPlayerLoop).bit
                                        End If
                                        'arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = iEmpty

                                        ' (move player left)
                                        m_arrPlayer(iPlayerLoop).x = m_arrPlayer(iPlayerLoop).x - 1

                                        ' redraw player on map
                                        'arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = iPlayerLoop
                                        arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) Or m_arrPlayer(iPlayerLoop).bit)

                                        ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                        ' MOVE TO FINISH LINE
                                        ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    ElseIf arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x - 1, cTerrainType) = iFinish Then
                                        bFinishFlag = TRUE
                                    End If
                                End If
                               
                            ElseIf _Button(arrKeyMap(iPlayerLoop, c_Map_Right)) Then ' RIGHT KEY IS CURRENTLY DOWN
                                'arrKeyState(arrKeyMap(iPlayerLoop, c_Map_Right)) = TRUE ' if we want to track state
                                If m_arrPlayer(iPlayerLoop).x < 128 Then
                                   
                                    ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    ' MOVE INTO AN EMPTY SPACE
                                    ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    If arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x + 1, cTerrainType) = iEmpty Then
                                        ' erase player from map
                                        If (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) And m_arrPlayer(iPlayerLoop).bit) = m_arrPlayer(iPlayerLoop).bit Then
                                            arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) - m_arrPlayer(iPlayerLoop).bit
                                        End If
                                        'arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = iEmpty

                                        ' (move player right)
                                        m_arrPlayer(iPlayerLoop).x = m_arrPlayer(iPlayerLoop).x + 1

                                        ' redraw player on map
                                        'arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = iPlayerLoop
                                        arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) Or m_arrPlayer(iPlayerLoop).bit)
                                       
                                        ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                        ' MOVE TO FINISH LINE
                                        ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    ElseIf arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x + 1, cTerrainType) = iFinish Then
                                        bFinishFlag = TRUE
                                    End If
                                End If
                            End If
                           
                            If _Button(arrKeyMap(iPlayerLoop, c_Map_Up)) Then ' UP KEY IS CURRENTLY DOWN
                                'arrKeyState(arrKeyMap(iPlayerLoop, c_Map_Up)) = TRUE ' if we want to track state
                                If m_arrPlayer(iPlayerLoop).y > 1 Then
                                   
                                    ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    ' MOVE INTO AN EMPTY SPACE
                                    ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    If arrWorld(m_arrPlayer(iPlayerLoop).y - 1, m_arrPlayer(iPlayerLoop).x, cTerrainType) = iEmpty Then
                                        ' erase player from map
                                        If (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) And m_arrPlayer(iPlayerLoop).bit) = m_arrPlayer(iPlayerLoop).bit Then
                                            arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) - m_arrPlayer(iPlayerLoop).bit
                                        End If
                                        'arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = iEmpty

                                        ' (move player up)
                                        m_arrPlayer(iPlayerLoop).y = m_arrPlayer(iPlayerLoop).y - 1

                                        ' redraw player on map
                                        'arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = iPlayerLoop
                                        arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) Or m_arrPlayer(iPlayerLoop).bit)
                                       
                                        ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                        ' MOVE TO FINISH LINE
                                        ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    ElseIf arrWorld(m_arrPlayer(iPlayerLoop).y - 1, m_arrPlayer(iPlayerLoop).x, cTerrainType) = iFinish Then
                                        bFinishFlag = TRUE
                                    End If
                                End If
                            ElseIf _Button(arrKeyMap(iPlayerLoop, c_Map_Down)) Then ' DOWN KEY IS CURRENTLY DOWN
                                'arrKeyState(arrKeyMap(iPlayerLoop, c_Map_Down)) = TRUE ' if we want to track state
                                If m_arrPlayer(iPlayerLoop).y < 128 Then

                                    ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    ' MOVE INTO AN EMPTY SPACE
                                    ' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    If arrWorld(m_arrPlayer(iPlayerLoop).y + 1, m_arrPlayer(iPlayerLoop).x, cTerrainType) = iEmpty Then
                                        ' erase player from map
                                        If (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) And m_arrPlayer(iPlayerLoop).bit) = m_arrPlayer(iPlayerLoop).bit Then
                                            arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) - m_arrPlayer(iPlayerLoop).bit
                                        End If
                                        'arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = iEmpty

                                        ' (move player down)
                                        m_arrPlayer(iPlayerLoop).y = m_arrPlayer(iPlayerLoop).y + 1

                                        ' redraw player on map
                                        'arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = iPlayerLoop
                                        arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) Or m_arrPlayer(iPlayerLoop).bit)
                                       
                                    ElseIf arrWorld(m_arrPlayer(iPlayerLoop).y + 1, m_arrPlayer(iPlayerLoop).x, cTerrainType) = iFinish Then
                                        bFinishFlag = TRUE
                                    End If
                                End If
                            End If
                            ' MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                            ' END HANDLE MOVEMENT @Movement
                            ' MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                           
                            ' BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
                            ' HANDLE QUIT ROUND BUTTON
                            ' BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
                            If _Button(arrKeyMap(iPlayerLoop, c_Map_Quit_Round)) Then ' QUIT ROUND KEY IS CURRENTLY DOWN
                                bGaveUp = TRUE
                            End If
                           
                            ' FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                            ' BEGIN PLAYER REACHED FINISH LINE #FINISH
                            ' FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                            If bFinishFlag = TRUE Or bGaveUp = TRUE Then
                                ' erase player from map
                                If (arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) And m_arrPlayer(iPlayerLoop).bit) = m_arrPlayer(iPlayerLoop).bit Then
                                    arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) = arrWorld(m_arrPlayer(iPlayerLoop).y, m_arrPlayer(iPlayerLoop).x, cPlayersType) - m_arrPlayer(iPlayerLoop).bit
                                End If
                               
                                ' DID PLAYER FINISH ALREADY?
                                If m_arrPlayer(iPlayerLoop).IsDone = FALSE Then
                                    ' SAVE FINAL TIME
                                    m_arrPlayer(iPlayerLoop).EndTime = GetCurrentDateTime$("{mm}/{dd}/{yyyy} {hh}:{nn}:{ss} {ampm}")
                                    sCurrentDateTime = Date$ + " " + Time$
                                    fCurrentSeconds = GetUnixTime##(sCurrentDateTime)
                                   
                                    ' IF PLAYER GAVE UP, SAVE TIME AS NEGATIVE
                                    If bGaveUp = FALSE Then
                                        m_arrPlayer(iPlayerLoop).GaveUp = FALSE
                                        m_arrPlayer(iPlayerLoop).TotalSeconds = fCurrentSeconds - fRoundStartSeconds
                                        m_arrPlayer(iPlayerLoop).Place = 1
                                    Else
                                        m_arrPlayer(iPlayerLoop).GaveUp = TRUE
                                        m_arrPlayer(iPlayerLoop).forfeits = m_arrPlayer(iPlayerLoop).forfeits + 1
                                       
                                        ' TOTAL SECONDS + PLACE WILL BE FIGURED OUT AT END OF ROUND
                                        m_arrPlayer(iPlayerLoop).TotalSeconds = fCurrentSeconds - fRoundStartSeconds
                                        m_arrPlayer(iPlayerLoop).Place = 4
                                    End If
                                   
                                    ' DETERMINE PLACE + IF ROUND IS OVER
                                    bRoundOver = TRUE
                                    ' Only place if we didn't forfeit
                                    If bGaveUp = FALSE Then
                                        For iOtherLoop = 1 To 4
                                            If iOtherLoop <> iPlayerLoop Then
                                                If m_arrPlayer(iOtherLoop).IsDone = TRUE Then
                                                    ' Place after other player if THEY didn't forfeit
                                                    If m_arrPlayer(iOtherLoop).GaveUp = FALSE Then
                                                        m_arrPlayer(iPlayerLoop).Place = m_arrPlayer(iPlayerLoop).Place + 1
                                                    End If
                                                Else
                                                    ' At least one player isn't done, so round not over
                                                    bRoundOver = FALSE
                                                End If
                                            End If
                                        Next iOtherLoop
                                    Else
                                        For iOtherLoop = 1 To 4
                                            If iOtherLoop <> iPlayerLoop Then
                                                If m_arrPlayer(iOtherLoop).IsDone = FALSE Then
                                                    ' At least one player isn't done, so round not over
                                                    bRoundOver = FALSE
                                                End If
                                            End If
                                        Next iOtherLoop
                                    End If
                                   
                                    ' AWARD POINTS, ETC.
                                    If bGaveUp = FALSE Then
                                        ' SAVE PLACE # TEXT
                                        Select Case m_arrPlayer(iPlayerLoop).Place
                                            Case 1:
                                                m_arrPlayer(iPlayerLoop).PlaceText = "1st place"
                                                m_arrPlayer(iPlayerLoop).wins = m_arrPlayer(iPlayerLoop).wins + 1
                                                m_arrPlayer(iPlayerLoop).ConsecWinCount = m_arrPlayer(iPlayerLoop).ConsecWinCount + 1
                                                ' Is this the best winning streak yet?
                                                If m_arrPlayer(iPlayerLoop).ConsecWinCount > m_arrPlayer(iPlayerLoop).ConsecWinMax Then
                                                    m_arrPlayer(iPlayerLoop).ConsecWinMax = m_arrPlayer(iPlayerLoop).ConsecWinCount
                                                End If
                                                m_arrPlayer(iPlayerLoop).ConsecLossCount = 0
                                            Case 2:
                                                m_arrPlayer(iPlayerLoop).PlaceText = "2nd place"
                                                m_arrPlayer(iPlayerLoop).Num2nd = m_arrPlayer(iPlayerLoop).Num2nd + 1
                                                m_arrPlayer(iPlayerLoop).ConsecWinCount = 0
                                                m_arrPlayer(iPlayerLoop).ConsecLossCount = 0
                                            Case 3:
                                                m_arrPlayer(iPlayerLoop).PlaceText = "3rd place"
                                                m_arrPlayer(iPlayerLoop).Num3rd = m_arrPlayer(iPlayerLoop).Num3rd + 1
                                                m_arrPlayer(iPlayerLoop).ConsecWinCount = 0
                                                m_arrPlayer(iPlayerLoop).ConsecLossCount = 0
                                            Case Else:
                                                m_arrPlayer(iPlayerLoop).PlaceText = "Last place"
                                                m_arrPlayer(iPlayerLoop).Num4th = m_arrPlayer(iPlayerLoop).Num4th + 1
                                                m_arrPlayer(iPlayerLoop).ConsecWinCount = 0
                                                m_arrPlayer(iPlayerLoop).ConsecLossCount = m_arrPlayer(iPlayerLoop).ConsecLossCount + 1
                                                ' Is this the worst losing streak yet?
                                                If m_arrPlayer(iPlayerLoop).ConsecLossCount > m_arrPlayer(iPlayerLoop).ConsecLossMax Then
                                                    m_arrPlayer(iPlayerLoop).ConsecLossMax = m_arrPlayer(iPlayerLoop).ConsecLossCount
                                                End If
                                        End Select
                                       
                                        ' AWARD SCORE
                                        ' PLACE   POINTS
                                        ' 1       4
                                        ' 2       3
                                        ' 3       2
                                        ' 4       1
                                        m_arrPlayer(iPlayerLoop).score = m_arrPlayer(iPlayerLoop).score + (5 - m_arrPlayer(iPlayerLoop).Place)

                                    Else
                                        m_arrPlayer(iPlayerLoop).PlaceText = "Gave up!"
                                        m_arrPlayer(iPlayerLoop).ConsecWinCount = 0
                                        m_arrPlayer(iPlayerLoop).ConsecLossCount = 0
                                    End If
                                   
                                    ' FLAG PLAYER AS FINISHED
                                    m_arrPlayer(iPlayerLoop).IsDone = TRUE
                                   
                                End If
                               
                                'TODO: PLAY A LITTLE TUNE?
                               
                                ' FOR NOW JUST MOVE PLAYER BACK TO THEIR START POSITION
                                ' LET THEM MOVE AROUND AS A "GHOST" UNTIL THE END OF THE ROUND
                                m_arrPlayer(iPlayerLoop).x = m_arrPlayer(iPlayerLoop).startx
                                m_arrPlayer(iPlayerLoop).y = m_arrPlayer(iPlayerLoop).starty
                               
                            End If
                            ' FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                            ' END PLAYER REACHED FINISH LINE @FINISH
                            ' FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                           
                            ' BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
                            ' HANDLE QUIT GAME BUTTON
                            ' BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
                            If _Button(arrKeyMap(iPlayerLoop, c_Map_Quit_Game)) Then ' QUIT GAME KEY IS CURRENTLY DOWN
                                bRoundOver = TRUE
                                bGameOver = TRUE
                            End If
                           
                        End If ' If m_arrPlayer(iPlayerLoop).delay <= m_arrPlayer(iPlayerLoop).speed Then
                        ' SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
                        ' END SPEED @SPEED
                        ' SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
                       
                    Next iPlayerLoop
                    ' =============================================================================
                    ' =============================================================================
                    ' =============================================================================
                    ' END GET INPUT AND MOVE PLAYERS @GetInput
                    ' =============================================================================
                    ' =============================================================================
                    ' =============================================================================
                   
                   
                    '' Detect changed key states
                    'arrKeys(c_bKey_CrsrUp) = IIF(_BUTTON(c_bKey_CrsrUp) = 0, FALSE, TRUE)
                    'arrKeys(c_bKey_CrsrDown) = IIF(_BUTTON(c_bKey_CrsrDown) = 0, FALSE, TRUE)
                    'arrKeys(c_bKey_CrsrLeft) = IIF(_BUTTON(c_bKey_CrsrLeft) = 0, FALSE, TRUE)
                    'arrKeys(c_bKey_CrsrRight) = IIF(_BUTTON(c_bKey_CrsrRight) = 0, FALSE, TRUE)
                    'arrKeys(c_bKey_RightCtrl) = IIF(_BUTTON(c_bKey_RightCtrl) = 0, FALSE, TRUE)
                    'arrKeys(c_bKey_Kpad8) = IIF(_BUTTON(c_bKey_Kpad8) = 0, FALSE, TRUE)
                    'arrKeys(c_bKey_Kpad2) = IIF(_BUTTON(c_bKey_Kpad2) = 0, FALSE, TRUE)
                    'arrKeys(c_bKey_Kpad4) = IIF(_BUTTON(c_bKey_Kpad4) = 0, FALSE, TRUE)
                    'arrKeys(c_bKey_Kpad6) = IIF(_BUTTON(c_bKey_Kpad6) = 0, FALSE, TRUE)
                    'arrKeys(c_bKey_Kpad0) = IIF(_BUTTON(c_bKey_Kpad0) = 0, FALSE, TRUE)
                    '
                    '' If the last key pressed is still held down, don't keep printing the code
                    'IF (iLoop <> iLastPressed) THEN
                    '   IF iCode <> 0 THEN
                    '       CLS
                    '       PRINT "Press a key to see what _BUTTON code is detetected."
                    '       PRINT
                    '       PRINT "Detected key press with _BUTTON(" + STR$(iLoop) + ") = " + STR$(iCode)
                    '       PRINT
                    '       PRINT "(Press <ESC> to exit)."
                    '       iLastPressed = iLoop
                    '   END IF
                    'ELSE
                    '   ' If last key is released, clear the code so it can be pressed again:
                    '   IF iCode = 0 THEN
                    '       iLastPressed = -1
                    '   END IF
                    'END IF
                   
                   
                   
                   
                    ' HANDLE END OF ROUND
                    If bRoundOver = TRUE Then
                        ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                        ' BEGIN DETERMINE TIME + PLACES FOR PLAYERS WHO QUIT
                        ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                        ' Look at this mess!
                        ' This is why we are Softintheheadware! ;-p
                       
                        ' PLAYERS WHO GAVE UP SOONER GET RANKED LOWER
                       
                        ' FIRST FIGURE OUT TIME FOR PLAYERS WHO QUIT
                        ' LOGIC FOR ADJUSTING TIME:
                        ' quitTime = time player quit = from m_arrPlayer(iPlayerLoop).TotalSeconds
                        ' totalTime = final time at end of round = from (fCurrentSeconds - fRoundStartSeconds)
                        ' quitTime2 = totalTime - quitTime = saved in fAdjustedSeconds
                        ' finalTime = totalTime + quitTime2 = save to m_arrPlayer(iPlayerLoop).TotalSeconds
                        ' example:
                        ' who   quitTime   totalTime   quitTime2  finalTime
                        ' a     10         50          40         90
                        ' b     20         50          30         80
                        For iPlayerLoop = 1 To 4
                            If m_arrPlayer(iPlayerLoop).GaveUp = TRUE Then
                                fAdjustedSeconds = (fCurrentSeconds - fRoundStartSeconds) - m_arrPlayer(iPlayerLoop).TotalSeconds
                                m_arrPlayer(iPlayerLoop).TotalSeconds = (fCurrentSeconds - fRoundStartSeconds) + fAdjustedSeconds
                            End If
                        Next iPlayerLoop
                       
                        ' FIND NEXT AVAILABLE PLACE
                        iNextPlace = 0
                        For iPlayerLoop = 1 To 4
                            If m_arrPlayer(iPlayerLoop).GaveUp = FALSE Then
                                If m_arrPlayer(iPlayerLoop).Place > iNextPlace Then
                                    iNextPlace = m_arrPlayer(iPlayerLoop).Place
                                End If
                            End If
                        Next iPlayerLoop
                       
                        ' INITALLY PLACE ALL PLAYERS WHO QUIT AFTER LAST PLAYER WHO FINISHED
                        For iPlayerLoop = 1 To 4
                            If m_arrPlayer(iPlayerLoop).GaveUp = TRUE Then
                                m_arrPlayer(iPlayerLoop).Place = iNextPlace + 1
                            End If
                        Next iPlayerLoop
                       
                        ' NOW ORDER THE PLAYERS WHO QUIT
                        For iPlayerLoop = 1 To 4
                            ' WHO QUIT
                            If m_arrPlayer(iPlayerLoop).GaveUp = TRUE Then
                                ' LOOK AT OTHERS
                                For iOtherLoop = 1 To 4
                                    ' OTHERS
                                    If iOtherLoop <> iPlayerLoop Then
                                        ' WHO QUIT
                                        If m_arrPlayer(iOtherLoop).GaveUp = TRUE Then
                                            ' ARE THEY AHEAD?
                                            If m_arrPlayer(iOtherLoop).TotalSeconds < m_arrPlayer(iPlayerLoop).TotalSeconds Then
                                                ' MOVE US DOWN ONE
                                                m_arrPlayer(iPlayerLoop).Place = m_arrPlayer(iPlayerLoop).Place + 1
                                            End If
                                        End If
                                    End If
                                Next iOtherLoop
                            End If
                        Next iPlayerLoop
                        ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                        ' END DETERMINE TIME + PLACES FOR PLAYERS WHO QUIT
                        ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                       
                       
                        ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                        ' ADD FINAL TIME TO EACH PLAYERS' GRAND TOTAL
                        For iPlayerLoop = 1 To 4
                            m_arrPlayer(iPlayerLoop).GameTime = m_arrPlayer(iPlayerLoop).GameTime + m_arrPlayer(iPlayerLoop).TotalSeconds
                        Next iPlayerLoop
                       
                        ' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                        ' EXIT
                        Exit Do
                    End If
                   
                    _Limit 100 ' keep loop at 100 frames per second
                Loop
                'Loop Until _KeyDown(27) ' leave loop when ESC key pressed
               
                ' END PLAY LOOP @PLAYLOOP
                ' ****************************************************************************************************************************************************************
                ' ****************************************************************************************************************************************************************
                ' ****************************************************************************************************************************************************************
                ' ****************************************************************************************************************************************************************
               
            End If
           
            ' EXIT IF ERRORS
            If Len(sError) > 0 Then bRoundOver = TRUE
           
        Loop Until bRoundOver
        ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ' END A SINGLE ROUND @ROUND
        ' ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND
        ' ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND
        ' ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND ROUND
        ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        ' ================================================================================================================================================================
        ' BEGIN RANK PLAYERS OVERALL #OVERALL
        ' ================================================================================================================================================================
        ' And look at this mess!
        ' THIS is why we are Softintheheadware! ;-p
        ' Q: how do we rank tied players?
        ' Measures where more is better:
        ' * score
        ' * wins
        ' * ConsecWinMax
        ' Measures where less is better:
        ' * GameTime
        ' * forfeits
        ' * ConsecLossMax
        ' Measures where we're not exactly sure:
        ' * Num2nd
        ' * Num3rd
        ' * Num4th
       
        ' RESET POINTS
        For iPlayerLoop = 1 To 4
            m_arrPlayer(iPlayerLoop).RankScore = 0
            m_arrPlayer(iPlayerLoop).OverallPlace = 1
            m_arrPlayer(iPlayerLoop).OverallPlaceText = "TBD"
        Next iPlayerLoop
       
        ' COUNT UP POINTS
        For iPlayerLoop = 1 To 4
            For iOtherLoop = 1 To 4
                If iOtherLoop <> iPlayerLoop Then
                    If m_arrPlayer(iPlayerLoop).score > m_arrPlayer(iOtherLoop).score Then
                        m_arrPlayer(iPlayerLoop).RankScore = m_arrPlayer(iPlayerLoop).RankScore + 1
                    End If
                    If m_arrPlayer(iPlayerLoop).wins > m_arrPlayer(iOtherLoop).wins Then
                        m_arrPlayer(iPlayerLoop).RankScore = m_arrPlayer(iPlayerLoop).RankScore + 1
                    End If
                    If m_arrPlayer(iPlayerLoop).ConsecWinMax > m_arrPlayer(iOtherLoop).ConsecWinMax Then
                        m_arrPlayer(iPlayerLoop).RankScore = m_arrPlayer(iPlayerLoop).RankScore + 1
                    End If

                    If m_arrPlayer(iPlayerLoop).GameTime < m_arrPlayer(iOtherLoop).GameTime Then
                        m_arrPlayer(iPlayerLoop).RankScore = m_arrPlayer(iPlayerLoop).RankScore + 1
                    End If
                    If m_arrPlayer(iPlayerLoop).forfeits < m_arrPlayer(iOtherLoop).forfeits Then
                        m_arrPlayer(iPlayerLoop).RankScore = m_arrPlayer(iPlayerLoop).RankScore + 1
                    End If
                    If m_arrPlayer(iPlayerLoop).ConsecLossMax < m_arrPlayer(iOtherLoop).ConsecLossMax Then
                        m_arrPlayer(iPlayerLoop).RankScore = m_arrPlayer(iPlayerLoop).RankScore + 1
                    End If
                End If
            Next iOtherLoop
        Next iPlayerLoop
       
        ' RANK 'EM
        For iPlayerLoop = 1 To 4
            For iOtherLoop = 1 To 4
                If iOtherLoop <> iPlayerLoop Then
                    If m_arrPlayer(iPlayerLoop).RankScore < m_arrPlayer(iOtherLoop).RankScore Then
                        m_arrPlayer(iPlayerLoop).OverallPlace = m_arrPlayer(iPlayerLoop).OverallPlace + 1
                    End If
                End If
            Next iOtherLoop
        Next iPlayerLoop
        For iPlayerLoop = 1 To 4
            Select Case m_arrPlayer(iPlayerLoop).OverallPlace
                Case 1:
                    m_arrPlayer(iPlayerLoop).OverallPlaceText = "1st place"
                Case 2:
                    m_arrPlayer(iPlayerLoop).OverallPlaceText = "2nd place"
                Case 3:
                    m_arrPlayer(iPlayerLoop).OverallPlaceText = "3rd place"
                Case Else:
                    m_arrPlayer(iPlayerLoop).OverallPlaceText = "Last place"
            End Select
        Next iPlayerLoop
       
        '' ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        '' BEGIN TEST RANKING #RANKTEST
        '' ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        '' DOES ALL THIS TALLYING AND RANKING REALLY WORK??? LOL I'M STILL NOT SURE!
        'cls
        'Print "Player TotalSeconds Place PlaceText  score wins GameTime forefeits RankScore OverallPlace OverallPlaceText"
        ''      1234567123456789012312345612345678901123456123451234567891234567890123456789012345678901231234567890123456
        ''           6           12     5         10     5    4        8         9         9           12               16
        'For iPlayerLoop = 1 To 4
        '   sLine = ""
        '   sLine = sLine + StrPadLeft$(_Trim$(Str$(iPlayerLoop)), 6) + " "
        '   sLine = sLine + StrPadLeft$(_Trim$(Str$(m_arrPlayer(iPlayerLoop).TotalSeconds)), 12) + " "
        '   sLine = sLine + StrPadLeft$(_Trim$(Str$(m_arrPlayer(iPlayerLoop).Place)), 5) + " "
        '   sLine = sLine + StrPadLeft$(m_arrPlayer(iPlayerLoop).PlaceText, 10) + " "
        '   sLine = sLine + StrPadLeft$(_Trim$(Str$(m_arrPlayer(iPlayerLoop).score)), 5) + " "
        '   sLine = sLine + StrPadLeft$(_Trim$(Str$(m_arrPlayer(iPlayerLoop).wins)), 4) + " "
        '   '_Trim$(Str$(m_arrPlayer(iPlayerLoop).ConsecWinMax))
        '   sLine = sLine + StrPadLeft$(_Trim$(Str$(m_arrPlayer(iPlayerLoop).GameTime)), 8) + " "
        '   sLine = sLine + StrPadLeft$(_Trim$(Str$(m_arrPlayer(iPlayerLoop).forfeits)), 9) + " "
        '   '_Trim$(Str$(m_arrPlayer(iPlayerLoop).ConsecLossMax))
        '   sLine = sLine + StrPadLeft$(_Trim$(Str$(m_arrPlayer(iPlayerLoop).RankScore)), 9) + " "
        '   sLine = sLine + StrPadLeft$(_Trim$(Str$(m_arrPlayer(iPlayerLoop).OverallPlace)), 12) + " "
        '   sLine = sLine + StrPadLeft$(m_arrPlayer(iPlayerLoop).OverallPlaceText, 16) + ""
        '   print sLine
        'Next iPlayerLoop
        'input "PRESS ANY KEY TO CONTINUE";in$
        '' ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        '' END TEST RANKING @RANKTEST
        '' ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
       
        ' ================================================================================================================================================================
        ' END RANK PLAYERS OVERALL @OVERALL
        ' ================================================================================================================================================================
       
        ' ================================================================================================================================================================
        ' EXIT IF ERRORS
        If Len(sError) > 0 Then
            bGameOver = TRUE
        End If
       
    Loop Until bGameOver
    ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ' END A SINGLE GAME @GAME
    ' GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME
    ' GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME
    ' GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME GAME
    ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   
   
    ' =============================================================================
    ' UNDO FULLSCREEN IF IT WAS ENABLED
    If _FullScreen = 0 Then
        _FullScreen _Off
    End If
   
    ' =============================================================================
    ' SHOW ANY ERRORS
    If Len(sError) > 0 Then
        sResult = "ERROR: " + sError
        'Print "ERROR: " + sError
        'Print sTemp
        'WaitForKey "Press <ESC> to continue", 27, 0
    End If
   
    ' =============================================================================
    ' CLEAR KEYBOARD BUFFER AND EXIT
    'WHILE _DEVICEINPUT(1): WEND ' clear and update the keyboard buffer
    _KeyClear: '_DELAY 1
   
    ' RETURN RESULT
    game1$ = sResult
   
End Function ' game1$

' ################################################################################################################################################################
' END GAME LOGIC
' ################################################################################################################################################################








' ################################################################################################################################################################
' BEGIN GRAPHICS ROUTINES
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////
' TEST CODE TO TRY GRAPHICS OTHER THAN SIMPLE RECTANGLES
' ALSO EVENTUALLY WE MAY WANT TO USE HARDWARE IMAGES
Sub game2 ()
    Dim sGraphic As String

    ' =============================================================================
    ' INITIALIZE PLAYERS + OBJECTS

    ' DETERMINE EACH PLAYER'S "HOME" SQUARES

    ' CLEAR KEYBOARD STATE
    For iLoop = 1 To 512
        arrKeys(iLoop) = 0
    Next iLoop

    ' -----------------------------------------------------------------------------
    ' INITIATE GRAPICS

    ' Player
    sGraphic = ""
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "......####......" + Chr$(13)
    sGraphic = sGraphic + "......####......" + Chr$(13)
    sGraphic = sGraphic + "......####......" + Chr$(13)
    sGraphic = sGraphic + "......####......" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" '+ chr$(13)
    'arrTextPics(0) = strBinary = Replace$(sGraphic, "#", "Y")
    'arrTextPics(1) = strBinary = Replace$(sGraphic, "#", "R")
    'arrTextPics(2) = strBinary = Replace$(sGraphic, "#", "G")
    'arrTextPics(3) = strBinary = Replace$(sGraphic, "#", "B")

    ' Key Right
    sGraphic = ""
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "....###........." + Chr$(13)
    sGraphic = sGraphic + "....#.######...." + Chr$(13)
    sGraphic = sGraphic + "....###..#.#...." + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" '+ chr$(13)
    'arrTextPics(4) = strBinary = Replace$(sGraphic, "#", "Y")
    'arrTextPics(5) = strBinary = Replace$(sGraphic, "#", "R")
    'arrTextPics(6) = strBinary = Replace$(sGraphic, "#", "G")
    'arrTextPics(7) = strBinary = Replace$(sGraphic, "#", "B")

    ' Key Left
    sGraphic = ""
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + ".........###...." + Chr$(13)
    sGraphic = sGraphic + "....######.#...." + Chr$(13)
    sGraphic = sGraphic + "....#.#..###...." + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" '+ chr$(13)
    'arrTextPics(8) = strBinary = Replace$(sGraphic, "#", "Y")
    'arrTextPics(9) = strBinary = Replace$(sGraphic, "#", "R")
    'arrTextPics(10) = strBinary = Replace$(sGraphic, "#", "G")
    'arrTextPics(11) = strBinary = Replace$(sGraphic, "#", "B")

    ' Key Up
    sGraphic = ""
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + ".......##......." + Chr$(13)
    sGraphic = sGraphic + "........#......." + Chr$(13)
    sGraphic = sGraphic + ".......##......." + Chr$(13)
    sGraphic = sGraphic + "........#......." + Chr$(13)
    sGraphic = sGraphic + "........#......." + Chr$(13)
    sGraphic = sGraphic + ".......###......" + Chr$(13)
    sGraphic = sGraphic + ".......#.#......" + Chr$(13)
    sGraphic = sGraphic + ".......###......" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" '+ chr$(13)
    'arrTextPics(12) = strBinary = Replace$(sGraphic, "#", "Y")
    'arrTextPics(13) = strBinary = Replace$(sGraphic, "#", "R")
    'arrTextPics(14) = strBinary = Replace$(sGraphic, "#", "G")
    'arrTextPics(15) = strBinary = Replace$(sGraphic, "#", "B")

    ' Key Down
    sGraphic = ""
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + ".......###......" + Chr$(13)
    sGraphic = sGraphic + ".......#.#......" + Chr$(13)
    sGraphic = sGraphic + ".......###......" + Chr$(13)
    sGraphic = sGraphic + "........#......." + Chr$(13)
    sGraphic = sGraphic + "........#......." + Chr$(13)
    sGraphic = sGraphic + "........##......" + Chr$(13)
    sGraphic = sGraphic + "........#......." + Chr$(13)
    sGraphic = sGraphic + "........##......" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" + Chr$(13)
    sGraphic = sGraphic + "................" '+ chr$(13)
    'arrTextPics(16) = strBinary = Replace$(sGraphic, "#", "Y")
    'arrTextPics(17) = strBinary = Replace$(sGraphic, "#", "R")
    'arrTextPics(18) = strBinary = Replace$(sGraphic, "#", "G")
    'arrTextPics(19) = strBinary = Replace$(sGraphic, "#", "B")

    ' -----------------------------------------------------------------------------
    ' DETECT PLAYER INPUT
    ' arrKeys(512) AS Integer

    'IF _KEYDOWN(119) then y% = y% -1 ' w
    'IF _KEYDOWN(115) then y% = y% + 1 ' s
    'IF _KEYDOWN(97) then x% = x% -1 ' a
    'IF _KEYDOWN(100) then x% = x% + 1 ' d

    ' =============================================================================
    ' MAIN LOOP = GET INPUT AND MOVE PLAYERS

    ' PLAYER   COMMAND    KEY                     _BUTTON  CONSTANT
    ' 1        up         Crsr Up                 329      c_bKey_CrsrUp
    ' 1        down       Crsr Down               337      c_bKey_CrsrDown
    ' 1        left       Crsr Left               332      c_bKey_CrsrLeft
    ' 1        right      Crsr Right              334      c_bKey_CrsrRight
    ' 1        drop item  Right Ctrl              286      c_bKey_RightCtrl
    ' -
    ' 2        up         KEYPAD 8 Up             73       c_bKey_Kpad8
    ' 2        down       KEYPAD 2 Down           81       c_bKey_Kpad2
    ' 2        left       KEYPAD 4 Left           76       c_bKey_Kpad4
    ' 2        right      KEYPAD 6 Right          78       c_bKey_Kpad6
    ' 2        drop item  KEYPAD 0 Ins            83       c_bKey_Kpad0
    ' -
    ' 3        up         ?                       ?        ?
    ' 3        down       ?                       ?        ?
    ' 3        left       ?                       ?        ?
    ' 3        right      ?                       ?        ?
    ' 3        drop item  ?                       ?        ?
    ' -
    ' 4        up         ?                       ?        ?
    ' 4        down       ?                       ?        ?
    ' 4        left       ?                       ?        ?
    ' 4        right      ?                       ?        ?
    ' 4        drop item  ?                       ?        ?

    Do

        While _DeviceInput(1): Wend ' clear and update the keyboard buffer

        ' Detect changed key states
        arrKeys(c_bKey_CrsrUp) = IIF(_Button(c_bKey_CrsrUp) = 0, FALSE, TRUE)
        arrKeys(c_bKey_CrsrDown) = IIF(_Button(c_bKey_CrsrDown) = 0, FALSE, TRUE)
        arrKeys(c_bKey_CrsrLeft) = IIF(_Button(c_bKey_CrsrLeft) = 0, FALSE, TRUE)
        arrKeys(c_bKey_CrsrRight) = IIF(_Button(c_bKey_CrsrRight) = 0, FALSE, TRUE)
        arrKeys(c_bKey_RightCtrl) = IIF(_Button(c_bKey_RightCtrl) = 0, FALSE, TRUE)
        arrKeys(c_bKey_Kpad8) = IIF(_Button(c_bKey_Kpad8) = 0, FALSE, TRUE)
        arrKeys(c_bKey_Kpad2) = IIF(_Button(c_bKey_Kpad2) = 0, FALSE, TRUE)
        arrKeys(c_bKey_Kpad4) = IIF(_Button(c_bKey_Kpad4) = 0, FALSE, TRUE)
        arrKeys(c_bKey_Kpad6) = IIF(_Button(c_bKey_Kpad6) = 0, FALSE, TRUE)
        arrKeys(c_bKey_Kpad0) = IIF(_Button(c_bKey_Kpad0) = 0, FALSE, TRUE)

        ' If the last key pressed is still held down, don't keep printing the code
        If (iLoop <> iLastPressed) Then
            If iCode <> 0 Then
                Cls
                Print "Press a key to see what _BUTTON code is detetected."
                Print
                Print "Detected key press with _BUTTON(" + Str$(iLoop) + ") = " + Str$(iCode)
                Print
                Print "(Press <ESC> to exit)."
                iLastPressed = iLoop
            End If
        Else
            ' If last key is released, clear the code so it can be pressed again:
            If iCode = 0 Then
                iLastPressed = -1
            End If
        End If





        iIndex = LBound(arrInfo) - 1
        For iLoop = 1 To iNumPlayers
            'TODO:

            'iIndex = iIndex + 1

            '' ERASE CURSORS AT CURRENT POSITION
            ''TODO:
            'LOCATE arrInfo(iIndex).y, arrInfo(iIndex).x: PRINT " ";

            '' GET NEXT MOUSE INPUT
            'IF in$ = "1" THEN
            '    ReadMouse1 arrMouseID(iIndex), arrInfo(iIndex).x, arrInfo(iIndex).y, left%, middle%, right%, arrInfo(iIndex).wheel, cMinWheel, cMaxWheel
            'ELSEIF in$ = "2" THEN
            '    ReadMouse2 arrMouseID(iIndex), arrInfo(iIndex).x, arrInfo(iIndex).y, left%, middle%, right%, arrInfo(iIndex).wheel, cMinWheel, cMaxWheel
            'END IF

            '' HANDLE LEFT MOUSE BUTTON
            'IF left% THEN
            '    IF arrInfo(iIndex).LeftDown = FALSE THEN
            '        ' BUTTON DOWN EVENT
            '        arrInfo(iIndex).LeftDown = TRUE
            '        arrInfo(iIndex).LeftCount = arrInfo(iIndex).LeftCount + 1
            '    END IF
            'ELSE
            '    IF arrInfo(iIndex).LeftDown = TRUE THEN
            '        ' BUTTON UP EVENT
            '        arrInfo(iIndex).LeftDown = FALSE
            '    END IF
            'END IF

            '' HANDLE MIDDLE MOUSE BUTTON (SCROLL WHEEL BUTTON)
            'IF middle% THEN
            '    IF arrInfo(iIndex).MiddleDown = FALSE THEN
            '        ' BUTTON DOWN EVENT
            '        arrInfo(iIndex).MiddleDown = TRUE
            '        arrInfo(iIndex).MiddleCount = arrInfo(iIndex).MiddleCount + 1
            '    END IF
            'ELSE
            '    IF arrInfo(iIndex).MiddleDown = TRUE THEN
            '        ' BUTTON UP EVENT
            '        arrInfo(iIndex).MiddleDown = FALSE
            '    END IF
            'END IF

            '' HANDLE RIGHT MOUSE BUTTON
            'IF right% THEN
            '    IF arrInfo(iIndex).RightDown = FALSE THEN
            '        ' BUTTON DOWN EVENT
            '        arrInfo(iIndex).RightDown = TRUE
            '        arrInfo(iIndex).RightCount = arrInfo(iIndex).RightCount + 1
            '    END IF
            'ELSE
            '    IF arrInfo(iIndex).RightDown = TRUE THEN
            '        ' BUTTON UP EVENT
            '        arrInfo(iIndex).RightDown = FALSE
            '    END IF
            'END IF

            '' CHECK BOUNDARIES
            'IF arrInfo(iIndex).x < cMinX THEN arrInfo(iIndex).x = cMinX
            'IF arrInfo(iIndex).x > cMaxX THEN arrInfo(iIndex).x = cMaxX
            'IF arrInfo(iIndex).y < cMinY THEN arrInfo(iIndex).y = cMinY
            'IF arrInfo(iIndex).y > cMaxY THEN arrInfo(iIndex).y = cMaxY

            '' PLOT CURSOR
            'LOCATE arrInfo(iIndex).y, arrInfo(iIndex).x: PRINT arrInfo(iIndex).c;

            '' DISPLAY VARIABLES
            'iLen = 3: sCount = LEFT$(LTRIM$(RTRIM$(STR$(iLoop))) + STRING$(iLen, " "), iLen)
            'iLen = 3: sX = LEFT$(LTRIM$(RTRIM$(STR$(arrInfo(iIndex).x))) + STRING$(iLen, " "), iLen)
            'iLen = 3: sY = LEFT$(LTRIM$(RTRIM$(STR$(arrInfo(iIndex).y))) + STRING$(iLen, " "), iLen)
            'iLen = 6: sWheel = LEFT$(LTRIM$(RTRIM$(STR$(arrInfo(iIndex).wheel))) + STRING$(iLen, " "), iLen)
            'iLen = 9: sLeftDown = LEFT$(LTRIM$(RTRIM$(STR$(arrInfo(iIndex).LeftDown))) + STRING$(iLen, " "), iLen)
            'iLen = 11: sMiddleDown = LEFT$(LTRIM$(RTRIM$(STR$(arrInfo(iIndex).MiddleDown))) + STRING$(iLen, " "), iLen)
            'iLen = 10: sRightDown = LEFT$(LTRIM$(RTRIM$(STR$(arrInfo(iIndex).RightDown))) + STRING$(iLen, " "), iLen)
            'iLen = 10: sLeftCount = LEFT$(LTRIM$(RTRIM$(STR$(arrInfo(iIndex).LeftCount))) + STRING$(iLen, " "), iLen)
            'iLen = 12: sMiddleCount = LEFT$(LTRIM$(RTRIM$(STR$(arrInfo(iIndex).MiddleCount))) + STRING$(iLen, " "), iLen)
            'iLen = 11: sRightCount = LEFT$(LTRIM$(RTRIM$(STR$(arrInfo(iIndex).RightCount))) + STRING$(iLen, " "), iLen)

            ''LOCATE 5,       1: PRINT "#  X  Y  Wheel LeftDown MiddleDown RightDown LeftCount MiddleCount RightCount   "
            'LOCATE 6 + iLoop, 1: PRINT sCount + sX + sY + sWheel + sLeftDown + sMiddleDown + sRightDown + sLeftCount + sMiddleCount + sRightCount

        Next iLoop

        _Limit 100 ' keep loop at 100 frames per second
    Loop Until _KeyDown(27) ' escape key exit
    _KeyClear: '_DELAY 1

    'LOCATE 25, 1: WaitForKey "Press <ESC> to continue", 27, 0
    'SYSTEM: END
End Sub ' game2

' /////////////////////////////////////////////////////////////////////////////
' Receives a 16x16 graphic as a string where linebreaks are chr$(13)
' and the other characters represent colors (a period "." is
' used for transparent),
' and returns as a 2D integer array indexed (y,x)
' containing the integer rgb value for each corresponding pixel,
' and returns iColCount and iRowCount for the used array size.

Sub TestPicStringToArray
    Dim arrColorValue(-1) As ULDictionary
    Dim arrSprite(16, 16) As Integer
    Dim sGraphic1 As String
    Dim sGraphic2 As String
    Dim bResult As Integer
    Dim iRowCount As Integer
    Dim iColCount As Integer
    Dim iLoopRows As Integer
    Dim iLoopCols As Integer

    bResult = GetColorDictionary%(arrColorValue())
    Print "GetColorDictionary%(arrColorValue()) RETURNS " + IIFSTR$(bResult, "TRUE", "FALSE")

    ' ****************************************************************************************************************************************************************
    Dim sFileName As String
    Dim sError As String
    Dim sTemp As String
    'sFileName = m_ProgramPath$ + m_ProgramName$ + ".TEST.txt" '
    sFileName = "c:\temp\maze_test_52.txt"
    sTemp = ""
    sTemp = sTemp + "CONTENTS OF arrColorValue():" + Chr$(13)
    sTemp = sTemp + "UBOUND(arrColorValue) RETURNS " + cstr$(UBound(arrColorValue)) + Chr$(13)
    sTemp = sTemp + DumpULDictionary$(arrColorValue())
    sError = PrintFile$(sFileName, sTemp, FALSE)
    If Len(sError) = 0 Then
        Print "Wrote output to file " + Chr$(34) + sFileName + Chr$(34) + "."
    Else
        Print "Could not write to file " + Chr$(34) + sFileName + Chr$(34) + "."
        Print sError
    End If
    WaitForEnter
    ' ****************************************************************************************************************************************************************

    sGraphic1 = ""
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + ".........###...." + Chr$(13)
    sGraphic1 = sGraphic1 + "....######.#...." + Chr$(13)
    sGraphic1 = sGraphic1 + "....#.#..###...." + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" + Chr$(13)
    sGraphic1 = sGraphic1 + "................" '+ chr$(13)

    sGraphic2 = Replace$(sGraphic1, "#", "Y")
    Print sGraphic2
    WaitForEnter

    picture_string_to_array arrColorValue(), sGraphic2, Chr$(13), arrSprite(), iRowCount, iColCount
    Print "iRowCount = " + cstr$(iRowCount)
    Print "iColCount = " + cstr$(iColCount)

    For iLoopRows = 0 To iRowCount - 1
        For iLoopCols = 0 To iColCount - 1
            'PRINT "arrSprite(" + cstr$(iLoopRows) + ",  " + cstr$(iLoopCols) + ") = " + cstr$(arrSprite(iLoopRows, iLoopCols))
            Print cstr$(arrSprite(iLoopRows, iLoopCols)) + " ";
        Next iLoopCols
        'WaitForEnter
        Print ""
    Next iLoopRows
    WaitForEnter

    Exit Sub

    Print sGraphic1
    WaitForEnter

    'yidder

    sGraphic2 = Replace$(sGraphic1, "#", "Y")
    Print sGraphic2
    WaitForEnter

    sGraphic2 = Replace$(sGraphic1, "#", "R")
    Print sGraphic2
    WaitForEnter

    sGraphic2 = Replace$(sGraphic1, "#", "G")
    Print sGraphic2
    WaitForEnter

    sGraphic2 = Replace$(sGraphic1, "#", "B")
    Print sGraphic2
    WaitForEnter

    Exit Sub

    'ReadULDictionary~&(arrColorValue(), "#", iDefault)
    'sGraphic = Replace$(sGraphic, "#", "R"): PRINT sGraphic
    'sGraphic = Replace$(sGraphic, "#", "G"): PRINT sGraphic
    'sGraphic = Replace$(sGraphic, "#", "B"): PRINT sGraphic

    'arrTextPics(12) = strBinary
End Sub ' TestPicStringToArray

' /////////////////////////////////////////////////////////////////////////////

Sub picture_string_to_array (arrColorValue() As ULDictionary, sGraphic As String, sDelim As String, arrGraphic( 16 , 16) As Integer, iRowCount As Integer, iColCount As Integer)
    ReDim arrLines$(0)
    Dim iRow%
    Dim iCol%
    Dim sChar$

    split sGraphic, sDelim, arrLines$()

    iRowCount = 0
    iColCount = 0
    For iRow% = 0 To UBound(arrLines$) ' LBOUND(arrLines$) TO UBOUND(arrLines$)
        If iRow% <= 50 Then
            iRowCount = iRowCount + 1
            For iCol% = 1 To Len(arrLines$(iRow%))
                If iCol% <= 50 Then
                    If iRowCount = 1 Then
                        iColCount = iColCount + 1
                    End If

                    sChar$ = Mid$(arrLines$(iRow%), iCol%, 1)

                    arrGraphic(iRow%, iCol% - 1) = ReadULDictionaryCaseSensitive~&(arrColorValue(), sChar$, -1)

                Else
                    ' Exit if out of bounds
                    Exit For
                End If
            Next iCol%
        Else
            ' Exit if out of bounds
            Exit For
        End If
    Next iRow%

End Sub ' picture_string_to_array

' ################################################################################################################################################################
' END GRAPHICS ROUTINES
' ################################################################################################################################################################

' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' BEGIN GRAPHIC PRINTING ROUTINES
' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

' /////////////////////////////////////////////////////////////////////////////
' Does a _PrintString at the specified row+column.
'
' iRow% and iCol% are 0-based in this version
'
' See also: PrintString, PrintString1, PutCharXY

Sub PrintAt (iRow%, iCol%, sText$)
    '_PrintString (iCol% * 8, iRow% * 16), sText$
    _PrintString (iCol% * 8, iRow% * 16), sText$
    '_PrintString (iCol%, iRow%), sText$
End Sub ' PrintAt

' /////////////////////////////////////////////////////////////////////////////
' Does a _PrintString at the specified row+column.
' iRow and iCol are 0-based.
' See also: PrintString1

Sub PrintString (iRow As Integer, iCol As Integer, MyString As String)
    Dim iX As Integer
    Dim iY As Integer
    iX = _FontWidth * iCol
    iY = _FontHeight * iRow ' (iRow + 1)
    _PrintString (iX, iY), MyString
End Sub ' PrintString

' /////////////////////////////////////////////////////////////////////////////
' Does a _PrintString at the specified row+column.
' iRow and iCol are 1-based.
' See also: PrintString

Sub PrintString1 (iRow As Integer, iCol As Integer, MyString As String)
    Dim iX As Integer
    Dim iY As Integer
    iX = _FontWidth * (iCol - 1)
    iY = _FontHeight * (iRow - 1)
    _PrintString (iX, iY), MyString
End Sub ' PrintString1

' /////////////////////////////////////////////////////////////////////////////
' Eliminates the math.

' Text resolution:
'  648 x  480:  80 x 30
'  720 x  480:  90 x 30
'  800 x  600: 100 x 37
' 1024 x  768: 128 x 48
' 1280 x 1024: 160 x 64
' 1920 x 1080: 240 x 67
' 2048 x 1152: 256 x 72 (truncated after 70 rows, 255 columns)
' 3840 x 2160: 480 x135 (truncated after 133 rows, 479 columns)

Sub PrintStringCR1 (iCol As Integer, iRow As Integer, MyString As String)
    Dim iCols As Integer
    Dim iRows As Integer
    Dim iX As Integer
    Dim iY As Integer
    iCols = _Width(0) \ _FontWidth
    iRows = _Height(0) \ _FontHeight
    iX = _FontWidth * (iCol - 1)
    iY = _FontHeight * (iRow - 1)
    _PrintString (iX, iY), MyString
End Sub ' PrintStringCR1

' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' END GRAPHIC PRINTING ROUTINES
' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++









' ################################################################################################################################################################
' BEGIN DICTIONARY DATA
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////
' ASSOCIATES EACH PLAYER AND THEIR KEYS/DOORS TO SPECIFIC COLORS

Function GetColorDictionary% (arrUnsignedLongDict() As ULDictionary)
    Dim bResult As Integer
    Dim iErrorCount As Integer

    InitULDictionary arrUnsignedLongDict()

    iErrorCount = 0

    ' PLAYER MAZE WALL COLORS
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "1", cRed), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "2", cYellow), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "3", cLime), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "4", cBlue), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "5", cOrange), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "6", cPurple), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "7", cLightPink), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "8", cWhite), 0, 1)

    ' DOOR/KEY COLORS (3 per player)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "A", cRed), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "B", cBrickRed), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "C", cOrangeRed), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "D", cYellow), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "E", cKhaki), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "F", cGold), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "G", cLime), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "H", cGreen), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "I", cDarkGreen), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "J", cBlue), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "K", cDodgerBlue), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "L", cCyan), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "M", cOrange), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "N", cDarkOrange), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "O", cDarkBrown), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "P", cPurple), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "Q", cPurpleRed), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "R", cMagenta), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "S", cLightPink), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "T", cHotPink), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "U", cDeepPink), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "V", cWhite), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "W", cGray), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "X", cBlack), 0, 1)

    ' UNUSED
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "d", cChartreuse), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "e", cMediumSpringGreen), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "r", cDeepSkyBlue), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "i", cSeaBlue), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "j", cBluePurple), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "k", cDeepPurple), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "m", cDarkRed), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "q", cOliveDrab), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "7", cDimGray), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "5", cDarkGray), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "4", cSilver), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "3", cLightGray), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "2", cGainsboro), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "1", cWhiteSmoke), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "w", cLightBrown), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), ".", cEmpty), 0, 1)

    GetColorDictionary% = IIF(iErrorCount = 0, TRUE, FALSE)
End Function ' GetColorDictionary%

' /////////////////////////////////////////////////////////////////////////////
' i think this ABS stuff was a holdover
' from a mistake i was making in the beginning
' where i was using long to store color values instead of _UNSIGNED LONG

' ASSOCIATES EACH PLAYER AND THEIR KEYS/DOORS TO SPECIFIC COLORS

Function GetColorDictionaryABS% (arrUnsignedLongDict() As ULDictionary)
    Dim bResult As Integer
    Dim iErrorCount As Integer

    InitULDictionary arrUnsignedLongDict()

    iErrorCount = 0

    ' PLAYER MAZE WALL COLORS
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "1", UnsignedLongABS~&(cRed)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "2", UnsignedLongABS~&(cYellow)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "3", UnsignedLongABS~&(cLime)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "4", UnsignedLongABS~&(cBlue)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "5", UnsignedLongABS~&(cOrange)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "6", UnsignedLongABS~&(cPurple)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "7", UnsignedLongABS~&(cLightPink)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionaryCaseSensitive%(arrUnsignedLongDict(), "8", UnsignedLongABS~&(cWhite)), 0, 1)

    ' DOOR/KEY COLORS (3 per player)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "A", UnsignedLongABS~&(cRed)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "B", UnsignedLongABS~&(cBrickRed)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "C", UnsignedLongABS~&(cOrangeRed)), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "D", UnsignedLongABS~&(cYellow)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "E", UnsignedLongABS~&(cKhaki)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "F", UnsignedLongABS~&(cGold)), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "G", UnsignedLongABS~&(cLime)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "H", UnsignedLongABS~&(cGreen)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "I", UnsignedLongABS~&(cDarkGreen)), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "J", UnsignedLongABS~&(cBlue)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "K", UnsignedLongABS~&(cDodgerBlue)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "L", UnsignedLongABS~&(cCyan)), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "M", UnsignedLongABS~&(cOrange)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "N", UnsignedLongABS~&(cDarkOrange)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "O", UnsignedLongABS~&(cDarkBrown)), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "P", UnsignedLongABS~&(cPurple)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "Q", UnsignedLongABS~&(cPurpleRed)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "R", UnsignedLongABS~&(cMagenta)), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "S", UnsignedLongABS~&(cLightPink)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "T", UnsignedLongABS~&(cHotPink)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "U", UnsignedLongABS~&(cDeepPink)), 0, 1)

    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "V", UnsignedLongABS~&(cWhite)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "W", UnsignedLongABS~&(cGray)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "X", UnsignedLongABS~&(cBlack)), 0, 1)

    ' UNUSED
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "d", UnsignedLongABS~&(cChartreuse)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "e", UnsignedLongABS~&(cMediumSpringGreen)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "r", UnsignedLongABS~&(cDeepSkyBlue)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "i", UnsignedLongABS~&(cSeaBlue)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "j", UnsignedLongABS~&(cBluePurple)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "k", UnsignedLongABS~&(cDeepPurple)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "m", UnsignedLongABS~&(cDarkRed)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "q", UnsignedLongABS~&(cOliveDrab)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "7", UnsignedLongABS~&(cDimGray)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "5", UnsignedLongABS~&(cDarkGray)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "4", UnsignedLongABS~&(cSilver)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "3", UnsignedLongABS~&(cLightGray)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "2", UnsignedLongABS~&(cGainsboro)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "1", UnsignedLongABS~&(cWhiteSmoke)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), "w", UnsignedLongABS~&(cLightBrown)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveULDictionary%(arrUnsignedLongDict(), ".", cEmpty), 0, 1)

    GetColorDictionaryABS% = IIF(iErrorCount = 0, TRUE, FALSE)
End Function ' GetColorDictionaryABS%

' /////////////////////////////////////////////////////////////////////////////

Function GetMapDictionary% (arrIntDict() As IntDictionary)
    Dim bResult As Integer
    Dim iErrorCount As Integer

    InitIntDictionary arrIntDict()

    iErrorCount = 0

    ' ONE PER PLAYER
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "1", cRed), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "2", cOrange), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "3", cYellow), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "4", cLime), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "5", cBlue), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "6", cPurple), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "7", cLightPink), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "8", cWhite), 0, 1)

    ' UNUSED
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "f", cCyan), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "h", cDodgerBlue), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "a", cOrangeRed), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "b", cDarkOrange), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "c", cGold), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "d", cChartreuse), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "e", cMediumSpringGreen), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "g", cDeepSkyBlue), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "i", cSeaBlue), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "j", cBluePurple), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "k", cDeepPurple), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "l", cPurpleRed), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "m", cDarkRed), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "n", cBrickRed), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "o", cDarkGreen), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "p", cGreen), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "q", cOliveDrab), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "s", cHotPink), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "t", cDeepPink), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "u", cMagenta), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "#", cBlack), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "7", cDimGray), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "6", cGray), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "5", cDarkGray), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "4", cSilver), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "3", cLightGray), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "2", cGainsboro), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "1", cWhiteSmoke), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "v", cDarkBrown), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "w", cLightBrown), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "x", cKhaki), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), ".", cEmpty, 0, 1)

    GetMapDictionary% = IIF(iErrorCount = 0, TRUE, FALSE)
End Function ' GetMapDictionary%

' /////////////////////////////////////////////////////////////////////////////
' i think this ABS stuff was a holdover
' from a mistake i was making in the beginning
' where i was using long to store color values instead of _UNSIGNED LONG

Function GetMapDictionaryABS% (arrIntDict() As IntDictionary)
    Dim bResult As Integer
    Dim iErrorCount As Integer

    InitIntDictionary arrIntDict()

    iErrorCount = 0

    ' ONE PER PLAYER
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "1", UnsignedLongABS~&(cRed)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "2", UnsignedLongABS~&(cOrange)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "3", UnsignedLongABS~&(cYellow)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "4", UnsignedLongABS~&(cLime)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "5", UnsignedLongABS~&(cBlue)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "6", UnsignedLongABS~&(cPurple)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "7", UnsignedLongABS~&(cLightPink)), 0, 1)
    iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "8", UnsignedLongABS~&(cWhite)), 0, 1)

    ' UNUSED
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "f", UnsignedLongABS~&(cCyan)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "h", UnsignedLongABS~&(cDodgerBlue)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "a", UnsignedLongABS~&(cOrangeRed)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "b", UnsignedLongABS~&(cDarkOrange)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "c", UnsignedLongABS~&(cGold)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "d", UnsignedLongABS~&(cChartreuse)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "e", UnsignedLongABS~&(cMediumSpringGreen)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "g", UnsignedLongABS~&(cDeepSkyBlue)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "i", UnsignedLongABS~&(cSeaBlue)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "j", UnsignedLongABS~&(cBluePurple)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "k", UnsignedLongABS~&(cDeepPurple)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "l", UnsignedLongABS~&(cPurpleRed)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "m", UnsignedLongABS~&(cDarkRed)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "n", UnsignedLongABS~&(cBrickRed)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "o", UnsignedLongABS~&(cDarkGreen)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "p", UnsignedLongABS~&(cGreen)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "q", UnsignedLongABS~&(cOliveDrab)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "s", UnsignedLongABS~&(cHotPink)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "t", UnsignedLongABS~&(cDeepPink)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "u", UnsignedLongABS~&(cMagenta)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "#", UnsignedLongABS~&(cBlack)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "7", UnsignedLongABS~&(cDimGray)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "6", UnsignedLongABS~&(cGray)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "5", UnsignedLongABS~&(cDarkGray)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "4", UnsignedLongABS~&(cSilver)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "3", UnsignedLongABS~&(cLightGray)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "2", UnsignedLongABS~&(cGainsboro)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "1", UnsignedLongABS~&(cWhiteSmoke)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "v", UnsignedLongABS~&(cDarkBrown)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "w", UnsignedLongABS~&(cLightBrown)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), "x", UnsignedLongABS~&(cKhaki)), 0, 1)
    'iErrorCount = iErrorCount + IIF(SaveIntDictionary%(arrIntDict(), ".", cEmpty), 0, 1)

    GetMapDictionaryABS% = IIF(iErrorCount = 0, TRUE, FALSE)
End Function ' GetMapDictionaryABS%

' ################################################################################################################################################################
' END DICTIONARY DATA
' ################################################################################################################################################################


























' ################################################################################################################################################################
' BEGIN MAZE ROUTINES
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////
' Generates a random maze and returns it as an array.
' iCols can be

Sub get_random_maze_array (arrMaze( 50 , 50) As Integer, iCols1 As Integer, iRows1 As Integer, iWidth1 As Integer, iWall1 As Integer, iEmpty1 As Integer, iRowCount As Integer, iColCount As Integer, sMaze As String)
    Dim arrMyMazeData(50, 50) As Integer ' the maze of cells
    Dim arrStack(2, 2500) As Integer ' cell stack to hold a list of cell locations
    Dim iCols As Integer: iCols = iCols1 ' maze width (# tiles across)
    Dim iRows As Integer: iRows = iRows1 ' maze height (# tiles up and down)
    Dim iWidth As Integer: iWidth = iWidth1 ' passage width (# tiles across, walls are always 1 tile wide)
    Dim iWall As Integer: iWall = iWall1 ' value that represents a wall in final maze array
    Dim iEmpty As Integer: iEmpty = iEmpty1 ' value that represents empty space in final maze array
    Dim sWall As String: sWall = "#"
    Dim sEmpty As String: sEmpty = "."
    'DIM sMaze AS STRING
    Dim iLoop As Integer
    Dim iNextRow As Integer
    Dim iNextColumn As Integer
    Dim sNextChar As String

    ' INITIALIZE THE CELLS
    init_cells iCols, iRows, arrMyMazeData(), arrStack()

    ' GENERATE MAZE DATA
    generate_maze iCols, iRows, arrMyMazeData(), arrStack()

    ' CONVERT MAZE DATA TO STRING REPRESENTATION
    sMaze = writeout_maze$(arrMyMazeData(), iCols, iRows, iWidth, sWall, sEmpty)

    ' CONVERT STRING REPRESENTATION TO ARRAY
    maze_string_to_array sMaze, Chr$(13), arrMaze(), sWall, sEmpty, iWall, iEmpty, iRowCount, iColCount

    'iColCount = 0 ' used to return # of rows
    'iRowCount = 0 ' used to return # of columns
    'iNextRow = 0
    'iNextColumn = -1
    'FOR iLoop = 1 TO LEN(sMaze)
    '    sNextChar = MID$(sMaze, iLoop, 1)
    '    IF (sNextChar = CHR$(13)) THEN
    '        iNextRow = iNextRow + 1
    '        iRowCount = iNextRow ' Return the max row as the # of rows
    '        iColCount = iNextColumn ' Return the max column as the # of columns
    '        iNextColumn = -1
    '    ELSE
    '        iNextColumn = iNextColumn + 1
    '        IF (sNextChar = sWall) THEN
    '            arrMaze(iNextColumn, iNextRow) = iWall
    '        ELSEIF (sNextChar = sEmpty) THEN
    '            arrMaze(iNextColumn, iNextRow) = iEmpty
    '        END IF
    '    END IF
    'NEXT iLoop
End Sub ' get_random_maze_array

' /////////////////////////////////////////////////////////////////////////////
' Receives a maze as a string where linebreaks are chr$(13)
' and returns as a 2D integer array indexed (y,x) containing iWall1 for wall and iEmpty1 for empty space (hall)
' and returns iColCount and iRowCount for the used array size

'OLD: SUB maze_string_to_array (sMaze AS STRING, arrMaze( 50 , 50) AS INTEGER, sWallChar1 AS STRING, sEmptyChar1 AS STRING, iWall1 AS INTEGER, iEmpty1 AS INTEGER, iRowCount AS INTEGER, iColCount AS INTEGER)
'NEW: SUB maze_string_to_array (sMaze AS STRING, sDelim AS STRING, arrMaze( 50 , 50) AS INTEGER, sWallChar1 AS STRING, sEmptyChar1 AS STRING, iWall1 AS INTEGER, iEmpty1 AS INTEGER, iRowCount AS INTEGER, iColCount AS INTEGER)

Sub maze_string_to_array (sMaze As String, sDelim As String, arrMaze( 50 , 50) As Integer, sWallChar1 As String, sEmptyChar1 As String, iWall1 As Integer, iEmpty1 As Integer, iRowCount As Integer, iColCount As Integer)
    ReDim arrLines$(0)
    Dim iRow%
    Dim iCol%
    Dim sChar$
    Dim sWallChar As String: sWallChar = sWallChar1
    Dim sEmptyChar As String: sEmptyChar = sEmptyChar1
    Dim iWall As Integer: iWall = iWall1
    Dim iEmpty As Integer: iEmpty = iEmpty1

    split sMaze, sDelim, arrLines$()

    iRowCount = 0
    iColCount = 0
    For iRow% = LBound(arrLines$) To UBound(arrLines$)
        If iRow% <= 50 Then
            iRowCount = iRowCount + 1
            For iCol% = 1 To Len(arrLines$(iRow%))
                If iCol% <= 50 Then
                    If iRowCount = 1 Then iColCount = iColCount + 1
                    sChar$ = Mid$(arrLines$(iRow%), iCol%, 1)
                    If sChar$ = sWallChar Then
                        arrMaze(iRow%, iCol%) = iWall
                    ElseIf sChar$ = sEmptyChar Then
                        arrMaze(iRow%, iCol%) = iEmpty
                    End If
                Else
                    ' Exit if out of bounds
                    Exit For
                End If
            Next iCol%
        Else
            ' Exit if out of bounds
            Exit For
        End If
    Next iRow%

End Sub ' maze_string_to_array

' /////////////////////////////////////////////////////////////////////////////
' Generates a random maze and returns it as a string.

' MazeGenerator
' based on the javascript Maze Generator by Stephen R. Schmitt
' http://home.att.net/~srschmitt/script_maze_generator.html

' Got it working in VBScript and now QB64!

Function random_maze$ (iCols1 As Integer, iRows1 As Integer, iWidth1 As Integer, sChar1 As String, sEmpty1 As String)
    Dim sResult As String
    Dim arrMaze(50, 50) As Integer ' the maze of cells
    Dim arrStack(2, 2500) As Integer ' cell stack to hold a list of cell locations
    Dim iCols As Integer: iCols = iCols1
    Dim iRows As Integer: iRows = iRows1
    Dim iWidth As Integer: iWidth = iWidth1
    Dim sChar As String: sChar = sChar1
    Dim sEmpty As String: sEmpty = sEmpty1

    ' create and display a maze

    'PRINT "init_cells ..." ' DEBUG
    init_cells iCols, iRows, arrMaze(), arrStack()

    'PRINT "generate_maze ..." ' DEBUG
    generate_maze iCols, iRows, arrMaze(), arrStack()

    'PRINT "writeout_maze$ ..." ' DEBUG
    sResult = writeout_maze$(arrMaze(), iCols, iRows, iWidth, sChar, sEmpty)

    Dim sFileName As String
    Dim sError As String
    Dim sInput As String
    sFileName = "c:\temp\maze_test_4.txt"
    sError = PrintFile$(sFileName, sResult, FALSE)
    If Len(sError) = 0 Then
        Print "Wrote output to file " + Chr$(34) + sFileName + Chr$(34) + "."
    Else
        Print "Could not write to file " + Chr$(34) + sFileName + Chr$(34) + "."
        Print sError
    End If
    Input "Press <ENTER> to continue", sInput

    'PRINT "returning value ..." ' DEBUG
    random_maze$ = sResult
End Function ' random_maze$

' /////////////////////////////////////////////////////////////////////////////
' initialize variable sized multidimensional arrays
' ^^^
' This has been giving us trouble in QB64
' (ReDim keeps causing compiler errors, it never seems to be allowed, etc.)
' so for now we are just using a fixed size array
' and manually keeping track of the used rows/coluns.

Sub init_cells (iCols1 As Integer, iRows1 As Integer, arrMaze( 50 , 50) As Integer, arrStack( 2 , 2500) As Integer)
    Dim iRow As Integer
    Dim iCol As Integer
    Dim iCols As Integer: iCols = iCols1
    Dim iRows As Integer: iRows = iRows1

    'ReDim arrMaze(iCols, iRows) ' create a maze of cells that is the proper size

    ' set all walls of each cell in maze by setting bits :  cN cE cS cW
    For iRow = 0 To iRows - 1
        For iCol = 0 To iCols - 1
            'PRINT "arrMaze R" + STR$(iRow) + "C" + STR$(iCol) ' DEBUG
            arrMaze(iCol, iRow) = cN + cE + cS + cW ' room begins with walls on all 4 sides
            'arrMaze(iCol, iRow) = SetBit256%(arrMaze(iC, iR), cN, True)
            'arrMaze(iCol, iRow) = SetBit256%(arrMaze(iC, iR), cS, True)
            'arrMaze(iCol, iRow) = SetBit256%(arrMaze(iC, iR), cE, True)
            'arrMaze(iCol, iRow) = SetBit256%(arrMaze(iC, iR), cW, True)
        Next iCol
    Next iRow

    ' create stack for storing previously visited locations
    'ReDim arrStack(2, iCols * iRows)

    ' initialize stack
    For iRow = 0 To (iRows * iCols)
        For iCol = 0 To 1
            'PRINT "arrStack R" + STR$(iRow) + "C" + STR$(iCol) ' DEBUG
            arrStack(iCol, iRow) = 0
        Next iCol
    Next iRow

End Sub ' init_cells

' /////////////////////////////////////////////////////////////////////////////
' use depth first search to create a maze

Sub generate_maze (iCols1 As Integer, iRows1 As Integer, arrMaze( 50 , 50) As Integer, arrStack( 2 , 2500) As Integer)
    Dim iCols As Integer: iCols = iCols1 ' UBound(arrMaze, 1)
    Dim iRows As Integer: iRows = iRows1 ' UBound(arrMaze, 2)
    Dim iI As Integer
    Dim iJ As Integer
    Dim iY As Integer
    Dim iX As Integer
    Dim iCurrX As Integer
    Dim iCurrY As Integer
    Dim iVisited As Integer
    Dim iTotal As Integer
    Dim iToS As Integer
    Dim arrMove(2, 4) As Integer
    Dim arrNext(2, 4) As Integer

    ' choose a cell at random and make it the current cell
    iX = RandomNumber(0, iCols - 1)
    iY = RandomNumber(0, iRows - 1)

    ' current search location
    iCurrX = iX
    iCurrY = iY

    iVisited = 1

    iTotal = iRows * iCols

    ' index for top of cell stack
    iToS = 0

    ' arrays of single step movements between cells
    ' stores the next move (dx, dy)

    ' LEFT
    arrMove(cX, 0) = -1
    arrMove(cY, 0) = 0

    ' DOWN
    arrMove(cX, 1) = 0
    arrMove(cY, 1) = 1

    ' RIGHT
    arrMove(cX, 2) = 1
    arrMove(cY, 2) = 0

    ' UP
    arrMove(cX, 3) = 0
    arrMove(cY, 3) = -1

    ' this is used for lookahead for adjacent rooms as we build the maze
    arrNext(cX, 0) = 0
    arrNext(cY, 0) = 0

    arrNext(cX, 1) = 0
    arrNext(cY, 1) = 0

    arrNext(cX, 2) = 0
    arrNext(cY, 2) = 0

    arrNext(cX, 3) = 0
    arrNext(cY, 3) = 0

    While iVisited < iTotal
        ' find all neighbors of current cell with all walls intact
        iJ = 0
        For iI = 0 To 3 ' look at each neighbor

            ' get coordinates of neighbor
            iX = iCurrX + arrMove(cX, iI)
            iY = iCurrY + arrMove(cY, iI)

            ' check for valid next cell
            If (iY >= 0) And (iY < iRows) And (iX >= 0) And (iX < iCols) Then
                ' check if previously visited

                If arrMaze(iX, iY) = (cN + cE + cS + cW) Then
                    ' not visited, so add to possible next cells
                    arrNext(cX, iJ) = iX
                    arrNext(cY, iJ) = iY
                    iJ = iJ + 1
                End If
            End If
        Next iI

        If iJ > 0 Then
            ' current cell has one or more unvisited neighbors, so choose one at random
            ' and knock down the wall between it and the current cell

            iI = RandomNumber(0, iJ - 1)

            If arrNext(cY, iI) = iCurrY Then
                ' next on same row
                iY = iCurrY
                If arrNext(cX, iI) > iCurrX Then
                    ' EAST
                    iX = iCurrX
                    arrMaze(iX, iY) = SetBit256%(arrMaze(iX, iY), cE, FALSE) ' Function SetBit256%(iNum As Variant, iBit As Variant, bVal As Boolean)
                    iX = arrNext(cX, iI)
                    arrMaze(iX, iY) = SetBit256%(arrMaze(iX, iY), cW, FALSE)
                Else
                    ' WEST
                    iX = iCurrX
                    arrMaze(iX, iY) = SetBit256%(arrMaze(iX, iY), cW, FALSE)
                    iX = arrNext(cX, iI)
                    arrMaze(iX, iY) = SetBit256%(arrMaze(iX, iY), cE, FALSE)
                End If
            Else
                ' next on same column
                iX = iCurrX
                If (arrNext(cY, iI) > iCurrY) Then
                    ' SOUTH
                    iY = iCurrY
                    arrMaze(iX, iY) = SetBit256%(arrMaze(iX, iY), cS, FALSE)
                    iY = arrNext(cY, iI)
                    arrMaze(iX, iY) = SetBit256%(arrMaze(iX, iY), cN, FALSE)
                Else
                    ' NORTH
                    iY = iCurrY
                    arrMaze(iX, iY) = SetBit256%(arrMaze(iX, iY), cN, FALSE)
                    iY = arrNext(cY, iI)
                    arrMaze(iX, iY) = SetBit256%(arrMaze(iX, iY), cS, FALSE)
                End If
            End If

            ' push current cell location to stack
            iToS = iToS + 1
            arrStack(cX, iToS) = iCurrX
            arrStack(cY, iToS) = iCurrY

            ' make next cell the current cell
            iCurrX = arrNext(cX, iI)
            iCurrY = arrNext(cY, iI)

            ' increment count of visited cells
            iVisited = iVisited + 1
        Else
            ' reached dead end, backtrack
            ' pop the most recent cell from the cell stack
            ' and make it the current cell
            iCurrX = arrStack(cX, iToS)
            iCurrY = arrStack(cY, iToS)
            iToS = iToS - 1
        End If
    Wend
End Sub ' generate_maze

' /////////////////////////////////////////////////////////////////////////////
' this version writes the maze with variable size rooms

Function writeout_maze$ (arrMaze( 50 , 50) As Integer, iCols1 As Integer, iRows1 As Integer, iWidth1 As Integer, sChar1 As String, sEmpty1 As String)
    Dim iR As Integer
    Dim iC As Integer
    Dim iK As Integer
    Dim iCols As Integer
    Dim iRows As Integer
    Dim sTemp As String
    Dim sNext1 As String
    Dim sNext2 As String
    Dim iLoop As Integer
    Dim iWidth As Integer: iWidth = iWidth1
    Dim sChar As String: sChar = sChar1
    Dim sEmpty As String: sEmpty = sEmpty1

    iCols = iCols1 ' UBound(arrMaze, 1)
    iRows = iRows1 ' UBound(arrMaze, 2)

    sTemp = ""
    sNext1 = ""
    sNext2 = ""

    For iR = 0 To iRows - 1
        For iK = 1 To 2
            For iC = 0 To iCols - 1
                If iK = 1 Then
                    If (GetBit256%(arrMaze(iC, iR), cN)) Then
                        'sNext1 = sNext1 + "+" + STRING$(iWidth, "-")
                        sNext1 = sNext1 + sChar + String$(iWidth, sChar)
                    Else
                        'sNext1 = sNext1 + "+" + STRING$(iWidth, " ")
                        sNext1 = sNext1 + sChar + String$(iWidth, sEmpty)
                    End If

                    If (iC + 1) = iCols Then
                        'sNext1 = sNext1 + "+"
                        sNext1 = sNext1 + sChar
                    End If
                ElseIf iK = 2 Then
                    If (GetBit256%(arrMaze(iC, iR), cW)) Then
                        'sNext2 = sNext2 + "|" + STRING$(iWidth, " ")
                        sNext2 = sNext2 + sChar + String$(iWidth, sEmpty)
                    Else
                        'sNext2 = sNext2 + " " + STRING$(iWidth, " ")
                        sNext2 = sNext2 + sEmpty + String$(iWidth, sEmpty)
                    End If

                    If (iC + 1) = iCols Then
                        'sNext2 = sNext2 + "|"
                        sNext2 = sNext2 + sChar
                    End If
                End If
            Next iC
        Next iK

        sTemp = sTemp + sNext1 + Chr$(13)

        For iLoop = 1 To iWidth
            sTemp = sTemp + sNext2 + Chr$(13)
        Next iLoop

        sNext1 = ""
        sNext2 = ""
    Next iR

    For iC = 0 To iCols - 1
        sTemp = sTemp + sChar + String$(iWidth, sChar)
    Next iC

    sTemp = sTemp + sChar + Chr$(13)

    ' RETURN RESULT
    writeout_maze$ = sTemp
End Function ' writeout_maze$

' /////////////////////////////////////////////////////////////////////////////

Sub TryDimensions1 ()
    ReDim arrNextMaze(-1, -1) As Integer ' holds next maze generated
    ReDim arrNextMaze(50, 50) As Integer
    Dim iMakeWidth As Integer
    Dim iMakeRows As Integer
    Dim iMakeCols As Integer
    Dim iFinalRows As Integer
    Dim iFinalCols As Integer
    Dim iWall As Integer: iWall = 1
    Dim iEmpty As Integer: iEmpty = 0
    Dim iRowCount As Integer
    Dim iColCount As Integer
    Dim sMaze As String
    Dim sFileName As String
    Dim vbCr As String: vbCr = Chr$(13)
    Dim vbTab As String: vbTab = Chr$(9)
    Dim quot As String: quot = Chr$(34)
    Dim sTempHR As String: sTempHR = "********************************************************************************************************************************************************************************************************************************************************************************************************************************"
    Dim sOut As String: sOut = ""
    Dim sError As String
    Dim sResult As String

    'sFileName = m_ProgramPath$ + LEFT$(m_ProgramName$, LEN(m_ProgramName$) - 4) + ".txt"

    sResult = ""
    For iMakeWidth = 1 To 10
        sFileName = m_ProgramPath$ + Left$(m_ProgramName$, Len(m_ProgramName$) - 4) + ".width " + cstr$(iMakeWidth) + ".txt"
        sOut = ""

        For iMakeRows = 2 To 35
            'FOR iMakeCols = 2 TO 35
            iMakeCols = iMakeRows

            'PRINT "iMakeWidth " + cstr$(iMakeWidth) + " of 5, iMakeRows " + cstr$(iMakeRows) + " of 35, iMakeCols " + cstr$(iMakeCols) + " of 35"
            Print "iMakeWidth " + cstr$(iMakeWidth) + " of 5, iMakeRows " + cstr$(iMakeRows) + " of 35"

            get_random_maze_array arrNextMaze(), iMakeCols, iMakeRows, iMakeWidth, iWall, iEmpty, iRowCount, iColCount, sMaze

            sOut = sOut + "iMakeWidth=" + cstr$(iMakeWidth) + vbCr
            sOut = sOut + "iMakeCols =" + cstr$(iMakeCols) + vbCr
            sOut = sOut + "iMakeRows =" + cstr$(iMakeRows) + vbCr
            sOut = sOut + "iRowCount=" + cstr$(iRowCount) + vbCr
            sOut = sOut + "iColCount=" + cstr$(iColCount) + vbCr
            sOut = sOut + sMaze + vbCr
            sOut = sOut + sTempHR + vbCr
            sOut = sOut + sTempHR + vbCr
            sOut = sOut + sTempHR + vbCr

            'NEXT iMakeCols
        Next iMakeRows

        sError = PrintFile$(sFileName, sOut, FALSE)
        If Len(sError) = 0 Then
            sResult = sResult + "Wrote output to file " + Chr$(34) + sFileName + Chr$(34) + "." + vbCr
        Else
            sResult = sResult + "Could not write to file " + Chr$(34) + sFileName + Chr$(34) + "." + vbCr
            sResult = sResult + sError + vbCr
        End If
        sResult = sResult + vbCr

    Next iMakeWidth

    Print sResult
    Print "DONE."
    WaitForEnter

End Sub ' TryDimensions1

' /////////////////////////////////////////////////////////////////////////////

Sub TryDimensions2 ()
    ReDim arrNextMaze(-1, -1) As Integer ' holds next maze generated
    ReDim arrNextMaze(50, 50) As Integer
    Dim iMakeWidth As Integer
    Dim iMakeRows As Integer
    Dim iMakeCols As Integer
    Dim iFinalRows As Integer
    Dim iFinalCols As Integer
    Dim iWall As Integer: iWall = 1
    Dim iEmpty As Integer: iEmpty = 0
    Dim iRowCount As Integer
    Dim iColCount As Integer
    Dim sMaze As String
    Dim sFileName As String
    Dim vbCr As String: vbCr = Chr$(13)
    Dim vbTab As String: vbTab = Chr$(9)
    Dim quot As String: quot = Chr$(34)
    Dim sTempHR As String: sTempHR = "********************************************************************************************************************************************************************************************************************************************************************************************************************************"
    Dim sOut As String: sOut = ""
    Dim sError As String
    Dim sResult As String

    sFileName = m_ProgramPath$ + Left$(m_ProgramName$, Len(m_ProgramName$) - 4) + ".width.txt"

    sResult = ""
    sOut = ""
    sOut = sOut + "iMakeWidth" + vbTab
    sOut = sOut + "iMakeCols" + vbTab
    sOut = sOut + "iMakeRows" + vbTab
    sOut = sOut + "iRowCount" + vbTab
    sOut = sOut + "iColCount" + vbTab
    sOut = sOut + vbCr

    For iMakeWidth = 1 To 10
        'sFileName = m_ProgramPath$ + LEFT$(m_ProgramName$, LEN(m_ProgramName$) - 4) + ".width " + cstr$(iMakeWidth) + ".txt"

        For iMakeRows = 2 To 35
            'FOR iMakeCols = 2 TO 35
            iMakeCols = iMakeRows

            'PRINT "iMakeWidth " + cstr$(iMakeWidth) + " of 5, iMakeRows " + cstr$(iMakeRows) + " of 35, iMakeCols " + cstr$(iMakeCols) + " of 35"
            Print "iMakeWidth " + cstr$(iMakeWidth) + " of 5, iMakeRows " + cstr$(iMakeRows) + " of 35"

            get_random_maze_array arrNextMaze(), iMakeCols, iMakeRows, iMakeWidth, iWall, iEmpty, iRowCount, iColCount, sMaze

            sOut = sOut + cstr$(iMakeWidth) + vbTab
            sOut = sOut + cstr$(iMakeCols) + vbTab
            sOut = sOut + cstr$(iMakeRows) + vbTab
            sOut = sOut + cstr$(iRowCount) + vbTab
            sOut = sOut + cstr$(iColCount) + vbTab
            sOut = sOut + vbCr

            'NEXT iMakeCols
        Next iMakeRows

    Next iMakeWidth

    sError = PrintFile$(sFileName, sOut, FALSE)
    If Len(sError) = 0 Then
        sResult = sResult + "Wrote output to file " + Chr$(34) + sFileName + Chr$(34) + "." + vbCr
    Else
        sResult = sResult + "Could not write to file " + Chr$(34) + sFileName + Chr$(34) + "." + vbCr
        sResult = sResult + sError + vbCr
    End If
    sResult = sResult + vbCr

    Print sResult
    Print "DONE."
    WaitForEnter

End Sub ' TryDimensions2

' ################################################################################################################################################################
' END MAZE ROUTINES
' ################################################################################################################################################################

























' ################################################################################################################################################################
' BEGIN WORLD ROUTINES
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////
' VIRTUAL WORLD v1

' TEXT    VALUE   TYPE                  COMMENT
' .       46      open space            can move freely
' x       88      open space, dark      can move freely, objects on space only visible when near player
' #       35      indestructible        blocks movement
' %       37      indestructible dark   blocks movement, only visible when near player
' ~       126     water                 can move slowly, visible, move fast if in boat

Function GetMap$
    Dim m$
    m$ = ""
    '                                                                                                             1111111111111111111111111111111111111111111111111111111111111
    '                   1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556
    '          1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    m$ = m$ + "################################################################################" + Chr$(13)
    m$ = m$ + "#.....................#...........#..........................................bB#" + Chr$(13)
    m$ = m$ + "#..####.####.####.##..#...####....#...........########..##...########..........#" + Chr$(13)
    m$ = m$ + "#..#..#.#..#.#..#.##.........#....#...#####...#......#..#....#......#..........#" + Chr$(13)
    m$ = m$ + "#..####.#..#.#..#.##.....####.....#...#.......#......#.......#......##.........#" + Chr$(13)
    m$ = m$ + "#..#....#..#.#..#.....#.......###.#...#####...#......#########........#........#" + Chr$(13)
    m$ = m$ + "#..#....####.####.##..#.......#...#...........#..............########..#.......#" + Chr$(13)
    m$ = m$ + "#######################...#####...#...#########.....#.##..#..........#..####...#" + Chr$(13)
    m$ = m$ + "#.........................#.......#.................#.##.#####........#....#...#" + Chr$(13)
    m$ = m$ + "#.....###.................#####################.....#.#########........#...#...#" + Chr$(13)
    m$ = m$ + "#.....###.........#...........................#.....#.......############...#...#" + Chr$(13)
    m$ = m$ + "#..#..###..#......#######################.....#.....####...#...............#...#" + Chr$(13)
    m$ = m$ + "#...#..#..#....################################...........#..###############...#" + Chr$(13)
    m$ = m$ + "#.../#####........#######################.................#..#.................#" + Chr$(13)
    m$ = m$ + "#......#..........#....................#.....########.#...#..###############...#" + Chr$(13)
    m$ = m$ + "#.....###.........#..#################.##....#........#...#................#...#" + Chr$(13)
    m$ = m$ + "#.....#.#.........##.#......#...........#....#.############..###############...#" + Chr$(13)
    m$ = m$ + "#....##.##.........#.#......#...........#.................#..#.................#" + Chr$(13)
    m$ = m$ + "##################.###########.############################..###############...#" + Chr$(13)
    m$ = m$ + "#...............#..............#..........#................................#...#" + Chr$(13)
    m$ = m$ + "#.............#.#............#.#..........#.#................###############...#" + Chr$(13)
    m$ = m$ + "#.............#.#............#.#..........#.#................#.................#" + Chr$(13)
    m$ = m$ + "#.............#.#............#.#..........#.#...............#..................#" + Chr$(13)
    m$ = m$ + "###...........#.#............#.#..........#.#..............#...................#" + Chr$(13)
    m$ = m$ + "#..############.##############.############.###############....................#" + Chr$(13)
    m$ = m$ + "#..............................................................................#" + Chr$(13)
    m$ = m$ + "#..............................................................................#" + Chr$(13)
    m$ = m$ + "#..####...........#..#.####.#....#....####...#####.#..#.####.#...#...#...####..#" + Chr$(13)
    m$ = m$ + "#..#..............#..#.#....#....#....#..#.....#...#..#.#..#.##.##..#.#..#.....#" + Chr$(13)
    m$ = m$ + "#..#..............####.####.#....#....#..#.....#...####.#..#.#.#.#.#####.####..#" + Chr$(13)
    m$ = m$ + "#..#....######....#..#.#....#....#....#..#.....#...#..#.#..#.#...#.#...#....#..#" + Chr$(13)
    m$ = m$ + "#..#....#.........#..#.####.####.####.####.....#...#..#.####.#...#.#...#.####..#" + Chr$(13)
    m$ = m$ + "#..#....#....#.................................................................#" + Chr$(13)
    m$ = m$ + "#..#....######.................................................................#" + Chr$(13)
    m$ = m$ + "#..#.........#.#####.######....................................................#" + Chr$(13)
    m$ = m$ + "#..###.......#.#..........#....................................................#" + Chr$(13)
    m$ = m$ + "#............#.#..........#######################################...#.....#....#" + Chr$(13)
    m$ = m$ + "#............#.#..........#............#.......#........#.......#...#.....#....#" + Chr$(13)
    m$ = m$ + "#....#########.#...............#...........#.......#........#...#...#.....#....#" + Chr$(13)
    m$ = m$ + "#..............#####################...########################.#...#.....#....#" + Chr$(13)
    m$ = m$ + "#....###########..........#...#........#.......#........#.......#...#######....#" + Chr$(13)
    m$ = m$ + "#..............#..........#.#.#....#.......#.......#........#...#..............#" + Chr$(13)
    m$ = m$ + "#....####################.#.#.###################################..............#" + Chr$(13)
    m$ = m$ + "#....#.........................................................................#" + Chr$(13)
    m$ = m$ + "#....###############....#######..##............................................#" + Chr$(13)
    m$ = m$ + "#..................#....#.........#............................................#" + Chr$(13)
    m$ = m$ + "#..................#....#.........#............................................#" + Chr$(13)
    m$ = m$ + "#..#################....###########............................................#" + Chr$(13)
    m$ = m$ + "#..#.....................................#################################.....#" + Chr$(13)
    m$ = m$ + "#..#.............................................................#.......#.....#" + Chr$(13)
    m$ = m$ + "#..#.............................................................#.......#.....#" + Chr$(13)
    m$ = m$ + "#..#################################..###############............#.......#.....#" + Chr$(13)
    m$ = m$ + "#..................................#..#.............#............#.......#.....#" + Chr$(13)
    m$ = m$ + "#........................########..#..#...########..#............#.......#.....#" + Chr$(13)
    m$ = m$ + "#..................##############..#..#..........#..#............#.......#.....#" + Chr$(13)
    m$ = m$ + "#..................#######.######..#..#...#..#...#..#............#.......#.....#" + Chr$(13)
    m$ = m$ + "#..................##############..#..#...########..##############.......#.....#" + Chr$(13)
    m$ = m$ + "#..................................#..#.......#..........................#.....#" + Chr$(13)
    m$ = m$ + "#..#################################..#####...###########..##...#######..###...#" + Chr$(13)
    m$ = m$ + "#..#......................................#.............#...#...#..........#...#" + Chr$(13)
    m$ = m$ + "#..#......................................#.............#...#...#..........#...#" + Chr$(13)
    m$ = m$ + "#..########################################.............####################...#" + Chr$(13)
    m$ = m$ + "#..............................................................................#" + Chr$(13)
    m$ = m$ + "#..............................................................................#" + Chr$(13)
    m$ = m$ + "#..............................................................................#" + Chr$(13)
    m$ = m$ + "#...###...###...###...###...###...###...###...###...###...###...###...###......#" + Chr$(13)
    m$ = m$ + "#...###...###...###...###...###...###...###...###...###...###...###...###......#" + Chr$(13)
    m$ = m$ + "#....#.....#.....#.....#.....#.....#.....#.....#.....#.....#.....#.....#.......#" + Chr$(13)
    m$ = m$ + "#....#.....#.....#.....#.....#.....#.....#.....#.....#.....#.....#.....#.......#" + Chr$(13)
    m$ = m$ + "#...###...###...###...###...###...###...###...###...###...###...###...###......#" + Chr$(13)
    m$ = m$ + "#..............................................................................#" + Chr$(13)
    m$ = m$ + "#......###...###...###...###...###...###...###...###...###...###...###...###...#" + Chr$(13)
    m$ = m$ + "#......###...###...###...###...###...###...###...###...###...###...###...###...#" + Chr$(13)
    m$ = m$ + "#.......#.....#.....#.....#.....#.....#.....#.....#.....#.....#.....#.....#....#" + Chr$(13)
    m$ = m$ + "#.......#.....#.....#.....#.....#.....#.....#.....#.....#.....#.....#.....#....#" + Chr$(13)
    m$ = m$ + "#......###...###...###...###...###...###...###...###...###...###...###...###...#" + Chr$(13)
    m$ = m$ + "#..............................................................................#" + Chr$(13)
    m$ = m$ + "#..............................................................................#" + Chr$(13)
    m$ = m$ + "#Aa............................................................................#" + Chr$(13)
    m$ = m$ + "################################################################################" + Chr$(13)
    GetMap$ = m$
End Function ' GetMap$

' /////////////////////////////////////////////////////////////////////////////

Sub GetMapArrays (arrMap1( 80 , 80) As String, arrPlayer1( 4 , 4) As Integer)
    Dim in$
    Dim delim$
    ReDim arrLines$(0)
    Dim iRow%
    Dim iCol%
    'DIM arrMap1(80, 80) AS STRING
    Dim sChar$

    delim$ = Chr$(13)
    in$ = GetMap$
    split in$, delim$, arrLines$()

    For iRow% = LBound(arrLines$) To UBound(arrLines$)
        If iRow% <= 80 Then
            'PRINT "arrLines$(" + LTRIM$(RTRIM$(STR$(iRow%))) + ") = " + CHR$(34) + arrLines$(iRow%) + CHR$(34)
            For iCol% = 1 To Len(arrLines$(iRow%))
                If iCol% <= 80 Then
                    sChar$ = Mid$(arrLines$(iRow%), iCol%, 1)
                    'IF (sChar$ = "a") THEN
                    '    m_arrPlayer(1, pX) = iCol%
                    '    m_arrPlayer(1, pY) = iRow%
                    '    sChar$ = "."
                    'ELSEIF (sChar$ = "A") THEN
                    '    m_arrPlayer(1, fX) = iCol%
                    '    m_arrPlayer(1, fY) = iRow%
                    '    sChar$ = "."
                    'ELSEIF (sChar$ = "b") THEN
                    '    m_arrPlayer(2, pX) = iCol%
                    '    m_arrPlayer(2, pY) = iRow%
                    '    sChar$ = "."
                    'ELSEIF (sChar$ = "B") THEN
                    '    m_arrPlayer(2, fX) = iCol%
                    '    m_arrPlayer(2, fY) = iRow%
                    '    sChar$ = "."
                    'ELSE
                    '    ' for now no other checking necessary
                    'END IF

                    arrMap1(iRow%, iCol%) = sChar$
                    'IF iCol% < LEN(arrLines$(iRow%)) THEN
                    '    PRINT arrMap1(iRow%, iCol%);
                    'ELSE
                    '    PRINT arrMap1(iRow%, iCol%)
                    'END IF
                Else
                    ' Exit if out of bounds
                    Exit For
                End If
            Next iCol%
        Else
            ' Exit if out of bounds
            Exit For
        End If
    Next iRow%

End Sub ' GetMapArrays

' ################################################################################################################################################################
' END WORLD ROUTINES
' ################################################################################################################################################################









' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' BEGIN COLOR FUNCTIONS
' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function cRed~& ()
    cRed = _RGB32(255, 0, 0)
End Function

Function cOrangeRed~& ()
    cOrangeRed = _RGB32(255, 69, 0)
End Function ' cOrangeRed~&

Function cDarkOrange~& ()
    cDarkOrange = _RGB32(255, 140, 0)
End Function ' cDarkOrange~&

Function cOrange~& ()
    cOrange = _RGB32(255, 165, 0)
End Function ' cOrange~&

Function cGold~& ()
    cGold = _RGB32(255, 215, 0)
End Function ' cGold~&

Function cYellow~& ()
    cYellow = _RGB32(255, 255, 0)
End Function ' cYellow~&

' LONG-HAIRED FRIENDS OF JESUS OR NOT,
' THIS IS NOT YELLOW ENOUGH (TOO CLOSE TO LIME)
' TO USE FOR OUR COMPLEX RAINBOW SEQUENCE:
Function cChartreuse~& ()
    cChartreuse = _RGB32(127, 255, 0)
End Function ' cChartreuse~&

' WE SUBSTITUTE THIS CSS3 COLOR FOR INBETWEEN LIME AND YELLOW:
Function cOliveDrab1~& ()
    cOliveDrab1 = _RGB32(192, 255, 62)
End Function ' cOliveDrab1~&

Function cLime~& ()
    cLime = _RGB32(0, 255, 0)
End Function ' cLime~&

Function cMediumSpringGreen~& ()
    cMediumSpringGreen = _RGB32(0, 250, 154)
End Function ' cMediumSpringGreen~&

' ADDED THIS FOR THE GAUGE COLOR:
Function cSpringGreen~& ()
    cSpringGreen = _RGB32(0, 255, 160)
End Function ' cSpringGreen~&

Function cCyan~& ()
    cCyan = _RGB32(0, 255, 255)
End Function ' cCyan~&

Function cDeepSkyBlue~& ()
    cDeepSkyBlue = _RGB32(0, 191, 255)
End Function ' cDeepSkyBlue~&

Function cDodgerBlue~& ()
    cDodgerBlue = _RGB32(30, 144, 255)
End Function ' cDodgerBlue~&

Function cSeaBlue~& ()
    cSeaBlue = _RGB32(0, 64, 255)
End Function ' cSeaBlue~&

Function cBlue~& ()
    cBlue = _RGB32(0, 0, 255)
End Function ' cBlue~&

Function cBluePurple~& ()
    cBluePurple = _RGB32(64, 0, 255)
End Function ' cBluePurple~&

Function cDeepPurple~& ()
    cDeepPurple = _RGB32(96, 0, 255)
End Function ' cDeepPurple~&

Function cPurple~& ()
    cPurple = _RGB32(128, 0, 255)
End Function ' cPurple~&

Function cPurpleRed~& ()
    cPurpleRed = _RGB32(128, 0, 192)
End Function ' cPurpleRed~&

Function cDarkRed~& ()
    cDarkRed = _RGB32(160, 0, 64)
End Function ' cDarkRed~&

Function cBrickRed~& ()
    cBrickRed = _RGB32(192, 0, 32)
End Function ' cBrickRed~&

Function cDarkGreen~& ()
    cDarkGreen = _RGB32(0, 100, 0)
End Function ' cDarkGreen~&

Function cGreen~& ()
    cGreen = _RGB32(0, 128, 0)
End Function ' cGreen~&

Function cOliveDrab~& ()
    cOliveDrab = _RGB32(107, 142, 35)
End Function ' cOliveDrab~&

Function cLightPink~& ()
    cLightPink = _RGB32(255, 182, 193)
End Function ' cLightPink~&

Function cHotPink~& ()
    cHotPink = _RGB32(255, 105, 180)
End Function ' cHotPink~&

Function cDeepPink~& ()
    cDeepPink = _RGB32(255, 20, 147)
End Function ' cDeepPink~&

Function cMagenta~& ()
    cMagenta = _RGB32(255, 0, 255)
End Function ' cMagenta~&

Function cBlack~& ()
    cBlack = _RGB32(0, 0, 0)
End Function ' cBlack~&

Function cDimGray~& ()
    cDimGray = _RGB32(105, 105, 105)
End Function ' cDimGray~&

Function cGray~& ()
    cGray = _RGB32(128, 128, 128)
End Function ' cGray~&

Function cDarkGray~& ()
    cDarkGray = _RGB32(169, 169, 169)
End Function ' cDarkGray~&

Function cSilver~& ()
    cSilver = _RGB32(192, 192, 192)
End Function ' cSilver~&

Function cLightGray~& ()
    cLightGray = _RGB32(211, 211, 211)
End Function ' cLightGray~&

Function cGainsboro~& ()
    cGainsboro = _RGB32(220, 220, 220)
End Function ' cGainsboro~&

Function cWhiteSmoke~& ()
    cWhiteSmoke = _RGB32(245, 245, 245)
End Function ' cWhiteSmoke~&

Function cWhite~& ()
    cWhite = _RGB32(255, 255, 255)
    'cWhite = _RGB32(254, 254, 254)
End Function ' cWhite~&

Function cDarkBrown~& ()
    cDarkBrown = _RGB32(128, 64, 0)
End Function ' cDarkBrown~&

Function cLightBrown~& ()
    cLightBrown = _RGB32(196, 96, 0)
End Function ' cLightBrown~&

Function cKhaki~& ()
    cKhaki = _RGB32(240, 230, 140)
End Function ' cKhaki~&

Function cEmpty~& ()
    'cEmpty~& = -1
    cEmpty = _RGB32(0, 0, 0, 0)
End Function ' cEmpty~&

' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' END COLOR FUNCTIONS
' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

' ################################################################################################################################################################
' BEGIN BOX DRAWING ROUTINES
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////
' Draws multiple boxes on screen for no apparent reason
' (what did we use this for?)

Sub DrawBoxes (iNumBoxes%)
    Dim iColor%
    Dim iX%
    Dim iY%
    Dim iSize%

    iX% = 1
    iY% = 1
    iSize% = 20

    For iColor% = 1 To iNumBoxes%
        iX% = iX% + iSize%
        iY% = iY% + (iSize% * 2)
        DrawBoxSolid iX%, iY%, iSize%, iColor%
    Next iColor%

End Sub ' DrawBoxes

' /////////////////////////////////////////////////////////////////////////////
' DRAW A 2-D BOX (OUTLINE)
' https://www.qb64.org/wiki/LINE

Sub DrawBoxOutline (iX As Integer, iY As Integer, iSize As Integer, fgColor As _Unsigned Long)
    Line (iX, iY)-(iX + iSize, iY + iSize), fgColor, B ' Draw box outline
End Sub ' DrawBoxOutline

' /////////////////////////////////////////////////////////////////////////////
' DRAW A 2-D BOX (SOLID)
' https://www.qb64.org/wiki/LINE

' Renamed DrawBox/DrawBoxLine to DrawSolidBox

Sub DrawBoxSolid (iX As Integer, iY As Integer, iSize As Integer, fgColor As _Unsigned Long)
    Line (iX, iY)-(iX + iSize, iY + iSize), fgColor, BF ' Draw a solid box
End Sub ' DrawBoxSolid

' /////////////////////////////////////////////////////////////////////////////
' DRAW A 2-D RECTANGLE (OUTLINE)

Sub DrawRectOutline (iX As Integer, iY As Integer, iSizeW As Integer, iSizeH As Integer, fgColor As _Unsigned Long)
    Line (iX, iY)-(iX + iSizeW, iY + iSizeH), fgColor, B ' Draw rectangle outline
End Sub ' DrawRectOutline

' /////////////////////////////////////////////////////////////////////////////
' DRAW A 2-D RECTANGLE (SOLID)

Sub DrawRectSolid (iX As Integer, iY As Integer, iSizeW As Integer, iSizeH As Integer, fgColor As _Unsigned Long)
    Line (iX, iY)-(iX + iSizeW, iY + iSizeH), fgColor, BF ' Draw a solid rectangle
End Sub ' DrawRectSolid

' /////////////////////////////////////////////////////////////////////////////
' DRAW A 2-D BOX (OUTLINE)
' https://www.qb64.org/wiki/LINE

' The style parameter 0-255 doesn't seem to have a solid line?
' For that, use DrawOutlineBox.

' LINE [STEP] [(column1, row1)]-[STEP] (column2, row2), color[, [{B|BF}], style%]
' B creates a box outline with each side parallel to the program screen sides. BF creates a filled box.
' The style% signed INTEGER value sets a dotted pattern to draw the line or rectangle outline.

Sub DrawStyledOutlineBox (iX%, iY%, iSize%, iColor~&, iStyle%)
    Line (iX%, iY%)-(iX% + iSize%, iY% + iSize%), iColor~&, B , iStyle%
End Sub ' DrawStyledOutlineBox

' /////////////////////////////////////////////////////////////////////////////
' DRAW A 2-D BOX (OUTLINE) WITH A SOLID LINE

Sub DrawOutlineBox (iX%, iY%, iSize2%, iColor~&, iWeight2%)
    Dim iFromX%
    Dim iFromY%
    Dim iToX%
    Dim iToY%
    iSize% = iSize2% - 1
    iWeight% = iWeight2% - 1
    If iWeight% = 0 Then
        ' TOP LINE
        iFromX% = iX%
        iFromY% = iY%
        iToX% = iX% + iSize%
        iToY% = iY%
        Line (iFromX%, iFromY%)-(iToX%, iToY%), iColor~&, BF

        ' BOTTOM LINE
        iFromX% = iX%
        iFromY% = iY% + iSize%
        iToX% = iX% + iSize%
        iToY% = iY% + iSize%
        Line (iFromX%, iFromY%)-(iToX%, iToY%), iColor~&, BF

        ' LEFT LINE
        iFromX% = iX%
        iFromY% = iY%
        iToX% = iX%
        iToY% = iY% + iSize%
        Line (iFromX%, iFromY%)-(iToX%, iToY%), iColor~&, BF

        ' RIGHT LINE
        iFromX% = iX% + iSize%
        iFromY% = iY%
        iToX% = iX% + iSize%
        iToY% = iY% + iSize%
        Line (iFromX%, iFromY%)-(iToX%, iToY%), iColor~&, BF
    ElseIf iWeight% > 0 Then
        ' TOP LINE
        For iFromY% = iY% To (iY% + iWeight%)
            iFromX% = iX%
            'iFromY% = iY%
            iToX% = iX% + iSize%
            iToY% = iFromY%
            Line (iFromX%, iFromY%)-(iToX%, iToY%), iColor~&, BF
        Next iFromY%

        ' BOTTOM LINE
        For iFromY% = ((iY% + iSize%) - iWeight%) To (iY% + iSize%)
            iFromX% = iX%
            'iFromY% = iY% + iSize%
            iToX% = iX% + iSize%
            iToY% = iFromY%
            Line (iFromX%, iFromY%)-(iToX%, iToY%), iColor~&, BF
        Next iFromY%

        ' LEFT LINE
        For iFromX% = iX% To (iX% + iWeight%)
            'iFromX% = iX%
            iFromY% = iY%
            iToX% = iFromX%
            iToY% = iY% + iSize%
            Line (iFromX%, iFromY%)-(iToX%, iToY%), iColor~&, BF
        Next iFromX%

        ' RIGHT LINE
        For iFromX% = ((iX% + iSize%) - iWeight%) To (iX% + iSize%)
            'iFromX% = iX% + iSize%
            iFromY% = iY%
            iToX% = iFromX%
            iToY% = iY% + iSize%
            Line (iFromX%, iFromY%)-(iToX%, iToY%), iColor~&, BF
        Next iFromX%
    End If
End Sub ' DrawOutlineBox

' ################################################################################################################################################################
' END BOX DRAWING ROUTINES
' ################################################################################################################################################################

' ################################################################################################################################################################
' BEGIN MISC GRAPHICS ROUTINES
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////
' Fastest!

Sub DrawLeftArrowLine_8x8 (iX As Integer, iY As Integer, fgColor As _Unsigned Long)
    Dim iStartY As Integer: iStartY = iY + 3
    Line (iX, iStartY)-(iX + 7, iStartY), fgColor ', B ' B=outline, BF=solid
    Line (iX, iStartY)-(iX + 3, iY), fgColor ', B ' B=outline, BF=solid
    Line (iX, iStartY)-(iX + 3, iStartY + 3), fgColor ', B ' B=outline, BF=solid
End Sub ' DrawLeftArrowLine_8x8

' /////////////////////////////////////////////////////////////////////////////
' Second fastest after DrawLeftArrowLine.
' This uses PSET to draw the arrow pixel-by-pixel

' PSET (X, Y), Color
' draw will start where pset leaves off

Sub DrawLeftArrowPset_8x8 (iX As Long, iY As Long, fgColor As _Unsigned Long)
    Dim iLoopX As Integer
    Dim iLoopY As Integer
    For iLoopX = iX To iX + 7: PSet (iLoopX, iY), fgColor: Next iLoopX
    PSet (iX + 1, iY - 1), fgColor
    PSet (iX + 2, iY - 2), fgColor
    PSet (iX + 3, iY - 3), fgColor
    PSet (iX + 1, iY + 1), fgColor
    PSet (iX + 2, iY + 2), fgColor
    PSet (iX + 3, iY + 3), fgColor
End Sub ' DrawLeftArrowPset_8x8

' ################################################################################################################################################################
' END MISC GRAPHICS ROUTINES
' ################################################################################################################################################################

' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' BEGIN PLOTTING FUNCTIONS
' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

' /////////////////////////////////////////////////////////////////////////////
' OLD VERSION - REPLACE WITH PlotLine2D

' based on code from:
' Qbasic Programs - Download free bas source code
' http://www.thedubber.altervista.org/qbsrc.htm

Sub DrawTextLine (x%, y%, x2%, y2%, c$)
    'bError% = FALSE
    'LOCATE 2, 2: PRINT "(" + STR$(x%) + "," + STR$(y%) + ") to (" + STR$(x2%) + "," + STR$(y2%) + ") of " + CHR$(34) + c$ + CHR$(34);

    i% = 0
    steep% = 0
    e1% = 0
    If (x2% - x%) > 0 Then sx% = 1: Else sx% = -1
    dx% = Abs(x2% - x%)
    If (y2% - y%) > 0 Then sy% = 1: Else sy% = -1
    dy% = Abs(y2% - y%)
    If (dy% > dx%) Then
        steep% = 1
        Swap x%, y%
        Swap dx%, dy%
        Swap sx%, sy%
    End If
    e1% = 2 * dy% - dx%
    For i% = 0 To dx% - 1
        If steep% = 1 Then
            'PSET (y%, x%), c%:
            Locate y%, x%
            Print c$;
        Else
            'PSET (x%, y%), c%
            Locate x%, y%
            Print c$;
        End If

        While E% >= 0
            y% = y% + sy%: e1% = e1% - 2 * dx%
        Wend
        x% = x% + sx%: e1% = e1% + 2 * dy%
    Next
    'PSET (x2%, y2%), c%
    Locate x2%, y2%
    Print c$;

End Sub ' DrawTextLine

' /////////////////////////////////////////////////////////////////////////////
' Based on "BRESNHAM.BAS" by Kurt Kuzba. (4/16/96)
' From: http://www.thedubber.altervista.org/qbsrc.htm

Sub PlotLine2D (x1a%, y1a%, x2a%, y2a%, MyArray() As _Byte)
    Dim iLoop%
    Dim steep%: steep% = 0
    Dim ev%: ev% = 0
    Dim sx%
    Dim sy%
    Dim dx%
    Dim dy%

    ' GET PARAMETERS
    Dim x1%: x1% = x1a%
    Dim y1%: y1% = y1a%
    Dim x2%: x2% = x2a%
    Dim y2%: y2% = y2a%

    ' FOR RETURN ARRAY
    Dim iMinX%
    Dim iMaxX%
    Dim iMinY%
    Dim iMaxY%
    ReDim MyArray(-1, -1) As _Byte

    ' CLEANUP INPUT
    x1% = Abs(x1%)
    y1% = Abs(y1%)
    x2% = Abs(x2%)
    y2% = Abs(y2%)

    ' SETUP RETURN ARRAY
    If x1% > x2% Then
        iMinX% = x2%
        iMaxX% = x1%
    Else
        iMinX% = x1%
        iMaxX% = x2%
    End If
    If y1% > y2% Then
        iMinY% = y2%
        iMaxY% = y1%
    Else
        iMinY% = y1%
        iMaxY% = y2%
    End If

    If iMinX% > 0 Then iMinX% = 1
    If iMinY% > 0 Then iMinY% = 1

    ReDim MyArray(iMinX% To iMaxX%, iMinY% To iMaxY%) As _Byte
    For sy% = iMinY% To iMaxY%
        For sx% = iMinX% To iMaxX%
            MyArray(sx%, sy%) = 0
        Next sx%
    Next sy%

    ' DRAW THE LINE
    If (x2% - x1%) > 0 Then
        sx% = 1
    Else
        sx% = -1
    End If

    dx% = Abs(x2% - x1%)
    If (y2% - y1%) > 0 Then
        sy% = 1
    Else
        sy% = -1
    End If

    dy% = Abs(y2% - y1%)
    If (dy% > dx%) Then
        steep% = 1
        Swap x1%, y1%
        Swap dx%, dy%
        Swap sx%, sy%
    End If

    ev% = 2 * dy% - dx%
    For iLoop% = 0 To dx% - 1
        If steep% = 1 Then
            '''PSET (y1%, x1%), c%:
            ''LOCATE y1%, x1%
            ''PRINT c$;
            'PlotPoint y1%, x1%, c$, MyArray()
            MyArray(y1%, x1%) = 1
        Else
            '''PSET (x1%, y1%), c%
            ''LOCATE x1%, y1%
            ''PRINT c$;
            'PlotPoint x1%, y1%, c$, MyArray()
            MyArray(x1%, y1%) = 1
        End If

        While ev% >= 0
            y1% = y1% + sy%
            ev% = ev% - 2 * dx%
        Wend
        x1% = x1% + sx%
        ev% = ev% + 2 * dy%
    Next iLoop%
    '''PSET (x2%, y2%), c%
    ''LOCATE x2%, y2%
    ''PRINT c$;
    'PlotPoint x2%, y2%, c$, MyArray()
    MyArray(x2%, y2%) = 1

End Sub ' PlotLine2D

' /////////////////////////////////////////////////////////////////////////////

Function PlotLine2DTest$
    Dim x1%
    Dim y1%
    Dim x2%
    Dim y2%
    Dim sLine As String
    Dim in$
    ReDim MyArray(-1, -1) As _Byte

    Do
        Cls
        Input "ENTER x1,y1,x2,y2 TO PLOT A LINE OR 0 TO EXIT? "; x1%, y1%, x2%, y2%
        If x1% = 0 Then Exit Do

        PlotLine2D x1%, y1%, x2%, y2%, MyArray()

        ' number columns at top
        sLine = "  "
        For x1% = LBound(MyArray, 1) To UBound(MyArray, 1)
            sLine = sLine + Left$(Right$(" " + cstr$(x1%), 2), 1)
        Next x1%
        Print sLine
        sLine = "  "
        For x1% = LBound(MyArray, 1) To UBound(MyArray, 1)
            sLine = sLine + Right$(cstr$(x1%), 1)
        Next x1%
        Print sLine

        ' show array
        For y1% = LBound(MyArray, 2) To UBound(MyArray, 2)
            sLine = Right$(" " + cstr$(y1%), 2) ' number rows on left
            For x1% = LBound(MyArray, 1) To UBound(MyArray, 1)
                If MyArray(x1%, y1%) = 0 Then
                    sLine = sLine + " "
                Else
                    sLine = sLine + "#"
                End If
            Next x1%
            sLine = sLine + cstr$(y1%) ' number rows on right
            Print sLine
        Next y1%

        ' number columns on bottom
        sLine = "  "
        For x1% = LBound(MyArray, 1) To UBound(MyArray, 1)
            sLine = sLine + Right$(cstr$(x1%), 1)
        Next x1%
        Print sLine
        sLine = "  "
        For x1% = LBound(MyArray, 1) To UBound(MyArray, 1)
            sLine = sLine + Left$(Right$(" " + cstr$(x1%), 2), 1)
        Next x1%
        Print sLine

        ' pause
        Print
        Input "PRESS <ENTER> TO CONTINUE"; in$

    Loop

End Function ' PlotLine2DTest$

' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' END PLOTTING FUNCTIONS
' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




















' ################################################################################################################################################################
' BEGIN _UNSIGNED LONG DICTIONARY ROUTINES
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////

Sub InitULDictionary (arrDict() As ULDictionary)
    ReDim arrDict(-1) As ULDictionary
    'arrDict(0).Value = 0
End Sub ' InitULDictionary

' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function SaveULDictionary% (arrDict() As ULDictionary, sKey As String, ulngValue As _Unsigned Long)
    Dim iLoop As Integer
    Dim iIndex As Integer
    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            'PRINT "debug a1: found key " + CHR$(34) + LCASE$(sKey) + CHR$(34)
            iIndex = iLoop
            Exit For
        End If
    Next iLoop
    If (iIndex > -1) Then
        ' KEY EXISTS, UPDATE VALUE
        'PRINT "debug a2: key exists, updating value to " + cstr$(ulngValue)

        arrDict(iIndex).Value = ulngValue
        SaveULDictionary% = TRUE
    Else
        ' KEY DOESN'T EXIST, ADD IT

        ' IS THERE ROOM?
        iIndex = UBound(arrDict) + 1
        If iIndex > cIntDictMax Then
            ' DICTIONARY FULL!
            SaveULDictionary% = FALSE
        Else
            ' ADD VALUE AND KEY
            ReDim _Preserve arrDict(iIndex) As ULDictionary
            arrDict(iIndex).Value = ulngValue
            arrDict(iIndex).Key = sKey
            SaveULDictionary% = TRUE
        End If
    End If
End Function ' SaveULDictionary%

' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function SaveULDictionaryCaseSensitive% (arrDict() As ULDictionary, sKey As String, ulngValue As _Unsigned Long)
    Dim iLoop As Integer
    Dim iIndex As Integer
    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            'PRINT "debug a1: found key " + CHR$(34) + LCASE$(sKey) + CHR$(34)
            iIndex = iLoop
            Exit For
        End If
    Next iLoop
    If (iIndex > -1) Then
        ' KEY EXISTS, UPDATE VALUE
        'PRINT "debug a2: key exists, updating value to " + cstr$(ulngValue)
        arrDict(iIndex).Value = ulngValue
        SaveULDictionaryCaseSensitive% = TRUE
    Else
        ' KEY DOESN'T EXIST, ADD IT

        ' IS THERE ROOM?
        iIndex = UBound(arrDict) + 1
        If iIndex > cIntDictMax Then
            ' DICTIONARY FULL!
            SaveULDictionaryCaseSensitive% = FALSE
        Else
            ' ADD VALUE AND KEY
            ReDim _Preserve arrDict(iIndex) As ULDictionary

            arrDict(iIndex).Value = ulngValue
            arrDict(iIndex).Key = sKey

            SaveULDictionaryCaseSensitive% = TRUE
        End If
    End If
End Function ' SaveULDictionaryCaseSensitive%

' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function FoundULDictionaryKey% (arrDict() As ULDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    FoundULDictionaryKey% = iIndex
End Function ' FoundULDictionaryKey%

' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function FoundULDictionaryKeyCaseSensitive% (arrDict() As ULDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    FoundULDictionaryKeyCaseSensitive% = iIndex
End Function ' FoundULDictionaryKeyCaseSensitive%


' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function DeleteULDictionaryKey% (arrDict() As ULDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer
    Dim bResult As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        If iIndex < UBound(arrDict) Then
            For iLoop = (UBound(arrDict) - 1) To iIndex Step -1
                arrDict(iLoop).Key = arrDict(iLoop + 1).Key
                arrDict(iLoop).Value = arrDict(iLoop + 1).Value
            Next iLoop
        End If
        ReDim _Preserve arrDict(UBound(arrDict) - 1) As ULDictionary
        bResult = TRUE
    Else
        bResult = FALSE
    End If

    DeleteULDictionaryKey% = bResult
End Function ' DeleteULDictionaryKey%

' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function DeleteULDictionaryKeyCaseSensitive% (arrDict() As ULDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer
    Dim bResult As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        If iIndex < UBound(arrDict) Then
            For iLoop = (UBound(arrDict) - 1) To iIndex Step -1
                arrDict(iLoop).Key = arrDict(iLoop + 1).Key
                arrDict(iLoop).Value = arrDict(iLoop + 1).Value
            Next iLoop
        End If
        ReDim _Preserve arrDict(UBound(arrDict) - 1) As ULDictionary
        bResult = TRUE
    Else
        bResult = FALSE
    End If

    DeleteULDictionaryKeyCaseSensitive% = bResult
End Function ' DeleteULDictionaryKeyCaseSensitive%

' /////////////////////////////////////////////////////////////////////////////

Function DumpULDictionary$ (arrDict() As ULDictionary)
    Dim iLoop As Integer
    Dim sResult As String
    sResult = ""
    sResult = sResult + "ULDictionary size: " + cstr$(UBound(arrDict) + 1) + Chr$(13)
    For iLoop = 0 To UBound(arrDict)
        sResult = sResult + "Item(" + Chr$(34) + arrDict(iLoop).Key + Chr$(34) + ") = " + cstrul$(arrDict(iLoop).Value) + Chr$(13)
    Next iLoop
    DumpULDictionary$ = sResult
End Function ' DumpULDictionary$

' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function ReadULDictionary~& (arrDict() As ULDictionary, sKey As String, ulDefault As _Unsigned Long)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        ReadULDictionary~& = arrDict(iIndex).Value
    Else
        ReadULDictionary~& = ulDefault
    End If
End Function ' ReadULDictionary~&


' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function ReadULDictionaryCaseSensitive~& (arrDict() As ULDictionary, sKey As String, ulDefault As _Unsigned Long)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        ReadULDictionaryCaseSensitive~& = arrDict(iIndex).Value
    Else
        ReadULDictionaryCaseSensitive~& = ulDefault
    End If
End Function ' ReadULDictionaryCaseSensitive~&

' ################################################################################################################################################################
' END _UNSIGNED LONG DICTIONARY ROUTINES
' ################################################################################################################################################################

' ################################################################################################################################################################
' BEGIN LONG DICTIONARY ROUTINES
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////

Sub InitLongDictionary (arrDict() As LongDictionary)
    ReDim arrDict(-1) As LongDictionary
    'arrDict(0).Value = 0
End Sub ' InitLongDictionary

' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function SaveLongDictionary% (arrDict() As LongDictionary, sKey As String, lngValue As Long)
    Dim iLoop As Integer
    Dim iIndex As Integer
    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            'PRINT "debug a1: found key " + CHR$(34) + LCASE$(sKey) + CHR$(34)
            iIndex = iLoop
            Exit For
        End If
    Next iLoop
    If (iIndex > -1) Then
        ' KEY EXISTS, UPDATE VALUE
        'PRINT "debug a2: key exists, updating value to " + cstr$(lngValue)

        arrDict(iIndex).Value = lngValue
        SaveLongDictionary% = TRUE
    Else
        ' KEY DOESN'T EXIST, ADD IT

        ' IS THERE ROOM?
        iIndex = UBound(arrDict) + 1
        If iIndex > cIntDictMax Then
            ' DICTIONARY FULL!
            SaveLongDictionary% = FALSE
        Else
            ' ADD VALUE AND KEY
            ReDim _Preserve arrDict(iIndex) As LongDictionary
            arrDict(iIndex).Value = lngValue
            arrDict(iIndex).Key = sKey
            SaveLongDictionary% = TRUE
        End If
    End If
End Function ' SaveLongDictionary%

' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function SaveLongDictionaryCaseSensitive% (arrDict() As LongDictionary, sKey As String, lngValue As Long)
    Dim iLoop As Integer
    Dim iIndex As Integer
    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            'PRINT "debug a1: found key " + CHR$(34) + LCASE$(sKey) + CHR$(34)
            iIndex = iLoop
            Exit For
        End If
    Next iLoop
    If (iIndex > -1) Then
        ' KEY EXISTS, UPDATE VALUE
        'PRINT "debug a2: key exists, updating value to " + cstr$(lngValue)
        arrDict(iIndex).Value = lngValue
        SaveLongDictionaryCaseSensitive% = TRUE
    Else
        ' KEY DOESN'T EXIST, ADD IT

        ' IS THERE ROOM?
        iIndex = UBound(arrDict) + 1
        If iIndex > cIntDictMax Then
            ' DICTIONARY FULL!
            SaveLongDictionaryCaseSensitive% = FALSE
        Else
            ' ADD VALUE AND KEY
            ReDim _Preserve arrDict(iIndex) As LongDictionary

            arrDict(iIndex).Value = lngValue
            arrDict(iIndex).Key = sKey

            SaveLongDictionaryCaseSensitive% = TRUE
        End If
    End If
End Function ' SaveLongDictionaryCaseSensitive%

' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function FoundLongDictionaryKey% (arrDict() As LongDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    FoundLongDictionaryKey% = iIndex
End Function ' FoundLongDictionaryKey%

' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function FoundLongDictionaryKeyCaseSensitive% (arrDict() As LongDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    FoundLongDictionaryKeyCaseSensitive% = iIndex
End Function ' FoundLongDictionaryKeyCaseSensitive%


' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function DeleteLongDictionaryKey% (arrDict() As LongDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer
    Dim bResult As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        If iIndex < UBound(arrDict) Then
            For iLoop = (UBound(arrDict) - 1) To iIndex Step -1
                arrDict(iLoop).Key = arrDict(iLoop + 1).Key
                arrDict(iLoop).Value = arrDict(iLoop + 1).Value
            Next iLoop
        End If
        ReDim _Preserve arrDict(UBound(arrDict) - 1) As LongDictionary
        bResult = TRUE
    Else
        bResult = FALSE
    End If

    DeleteLongDictionaryKey% = bResult
End Function ' DeleteLongDictionaryKey%

' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function DeleteLongDictionaryKeyCaseSensitive% (arrDict() As LongDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer
    Dim bResult As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        If iIndex < UBound(arrDict) Then
            For iLoop = (UBound(arrDict) - 1) To iIndex Step -1
                arrDict(iLoop).Key = arrDict(iLoop + 1).Key
                arrDict(iLoop).Value = arrDict(iLoop + 1).Value
            Next iLoop
        End If
        ReDim _Preserve arrDict(UBound(arrDict) - 1) As LongDictionary
        bResult = TRUE
    Else
        bResult = FALSE
    End If

    DeleteLongDictionaryKeyCaseSensitive% = bResult
End Function ' DeleteLongDictionaryKeyCaseSensitive%

' /////////////////////////////////////////////////////////////////////////////

Function DumpLongDictionary$ (arrDict() As LongDictionary)
    Dim iLoop As Integer
    Dim sResult As String
    sResult = ""
    sResult = sResult + "LongDictionary size: " + cstr$(UBound(arrDict) + 1) + Chr$(13)
    For iLoop = 0 To UBound(arrDict)
        sResult = sResult + "Item(" + Chr$(34) + arrDict(iLoop).Key + Chr$(34) + ") = " + cstrl$(arrDict(iLoop).Value) + Chr$(13)
    Next iLoop
    DumpLongDictionary$ = sResult
End Function ' DumpLongDictionary$

' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function ReadLongDictionary% (arrDict() As LongDictionary, sKey As String, iDefault As Integer)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        ReadLongDictionary% = arrDict(iIndex).Value
    Else
        ReadLongDictionary% = iDefault
    End If
End Function ' ReadLongDictionary%


' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function ReadLongDictionaryCaseSensitive% (arrDict() As LongDictionary, sKey As String, iDefault As Integer)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        ReadLongDictionaryCaseSensitive% = arrDict(iIndex).Value
    Else
        ReadLongDictionaryCaseSensitive% = iDefault
    End If
End Function ' ReadLongDictionaryCaseSensitive%

' ################################################################################################################################################################
' END LONG DICTIONARY ROUTINES
' ################################################################################################################################################################

' ################################################################################################################################################################
' BEGIN INTEGER DICTIONARY ROUTINES
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////

Sub InitIntDictionary (arrDict() As IntDictionary)
    ReDim arrDict(-1) As IntDictionary
    'arrDict(0).Value = 0
End Sub ' InitIntDictionary

' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function SaveIntDictionary% (arrDict() As IntDictionary, sKey As String, iValue As Integer)
    Dim iLoop As Integer
    Dim iIndex As Integer
    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            'PRINT "debug a1: found key " + CHR$(34) + LCASE$(sKey) + CHR$(34)
            iIndex = iLoop
            Exit For
        End If
    Next iLoop
    If (iIndex > -1) Then
        ' KEY EXISTS, UPDATE VALUE
        'PRINT "debug a2: key exists, updating value to " + cstr$(iValue)

        arrDict(iIndex).Value = iValue
        SaveIntDictionary% = TRUE
    Else
        ' KEY DOESN'T EXIST, ADD IT

        ' IS THERE ROOM?
        iIndex = UBound(arrDict) + 1
        If iIndex > cIntDictMax Then
            ' DICTIONARY FULL!
            SaveIntDictionary% = FALSE
        Else
            ' ADD VALUE AND KEY
            ReDim _Preserve arrDict(iIndex) As IntDictionary
            arrDict(iIndex).Value = iValue
            arrDict(iIndex).Key = sKey
            SaveIntDictionary% = TRUE
        End If
    End If
End Function ' SaveIntDictionary%

' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function SaveIntDictionaryCaseSensitive% (arrDict() As IntDictionary, sKey As String, iValue As Integer)
    Dim iLoop As Integer
    Dim iIndex As Integer
    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            'PRINT "debug a1: found key " + CHR$(34) + LCASE$(sKey) + CHR$(34)
            iIndex = iLoop
            Exit For
        End If
    Next iLoop
    If (iIndex > -1) Then
        ' KEY EXISTS, UPDATE VALUE
        'PRINT "debug a2: key exists, updating value to " + cstr$(iValue)

        arrDict(iIndex).Value = iValue
        SaveIntDictionaryCaseSensitive% = TRUE
    Else
        ' KEY DOESN'T EXIST, ADD IT

        ' IS THERE ROOM?
        iIndex = UBound(arrDict) + 1
        If iIndex > cIntDictMax Then
            ' DICTIONARY FULL!
            SaveIntDictionaryCaseSensitive% = FALSE
        Else
            ' ADD VALUE AND KEY
            ReDim _Preserve arrDict(iIndex) As IntDictionary
            arrDict(iIndex).Value = iValue
            arrDict(iIndex).Key = sKey
            SaveIntDictionaryCaseSensitive% = TRUE
        End If
    End If
End Function ' SaveIntDictionaryCaseSensitive%

' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function FoundIntDictionaryKey% (arrDict() As IntDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    FoundIntDictionaryKey% = iIndex
End Function ' FoundIntDictionaryKey%

' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function FoundIntDictionaryKeyCaseSensitive% (arrDict() As IntDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    FoundIntDictionaryKeyCaseSensitive% = iIndex
End Function ' FoundIntDictionaryKeyCaseSensitive%


' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function DeleteIntDictionaryKey% (arrDict() As IntDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer
    Dim bResult As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        If iIndex < UBound(arrDict) Then
            For iLoop = (UBound(arrDict) - 1) To iIndex Step -1
                arrDict(iLoop).Key = arrDict(iLoop + 1).Key
                arrDict(iLoop).Value = arrDict(iLoop + 1).Value
            Next iLoop
        End If
        ReDim _Preserve arrDict(UBound(arrDict) - 1) As IntDictionary
        bResult = TRUE
    Else
        bResult = FALSE
    End If

    DeleteIntDictionaryKey% = bResult
End Function ' DeleteIntDictionaryKey%

' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function DeleteIntDictionaryKeyCaseSensitive% (arrDict() As IntDictionary, sKey As String)
    Dim iLoop As Integer
    Dim iIndex As Integer
    Dim bResult As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        If iIndex < UBound(arrDict) Then
            For iLoop = (UBound(arrDict) - 1) To iIndex Step -1
                arrDict(iLoop).Key = arrDict(iLoop + 1).Key
                arrDict(iLoop).Value = arrDict(iLoop + 1).Value
            Next iLoop
        End If
        ReDim _Preserve arrDict(UBound(arrDict) - 1) As IntDictionary
        bResult = TRUE
    Else
        bResult = FALSE
    End If

    DeleteIntDictionaryKeyCaseSensitive% = bResult
End Function ' DeleteIntDictionaryKeyCaseSensitive%

' /////////////////////////////////////////////////////////////////////////////

Function DumpIntDictionary$ (arrDict() As IntDictionary)
    Dim iLoop As Integer
    Dim sResult As String
    sResult = ""
    sResult = sResult + "IntDictionary size: " + cstr$(UBound(arrDict) + 1) + Chr$(13)
    For iLoop = 0 To UBound(arrDict)
        sResult = sResult + "Item(" + Chr$(34) + arrDict(iLoop).Key + Chr$(34) + ") = " + cstr$(arrDict(iLoop).Value) + Chr$(13)
    Next iLoop
    DumpIntDictionary$ = sResult
End Function ' DumpIntDictionary$

' /////////////////////////////////////////////////////////////////////////////
' Key is NOT case-sensitive: eg "a" = "A"

Function ReadIntDictionary% (arrDict() As IntDictionary, sKey As String, iDefault As Integer)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If LCase$(arrDict(iLoop).Key) = LCase$(sKey) Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        ReadIntDictionary% = arrDict(iIndex).Value
    Else
        ReadIntDictionary% = iDefault
    End If
End Function ' ReadIntDictionary%


' /////////////////////////////////////////////////////////////////////////////
' Key is case-sensitive: eg "a" <> "A"

Function ReadIntDictionaryCaseSensitive% (arrDict() As IntDictionary, sKey As String, iDefault As Integer)
    Dim iLoop As Integer
    Dim iIndex As Integer

    iIndex = -1
    For iLoop = 0 To UBound(arrDict)
        If arrDict(iLoop).Key = sKey Then
            iIndex = iLoop
            Exit For
        End If
    Next iLoop

    If (iIndex > -1) Then
        ReadIntDictionaryCaseSensitive% = arrDict(iIndex).Value
    Else
        ReadIntDictionaryCaseSensitive% = iDefault
    End If
End Function ' ReadIntDictionaryCaseSensitive%

' ################################################################################################################################################################
' END INTEGER DICTIONARY ROUTINES
' ################################################################################################################################################################

' ################################################################################################################################################################
' BEGIN HELPER ROUTINES #HELPER
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////
' div: int1% = num1% \ den1%
' mod: rem1% = num1% MOD den1%

Function NextColorIndex% (iX As Integer, iY As Integer)
    Dim iIndex As Integer
    Dim iAdd As Integer
    ''iOut = (iX MOD 8) + 1
    ''iAdd = (iY MOD 8)
    'iOut = (iX MOD 8)
    'iAdd = (iY MOD 8)
    iOut = (iX Mod 4)
    iAdd = (iY Mod 4)
    NextColorIndex% = iOut + iAdd + 1
End Function ' NextColorIndex%

' /////////////////////////////////////////////////////////////////////////////
' TEST OUTPUT OF NextColorIndex

Sub NextColorIndexTest
    Dim iX%, iY%
    Dim iColor%
    Dim iMin%
    Dim iMax%
    'dim sLine$
    Dim in$
    Cls
    iMin% = 0: iMax% = 0
    For iY% = 1 To 80
        sLine$ = ""
        For iX% = 1 To 80
            iColor% = NextColorIndex%(iX%, iY%)
            If iColor% < iMin% Then iMin% = iColor%
            If iColor% > iMax% Then iMax% = iColor%
            'sLine$ = sLine$ + _Trim$(Str$(iColor%)) + " "
            'print _Trim$(Str$(iColor%)) + " ";
        Next iX%
        'print sLine$
    Next iY%
    Print "Min: " + _Trim$(Str$(iMin%))
    Print "Max: " + _Trim$(Str$(iMax%))
    Input "press any key to continue"; in$
End Sub ' NextColorIndexTest

' ################################################################################################################################################################
' END HELPER ROUTINES @HELPER
' ################################################################################################################################################################

' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' BEGIN TIMESTAMP FUNCTIONS
' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

' /////////////////////////////////////////////////////////////////////////////
' QB64 equivalent of the Visual Basic / VBA DateDiff function.

' See:
' Microsoft > Office VBA Reference > DateDiff function
' https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/datediff-function

' Receives:
' interval$ = String expression that is the interval of time you use
'             to calculate the difference between date1$ and date2$,
'             and can be one of the following values:
'             SETTING   DESCRIPTION   COMMENT
'             -------   -----------   -------------------
'             yyyy      Year          (NOT SUPPORTED YET)
'             q         Quarter       (NOT SUPPORTED YET)
'             m         Month         (NOT SUPPORTED YET)
'             y         Day of year   (NOT SUPPORTED YET)
'             d         Day
'             w         Weekday       (NOT SUPPORTED YET)
'             ww        Week          (NOT SUPPORTED YET)
'             h         Hour
'             n         Minute
'             s         Second
'
' date1##, date2## = Two dates you want to use in the calculation,
'                    in UNIX time (# seconds elapsed since 1/1/1970 12:00:00 AM GMT),
'                    we assume the dates are timezone-corrected.

' Returns an _Float specifying the number of time intervals between
' two specified dates.

Function DateDiff## (interval$, fDate1##, fDate2##)
    Dim fResult As _Float: fResult = 0
    Dim fDiffSeconds As _Float
   
    fDiffSeconds = fDate2## - fDate1##
   
    Select Case interval$
        Case "yyyy":
            ' Year = UNDER CONSTRUCTION
        Case "q":
            ' Quarter = UNDER CONSTRUCTION
        Case "m":
            ' Month = UNDER CONSTRUCTION
        Case "y":
            ' Day of year = UNDER CONSTRUCTION
        Case "d":
            ' Get # of days
            fResult = (fDiffSeconds \ 86400)
        Case "w":
            ' Weekday = UNDER CONSTRUCTION
        Case "ww":
            ' Week = UNDER CONSTRUCTION
        Case "h":
            ' Get # of hours
            fResult = (fDiffSeconds \ 3600)
        Case "n":
            ' get # of minutes
            fResult = (fDiffSeconds \ 60)
        Case "s":
            ' get # of seconds
            fResult = fDiffSeconds
        Case Else:
            ' Unknown
    End Select
   
    DateDiff## = fResult
End Function ' DateDiff##

' /////////////////////////////////////////////////////////////////////////////

Sub DateDiffTest
    Dim in$
    Cls
    Print "Demonstration of Function DateDiff## (interval$, fDate1##, fDate2##)"
    Print "--------------------------------------------------------------------"
    DateDiffTest1 "s", "07-04-2022 12:00:00 PM", "07-04-2022 12:00:45 PM" ' 45s
    DateDiffTest1 "s", "07/04/2022 12:00:00 PM", "07/04/2022 12:00:45 PM" ' 45s
    DateDiffTest1 "s", "07-04-2022 12:00:00", "07-04-2022 12:00:45" ' 45s
    DateDiffTest1 "s", "07/04/2022 12:00:00", "07/04/2022 12:00:45" ' 45s
    Print
    DateDiffTest1 "n", "07-04-2022 12:00:00 PM", "07-04-2022 12:12:34 PM" ' 754s
    DateDiffTest1 "n", "07/04/2022 12:00:00 PM", "07/04/2022 12:12:34 PM" ' 754s
    DateDiffTest1 "n", "07-04-2022 12:00:00", "07-04-2022 12:12:34" ' 754s
    DateDiffTest1 "n", "07/04/2022 12:00:00", "07/04/2022 12:12:34" ' 754s
    Print
    DateDiffTest1 "h", "07-04-2022 12:00:00 PM", "07-04-2022 01:15:43 PM" ' 47743s
    DateDiffTest1 "h", "07/04/2022 12:00:00 PM", "07/04/2022 01:15:43 PM" ' 47743s  1:15:43
    DateDiffTest1 "h", "07-04-2022 12:00:00", "07-04-2022 13:15:43" ' 4543s 1:15:43
    DateDiffTest1 "h", "07/04/2022 12:00:00", "07/04/2022 13:15:43" ' 4543s 1:15:43
    Print
    DateDiffTest1 "d", "07-04-2022 12:00:00 PM", "07-05-2022 01:15:43 PM" ' 134143s
    DateDiffTest1 "d", "07/04/2022 12:00:00 PM", "07/05/2022 01:15:43 PM" ' 134143s 1:15:43
    DateDiffTest1 "d", "07-04-2022 12:00:00", "07-05-2022 13:15:43" ' 94543s 26:15:43
    DateDiffTest1 "d", "07/04/2022 12:00:00", "07/05/2022 13:15:43" ' 94543s 26:15:43
    Input "PRESS ENTER TO CONTINUE"; in$
End Sub ' DateDiffTest

' /////////////////////////////////////////////////////////////////////////////

Sub DateDiffTest1 (interval$, date1$, date2$)
    Dim fDiff As _Float
    Dim sInterval As String
    sInterval = GetTimeIntervalName$(interval$)
    fDiff = DateDiff##(interval$, GetUnixTime##(date1$), GetUnixTime##(date2$))
    Print _
        StrPadLeft$(_Trim$(Str$(fDiff)), 8) + " " + _
        StrPadRight$(sInterval, 7) + " " + _
        "elapsed between " + _
        StrPadRight$(date1$, 22) + " and " + _
        StrPadRight$(date2$, 22)
End Sub ' DateDiffTest1

' /////////////////////////////////////////////////////////////////////////////

Sub DateDiffSanityTest1 (interval$, date1$, date2$)
    Dim fDate1 As _Float
    Dim fDate2 As _Float
    fDate1 = GetUnixTime##(date1$)
    fDate2 = GetUnixTime##(date2$)
    Print StrPadRight$(date1$, 22) + " = " + StrPadRight$(_Trim$(Str$(fDate1)), 12) + " seconds"
    Print StrPadRight$(date2$, 22) + " = " + StrPadRight$(_Trim$(Str$(fDate2)), 12) + " seconds"
    Print StrPadRight$("", 22) + "   " + StrPadRight$(_Trim$(Str$(fDate2 - fDate1)), 12) + " seconds difference"
    Print
End Sub ' DateDiffSanityTest1

' /////////////////////////////////////////////////////////////////////////////
' Receives:
' fSeconds = time period in seconds

' Returns:
' The time period in the format "{days} days, {hours} hours, {minutes} minutes, {seconds} seconds"

' TODO:
' Add support for years, months, weeks

Function GetElapsedTime$ (fElapsedSeconds As _Float)
    Dim sResult As String: sResult = ""
    Dim fSeconds As _Float
    Dim iDays As _Integer64
    Dim iHours As Integer
    Dim iMinutes As Integer
    Dim iSeconds As Integer
    Dim sSign As String
   
    ' Handle negative values
    If Sgn(fElapsedSeconds) = -1 Then
        fSeconds = 0 - fElapsedSeconds
        sSign = "-"
    Else
        fSeconds = fElapsedSeconds
        sSign = ""
    End If
   
    ' Get # of days
    iDays = fSeconds \ 86400
   
    ' Get # of hours
    fSeconds = fSeconds - (iDays * 86400)
    iHours = fSeconds \ 3600
   
    ' get # of minutes
    fSeconds = fSeconds - (iHours * 3600)
    iMinutes = fSeconds \ 60
   
    ' get # of seconds
    fSeconds = fSeconds - (iMinutes * 60)
    iSeconds = Int(fSeconds)
   
    ' Assemble output
    If (iDays > 0) Then sResult = _Trim$(Str$(iDays)) + " days"
    If (iHours > 0) Then sResult = AppendString$(sResult, _Trim$(Str$(iHours)) + " hours", ", ")
    If (iMinutes > 0) Then sResult = AppendString$(sResult, _Trim$(Str$(iMinutes)) + " minutes", ", ")
    If (iSeconds > 0) Then sResult = AppendString$(sResult, _Trim$(Str$(iSeconds)) + " seconds", ", ")
    sResult = sSign + sResult
   
    ' Return result
    GetElapsedTime$ = sResult
End Function ' GetElapsedTime$

' /////////////////////////////////////////////////////////////////////////////
' Based on "Test Steve timeStamp" by SMcNeill & bplus
' https://www.qb64.org/forum/index.php?topic=1638.30
' https://www.qb64.org/forum/index.php?topic=1638.msg108650#msg108650

Sub GetElapsedTimeTest1
    ReDim arrDateTime$(-1)
    Dim iLoop1 As Integer
    Dim iLoop2 As Integer
    Dim MyDateTime1$
    Dim MyDateTime2$
    Dim iYear As Integer
    Dim MyDate1$
    Dim MyDate2$
    Dim fSeconds1 As _Float
    Dim fSeconds2 As _Float
    Dim fDiffSeconds As _Float
    Dim in$
   
    Cls
    Print "Demonstration of Function GetElapsedTime$ (fElapsedSeconds As _Float)"
    Print "---------------------------------------------------------------------"
   
    ' TEST DATES
    AppendToStringArray arrDateTime$(), "01-01-0966 00:00:00"
    AppendToStringArray arrDateTime$(), "01-01-1815 00:00:00"
    AppendToStringArray arrDateTime$(), "01-01-1970 00:00:00"
    AppendToStringArray arrDateTime$(), "01-01-2020 00:00:00"
    AppendToStringArray arrDateTime$(), "01-01-2020 12:00:00 AM"
    AppendToStringArray arrDateTime$(), "01-01-2020 12:00:00 PM"
    AppendToStringArray arrDateTime$(), "01-01-2020 01:00:00 PM"
    AppendToStringArray arrDateTime$(), "01-01-2020 11:59:59 PM"
    AppendToStringArray arrDateTime$(), "01-02-2020 12:00:00 AM"
    AppendToStringArray arrDateTime$(), "07-27-2022 12:00:00 PM"
    AppendToStringArray arrDateTime$(), "07-27-2022 06:00:00 PM"
    AppendToStringArray arrDateTime$(), "07-28-2022 00:00:00"
    AppendToStringArray arrDateTime$(), "01-01-2023 00:00:00"
    AppendToStringArray arrDateTime$(), "01-01-2525 00:00:00"
   
    ' GET CURRENT DATE/TIME
    MyDateTime1$ = GetCurrentDateTime$("{mm}/{dd}/{yyyy} {hh}:{nn}:{ss} {ampm}")
    fSeconds1 = GetUnixTime##(MyDateTime1$)
    Print "Current date/time is " + MyDateTime1$ + " = " + _Trim$(Str$(fSeconds1)) + " seconds"
    Print
   
    ' COMPARE TEST DATES
    For iLoop1 = LBound(arrDateTime$) To UBound(arrDateTime$)
        MyDateTime2$ = arrDateTime$(iLoop1)
        fSeconds2 = GetUnixTime##(MyDateTime2$)
        fDiffSeconds = fSeconds1 - fSeconds2
       
        Print _
            StrPadRight$(MyDateTime1$, 22) + _
            " - " + _
            StrPadRight$(MyDateTime2$, 22) + _
            " = " + _
            StrPadRight$(_Trim$(Str$(fSeconds1)), 12) + "s" + _
            " - " + _
            StrPadRight$(_Trim$(Str$(fSeconds2)), 12) + "s" + _
            " = " + _
            StrPadRight$(_Trim$(Str$(fDiffSeconds)), 12) + "s" + _
            " = " + _
            GetElapsedTime$(fDiffSeconds)
    Next iLoop1
   
    Input "PRESS ENTER TO CONTINUE"; in$
End Sub ' GetElapsedTimeTest1

' /////////////////////////////////////////////////////////////////////////////
' Based on "Test Steve timeStamp" by SMcNeill & bplus
' https://www.qb64.org/forum/index.php?topic=1638.30
' https://www.qb64.org/forum/index.php?topic=1638.msg108650#msg108650

Sub GetElapsedTimeTest2
    Dim MyDateTime1$
    Dim MyDateTime2$
    Dim MyDate1$
    Dim MyDate2$
    Dim fSeconds1 As _Float
    Dim fSeconds2 As _Float
    Dim fDiffSeconds As _Float
    Dim in$
   
    ' GET CURRENT DATE/TIME
    MyDateTime1$ = GetCurrentDateTime$("{mm}/{dd}/{yyyy} {hh}:{nn}:{ss} {ampm}")
    fSeconds1 = GetUnixTime##(MyDateTime1$)
    Print "Current date/time is " + MyDateTime1$ + " = " + _Trim$(Str$(fSeconds1)) + " seconds"
   
   
    ' COUNT SECONDS UNTIL USER PRESSES ESCAPE
    Cls
    Print "GetElapsedTimeTest2"
    Print "---------------------------------------------------------------------"
    Print
    Print "Seconds elapsed: "
    Print "Time    elapsed: "
    Print
    Print "Press ESC to exit."
    Do
        'While _DeviceInput(1): Wend ' clear and update the keyboard buffer
       
        MyDateTime2$ = GetCurrentDateTime$("{mm}/{dd}/{yyyy} {hh}:{nn}:{ss} {ampm}")
        fSeconds2 = GetUnixTime##(MyDateTime2$)
        fDiffSeconds = fSeconds2 - fSeconds1
       
        'LOCATE 1, 1 is the top left SCREEN text position. LOCATE pY%, pX%
        Locate 4, 18: Print _Trim$(Str$(fDiffSeconds))
        Locate 5, 18: Print GetElapsedTime$(fDiffSeconds)
       
        _Limit 100 ' keep loop at 100 frames per second
    Loop Until _KeyDown(27) ' leave loop when ESC key pressed
   
    _KeyClear: '_DELAY 1
    Input "PRESS ENTER TO CONTINUE"; in$
End Sub ' GetElapsedTimeTest2

' /////////////////////////////////////////////////////////////////////////////

Function GetTimeIntervalName$ (interval$)
    Dim sInterval As String
    Select Case interval$
        Case "yyyy":
            sInterval = "years"
        Case "q":
            sInterval = "quarters"
        Case "m":
            sInterval = "months"
        Case "y":
            sInterval = "days of the year"
        Case "d":
            sInterval = "days"
        Case "w":
            sInterval = "weekdays"
        Case "ww":
            sInterval = "weeks"
        Case "h":
            sInterval = "hours"
        Case "n":
            sInterval = "minutes"
        Case "s":
            sInterval = "seconds"
        Case Else:
            sInterval = "unknown units"
    End Select
    GetTimeIntervalName$ = sInterval
End Function ' GetTimeIntervalName$

' /////////////////////////////////////////////////////////////////////////////
' Based on "Test Steve timeStamp" by SMcNeill & bplus
' https://www.qb64.org/forum/index.php?topic=1638.30
' https://www.qb64.org/forum/index.php?topic=1638.msg108650#msg108650

' Receives:
' MyDate$ can be date or date+time, in any of the following formats:
' 12-hour time:
' 01-01-2020 11:59:59 PM
' 01/01/2020 11:59:59 PM
' 24-hour time:
' 01-01-2020 23:59:59
' 01/01/2020 23:59:59

Function GetUnixTime## (sDate$)
    Dim iPos1 As Integer
    Dim iPos2 As Integer
    Dim iMonth As Integer
    Dim iDay As Integer
    Dim iYear As Integer
    Dim iLoop1 As Integer
    Dim fDateSeconds As _Float
    Dim MyDate$
    Dim sTime$
    Dim fTimeSeconds As _Float ' MyTime##
    Dim fTotalSeconds As _Float: fTotalSeconds = 0
   
    ' Do we have date+time or just date?
    ' Look at sDate$:
    ' e.g. 01-01-2020 11:59:59 PM
    '      1234567890123456789012
    '                 10987654321
    If Len(sDate$) > 19 Then
        ' Date + time, 12-hour time
        sTime$ = Right$(sDate$, Len(sDate$) - 11)
        fTimeSeconds = TimeStringToSeconds##(sTime$)
        MyDate$ = Left$(sDate$, 10)
    ElseIf Len(sDate$) > 10 Then
        ' Date + time, 24-hour time
        sTime$ = Right$(sDate$, Len(sDate$) - 11)
        fTimeSeconds = TimeStringToSeconds##(sTime$)
        MyDate$ = Left$(sDate$, 10)
    Else
        ' Just a date, assume time=12:00:00 AM
        fTimeSeconds = 0
        MyDate$ = sDate$
    End If
    MyDate$ = Replace$(MyDate$, "/", "-")
   
    ' Get seconds for date
    iPos1 = InStr(MyDate$, "-")
    iPos2 = InStr(iPos1 + 1, MyDate$, "-")
    iMonth = Val(Left$(MyDate$, iPos1))
    iDay = Val(Mid$(MyDate$, iPos1 + 1))
    iYear = Val(Mid$(MyDate$, iPos2 + 1))
   
    If iYear < 1970 Then
        ' CALCULATE SHE-IT BACKWARDS
        Select Case iMonth ' turn the day backwards for the month
            Case 1, 3, 5, 7, 8, 10, 12: iDay = 31 - iDay ' 31 days
            Case 2: iDay = 28 - iDay ' special 28 or 29.
            Case 4, 6, 9, 11: iDay = 30 - iDay ' 30 days
        End Select
       
        If iYear Mod 4 = 0 And iMonth < 3 Then ' check for normal leap year, and we're before it...
            iDay = iDay + 1 ' assume we had a leap year, subtract another day
            If iYear Mod 100 = 0 And iYear Mod 400 <> 0 Then iDay = iDay - 1 ' not a leap year if year is divisible by 100 and not 400
        End If
       
        ' then count the months that passed after the current month
        For iLoop1 = iMonth + 1 To 12
            Select Case iLoop1
                Case 2: iDay = iDay + 28
                Case 3, 5, 7, 8, 10, 12: iDay = iDay + 31
                Case 4, 6, 9, 11: iDay = iDay + 30
            End Select
        Next iLoop1
       
        ' we should now have the entered year calculated.  Now lets add in for each year from this point to 1970
        iDay = iDay + 365 * (1969 - iYear) ' 365 days per each standard year
       
        For iLoop1 = 1968 To iYear + 1 Step -4 ' from 1968 onwards,backwards, skipping the current year (which we handled previously in the FOR loop)
            iDay = iDay + 1 ' subtract an extra day every leap year
            If (iLoop1 Mod 100) = 0 And (iLoop1 Mod 400) <> 0 Then iDay = iDay - 1 ' but skipping every year divisible by 100, but not 400
        Next iLoop1
       
        fDateSeconds = iDay * 24 * 60 * 60 ' Seconds are days * 24 hours * 60 minutes * 60 seconds
        fTotalSeconds = -(fDateSeconds + 24 * 60 * 60 - fTimeSeconds)
        'fDateSeconds = -(fDateSeconds + 24 * 60 * 60)
        'Exit Function
    Else
        ' CALCULATE FORWARD
        iYear = iYear - 1970
        For iLoop1 = 1 To iMonth ' for this year,
            Select Case iLoop1 ' Add the number of days for each previous month passed
                Case 1: iDay = iDay ' January doestn't have any carry over days.
                Case 2, 4, 6, 8, 9, 11: iDay = iDay + 31
                Case 3 ' Feb might be a leap year
                    If (iYear Mod 4) = 2 Then ' if this year is divisible by 4 (starting in 1972)
                        iDay = iDay + 29 ' its a leap year
                        If (iYear Mod 100) = 30 And (iYear Mod 400) <> 30 Then ' unless..
                            iDay = iDay - 1 ' the year is divisible by 100, and not divisible by 400
                        End If
                    Else ' year not divisible by 4, no worries
                        iDay = iDay + 28
                    End If
                Case 5, 7, 10, 12: iDay = iDay + 30
            End Select
        Next iLoop1
       
        iDay = (iDay - 1) + 365 * iYear ' current month days passed + 365 days per each standard year
       
        For iLoop1 = 2 To iYear - 1 Step 4 ' from 1972 onwards, skipping the current year (which we handled previously in the FOR loopp)
            iDay = iDay + 1 ' add an extra day every leap year
            If (iLoop1 Mod 100) = 30 And (iLoop1 Mod 400) <> 30 Then iDay = iDay - 1 ' but skiping every year divisible by 100, but not 400
        Next iLoop1
       
        fDateSeconds = iDay * 24 * 60 * 60 ' Seconds are days * 24 hours * 60 minutes * 60 seconds
       
        fTotalSeconds = fDateSeconds + fTimeSeconds
    End If
   
    GetUnixTime## = fTotalSeconds
End Function ' GetUnixTime##

' /////////////////////////////////////////////////////////////////////////////
' mod from Pete's calendar this is a very clear calc

' From "Test Steve timeStamp" by SMcNeill & bplus
' https://www.qb64.org/forum/index.php?topic=1638.30
' https://www.qb64.org/forum/index.php?topic=1638.msg108650#msg108650

Function IsLeapYear% (yr)
    Dim bResult%: bResult% = FALSE
    If yr Mod 4 = 0 Then
        If yr Mod 100 = 0 Then
            If yr Mod 400 = 0 Then
                bResult% = TRUE
            End If
        Else
            bResult% = TRUE
        End If
    End If
    IsLeapYear% = bResult%
End Function ' IsLeapYear%

' /////////////////////////////////////////////////////////////////////////////
' Convert time string to seconds.

' Receives a time string in the format:
' {hh}:[mm}:{ss} {AM/PM}

' If the string contains "AM" or "PM" then it is treated as 12-hour time,
' else it is treated as 24-hour (military) time.

' Counts up the number of seconds from midnight until that time,
' and returns it as type Float.

' TODO:
' * First remove all non-numeric characters, except AM or PM on the right,
'   so that we can parse dates with other separators, like "12.25.2003".
' * Create the inverse function "SecondsToTimeString$".
' * Create a date/time type with all the standard Date operations.

Function TimeStringToSeconds## (sTime$)
    Dim sHH$: sHH$ = Left$(sTime$, 2)
    Dim sNN$: sNN$ = Mid$(sTime$, 4, 2)
    Dim sSS$: sSS$ = Mid$(sTime$, 7, 2)
    Dim fSeconds##: fSeconds## = 0
   
    ' MAKE SURE VALUES ARE NUMBERS
    If (IsNum%(sHH$) = TRUE) And (IsNum%(sNN$) = TRUE) And (IsNum%(sSS$) = TRUE) Then
        ' IF TIME CONTAINS AM/PM, USE 12-HOUR TIME, ELSE 24-HOUR
        If InStr(UCase$(sTime$), "AM") > 0 Then
            ' 12-HOUR TIME, A.M.
            'Print "Ante-meridian!"
            If Val(sHH$) = 12 Then
                ' Hour is zero for 12 A.M.
                'Print "12 A.M., that's zero for hours"
                fSeconds## = (Val(sNN$) * 60) + Val(sSS$)
            Else
                ' Count hour normally
                'Print "Between 1 A.M. and 11:59:59 A.M."
                fSeconds## = (Val(sHH$) * 3600) + (Val(sNN$) * 60) + Val(sSS$)
            End If
        ElseIf InStr(UCase$(sTime$), "PM") > 0 Then
            ' 12-HOUR TIME, P.M.
            ' Unless it is noon, add 12 hours.
            If Val(sHH$) = 12 Then
                ' Count hour normally
                'Print "12 noon. Leave hours alone."
                fSeconds## = (Val(sHH$) * 3600) + (Val(sNN$) * 60) + Val(sSS$)
            Else
                ' Add 12 hours.
                'Print "Post-meridian but not noon. Add 12 hours."
                fSeconds## = ((Val(sHH$) + 12) * 3600) + (Val(sNN$) * 60) + Val(sSS$)
            End If
        Else
            ' 24-HOUR TIME
            'Print "24 hours, boys!!"
            fSeconds## = (Val(sHH$) * 3600) + (Val(sNN$) * 60) + Val(sSS$)
        End If
        'Else
        '    Print "Something's not right"
        '    Print "(IsNum%(sHH$) = " + _Trim$(Str$(IsNum%(sHH$))) + ", sHH$=" + chr$(34) + sHH$ + chr$(34)
        '    Print "(IsNum%(sNN$) = " + _Trim$(Str$(IsNum%(sNN$))) + ", sNN$=" + chr$(34) + sNN$ + chr$(34)
        '    Print "(IsNum%(sSS$) = " + _Trim$(Str$(IsNum%(sSS$))) + ", sSS$=" + chr$(34) + sSS$ + chr$(34)
    End If
   
    ' RETURN RESULT
    TimeStringToSeconds## = fSeconds##
   
End Function ' TimeStringToSeconds##

' /////////////////////////////////////////////////////////////////////////////

Sub TimeStringToSecondsTest
    ReDim arrTime$(0 To 17)
    Dim iLoop%
    Dim in$
    arrTime$(0) = "00:00:00"
    arrTime$(1) = "12:00:00 AM"
    arrTime$(2) = "01:00:00"
    arrTime$(3) = "01:00:00 AM"
    arrTime$(4) = "01:02:00 AM"
    arrTime$(5) = "01:02:34 AM"
    arrTime$(6) = "02:00:00"
    arrTime$(7) = "02:00:00 AM"
    arrTime$(8) = "02:02:00 AM"
    arrTime$(9) = "02:02:34 AM"
    arrTime$(10) = "01:00:00 PM"
    arrTime$(11) = "01:02:00 PM"
    arrTime$(12) = "01:02:34 PM"
    arrTime$(13) = "13:00:00"
    arrTime$(14) = "13:01:00"
    arrTime$(15) = "13:01:34"
    arrTime$(16) = "23:59:59"
    arrTime$(17) = "11:59:59 PM"
    Cls
    Print "Demonstration of Function TimeStringToSeconds## (sTime$)"
    Print "--------------------------------------------------------"
    For iLoop% = LBound(arrTime$) To UBound(arrTime$)
        Print "Time " + Chr$(34) + arrTime$(iLoop%) + Chr$(34) + " = " + _Trim$(Str$(TimeStringToSeconds##(arrTime$(iLoop%)))) + " seconds."
    Next iLoop%
    Input "PRESS ENTER TO CONTINUE"; in$
End Sub ' TimeStringToSecondsTest

' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' END TIMESTAMP FUNCTIONS
' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

' ################################################################################################################################################################
' BEGIN GENERAL ROUTINES #GENERAL
' ################################################################################################################################################################

' /////////////////////////////////////////////////////////////////////////////

Function AppendString$ (MyString As String, NewString As String, MyDelimiter As String)
    Dim sResult As String: sResult = MyString
    If Len(MyString) > 0 Then
        sResult = sResult + MyDelimiter
    End If
    sResult = sResult + NewString
    AppendString$ = sResult
End Function ' AppendString$

' /////////////////////////////////////////////////////////////////////////////

Sub AppendToStringArray (MyStringArray$(), MyString$)
    ReDim _Preserve MyStringArray$(LBound(MyStringArray$) To UBound(MyStringArray$) + 1)
    MyStringArray$(UBound(MyStringArray$)) = MyString$
End Sub ' AppendToStringArray

' /////////////////////////////////////////////////////////////////////////////
' See also StringTo2dArray

Function Array2dToString$ (MyArray() As String)
    Dim MyString As String
    Dim iY As Integer
    Dim iX As Integer
    Dim sLine As String
    MyString = ""
    For iY = LBound(MyArray, 1) To UBound(MyArray, 1)
        sLine = ""
        For iX = LBound(MyArray, 2) To UBound(MyArray, 2)
            sLine = sLine + MyArray(iY, iX)
        Next iX
        MyString = MyString + sLine + Chr$(13)
    Next iY
    Array2dToString$ = MyString
End Function ' Array2dToString$

' /////////////////////////////////////////////////////////////////////////////

'Function Array2dToStringTest$ (MyArray() As String)
'    Dim MyString As String
'    Dim iY As Integer
'    Dim iX As Integer
'    Dim sLine As String
'    MyString = ""
'    MyString = MyString + "           11111111112222222222333" + Chr$(13)
'    MyString = MyString + "  12345678901234567890123456789012" + Chr$(13)
'    For iY = LBound(MyArray, 1) To UBound(MyArray, 1)
'        sLine = ""
'        sLine = sLine + Right$("  " + cstr$(iY), 2)
'        For iX = LBound(MyArray, 2) To UBound(MyArray, 2)
'            sLine = sLine + MyArray(iY, iX)
'        Next iX
'        sLine = sLine + Right$("  " + cstr$(iY), 2)
'        MyString = MyString + sLine + Chr$(13)
'    Next iY
'    MyString = MyString + "  12345678901234567890123456789012" + Chr$(13)
'    MyString = MyString + "           11111111112222222222333" + Chr$(13)
'    Array2dToStringTest$ = MyString
'End Function ' Array2dToStringTest$

' /////////////////////////////////////////////////////////////////////////////
' Convert a value to string and trim it (because normal Str$ adds spaces)

Function cstr$ (myValue)
    'cstr$ = LTRIM$(RTRIM$(STR$(myValue)))
    cstr$ = _Trim$(Str$(myValue))
End Function ' cstr$

' /////////////////////////////////////////////////////////////////////////////
' Convert a Long value to string and trim it (because normal Str$ adds spaces)

Function cstrl$ (myValue As Long)
    cstrl$ = _Trim$(Str$(myValue))
End Function ' cstrl$

' /////////////////////////////////////////////////////////////////////////////
' Convert a Single value to string and trim it (because normal Str$ adds spaces)

Function cstrs$ (myValue As Single)
    ''cstr$ = LTRIM$(RTRIM$(STR$(myValue)))
    cstrs$ = _Trim$(Str$(myValue))
End Function ' cstrs$

' /////////////////////////////////////////////////////////////////////////////
' Convert an unsigned Long value to string and trim it (because normal Str$ adds spaces)

Function cstrul$ (myValue As _Unsigned Long)
    cstrul$ = _Trim$(Str$(myValue))
End Function ' cstrul$

' /////////////////////////////////////////////////////////////////////////////
' Simple timestamp function

Function CurrentDateTime$
    CurrentDateTime$ = Mid$(Date$, 7, 4) + "-" + _
        Mid$(Date$, 1, 5) + " " + _
        Time$
End Function ' CurrentDateTime$

' /////////////////////////////////////////////////////////////////////////////
' Scientific notation - QB64 Wiki
' https://www.qb64.org/wiki/Scientific_notation

' Example: A string function that displays extremely small or large exponential decimal values.

Function DblToStr$ (n#)
    value$ = UCase$(LTrim$(Str$(n#)))
    Xpos% = InStr(value$, "D") + InStr(value$, "E") 'only D or E can be present
    If Xpos% Then
        expo% = Val(Mid$(value$, Xpos% + 1))
        If Val(value$) < 0 Then
            sign$ = "-": valu$ = Mid$(value$, 2, Xpos% - 2)
        Else valu$ = Mid$(value$, 1, Xpos% - 1)
        End If
        dot% = InStr(valu$, "."): L% = Len(valu$)
        If expo% > 0 Then add$ = String$(expo% - (L% - dot%), "0")
        If expo% < 0 Then min$ = String$(Abs(expo%) - (dot% - 1), "0"): DP$ = "."
        For n = 1 To L%
            If Mid$(valu$, n, 1) <> "." Then num$ = num$ + Mid$(valu$, n, 1)
        Next
    Else DblToStr$ = value$: Exit Function
    End If
    DblToStr$ = _Trim$(sign$ + DP$ + min$ + num$ + add$)
End Function ' DblToStr$

' /////////////////////////////////////////////////////////////////////////////
' Receives an {sDelim} delimited list {sInput}
' returns the list with all duplicate entries removed.

Function DedupeDelimList$ (sInput As String, sDelim As String)
    ReDim arrLines(-1) As String
    Dim sOutput As String
    Dim iLoop As Integer

    split sInput, sDelim, arrLines()
    sOutput = sDelim
    For iLoop = LBound(arrLines) To UBound(arrLines)
        If InStr(1, sOutput, sDelim + arrLines(iLoop) + sDelim) = 0 Then
            sOutput = sOutput + arrLines(iLoop) + sDelim
        End If
    Next iLoop

    DedupeDelimList$ = sOutput
End Function ' DedupeDelimList$

' /////////////////////////////////////////////////////////////////////////////
' SMcNeill
' More efficient version of ExtendedTimer.
' This stores our day values and only updates them when necessary.
' We really don't need to figure out how many seconds are in today over and over endlessly
' -- just count them once, and when the clock swaps back to 0:0:0, add 24*60*60 seconds to the count.
' Re: how to time something (ie do loop for n seconds)
' https://forum.qb64.org/index.php?topic=4682.0

Function ExtendedTimer##
    'modified extendedtimer to store the old day's count, and not have to recalculate it every time the routine is called.

    Static olds As _Float, old_day As _Float
    Dim m As Integer, d As Integer, y As Integer
    Dim s As _Float, day As String
    If olds = 0 Then 'calculate the day the first time the extended timer runs
        day = Date$
        m = Val(Left$(day, 2))
        d = Val(Mid$(day, 4, 2))
        y = Val(Right$(day, 4)) - 1970
        Select Case m 'Add the number of days for each previous month passed
            Case 2: d = d + 31
            Case 3: d = d + 59
            Case 4: d = d + 90
            Case 5: d = d + 120
            Case 6: d = d + 151
            Case 7: d = d + 181
            Case 8: d = d + 212
            Case 9: d = d + 243
            Case 10: d = d + 273
            Case 11: d = d + 304
            Case 12: d = d + 334
        End Select
        If (y Mod 4) = 2 And m > 2 Then d = d + 1 'add a day if this is leap year and we're past february
        d = (d - 1) + 365 * y 'current month days passed + 365 days per each standard year
        d = d + (y + 2) \ 4 'add in days for leap years passed
        s = d * 24 * 60 * 60 'Seconds are days * 24 hours * 60 minutes * 60 seconds
        old_day = s
    End If
    If Timer < oldt Then 'we went from 23:59:59 (a second before midnight) to 0:0:0 (midnight)
        old_day = s + 83400 'add another worth of seconds to our counter
    End If
    oldt = Timer
    olds = old_day + oldt
    ExtendedTimer## = olds
End Function ' ExtendedTimer##

' /////////////////////////////////////////////////////////////////////////////
' TODO: find the newer formatting function?

Function FormatNumber$ (myValue, iDigits As Integer)
    Dim strValue As String
    strValue = DblToStr$(myValue) + String$(iDigits, " ")
    If myValue < 1 Then
        If myValue < 0 Then
            strValue = Replace$(strValue, "-.", "-0.")
        ElseIf myValue > 0 Then
            strValue = "0" + strValue
        End If
    End If
    FormatNumber$ = Left$(strValue, iDigits)
End Function ' FormatNumber$

' /////////////////////////////////////////////////////////////////////////////
' From: Bitwise Manipulations By Steven Roman
' http://www.romanpress.com/Articles/Bitwise_R/Bitwise.htm

' Returns the 8-bit binary representation
' of an integer iInput where 0 <= iInput <= 255

Function GetBinary$ (iInput1 As Integer)
    Dim sResult As String
    Dim iLoop As Integer
    Dim iInput As Integer: iInput = iInput1

    sResult = ""

    If iInput >= 0 And iInput <= 255 Then
        For iLoop = 1 To 8
            sResult = LTrim$(RTrim$(Str$(iInput Mod 2))) + sResult
            iInput = iInput \ 2
            'If iLoop = 4 Then sResult = " " + sResult
        Next iLoop
    End If

    GetBinary$ = sResult
End Function ' GetBinary$

' /////////////////////////////////////////////////////////////////////////////
' wonderfully inefficient way to read if a bit is set
' ival = GetBit256%(int we are comparing, int containing the bits we want to read)

' See also: GetBit256%, SetBit256%

Function GetBit256% (iNum1 As Integer, iBit1 As Integer)
    Dim iResult As Integer
    Dim sNum As String
    Dim sBit As String
    Dim iLoop As Integer
    Dim bContinue As Integer
    'DIM iTemp AS INTEGER
    Dim iNum As Integer: iNum = iNum1
    Dim iBit As Integer: iBit = iBit1

    iResult = FALSE
    bContinue = TRUE

    If iNum < 256 And iBit <= 128 Then
        sNum = GetBinary$(iNum)
        sBit = GetBinary$(iBit)
        For iLoop = 1 To 8
            If Mid$(sBit, iLoop, 1) = "1" Then
                'if any of the bits in iBit are false, return false
                If Mid$(sNum, iLoop, 1) = "0" Then
                    iResult = FALSE
                    bContinue = FALSE
                    Exit For
                End If
            End If
        Next iLoop
        If bContinue = TRUE Then
            iResult = TRUE
        End If
    End If

    GetBit256% = iResult
End Function ' GetBit256%

' /////////////////////////////////////////////////////////////////////////////
' Returns the text character at positon x%, y%

' Does the same as:
'   Locate y%, x%
'   GetCharXY% = Screen(CsrLin, Pos(0))

' See also: GetColorXY&

Function GetCharXY% (x%, y%)
    GetCharXY% = Screen(y%, x%, 0) ' when 3rd parameter = 0 returns character code
End Function ' GetCharXY%

' /////////////////////////////////////////////////////////////////////////////
' Returns the text color at positon x%, y%

' See also: GetCharXY%

Function GetColorXY& (x%, y%)
    GetColorXY& = Screen(y%, x%, 1) ' when 3rd parameter = 1 returns character color
End Function ' GetColorXY

' /////////////////////////////////////////////////////////////////////////////
' Simple timestamp function
' Format: {YYYY}-{MM}-{DD} {hh}:[mm}:{ss}

' Uses:
'     TIME$
'         The TIME$ Function returns a STRING representation
'         of the current computer time in a 24 hour format.
'         https://qb64phoenix.com/qb64wiki/index.php/TIME$
'     DATE$
'         The DATE$ function returns the current computer date
'         as a string in the format "mm-dd-yyyy".
'         https://qb64phoenix.com/qb64wiki/index.php/DATE$
'
' TODO: support template where
'       {yyyy} = 4 digit year
'       {mm}   = 2 digit month
'       {dd}   = 2 digit day
'       {hh}   = 2 digit hour (12-hour)
'       {rr}   = 2 digit hour (24-hour)
'       {nn}   = 2 digit minute
'       {ss}   = 2 digit second
'       {ampm} = AM/PM

' We got the nn for minute from Microsoft > Office VBA Reference > DateDiff function
' https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/datediff-function

' PRINT "Current date time (simple format) = " + Chr$(34) + GetCurrentDateTime$("{yyyy}-{mm}-{dd} {rr}:{nn}:{ss}") + Chr$(34)
' PRINT "Current date time (US format)     = " + Chr$(34) + GetCurrentDateTime$("{mm}/{dd}/{yyyy} {hh}:{nn}:{ss} {ampm}") + Chr$(34)
' PRINT "Filename timestamp                = " + Chr$(34) + GetCurrentDateTime$("{yyyy}{mm}{dd}_{rr}{nn}{ss}") + Chr$(34)

Function GetCurrentDateTime$ (sTemplate$)
    Dim sDate$: sDate$ = Date$
    Dim sTime$: sTime$ = Time$
    Dim sYYYY$: sYYYY$ = Mid$(sDate$, 7, 4)
    Dim sMM$: sMM$ = Mid$(sDate$, 1, 2)
    Dim sDD$: sDD$ = Mid$(sDate$, 4, 2)
    Dim sHH24$: sHH24$ = Mid$(sTime$, 1, 2)
    Dim sHH$: sHH$ = ""
    Dim sMI$: sMI$ = Mid$(sTime$, 4, 2)
    Dim sSS$: sSS$ = Mid$(sTime$, 7, 2)
    Dim iHour%: iHour% = Val(sHH24$)
    Dim sAMPM$: sAMPM$ = ""
    Dim result$: result$ = ""

    ' FIGURE OUT AM/PM
    If InStr(sTemplate$, "{ampm}") > 0 Then
        If iHour% = 0 Then
            sAMPM$ = "AM"
            iHour% = 12
        ElseIf iHour% > 0 And iHour% < 12 Then
            sAMPM$ = "AM"
        ElseIf iHour% = 12 Then
            sAMPM$ = "PM"
        Else
            sAMPM$ = "PM"
            iHour% = iHour% - 12
        End If
        sHH$ = Right$("00" + _Trim$(Str$(iHour%)), 2)
    End If

    ' POPULATE TEMPLATE
    result$ = sTemplate$
    result$ = Replace$(result$, "{yyyy}", sYYYY$)
    result$ = Replace$(result$, "{mm}", sMM$)
    result$ = Replace$(result$, "{dd}", sDD$)
    result$ = Replace$(result$, "{hh}", sHH$)
    result$ = Replace$(result$, "{rr}", sHH24$)
    result$ = Replace$(result$, "{nn}", sMI$)
    result$ = Replace$(result$, "{ss}", sSS$)
    result$ = Replace$(result$, "{ampm}", sAMPM$)

    ' RETURN RESULT
    GetCurrentDateTime$ = result$
End Function ' GetCurrentDateTime$

' /////////////////////////////////////////////////////////////////////////////
' From: Bitwise Manipulations By Steven Roman
' http://www.romanpress.com/Articles/Bitwise_R/Bitwise.htm

' Returns the integer that corresponds to a binary string of length 8

Function GetIntegerFromBinary% (sBinary1 As String)
    Dim iResult As Integer
    Dim iLoop As Integer
    Dim strBinary As String
    Dim sBinary As String: sBinary = sBinary1

    iResult = 0
    strBinary = Replace$(sBinary, " ", "") ' Remove any spaces
    For iLoop = 0 To Len(strBinary) - 1
        iResult = iResult + 2 ^ iLoop * Val(Mid$(strBinary, Len(strBinary) - iLoop, 1))
    Next iLoop

    GetIntegerFromBinary% = iResult
End Function ' GetIntegerFromBinary%

' /////////////////////////////////////////////////////////////////////////////
' Receives a {sDelimeter} delimited list of numbers {MyString}
' and splits it up into an integer array arrInteger()
' beginning at index {iMinIndex}.

Sub GetIntegerArrayFromDelimList (MyString As String, sDelimiter As String, iMinIndex As Integer, arrInteger() As Integer)
    ReDim arrString(-1) As String
    Dim CleanString As String
    Dim iLoop As Integer
    Dim iCount As Integer: iCount = iMinIndex - 1

    ReDim arrInteger(-1) As Integer

    'DebugPrint "GetIntegerArrayFromDelimList " + _
    '    "MyString=" + chr$(34) + MyString + chr$(34) + ", " + _
    '    "sDelimiter=" + chr$(34) + sDelimiter + chr$(34) + ", " + _
    '    "iMinIndex=" + cstr$(iMinIndex) + ", " + _
    '    "arrInteger()"


    If Len(sDelimiter) > 0 Then
        CleanString = MyString
        If sDelimiter <> " " Then
            CleanString = Replace$(CleanString, " ", "")
        End If

        split CleanString, sDelimiter, arrString()
        iCount = iMinIndex - 1
        For iLoop = LBound(arrString) To UBound(arrString)
            If IsNum%(arrString(iLoop)) = TRUE Then
                iCount = iCount + 1
                ReDim _Preserve arrInteger(iMinIndex To iCount) As Integer
                arrInteger(iCount) = Val(arrString(iLoop))
                'DebugPrint "5633 arrInteger(" + cstr$(iCount) + ") = VAL(arrString(" + cstr$(iLoop) + ")) = " + cstr$(arrInteger(iCount))

            End If
        Next iLoop
    Else
        If IsNum%(MyString) = TRUE Then
            ReDim _Preserve arrInteger(iMinIndex To iMinIndex) As Integer
            arrInteger(iMinIndex) = Val(MyString)
        End If
    End If

    'CleanString=""
    'for iLoop=lbound(arrInteger) to ubound(arrInteger)
    'CleanString = CleanString + iifstr$(iLoop=lbound(arrInteger), "", ",") + cstr$(arrInteger(iLoop))
    'next iLoop
    'DebugPrint "arrInteger=(" + CleanString + ")"
End Sub ' GetIntegerArrayFromDelimList

' /////////////////////////////////////////////////////////////////////////////
' IIF function for QB for integers

Function IIF (Condition, IfTrue, IfFalse)
    If Condition Then IIF = IfTrue Else IIF = IfFalse
End Function

' /////////////////////////////////////////////////////////////////////////////
' IIF function for QB for strings

Function IIFSTR$ (Condition, IfTrue$, IfFalse$)
    If Condition Then IIFSTR$ = IfTrue$ Else IIFSTR$ = IfFalse$
End Function

' /////////////////////////////////////////////////////////////////////////////

Function IntPadLeft$ (iValue As Integer, iWidth As Integer)
    IntPadLeft$ = Right$(String$(iWidth, " ") + _Trim$(Str$(iValue)), iWidth)
End Function ' IntPadLeft$

' /////////////////////////////////////////////////////////////////////////////

Function IntPadRight$ (iValue As Integer, iWidth As Integer)
    IntPadRight$ = Left$(_Trim$(Str$(iValue)) + String$(iWidth, " "), iWidth)
End Function ' IntPadRight$

' /////////////////////////////////////////////////////////////////////////////
' Returns TRUE if number n is even
' https://slaystudy.com/qbasic-program-to-check-if-number-is-even-or-odd/

Function IsEven% (n)
    If n Mod 2 = 0 Then
        IsEven% = TRUE
    Else
        IsEven% = FALSE
    End If
End Function ' IsEven%

' /////////////////////////////////////////////////////////////////////////////
' Returns TRUE if number n is odd
' https://slaystudy.com/qbasic-program-to-check-if-number-is-even-or-odd/

Function IsOdd% (n)
    If n Mod 2 = 1 Then
        IsOdd% = TRUE
    Else
        IsOdd% = FALSE
    End If
End Function ' IsOdd%

' /////////////////////////////////////////////////////////////////////////////
' Returns TRUE if value text$ is numeric.

Function IsNum% (text$)
    IsNum% = IsNumber%(text$)
End Function ' IsNum%

'' NOTE: THIS FAILS FOR NUMBERS LIKE "002" AND "2.000":
'Function IsNum% (text$)
'    Dim a$
'    Dim b$
'    a$ = _Trim$(text$)
'    b$ = _Trim$(Str$(Val(text$)))
'    If a$ = b$ Then
'        IsNum% = TRUE
'    Else
'        IsNum% = FALSE
'    End If
'End Function ' IsNum%

' /////////////////////////////////////////////////////////////////////////////
' Returns TRUE if value OriginalString$ is numeric.

' Re: Does a Is Number function exist in QB64?
' https://www.qb64.org/forum/index.php?topic=896.15

' Version 2 by madscijr
' Returns TRUE (-1) if string is an integer, FALSE (0) if not

' Version 1 by MWheatley
' Reply #18 on: January 01, 2019, 11:24:30 AM
' returns 1 if string is an integer, 0 if not

Function IsNumber% (OriginalString$)
    Dim bResult%: bResult% = FALSE
    Dim iLoop%
    Dim TestString$
    'Dim bNegative%
    Dim iDecimalCount%
    Dim sNextChar$
   
    'THEY SHOULD TRIM OUTSIDE THE FUNCTION!
    'TestString$ = _TRIM$(OriginalString$)
   
    If Len(OriginalString$) > 0 Then
        TestString$ = ""
        If Left$(OriginalString$, 1) = "+" Then
            TestString$ = Right$(OriginalString$, Len(OriginalString$) - 1)
            'bNegative% = FALSE
        ElseIf Left$(OriginalString$, 1) = "-" Then
            TestString$ = Right$(OriginalString$, Len(OriginalString$) - 1)
            'bNegative% = TRUE
        Else
            TestString$ = OriginalString$
            'bNegative% = FALSE
        End If
        If Len(TestString$) > 0 Then
            bResult% = TRUE
            iDecimalCount% = 0
            For iLoop% = 1 To Len(TestString$)
                sNextChar$ = Mid$(TestString$, iLoop%, 1)
                If sNextChar$ = "." Then
                    iDecimalCount% = iDecimalCount% + 1
                    If iDecimalCount% > 1 Then
                        ' TOO MANY DECIMAL POINTS, INVALID!
                        bResult% = FALSE
                        Exit For
                    End If
                ElseIf Asc(sNextChar$) < 48 Or Asc(sNextChar$) > 57 Then
                    ' NOT A NUMERAL OR A DECIMAL, INVALID!
                    bResult% = FALSE
                    Exit For
                End If
            Next iLoop%
        End If
    End If
    IsNumber% = bResult%
End Function ' IsNumber%

' /////////////////////////////////////////////////////////////////////////////

'Sub IsNumberTest
'    Dim in$
'    Cls
'    IsNumberTest1 "1"
'    IsNumberTest1 "01"
'    IsNumberTest1 "001"
'    IsNumberTest1 "-1"
'    IsNumberTest1 "-01"
'    IsNumberTest1 "-001"
'    IsNumberTest1 "+1"
'    IsNumberTest1 "+01"
'    IsNumberTest1 "+001"
'    IsNumberTest1 ".1"
'    IsNumberTest1 ".01"
'    IsNumberTest1 ".001"
'    IsNumberTest1 ".10"
'    IsNumberTest1 ".100"
'    IsNumberTest1 "..100"
'    IsNumberTest1 "100."
'    Input "PRESS ENTER TO CONTINUE TEST";in$
'    Cls
'    IsNumberTest1 "0.10"
'    IsNumberTest1 "00.100"
'    IsNumberTest1 "000.1000"
'    IsNumberTest1 "000..1000"
'    IsNumberTest1 "000.1000.00"
'    IsNumberTest1 "+1.00"
'    IsNumberTest1 "++1.00"
'    IsNumberTest1 "+-1.00"
'    IsNumberTest1 "-1.00"
'    IsNumberTest1 "-+1.00"
'    IsNumberTest1 " 1"
'    IsNumberTest1 "1 "
'    IsNumberTest1 "1. 01"
'    IsNumberTest1 "+1 "
'End Sub ' IsNumberTest
'Sub IsNumberTest1(MyString As String)
'    Const cWidth = 16
'    Dim sInput As String : sInput = left$(Chr$(34) + MyString + Chr$(34) + String$(cWidth, " "), cWidth)
'    Dim sResult As String : sResult = right$(String$(2, " ") + _Trim$(Str$(IsNumber%(MyString))), 2)
'    Print "IsNumber%(" + sInput + ") returns " + sResult
'End Sub ' IsNumberTest1

' /////////////////////////////////////////////////////////////////////////////
' Split and join strings
' https://www.qb64.org/forum/index.php?topic=1073.0

'Combine all elements of in$() into a single string with delimiter$ separating the elements.

Function join$ (in$(), delimiter$)
    result$ = in$(LBound(in$))
    For i = LBound(in$) + 1 To UBound(in$)
        result$ = result$ + delimiter$ + in$(i)
    Next i
    join$ = result$
End Function ' join$

' /////////////////////////////////////////////////////////////////////////////
' ABS was returning strange values with type LONG
' so I created this which does not.

' See also: UnsignedLongABS

Function LongABS& (lngValue As Long)
    If Sgn(lngValue) = -1 Then
        LongABS& = 0 - lngValue
    Else
        LongABS& = lngValue
    End If
End Function ' LongABS&

' /////////////////////////////////////////////////////////////////////////////
' remove scientific Notation to String (~40 LOC)
' SMcNeill Jan 7, 2020
' https://www.qb64.org/forum/index.php?topic=1555.msg112989#msg112989

' Last Function in code marked Best Answer (removed debug comments and
' blank lines added these 2 lines.)

Function N2S$ (EXP$)
    ReDim t$, sign$, l$, r$, r&&
    ReDim dp As Long, dm As Long, ep As Long, em As Long, check1 As Long, l As Long, i As Long
    t$ = LTrim$(RTrim$(EXP$))
    If Left$(t$, 1) = "-" Or Left$(t$, 1) = "N" Then sign$ = "-": t$ = Mid$(t$, 2)
    dp = InStr(t$, "D+"): dm = InStr(t$, "D-")
    ep = InStr(t$, "E+"): em = InStr(t$, "E-")
    check1 = Sgn(dp) + Sgn(dm) + Sgn(ep) + Sgn(em)
    If check1 < 1 Or check1 > 1 Then N2S = _Trim$(EXP$): Exit Function ' If no scientic notation is found, or if we find more than 1 type, it's not SN!
    Select Case l ' l now tells us where the SN starts at.
        Case Is < dp: l = dp
        Case Is < dm: l = dm
        Case Is < ep: l = ep
        Case Is < em: l = em
    End Select
    l$ = Left$(t$, l - 1) ' The left of the SN
    r$ = Mid$(t$, l + 1): r&& = Val(r$) ' The right of the SN, turned into a workable long
    If InStr(l$, ".") Then ' Location of the decimal, if any
        If r&& > 0 Then
            r&& = r&& - Len(l$) + 2
        Else
            r&& = r&& + 1
        End If
        l$ = Left$(l$, 1) + Mid$(l$, 3)
    End If
    Select Case r&&
        Case 0 ' what the heck? We solved it already?
            ' l$ = l$
        Case Is < 0
            For i = 1 To -r&&
                l$ = "0" + l$
            Next
            l$ = "." + l$
        Case Else
            For i = 1 To r&&
                l$ = l$ + "0"
            Next
            l$ = l$
    End Select
    N2S$ = sign$ + l$
End Function ' N2S$

' /////////////////////////////////////////////////////////////////////////////

Function PadLeft$ (MyString As String, iLength As Integer)
    Dim sValue As String
    sValue = String$(iLength, " ") + MyString
    sValue = Right$(sValue, iLength)
    PadLeft$ = sValue
End Function ' PadLeft$

' /////////////////////////////////////////////////////////////////////////////

Function PadRight$ (MyString As String, iLength As Integer)
    Dim sValue As String
    sValue = MyString + String$(iLength, " ")
    sValue = Left$(sValue, iLength)
    PadRight$ = sValue
End Function ' PadRight$

' /////////////////////////////////////////////////////////////////////////////
' Pauses for iDS deciseconds (iDS * 100 ms)

Sub PauseDecisecond (iDS As Integer)
    Dim iCount As Integer
    iCount = 0
    Do
        iCount = iCount + 1
        _Limit 10 ' run 10x every second
    Loop Until iCount = iDS
End Sub ' PauseDecisecond

' /////////////////////////////////////////////////////////////////////////////
' Returns TRUE if point (x1%, y1%) is adjacent to point (x2%, y2%)

Function PointsAreAdjacent% (x1%, y1%, x2%, y2%)
    Dim bResult%: bResult% = FALSE

    ' x or y can be the same, but not both
    If (x1% <> x2%) Or (y1% <> y2%) Then
        If (x1% = x2%) Or ((x1% = (x2% + 1)) Or (x2% = (x1% + 1))) Then
            If (y1% = y2%) Or ((y1% = (y2% + 1)) Or (y2% = (y1% + 1))) Then
                bResult% = TRUE
            End If
        End If
    End If
    PointsAreAdjacent% = bResult%
End Function ' PointsAreAdjacent%

' /////////////////////////////////////////////////////////////////////////////
' Writes sText to file sFileName.
' If bAppend=TRUE appends to file, else overwrites it.

' Returns blank if successful else returns error message.

' Example:
' ProgramPath$ = Left$(Command$(0), _InStrRev(Command$(0), "\"))
' ProgramName$: m_ProgramName$ = Mid$(Command$(0), _InStrRev(Command$(0), "\") + 1)
' sFileName = ProgramPath$ + ProgramName$ + ".OUT.txt"
' sText = "This is a test." + chr$(13) + "Here is line 2." + chr$(13) + "End."
' sError = PrintFile$(sFileName, sText, FALSE)

Function PrintFile$ (sFileName As String, sText As String, bAppend As Integer)
    Dim sError As String: sError = ""

    If Len(sError) = 0 Then
        If (bAppend = TRUE) Then
            If _FileExists(sFileName) Then
                Open sFileName For Append As #1 ' opens an existing file for appending
            Else
                sError = "Error in PrintFile$ : File not found. Cannot append."
            End If
        Else
            Open sFileName For Output As #1 ' opens and clears an existing file or creates new empty file
        End If
    End If
    If Len(sError) = 0 Then
        ' NOTE: WRITE places text in quotes in the file
        'WRITE #1, x, y, z$
        'WRITE #1, sText

        ' PRINT does not put text inside quotes
        Print #1, sText

        Close #1
    End If

    PrintFile$ = sError
End Function ' PrintFile$

' /////////////////////////////////////////////////////////////////////////////
' Prints text character char$ at positoin x%,y% in color myColor&.

Sub PutCharXY (x%, y%, char$, myColor&)
    Color myColor&
    Locate y%, x%
    Print char$;
End Sub ' PutCharXY

' /////////////////////////////////////////////////////////////////////////////
' Generate random value between Min and Max inclusive.

Function RandomNumber% (Min%, Max%)
    Dim NumSpread%

    ' SET RANDOM SEED
    'Randomize ' Initialize random-number generator.
    Randomize Timer

    ' GET RANDOM # Min%-Max%
    'RandomNumber = Int((Max * Rnd) + Min) ' generate number

    NumSpread% = (Max% - Min%) + 1

    RandomNumber% = Int(Rnd * NumSpread%) + Min% ' GET RANDOM # BETWEEN Max% AND Min%
End Function ' RandomNumber%

'' /////////////////////////////////////////////////////////////////////////////
'
'Sub RandomNumberTest
'    Dim iCols As Integer: iCols = 10
'    Dim iRows As Integer: iRows = 20
'    Dim iLoop As Integer
'    Dim iX As Integer
'    Dim iY As Integer
'    Dim sError As String
'    Dim sFileName As String
'    Dim sText As String
'    Dim bAppend As Integer
'    Dim iMin As Integer
'    Dim iMax As Integer
'    Dim iNum As Integer
'    Dim iErrorCount As Integer
'    Dim sInput$
'
'    sFileName = "c:\temp\maze_test_1.txt"
'    sText = "Count" + Chr$(9) + "Min" + Chr$(9) + "Max" + Chr$(9) + "Random"
'    bAppend = FALSE
'    sError = PrintFile$(sFileName, sText, bAppend)
'    If Len(sError) = 0 Then
'        bAppend = TRUE
'        iErrorCount = 0
'
'        iMin = 0
'        iMax = iCols - 1
'        For iLoop = 1 To 100
'            iNum = RandomNumber%(iMin, iMax)
'            sText = Str$(iLoop) + Chr$(9) + Str$(iMin) + Chr$(9) + Str$(iMax) + Chr$(9) + Str$(iNum)
'            sError = PrintFile$(sFileName, sText, bAppend)
'            If Len(sError) > 0 Then
'                iErrorCount = iErrorCount + 1
'                Print Str$(iLoop) + ". ERROR"
'                Print "    " + "iMin=" + Str$(iMin)
'                Print "    " + "iMax=" + Str$(iMax)
'                Print "    " + "iNum=" + Str$(iNum)
'                Print "    " + "Could not write to file " + Chr$(34) + sFileName + Chr$(34) + "."
'                Print "    " + sError
'            End If
'        Next iLoop
'
'        iMin = 0
'        iMax = iRows - 1
'        For iLoop = 1 To 100
'            iNum = RandomNumber%(iMin, iMax)
'            sText = Str$(iLoop) + Chr$(9) + Str$(iMin) + Chr$(9) + Str$(iMax) + Chr$(9) + Str$(iNum)
'            sError = PrintFile$(sFileName, sText, bAppend)
'            If Len(sError) > 0 Then
'                iErrorCount = iErrorCount + 1
'                Print Str$(iLoop) + ". ERROR"
'                Print "    " + "iMin=" + Str$(iMin)
'                Print "    " + "iMax=" + Str$(iMax)
'                Print "    " + "iNum=" + Str$(iNum)
'                Print "    " + "Could not write to file " + Chr$(34) + sFileName + Chr$(34) + "."
'                Print "    " + sError
'            End If
'        Next iLoop
'
'        Print "Finished generating numbers. Errors: " + Str$(iErrorCount)
'    Else
'        Print "Error creating file " + Chr$(34) + sFileName + Chr$(34) + "."
'        Print sError
'    End If
'
'    Input "Press <ENTER> to continue", sInput$
'End Sub ' RandomNumberTest

' /////////////////////////////////////////////////////////////////////////////
' FROM: String Manipulation
' found at abandoned, outdated and now likely malicious qb64 dot net website
' http://www.qb64.[net]/forum/index_topic_5964-0/
'
'SUMMARY:
'   Purpose:  A library of custom functions that transform strings.
'   Author:   Dustinian Camburides (dustinian@gmail.com)
'   Platform: QB64 (www.qb64.org)
'   Revision: 1.6
'   Updated:  5/28/2012

'SUMMARY:
'[Replace$] replaces all instances of the [Find] sub-string with the [Add] sub-string within the [Text] string.
'INPUT:
'Text: The input string; the text that's being manipulated.
'Find: The specified sub-string; the string sought within the [Text] string.
'Add: The sub-string that's being added to the [Text] string.

Function Replace$ (Text1 As String, Find1 As String, Add1 As String)
    ' VARIABLES:
    Dim Text2 As String
    Dim Find2 As String
    Dim Add2 As String
    Dim lngLocation As Long ' The address of the [Find] substring within the [Text] string.
    Dim strBefore As String ' The characters before the string to be replaced.
    Dim strAfter As String ' The characters after the string to be replaced.

    ' INITIALIZE:
    ' MAKE COPIESSO THE ORIGINAL IS NOT MODIFIED (LIKE ByVal IN VBA)
    Text2 = Text1
    Find2 = Find1
    Add2 = Add1

    lngLocation = InStr(1, Text2, Find2)

    ' PROCESSING:
    ' While [Find2] appears in [Text2]...
    While lngLocation
        ' Extract all Text2 before the [Find2] substring:
        strBefore = Left$(Text2, lngLocation - 1)

        ' Extract all text after the [Find2] substring:
        strAfter = Right$(Text2, ((Len(Text2) - (lngLocation + Len(Find2) - 1))))

        ' Return the substring:
        Text2 = strBefore + Add2 + strAfter

        ' Locate the next instance of [Find2]:
        lngLocation = InStr(1, Text2, Find2)

        ' Next instance of [Find2]...
    Wend

    ' OUTPUT:
    Replace$ = Text2
End Function ' Replace$

'' /////////////////////////////////////////////////////////////////////////////
'
'Sub ReplaceTest
'    Dim in$
'
'    Print "-------------------------------------------------------------------------------"
'    Print "ReplaceTest"
'    Print
'
'    Print "Original value"
'    in$ = "Thiz iz a teZt."
'    Print "in$ = " + Chr$(34) + in$ + Chr$(34)
'    Print
'
'    Print "Replacing lowercase " + Chr$(34) + "z" + Chr$(34) + " with " + Chr$(34) + "s" + Chr$(34) + "..."
'    in$ = Replace$(in$, "z", "s")
'    Print "in$ = " + Chr$(34) + in$ + Chr$(34)
'    Print
'
'    Print "Replacing uppercase " + Chr$(34) + "Z" + Chr$(34) + " with " + Chr$(34) + "s" + Chr$(34) + "..."
'    in$ = Replace$(in$, "Z", "s")
'    Print "in$ = " + Chr$(34) + in$ + Chr$(34)
'    Print
'
'    Print "ReplaceTest finished."
'End Sub ' ReplaceTest

' /////////////////////////////////////////////////////////////////////////////
' https://qb64phoenix.com/forum/showthread.php?tid=644
' From: bplus
' Date: 07-18-2022, 03:16 PM
' Here is a Round$ that acts the way you'd expect in under 100 LOC
' b = b + ...

Function Round$ (anyNumber, dp As Long)
    ' 5 and up at decimal place dp+1 > +1 at decimal place   4 and down  > +0 at dp
    ' 2 1 0.-1 -2 -3 -4 ...  pick dp like this for this Round$ Function
    sn$ = N2S$(Str$(anyNumber + .5 * 10 ^ dp)) ' get rid of sci notation, steve trims it so next find dot
    dot = InStr(sn$, ".")
    If dot Then
        predot = dot - 1
        postdot = Len(sn$) - (dot + 1)
    Else
        predot = Len(sn$)
        postdot = 0
    End If
    ' xxx.yyyyyy  dp = -2
    '      ^ dp
    If dp >= 0 Then
        Rtn$ = Mid$(sn$, 1, predot - dp) + String$(dp, "0")
    Else
        Rtn$ = Mid$(sn$, 1, predot) + "." + Mid$(sn$, dot + 1, -dp)
    End If
    If Rtn$ = "" Then
        Round$ = "0"
    Else
        Round$ = Rtn$
    End If
End Function ' Round$

'' /////////////////////////////////////////////////////////////////////////////
'
'Sub RoundTest
'   Print Round$(.15, 0) '  0
'   Print Round$(.15, -1) ' .2
'   Print Round$(.15, -2) ' .15
'   Print Round$(.15, -3) ' .150
'   Print
'   Print Round$(3555, 0) ' 3555
'   Print Round$(3555, 1) ' 3560
'   Print Round$(3555, 2) ' 3600 'good
'   Print Round$(3555, 3) ' 4000
'   Print
'   Print Round$(23.149999, -1) ' 23.1
'   Print Round$(23.149999, -2) ' 23.15
'   Print Round$(23.149999, -3) ' 23.150
'   Print Round$(23.149999, -4) ' 23.1500
'   Print
'   Print Round$(23.143335, -1) ' 23.1 OK?
'   Print Round$(23.143335, -2) ' 23.14
'   Print Round$(23.143335, -3) ' 23.143
'   Print Round$(23.143335, -4) ' 23.1433
'   Print Round$(23.143335, -5) ' 23.14334
'   Print
'   Dim float31 As _Float
'   float31 = .310000000000009
'   Print Round$(.31, -2) ' .31
'   Print Round$(.31##, -2)
'   Print Round$(float31, -2)
'End Sub ' RoundTest

' /////////////////////////////////////////////////////////////////////////////
' TODO: verify these work (function Round$ works)

' https://www.qb64.org/forum/index.php?topic=3605.0
' Quote from: SMcNeill on Today at 03:53:48 PM
'
' Sometimes, you guys make things entirely too complicated.
' There ya go!  Three functions to either round naturally,
' always round down, or always round up, to whatever number of digits you desire.
' EDIT: Modified to add another option to round scientific,
' since you had it's description included in your example.

Function RoundNatural## (num##, digits%)
    RoundNatural## = Int(num## * 10 ^ digits% + .5) / 10 ^ digits%
End Function

Function RoundUp## (num##, digits%)
    RoundUp## = _Ceil(num## * 10 ^ digits%) / 10 ^ digits%
End Function

Function RoundDown## (num##, digits%)
    RoundDown## = Int(num## * 10 ^ digits%) / 10 ^ digits%
End Function

Function Round_Scientific## (num##, digits%)
    Round_Scientific## = _Round(num## * 10 ^ digits%) / 10 ^ digits%
End Function

Function RoundUpDouble# (num#, digits%)
    RoundUpDouble# = _Ceil(num# * 10 ^ digits%) / 10 ^ digits%
End Function

Function RoundUpSingle! (num!, digits%)
    RoundUpSingle! = _Ceil(num! * 10 ^ digits%) / 10 ^ digits%
End Function

' /////////////////////////////////////////////////////////////////////////////
' fantastically inefficient way to set a bit

' example use: arrMaze(iX, iY) = SetBit256%(arrMaze(iX, iY), cS, FALSE)

' See also: GetBit256%, SetBit256%

' newint=SetBit256%(oldint, int containing the bits we want to set, value to set them to)
Function SetBit256% (iNum1 As Integer, iBit1 As Integer, bVal1 As Integer)
    Dim sNum As String
    Dim sBit As String
    Dim sVal As String
    Dim iLoop As Integer
    Dim strResult As String
    Dim iResult As Integer
    Dim iNum As Integer: iNum = iNum1
    Dim iBit As Integer: iBit = iBit1
    Dim bVal As Integer: bVal = bVal1

    If iNum < 256 And iBit <= 128 Then
        sNum = GetBinary$(iNum)
        sBit = GetBinary$(iBit)
        If bVal = TRUE Then
            sVal = "1"
        Else
            sVal = "0"
        End If
        strResult = ""
        For iLoop = 1 To 8
            If Mid$(sBit, iLoop, 1) = "1" Then
                strResult = strResult + sVal
            Else
                strResult = strResult + Mid$(sNum, iLoop, 1)
            End If
        Next iLoop
        iResult = GetIntegerFromBinary%(strResult)
    Else
        iResult = iNum
    End If

    SetBit256% = iResult
End Function ' SetBit256%

' /////////////////////////////////////////////////////////////////////////////
' TODO: verify this works

' Scientific notation - QB64 Wiki
' https://www.qb64.org/wiki/Scientific_notation

' Example: A string function that displays extremely small or large exponential decimal values.

Function SngToStr$ (n!)
    value$ = UCase$(LTrim$(Str$(n!)))
    Xpos% = InStr(value$, "D") + InStr(value$, "E") 'only D or E can be present
    If Xpos% Then
        expo% = Val(Mid$(value$, Xpos% + 1))
        If Val(value$) < 0 Then
            sign$ = "-": valu$ = Mid$(value$, 2, Xpos% - 2)
        Else valu$ = Mid$(value$, 1, Xpos% - 1)
        End If
        dot% = InStr(valu$, "."): L% = Len(valu$)
        If expo% > 0 Then add$ = String$(expo% - (L% - dot%), "0")
        If expo% < 0 Then min$ = String$(Abs(expo%) - (dot% - 1), "0"): DP$ = "."
        For n = 1 To L%
            If Mid$(valu$, n, 1) <> "." Then num$ = num$ + Mid$(valu$, n, 1)
        Next
    Else SngToStr$ = value$: Exit Function
    End If
    SngToStr$ = _Trim$(sign$ + DP$ + min$ + num$ + add$)
End Function ' SngToStr$

' /////////////////////////////////////////////////////////////////////////////
' Split and join strings
' https://www.qb64.org/forum/index.php?topic=1073.0
'
' FROM luke, QB64 Developer
' Date: February 15, 2019, 04:11:07 AM
'
' Given a string of words separated by spaces (or any other character),
' splits it into an array of the words. I've no doubt many people have
' written a version of this over the years and no doubt there's a million
' ways to do it, but I thought I'd put mine here so we have at least one
' version. There's also a join function that does the opposite
' array -> single string.
'
' Code is hopefully reasonably self explanatory with comments and a little demo.
' Note, this is akin to Python/JavaScript split/join, PHP explode/implode.

'Split in$ into pieces, chopping at every occurrence of delimiter$. Multiple consecutive occurrences
'of delimiter$ are treated as a single instance. The chopped pieces are stored in result$().
'
'delimiter$ must be one character long.
'result$() must have been REDIMmed previously.

' Modified to handle multi-character delimiters

Sub split (in$, delimiter$, result$())
    Dim start As Integer
    Dim finish As Integer
    Dim iDelimLen As Integer
    ReDim result$(-1)

    iDelimLen = Len(delimiter$)

    start = 1
    Do
        'While Mid$(in$, start, 1) = delimiter$
        While Mid$(in$, start, iDelimLen) = delimiter$
            'start = start + 1
            start = start + iDelimLen
            If start > Len(in$) Then
                Exit Sub
            End If
        Wend
        finish = InStr(start, in$, delimiter$)
        If finish = 0 Then
            finish = Len(in$) + 1
        End If

        ReDim _Preserve result$(0 To UBound(result$) + 1)

        result$(UBound(result$)) = Mid$(in$, start, finish - start)
        start = finish + 1
    Loop While start <= Len(in$)
End Sub ' split

'' /////////////////////////////////////////////////////////////////////////////
'
'Sub SplitTest
'    Dim in$
'    Dim delim$
'    ReDim arrTest$(0)
'    Dim iLoop%
'
'    delim$ = Chr$(10)
'    in$ = "this" + delim$ + "is" + delim$ + "a" + delim$ + "test"
'    Print "in$ = " + Chr$(34) + in$ + Chr$(34)
'    Print "delim$ = " + Chr$(34) + delim$ + Chr$(34)
'    split in$, delim$, arrTest$()
'
'    For iLoop% = LBound(arrTest$) To UBound(arrTest$)
'        Print "arrTest$(" + LTrim$(RTrim$(Str$(iLoop%))) + ") = " + Chr$(34) + arrTest$(iLoop%) + Chr$(34)
'    Next iLoop%
'    Print
'    Print "Split test finished."
'End Sub ' SplitTest

'' /////////////////////////////////////////////////////////////////////////////
'
'Sub SplitAndReplaceTest
'    Dim in$
'    Dim out$
'    Dim iLoop%
'    ReDim arrTest$(0)
'
'    Print "-------------------------------------------------------------------------------"
'    Print "SplitAndReplaceTest"
'    Print
'
'    Print "Original value"
'    in$ = "This line 1 " + Chr$(13) + Chr$(10) + "and line 2" + Chr$(10) + "and line 3 " + Chr$(13) + "finally THE END."
'    out$ = in$
'    out$ = Replace$(out$, Chr$(13), "\r")
'    out$ = Replace$(out$, Chr$(10), "\n")
'    out$ = Replace$(out$, Chr$(9), "\t")
'    Print "in$ = " + Chr$(34) + out$ + Chr$(34)
'    Print
'
'    Print "Fixing linebreaks..."
'    in$ = Replace$(in$, Chr$(13) + Chr$(10), Chr$(13))
'    in$ = Replace$(in$, Chr$(10), Chr$(13))
'    out$ = in$
'    out$ = Replace$(out$, Chr$(13), "\r")
'    out$ = Replace$(out$, Chr$(10), "\n")
'    out$ = Replace$(out$, Chr$(9), "\t")
'    Print "in$ = " + Chr$(34) + out$ + Chr$(34)
'    Print
'
'    Print "Splitting up..."
'    split in$, Chr$(13), arrTest$()
'
'    For iLoop% = LBound(arrTest$) To UBound(arrTest$)
'        out$ = arrTest$(iLoop%)
'        out$ = Replace$(out$, Chr$(13), "\r")
'        out$ = Replace$(out$, Chr$(10), "\n")
'        out$ = Replace$(out$, Chr$(9), "\t")
'        Print "arrTest$(" + cstr$(iLoop%) + ") = " + Chr$(34) + out$ + Chr$(34)
'    Next iLoop%
'    Print
'
'    Print "SplitAndReplaceTest finished."
'End Sub ' SplitAndReplaceTest

' /////////////////////////////////////////////////////////////////////////////
' Converts a chr$(13) delimited string
' into a 2-dimensional array.

' Usage:
' Dim StringArray(1 To 48, 1 To 128) As String
' StringTo2dArray StringArray(), GetMap$

' Version 2 with indexed array(row, columm)
' Renamed StringToArray to StringTo2dArray.

' See also: Array2dToString$

Sub StringTo2dArray (MyArray() As String, MyString As String)
    Dim sDelim As String
    ReDim arrLines(0) As String
    Dim iRow As Integer
    Dim iCol As Integer
    Dim sChar As String
    Dim iDim1 As Integer
    Dim iDim2 As Integer
    Dim iIndex1 As Integer
    Dim iIndex2 As Integer

    iDim1 = LBound(MyArray, 1)
    iDim2 = LBound(MyArray, 2)
    sDelim = Chr$(13)
    split MyString, sDelim, arrLines()
    For iRow = LBound(arrLines) To UBound(arrLines)
        If iRow <= UBound(MyArray, 1) Then
            For iCol = 1 To Len(arrLines(iRow))
                If iCol <= UBound(MyArray, 2) Then
                    sChar = Mid$(arrLines(iRow), iCol, 1)

                    If Len(sChar) > 1 Then
                        sChar = Left$(sChar, 1)
                    Else
                        If Len(sChar) = 0 Then
                            sChar = "."
                        End If
                    End If

                    iIndex1 = iRow + iDim1
                    iIndex2 = (iCol - 1) + iDim2
                    MyArray(iIndex1, iIndex2) = sChar
                    'DebugPrint "MyArray(" + cstr$(iIndex1) + ", " + cstr$(iIndex2) + " = " + chr$(34) + sChar + chr$(34)
                Else
                    ' Exit if out of bounds
                    Exit For
                End If
            Next iCol
        Else
            ' Exit if out of bounds
            Exit For
        End If
    Next iRow
End Sub ' StringTo2dArray

' /////////////////////////////////////////////////////////////////////////////

Function StrPadLeft$ (sValue As String, iWidth As Integer)
    StrPadLeft$ = Right$(String$(iWidth, " ") + sValue, iWidth)
End Function ' StrPadLeft$

' /////////////////////////////////////////////////////////////////////////////

Function StrJustifyRight$ (sValue As String, iWidth As Integer)
    StrJustifyRight$ = Right$(String$(iWidth, " ") + sValue, iWidth)
End Function ' StrJustifyRight$

' /////////////////////////////////////////////////////////////////////////////

Function StrPadRight$ (sValue As String, iWidth As Integer)
    StrPadRight$ = Left$(sValue + String$(iWidth, " "), iWidth)
End Function ' StrPadRight$

' /////////////////////////////////////////////////////////////////////////////

Function StrJustifyLeft$ (sValue As String, iWidth As Integer)
    StrJustifyLeft$ = Left$(sValue + String$(iWidth, " "), iWidth)
End Function ' StrJustifyLeft$

' /////////////////////////////////////////////////////////////////////////////
' div: int1% = num1% \ den1%
' mod: rem1% = num1% MOD den1%

Function StrJustifyCenter$ (sValue As String, iWidth As Integer)
    Dim iLen0 As Integer
    Dim iLen1 As Integer
    Dim iLen2 As Integer
    Dim iExtra As Integer

    iLen0 = Len(sValue)
    If iWidth = iLen0 Then
        ' no extra space: return unchanged
        StrJustifyCenter$ = sValue
    ElseIf iWidth > iLen0 Then
        If IsOdd%(iWidth) Then
            iWidth = iWidth - 1
        End If

        ' center
        iExtra = iWidth - iLen0
        iLen1 = iExtra \ 2
        iLen2 = iLen1 + (iExtra Mod 2)
        StrJustifyCenter$ = String$(iLen1, " ") + sValue + String$(iLen2, " ")
    Else
        ' string is too long: truncate
        StrJustifyCenter$ = Left$(sValue, iWidth)
    End If
End Function ' StrJustifyCenter$

' /////////////////////////////////////////////////////////////////////////////
' Use to pretty print TRUE and FALSE values.

Function TrueFalse$ (myValue)
    If myValue = TRUE Then
        TrueFalse$ = "TRUE"
    Else
        TrueFalse$ = "FALSE"
    End If
End Function ' TrueFalse$

' /////////////////////////////////////////////////////////////////////////////
' ABS was returning strange values with type _UNSIGNED LONG
' so I created this which does not.

' See also: LongABS

Function UnsignedLongABS~& (ulValue As _Unsigned Long)
    If Sgn(ulValue) = -1 Then
        UnsignedLongABS~& = 0 - ulValue
    Else
        UnsignedLongABS~& = ulValue
    End If
End Function ' UnsignedLongABS~&

' /////////////////////////////////////////////////////////////////////////////

Sub WaitForEnter
    Dim in$
    Input "Press <ENTER> to continue", in$
End Sub ' WaitForEnter

' /////////////////////////////////////////////////////////////////////////////
' WaitForKey "Press <ESC> to continue", 27, 0
' WaitForKey "Press <ENTER> to begin;", 13, 0
' waitforkey "", 65, 5

Sub WaitForKey (prompt$, KeyCode&, DelaySeconds%)
    ' SHOW PROMPT (IF SPECIFIED)
    If Len(prompt$) > 0 Then
        If Right$(prompt$, 1) <> ";" Then
            Print prompt$
        Else
            Print Right$(prompt$, Len(prompt$) - 1);
        End If
    End If

    ' WAIT FOR KEY
    Do: Loop Until _KeyDown(KeyCode&) ' leave loop when specified key pressed

    ' PAUSE AFTER (IF SPECIFIED)
    If DelaySeconds% < 1 Then
        _KeyClear: '_DELAY 1
    Else
        _KeyClear: _Delay DelaySeconds%
    End If
End Sub ' WaitForKey

' ################################################################################################################################################################
' END GENERAL ROUTINES @GENERAL
' ################################################################################################################################################################




' /////////////////////////////////////////////////////////////////////////////
' INCLUDE LIBRARIES (TBD)

'$/INCLUDE: 'string_functions.bas'

' /////////////////////////////////////////////////////////////////////////////

' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
' BEGIN FEATURES #FEATURES #IDEAS
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
' THINGS TO MAKE IT MORE INTERESTING:
' Allow players to demolish/build/move walls, secret doors/passages, teleportation, etc.
' objects: ladders, bombs, objects that speed you up
' Button briefly shows map of maze on screen (limited # of uses)
' Track # of map uses (less with difficulty?)
' terrain: water, etc. (some slow you down, require vehicle, etc.)
' portals / hidden passages
' keys/locked doors
' traps
' NPCs catch you and put you in jail / back to start
' NPCs take your flag and move it
' game variants
' * capture the flag
' * each player gets x bricks and can build/modify their own fort
' * maze war construction set
' * hide & seek
' * War game offshoot: change players to Berzerk style stick figures with Combat style tanks that they can use, with team play, capture the flag variant, etc.

' MORE TO DO
' Flag object
' Pick up / drop item
' Can hold 2 items?
' Items point in direction player moves? (maybe make this an option?)
' breadcrumb objects
' speed potion (random can be faster or slower)
' speed potion antidote (returns speed to previous)
' player-specific blank space (all except given player are slower on it)
' letter tiles / signs
' GPS object = tells coordinates
' shovel object = to dig up buried objects or re-bury objects (disturbed dirt visible when near?)
' buried objects (keys)
' treasure map object = tells coordinates or directions to buried objects
' smooth movement / smooth scrolling
' hidden doors or portals to get into outer area which will contain fun stuff
' mazes in outer area (1 for each player, randomize which is where?)
'
' PHASE 1 = 1 BASIC GAME
' Randomly drop 4 flags each
' (1 in each maze)
' Goal is to collect all 4 and return to base
'
' PHASE 2 = KEYS/DOORS
' Key object
' Door terrain
' Key must match door (same color)
' Keys that don't just match color but also # of prongs?
' Master key for a given maze?
' Master key for entire world? (disappears after x time?)
' How do keys work ie only allow you to pass one way? can you leave a door locked/unlcoked?
'
' Game rules "Travels"
'     1. Start in maze 1
'     2. Key in maze 2
'     3. Flag in maze 3 (flag inside locked room)
'     4. Home in maze 4
'
' Keys
'     1. Front door
'     2. Back door
'     3. Flag room
'     4. Secret passage
'
' Forbidden Zone = area outside of the playing area, usually walled off, but make accessible with special keys?
'     * Contains special objects?
'     * hidden passages?
'     * dragons / creatures?
'
' CONTROLLERS
'     * support gamepads?
'     * multiple mice / keyboards using Raw Input API
'
' PHASE 3 = COMPUTER OPPONENTS
' computer players AI?
'
' GRAPHICS / RENDERING
' add texture to walls to see movement when moving down halls?
' 32x32 tiles?
' Choose point of view (or multiple simultaneous)
'     * overhead 2-D (Adventure)
'     * isometric
'     * 3D first person
' Hires tiles - bit blitting?
'     * Photoreal tiles (Legos)
'     * Hand drawn tiles (graphy paper)
' option for smooth movement/scrolling or tile-by-tile?
'
' GAME OPTIONS
' Each player can edit their own area before start of round
' 3 doors/keys for each player
'
' BASIC OBJECTS #1
' Bat
' Ladder
' Magnet
' Chalice
' Dragons
' Sword
'
' SPECIAL OBJECTS #1
' Lantern
' Flashlight
' opera glasses give "second sight" (allow player to change display from flip screen to scrolling & back)
'
' "I've got electric light, And I've got second sight, I got amazing powers of observation"
'
' Overhead lights (players can turn on/off light switch!)
'     * each switch controls light for entire maze or a certain area in the maze
'     * can be multiple switches for the same area
'
' paint - allows player to change the color of an object (to disguise it!)
' paint remover - removes paint disguise, but can also remove color of a non-painted object!
'
' Notes + combination locks (or passwords)
'     * Plain text or encrypted
'     * Some notes have encryption keys (or partial encryption key)
'
' binoculars allow player to see farther away (temporarily change display to miniature map?)
'
' SPECIAL OBJECTS #2
' Shoot to stun
' Rearview mirror enables player to see behind them (if we are using POV vision)
' Mirrors enable around corners (if we are using POV vision)
'
' MAGIC OBJECTS #1
' Speed potion - speeds up player for x moves or time
' Sleepy potion - slows down player for x moves or time
'
' TERRAIN
' Shadow squares
' Darkness / light (need lantern / flashlight)
'     * Line of sight (maybe with flashlight object, in dark)
' Obstacles affect speed (eg swamp, water)
' Secret passages
' Warps
' False doors
' One way doors
' Obstacles / moving walls / etc.
' Obstacle that makes you drop objects when going one way (n/s/e/w)
' Spirals, queues, concentric circles, other shapes
' Traps (release NPC, slow down player, transport player somewhere inconvenient)
'
'
' MAGIC OBJECTS #2
' Shrink / growth potion
' Players can shrink & grow ("drink me")
'     * Your on screen character stays the same size & the world around you grows or shrinks (ie size stays relative)
'     * When you change size, you can't hold objects your old size could (you drop them)
'     * When you're small,
'         - you can fit in places you can't when you're bigger,
'         - players 1 size bigger can pick you up,
'         - players 2 sizes bigger can't see you (without a magnifying glass?),
'         - you can see / pick up & use small objects,
'         - you move slower over long distances
'         - Players and objects 2 sizes bigger just behave like walls?
'         - Can you fit under a locked door?
'         - Can you hide inside or stow away inside an object or player 2 sizes bigger?
'         - Can you be "swept away" or "squashed" by players 2 sizes bigger?
'     * When you're bigger,
'         - you can pick up & use larger objects,
'         - you can pick up & carry smaller players
'             + If 2x smaller you need magnifying glass to see, tweezers to pick up, can you put them in a box & they can't get out until you take the lid off?
'         - you move faster over long distances,
'         - you can open bigger doors,
'         - Can you step over walls and barriers?
'         - you don't fit in smaller spaces
'     * V1 = 3 sizes (small, medium, large)
'     * V2 = 6 sizes (microscopic, flea, small, regular, large, giant)?
'
' NPCs
' robot players (can choose difficulty / intelligence)
' bats
' (other animals?)
' programmable robots?
' Pac Man chases player, Ghosts kill Pac Man (don't hurt player)

' Other options
' * Players can't go into each others' mazes

' ----------------------------------------------------------------------------------------------------------------------------------------------------------------
' END FEATURES @FEATURES @IDEAS
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------