Dim d(20) As Long

Randomize Timer
_ControlChr Off

Screen _NewImage(1200, 800, 32)
d(4) = _LoadFont("dpoly\DPoly Four-Sider.otf", 64)
d(6) = _LoadFont("dpoly\DPoly Six-Sider.otf", 64, "monospace")
d(8) = _LoadFont("dpoly\DPoly Eight-Sider.otf", 64, "monospace")
d(10) = _LoadFont("dpoly\DPoly Ten-Sider.otf", 64, "monospace")
d(12) = _LoadFont("dpoly\DPoly Twelve-Sider.otf", 64, "monospace")
d(20) = _LoadFont("dpoly\DPoly Twenty-Sider.otf", 64, "monospace")

_Font d(20)
For i = 32 To 127
    Print Chr$(i);
Next
v = 31
For y = 0 To _Height - _FontHeight Step _FontHeight
    For x = 0 To _Width - _FontWidth Step _FontWidth
        v = v + 1
        If v > 127 Then _Continue
        _UPrintString (x, y + _Height / 2), Chr$(v)
    Next
Next
Sleep



_Font 16
