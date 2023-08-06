''
' LIGHTBAR Menu
'
' Creating lightbar driven menus using arrow keys to choose, enter to select, 
' and making it reusable and modular.
'
' Code is a bit long, I'm sure someone can do this better! Regardless, this 
' will end up in my QB64_GJ_LIB library soon.
' 
' @author Rick Christy <grymmjack@gmail.com>
'
OPTION _EXPLICIT
_TITLE "LIGHTBAR32 Menu Routine DEMO"

'SCREEN 0       ' This uses SCREEN 0 (text mode)
DIM CANVAS AS LONG
CANVAS& = _NEWIMAGE(132 * 8, 50*16, 32)
SCREEN CANVAS&

DIM SHARED EGA(0 TO 15) AS _UNSIGNED LONG
EGA(0)  = _RGB32(&H00, &H00, &H00)
EGA(1)  = _RGB32(&H00, &H00, &HAA)
EGA(2)  = _RGB32(&H00, &HAA, &H00)
EGA(3)  = _RGB32(&H00, &HAA, &HAA)
EGA(4)  = _RGB32(&HAA, &H00, &H00)
EGA(5)  = _RGB32(&HAA, &H00, &HAA)
EGA(6)  = _RGB32(&HAA, &H55, &H00)
EGA(7)  = _RGB32(&HAA, &HAA, &HAA)
EGA(8)  = _RGB32(&H55, &H55, &H55)
EGA(9)  = _RGB32(&H55, &H55, &HFF)
EGA(10) = _RGB32(&H55, &HFF, &H55)
EGA(11) = _RGB32(&H55, &HFF, &HFF)
EGA(12) = _RGB32(&HFF, &H55, &H55)
EGA(13) = _RGB32(&HFF, &H55, &HFF)
EGA(14) = _RGB32(&HFF, &HFF, &H55)
EGA(15) = _RGB32(&HFF, &HFF, &HFF)

_BLINK OFF      ' Allow high intensity background colors > 7
_CONTROLCHR OFF ' Allow printing of any characters including control chars

' LIGHTBAR configuration UDT
TYPE LIGHTBAR32
    opt_bg_color AS _UNSIGNED LONG ' Unselected background color
    opt_fg_color AS _UNSIGNED LONG ' Unselected foreground color
    bar_bg_color AS _UNSIGNED LONG ' Selected background color
    bar_fg_color AS _UNSIGNED LONG ' Selected foreground color
    bar_kf_color AS _UNSIGNED LONG ' Selected hot key foreground color
    bar_kb_color AS _UNSIGNED LONG ' Selected hot key background color
    key_bg_color AS _UNSIGNED LONG ' Unselected hot key background color
    key_fg_color AS _UNSIGNED LONG ' Unselected hot key foreground color
    opt_selected AS INTEGER        ' Selected option index
    opt_vertical AS INTEGER        ' 1 = true (then vertical) 0 = false (then horiz)
    max_width    AS INTEGER        ' Maximum width for horizontal options
    delimeter    AS STRING         ' Single character used to surround hot key
    use_sounds   AS INTEGER        ' 1 = true (use sounds) 0 = false (no sounds)
    snd_move_frq AS SINGLE         ' Frequency for SOUND movement
    snd_move_dur AS SINGLE         ' Duration for SOUND movement
    snd_move_vol AS SINGLE         ' Volume for SOUND movement
    snd_pick_frq AS SINGLE         ' Frequency for SOUND pick
    snd_pick_dur AS SINGLE         ' Duration for SOUND pick
    snd_pick_vol AS SINGLE         ' Volume for SOUND pick
    snd_abrt_frq AS SINGLE         ' Frequency for SOUND pick
    snd_abrt_dur AS SINGLE         ' Duration for SOUND pick
    snd_abrt_vol AS SINGLE         ' Volume for SOUND pick
END TYPE

' UDT for option data
TYPE LIGHTBAR_OPTION
    row AS INTEGER ' Option row
    col AS INTEGER ' Option column
    lft AS STRING  ' Option left side text
    key AS STRING  ' Option hot key
    rgt AS STRING  ' Option right side text
    len AS INTEGER ' Option length (left + key + right)
    sel AS INTEGER ' Is this option selected? 0 = no, 1 = yes
