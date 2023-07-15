'a relatively simple gui example by James D. Jarvis
'QB64 PE 3.4 or later needed to compile
'text screen mode 0 program that uses the mouse button to track gui input
'the scheme in this program allows for up to 255 buttons to be used in a program
'
'a mouse is used to click on button and menu selections that are shown in a text screen
'the position of buttons that are active is recorded in a button image
'$dynamic
Dim Shared ts&
Dim Shared bt&
Dim Shared forek, backk
ts& = _NewImage(80, 25, 0) 'the main text screen  for the program
Screen ts&
bt& = _NewImage(_Width + 1, _Height + 1, 256) 'the button tracking image needed for the gui
Type button_type
    txt As String 'the button label
    style As String 'what type of button to use : TEXTONLY,BTEXT,MENU,LBAR,CBAR,BBOX1,BBOX2
    bxx As Integer 'button x coordinate
    byy As Integer 'button y coordinate
    bwid As Integer 'button width in pixels. button height is determined by style and text size
    tklr As Integer 'text color
    bklr As Integer 'background color
    fklr As Integer 'foreground color
    state As String 'is button on or off
    container As String 'doesn't do anything in the demo but I like to plan ahead
End Type
Dim Shared btn(0) As button_type
Dim tempb As button_type
Dim Shared button_count
button_count = 0
Print "Building GUI";
forek = 15: backk = 0
menu_on = 0
'creating buttosn for the demo code
tempb.bxx = 3: tempb.byy = 3: tempb.bwid = 8: tempb.style = "TEXTONLY"
tempb.txt = "Button 1": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "ON": tempb.container = ""
addbutton tempb
tempb.bxx = 3: tempb.byy = 5: tempb.bwid = 8: tempb.style = "BTEXT"
tempb.txt = "Button 2": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "ON": tempb.container = ""
addbutton tempb
tempb.bxx = 3: tempb.byy = 7: tempb.bwid = 12: tempb.style = "BBOX2"
tempb.txt = "Button 3": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "ON": tempb.container = ""
addbutton tempb
tempb.bxx = 3: tempb.byy = 15: tempb.bwid = 52: tempb.style = "BBOX1"
tempb.txt = "QUIT": tempb.tklr = 0: tempb.bklr = 12: tempb.fklr = 15
tempb.state = "ON": tempb.container = ""
addbutton tempb
'creating the menus for the demo code.
'note: menu selections are just buttons that are only active when the menu is selected
tempb.bxx = 1: tempb.byy = 1: tempb.bwid = 8: tempb.style = "MENU"
tempb.txt = "MENU": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "ON": tempb.container = ""
addbutton tempb
tempb.bxx = 1: tempb.byy = 2: tempb.bwid = 8: tempb.style = "LBAR"
tempb.txt = "Select1": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "OFF": tempb.container = ""
addbutton tempb
tempb.bxx = 1: tempb.byy = 3: tempb.bwid = 8: tempb.style = "LBAR"
tempb.txt = "Select2": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "OFF": tempb.container = ""
addbutton tempb
tempb.bxx = 1: tempb.byy = 4: tempb.bwid = 8: tempb.style = "LBAR"
tempb.txt = "--------": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "OFF": tempb.container = ""
addbutton tempb
tempb.bxx = 1: tempb.byy = 5: tempb.bwid = 8: tempb.style = "LBAR"
tempb.txt = "QUIT": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "OFF": tempb.container = ""
addbutton tempb

tempb.bxx = 9: tempb.byy = 1: tempb.bwid = 8: tempb.style = "MENU"
tempb.txt = "MENU2": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "ON": tempb.container = ""
addbutton tempb
tempb.bxx = 9: tempb.byy = 2: tempb.bwid = 8: tempb.style = "LBAR"
tempb.txt = "Hello": tempb.tklr = 15: tempb.bklr = 7: tempb.fklr = 15
tempb.state = "OFF": tempb.container = ""
addbutton tempb
tempb.bxx = 9: tempb.byy = 3: tempb.bwid = 8: tempb.style = "LBAR"
tempb.txt = "Name?": tempb.tklr = 15: tempb.bklr = 5: tempb.fklr = 15
tempb.state = "OFF": tempb.container = ""
addbutton tempb
Dim Shared username$
username$ = ""


