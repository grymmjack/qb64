''
' MENU BAR EXAMPLE
'
' Shows some basic mouse and graphics stuff with font calculations
' with a goal to be compatible with 256 color screen modes of any 
' width and height.
'
' @author Rick Christy <grymmjack@gmail.com>
'

'$DYNAMIC
OPTION _EXPLICIT ' Require DIM for variables

' SETUP SCREEN
_FULLSCREEN _SQUAREPIXELS ' Optional: Comment out for window mode
SCREEN _NEWIMAGE(_DESKTOPWIDTH, _DESKTOPHEIGHT, 256) ' Optional: SCREEN 13

' Color constants (C_)
CONST C_MENU_BACKGROUND                  = 1
CONST C_MENU_BORDER                      = 9
CONST C_MENU_FOREGROUND                  = 7
CONST C_MENU_BACKGROUND_HIGHLIGHT        = 1
CONST C_MENU_BORDER_HIGHLIGHT            = 11
CONST C_MENU_OPTION_HIGHLIGHT            = 0
CONST C_MENU_OPTION_BACKGROUND_HIGHLIGHT = 15
CONST C_MENU_OPTION_CLICKED              = 10
CONST C_MENU_OPTION_BACKGROUND_CLICKED   = 2
CONST C_DBC_BACKGROUND                   = 13
CONST C_DBC_FOREGROUND                   = 14

' Geometry constants (G_)
CONST G_MENU_PADDING = 2
CONST G_DBC_PADDING  = 10
CONST G_DBC_ROWS     = 5

' Setup Menu
DIM AS INTEGER MenuIndex(99), MenuOptionsIndex(99)
DIM MenuOptions(99) AS STRING
RESTORE MenuData
DIM i AS INTEGER
DIM token AS INTEGER
i% = 0
DO:
    READ token%
    IF token% <> -1 THEN
        MenuIndex(i%) = token%
        READ MenuOptionsIndex(i%)
        READ MenuOptions$(i%)
        i% = i% + 1
    END IF
LOOP UNTIL token% = -1
REDIM _PRESERVE MenuIndex(i%)
REDIM _PRESERVE MenuOptionsIndex(i%)
REDIM _PRESERVE MenuOptions(i%)

' @TODO: Populate MenuBar using arrays
_PRINTSTRING (0, 100), _
    STR$(MenuIndex(0)) + "," _
    + STR$(MenuOptionsIndex(0)) _
    + "," + MenuOptions$(0) _
    + "," + STR$(LBOUND(MenuOptionsIndex)) _
    + "," + STR$(UBOUND(MenuOptionsIndex))

MenuData:
    DATA 0, 1, "FILE"
        DATA 1, 0, "NEW"
        DATA 1, 1, "SAVE"
        DATA 1, 2, "-"
        DATA 1, 3, "QUIT"
    DATA 0, 2, "EDIT"
        DATA 2, 0, "COPY"
        DATA 2, 1, "PASTE"
    DATA -1

' Custom palette colors
_PALETTECOLOR 13, _RGB32(16, 16, 16)
_PALETTECOLOR 14, _RGB32(96, 96, 96)

' Mouse constants (M_)
CONST M_LEFT_CLICK   = 1
CONST M_RIGHT_CLICK  = 2
CONST M_MIDDLE_CLICK = 3

' Show the mouse pointer
_MOUSESHOW "CROSSHAIR"

' Mouse over check variables (mo_) 0 = mouse not over, 1 = mouse is over
DIM mo_Menu AS INTEGER      
DIM mo_MenuFile AS INTEGER
' Mouse click check variables
DIM mo_LeftClick AS INTEGER
DIM mo_RightClick AS INTEGER
DIM mo_MiddleClick AS INTEGER



