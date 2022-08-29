''
' C=64 PETSCII FONT SUPPORT FOR QB64
'
' NOTE:
' To render PETSCII byte for byte you should loop
' through 0 to 255 and _MAPUNICODE using the
' PETSCII_UPPER_PUA or PETSCII_LOWER_PUA codepoint
' accordingly. I will build a PETSCII viewer later
' to read SEQ files from C64 maybe!
'
' Since we have foreground and background colors:
' - I skipped mapping inverse characters
' - I mapped all of the PETSCII glyphs (shifted and unshifted)
' - I kept the full alphabet (UPPER and lower)
'
' Get the font from here:
' https://style64.org/c64-truetype
'
' Tested and working in SCREEN 0, 12, and 13
'
' @author   Rick Christy
' @email    grymmjack@gmail.com
' @depends  C64_Pro-STYLE.ttf
' @see      https://style64.org/c64-truetype
'
' _FULLSCREEN _SQUAREPIXELS
SCREEN 9
ROOT_PATH$ = ENVIRON$("SYSTEMROOT")
FONT_FILE$ = "C64_Pro-STYLE.ttf"
FONT_STYLE$ = "MONOSPACE"
F& = _LOADFONT(FONT_FILE$, 16, FONT_STYLE$)
_FONT F&
_CONTROLCHR OFF
CLS
LOCATE 1, 1
PETSCII_UPPER_PUA = 60928 '&HEE00
PETSCII_UPPER_OFFSET = 64

PETSCII_LOWER_PUA = 61184 '&HEF00
PETSCII_LOWER_OFFSET = 28

FOR I = 127 TO (255 - PETSCII_UPPER_OFFSET)
    _MAPUNICODE PETSCII_UPPER_PUA - PETSCII_UPPER_OFFSET + I TO I
NEXT I

FOR I = (255 - PETSCII_UPPER_OFFSET) TO (255 - PETSCII_LOWER_OFFSET)
    _MAPUNICODE PETSCII_LOWER_PUA + PETSCII_LOWER_OFFSET + I TO I
NEXT I

FOR I = &H00 TO &HFF
    PRINT CHR$(I);
    IF I MOD 16 = 0 THEN PRINT
NEXT I

END
