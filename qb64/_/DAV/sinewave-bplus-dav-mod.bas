 
Dim w, h
w = 640
h = 640
Screen _NewImage(w, h, 32)
_ScreenMove 340, 60
Dim i, t, x, y
Do
    t = t + 0.01
    Line (0, 0)-(w, h), _RGBA(0, 0, 0, 25), BF
    For i = 1 To 8
        Color _RGBA(i * 32, i * 32 * .7, 0, i * 32)
        For x = 0 To w
            y = 100 * Sin(_Pi * x / w) * Sin(1 * _Pi * x / w + t + i * t * _Pi * 0.1)
            Circle (x, h / 2 + y), i
            Circle (w / 2 + y, x), i
        Next
    Next
    _Display
    _Limit 30
Loop