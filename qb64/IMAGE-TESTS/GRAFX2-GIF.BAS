$Debug
'$INCLUDE:'../../../QB64_GJ_LIB/_GJ_LIB.BI'
canvas& = _NEWIMAGE(1024, 768, 256)
SCREEN canvas&

DIM SHARED buffer~%%(127)
file$ = "C:\GIT\QB64\QB64\IMAGE-TESTS\ASSETS\test.gif"
pos_in_file = find_in_file(file$, "CRNG", buffer~%%())
PRINT pos_in_file
PRINT dump_unsigned_byte_array_as_ascii(buffer~%%(), "DATA")
CONST MAX_CYCLE_CONFIGS = 15

TYPE GFX2_COLOR_CYCLE
    inverse           AS INTEGER
    speed             AS INTEGER
    color_range_start AS _BYTE
    color_range_end   AS _BYTE
END TYPE
DIM cc(MAX_CYCLE_CONFIGS) AS GFX2_COLOR_CYCLE
cycle_size = LEN(cc(0))
PRINT cycle_size

c = 0 : i = 12
DO WHILE c <= MAX_CYCLE_CONFIGS
    ' PRINT BIN$(buffer~%%(i+0)); (buffer~%%(i+0)); HEX$((buffer~%%(i+0)))
    ' PRINT BIN$(buffer~%%(i+1)); (buffer~%%(i+1)); HEX$((buffer~%%(i+1)))
    rate    = buffer~%%(i+0)+buffer~%%(i+1)
    flags   = buffer~%%(i+2)+buffer~%%(i+3)
    col1    = buffer~%%(i+4)
    col2    = buffer~%%(i+5)
    IF col1 <> col2 THEN
        cc(c).inverse = 0
        cc(c).speed   = 0
        cc(c).color_range_start = min(col1, col2)
        cc(c).color_range_end   = max(col1, col2)
        IF flags AND 2 THEN cc(c).inverse = 1
        cc(c).speed = rate
    END IF
    c = c + 1 : i = i + cycle_size
LOOP

FOR i = 0 TO MAX_CYCLE_CONFIGS
    PRINT "cc("; _TRIM$(STR$(i)); "): " _
        "color range start:"; cc(i).color_range_start, _
        "color range end:"; cc(i).color_range_end, _
        "speed"; cc(i).speed, _
        "inverse?:"; cc(i).inverse
NEXT i

img& = _LOADIMAGE(file$, 256)
_SOURCE img&
_DEST canvas&
' _PUTIMAGE(img&, canvas&)
' _DEST CANVAS& : CLS ,0
' img& = _LOADIMAGE("ASSETS/STARFIGHTER-VGA.gif", 256)

' _PUTIMAGE (x,y)-(x+w,y+h), img&, CANVAS&
_PUTIMAGE (700,0), img&, canvas&

limit    = 5 ' Loop limiter
startIdx = cc(0).color_range_start ' Starting palette color
endIdx   = cc(0).color_range_end ' Ending palette color

' Direction of palette cycle
' direction$ = "forwards"   
' direction$ = "backwards"
direction$ = "forwards"

' Determine color range of cycling
range = endIdx - startIdx

HEX_PALETTE_FILE$ = "ASSETS/ANSI32.HEX"

TYPE RGB_COLOR
    R AS INTEGER
    G AS INTEGER
    B AS INTEGER
    H AS STRING
    HEX32 AS STRING
END TYPE

'$DYNAMIC
DIM RGB_PAL(256) AS RGB_COLOR ' Support for 256 colors maximum

' Read the palette from the file and store it in RGB_PAL
OPEN HEX_PALETTE_FILE$ FOR INPUT AS #1&
COLOR_COUNT% = 0
DO UNTIL EOF(1)
    LINE INPUT #1, COLOR$

    RED$   = UCASE$(MID$(COLOR$, 1, 2))
    GREEN$ = UCASE$(MID$(COLOR$, 3, 2))
    BLUE$  = UCASE$(MID$(COLOR$, 5, 2))

    R$ = "&H00" + RED$
    G$ = "&H00" + GREEN$
    B$ = "&H00" + BLUE$
    H$ = "#" + COLOR$
    HEX32$ = "&HFF" + RED$ + GREEN$ + BLUE$

    RGB_PAL(COLOR_COUNT%).R = VAL(R$)
    RGB_PAL(COLOR_COUNT%).G = VAL(G$)
    RGB_PAL(COLOR_COUNT%).B = VAL(B$)
    RGB_PAL(COLOR_COUNT%).H = H$
    RGB_PAL(COLOR_COUNT%).HEX32 = HEX32$

    COLOR_COUNT% = COLOR_COUNT% + 1
