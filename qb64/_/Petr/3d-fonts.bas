 
Option _Explicit
 
' I worked with AI to complete this program. Just because I've written
' something with _MapTriangle doesn't mean I understand everything!
'
' Petr
'
'
'-------------------- WHAT THIS PROGRAM DOES --------------------
'
' Goal:
'  Render a 3D "extruded" letter (or text) using _MAPTRIANGLE(3D).
'  The 3D mesh is not built from vector outlines. Instead, we:
'    1) Render the glyph to a 32-bit software image with alpha.
'    2) Convert that alpha image into a binary mask (inside/outside).
'    3) Convert the mask into a set of merged rectangles:
'          - Fill rectangles (front/back faces) using scanline merging.
'          - Edge rectangles (left/right/top/bottom walls) using run-lengths.
'    4) Each rectangle becomes a quad => 2 triangles => drawn with _MAPTRIANGLE(3D).
'
' Why rectangles?
'  Because scanline merging can compress thousands of pixels into
'  a small number of rectangles. That makes triangulation trivial:
'  each rectangle is always 2 triangles. No polygon triangulation needed.
'
' -------------------- QB64PE-SAFE WORKFLOW --------------------
'
' In QB64PE, hardware images (mode 33) act like OpenGL textures.
' The safe pattern used here is:
'
'  - Do all "drawing/building" (printing glyph, building mask) in SOFTWARE images (mode 32).
'  - Convert the small color textures to hardware textures using _COPYIMAGE(...,33).
'  - Use hardware textures ONLY as sources for _MAPTRIANGLE / _PUTIMAGE.
'  - Do NOT rely on _DEST to a hardware image for "rendering into it".
'
' Rendering strategy:
'  - Screen is software (32).
'  - _MAPTRIANGLE(3D) draws to the OpenGL layer over the screen.
'  - To clear the OpenGL layer each frame:
'      * Clear depth buffer: _DEPTHBUFFER _CLEAR
'      * Draw a large background plane far behind the glyph (two triangles).
'
' -------------------- WHERE ROTATION IS SET --------------------
'
' Rotation angles (radians):
'  ax, ay, az
' Angular velocities (radians per frame):
'  daX, daY, daZ
'
' Each frame:
'  ax = ax + daX
'  ay = ay + daY
'  az = az + daZ
'
' Rotation math happens in TransformPoint().
'
' -------------------- HOW TO RENDER A WHOLE TEXT --------------------
'
' There are TWO reasonable approaches:
'
' A) Extrude the whole string as one big mask (simple, heavier mesh):
'    - Set glyph = "HELLO WORLD" (any string).
'    - Call BuildGlyph glyph, ...
'    - Result: one combined 3D object.
'    - Tradeoff: large mask => more rectangles => more triangles.
'
' B) Extrude per character (best for long texts, reusable cache):
'    - Prebuild each character into its own rectangle lists.
'    - Render them in a loop with an X offset (advance).
'    - You need per-character storage (arrays of Rect lists).
'
' PSEUDOCODE for approach B:
'    For each char in text:
'        BuildGlyph char, ...
'        Copy the generated rect arrays into a glyph-cache structure
'    During render:
'        xOffset = 0
'        For each char in text:
'            Load rect arrays from cache
'            DrawGlyph3D with tx = baseTx + xOffset
'            xOffset = xOffset + advanceWidth(char)
'
' Advance width in pixels (for spacing) can be approximated by:
'    advancePixels = PrintWidth(char)  (measured with the same font setup)
' Then convert to world units using the same scaling as used in DrawGlyph3D:
'    advanceWorld = advancePixels * baseScale * aspectCorr
'
' -------------------- QUALITY / PERFORMANCE KNOBS --------------------
'
' maskScale:
'  Higher = smoother silhouette (less "stairs") but more rectangles/triangles.
' alphaThresh:
'  Higher = tighter mask (can shrink thin antialiased edges).
' depth:
'  Extrusion thickness along Z.
' tz:
'  Camera translation along Z (must be < -1 for 3D view volume).
' baseScale:
'  Overall size of the mesh in world units.
'
'============================================================
 
Type RectI
    x1 As Long
    y1 As Long
    x2 As Long
    y2 As Long
End Type
 
Type RectEdgeV
    xEdge As Long
    y1 As Long
    y2 As Long
End Type
 
Type RectEdgeH
    yEdge As Long
    x1 As Long
    x2 As Long
End Type
 
'---- shared glyph data ----
Dim Shared mw As Long, mh As Long
ReDim Shared mask(0, 0) As _Unsigned _Byte
 
ReDim Shared rectFill(0) As RectI
Dim Shared rectFillCnt As Long
 
