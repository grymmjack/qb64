''
' TODO: Add Command Line processing support for multiple files. 
' IMG2ANS-25
' Convert any QB64 supported image into ANSI block art
' (as long as the image is using EGA palette colors)
'
' This version attempts to support 8px font with half block colors in addition
' to full blocks so it's slightly less lossy than IMG2ANS-25.BAS :)
'
' So it is a condensed format that will render properly on 80x25, etc.
'
' @author Rick Christy (grymmjack@gmail.com)
' @link https://youtube.com/grymmjack
' @version 0.1
'

'$INCLUDE:'../SAUCE/SAUCE.BI'

DIM AS LONG CANVAS, SRC_IMAGE
DIM AS INTEGER SRC_W, SRC_H, x, y, z, xx, yy
DIM AS STRING SRC_FILE, ans
DIM AS _UNSIGNED LONG c
CONST E  = 27  ' ESCAPE - The ANSI escape code
CONST B  = 219 '█ BLOCK CHARACTER - Full block foreground
CONST FT = 223 '▀ HALF BLOCK Top FG Bottom BG
CONST FB = 220 '▄ HALF BLOCK Top BG Bottom FG 

' Maps RGB32 _UNSIGNED LONG colors (from POINT(x,y)) to ANSI Escape Color Codes
TYPE ANSI_MAP
    RGBC    AS _UNSIGNED LONG
    FG_CODE AS STRING
    BG_CODE AS STRING
END TYPE
DIM ANSI_MAP(15) AS ANSI_MAP
' BLACK
ANSI_MAP(0).FG_CODE$  = "0;30" : ANSI_MAP(0).RGBC~&  = &HFF000000 : ANSI_MAP(0).BG_CODE$ = "40"
' BLUE
ANSI_MAP(1).FG_CODE$  = "0;34" : ANSI_MAP(1).RGBC~&  = &HFF0000AA : ANSI_MAP(1).BG_CODE$ = "44"
' GREEN
ANSI_MAP(2).FG_CODE$  = "0;32" : ANSI_MAP(2).RGBC~&  = &HFF00AA00 : ANSI_MAP(2).BG_CODE$ = "42"
' CYAN
ANSI_MAP(3).FG_CODE$  = "0;36" : ANSI_MAP(3).RGBC~&  = &HFF00AAAA : ANSI_MAP(3).BG_CODE$ = "46"
' RED
ANSI_MAP(4).FG_CODE$  = "0;31" : ANSI_MAP(4).RGBC~&  = &HFFAA0000 : ANSI_MAP(4).BG_CODE$ = "41"
' PURPLE
ANSI_MAP(5).FG_CODE$  = "0;35" : ANSI_MAP(5).RGBC~&  = &HFFAA00AA : ANSI_MAP(5).BG_CODE$ = "45"
' BROWN
ANSI_MAP(6).FG_CODE$  = "0;33" : ANSI_MAP(6).RGBC~&  = &HFFAA5500 : ANSI_MAP(6).BG_CODE$ = "43"
' WHITE
ANSI_MAP(7).FG_CODE$  = "0;37" : ANSI_MAP(7).RGBC~&  = &HFFAAAAAA : ANSI_MAP(7).BG_CODE$ = "47"
' BRIGHT BLACK
ANSI_MAP(8).FG_CODE$  = "1;30" : ANSI_MAP(8).RGBC~&  = &HFF555555 : ANSI_MAP(8).BG_CODE$ = "5;40"
' BRIGHT BLUE
ANSI_MAP(9).FG_CODE$  = "1;34" : ANSI_MAP(9).RGBC~&  = &HFF5555FF : ANSI_MAP(9).BG_CODE$ = "5;44"
' BRIGHT GREEN
ANSI_MAP(10).FG_CODE$ = "1;32" : ANSI_MAP(10).RGBC~& = &HFF55FF55 : ANSI_MAP(10).BG_CODE$ = "5;42"
' BRIGHT CYAN
ANSI_MAP(11).FG_CODE$ = "1;36" : ANSI_MAP(11).RGBC~& = &HFF55FFFF : ANSI_MAP(11).BG_CODE$ = "5;46"
' BRIGHT RED
ANSI_MAP(12).FG_CODE$ = "1;31" : ANSI_MAP(12).RGBC~& = &HFFFF5555 : ANSI_MAP(12).BG_CODE$ = "5;41"
' BRIGHT PURPLE
ANSI_MAP(13).FG_CODE$ = "1;35" : ANSI_MAP(13).RGBC~& = &HFFFF55FF : ANSI_MAP(13).BG_CODE$ = "5;45"
' BRIGHT YELLOW
ANSI_MAP(14).FG_CODE$ = "1;33" : ANSI_MAP(14).RGBC~& = &HFFFFFF55 : ANSI_MAP(14).BG_CODE$ = "5;43"
' BRIGHT WHITE
ANSI_MAP(15).FG_CODE$ = "1;37" : ANSI_MAP(15).RGBC~& = &HFFFFFFFF : ANSI_MAP(15).BG_CODE$ = "5;47"

