Option _Explicit
_Title "Wheel of Fortune Cookies" ' b+ started 2020-12-26
' 2020-12-29 Puzzle limited to 3 words or less 11 letters or less each word
' category added to puzzle and readjusted screen to fit in the label.
' 12-31 5 secs to explain lose turn

Randomize Timer
Const Xmax = 1240, Ymax = 640, ORad = 299, IRad = 100, CA = _Pi(2 / 24), Cad2 = CA / 2
Const Vowels = "AEIOU", Letters = "BCDFGHJKLMNPQRSTVWXYZ"
Type player
    Index As Long
    Name As String
    Spin As String
    Current As Long
    Game As Long
    FreePlay As Long
End Type

ReDim Shared Wheel&, WheelSpin$(0), P(0 To 2) As player, Category$, Puzzle$, Hidden$, LettersAvail$, VowelsAvail$, Turn As Long

Screen _NewImage(Xmax, Ymax, 32)
_Delay .25
_ScreenMove _Middle

'local main module variables  lower case 1st letter
ReDim s$, i As Long, highSpin As Long, savePlayer, tie ' who plays first?
ReDim mx As Long, my As Long, mb As Long, ok As Long, ln As Long, guess$
ReDim mx1 As Long, my1 As Long, mb1 As Long, letter As Long, amt As Long ' just for picking letters
ReDim time!

DIM SHARED AS LONG FV72, F20, F40
'                                                      getting started
FV72& = _LoadFont("OpenSans-ExtraBold.ttf", 72) ' used for letters and digits in makeWheel
F20&  = _LoadFont("OpenSans-ExtraBold.ttf", 20) ' Host says and small letter and vowel picks in puzzle
F40&  = _LoadFont("OpenSans-ExtraBold.ttf", 40) ' large letters in puzzle

'    debug
'GetPuzzle
'PRINT Category$, Puzzle$
'PRINT Hidden$
'END

'ShowLetters
'ShowVowels
'ShowPuzzleBoard

' oh we have to initialize UDT's
For i = 0 To 2
    P(i).Index = 0
    P(i).Name = ""
    P(i).Spin = ""
    P(i).Current = 0
    P(i).Game = 0
    P(i).FreePlay = 0
Next
MakeWheel
RotoZoom2 0, Xmax - 19 - 299, 19 + 299, Wheel&, 1, 1, -22 * CA
Line (Xmax - 19 - 299 - 3, 19 + 299 - 315)-Step(6, 20), &HFFFFFFFF, BF
Line (Xmax - 19 - 299 - 3, 19 + 299 - 315)-Step(6, 20), &HFF000000, B
Color &HFFFFFFFF

highSpin = 0: tie = -1
For i = 0 To 2
    P(i).Index = i
    HostSays "Hello player " + _Trim$(Str$(i + 1)) + ", please enter your name:"
    Color &HFFFFFFFF
    Locate 6, 5: Input ""; P(i).Name
    P(i).Spin = SpinWheel$(P(i).Name)
    While P(i).Spin = "FREE PLAY":
        P(i).Spin = SpinWheel$(P(i).Name)
        UpdatePlayer i, -1
    Wend
    UpdatePlayer i, 0
    If Val(P(i).Spin) > highSpin Then
        savePlayer = i: highSpin = Val(P(i).Spin): tie = 0
    ElseIf Val(P(i).Spin) = highSpin Then
        tie = -1
    End If
Next
'tie = -1 'debug test
Line (0, 0)-Step(600, 110), &HFF000000, BF
While tie
    tie = -1: highSpin = 0: savePlayer = -1
    For i = 0 To 2
        UpdatePlayer i, -1
        P(i).Spin = SpinWheel$(P(i).Name)
        While P(i).Spin = "FREE PLAY"
            P(i).Spin = SpinWheel$(P(i).Name)
            UpdatePlayer i, -1
        Wend
        UpdatePlayer i, 0
        If Val(P(i).Spin) > highSpin Then
            savePlayer = i: highSpin = Val(P(i).Spin): tie = 0
        ElseIf Val(P(i).Spin) = highSpin Then
            tie = -1
        End If
    Next
