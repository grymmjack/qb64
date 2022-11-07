CONST _
    FONT = "ASSETS/Geometos.ttf", _
    BG_IMG = "ASSETS/STARFIELD.JPG", _
    BG_ALPHA = 100, _
    W = 1280, _
    H = 720, _
    BPP = 32, _
    TITLE_BOX_H = 140, _
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
img_bg& = _LOADIMAGE(BG_IMG)
_BLEND img_bg&
_BLEND CANVAS&
_SETALPHA BG_ALPHA, ,img_bg&
_PUTIMAGE (1, 1), img_bg&, CANVAS&

DRAW "" _
    + "B M1,1" _
    + " C" + STR$(_RGB(0,0,0)) _
    + " R" + STR$(W) _
    + " D" + STR$(TITLE_BOX_H) _
    + " L" + STR$(W) _
    + " U" + STR$(TITLE_BOX_H) _ 
    + " B M2,2 " _
    + " P" + STR$(_RGB(0,0,0)) + "," + STR$(_RGB(0,0,0))

F2& = _LOADFONT(FONT, TITLE_PX)
_FONT F2&, img_title&
_DEST img_title&
    COLOR _RGB(255, 255, 255)
    _PRINTSTRING (1, 1), "QB64 IN VSCODE", img_title&
_DEST 0
_PUTIMAGE (TITLE_X, TITLE_Y), img_title&, CANVAS&

F& = _LOADFONT(FONT, SUBTITLE_PX)
_FONT F&, img_subtitle&
_DEST img_subtitle&
    COLOR _RGB(128, 128, 128)
    _PRINTSTRING (1, 1), "LET'S LOOK AT", img_subtitle&
_DEST 0
_PUTIMAGE (SUBTITLE_X, SUBTITLE_Y), img_subtitle&, CANVAS&

SLEEP