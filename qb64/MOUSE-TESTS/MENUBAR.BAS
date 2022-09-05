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
DEFINT A-Z

'SETUP SCREEN
_FULLSCREEN _SQUAREPIXELS 'Optional: Comment out for window mode
SCREEN _NEWIMAGE(_DESKTOPWIDTH, _DESKTOPHEIGHT, 256) ' Optional: SCREEN 13

'Color constants (C_)
CONST C_MENU_BACKGROUND                  = 1
CONST C_MENU_BORDER                      = 9
CONST C_MENU_FOREGROUND                  = 7
CONST C_MENU_BACKGROUND_HIGHLIGHT        = 1
CONST C_MENU_BORDER_HIGHLIGHT            = 11
CONST C_MENU_OPTION_HIGHLIGHT            = 0
CONST C_MENU_OPTION_BACKGROUND_HIGHLIGHT = 15
CONST C_MENU_OPTION_CLICKED              = 10
CONST C_MENU_OPTION_BACKGROUND_CLICKED   = 2
CONST C_DBC_BACKGROUND                   = 50
CONST C_DBC_FOREGROUND                   = 51

'Geometry constants (G_)
CONST G_MENU_PADDING = 2
CONST G_DBC_PADDING  = 10
CONST G_DBC_ROWS     = 5

'Mouse button constants
CONST LEFT_CLICK   = 1
CONST RIGHT_CLICK  = 2
CONST MIDDLE_CLICK = 3
'Mouse over (mo_) check variables : 0 = mouse not over, 1 = mouse is over
mo_Menu        = 0
mo_MenuFile    = 0
'Mouse button click check (mc_) variables : 0 = not clicked, 1 = clicked
mc_LeftClick   = 0
mc_RightClick  = 0
mc_MiddleClick = 0

'Custom palette colors
_PALETTECOLOR 50, _RGB32(16, 16, 16)
_PALETTECOLOR 51, _RGB32(96, 96, 96)

'SETUP MENU
TYPE MENU_OPTION
    label     AS STRING
    index     AS INTEGER
    parent    AS INTEGER
    selected  AS INTEGER
    activated AS INTEGER
    visible   AS INTEGER
    width     AS INTEGER
    height    AS INTEGER
    posX      AS INTEGER
    posY      AS INTEGER
END TYPE
DIM Menu(99) AS MENU_OPTION
RESTORE MENU_DATA
CONST END_OF_DATA = -1
i = 0
DO:
    READ parent
    IF parent <> END_OF_DATA THEN
        READ index
        READ label$
        Menu(i).label     = space$(1) + label$ + space$(1)
        Menu(i).index     = index
        Menu(i).parent    = parent
        Menu(i).selected  = 0
        Menu(i).visible   = 0
        Menu(i).activated = 0

        Menu(i).width  = _FONTWIDTH * LEN(Menu(i).label) + (G_MENU_PADDING * 2)
        Menu(i).height = _FONTHEIGHT

        'Calculate menu item positions
        IF parent = 0 THEN 'Top level menu options
            IF index = 1 THEN 'First menu option
                Menu(i).posX = 0 + G_MENU_PADDING 
                Menu(i).posY = 0 + G_MENU_PADDING
            ELSE 'Still top level but not first menu option
                Menu(i).posX = Menu(i-1).posX + Menu(i-1).width + G_MENU_PADDING
                Menu(i).posY = 0 + G_MENU_PADDING
            END IF
        ELSE 'Sub menu options
            Menu(i).posX = Menu(parent-1).posX
            Menu(i).posY = Menu(parent-1).posY + (index * _FONTHEIGHT)
        END IF
        i = i + 1
    END IF
LOOP UNTIL parent = END_OF_DATA
REDIM _PRESERVE Menu(i) AS MENU_OPTION

'Draw menu for test
FOR i = 0 TO UBOUND(Menu)
    _PRINTSTRING (Menu(i).posX, Menu(i).posY), Menu(i).label
NEXT i

MENU_DATA:
    DATA 0, 1, "FILE"
    DATA 0, 2, "EDIT"
    DATA 0, 3, "VIEW"
    DATA 0, 4, "LAST MENU"

    DATA 1, 1, "NEW"
    DATA 1, 2, "SAVE"
    DATA 1, 3, "-"
    DATA 1, 4, "QUIT"

    DATA 2, 1, "COPY"
    DATA 2, 2, "PASTE"

    DATA 3, 1, "TEXT"
    DATA 3, 2, "GRAPHICS"

    DATA 4, 1, "MORE"
    DATA 4, 2, "COMMANDS"

    DATA -1



END