Cls
draw_allbuttons 'have to draw them if you want the user to see them
Locate 3, 16: Print "Will Show Button 3 if it is hiding"
Locate 5, 16: Print "Changes Text Color of this button"
Locate 8, 16: Print "Will hide itself"
Do ' main program loop
    _Limit 1000

    bkk = 0

    Do While _MouseInput
        pbx = _MouseX
        pby = _MouseY
        If _MouseButton(1) Then
            _Source bt& 'checking the button tracking image
            bkk = Point(pbx, pby) 'get the button clicked if there is one at those coordinates
            _Source ts&
            'uncomment following lines if you wish to see the demo echoing the button click
            ' If bkk > 0 Then
            ' Locate 1, 1: Print "Clicked "; bkk
            ' Else
            '     Locate 1, 1: Print "                 "
            ' End If
        End If
    Loop

    Select Case bkk 'a handler for each button
        Case 1
            Beep
            flash_button 1
            If btn(3).state = "HIDE" Then show_button 3
            draw_button 1
        Case 2
            flash_button 2
            btn(2).tklr = Int(Rnd * 32)
            draw_button 2
        Case 3
            flash_button 3
            hide_button 3
        Case 4
            flash_button 4
            draw_button 4
            Exit Do
        Case 5 'menu1
            menu1 mchoice$
            Locate 12, 16
            If mchoice$ <> "" Then Print "Selected "; mchoice$
            If mchoice$ = "QUIT" Then Exit Do
        Case 6 'this is a menu selection and tracked in the sub menu1
        Case 7 'this is a menu selection and tracked in the sub menu1
        Case 8 'this is a menu selection and tracked in the sub menu1
        Case 9 'this is a menu selection and tracked in the sub menu1
        Case 10 'menu2
            mchoice$ = ""
            menu2 mchoice$
            If mchoice$ = "hello" Then
                If username$ = "" Then
                    _MessageBox "Hello", "Hello stranger.", "info"
                Else
                    un$ = "HELLO THERE " + username$ + "!"
                    _MessageBox "HELLO", un$, "info"
                End If
            End If
            If mchoice$ = "name?" Then
                username$ = _InputBox$("Name?", "Enter your name:", "anonymous")
            End If
        Case 11 'this is a menu selection and tracked in the sub menu2
        Case 12 'this is a menu selection and tracked in the sub menu2

    End Select
Loop Until InKey$ = Chr$(27)
_FreeImage bt&
System

'=========================================================================
' button routines for gui
'=========================================================================

Sub menu1 (mchoice$)
    'menu handling has to be hardcoded as is, this needs to change.
    show_button 6
    show_button 7
    show_button 8
    show_button 9
    menu_on = 1
    mchoice$ = ""
    Do 'menu takes over mouse handling only recognizing clicks in the menu or pressing the escape key
        _Limit 60
        Do While _MouseInput
            pbx = _MouseX
            pby = _MouseY
            If _MouseButton(1) Then
                _Source bt& 'checking the button tracking image
                bkk = Point(pbx, pby) 'get the button clicked if there is one at those coordinates
                _Source ts&
            End If
        Loop
        Select Case bkk 'a handler for each button
            Case 6
                flash_button 6
                mchoice$ = "m1a"
                menu_on = 0
            Case 7
                flash_button 7
                mchoice$ = "m1b"
                menu_on = 0
                'case 8
                'there is no entry for button 8. it's just a line separator
            Case 9
                flash_button 9
                mchoice$ = "QUIT"
                menu_on = 0
        End Select
        mk$ = InKey$
    Loop Until menu_on = 0 Or mk$ = Chr$(27)
    'hide all the menu entries
    hide_button 6
    hide_button 7
    hide_button 8
    hide_button 9
    'draw all the buttons now that the menu entries are hidden
    draw_allbuttons
End Sub
Sub menu2 (mchoice$)
    'menu handling has to be hardcoded as is
    show_button 11
    show_button 12
    menu_on = 1
    mchoice$ = ""
    Do 'menu takes over mouse handling only recognizing clicks in the menu or pressing the escape key
        _Limit 60
        Do While _MouseInput
            pbx = _MouseX
            pby = _MouseY
            If _MouseButton(1) Then
                _Source bt& 'checking the button tracking image
                bkk = Point(pbx, pby) 'get the button clicked if there is one at those coordinates
                _Source ts&
            End If
        Loop
        Select Case bkk 'a handler for each button
            Case 11
                flash_button 11
                mchoice$ = "hello"
                menu_on = 0
            Case 12
                flash_button 7
                mchoice$ = "name?"
                menu_on = 0
        End Select
        mk$ = InKey$
    Loop Until menu_on = 0 Or mk$ = Chr$(27)
    'hide the menu entries
    hide_button 11
    hide_button 12
    'draw all the buttons now that the menu entries are hidden
    draw_allbuttons
