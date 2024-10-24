'Paint Pixels 8
'by Sierraken, B+, Steve, and Dav.
'Developed at the QB64 Forums.
'Made on July 5, 2020
'Technical Notes:
'First I want to thank all of the people that have helped me so far in this program:
'B+ for the color picker and help with the circles, boxes and rays and other help.
'SpriggySpriggs for his file opening and saving examples that inspired me to keep going.
'Dav for the Right Click Menu and helping me fix bugs.
'Thank you also to everyone else who has used and helped me with this!
'Steve for helping me fix a bug.
'-----------------------------------------------------------------------------------------------
'New Additions for Version 8:
'Right Click Menu to select everything you need to draw with.
'Fixed Lines, Circles, and Boxes so that you can put them anywhere using the mouse by
'dragging their sizes with the left mouse button. Also lets you place as many as you want.
'Made boxes not fill-in anymore because there is already a fill-in option.
'Fixed lines, circles, and boxes visibility.
'Added Text Mode.
'Added 3D Text.
'Added Title Screen
'Updated on Aug. 14, 2024: Improved File Dialog with no need for library files anymore.
'-----------------------------------------------------------------------------------------------
$Color:32
'=== =============DEFINES FOR RIGHT CLICK MENU - CHANGE TO SUIT ==========================
DECLARE FUNCTION RightClickMenu% ()

Dim Shared RightClickItems: RightClickItems = 24 '    <----- Number of items in your menu
Dim Shared RightClickList$(1 To RightClickItems)

RightClickList$(1) = "New" '     <------------ List all your menu items here
RightClickList$(2) = "Open..."
RightClickList$(3) = "Save As..."
RightClickList$(4) = "---" '   <------------ This means it's a separator (---)
RightClickList$(5) = "Draw"
RightClickList$(6) = "---"
RightClickList$(7) = "Erase"
RightClickList$(8) = "---"
RightClickList$(9) = "Paint Color"
RightClickList$(10) = "Lines"
RightClickList$(11) = "Circles"
RightClickList$(12) = "Boxes"
RightClickList$(13) = "Text"
RightClickList$(14) = "---"
RightClickList$(15) = "Fill-In"
RightClickList$(16) = "---"
RightClickList$(17) = "Undo"
RightClickList$(18) = "---" '     <------------ (another separator)
RightClickList$(19) = "Print"
RightClickList$(20) = "---"
RightClickList$(21) = "Help"
RightClickList$(22) = "Exit Menu"
RightClickList$(23) = "---"
RightClickList$(24) = "Exit Paint Pixels"

'========================================================================================

Dim mousex, mousey, mouseRightButton, mouseLeftButton
Dim ecc$, ist, screensz, screenx, screeny
Dim begin, bcol, mo, mm, a%, button, img, a$, a2$
Dim back&
Dim s&
Dim picture&
Dim undo&
Dim clr~&
Dim i&
Dim copy&
Dim j&
Dim landscape&
Dim lastx, lasty, size, size2, xx, yy, seconds, sz
Dim XMAX, YMAX, i$
Dim f&

_Limit 500
_Title "Paint Pixels 8"
Screen _NewImage(640, 480, 32)
i& = _LoadImage("Title.png")
Screen i&
_Delay 5
start:
Cls
Screen 0
_FreeImage i&
_FullScreen _Off
_Title "Paint Pixels 8"
Width 40, 43
_Font 16
Color 15, 0
_ScreenMove _Middle
Print
Print "          Paint Pixels 8"
Print
Print "   By SierraKen, B+, Steve, and Dav"
Print
Print "   Developed at the QB64 Forums."
Print
Print
Print "          Instructions"
Print
Print "  Right-Click on the drawing screen"
Print "  with your mouse to see the Menu."
Print
Print "Use mouse to paint and also to plot and"
Print "change sizes of Lines, Circles, and"
Print "Boxes holding down the left mouse"
Print "button. Release button to keep them."
Print "You can also add Text, Fill-In, and"
Print "select Undo to remove your last action."
Print "Save, Open, and Print on your printer."
Print
Print "  Supports: JPG, PNG, GIF, BMP"
Print
Print "  Press the Space Bar to begin."
Print
Print "        Or Esc to quit."
paintpixelsinst:
ecc$ = InKey$
If ecc$ = " " Then GoTo start2:
If ecc$ = Chr$(27) Then End
If ecc$ = "" Then GoTo paintpixelsinst:
GoTo paintpixelsinst:
start2:
If ist = 1 Then ist = 0: GoTo start4:
Cls
Screen 0
_Title "Paint Pixels 8"
Width 40, 43
_Font 16
Color 15, 0
Print "            Screen Size"
Print
Print "         (1) 640 x 480"
Print "         (2) 800 x 600"
Print "         (3) 1024 x 768"
Print "         (4) 1536 x 1024"
Print "         (5) Other"
Print
Print "Type number (1-5) here:"
screensize:
screensz = Val(InKey$)
If screensz = 1 Then screenx = 640: screeny = 480: GoTo nextsc:
If screensz = 2 Then screenx = 800: screeny = 600: GoTo nextsc:
If screensz = 3 Then screenx = 1024: screeny = 768: GoTo nextsc:
If screensz = 4 Then screenx = 1536: screeny = 1024: GoTo nextsc:
If screensz = 5 Then
    morescreensz:
    Print
    Input "Horizontal X (640-1920): ", screenx
    If screenx < 640 Or screenx > 1920 Then Print "Try again.": GoTo morescreensz:
    Input "Vertical   Y (480-1024): ", screeny
    If screeny < 480 Or screeny > 1024 Then Print "Try again.": GoTo morescreensz:
    GoTo nextsc:
