' From: https://qb64forum.alephc.xyz/index.php?topic=4638.msg140530#msg140530

_Title "Quick Falling Letters Game B+ mod" 'b+ 2022-02-08
 
const nn = 1
Const twidth = 640, theight = 480, zoom = 128
Dim Shared noise(nn*twidth * theight) '//the noise array
Dim Shared texture(nn*twidth * theight) '//texture array
Dim Shared pal(256) As _Unsigned Long '//color palette
 
Dim letters$(1 To 25), lx(1 To 25) As Integer ' screen 0 25 lines 80 letters across
Dim hits, letterPos, i, K$, GameOver
 
screen _newimage(640,480,32)
MakePalette 255, 155, 255, 10, 100, 180
GenerateNoise
buildtexture
 
dim vs as long
vs = _newimage(twidth, theight, 32)
_dest vs
drawtexture 0
_dest 0
 
ii = 0
jj = -1
kk = 0
Do
        kk = kk + 1
        ii = ii + 1
        if ii >= 640 then
                ii = 0
                jj = not jj
        end if         
 
        if jj then
                _putimage (ii , 0)-step(640,480), vs
                _putimage (ii , 0)-step(-640,480), vs
        else
                _putimage (ii + 640, 0)-step(-640,480), vs
                _putimage (ii - 640 , 0)-step(640,480), vs
        end if
 
    'Cls
        if kk mod 50 = 0 then
                letterPos = letterPos + 1 ' generate new letter at each round
                If letterPos > 24 Then GameOver = -1
                For i = letterPos - 1 To 1 Step -1 ' cycle letters and positions down
                        letters$(i + 1) = letters$(i)
                        lx(i + 1) = lx(i)
                Next
                letters$(1) = Chr$(Int(Rnd * 26) + 97) ' start a new letter
                lx(1) = Int(Rnd * 80) + 1 ' at a new place
                K$ = InKey$ ' check key presses for match to current letterPos
                While K$ = letters$(letterPos) ' catch up with all keypresses
                        hits = hits + 1 '            add to score
                        letterPos = letterPos - 1
                        K$ = InKey$ '                check next keypress
                Wend
        end if
 
        For i = 1 To letterPos 'show board what's left of letters
                Locate i, lx(i): Print letters$(i);
        Next
        Locate 25, 36: Print "Hits:"; hits
 
        _display
    _Limit 50
Loop Until GameOver
Locate 25, 26: Print "Game Over"
_display
Sleep
system
 
'//interpolation code by rattrapmax6
Sub MakePalette (sr, sg, sb, er, eg, eb) ' (b+) start and end RGB's ? yes
    Dim i, istart(3), iend(3), ishow(3), rend(3), interpol(3)
 
    interpol(0) = 255
    istart(1) = sr
    istart(2) = sg
    istart(3) = sb
    iend(1) = er
    iend(2) = eg
    iend(3) = eb
    interpol(1) = (istart(1) - iend(1)) / interpol(0)
    interpol(2) = (istart(2) - iend(2)) / interpol(0)
    interpol(3) = (istart(3) - iend(3)) / interpol(0)
    rend(1) = istart(1)
    rend(2) = istart(2)
    rend(3) = istart(3)
 
    For i = 0 To 255
        ishow(1) = rend(1)
        ishow(2) = rend(2)
        ishow(3) = rend(3)
 
        pal(i) = _RGB32(ishow(1), ishow(2), ishow(3))
 
        rend(1) = rend(1) - interpol(1)
        rend(2) = rend(2) - interpol(2)
        rend(3) = rend(3) - interpol(3)
    Next i
End Sub
 
'//generates random noise.
Sub GenerateNoise ()
    Dim As Long x, y
 
    For x = 0 To nn*twidth - 1
        For y = 0 To theight - 1
                        zz = rnd
            noise(x + y * twidth) = zz
        Next y
    Next x
 
End Sub
 
Function SmoothNoise (x, y)
    '//get fractional part of x and y
    Dim fractx, fracty, x1, y1, x2, y2, value
    fractx = x - Int(x)
    fracty = y - Int(y)
 
    '//wrap around
    x1 = (Int(x) + nn*twidth) Mod twidth
    y1 = (Int(y) + theight) Mod theight
 
    '//neighbor values
    x2 = (x1 + nn*twidth - 1) Mod twidth
    y2 = (y1 + theight - 1) Mod theight
 
    '//smooth the noise with bilinear interpolation
    value = 0.0
    value = value + fractx * fracty * noise(x1 + y1 * twidth)
    value = value + fractx * (1 - fracty) * noise(x1 + y2 * twidth)
    value = value + (1 - fractx) * fracty * noise(x2 + y1 * twidth)
    value = value + (1 - fractx) * (1 - fracty) * noise(x2 + y2 * twidth)
 
    SmoothNoise = value
End Function
 
Function Turbulence (x, y, size)
    Dim value, initialsize
 
    initialsize = size
    While (size >= 1)
        value = value + SmoothNoise(x / size, y / size) * size
        size = size / 2.0
    Wend
    Turbulence = (128.0 * value / initialsize)
End Function
 
'//builds the texture.
Sub buildtexture
    Dim x, y
 
    For x = 0 To nn*twidth - 1
        For y = 0 To theight - 1
            texture(x + y * nn*twidth) = Turbulence(x, y, zoom)
        Next y
    Next x
End Sub
 
'//draws texture to screen.
Sub drawtexture (dx )
    Dim x, y
        dim as long c, r, g, b
 
    For x = 0 To twidth - 1
        For y = 0 To theight - 1
                        c = pal(texture(((x + dx) + y * nn*twidth)))
                        r = _red(c)
                        g = _green(c)
                        b = _blue(c)
                        c = _rgb(r - 0.2*y, g - 0.2*y, b - 0.2*b)
            PSet (x, y), c'pal(texture(((x + dx) + y * nn*twidth)))
        Next y
    Next x
End Sub
 