Wend
Turn = savePlayer 'from the spinoff above, from here on the players play in sequence

NewPuzzle
Do ' play a round
    playAgain: ' may restart same player
    s$ = P(Turn).Name + ", click: The Wheel or Solve"
    If VowelsAvail$ <> "     " And P(Turn).Current >= 250 Then s$ = s$ + " or Vowel (to buy)"
    HostSays s$
    UpdatePlayer Turn, -1
    ShowLetters
    ShowVowels
    ShowPuzzleBoard
    _PrintString (50, 80), "Solve"

    ok = 0
    Do ' wait for click a spot input from player
        While _MouseInput: Wend
        mb = _MouseButton(1)
        If mb Then 'where did the click occur
            mx = _MouseX: my = _MouseY
            _Delay .25 'wait
            If mx > 50 And mx < 90 And my > 80 And my < 96 Then 'wants to solve
                s$ = P(Turn).Name + ", type in your guess and press enter."
                HostSays s$
                Locate 6, 5: Input ""; guess$
                If UCase$(guess$) = Puzzle$ Then 'we have a winner!
                    'move the winner's current into game
                    If P(Turn).Current < 1000 Then 'player must win at least 1000
                        P(Turn).Game = P(Turn).Game + 1000
                    Else
                        P(Turn).Game = P(Turn).Game + P(Turn).Current
                    End If
                    Hidden$ = Puzzle$ 'reveal
                    ShowPuzzleBoard
                    s$ = P(Turn).Name + ", Congratulations you solved the puzzle!"
                    HostSays s$
                    _Delay 3

                    NewPuzzle
                    ok = -1 'and we are onto checking if next player has lost turn


                Else
                    Beep: ok = -1 ' move to next player
                    s$ = P(Turn).Name + ", sorry, that's not it."
                    HostSays s$
                    _Delay 3
                End If

            ElseIf mx > Xmax - 640 Then ' wants to spin
                P(Turn).Spin = SpinWheel$(P(Turn).Name)
                UpdatePlayer Turn, -1
                If P(Turn).Spin = "FREE PLAY" Or Len(P(Turn).Spin) < 5 Then ' money or token
                    If P(Turn).Spin = "FREE PLAY" Then P(Turn).FreePlay = P(Turn).FreePlay + 1
                    'now pick a letter
                    s$ = P(Turn).Name + ", and now click a letter not guessed yet."
                    HostSays s$ ' too slow
                    _Font F20&
                    _PrintString (300 - _PrintWidth(s$) / 2, 40), s$
                    _Font 16
                    letter = 0
                    Do
                        While _MouseInput: Wend
                        mb1 = _MouseButton(1)
                        If mb1 Then 'where did the click occur
                            mx1 = _MouseX: my1 = _MouseY
                            _Delay .25 'make sure click is done
                            If mx1 > 25 And mx1 < 550 And my1 > Ymax - 50 And my1 < Ymax Then 'we're in the letters
                                ln = Int((mx1 - 25) / 25) + 1
                                If InStr(LettersAvail$, Mid$(Letters, ln, 1)) > 0 Then
                                    Mid$(LettersAvail$, ln, 1) = " " 'remove from avail
                                    amt = Find&(Mid$(Letters, ln, 1))
                                    If amt Then ' player may go again but has 10 secs to solve
                                        P(Turn).Current = P(Turn).Current + amt * Val(P(Turn).Spin)
                                        GoTo playAgain
                                    Else
                                        Beep: letter = -1: ok = -1 'escape from loop
                                    End If ' find letter or not
                                Else
                                    Beep: letter = -1: ok = -1 'you lose turn for clicking a letter already used
                                End If ' letter is avail
                            End If ' in letter area
                        End If 'mb to click a letter
                    Loop Until letter = -1

                ElseIf P(Turn).Spin = "BANKRUPT" Then
                    P(Turn).Current = 0: ok = -1: _Delay 2
                ElseIf P(Turn).Spin = "LOSE TURN" Then
                    s$ = P(Turn).Name + ", sorry you lose next turn unless have FREE PLAY."
                    HostSays s$
                    _Delay 5
                    ok = -1
                End If

            ElseIf mx > 25 And mx < 150 And my > Ymax - 100 And my < Ymax - 60 Then 'buying a vowel
                'which vowel clicked is it available?
                ln = Int((mx - 25) / 25) + 1
                If InStr(VowelsAvail$, Mid$(Vowels, ln, 1)) > 0 Then 'vowel not already taken
                    If P(Turn).Current >= 250 Then ' player has the cash
                        P(Turn).Current = P(Turn).Current - 250

                        'take vowel off
                        Mid$(VowelsAvail$, ln, 1) = " "

                        'OK now see if vowel in clue
                        If Find&(Mid$(Vowels, ln, 1)) Then ' player may go again but has 10 secs to solve
                            GoTo playAgain
                        Else
                            Beep: ok = -1 'escape from loop
                        End If
                    Else
                        Beep: ok = -1 'don't have money to buy loose your turn
                    End If
                Else
                    Beep: ok = -1 ' vowel taken  lose turn  when click a vowel already played
                End If

            End If 'mx, my are in active zones

        End If ' a click has occurred
        _Limit 60
    Loop Until ok ' no escape but click and follow instructions

    'ok the player's turn is up and before we move onto next player
    'let's offer a Play Free Play button if the player has one before moving to next player
    ' this is best under a Timer
    If P(Turn).FreePlay Then

        s$ = P(Turn).Name + ", Click me in 5 secs to play a Free Play."
        HostSays s$
        time! = Timer(.01)
        Do
            While _MouseInput: Wend
            mb1 = _MouseButton(1)
            If mb1 Then 'where did the click occur
                mx1 = _MouseX: my1 = _MouseY
                _Delay .25
                If mx1 > 0 And mx1 < 600 Then
                    If my1 > 0 And my1 < 110 Then
                        P(Turn).FreePlay = P(Turn).FreePlay - 1
                        s$ = P(Turn).Name + ", using a FREE PLAY."
                        HostSays s$
                        GoTo playAgain
                    End If
                End If
            End If
        Loop Until Timer(.01) - time! > 5
    End If

    UpdatePlayer Turn, 0
    updateTurn:
    Turn = (Turn + 1) Mod 3
    If P(Turn).Spin = "LOSE TURN" Then 'check next player up for LOSE TURN status
        P(Turn).Spin = "PAID TURN" ' because we are skipping now
        UpdatePlayer Turn, 0
        If P(Turn).FreePlay > 0 Then
            P(Turn).FreePlay = P(Turn).FreePlay - 1
            s$ = P(Turn).Name + ", using a FREE PLAY."
            HostSays s$
            _Delay 2
        Else
            GoTo updateTurn ' skip this player it actually happened that 2 players in row Lose Turn!!!
        End If
    End If ' checking for LOSE TURN of next player
