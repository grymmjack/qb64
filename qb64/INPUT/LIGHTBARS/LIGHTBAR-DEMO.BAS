$Debug
''
' LIGHTBAR Menu
'
' Creating lightbar driven menus using arrow keys to choose, enter to select, and
' making it reusable and modular.
'
' Code is a bit long, I'm sure someone can do this better! Regardless, this will end
' up in my QB64_GJ_LIB library soon.
' 
' @author Rick Christy <grymmjack@gmail.com>
'
OPTION _EXPLICIT
_TITLE "LIGHTBAR Menu Routine DEMO"

SCREEN 0        ' this uses SCREEN 0 (text mode)
_BLINK OFF      ' allow high intensity background colors > 7
_CONTROLCHR OFF ' allow printing of any characters including control chars

' LIGHTBAR configuration UDT
TYPE LIGHTBAR ' bg|b = background, fg|f = foreground, k = key
    opt_bg_color AS INTEGER ' unselected background color
    opt_fg_color AS INTEGER ' unselected foreground color
    bar_bg_color AS INTEGER ' selected background color
    bar_fg_color AS INTEGER ' selected foreground color
    bar_kf_color AS INTEGER ' selected hot key foreground color
    bar_kb_color AS INTEGER ' selected hot key background color
    key_bg_color AS INTEGER ' unselected hot key background color
    key_fg_color AS INTEGER ' unselected hot key foreground color
    opt_selected AS INTEGER ' selected option index
    opt_vertical AS INTEGER ' 1 = true (then vertical) 0 = false (then horizontal)
    delimeter    AS STRING  ' Single character used to surround hot key
END TYPE

DIM menu AS LIGHTBAR    ' Create a LIGHTBAR menu
DIM opts(13) AS STRING  ' Our menu will contain 6 options (0 indexed array)

DIM choice AS INTEGER   ' This variable will contain the choice the user made
' using either the hot key directly, or by using the
' home, end, or arrow keys to select with ENTER.
' This variable will be -1 if the user hit ESC to abort.

' Configure the LIGHTBAR menu
menu.opt_bg_color% = 0  : menu.opt_fg_color% = 12 ' Unselected option colors
menu.bar_bg_color% = 3  : menu.bar_fg_color% = 11 ' Selected option colors
menu.bar_kf_color% = 14 : menu.bar_kb_color% = 11 ' Selected hot key colors
menu.key_bg_color% = 0  : menu.key_fg_color% = 14 ' Unselected hot key colors
' Select the first option by default
menu.opt_selected% = 0
' Use vertical orientation (new lines after each option)
menu.opt_vertical% = 1
' Use vertical orientation (new lines after each option)
' menu.opt_vertical = 0
' Delimiter can be any single character but must be same char on both sides
' OK: "|F|oo", Not OK: "[F]oo"
menu.delimeter$ = "|" 

' Populate the LIGHTBAR options - NOTE: spaces and formatting are kept intact
' If you want longer bars, add more spaces or whatever characters that bar is made of.
IF menu.opt_vertical% = 1 THEN ' vertical LIGHTBAR menu
    opts$(0)  = " |P|izza                   " ' | = delimeter, so |P| for Pizza
    opts$(1)  = " |R|ibs                    " ' Notice that Ribs, ...
    opts$(2)  = " |W|ings                   " ' Wings, ...
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
    opts$(13) = " |Q|uit " ' However, each option can have a different bar length like this.
END IF

