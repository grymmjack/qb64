'$Dynamic
$Resize:On

Type Vec2_Float
    As Single X, Y
End Type
Type Vec2_Int
    As Integer X, Y
End Type
Type Vec3_Float
    As Single X, Y, Z
End Type
Type Vec3_Int
    As Integer X, Y, Z
End Type
Type ChunkType
    As Integer X, Z
    As _Unsigned Long Count, TCount, ShowCount, ShowTCount
    As Integer MinimumHeight, MaximumHeight
    As _Byte LoadedChunkData, LoadedRenderData, ShowRenderData
End Type
Type BlockType
    As _Byte Block, Visibility, Light
End Type

Screen _NewImage(960, 540, 32)
_PrintMode _KeepBackground

Do Until _ScreenExists: Loop
Do While _Resize: Loop

_Title "QB Blocks 2"

Randomize Timer
Const True = -1, False = 0
Const DEBUG = False

If DEBUG Then _Title "QB Blocks 2 - Debug"

Dim Shared As _Bit LoadChunk, FOG, FLYMODE, ZOOM: LoadChunk = -1: FLYMODE = 0
Dim Shared As _Byte RenderDistance: RenderDistance = 8

Const ChunkSize = 16
Const ChunkHeight = 64
Const WaterLevel = ChunkHeight * 2 / 5
Const Chunk_Cave_Generate_Threshold = 0.3

Const PlayerHeight = 1.75

Const FOV = 70

'---------------------
Const ChunkSectionSize = ChunkSize * ChunkSize * ChunkHeight * 6 / 8
Const ChunkTSectionSize = ChunkSize * ChunkSize * ChunkHeight * 8 / 8
'---------------------

Dim Shared SeedRatio As Single, Seed As _Unsigned Integer: SeedRatio = Rnd: Seed = SeedRatio * 65536

Dim Shared Chunk(1 To (2 * RenderDistance + 1) ^ 2) As ChunkType
Dim Shared ChunkData(1 To (2 * RenderDistance + 1) ^ 2, 0 To ChunkSize + 1, -1 To ChunkHeight + 1, 0 To ChunkSize + 1) As BlockType
Dim Shared As Integer ChunkLoadTime
Dim Shared As Long LoadedChunks
Dim Shared CubeVertices(23) As Vec3_Int, CubeTexCoords(23) As Vec2_Float
For I = 0 To 23
    Read CubeVertices(I).X, CubeVertices(I).Y, CubeVertices(I).Z, CubeTexCoords(I).X, CubeTexCoords(I).Y
Next I
'--------------------------------
'+X
Data 1,1,1,0,0: Data 1,1,0,1,0: Data 1,0,0,1,1: Data 1,0,1,0,1
'-X
Data 0,0,0,0,1: Data 0,1,0,0,0: Data 0,1,1,1,0: Data 0,0,1,1,1
'+Y
Data 0,1,0,0,0: Data 1,1,0,1,0: Data 1,1,1,1,1: Data 0,1,1,0,1
'-Y
Data 0,0,0,0,0: Data 1,0,0,1,0: Data 1,0,1,1,1: Data 0,0,1,0,1
'+Z
Data 0,0,1,0,1: Data 1,0,1,1,1: Data 1,1,1,1,0: Data 0,1,1,0,0
'-Z
Data 0,0,0,0,1: Data 1,0,0,1,1: Data 1,1,0,1,0: Data 0,1,0,0,0
'--------------------------------
MAXVERTICES = (2 * RenderDistance + 1) ^ 2 * ChunkSectionSize
MAXTVERTICES = (2 * RenderDistance + 1) ^ 2 * ChunkTSectionSize
Dim Shared Vertices(1 To MAXVERTICES) As Vec3_Int, TexCoords(1 To MAXVERTICES) As Vec2_Float
Dim Shared TVertices(1 To MAXTVERTICES) As Vec3_Int, TTexCoords(1 To MAXTVERTICES) As Vec2_Float

Dim Shared Camera As Vec3_Float, CameraAngle As Vec2_Float, PlayerVelocity As Vec3_Float
Dim Shared RayPos As Vec3_Float, RayDir As Vec3_Float, RayBlockPos As Vec3_Int, RayPreviousBlockPos As Vec3_Int
Dim Shared As Vec2_Float CameraAngleSine, CameraAngleCoSine

Dim As _Byte CX, CZ, CPX, CPY, CPZ

Camera.X = 0.5
Camera.Y = ChunkHeight
Camera.Z = 0.5

CameraAngleSine.X = Sin(_D2R(CameraAngle.X)): CameraAngleSine.Y = Sin(_D2R(CameraAngle.Y))
CameraAngleCoSine.X = Cos(_D2R(CameraAngle.X)): CameraAngleCoSine.Y = Cos(_D2R(CameraAngle.Y))

Const Gravity = -20

'--------------------------------
Print "Generating Textures"
Const BLOCK_AIR = 0
Const BLOCK_GRASS = 1
Const BLOCK_DIRT = 2
Const BLOCK_STONE = 3
Const BLOCK_WATER = 4
Const BLOCK_SAND = 5
Const BLOCK_SNOW = 6
Const BLOCK_OAK_LOG = 7
Const BLOCK_OAK_LEAVES = 8

Const TEXTURESIZE = 16
Const IMAGEHEIGHT = 50

