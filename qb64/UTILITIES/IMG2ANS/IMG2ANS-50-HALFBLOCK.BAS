''
' TODO: Add Command Line processing support for multiple files. 
' IMG2ANS-HALFBLOCK
' Convert any QB64 supported image into ANSI block art
' (as long as the image is using EGA palette colors)
'
' This version attempts to support 9px font with half block colors in addition
' to full blocks so it's slightly less lossy than IMG2ANS-25.BAS :)
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
CONST E  = 27   ' ESCAPE - The ANSI escape code
CONST B  = 219  '█ BLOCK CHARACTER - Full block foreground
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
ANSI_MAP(0).FG_CODE$  = CHR$(E)+"[0;30m" : ANSI_MAP(0).RGBC~&  = &HFF000000 : ANSI_MAP(0).BG_CODE$ = CHR$(E)+"[40m"
' BLUE
ANSI_MAP(1).FG_CODE$  = CHR$(E)+"[0;34m" : ANSI_MAP(1).RGBC~&  = &HFF0000AA : ANSI_MAP(1).BG_CODE$ = CHR$(E)+"[44m"
' GREEN
ANSI_MAP(2).FG_CODE$  = CHR$(E)+"[0;32m" : ANSI_MAP(2).RGBC~&  = &HFF00AA00 : ANSI_MAP(2).BG_CODE$ = CHR$(E)+"[42m"
' CYAN
ANSI_MAP(3).FG_CODE$  = CHR$(E)+"[0;36m" : ANSI_MAP(3).RGBC~&  = &HFF00AAAA : ANSI_MAP(3).BG_CODE$ = CHR$(E)+"[46m"
' RED
ANSI_MAP(4).FG_CODE$  = CHR$(E)+"[0;31m" : ANSI_MAP(4).RGBC~&  = &HFFAA0000 : ANSI_MAP(4).BG_CODE$ = CHR$(E)+"[41m"
' PURPLE
ANSI_MAP(5).FG_CODE$  = CHR$(E)+"[0;35m" : ANSI_MAP(5).RGBC~&  = &HFFAA00AA : ANSI_MAP(5).BG_CODE$ = CHR$(E)+"[45m"
' BROWN
ANSI_MAP(6).FG_CODE$  = CHR$(E)+"[0;33m" : ANSI_MAP(6).RGBC~&  = &HFFAA5500 : ANSI_MAP(6).BG_CODE$ = CHR$(E)+"[43m"
' WHITE
ANSI_MAP(7).FG_CODE$  = CHR$(E)+"[0;37m" : ANSI_MAP(7).RGBC~&  = &HFFAAAAAA : ANSI_MAP(7).BG_CODE$ = CHR$(E)+"[47m"
' BRIGHT BLACK
ANSI_MAP(8).FG_CODE$  = CHR$(E)+"[1;30m" : ANSI_MAP(8).RGBC~&  = &HFF555555 : ANSI_MAP(8).BG_CODE$ = CHR$(E)+"[5;40m"
' BRIGHT BLUE
ANSI_MAP(9).FG_CODE$  = CHR$(E)+"[1;34m" : ANSI_MAP(9).RGBC~&  = &HFF5555FF : ANSI_MAP(9).BG_CODE$ = CHR$(E)+"[5;44m"
' BRIGHT GREEN
ANSI_MAP(10).FG_CODE$ = CHR$(E)+"[1;32m" : ANSI_MAP(10).RGBC~& = &HFF55FF55 : ANSI_MAP(10).BG_CODE$ = CHR$(E)+"[5;42m"
' BRIGHT CYAN
ANSI_MAP(11).FG_CODE$ = CHR$(E)+"[1;36m" : ANSI_MAP(11).RGBC~& = &HFF55FFFF : ANSI_MAP(11).BG_CODE$ = CHR$(E)+"[5;46m"
' BRIGHT RED
ANSI_MAP(12).FG_CODE$ = CHR$(E)+"[1;31m" : ANSI_MAP(12).RGBC~& = &HFFFF5555 : ANSI_MAP(12).BG_CODE$ = CHR$(E)+"[5;41m"
' BRIGHT PURPLE
ANSI_MAP(13).FG_CODE$ = CHR$(E)+"[1;35m" : ANSI_MAP(13).RGBC~& = &HFFFF55FF : ANSI_MAP(13).BG_CODE$ = CHR$(E)+"[5;45m"
' BRIGHT YELLOW
ANSI_MAP(14).FG_CODE$ = CHR$(E)+"[1;33m" : ANSI_MAP(14).RGBC~& = &HFFFFFF55 : ANSI_MAP(14).BG_CODE$ = CHR$(E)+"[5;43m"
' BRIGHT WHITE
ANSI_MAP(15).FG_CODE$ = CHR$(E)+"[1;37m" : ANSI_MAP(15).RGBC~& = &HFFFFFFFF : ANSI_MAP(15).BG_CODE$ = CHR$(E)+"[5;47m"

