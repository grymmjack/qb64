_Title "Particle Fountain" 'b+ 2020-08-27
Const nP = 5000
Type particle
    x As Single
    y As Single
    dx As Single
    dy As Single
    r As Single
    c As _Unsigned Long
End Type
Dim Shared p(1 To nP) As particle
Screen _NewImage(800, 600, 32)
_Delay .25
_ScreenMove _Middle
For i = 1 To nP
    new i
Next
Color , &HFF002200
Do
    Cls
    If lp < nP Then lp = lp + 100
    For i = 1 To lp
        p(i).dy = p(i).dy + .1
        p(i).x = p(i).x + p(i).dx
        p(i).y = p(i).y + p(i).dy
        If p(i).x < 0 Or p(i).x > _Width Then new i
        If p(i).y > _Height And p(i).dy > 0 Then
            p(i).dy = -.75 * p(i).dy: p(i).y = _Height - 5
        End If
        Circle (p(i).x, p(i).y), p(i).r, p(i).c
    Next
    _Display
    _Limit 60
Loop Until _KeyDown(27)
Sub new (i)
    p(i).x = _Width / 2 + Rnd * 20 - 10
    p(i).y = _Height + Rnd * 5
    p(i).dx = Rnd * 1 - .5
    p(i).dy = -10
    p(i).r = Rnd * 3
    p(i).c = _RGB32(50 * Rnd + 165, 50 * Rnd + 165, 255)
End Sub