ReDim Shared rectLeft(0) As RectEdgeV
Dim Shared rectLeftCnt As Long
 
ReDim Shared rectRight(0) As RectEdgeV
Dim Shared rectRightCnt As Long
 
ReDim Shared rectTop(0) As RectEdgeH
Dim Shared rectTopCnt As Long
 
ReDim Shared rectBot(0) As RectEdgeH
Dim Shared rectBotCnt As Long
 
'---- render / settings ----
Dim sw As Long, sh As Long
 
Dim texFrontSoft As Long, texSideSoft As Long, texBackSoft As Long, texBgSoft As Long
Dim texFrontHW As Long, texSideHW As Long, texBackHW As Long, texBgHW As Long
 
Dim glyph As String
Dim fontFile As String
Dim baseFontSize As Long
Dim maskScale As Long
Dim pad As Long
Dim alphaThresh As Long
 
Dim scaleMul As Single
Dim baseScale As Single
Dim depth As Single
 
Dim ax As Single, ay As Single, az As Single
Dim daX As Single, daY As Single, daZ As Single
 
Dim tx As Single, ty As Single, tz As Single
 
Dim aspectCorr As Single
Dim keyCode As Long
Dim showInfo As Long
 
'================= init =================
sw = 960: sh = 540
Screen _NewImage(sw, sh, 32)
_Title "3D Font (_MAPTRIANGLE 3D) - scanline extrude (QB64PE-safe)"
_ScreenMove _Middle
 
' aspectCorr:
'  _MAPTRIANGLE(3D) uses a normalized-ish view where X/Y are affected by aspect.
'  A simple practical hack is to scale X by (sh/sw) so objects do not look stretched.
aspectCorr = CSng(sh) / CSng(sw)
 
' textures: SW -> HW (33)
' These are tiny 2x2 color textures used for shading:
'  front = bright, side = mid, back = darker, bg = background plane.
texFrontSoft = _NewImage(2, 2, 32)
texSideSoft = _NewImage(2, 2, 32)
texBackSoft = _NewImage(2, 2, 32)
texBgSoft = _NewImage(2, 2, 32)
 
MakeSolidTextureSoft texFrontSoft, 230, 230, 240
MakeSolidTextureSoft texSideSoft, 160, 160, 180
MakeSolidTextureSoft texBackSoft, 120, 120, 140
MakeSolidTextureSoft texBgSoft, 30, 30, 40
 
texFrontHW = _CopyImage(texFrontSoft, 33)
texSideHW = _CopyImage(texSideSoft, 33)
texBackHW = _CopyImage(texBackSoft, 33)
texBgHW = _CopyImage(texBgSoft, 33)
 
_FreeImage texFrontSoft: texFrontSoft = 0
_FreeImage texSideSoft: texSideSoft = 0
_FreeImage texBackSoft: texBackSoft = 0
_FreeImage texBgSoft: texBgSoft = 0
 
' ---- glyph setup ----
glyph = "QB64 PE (Phoenix Edition)" 'for protection, of course...    
' (You can set glyph to a full string or just one character...
'  glyph = "HELLO WORLD"
'  Note: bigger string => bigger mask => more rectangles => slower.)
fontFile = "/home/grymmjack/.local/share/fonts/segoeui.ttf"
baseFontSize = 80
 
' maskScale:
'  Main "anti-stair" control. Higher = smoother but more geometry.
maskScale = 80
pad = maskScale * 12
alphaThresh = 64
 
scaleMul = 1
depth = 0.60
 
' ---- rotation ----
ax = 0: ay = 0: az = 0
daX = 0.012
daY = 0.017
daZ = 0.008
 
' ---- camera translation ----
' tz must stay < -1.0 (z=-1 is the near plane center in QB64's 3D system).
tx = 0
ty = 0
tz = -4.0
 
showInfo = -1
 