Dim Shared As _Unsigned _Byte BlockData(1 To 8)
Dim Shared As Long Texture, Cross
Texture = _NewImage(TEXTURESIZE * 20, TEXTURESIZE * IMAGEHEIGHT, 32)
DIRTBACKGROUND& = _NewImage(_Width, _Height, 32)
DIRT& = _LoadImage("res\dirt.png", 32)
For I = 1 To _Width \ _Width(DIRT&) \ 4 + 1
    For J = 1 To _Height \ _Height(DIRT&) \ 4 + 1
        _PutImage ((I - 1) * _Width(DIRT&) * 4, (J - 1) * _Height(DIRT&) * 4)-(I * _Width(DIRT&) * 4, J * _Height(DIRT&) * 4), DIRT&, DIRTBACKGROUND&
Next J, I
Open "res.list" For Input As #1
ChDir "res"
I = 0
Do
    Line Input #1, I$
    If Left$(I$, 2) = "//" Then _Continue
    If Left$(I$, 2) = "/*" Then MULTILINECOMMENT = True: _Continue
    If Left$(I$, 2) = "*/" Then MULTILINECOMMENT = False: _Continue
    If MULTILINECOMMENT Then _Continue
    If _Trim$(I$) = "" Then _Continue
    I = I + 1
    If _Trim$(I$) = "/n" Then
    Else
        If _FileExists(I$) = 0 Then Print "Unable to load "; I$: End
        IMG& = _LoadImage(I$, 32)
        If IMG& >= -1 Then Print "Unable to load "; I$: End
        For J = 1 To 20
            _PutImage ((J - 1) * TEXTURESIZE, (I - 1) * TEXTURESIZE)-(J * TEXTURESIZE - 1, I * TEXTURESIZE - 1), IMG&, Texture ', (0, 0)-(TEXTURESIZE - 1, TEXTURESIZE - 1)
        Next J
        _FreeImage IMG&
    End If
    If I >= 48 Then Exit Do
Loop
Close #1
Cross = _LoadImage("cross.png", 32)
ChDir ".."
_Source Texture: _Dest Texture
For I = 1 To 20
    For X = I * TEXTURESIZE To _Width
        For Y = 0 To _Height - 1
            If _Alpha32(Point(X, Y)) = 255 Then PSet (X, Y), _RGBA32(0, 0, 0, 17)
    Next Y, X
Next I
_Source 0: _Dest 0
__GL_Generate_Texture = -1
Do While __GL_Generate_Texture = -1: Loop
ChunkX = Int(Camera.X / ChunkSize): ChunkZ = Int(Camera.Z / ChunkSize)
For R = 0 To RenderDistance: For X = ChunkX - R To ChunkX + R: For Z = ChunkZ - R To ChunkZ + R
            T = ChunkLoader(X, Z)
            T = ChunkReloader(X, Z)
            If _Resize Then
                Screen _NewImage(_ResizeWidth, _ResizeHeight, 32)
                _PrintMode _KeepBackground
                aspectRatio = _Width / _Height
            End If
            _PutImage (0, 0)-(_Width - 1, _Height - 1), DIRTBACKGROUND&
            T$ = "Generating Chunks:" + Str$(LoadedChunks) + "/" + Str$(Int(2 * RenderDistance + 1) * Int(2 * RenderDistance + 1))
            _PrintString ((_Width - _FontWidth * Len(T$)) / 2, (_Height - _FontHeight) / 2), T$
            _Display
Next Z, X: Next R
'--------------------------------

Dim Shared As _Unsigned Integer LFPS, GFPS, LFPSCount, GFPSCount: LFPS = 60
FPSCounterTimer = _FreeTimer
On Timer(FPSCounterTimer, 1) GoSub FPSCounter
Timer(FPSCounterTimer) On

