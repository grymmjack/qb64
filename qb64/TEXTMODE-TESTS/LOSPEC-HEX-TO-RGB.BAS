''
' LOSPEC TO QB64 RGB_COLOR IMPORTER
'
' Loads LOSPEC HEX format palette into RGB_COLOR array
'
' RGB_COLOR
'   .[R | G | B] = INTEGER: Decimal values for red, green, and blue
'   .H = STRING: RGB color in web format (#RRGGBB)
'   .HEX32 = STRING: QB64 HEX32 Color for use with _PALETTECOLOR
'
' @see: https://lospec.com/palette-list/ansi32
' @uses: https://lospec.com/palette-list/ansi32.hex
' @author Rick Christy <grymmjack@gmail.com>
'

_FULLSCREEN _SQUAREPIXELS, _SMOOTH

' Palette downloaded from LOSPEC in HEX format
HEX_PALETTE_FILE$ = "ASSETS/C64PAL.HEX"
_BLINK OFF

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

' Initialize the screen
SCREEN _NEWIMAGE(800, 600, 256)
WIDTH 80, 50
CLS

' Display the results
PRINT "LOSPEC TO QB64 RGB_COLOR IMPORTER BY GRYMMJACK"
COLOR 8,0
PRINT STRING$(64, "-")
PRINT "PALETTE FILE: " + CHR$(34) + HEX_PALETTE_FILE$ + CHR$(34)
PRINT STR$(COLOR_COUNT%) + " COLORS IMPORTED - ARRAY SIZE: " + STR$(UBOUND(RGB_PAL))
PRINT STRING$(64, "-")
PRINT   "  #       RED     GREEN      BLUE       #HEX        HEX32"
TEMP$ = "###       ###       ###       ###       &     &"
PRINT STRING$(64, "-")

FOR I% = 0 TO COLOR_COUNT%
    _PALETTECOLOR I%, VAL(RGB_PAL(I%).HEX32$)
    IF I% = 0 THEN
        COLOR I%, I%+1
    ELSE
        COLOR I%, 0
    END IF

    PRINT USING TEMP$; _
        I%+1, _
        RGB_PAL(I%).R, _
        RGB_PAL(I%).G, _
        RGB_PAL(I%).B, _ 
        LTRIM$(RGB_PAL(I%).H), _
        LTRIM$(RGB_PAL(I%).HEX32)
NEXT I%