End Sub
Sub addbutton (newbtn As button_type)
    If button_count < 255 Then
        button_count = button_count + 1
        ReDim _Preserve btn(button_count) As button_type
        Swap btn(button_count), newbtn
        Select Case btn(button_count).style
            Case "TEXTONLY", "BTEXT"
                'correct bwid to be equal to text length for these styles
                btn(button_count).bwid = Len(btn(button_count).txt)
        End Select
    End If
End Sub

Sub draw_button (bnum)
    'draw alll the buttons on the mainscreen and on the button tracking image
    If bnum < 1 Or bnum > button_count GoTo enddrawb
    ds& = _Dest
    If btn(bnum).state = "ON" Then
        _Dest bt&
        Select Case btn(bnum).style
            Case "TEXTONLY"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), bnum, BF
                _Dest ds&
                Color btn(bnum).tklr, backk
                _PrintString (btn(bnum).bxx, btn(bnum).byy), btn(bnum).txt
                Color forek
            Case "BTEXT", "MENU"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), bnum, BF
                _Dest ds&
                Color btn(bnum).tklr, btn(bnum).bklr
                _PrintString (btn(bnum).bxx, btn(bnum).byy), btn(bnum).txt
                Color forek, backk
            Case "LBAR"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), bnum, BF
                _Dest ds&
                Color btn(bnum).tklr, btn(bnum).bklr
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, " ")
                _PrintString (btn(bnum).bxx, btn(bnum).byy), btn(bnum).txt
                Color forek, backk
            Case "CBAR"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), bnum, BF
                _Dest ds&
                Color btn(bnum).tklr, btn(bnum).bklr
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, " ")
                tpx = btn(bnum).bxx + (Int(btn(bnum).bwid / 2) - Int(Len(btn(bnum).txt) / 2))
                _PrintString (tpx, btn(bnum).byy), btn(bnum).txt
                Color forek, backk
            Case "BBOX1"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 2), bnum, BF
                _Dest ds&
                Color btn(bnum).fklr, btn(bnum).bklr
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, Chr$(196))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 1), String$(btn(bnum).bwid, " ")
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 2), String$(btn(bnum).bwid, Chr$(196))
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(1, Chr$(218))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 1), String$(1, Chr$(179))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 2), String$(1, Chr$(192))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), String$(1, Chr$(191))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 1), String$(1, Chr$(179))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 2), String$(1, Chr$(217))
                Color btn(bnum).tklr, btn(bnum).bklr
                tpx = btn(bnum).bxx + (Int(btn(bnum).bwid / 2) - Int(Len(btn(bnum).txt) / 2))
                _PrintString (tpx, btn(bnum).byy + 1), btn(bnum).txt
                Color forek, backk
            Case "BBOX2"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 2), bnum, BF
                _Dest ds&
                Color btn(bnum).fklr, btn(bnum).bklr
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, Chr$(205))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 1), String$(btn(bnum).bwid, " ")
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 2), String$(btn(bnum).bwid, Chr$(205))
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(1, Chr$(201))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 1), String$(1, Chr$(186))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 2), String$(1, Chr$(200))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), String$(1, Chr$(187))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 1), String$(1, Chr$(186))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 2), String$(1, Chr$(188))
                Color btn(bnum).tklr, btn(bnum).bklr
                tpx = btn(bnum).bxx + (Int(btn(bnum).bwid / 2) - Int(Len(btn(bnum).txt) / 2))
                _PrintString (tpx, btn(bnum).byy + 1), btn(bnum).txt
                Color forek, backk
        End Select
    End If
    enddrawb:
End Sub