' _MouseHide
_GLRender _Behind
Do
    _Limit 60
    LFPSCount = LFPSCount + 1
    If LoadChunk And (LFPSCount Mod 5 = 1) Then GoSub LoadChunk
    If _WindowHasFocus = 0 Then
        allowGL = 0
        _Continue
    Else
        allowGL = -1
    End If
    If _Resize Then
        Screen _NewImage(_ResizeWidth, _ResizeHeight, 32)
        _PrintMode _KeepBackground
        aspectRatio = _Width / _Height
    End If
    While _MouseInput
        If ZOOM Then
            CameraAngle.X = CameraAngle.X + _MouseMovementX / 16
            CameraAngle.Y = CameraAngle.Y - _MouseMovementY / 16
        Else
            CameraAngle.X = CameraAngle.X + _MouseMovementX / 8
            CameraAngle.Y = CameraAngle.Y - _MouseMovementY / 8
        End If
        If CameraAngle.Y < -90 Then CameraAngle.Y = -90
        If CameraAngle.Y > 90 Then CameraAngle.Y = 90
        If CameraAngle.X > 180 Then CameraAngle.X = CameraAngle.X - 360
        If CameraAngle.X < -180 Then CameraAngle.X = CameraAngle.X + 360
        CameraAngleSine.X = Sin(_D2R(CameraAngle.X)): CameraAngleSine.Y = Sin(_D2R(CameraAngle.Y))
        CameraAngleCoSine.X = Cos(_D2R(CameraAngle.X)): CameraAngleCoSine.Y = Cos(_D2R(CameraAngle.Y))
        If FLYMODE = 0 Then
            RayPos = Camera: RayDir.X = CameraAngleSine.X * CameraAngleCoSine.Y: RayDir.Y = CameraAngleSine.Y: RayDir.Z = -CameraAngleCoSine.X * CameraAngleCoSine.Y
            For I = 1 To 4
                If BlockExists(RayPos.X, RayPos.Y, RayPos.Z) Then Exit For
                RayPos.X = RayPos.X + RayDir.X
                RayPos.Y = RayPos.Y + RayDir.Y
                RayPos.Z = RayPos.Z + RayDir.Z
            Next I
            Vec3_FloatToInt RayPos, RayBlockPos
        End If
        _MouseMove _Width / 2, _Height / 2
    Wend

    _KeyClear
    ChunkRelativeCameraPosition Camera, CX, CZ, CPX, CPY, CPZ

    If FLYMODE = 0 Then
        If _MouseButton(1) Then
            While _MouseInput Or _MouseButton(1): Wend
            SetBlockReloadChunk RayBlockPos.X, RayBlockPos.Y, RayBlockPos.Z, BLOCK_AIR
        End If
        If _MouseButton(2) Then
            While _MouseInput Or _MouseButton(2): Wend
            SetBlockReloadChunk RayBlockPos.X, RayBlockPos.Y, RayBlockPos.Z, BLOCK_STONE
        End If
    End If

    If InRange(1, Camera.Y, ChunkHeight) = 0 Then FLYMODE = -1
    If _KeyDown(87) Or _KeyDown(119) Then 'W
        If FLYMODE Then
            Camera.X = Camera.X + CameraAngleSine.X * Movespeed / LFPS
            Camera.Z = Camera.Z - CameraAngleCoSine.X * Movespeed / LFPS
        Else
            If BlockExists(Camera.X + Sgn(CameraAngleSine.X) / 2, Camera.Y, Camera.Z) = 0 And BlockExists(Camera.X + Sgn(CameraAngleSine.X) / 2, Camera.Y - 1, Camera.Z) = 0 Then Camera.X = Camera.X + CameraAngleSine.X * Movespeed / LFPS
            If BlockExists(Camera.X, Camera.Y, Camera.Z - Sgn(CameraAngleCoSine.X) / 2) = 0 And BlockExists(Camera.X, Camera.Y - 1, Camera.Z - Sgn(CameraAngleCoSine.X) / 2) = 0 Then Camera.Z = Camera.Z - CameraAngleCoSine.X * Movespeed / LFPS
        End If
    End If
    If _KeyDown(83) Or _KeyDown(115) Then 'S
        If FLYMODE Then
            Camera.X = Camera.X - CameraAngleSine.X * Movespeed / LFPS
            Camera.Z = Camera.Z + CameraAngleCoSine.X * Movespeed / LFPS
        Else
            If BlockExists(Camera.X - Sgn(CameraAngleSine.X) / 2, Camera.Y, Camera.Z) = 0 And BlockExists(Camera.X - Sgn(CameraAngleSine.X) / 2, Camera.Y - 1, Camera.Z) = 0 Then Camera.X = Camera.X - CameraAngleSine.X * Movespeed / LFPS
            If BlockExists(Camera.X, Camera.Y, Camera.Z + Sgn(CameraAngleCoSine.X) / 2) = 0 And BlockExists(Camera.X, Camera.Y - 1, Camera.Z + Sgn(CameraAngleCoSine.X) / 2) = 0 Then Camera.Z = Camera.Z + CameraAngleCoSine.X * Movespeed / LFPS
        End If
    End If
    If _KeyDown(65) Or _KeyDown(97) Then 'A
        If FLYMODE Then
            Camera.X = Camera.X - CameraAngleCoSine.X * Movespeed / LFPS
            Camera.Z = Camera.Z - CameraAngleSine.X * Movespeed / LFPS
        Else
            If BlockExists(Camera.X - Sgn(CameraAngleCoSine.X) / 2, Camera.Y, Camera.Z) = 0 And BlockExists(Camera.X - Sgn(CameraAngleCoSine.X) / 2, Camera.Y - 1, Camera.Z) = 0 Then Camera.X = Camera.X - CameraAngleCoSine.X * Movespeed / LFPS
            If BlockExists(Camera.X, Camera.Y, Camera.Z - Sgn(CameraAngleSine.X) / 2) = 0 And BlockExists(Camera.X, Camera.Y - 1, Camera.Z - Sgn(CameraAngleSine.X) / 2) = 0 Then Camera.Z = Camera.Z - CameraAngleSine.X * Movespeed / LFPS
        End If
    End If
    If _KeyDown(68) Or _KeyDown(100) Then 'D
        If FLYMODE Then
            Camera.X = Camera.X + CameraAngleCoSine.X * Movespeed / LFPS
            Camera.Z = Camera.Z + CameraAngleSine.X * Movespeed / LFPS
        Else
            If BlockExists(Camera.X + Sgn(CameraAngleCoSine.X) / 2, Camera.Y, Camera.Z) = 0 And BlockExists(Camera.X + Sgn(CameraAngleCoSine.X) / 2, Camera.Y - 1, Camera.Z) = 0 Then Camera.X = Camera.X + CameraAngleCoSine.X * Movespeed / LFPS
            If BlockExists(Camera.X, Camera.Y, Camera.Z + Sgn(CameraAngleSine.X) / 2) = 0 And BlockExists(Camera.X, Camera.Y - 1, Camera.Z + Sgn(CameraAngleSine.X) / 2) = 0 Then Camera.Z = Camera.Z + CameraAngleSine.X * Movespeed / LFPS
        End If
    End If
    If _KeyDown(67) Or _KeyDown(99) Then 'C
        ZOOM = -1
    Else
        ZOOM = 0
    End If
    If _KeyDown(80) Or _KeyDown(112) Then 'P
        Do While _KeyDown(80) Or _KeyDown(112): _Limit 30: Loop
        _MouseShow
        allowGL = 0
        Do Until _KeyDown(80) Or _KeyDown(112): _Limit 30: Loop
        _MouseHide
        allowGL = -1
        Do While _KeyDown(80) Or _KeyDown(112): _Limit 30: Loop
    End If
    If (_KeyDown(70) Or _KeyDown(102)) And InRange(1, Camera.Y, ChunkHeight) Then 'F
        Do While _KeyDown(70) Or _KeyDown(102): _Limit 30: Loop
        FLYMODE = Not FLYMODE
    End If
    If _KeyDown(71) Or _KeyDown(103) Then 'G
        Do While _KeyDown(71) Or _KeyDown(103): _Limit 30: Loop
        FOG = Not FOG
    End If
    If _KeyDown(76) Or _KeyDown(108) Then 'L
        Do While _KeyDown(76) Or _KeyDown(108): _Limit 30: Loop
        LoadChunk = Not LoadChunk
    End If
    If _KeyDown(100304) Then 'LShift
        If FLYMODE Then
            Camera.Y = Camera.Y - Movespeed / LFPS
        Else
            If InRange(0, Camera.Y - PlayerHeight, ChunkHeight) Then If BlockExists(Camera.X, Camera.Y - PlayerHeight, Camera.Z) = 0 Then Camera.Y = Camera.Y - Movespeed / LFPS
        End If
    End If
    If _KeyDown(32) Then 'Space
        If FLYMODE Then
            Camera.Y = Camera.Y + Movespeed / LFPS
        Else
            If InRange(0, Camera.Y - PlayerHeight, ChunkHeight) Then If BlockExists(Camera.X, Camera.Y - PlayerHeight, Camera.Z) <> 0 Then PlayerVelocity.Y = 6
        End If
    End If
    If _KeyDown(100306) Then 'LCtrl
        If FLYMODE Then
            Movespeed = 16
        Else
            Movespeed = 6
        End If
    Else
        Movespeed = 4
    End If
    If FLYMODE = 0 Then
        Camera.Y = Camera.Y + PlayerVelocity.Y / LFPS
        If InRange(0, Camera.Y - PlayerHeight, ChunkHeight) Then
            If BlockExists(Camera.X, Camera.Y - PlayerHeight, Camera.Z) Then
                PlayerVelocity.Y = 0
            Else
                PlayerVelocity.Y = PlayerVelocity.Y + Gravity / LFPS
            End If
        End If
    End If
