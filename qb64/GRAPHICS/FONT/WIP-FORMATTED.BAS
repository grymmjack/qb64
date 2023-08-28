'$DYNAMIC
Option _Explicit
Option _ExplicitArray

Const CHARS = 8
Const COLS = 9
Const ROWS = 9
Const BPP2 = 32

' screen setup
Dim CANVAS As Long
CANVAS& = _NewImage(COLS * 150, ROWS * 100, BPP2)
Screen CANVAS&
_Dest CANVAS&

' glyph data
Dim GD(CHARS) As String
GD$(0) = GD$(0) + "XXXXXXXXX"
GD$(0) = GD$(0) + ".X......."
GD$(0) = GD$(0) + "..X......"
GD$(0) = GD$(0) + "...X....."
GD$(0) = GD$(0) + "....X...."
GD$(0) = GD$(0) + ".....X..."
GD$(0) = GD$(0) + "......X.."
GD$(0) = GD$(0) + ".......X."
GD$(0) = GD$(0) + "XXXXXXXXX"

GD$(1) = GD$(1) + "XXXXXXXXX"
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."

GD$(2) = GD$(2) + "....X...."
GD$(2) = GD$(2) + "...X.X..."
GD$(2) = GD$(2) + "..X...X.."
GD$(2) = GD$(2) + ".X.....X."
GD$(2) = GD$(2) + "XXXXXXXXX"
GD$(2) = GD$(2) + "X.......X"
GD$(2) = GD$(2) + "X.......X"
GD$(2) = GD$(2) + "X.......X"
GD$(2) = GD$(2) + "X.......X"

GD$(3) = GD$(3) + "XXXXXXXXX"
GD$(3) = GD$(3) + "X......X."
GD$(3) = GD$(3) + "X.....X.."
GD$(3) = GD$(3) + "X....X..."
GD$(3) = GD$(3) + "X...X...."
GD$(3) = GD$(3) + "X..X....."
GD$(3) = GD$(3) + "X.X......"
GD$(3) = GD$(3) + "XX......."
GD$(3) = GD$(3) + "XXXXXXXXX"

GD$(4) = GD$(4) + "XXXXXXXXX"
GD$(4) = GD$(4) + ".X......."
GD$(4) = GD$(4) + "..X......"
GD$(4) = GD$(4) + "...XXXXXX"
GD$(4) = GD$(4) + "..X......"
GD$(4) = GD$(4) + ".X......."
GD$(4) = GD$(4) + "X........"
GD$(4) = GD$(4) + "X........"
GD$(4) = GD$(4) + "X........"

GD$(5) = GD$(5) + "XXXXXXXXX"
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "XXXXXXXXX"

GD$(6) = GD$(6) + "XXXXXXXXX"
GD$(6) = GD$(6) + "X........"
GD$(6) = GD$(6) + "X........"
GD$(6) = GD$(6) + "X..XXXXXX"
GD$(6) = GD$(6) + "X...X...."
GD$(6) = GD$(6) + "X....X..."
GD$(6) = GD$(6) + "X.....X.."
GD$(6) = GD$(6) + "X......X."
GD$(6) = GD$(6) + "XXXXXXXXX"

GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "XXXXXXXXX"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"

GD$(8) = GD$(8) + "XXXXXXXXX"
GD$(8) = GD$(8) + ".X......."
GD$(8) = GD$(8) + "..X......"
GD$(8) = GD$(8) + "...X....."
GD$(8) = GD$(8) + "....XXXXX"
GD$(8) = GD$(8) + "...X....."
GD$(8) = GD$(8) + "..X......"
GD$(8) = GD$(8) + ".X......."
GD$(8) = GD$(8) + "XXXXXXXXX"

' F0NT UDT
Type F0NT
    glyph_width As Integer
    glyph_height As Integer
    char As String
    img As Long
End Type
Dim STARFIGHTER_FONT(CHARS) As F0NT
Dim STARFIGHTER_BIG_FONT(CHARS) As F0NT

' create the glyph images from the glyph data
Dim kolor As Long
kolor& = _RGB32(&HFF, &HFF, &HFF)
Call F0NT.make_glyph("S", STARFIGHTER_FONT(0), GD$(0), kolor&)
Call F0NT.make_glyph("T", STARFIGHTER_FONT(1), GD$(1), kolor&)
Call F0NT.make_glyph("A", STARFIGHTER_FONT(2), GD$(2), kolor&)
Call F0NT.make_glyph("R", STARFIGHTER_FONT(3), GD$(3), kolor&)
Call F0NT.make_glyph("F", STARFIGHTER_FONT(4), GD$(4), kolor&)
Call F0NT.make_glyph("I", STARFIGHTER_FONT(5), GD$(5), kolor&)
Call F0NT.make_glyph("G", STARFIGHTER_FONT(6), GD$(6), kolor&)
Call F0NT.make_glyph("H", STARFIGHTER_FONT(7), GD$(7), kolor&)
Call F0NT.make_glyph("E", STARFIGHTER_FONT(8), GD$(8), kolor&)

