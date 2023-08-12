OPTION _EXPLICIT
$Debug
_CONTROLCHR OFF
SCREEN 0
DIM AS STRING answer1, answer2, word1, word2, word3, words
DIM AS INTEGER row, col
DIM char_stats(4) AS INTEGER
PRINT "Choose a password 3-8 characters in length."
PRINT ": ";
answer1$ = imput$(3, 8, 0, "*", "_", "ENTER PASSWORD")
get_char_stats answer1$, char_stats%()
print_char_stats answer1$, char_stats%()

PRINT : PRINT "Enter a random thought..."
PRINT ": ";
answer2$ = imput$(0, 77, 1, "", ".", "it can literrally be anything...")
get_char_stats answer2$, char_stats%()
print_char_stats answer2$, char_stats%()

PRINT : PRINT "Now enter 3 different short words"
PRINT ": ";
row% = CSRLIN : col% = POS(0)
PRINT "____________________ ____________________ ____________________";
LOCATE row%, col%
word1$ = imput$(0, 20, 1, "", "_", "WORD 1")
LOCATE row%, col% + 21
word2$ = imput$(0, 20, 1, "", "_", "WORD 2")
LOCATE row%, col% + 42
word3$ = imput$(0, 20, 1, "", "_", "WORD 3")
words$ = word1$ + " " + word2$ + " " + word3$
get_char_stats words$, char_stats%()
print_char_stats words$, char_stats%()



''
' (imp)roved input draw string routine
' Draws from a position, then returns to that same position
' @param INTEGER row% row to draw on
' @param INTEGER col% col to start on
' @param STRING s$ string to draw
'
SUB imput_draw(row%, col%, s$)
    LOCATE row%, col%, 1 : PRINT s$; : LOCATE row%, col%, 1
END SUB