LOOP
CLOSE #1

' Resize the array to save space if we aren't using 256 colors
REDIM _PRESERVE RGB_PAL(COLOR_COUNT%) AS RGB_COLOR

' Holds all the colors
DIM c(255, 3) AS LONG

' Get starting palette from image using color array
FOR z& = 0 TO UBOUND(c)
    value32& = _PALETTECOLOR(z&, CANVAS&)
    r& = _RED32(value32&)
    g& = _GREEN32(value32&)
    b& = _BLUE32(value32&)
    c&(z&, 1) = r&
    c&(z&, 2) = g&
    c&(z&, 3) = b&
NEXT z&

dump_colors c&(), "SCREEN 13", FALSE

' Cycle palette until ESC is pressed
DO
    SELECT CASE direction$
        CASE "pingpong":
            FOR o = startIdx TO endIdx
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c&((z + o) MOD range + startIdx, 1), _
                        c&((z + o) MOD range + startIdx, 2), _
                        c&((z + o) MOD range + startIdx, 3) _
                    )
                NEXT z
            NEXT o
            FOR o = endIdx TO startIdx STEP -1
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c&((z + o) MOD range + startIdx, 1), _
                        c&((z + o) MOD range + startIdx, 2), _
                        c&((z + o) MOD range + startIdx, 3) _
                    )
                NEXT z
            NEXT o
        CASE "forwards":
            FOR o = endIdx TO startIdx STEP -1
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c&((z + o) MOD range + startIdx, 1), _
                        c&((z + o) MOD range + startIdx, 2), _
                        c&((z + o) MOD range + startIdx, 3) _
                    )
                NEXT z
            NEXT o
        CASE "backwards":
            FOR o = startIdx TO endIdx
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c&((z + o) MOD range + startIdx, 1), _
                        c&((z + o) MOD range + startIdx, 2), _
                        c&((z + o) MOD range + startIdx, 3) _
                    )
                NEXT z
            NEXT o
    END SELECT
LOOP UNTIL _KEYHIT = 27

SUB dump_colors (colors&(), label$, verbose)
    l = LBOUND(colors&) : u = UBOUND(colors&)
    PRINT "COLORS: " label$
    FOR i = l to u
        dump_rgb colors&(i,1), colors&(i,2), colors&(i,3), i, verbose
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


FUNCTION BIN$(n%)
  maxx% = 8 * LEN(n%) 
  MSB% = 1  'uncomment for 16 (32 or 64) bit returns
  FOR i = maxx% - 1 TO 0 STEP -1    'read as big-endian MSB to LSB
    IF (n% AND 2 ^ i) THEN MSB% = 1: B$ = B$ + "1" ELSE IF MSB% THEN B$ = B$ + "0"
  NEXT
  IF B$ = "" THEN BIN$ = "0" ELSE BIN$ = B$    'check for empty string
END FUNCTION


FUNCTION min (a, b)
    IF a < b THEN
        min = a
    ELSE
        min = b
    END IF
END FUNCTION


FUNCTION max (a, b)
    IF a > b THEN
        max = a
    ELSE
        max = b
    END IF
END FUNCTION


FUNCTION byte_array_to_string$ (bytes~%%())
    l = LBOUND(bytes~%%) : u = UBOUND(bytes~%%)
    s$ = ""
    FOR i = l TO u
        s$ = s$ + CHR$(bytes~%%(i))
    NEXT i
    byte_array_to_string$ = s$
END FUNCTION



FUNCTION find_in_file (filename$, search$, buffer~%%())
    ' search for ascii text
    fn& = FREEFILE
    OPEN filename$ FOR BINARY AS fn&
    DO
        GET fn& , , buffer~%%()
        buff$ = byte_array_to_string$(buffer~%%()) 
        position% = INSTR(buff$, search$)
        IF position% THEN
            found = 1
            found_at = SEEK(fn&) - LEN(buffer~%%()) + position% - 1
            SEEK fn&, found_at
            GET fn& , , buffer~%%()
        ELSE
            found = 0
            PRINT "Seeking - CUR: "; SEEK(1); " DEST: "; SEEK(1)+LEN(buffer~%%())
            SEEK fn&, SEEK(fn&) + LEN(buffer~%%())
        END IF
    LOOP UNTIL found = 1 OR EOF(fn&)
    CLOSE fn&
    IF found THEN
        find_in_file = found_at
    ELSE
        find_in_file = -1
    END IF
END FUNCTION

'$INCLUDE:'../../../QB64_GJ_LIB/_GJ_LIB.BM'
