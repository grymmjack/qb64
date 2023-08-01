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
SCREEN 0 : _BLINK OFF : _CONTROLCHR OFF
_TITLE "LIGHTBAR Menu Routine DEMO"

TYPE LIGHTBAR ' bg|b = background, fg|f = foreground, k = key
    opt_bg_color AS INTEGER
    opt_fg_color AS INTEGER
    bar_bg_color AS INTEGER
    bar_fg_color AS INTEGER
    bar_kf_color AS INTEGER
    bar_kb_color AS INTEGER
    key_bg_color AS INTEGER
    key_fg_color AS INTEGER
    opt_selected AS INTEGER
    delimeter    AS STRING
END TYPE

DIM menu AS LIGHTBAR : DIM opts(5) AS STRING : DIM choice AS INTEGER
menu.opt_bg_color  = 0
menu.opt_fg_color  = 12
menu.bar_bg_color  = 3
menu.bar_fg_color  = 11
menu.bar_kf_color  = 14
menu.bar_kb_color  = 11
menu.key_bg_color  = 3
menu.key_fg_color  = 14
menu.opt_selected  = 0
menu.delimeter     = "|"
opts$(0)           = " |P|izza                                  "
opts$(1)           = " |R|ibs                                   "
opts$(2)           = " |W|ings                                  "
opts$(3)           = " |S|alad                                  "
opts$(4)           = " |B|readsticks                            "
opts$(5)           = " |Q|uit                                   "

COLOR 12, 0: PRINT "----------------------------------------"
COLOR 7, 0 : PRINT " Welcome to"; 
COLOR 12, 0: PRINT " ANTONIOS"; : COLOR 10, 0: PRINT " PIZZERIA!"
COLOR 7, 0 : PRINT " Pick your favorite food from our menu!"
COLOR 14, 0: PRINT "----------------------------------------"
COLOR 2, 0 : PRINT " ..if you're not hungry press ESCAPE.. "
COLOR 12, 0: PRINT "----------------------------------------"
PRINT
COLOR 9, 0 : PRINT " UP and DOWN choose and ENTER picks!"
PRINT

choice% = LIGHTBAR%(menu, opts$())
IF choice% <> -1 THEN
    PRINT
    COLOR 11, 0 : PRINT "You chose option ";
    COLOR 14, 0 : PRINT UCASE$(_TRIM$(STR$(choice%)));
    COLOR 11, 0 : PRINT ": ";
    COLOR 12, 0 : PRINT _TRIM$(opts$(choice%))
    IF choice% = 0 THEN
        COLOR 10, 0 : PRINT "An excellent choice! It is also my favorite!"
    END IF
ELSE
    PRINT
    COLOR 3, 0 : PRINT "Not hungry eh? OK you come back later!"
END IF
PRINT
COLOR 12, 0 : PRINT "Thank you! Come again!"



FUNCTION LIGHTBAR%(menu AS LIGHTBAR, options$())
    DIM AS STRING opt_l, opt_r, k, opt_sel_l, opt_sel_r, opt_sel_k
    DIM AS INTEGER obg, ofg, bbg, bfg, bkf, bkb, kbg, kfg, key_pos_s, key_pos_e
    DIM AS INTEGER row, col, orig_bg, orig_fg, lb, ub, i, selected, choice_made
    lb% = LBOUND(options$) : ub% = UBOUND(options$)

    ' fetch convenience colors
    obg% = menu.opt_bg_color : ofg% = menu.opt_fg_color
    bbg% = menu.bar_bg_color : bfg% = menu.bar_fg_color
    bkf% = menu.bar_kf_color : bkb% = menu.bar_kb_color
    kbg% = menu.key_bg_color : kfg% = menu.key_fg_color  

    DIM keys(lb% TO ub%) AS STRING          ' holds hot keys (chars in delimeters)
    row% = CSRLIN : col% = POS(0)           ' store initial cursor position
    orig_fg% = SCREEN(row%, col%, 1) AND 15 ' store initial foreground color
    orig_bg% = SCREEN(row%, col%, 1) \ 16   ' store initial background color
    selected% = menu.opt_selected           ' get selected option

    LIGHTBAR_draw:
        LOCATE row%, col%
        FOR i% = lb% TO ub%
            key_pos_s% = INSTR(0, options$(i%), menu.delimeter)
            key_pos_e% = INSTR(key_pos_s%, options$(i%), menu.delimeter)
            keys$(i%) = MID$(options$(i%), key_pos_s% + 1, 1)
            opt_l$ = MID$(options$(i%), 0, key_pos_s%)
            opt_r$ = MID$(options$(i%), key_pos_s% + 3)
            COLOR ofg%, obg% : PRINT opt_l$;
            COLOR kfg%, kbg% : PRINT keys$(i%);
            COLOR ofg%, obg% : PRINT opt_r$
            IF i% = selected% THEN
                opt_sel_l$ = opt_l$ : opt_sel_r$ = opt_r$ : opt_sel_k$ = keys$(i%)
            END IF
        NEXT i%

        ' draw selected option
        LOCATE row% + selected%, col%
        COLOR bfg%, bbg% : PRINT opt_sel_l$;
        COLOR bkf%, bkb% : PRINT opt_sel_k$;
        COLOR bfg%, bbg% : PRINT opt_sel_r$

    LIGHTBAR_get_choice:
        DO:
            ' handle arrow keys
            k$ = INKEY$
            SELECT CASE k$
                CASE CHR$(27): ' escape to abort
                    selected% = -1
                CASE CHR$(0) + CHR$(71): ' home to jump to first option
                    selected% = lb%
                    GOTO LIGHTBAR_draw
                CASE CHR$(0) + CHR$(79): ' end to jump to last option
                    selected% = ub%
                    GOTO LIGHTBAR_draw
                CASE CHR$(0) + CHR$(80): ' down arrow to go down an option
                    selected% = selected% + 1
                    IF selected% > ub% THEN selected% = lb%
                    GOTO LIGHTBAR_draw
                CASE CHR$(0) + CHR$(72): ' up arrow to go up an option
                    selected% = selected% - 1
                    IF selected% < lb% THEN selected% = ub%
                    GOTO LIGHTBAR_draw
            END SELECT
            ' handle hot keys
            FOR i% = lb% TO ub%
                IF LCASE$(k$) = LCASE$(keys$(i%)) THEN 
                    selected% = i%
                    choice_made% = 1
                    GOTO LIGHTBAR_draw
                END IF
            NEXT i%
        LOOP UNTIL k$ = CHR$(13) OR k$ = CHR$(27) OR choice_made% = 1

    COLOR orig_fg%, orig_bg% ' restore original colors
    LOCATE row% + (ub% - lb%) + 1, col% ' position cursor under menu
    LIGHTBAR% = selected%
END FUNCTION