Loop Until Inp(&H60) = 1
System

FPSCounter:
If GFPSCount Then GFPS = GFPSCount
GFPSCount = 0
If LFPSCount Then LFPS = LFPSCount
LFPSCount = 0
Return

LoadChunk:
ChunkX = Int(Camera.X / ChunkSize)
ChunkZ = Int(Camera.Z / ChunkSize)
Dim EMPTYBLOCKTYPE As BlockType
For I = LBound(Chunk) To UBound(Chunk)
    If Chunk(I).LoadedChunkData = 0 Then _Continue
    If InRange(-RenderDistance, Chunk(I).X - ChunkX, RenderDistance) = 0 Or InRange(-RenderDistance, Chunk(I).Z - ChunkZ, RenderDistance) = 0 Then
        Chunk(I).X = 0
        Chunk(I).Z = 0
        For X = LBound(ChunkData, 2) To UBound(ChunkData, 2): For Y = LBound(ChunkData, 3) To UBound(ChunkData, 3): For Z = LBound(ChunkData, 4) To UBound(ChunkData, 4)
                    ChunkData(I, X, Y, Z) = EMPTYBLOCKTYPE
        Next Z, Y, X
        Chunk(I).Count = 0
        Chunk(I).TCount = 0
        Chunk(I).LoadedChunkData = 0
        Chunk(I).LoadedRenderData = 0
        LoadedChunks = LoadedChunks - 1
        Exit For
    End If
Next I
ChunkLoadingStartTime = Timer(0.001)
CL = 0
For R = 0 To RenderDistance
    For X = ChunkX - R To ChunkX + R: For Z = ChunkZ - R To ChunkZ + R
            If ChunkLoader(X, Z) Then
                CL = -1
                Exit For
            End If
            If ChunkReloader(X, Z) Then
                CL = -1
                Exit For
            End If
    Next Z, X
Next R
If CL Then ChunkLoadTime = Int(1000 * (Timer(0.001) - ChunkLoadingStartTime)) Else ChunkLoadTime = 0
Return

