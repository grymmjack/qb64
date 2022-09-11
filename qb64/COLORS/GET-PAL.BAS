'$INCLUDE:'../_LIB/DUMP.BI'
SCREEN _NEWIMAGE(_DESKTOPWIDTH,_DESKTOPHEIGHT,13)
_FULLSCREEN _SQUAREPIXELS

CONST FALSE = 0: CONST TRUE = NOT FALSE

DIM COLORS&(255, 2)
OUT &H3C7, 0
FOR i = 0 TO 255
    COLORS&(i,0) = INP(&H3C9)*4
    COLORS&(i,1) = INP(&H3C9)*4
    COLORS&(i,2) = INP(&H3C9)*4
NEXT i

'DO
DIM SHARED COLPAL&(9,9)

DIM foo%(9)
fill_int_arr foo%(), 9, 1, 1

PRINT dump_integer_array$(foo%(), "foo")

'COLPAL& = palette_cycle(0, 9, 1, 1000)
'PRINT dump_long_array$(COLPAL&(), "palette_cycle")
'LOOP UNTIL _KEYHIT=27



SUB fill_int_arr (arr%(), num%, value%, valueStep%)
    l% = LBOUND(arr%) : u% = UBOUND(arr%) : diff% = u% - l%
    IF diff% < num% THEN 
        EXIT SUB
    END IF
    FOR i% = l% TO num%
        IF valueStep% > 0 THEN
            arr%(i%) = i% * valueStep%
        ELSE
            arr%(i%) = value%
        END IF
    NEXT i%
END SUB


' move ->
'   0 1 2 3 4 5 6 7 8 9
'   9 0 1 2 3 4 5 6 7 8
'   8 9 0 1 2 3 4 5 6 7
'   7 8 9 0 1 2 3 4 5 6
'   6 7 8 9 0 1 2 3 4 5
'   5 6 7 8 9 0 1 2 3 4
'   4 5 6 7 8 9 0 1 2 3
'   3 4 5 6 7 8 9 0 1 2
'   2 3 4 5 6 7 8 9 0 1
'   1 2 3 4 5 6 7 8 9 0
' - loop


        c = (c + 1) MOD UBOUND(c)
        IF c = 0 THEN c = 1

' FUNCTION palette_cycle& (fromIdx%, toIdx%, direction%, delay%)
'     numColors% = ABS(toIdx% - fromIdx%)
'     STATIC cycleTable(numColors%, numColors%) AS LONG
'     STATIC cycleIdx%
'     offset% = 0
'     DO
'         FOR x% = fromIdx% TO toIdx%
'             FOR y% = fromIdx% TO toIdx%
'                 cycleTable&(y%, x%) = x% + offset%
'             NEXT y%
'         NEXT x%
'         offset% = offset% + 1
'     LOOP UNTIL offset% = numColors%
'     palette_cycle& = cycleTable&
' END FUNCTION



SUB pop_int_arr (arr%(), pop%)
    u = UBOUND(arr%)
    pop% = arr%(u)
    REDIM _PRESERVE arr%(u-1)
END SUB

SUB push_int_arr (arr%(), push%)
    u = UBOUND(arr%)
    REDIM _PRESERVE arr%(u+1)
    arr%(u+1) = push%
END SUB

'dump_colors COLORS&(), "SCREEN 13", TRUE

SUB dump_colors(colors&(), label$, verbose)
    l = LBOUND(colors&) : u = UBOUND(colors&)
    PRINT "COLORS: " label$
    FOR i = l to u
        dump_rgb colors&(i,0), colors&(i,1), colors&(i,2), i, verbose
    NEXT i
END SUB

SUB dump_rgb (r&, g&, b&, idx%, verbose)
    IF verbose THEN 
        PRINT idx% " R:" r& " G: " g& " B: " b& " ";
        COLOR _RGB(r&, g&, b&)
        PRINT CHR$(219)
        COLOR _DEFAULTCOLOR
    ELSE
        COLOR _RGB(r&, g&, b&)
        PRINT CHR$(219);
        COLOR _DEFAULTCOLOR
    END IF
END SUB
'$INCLUDE:'../_LIB/DUMP.BM'
