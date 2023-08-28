_Title "Font From String Patterns" ' b+ 2023-08-27
' Inspired by grymmjack post here https://qb64phoenix.com/forum/showthread...0#pid18990
' I used his font patterns to get my version started
 
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
    Dim As Integer ls, a, sq, r, c, i
    ls = Len(s$)
    For l = 1 To ls
        a = Asc(s$, l)
        If Len(PA$(a)) Then ' do we have a pattern
            sq = Sqr(Len(PA$(a)))
            'Print Chr$(a), sq  'debug
            For r = 0 To sq - 1 ' row and col of letter block
                For c = 0 To sq - 1
                    i = r * sq + c + 1
                    If Asc(PA$(a), i) <> Asc(".") Then
                        Line (x% + ((l - 1) * (sq + spacing%) + c) * scale%, y% + r * scale%)-Step(scale%, scale%), colr~&, BF
                    End If
                Next
            Next
        End If
    Next
End Sub
 
Sub LoadPatterns9x9 (SPattern() As String)
    Dim As Integer a
    a = Asc("S")
    SPattern(a) = "..XXXXXX."
    SPattern(a) = SPattern(a) + ".X......."
    SPattern(a) = SPattern(a) + ".X......."
    SPattern(a) = SPattern(a) + "..S......"
    SPattern(a) = SPattern(a) + "...SXS..."
    SPattern(a) = SPattern(a) + "......S.."
    SPattern(a) = SPattern(a) + ".......S."
    SPattern(a) = SPattern(a) + ".......S."
    SPattern(a) = SPattern(a) + "SXXXXXX.."
    a = Asc("T")
    SPattern(a) = "XXXXXXXXX"
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    a = Asc("A")
    SPattern(a) = "...aXA..."
    SPattern(a) = SPattern(a) + "..X...X.."
    SPattern(a) = SPattern(a) + "..X...X.."
    SPattern(a) = SPattern(a) + ".X.....X."
    SPattern(a) = SPattern(a) + ".XXXXXXX."
    SPattern(a) = SPattern(a) + ".X.....X."
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X.......X"
    a = Asc("F")
    SPattern(a) = "XXXXXXXXX"
    SPattern(a) = SPattern(a) + "F........"
    SPattern(a) = SPattern(a) + "F........"
    SPattern(a) = SPattern(a) + "F........"
    SPattern(a) = SPattern(a) + "FFFXXXX.."
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    a = Asc("I")
    SPattern(a) = ".XXXXXXX."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + "....X...."
    SPattern(a) = SPattern(a) + ".XXXXXXX."
    a = Asc("G")
    SPattern(a) = ".XXXXXXXX"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X....GGGX"
    SPattern(a) = SPattern(a) + "X.......G"
    SPattern(a) = SPattern(a) + "X......gG"
    SPattern(a) = SPattern(a) + "X.....G.X"
    SPattern(a) = SPattern(a) + ".XXXXX..G"
    a = Asc("H")
    SPattern(a) = "X.......X"
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "XXXXXXXXX"
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X.......X"
    a = Asc("E")
    SPattern(a) = "XXXXXXXXX"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "XXXXXXX.."
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "XXXXXXXXX"
    a = Asc("N")
    SPattern(a) = "X.......N"
    SPattern(a) = SPattern(a) + "XX......N"
    SPattern(a) = SPattern(a) + "X.X.....N"
    SPattern(a) = SPattern(a) + "N..X....N"
    SPattern(a) = SPattern(a) + "N...X...N"
    SPattern(a) = SPattern(a) + "N....X..N"
    SPattern(a) = SPattern(a) + "N.....X.N"
    SPattern(a) = SPattern(a) + "N......XN"
    SPattern(a) = SPattern(a) + "N.......N"
    a = Asc("B")
    SPattern(a) = "BBBBBBB.."
    SPattern(a) = SPattern(a) + "X......B."
    SPattern(a) = SPattern(a) + "X.......N"
    SPattern(a) = SPattern(a) + "N......N."
    SPattern(a) = SPattern(a) + "NBBBBBN.."
    SPattern(a) = SPattern(a) + "N......b."
    SPattern(a) = SPattern(a) + "N.......B"
    SPattern(a) = SPattern(a) + "N......X."
    SPattern(a) = SPattern(a) + "NBBBBBB.."
    a = Asc("L")
    SPattern(a) = "B........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "N........"
    SPattern(a) = SPattern(a) + "N........"
    SPattern(a) = SPattern(a) + "N........"
    SPattern(a) = SPattern(a) + "N........"
    SPattern(a) = SPattern(a) + "N........"
    SPattern(a) = SPattern(a) + "NBBBBBBLL"
    a = Asc("U")
    SPattern(a) = "B.......U"
    SPattern(a) = SPattern(a) + "X.......U"
    SPattern(a) = SPattern(a) + "X.......U"
    SPattern(a) = SPattern(a) + "N.......U"
    SPattern(a) = SPattern(a) + "N.......U"
    SPattern(a) = SPattern(a) + "N.......U"
    SPattern(a) = SPattern(a) + "N.......U"
    SPattern(a) = SPattern(a) + "N.......U"
    SPattern(a) = SPattern(a) + ".BBBBBBL."
    a = Asc("P")
    SPattern(a) = "XPPPPPP.."
    SPattern(a) = SPattern(a) + "X......X."
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X......P."
    SPattern(a) = SPattern(a) + "XXXXXX..."
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    SPattern(a) = SPattern(a) + "X........"
    a = Asc("R")
    SPattern(a) = "XPPPPPP.."
    SPattern(a) = SPattern(a) + "X......X."
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X......P."
    SPattern(a) = SPattern(a) + "XXXXXXR.."
    SPattern(a) = SPattern(a) + "X.....R.."
    SPattern(a) = SPattern(a) + "X......R."
    SPattern(a) = SPattern(a) + "X.......X"
    SPattern(a) = SPattern(a) + "X.......X"
End Sub
 
Sub LoadPatterns5x5 (SPattern() As String)
    Dim As Integer a
    a = Asc("b")
    SPattern(a) = "b...."
    SPattern(a) = SPattern(a) + "b...."
    SPattern(a) = SPattern(a) + "b.bb."
    SPattern(a) = SPattern(a) + "bb..b"
    SPattern(a) = SPattern(a) + "b.bb."
    a = Asc("+")
    SPattern(a) = "....."
    SPattern(a) = SPattern(a) + "..+.."
    SPattern(a) = SPattern(a) + ".+++."
    SPattern(a) = SPattern(a) + "..+.."
    SPattern(a) = SPattern(a) + "....."
End Sub