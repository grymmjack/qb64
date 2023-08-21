'draw_polyFT
' by James D.  Jarvis  , August 20,2023
'draw filled  polygons
'
'HEADER
Dim Shared xmax, ymax
xmax = 800: ymax = 500
Screen _NewImage(xmax, ymax, 32)
Dim Shared pk& 'must be included in a program that uses polyFT
pk& = _NewImage(3, 3, 32) 'must be included in a program that uses polyFT
 
'======================================
' demo
'======================================
' This demo draws 64000 random polygons, and then clears the screen and draws a handful of polygons  rotating
 
Randomize Timer
 
t1 = Timer
For reps = 1 To 64000
    polyFT Int(Rnd * xmax), Int(Rnd * ymax), Int(3 + Rnd * 20), Int(3 + Rnd * 12), Int(Rnd * 60), Int(1 + Rnd * 3), Int(1 + Rnd * 3), _RGB32(Int(Rnd * 256), Int(Rnd * 256), Int(Rnd * 256)), _RGB32(Int(Rnd * 256), Int(Rnd * 256), Int(Rnd * 256))
Next reps
t2 = Timer
Print "That took "; t2 - t1; " seconds to draw 64000 polygons"
Sleep
rtn = 0
Do
    _Limit 60
    Cls
    Print "Press <ESC> to quit>"
    polyFT 100, 100, 40, 3, rtn, 1, 1, _RGB32(100, 200, 50), 0
    polyFT 200, 100, 40, 4, 45 + rtn, 1, 1, _RGB32(100, 200, 250), 0
    polyFT 300, 100, 40, 5, rtn, 1, 1, _RGB32(200, 100, 250), 0
    polyFT 400, 100, 40, 6, rtn, 1, 1, _RGB32(100, 250, 150), 0
    polyFT 500, 100, 40, 7, rtn, 1, 1, _RGB32(150, 200, 200), 0
    polyFT 600, 100, 40, 8, 22.5 + rtn, 1, 1, _RGB32(200, 200, 0), 0
    _PrintString (100 - (_PrintWidth("Triangle")) / 2, 160), "Triangle"
    _PrintString (200 - (_PrintWidth("Square")) / 2, 160), "Square"
    _PrintString (300 - (_PrintWidth("Pentagon")) / 2, 160), "Pentagon"
    _PrintString (400 - (_PrintWidth("Hexagon")) / 2, 160), "Hexagon"
    _PrintString (500 - (_PrintWidth("Heptagon")) / 2, 160), "Heptagon"
    _PrintString (600 - (_PrintWidth("Octagon")) / 2, 160), "Octagon"
    rtn = rtn + 1: If rtn > 360 Then rtn = 0
    _Display 'for smooth display
Loop Until InKey$ = Chr$(27)
 
'==========================================================================
'subroutines
'
'  polyFT    draw a filled polygon
'
' setklr    is an  sub to build the color image used byt triangles in  polyT
'====================================== ==================================
Sub polyFT (cx As Long, cy As Long, rad As Long, sides As Integer, rang As Long, ww, vv, klr As _Unsigned Long, lineyes As _Unsigned Long)
    'draw an equilateral polygon using filled triangle for each segment
    'centered at cx,cy to radius rad of sides # of face rotated to angle rang scaled to ww and vv of color klr and lineyes if there is an outline, a value 0 would create no outline
    setklr klr
    Dim px(sides)
    Dim py(sides)
    pang = 360 / sides
    ang = 0
    For p = 1 To sides
        px(p) = cx + (rad * Cos(0.01745329 * (ang + rang))) * ww
        py(p) = cy + (rad * Sin(0.01745329 * (ang + rang))) * vv
        ang = ang + pang
 
    Next p
    For p = 1 To sides - 1
        _MapTriangle (0, 0)-(0, 2)-(2, 0), pk& To(cx, cy)-(px(p), py(p))-(px(p + 1), py(p + 1))
        If lineyes > 0 Then Line (px(p), py(p))-(px(p + 1), py(p + 1)), lineyes
    Next p
    _MapTriangle (0, 0)-(0, 2)-(2, 0), pk& To(cx, cy)-(px(sides), py(sides))-(px(1), py(1))
    If lineyes > 0 Then Line (px(sides), py(sides))-(px(1), py(1)), lineyes
 
 
 
End Sub
Sub setklr (klr As Long)
    'internal routine to setup an image to copy a colored triangle from in the color klr
    'called by polyT
    _Dest pk&
    Line (0, 0)-(2, 2), klr, BF
    _Dest 0
End Sub