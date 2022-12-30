Option _Explicit
Do Until _ScreenExists: Loop
_Title "Driven Draw"

Screen _NewImage(640, 640, 32)
Randomize Timer

Dim Shared NBodies As Integer
NBodies = 99

Dim q(2 * NBodies + 1) As Double
Dim qtmp(2 * NBodies + 1) As Double
Dim p(2 * NBodies + 1) As Double
Dim f(4, 2 * NBodies + 1) As Double
Dim dt As Double

Dim Shared As Double mx, my, mx0, my0, mb
Dim Shared As Double x(NBodies), y(NBodies), l(NBodies), m(NBodies)
Dim Shared As Double g, xd0, yd0, omegadx, omegady, damp
Dim Shared As Integer MouseMode
Dim As Integer j

Dim t1 As _Unsigned Long
t1 = _FreeTimer
On Timer(t1, .01) RePin
Timer(t1) On

Timer(t1) Off
Timer(t1) On
NBodies = 4
MouseMode = 1
dt = .005
For j = 1 To NBodies
    l(j) = 10
    m(j) = 1
Next
g = -100.0
xd0 = 10
omegadx = 10
yd0 = 10
omegady = 10
damp = 0.3
For j = 1 To NBodies
    q(2 * j - 1) = -(_Pi) + (Rnd - .5) * 1
    q(2 * j) = 0
Next
q(2 * NBodies + 1) = 0

Dim As Long iter
Do
    iter = iter + 1

    Do While (_MouseInput): Loop
    If (_MouseButton(1)) Then mb = 1

    mx = _MouseX - _Width / 2
    my = -(_MouseY) + _Height / 2

    For j = 1 To 2 * NBodies + 1: qtmp(j) = q(j): Next
    Call Calculate(p(), qtmp())
    For j = 1 To 2 * NBodies + 1: f(1, j) = dt * p(j): Next

    For j = 1 To 2 * NBodies + 1: qtmp(j) = q(j) + f(1, j) / 2: Next
    Call Calculate(p(), qtmp())
    For j = 1 To 2 * NBodies + 1: f(2, j) = dt * p(j): Next

    For j = 1 To 2 * NBodies + 1: qtmp(j) = q(j) + f(2, j) / 2: Next
    Call Calculate(p(), qtmp())
    For j = 1 To 2 * NBodies + 1: f(3, j) = dt * p(j): Next

    For j = 1 To 2 * NBodies + 1: qtmp(j) = q(j) + f(3, j): Next
    Call Calculate(p(), qtmp())
    For j = 1 To 2 * NBodies + 1: f(4, j) = dt * p(j): Next

    For j = 1 To 2 * NBodies + 1
        q(j) = q(j) + (f(1, j) + (2 * f(2, j)) + (2 * f(3, j)) + f(4, j)) / 6
    Next

    'Cls
    Line (0, 0)-(_Width, _Height), _RGB32(0, 0, 0, 1), BF

    x(0) = mx + mb * xd0 * Cos(omegadx * q(2 * NBodies + 1))
    y(0) = my + mb * yd0 * Sin(omegady * q(2 * NBodies + 1))

    For j = 1 To NBodies
        x(j) = x(j - 1) + l(j) * Sin(q(2 * j - 1))
        y(j) = y(j - 1) - l(j) * Cos(q(2 * j - 1))
    Next

    For j = 0 To NBodies - 1
        Call LineSmooth(x(j), y(j), x(j + 1), y(j + 1), _RGB32(255 - 28, 255 - 28, 255 - 255, 255))
    Next

    For j = 1 To NBodies
        Call CCircleF(x(j), y(j), 2, hRGB~&(j / _Pi + iter / 1000))
    Next

    _Display
    mb = 0
Loop

System

' modified from vince
Function hRGB~& (h As Double)
    Dim As Double r, g, b
    Do While (h < 0)
        h = 1 + h
    Loop
    Do While (h > 1)
        h = h - 1
    Loop
    r = Abs(.5 * (1 + Cos(2 * _Pi * h)))
    If (h < 2 / 3) Then g = Abs(.5 * (1 - Cos(2 * _Pi * h * 1.5)))
    If (h > 1 / 3) Then b = Abs(.5 * (1 + Cos(2 * _Pi * h * 1.5)))
    hRGB~& = _RGB32(255 * r, 255 * g, 255 * b, 255)
End Function

Sub RePin
    Dim As Double n
    n = .05
    mx0 = n * mx + (1 - n) * mx0
    my0 = n * my + (1 - n) * my0
End Sub

