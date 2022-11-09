CONST _
    FONT = "ASSETS/Geometos.ttf", _
    BG_IMG = "ASSETS/STARFIELD.JPG", _
    BG_ALPHA = 64, _
    W = 1280, _
    H = 720, _
    BPP = 32, _ 
    TITLE_BOX_H = 140, _
    TITLE_BOX_X = 0, _
    TITLE_BOX_Y = 0, _
    TITLE_BOX_ALPHA = 200, _
    SUBTITLE_PX = 32, _
    TITLE_PX = 64, _
    SUBTITLE_X = 32, _
    SUBTITLE_Y = 32, _
    TITLE_X = 32, _
    TITLE_Y = 64


CANVAS& = _NEWIMAGE(W, H, BPP)
SCREEN CANVAS&
COLOR ,&H0000AA
CLS

img_subtitle& = _NEWIMAGE(W, SUBTITLE_PX, BPP)
img_title& = _NEWIMAGE(W, TITLE_PX, BPP)
img_temp& = _NEWIMAGE(W, TITLE_BOX_H, BPP)

' Background image
img_bg& = _LOADIMAGE(BG_IMG)
_SETALPHA BG_ALPHA, , img_bg&
_PUTIMAGE (1, 1), img_bg&, CANVAS&

' Black title box
_DEST img_temp&
DRAW "" _
    + "B M1,1" _
    + " C" + STR$(_RGB(0,0,0)) _
    + " R" + STR$(W) _
    + " D" + STR$(TITLE_BOX_H) _
    + " L" + STR$(W) _
    + " U" + STR$(TITLE_BOX_H) _ 
    + " B M2,2 " _
    + " P" + STR$(_RGB(0,0,0)) + "," + STR$(_RGB(0,0,0))
_SETALPHA TITLE_BOX_ALPHA, , img_temp&
_PUTIMAGE (TITLE_BOX_X, TITLE_BOX_Y), img_temp&, CANVAS&
_DEST 0

' Title text
F2& = _LOADFONT(FONT, TITLE_PX)
_FONT F2&, img_title&
_DEST img_title&
    COLOR _RGB(255, 255, 255)
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING (1, 1), "QB64 IN VSCODE", img_title&
_DEST 0
_PUTIMAGE (TITLE_X, TITLE_Y), img_title&, CANVAS&

' Sub-title text
F& = _LOADFONT(FONT, SUBTITLE_PX)
_FONT F&, img_subtitle&
_DEST img_subtitle&
    COLOR _RGB(128, 128, 128)
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING (1, 1), "LET'S LOOK AT", img_subtitle&
_DEST 0
_PUTIMAGE (SUBTITLE_X, SUBTITLE_Y), img_subtitle&, CANVAS&

' Copy fully rendered screen
old& = _COPYIMAGE(CANVAS&)
_DISPLAY

' Fade tests
SLEEP
fade_out _RGB(255, 255, 255), 25, 1
SLEEP
fade_in old&, 25, 1

' Clean up
_FREEIMAGE img_subtitle&
_FREEIMAGE img_title&
_FREEIMAGE img_temp&
_FREEIMAGE img_bg&
_FREEIMAGE old&



''
' Fades entire screen out to a color percentage at speed
'
' @param LONG toColor& Color to fade to in _RGB() format
' @param INTEGER toPercent% percentage to fade to and stop
' @param INTEGER speed% how fast to fade - 1 = normal speed
' 
SUB fade_out (toColor&, toPercent%, speed%)
    colScreen& = _NEWIMAGE(W, H, BPP)
    _DEST colScreen&
    CLS ,toColor&
    FOR i=0 TO toPercent% STEP speed%
        _SETALPHA i, , colScreen&
        _PUTIMAGE (0, 0), colScreen&, CANVAS&
        _DISPLAY
    NEXT i
    _DEST 0
    _FREEIMAGE colScreen&
END SUB


''
' Fades an image into screen to percentage at speed
'
' @param LONG img& Image handle to fade in from _LOADIMAGE format
' @param INTEGER toPercent% percentage to fade to and stop
' @param INTEGER speed% how fast to fade - 1 = normal speed
' 
SUB fade_in (img&, toPercent%,  speed%)
    FOR i=0 TO toPercent% STEP speed%
        _SETALPHA i, , img&
        _PUTIMAGE (0, 0), img&, CANVAS&
        _DISPLAY
    NEXT i
END SUB