' Choose an image file with dialog
SRC_FILE$ = _OPENFILEDIALOG$( _
    "Choose an image", _
    , _
    "*.jpg|*.jpeg|*.png|*.tga|*.bmp|*.psd|*.gif|*.pcx|*.svg|*.qoi", _
    "Image Files", _
    -1 _
)
IF SRC_FILE$ = "" THEN SYSTEM ' image is required...

SRC_FILE$ = SRC_FILE$ + "|"

DIM AS INTEGER i, l, ch
DIM AS STRING filename
l% = LEN(SRC_FILE$)

FOR i%=0 TO l%
    IF i%+1 <= l% THEN ' At end of file list, do nothing
        ch% = ASC(SRC_FILE$, i%+1)
        IF CHR$(ch%) = "|" THEN ' File found
            ' Load the image into the canvas at the same size
            SRC_IMAGE& = _LOADIMAGE(filename$, 32) 
            SRC_W% = _WIDTH(SRC_IMAGE&) : SRC_H% = _HEIGHT(SRC_IMAGE&)
            CANVAS& = _NEWIMAGE(SRC_W%, SRC_H%, 32)
            SCREEN CANVAS&
            _SOURCE SRC_IMAGE& : _DEST CANVAS& : _PUTIMAGE

            ' Parse the image into ansi color blocks
            ans$ = ""
            FOR y% = 0 TO SRC_H% - 2
                IF (y% = 0) OR (y% MOD 2 = 0) THEN
                    ans$ = ans$ + CHR$(E) + "[0m" ' reset on each line
                    FOR x% = 0 TO SRC_W% - 1
                    DIM AS _UNSIGNED LONG TopColor, BottomColor
                    TopColor~& = POINT(x%, y%) ' top pixel
                    BottomColor~& = POINT(x%, y%+1) ' pixel under
                        DIM AS STRING FG_CODE, BG_CODE
                        ' Set defaults in case not found
                        FG_CODE$ = ANSI_MAP(0).FG_CODE$
                        BG_CODE$ = ANSI_MAP(0).BG_CODE$
                        FOR z% = 0 TO UBOUND(ANSI_MAP) ' Get FG Color Code
                            IF TopColor~& = ANSI_MAP(z%).RGBC~& THEN
                                FG_CODE$ = ANSI_MAP(z%).FG_CODE$
                                EXIT FOR
                            END IF            
                        NEXT z%
                        FOR z% = 0 TO UBOUND(ANSI_MAP) ' Get BG Color Code
                            IF BottomColor~& = ANSI_MAP(z%).RGBC~& THEN
                                BG_CODE$ = ANSI_MAP(z%).BG_CODE$
                                EXIT FOR
                            END IF            
                        NEXT z%
                        ans$ = ans$ _
                             + CHR$(E) _
                             + "[0m" _
                             + CHR$(E) _
                             + "[" _
                             + FG_CODE$ _
                             + ";" _
                             + BG_CODE$ _
                             + "m" _
                             + CHR$(FT)
                    NEXT x%
                END IF
                ans$ = ans$ + CHR$(E) + "[0m" ' reset on each line
            NEXT y%

            SCREEN 0
            CLS

            ' Write the output.ans file
            PRINT ans$
            OPEN filename$ + "-25.ans" FOR OUTPUT AS #1
            PRINT #1, ans$
            CLOSE #1

            OPEN filename$ + "-25.ans" FOR APPEND AS #1
            PRINT #1, CHR$(&H1A) ' EOF
            CLOSE #1 

            OPEN filename$ + "-25.ans" FOR BINARY AS #1
            SEEK #1, LOF(1)
            SAUCE.InitPacket
            SauceRecord.ID$         = "SAUCE"
            SauceRecord.Version$    = "00"
            DIM slash AS STRING
            slash$ = "/" : IF _OS$ = "WINDOWS" THEN slash$ = "\"            
            s$ = MID$(filename$, _INSTRREV(filename$, slash$) + 1)
            MID$(SauceRecord.Title$, 1, LEN(s$)) = s$
            s$ = "grymmjack"
            MID$(SauceRecord.Author$, 1, LEN(s$)) = s$
            s$ = "MiSTiGRiS"
            MID$(SauceRecord.Group$, 1, LEN(s$)) = s$
            s$ = "20231231"
            MID$(SauceRecord.Date$, 1, LEN(s$)) = s$
            SauceRecord.FileSize~&  = LOF(1)-1
            SauceRecord.DataType~%% = 1
            SauceRecord.FileType~%% = 1
            SauceRecord.TInfo1~%    = SRC_W%
            SauceRecord.TInfo2~%    = SRC_H% \ 2
            SauceRecord.TInfo3~%    = 0
            SauceRecord.TInfo4~%    = 0
            SauceRecord.Comments~%% = 0
            SauceRecord.TFlags~%%   = 3 '8px iCE Color
            s$ = "IBM VGA"
            MID$(SauceRecord.TInfoS$, 1, LEN(s$)) = s$
            SAUCE.FillPacket
            PUT #1, LOF(1)-1, SauceRecord
            CLOSE #1

            filename$ = ""
        ELSE ' Not at end of filename yet concat...
            filename$ = filename$ + CHR$(ch%)
        END IF
    END IF
NEXT i%

' Clean up
_FREEIMAGE SRC_IMAGE&
_FREEIMAGE CANVAS&

'$INCLUDE:'../SAUCE/SAUCE.BM'
