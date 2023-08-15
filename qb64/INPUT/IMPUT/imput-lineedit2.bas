'$DYNAMIC
DIM CANVAS AS LONG
CANVAS& = _NEWIMAGE(800, 600, 32)
SCREEN CANVAS&
DIM bytes(0) AS _BYTE
DIM dest_bytes(1) AS _BYTE
DIM AS _BYTE b1, b2
                   bytes(0) = 1  '0
CALL ARR_BYTE.push(bytes%%(), 2) '1
CALL ARR_BYTE.push(bytes%%(), 3) '2
CALL ARR_BYTE.push(bytes%%(), 4) '3
CALL ARR_BYTE.push(bytes%%(), 5) '4
CALL ARR_BYTE.push(bytes%%(), 6) '5
PRINT bytes%%(0), bytes%%(1), bytes%%(2), bytes%%(3), bytes%%(4)', bytes%%(5)
PRINT UBOUND(bytes%%)
b1%% = ARR_BYTE.shift(bytes%%())
PRINT bytes%%(0), bytes%%(1), bytes%%(2), bytes%%(3), bytes%%(4)', bytes%%(5)
PRINT UBOUND(bytes%%)
' b1%% = ARR_BYTE.pop(bytes%%())
' b2%% = ARR_BYTE.pop(bytes%%())
PRINT b1%%', b2%%
CALL ARR_BYTE.slice(bytes%%(), dest_bytes%%(), 1, 2)
PRINT dest_bytes%%(0), dest_bytes%%(1)', dest_bytes%%(2)', dest_bytes%%(3)  
PRINT UBOUND(dest_bytes%%)
''
' Slice an array from source to destination starting at index and count slices
' @param BYTE() source_arr%% to slice from
' @param BYTE() dest_arr%% to put slices into
' @param INTEGER start_idx% starting index to use as slice range
' @param INTEGER count% number of slices - if negative, backwards from index
'
SUB ARR_BYTE.slice(source_arr%%(), dest_arr%%(), start_idx%, count%)
    DIM AS INTEGER ub, lb, i, n
    lb% = LBOUND(source_arr%%) : ub% = UBOUND(source_arr%%)
    IF start_idx% < lb% OR start_idx% + count% > ub% THEN EXIT SUB ' out of range
    IF ub% - lb% < count% THEN EXIT SUB ' too many and not enough
    REDIM dest_arr(0 TO ABS(count%)) AS _BYTE
    IF SGN(count%) = -1 THEN
        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
        n% = 0
        FOR i% = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
            dest_arr%%(n%) = source_arr%%(i%)
            n% = n% + 1
        NEXT i%
    ELSE
        IF ((start_idx% + 1) + ABS(count%)) > (ub% - lb%) THEN EXIT SUB ' out of range
        n% = 0
        FOR i% = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
            dest_arr%%(n%) = source_arr%%(i%)
            n% = n% + 1
        NEXT i%
    END IF
END SUB

SUB ARR_BYTE.push(arr%%(), value%%)
    DIM AS INTEGER ub, lb
    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%)
    REDIM _PRESERVE arr(lb% TO (ub% + 1)) AS _BYTE
    arr%%(ub% + 1) = value%%
END SUB

FUNCTION ARR_BYTE.pop%%(arr%%())
    DIM AS INTEGER ub, lb
    DIM AS _BYTE res
    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%)
    res%% = arr%%(ub%)
    REDIM _PRESERVE arr(lb% TO (ub% - 1)) AS _BYTE
    ARRAY_BYTE.pop%% = res%%
END FUNCTION

FUNCTION ARR_BYTE.shift%%(arr%%())
    DIM AS INTEGER ub, lb, i
    DIM AS _BYTE res
    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%)
    res%% = arr%%(lb%)
    FOR i% = lb% TO ub% - 1
        arr%%(i%) = arr%%(i% + 1) 
    NEXT i%
    REDIM _PRESERVE arr(lb% TO ub% - 1) AS _BYTE
    ARRAY_BYTE.shift%% = res%%
END FUNCTION