Loop

Sub NewPuzzle
    Dim i
    Cls
    RotoZoom2 0, Xmax - 19 - 299, 19 + 299, Wheel&, 1, 1, -22 * CA
    'clear players round
    For i = 0 To 2
        'P(i).Spin = ""  LOSE TURN carries over to next game
        P(i).Current = 0
        'P(i).FreePlay = 0  carries over to next game
        UpdatePlayer i, (Turn = i)
    Next 'reset some player data
    GetPuzzle 'reset Puzzle$, Hidden$ , letters and vowels Avail$
    ShowPuzzleBoard
    ShowVowels
    ShowLetters
End Sub

Sub HostSays (s$)
    Line (0, 0)-Step(600, 110), &HFF000000, BF
    _Font F20&
    Color &HFFDDDDFF
    _PrintString (300 - _PrintWidth(s$) / 2, 40), s$
    _Font 16
End Sub

Function Find& (L$) ' not used letter in puzzle and change hidden$ and report how many found
    ReDim i As Long, b$, rtn&
    b$ = ""
    For i = 1 To Len(Puzzle$)
        If Mid$(Puzzle$, i, 1) = L$ Then b$ = b$ + L$: rtn& = rtn& + 1 Else b$ = b$ + Mid$(Hidden$, i, 1)
    Next
    Hidden$ = b$
    Find& = rtn&
