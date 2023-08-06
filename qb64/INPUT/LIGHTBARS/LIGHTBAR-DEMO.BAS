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
_TITLE "LIGHTBAR Menu Routine DEMO"

SCREEN 0        ' This uses SCREEN 0 (text mode)
_BLINK OFF      ' Allow high intensity background colors > 7
_CONTROLCHR OFF ' Allow printing of any characters including control chars

' LIGHTBAR configuration UDT
TYPE LIGHTBAR
    opt_bg_color AS INTEGER ' Unselected background color
    opt_fg_color AS INTEGER ' Unselected foreground color
    bar_bg_color AS INTEGER ' Selected background color
    bar_fg_color AS INTEGER ' Selected foreground color
    bar_kf_color AS INTEGER ' Selected hot key foreground color
    bar_kb_color AS INTEGER ' Selected hot key background color
    key_bg_color AS INTEGER ' Unselected hot key background color
    key_fg_color AS INTEGER ' Unselected hot key foreground color
    opt_selected AS INTEGER ' Selected option index
    opt_vertical AS INTEGER ' 1 = true (then vertical) 0 = false (then horiz)
    max_width    AS INTEGER ' Maximum width for horizontal options
    delimeter    AS STRING  ' Single character used to surround hot key
END TYPE

DIM menu AS LIGHTBAR    ' Create a LIGHTBAR menu
DIM opts(13) AS STRING  ' Our menu will contain 6 options (0 indexed array)

' choice variable will contain the choice the user made using either the 
' hot key directly, or by using the home, end, or arrow keys to select 
' and confirm with ENTER. This var  will be -1 if the user hit ESC to abort.
DIM choice AS INTEGER   

' Configure the LIGHTBAR menu
menu.opt_bg_color% = 0  : menu.opt_fg_color% = 12 ' Unselected option colors
menu.bar_bg_color% = 3  : menu.bar_fg_color% = 11 ' Selected option colors
menu.bar_kf_color% = 14 : menu.bar_kb_color% = 11 ' Selected hot key colors
menu.key_bg_color% = 0  : menu.key_fg_color% = 14 ' Unselected hot key colors
' Select the first option by default
menu.opt_selected% = 0
' Use vertical orientation (new lines after each option)
menu.opt_vertical% = 1
' Delimiter can be any single char but must be same char on both sides of key
' OK: "|F|oo", Not OK: "[F]oo"
menu.delimeter$ = "|" 
' Set max width to screen width
menu.max_width% = _WIDTH(0)

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

' Draw some basic goofy screen under which we will have a LIGHTBAR menu
COLOR 12, 0: PRINT "----------------------------------------"
COLOR 7, 0 : PRINT " Welcome to"; 
COLOR 12, 0: PRINT " ANTONIOS"; : COLOR 10, 0: PRINT " PIZZERIA!"
COLOR 7, 0 : PRINT " Pick your favorite food from our menu!"
COLOR 14, 0: PRINT "----------------------------------------"
COLOR 2, 0 : PRINT " ..if you're not hungry press ESCAPE.. "
COLOR 12, 0: PRINT "----------------------------------------"
COLOR 9, 0 : PRINT " PRESS ARROWS & HOME/END to choose..."
COLOR 9, 0 : PRINT " PRESS ENTER or HOT KEY to PICK..."
COLOR 9, 0 : PRINT " PRESS ESC to abort!"
PRINT

' Draw the LIGHTBAR menu, and store the result chosen in choice%
choice% = LIGHTBAR%(menu, opts$())

' If user did not press ESC to abort show which option they chose.
IF choice% <> -1 THEN
    PRINT
    COLOR 11, 0 : PRINT "You chose option ";
    COLOR 14, 0 : PRINT UCASE$(_TRIM$(STR$(choice%)));
    COLOR 11, 0 : PRINT ": ";
    COLOR 12, 0 : PRINT _TRIM$(opts$(choice%))
    IF choice% = 0 THEN
        COLOR 10, 0 : PRINT "An excellent choice! It is also my favorite!"
    END IF
' User pressed ESC to abort, so show something else
ELSE
    PRINT
    COLOR 3, 0 : PRINT "Not hungry eh? OK you come back later!"
END IF
PRINT
COLOR 12, 0 : PRINT "Thank you! Come again!"