Sub Calculate (p() As Double, q() As Double)
    Dim A(NBodies, NBodies) As Double
    Dim AInv(NBodies, NBodies) As Double
    Dim B(NBodies) As Double
    Dim As Integer n, j, k
    Dim As Double xdd, ydd

    If (MouseMode = 1) Then
        xdd = (mx - mx0) * xd0
        ydd = (my - my0) * xd0
    Else
        xdd = -xd0 * (omegadx ^ 2) * Cos(omegadx * q(2 * NBodies + 1))
        ydd = -yd0 * (omegady ^ 2) * Sin(omegady * q(2 * NBodies + 1))
    End If

    For n = 1 To NBodies
        A(n, n) = 0
        For j = n To NBodies
            A(n, n) = A(n, n) + m(j)
        Next
        A(n, n) = A(n, n) * l(n) ^ 2
    Next

    For n = 1 To NBodies
        For k = 1 To NBodies
            If (n <> k) Then
                A(n, k) = 0
                For j = n To NBodies
                    A(n, k) = A(n, k) + m(j) * sigma(k, j) * l(n) * l(k) * Cos(q(2 * n - 1) - q(2 * k - 1))
                Next
            End If
        Next
    Next

    For n = 1 To NBodies
        B(n) = 0
        For j = n To NBodies
            B(n) = B(n) - m(j) * l(n) * (xdd * Cos(q(2 * n - 1)) + ydd * Sin(q(2 * n - 1)))
            B(n) = B(n) + g * m(j) * l(n) * Sin(q(2 * n - 1))
            For k = 1 To j
                If (n <> k) Then
                    B(n) = B(n) - m(j) * l(n) * l(k) * q(2 * k) ^ 2 * Sin(q(2 * n - 1) - q(2 * k - 1))
                End If
            Next
        Next
    Next

    Call InverseMatrix(AInv(), A())

    For j = 1 To NBodies
        p(2 * j - 1) = q(2 * j)
        p(2 * j) = -damp * Sgn(q(2 * j)) * (Abs(q(2 * j)) ^ 1.5)
        For k = 1 To NBodies
            p(2 * j) = p(2 * j) + AInv(j, k) * B(k)
        Next
    Next
    p(2 * NBodies + 1) = 1

End Sub

Function sigma (x As Integer, y As Integer)
    Dim TheReturn As Integer
    If (x > y) Then TheReturn = 0
    If (x <= y) Then TheReturn = 1
    sigma = TheReturn
End Function

Sub InverseMatrix (i() As Double, a() As Double)
    Dim As Integer n, j, k
    Dim As Double f, deta
    n = UBound(a, 1)
    Dim s(n - 1, n - 1) As Double
    deta = Determinant(a())
    For j = 1 To n
        For k = 1 To n
            Call SubMatrix(s(), a(), k, j)
            f = Determinant(s())
            'i(j, k) = ((-1) ^ (j + k)) * f / deta
            If (((j + k) Mod 2) = 1) Then f = -1 * f
            i(j, k) = f / deta
        Next
    Next
End Sub

Sub SubMatrix (s() As Double, a() As Double, r As Integer, c As Integer)
    Dim As Integer j, k
    Dim As Integer y, x
    y = 0
    For j = 1 To UBound(a, 1)
        If (j <> r) Then
            y = y + 1
            x = 0
            For k = 1 To UBound(a, 2)
                If (k <> c) Then
                    x = x + 1
                    s(y, x) = a(j, k)
                End If
            Next
        End If
    Next
End Sub

Function Determinant (a() As Double)
    Dim TheReturn As Double
    Dim As Double f
    Dim As Integer n, j
    n = UBound(a, 1)
    If (n = 1) Then
        TheReturn = a(1, 1)
    End If
    If (n = 2) Then
        TheReturn = a(1, 1) * a(2, 2) - a(1, 2) * a(2, 1)
    End If
    If (n > 2) Then
        Dim b(n - 1, n - 1) As Double
        For j = 1 To n
            Call SubMatrix(b(), a(), 1, j)
            f = Determinant(b())
            If ((j Mod 2) = 0) Then f = -1 * f
            TheReturn = TheReturn + a(1, j) * f
        Next
    End If
    Determinant = TheReturn
End Function

Sub CPrintstring (x0 As Double, y0 As Double, txt As String)
    _PrintString (_Width / 2 + x0 - Len(txt) * 4, -y0 + _Height / 2 - 8), txt
End Sub

Sub CPset (x0 As Double, y0 As Double, shade As _Unsigned Long)
    PSet (_Width / 2 + x0, -y0 + _Height / 2), shade
End Sub

