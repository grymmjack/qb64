$Color:32
Screen _NewImage(1024, 720, 32)
_Font _LoadFont("/home/grymmjack/.local/share/fonts/Geometos.ttf", 48)
Color Black, transparent


Do
    k = _KeyHit
    Select Case k
        Case 19712, 18432: value = _Clamp(value + 1, 0, 100)
        Case 19200, 20480: value = _Clamp(value - 1, 0, 100)
        Case 27: System
    End Select
    DrawKnob 512, 360, 50, 80, value, 200
    _Limit 30
    _Display
Loop



Sub DrawKnob (cX As Long, cy As Long, r1 As Single, r2 As Single, value As Long, maxvalue As Long)
    increase = value / maxvalue * 270
    FilledRingArc cX, cy, 0, r1, 0, 360, DarkGray 'the knob
    FilledRingArc cX, cy, r1, r2, -45, 225, LightGray 'the light gray indicator
    FilledRingArc cX, cy, r1, r2, 225 - increase, 225, Red 'the red value
    _PrintString (cX - _PrintWidth(_ToStr$(value)) / 2, cy - _FontHeight / 2), _ToStr$(value)
End Sub



Sub FilledRingArc (cx As Long, cy As Long, r1 As Long, r2 As Long, a1 As Single, a2 As Single, col As _Unsigned Long)
    ' Draws a filled ring arc (donut slice)
    ' cx, cy  = center
    ' r1      = inner radius
    ' r2      = outer radius
    ' a1, a2  = start/end angles in degrees
    ' col    = fill color

    Const angStep! = 1! ' smaller = smoother arc
    Dim As Single vx(0 To 2000), vy(0 To 2000), interX(0 To 2000)
    Dim As Single angle, x, y, x1, y1, x2, y2, temp
    Dim As Long count, i, j, n, minY, maxY, yScan

    ' Normalize angles
    If a1 < 0 _OrElse a1 > 360 Then a1 = a1 Mod 360
    If a2 < 0 _OrElse a2 > 360 Then a2 = a2 Mod 360
    If a2 < a1 Then a2 = a2 + 360

    ' ---- Outer arc (A1 ? A2) ----
    For angle = a1 To a2 Step angStep
        x = cx + r2 * Cos(_D2R(angle)): y = cy - r2 * Sin(_D2R(angle)): vx(n) = x: vy(n) = y: n = n + 1
    Next

    ' Ensure exact endpoint
    x = cx + r2 * Cos(_D2R(a2)): y = cy - r2 * Sin(_D2R(a2)): vx(n) = x: vy(n) = y: n = n + 1

    ' ---- Inner arc (A2 ? A1, reversed) ----
    For angle = a2 To a1 Step -angStep
        x = cx + r1 * Cos(_D2R(angle)): y = cy - r1 * Sin(_D2R(angle)): vx(n) = x: vy(n) = y: n = n + 1
    Next

    ' Ensure exact endpoint
    x = cx + r1 * Cos(_D2R(a1)): y = cy - r1 * Sin(_D2R(a1)): vx(n) = x: vy(n) = y: n = n + 1

    ' ---- Scanline fill ----
    minY = vy(0): maxY = vy(0)
    For i = 1 To n - 1: maxY = _Max(maxY, vy(i)): minY = _Min(minY, vy(i)): Next

    For yScan = minY To maxY
        count = 0
        ' Find intersections
        For i = 0 To n - 1
            j = (i + 1) Mod n: x1 = vx(i): y1 = vy(i): x2 = vx(j): y2 = vy(j)
            If (y1 <= yScan And y2 > yScan) Or (y2 <= yScan And y1 > yScan) Then
                If y2 <> y1 Then interX(count) = x1 + (yScan - y1) * (x2 - x1) / (y2 - y1): count = count + 1
            End If
        Next
        ' Sort intersections
        For i = 0 To count - 2
            For j = i + 1 To count - 1
                If interX(j) < interX(i) Then Swap interX(i), interX(j)
        Next j, i
        ' Draw spans
        For i = 0 To count - 2 Step 2
            Line (CLng(interX(i)), yScan)-(CLng(interX(i + 1)), yScan), col, BF
        Next
    Next yScan
End Sub