' Build mesh from current glyph
BuildGlyph glyph, fontFile, baseFontSize, maskScale, pad, alphaThresh
AutoFitScale baseScale, mw, mh, tz
baseScale = baseScale * scaleMul
 
 
Do
    _Limit 60
 
    keyCode = _KeyHit
    If keyCode = 27 Then Exit Do
 
    ' Controls:
    '  + / - : zoom (scaleMul)
    '  [ / ] : extrusion depth (depth)
    If keyCode = Asc("+") Or keyCode = Asc("=") Then
        scaleMul = scaleMul * 1.06
        baseScale = baseScale * 1.06
    ElseIf keyCode = Asc("-") Then
        scaleMul = scaleMul / 1.06
        baseScale = baseScale / 1.06
    ElseIf keyCode = Asc("[") Then
        depth = depth / 1.06
        If depth < 0.05 Then depth = 0.05
    ElseIf keyCode = Asc("]") Then
        depth = depth * 1.06
        If depth > 5 Then depth = 5
    ElseIf keyCode >= 32 And keyCode <= 126 Then
        ' Any printable key becomes the new glyph.
        ' For full string: set glyph manually and call BuildGlyph once.
        glyph = Chr$(keyCode)
        BuildGlyph glyph, fontFile, baseFontSize, maskScale, pad, alphaThresh
        AutoFitScale baseScale, mw, mh, tz
        baseScale = baseScale * scaleMul
    End If
 
    ' Apply rotation each frame (this is THE place to change rotation behavior):
    ax = ax + daX
    ay = ay + daY
    az = az + daZ
 
    ' Clear software layer (2D background)
    Cls , _RGB32(0, 0, 0)
 
    ' Clear depth buffer for 3D OpenGL layer
    _DepthBuffer _Clear
 
    ' Clear the 3D color layer by drawing a big plane BEHIND the glyph.
    ' This effectively overwrites the previous frame's 3D color.
    DrawBackgroundPlane texBgHW, tz - 60, CSng(sw) / CSng(sh)
 
    ' Draw glyph (3D triangles) to the OpenGL layer
    DrawGlyph3D ax, ay, az, tx, ty, tz, baseScale, depth, aspectCorr, texFrontHW, texBackHW, texSideHW
 
    If showInfo Then
        DrawHud glyph, baseScale, depth, mw, mh, rectFillCnt, rectLeftCnt, rectRightCnt, rectTopCnt, rectBotCnt
    End If
 
    _Display
Loop
 
'cleanup
If texFrontHW Then _FreeImage texFrontHW
If texSideHW Then _FreeImage texSideHW
If texBackHW Then _FreeImage texBackHW
If texBgHW Then _FreeImage texBgHW
End
 
 
Sub MakeSolidTextureSoft (img As Long, r As Long, g As Long, b As Long)
    ' Creates a flat-color 2x2 texture in a software image.
    ' Later we convert it to a hardware texture via _CopyImage(...,33).
    Dim oldDest As Long
    oldDest = _Dest
    _Dest img
    Cls
    Line (0, 0)-(_Width(img) - 1, _Height(img) - 1), _RGB32(r, g, b), BF
    _Dest oldDest
End Sub
 
Sub DrawHud (glyph As String, sc As Single, dep As Single, w As Long, h As Long, cFill As Long, cL As Long, cR As Long, cT As Long, cB As Long)
    ' Debug info:
    '  - Mask size and rectangle counts tell you if the mask is sane.
    '    If FillRects is 1 and mask is huge => you likely got a "full mask" (alpha background problem).
    Dim s1 As String, s2 As String, s3 As String
    s1 = "Glyph:[" + glyph + "]  zoom(+/-):" + LTrim$(Str$(sc)) + "  depth([/]):" + LTrim$(Str$(dep))
    s2 = "Mask:" + LTrim$(Str$(w)) + "x" + LTrim$(Str$(h)) + "  FillRects:" + LTrim$(Str$(cFill))
    s3 = "SideRuns L/R/T/B:" + LTrim$(Str$(cL)) + "/" + LTrim$(Str$(cR)) + "/" + LTrim$(Str$(cT)) + "/" + LTrim$(Str$(cB))
    _PrintString (10, 10), s1
    _PrintString (10, 28), s2
    _PrintString (10, 46), s3
End Sub
 
Sub AutoFitScale (sc As Single, w As Long, h As Long, tz As Single)
    ' Very simple "auto scale" so the glyph fits into the view volume.
    ' Rough idea: projected size ? worldSize / -z
    ' We aim for about 1.4 in projected units (fits into [-1..1] with margin).
    Dim maxDim As Long
    Dim wantProj As Single
 
    maxDim = w
    If h > maxDim Then maxDim = h
    If maxDim < 1 Then maxDim = 1
 
    If tz > -1.1 Then tz = -1.1
    wantProj = 1.4
    sc = (wantProj * (-tz)) / CSng(maxDim)
End Sub
 
Sub BuildGlyph (glyph As String, fontFile As String, baseFontSize As Long, wantMaskScale As Long, pad As Long, alphaThresh As Long)
    ' Pipeline:
    '  1) MakeMaskFromText: build binary mask from rendered alpha glyph
    '  2) BuildFillRects: scanline merged rectangles for the front/back faces
    '  3) Build*EdgeRects: run-length rectangles for the side walls
    MakeMaskFromText glyph, fontFile, baseFontSize, wantMaskScale, pad, alphaThresh
    BuildFillRects
    BuildLeftEdgeRects
    BuildRightEdgeRects
    BuildTopEdgeRects
    BuildBotEdgeRects
