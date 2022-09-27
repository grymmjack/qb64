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

DEFINT A-Z
'$DYNAMIC

DIM SHARED Dbg: Dbg = 1
DIM SHARED powerOf2&(11)
FOR a = 0 TO 11: powerOf2&(a) = 2 ^ a: NEXT a

TYPE GIFDATA
  file AS INTEGER
  sigver AS STRING * 6
  width AS _UNSIGNED INTEGER
  height AS _UNSIGNED INTEGER
  bpp AS _UNSIGNED _BYTE
  sortFlag AS _BYTE ' Unused
  colorRes AS _UNSIGNED _BYTE
  colorTableFlag AS _BYTE
  bgColor AS _UNSIGNED _BYTE
  aspect AS SINGLE ' Unused
  numColors AS _UNSIGNED INTEGER
  palette AS STRING * 768
END TYPE

TYPE FRAMEDATA
  addr AS LONG
  left AS _UNSIGNED INTEGER
  top AS _UNSIGNED INTEGER
  width AS _UNSIGNED INTEGER
  height AS _UNSIGNED INTEGER
  localColorTableFlag AS _BYTE
  interlacedFlag AS _BYTE
  sortFlag AS _BYTE ' Unused
  palBPP AS _UNSIGNED _BYTE
  minimumCodeSize AS _UNSIGNED _BYTE
  transparentFlag AS _BYTE 'GIF89a-specific (animation) values
  userInput AS _BYTE ' Unused
  disposalMethod AS _UNSIGNED _BYTE
  delay AS SINGLE
  transColor AS _UNSIGNED _BYTE
END TYPE

TYPE GFX2_COLOR_CYCLE
    inverse           AS INTEGER
    speed             AS INTEGER
    color_range_start AS _BYTE
    color_range_end   AS _BYTE
END TYPE

DIM gifData AS GIFDATA
DIM frameData(0 TO 0) AS FRAMEDATA

filename$ = "C:\git\qb64\qb64\IMAGE-TESTS\ASSETS\test.gif"  '<<<<<<<<<<<< Enter a file name here!!!
openGif filename$, gifData, frameData()
CLOSE gifData.file

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
direction$ = "pingpong"

' Determine color range of cycling
range = endIdx - startIdx

' Holds all the colors
DIM c(255, 3) AS LONG

' Get starting palette from image using color array
FOR z& = 0 TO UBOUND(c)
    value32& = _RGB32(ASC(gifData.palette, z& * 3 + 1), ASC(gifData.palette, z& * 3 + 2), ASC(gifData.palette, z& * 3 + 3))
    'PRINT HEX$(_RGB32(ASC(gifData.palette, i * 3 + 1), ASC(gifData.palette, i * 3 + 2), ASC(gifData.palette, i * 3 + 3)))
    r& = _RED32(value32&)
    g& = _GREEN32(value32&)
    b& = _BLUE32(value32&)
    c&(z&, 1) = r&
    c&(z&, 2) = g&
    c&(z&, 3) = b&
NEXT z&

dump_colors c&(), "SCREEN 13", FALSE

END

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


