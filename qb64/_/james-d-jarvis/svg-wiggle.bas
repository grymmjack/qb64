'wiggleblocks
'
'just some doodling with internal SVGs
'for QB64PE 3.9.0 and later
Screen _NewImage(300, 300, 32)
_Title "WiggleBlocks <q> to quit"
Dim As Long simg
Dim x(3, 4), y(3, 4)
Randomize Timer
For n = 1 To 4
    x(1, n) = Int(1 + Rnd * 80): x(2, n) = Int(1 + Rnd * 80): x(3, n) = Int(1 + Rnd * 80)
    y(1, n) = Int(1 + Rnd * 80): y(2, n) = Int(1 + Rnd * 80): y(3, n) = Int(1 + Rnd * 80)
Next
angle = 0
kb$ = "#" + Hex$(100 + Rnd * 40) + Hex$(140 + Rnd * 40) + Hex$(80 + Rnd * 40)
Do
    Cls
    s$ = svgsquare$(1, x(), y(), "#CCBBDD")
    simg = _LoadImage(s$, 32, "memory")
    _PutImage (0, 0), simg
    _PutImage (200, 0), simg
    _FreeImage simg
    wigglexy x(), y()
    s$ = svgsquare$(2, x(), y(), "#ACABDD")
    simg = _LoadImage(s$, 32, "memory")
    _PutImage (100, 0), simg
    _PutImage (100, 200), simg
    _FreeImage simg
    wigglexy x(), y()
    If Int(1 + Rnd * 10) < 3 Then kb$ = "#" + Hex$(100 + Rnd * 40) + Hex$(140 + Rnd * 40) + Hex$(80 + Rnd * 40)
    s$ = svgsquare$(3, x(), y(), kb$)
    simg = _LoadImage(s$, 32, "memory")
    _PutImage (0, 100), simg
    _PutImage (200, 100), simg
    _PutImage (0, 200), simg
    _FreeImage simg
    wigglexy x(), y()
    k$ = "#" + Hex$(100 + Rnd * 40) + Hex$(140 + Rnd * 40) + Hex$(80 + Rnd * 40)
    s$ = svgsquare$(4, x(), y(), k$)
    simg = _LoadImage(s$, 32, "memory")
    _PutImage (100, 100), simg
    _PutImage (200, 200), simg
    _Display
    _Delay 0.04
    _FreeImage simg
Loop Until InKey$ = "q"
System
 
 
Sub wigglexy (x(), y())
    'wiggle the little rectangles
    For n = 1 To 4
        For r = 1 To 3
            x(r, n) = x(r, n) + Int(Rnd * 4) - Int(Rnd * 4)
            y(r, n) = y(r, n) + Int(Rnd * 4) - Int(Rnd * 4)
            If x(r, n) < 1 Then x(r, n) = Int(1 + Rnd * 80)
            If y(r, n) < 1 Then y(r, n) = Int(1 + Rnd * 80)
            If x(r, n) > 90 Then x(r, n) = Int(1 + Rnd * 80)
            If y(r, n) > 90 Then y(r, n) = Int(1 + Rnd * 80)
        Next
    Next n
End Sub
 
Function svgsquare$ (n, x(), y(), f$)
    'define one of the svgsquares
    xa$ = _Trim$(Str$(x(1, n)))
    xb$ = _Trim$(Str$(x(2, n)))
    xc$ = _Trim$(Str$(x(3, n)))
    ya$ = _Trim$(Str$(y(1, n)))
    yb$ = _Trim$(Str$(y(2, n)))
    yc$ = _Trim$(Str$(y(3, n)))
    'build a string to create an SVG image
    s$ = "<svg width='100' height='100' x='0' y='0' >"
    s$ = s$ + "<rect x='5' y='5' width='90' height='90' rx='10' ry='10' fill='" + f$ + "' />"
    s$ = s$ + "<rect x='+" + xa$ + "' y='+" + ya$ + "' width='20' height='20'rx='5' ry='5' fill='red'  /><rect x='+" + xb$ + "' y='+" + yb$ + "' width='20' height='20' rx='3' ry='3' fill='yellow' />"
    s$ = s$ + "<rect x='" + xc$ + "' y='+" + yc$ + "' width='20' height='20'rx='8' ry='8' fill='green'  />"
    s$ = s$ + "</svg>"
    svgsquare$ = s$
End Function