End Sub
 
Sub MakeMaskFromText (glyph As String, fontFile As String, baseFontSize As Long, wantMaskScale As Long, pad As Long, alphaThresh As Long)
 
    ' Creates a binary mask from the alpha channel of rendered text.
    '
    ' Key detail:
    '  Background MUST have alpha = 0, otherwise the bounding box becomes the whole image
    '  and the mask becomes "all ones" => you only get huge rectangles.
    '
    ' Steps:
    '  1) Load font at baseFontSize*maskScale (supersampling in mask space).
    '  2) Create 32-bit image, clear with RGBA(0,0,0,0).
    '  3) PrintString the glyph in opaque white.
    '  4) Find bounding box of pixels with alpha > 0.
    '  5) Crop into mask array and threshold alpha.
 
    Dim fontH As Long
    Dim useScale As Long
    Dim wText As Long, hText As Long
    Dim img32 As Long
    Dim x As Long, y As Long
    Dim a As Long
    Dim minX As Long, minY As Long, maxX As Long, maxY As Long
    Dim x0 As Long, y0 As Long
    Dim imgW As Long, imgH As Long
    Dim oldFont As Long
    Dim clearCol As _Unsigned Long
    Dim textCol As _Unsigned Long
 
    useScale = wantMaskScale
    fontH = 0
    oldFont = _Font
 
    clearCol = _RGBA32(0, 0, 0, 0)
    textCol = _RGBA32(255, 255, 255, 255)
 
    If _FileExists(fontFile) Then
        fontH = _LoadFont(fontFile, baseFontSize * useScale, )
        If fontH = 0 Then useScale = 1
    Else
        useScale = 1
    End If
 
    If fontH <> 0 Then _Font fontH
 
    wText = _PrintWidth(glyph)
    hText = _FontHeight
    If wText < 1 Then wText = 1
    If hText < 1 Then hText = 1
 
    imgW = wText + pad * 2
    imgH = hText + pad * 2
 
    img32 = _NewImage(imgW, imgH, 32)
    _Dest img32
 
    _DontBlend
    Cls , clearCol
    _Blend
 
    Color textCol, clearCol
    _PrintString (pad, pad), glyph
 
    _Source img32
 
    minX = imgW: minY = imgH
    maxX = -1: maxY = -1
 
    For y = 0 To imgH - 1
        For x = 0 To imgW - 1
            a = _Alpha32(Point(x, y))
            If a > 0 Then
                If x < minX Then minX = x
                If y < minY Then minY = y
                If x > maxX Then maxX = x
                If y > maxY Then maxY = y
            End If
        Next x
    Next y
 
    If maxX < 0 Then
        mw = 1: mh = 1
        ReDim mask(0, 0) As _Unsigned _Byte
        mask(0, 0) = 0
    Else
        mw = (maxX - minX) + 1
        mh = (maxY - minY) + 1
        ReDim mask(mw - 1, mh - 1) As _Unsigned _Byte
 
        For y = 0 To mh - 1
            y0 = minY + y
            For x = 0 To mw - 1
                x0 = minX + x
                a = _Alpha32(Point(x0, y0))
                If a >= alphaThresh Then
                    mask(x, y) = 1
                Else
                    mask(x, y) = 0
                End If
            Next x
        Next y
    End If
 
    _Source 0
    _Dest 0
 
    If img32 Then _FreeImage img32
    If fontH <> 0 Then _FreeFont fontH
    _Font oldFont
 
End Sub
 