END TYPE

DIM menu AS LIGHTBAR32              ' Create a LIGHTBAR menu
DIM opts(13) AS STRING              ' Menu contains 13 options (0 indexed array)
DIM options(13) AS LIGHTBAR_OPTION  ' Menu options storage

' choice variable will contain the choice the user made using either the 
' hot key directly, or by using the home, end, or arrow keys to select 
' and confirm with ENTER. This var  will be -1 if the user hit ESC to abort.
DIM choice AS INTEGER   

' Configure the LIGHTBAR32 menu
menu.opt_bg_color~& = EGA(0)  : menu.opt_fg_color~& = EGA(12) ' Unselected option colors
menu.bar_bg_color~& = EGA(3)  : menu.bar_fg_color~& = EGA(11) ' Selected option colors
menu.bar_kf_color~& = EGA(14) : menu.bar_kb_color~& = EGA(3)  ' Selected hot key colors
menu.key_bg_color~& = EGA(0)  : menu.key_fg_color~& = EGA(14) ' Unselected hot key colors
' Select the first option by default
menu.opt_selected% = 0
' Use vertical orientation (new lines after each option)
menu.opt_vertical% = 1
' Delimiter can be any single char but must be same char on both sides of key
' OK: "|F|oo", Not OK: "[F]oo"
menu.delimeter$ = "|" 
' Set max width to screen width
menu.max_width% = _WIDTH(0)
' Setup sounds
menu.use_sounds% = 1
menu.snd_move_frq! = 150
menu.snd_move_dur! = 1
menu.snd_move_vol! = 0.5
menu.snd_pick_frq! = 400
menu.snd_pick_dur! = 2
menu.snd_pick_vol! = 0.75
menu.snd_abrt_frq! = 75
menu.snd_abrt_dur! = 3
menu.snd_abrt_vol! = 0.5

' Populate the LIGHTBAR options - NOTE: Vertical options are padded with spaces
' If you want longer bars, add more spaces or characters that bar is made of
IF menu.opt_vertical% = 1 THEN ' Vertical LIGHTBAR menu
    opts$(0)  = " |P|izza                   " ' | = delimeter, so |P| for Pizza
    opts$(1)  = " |R|ibs                    " ' Notice that Ribs, ...
    opts$(2)  = " |H|ot Wings               " ' Hot Wings, ...
    opts$(3)  = " |S|alad                   " ' Salad, ...
    opts$(4)  = " |B|readsticks             " ' ...
    opts$(5)  = " |A|pple Pie               " ' ...
    opts$(6)  = " |C|innamon Sticks         " ' ...
    opts$(7)  = " |K|rispy Kreme Donuts     " ' ...
    opts$(8)  = " |D|eluxe Pepperoni Bread  " ' ...
    opts$(9)  = " |E|ggplant Parmesan       " ' ...
    opts$(10) = " |F|ettucinni Alfredo Bowl " ' ...
    opts$(11) = " |J|uice for the Bambinos  " ' ...
    opts$(12) = " |W|ine for Padre + Madre  " ' All of the same length
    opts$(13) = " |Q|uit " ' However, each can have diff bar length like this.
END IF

' Populate the LIGHTBAR options - NOTE: Horizontal options aren't padded.
IF menu.opt_vertical% = 0 THEN ' Horizontal LIGHTBAR menu
    opts$(0)  = " |P|izza "
    opts$(1)  = " |R|ibs "
    opts$(2)  = " |H|ot Wings "
    opts$(3)  = " |S|alad "
    opts$(4)  = " |B|readsticks "
    opts$(5)  = " |A|pple Pie "
    opts$(6)  = " |C|innamon Sticks "
    opts$(7)  = " |K|rispy Kreme Donut "
    opts$(8)  = " |D|eluxe Pepperoni Bread "
    opts$(9)  = " |E|ggplant Parmesan "
    opts$(10) = " |F|ettucinni Alfredo Bowl "
    opts$(11) = " |J|uice for the Bambinos "
    opts$(12) = " |W|ine for Padre + Madre "
    opts$(13) = " |Q|uit "