SUB openGif (filename$, gifData AS GIFDATA, frameData() AS FRAMEDATA) STATIC
    file = FREEFILE: gifData.file = file
    OPEN "B", gifData.file, filename$
    GET file, , gifData.sigver
    GET file, , gifData.width
    GET file, , gifData.height
    GET file, , byte~%%
    gifData.bpp = (byte~%% AND 7) + 1
    gifData.sortFlag = (byte~%% AND 8) > 0
    gifData.colorRes = (byte~%% \ 16 AND 7) + 1
    gifData.colorTableFlag = (byte~%% AND 128) > 0
    gifData.numColors = 2 ^ gifData.bpp
    GET file, , gifData.bgColor
    GET file, , byte~%%
    IF byte~%% = 0 THEN gifData.aspect = 0 ELSE gifData.aspect = (byte~%% + 15) / 64

    IF gifData.sigver <> "GIF87a" AND gifData.sigver <> "GIF89a" THEN _DEST 0: PRINT "Invalid version": END
    IF NOT gifData.colorTableFlag THEN _DEST 0: PRINT "No Color Table": END

    palette$ = SPACE$(3 * gifData.numColors)
    GET file, , palette$
    gifData.palette = palette$
    IF Dbg AND 1 THEN 
    PRINT "sigver         ="; gifData.sigver
    PRINT "width          ="; gifData.width
    PRINT "height         ="; gifData.height
    PRINT "bpp            ="; gifData.bpp
    PRINT "sortFlag       ="; gifData.sortFlag
    PRINT "colorRes       ="; gifData.colorRes
    PRINT "colorTableFlag ="; gifData.colorTableFlag
    PRINT "bgColor        ="; gifData.bgColor
    PRINT "aspect         ="; gifData.aspect
    PRINT "numColors      ="; gifData.numColors
    FOR i = 0 TO gifData.numColors - 1
        PRINT USING "pal(###) = "; i;
        PRINT HEX$(_RGB32(ASC(gifData.palette, i * 3 + 1), ASC(gifData.palette, i * 3 + 2), ASC(gifData.palette, i * 3 + 3)))
    NEXT
    END IF
    DO
    GET file, , byte~%%
    IF Dbg AND 2 THEN PRINT "Chunk: "; HEX$(byte~%%)
    SELECT CASE byte~%%
        CASE &H2C ' Image Descriptor
        IF frame > UBOUND(frameData) THEN
            REDIM _PRESERVE frameData(0 TO frame * 2 - 1) AS FRAMEDATA
        END IF

        GET file, , frameData(frame).left
        GET file, , frameData(frame).top
        GET file, , frameData(frame).width
        GET file, , frameData(frame).height
        GET file, , byte~%%
        frameData(frame).localColorTableFlag = (byte~%% AND 128) > 0
        frameData(frame).interlacedFlag = (byte~%% AND 64) > 0
        frameData(frame).sortFlag = (byte~%% AND 32) > 0
        frameData(frame).palBPP = (byte~%% AND 7) + 1
        frameData(frame).addr = LOC(file) + 1

        IF frameData(frame).localColorTableFlag THEN
            SEEK file, LOC(file) + 3 * 2 ^ frameData(frame).palBPP + 1
        END IF
        GET file, , frameData(frame).minimumCodeSize
        IF Dbg AND 2 THEN 
            PRINT "addr                ="; HEX$(frameData(frame).addr - 1)
            PRINT "left                ="; frameData(frame).left
            PRINT "top                 ="; frameData(frame).top
            PRINT "width               ="; frameData(frame).width
            PRINT "height              ="; frameData(frame).height
            PRINT "localColorTableFlag ="; frameData(frame).localColorTableFlag
            PRINT "interlacedFlag      ="; frameData(frame).interlacedFlag
            PRINT "sortFlag            ="; frameData(frame).sortFlag
            PRINT "palBPP              ="; frameData(frame).palBPP
            PRINT "minimumCodeSize     ="; frameData(frame).minimumCodeSize
        END IF
        IF localColors THEN _DEST 0: PRINT "Local color table": END
        IF frameData(frame).disposalMethod > 2 THEN PRINT "Unsupported disposalMethod: "; frameData(frame).disposalMethod: END
        skipBlocks file

        frame = frame + 1
        CASE &H3B ' Trailer
        EXIT DO
        CASE &H21 ' Extension Introducer
        GET file, , byte~%% ' Extension Label
        IF Dbg AND 2 THEN PRINT "Extension Introducer: "; HEX$(byte~%%)
        SELECT CASE byte~%%
            CASE &HFF, &HFE ' Application Extension, Comment Extension
            skipBlocks file
            CASE &HF9
            IF frame > UBOUND(frameData) THEN
                REDIM _PRESERVE frameData(0 TO frame * 2 - 1) AS FRAMEDATA
            END IF

            GET 1, , byte~%% ' Block Size (always 4)
            GET 1, , byte~%%
            frameData(frame).transparentFlag = (byte~%% AND 1) > 0
            frameData(frame).userInput = (byte~%% AND 2) > 0
            frameData(frame).disposalMethod = byte~%% \ 4 AND 7
            GET 1, , delay~%
            IF delay~% = 0 THEN frameData(frame).delay = 0.1 ELSE frameData(frame).delay = delay~% / 100
            GET 1, , frameData(frame).transColor
            IF Dbg AND 2 THEN 
                PRINT "frame           ="; frame
                PRINT "transparentFlag ="; frameData(frame).transparentFlag
                PRINT "userInput       ="; frameData(frame).userInput
                PRINT "disposalMethod  ="; frameData(frame).disposalMethod
                PRINT "delay           ="; frameData(frame).delay
                PRINT "transColor      ="; frameData(frame).transColor
            END IF
            skipBlocks file
            CASE ELSE
            PRINT "Unsupported extension Label: "; HEX$(byte~%%): END
        END SELECT
        CASE ELSE
        PRINT "Unsupported chunk: "; HEX$(byte~%%): END
    END SELECT
    LOOP

    REDIM _PRESERVE frameData(0 TO frame - 1) AS FRAMEDATA
END SUB


SUB skipBlocks (file)
    DO
        GET file, , byte~%% ' Block Size
        IF Dbg AND 2 THEN PRINT "block size ="; byte~%%
        SEEK file, LOC(file) + byte~%% + 1
    LOOP WHILE byte~%%
END SUB


'$INCLUDE:'../../../QB64_GJ_LIB/_GJ_LIB.BM'