Sub hide_button (bnum)
    'blacks out a button on the mainscreen and the button tracking image
    If bnum < 1 Or bnum > button_count Then GoTo endhide
    ds& = _Dest
    If btn(bnum).state = "ON" Then
        btn(bnum).state = "HIDE"
        _Dest bt&
        Select Case btn(bnum).style
            Case "TEXTONLY"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), 0, BF
                _Dest ds&
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(Len(btn(bnum).txt), " ")
            Case "BTEXT", "MENU"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), 0, BF
                _Dest ds&
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(Len(btn(bnum).txt), " ")
                Color forek, backk
            Case "LBAR"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), 0, BF
                _Dest ds&
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, " ")

            Case "CBAR"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), 0, BF
                _Dest ds&
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, " ")
            Case "BBOX1", "BBOX2"
                Line (btn(bnum).bxx, btn(bnum).byy)-(btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 2), 0, BF
                _Dest ds&
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, " ")
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 1), String$(btn(bnum).bwid, " ")
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 2), String$(btn(bnum).bwid, " ")
        End Select
    End If
    endhide:
End Sub

Sub show_button (bnum)
    'chnage a buttons state and draw it on the main screen and button tracking image
    If bnum > 0 And bnum <= button_count Then
        btn(bnum).state = "ON"
        draw_button bnum
    End If
End Sub
Sub draw_allbuttons
    'draw all the buttons
    For b = 1 To button_count
        draw_button b
    Next b
End Sub

Sub flash_button (bnum)
    'have the button flash to show it has been selected
    If bnum < 1 Or bnum > button_count GoTo endflashb
    If btn(bnum).state = "ON" Then
        Select Case btn(bnum).style
            Case "TEXTONLY"
                Color backk, btn(bnum).tklr \ 2
                _PrintString (btn(bnum).bxx, btn(bnum).byy), btn(bnum).txt
                _Delay 0.3
                Color forek
            Case "BTEXT", "MENU"
                Color backk, btn(bnum).tklr \ 2
                _PrintString (btn(bnum).bxx, btn(bnum).byy), btn(bnum).txt
                _Delay 0.3
                Color forek, backk
            Case "LBAR"
                Color backk, btn(bnum).tklr, btn(bnum).bklr
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, " ")
                _PrintString (btn(bnum).bxx, btn(bnum).byy), btn(bnum).txt
                _Delay 0.3
                Color forek, backk
            Case "CBAR"
                Color backk, btn(bnum).tklr \ 2
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, " ")
                tpx = btn(bnum).bxx + (Int(btn(bnum).bwid / 2) - Int(Len(btn(bnum).txt) / 2))
                _PrintString (tpx, btn(bnum).byy), btn(bnum).txt
                _Delay 0.3
                Color forek, backk
            Case "BBOX1"
                Color backk, btn(bnum).fklr \ 2
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, Chr$(196))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 1), String$(btn(bnum).bwid, " ")
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 2), String$(btn(bnum).bwid, Chr$(196))
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(1, Chr$(218))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 1), String$(1, Chr$(179))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 2), String$(1, Chr$(192))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), String$(1, Chr$(191))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 1), String$(1, Chr$(179))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 2), String$(1, Chr$(217))
                Color backk, btn(bnum).tklr
                tpx = btn(bnum).bxx + (Int(btn(bnum).bwid / 2) - Int(Len(btn(bnum).txt) / 2))
                _PrintString (tpx, btn(bnum).byy + 1), btn(bnum).txt
                _Delay 0.3
                Color forek, backk
            Case "BBOX2"
                Color backk, btn(bnum).fklr \ 2
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(btn(bnum).bwid, Chr$(205))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 1), String$(btn(bnum).bwid, " ")
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 2), String$(btn(bnum).bwid, Chr$(205))
                _PrintString (btn(bnum).bxx, btn(bnum).byy), String$(1, Chr$(201))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 1), String$(1, Chr$(186))
                _PrintString (btn(bnum).bxx, btn(bnum).byy + 2), String$(1, Chr$(200))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy), String$(1, Chr$(187))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 1), String$(1, Chr$(186))
                _PrintString (btn(bnum).bxx + btn(bnum).bwid - 1, btn(bnum).byy + 2), String$(1, Chr$(188))
                Color backk, btn(bnum).tklr
                tpx = btn(bnum).bxx + (Int(btn(bnum).bwid / 2) - Int(Len(btn(bnum).txt) / 2))
                _PrintString (tpx, btn(bnum).byy + 1), btn(bnum).txt
                _Delay 0.3
                Color forek, backk
        End Select
    End If
    endflashb:
End Sub