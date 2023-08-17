'$DYNAMIC

'//TODO: all: .unique
'//TODO: all: .find
'//TODO: all: .in
'//TODO: all: .not_in
'//TODO: numbers: .sum
'//TODO: numbers: .avg
'//TODO: numbers: .product
'//TODO: numbers: .gt
'//TODO: numbers: .lt
'//TODO: numbers: .gte
'//TODO: numbers: .lte
'//TODO: numbers: .between
'//TODO: numbers: .odd
'//TODO: numbers: .even
'//TODO: strings: .starts_with
'//TODO: strings: .contains
'//TODO: strings: .ends_with
'//TODO: strings: .len_gt
'//TODO: strings: .len_lt

DIM CANVAS AS LONG
DIM temp_str AS STRING
CANVAS& = _NEWIMAGE(800, 600, 32)
SCREEN CANVAS&
DIM bytes(0) AS _BYTE
DIM dest_bytes(1) AS _BYTE
DIM AS _BYTE b1, b2
                '    bytes(0) = 1  '0
' CALL ARR_BYTE.push(bytes%%(), 2) '1
' CALL ARR_BYTE.push(bytes%%(), 3) '2
' CALL ARR_BYTE.push(bytes%%(), 4) '3
' CALL ARR_BYTE.push(bytes%%(), 5) '4
' CALL ARR_BYTE.push(bytes%%(), 6) '5
CALL ARR_BYTE.new(bytes%%(), "1,2,3,4,5,6,7,8,9,10,11,12")
CALL ARR_BYTE.shuffle(bytes%%(), dest_bytes%%())
CALL ARR_BYTE.join(bytes%%(), temp_str$)
PRINT temp_str$
' PRINT(_TRIM$(STR$(ARR_BYTE.count(bytes%%()))))
CALL ARR_BYTE.join(dest_bytes%%(), temp_str$)
PRINT temp_str$
CALL ARR_BYTE.sort(dest_bytes%%(), bytes%%())
CALL ARR_BYTE.join(bytes%%(), temp_str$)
PRINT temp_str$
CALL ARR_BYTE.rsort(dest_bytes%%(), bytes%%())
CALL ARR_BYTE.join(bytes%%(), temp_str$)
PRINT temp_str$
' PRINT(_TRIM$(STR$(ARR_BYTE.random%%(bytes%%()))))

' CALL ARR_BYTE.join(dest_bytes%%(), temp_str$)
' PRINT temp_str$
SLEEP
SYSTEM
' PRINT bytes%%(0), bytes%%(1), bytes%%(2), bytes%%(3), bytes%%(4), bytes%%(5)
' PRINT UBOUND(bytes%%)
' CALL ARR_BYTE.shift(bytes%%(), b2%%)
' CALL ARR_BYTE.unshift(bytes%%(), 99)
' CALL ARR_BYTE.unshift(bytes%%(), 100)
' PRINT bytes%%(0), bytes%%(1), bytes%%(2), bytes%%(3), bytes%%(4), bytes%%(5)', bytes%%(6)
' PRINT UBOUND(bytes%%)
' CALL ARR_BYTE.pop(bytes%%(), b1%%)
' PRINT "b1=", b1%%
' PRINT "b2=", b2%%
' CALL ARR_BYTE.slice(bytes%%(), dest_bytes%%(), 1, 2)
' PRINT dest_bytes%%(0), dest_bytes%%(1)', dest_bytes%%(2)', dest_bytes%%(3)  
' PRINT UBOUND(dest_bytes%%)
' CALL ARR_BYTE.join(bytes%%(), temp_str$)
' PRINT temp_str$
DIM more_bytes(0) AS _BYTE
CALL ARR_BYTE.new(more_bytes%%(), "10,11,12,13")
CALL ARR_BYTE.join(more_bytes%%(), temp_str$)
PRINT temp_str$
PRINT LEN(more_bytes%%)



''
' Slice an array from source to destination starting at index and count slices
'
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


''
' Push a byte onto the end of a _BYTE array
' @param _BYTE arr%%() array to push into
' @param _BYTE value%% of byte to push
'
SUB ARR_BYTE.push(arr%%(), value%%)
    DIM AS INTEGER ub, lb
    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%)
    REDIM _PRESERVE arr(lb% TO (ub% + 1)) AS _BYTE
    arr%%(ub% + 1) = value%%
END SUB


''
' Pop a byte from the end of a _BYTE array
' @param _BYTE arr%%() array to pop from
' @param _BYTE var%% of byte to store popped byte
'
SUB ARR_BYTE.pop(arr%%(), var%%)
    DIM AS INTEGER ub, lb
    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%)
    var%% = arr%%(ub%)
    REDIM _PRESERVE arr(lb% TO (ub% - 1)) AS _BYTE
