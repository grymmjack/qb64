SCREEN 12

cellSize = 1 ' Set the desired size of each grid cell (including gridlines)

DO:
    k$ = INKEY$
    IF k$ = "+" THEN cellSize = cellSize + 1
    IF k$ = "-" THEN cellSize = cellSize - 1
    IF cellSize < 1 THEN cellSize = 1
    IF cellSize > 50 THEN cellSize = 50
    IF k$ <> "" THEN
        CLS
        DRAW_GRID cellSize
        LOCATE 1, 1: PRINT "Press '+' to increase cell size, '-' to decrease cell size, or ESC to quit."
        LOCATE 2, 1: PRINT "Current cell size: "; cellSize
    END IF
    _LIMIT 30
LOOP UNTIL k$ = CHR$(27)

SUB DRAW_GRID(cellSize)
    ' Calculate the maximum number of complete cells that can fit horizontally
    maxCells = INT(80 / cellSize)

    ' Calculate the maximum number of columns based on the number of cells and cell size
    maxCols = maxCells * cellSize

    FOR row = 1 TO 25
        FOR col = 1 TO maxCols
            ' Check if we're on a gridline
            IF (row - 1) MOD cellSize = 0 OR (col - 1) MOD cellSize = 0 THEN
                ' Determine which line character to use
                IF (row - 1) MOD cellSize = 0 AND (col - 1) MOD cellSize = 0 THEN
                    ' Intersection point
                    IF row = 1 THEN
                        ' Top row
                        IF col = 1 THEN
                            LOCATE row, col: PRINT CHR$(218) ' Top-left corner
                        ELSEIF col = maxCols THEN
                            LOCATE row, col: PRINT CHR$(191) ' Top-right corner
                        ELSE
                            LOCATE row, col: PRINT CHR$(194) ' Downward T
                        END IF
                    ELSEIF row = 25 THEN
                        ' Bottom row
                        IF col = 1 THEN
                            LOCATE row, col: PRINT CHR$(192) ' Bottom-left corner
                        ELSEIF col = maxCols THEN
                            LOCATE row, col: PRINT CHR$(217) ' Bottom-right corner
                        ELSE
                            LOCATE row, col: PRINT CHR$(193) ' Upward T
                        END IF
                    ELSEIF col = 1 THEN
                        ' Leftmost column
                        LOCATE row, col: PRINT CHR$(195) ' Rotated |-
                    ELSEIF col = maxCols THEN
                        ' Rightmost column
                        LOCATE row, col: PRINT CHR$(180) ' Rotated -|
                    ELSE
                        ' Middle rows and columns
                        LOCATE row, col: PRINT CHR$(197) ' Cross
                    END IF
                ELSEIF (row - 1) MOD cellSize = 0 THEN
                    ' Horizontal line
                    LOCATE row, col: PRINT CHR$(196) ' Horizontal line
                ELSE
                    ' Vertical line
                    LOCATE row, col: PRINT CHR$(179) ' Vertical line
                END IF
            ELSE
                ' Print a space for empty cells
                LOCATE row, col: PRINT " "
            END IF
        NEXT col
    NEXT row
END SUB