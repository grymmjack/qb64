 
_Title "Font From String Patterns Strokes" ' b+ 2023-08-27
' Inspired by grymmjack post here https://qb64phoenix.com/forum/showthread...0#pid18990
' I used his font patterns to get my version started
 
' 2023-08-29 fixed with -1's in steps
 
' 2023-08-29 Now with numbered strokes for drawing
' and grymmjack's fix for character design
 
 
Screen _NewImage(800, 600, 32)
_ScreenMove 200, 60
Dim spattern$(0 To 255)
Dim pattern5$(0 To 255)
LoadPatterns9x9 spattern$()
LoadPatterns5x5 pattern5$()
FPrint "TESTING", spattern$(), 323, 50, 2, 3, &HFF0000FF
FPrint "STARFIGHTER", spattern$(), 218, 180, 3, 3, &HFFFF0000
FPrint "STARFISHING", spattern$(), 70, 300, 5, 3, &HFFFFFF00
FPrint "BPLUS", spattern$(), 376, 550, 1, 2, &HFF008800
FPrint "b+", pattern5$(), 435, 547, 1, 1, &HFFFFFFFF
Sleep
 
 
Sub FPrint (s$, PA$(), x%, y%, scale%, spacing%, colr~&)
    ' s$ is string to "print" out
    ' PA$() is the array of string holding the font THE SQUARE pattern (must be NxN pattern)
    ' x, y top, left corner of print just like _PrintString
    ' scale is multiplier of pixeled font at NxN so now is Scale * N x Scale * N
    ' spacing is amount of pixels * scale between letters
    ' color~& type allows up to _RGB32() colors
    Dim As Integer ls, a, sq, r, c, i, digi
    Dim d$
    ls = Len(s$)
    For l = 1 To ls
        a = Asc(s$, l)
        If Len(PA$(a)) Then ' do we have a pattern
            sq = Sqr(Len(PA$(a)))
            'Print Chr$(a), sq  'debug
            For digi = 1 To 9
                d$ = _Trim$(Str$(digi))
                For r = 0 To sq - 1 ' row and col of letter block
                    For c = 0 To sq - 1
                        i = r * sq + c + 1
                        If Mid$(PA$(a), i, 1) = d$ Then
                            Line (x% + ((l - 1) * (sq + spacing%) + c) * scale%, y% + r * scale%)-Step(scale% - 1, scale% - 1), colr~&, BF
                            _Delay .04
                        End If
                    Next
                Next
            Next
        End If
    Next