Sub _GL
    Dim As _Byte CX, CZ, CPX, CPY, CPZ
    Shared allowGL, __GL_Generate_Texture, __GL_Generate_Chunks
    Shared aspectRatio As Single
    Static TextureHandle As Long
    If __GL_Generate_Texture Then
        aspectRatio = _Width / _Height
        Dim M As _MEM
        _glGenTextures 1, _Offset(TextureHandle)
        _glBindTexture _GL_TEXTURE_2D, TextureHandle
        M = _MemImage(Texture)
        _glTexImage2D _GL_TEXTURE_2D, 0, _GL_RGBA, _Width(Texture), _Height(Texture), 0, _GL_BGRA_EXT, _GL_UNSIGNED_BYTE, M.OFFSET
        _MemFree M
        _FreeImage Texture
        _glTexParameteri _GL_TEXTURE_2D, _GL_TEXTURE_MIN_FILTER, _GL_NEAREST
        _glTexParameteri _GL_TEXTURE_2D, _GL_TEXTURE_MAG_FILTER, _GL_NEAREST
        __GL_Generate_Texture = 0
    End If

    If allowGL = 0 Then Exit Sub

    _glViewport 0, 0, _Width - 1, _Height - 1
    _glEnable _GL_BLEND
    _glDisable _GL_MULTISAMPLE
    _glEnable _GL_DEPTH_TEST

    _glClearColor 0.47, 0.65, 1, 0
    _glClear _GL_DEPTH_BUFFER_BIT Or _GL_COLOR_BUFFER_BIT

    _glTranslatef 0, 0, -0.25
    _glRotatef -CameraAngle.Y, 1, 0, 0
    _glRotatef CameraAngle.X, 0, 1, 0
    _glTranslatef -Camera.X, -Camera.Y, -Camera.Z

    _glMatrixMode _GL_PROJECTION
    _glLoadIdentity
    _gluPerspective FOV + ZOOM * (FOV - 30), aspectRatio, 0.1, Max(ChunkHeight, ChunkSize * (4 + RenderDistance))

    _glMatrixMode _GL_MODELVIEW

    _glEnable _GL_TEXTURE_2D
    _glBindTexture _GL_TEXTURE_2D, TextureHandle

    If FOG Then
        _glEnable _GL_FOG
        _glFogi _GL_FOG_MODE, _GL_EXP2
        _glFogfv _GL_FOG_COLOR, glVec4(120, 167, 255, 255)
        _glFogf _GL_FOG_DENSITY, 0.001
    End If

    _glEnableClientState _GL_VERTEX_ARRAY
    _glEnableClientState _GL_TEXTURE_COORD_ARRAY
    For I = LBound(Chunk) - 1 To UBound(Chunk) - 1
        If Chunk(I + 1).ShowRenderData = 0 Or Chunk(I + 1).Count = 0 Then _Continue
        _glVertexPointer 3, _GL_SHORT, 0, _Offset(Vertices(I * ChunkSectionSize + 1))
        _glTexCoordPointer 2, _GL_FLOAT, 0, _Offset(TexCoords(I * ChunkSectionSize + 1))
        _glDrawArrays _GL_QUADS, 0, Chunk(I + 1).ShowCount
    Next I
    For I = LBound(Chunk) - 1 To UBound(Chunk) - 1
        If Chunk(I + 1).ShowRenderData = 0 Or Chunk(I + 1).TCount = 0 Then _Continue
        _glVertexPointer 3, _GL_SHORT, 0, _Offset(TVertices(I * ChunkSectionSize + 1))
        _glTexCoordPointer 2, _GL_FLOAT, 0, _Offset(TTexCoords(I * ChunkSectionSize + 1))
        _glDrawArrays _GL_QUADS, 0, Chunk(I + 1).ShowTCount
    Next I
    DrawOutlineBox
    _glDisableClientState _GL_VERTEX_ARRAY
    _glDisableClientState _GL_TEXTURE_COORD_ARRAY
    If FOG Then _glDisable _GL_FOG
    _glDisable _GL_TEXTURE_2D
    _glDisable _GL_DEPTH_TEST
    _glDisable _GL_BLEND
    _glFlush
    Cls 2, 0
    Print "FPS(G/L):"; GFPS; "/"; LFPS;: Print "Seed:"; Seed
    Print "Camera:"; Int(Camera.X); Int(Camera.Y); Int(Camera.Z); Int(CameraAngle.X); Int(CameraAngle.Y)
    Print "Chunks:"; LoadedChunks
    ChunkRelativeCameraPosition Camera, CX, CZ, CPX, CPY, CPZ
    Print "Chunk Relative:"; CX; CZ, CPX; CPY; CPZ
    Print "Selected Block:"; Int(RayBlockPos.X); Int(RayBlockPos.Y); Int(RayBlockPos.Z)
    If ChunkLoadTime Then Print "Chunk Load Time:"; ChunkLoadTime
    _PutImage (_Width / 2, _Height / 2), Cross&
    _Display
    GFPSCount = GFPSCount + 1
End Sub

Sub DrawOutlineBox: X = RayBlockPos.X: Y = RayBlockPos.Y: Z = RayBlockPos.Z: _glBegin _GL_LINES: For I = 0 To 23: _glVertex3f X + CubeVertices(I).X, Y + CubeVertices(I).Y, Z + CubeVertices(I).Z: Next I: _glEnd: End Sub