End Function

Sub ShowPuzzleBoard
    ReDim words$(1 To 1), i As Long, j As Long
    Split Hidden$, " ", words$()


    '            DEBUG
    'PRINT LBOUND(words$), UBOUND(words$)
    'FOR i = LBOUND(words$) TO UBOUND(words$)
    '    PRINT words$(i)
    'NEXT
    'SLEEP

    Line (0, Ymax - 430)-Step(600, 180), &HFF000000, BF
    Color &HFFEEEEEE
    _PrintString (50, 210), "Category: " + Category$
    For i = 1 To UBound(words$)
        For j = 1 To Len(words$(i))
            ShowLetterBox j * 50, 140 + i * 100, Mid$(words$(i), j, 1), -1
        Next
    Next
End Sub

Sub ShowVowels
    ReDim i
    Line (0, Ymax - 100)-Step(600, 50), &HFF000000, BF
    For i = 1 To Len(VowelsAvail$)
        ShowLetterBox i * 25, Ymax - 100, Mid$(VowelsAvail$, i, 1), 0
    Next
    _PrintString (160, Ymax - 100 + 12), "Vowels for sale @ $250"
End Sub

Sub ShowLetters
    ReDim i
    Line (0, Ymax - 50)-Step(600, 50), &HFF000000, BF
    For i = 1 To Len(LettersAvail$)
        ShowLetterBox i * 25, Ymax - 50, Mid$(LettersAvail$, i, 1), 0
    Next
End Sub

Sub ShowLetterBox (x, y, L$, dbl)
    ReDim w As Long, h As Long
    Color &HFF000000, &HFFFFFFFF
    If dbl Then w = 41: h = 80: _Font F40& Else w = 20: h = 40: _Font F20&
    If L$ = "*" Then
        Line (x, y)-Step(w, h), &HFF00AA33, BF
    ElseIf L$ <> " " And L$ <> "*" Then
        Line (x, y)-Step(w, h), &HFFFFFFFF, BF
        If dbl Then
            _PrintString (x + 21 - _PrintWidth(L$) / 2, y + 40 - _FontHeight(F40&) / 2), L$
        Else
            _PrintString (x + 11 - _PrintWidth(L$) / 2, y + 20 - _FontHeight(F20&) / 2), L$
        End If
    End If
    _Font 16
    Color &HFFFFFFFF, &HFF000000
End Sub

Sub GetPuzzle 'set the shared variable Puzzle$ and hide the letters
    ReDim last As Long, i As Long, fline$, save1$
    Puzzle$ = ""
    If _FileExists("Fortune Puzzles with Categories.txt") Then
        If _FileExists("Last Fortune Puzzle.txt") Then
            Open "Last Fortune Puzzle.txt" For Input As #1
            Input #1, last
            Close #1
            Open "Last Fortune Puzzle.txt" For Output As #1
            Print #1, last + 1
            Close #1
        Else
            last = 1
            Open "Last Fortune Puzzle.txt" For Output As #1
            Print #1, last
            Close #1
        End If
        Open "Fortune Puzzles with Categories.txt" For Input As #1
        While Not EOF(1)
            Line Input #1, fline$
            i = i + 1
            If i = last Then
                Category$ = UCase$(LeftOf$(fline$, "=")): Puzzle$ = UCase$(RightOf$(fline$, "="))
                Close #1: Exit While
                If i = 1 Then save1$ = fline$
            End If
        Wend
        If Puzzle$ = "" Then ' use the first entry we saved
            Category$ = UCase$(LeftOf$(save1$, "=")): Puzzle$ = UCase$(RightOf$(save1$, "="))
            Close #1
            Open "Last Fortune Puzzle.txt" For Output As #1
            Print #1, "2"
            Close #1
        End If
    Else 'something! temporary

        Print " Warning: Fortune Puzzles with Categories.txt file not found, better fix problem."
        Puzzle$ = "LOAD FORTUNE COOKIES.TXT"
    End If
    Hidden$ = ""
    For i = 1 To Len(Puzzle$)
        If InStr(Letters, Mid$(Puzzle$, i, 1)) > 0 Or InStr(Vowels, Mid$(Puzzle$, i, 1)) > 0 Then
            Hidden$ = Hidden$ + "*"
        Else
            Hidden$ = Hidden$ + Mid$(Puzzle$, i, 1)
        End If
    Next
    LettersAvail$ = Letters: VowelsAvail$ = Vowels

    'debug
    '_TITLE Puzzle$
    'Hidden$ = Puzzle$