''
' Render a LIGHTBAR menu using options$
' @param LIGHTBAR menu UDT
' @param string array of menu options
' @return integer choice made (-1 if abort with ESC)
'
FUNCTION LIGHTBAR%(menu AS LIGHTBAR, options$())
    DIM AS STRING k
    DIM AS INTEGER key_pos_s, key_pos_e, key_code
    DIM AS INTEGER orig_bg, orig_fg, fg, bg, kf, kb
    DIM AS INTEGER row, col, cur_row, cur_col, lb, ub, sel, chose, w, i

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

    ' Define key constants
    CONST KEY_ESC   = 27
    CONST KEY_HOME  = 71 : CONST KEY_END   = 79
    CONST KEY_LEFT  = 75 : CONST KEY_RIGHT = 77
    CONST KEY_UP    = 72 : CONST KEY_DOWN  = 80
    CONST KEY_ENTER = 13

    ' Get lower and upper bounds of options array
    lb% = LBOUND(options$) : ub% = UBOUND(options$)

    ' Capture initial state for cursor and colors
    row%     = CSRLIN : col% = POS(0)       ' Store initial cursor position
    orig_fg% = SCREEN(row%, col%, 1) AND 15 ' Store initial foreground color
    orig_bg% = SCREEN(row%, col%, 1) \ 16   ' Store initial background color
    cur_row% = row% : cur_col% = col%       ' Init current row and current col
    w%       = menu.max_width%              ' Get the max width for horiz menu
    DIM o(lb% TO ub%) AS LIGHTBAR_OPTION

    LIGHTBAR_get_options:
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
                IF cur_col% + o(i%).len% >= w% THEN ' Option WILL wrap
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
            LOCATE cur_row%, cur_col%
        NEXT i%

    LIGHTBAR_draw:
        FOR i% = lb% TO ub% ' Walk the array of menu options
            LOCATE o(i%).row%, o(i%).col% ' Position the option
            IF i% = sel% THEN ' Selected colors
                fg% = menu.bar_fg_color% : bg% = menu.bar_bg_color%
                kf% = menu.bar_kf_color% : kb% = menu.bar_kb_color%
            ELSE ' Unselected colors
                fg% = menu.opt_fg_color% : bg% = menu.opt_bg_color%
                kf% = menu.key_fg_color% : kb% = menu.key_bg_color%
            END IF
            ' Draw the option
            COLOR fg%, bg% : PRINT o(i%).lft$; ' Draw opt left
            COLOR kf%, kb% : PRINT o(i%).key$; ' Draw opt hot key
            COLOR fg%, bg% : PRINT o(i%).rgt$; ' Draw opt right
        NEXT i%

    ' Wait for the user to choose an option
    LIGHTBAR_get_choice:
        DO:
            _LIMIT 30
            k$ = INKEY$
            IF k$ <> "" THEN
                IF LEFT$(k$, 1) = CHR$(0) THEN ' Handle SPECIAL keys
                    key_code% = ASC(RIGHT$(k$, 1)) ' Get char code sans CHR$(0)
                    SELECT CASE key_code%
                        CASE KEY_HOME:
                            sel% = lb%
                            GOTO LIGHTBAR_draw
                        CASE KEY_END:
                            sel% = ub%
                            GOTO LIGHTBAR_draw
                        CASE KEY_DOWN, KEY_RIGHT:
                            sel% = sel% + 1
                            IF sel% > ub% THEN sel% = lb%
                            GOTO LIGHTBAR_draw
                        CASE KEY_UP, KEY_LEFT:
                            sel% = sel% - 1
                            IF sel% < lb% THEN sel% = ub%
                            GOTO LIGHTBAR_draw
                    END SELECT
                END IF

                FOR i% = lb% TO ub% ' Handle option hot keys
                    IF LCASE$(k$) = LCASE$(o(i%).key$) THEN
                        sel% = i%
                        chose% = 1
                        GOTO LIGHTBAR_draw
                    END IF
                NEXT i%

                IF k$ = CHR$(KEY_ESC) THEN ' ESCAPE to abort
                    sel% = -1
                END IF

            END IF
        LOOP UNTIL k$ = CHR$(KEY_ENTER) OR k$ = CHR$(KEY_ESC) OR chose% = 1

    ' Restore original colors
    COLOR orig_fg%, orig_bg% 

    ' Position cursor under menu
    IF menu.opt_vertical = 1 THEN
        LOCATE row% + (ub% - lb%) + 1, col% ' Vertical
    ELSE
        LOCATE o(ub%).row% + 1, col% ' Horizontal
    END IF

    LIGHTBAR% = sel%
END FUNCTION