End If
GoTo screensize:

'Choose Background Color.
nextsc:
Cls
background& = _NewImage(800, 600, 32)
begin = 1
bcol = 0
background& = _LoadImage("colorwheelpage.png", 32)
Screen background&
mouseLeftButton = 0
colorwheel:
_Limit 500
Do While _MouseInput
    mousex = _MouseX
    mousey = _MouseY
    mouseLeftButton = _MouseButton(1)
Loop
If mouseLeftButton = -1 Then
    back& = Point(mousex, mousey)
    If back& = _RGB32(0, 0, 0) Then bcol = 1
    mouseLeftButton = 0
    mousex = 0: mousey = 0
    GoTo start3:
End If
GoTo colorwheel:
start3:
_Limit 500
If undo& Then _FreeImage undo&
undo& = _NewImage(screenx, screeny, 32)
If s& Then _FreeImage s&
s& = _NewImage(screenx, screeny, 32)
If picture& Then _FreeImage picture&
picture& = _NewImage(screenx, screeny, 32)
Screen s&
Line (0, 0)-(screenx, screeny), back&, BF
_PutImage , s&, picture&
Cls
begin = 1
_Title "Choose Your Paint Color Here By Using The 4 Sliders With Your Mouse."
GoSub chosencolor:
start4:
_ScreenMove _Middle
mo = 1
_Title "Right Click Mouse To See Menu."
'---------------------------------------------------
'Here is the main loop of the program when painting.
'---------------------------------------------------
Do

    _Limit 500
    _PutImage , picture&, s&
    Screen s&
    Do While _MouseInput
        mousex = _MouseX
        mousey = _MouseY
        mouseLeftButton = _MouseButton(1)
        mouseRightButton = _MouseButton(2)
    Loop
    If mouseLeftButton = 0 Then button = 1
    a$ = InKey$
    a% = RightClickMenu% ' <----- Check for rightclick menu

    '=== what did you select?
    If a% > 0 Then
        If a% = 1 Then a2$ = "1"
        If a% = 2 Then a2$ = "l"
        If a% = 3 Then a2$ = "s"
        If a% = 5 Then a2$ = "d"
        If a% = 7 Then a2$ = "e"
        If a% = 9 Then a2$ = "c"
        If a% = 10 Then a2$ = "r": 'lastx = 0: lasty = 0
        If a% = 11 Then a2$ = "o": 'lastx = 0: lasty = 0
        If a% = 12 Then a2$ = "b": 'lastx = 0: lasty = 0
        If a% = 13 Then a2$ = "t"
        If a% = 15 Then a2$ = "f"
        If a% = 17 Then a2$ = "u"
        If a% = 19 Then a2$ = "p"
        If a% = 21 Then a2$ = "i"
        If a% = 22 Then a% = 0
        If a% = 24 Then End
        mouseLeftButton = 0
        a% = 0
    End If
    'Here is when someone whipes the screen blank with the space bar.
    If a2$ = "1" Then a2$ = "": GoTo start2:
    If a2$ = "s" Then
        a2$ = ""
        GoSub saving:
    End If
    If a2$ = "l" Then
        a2$ = ""
        GoSub loading:
    End If
    If a2$ = "i" Or a$ = Chr$(27) Then m = 0: ist = 1: a2$ = "": a$ = "": GoTo start:
    'Here is code needed to call up the Windows Color Picker.
    'It also uses the code on top of this program and the Function at the end
    'of this program.
    If a2$ = "c" Then
        a2$ = ""
        chosencolor:
        check$ = colorDialog$
        If check$ <> "" Then clr~& = Val(check$) 'ELSE <<< don't change drawing color
        If begin = 1 Then begin = 0: Return
    End If
    If a2$ = "d" Then
        a2$ = ""
        a% = 0
        mo = 1
    End If
    If mo = 1 Then
        If mouseLeftButton Then
            If button = 1 Then
                lastx = mousex
                lasty = mousey:
                If undo& Then _FreeImage undo&
                undo& = _CopyImage(0)
            End If
            For sz = .25 To 2 Step .25
                Line (mousex, mousey)-(lastx + sz, lasty + sz), clr~&
                Line (mousex + sz, mousey + sz)-(lastx + sz, lasty + sz), clr~&
                Line (mousex + sz, mousey)-(lastx + sz, lasty), clr~&
                Line (mousex, mousey + sz)-(lastx, lasty + sz), clr~&
            Next sz
            button = 0
            lastx = mousex: lasty = mousey
            _PutImage , s&, picture&
        End If
    End If
    If a2$ = "e" Then
        a% = 0
        a2$ = ""
        mo = 2
    End If
    If mo = 2 Then
        If mouseLeftButton Then
            If button = 1 Then
                lastx = mousex
                lasty = mousey
                If undo& Then _FreeImage undo&
                undo& = _CopyImage(0)
            End If
            For sz = .25 To 2 Step .25
                Line (mousex, mousey)-(lastx + sz, lasty + sz), back&
                Line (mousex + sz, mousey + sz)-(lastx + sz, lasty + sz), back&
                Line (mousex + sz, mousey)-(lastx + sz, lasty), back&
                Line (mousex, mousey + sz)-(lastx, lasty + sz), back&
            Next sz
            button = 0
            _PutImage , s&, picture&
        End If
    End If
    'Here is the Ray Lines code.
    If a2$ = "r" Then
        a2$ = ""
        mo = 3
        lastx = mousex: lasty = mousey
        If mouseLeftButton = 0 Then
            If undo& Then _FreeImage undo&
            undo& = _CopyImage(0)
        End If
    End If
    If mo = 3 Then
        If mouseLeftButton Then
            If mm = 3 Then
                _Delay .05
                If undo& Then _FreeImage undo&
                undo& = _CopyImage(0)
            End If
            If mm = 0 Then lastx = mousex: lasty = mousey
            For sz = .25 To 2 Step .25
                Line (lastx, lasty)-(mousex, mousey), clr~&
                Line (lastx + sz, lasty)-(mousex + sz, mousey), clr~&
                Line (lastx, lasty + sz)-(mousex, mousey + sz), clr~&
                Line (lastx, lasty + sz)-(mousex + sz, mousey), clr~&
            Next sz
            mm = 3
            _Display
        End If
        If mouseLeftButton = 0 And mm = 3 Then
            _Delay .2
            For sz = .25 To 2 Step .25
                Line (lastx, lasty)-(mousex, mousey), clr~&
                Line (lastx + sz, lasty)-(mousex + sz, mousey), clr~&
                Line (lastx, lasty + sz)-(mousex, mousey + sz), clr~&
                Line (lastx, lasty + sz)-(mousex + sz, mousey), clr~&
            Next sz
            _Delay .2
            lastx = mousex: lasty = mousey
            mm = 0
            _PutImage , s&, picture&
            _AutoDisplay
        End If
    End If
    'Here is the Orbit Circles code.
    If a2$ = "o" Then
        a2$ = ""
        mo = 4
        If mouseLeftButton = 0 Then
            If undo& Then _FreeImage undo&
            undo& = _CopyImage(0)
        End If
    End If
    If mo = 4 Then
        If mouseLeftButton Then
            If mm = 4 Then _Delay .05
            If undo& Then
                _FreeImage undo&
                undo& = _CopyImage(0)
            End If
            If mm = 0 Then lastx = mousex: lasty = mousey
            If mousex < lastx Then size = lastx - mousex
            If mousex > lastx Then size = mousex - lastx
            If mousey < lasty Then size2 = lasty - mousey
            If mousey > lasty Then size2 = mousey - lasty
            one:
            seconds = seconds + .01
            s = (60 - seconds) * 6 + size
            xx = Int(Sin(s / 180 * 3.141592) * size) + lastx
            yy = Int(Cos(s / 180 * 3.141592) * size2) + lasty
            Circle (xx, yy), 1, clr~&
            If seconds > 60 Then
                seconds = 0
                GoTo two:
            End If
            GoTo one:
            two:
            mm = 4
            _Display
        End If
        If mouseLeftButton = 0 And mm = 4 Then
            _Delay .2
            three:
            seconds = seconds + .01
            s = (60 - seconds) * 6 + size
            xx = Int(Sin(s / 180 * 3.141592) * size) + lastx
            yy = Int(Cos(s / 180 * 3.141592) * size2) + lasty
            Circle (xx, yy), 1, clr~&
            If seconds > 60 Then
                seconds = 0
                GoTo four:
            End If
            GoTo three:
            four:
            _Delay .2
            lastx = mousex: lasty = mousey
            mm = 0
            size = 0: size2 = 0
            _PutImage , s&, picture&
            _AutoDisplay
        End If
    End If
    'Here is the Boxes code.
    If a2$ = "b" Then
        a2$ = ""
        a% = 0
        mo = 5
        lastx = mousex: lasty = mousey
        If mouseLeftButton = 0 Then
            _Delay .2
            If undo& Then _FreeImage undo&
            undo& = _CopyImage(0)
        End If
    End If
    If mo = 5 Then
        If mouseLeftButton Then
            If mm = 5 Then
                _Delay .05
                If undo& Then _FreeImage undo&
                undo& = _CopyImage(0)
            End If
            If mm = 0 Then lastx = mousex: lasty = mousey
            For sz = .25 To 2 Step .25
                Line (lastx - sz, lasty - sz)-(mousex + sz, mousey + sz), clr~&, B
            Next sz
            mm = 5
            _Display
        End If
        If mouseLeftButton = 0 And mm = 5 Then
            _Delay .2
            For sz = .25 To 2 Step .25
                Line (lastx - sz, lasty - sz)-(mousex + sz, mousey + sz), clr~&, B
            Next sz
            _Delay .2
            lastx = mousex: lasty = mousey
            mm = 0
            _PutImage , s&, picture&
            _AutoDisplay
        End If
    End If
    If a2$ = "t" Then
        a2$ = ""
        mo = 7
        If copy& Then _FreeImage copy&
        copy& = _CopyImage(0)
        Cls
        _Title "Select a text color here."
        textcolorchart& = _LoadImage("colorwheelpage2.png")
        Screen textcolorchart&
        mouseLeftButton = 0
        colorwheel2:
        Do While _MouseInput
            mousex = _MouseX
            mousey = _MouseY
            mouseLeftButton = _MouseButton(1)
        Loop
        If mouseLeftButton = -1 Then
            textcolor& = Point(mousex, mousey)
            mouseLeftButton = 0
            mousex = 0: mousey = 0
            GoTo textcol:
        End If
        GoTo colorwheel2:
        textcol:
        Cls
        s& = copy&
        _PutImage , s&, picture&
        Screen s&, picture&
        copy& = _CopyImage(0)
        _Delay .25
        undo& = _CopyImage(0)
        _Title "Type your text and press Enter."
        Locate 5, 1
        inputting:
        Color _RGB32(0, 0, 0), _RGB32(255, 255, 255)
        Input "Text: ", text$
        _Title "Type your text size and press Enter."
        Input "Size (12-72):", sz
        If sz < 12 Or sz > 72 Or sz <> Int(sz) Then Print "Try again.": sz = 0: GoTo inputting:
        Input "3D Text (Y/N)"; d3$
        If Left$(d3$, 1) = "y" Or Left$(d3$, 1) = "Y" Then bigtext = 1
        font$ = "Arial.ttf"
        rootpath$ = Environ$("SYSTEMROOT") 'normally "C:\WINDOWS"
        fontfile$ = rootpath$ + "\Fonts\" + font$ 'TTF file in Windows
        f& = _LoadFont(fontfile$, sz)
        Cls
        s& = copy&
        Screen s&, picture&
        _Title "Left click the area for your text to be at."
        Do
            mouseWheel = 0
            Do While _MouseInput
                mousex = _MouseX
                mousey = _MouseY
                mouseLeftButton = _MouseButton(1)
                mouseRightButton = _MouseButton(2)
                mouseMiddleButton = _MouseButton(3)
                mouseWheel = mouseWheel + _MouseWheel
            Loop
            If mouseLeftButton = -1 Then
                For big = bigtext To 0 Step -1
                    _PrintMode _KeepBackground
                    Color textcolor&
                    _Font f&
                    _PrintString (mousex + bt, mousey + bty), text$
                    textcolor& = textcolor& + 100
                    bt = 2
                    bty = 1
                Next big
                btl = 0
                bty = 0
                bt = 0
                bigtext = 0
                mouseLeftButton = 0
                _PutImage , s&, picture&
                Screen s&, picture&
                GoTo textdone:
            End If
        Loop
        textdone:
        _Delay .5
        bigtext = 0
        copy& = 0
        mo = 1
        text$ = ""
        sz = 0
        If f& > 0 Then
            _Font 16 'change used font to the QB64 8x16 default font
            _FreeFont f&
        End If
        _Title "Right Click Mouse To See Menu."
    End If
    'Here is Fill-In
    If a2$ = "f" Then
        a2$ = ""
        mo = 6
    End If
    If mo = 6 Then
        If mouseLeftButton Then
            If undo& Then _FreeImage undo&
            undo& = _CopyImage(0)
        End If
        _Delay .2
        If mouseLeftButton Then paint3 mousex, mousey, clr~&
        _PutImage , s&, picture&
    End If
    If a2$ = "u" Then
        a2$ = ""
        Screen undo&
        s& = undo&
        _PutImage , s&, picture&
        mouseLeftButton = 0
        undo& = _CopyImage(0)
    End If
    'Here is the Printing of the picture.
    If a2$ = "p" Then
        a2$ = ""
        mo = 0
        If bcol <> 1 Then
            j& = _CopyImage(0)
            _Delay .25
            Input "Print on printer (Y/N)?", i$ 'print screen page on printer
            Cls
            Screen j&
            _Delay .25
            If Left$(i$, 1) = "y" Or Left$(i$, 1) = "Y" Then
                'printer prep (code copied and pasted from bplus Free Calendar Program)
                YMAX = _Height: XMAX = _Width
                landscape& = _NewImage(YMAX, XMAX, 32)
                _MapTriangle (XMAX, 0)-(0, 0)-(0, YMAX), 0 To(0, 0)-(0, XMAX)-(YMAX, XMAX), landscape&
                _MapTriangle (XMAX, 0)-(XMAX, YMAX)-(0, YMAX), 0 To(0, 0)-(YMAX, 0)-(YMAX, XMAX), landscape&
                _PrintImage landscape&
                _Delay 2
                _FreeImage landscape&
                s& = j&
                _FreeImage j&
            End If
        End If
    End If