End Sub

Sub UpdatePlayer (p02, focus)
    Line (200 * p02, 110)-Step(199, 100), &HFF000000, BF
    If focus Then
        Color &HFFFFFFFF
    Else
        Select Case p02
            Case 0: Color &HFFFF0000
            Case 1: Color &HFFEEEE00
            Case 2: Color &HFF0000FF
        End Select
    End If
    _PrintString (200 * p02 + 50, 110), P(p02).Name
    _PrintString (200 * p02 + 50, 110 + 16), P(p02).Spin
    _PrintString (200 * p02 + 50, 110 + 32), "  Current: " + TS$(P(p02).Current)
    _PrintString (200 * p02 + 50, 110 + 48), " Winnings: " + TS$(P(p02).Game)
    _PrintString (200 * p02 + 50, 110 + 64), "Free Play: " + TS$(P(p02).FreePlay)
End Sub

Function SpinWheel$ (player$)
    ReDim yc, xc, a, stopAt As Long, l As Single
    Color &HFFFFFFFF: yc = 19 + 299: xc = Xmax - 19 - 299 ' practice spinning wheel
    stopAt = Int(Rnd * 24): l = (24 + stopAt) * 5
    For a = 0 To (24 + stopAt) * CA Step _Pi(2 / 120) ' give it a right quick start
        Fcirc xc, yc, IRad - 1, &HFF000000
        RotoZoom2 0, xc, yc, Wheel&, 1, 1, -a
        Line (xc - 3, yc - 315)-Step(6, 20), &HFFFFFFFF, BF
        Line (xc - 3, yc - 315)-Step(6, 20), &HFF000000, B
        _PrintString (xc - _PrintWidth(player$) / 2, yc - 16), player$
        _Display
        If l > 2 Then l = l - 1
        If l > 30 Then _Limit 30 Else _Limit l
    Next
    _PrintString (xc - _PrintWidth(player$) / 2, yc - 16), player$
    _PrintString (xc - _PrintWidth(WheelSpin$(stopAt)) / 2, yc), WheelSpin$(stopAt)
    _Display
    _Delay 1
    SpinWheel$ = WheelSpin$(stopAt)
    _AutoDisplay
End Function

