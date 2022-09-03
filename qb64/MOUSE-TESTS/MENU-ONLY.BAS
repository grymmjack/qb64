'$DYNAMIC

'SETUP SCREEN
_FULLSCREEN _SQUAREPIXELS 'Optional: Comment out for window mode
SCREEN _NEWIMAGE(_DESKTOPWIDTH, _DESKTOPHEIGHT, 256) ' Optional: SCREEN 13

CONST G_MENU_PADDING = 2

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