END IF

' Draw some basic goofy screen under which we will have a LIGHTBAR32 menu
COLOR EGA(12), EGA(0) : PRINT "----------------------------------------"
COLOR EGA(7),  EGA(0) : PRINT " Welcome to"; 
COLOR EGA(12), EGA(0) : PRINT " ANTONIOS"; : COLOR EGA(10), EGA(0): PRINT " PIZZERIA!"
COLOR EGA(7),  EGA(0) : PRINT " Pick your favorite food from our menu!"
COLOR EGA(14), EGA(0) : PRINT "----------------------------------------"
COLOR EGA(2),  EGA(0) : PRINT " ..if you're not hungry press ESCAPE.. "
COLOR EGA(12), EGA(0) : PRINT "----------------------------------------"
COLOR EGA(9),  EGA(0) : PRINT " PRESS ARROWS & HOME/END to choose..."
COLOR EGA(9),  EGA(0) : PRINT " PRESS ENTER or HOT KEY to PICK..."
COLOR EGA(9),  EGA(0) : PRINT " PRESS ESC to abort!"
PRINT

' Draw the LIGHTBAR32 menu, and store the result chosen in choice%
choice% = LIGHTBAR32%(menu, opts$(), options())

' If user did not press ESC to abort show which option they chose.
IF choice% <> -1 THEN
    PRINT
    COLOR EGA(11), EGA(0) : PRINT "You chose option ";
    COLOR EGA(14), EGA(0) : PRINT UCASE$(_TRIM$(STR$(choice%)));
    COLOR EGA(11), EGA(0) : PRINT ": ";
    COLOR EGA(12), EGA(0) : PRINT _TRIM$(opts$(choice%))
    IF choice% = 0 THEN
        COLOR EGA(10), EGA(0) : PRINT "An excellent choice! It is also my favorite!"
    END IF
' User pressed ESC to abort, so show something else
ELSE
    PRINT
    COLOR EGA(3), EGA(0) : PRINT "Not hungry eh? OK you come back later!"
END IF
PRINT
COLOR EGA(12), EGA(0) : PRINT "Thank you! Come again!"



''
' Render a LIGHTBA32R menu using options$
' @param LIGHTBAR32 menu UDT
' @param STRING opts$ array of menu options
' @param LIGHTBAR_OPTIONS o array to hold LIGHTBAR_OPTIONS
' @return integer choice made (-1 if abort with ESC)
'
FUNCTION LIGHTBAR32%(menu AS LIGHTBAR32, opt$(), o() AS LIGHTBAR_OPTION)
    DIM AS INTEGER row, col, sel, lb, ub
    DIM AS _UNSIGNED LONG  orig_fg, orig_bg

    ' Get lower and upper bounds of options array
    lb% = LBOUND(opt$) : ub% = UBOUND(opt$)

    ' Capture initial state for cursor and colors
    row%     = CSRLIN : col% = POS(0)       ' Store initial cursor position
    orig_fg~& = EGA(7) ' Store initial foreground color
    orig_bg~& = EGA(0) ' Store initial background color

    LIGHTBAR32.get_options menu, opt$(), o(), row%, col%, menu.opt_selected%
    LIGHTBAR32.draw menu, opt$(), o(), menu.opt_selected%
    sel% = LIGHTBAR32.get_choice%(menu, opt$(), o())

    ' Restore original colors
    COLOR orig_fg~&, orig_bg~& 

    ' Position cursor under menu
    IF menu.opt_vertical = 1 THEN
        LOCATE row% + (ub% - lb%) + 1, col% ' Vertical
    ELSE
        LOCATE o(ub%).row% + 1, col% ' Horizontal
    END IF

    LIGHTBAR32% = sel%
END FUNCTION