Function noise1# (x As _Integer64, Seed~%): Dim As _Integer64 xx, tx: x = x + Seed~%: tx = _SHL(x, 13) * x: xx = (tx * (tx * tx * 60493 + 19990303) + 1376312589) And &H7FFFFFFF: noise1 = 1 - xx / 1073741824: End Function
Function noise2# (x, z, Seed~%): noise2 = noise1(x + z * 57, Seed~%): End Function
Function lerp# (a, b, z): lerp = a + (b - a) * (1 - Cos(z * _Pi)) / 2: End Function
Function noisef# (x, z, Seed~%): fX = Int(x): fZ = Int(z): noisef = lerp#(lerp#(noise2#(fX, fZ, Seed~%), noise2#(fX + 1, fZ, Seed~%), x - fX), lerp#(noise2#(fX, fZ + 1, Seed~%), noise2#(fX + 1, fZ + 1, Seed~%), x - fX), z - fZ): End Function
Function interpolate# (a0!, a1!, w!): interpolate# = (a1! - a0!) * w! + a0!: End Function
Function dotGridGradient! (ix%, iy%, yz%, x!, y!, z!, S~%)
    Dim As Single gx, gy, gz, dx, dy, dz, r
    r = ix% + iy% + iz% + (Not (ix%) Xor Not (iy%) Xor Not (iz%)) + S~% * _Pi(16) / 65536
    r = r * -Cos(ix%) + r * Sin(iz%)
    gx = Cos(r): gz = Sin(r)
    gy = (gx + gz) / 2
    dx = x! - ix%: dy = y! - iy%: dz = z! - iz%
    dotGridGradient! = dx * gx + dy * gy + dz * gz
End Function
Function perlin! (x As Single, y As Single, z As Single, S~%)
    Dim As _Integer64 x0, x1, y0, y1, z0, z1: x0 = Int(x): x1 = x0 + 1: y0 = Int(y): y1 = y0 + 1: z0 = Int(z): z1 = z0 + 1
    perlin! = interpolate(interpolate(interpolate(dotGridGradient(x0, y0, z0, x, y, z, S~%), dotGridGradient(x1, y0, z0, x, y, z, S~%), x - x0), interpolate(dotGridGradient(x0, y0, z1, x, y, z, S~%), dotGridGradient(x1, y0, z1, x, y, z, S~%), x - x0), z - z0), interpolate(interpolate(dotGridGradient(x0, y1, z0, x, y, z, S~%), dotGridGradient(x1, y1, z0, x, y, z, S~%), x - x0), interpolate(dotGridGradient(x0, y1, z1, x, y, z, S~%), dotGridGradient(x1, y1, z1, x, y, z, S~%), x - x0), z - z0), y - y0)
End Function
Function noise3# (X, Y, Z, Seed~%): noise3 = (perlin(X / 64, Y / 64, Z / 64, Seed~%) + 1) / 2: End Function
Function Noise# (X, Z, O~%%, Seed~%): Noise# = (noisef#(X / 64, Z / 64, Seed~%) + 1) / 2: End Function

Function glVec4%& (X!, Y!, Z!, W!) Static
    If firstRun` = 0 Then
        Dim VEC4(3) As Single
        firstRun` = -1
    End If
    VEC4(0) = X!: VEC4(1) = Y!: VEC4(2) = Z!: VEC4(3) = W!
glVec4%& = _Offset(VEC4()): End Function

Function ChunkLoader (CX As Long, CZ As Long)
    Dim Block As _Unsigned _Byte
    For I = LBound(Chunk) To UBound(Chunk)
        If Chunk(I).X = CX And Chunk(I).Z = CZ And Chunk(I).LoadedChunkData = -1 Then Exit Function
        If Chunk(I).LoadedChunkData = 0 And FoundI = 0 Then FoundI = I
    Next I
    If FoundI = 0 Then Exit Function
    Chunk(FoundI).X = CX
    Chunk(FoundI).Z = CZ
    If DEBUG Then
        MinimumHeight = 1
        MaximumHeight = ChunkHeight
    Else
        MinimumHeight = ChunkHeight
        MaximumHeight = 1
    End If
    TreeSpawnX = Int((Noise(CX, CZ, 0, Seed) + 1) / 2 * ChunkSize) + 1
    TreeSpawnZ = Int((Noise(CZ, CX, 0, Seed) + 1) / 2 * ChunkSize) + 1
    For X = 0 To ChunkSize + 1
        For Z = 0 To ChunkSize + 1
            Biome = Int(4 * Noise(CX * ChunkSize + X, CZ * ChunkSize + Z, 0, Seed))
            H = Int(ChunkHeight * Noise(CX * ChunkSize + X, CZ * ChunkSize + Z, 7, Seed))
            If X = TreeSpawnX And Z = TreeSpawnZ Then
                TreeBiome = Biome
                TreeHeight = H
            End If
            If MinimumHeight > H - 1 Then MinimumHeight = H - 1
            If MaximumHeight < H Then MaximumHeight = Max(H, WaterLevel)
            ChunkData(FoundI, X, 1, Z).Block = BLOCK_STONE
            For Y = 1 To Max(H, WaterLevel)
                If Y < H - 2 Then
                    Block = BLOCK_STONE
                ElseIf Y < H Then
                    If Biome >= 2 Then
                        Block = BLOCK_DIRT
                    Else
                        Block = BLOCK_SAND
                    End If
                ElseIf Y = H And H > WaterLevel Then
                    If Biome >= 3 Then
                        Block = BLOCK_SNOW
                    ElseIf Biome >= 2 Then
                        Block = BLOCK_GRASS
                    ElseIf Biome >= 1 Then
                        Block = BLOCK_SAND
                    Else
                        Block = BLOCK_WATER
                    End If
                ElseIf Y >= H And H <= WaterLevel Then
                    Block = BLOCK_WATER
                End If
                If Y < H And DEBUG Then
                    If noise3(CX * ChunkSize + X, Y, CZ * ChunkSize + Z, Seed) > Chunk_Cave_Generate_Threshold Then ChunkData(FoundI, X, Y, Z).Block = Block
                Else
                    ChunkData(FoundI, X, Y, Z).Block = Block
                End If
            Next Y
    Next Z, X
    If TreeBiome >= 2 And SpawnTrees Then
        H = TreeHeight
        TreeHeight = 3 + CInt(Rnd * 2) + TreeHeight
        For Y = H To TreeHeight
            If InRange(1, Y, ChunkHeight) Then SetBlock CX * ChunkSize + TreeSpawnX, Y, CZ * ChunkSize + TreeSpawnZ, BLOCK_OAK_LOG
        Next Y
        For Y = TreeHeight + 3 To TreeHeight + 1 Step -1
            AreaSide = AreaSide + 1
            If MaximumHeight < Y Then MaximumHeight = Y
            For X = TreeSpawnX - AreaSide To TreeSpawnX + AreaSide
                For Z = TreeSpawnZ - AreaSide To TreeSpawnZ + AreaSide
                    If InRange(1, Y, ChunkHeight) Then SetBlock CX * ChunkSize + X, Y, CZ * ChunkSize + Z, BLOCK_OAK_LEAVES
            Next Z, X
        Next Y
    End If
    Chunk(FoundI).MinimumHeight = MinimumHeight
    Chunk(FoundI).MaximumHeight = MaximumHeight
    Chunk(FoundI).LoadedChunkData = -1
    ChunkLoader = -1
