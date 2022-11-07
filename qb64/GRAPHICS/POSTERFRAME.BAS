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

img_bg& = _LOADIMAGE(BG_IMG)
_SETALPHA BG_ALPHA, , img_bg&
_PUTIMAGE (1, 1), img_bg&, CANVAS&

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

F2& = _LOADFONT(FONT, TITLE_PX)
_FONT F2&, img_title&
_DEST img_title&
    COLOR _RGB(255, 255, 255)
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING (1, 1), "QB64 IN VSCODE", img_title&
_DEST 0
_PUTIMAGE (TITLE_X, TITLE_Y), img_title&, CANVAS&

example$ = "" _
    + " zindex:0" _
    + " font:geometos" _
    + " font_size:32" _
    + " color_fg:" + STR$(_RGB(128, 128, 128)) _
    + " color_bg:" + STR$(_RGB(0, 0, 0)) _
    + " width:" + STR$(W) _
    + " height: " + STR$(TITLE_BOX_H) _
    + " alpha:200" _
    + " text:'LET\'S LOOK AT'"

' TYPE LAYER
'     AS _UNSIGNED INTEGER zindex, font_size, width, height, alpha
'     AS LONG color_fg, color_bg
' END TYPE
' DIM title AS LAYER
' title.zindex = 0
' title.font = "geometos"
' title.font_size = 32
' title.color_fg = _RGB(128, 128, 128)
' title.color_bg = _RGB(0, 0, 0)
' title.width = W
' title.height = TITLE_BOX_H
' title.alpha = TITLE_BOX_ALPHA
' title.text = "LET'S LOOK AT"
' draw_layer(title)

F& = _LOADFONT(FONT, SUBTITLE_PX)
_FONT F&, img_subtitle&
_DEST img_subtitle&
    COLOR _RGB(128, 128, 128)
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING (1, 1), "LET'S LOOK AT", img_subtitle&
_DEST 0
_PUTIMAGE (SUBTITLE_X, SUBTITLE_Y), img_subtitle&, CANVAS&

SLEEP