END SUB


''
' Pop a byte from the beginning of a _BYTE array
' @param _BYTE arr%%() array to pop from
' @param _BYTE var%% of byte to store popped byte
'
SUB ARR_BYTE.shift(arr%%(), var%%)
    DIM AS INTEGER ub, lb, i
    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%)
    var%% = arr%%(lb%)
    FOR i% = lb% TO ub% - 1
        arr%%(i%) = arr%%(i% + 1) 
    NEXT i%
    REDIM _PRESERVE arr(lb% TO (ub% - 1)) AS _BYTE
END SUB


''
' Push a byte into the beginning of a _BYTE array
' @param _BYTE arr%%() array to push into
' @param _BYTE value%% of byte to push
'
SUB ARR_BYTE.unshift(arr%%(), value%%)
    DIM AS INTEGER ub, lb, i
    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%)
    DIM work(lb% TO ub%) AS _BYTE
    CALL ARR_BYTE.copy(arr%%(), work%%())
    REDIM _PRESERVE arr(lb% TO (ub% + 1)) AS _BYTE
    FOR i% = lb% + 1 TO ub% + 1
        arr%%(i%) = work%%(i%-1)
    NEXT i%
    arr%%(lb%) = value%%
END SUB


''
' Copy an array of _BYTEs to another _BYTE array
' @param _BYTE ARRAY source_arr%() source array to copy
' @param _BYTE ARRAY dest_arr%() dest array to copy into
'
SUB ARR_BYTE.copy(source_arr%%(), dest_arr%%())
    DIM AS INTEGER ub, lb, i
    lb% = LBOUND(source_arr%%) : ub% = UBOUND(source_arr%%)
    FOR i% = lb% TO ub%
        dest_arr%%(i%) = source_arr%%(i%)
    NEXT i%
END SUB


''
' Joins an array of _BYTEs as a string
' @param _BYTE ARRAY arr%%() to get as a string
' @param STRING s$ to store stringified array in
' 
SUB ARR_BYTE.join(arr%%(), s$)
    DIM AS INTEGER ub, lb, i
    s$ = ""
    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%)
    FOR i% = lb% TO ub%
        s$ = s$ + _TRIM$(STR$(arr%%(i%))) + ", "
    NEXT i%
    ' remove trailing comma
    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")) )
END SUB


''
' Create a new _BYTE array using string of bytes seperated by commas
' @param _BYTE ARRAY arr%%() to store the bytes in
' @param STRING s$ string of comma separated bytes
'
SUB ARR_BYTE.new(arr%%(), s$)
    DIM AS INTEGER i, count
    DIM t AS STRING
    count% = 0
    FOR i% = 1 TO LEN(s$)
        IF ASC(s$, i%) = ASC(",") THEN count% = count% + 1
    NEXT i%
    REDIM arr(0 TO count%) AS _BYTE
    IF count% = 0 THEN
        arr%%(0) = VAL(s$)
        EXIT SUB
    END IF
    count% = 0
    FOR i% = 1 TO LEN(s$)
        t$ = t$ + CHR$(ASC(s$, i%))
        IF ASC(s$, i%) = ASC(",") OR i% = LEN(s$) THEN 
            arr%%(count%) = VAL(t$)
            count% = count% + 1
            t$ = ""
        END IF
    NEXT i%
END SUB


''
' Return the number of elements in a _BYTE array
' @param _BYTE ARRAY arr%%() to count
' @return INTEGER number of elements
'
FUNCTION ARR_BYTE.count%(arr%%())
    ARR_BYTE.count% = UBOUND(arr%%) - LBOUND(arr%%)
END FUNCTION


''
' Return the size of a _BYTE array
' @param _BYTE ARRAY arr%%() to get size of
' @return INTEGER size in bytes
'
FUNCTION ARR_BYTE.size%(arr%%())
    ' Because this is a byte array the number of elements 
    ' determines the number of bytes as 1 element = 1 byte
    ARR_BYTE.size% = UBOUND(arr%%) - LBOUND(arr%%)
END FUNCTION


''
' Reverses the elements of a _BYTE array
' @param _BYTE ARRAY source_arr%%() to reverse
' @param _BYTE ARRAY dest_arr%%() to store reversed array in
'
SUB ARR_BYTE.reverse(source_arr%%(), dest_arr%%())
    DIM AS INTEGER lb, ub, i, n
    lb% = LBOUND(source_arr%%) : ub% = UBOUND(source_arr%%)
    REDIM dest_arr(0 TO (ub% - lb%)) AS _BYTE
    n% = 0
    FOR i% = ub% TO lb% STEP -1
        dest_arr%%(n%) = source_arr%%(i%)
        n% = n% + 1
    NEXT i%