''
' Get LIGHTBAR32 options as an array
' @param LIGHTBAR32 menu
' @param STRING options$ array of string options
' @param LIGHTBAR_OPTIONS array of LIGHTBAR_OPTIONS
' @param INTEGER row% the original row cursor was on
' @param INTEGER col% the original column cursor was on
' @param INTEGER sel% the selected menu item
'
SUB LIGHTBAR32.get_options(menu AS LIGHTBAR32, options$(), o() AS LIGHTBAR_OPTION, row%, col%, sel%)
    DIM AS INTEGER i, lb, ub, key_pos_s, key_pos_e, key_code
    DIM AS INTEGER cur_row, cur_col, w
    
    ' Get lower and upper bounds of options array
    lb% = LBOUND(options$) : ub% = UBOUND(options$)

    w% = menu.max_width% ' Get the max width for horiz menu
    cur_row% = row% : cur_col% = col% ' Init current row and current col

    FOR i% = lb% to ub%
        ' Extract hot key start and end positions
        key_pos_s% = INSTR(0, options$(i%), menu.delimeter$)
        key_pos_e% = INSTR(key_pos_s%, options$(i%), menu.delimeter$)

        ' Extract left and right part of option without key or delimeter
        o(i%).lft$ = MID$(options$(i%), 0, key_pos_s%)
        o(i%).rgt$ = MID$(options$(i%), key_pos_s% + 3)

        ' Capture hot key into arrays
        o(i%).key$ = MID$(options$(i%), key_pos_s% + 1, 1)

        ' Capture visible option length
        o(i%).len% = LEN(o(i%).lft$ + o(i%).key$ + o(i%).rgt$)

        ' Check if option is selected
        o(i%).sel% = 0
        IF i% = menu.opt_selected% THEN sel% = i% : o(i%).sel% = 1

        ' Calculate row and col positions for option
        IF menu.opt_vertical% = 1 THEN ' Vertical
            o(i%).row% = row% + i% ' In vert LIGHTBAR menu, 1 opt per row
            o(i%).col% = col%      ' In vert LIGHTBAR menu, column is same
        ELSE ' Horizontal
            IF ((cur_col% + o(i%).len%) * _FONTWIDTH) >= w% THEN ' Will wrap
                o(i%).col%   = col%              ' Reset col to init col
                cur_col% = col% + o(i%).len%     ' Reset cur_col counter
                cur_row% = cur_row% + 1          ' Increment cur_row
                o(i%).row%   = cur_row%          ' Set row to cur_row
            ELSE ' Option will NOT wrap
                o(i%).col%   = cur_col%          ' Set col to current col
                o(i%).row%   = cur_row%          ' Set row to current row
                cur_col% = cur_col% + o(i%).len% ' Increment current col
            END IF
        END IF
    NEXT i%
END SUB


''
' Draws LIGHTBAR32 menu
' @param LIGHTBAR32 menu
' @param STRING options$ array of string options
' @param LIGHTBAR_OPTIONS array of LIGHTBAR_OPTIONS
' @param INTEGER sel% which option is selected
'
SUB LIGHTBAR32.draw(menu AS LIGHTBAR32, options$(), o() AS LIGHTBAR_OPTION, sel%)
    DIM AS INTEGER i, lb, ub
    DIM AS _UNSIGNED LONG fg, bg, kf, kb

    ' Get lower and upper bounds of options array
    lb% = LBOUND(options$) : ub% = UBOUND(options$)

    FOR i% = lb% TO ub% ' Walk the array of menu options
        LOCATE o(i%).row%, o(i%).col% ' Position the option
        IF i% = sel% THEN ' Selected colors
            fg~& = menu.bar_fg_color~& : bg~& = menu.bar_bg_color~&
            kf~& = menu.bar_kf_color~& : kb~& = menu.bar_kb_color~&
        ELSE ' Unselected colors
            fg~& = menu.opt_fg_color~& : bg~& = menu.opt_bg_color~&
            kf~& = menu.key_fg_color~& : kb~& = menu.key_bg_color~&
        END IF
        ' Draw the option
        COLOR fg~&, bg~& : PRINT o(i%).lft$; ' Draw opt left
        COLOR kf~&, kb~& : PRINT o(i%).key$; ' Draw opt hot key
        COLOR fg~&, bg~& : PRINT o(i%).rgt$; ' Draw opt right
    NEXT i%