Sub BuildFillRects ()
    ' Builds rectangles covering the "inside" pixels of the mask.
    '
    ' Algorithm:
    '  For each row y:
    '    1) Find all runs of 1s => segments [xStart, xEnd)
    '    2) Merge vertically: if a segment matches a previous open rectangle (same xStart/xEnd),
    '        extend that rectangle down by 1.
    '    3) If an open rectangle does not continue, close it and store to rectFill.
    '
    ' Result:
    '  rectFill[] describes the front/back faces as rectangles in mask pixel space.
 
    Dim x As Long, y As Long
    Dim segCnt As Long, openCnt As Long
    Dim i As Long, j As Long
    Dim hit As Long
    Dim xStart As Long, xEnd As Long
 
    ' NOTE: these MUST be ARRAYS (so ReDim works)
    Dim segX1 As Long, segX2 As Long
    Dim openX1 As Long, openX2 As Long
    Dim openY1 As Long, openY2 As Long
    Dim openUsed As _Unsigned _Byte
 
    rectFillCnt = 0
    ReDim rectFill(0) As RectI
    If mw < 1 Or mh < 1 Then Exit Sub
 
    ReDim segX1(1 To mw) As Long
    ReDim segX2(1 To mw) As Long
    ReDim openX1(1 To mw) As Long
    ReDim openX2(1 To mw) As Long
    ReDim openY1(1 To mw) As Long
    ReDim openY2(1 To mw) As Long
    ReDim openUsed(1 To mw) As _Unsigned _Byte
 
    openCnt = 0
 
    For y = 0 To mh - 1
        segCnt = 0
        x = 0
        Do While x < mw
            If mask(x, y) <> 0 Then
                xStart = x
                x = x + 1
                Do While x < mw
                    If mask(x, y) = 0 Then Exit Do
                    x = x + 1
                Loop
                xEnd = x
                segCnt = segCnt + 1
                segX1(segCnt) = xStart
                segX2(segCnt) = xEnd
            Else
                x = x + 1
            End If
        Loop
 
        For j = 1 To openCnt
            openUsed(j) = 0
        Next j
 
        For i = 1 To segCnt
            hit = 0
            For j = 1 To openCnt
                If openX1(j) = segX1(i) Then
                    If openX2(j) = segX2(i) Then
                        openY2(j) = y + 1
                        openUsed(j) = 1
                        hit = j
                        Exit For
                    End If
                End If
            Next j
 
            If hit = 0 Then
                openCnt = openCnt + 1
                openX1(openCnt) = segX1(i)
                openX2(openCnt) = segX2(i)
                openY1(openCnt) = y
                openY2(openCnt) = y + 1
                openUsed(openCnt) = 1
            End If
        Next i
 
        j = openCnt
        Do While j >= 1
            If openUsed(j) = 0 Then
                rectFillCnt = rectFillCnt + 1
                If rectFillCnt > UBound(rectFill) Then ReDim _Preserve rectFill(rectFillCnt + 2048) As RectI
                rectFill(rectFillCnt).x1 = openX1(j)
                rectFill(rectFillCnt).x2 = openX2(j)
                rectFill(rectFillCnt).y1 = openY1(j)
                rectFill(rectFillCnt).y2 = openY2(j)
 
                openX1(j) = openX1(openCnt): openX2(j) = openX2(openCnt)
                openY1(j) = openY1(openCnt): openY2(j) = openY2(openCnt)
                openUsed(j) = openUsed(openCnt)
                openCnt = openCnt - 1
            End If
            j = j - 1
        Loop
    Next y
 
    For j = 1 To openCnt
        rectFillCnt = rectFillCnt + 1
        If rectFillCnt > UBound(rectFill) Then ReDim _Preserve rectFill(rectFillCnt + 2048) As RectI
        rectFill(rectFillCnt).x1 = openX1(j)
        rectFill(rectFillCnt).x2 = openX2(j)
        rectFill(rectFillCnt).y1 = openY1(j)
        rectFill(rectFillCnt).y2 = openY2(j)
    Next j
 
    If rectFillCnt < UBound(rectFill) Then ReDim _Preserve rectFill(rectFillCnt) As RectI
End Sub
 
Sub BuildLeftEdgeRects ()
    ' Left wall runs:
    '  A pixel (x,y) contributes to the LEFT wall if:
    '    mask(x,y)=1 and (x=0 or mask(x-1,y)=0)
    ' We then merge contiguous y runs for each xEdge into RectEdgeV entries.
    Dim x As Long, y As Long
    Dim yStart As Long
    Dim edge1 As Long, edge2 As Long
 
    rectLeftCnt = 0
    ReDim rectLeft(0) As RectEdgeV
    If mw < 1 Or mh < 1 Then Exit Sub
 
    For x = 0 To mw - 1
        y = 0
        Do While y < mh
            edge1 = 0
            If mask(x, y) <> 0 Then
                If x = 0 Then
                    edge1 = -1
                Else
                    If mask(x - 1, y) = 0 Then edge1 = -1
                End If
            End If
 
            If edge1 Then
                yStart = y
                y = y + 1
                Do While y < mh
                    edge2 = 0
                    If mask(x, y) <> 0 Then
                        If x = 0 Then
                            edge2 = -1
                        Else
                            If mask(x - 1, y) = 0 Then edge2 = -1
                        End If
                    End If
                    If edge2 = 0 Then Exit Do
                    y = y + 1
                Loop
 
                rectLeftCnt = rectLeftCnt + 1
                If rectLeftCnt > UBound(rectLeft) Then ReDim _Preserve rectLeft(rectLeftCnt + 2048) As RectEdgeV
                rectLeft(rectLeftCnt).xEdge = x
                rectLeft(rectLeftCnt).y1 = yStart
                rectLeft(rectLeftCnt).y2 = y
            Else
                y = y + 1
            End If
        Loop
    Next x
 
    If rectLeftCnt < UBound(rectLeft) Then ReDim _Preserve rectLeft(rectLeftCnt) As RectEdgeV