End Function

Function ChunkReloader (CX, CZ)
    For I = LBound(Chunk) To UBound(Chunk)
        If Chunk(I).X = CX And Chunk(I).Z = CZ Then
            If Chunk(I).LoadedChunkData = 0 Then _Continue
            If Chunk(I).LoadedRenderData = -1 Then Exit Function
            FoundI = I
            Exit For
        End If
    Next I
    If FoundI = 0 Then Exit Function
    Chunk(FoundI).LoadedRenderData = -1
    Dim As _Unsigned Long LV, LTV
    LV = (FoundI - 1) * ChunkSectionSize
    LTV = (FoundI - 1) * ChunkSectionSize
    For X = 1 To ChunkSize
        For Z = 1 To ChunkSize
            For Y = Chunk(FoundI).MinimumHeight To Chunk(FoundI).MaximumHeight
                If ChunkData(FoundI, X, Y, Z).Block = BLOCK_AIR Then _Continue
                ChunkData(FoundI, X, Y, Z).Visibility = isTransparent(ChunkData(FoundI, X + 1, Y, Z).Block) + 2 * isTransparent(ChunkData(FoundI, X - 1, Y, Z).Block) + 4 * isTransparent(ChunkData(FoundI, X, Y + 1, Z).Block) + 8 * isTransparent(ChunkData(FoundI, X, Y - 1, Z).Block) + 16 * isTransparent(ChunkData(FoundI, X, Y, Z + 1).Block) + 32 * isTransparent(ChunkData(FoundI, X, Y, Z - 1).Block)
                If ChunkData(FoundI, X, Y + 1, Z).Block = BLOCK_WATER Then
                    If ChunkData(FoundI, X, Y, Z).Block = BLOCK_WATER Then
                        ChunkData(FoundI, X, Y, Z).Visibility = 0
                    Else
                        If ChunkData(FoundI, X, Y, Z).Visibility = 0 Then ChunkData(FoundI, X, Y, Z).Visibility = 63
                    End If
                End If
                LIGHT~%% = 0
                ChunkData(FoundI, X, Y, Z).Light = 0
                For YY = Y + 1 To Chunk(FoundI).MaximumHeight
                    If ChunkData(FoundI, X, YY, Z).Block Then ChunkData(FoundI, X, Y, Z).Light = 5: Exit For
                Next YY
                If isTransparent(ChunkData(FoundI, X, Y, Z).Block) Then
                    For I = 0 To 23
                        FACE%% = _SHL(1, _SHR(I, 2))
                        If (FACE%% And ChunkData(FoundI, X, Y, Z).Visibility) = 0 Then _Continue
                        If ChunkData(FoundI, X, Y, Z).Block = BLOCK_WATER Then If FACE%% <> 4 Then _Continue
                        LIGHT~%% = ChunkData(FoundI, X, Y, Z).Light * Sgn(FACE%% And 4) + 4 * Sgn(FACE%% And 48) + 6 * Sgn(FACE%% And 3) + 8 * Sgn(FACE%% And 8)
                        LTV = LTV + 1
                        TVertices(LTV).X = CubeVertices(I).X + CX * ChunkSize + X
                        TVertices(LTV).Y = CubeVertices(I).Y + Y
                        TVertices(LTV).Z = CubeVertices(I).Z + CZ * ChunkSize + Z
                        TTexCoords(LTV).X = (CubeTexCoords(I).X + LIGHT~%%) / 20
                        TTexCoords(LTV).Y = (CubeTexCoords(I).Y + _SHR(I, 2) + 6 * ChunkData(FoundI, X, Y, Z).Block - 6) / IMAGEHEIGHT
                        Chunk(FoundI).TCount = Chunk(FoundI).TCount + 1
                    Next I
                Else
                    For I = 0 To 23
                        FACE%% = _SHL(1, _SHR(I, 2))
                        If (FACE%% And ChunkData(FoundI, X, Y, Z).Visibility) = 0 Then _Continue
                        If FACE%% And BlockData(ChunkData(FoundI, X, Y, Z).Block) Then _Continue
                        LIGHT~%% = ChunkData(FoundI, X, Y, Z).Light * Sgn(FACE%% And 4) + 4 * Sgn(FACE%% And 48) + 6 * Sgn(FACE%% And 3) + 8 * Sgn(FACE%% And 8)
                        LV = LV + 1
                        Vertices(LV).X = CubeVertices(I).X + CX * ChunkSize + X
                        Vertices(LV).Y = CubeVertices(I).Y + Y
                        Vertices(LV).Z = CubeVertices(I).Z + CZ * ChunkSize + Z
                        TexCoords(LV).X = (CubeTexCoords(I).X + LIGHT~%%) / 20
                        TexCoords(LV).Y = (CubeTexCoords(I).Y + _SHR(I, 2) + 6 * ChunkData(FoundI, X, Y, Z).Block - 6) / IMAGEHEIGHT
                        Chunk(FoundI).Count = Chunk(FoundI).Count + 1
                    Next I
                End If
    Next Y, Z, X
    Chunk(FoundI).ShowCount = Chunk(FoundI).Count
    Chunk(FoundI).ShowTCount = Chunk(FoundI).TCount
    Chunk(FoundI).ShowRenderData = -1
    LoadedChunks = LoadedChunks + 1
    ChunkReloader = -1