End Sub
 
 
Sub LoadPatterns9x9 (SPattern() As String)
    Dim As Integer a
    a = Asc("S")
    SPattern(a) = SPattern(a) + "..111111."
    SPattern(a) = SPattern(a) + ".2......."
    SPattern(a) = SPattern(a) + ".2......."
    SPattern(a) = SPattern(a) + "..3......"
    SPattern(a) = SPattern(a) + "...333..."
    SPattern(a) = SPattern(a) + "......4.."
    SPattern(a) = SPattern(a) + ".......4."
    SPattern(a) = SPattern(a) + ".......4."
    SPattern(a) = SPattern(a) + "5555555.."
    a = Asc("T")
    SPattern(a) = SPattern(a) + "111111111"
    SPattern(a) = SPattern(a) + "....2...."
    SPattern(a) = SPattern(a) + "....2...."
    SPattern(a) = SPattern(a) + "....2...."
    SPattern(a) = SPattern(a) + "....2...."
    SPattern(a) = SPattern(a) + "....2...."
    SPattern(a) = SPattern(a) + "....2...."
    SPattern(a) = SPattern(a) + "....2...."
    SPattern(a) = SPattern(a) + "....2...."
    a = Asc("A")
    SPattern(a) = SPattern(a) + "...122..."
    SPattern(a) = SPattern(a) + "..1...2.."
    SPattern(a) = SPattern(a) + "..1...2.."
    SPattern(a) = SPattern(a) + ".1.....2."
    SPattern(a) = SPattern(a) + ".1333332."
    SPattern(a) = SPattern(a) + ".1.....2."
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1.......2"
    a = Asc("F")
    SPattern(a) = SPattern(a) + "122222222"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1333333.."
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    a = Asc("I")
    SPattern(a) = SPattern(a) + ".2222222."
    SPattern(a) = SPattern(a) + "....1...."
    SPattern(a) = SPattern(a) + "....1...."
    SPattern(a) = SPattern(a) + "....1...."
    SPattern(a) = SPattern(a) + "....1...."
    SPattern(a) = SPattern(a) + "....1...."
    SPattern(a) = SPattern(a) + "....1...."
    SPattern(a) = SPattern(a) + "....1...."
    SPattern(a) = SPattern(a) + ".3333333."
    a = Asc("G")
    SPattern(a) = SPattern(a) + ".11111111"
    SPattern(a) = SPattern(a) + "2........"
    SPattern(a) = SPattern(a) + "2........"
    SPattern(a) = SPattern(a) + "2........"
    SPattern(a) = SPattern(a) + "2....4444"
    SPattern(a) = SPattern(a) + "2.......5"
    SPattern(a) = SPattern(a) + "2......35"
    SPattern(a) = SPattern(a) + "2.....3.5"
    SPattern(a) = SPattern(a) + ".33333..5"
    a = Asc("H")
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "133333332"
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1.......2"
    a = Asc("E")
    SPattern(a) = SPattern(a) + "111111111"
    SPattern(a) = SPattern(a) + "2........"
    SPattern(a) = SPattern(a) + "2........"
    SPattern(a) = SPattern(a) + "2........"
    SPattern(a) = SPattern(a) + "2444444.."
    SPattern(a) = SPattern(a) + "2........"
    SPattern(a) = SPattern(a) + "2........"
    SPattern(a) = SPattern(a) + "2........"
    SPattern(a) = SPattern(a) + "233333333"
    a = Asc("N")
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + "12......3"
    SPattern(a) = SPattern(a) + "1.2.....3"
    SPattern(a) = SPattern(a) + "1..2....3"
    SPattern(a) = SPattern(a) + "1...2...3"
    SPattern(a) = SPattern(a) + "1....2..3"
    SPattern(a) = SPattern(a) + "1.....2.3"
    SPattern(a) = SPattern(a) + "1......23"
    SPattern(a) = SPattern(a) + "1.......3"
    a = Asc("B")
    SPattern(a) = SPattern(a) + "1222222.."
    SPattern(a) = SPattern(a) + "1......3."
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + "1......3."
    SPattern(a) = SPattern(a) + "1333333.."
    SPattern(a) = SPattern(a) + "1......4."
    SPattern(a) = SPattern(a) + "1.......4"
    SPattern(a) = SPattern(a) + "1......4."
    SPattern(a) = SPattern(a) + "1444444.."
    a = Asc("L")
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "122222222"
    a = Asc("U")
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + "1.......3"
    SPattern(a) = SPattern(a) + ".2222222."
    a = Asc("P")
    SPattern(a) = SPattern(a) + "1222222.."
    SPattern(a) = SPattern(a) + "1......2."
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1......2."
    SPattern(a) = SPattern(a) + "1333332.."
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    SPattern(a) = SPattern(a) + "1........"
    a = Asc("R")
    SPattern(a) = SPattern(a) + "1222222.."
    SPattern(a) = SPattern(a) + "1......2."
    SPattern(a) = SPattern(a) + "1.......2"
    SPattern(a) = SPattern(a) + "1......2."
    SPattern(a) = SPattern(a) + "1333332.."
    SPattern(a) = SPattern(a) + "1.....4.."
    SPattern(a) = SPattern(a) + "1......4."
    SPattern(a) = SPattern(a) + "1.......4"
    SPattern(a) = SPattern(a) + "1.......4"
End Sub
 
Sub LoadPatterns5x5 (SPattern() As String)
    Dim As Integer a
    a = Asc("b")
    SPattern(a) = SPattern(a) + "1...."
    SPattern(a) = SPattern(a) + "1...."
    SPattern(a) = SPattern(a) + "1.22."
    SPattern(a) = SPattern(a) + "12..2"
    SPattern(a) = SPattern(a) + "1.22."
    a = Asc("+")
    SPattern(a) = SPattern(a) + "....."
    SPattern(a) = SPattern(a) + "..1.."
    SPattern(a) = SPattern(a) + ".212."
    SPattern(a) = SPattern(a) + "..1.."
    SPattern(a) = SPattern(a) + "....."
End Sub