End Sub
 
Sub BuildRightEdgeRects ()
    ' Right wall runs:
    '  mask(x,y)=1 and (x=mw-1 or mask(x+1,y)=0)
    Dim x As Long, y As Long
    Dim yStart As Long
    Dim edge1 As Long, edge2 As Long
 
    rectRightCnt = 0
    ReDim rectRight(0) As RectEdgeV
    If mw < 1 Or mh < 1 Then Exit Sub
 
    For x = 0 To mw - 1
        y = 0
        Do While y < mh
            edge1 = 0
            If mask(x, y) <> 0 Then
                If x = mw - 1 Then
                    edge1 = -1
                Else
                    If mask(x + 1, y) = 0 Then edge1 = -1
                End If
            End If
 
            If edge1 Then
                yStart = y
                y = y + 1
                Do While y < mh
                    edge2 = 0
                    If mask(x, y) <> 0 Then
                        If x = mw - 1 Then
                            edge2 = -1
                        Else
                            If mask(x + 1, y) = 0 Then edge2 = -1
                        End If
                    End If
                    If edge2 = 0 Then Exit Do
                    y = y + 1
                Loop
 
                rectRightCnt = rectRightCnt + 1
                If rectRightCnt > UBound(rectRight) Then ReDim _Preserve rectRight(rectRightCnt + 2048) As RectEdgeV
                rectRight(rectRightCnt).xEdge = x + 1
                rectRight(rectRightCnt).y1 = yStart
                rectRight(rectRightCnt).y2 = y
            Else
                y = y + 1
            End If
        Loop
    Next x
 
    If rectRightCnt < UBound(rectRight) Then ReDim _Preserve rectRight(rectRightCnt) As RectEdgeV
End Sub
 
Sub BuildTopEdgeRects ()
    ' Top wall runs:
    '  mask(x,y)=1 and (y=0 or mask(x,y-1)=0)
    Dim y As Long, x As Long
    Dim xStart As Long
    Dim edge1 As Long, edge2 As Long
 
    rectTopCnt = 0
    ReDim rectTop(0) As RectEdgeH
    If mw < 1 Or mh < 1 Then Exit Sub
 
    For y = 0 To mh - 1
        x = 0
        Do While x < mw
            edge1 = 0
            If mask(x, y) <> 0 Then
                If y = 0 Then
                    edge1 = -1
                Else
                    If mask(x, y - 1) = 0 Then edge1 = -1
                End If
            End If
 
            If edge1 Then
                xStart = x
                x = x + 1
                Do While x < mw
                    edge2 = 0
                    If mask(x, y) <> 0 Then
                        If y = 0 Then
                            edge2 = -1
                        Else
                            If mask(x, y - 1) = 0 Then edge2 = -1
                        End If
                    End If
                    If edge2 = 0 Then Exit Do
                    x = x + 1
                Loop
 
                rectTopCnt = rectTopCnt + 1
                If rectTopCnt > UBound(rectTop) Then ReDim _Preserve rectTop(rectTopCnt + 2048) As RectEdgeH
                rectTop(rectTopCnt).yEdge = y
                rectTop(rectTopCnt).x1 = xStart
                rectTop(rectTopCnt).x2 = x
            Else
                x = x + 1
            End If
        Loop
    Next y
 
    If rectTopCnt < UBound(rectTop) Then ReDim _Preserve rectTop(rectTopCnt) As RectEdgeH
End Sub
 
Sub BuildBotEdgeRects ()
    ' Bottom wall runs:
    '  mask(x,y)=1 and (y=mh-1 or mask(x,y+1)=0)
    Dim y As Long, x As Long
    Dim xStart As Long
    Dim edge1 As Long, edge2 As Long
 
    rectBotCnt = 0
    ReDim rectBot(0) As RectEdgeH
    If mw < 1 Or mh < 1 Then Exit Sub
 
    For y = 0 To mh - 1
        x = 0
        Do While x < mw
            edge1 = 0
            If mask(x, y) <> 0 Then
                If y = mh - 1 Then
                    edge1 = -1
                Else
                    If mask(x, y + 1) = 0 Then edge1 = -1
                End If
            End If
 
            If edge1 Then
                xStart = x
                x = x + 1
                Do While x < mw
                    edge2 = 0
                    If mask(x, y) <> 0 Then
                        If y = mh - 1 Then
                            edge2 = -1
                        Else
                            If mask(x, y + 1) = 0 Then edge2 = -1
                        End If
                    End If
                    If edge2 = 0 Then Exit Do
                    x = x + 1
                Loop
 
                rectBotCnt = rectBotCnt + 1
                If rectBotCnt > UBound(rectBot) Then ReDim _Preserve rectBot(rectBotCnt + 2048) As RectEdgeH
                rectBot(rectBotCnt).yEdge = y + 1
                rectBot(rectBotCnt).x1 = xStart
                rectBot(rectBotCnt).x2 = x
            Else
                x = x + 1
            End If
        Loop
    Next y
 
    If rectBotCnt < UBound(rectBot) Then ReDim _Preserve rectBot(rectBotCnt) As RectEdgeH
