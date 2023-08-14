$Debug
SCREEN 0
_SCREENMOVE 960, 540
CLS , 1

COLOR 14, 1

CONST IMP_OVERWRITING = -1
CONST IMP_INSERTING   = 0
CONST IMP_POS_START   = 0
CONST IMP_POS_BETWEEN = 1
CONST IMP_POS_END     = 2
CONST IMP_KEY_LEFT    = 75
CONST IMP_KEY_RIGHT   = 77
CONST IMP_KEY_CR      = 13
CONST IMP_KEY_BS      = 8
CONST IMP_KEY_DEL     = 83
CONST IMP_KEY_INS     = 82
CONST IMP_KEY_TAB     = 9
CONST IMP_KEY_HOME    = 71
CONST IMP_KEY_END     = 79
CONST IMP_KEY_CTRL_K  = 11
CONST IMP_KEY_CTRL_X  = 24
CONST IMP_KEY_CTRL_Y  = 25

DIM AS INTEGER orig_row, orig_col, done, ins_ovr, cy, cx
' default to overwrite mode
ins_ovr% = IMP_INSERTING

v$ = "A line of input"
PRINT "> ";
orig_row% = CSRLIN : orig_col% = POS(0)
done% = 0

PRINT v$;

LOCATE orig_row%, orig_col% + LEN(v$), 1 : draw_cursor(ins_ovr%)
cy% = CSRLIN : cx% = POS(0)
r$ = v$
DO:
    _LIMIT 30
    k$ = INKEY$

    IF k$ <> "" THEN
        cy% = CSRLIN : cx% = POS(0)
        ' get insert position
        IF cx% = orig_col% THEN
            ins_pos% = IMP_POS_START
        ELSEIF cx% = orig_col% + LEN(v$) THEN
            ins_pos% = IMP_POS_END
        ELSE
            ins_pos% = IMP_POS_BETWEEN
        END IF

        SELECT CASE ASC(RIGHT$(k$, 1))
            CASE IMP_KEY_LEFT:
                IF ins_pos% > IMP_POS_START THEN
                    LOCATE cy%, cx% - 1, 1 : draw_cursor(ins_ovr%)
                END IF
            CASE IMP_KEY_RIGHT:
                IF ins_pos% < IMP_POS_END THEN
                    LOCATE cy%, cx% + 1, 1 : draw_cursor(ins_ovr%)
                END IF
            CASE IMP_KEY_CR:
                done% = 1
            CASE IMP_KEY_BS:
                IF ins_pos% > IMP_POS_START THEN
                    IF ins_pos% = IMP_POS_END THEN
                        LOCATE cy%, cx% - 1, 1 : draw_cursor(ins_ovr%)
                        PRINT " ";
                        r$ = MID$(v$, 1, LEN(v$) - 1)
                        cx% = cx% - 1
                    ELSEIF ins_pos% = IMP_POS_BETWEEN THEN
                        IF ins_ovr% = IMP_INSERTING THEN
                            LOCATE cy%, cx% + 1, 1 : draw_cursor(ins_ovr%)
                            PRINT SPACE$(LEN(MID$(v$, cx% + 1)));
                            r$ = MID$(v$, 1, cx%) + k$ + MID$(v$, cx% + 1)
                        ELSE
                            LOCATE cy%, cx% - 1, 1 : draw_cursor(ins_ovr%)
                            PRINT " ";
                            r$ = MID$(v$, 1, cx%) + k$ + MID$(v$, cx% + 1)
                            cx% = cx% - 1
                        END IF
                    END IF
                END IF
            CASE IMP_KEY_DEL:
                IF ins_pos% < IMP_POS_END THEN
                    LOCATE cy%, cx% + 1, 1 : draw_cursor(ins_ovr%)
                    PRINT SPACE$(LEN(v$) - 1);
                    PRINT MID$(v$, cx% + 1);
                    r$ = MID$(v$, 1, cx%) + MID$(v$, cx% + 1)
                END IF
            CASE IMP_KEY_INS:
                ins_ovr% = NOT ins_ovr%
                draw_cursor(ins_ovr%)
            CASE IMP_KEY_TAB:
                r$ = v$ + SPACE$(8)
            CASE IMP_KEY_HOME:
                LOCATE orig_row%, orig_col%, 1 : draw_cursor(ins_ovr%)
            CASE IMP_KEY_END:
                LOCATE orig_row%, orig_col% + LEN(v$), 1 : draw_cursor(ins_ovr%)
            CASE IMP_KEY_CTRL_K, IMP_KEY_CTRL_X, IMP_KEY_CTRL_Y:
                LOCATE orig_row%, orig_col%, 1 : draw_cursor(ins_ovr%)
                PRINT SPACE$(LEN(v$));
        END SELECT
        IF ASC(k$) > = 32 THEN
            IF ins_pos% = IMP_POS_START THEN ' cursor at start
                IF ins_ovr% = IMP_INSERTING THEN
                    r$ = k$ + v$
                ELSE
                    r$ = k$ + MID$(v$, 1)
                END IF
            END IF
            IF ins_pos% = IMP_POS_END THEN ' cursor at end
                r$ = v$ + k$
            ELSE ' cursor in between start and end of input
                IF ins_ovr% = IMP_INSERTING THEN
                    r$ = MID$(v$, 1, POS(0) - 1) + k$ + MID$(v$, POS(0) + 1)
                ELSE
                    r$ = MID$(v$, 1, POS(0) - 1) + k$ + MID$(v$, POS(0))
                END IF
            END IF
        END IF
    END IF
    ' update string
    IF r$ <> v$ THEN
        LOCATE orig_row%, orig_col%, 1 : draw_cursor(ins_ovr%)
        PRINT SPACE$(LEN(r$));
        LOCATE orig_row%, orig_col%, 1 : draw_cursor(ins_ovr%)
        PRINT r$;
        LOCATE cy%, cx%, 1 : draw_cursor(ins_ovr%)
        v$ = r$
    END IF
LOOP UNTIL done% = 1 OR k$ = CHR$(13) OR k$ = CHR$(27)

PRINT
PRINT v$

SUB draw_cursor(ins_ovr%)
    IF ins_ovr% = IMP_INSERTING THEN
        LOCATE ,,1,30,31
    ELSE
        LOCATE ,,1,0,31
    END IF
END SUB