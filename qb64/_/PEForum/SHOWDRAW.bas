'---------------------------------------------------
'show draw header
'---------------------------------------------------
Dim Shared dspace& 'this is the drawing space/canvas that allows mixed mode graphics routines to function
Dim Shared ts& 'the text screen
Dim Shared stwd, stht
stwd = 80: stht = 40 'resize as you wish, on my monitor 2pixels wide per 1 vertical looks decent
ts& = _NewImage(stwd, stht, 0)
dspace& = _NewImage(stwd + 1, stht + 1, 32)
Screen ts&
_FullScreen
'-------------------------------------
'demo code
'-------------------------------------
Print "Plain old text screen set to 80 characters wide by 40 characters high."
Input "Enter a your name"; uname$
_Dest dspace& 'set the destination so graphics commands will be drawn into space&
Line (1, 1)-(stwd, stht), _RGB32(3, 176, 7), BF
Color _RGB32(15, 48, 0)
_PrintString (1, 1), "GIANT TEXT"
Circle (15, 15), 8, _RGB32(8, 72, 0)
Line (2, 2)-(20, 20), _RGB32(31, 176, 15), B
Color _RGB32(15, 48, 0)
_Dest ts& 'set the screen to the text screen
showdraw 1, 1, stwd, stht 'show dspace on the textscreen rendered in characters
Color 15, 0 'change the color it may be changed in showdraw
_Delay 1
Print "WELL WELL WELL"
_Delay 1
Cls
Print "WELL WELL WELL... you can use any standard graphics command."
Print
For cx = -5 To 90
    Print "An animated circle, on a text screem."
    _Limit 24
    _Dest dspace& 'rember to set the destination to dspace& before you call showdraw
    Line (1, 1)-(stwd, stht), _RGB32(8, 177, 7), BF
    For bl = -20 To 80 Step 5
        Line (bl, 1)-(bl + 6, stht), _RGB32(12, Asc("*"), 2)
    Next bl
    Circle (cx, 21), 5, _RGB32(15, 219, 0)
    showdraw 1, 1, stwd, stht 'showdraw always writes to ts& so you don't have to change destination manually
Next cx
_Dest dspace& 'writitng to dspace& again
Color _RGB32(15, 219, 0) 'use color _RGB32( FOREGROUND_COLOR, DRAWN_CHARACTER, background_color) before printing to dspace&
_PrintString (1, 1), uname$
showdraw 1, 1, stwd, stht
Color 15, 0 'restoring to text mode colors white and black for foreground and background
Locate 1, 1: Print "BYE"
_Delay 1


'-----------------------------------------
'SHOWDRAW
'copies the image from the drawing space onto the text screen
'each pixel in dspace& will hold the text screen character and colors
'-----------------------------------------
Sub showdraw (xa, ya, xb, yb)
    Dim tk As _Unsigned Long
    'render from xa,ya to xb,yb from dspace& to the ts&
    x1 = xa: x2 = xb: y1 = ya: y2 = yb
    If x1 < 1 Then x1 = 1
    If y1 < 1 Then x1 = 1
    If y2 > stht Then y2 = stht
    If x2 > stwd Then x2 = stwd
    For x = x1 To x2
        For y = y1 To y2
            _Source dspace&
            tk = Point(x, y)
            Locate 1, 1
            tc = _Red32(tk) 'the red color channel is foreground color for the text screen
            ac = _Green32(tk) 'the green color channel is the ascii character to be drawn to the text screen
            bc = _Blue32(tk) 'the blue color background color for the text screen
            If tc > 0 Then
                _Dest ts&
                Color tc, bc
                _PrintString (x, y), Chr$(ac)
            End If
        Next y
    Next x
    _Source ts&
End Sub