Loop

'Saving Section
saving:
nm$ = _SaveFileDialog$("Save File", "", "*.jpg|*.png|*.gif|*.bmp", "Picture Files .jpg,.png,.gif,.bmp")
If nm$ = "" Then GoTo skipsave:
_SaveImage nm$, picture&
_Delay .5
nm$ = ""
skipsave:
mo = 1
a% = 0
a2$ = ""
mouseLeftButton = 0
button = 1
lastx = 0
lasty = 0
Return

'Loading Section
loading:
nm$ = _OpenFileDialog$("Open Image", "", "*.jpg|*.png|*.gif|*.bmp", "Image Files .jpg,.png,.gif,.bmp", -1)
If nm$ = "" Then GoTo skipopen:
Cls
l = 0
i& = _LoadImage(nm$, 32)
Screen i&
s& = i&
screenx = _Width
screeny = _Height
picture& = _NewImage(screenx, screeny, 32)
_PutImage , s&, picture&
Screen s&, picture&
back& = _RGB32(255, 255, 255)
nm$ = ""
skipopen:
mo = 1
a% = 0
a2$ = ""
mouseLeftButton = 0
button = 1
lastx = 0
lasty = 0
Return


Function colorDialog$

    'first screen dimensions items to restore at exit
    Dim curRow As Integer, curCol As Integer, autoDisplay As Integer
    Dim sw As Integer, sh As Integer, fg As _Unsigned Long, bg As _Unsigned Long
    Dim curScrn As Long, backScrn As Long 'some handles

    Dim cd As Long
    Dim r As Integer, g As Integer, b As Integer, a As Integer, mb As Integer, mx As Integer, my As Integer, i As Integer
    Dim makeConst$, k$
    Dim f As Single

    'save old settings to restore at end ofsub
    curRow = CsrLin
    curCol = Pos(0)
    autoDisplay = _AutoDisplay
    sw = _Width
    sh = _Height
    fg = _DefaultColor
    bg = _BackgroundColor
    _KeyClear
    'screen snapshot
    curScrn = _Dest
    backScrn = _NewImage(sw, sh, 32)
    _PutImage , curScrn, backScrn

    cd = _NewImage(800, 600, 32)
    Screen cd
    r = 128: g = 128: b = 128: a = 128
    Color &HFFDDDDDD, 0
    Do
        Cls
        makeConst$ = "&H" + Right$(String$(8, "0") + Hex$(_RGBA32(r, g, b, a)), 8)
        slider 16, 10, r, "Red"
        slider 16, 60, g, "Green"
        slider 16, 110, b, "Blue"
        slider 16, 160, a, "Alpha"
        _PrintString (150, 260), "Press Enter or Spacebar, if you want to use the color: " + makeConst$
        _PrintString (210, 280), "Press Escape or Q to not use any color, returns 0."
        Line (90, 300)-(710, 590), , B
        For i = 100 To 700
            f = 255 * (i - 100) / 600
            Line (i, 310)-Step(0, 30), _RGB32(f, 0, 0): Line (i, 310)-Step(0, 20), Val(makeConst$)
            Line (i, 340)-Step(0, 30), _RGB32(0, f, 0): Line (i, 340)-Step(0, 20), Val(makeConst$)
            Line (i, 370)-Step(0, 30), _RGB32(0, 0, f): Line (i, 370)-Step(0, 20), Val(makeConst$)
            Line (i, 400)-Step(0, 30), _RGB32(f, f, 0): Line (i, 400)-Step(0, 20), Val(makeConst$)
            Line (i, 430)-Step(0, 30), _RGB32(0, f, f): Line (i, 430)-Step(0, 20), Val(makeConst$)
            Line (i, 460)-Step(0, 30), _RGB32(f, 0, f): Line (i, 460)-Step(0, 20), Val(makeConst$)
            Line (i, 490)-Step(0, 30), _RGB32(f, f, f): Line (i, 490)-Step(0, 20), Val(makeConst$)
            Line (i, 520)-Step(0, 30), _RGB32(0, 0, 0): Line (i, 520)-Step(0, 20), Val(makeConst$)
            Line (i, 550)-Step(0, 30), _RGB32(255, 255, 255): Line (i, 550)-Step(0, 20), Val(makeConst$)
        Next
        While _MouseInput: Wend
        mb = _MouseButton(1)
        If mb Then 'clear it
            mx = _MouseX: my = _MouseY
            If mx >= 16 And mx <= 781 Then
                If my >= 10 And my <= 50 Then
                    r = Int((mx - 16) / 3)
                ElseIf my >= 60 And my <= 100 Then
                    g = Int((mx - 16) / 3)
                ElseIf my >= 110 And my <= 150 Then
                    b = Int((mx - 16) / 3)
                ElseIf my >= 160 And my <= 200 Then
                    a = Int((mx - 16) / 3)
                End If
            End If
        End If
        k$ = InKey$
        If Len(k$) Then
            If Asc(k$) = 27 Or k$ = "q" Then Exit Do
            If Asc(k$) = 13 Or k$ = " " Then colorDialog$ = makeConst$: Exit Do
        End If
        _Display
        _Limit 60
    Loop

    'put things back
    Screen curScrn
    Color _RGB32(255, 255, 255), _RGB32(0, 0, 0): Cls
    _PutImage , backScrn
    _Display
    Color fg, bg
    _FreeImage backScrn
    _FreeImage cd
    If autoDisplay Then _AutoDisplay
    'clear key presses
    _KeyClear
    'clear mouse clicks
    While _MouseInput: Wend
    mb = _MouseButton(1)
    If mb Then 'clear it
        While mb 'OK!
            If _MouseInput Then mb = _MouseButton(1)
            _Limit 10
        Wend
    End If
    Locate curRow, curCol

