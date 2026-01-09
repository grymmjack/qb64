CONST EMPTY = " "
DIM SHARED board(1 TO 3, 1 TO 3) AS STRING

CALL ResetBoard
CALL PlayGame

SUB ResetBoard
    FOR row = 1 TO 3
        FOR col = 1 TO 3
            board(row, col) = EMPTY
        NEXT col
    NEXT row
END SUB

SUB DisplayBoard
    CLS
    PRINT "TIC-TAC-TOE"
    PRINT
    FOR row = 1 TO 3
        FOR col = 1 TO 3
            IF col > 1 THEN PRINT " | ";
            PRINT board(row, col);
        NEXT col
        PRINT
        IF row < 3 THEN PRINT "--+---+--"
    NEXT row
    PRINT
END SUB

FUNCTION CheckWin$ ()
    DIM i AS INTEGER

    ' Check rows and columns
    FOR i = 1 TO 3
        IF board(i, 1) = board(i, 2) AND board(i, 2) = board(i, 3) AND board(i, 1) <> EMPTY THEN
            CheckWin$ = board(i, 1)
            EXIT FUNCTION
        END IF
        IF board(1, i) = board(2, i) AND board(2, i) = board(3, i) AND board(1, i) <> EMPTY THEN
            CheckWin$ = board(1, i)
            EXIT FUNCTION
        END IF
    NEXT i

    ' Check diagonals
    IF board(1, 1) = board(2, 2) AND board(2, 2) = board(3, 3) AND board(1, 1) <> EMPTY THEN
        CheckWin$ = board(1, 1)
        EXIT FUNCTION
    END IF
    IF board(1, 3) = board(2, 2) AND board(2, 2) = board(3, 1) AND board(1, 3) <> EMPTY THEN
        CheckWin$ = board(1, 3)
        EXIT FUNCTION
    END IF

    CheckWin$ = ""
END FUNCTION

FUNCTION IsBoardFull
    FOR row = 1 TO 3
        FOR col = 1 TO 3
            IF board(row, col) = EMPTY THEN
                IsBoardFull = 0
                EXIT FUNCTION
            END IF
        NEXT col
    NEXT row
    IsBoardFull = -1
END FUNCTION

SUB PlayGame
    DIM currentPlayer AS STRING
    DIM row AS INTEGER, col AS INTEGER
    currentPlayer = "X"

    DO
        CALL DisplayBoard
        PRINT "Player "; currentPlayer; "'s turn"

        DO
            PRINT "Enter row (1-3): ";
            INPUT row
            PRINT "Enter column (1-3): ";
            INPUT col

            IF row >= 1 AND row <= 3 AND col >= 1 AND col <= 3 THEN
                IF board(row, col) = EMPTY THEN
                    board(row, col) = currentPlayer
                    EXIT DO
                ELSE
                    PRINT "Cell already taken. Try again."
                END IF
            ELSE
                PRINT "Invalid input. Try again."
            END IF
        LOOP

        winner$ = CheckWin$
        IF winner$ <> "" THEN
            CALL DisplayBoard
            PRINT "Player "; winner$; " wins!"
            EXIT DO
        END IF

        IF IsBoardFull THEN
            CALL DisplayBoard
            PRINT "It's a draw!"
            EXIT DO
        END IF

        IF currentPlayer = "X" THEN
            currentPlayer = "O"
        ELSE
            currentPlayer = "X"
        END IF
    LOOP
END SUB
