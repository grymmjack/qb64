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


CANVAS& = _NewImage(W, H, BPP)
Screen CANVAS&
Color , &H0000AA
Cls

img_subtitle& = _NewImage(W, SUBTITLE_PX, BPP)
img_title& = _NewImage(W, TITLE_PX, BPP)
img_temp& = _NewImage(W, TITLE_BOX_H, BPP)

' Background image
img_bg& = _LoadImage(BG_IMG)
_SetAlpha BG_ALPHA, , img_bg&
_PutImage (1, 1), img_bg&, CANVAS&

' Black title box
_Dest img_temp&
DRAW "" _
    + "B M1,1" _
    + " C" + STR$(_RGB(0,0,0)) _
    + " R" + STR$(W) _
    + " D" + STR$(TITLE_BOX_H) _
    + " L" + STR$(W) _
    + " U" + STR$(TITLE_BOX_H) _ 
    + " B M2,2 " _
    + " P" + STR$(_RGB(0,0,0)) + "," + STR$(_RGB(0,0,0))
_SetAlpha TITLE_BOX_ALPHA, , img_temp&
_PutImage (TITLE_BOX_X, TITLE_BOX_Y), img_temp&, CANVAS&
_Dest 0

' Title text
F2& = _LoadFont(FONT, TITLE_PX)
_Font F2&, img_title&
_Dest img_title&
Color _RGB(255, 255, 255)
_PrintMode _KeepBackground
_PrintString (1, 1), "QB64 IN VSCODE", img_title&
_Dest 0
_PutImage (TITLE_X, TITLE_Y), img_title&, CANVAS&

' Sub-title text
F& = _LoadFont(FONT, SUBTITLE_PX)
_Font F&, img_subtitle&
_Dest img_subtitle&
Color _RGB(128, 128, 128)
_PrintMode _KeepBackground
_PrintString (1, 1), "LET'S LOOK AT", img_subtitle&
_Dest 0
_PutImage (SUBTITLE_X, SUBTITLE_Y), img_subtitle&, CANVAS&

' Copy fully rendered screen
old& = _CopyImage(CANVAS&)

' Fade tests
Sleep 2
FadeScreen old&, 0, 0.1, 100

Cls: _PutImage (0, 0), old&

Sleep 2
FadeScreen old&, -1, 0.1, 100

' Clean up
_FreeImage img_subtitle&
_FreeImage img_title&
_FreeImage img_temp&
_FreeImage img_bg&
_FreeImage old&


' Fades the screen to / from black
' img& - image to use. can be the screen or _DEST
' isIn%% - 0 or -1. -1 is fade in, 0 is fade out
' dly! - delay in seconds
' stopat& - %age when to bail out (use for partial fades). -1 to ignore
Sub FadeScreen (img&, isIn%%, dly!, stopat&)
    tmp& = _CopyImage(img&)
    x& = _Width(tmp&) - 1
    y& = _Height(tmp&) - 1

    For i& = 0 To 255
        If stopat& > -1 And ((i& * 100) \ 255) >= stopat& Then Exit For

        _PutImage (0, 0), tmp&

        If isIn%% Then
            Line (0, 0)-(x&, y&), _RGBA32(0, 0, 0, 255 - i&), BF
        Else
            Line (0, 0)-(x&, y&), _RGBA32(0, 0, 0, i&), BF
        End If

        _Display

        _Delay dly!
    Next

    _FreeImage tmp&
End Sub