Sub MakeWheel
    ReDim WheelSpin$(0 To 23), wC(23) As _Unsigned Long, x0, y0, midR, i As Long, s$, sc As _Unsigned Long
    ReDim ls, rr, rrd2, f, j As Long
    GoSub initWheel
    Wheel& = _NewImage(599, 599, 32)
    _Dest Wheel&
    _Source Wheel&
    x0 = 299: y0 = 299: midR = (ORad + IRad) / 2
    Color &HFF000000, &H00000000
    Circle (x0, y0), ORad
    Circle (x0, y0), IRad
    For i = 0 To 23 ' wedge border
        Line (x0 + IRad * Cos(i * CA - Cad2), y0 + IRad * Sin(i * CA - Cad2))-(x0 + ORad * Cos(i * CA - Cad2), y0 + ORad * Sin(i * CA - Cad2))
    Next
    For i = 0 To 23
        Paint (x0 + midR * Cos(i * CA), y0 + midR * Sin(i * CA)), wC((i + 6) Mod 24), &HFF000000
        s$ = WheelSpin$((i + 6) Mod 24)
        If s$ = "LOSE TURN" Then
            sc = &HFF000000
        ElseIf s$ = "BANKRUPT" Then
            sc = &HFFFFFFFF
        ElseIf s$ = "FREE PLAY" Then
            sc = &HFFFFFF00
        ElseIf Len(s$) = 4 Then
            sc = &HFF000000: s$ = "$" + s$
        Else 's$ = 3 char $ amt
            sc = &HFF000000: s$ = "$" + s$
        End If
        ls = Len(s$): rr = (ORad - IRad - 10) / ls: rrd2 = rr / 2 - 5: f = (rr / 90)
        For j = 1 To ls
            f = rr / (58 + 8 * j)
            ' drwstring(S$, c AS _UNSIGNED LONG, midX, midY, xScale, yScale, Rotation)
            DrwString Wheel&, Mid$(s$, j, 1), sc, x0 + (ORad - j * rr + rrd2) * Cos(i * CA), y0 + (ORad - j * rr + rrd2) * Sin(i * CA), f, f, i * CA + _Pi(1 / 2)
        Next
    Next
    _Dest 0
    _Source 0
    Exit Sub

    initWheel:
    WheelSpin$(0) = "LOSE TURN": wC(0) = &HFFFFFFFF
    WheelSpin$(1) = "2500": wC(1) = &HFFFF3310
    WheelSpin$(2) = "350": wC(2) = &HFFCC0099
    WheelSpin$(3) = "3500": wC(3) = &HFFFF6666
    WheelSpin$(4) = "700": wC(4) = &HFF00AA33
    WheelSpin$(5) = "1500": wC(5) = &HFFFF8800
    WheelSpin$(6) = "BANKRUPT": wC(6) = &HFF000000
    WheelSpin$(7) = "400": wC(7) = &HFFAA0066
    WheelSpin$(8) = "550": wC(8) = &HFF00AA00
    WheelSpin$(9) = "600": wC(9) = &HFFFFFF00
    WheelSpin$(10) = "450": wC(10) = &HFFCC1100
    WheelSpin$(11) = "950": wC(11) = &HFF0077AA
    WheelSpin$(12) = "650": wC(12) = &HFFEE6600
    WheelSpin$(13) = "900": wC(13) = &HFFAA0077
    WheelSpin$(14) = "750": wC(14) = &HFFFFFF00
    WheelSpin$(15) = "300": wC(15) = &HFFFF7777
    WheelSpin$(16) = "850": wC(16) = &HFFFF1100
    WheelSpin$(17) = "2000": wC(17) = &HFF0000FF
    WheelSpin$(18) = "500": wC(18) = &HFF009900
    WheelSpin$(19) = "3000": wC(19) = &HFFFF8888
    WheelSpin$(20) = "BANKRUPT": wC(20) = &HFF000000
    WheelSpin$(21) = "800": wC(21) = &HFF990088
    WheelSpin$(22) = "FREE PLAY": wC(22) = &HFF006600
    WheelSpin$(23) = "1000": wC(23) = &HFF0000FF
    Return
End Sub

'drwString needs sub RotoZoom2, intended for graphics screens using the default font.
'S$ is the string to display
'c is the color (will have a transparent background)
'midX and midY is the center of where you want to display the string
'xScale would multiply 8 pixel width of default font
'yScale would multiply the 16 pixel height of the default font
'Rotation is in Radian units, use _D2R to convert Degree units to Radian units
Sub DrwString (DH&, S$, C As _Unsigned Long, MidX, MidY, xScale, yScale, Rotation)
    ReDim storeFont&, storeDest&, tempI&
    storeFont& = _Font
    storeDest& = _Dest
    _Font FV72& ' loadfont at start and share handle
    tempI& = _NewImage(_PrintWidth(S$), _FontHeight(FV72&), 32)
    _Dest tempI&
    _Font FV72&
    Color C, _RGBA32(0, 0, 0, 0)
    _PrintString (0, 0), S$
    _Dest storeDest&
    RotoZoom2 DH&, MidX, MidY, tempI&, xScale, yScale, Rotation
    _FreeImage tempI&
    _Font storeFont&
End Sub