End Sub
 
Sub DrawBackgroundPlane (tex As Long, zBg As Single, invAspect As Single)
    ' Clears the 3D OpenGL color layer by overdrawing it.
    ' We draw a large quad (2 triangles) far behind the glyph.
    '
    ' zBg should be much smaller (more negative) than the glyph's tz,
    ' otherwise it may intersect/occlude the mesh.
    Dim s As Single
    Dim x0 As Single, y0 As Single, z0 As Single
    Dim x1 As Single, y1 As Single, z1 As Single
    Dim x2 As Single, y2 As Single, z2 As Single
    Dim x3 As Single, y3 As Single, z3 As Single
 
    s = -zBg
    If s < 2 Then s = 2
 
    x0 = -s: y0 = -s * invAspect: z0 = zBg
    x1 = s: y1 = -s * invAspect: z1 = zBg
    x2 = s: y2 = s * invAspect: z2 = zBg
    x3 = -s: y3 = s * invAspect: z3 = zBg
 
    _MapTriangle _AntiClockwise (0, 0)-(1, 0)-(1, 1), tex To(x0, y0, z0)-(x1, y1, z1)-(x2, y2, z2), , _Smooth
    _MapTriangle _AntiClockwise (0, 0)-(1, 1)-(0, 1), tex To(x0, y0, z0)-(x2, y2, z2)-(x3, y3, z3), , _Smooth
End Sub
 
Sub DrawGlyph3D (ax As Single, ay As Single, az As Single, tx As Single, ty As Single, tz As Single, sc As Single, dep As Single, aspectCorr As Single, texF As Long, texB As Long, texS As Long)
    ' Converts rectangle lists into 3D quads (front/back/sides), then draws them.
    '
    ' Coordinate mapping:
    '  mask pixel space:
    '    x grows to the right
    '    y grows downwards
    '  world space used here:
    '    x grows to the right, y grows up
    '    we center the glyph around (0,0) by subtracting (mw/2, mh/2)
    '  z:
    '    front face at z=0
    '    back face at z=-dep
    '
    ' aspectCorr:
    '  simple correction to avoid horizontal stretching.
 
    Dim cosx As Single, sinx As Single
    Dim cosy As Single, siny As Single
    Dim cosz As Single, sinz As Single
 
    Dim cx As Single, cy As Single
    Dim i As Long
 
    Dim xL As Single, xR As Single
    Dim yT As Single, yB As Single
    Dim zF As Single, zB As Single
 
    Dim xE As Single, yE As Single
 
    cosx = CSng(Cos(ax)): sinx = CSng(Sin(ax))
    cosy = CSng(Cos(ay)): siny = CSng(Sin(ay))
    cosz = CSng(Cos(az)): sinz = CSng(Sin(az))
 
    cx = CSng(mw) / 2
    cy = CSng(mh) / 2
 
    zF = 0
    zB = -dep
 
    ' Front + Back faces
    For i = 1 To rectFillCnt
        xL = (CSng(rectFill(i).x1) - cx) * sc * aspectCorr
        xR = (CSng(rectFill(i).x2) - cx) * sc * aspectCorr
        yT = (cy - CSng(rectFill(i).y1)) * sc
        yB = (cy - CSng(rectFill(i).y2)) * sc
 
        DrawQuad3D texF, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, xL, yT, zF, xL, yB, zF, xR, yB, zF, xR, yT, zF
        DrawQuad3D texB, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, xL, yT, zB, xR, yT, zB, xR, yB, zB, xL, yB, zB
    Next i
 
    ' Left wall
    For i = 1 To rectLeftCnt
        xE = (CSng(rectLeft(i).xEdge) - cx) * sc * aspectCorr
        yT = (cy - CSng(rectLeft(i).y1)) * sc
        yB = (cy - CSng(rectLeft(i).y2)) * sc
        DrawQuad3D texS, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, xE, yT, zF, xE, yT, zB, xE, yB, zB, xE, yB, zF
    Next i
 
    ' Right wall
    For i = 1 To rectRightCnt
        xE = (CSng(rectRight(i).xEdge) - cx) * sc * aspectCorr
        yT = (cy - CSng(rectRight(i).y1)) * sc
        yB = (cy - CSng(rectRight(i).y2)) * sc
        DrawQuad3D texS, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, xE, yT, zF, xE, yB, zF, xE, yB, zB, xE, yT, zB
    Next i
 
    ' Top wall
    For i = 1 To rectTopCnt
        yE = (cy - CSng(rectTop(i).yEdge)) * sc
        xL = (CSng(rectTop(i).x1) - cx) * sc * aspectCorr
        xR = (CSng(rectTop(i).x2) - cx) * sc * aspectCorr
        DrawQuad3D texS, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, xL, yE, zF, xR, yE, zF, xR, yE, zB, xL, yE, zB
    Next i
 
    ' Bottom wall
    For i = 1 To rectBotCnt
        yE = (cy - CSng(rectBot(i).yEdge)) * sc
        xL = (CSng(rectBot(i).x1) - cx) * sc * aspectCorr
        xR = (CSng(rectBot(i).x2) - cx) * sc * aspectCorr
        DrawQuad3D texS, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, xL, yE, zF, xL, yE, zB, xR, yE, zB, xR, yE, zF
    Next i
