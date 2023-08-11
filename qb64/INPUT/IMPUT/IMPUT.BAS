$Debug
_CONTROLCHR OFF
SCREEN 0
DIM answer AS STRING
DIM char_stats(4) AS INTEGER
PRINT "Choose a password 3-8 characters in length."
PRINT ": ";
answer$ = imput$(3, 8, "*", ".", "ENTER PASSWORD")
get_char_stats answer$, char_stats%()
PRINT
PRINT "User entered: "; answer$
PRINT "--- Statistics ---"
PRINT
PRINT "Length: "; _TRIM$(STR$(LEN(answer$)))
PRINT "Number of vowels: "; _TRIM$(STR$(char_stats%(0)))
PRINT "Number of consonants: "; _TRIM$(STR$(char_stats%(1)))
PRINT "Number of digits: "; _TRIM$(STR$(char_stats%(2)))
PRINT "Number of symbols: "; _TRIM$(STR$(char_stats%(3)))
PRINT "Number of spaces: "; _TRIM$(STR$(char_stats%(4)))
PRINT


''
' (imp)roved input
' - Accepts any visible characters (ASC(32)+)
' - Can backspace, when backspace replaces with blank or empty_char$
' - Abort with ESC (optional)
' - Clear with CTRL-X, CTRL-Y
' @param INTEGER min% minimum length of input required
' @param INTEGER max% maximum length of input allowed
' @param STRING echo_char$ instead of showing keys as typed use char$
' @param STRING empty_char$ to use instead of space
' @param STRING placeholder$ display string and as soon as key typed, clear it
' @return STRING of characters typed
FUNCTION imput$(min%, max%, echo_char$, empty_char$, placeholder$)
    DIM AS STRING k, ret
    DIM AS INTEGER orig_row, orig_col, cx, cy, done
    orig_row% = CSRLIN : orig_col% = POS(0)
    IF empty_char$ = "" THEN empty_char$ = " "

    IF placeholder$ <> "" THEN ' print placeholder
        LOCATE orig_row%, orig_col%
        PRINT placeholder$;
        LOCATE orig_row%, orig_col%
    ELSEIF max% > 0 THEN ' print max empty_char if placeholder blank
        LOCATE orig_row%, orig_col%
        PRINT STRING$(max%, empty_char$);
        LOCATE orig_row%, orig_col%
    END IF

    done% = 0
    DO:
        _LIMIT 30
        k$ = INKEY$
        IF k$ <> "" THEN ' valid keypress
            IF k$ = CHR$(27) THEN ' abort with ESCAPE
                imput$ = ""
                EXIT FUNCTION
            END IF
            IF k$ = CHR$(13) THEN ' finish with enter...
                IF LEN(ret$) >= min% AND LEN(ret$) <= max% THEN ' and legal...
                    done% = 1
                ELSE ' not legal because not long enough
                    BEEP
                END IF
            END IF
            IF k$ = CHR$(24) OR k$ = CHR$(25) THEN ' CTRL-X or CTRL-Y = clear
                IF LEN(ret$) > 0 THEN
                    IF max% > 0 THEN ' if max print empty_char$ * max
                        IF placeholder$ <> "" THEN
                            LOCATE orig_row%, orig_col%
                            PRINT STRING$(LEN(placeholder$), " ");
                            LOCATE orig_row%, orig_col%
                        END IF
                        LOCATE orig_row%, orig_col%
                        PRINT STRING$(max%, empty_char$);
                        LOCATE orig_row%, orig_col%
                    END IF
                    IF placeholder$ <> "" THEN
                        LOCATE orig_row%, orig_col%
                        PRINT STRING$(LEN(placeholder$), empty_char$);
                        LOCATE orig_row%, orig_col%
                        PRINT placeholder$;
                        LOCATE orig_row%, orig_col%
                    END IF
                    ret$ = ""
                END IF
            END IF
            IF k$ = CHR$(8) THEN ' backspace
                IF LEN(ret$) > 0 THEN 'something to erase exists
                    cur_row% = CSRLIN
                    cur_col% = POS(0)
                    LOCATE cur_row%, cur_col% - 1
                    PRINT empty_char$;
                    LOCATE cur_row%, cur_col% - 1
                    ret$ = MID$(ret$, 1, LEN(ret$)-1)
                END IF
                IF LEN(ret$) = 0 THEN ' nothing to erase - print placeholder
                    IF max% > 0 THEN ' if max print empty_char$ * max
                        IF placeholder$ <> "" THEN
                            LOCATE orig_row%, orig_col%
                            PRINT STRING$(LEN(placeholder$), " ");
                            LOCATE orig_row%, orig_col%
                        END IF
                        LOCATE orig_row%, orig_col%
                        PRINT STRING$(max%, empty_char$);
                        LOCATE orig_row%, orig_col%
                    END IF
                    IF placeholder$ <> "" THEN
                        LOCATE orig_row%, orig_col%
                        PRINT STRING$(LEN(placeholder$), empty_char$);
                        LOCATE orig_row%, orig_col%
                        PRINT placeholder$;
                        LOCATE orig_row%, orig_col%
                    END IF
                END IF
            END IF
            IF ASC(k$) >= 32 THEN ' valid printable character
                IF LEN(ret$) + 1 <= max% THEN ' less than or equal to max
                    IF LEN(ret$) = 0 THEN ' clear placeholder on first key
                        IF placeholder$ <> "" THEN
                            LOCATE orig_row%, orig_col%
                            PRINT STRING$(LEN(placeholder$), empty_char$);
                            LOCATE orig_row%, orig_col%
                        END IF
                        IF max% > 0 THEN ' if max print empty_char$ * max
                            IF placeholder$ <> "" THEN
                                LOCATE orig_row%, orig_col%
                                PRINT STRING$(LEN(placeholder$), " ");
                                LOCATE orig_row%, orig_col%
                            END IF
                            LOCATE orig_row%, orig_col%
                            PRINT STRING$(max%, empty_char$);
                            LOCATE orig_row%, orig_col%
                        END IF
                    END IF
                    ret$ = ret$ + k$ ' append
                    IF echo_char$ = "" THEN ' print echo_char or key itself
                        PRINT k$;
                    ELSE
                        PRINT echo_char$;
                    ENDIF
                ELSE ' another char would exceed max
                    BEEP
                END IF
            END IF
        END IF
    LOOP UNTIL done% = 1
    imput$ = ret$
END FUNCTION

SUB get_char_stats (st$, char_stats%())
    DIM AS INTEGER i, vowels, consonants, digits, symbols, spaces
    DIM ch AS STRING
    s$ = UCASE$(st$)
    FOR i% = 1 TO LEN(st$)
        ch$ = MID$(s$, i%, 1)
        SELECT EVERYCASE ch$
            CASE "A", "E", "I", "O", "U":
                vowels% = vowels% + 1
            CASE "B" TO "D", _
                 "F" TO "H", _
                 "J" TO "N", _
                 "P" TO "T", _
                 "V" TO "Z":
                consonants% = consonants% + 1
            CASE "0" TO "9":
                digits% = digits% + 1
            CASE CHR$(32), CHR$(13), CHR$(9):
                spaces% = spaces% + 1
            CASE ELSE:
                  symbols% = symbols% + 1
        END SELECT
    NEXT i%
    char_stats%(0) = vowels%
    char_stats%(1) = consonants%
    char_stats%(2) = digits%
    char_stats%(3) = symbols%
    char_stats%(4) = spaces%
END SUB

FUNCTION validpat$(st$, pattern$)
END FUNCTION