End Function

Sub slider (x, y, value, label$)
    Dim c~&, s$
    Select Case label$
        Case "Red": c~& = &HFFFF0000
        Case "Green": c~& = &HFF008800
        Case "Blue": c~& = &HFF0000FF
        Case "Alpha": c~& = &H88FFFFFF
    End Select
    Line (x, y)-Step(765, 40), c~&, B
    Line (x, y)-Step(3 * value, 40), c~&, BF
    s2$ = Str$(value)
    s3$ = LTrim$(RTrim$(s2$))
    s$ = label$ + " = " + s3$
    _PrintString (x + 384 - 4 * Len(s$), y + 12), s$
End Sub

Sub paint3 (x0, y0, fill As _Unsigned Long) ' needs max, min functions
    Dim fillColor As _Unsigned Long, W, H, parentF, tick, ystart, ystop, xstart, xstop, x, y
    fillColor = Point(x0, y0)
    'PRINT fillColor
    W = _Width - 1: H = _Height - 1
    Dim temp(W, H)
    temp(x0, y0) = 1: parentF = 1
    PSet (x0, y0), fill
    While parentF = 1
        parentF = 0: tick = tick + 1
        ystart = max(y0 - tick, 0): ystop = min(y0 + tick, H)
        y = ystart
        While y <= ystop
            xstart = max(x0 - tick, 0): xstop = min(x0 + tick, W)
            x = xstart
            While x <= xstop
                If Point(x, y) = fillColor And temp(x, y) = 0 Then
                    If temp(max(0, x - 1), y) Then
                        temp(x, y) = 1: parentF = 1: PSet (x, y), fill
                    ElseIf temp(min(x + 1, W), y) Then
                        temp(x, y) = 1: parentF = 1: PSet (x, y), fill
                    ElseIf temp(x, max(y - 1, 0)) Then
                        temp(x, y) = 1: parentF = 1: PSet (x, y), fill
                    ElseIf temp(x, min(y + 1, H)) Then
                        temp(x, y) = 1: parentF = 1: PSet (x, y), fill
                    End If
                End If
                x = x + 1
            Wend
            y = y + 1
        Wend
    Wend
