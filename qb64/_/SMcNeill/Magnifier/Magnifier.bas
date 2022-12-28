Type POINTAPI
    X As Long
    Y As Long
End Type
Dim WinMse As POINTAPI


Declare Dynamic Library "Gdi32"
    Function CreateEllipticRgn%& (ByVal x1&, Byval y1&, Byval x2&, Byval y2&)
End Declare

Declare Dynamic Library "User32"
    Function GetWindowLongA& (ByVal hwnd As Long, Byval nIndex As Long)
    Function SetWindowLongA& (ByVal hwnd As Long, Byval nIndex As Long, Byval dwNewLong As Long)
    Function SetWindowPos& (ByVal hwnd As Long, Byval hWndInsertAfter As Long, Byval x As Long, Byval y As Long, Byval cx As Long, Byval cy As Long, Byval wFlags As Long)
    Function SetWindowRgn (ByVal windowhandle%&, Byval region%&, Byval redraw%%)
    Function GetCursorPos (lpPoint As POINTAPI)
    Function GetKeyState% (ByVal nVirtKey As Long) 'reads Windows key presses independently
End Declare
GWL_STYLE = -16
WS_VISIBLE = &H10000000

Screen _NewImage(720, 720, 32)


_ScreenHide
hwnd& = _WindowHandle
winstyle& = GetWindowLongA&(hwnd&, GWL_STYLE)
a& = SetWindowLongA&(hwnd&, GWL_STYLE, winstyle& And WS_VISIBLE)
a& = SetWindowPos&(hwnd&, -2, 0, 0, 0, 0, 39)
rgn%& = CreateEllipticRgn(0, 0, _Width - 1, _Height - 1)
result = SetWindowRgn(hwnd&, rgn%&, -1)


magnify = -1
_ScreenShow
zoom = 5
Do
    update = (update + 1) Mod 6
    Cls , 0
    m = GetCursorPos(WinMse)
    If GetKeyState(17) < 0 Then 'CTRL +
        If GetKeyState(&HBD) < 0 Then zoom = zoom + .2
        If GetKeyState(&HBB) < 0 Then zoom = zoom - .2

        If GetKeyState(Asc("M")) < 0 Then 'M for MAGNIFY
            magnify = Not magnify
            If magnify Then _ScreenShow Else _ScreenHide
            _Delay .2 'give the user time to get their fat fingers off the CTRL-M keys so we don't have multi on/off events instantly.
        End If
        If GetKeyState(Asc("Q")) < 0 Then System 'Q for QUIT
        If GetKeyState(Asc("P")) < 0 Then _ScreenMove WinMse.X - 320, WinMse.Y - 320 'P for POSITION
    End If

    If zoom < .2 Then zoom = .2
    If zoom > 10 Then zoom = 10
    If update = 1 Then
        If DTI Then _FreeImage DTI
        DTI = _ScreenImage
    End If

    _PutImage , DTI, 0, (WinMse.X - 50 * zoom, WinMse.Y - 50 * zoom)-(WinMse.X + 50 * zoom, WinMse.Y + 50 * zoom)

    _Limit 30
    oldx = WinMse.X: oldy = WinMse.Y
    _Display
Loop