Sub RotoZoom2 (Dh&, X As Long, Y As Long, Image As Long, xScale As Single, yScale As Single, Rotation As Single)
    ReDim px(3) As Single, py(3) As Single, w&, h&, sinr!, cosr!, i&, x2&, y2&
    w& = _Width(Image&): h& = _Height(Image&)
    px(0) = -w& / 2: py(0) = -h& / 2: px(1) = -w& / 2: py(1) = h& / 2
    px(2) = w& / 2: py(2) = h& / 2: px(3) = w& / 2: py(3) = -h& / 2
    sinr! = Sin(-Rotation): cosr! = Cos(-Rotation)
    For i& = 0 To 3
        x2& = (px(i&) * cosr! + sinr! * py(i&)) * xScale + X: y2& = (py(i&) * cosr! - px(i&) * sinr!) * yScale + Y
        px(i&) = x2&: py(i&) = y2&
    Next
    _MapTriangle _Seamless(0, 0)-(0, h& - 1)-(w& - 1, h& - 1), Image& To(px(0), py(0))-(px(1), py(1))-(px(2), py(2)), Dh&, _Smooth
    _MapTriangle _Seamless(0, 0)-(w& - 1, 0)-(w& - 1, h& - 1), Image& To(px(0), py(0))-(px(3), py(3))-(px(2), py(2)), Dh&, _Smooth
End Sub

Function TS$ (n As Long)
    TS$ = _Trim$(Str$(n))
End Function

'from Steve Gold standard
Sub Fcirc (CX As Integer, CY As Integer, R As Integer, C As _Unsigned Long)
    Dim Radius As Integer, RadiusError As Integer
    Dim X As Integer, Y As Integer
    Radius = Abs(R): RadiusError = -Radius: X = Radius: Y = 0
    If Radius = 0 Then PSet (CX, CY), C: Exit Sub
    Line (CX - X, CY)-(CX + X, CY), C, BF
    While X > Y
        RadiusError = RadiusError + Y * 2 + 1
        If RadiusError >= 0 Then
            If X <> Y + 1 Then
                Line (CX - Y, CY - X)-(CX + Y, CY - X), C, BF
                Line (CX - Y, CY + X)-(CX + Y, CY + X), C, BF
            End If
            X = X - 1
            RadiusError = RadiusError - X * 2
        End If
        Y = Y + 1
        Line (CX - X, CY - Y)-(CX + X, CY - Y), C, BF
        Line (CX - X, CY + Y)-(CX + X, CY + Y), C, BF
    Wend
End Sub

'notes: REDIM the array(0) to be loaded before calling Split '<<<< IMPORTANT dynamic array and empty, can use any lbound though
'This SUB will take a given N delimited string, and delimiter$ and create an array of N+1 strings using the LBOUND of the given dynamic array to load.
'notes: the loadMeArray() needs to be dynamic string array and will not change the LBOUND of the array it is given.  rev 2019-08-27
Sub Split (SplitMeString As String, delim As String, loadMeArray() As String)
    Dim curpos As Long, arrpos As Long, LD As Long, dpos As Long 'fix use the Lbound the array already has
    curpos = 1: arrpos = LBound(loadMeArray): LD = Len(delim)
    dpos = InStr(curpos, SplitMeString, delim)
    Do Until dpos = 0
        loadMeArray(arrpos) = Mid$(SplitMeString, curpos, dpos - curpos)
        arrpos = arrpos + 1
        If arrpos > UBound(loadMeArray) Then ReDim _Preserve loadMeArray(LBound(loadMeArray) To UBound(loadMeArray) + 1000) As String
        curpos = dpos + LD
        dpos = InStr(curpos, SplitMeString, delim)
    Loop
    loadMeArray(arrpos) = Mid$(SplitMeString, curpos)
    ReDim _Preserve loadMeArray(LBound(loadMeArray) To arrpos) As String 'get the ubound correct
End Sub

Function LeftOf$ (source$, of$)
    If InStr(source$, of$) > 0 Then LeftOf$ = _Trim$(Mid$(source$, 1, InStr(source$, of$) - 1))
End Function

Function RightOf$ (source$, of$)
    If InStr(source$, of$) > 0 Then RightOf$ = _Trim$(Mid$(source$, InStr(source$, of$) + Len(of$)))
End Function