End Sub


Function min (n1, n2)
    If n1 > n2 Then min = n2 Else min = n1
End Function

Function max (n1, n2)
    If n1 < n2 Then max = n2 Else max = n1
End Function

'================================================================================
'================================================================================
'================================================================================
Function RightClickMenu% ()

    'Returns 0 if nothing selected, else return number of item selected.
    'Requires RightClickList$ array defined.

    Cheese = _MouseInput

    If _MouseButton(2) Then

        Row = Fix(_MouseY / 16): Col = Fix(_MouseX / 8)

        x = Col * 8 - 8: y = Row * 16 - 16

        '=== Compute BoxWidth based on longest menu item string length
        BoxWidth = 0
        For t = 1 To RightClickItems
            temp = Len(RightClickList$(t))
            If Left$(RightClickList$(t), 1) = "-" Then temp = temp - 1
            If temp > BoxWidth Then BoxWidth = temp
        Next: BoxWidth = BoxWidth * 8

        '=== Compute BoxHeight based on num of menu items
        BoxHeight = RightClickItems * 16

        '===== Make sure Mouse not too close to edge of screen
        '===== If it is, Adjust x & y position here, move in closer...
        If _MouseX < 20 Then
            Col = 3: x = Col * 8 - 8:
        End If
        If _MouseX + BoxWidth + 20 > _Width Then
            xm = _Width - (BoxWidth + 10)
            Col = Fix(xm / 8): x = Col * 8 - 8:
        End If
        If _MouseY < 20 Then
            Row = 2: y = Row * 16 - 16
        End If
        If _MouseY + BoxHeight + 20 > _Height Then
            xy = _Height - (BoxHeight + 10)
            Row = Fix(xy / 16): y = Row * 16 - 16
        End If

        FirstRow = Row - 1

        '=== copy screen using _mem (thanks Steve!)
        Dim m As _MEM, n As _MEM
        m = _MemImage(0)
        n = _MemNew(m.SIZE)
        _MemCopy m, m.OFFSET, m.SIZE To n, n.OFFSET

        '=== trap until buttons up
        Do
            nibble = _MouseInput
        Loop Until Not _MouseButton(2)

        '=== Draw Box (10 pix padding)
        Line (x - 10, y - 10)-(x + 10 + BoxWidth, y + 10 + BoxHeight), _RGB(214, 211, 206), BF
        Line (x + 10 + BoxWidth, y - 10)-(x + 10 + BoxWidth, y + 10 + BoxHeight), _RGB(66, 65, 66), B
        Line (x - 10, y + 10 + BoxHeight)-(x + 10 + BoxWidth, y + 10 + BoxHeight), _RGB(66, 65, 66), B
        Line (x - 9, y - 9)-(x + 9 + BoxWidth, y + 9 + BoxHeight), _RGB(255, 255, 255), B
        Line (x - 9, y - 9)-(x + 9 + BoxWidth, y + 9 + BoxHeight), _RGB(255, 255, 255), B
        Line (x + 9 + BoxWidth, y - 9)-(x + 9 + BoxWidth, y + 9 + BoxHeight), _RGB(127, 127, 127), B
        Line (x - 9, y + 9 + BoxHeight)-(x + 9 + BoxWidth, y + 9 + BoxHeight), _RGB(127, 127, 127), B

        Do
            Cheese = _MouseInput

            '=== if in bounds of menu space
            If _MouseX > x And _MouseX < x + BoxWidth And _MouseY > y And _MouseY < y + BoxHeight Then

                '=== Draw items
                If CurRow <> Fix(_MouseY / 16) Then
                    Color _RGB(0, 0, 0), _RGB(214, 211, 206)
                    For t = 0 To RightClickItems - 1
                        If Row + t - FirstRow = Fix(_MouseY / 16) - FirstRow + 1 Then
                            'Draw highlight box...
                            Color _RGB(255, 255, 255), _RGB(8, 36, 107)
                        Else
                            If Left$(RightClickList$(t + 1), 1) = "-" Then
                                Color _RGB(130, 130, 130), _RGB(214, 211, 206)
                            Else
                                Color _RGB(0, 0, 0), _RGB(214, 211, 206)
                            End If
                        End If
                        padme = BoxWidth / 8 - Len(RightClickList$(t + 1))
                        If Left$(RightClickList$(t + 1), 1) = "-" Then padme = padme - 1
                        If padme > 0 Then pad$ = Space$(padme) Else pad$ = ""
                        Locate Row + t, Col - 1
                        If RightClickList$(t + 1) = "---" Then
                            Color _RGB(127, 127, 127), _RGB(214, 211, 206)
                            Print String$((BoxWidth / 8) + 2, 196);
                        Else
                            If Left$(RightClickList$(t + 1), 1) = "-" Then
                                Print " "; Right$(RightClickList$(t + 1), Len(RightClickList$(t + 1)) - 1); pad$; " ";
                            Else
                                Print " "; RightClickList$(t + 1); pad$; " ";
                            End If
                        End If
                    Next
                End If

                If _MouseButton(1) Then
                    sel = Fix(_MouseY / 16) - FirstRow + 1
                    'only select if not a seperator and not disabled
                    If RightClickList$(sel) <> "---" Then
                        If Left$(RightClickList$(sel), 1) <> "-" Then
                            RightClickMenu% = sel: Exit Do
                        End If
                    End If
                End If

                If _MouseButton(2) Then Exit Do

            Else

                '=== Draw items
                If Fix(_MouseY / 16) <> CurRow Then
                    For t = 0 To RightClickItems - 1
                        padme = BoxWidth / 8 - Len(RightClickList$(t + 1))
                        If Left$(RightClickList$(t + 1), 1) = "-" Then padme = padme - 1
                        If padme > 0 Then pad$ = Space$(padme) Else pad$ = ""
                        Locate Row + t, Col - 1
                        If RightClickList$(t + 1) = "---" Then
                            Color _RGB(127, 127, 127), _RGB(214, 211, 206)
                            Print String$((BoxWidth / 8) + 2, 196);
                        Else

                            If Left$(RightClickList$(t + 1), 1) = "-" Then
                                Color _RGB(127, 127, 127), _RGB(214, 211, 206)
                                Print " "; Right$(RightClickList$(t + 1), Len(RightClickList$(t + 1)) - 1); pad$; " ";
                            Else
                                Color _RGB(0, 0, 0), _RGB(214, 211, 206)
                                Print " "; RightClickList$(t + 1); pad$; " ";
                            End If

                        End If
                    Next
                End If

                If _MouseButton(1) Or _MouseButton(2) Then Exit Do

            End If

            '=== Mark current row mouse is in
            CurRow = Fix(_MouseY / 16)

        Loop

        '### Make sure both buttons are up before leaving
        '### Added by Dav for bug testing...
        Do
            nibble = _MouseInput
            If _MouseButton(1) = 0 And _MouseButton(2) = 0 Then Exit Do
        Loop

        '=== restore screen
        _MemCopy n, n.OFFSET, n.SIZE To m, m.OFFSET
        _MemFree m: _MemFree n

    End If

End Function
'================================================================================
'================================================================================
'================================================================================