END SUB


''
' Returns a random byte from a _BYTE array
' @param _BYTE ARRAY arr%%() array to get randomo element from
' @return _BYTE random element
'
FUNCTION ARR_BYTE.random%%(arr%%())
    DIM AS INTEGER lb, ub
    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%)
    RANDOMIZE TIMER 
    ARR_BYTE.random%% = arr%%(INT(RND * (ub% - lb%)) + 1)
END FUNCTION


''
' Shuffle the elements of a _BYTE array
' @param _BYTE ARRAY source_arr%%() to shuffle
' @param _BYTE ARRAY dest_arr%%() to store shuffled array in
'
SUB ARR_BYTE.shuffle(source_arr%%(), dest_arr%%())
    DIM AS INTEGER lb, ub, i, r1, r2, count
    lb% = LBOUND(source_arr%%) : ub% = UBOUND(source_arr%%)
    count% = ub% - lb%
    REDIM dest_arr(0 TO count%) AS _BYTE
    CALL ARR_BYTE.copy(source_arr%%(), dest_arr%%())
    RANDOMIZE TIMER 
    FOR i% = 0 TO count%
        SWAP dest_arr%%(i%), dest_arr%%(lb% + RND * (ub% - lb%)) 
    NEXT i%
END SUB


''
' Sorts _BYTE array in ascending order
' @param _BYTE ARRAY source_arr%%() array to sort
' @param _BYTE ARRAY dest_arr%%() array to store sorted in
'
SUB ARR_BYTE.sort(source_arr%%(), dest_arr%%())
    DIM AS INTEGER lb, ub, i, count, n
    lb% = LBOUND(source_arr%%) : ub% = UBOUND(source_arr%%)
    count% = ub% - lb%
    REDIM dest_arr(0 TO count%) AS _BYTE
    CALL ARR_BYTE.copy(source_arr%%(), dest_arr%%())
    CALL ARR_BYTE.quicksort(dest_arr%%(), lb%, ub%, 0)
END SUB


''
' Sorts _BYTE array in descending order
' @param _BYTE ARRAY source_arr%%() array to sort
' @param _BYTE ARRAY dest_arr%%() array to store sorted in
'
SUB ARR_BYTE.rsort(source_arr%%(), dest_arr%%())
    DIM AS INTEGER lb, ub, i, count, n
    lb% = LBOUND(source_arr%%) : ub% = UBOUND(source_arr%%)
    count% = ub% - lb%
    REDIM dest_arr(0 TO count%) AS _BYTE
    CALL ARR_BYTE.copy(source_arr%%(), dest_arr%%())
    CALL ARR_BYTE.quicksort(dest_arr%%(), lb%, ub%, 1)
END SUB


''
' Quicksort array with pivot algorithm by logiclrd
'
' @link https://www.tek-tips.com/faqs.cfm?fid=336
' @param _BYTE ARRAY array%%() to sort
' @param INTEGER start% of range to sort
' @param INTEGER finish% range of sort
' @param INTEGER order% to sort by (0 = asc / 1 = desc)
'
SUB ARR_BYTE.quicksort(arr%%(), start%, finish%, order%)
    DIM pivot AS INTEGER
    DIM pivotvalue AS _BYTE

    'first, partition the array
    pivot% = start%
    pivotvalue%% = arr%%(pivot%)
    FOR i% = start% + 1 TO finish%
        IF order% = 0 THEN
            IF arr%%(i%) < pivotvalue%% THEN
                arr%%(pivot%) = arr%%(i%)
                arr%%(i%) = arr%%(pivot% + 1)
                arr%%(pivot% + 1) = pivotvalue%%
                pivot% = pivot% + 1
            END IF
        ELSE
            IF arr%%(i%) > pivotvalue%% THEN
                arr%%(pivot%) = arr%%(i%)
                arr%%(i%) = arr%%(pivot% + 1)
                arr%%(pivot% + 1) = pivotvalue%%
                pivot% = pivot% + 1
            END IF
        END IF
    NEXT i%

    'then, sort the subarrays to each side of the pivot
    IF pivot% - start% >= 2 THEN 
        CALL ARR_BYTE.quicksort(arr%%(), start%, pivot% - 1, order%)
    END IF
    IF finish% - pivot% >= 2 THEN 
        CALL ARR_BYTE.quicksort(arr%%(), pivot% + 1, finish%, order%)
    END IF
END SUB