End Function

Sub SetBlockReloadChunk (X, Y, Z, B)
    Dim As Integer __CX, __CZ, __CPX, __CPY, __CPZ
    __CX = Int(X / ChunkSize)
    __CZ = Int(Z / ChunkSize)
    __CPX = Int(X - __CX * ChunkSize)
    __CPY = Int(Y)
    __CPZ = Int(Z - __CZ * ChunkSize)
    For I = LBound(Chunk) To UBound(Chunk)
        If Chunk(I).X = __CX And Chunk(I).Z = __CZ And Chunk(I).LoadedChunkData Then FoundI = I: Exit For
    Next I
    If FoundI = 0 Then Exit Sub
    ChunkData(FoundI, __CPX, __CPY, __CPZ).Block = B
    Chunk(FoundI).MinimumHeight = Max(0, Min(Chunk(FoundI).MinimumHeight, __CPY - 1))
    Chunk(FoundI).MaximumHeight = Max(Chunk(FoundI).MaximumHeight, __CPY)
    Chunk(FoundI).LoadedRenderData = 0
    Chunk(FoundI).Count = 0
    Chunk(FoundI).TCount = 0
    T = ChunkReloader(__CX, __CZ)
End Sub

Sub SetBlock (X, Y, Z, B)
    __CX = Int(X / ChunkSize)
    __CZ = Int(Z / ChunkSize)
    __CPX = Int(X - __CX * ChunkSize)
    __CPY = Int(Y)
    __CPZ = Int(Z - __CZ * ChunkSize)
    For I = LBound(Chunk) To UBound(Chunk)
        If Chunk(I).X = __CX And Chunk(I).Z = __CZ Then FoundI = I: Exit For
    Next I
    If FoundI = 0 Then Exit Sub
    ChunkData(FoundI, __CPX, __CPY, __CPZ).Block = B
End Sub
Function Collide (CamX, CamY, CamZ, VX, VY, VZ)
End Function

Function cfloor% (X As Single)
    cfloor = CLng(X - 0.5)
End Function

Function isTransparent (B)
    If B = BLOCK_AIR Or B = BLOCK_WATER Or B = BLOCK_OAK_LEAVES Then isTransparent = 1
End Function

Function isNotBlock (B)
    If B = BLOCK_AIR Or B = BLOCK_WATER Then isNotBlock = 1
End Function

Function Dis2 (X1, Y1, X2, Y2)
    Dis2 = _Hypot(X1 - X2, Y1 - Y2) 'Got this _hypot() idea from bplus
End Function

Function Min (A, B)
    If A < B Then Min = A Else Min = B
End Function
Function Max (A, B)
    If A < B Then Max = B Else Max = A
End Function

Function InRange (A, B, C)
    If A <= B And B <= C Then InRange = -1
End Function

Sub ChunkRelativeCameraPosition (__Camera As Vec3_Float, __CX As _Byte, __CZ As _Byte, __CPX As _Byte, __CPY As _Byte, __CPZ As _Byte)
    __CX = Int(__Camera.X / ChunkSize)
    __CZ = Int(__Camera.Z / ChunkSize)
    __CPX = cfloor(__Camera.X - __CX * ChunkSize)
    __CPY = Int(__Camera.Y)
    __CPZ = cfloor(__Camera.Z - __CZ * ChunkSize)
End Sub

Function BlockExists (X, Y, Z)
    __CX = Int(X / ChunkSize): __CZ = Int(Z / ChunkSize)
    For I = LBound(Chunk) To UBound(Chunk): If Chunk(I).X = __CX And Chunk(I).Z = __CZ And Chunk(I).LoadedChunkData Then FoundI = I: Exit For
    Next I: If FoundI = 0 Then Exit Function
    __CPX = cfloor(X - __CX * ChunkSize): __CPY = Int(Y): __CPZ = cfloor(Z - __CZ * ChunkSize)
    BlockExists = ChunkData(FoundI, __CPX, __CPY, __CPZ).Block
End Function

Sub Vec3_FloatToInt (A As Vec3_Float, B As Vec3_Int)
    B.X = Int(A.X)
    B.Y = Int(A.Y)
    B.Z = Int(A.Z)
End Sub