' Choose an image file with dialog
SRC_FILE$ = _OPENFILEDIALOG$( _
    "Choose an image", _
    , _
    "*.jpg|*.jpeg|*.png|*.tga|*.bmp|*.psd|*.gif|*.hdr|*.pic|*.pnm|*.pcx|*.svg|*.qoi", _
    "Image Files", _
    -1 _
)
IF SRC_FILE$ = "" THEN SYSTEM ' image is required...

SRC_FILE$ = SRC_FILE$ + "|"

' PRINT SRC_FILE$
' SLEEP

DIM AS INTEGER i, l, ch
DIM AS STRING filename
l% = LEN(SRC_FILE$)
' PRINT l%
' SLEEP

FOR i%=0 TO l%
    IF i%+1 <= l% THEN ' At end of file list, do nothing
        ch% = ASC(SRC_FILE$, i%+1)
        IF CHR$(ch%) = "|" THEN ' File found
            ' PRINT "PROCESSING: "; filename$; i%
            ' SLEEP
            
            ' Load the image into the canvas at the same size
            SRC_IMAGE& = _LOADIMAGE(filename$, 32) 
            SRC_W% = _WIDTH(SRC_IMAGE&) : SRC_H% = _HEIGHT(SRC_IMAGE&)
            CANVAS& = _NEWIMAGE(SRC_W%, SRC_H%, 32)
            SCREEN CANVAS&
            _SOURCE SRC_IMAGE& : _DEST CANVAS& : _PUTIMAGE

            ' Parse the image into ansi color blocks
            ans$ = ""
            FOR y% = 0 TO SRC_H% - 1
                ans$ = ans$ + CHR$(E) + "[0m" ' reset on each line
                FOR x% = 0 TO SRC_W% - 1
                    DIM AS _UNSIGNED LONG TopColor, BottomColor
                    TopColor~& = POINT(x%, y%)
                    BottomColor~& = POINT(x%, y%+1)
                    ' IF y% > 0 AND y% MOD 2 = 0 THEN
                        ' IF TopColor~& = BottomColor~& THEN ' Solid block
                        '     FOR z% = 0 TO UBOUND(ANSI_MAP)
                        '         IF TopColor~& = ANSI_MAP(z%).RGBC~& THEN
                        '             ans$ = ans$ + ANSI_MAP(z%).FG_CODE$ + CHR$(B)
                        '             EXIT FOR
                        '         END IF            
                        '     NEXT z%
                        ' ELSE ' Half block
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
                            ans$ = ans$ + FG_CODE$ + BG_CODE$ + CHR$(FT)
                        ' END IF
                    ' END IF
                NEXT x%
                ' ans$ = ans$ + CHR$(10) ' line feed
            NEXT y%

            SCREEN 0
            CLS

            ' Write the output.ans file
            PRINT ans$
            OPEN filename$ + "-50-halfblock.ans" FOR OUTPUT AS #1
            PRINT #1, ans$
            CLOSE #1

            OPEN filename$ + "-50-halfblock.ans" FOR APPEND AS #1
            PRINT #1, CHR$(&H1A) ' EOF
            CLOSE #1 

            OPEN filename$ + "-50-halfblock.ans" FOR BINARY AS #1
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
            SauceRecord.TInfo2~%    = SRC_H%
            SauceRecord.TInfo3~%    = 0
            SauceRecord.TInfo4~%    = 0
            SauceRecord.Comments~%% = 0
            SauceRecord.TFlags~%%   = 3 '8px iCE Color
            s$ = "IBM VGA50"
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