' Populate the LIGHTBAR options - NOTE: spaces and formatting are kept intact
IF menu.opt_vertical% = 0 THEN ' horizontal LIGHTBAR menu
    opts$(0)  = " |P|izza "
    opts$(1)  = " |R|ibs "
    opts$(2)  = " |W|ings "
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
    DIM AS STRING k, o
    DIM AS INTEGER key_pos_s, key_pos_e, ks, fg, bg, kf, kb
    DIM AS INTEGER row, col, orig_bg, orig_fg, lb, ub, sel, choice_made
    DIM AS INTEGER rows_drawn, cols_drawn, i, j
    lb% = LBOUND(options$) : ub% = UBOUND(options$)

    ' UDT for option data
    TYPE LIGHTBAR_OPTION
        row         AS INTEGER  ' Option row
        col         AS INTEGER  ' Option column
        opt_left    AS STRING   ' Option left side text
        opt_key     AS STRING   ' Option hot key
        opt_right   AS STRING   ' Option right side text
        opt_len     AS INTEGER  ' Option length (left + key + right)
        is_selected AS INTEGER  ' Is this option selected? 0 = no, 1 = yes
    END TYPE

    ' Define key constants
    CONST KEY_ESC   = 27
    CONST KEY_HOME  = 71 : CONST KEY_END   = 79
    CONST KEY_LEFT  = 75 : CONST KEY_RIGHT = 77
    CONST KEY_UP    = 72 : CONST KEY_DOWN  = 80
    CONST KEY_ENTER = 13

    DIM keys(lb% TO ub%) AS STRING ' holds hot keys (chars in delimeters)
    row%         = CSRLIN : col% = POS(0)       ' store initial cursor position
    orig_fg%     = SCREEN(row%, col%, 1) AND 15 ' store initial foreground color
    orig_bg%     = SCREEN(row%, col%, 1) \ 16   ' store initial background color
    cols_drawn%  = 0                            ' init columns drawn

    LIGHTBAR_get_options:
        DIM opt(lb% TO ub%) AS LIGHTBAR_OPTION
        FOR i% = lb% to ub%
            ' Extract hot key start and end positions
            key_pos_s% = INSTR(0, options$(i%), menu.delimeter$)
            key_pos_e% = INSTR(key_pos_s%, options$(i%), menu.delimeter$)

            ' Extract left and right part of option without hotkey or delimeter
            opt(i%).opt_left$  = MID$(options$(i%), 0, key_pos_s%)
            opt(i%).opt_right$ = MID$(options$(i%), key_pos_s% + 3)

            ' Capture hot key into arrays
            opt(i%).opt_key$ = MID$(options$(i%), key_pos_s% + 1, 1)


            ' Capture visible option length
            o$ = opt(i%).opt_left$ + opt(i%).opt_key$ + opt(i%).opt_right$

            opt(i%).opt_len% = LEN(o$)

            ' Check if option is selected
            opt(i%).is_selected% = 0
            IF i% = menu.opt_selected% THEN
                sel% = i%
                opt(i%).is_selected% = 1
            END IF

            ' Calculate row and col positions for option
            IF menu.opt_vertical% = 1 THEN
                opt(i%).row% = row% + i%
                opt(i%).col% = col%
            ELSE
                opt(i%).row% = row%
                cols_drawn%  = cols_drawn% + opt(i%).opt_len%
                opt(i%).col% = cols_drawn% - opt(i%).opt_len%
            END IF
        NEXT i%

    LIGHTBAR_draw:
        FOR j% = lb% TO ub% ' Walk the array of menu options
            safe_locate opt(j%).row%, opt(j%).col%
            IF j% = sel% THEN ' selected colors
                fg% = menu.bar_fg_color% : bg% = menu.bar_bg_color%
                kf% = menu.bar_kf_color% : kb% = menu.bar_kb_color%
            ELSE ' unselected colors
                fg% = menu.opt_fg_color% : bg% = menu.opt_bg_color%
                kf% = menu.key_fg_color% : kb% = menu.key_bg_color%
            END IF
            COLOR fg%, bg% : PRINT opt(j%).opt_left$; ' draw opt left
            COLOR kf%, kb% : PRINT opt(j%).opt_key$;  ' draw opt hot key
            COLOR fg%, bg% : PRINT opt(j%).opt_right$ ' draw opt right
        NEXT j%

    ' Wait for the user to choose an option
    LIGHTBAR_get_choice:
        DO:
            _LIMIT 30
            k$ = INKEY$
            IF k$ <> "" THEN
                IF LEFT$(k$, 1) = CHR$(0) THEN ' handle SPECIAL keys
                    ks% = ASC(RIGHT$(k$, 1)) ' get the char code minus the CHR$(0)
                    SELECT CASE ks%
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

                FOR i% = lb% TO ub% ' handle option hot keys
                    IF LCASE$(k$) = LCASE$(opt(i%).opt_key$) THEN
                        sel% = i%
                        choice_made% = 1
                        GOTO LIGHTBAR_draw
                    END IF
                NEXT i%

                IF k$ = CHR$(KEY_ESC) THEN ' ESCAPE to abort
                    sel% = -1
                END IF

            END IF
        LOOP UNTIL k$ = CHR$(KEY_ENTER) OR k$ = CHR$(KEY_ESC) OR choice_made% = 1

    ' User chose option or aborted with ESC
    COLOR orig_fg%, orig_bg% ' restore original colors

     ' position cursor under menu
    IF menu.opt_vertical = 1 THEN
        LOCATE row% + (ub% - lb%) + 1, col% ' if vertical
    ELSE
        LOCATE opt(ub%).row% + 1, col% ' if not vertical
    END IF

    LIGHTBAR% = sel%
END FUNCTION


''
' Safely locates within boundaries
' @param INTEGER row%
' @param INTEGER col%
' 
SUB safe_locate(row%, col%)
    IF col% > _WIDTH(0) THEN
        row% = row% + (col% \ _WIDTH(0))
        col% = col% MOD _WIDTH(0)
    END IF
    LOCATE clamp_int(row%, 1, _HEIGHT(0)), clamp_int(col%, 1, _WIDTH(0))
END SUB


''
' Clamps a value between a minimum and a maximum
' Clamp = do not be less than min, or more than max.
' @param INTEGER var% to clamp
' @param INTEGER min% minimum value allowed
' @param INTEGER max% maximum value allowed
' @return INTEGER clamped value between min and max range
'
FUNCTION clamp_int%(var%, min%, max%)
    DIM r AS INTEGER
    IF (var%) < min% THEN 
        r% = min%
    ELSEIF (var%) > max% THEN 
        r% = max%
    ELSE
        r% = var%
    END IF
    clamp_int = r%
END FUNCTION
