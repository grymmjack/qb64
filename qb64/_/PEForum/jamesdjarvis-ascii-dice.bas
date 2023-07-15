'ASCII DICE DEMO
'by James D. Jarvis, 5/12/2023 , use as you wish
'
'demo of asciidie routine   rolls 3 dice 6 times and displays total of each roll of the 3 dice
Screen _NewImage(45, 36, 0)
_Title "ASCII DICE DEMO"
_Font 8 'using font 8 so dice faces show as true squares
_ControlChr Off
Randomize Timer
'-------- need these pre-defined for box subroutine
Dim Shared trc$, tlc$, brc$, blc$, hzb$, vrb$ 'strings to keep track of ascii values to display dice face
trc$ = Chr$(191) 'top right corner
tlc$ = Chr$(218) 'top left corner
brc$ = Chr$(217) 'botton right corner
blc$ = Chr$(192) 'bottom left corner
hzb$ = Chr$(196) 'horitzontal bar
vrb$ = Chr$(179) 'vertical bar
'----------------------------------------------------
Color 15, 0
Do 'demo rolling 3d6 6 times
    For r = 1 To 6
        d1 = rolld6(3, r * 6 - 5): d2 = rolld6(9, r * 6 - 5): d3 = rolld6(15, r * 6 - 5)
        _PrintString (21, r * 6 - 3), "Total Roll =        "
        _PrintString (36, r * 6 - 3), Str$(d1 + d2 + d3)
    Next r
    Beep
    kk$ = waitanykey$
Loop Until kk$ = Chr$(27)

Function waitanykey$ 'uses inkey$ but waits for a return value
    Do
        _Limit 60
        ik$ = InKey$
    Loop Until ik$ <> ""
    _KeyClear
    waitanykey$ = ik$
End Function

Function rolld6 (px, py)
    'simulate "rolling" a die by calling asciidie repeatedly
    dr = Int(1 + Rnd * 6)
    For x = 1 To 6
        _Limit 100
        dr = Int(1 + Rnd * 6)
        asciidie px, py, dr 'displays score dr as a die starting at px,py
    Next x
    rolld6 = dr
End Function

Sub asciidie (px, py, roll)
    'display die face of roll at location px,py
    box px, py, 5, 5, " " 'draws a box 5 characters by 5 charcters for display of dice face
    Select EveryCase roll
        Case 1, 3, 5
            _PrintString (px + 2, py + 2), Chr$(7)
        Case 2, 3, 4, 5, 6
            _PrintString (px + 1, py + 1), Chr$(7)
            _PrintString (px + 3, py + 3), Chr$(7)
        Case 4, 5, 6
            _PrintString (px + 3, py + 1), Chr$(7)
            _PrintString (px + 1, py + 3), Chr$(7)
        Case 6
            _PrintString (px + 1, py + 2), Chr$(7)
            _PrintString (px + 3, py + 2), Chr$(7)
    End Select
    Color 15, 0
End Sub
Sub box (bx, by, ww, hh, ff$)
    'draws a box, strings are defined in main program (so they can be changed prior to calling routine)
    t$ = tlc$ + String$(ww - 2, hzb$) + trc$
    m$ = vrb$ + String$(ww - 2, ff$) + vrb$
    b$ = blc$ + String$(ww - 2, hzb$) + brc$
    _PrintString (bx, by), t$
    For h = 1 To hh - 2
        _PrintString (bx, by + h), m$
    Next h
    _PrintString (bx, by + hh - 1), b$
End Sub