' prepare for output
_Dest CANVAS&
Color 0, _RGB32(&H00, &H00, &HAA)
Cls

' test 1
Dim As Integer x, y, scale, kerning, spacing
Color &HFFFFFF00
_PrintString (50, 20), "Testing spacing 0 to 4 with scale = 1"
For spacing% = 0 To 4
    x% = 200 * spacing% + 50: y% = 50: scale% = 1
Call F0NT.print("STARFIGHTER", STARFIGHTER_FONT(), x%, y%, scale%, spacing%)
Next

' test 2
x% = 50: y% = 100: scale% = 4: kerning% = 0: spacing% = 4
Call F0NT.print("STARFIGHTER", STARFIGHTER_FONT(), x%, y%, scale%, spacing%)

' test 3
x% = 50: y% = 200: scale% = 7: kerning% = 0: spacing% = 2
Call F0NT.print("STARFIGHTER", STARFIGHTER_FONT(), x%, y%, scale%, spacing%)

' test 4
x% = 50: y% = 400: scale% = 8: spacing% = 2
Call F0NT.print("STARFIGHTER", STARFIGHTER_FONT(), x%, y%, scale%, spacing%)
Call F0NT.free(STARFIGHTER_FONT())
Call F0NT.free(STARFIGHTER_BIG_FONT())



''
' Free the font glyph images from memory
'
' @param F0NT ARRAY f()
'
Sub F0NT.free (f() As F0NT)
    Dim As Integer i, lb, ub
    lb% = LBound(f): ub% = UBound(f)
    For i% = lb% To ub%
        _FreeImage f(i%).img&
    Next i%
End Sub


''
' Copies the source font to the dest font
'
' @param F0NT ARRAY sf() source font
' @param F0NT ARRAY df() dest font
'
Sub F0NT.copy (sf() As F0NT, df() As F0NT)
    Dim As Integer i, lb, ub
    lb% = LBound(sf): ub% = UBound(sf)
    ReDim df(lb% To ub%) As F0NT
    For i% = lb% To ub%
        df(i%).char$ = sf(i%).char$
        df(i%).img& = sf(i%).img&
    Next i%
End Sub


''
' Save glyphs of a font to disk
'
' @param STRING s$ characters to save
' @param F0NT ARRAY f()
' @param STRING dest_dir$
'
Sub F0NT.save_glyphs_to_disk (s$, f() As F0NT)
    Dim As Integer i, lb, ub
    lb% = LBound(f): ub% = UBound(f)
    For i% = lb% To ub%
        If f(i%).char$ = Chr$(Asc(s$, i% + 1)) Then
            Call SaveImage(f(i%).img&, f(i%).char$)
        End If
    Next i%
End Sub


''
' Make a glyph from glyph data and store it in F0NT
'
' @param STRING c$ glyph character identifier
' @param F0NT ARRAY f()
' @param STRING ARRAY glyph_data$()
' @param LONG kolor& to make glyphs
'
Sub F0NT.make_glyph (c$, f As F0NT, glyph_data$, kolor&)
    Dim As Integer y, x, p, dbg
    Dim s As String
    Dim old_dest As Long
    ' dbg% = -1
    f.char$ = c$
    If dbg% Then Print c$
    f.img& = _NewImage(COLS, ROWS, BPP2)
    old_dest& = _Dest: _Dest f.img&
    _ClearColor _RGB32(&H00, &H00, &H00)
    For y% = 0 To ROWS
        For x% = 0 To COLS
            p% = (y% * COLS) + x% + 1
            s$ = Mid$(glyph_data$, p%, 1)
            If dbg% Then
                _Dest old_dest&: Print s$;: _Dest f.img&
            End If
            If s$ <> "." Then
                Call PSet((x%, y%), kolor&)
            End If
        Next x%
        If dbg% Then
            _Dest old_dest&: Print: _Dest f.img&
        End If
    Next y%
    If dbg% Then Sleep
    _Dest old_dest&
End Sub


''
' Get a glyph image from a F0NT by character identifier
'
' @param STRING c$ character identifier of glyph to get
' @param F0NT ARRAY f()
' @return LONG image handle for glyph image of F0NT
'
Function F0NT.get_glyph& (c$, f() As F0NT)
    Dim As Integer i, lb, ub
    lb% = LBound(f): ub% = UBound(f)
    For i% = lb% To ub%
        If f(i%).char$ = c$ Then
            F0NT.get_glyph& = f(i%).img&
            Exit Function
        End If
    Next i%
End Function


