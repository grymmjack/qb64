_Title "Lava Flow" 'bplus 2019-12-12 based on Lava 3.bas SmallBASIC 2015-04-25

'================================================================================
'                  Press Spacebar for slightly differnt lava effect
'================================================================================

Const xmax = 1200, ymax = 720, n = 800, bg = &HFF000000 '<< try different colors
Dim Shared x(1 To n), y(1 To n), xr(1 To n), yr(1 To n), c(1 To n) As _Unsigned Long
Screen _NewImage(xmax, ymax, 32)
_FullScreen
Randomize Timer
For i = 1 To n: new i, -1: Next 'init lava
Line (0, 0)-(xmax, ymax), bg, BF 'black'n screen
Do
    If InKey$ = " " Then toggle = 1 - toggle
    For i = 1 To n
        If toggle Then Color c(i) Else Color lavaColor~&
        fEllipse x(i), y(i), xr(i), yr(i)
        x(i) = x(i) + xr(i)
        y(i) = y(i) + (Int(Rnd * 3) - 1) * yr(i) + .1
        If x(i) > xmax Then new i, 0
        If y(i) < -5 Or y(i) > ymax + 5 Then new i, 0
    Next
    xp = Int(Rnd * (xmax - 5)) + 1
    yp = Int(Rnd * (ymax - 5)) + 1
    Paint (xp, yp), fire~&, bg
    If xp Mod 100 = 50 Or xp Mod 100 = 55 Then Paint (xp, yp), bg, bg
    _Limit 30
Loop Until _KeyDown(27)
System

Sub fEllipse (CX As Long, CY As Long, xRadius As Long, yRadius As Long)
    Dim scale As Single, x As Long, y As Long
    scale = yRadius / xRadius
    Line (CX, CY - yRadius)-(CX, CY + yRadius), , BF
    For x = 1 To xRadius
        y = scale * Sqr(xRadius * xRadius - x * x)
        Line (CX + x, CY - y)-(CX + x, CY + y), , BF
        Line (CX - x, CY - y)-(CX - x, CY + y), , BF
    Next
End Sub

Sub new (i, rndxTF)
    If rndxTF Then x(i) = Int(Rnd * (xmax - 10)) + 5 Else x(i) = Rnd * 10
    y(i) = Int(Rnd * (ymax - 10)) + 5
    xr(i) = Int(Rnd * 4) + 3
    yr(i) = Rnd * xr(i) * .5
    c(i) = lavaColor~&
End Sub

Function fire~&
    If Rnd < .25 Then fire~& = &HFF000000 Else fire~& = _RGB32(255, Rnd * 128 + 127, 0)
End Function

Function lavaColor~&
    r = Int(Rnd * 31)
    If r Mod 4 = 0 Then lavaColor = bg Else lavaColor~& = _RGB32(r / 30 * 128 + 127, Rnd * r / 45 * 255, 0)
End Function