' MAIN LOOP
' =========
DIM k AS INTEGER
DO:
    _LIMIT 30 ' Limit to 30 FPS to save CPU
    k = _KEYHIT ' Get code of key hit if any


    ' MOUSE LOOP
    ' ----------
    ' _MOUSEINPUT is required to poll the mouse
    DO WHILE _MOUSEINPUT:
        ' See if any buttons are clicked
        mo_LeftClick   = _MOUSEBUTTON(M_LEFT_CLICK)
        mo_RightClick  = _MOUSEBUTTON(M_RIGHT_CLICK)
        mo_MiddleClick = _MOUSEBUTTON(M_MIDDLE_CLICK)

        ' Check if mouse is over any part of the menu bar
        mo_Menu = isMouseOver( _
            0, 0, _WIDTH, _FONTHEIGHT + G_MENU_PADDING _
        )
        ' Check if the mouse is over the file option of the menu bar
        mo_MenuFile = isMouseOver( _
            0, 0, _FONTWIDTH * LEN("FILE"), _FONTHEIGHT + G_MENU_PADDING _
        )
    LOOP


    ' Draw the base menu bar as the lowest z-order behind everything else
    DrawMenuBar

    ' If the mouse is over any part of the menu bar...
    IF mo_Menu THEN 
        DrawMenuBarHighlighted ' ...highlight it
    END IF

    ' If the mouse is over the file option in the menu bar...
    IF mo_MenuFile THEN 
        ' ...highlight the option
        DrawMenuBarOptionHighlighted _
            1, _
            1, _
            _FONTWIDTH * LEN("FILE"), _
            _FONTHEIGHT, _
            "FILE"
    END IF

    ' If the mouse is over the file option and left clicking...
    IF mo_MenuFile AND mo_LeftClick THEN
        ' ...show the option as clicked
        DrawMenuBarOptionClicked _
            1, _
            1, _
            _FONTWIDTH * LEN("FILE"), _
            _FONTHEIGHT, _
            "FILE"
    END IF

    ' Draw the debug console including mouse position
    DebugConsole _
        "mo_Menu:" + STR$(mo_Menu) _
        + ", mo_MenuFile:" + STR$(mo_MenuFile) _
        + "," + STR$(_MOUSEX) + "," + STR$(_MOUSEY)

    
    ' Call display to prevent flickering
    _DISPLAY
    
LOOP UNTIL k = 27 ' ESC to quit

END



''
' Draws the menu bar without any highlighting
'
SUB DrawMenuBar()
    _PRINTMODE _KEEPBACKGROUND

    DrawRectStroked _
        0, _
        0, _
        _WIDTH - 1, _
        _FONTHEIGHT + G_MENU_PADDING, _
        C_MENU_BACKGROUND, _
        C_MENU_BORDER

    COLOR C_MENU_FOREGROUND
    _PRINTSTRING (G_MENU_PADDING, G_MENU_PADDING), "FILE"
END SUB


''
' Draws the menu bar highlighted when the mouse is over it
'
SUB DrawMenuBarHighlighted()
    _PRINTMODE _KEEPBACKGROUND

    DrawRectStroked _
        0, _
        0, _
        _WIDTH - 1, _
        _FONTHEIGHT + G_MENU_PADDING, _
        C_MENU_BACKGROUND_HIGHLIGHT, _
        C_MENU_BORDER_HIGHLIGHT

    COLOR C_MENU_FOREGROUND
    _PRINTSTRING (G_MENU_PADDING, G_MENU_PADDING), "FILE"
END SUB


''
' Draws a menu option highlighted when the mouse is over an option
' 
' @param posX Starting X position of menu bar option
' @param posY Starting Y position of menu bar option
' @param width The width of the menu bar option
' @param height the height of the menu bar option
' @param option$ The text of the menu bar option
'
SUB DrawMenuBarOptionHighlighted(posX%, posY%, width%, height%, option$)
    _PRINTMODE _KEEPBACKGROUND

    DrawRect _
        posX%, _
        posY%, _
        width%, _
        height%, _
        C_MENU_OPTION_BACKGROUND_HIGHLIGHT

    COLOR C_MENU_OPTION_HIGHLIGHT
    _PRINTSTRING (G_MENU_PADDING, G_MENU_PADDING), option$
END SUB


''
' Draws a menu option clicked when the mouse is left clicking an option
' 
' @param posX Starting X position of menu bar option
' @param posY Starting Y position of menu bar option
' @param width The width of the menu bar option
' @param height the height of the menu bar option
' @param option$ The text of the menu bar option
'
SUB DrawMenuBarOptionClicked(posX%, posY%, width%, height%, option$)
    _PRINTMODE _KEEPBACKGROUND

    DrawRect _
        posX%, _
        posY%, _
        width%, _
        height%, _
        C_MENU_OPTION_BACKGROUND_CLICKED

    COLOR C_MENU_OPTION_CLICKED
    _PRINTSTRING (G_MENU_PADDING, G_MENU_PADDING), option$
END SUB