End Sub
 
Sub DrawQuad3D (tex As Long, _
    cosx As Single, sinx As Single, _
    cosy As Single, siny As Single, _
    cosz As Single, sinz As Single, _
    tx As Single, ty As Single, tz As Single, _
    x0 As Single, y0 As Single, z0 As Single, _
    x1 As Single, y1 As Single, z1 As Single, _
    x2 As Single, y2 As Single, z2 As Single, _
    x3 As Single, y3 As Single, z3 As Single)
 
    ' Draws a quad as 2 triangles using _MAPTRIANGLE(3D).
    ' IMPORTANT:
    '  Do not overwrite input vertices (x0..z3) during transform!
    '  We write transformed vertices into vx0..vz3.
 
    Dim vx0 As Single, vy0 As Single, vz0 As Single
    Dim vx1 As Single, vy1 As Single, vz1 As Single
    Dim vx2 As Single, vy2 As Single, vz2 As Single
    Dim vx3 As Single, vy3 As Single, vz3 As Single
 
    TransformPoint x0, y0, z0, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, vx0, vy0, vz0
    TransformPoint x1, y1, z1, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, vx1, vy1, vz1
    TransformPoint x2, y2, z2, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, vx2, vy2, vz2
    TransformPoint x3, y3, z3, cosx, sinx, cosy, siny, cosz, sinz, tx, ty, tz, vx3, vy3, vz3
 
    ' UV mapping for 2x2 texture:
    '  (0,0) top-left, (1,0) top-right, (1,1) bottom-right, (0,1) bottom-left
    _MapTriangle _AntiClockwise (0, 0)-(1, 0)-(1, 1), tex To(vx0, vy0, vz0)-(vx1, vy1, vz1)-(vx2, vy2, vz2), , _Smooth
    _MapTriangle _AntiClockwise (0, 0)-(1, 1)-(0, 1), tex To(vx0, vy0, vz0)-(vx2, vy2, vz2)-(vx3, vy3, vz3), , _Smooth
 
End Sub
 
Sub TransformPoint (xIn As Single, yIn As Single, zIn As Single, cosx As Single, sinx As Single, cosy As Single, siny As Single, cosz As Single, sinz As Single, tx As Single, ty As Single, tz As Single, xRes As Single, yRes As Single, zRes As Single)
    ' Applies rotation around X, then Y, then Z, then translation.
    ' This is the only place that defines the rotation order.
    Dim x1 As Single, y1 As Single, z1 As Single
    Dim x2 As Single, y2 As Single, z2 As Single
    Dim x3 As Single, y3 As Single, z3 As Single
 
    ' X rot
    x1 = xIn
    y1 = yIn * cosx - zIn * sinx
    z1 = yIn * sinx + zIn * cosx
 
    ' Y rot
    x2 = x1 * cosy + z1 * siny
    y2 = y1
    z2 = -x1 * siny + z1 * cosy
 
    ' Z rot
    x3 = x2 * cosz - y2 * sinz
    y3 = x2 * sinz + y2 * cosz
    z3 = z2
 
    ' translate (camera-space)
    xRes = x3 + tx
    yRes = y3 + ty
    zRes = z3 + tz
End Sub