END SUB


''
' Get choice from user in LIGHTBAR menu
' @param LIGHTBAR32 menu
' @param STRING options$ array of string options
' @param LIGHTBAR_OPTIONS array of LIGHTBAR_OPTIONS
' @return INTEGER choice user made (-1 = aborted)
'
FUNCTION LIGHTBAR32.get_choice%(menu AS LIGHTBAR32, options$(), o() AS LIGHTBAR_OPTION)
    DIM k AS STRING
    DIM AS INTEGER i, key_code, do_move, lb, ub, sel

    ' Get lower and upper bounds of options array
    lb% = LBOUND(options$) : ub% = UBOUND(options$)

    ' Define key constants
    CONST KEY_ESC   = 27
    CONST KEY_HOME  = 71 : CONST KEY_END   = 79
    CONST KEY_LEFT  = 75 : CONST KEY_RIGHT = 77
    CONST KEY_UP    = 72 : CONST KEY_DOWN  = 80
    CONST KEY_ENTER = 13

    DO:
        ' Init do_move which determines if we moved after all the SELECTs
        do_move% = 0 ' 1 = move, 2 = pick, 3 = abort
        _LIMIT 30
        k$ = INKEY$
        IF k$ <> "" THEN
            IF LEFT$(k$, 1) = CHR$(0) THEN ' Handle SPECIAL keys
                key_code% = ASC(RIGHT$(k$, 1)) ' Get char code sans CHR$(0)
                SELECT CASE key_code%
                    CASE KEY_HOME:
                        do_move% = 1
                        sel% = lb% 
                    CASE KEY_END:
                        do_move% = 1
                        sel% = ub%
                    CASE KEY_DOWN, KEY_RIGHT:
                        do_move% = 1
                        sel% = sel% + 1
                        IF sel% > ub% THEN sel% = lb%
                    CASE KEY_UP, KEY_LEFT:
                        do_move% = 1
                        sel% = sel% - 1
                        IF sel% < lb% THEN sel% = ub%
                END SELECT
            END IF

            FOR i% = lb% TO ub% ' Handle option hot keys
                IF LCASE$(k$) = LCASE$(o(i%).key$) THEN
                    do_move% = 2
                    sel% = i%
                END IF
            NEXT i%

            IF k$ = CHR$(KEY_ESC) THEN ' ESCAPE to abort
                do_move% = 3
            END IF
        END IF
        IF do_move% > 0 THEN
            ' Handle moves
            SELECT CASE do_move%
                CASE 1: ' move
                    LIGHTBAR32.sound menu.use_sounds%, menu.snd_move_frq!, menu.snd_move_dur!, menu.snd_move_vol!
                    LIGHTBAR32.draw menu, options$(), o(), sel%
                CASE 2: ' pick
                    LIGHTBAR32.draw menu, options$(), o(), sel%
                CASE 3: ' abort
                    LIGHTBAR32.sound menu.use_sounds%, menu.snd_abrt_frq!, menu.snd_abrt_dur!, menu.snd_abrt_vol!
                    LIGHTBAR32.get_choice% = -1
                    EXIT FUNCTION
            END SELECT
        END IF
    LOOP UNTIL k$ = CHR$(KEY_ENTER) OR k$ = CHR$(KEY_ESC) OR do_move% = 2
    LIGHTBAR32.sound menu.use_sounds%, menu.snd_pick_frq!, menu.snd_pick_dur!, menu.snd_pick_vol!
    LIGHTBAR32.get_choice% = sel%
END FUNCTION


''
' Handles LIGHTBAR sounds
' @param INTEGER use_sounds% 0 = no, 1 = yes
' @param SINGLE frq frequency for sound
' @param SINGLE dur duration of sound
' @param SINGLE vol volume of sound
'
SUB LIGHTBAR32.sound(use_sounds%, frq!, dur!, vol!)
    IF use_sounds% = 1 THEN
        SOUND frq!, dur!, vol!
    END IF
END SUB