''
' Draws the bottom debug console area
' 
' @param message$ Message to show in the console
'
SUB DebugConsole(message$)
    DIM cols AS INTEGER
    DIM rows AS INTEGER
    
    COLOR C_DBC_FOREGROUND, C_DBC_BACKGROUND

    cols = fontColsAvailable(_WIDTH)
    rows = fontRowsAvailable(_HEIGHT)

    DrawRect _
        0, _
        _HEIGHT - _FONTHEIGHT * G_DBC_ROWS - G_DBC_PADDING * 2, _
        _WIDTH, _
        _HEIGHT, _
        C_DBC_BACKGROUND

    ' Erase console
    _PRINTMODE _FILLBACKGROUND

    DIM i AS INTEGER
    FOR i% = 1 TO G_DBC_ROWS
        _PRINTSTRING _
            ( _
                G_DBC_PADDING, _
                _HEIGHT - _FONTHEIGHT * i% - G_DBC_PADDING _
            ), _
            SPACE$(cols)
    NEXT i%

    ' Print console
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING _
        ( _
            G_DBC_PADDING, _
            _HEIGHT - _FONTHEIGHT * G_DBC_ROWS - G_DBC_PADDING _
        ), _
        message$ 
END SUB


''
' Determines how many rows of text are available for current font (height)
'
' @param height Total height of area to calculate
' @return INTEGER
'
FUNCTION fontRowsAvailable(height%)
    fontRowsAvailable = height% \ _FONTHEIGHT
END FUNCTION


''
' Determines how many columns of text are available for current font (width)
'
' @param width Total width of area to calculate
' @return INTEGER
'
FUNCTION fontColsAvailable(width%)
    fontColsAvailable = width% \ _FONTWIDTH
END FUNCTION


'' 
' Repeats a string n times
'
' @param times Number of times to repeat the string
' @param the_string The string to repeat
' @return STRING
'
FUNCTION strRepeat$(times%, theString$)
    DIM s AS STRING
    s$ = ""
    
    DIM i AS INTEGER
    FOR i% = 0 TO times%
        s$ = s$ + theString$
    NEXT i%
    
    strRepeat = s$
END FUNCTION


''
' Determines if the mouse is over a rectangle
'
' @param posX Rectangle starting X position
' @param posY Rectangle starting Y position
' @param width Rectangle width
' @param height Rectangle height
' @return BOOLEAN 0 if mouse not over, 1 if mouse is over
'
FUNCTION isMouseOver(posX%, posY%, width%, height%)
    DIM mX AS INTEGER
    DIM mY AS INTEGER

    mX% = _MOUSEX
    mY% = _MOUSEY

    isMouseOver = ABS( _
        (mX% >= posX% AND mX% <= posX% + width%) _
        AND _
        (mY% >= posY% AND mY% <= posY% + height%) _
    )
END FUNCTION


''
' Draw a rectangle with a stroked outline
' 
' @param posX Rectangle starting X position
' @param posY Rectangle starting Y position
' @param width Rectangle width
' @param height Rectangle height
' @param bgColor Palette index of background color
' @param fgColor Palette index of foreground color
'
SUB DrawRectStroked(posX%, posY%, width%, height%, bgColor%, fgColor%)
    DIM boxTop AS INTEGER
    DIM boxLeft AS INTEGER
    DIM boxRight AS INTEGER
    DIM boxBottom AS INTEGER

    boxTop%    = posY%
    boxLeft%   = posX%
    boxRight%  = posX% + width%
    boxBottom% = posY% + height%

    ' Draw filled rectangle first (lower z-order)
    LINE(boxLeft%, boxTop%)-(boxRight%, boxBottom%), bgColor%, BF

    ' Draw unfilled rectangle on top (higher z-order)
    LINE(boxLeft%, boxTop%)-(boxRight%, boxBottom%), fgColor%, B
END SUB


''
' Draw a rectangle without a stroked outline
' 
' @param posX Rectangle starting X position
' @param posY Rectangle starting Y position
' @param width Rectangle width
' @param height Rectangle height
' @param bgColor Palette index of background color
'
SUB DrawRect(posX%, posY%, width%, height%, bgColor%)
    DIM boxTop AS INTEGER
    DIM boxLeft AS INTEGER
    DIM boxRight AS INTEGER
    DIM boxBottom AS INTEGER

    boxTop%    = posY%
    boxLeft%   = posX%
    boxRight%  = posX% + width%
    boxBottom% = posY% + height%

    ' Draw filled rectangle
    LINE(boxLeft%, boxTop%)-(boxRight%, boxBottom%), bgColor%, BF
END SUB