Sub CLineBF (x0 As Double, y0 As Double, x1 As Double, y1 As Double, shade As _Unsigned Long)
    Line (_Width / 2 + x0, -y0 + _Height / 2)-(_Width / 2 + x1, -y1 + _Height / 2), shade, BF
End Sub

Sub CCircleF (x As Long, y As Long, r As Long, c As Long)
    Dim As Long xx, yy, e
    xx = r
    yy = 0
    e = -r
    Do While (yy < xx)
        If (e <= 0) Then
            yy = yy + 1
            Call CLineBF(x - xx, y + yy, x + xx, y + yy, c)
            Call CLineBF(x - xx, y - yy, x + xx, y - yy, c)
            e = e + 2 * yy
        Else
            Call CLineBF(x - yy, y - xx, x + yy, y - xx, c)
            Call CLineBF(x - yy, y + xx, x + yy, y + xx, c)
            xx = xx - 1
            e = e - 2 * xx
        End If
    Loop
    Call CLineBF(x - r, y, x + r, y, c)
End Sub

Sub LineSmooth (x0 As Single, y0 As Single, x1 As Single, y1 As Single, c As _Unsigned Long)
    ' source: https://en.wikipedia.org/w/index.php?title=Xiaolin_Wu%27s_line_algorithm&oldid=852445548
    ' translated: FellippeHeitor @ qb64.org
    ' bugfixed for alpha channel

    Dim plX As Integer, plY As Integer, plI

    Dim steep As _Byte
    steep = Abs(y1 - y0) > Abs(x1 - x0)

    If steep Then
        Swap x0, y0
        Swap x1, y1
    End If

    If x0 > x1 Then
        Swap x0, x1
        Swap y0, y1
    End If

    Dim dx, dy, gradient
    dx = x1 - x0
    dy = y1 - y0
    gradient = dy / dx

    If dx = 0 Then
        gradient = 1
    End If

    'handle first endpoint
    Dim xend, yend, xgap, xpxl1, ypxl1
    xend = _Round(x0)
    yend = y0 + gradient * (xend - x0)
    xgap = (1 - ((x0 + .5) - Int(x0 + .5)))
    xpxl1 = xend 'this will be used in the main loop
    ypxl1 = Int(yend)
    If steep Then
        plX = ypxl1
        plY = xpxl1
        plI = (1 - (yend - Int(yend))) * xgap
        Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot

        plX = ypxl1 + 1
        plY = xpxl1
        plI = (yend - Int(yend)) * xgap
        Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot
    Else
        plX = xpxl1
        plY = ypxl1
        plI = (1 - (yend - Int(yend))) * xgap
        Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot

        plX = xpxl1
        plY = ypxl1 + 1
        plI = (yend - Int(yend)) * xgap
        Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot
    End If

    Dim intery
    intery = yend + gradient 'first y-intersection for the main loop

    'handle second endpoint
    Dim xpxl2, ypxl2
    xend = _Round(x1)
    yend = y1 + gradient * (xend - x1)
    xgap = ((x1 + .5) - Int(x1 + .5))
    xpxl2 = xend 'this will be used in the main loop
    ypxl2 = Int(yend)
    If steep Then
        plX = ypxl2
        plY = xpxl2
        plI = (1 - (yend - Int(yend))) * xgap
        Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot

        plX = ypxl2 + 1
        plY = xpxl2
        plI = (yend - Int(yend)) * xgap
        Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot
    Else
        plX = xpxl2
        plY = ypxl2
        plI = (1 - (yend - Int(yend))) * xgap
        Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot

        plX = xpxl2
        plY = ypxl2 + 1
        plI = (yend - Int(yend)) * xgap
        Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot
    End If

    'main loop
    Dim x
    If steep Then
        For x = xpxl1 + 1 To xpxl2 - 1
            plX = Int(intery)
            plY = x
            plI = (1 - (intery - Int(intery)))
            Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot

            plX = Int(intery) + 1
            plY = x
            plI = (intery - Int(intery))
            Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot

            intery = intery + gradient
        Next
    Else
        For x = xpxl1 + 1 To xpxl2 - 1
            plX = x
            plY = Int(intery)
            plI = (1 - (intery - Int(intery)))
            Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot

            plX = x
            plY = Int(intery) + 1
            plI = (intery - Int(intery))
            Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c))) 'GoSub plot

            intery = intery + gradient
        Next
    End If

    Exit Sub

    plot:
    ' Change to regular PSET for standard coordinate orientation.
    'Call CPset(plX, plY, _RGB32(_Red32(c), _Green32(c), _Blue32(c), plI * _Alpha32(c)))
    'Return
End Sub
