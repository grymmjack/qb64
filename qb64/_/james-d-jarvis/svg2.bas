'SVG example 2 resizable rectangle
'by James D. Jarvis November 18,2023
'
'This example is going to use much of the previous example but I'm going to show how the format allows for modification.
'
Screen _NewImage(800, 500, 32)
'going to have a resizable window along with a resizable rectangle
$Resize:Smooth
Dim As Long simg 'we are going to draw the SVG into this image
'default values for the rectangle height, width, and corner radius
HT = 100
WD = 200
RC = 12
'this will result in a centered rectangle being drawn on the screen
xoff$ = _Trim$(Str$(Int(_Width / 20))) '_trim$ needs to be used to trim off the leading space STR$ creates to make sure the value is properly entered
yoff$ = _Trim$(Str$(Int(_Height / 20)))
Do
    Cls
    rw1$ = _Trim$(Str$(WD)) 'convert rectangle width to a string value so it fits in the string definition
    rh1$ = _Trim$(Str$(HT)) 'convert rectangle height to a string value so it fits in the string definition
    crd$ = _Trim$(Str$(RC)) 'convert rectangle corner radius to a string value so it fits in the string definition
    goff$ = _Trim$(Str$(HT - _Height / 10)) 'top gradient offset
    'make a minimal header and footer to setup the SVG
    'scaling the postion of the rectangle to be drawn relative to the dimension of the window
    'the header and gradient definitions were moved into the main loop because dimensions may change
    svgheader$ = "<svg x='0' y='0' width='" + _Trim$(Str$(_Width)) + "' height= '" + _Trim$(Str$(_Height)) + "'  >" 'makes sure the SVG will match the screen 1 to 1
    svgfooter$ = "</svg>" 'this idicates the end of the SVG
    'gd$ is going to be the linear gradient
    'gradients have to be defined before they can be called later in the SVG
    gd$ = "  <defs> <linearGradient id='LGrad1' x1='0' y1='0' x2='0' y2='" + rh1$ + "'  >" 'x1,y1,x2,y2 establishes the gradient will run from top to bottom
    gd$ = gd$ + "      <stop class='stop1' offset='0%'stop-color='#550000' />" 'the gradient at this point is starting out dark red
    gd$ = gd$ + "      <stop class='stop2' offset='50%'  stop-color='red' />" 'the gradient at this point is default red
    gd$ = gd$ + "      <stop class='stop3' offset='" + goff$ + "'stop-color='#550000' />" 'the gradient is ending in dark red
    'in the line above we ar setting stop 3 to goff$ so it will match the postion of the rescaled rectangle a little better
    gd$ = gd$ + "    </linearGradient> "
    gd$ = gd$ + " </defs>"
    'i$  will hold the actual image data
    'rect defines a rectanglt at x,y with height and width, rx,ry define the rounded rectangle corners
    i$ = "<rect x='" + xoff$ + "' y='" + yoff$ + "' height='" + rh1$ + "' width='" + rw1$ + "'rx='" + crd$ + "' ry='" + crd$ + "' fill='url(#LGrad1)' stroke='white' stroke-width='9' />"
    i$ = i$ + "<rect x='" + xoff$ + "' y='" + yoff$ + "' height='" + rh1$ + "' width='" + rw1$ + "'rx='" + crd$ + "' ry='" + crd$ + "' fill='none' stroke='black' stroke-width='3' />"
    'note in the second rectangle definition above that draw the back line is set to a fill='none' as opposed to 'transparent' the library doesn't render 'none' but will render 'transparent' as a grey box
    svg$ = svgheader$ + gd$ + i$ + svgfooter$ 'put all the strings together into one string called svg$
    simg = _LoadImage(svg$, 32, "memory") 'load and render the defined SVG$ into simg
    'put some type inside the rectangle, ideally centered
    _Dest simg 'make the destination simg for now
    _PrintMode _KeepBackground
    tx$ = "X,x,Y,y,R,r"
    pax = Val(xoff$) + WD / 2 - (Len(tx$) * 8) / 2
    pay = Val(yoff$) + HT / 2 - 16
    _PrintString (pax, pay), "X,x,Y,y,R,r"
    _PrintString (pax, pay + 16), "to Resize"
    _Dest 0 'return the destination to the screen
    _PutImage , simg 'put simg on the screen
    Print "<ESC> to quit" 'this will show in the same position n the screen regardless of changes
    _Display 'refresh our window with no flickering
    'let's get some user input
    Do
        _Limit 30
        kk$ = InKey$
    Loop Until kk$ <> "" 'wait for a key to be pressed
    Select Case kk$ 'handle the keys pressed
        Case "X" 'enlarge the rectangle width
            If WD < (_Width - _Width / 10) Then WD = WD + 4
        Case "Y" 'enlarge the rectangle height
            If HT < (_Height - _Height / 10) Then HT = HT + 4
        Case "x" 'decrease the rectangle width
            If WD - 4 > (Len(tx$) * 8) + RC Then WD = WD - 4
        Case "y" 'increase the rectangle height
            If HT - 4 > 40 Then HT = HT - 4
        Case "r" 'decrease the corner radius
            If RC > 1 Then RC = RC - 1 'do not decrease the corner radius beneath 1
        Case "R" 'increase the corner radius
            RC = RC + 1
    End Select
    _FreeImage simg 'keep the memory use reasonable, might not always want this in the main loop but it's the best spot for it in this program
Loop Until kk$ = Chr$(27) 'press <ESC> to exit
Cls
Print "The SVG last displayed"
Print svg$
End