''
' Print something using a F0NT
'
' @param STRING s$ what to print
' @param F0NT ARRAY f()
' @param INTEGER x% position
' @param INTEGER y% position
' @param INTEGER scale% size multiplier
' @param INTEGER kerning% scaling space between characters
' @param INTEGER spacing% spaces between characters
'
Sub F0NT.print (s$, f() As F0NT, x%, y%, scale%, spacing%)
    Dim As Integer i, l, dx1, dy1, dx2, dy2, orig_x
    Dim c As String
    Dim g As Long
    l% = Len(s$)
    ' PSet (x%, y%)
    For i% = 1 To l%
        c$ = Mid$(s$, i%, 1)
        'g& =
        '_Source g&
        dx1% = x% + (i% - 1) * (COLS + spacing%) * scale%
        dy1% = y%
        'dx2% = (COLS * scale%) + dx1%
        'dy2% = (ROWS * scale%) + dy1%
        _PutImage (dx1%, dy1%)-Step(COLS * scale% - 1, ROWS * scale% - 1), F0NT.get_glyph(c$, f())
    Next i%
End Sub


''
' Scales a source F0NT glyphs images and stores into dest F0NT
'
' @param STRING s$ Glyphs to scale
' @param F0NT ARRAY sf() source font
' @param F0NT ARRAY df() dest font
' @param INTEGER scale% multiplier
'
Sub F0NT.scale (s$, sf() As F0NT, df() As F0NT, scale%)
    Dim As Integer i, lb, ub, dx1, dy1, dx2, dy2
    Dim As Long sg, dg, old_dest
    Call F0NT.copy(sf(), df())
    lb% = LBound(sf): ub% = UBound(sf)
    old_dest& = _Dest
    For i% = lb% To ub%
        dx1% = 0
        dy1% = 0
        dx2% = (COLS * scale%) + dx1%
        dy2% = (ROWS * scale%) + dy1%
        df(i%).img& = _NewImage(dx2%, dy2%, BPP2)
        _Source sf(i%).img&: _Dest df(i%).img&
        _PutImage (dx1%, dy1%)-(dx2%, dy2%)
    Next i%
    _Dest old_dest&
End Sub


''
' Save image to disk as filename by Galleon
'
' @param LONG image& to save to disk
' @param STRING filename$ to save as
'
Sub SaveImage (image&, filename$)
    Dim As Long f, c, cv, x, y, py, px, lastsource, bpp, bytesperpixel
    Dim As String b, d, ext, padder, r
    bytesperpixel& = _PixelSize(image&)
    If bytesperpixel& = 0 Then Print "Text modes unsupported!": Exit Sub
    If bytesperpixel& = 1 Then bpp& = 8 Else bpp& = 24
    x& = _Width(image&)
    y& = _Height(image&)
    b$ = "BM????QB64????" + MKL$(40) + MKL$(x&) + MKL$(y&) + MKI$(1) + MKI$(bpp&) + MKL$(0) + "????" + String$(16, 0) 'partial BMP header info(???? to be filled later)
    If bytesperpixel& = 1 Then
        For c& = 0 To 255 ' read BGR color settings from JPG image + 1 byte spacer(CHR$(0))
            cv& = _PaletteColor(c&, image&) ' color attribute to read.
            b$ = b$ + Chr$(_Blue32(cv&)) + Chr$(_Green32(cv&)) + Chr$(_Red32(cv&)) + Chr$(0) 'spacer byte
        Next
    End If
    Mid$(b$, 11, 4) = MKL$(Len(b$)) ' image pixel data offset(BMP header)
    lastsource& = _Source
    _Source image&
    If ((x& * 3) Mod 4) Then padder$ = String$(4 - ((x& * 3) Mod 4), 0)
    For py& = y& - 1 To 0 Step -1 ' read JPG image pixel color data
        r$ = ""
        For px& = 0 To x& - 1
            c& = Point(px&, py&) 'POINT 32 bit values are large LONG values
            If bytesperpixel& = 1 Then r$ = r$ + Chr$(c&) Else r$ = r$ + Left$(MKL$(c&), 3)
        Next px&
        d$ = d$ + r$ + padder$
    Next py&
    _Source lastsource&
    Mid$(b$, 35, 4) = MKL$(Len(d$)) ' image size(BMP header)
    b$ = b$ + d$ ' total file data bytes to create file
    Mid$(b$, 3, 4) = MKL$(Len(b$)) ' size of data file(BMP header)
    If LCase$(Right$(filename$, 4)) <> ".bmp" Then ext$ = ".bmp"
    f& = FreeFile
    Open filename$ + ext$ For Output As #f&: Close #f& ' erases an existing file
    Open filename$ + ext$ For Binary As #f&
    Put #f&, , b$
    Close #f&
End Sub