'=========
'MAIN LOOP
'=========
_MOUSESHOW "CROSSHAIR"
DO:
    _LIMIT 30
    k = _KEYHIT '

    '----------
    'MOUSE LOOP
    '----------
    '_MOUSEINPUT is required to poll the mouse
    DO WHILE _MOUSEINPUT:
        ' See if any buttons are clicked
        mc_LeftClick   = _MOUSEBUTTON(LEFT_CLICK)
        mc_RightClick  = _MOUSEBUTTON(RIGHT_CLICK)
        mc_MiddleClick = _MOUSEBUTTON(MIDDLE_CLICK)

        'Check if mouse is over any part of the menu bar
        mo_Menu = isMouseOver( _
            0, 0, _WIDTH, _FONTHEIGHT + G_MENU_PADDING _
        )
        'Check if the mouse is over the file option of the menu bar
        mo_MenuFile = isMouseOver( _
            0, 0, _FONTWIDTH * LEN(" FILE "), _FONTHEIGHT + G_MENU_PADDING _
        )
    LOOP

    'Draw the base menu bar as the lowest z-order behind everything else
    DrawMenuBar

    'Handle mouse input
    IF mo_Menu THEN 
        DrawMenuBarHighlighted
    END IF

    IF mo_MenuFile THEN 
        DrawMenuBarOptionHighlighted _
            1, _
            1, _
            _FONTWIDTH * LEN(" FILE "), _
            _FONTHEIGHT, _
            " FILE "
    END IF

    IF mo_MenuFile AND mc_LeftClick THEN
        DrawMenuBarOptionClicked _
            1, _
            1, _
            _FONTWIDTH * LEN(" FILE "), _
            _FONTHEIGHT, _
            " FILE "
    END IF

    'Draw the debug console including mouse position
    DebugConsole _
        "mo_Menu:" + STR$(mo_Menu) _
        + ", mo_MenuFile:" + STR$(mo_MenuFile) _
        + "," + STR$(_MOUSEX) + "," + STR$(_MOUSEY)

    _DISPLAY 'Call display to prevent flickering
    
LOOP UNTIL k = 27 'ESC to quit

END



SUB DrawMenuBar ()
    _PRINTMODE _KEEPBACKGROUND
    DrawRectStroked _
        0, _
        0, _
        _WIDTH - 1, _
        _FONTHEIGHT + G_MENU_PADDING, _
        C_MENU_BACKGROUND, _
        C_MENU_BORDER
    COLOR C_MENU_FOREGROUND
    _PRINTSTRING (G_MENU_PADDING, G_MENU_PADDING), " FILE "
END SUB


SUB DrawMenuBarHighlighted ()
    _PRINTMODE _KEEPBACKGROUND
    DrawRectStroked _
        0, _
        0, _
        _WIDTH - 1, _
        _FONTHEIGHT + G_MENU_PADDING, _
        C_MENU_BACKGROUND_HIGHLIGHT, _
        C_MENU_BORDER_HIGHLIGHT
    COLOR C_MENU_FOREGROUND
    _PRINTSTRING (G_MENU_PADDING, G_MENU_PADDING), " FILE "
END SUB


SUB DrawMenuBarOptionHighlighted (posX, posY, width, height, option$)
    _PRINTMODE _KEEPBACKGROUND
    DrawRect _
        posX, _
        posY, _
        width, _
        height, _
        C_MENU_OPTION_BACKGROUND_HIGHLIGHT
    COLOR C_MENU_OPTION_HIGHLIGHT
    _PRINTSTRING (G_MENU_PADDING, G_MENU_PADDING), option$
END SUB


SUB DrawMenuBarOptionClicked (posX, posY, width, height, option$)
    _PRINTMODE _KEEPBACKGROUND
    DrawRect _
        posX, _
        posY, _
        width, _
        height, _
        C_MENU_OPTION_BACKGROUND_CLICKED
    COLOR C_MENU_OPTION_CLICKED
    _PRINTSTRING (G_MENU_PADDING, G_MENU_PADDING), option$
END SUB


SUB DebugConsole (message$)
    cols = _WIDTH \ _FONTWIDTH
    rows = _HEIGHT \ _FONTHEIGHT
    COLOR C_DBC_FOREGROUND, C_DBC_BACKGROUND
    DrawRect _
        0, _
        _HEIGHT - _FONTHEIGHT * G_DBC_ROWS - G_DBC_PADDING * 2, _
        _WIDTH, _
        _HEIGHT, _
        C_DBC_BACKGROUND

    'Erase console
    _PRINTMODE _FILLBACKGROUND
    FOR i = 1 TO G_DBC_ROWS
        _PRINTSTRING _
            ( _
                G_DBC_PADDING, _
                _HEIGHT - _FONTHEIGHT * i - G_DBC_PADDING _
            ), _
            SPACE$(cols)
    NEXT i

    'Print console
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING _
        ( _
            G_DBC_PADDING, _
            _HEIGHT - _FONTHEIGHT * G_DBC_ROWS - G_DBC_PADDING _
        ), _
        message$ 
END SUB


FUNCTION isMouseOver (posX, posY, width, height)
    mX = _MOUSEX
    mY = _MOUSEY
    isMouseOver = ABS( _
        (mX >= posX AND mX <= posX + width) _
        AND _
        (mY >= posY AND mY <= posY + height) _
    )
END FUNCTION


SUB DrawRectStroked (posX, posY, width, height, bgColor, fgColor)
    boxTop    = posY
    boxLeft   = posX
    boxRight  = posX + width
    boxBottom = posY + height
    'Draw filled (BF) rectangle first (lower z-order)
    LINE(boxLeft, boxTop)-(boxRight, boxBottom), bgColor, BF
    'Draw unfilled (B) rectangle on top (higher z-order)
    LINE(boxLeft, boxTop)-(boxRight, boxBottom), fgColor, B
END SUB


SUB DrawRect (posX, posY, width, height, bgColor)
    boxTop    = posY
    boxLeft   = posX
    boxRight  = posX + width
    boxBottom = posY + height
    'Draw filled (BF) rectangle
    LINE(boxLeft, boxTop)-(boxRight, boxBottom), bgColor, BF
END SUB