''
' (imp)roved input
'
' - Accepts any visible characters (ASC(32)+)
' - Use ENTER to complete input
' - Can backspace, when backspace replaces with blank or empty_char$
' - +Can use delete, when pressing delete, removes from the right side
' - +Can use insert or overwrite mode
' - +Can use CTRL-LEFT and CTRL-RIGHT to move between words
' - +Can use HOME and END to go to home or end
' - +Can use TAB to insert spaces
' - +Configure to use sound or not (new param)
' - +Configure to use cursor or not (new param)
' - Abort with ESC (optional)
' - Clear with CTRL-K, CTRL-X, CTRL-Y
'
' @param INTEGER min% minimum length of input required
' @param INTEGER max% maximum length of input allowed
' @param INTEGER use_default% use placeholder as default value
' @param STRING echo_char$ instead of showing keys as typed use char$
' @param STRING empty_char$ to use instead of space
' @param STRING placeholder$ display string and as soon as key typed, clear it
' @return STRING of characters typed
'
FUNCTION imput$(min%, max%, use_default%, echo_char$, empty_char$, placeholder$)
    DIM AS STRING k, ret
    DIM AS INTEGER orig_row, orig_col, cur_row, cur_col, done
    orig_row% = CSRLIN : orig_col% = POS(0)
    cur_row% = orig_row% : cur_col% = orig_col%
    IF empty_char$ = "" THEN empty_char$ = " "

    IF max% > 0 THEN ' print max empty_char if placeholder blank
        imput_draw orig_row%, orig_col%, STRING$(max%, empty_char$)
    END IF
    IF placeholder$ <> "" THEN ' print placeholder
        imput_draw orig_row%, orig_col%, placeholder$
    END IF

    done% = 0
    IF use_default% = 1 THEN 
        ret$ = placeholder$
        LOCATE orig_row%, orig_col% + LEN(placeholder$), 1
    END IF
    DO:
        _LIMIT 30
        k$ = INKEY$
        IF k$ <> "" THEN ' valid keypress
            IF k$ = CHR$(27) THEN ' abort with ESCAPE
                imput$ = "" : EXIT FUNCTION
            END IF
            IF k$ = CHR$(13) THEN ' finish with enter...
                IF use_default% = 1 OR _
                LEN(ret$) >= min% AND LEN(ret$) <= max% THEN ' and legal...
                    done% = 1
                ELSE ' not legal because not long enough
                    BEEP
                END IF
            END IF
            IF k$ = CHR$(24) _
            OR k$ = CHR$(25) _
            OR k$ = CHR$(11) THEN ' CTRL-(K,X,Y) = clear
                IF LEN(ret$) > 0 THEN
                    ret$ = "" ' empty the contents of the user input
                    IF max% > 0 THEN ' if max, print empty_char$ * max
                        IF placeholder$ <> "" THEN
                            imput_draw orig_row%, orig_col%, STRING$(LEN(placeholder$), " ")
                        END IF
                        imput_draw orig_row%, orig_col%, STRING$(max%, empty_char$)
                    END IF
                END IF
            END IF
            IF k$ = CHR$(8) THEN ' backspace
                IF LEN(ret$) > 0 THEN 'something to erase exists
                    cur_row% = CSRLIN : cur_col% = POS(0)
                    imput_draw cur_row%, cur_col% - 1, empty_char$
                    ret$ = MID$(ret$, 1, LEN(ret$)-1)
                END IF
                IF LEN(ret$) = 0 THEN ' nothing to erase - print placeholder
                    IF max% > 0 THEN ' if max print empty_char$ * max
                        IF placeholder$ <> "" THEN
                            imput_draw orig_row%, orig_col%, STRING$(LEN(placeholder$), " ")
                        END IF
                        imput_draw orig_row%, orig_col%, STRING$(max%, empty_char$)
                    END IF
                END IF
            END IF
            IF ASC(k$) >= 32 THEN ' valid printable character
                IF LEN(ret$) + 1 <= max% THEN ' less than or equal to max
                    IF LEN(ret$) = 0 THEN ' clear placeholder on first key
                        IF placeholder$ <> "" THEN
                            imput_draw orig_row%, orig_col%, STRING$(LEN(placeholder$), empty_char$)
                        END IF
                        IF max% > 0 THEN ' if max print empty_char$ * max
                            IF placeholder$ <> "" THEN ' clear any placeholder
                                imput_draw orig_row%, orig_col%, STRING$(LEN(placeholder$), " ")
                            END IF
                            ' draw empty chars length of max
                            imput_draw orig_row%, orig_col%, STRING$(max%, empty_char$)
                        END IF
                    END IF
                    ret$ = ret$ + k$ ' append user input
                    IF echo_char$ = "" THEN ' print echo_char or key itself
                        PRINT k$;
                    ELSE
                        PRINT echo_char$;
                    ENDIF
                ELSE ' another char would exceed max so disallow
                    BEEP
                END IF
            END IF
        END IF
    LOOP UNTIL done% = 1
    imput$ = ret$
END FUNCTION


''
' Returns statistics about a string
'
' @param STRING st$ string to get stats for
' @param INTEGER char_stats%() array to store stats in
'
SUB get_char_stats (st$, char_stats%())
    IF st$ = "" THEN EXIT SUB
    DIM AS INTEGER i, vowels, consonants, digits, symbols, spaces
    DIM AS STRING ch, s
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


''
' Print character stats for a string
' @param STRING st$ string to print stats for
' @param INTEGER char_stats%() array stats are in
'
SUB print_char_stats(st$, char_stats%())
    IF st$ = "" THEN EXIT SUB
    PRINT : PRINT
    PRINT "String: "; st$
    PRINT
    PRINT "--- Statistics ---"
    PRINT
    PRINT "Length: "; _TRIM$(STR$(LEN(st$)))
    PRINT
    PRINT "Number of vowels:     "; _TRIM$(STR$(char_stats%(0)))
    PRINT "Number of consonants: "; _TRIM$(STR$(char_stats%(1)))
    PRINT "Number of digits:     "; _TRIM$(STR$(char_stats%(2)))
    PRINT "Number of symbols:    "; _TRIM$(STR$(char_stats%(3)))
    PRINT "Number of spaces:     "; _TRIM$(STR$(char_stats%(4)))
    PRINT
END SUB
