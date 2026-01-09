'=====================
'DavsHarp-Xmas2025.bas
'=====================
'Christmas 2025 edition of Dav's Harp.
'Includes demo of looping Christmas songs.
'Also this is a playable harp complete with
'recording/saving/loading your own songs.
'Coded by Dav in QB64PE, DEC/2025

'Merry Christmas to all qb64pheonix.com coders !

'Press the following keys to play the harp:
'1,2,3,4,5,6,7,8,9,0,-,=,q,w,e

'R = Record what you play (overwrites previous)
'P = Playback what your recorded or loaded song.
'S = Saves current recording to a file on disk.
'L = Load a recorded file from disk.
'D = Starts built-in DEMO of Christmas songs.
'X = Exit (quit) the program.

'ESC = Will Open/close the menu at anytime.
'      Opening the menu will also stop playback'
'      and recording in progress.

Randomize Timer

Screen _NewImage(800, 600, 32)
_FullScreen _SquarePixels
_PrintMode _KeepBackground

'decode/load harp image
back& = _LoadImage(harp$, 32, "memory"): If back& = 0 Then er = 1

'decode/load harp menu image
menu& = _LoadImage(harpmenu$, 32, "memory"): If menu& = 0 Then er = 1

'decode/load merry christmas sign
merry& = _LoadImage(merrydat$, 32, "memory"): If merry& = 0 Then er = 1

'decode/load dav image
dav& = _LoadImage(davdat$, 32, "memory"): If dav& = 0 Then er = 1

'decode/load dav santa image
davsanta& = _LoadImage(davsantadat$, 32, "memory"): If davsanta& = 0 Then er = 1

'decode/load sound files
note01& = _SndOpen(N01$, "memory"): If note01& = 0 Then er = 1
note02& = _SndOpen(N02$, "memory"): If note02& = 0 Then er = 1
note03& = _SndOpen(N03$, "memory"): If note03& = 0 Then er = 1
note04& = _SndOpen(N04$, "memory"): If note04& = 0 Then er = 1
note05& = _SndOpen(N05$, "memory"): If note05& = 0 Then er = 1
note06& = _SndOpen(N06$, "memory"): If note06& = 0 Then er = 1
note07& = _SndOpen(N07$, "memory"): If note07& = 0 Then er = 1
note08& = _SndOpen(N08$, "memory"): If note08& = 0 Then er = 1
note09& = _SndOpen(N09$, "memory"): If note09& = 0 Then er = 1
note10& = _SndOpen(N10$, "memory"): If note10& = 0 Then er = 1
note11& = _SndOpen(N11$, "memory"): If note11& = 0 Then er = 1
note12& = _SndOpen(N12$, "memory"): If note12& = 0 Then er = 1
note13& = _SndOpen(N13$, "memory"): If note13& = 0 Then er = 1
note14& = _SndOpen(N14$, "memory"): If note14& = 0 Then er = 1
note15& = _SndOpen(N15$, "memory"): If note15& = 0 Then er = 1

'decode/load sound effects
sparkle& = _SndOpen(sparkledat$, "memory"): If sparkle& = 0 Then er = 1
jingle& = _SndOpen(jingledat$, "memory"): If jingle& = 0 Then er = 1

If er = 1 Then Print "Error loading media resource.": End

_Display

_SndPlayCopy jingle&

'show the intro here...fade in sign
For fv = 255 To 0 Step -4
    _PutImage (0, 0)-(_Width, _Height), merry&
    Line (0, 0)-(_Width, _Height), _RGBA(0, 0, 0, fv), BF
    _Display
    _Limit 30
Next
_PutImage (0, 0)-(_Width, _Height), merry&
UnExplodeImage 340, 430, dav&
_Delay 1

'show snow balls over dav, play sound too

_SndPlayCopy sparkle&

dustmax = 600 'make sure enough dust particles
Dim dustx(dustmax), dusty(dustmax)
Dim dustxv(dustmax), dustyv(dustmax)
Dim dustr(dustmax), dusta(dustmax)
dustcount = 0 'no active dust particles yet

For showit = 1 To 120
    _PutImage (0, 0)-(_Width, _Height), merry&
    _PutImage (340, 430), dav&
    _PutImage (340, 430), davsanta&
    If showit < 15 Then
        For ex = 1 To 60
            If dustcount < dustmax Then
                dustcount = dustcount + 1
                dustx(dustcount) = 400 + (Rnd * 10) - (Rnd * 10)
                dusty(dustcount) = 430
                dustxv(dustcount) = Rnd * 5 - 2.5
                dustyv(dustcount) = Rnd * 5 - 2.5
                dustr(dustcount) = Int(Rnd * 5) + 1
                dusta(dustcount) = Rnd * 255
            End If
        Next
    End If

    If dustcount > 0 Then
        For i = 1 To dustcount
            dustyv(i) = dustyv(i) + .1 'gravity effect
            dustx(i) = dustx(i) + dustxv(i)
            dusty(i) = dusty(i) + dustyv(i)
            If dusta(i) > 0 Then
                Line (dustx(i), dusty(i))-Step(dustr(i), dustr(i)), _RGBA(255, 255, 255, dusta(i)), BF
                dusta(i) = dusta(i) - 4 'fading
            End If
        Next
        For i = 1 To dustcount
            If dusta(i) <= 0 Then
                dustcount = dustcount - 1
                For j = i To dustcount
                    dustx(j) = dustx(j + 1)
                    dusty(j) = dusty(j + 1)
                    dustxv(j) = dustxv(j + 1)
                    dustyv(j) = dustyv(j + 1)
                    dustr(j) = dustr(j + 1)
                    dusta(j) = dusta(j + 1)
                Next
            End If
        Next

    End If
    _Display
    _Limit 30
Next

'fade out intro
For fv = 0 To 255 Step 4
    Line (0, 0)-(_Width, _Height), _RGBA(0, 0, 0, fv), BF
    _Display
    _Limit 30
Next

strings = 15 'number of harp strings
Dim notex1(strings), notey1(strings)
Dim notex2(strings), notey2(strings)
Dim noter(strings), noteg(strings), noteb(strings) 'colors
Dim notevib(strings) 'vibrating value
Dim noteon(strings) 'on/off flag for when note key is pressed

'init all 15 strings x/y positions
notex1(1) = 330: notey1(1) = 162: notex2(1) = 360: notey2(1) = 477
notex1(2) = 344: notey1(2) = 153: notex2(2) = 365: notey2(2) = 477
notex1(3) = 360: notey1(3) = 150: notex2(3) = 370: notey2(3) = 477
notex1(4) = 375: notey1(4) = 162: notex2(4) = 375: notey2(4) = 480
notex1(5) = 390: notey1(5) = 166: notex2(5) = 380: notey2(5) = 481
notex1(6) = 402: notey1(6) = 179: notex2(6) = 385: notey2(6) = 481
notex1(7) = 416: notey1(7) = 184: notex2(7) = 390: notey2(7) = 481
notex1(8) = 432: notey1(8) = 176: notex2(8) = 395: notey2(8) = 483
notex1(9) = 444: notey1(9) = 158: notex2(9) = 400: notey2(9) = 483
notex1(10) = 458: notey1(10) = 142: notex2(10) = 405: notey2(10) = 483
notex1(11) = 469: notey1(11) = 130: notex2(11) = 410: notey2(11) = 483
notex1(12) = 481: notey1(12) = 126: notex2(12) = 413: notey2(12) = 483
notex1(13) = 494: notey1(13) = 127: notex2(13) = 415: notey2(13) = 483
notex1(14) = 511: notey1(14) = 131: notex2(14) = 417: notey2(14) = 483
notex1(15) = 523: notey1(15) = 148: notex2(15) = 419: notey2(15) = 483

'init holiday colors for harp string
For n = 1 To strings
    Select Case Int(Rnd * 3) + 1
        Case 1: noter(n) = 255: noteg(n) = 150: noteb(n) = 150
        Case 2: noter(n) = 150: noteg(n) = 255: noteb(n) = 150
        Case Else: noter(n) = 255: noteg(n) = 255: noteb(n) = 150
    End Select
Next

'make a flake image
flake& = _NewImage(30, 30, 32): _Dest flake&
r = 255: g = 255: b = 255
For s = 1 To 15 Step .2
    Circle (15, 15), s, _RGBA(r, g, b, Rnd * 255)
    r = r - 2: g = g - 2: b = b - 2
Next: _Dest 0: _Display

'generate flakes...
flakes = 500 'number of flakes
Dim Shared flake.x(flakes), flake.y(flakes), flake.ys(flakes) 'x/y values, y speed
Dim Shared flake.a(flakes), flake.s(flakes) 'alpha value & flake size
Dim Shared snows(0 To 255) As Long
'init snowflake vaues
For f = 1 To flakes
    flake.x(f) = Rnd * _Width 'make randowm starting x position
    flake.y(f) = Rnd * _Height * 2 - _Height 'make random starting y position
    Select Case Int(Rnd * 4) + 1 'make a random y falling speed
        Case 1: flake.ys(f) = .2
        Case 2: flake.ys(f) = .3
        Case 3: flake.ys(f) = .4
        Case 4: flake.ys(f) = .5
    End Select
    flake.a(f) = (Rnd * 192) 'random alpha value
    flake.s(f) = Rnd * 0.15 + .2 'random snowflake size
Next
'make some flakes faded looking
For i = 0 To 255
    _SetAlpha i, 1 To -1, flake&
    snows(i) = _CopyImage(flake&, 32)
Next

Cls: _Display

'set defaults
record = 0
playback = 0
overdub = 0
songcount = 0 'counter for when recording
songlimit = 40000 'about a 5 minute song can be recorded
menuon = 1
fadein = 1: fv = 255 'first time, fade in flag and value
demo = 0

Do

    _PutImage (0, 0), back&

    'get keypress, play note
    k$ = UCase$(InKey$)

    If k$ = Chr$(27) Then
        _KeyClear
        If menuon = 1 Then
            menuon = 0
        Else
            menuon = 1
        End If
    End If

    If k$ = "D" Then
        _KeyClear
        If demo = 1 Then
            demo = 0
            song$ = ""
            playback = 0
        Else
            song$ = demodat$
            demo = 1
            menuon = 0
            playback = 1
            record = 0
            songpos = 1
        End If
    End If

    If k$ = "X" Then playback = 0: demo = 0: record = 0: Exiting = 1

    If k$ = "1" And noteon(1) = 0 Then notevib(1) = 13: _SndPlayCopy note01&: noteon(1) = 1
    If k$ = "2" And noteon(2) = 0 Then notevib(2) = 13: _SndPlayCopy note02&: noteon(2) = 1
    If k$ = "3" And noteon(3) = 0 Then notevib(3) = 13: _SndPlayCopy note03&: noteon(3) = 1
    If k$ = "4" And noteon(4) = 0 Then notevib(4) = 13: _SndPlayCopy note04&: noteon(4) = 1
    If k$ = "5" And noteon(5) = 0 Then notevib(5) = 13: _SndPlayCopy note05&: noteon(5) = 1
    If k$ = "6" And noteon(6) = 0 Then notevib(6) = 13: _SndPlayCopy note06&: noteon(6) = 1
    If k$ = "7" And noteon(7) = 0 Then notevib(7) = 13: _SndPlayCopy note07&: noteon(7) = 1
    If k$ = "8" And noteon(8) = 0 Then notevib(8) = 13: _SndPlayCopy note08&: noteon(8) = 1
    If k$ = "9" And noteon(9) = 0 Then notevib(9) = 13: _SndPlayCopy note09&: noteon(9) = 1
    If k$ = "0" And noteon(10) = 0 Then notevib(10) = 13: _SndPlayCopy note10&: noteon(10) = 1
    If k$ = "-" And noteon(11) = 0 Then notevib(11) = 13: _SndPlayCopy note11&: noteon(11) = 1
    If k$ = "=" And noteon(12) = 0 Then notevib(12) = 13: _SndPlayCopy note12&: noteon(12) = 1
    If k$ = "Q" And noteon(13) = 0 Then notevib(13) = 13: _SndPlayCopy note13&: noteon(13) = 1
    If k$ = "W" And noteon(14) = 0 Then notevib(14) = 13: _SndPlayCopy note14&: noteon(14) = 1
    If k$ = "E" And noteon(15) = 0 Then notevib(15) = 13: _SndPlayCopy note15&: noteon(15) = 1

    'update note on/off flags (trying to prevent fast note buildup playing)
    If k$ <> "1" Then noteon(1) = 0
    If k$ <> "2" Then noteon(2) = 0
    If k$ <> "3" Then noteon(3) = 0
    If k$ <> "4" Then noteon(4) = 0
    If k$ <> "5" Then noteon(5) = 0
    If k$ <> "6" Then noteon(6) = 0
    If k$ <> "7" Then noteon(7) = 0
    If k$ <> "8" Then noteon(8) = 0
    If k$ <> "9" Then noteon(9) = 0
    If k$ <> "0" Then noteon(10) = 0
    If k$ <> "-" Then noteon(11) = 0
    If k$ <> "=" Then noteon(12) = 0
    If k$ <> "Q" Then noteon(13) = 0
    If k$ <> "W" Then noteon(14) = 0
    If k$ <> "E" Then noteon(15) = 0

    If k$ = "P" And song$ <> "" And demo = 0 Then
        menuon = 0
        _KeyClear
        If playback = 1 Then
            playback = 0
            demo = 0
            overdub = 0
        Else
            playback = 1
            record = 0
            songpos = 1
        End If
    End If

    'if playing song...
    If playback = 1 Then
        'grab a note from song$
        n$ = Mid$(song$, songpos, 1)
        'if last note, turn playback off
        songpos = songpos + 1
        If songpos > Len(song$) Then playback = 0: overdub = 0
        If songpos > Len(song$) And demo = 1 Then playback = 1: songpos = 1
        'play note
        If n$ = "1" And noteon(1) = 0 Then notevib(1) = 13: _SndPlayCopy note01&: noteon(1) = 1
        If n$ = "2" And noteon(2) = 0 Then notevib(2) = 13: _SndPlayCopy note02&: noteon(2) = 1
        If n$ = "3" And noteon(3) = 0 Then notevib(3) = 13: _SndPlayCopy note03&: noteon(3) = 1
        If n$ = "4" And noteon(4) = 0 Then notevib(4) = 13: _SndPlayCopy note04&: noteon(4) = 1
        If n$ = "5" And noteon(5) = 0 Then notevib(5) = 13: _SndPlayCopy note05&: noteon(5) = 1
        If n$ = "6" And noteon(6) = 0 Then notevib(6) = 13: _SndPlayCopy note06&: noteon(6) = 1
        If n$ = "7" And noteon(7) = 0 Then notevib(7) = 13: _SndPlayCopy note07&: noteon(7) = 1
        If n$ = "8" And noteon(8) = 0 Then notevib(8) = 13: _SndPlayCopy note08&: noteon(8) = 1
        If n$ = "9" And noteon(9) = 0 Then notevib(9) = 13: _SndPlayCopy note09&: noteon(9) = 1
        If n$ = "0" And noteon(10) = 0 Then notevib(10) = 13: _SndPlayCopy note10&: noteon(10) = 1
        If n$ = "-" And noteon(11) = 0 Then notevib(11) = 13: _SndPlayCopy note11&: noteon(11) = 1
        If n$ = "=" And noteon(12) = 0 Then notevib(12) = 13: _SndPlayCopy note12&: noteon(12) = 1
        If n$ = "Q" And noteon(13) = 0 Then notevib(13) = 13: _SndPlayCopy note13&: noteon(13) = 1
        If n$ = "W" And noteon(14) = 0 Then notevib(14) = 13: _SndPlayCopy note14&: noteon(14) = 1
        If n$ = "E" And noteon(15) = 0 Then notevib(15) = 13: _SndPlayCopy note15&: noteon(15) = 1

        'seret overdub for recording extra notes during playback
        'overdubbing must be turned on during playback using K key
        'only records note keys, ignore all other key presses
        If overdub = 1 Then
            Select Case k$
                Case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "Q", "W", "E"
                    leftside$ = Left$(song$, songpos - 1)
                    rightside$ = Right$(song$, Len(song$) - songpos)
                    song$ = leftside$ + k$ + rightside$
                    songcount = songcount + 1
                    '_KeyClear
            End Select

            Color _RGBA(255, 64, 64, 255)
            Locate 1, 1: Print "DUB";

        End If

        'allow secret overdub under playback
        If k$ = "K" Then
            _KeyClear
            If overdub = 1 Then
                overdub = 0
            Else
                overdub = 1
            End If
        End If

    End If

    If k$ = "R" And demo = 0 And playback = 0 Then
        menuon = 0
        _KeyClear
        If record = 1 Then
            record = 0
        Else
            record = 1: song$ = "" 'recording fresh song
            soundcount = 0
            demo = 0
        End If
    End If

    If record = 1 Then
        'only record note keys, ignore all other key presses
        Select Case k$
            Case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "Q", "W", "E"
                song$ = song$ + k$
            Case Else
                song$ = LTrim$(song$) + " "
        End Select
        songcount = songcount + 1
        If songcount > songlimit Then record = 0
        Color _RGBA(255, 64, 64, 255)
        Locate 1, 1: Print "REC";
    End If

    'update all notes vib value
    For v = 1 To strings
        If notevib(v) > 6 Then
            notevib(v) = notevib(v) - .35
        Else
            notevib(v) = notevib(v) - .1
        End If

        If notevib(v) < 0 Then notevib(v) = 0
    Next

    'draw all strings
    For d = 1 To strings
        PluckString notex1(d), notey1(d), notex2(d), notey2(d), notevib(d), noter(d), noteg(d), noteb(d)
    Next

    'update the flakes
    For f = 1 To flakes
        _PutImage (flake.x(f), flake.y(f))-Step(30 * flake.s(f), 30 * flake.s(f)), snows(flake.a(f))
        flake.y(f) = flake.y(f) + flake.ys(f) 'lower y position
        'if flake goes off screen below , make a new flake above
        If flake.y(f) > _Height + (flake.s(f) * 8) Then flake.y(f) = Rnd * _Height - _Height - (flake.s(f) * 8)
        If flake.x(f) < -(flake.s(f) * 8) Then flake.x(f) = Rnd * _Width + _Height + (flake.s(f) * 8)
        If Int(Rnd * 3) = 1 Then flake.x(f) = flake.x(f) - (flake.s(f) / 1.4)
        If Int(Rnd * 3) = 2 Then flake.x(f) = flake.x(f) + (flake.s(f) / 1.4)
    Next

    If k$ = "S" And song$ <> "" Then
        sng$ = IBOX$("SAVE FILE: ", 12, _RGBA(255, 64, 64, 255), _RGBA(32, 0, 0, 165), 0)
        If sng$ <> "" Then
            Open sng$ For Output As 9
            Print #9, LTrim$(song$);
            Close 9
            msg$ = IBOX$("SAVED:" + sng$, 0, _RGBA(255, 64, 64, 255), _RGBA(32, 0, 0, 165), 2)
        End If
    End If

    If k$ = "L" Then
        sng$ = IBOX$("LOAD FILE: ", 12, _RGBA(255, 64, 64, 255), _RGBA(32, 0, 0, 165), 0)
        If sng$ <> "" Then
            If _FileExists(sng$) Then
                Open sng$ For Binary As 9
                song$ = Input$(LOF(9), 9)
                'playback = 1 'auto play after loading
                record = 0
                songpos = 1
                Close 9
                msg$ = IBOX$("LOADED:" + sng$, 0, _RGBA(255, 64, 64, 255), _RGBA(32, 0, 0, 165), 2)
            Else
                msg$ = IBOX$("FILE NOT FOUND:" + sng$, 0, _RGBA(255, 64, 64, 255), _RGBA(32, 0, 0, 165), 2)
            End If
        End If
    End If

    If menuon = 1 Then
        If demo = 1 Then song$ = "": demo = 0 'stop demo if playing
        record = 0: playback = 0: overdub = 0 'stop these too
        Line (220, 120)-(580, 480), _RGBA(32, 0, 0, 165), BF
        _PutImage (200, 100), menu&
    End If

    'fading in first time
    If fadein = 1 Then
        Line (0, 0)-(_Width, _Height), _RGBA(0, 0, 0, fv), BF
        fv = fv - 3: If fv < 0 Then fadein = 0
    End If

    'if quitting...fade out to black
    If Exiting = 1 Then
        Line (0, 0)-(_Width, _Height), _RGBA(0, 0, 0, ef), BF
        ef = ef + 3: If ef > 255 Then Exit Do
    End If

    _Display

    _Limit 60
Loop

System


Sub PluckString (x1, y1, x2, y2, vib, r, g, b)
    'calc middle control points
    cx = ((x1 + x2) / 2) + ((Rnd * vib) - (Rnd * vib))
    cy = ((y1 + y2) / 2) + ((Rnd * vib) - (Rnd * vib))
    oldx = x1
    oldy = y1
    For t = 0 To 1 Step .001
        curx = (1 - t) ^ 2 * x1 + 2 * (1 - t) * t * cx + t ^ 2 * x2
        cury = (1 - t) ^ 2 * y1 + 2 * (1 - t) * t * cy + t ^ 2 * y2
        Line (oldx - 2, oldy - 2)-(curx - 2, cury - 2), _RGBA(0, 0, 50, 25 + (vib * 5)), BF
        Line (oldx - 1, oldy - 1)-(curx - 1, cury - 1), _RGBA(r - 32 + (vib * 2), g - 32 + (vib * 2), b - 32, 25 + (vib * 7)), BF
        Line (oldx, oldy)-(curx, cury), _RGBA(r + (vib * 3), g + (vib * 3), b + (vib * 3), 50 + (vib * 7)), BF
        Line (oldx + 1, oldy + 1)-(curx + 1, cury + 1), _RGBA(r - 32 + (vib * 2), g - 32 + (vib * 2), b - 32, 25 + (vib * 7)), BF
        Line (oldx + 2, oldy + 2)-(curx + 2, cury + 2), _RGBA(0, 0, 0, 25 + (vib * 5)), BF
        oldx = curx
        oldy = cury
    Next
End Sub

Sub UnExplodeImage (x, y, image&)

    tempback& = _CopyImage(_Display)

    pixels& = _Width(image&) * _Height(image&)
    ReDim PixX(pixels&), PixY(pixels&)
    ReDim PixXDir(pixels&), PixYDir(pixels&)
    ReDim PixClr&(pixels&)
    _Source image&
    pix& = 0
    For x2 = 0 To _Width(image&) - 1
        For y2 = 0 To _Height(image&) - 1
            PixClr&(pix&) = Point(x2, y2) 'pixel color
            PixX(pix&) = x + x2 'pixel x pos
            PixY(pix&) = y + y2 'pixel y pos
            'generate random x/y dir movement values
            Do
                'assign a random x/y dir value (from range -8 to 8)
                PixXDir(pix&) = Rnd * 8 - Rnd * 8 'go random +/- x pixels
                PixYDir(pix&) = Rnd * 8 - Rnd * 8 'go random +/- y pixels
                'Keep looping until both directions have non-zero values
                If PixXDir(pix&) <> 0 And PixYDir(pix&) <> 0 Then Exit Do
            Loop
            pix& = pix& + 1 'goto next pixels
        Next
    Next
    _Source 0

    'compute putting all pixels off screen
    alloff& = 0
    loopcont = 0
    Do
        For pix& = 0 To pixels& - 1
            PixX(pix&) = PixX(pix&) + PixXDir(pix&)
            PixY(pix&) = PixY(pix&) + PixYDir(pix&)
            If PixY(pix&) < 0 Or PixY(pix&) > _Height Then
                If PixX(pix&) < 0 Or PixX(pix&) > _Width Then
                    alloff& = alloff& + 1
                End If
            End If
        Next
        If alloff& > pixels& - 1 Then Exit Do
        loopcount = loopcount + 1
    Loop

    'Now do the visual assemble of pixels

    For a = 0 To loopcount

        Cls
        _PutImage (0, 0), tempback&

        'display all pixels
        For pix& = pixels& - 1 To 0 Step -1
            'pixel x pos, +/- dir value
            PixX(pix&) = PixX(pix&) - PixXDir(pix&)
            'pixel y pos, +/- dir value
            PixY(pix&) = PixY(pix&) - PixYDir(pix&)
            '===============================================================================
            If loopcount - a < 3 Then
                PSet (PixX(pix&), PixY(pix&)), PixClr&(pix&) 'can use this instead of LINE below
            Else
                Line (PixX(pix&), PixY(pix&))-Step(3, 3), PixClr&(pix&), BF
            End If
            '=================================================================================
        Next
        _Limit 30
        _Display
    Next

    _FreeImage tempback&

End Sub

Function IBOX$ (txt$, limitnum, fg~&, bg~&, delay)

    'This function either gets user input or shows info.

    'text$: Your text to show
    'limitnum: how many letters of input to get
    'fg&: The Text color
    'bg&: Background color of box

    'If limitnum is 0, it just shows info (message box),
    'and in that case an optional delay value can be used.
    'If delay set at -1, it will wait for keypress to close.

    textsize = _FontHeight

    '=== Save whole screen
    Dim scr1 As _MEM, scr2 As _MEM
    scr1 = _MemImage(0): scr2 = _MemNew(scr1.SIZE)
    _MemCopy scr1, scr1.OFFSET, scr1.SIZE To scr2, scr2.OFFSET

    '=== find center cx/cy of screen
    cy = Int(_Height / 2)
    cx = Int(_Width / 2)

    tl = (Len(txt$) + limitnum) 'total length of letter spacing used

    x1 = cx - (Int(tl / 2) * (textsize / 2)) - textsize: y1 = cy - textsize
    x2 = cx + (Int(tl / 2) * (textsize / 2)) + textsize:: y2 = cy + textsize

    Line (x1, y1)-(x2, y2), bg~&, BF
    Line (x1, y1)-(x2, y2), fg~&, B

    Color fg~&: _PrintString (x1 + textsize, y1 + (textsize / 2)), txt$

    _Display


    'if just message...
    If limitnum = 0 Then
        If delay = -1 Then
            a$ = Input$(1)
        Else
            _Delay delay
        End If
        IBOX$ = ""
    Else

        'else get user input

        entry$ = ""

        Do
            a$ = InKey$

            If a$ <> "" Then
                '=== Return exits with data
                If a$ = Chr$(13) Then IBOX$ = entry$: Exit Do
                '=== ESC cancels
                If a$ = Chr$(27) Then IBOX$ = "": Exit Do
                '=== Handle the backspace
                If a$ = Chr$(8) Then 'Backspace goes back a space
                    If Len(entry$) > 0 Then
                        entry$ = Mid$(entry$, 1, Len(entry$) - 1)
                    End If
                Else
                    'add letter entered, if not over limitnum
                    If Len(entry$) < limitnum Then
                        entry$ = entry$ + a$
                    End If
                End If
            End If

            'refresh background
            _MemCopy scr2, scr2.OFFSET, scr2.SIZE To scr1, scr1.OFFSET

            Line (x1, y1)-(x2, y2), bg~&, BF
            Line (x1, y1)-(x2, y2), fg~&, B

            Color fg~&
            'use timer to simulate a blinking cursor
            If (Timer * 2) Mod 2 Then
                _PrintString (x1 + textsize, y1 + (textsize / 2)), txt$ + entry$ + Chr$(219)
            Else
                _PrintString (x1 + textsize, y1 + (textsize / 2)), txt$ + entry$
            End If

            _Display
            _Limit 30

        Loop

    End If

    '=== Restore the whole screen
    _MemCopy scr2, scr2.OFFSET, scr2.SIZE To scr1, scr1.OFFSET
    _MemFree scr1: _MemFree scr2

End Function

'==================================================================================
'   FROM HERE ON ALL THE CODE IS JUST ENCODED MEDIA FILES THAT THE PROGRAM USES
'==================================================================================

Function N01$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(11801): a& = 1
    Mid$(A$, a&, 160) = "0O)?-zDe>L3^I[V[)fYKI3\b>(6iHKJ1ChdB;]|vW'G(W0+oNUw,[qwK\{eE]qm'pfG,j3.5:J=Dx-Zi\uP>k8f+gOgP{<EGu,/9aP?|S:G{qMl*r(xoeb7'OSp'PfEG_zJAL9vku]z='0'jJ-zl^pK=D=Mw,8rR": a& = a& + 160
    Mid$(A$, a&, 160) = "StF3E1\p*kAb3\M-)w'7GU_UX7)8W560h]9e71sA;+p+Yi9V{r:amij)(FMI??>XDA5YMI3U.HqBYf7iJA4q/N5EgIhpTP7\E4swLV^6eMg,J'(rm5MS'5/-T=XAHxWI']qHK]_[^xW/(eO?[SDVo}Ndog']/Hp.": a& = a& + 160
    Mid$(A$, a&, 160) = "7-6(Pt6yOcc''rRJ>weH'ezU'^:{D*RK:R{bFCoj^H+FSbSM,NWp82?3LOxqW['RId23LMXWX]Sj6ioX*2P847Ope*W\5Oxom[7\dw?4]xi/?_Z<,|\ZC,>{x:AvQOZa3)767DO'N9CKZh'.c(bQgtv^wGNuX1A/": a& = a& + 160
    Mid$(A$, a&, 160) = "KDwai4K7agMW8V=N{<Ef6R4s+;[Mg4Pq8EZu^Wf?DqOlPR(9NsBU}h>y^='B;-LHOuZ3GK)e=1y)Gsth2J_8=S4mr=W+-IlDJE06U/5gA}V\BT+=hmBk(1hv32rQUgidmOI,2gOo:r>NglAD-^3;\EYFoj*>n(8U": a& = a& + 160
    Mid$(A$, a&, 160) = "9YuqyAXh{Md?V:PX\F.{VJ*p.n_UdBSKw(,fMNrfV*|'xhbKRB)8sKK?uiR1(C<9CUst\C5K]pKD:A1I\*T/]G[lC\xbORkyud'ab.P-xRiQe85-2/Ssvf3kA9yAnTYlskBCjxomy2}[rw(]UMz8[jH6.X.4_'i'": a& = a& + 160
    Mid$(A$, a&, 160) = "_m}\oC-{,spNZpAnn/4(u^X?C_qTo,M,UY66Dc7Btr_-}Lbt3z=U]}7JEtRMJ2c(gJzVM1K?XnZMxZ?Z3ERbhtX80^x]<vuA>3*<L=V7MLFV43l2I|3'cqXTJCkEs^8Ecd{J4}ySL=L53AtG0N0gUQL+.:A0[fI5": a& = a& + 160
    Mid$(A$, a&, 160) = "6r6D}B,:yK2inzNIOd.=lLwDr^7(IYJUwY2L^Ex08:RxgtZ6rc45d/kKw>m\7j4OuNH)etN*mwK.JG+Y3E+nS,-+)7eIfd:=[W9cPNC4/UFW/}6QvX,dPc862jU9\g=9|JURk'pCp8YY4-ji]ukI[PL6E,aNtS;.": a& = a& + 160
    Mid$(A$, a&, 160) = "U''W+XkLkvOPyW'xXSHP_V.Z|/9+w8IX7yte-q|KO(6QRDYBU8c*biz8NU+-vt4qjQQWk1Gu(u*FOik4q)8iq?HYx_.Isy^DV=2;.j,Xlr:dT;8dpc=8OBr'}?T^hES:x3ZH2y,dYSZoKN5eYuhK</JeQe?jZV'O": a& = a& + 160
    Mid$(A$, a&, 160) = "jsM6=pk;bW]Nsm8o3*^E}:ZH/j)WyP)wnY^369mT{/J;Aw,Qcx?/)}o9S:*a7Nvj.fWx(6h^J71dlz]}OOplL}:oM_lz7izEdgO<}5hT;Jr)pwGg^C=HX,SgkU77_cwjL:>>z0?/ybg}|(vpY0kSps|C(.ZKSj7/": a& = a& + 160
    Mid$(A$, a&, 160) = "ZVl5wU8;AHyD_7J25k/7,:++]Q5VRAJLqQCl3q*X9?RW]HCJF{:(Md}HhgU*vc+A1qIWB.y[Zh23w?8y,HT:H1O9UofqW8j2a<NMsb1rai0e/TNu}1><{<]HwU;aW'F\AjhIa=BG*nXN:Ew<Fr0xchnd<v7R.Wrh": a& = a& + 160
    Mid$(A$, a&, 160) = "T9*z6kfTleRU'Az[-<ycjR[uM48;A<q7M/^]8wQ5A;Z,'0qbf5BEvIJF*2X:etNkU*TzIX88vjM8Uj9We/t[QI;VV^PHH3{Q6k6RSlNV:1_hYv['g'=q<kMDQtoR'dpz7ajOjC+^w'4hqGg6OpCTNdpWRB[KVWAb": a& = a& + 160
    Mid$(A$, a&, 160) = "x(Znw>898qvk'ir,'7GK}I6c-Labs^Z'IvQ;w/Rj/jzr'UNhSXVv<pLhox:+iF-{''XJ48][1JFyBi2y?Ad_Z1=?E4\{/X>G'(|(p*buW4iXtt+oXYgPG1WS=?^M-*6Qu{D5Bescjc?duC:B1mts+*pR7=W:>+ci": a& = a& + 160
    Mid$(A$, a&, 160) = "l4*(bh0pUHi)y;_Fq7poatf*GB7]Sk*4knX|3Fu7cCo09Ho*mJw]cVQ2[CS^IZi;P,Hu2[VI/GRXd{+KZIZT\):Wkp.I^s<B:ik.sU1Ii_A/Z)<ltjE1M=o<MpEO0=v3Y:}X10FjxLx5(iBRfyoz/EJyYYv7=LX}": a& = a& + 160
    Mid$(A$, a&, 160) = "=[T{+Hf7/V>YODD_5AnRU8),*T:[XT8G_z5CH2WMwoZnf-D|)PZ-.X'}*v+oFU;fwol;wL/MJ3SOB/TM284OqZ2Ikgu>treGb5c1be3azvzcbG?q(Zq3,tSgXb=.Al>QXDUrJ_'</RJni<li7dlM.PqQXeCjG={-": a& = a& + 160
    Mid$(A$, a&, 160) = "L<Q,*U8^}Vffh9,'B<=(cC},BAt{a|t4[<jVWpL'Q5FtatsfZpBDyAzlnjG,Ct;3dEE3Mu4],E>oi7oXBaTy}xZy*o3+x:EjN8}yL,]W6Dt.IrbEDSd1uutgPbt}cXP}Mo+334>}8PRv;^*0-wbqoMPXv>0DoasW": a& = a& + 160
    Mid$(A$, a&, 160) = "Im,I2CCD2Da:?X?Rlp;NI+<_qP:wEI_Pr__yeDxAFGmBMb4yKMDf57.O/[8r2>BLX\P9w?A;\Z<H\0Q'5F]-2FuaGf+DpgXE7ZW9-jx'fSZ5(}Dh/qI\-vqSRSoB2_.zoZBzcmZRDj'^9pU?[+uN[pPX8:JiX9eu": a& = a& + 160
    Mid$(A$, a&, 160) = "Xon;/{R0j-,=>bcl\a^L,O3ir'=,d\Mx-CJAB.:3*IYauOPgm=,]8WEq7E8QDHhiYz>_M9t5QtBsIZ{a:xU?owO=)t:6<b{^S,i9FSl>:)hzzn?qQdsE.ul8zh'i)tQYp0Kytr*\mzON([U_nTC/f]q'}aZt]TOd": a& = a& + 160
    Mid$(A$, a&, 160) = "4_M,/,;]hC*8,TTFFO|H+GLf4UmL-r5V3\S|;D1+/)>A21F83/Vfy2QG-1CQIY.HBzxRprAjR3G*q}q[UQn.B<FYX)H/WpLZiNpXHAF+P.N'ffmGd{-Xg:GJQHK.TXt-^LIQka{l]c)+BE5[n{2SuDb((339+]IX": a& = a& + 160
    Mid$(A$, a&, 160) = "Q.]P=S.>IDCm0/d:9LPlv0bL^3*f\Mlg.iRjBY3AGb1/)c:(9i_DKbG;'Fw>Glvo+u]/xgP^q5tv4qYdn\>(/qY:zw6^9UbvPssZ}RvG-FTb*kbA_0Y75Ej2<JFkxvJyjO|6:2mZeD:LG]rMu/Z*Z*]_5qB7WKFR": a& = a& + 160
    Mid$(A$, a&, 160) = ",4i1*<D+E7{.8*2j'ZX5SqGuAsoO,tem9KfIw/5O+598La?qH*(RD+5_\/N26J/2^Q[0{.,l{7O]P0[7>rZmH>9R(_RyYG,R,,[|jkl2HkCHdY=_>N-Zbn<u:u4>5|]zN<eEW|nAZpJst.|/r.xXDD,c8=of(}pk": a& = a& + 160
    Mid$(A$, a&, 160) = "dh}JYR01yLH{--6dhH]gHmhs)zBv9XVYxiH\?\2Ggwg+wEq4FVi:Cs}(=V.yjQSk\+/2fGtGN57W6V:f7XqBQi9ORq'CK[{8f[G,YZ0WUGsj?sK?5b;^]v)8P+*B(.bQVf8CPauvqQq>vn13TR>zgRk\-Dp63yG:": a& = a& + 160
    Mid$(A$, a&, 160) = "QH'1hK<7^KvdiNHh:;IOVn*c5j5Oea37[W{0tEEvmJ*m4aoPb*08R4Yd5LAC|+HA4fr>9)vcFnnR;2E\d]oq]|G]-lP^alGL1ISNxe^z,d>B-{+rwxAc1(j?+-T+8o[_,jY+9Wcrp<)|JtY56fD^aoW=U6Zx(rI,": a& = a& + 160
    Mid$(A$, a&, 160) = "e:.\'-yvbYZcwm/A)F7T1A2Cf'a8r2XY=}*xEsoh,1SgVsR)nZqL<;,=0:p.x-2>E7Bw.3nzMhe:d'DWP<'yJOD]J^E*Rh8J^0gi.aNgrk61P[SjzH3*-3;?fL2ZZ3i:XH{y;Q{FdR]Mp1juF;QmO(jyoPfN0z}1": a& = a& + 160
    Mid$(A$, a&, 160) = "tf/[Wb7mkRT4U=3HZwlz*>+,Psj21'_HAgt\3^h=Wt>vcDH6+e\One|7jF<jcANWC?u^7H0zf5}AZu6?N0qG)ccZX[Cg4TaDr.Zl1B:JjYUs?vj\-WZ3<i0]-ExWKGYCWu(A?L1?Fx+3Lnis_+F.1_[YdaGk1JQ4": a& = a& + 160
    Mid$(A$, a&, 160) = "iFw8}VygcA]?1.*TCK8LhDJ?c<)Lhc,hdv<OX0(8Lut;ZP0>HHJffJ}zS7a?w>VgM5a8cOT.4FEpl0,X^'Hl=+5P|U_4rF7N1RHy8i3\uR(Ae.WmmIC/([wfWRR-,p6^DHv2W}j5<8)C1j<)5e1WjwfMqI/]mpuR": a& = a& + 160
    Mid$(A$, a&, 160) = "1oRPe,l>0X_sC\]7(8r[7OjV^SaT*D]HPjth<6ROhaaeu8.rD9=u:VOfs4|:/N41589UxQa<eyp*iQVI471nzT5t>hdG**X:JOEdaE^d*XFW:bCtf.or^}8nrr;[jXDkK*{<*57t;tBBK8n;[26x:CoqQUaNjmEH": a& = a& + 160
    Mid$(A$, a&, 160) = "RUp|<UE'AO0J5[z9YGg+},4I55*aOl7qfZHN(aP{lMZ:[EkaS.EjT}jezw(cUExr-KX0+P{I>'rxVWwyg1t'pu/H2D_Ay:ufdn{ET1Hx8V+a8TnA<]l^PEV=34kTI2jiUpJx7{P46DxZLgZ98}4|8;1irhKs+*fy": a& = a& + 160
    Mid$(A$, a&, 160) = ">'>h[iCD=IVT^Uh//R?f/UFBzMP3_MN7{nF5Kir+odDt],N>}1n,J>K8Fes_TLTdJc)-T<JN:rtFD(MdTEmN'{=zaDcLX6a,'[2y<GXN?+TW|pb5Cu;Bk0S\UV4Ya6dMP7e1i,i{:b:^.ECn'?D'M5WBkci[ws42": a& = a& + 160
    Mid$(A$, a&, 160) = "'/2bAzMV41JHYOio_je4/]9_ynvL|kr\J_<q_XUi+=CN/1g9QtB^,wwLNa/861WQ(o8;TN5bm7^NDa?WHa+(0W>/MbqJt]h:2E'hA'+Ragvb1l::NPo*0;n^nJ4sAjH/bq}=up)Q+A}|5*it|+;kK\rozh?w(Q3}": a& = a& + 160
    Mid$(A$, a&, 160) = "CmMw}E.7t2l)RIu.C:Q<^>.*f.d>DIt?+y\Hgp6AH1B)Ri\/CRt(LO}PkDEu+Ujw.KzohG>-H01?7qhde4rAu0M^JUEm\fhuLQ|M_vbWA-P3yPIqgoh'9oRtydX8tc{0(igqc4/^:V4.rhfJ|8x2/5.,=feZC0WF": a& = a& + 160
    Mid$(A$, a&, 160) = "/Dnx/|ZwAo^Nb_;*1nkw?S-yoH-},s+B,zo5SuSs]FfoWG-HjZh;v{<hj)[lnCa{TIR'X_Ir=PsD+1S8F;n\NJfWFdas:T{\KC/DXMaG|P\MA-[Qa_,Fs6Qdfii9mX+p;wBkVU2XR3n\0]MDK?0c-WXgFPx?H?+9": a& = a& + 160
    Mid$(A$, a&, 160) = "\C4]fjG-<P,_{/7Cps4Re+U1{O.QB208Cm:vG68(LabvJKJdYZB'L8DLc9.8M,J^eI/Yjh,[';_*z0YH).).8TBSLBHSdzzK:tkQ7T[Wc4^H*B:nhrrq,[ht-p':/\^{g3gaIQINcbRoRs}=[aOkG1mG3YWQlR^w": a& = a& + 160
    Mid$(A$, a&, 160) = "f(s5s8:00bB^Liz>h)Qt=,;Re<_W^JAlUm7xPPYCr,Qq'\1\gV*yc>WH>0}S6)ifc-koOT,Z\t(|UUC.}ZEevs4893](Xn[mDF80T[(g4|wq4b7pyY2A'/t^y-rAjKduhjqn?>YTjz=2|{3)5rI?l,NWz0,ISDqi": a& = a& + 160
    Mid$(A$, a&, 160) = "SBc:Bc-R(<7,iLIJqxfWBglbUV7paE}<ISN(K7=3-DyKJC838_c?''L<GW/18Z/SO,vW\B+lbfClB++[W\G?tlj_=cqk*xMu7v|2pW,.:U]2DUMnw03-s|+U//TZdg/tfoNXl{;C:+')Wl))IO\r]aY[,6+anRRj": a& = a& + 160
    Mid$(A$, a&, 160) = "O2GYLC6M38IgxK3*rlHjLnMHiU*iER'Zb,,x_Stdsvqv|Kd==j-e68CD>dlb-6Sp\F0;mw}^-e-i[w>QaD>=jy;_M)hf>k<.'raI,.)9d*8LzEW)qbqF{)I[r,Y,L,sMp?21xCFKtZ1=xrj)9Z/-iZ,YD8])]huK": a& = a& + 160
    Mid$(A$, a&, 160) = "2Y?hq}nrXQRD>w(-LWk:fHFWIVVnL*;V<VWQ;l>h:wq>;EzRo^kRd_os+ae'F[GXp:piMe9U.vyNYv.zTZzZ5wKP]4>=F\8I)R4]v*;l'(Fi0=5xIWoboy7kE4caqZ5EYI+KsuC}C1AsI0heLrQDR88qsL.bp5/k": a& = a& + 160
    Mid$(A$, a&, 160) = "g<YH4RdQOGGX\ZoPlD)k8p(f->1K9+2){pBDw((ofIM0O..2w6U_:*;z:hcqX[M6=M9KrY)r7)L?Lxsn5o>MZ<G7/4JGn0iu_R7/B48.Zt15.3bcZqo=EJ?'dQ_7qLUL+v|^S\R^b(e8cx}_*Bklgp<'U^loH,PN": a& = a& + 160
    Mid$(A$, a&, 160) = "T.m6*>]GvD:-{Q[o0CW;1Zlwm6sQjSidihJxxuK48qr+0WlhiWTXg.:doeyV]X3:|:ws.<O:v6w3V{qz6uoct_]C*/g'Vw.K,48|eBBjW<fE-BaFx:]<F[_]aCZV^Rh+-RVM0KpmnwVaJWBx<_.6(R8Zy,wIM\y-": a& = a& + 160
    Mid$(A$, a&, 160) = "T5qS4]^Xbdg(<fHtUj-DK2UZgM>WN?g7*y3F8Z(bTkdwC;wmZi9vfi+d:XCM,Q/4Se)*\F;.Mt/NFR+{,a}{HB,IfiBJq,w.>\C(tb37R27LqXNQ5gde.S5zFC1D|s75BuY;7ZUgf,2c46NhUBo7^}Cirt=/FH'3": a& = a& + 160
    Mid$(A$, a&, 160) = "TIbR{:?Y.7V)p'6\Gpw2LiqEf2Xue{FEtjVT(6+f5zmGt2cn*)rJ(dr9O+-HZ6F6S__?746:mQ/sfcht;kdfU]/|vQvv-q>Q]p2H1+:ykT6f)Q)D*rkQ[VndG\gaDw+hB5XUNrl8o'[9i,/{_Nn|]H<vy8Su:[[n": a& = a& + 160
    Mid$(A$, a&, 160) = "Vp6Q|D3j7DoExM,574OkY1LYeFSEj<<C|G.}7-nB3,qfnUCJag,Y5>P_UK1j<eg[hC.F6VxEl_I=/P}paM)qezJVueJs=M{2T}:RBLNDT/FH5aURkbkt,BSU0D4aS]]PAa8tG+}LdB]X[X[YT*^mJv^pEojNAfc}": a& = a& + 160
    Mid$(A$, a&, 160) = "r<hX7KFrcX70.sMTu)rlsww.rv=|DO[qn5z,My2TVr21u0^nNtJO/I5o;dzXz^|p8pku*((2o^SNIWs]Z(e)<w*TFL-]TMNvSKr:w'w^SzKl^t'jw/}d2f*yZ>n)m9MFa(.fBiCRF14k[l41j-:H[r:h|]LG7V)f": a& = a& + 160
    Mid$(A$, a&, 160) = "hBkQ9d>FJ/jDz0m]E6ID53(U2o;}i-kY0s>]csQ6{X-vmqw]>eQAYEPqwgLNNZzm)4Qym:0'25G\9oav(sHINv_yhK)mkns.e(40F2*xU]>jw^Q;Z\4oA*krH4d?vdwqC?9nZVHY\Q8lw,UK{3aEiYwQ<P-B:1H6": a& = a& + 160
    Mid$(A$, a&, 160) = "kYy<TN]NkKYbA50OqyHzR[F(*|.p5uc0yp8n'4QqV?oihvrJBZ(B^daqLl9>^hdqV{'2H):.Qvg_T>d}3pvYg?47]=:S7E(.+y6'^\Q]VsRx:KD95Z6CO^QhWAUEM52yqwk3M^e\cdeCY+JZk,KZy5CmX-N<?C^z": a& = a& + 160
    Mid$(A$, a&, 160) = "XYA_2<8eZ;(N6Z>i3:DJv<2a0YVEV+:TIyIlJaRl7P|u<IkpO2T5,ZY(A)>Nse/MwkW'Sy}jAr/FI-ExOZ<zrCz(XBBG*TH7OUNd0tAUtGW95,7_3SSwcddYOte;o_2JDy;eDyAhYG7[)1)u)Iktl}X6]IzIUkUF": a& = a& + 160
    Mid$(A$, a&, 160) = "SmPowJ,/Q(HL^[FfSk8{}uBlSX'|;9q=he4JpAL5)K7,UFoFx93)<)vyKtawGq^v}19|4xY^ZyqiY3A*w2RWwxp]j.}o6pu4uDbbJ(Po0SU+GHc6ulqdwto>jkRKOW)-=zbAHq{Zc4{kf(O/p;ttXjsu0CNzZ_EC": a& = a& + 160
    Mid$(A$, a&, 160) = "TEXmjskZ4}Qa[e?K2X2fwnB-'CHkFWz;XEpbo2CUg6t/^?l4\NzHx*uXOZgX<qdy.)E:/>_Om7Z(/gOi\10(GHNsiNpCP1fW-b0z9K+GhGOD6hLnoo(*KepyJ1dnBVa;Oa^6kTcUg''Jhc}\,|K1DIdQu>|^D-Ob": a& = a& + 160
    Mid$(A$, a&, 160) = "IbAZL;*j'Wz]p+b[yjIo>N1DDn8'UuNpu}\iw-YxwTTO[C<AH6ybHeIMtnZUujLjz+UU9gvR,\hS_)jkPb;^soY|84{:DN::ZPvv,Dd2O>]03J[;3ghAq;{y}HSwPd[D2fvvMo67\)Ty|ar-g}Vkm}]TGkbe?ZF^": a& = a& + 160
    Mid$(A$, a&, 160) = "v*9Yj9c6C|Im;cLjumq]iZ=f>L'93/=f{{30zm,Kng|On:zrfq0'GzsX(cRa(tKGgWYA<Pc'kiDIG1kfqhd>_wedW]hmFdYo-81phyw.|W(;gzVJRydJcXAE0JOO;'Fhv\\?e;?j2n\Fu]\Iilc)rw).-?k>=CON": a& = a& + 160
    Mid$(A$, a&, 160) = "gZ5\CXzk?dB?O}jHI2]SfJpf\L+)z:-]ZZK}vs\eYnBo{|pC7D?(1bYrIEeM|a-A94My8CLnJsUbj2[^+mwb5iWAJOvZa2LUKytAb5PFbP.bYWqk5{Fq-XWSyrxI_z402'U.Du*XGv[JkG4yyrwddA>e=P(<UzF?": a& = a& + 160
    Mid$(A$, a&, 160) = "0;OPVBJ'4CybEqR:[_JDh+fV(=eX7eZ,UMnI4[/M}4Lh\MSxLk30WML<L*D{2AeMjaUf0b>+zelMLUTC.Gx=2b(4jHTE3O^^X(P>nZdB4zoMK*T_eT[8kNn\jX(vuy8=?qwG\a)5\(Guql,y3SB2xOEH9i6uQOOX": a& = a& + 160
    Mid$(A$, a&, 160) = "vIV4hCbSL>5ZMp0x)Ah8(rjj*yX;s'KE9a5w/*Z?KV[F=TfNP7RQJF^My?:x-.l?-VNXxnUIWKHADy>qXxESK;N47TRLd|'RgA=yaA6n7X3Vqq9pl({Zv|.jmy.+xw(bPKP/*Z>y3nih>Re:gvnFpeEpVq0LQev*": a& = a& + 160
    Mid$(A$, a&, 160) = "}mffA;Xx2WlVUGxmVch5EpVA3SBh(?>pgkk9>6B6|Ul9ytg8>jL,xc8LCG(BxzBX\SPM)SGXa13K'/kwDQ2na(s9K*IuqeI<0}TLeH1^g]mIVWvM^tY+-Vtzuid.ooP+7FN/Fhf1XeR_;/Oz6ih:=S-qX5U:=a4Y": a& = a& + 160
    Mid$(A$, a&, 160) = "FphEYmY?5)t6)W'>NFyn6vpcv,(OoFp[,A}2A8B9tBypCinQOjTIk[cy]BpCf15u<)3\27*x3,<3M=^B\4+(XHvpBQ<eq49OcPiMWJ7isfPmhStG7fItuB5j<x;x4//C6eVWmxh'C\3|S[ICDg^Co^UnPwyI?\KR": a& = a& + 160
    Mid$(A$, a&, 160) = "(e/_NqwFx,^nDE}Cz/:?Hxk-W<Co(pz_,\dUOSgV3Oh0_\C9.h'4LSF|'QegUc[PGO4{Q4?rB,Y/pkLN8VkktlXPCWfbrBPD,\;WdNF]Wpaz]j_FnE:\>_hOLh2SqVwy)}eYfTpr_<{E_bKY<EWRTKy>i|PoR*q6": a& = a& + 160
    Mid$(A$, a&, 160) = "KMEZ2)8Ln{:V],S*is7KuhB3rP8zOv477T6130dFG-1kn<q-6?+e6b+LF;_Cr**d{Z+wmt;yyOkboh5(.hxGj,0tOfgXN-x+7h0v0J?tL|O.(?m4hwv=;gi/^x01zitYpU*b,:\E[pxF-ier?8l'9+A+9whgO(xf": a& = a& + 160
    Mid$(A$, a&, 160) = "RRC0+<OCseSL[i^R=*)n(-8QBG8ba2}X([ty>1;l(,0T{-f>,f<Y4Za36Ee{]2dNbQjmoIOf6sB2t7D+kRDzA,fMM9oXbZnML5EkpnV{[j4M|GktO)*'UW{>4X|iqBd4]p'7.7ztmF2v{6BtppM>n9OvH>Tg:'8d": a& = a& + 160
    Mid$(A$, a&, 160) = "1LkmFJ1jJcoy7g93O\JgFN6W(q;M^}^?QFd.TV6B>,,Sv}GC/vyU2'g/vh[5]Ahk:)gg>^fTNy/D*6l1a55m'Mw_{{-48Nf4;?=6qd(*]rW7+L^2|^(]asz998th|p;3(C)5QT_>nvowFlTb|xZ7t[W:JV\IE]-*": a& = a& + 160
    Mid$(A$, a&, 160) = "VL-8?rx*f_*H:hD.qWniC>f/S5-dW46]DbDXgTpR6ZT3C=tFjA9OyrQ9CDCnP'v=y66<)cAvsl'GpRz:b+?O3pS8]s)J:ll6pIgTYotnL/jSlG1/XTV[ur=iBpFr,2Eb/45Dxgj>YD<+)Fokhhh3t{_ZorBMNot[": a& = a& + 160
    Mid$(A$, a&, 160) = "Th8ZMEwL[V^SS{b0[Lz<Y.S?v:r_/sCmCRY5hAO?bgmYLcX}-Pct_DODf2RuvrKCYx;>5TyEv<y_9*n=mOKe-vtyRBZRgeJelne-m-+Hn?PF(KF[W]ss4Fn;Frc-j6XRk4zb}NkhZ2:Y\i}hR*,X?FLp?XoGE9;{": a& = a& + 160
    Mid$(A$, a&, 160) = "-OZ,\vGhJY>NK3t,L<N/TYX2B*vi6xNwXI,x2cmG)LWdb^Ps|0[po5T6giajE2fM<7cLkeDXcJz8tZCLJ?Ynw(1e56'<)TadRxoA70/+8OH=.NwZtAQTX;}4bhe.,;[W'u('w?rzt47w8RK_mn+(E[15;5:?j>6x": a& = a& + 160
    Mid$(A$, a&, 160) = "y1sH|C)fw9IR.A+5V0jo;v;u-O^?W(>k9||RUuUbz/>Dl7kV_0X+CR:seCR|rkJ:YcXIvl?28'DxFkV+/xy;x8I(GoB7MYDjzly^q^Q5Xm2N7,7eNtYGm}G^vg?P0;nuG?CSe}IV^FclM(\dxIL,*9jccMqdvRtq": a& = a& + 160
    Mid$(A$, a&, 160) = "QYW.W(Si0AXHG)1i7Z{1WNb2lq/CXHAk(tkGg]cdS+DeZA)^hnwhUdycW/>xeI>^7AE-,J|T29<DY2e=>E,D|?(oe^Jv}^F++oW)F+OEiP7Jd78:{.M6Z,/gt9M\8V4CR(O1=VR,f)ncT7ho6UJ4dZaEk=*Rr;,h": a& = a& + 160
    Mid$(A$, a&, 160) = "'JA[cu,0:Cx5>Uo{8BSx3-|z{h(/qO'yuRcqoThc}79xu18z+zM1S(:+hfhbc'n[7gq[s5LDEzq(f7?PqnmI|VdJGrnx19*?1N\zKH1PaqZs)'6]-wq7aDlSHC9m;HQorh.OzG,]y\.{t+MVZlaOW^GCD]R{jVI}": a& = a& + 160
    Mid$(A$, a&, 160) = "tOBfM/VH0*9ynDb/:*Zix*RLS*Sk^Ko'WDVF]?WmzD|a[9Ll0uvL\^,CAb87m4vf^MYtCLVr<=1EhLBOg_gEa/?fL<jTzNZ*bW57x(cwQeOLjPSEqtwC7Ton8x:wfNmX[W8(0u:I2<C+{H9ucQ4E>;z*<Pv}pbgt": a& = a& + 160
    Mid$(A$, a&, 160) = "<SIT6).5:pNcmc:DlH|8J;u[]CuN{r\Aw(haC<euj9{+/<DDTm+tyeHwN6icvpcHR?1J<41C:XQiM;;,F'-bZe_*hA(NU^b*?{z8wZQIKq3mbnT3i4b6hT5-R9KW*W0xfx7C\+}_e{/G*[{N56=0?hJ:f+brGg5o": a& = a& + 160
    Mid$(A$, a&, 160) = ">z1NeN/NZItNxO)*6xIZ5]QhNi7?LWDjWPma^][Mu=l|:El>/:_5j>\aKsZ_;5[\zTRf|RJ4C(Pr3}3<]9x4bG/Q}os)yZF*p([)rnKXnOeHAPU4*\}2qTVRi1?b3PBIDt:qdH-Wx)Hl)rd>73z.e7K=<,H9N*A4": a& = a& + 160
    Mid$(A$, a&, 160) = "O*GG2bZ|Lswt=/*OqmFFnC*hOX0-_=KK'B=]r8)C'uVzdns/QTiY?\S,zt0ROHu7ewvCChn68KLKI8t-u_pbBXIUc0\Aiyh>^pN,I[]H?]*n2ceu{bvJ9]4Zw2-xtwtCvZ?f2Vj_6Jm^0?kk+wb5Xgd8*tVyLxna": a& = a& + 160
    Mid$(A$, a&, 160) = "_ESNm^elVGF\s1*T0'Hbn?EFY6Wx,u]J7tSoGBqyv9gy0,fDZkg8.[-:8j\]7oUYl-+F^^FHT-]x_hw?h9KX=FB=)5stM4KqjV/>Mjma/\hbD*jzF:y*S;(BNaGJMSe|9AQVAj/Z94LT*spCzZP1?8iUH[HJJycR": a& = a& + 160
    Mid$(A$, a&, 160) = "BsV4X*J9PYN34<a3DDm*V]b_5|=c7vGSR+L;^UzQl9rk^'Syjr\S:5^Jn\*97=)Yz{\H8lnVKp8}'[ONj?0uD81UVw)<s>\2wTEC+DtzEhAEAF?R9Eq*bL?H;wTTvbCAWm{V/D/E-rsnF<zFTz9,tUe7wBpaE_'|": a& = a& + 160
    Mid$(A$, a&, 160) = "r\=Pi-xE|w4:ya3Rb^]g+-MsS.>nbjIk:a[A0dB\Z'FjL]0OzSL,8'N:r||L{Y=iuz)<F*K>x<lVl+bdUy9\Z.8Yc9mVqv.L7m0MTUt:dY<8J3;<U_Wt0DOKUr;cdB'JpmkFV^tQ/P'n(?8WFnKMZFy_2^Bsj}QD": a& = a& + 160
    Mid$(A$, a&, 160) = "?-^y\t*y.84Xy(qtDEKVG?X<<+]l-rs=:(0JNG//4Y7T(UJXQG[j.NoMLXJtWE?+N*,Q29k=o1KvZ)z0fS5HCZkJd{4vUOe{j>uWkF|5wU.kl9rb9HQYL-10/syuU>6b8N_1TYgKc2*?vK8KD?E[uq6sV:X4jb)C": a& = a& + 160
    Mid$(A$, a&, 160) = ",.U'4Vd5Cx6hi1w.Gp'+SGWPVzLe1H^)q*=DGJ^[K+2BNjZ};Unp1Dgn>{1v'+C8IkG|IA)8)4Nj90Xa=AZa)f^CPG0PNr/XdeWi)i0m4pLJ_^]yJO)cfA_6\4YYVAVY^FjX4{dQ-R7.M2W't'(|QA]+C:p+g<5B": a& = a& + 160
    Mid$(A$, a&, 160) = "SInq]cGGfx>?600:ImiN|zPYr.(hHNBSenJ]ILN9yGc0VNb3Ae0(G:OWVBzQtNEJbU?vGgDTm{Y^X;zLCILo\t([{eB+;hay{4v3Wu7PLn1LfS9)XNdw-wSF"
    o$ = Space$(9440): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N01$ = _Inflate$(btemp$, 10286): btemp$ = ""
End Function


Function N02$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(11336): a& = 1
    Mid$(A$, a&, 160) = "4O)?-zDe>L3t12i2ISCJ>*rT;0G*K9p<EGf1,A|6j*(5\V<rnyod]D-.(,plj(GUHd)nDViR5=D?^'jW_Qurzn.-D<KzyuNjo+WJ)o|fe]pR2(Y:T6P'FrQ/10e0q9<J|n?8OyL->e:)wkVf\LQNeIdkmQ;PLthE": a& = a& + 160
    Mid$(A$, a&, 160) = "++DlSSk^xNWTA)2:0Bq.R,yDL1qkq:PUZ.,A5K9Zh=L3^jqP.X]d*6vrd5n]X<V=x9LKD8}.Zg]:-EovmFh}G:]3TTGKUnzw-2b+iO<rhQ4XG_1<T19.R?XCC)a8Sdp}UUY:o)V6s|<p]*T}*:-'EXuixYIE8--=": a& = a& + 160
    Mid$(A$, a&, 160) = "Ql/yHTqXBp[nhu2]''Yj).rb6Deo9xs;'UEPH_]d?eUHNeMcs9yJ(-?D/dUVMWQld?RS\iH'S3vHU/\C;VxC'}0Y2GM<ASVCBIuWic\acNn3U>sy'O5v>7xks2o>>['[P3^tc(.)yAA8z-Ak4s465?J3+(|7b:F^": a& = a& + 160
    Mid$(A$, a&, 160) = "xR?)6w8V_[|kF(ZAsk_M_p}IVCA;.v=pkT'1*nDk8S2<e=xdLIjNTYQLWt),Mr}(BVgSTc3G(EpJ][Pasy\vaBeJj\SG25J2-}xc)yC/(+[p^Y;dPjL|MDhH8',|bjO:W,s5RunGhStxjzua0X2KXqNduc:vGdYQ": a& = a& + 160
    Mid$(A$, a&, 160) = "fX[v[3M{Kj{Yx[^mRma87JF*pwG}}:6+?\(}9wLE9\2Czc*dRCoyA,?)09^)\X7]_,>EObAdM3i*+m/E<E.wRuBp3b,U14GoQ/}qfZw0hy5:1M]*SKT_)m3UdGd=O_oMB\(Xi\e5pakwPNQIP>KBW3*[e-nkE[l1": a& = a& + 160
    Mid$(A$, a&, 160) = "ESqA[Xpi:o>-}uY\_Z4I'OM}2SEUq^bV2*n1=}zM?(ys8GZ2_Hy'KeV;-iC:fY57v)IlHnq]9J^<HjPZHuGLfm;mTCsu/]cc[^fRZ?FN=g+_ANns60f6Cd*UWT\xp0_Z:c.yKQ3dmhXHO3LnFm^a*o]PMq]kA..V": a& = a& + 160
    Mid$(A$, a&, 160) = "{^),4|V/6=s7gdl]s^lIZx]2|1qw79NGv\*5UwUl[E''f/-hGv')al2eMbJE<Lnf+*.A\MBho2^0sSCTwOQSdhgB?5)tKv2A1-K^M_L5,As0xdE)Qe]X[W8Qv5JQKIc-Hna^:N[NyY[4]TM*i,aA9IA>-Z}eedK2": a& = a& + 160
    Mid$(A$, a&, 160) = "}nR*fQ*DL\75-ar6tBVp1EITVRZnZ9Sf7L6kbN}NO)K:2'[9s]4hMxP7tXW[rMQObrx'[L.sW^]Sm\qU6flbw.X585|F4/hysuLB5>}KJo_NZ1iX9;2QUkg1'mE==fq,ws-<kF>{1G1vbEpqOf\0K<j]1IfxL[dR": a& = a& + 160
    Mid$(A$, a&, 160) = ">?>EFt-.7zB2q;cldXrLkkPkSN^O4LoEh1kSzH8[}',cn8PoKJlL^d8X*(,EnjyBdF2I[17Z<L.6'pwgFjO_^4fZ{s./2G0USjTSM_}vea>4zSx,Pz[bs\N?1e7;+ve6h=X'rS+ZC+0kC.1Pfn1lMZEgjJAGv^*s": a& = a& + 160
    Mid$(A$, a&, 160) = "jV[\AiG7k)?-4qJsDlpR/]kGPVZ?jlcxYTgn:ayLAM07__:)2z;4=rWzgU)Y+oYUEGLp|<1V*k>y2gv<=.G5MSS'u\e=x/K3Bh=-JF43;M2w^o46j;1*mn9])JCwDNG__**iO:W/N3,z;<ND>XKuqxo3'RTRS5hI": a& = a& + 160
    Mid$(A$, a&, 160) = "E+bn_G84+ZlQH4NIh/ZK2.t'+jNS+wRV7m2U6cZdmL=s|;]Vw\jg;O3}5AD3Un;;j3)bgoJlgI\09fW^L-Vq0=m52v^svBn4>F1{1l>=^jLP?,m-Qw?z/{,DVPIpI=t.kfVjaz)N9wWn:(enVem__8k/\cqwJ[_}": a& = a& + 160
    Mid$(A$, a&, 160) = "vxHvt1l0fw7CO1:-IxzRj(cusNrk{2I2TUjG',F/4i:zeRS(YS}q-Jgc-UOvUbE-zgDOCy1xhlccp(p\]>oP+l(ex>Y4-b9N;YB4]R|>7Xi/S]yM4QJ\g<1(L>F'R0938c/gTP6vQV<0+IrNB_pZI\R2Zq),irHw": a& = a& + 160
    Mid$(A$, a&, 160) = "]iU5[{Ul]9O+70v+nM_70ISgLyKDO(gVxH^0Wv(fU<v/[b]iMtAQM+s/11b_q92r7MRybK2suOJtiF+RbhP+j[Av6?+rs-l*g/5'4L6<-eF]ANCU,=c>w-FddL(yi>WkKG|<*K7.XuAf)1pJx6s39za3L3W*QW?,": a& = a& + 160
    Mid$(A$, a&, 160) = "c])9aO_>G0o(U0PDz?u-6)rx+,'q(7_5yopUG7N)SGj?Rii>i:g<SQmk*<uK01O6\AD)/;SHXVQ/EzawQ5si^.gy\])oioP/Xeg2=aCi:=l:c6Q)lrEe1x_Q\CYB:qrxIojOG8+sNIFdi0IUl<E:bb]JK\tAOB(C": a& = a& + 160
    Mid$(A$, a&, 160) = "Bg+HTOh0bXU>v)WmectTNR6^-_kP+qdbZU(las6:a4,A*F*AEO}V}\PhQwHlaXBI14JjhB9P,S-gzbjRl_>u068-BugV{;QjU*Ek5w/aV95=)p}t[qE3<LF6+q{swfL_=lSz3hs{)pmmnTSd)k*.:nKOu_tB<D/^": a& = a& + 160
    Mid$(A$, a&, 160) = "uC,wVOv4>-{HBUNW9D<^<ah^E?]zh;6W[5aR?/l7xtBsx.l.^Cr,8k}gq7qnm6ejH'FW'Vn0L2xf)gtE'q8>2Z-AS57.sRfXm+{?PQb,pyGGtJ31hQ6S_zf2G,qQM,pUYgC*v^wzXGogaWk,M1BKF18EDz?r>ss)": a& = a& + 160
    Mid$(A$, a&, 160) = "+8={jyd{W+3U4oK96u7Ffe-\4\MM^'mq.Z{RxnB{BuV4I>Y+71/B[7WFWg{hYIT6,{;ui([^R4Rv*uk1a;>[k.TiK^1((o5QB5(NmIE3FzkXvP'cV8t:_QZLuAvGrFRo:N7.J(*z*z*|/diy)A?y^8'3rpfy{6Hn": a& = a& + 160
    Mid$(A$, a&, 160) = "z?B/G5kn+X2\PwBcI-(m+U1:_b=q/.3M(Yfst=f}dT<O=YoFj*qc]tnkN877^VUsc;Nl2HP+a9U8'Ymlr9Q1HAABzPN\{RNvkr_Uzf':fN>sf_:dvYFJ2'XEf(?PEzT\jllG{GAoCVRP+T539BrnOR8PD)dB2EG2": a& = a& + 160
    Mid$(A$, a&, 160) = "w_?{u1):,]'jK:\wZ-vVAf}*oysY2-3\]lA<8UvmhDm]fp<d9PkFql,Iwg<7AHpg6\?y+OCn4|7=R8e5tUSIou[4O<jrvkDhmUi/spTH,:nZIS9,vb*GqLGkYxclz5f5|lZE\^K-sa5jYv'Yf}33u0(]>FVcNiJU": a& = a& + 160
    Mid$(A$, a&, 160) = "kLyJw4NHw0FlBbi0RykIjvmZsNjc7jYw.P?8b65=nd_AlBwx{Dq<'MhCAEind(ny)K+=Xo_lQ_goPtDNgvwyZI\725<t,{]-dXvD*[])uKo9J.1r=tFHMbcr>KPYk+zC<jQK0MHzMNzstj]gXzhkQfYa59[nxxZG": a& = a& + 160
    Mid$(A$, a&, 160) = "Jm>I:.*Ogb.,/-DKYwg]A99YdK*6F;HoNB+42)R}e?o{DeV]{:JrD3ZkwHx=tHhy=Ks,c),^p'lE;qW{+'Qb+r9{sGOc*w;3T6T4x(+{;<A=hKEFX3k]/6|PPzIG/mHnS*[=ir=YrS-wofOcm,:PNQ|ItE{w2JJS": a& = a& + 160
    Mid$(A$, a&, 160) = "/>Qe(<Xuel|1=KOge7EXvXd:<lCKPeJo_B?2pQ^?<xG_Cwoai\igD/>uaGrHFy\U6<g'sSI7poG8p.01}(Y'WFt9KHfY}9cYKVHm/;i\)}sreD5sZIN-q'tH(S;,eMP-lB9ghkccr]X*oeCGV>1La;6hPj)x(dq[": a& = a& + 160
    Mid$(A$, a&, 160) = ")rsoz0T]nJS0brI./\=Q0Hx.N?hV^}G^/We576B4)^5yBoM*6(EtEgGpd:xB()J2y'n*KUPG-5c8:l]'}*|d)/bDW{XV2=AZwmnnWieVd9^:Y>tZ)]=,[ASDdkFNga^DKag=.E>:78Z<Ku'Pa;H8Os{M>bs-+W]{": a& = a& + 160
    Mid$(A$, a&, 160) = "H]>ElG;:K]PF-NT2OX38=*,Qtd,:KT4)5_2,qgl+OS{x.Lv1;xD-(uYLg.2Uk,fO](z9MSTVY,LaiR}.EG;Y9IEroWF.<{--b/kUu4VQzn=ySK'Ka{.F;-1Eikx66l1i_=(EUkP/g;ikM9Y2;N^V8KUazVusE(>)": a& = a& + 160
    Mid$(A$, a&, 160) = "EcadJ2[RK],'C^X8aw.*RqxeJgL.88frn[;LnbOK5WKH|(]L9D[-CRI+Og|0RgyztmlE3o^;Iyg>jo:TJZDE'mJpLfHeLg?*9HL0v/BxQ/8a)NC<z5VT5\zjj289zY26G\>:I2-ViDb8cB>b2o0:hvutRJiUm{='": a& = a& + 160
    Mid$(A$, a&, 160) = "[;Rh-4FZ/)hW:evL])=^NNi;2smgIUPpWnRu1x8+a6[-Q/+8:=z_j_N6Kap1Gtu.h6=sp+dV(?*;KMXXK)K>50<N4^fEZCUTUwn^>V\?n3_\c<X5d?m')3;5e^=p]k_YCV0J2e8Oeg[xm>yR1,Sv)3oxcU2''|G9": a& = a& + 160
    Mid$(A$, a&, 160) = "Yio8ubwx,edsDNk'CN9C<S;2Ikx8o=h/dibq*\+RPf*u:BqY=n{FC7k]b0tNxDx1e.9>BBmk.Wa1o)^l3^-s0gh^JCXDjb0\(=1Y]S{,0*a7MsZhV>56>ALJm'CLIq;}?5bu6ge<o4Z4(aI,C|MH}-=U.PyhT-r8": a& = a& + 160
    Mid$(A$, a&, 160) = "CN7j^K]}|qrYR2KGT]fS'u(h0QeKB>P^kHM<P3,..\J<1SJvRKDbA\/},bYBq*aop3S,Ba8Zt}9j>m2IKeZ052=aUf|MiAbMho{suS\oI[hbv6YHPapG+d<fzq9EWFa/[}yTXTPa73Va00H;X<M;'Nokyk}Fq4+K": a& = a& + 160
    Mid$(A$, a&, 160) = "cyd'L0o):F/^;|t4x4VrpyaWWOW+*P-E4-Q{AIXvlt_sP)^{k0:JprI4r+x'o;d+7aPF|tUD+^;r)yjK}va:wTUslyZ9OkV>z]yJ]lE0Sf7Z6-_u2GCkoB2?}mW_.FgI7Rsq)9g6Q?G(X>4HxIwyxUhITj|gJ5-a": a& = a& + 160
    Mid$(A$, a&, 160) = "M,{4npTLrXmE{E7tQ|B\s424}^lN/]<?D)S8e,uS>15Jooz/qvJk9X;mAqh{I<.u3J\m>NckQtQ[k/fzD:XcDCnIZV[pzKE.vVbyh>Hh4Jm=ZoI(Yg1SOF,B:-/p3-a<Y8LacFP6BMygr33[?^[P<(Nw=9ZX.35Q": a& = a& + 160
    Mid$(A$, a&, 160) = "aN\jF|3Lonjto>Jm_VR4^9JisZDVg45p:[Zuil{mEOg?6>v,*;w0nt-<uJTfFj^4>x0+Ei8>\SE)J'kh6r\hV^0uJZMdgE:lnN:rZB:G_q[wo(2vNn;ZeHz,lUCI7*Zu5{c_]0sQD0>f7DQ63;lfz/kB<h{4c*>+": a& = a& + 160
    Mid$(A$, a&, 160) = "rW+X4(.y;Zd[NLw]YvZ.1(,oWO-O26MI_6VMXI?pcr-y2bwd7/92Weal9I04e:183cdREbc-Tw>}kVzd0=xVHiOBAnr=Q-z|m4I'4QKn\q']1dVqLaDB4{^n*>b7vlhaY9/4,mF0hG>*O^^lwo-W:fR/MNCL(85R": a& = a& + 160
    Mid$(A$, a&, 160) = "y+K84l/YB|TW6{XC{0ZQP3EQzc)DXCU2=>I,Eu]b;J=ZCH[M_}J8je;nb?N)vX'Uq6vWfC>4h>rXk\XM06kU/3(d+hE80a4]t\O9KD>YoL-0KWu'IViQ;Z?hCSnYVxv2Zz{KpKWv,_=VL/PLLurd_|1>aP*l.jeK": a& = a& + 160
    Mid$(A$, a&, 160) = "JDcVSTl'kgGh\59sbGi,mRl,4M5]z*UnD^TlHI0pDFWX|u/^3jdL)9w2AeqbaO:cMD.r8_{pjXxik/w{XILS(ZL-+Pv+gR(z=q7qk=mpEIG4+qDfDTTYu2zA{FWtM'ELe[DuW\]=w0-aOQ_mD?Kjz6Io/2Vh;:RK": a& = a& + 160
    Mid$(A$, a&, 160) = "G+pIQZID^of=lyPki<-5VclZkNHnh87sP=+Bs7IeIRJ{4Mj\77zHiSBQL=;=OU'ai'RBUpj9}^^HJ0Y\TAl{8fz>J[/nGnz;ec}kA<=lW^QO2wJo+}F9U[(gL0]Kg(r'4Oco{cGQV1yXLm.'ChNY=_\Bg:jXno+t": a& = a& + 160
    Mid$(A$, a&, 160) = "blnVwPG\^Xr5R2av:||qX=oDM.jlYb|an(_.R6)oX7aN{fw^^G0F/RFA?}j-DwgfSDB+w[Hq'-Q8(Ot,RG*[:WKq.tex3bI5V*9;gPJ:>ROPG4JG'*[W.?Kg8HzCC|oITi*g}CdTb14G|Qk3XE('vkORS1iDo]dY": a& = a& + 160
    Mid$(A$, a&, 160) = "2-uVhHJIeLc:n>/vv\51'?ozq|w*6v0MaL:XUrBBr09e6pE?0dt]ReJ0CNwxb\iD)f.o5h-,S)g^FS\P_Q=8{v+Ifj6ab7Gw:95}'tybszwO6j9^p\==TL'RJMNb37V,0B<T:*vWCh<gZodQVo51G[gC=t=>)KyO": a& = a& + 160
    Mid$(A$, a&, 160) = "Q\'7ihB+Jj)^:ICKnfqYT6;e+AY98C2mb>6vE+}-z2qXJ1e1Cy*dhO(q(2a)3=-8<}45*kZ*hiw4eq,ST7.B=ZV0)^o'r(2Adnrq/t-w+nz0:V'PIL*cr_7'Q3L5OeHfca,oQ7y]><BG;Cl]x^xVE=Al^tfU_<0W": a& = a& + 160
    Mid$(A$, a&, 160) = "<'gR}(fJp<1M)D4j-hdR|TDYs0Gg>xYySf[Ho8D(S4G<^)4gtkHmNz1y?0N<6x}9x7?iDQQreL*)8hFxRKsM*Q_cV'6[[/cer.P2u*KTuGt/audeGgH3p_|dt2,yMKq9Pde38ZV_d|h,<A{t:9T\S6DDk]qWSx6I": a& = a& + 160
    Mid$(A$, a&, 160) = ":1zJ0PPk/EeCpUSl7OD_gCsd\VRc.'Rp:QY]qM*m:Om<FOAfHr4:0XMxyOM4dS(CS04r,;VA'3]8?Rjr<I/Ph?)U}cCY3D?x<bYC>X2d|l=H[*}sGu\XX,;Gdp/IQf[CZGnvZXx1u_\PjQe?gUEq}-0{4<N|8[9t": a& = a& + 160
    Mid$(A$, a&, 160) = "NX(VBZ'CrEWC-btC-M(rw*+)GosXlhe235(^uw^VozYRUWf7w|*0uuIXmS=w8m}x7{bT'^X\6i4;ekiFCU.r6)cx\eUEB66hc6uW3F7,G^3D\Y)u;UrUd/I^2o\4'sd{6=K:?.y?DvWBoip-mL\AlwYYWM;QMb7e": a& = a& + 160
    Mid$(A$, a&, 160) = "x3u<*_(7N5Rh}mRv'7vg>p,NK2lPNWny0hN*x[VBkY*'Lt2h0_}fOxH9H<t'v]aMWO=py;'t*QkHyzVzhWkY/b;Y,jMbqTc}U=wLr6OxQ{t*p45cj)y;\C9AN4<p+Tq'/USHD4}0HB?[VrrXn>p\nRt[c+?_D-L-": a& = a& + 160
    Mid$(A$, a&, 160) = "*3r*vZSr7I^Y]6OL1B[WWb=CnE>C(-(Mu:F4ws>UGqSMlD<-F(*A)+d(8?mihP{PX;=fGY|S2X>k,'SEBB_;3A6<(xmA7l]pp0tzvlbDF)ea1stGY:hwq_'Fb4S1f]<-xNbWvN.Wx_}[V]]+m'tHCb4<i\IQ2(cO": a& = a& + 160
    Mid$(A$, a&, 160) = "Y=k{opdO0d5bRXm(D=Oi/N9{P];IBsjV85r8({/Q6C.l?BKFH*6O-e[Ww_0BG0/MY-JGD>x+k4M8U-SxghEW_5]dny.vyai9ZoBwRd'_fQrg<Q|''VFO/hQ<pp|fO'_Z2Iu2|*SBem)dXdJZiAqtBpE'wO1f8hcm": a& = a& + 160
    Mid$(A$, a&, 160) = "[2D_|4W;zlg5rg*_Wy8ozXE|njYY0GJkrJl/k}sgTXSUxJr9CtgIK>=_+XJqa2,YgcJrf;}pra1)/1<58UhtLfV.8.GNyAVOM{DMrxN8l)cXu(vkOG]n<ig\HA2]tV/u;qR\*K,w(?c-5?1bNk_-yF>IL;Xg4Y}G": a& = a& + 160
    Mid$(A$, a&, 160) = "PFi0t=+1F_=pFys+yL0YDYm1_|0AZu4(e9i?JjKGHasVvzCpsL\/qV4JnY9qvFQBckP\{9=o[PovHGPR0n:,mOQzi3Z(Ez.f'=-aZ(JDNayr/Q{loZB3R4(f:WxYDFL2zN/SH;e|yIxr}waCXBFJ{v?44a(::LEF": a& = a& + 160
    Mid$(A$, a&, 160) = "eOwVQL7q]IvwK;{ZHz2Q:Pjhh9ue+u0eUBe>V2+WCL)2:n7tN\kDB59IuZTb0k,H)c4;G1bqP;M+[0>H*fZp'},t''z(I)yo<c.8ko5qp/cdJvhb:)(;vP\?D=RL\=,6HlgTu[y{[8>SP-a]6JMf2XLr=x9mx/YZ": a& = a& + 160
    Mid$(A$, a&, 160) = "dnZ)9Jd2z2VL+S2nIKKiG1uyuQaUa:WzWQa*TT2=2SjgxIfG2cOaC{ZG\ws_N?kF'5vYFYw2uk-1.t0tZJ:axzwnTYW]6x)''[\:zI,m-IGE3pb=_7cV;E8RQ)-1fYasqz{_M+HGhqjTxP/TVa832}p=_DgIa/;:": a& = a& + 160
    Mid$(A$, a&, 160) = "|[{VC{SSj8p-Y-dbY9-JqUU0kPv.H:A>t.qvIq).nfFp[^^AaJG3Cs9cw:DsggPL97M4Y{o9?0dtfFp*^X4Vj<Z1NLe]TR}}fi>l^vrzt4^+rmdAcuG/1;gd'8[sBQ\Ni/{=0))>bVMVb8:9;l,1:CFcF)fqARgy": a& = a& + 160
    Mid$(A$, a&, 160) = "'dK}cZF=r+oHTavJ5+hmc/Y794/J)|VHxQ=>wZlZd5-Y>^yCpH(kZ|_-HDoK9yvo^{DE+SBWc>L*yeX_Ps{fg{Ru=J[zE{EU/*l<oQlY]rstKgWaUGC/wI'SA'[\nQx-g7wks'(S('qk5b:j>Be3V.N[\w8-[;:k": a& = a& + 160
    Mid$(A$, a&, 160) = "T'A*]I,EFQeT2NWLQ7jf'/s<P'fdkgcS,gr\S_wrUeDWS56)E36R-[PpA5=yy9)K7OL+V2ehA-1?:XEA-sL9iGd*\:tbiQ,TcfLIQkfZJSsw7VRBiEAMp6.hP[q*2D8P/VyHJ5J0:ZBIHv4*Sk_soBBsf<*IB4R7": a& = a& + 160
    Mid$(A$, a&, 160) = "hbNn<\4wg(up9d=T0z1:AY;a|UYhe1TzOV{N=PKnlw9B4az0/N)NCc;8WMCMeSsuJTnPfhn0-lm+(L'Ng;8cbg'+qpj12>}S9HP9Ipn=)]I/oc>P?DP=0oFFQ99>YT;K>EgH,a?KTl9flM(M{+^9ag_0[6WSJ7OM": a& = a& + 160
    Mid$(A$, a&, 160) = "dR(O1A.qV)rW8oV>]y=1Zy'S)aL\u,lHlu,2tu]0(dbF'Quu(:pQvDanxDJIr\DeS+k9.85Se[-Ak[y<KO7CiKd}YBqCSC<-vK>,2NTax(y7aH?3,,[1m+;y|SM62?*3=2{Q>A]p.}E=i,J^7yQzvu3bD'hVh>[[": a& = a& + 160
    Mid$(A$, a&, 160) = "y+egdX6Rp\/s_^'oK/[JNA4=xP1rSag<gV*/AlpY/qi>7U^TTrLRUU_]plhHHOUe')u|_wMxsLsoTl0r^o/W|SxX}T..I?/2K.|4b[^Lzxf)qJ0Se43'n/)^sq1w0AnC2C^VNQC,/wK_up{FDZp|2P9)KYVl[.3}": a& = a& + 160
    Mid$(A$, a&, 160) = "NqSEByEg5NeC/I4mrHvGEpU6O|8J{u1;'K}]aP|h4QasCI(FrXYB))69f}fL(S\9<6;S6:Er)]W,;p[ekM?}jkQ<8r.+?OfR0GQAx*.L*LRFVvCckv2BOPaPEHg/mNI6DBs3U'NGxb>Txkd+fseio4;:N{,qT,op": a& = a& + 160
    Mid$(A$, a&, 160) = "=B[^<{Sk]HJX7A6{tZ]4h8\[9YW(}dv6'yjie}1j}s'{^[SV*sSN)v(u7|Mj4to_Y<v<WhW4u)G,oYICN:OCXdZIRz{'Xk0Is]\86B46oRg<yDgD=\x00d?I{_t1UFN35X.'>)*laFN6bqX>d1W7Yo=)I:n,Edh[": a& = a& + 160
    Mid$(A$, a&, 160) = "lfqrIKUs4RebYrlKztp{yhk.cb?(u:tGP1^9X8(?VvF\+qC16,wz5__\bn6ZAcG\JM=l\L0/]}5vhv?)QU}Gm+jmd'VA}CHCp>Nlp[7YVAh^oxtc4IZdmsD^py_GzS2ZDjg,Z^j}O(7Jq8294}*(|t(21LS{;JeR": a& = a& + 160
    Mid$(A$, a&, 160) = "-.;Uy^dk=\ph\{Pc'jhm+FYjLIJZf*>5*gfr=K\UHgbH_D6)5N{<d/UMB9H{<.?C.kz\*Z9?ngxX2tmXg:lshCgUdr+BE'Np8+TM2q*n6GHz8QFNTtx^lgrR*XQ?ay7,Zftyx\i_V/tEA^X27mqn7y9NG^L1ecyQ": a& = a& + 160
    Mid$(A$, a&, 160) = "f-GZCAzGTIgk8;gsOZ<f0Q.GA4U+qTu[=8x</7Y}yhM,1UwHuJIaXv0qmt15ha;5q;rZXW==GQM]Sf79H\ir;D>j\(b[B8Q|dbwCLP2y*Biv6hkzvk'KuUy)V(L4NUqt>ut=P'8C*D7R8bU?,73gTUw+eWu5gZyO": a& = a& + 160
    Mid$(A$, a&, 160) = "SNek}PR?sKl2Or|_8Vx=Fvjba}0q3E|4PU4Cl<7KjD|:g:FmIVp?';Es2XpH3ahRnD7^mA0xKu9*OC-sjN>V//9HcAC;e+6g*,ZDwz++i8_YG^z+FITSe0XT)QAIt?ko|+1h=W50Bm[?OKgt5]IJX7xV5e3Y5]C?": a& = a& + 160
    Mid$(A$, a&, 160) = "PRkXp/vw8[q[S2rzviXTmCldeg6e.}t=Wt1*qT/)<X.eua2.=NxuJ*9ms4=YR^\Uqm>PE+elR:HCq6w0,<9(V,?=gp+Le-O^;nQKU3K7G48G.iG_vJS}X[ebEI<To8yP)/-m5xQ-uEc8)-MzUGso0mPChhJhZ2i=": a& = a& + 160
    Mid$(A$, a&, 160) = "w()uCl>Zf885_*Z}5.haKtTgBeef+27>'a]kG,MUg\{e:Kc_TI-fN\>rDALMAU5]m_->(<E?aiji:Fc.Iaz(ZIx+E:9Om+mITSv[knZQYvRFE1THMfjt'Y2k2UK'[h41{74VANH/c;dCl3FL>sUy.lU\*.Z>c3_U": a& = a& + 160
    Mid$(A$, a&, 160) = "e0]Onr)QpRQnM4yZrMO25S9WAAc<0dKF/,kRmdNVh(KkG_qYAIWrdgfyS)t)*]GOn]asKrUpjnoShh42l(\'9/yv\_Ru8y{LC2cw|nQ4kehnE*m9yh4t:z,^)HCxAn>pVH-n8P6R3AF6wU*mKU?1m1DSsr>9]J*u": a& = a& + 160
    Mid$(A$, a&, 160) = "00-O3]zC.{>X{'uQE2(foHnjlq^z*F3-i(v4st{OzJc5<JaPjBeCN\Vk\7*L+fWpdOmud8O]CHZ'2U7TuBkzhjFqxZQzjKqzbB)ijTGQ4^_=^6Tb;aB):(|:5z}_?<1>^W-vig*weH5H>aS8c.v'7B8H^x+r4.bm": a& = a& + 160
    Mid$(A$, a&, 160) = "lLiEfXw{Uumi9U[?cWo;85;uBF6\TG_{=uMuuChed.lBi1[<=I;[]i'wMl5:WrAaC}xq8v]M[.41[DCs9]EOf0wHNdw=6+YGKB9MT.pw}6=2_uEF7'kEnI(2'9[>?TV'xCNfCtIa^9;'sro:rD/,SZxDjPC>plN0": a& = a& + 160
    Mid$(A$, a&, 160) = "ZH{p7XXJfb1yn+)2_}3sT9KN9MY8Pd'm*'s3QMia2Uz{o|yqA{{g4>he0-1fXg]ibK5f'>EcZ2B9B/hukZoKZgoVob,-fV}UkQckDwxE9^nerW{K];R96]a9bTG8<sD=tM{U_OILXU_}U'd[1A-Y9SUTK1?[Mb]E": a& = a& + 160
    Mid$(A$, a&, 160) = "oB=SY8B66*W+lqfRH8obRx3sA'v_e04/oc+wSuJ\{0DC*M)1qK<:;bl:T<D)uF\QTBEJEM'0,UrAz>V7YyIC't8hIWgTq/2ooQRo3zW='hde=]fKif[VcDQT/KFr|1yB2{zl[udJ.4b];wc_>h5]a4uq+DB'lI3f": a& = a& + 160
    Mid$(A$, a&, 160) = "c2dkv(V4t;gt'R_WKW\<aZcYXoJZbZGKhyg>1Q.VOTR/sQuyZF0Z>(E:MIW+QB?H6luj-=Dzm|UDyK8Xpld,GaIP:ft-Zeg2d4>(CQPnVBlW]lf^^+m<osjn\yknE}6bcIKqTXql9Fm.(:PE2R,FUZb:yD;4B/Uy": a& = a& + 160
    Mid$(A$, a&, 160) = "S=<_|9U<{?/:Q(+>eq78k)4H{{dHvE3/Tsw+1UMo=xfjOgwTR((ZDIK,CvoJ3[|5Xld8.^iA6ckBV3{[_A,U7TT<aC>cosb24o[bUKdjJa4iS*XM>EqJ]GzHVkoM\hHjf,:IA9bI(EJhhI1B2TXo=}ZzK/Adut5|": a& = a& + 160
    Mid$(A$, a&, 160) = "?YZ7tGp6ytbu<ENT=s}0JB3)]2k}O|.PzmI{CZkdtu^=]CmL/t>xxvPdux1G9,F*u3)Kk=uV+gcFN,;1GaOA?}x/z+(vj([e.8a[J'JMR9g=caRi')o*y:4Ed=s(OpgFF/y/SG'ZG-f/G6aq?eV/]k=V+Sj92wN0": a& = a& + 160
    Mid$(A$, a&, 160) = "WDX29T_Xk6cKXpPa^dG}7:aY]QN|*48L.,+sf+J_yUZ6P:wZV3=rJtHsB{/:N43p.nGLcpy,l0Q<YBUkGMij}*Yi5QLX1hPj^7|hKk)R:7br?\rUV(-D6^JxFfce7lxGHYr1)"
    o$ = Space$(9065): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N02$ = _Inflate$(btemp$, 9884): btemp$ = ""
End Function


Function N03$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(10846): a& = 1
    Mid$(A$, a&, 160) = "3OE[6{IxAfnjt4,4G0{fZ]e,0ERj74'gHu9'7ia+D9JD3JlLx'WEC-PeDe35W=:Hn_LZWdMDFA.o/k\}_pCZ1ztaCnw{7L']v/'{?kcSICMq6o1PMNJ6DZBKw9u80Op}Cg3PlkaaN(17z??8gf1CPXzxe=?]NU-2": a& = a& + 160
    Mid$(A$, a&, 160) = "FVp<2={9/|)M>3B3EyExJ6i7C4sG>+W:;ptTqhe;NIB[w9>bH2>6Jwky+ZqHuA<.EL,Mp?8/7T_G*/vm<a}iz1prQQha2^pVh6/y/EKTQe3h:Cjhz[;I_CgK}0Azap2QAeh''f:TPKoIv2FGYdqW?URi0+?>k/)a": a& = a& + 160
    Mid$(A$, a&, 160) = "cs4;h>t)VH6NED)6E)WkogJSGf6LPoPLFPnrwY7BEV4*48?]L^Qr/;L8JNu7CBR2a6W:8=Vh|-SNNqyk73t|wI3]al+s.QZZ[5u8dSo]4L..9Na.Zz)l3eRzk<:fTsS>7D70cNQNJ{^?VCN|k>Z4y0B>71K^eJ.<": a& = a& + 160
    Mid$(A$, a&, 160) = "lh3u00HePv>lu0f:5[D7<AMPqFFq*rcEwSGVdpQ_E.axR_;[5[b]qv/JEoTT:CCB<ails}ubJp7OXtu}Z=lc]8(/Y4S;<\i-.[\iN+TQ7Ug?]yDMKEoqH(tx>^m0ZDQ37G,-C\;'C|koMahQj+<qYxWBkHFgN0O9": a& = a& + 160
    Mid$(A$, a&, 160) = "tmGwK5KAoXtACIR_f?m4s?]w8_]1>p{Dg;_:vW|AHXE]G+cKktCR}+aUS2N08ZMBGe^>;,N.Qb.Fd;1=/1*3uFihH+m^WIKAhdo.|K}(V]rPF((*,KJ-<'wuYQ67xBmABpIuGCb4d*oa4z{.YX6KC-FO+9Nm0r:f": a& = a& + 160
    Mid$(A$, a&, 160) = "kRiug,;<r8.]ci8a*|XJK/3KH'9e.VRBBr\IDYA3HRbLN4Q8'189|T28o-rh^MBjf5c8HipOBzCjNZ|4hrEXyepCp3=McTeiyu4KUS(Jiz4gdaK58E('xp(z)NdO[izn=JT^>*uY\K'{/I6_m927P>yXizBOYbj'": a& = a& + 160
    Mid$(A$, a&, 160) = "HKQ)eTh?f1J3N_JFBP:7Cjt7n=;m<o3m[b2O>XLbwZG(E/(wPrX?tx_}*?MumFA|yTu?)]n_{v=ZlX[9Zd/gxHTJ>/Xn<7nuE7X5*cx4GqBD4XAPR.ua(,GFI2{{Gt3oJX^mQL(*;0w|goZEvsaM\VOV?sQ))s/*": a& = a& + 160
    Mid$(A$, a&, 160) = "w..w<8)+48aNQp8znY]);gyAMC;1]r6;jWJhs[Rc2,c>v>52ZWKP|kSsoa|NLTXOBBN;H55]z3o=Da0TXip5NV9k(^18?\m=EQ{*Jh1p+_1l3HRKt4[y7SHfvBI56(=lTs^]0q,.'+A1sCc2X{jk^5ueEopW5YA;": a& = a& + 160
    Mid$(A$, a&, 160) = "u56w6m]R>.Etc6[9,C0.IE_R[U2G,on0iF>DE8es=F[>/Bm=vp/1uB}AL^G*LUfft?jv:mCrUEeB)>x8/.:S4|;frA.Y}dy2:;y^fpwGbTM}<*+uFBR^'K|uoxibY{gSu)J'ue;u89\sUMP7w4Wjfkt9EYciH8:Z": a& = a& + 160
    Mid$(A$, a&, 160) = "']2n}b89}UD:=\XtDyzLX,9j=y*FeoSHXyz{j*WNE5]S2kVwt>DARv3oWqql}DQ=]:-On>s='O)OeCc{,\UwI^DV9IL_ux-UhEp(re*)Rg78dcDouB3e{27*s7p9;j/Aiqtj}YMc2;FUTX^MX])FwtyEaMXMiq)K": a& = a& + 160
    Mid$(A$, a&, 160) = "j\-:+=hi4{rCRA7fmqYLQtkTciGi|Wo,);FoSkCV^s'7Z-Kx85oNE?qrzgi2'T<+b)x1T+Q9^LoT*lF=agYEdCn9TWz92khL'Gut]A<|o9jP*A.>4yr1iz/tgyo^oxTon4K43t5PsU6\NKPu|Lws.9o_,}31FA5c": a& = a& + 160
    Mid$(A$, a&, 160) = "\i?\j/8Y+E'jd,XqQ4IuYMxvUsXdqa=?LqFw(].TEI8*l=)Vzirga,O|2IaE.A7XzN48,(**-YVxvC2gcv?*8\3Bq?ut>af-gNm;W:9CBgrAy_HQeD8z-d45Se_F86lLdoyyC|^'TfwkaE[s[AR9H5/dRMMAvzdO": a& = a& + 160
    Mid$(A$, a&, 160) = "MsQIZAHM2nrSy?{pr*o6xykYE6_wxhQ>/00_?R7{jK?votVFiF|+t[;7k5^.t*IF}XV+8=Z7o-:,q*wl=L=>dlFv7W7LEv/U2?ao(.-OW^^YHEtMxMOp)3C?J83;F.R?'.v(v[;>n;Cr|B?v>N>]jrO\2rw2Y(o4": a& = a& + 160
    Mid$(A$, a&, 160) = "zu{1k4FtxvoeG6\a6<7SrE62K'lIAMoSj^q2UBp[lxwX<wO27w*.0gf^iEqCh<tT|0F94,xarYLSd,NIWcwUAc:50XE\FM=rFvbK+WbYkf5Uz.E'[s+rS-k0Ag,,}1fnRsRi-SW;B;J}_\}6HLiEq\D\y}';-IB_": a& = a& + 160
    Mid$(A$, a&, 160) = ">P3BQ(m5]f5LrNFY7ea(MyK0<.<^.31A>*]Yh.gAWSow9^Sh(iBN0BkAkP6PG=X*Nd9u1;r^L/2o''Ef0>2|RPLOYlo,SfU8QJ-XU1ZSuom7GOM)8Z{WL+J89;vaMG);AJi)5vo'AfI^avvZPi5X-z.6A(6O'iy)": a& = a& + 160
    Mid$(A$, a&, 160) = "E(I/FzV_1CZ5roi[kd{bd7]WK-n,ay8I.89h506tuFh;hE9p}tH7>)KDsF^{i,43X5CKv7?U?u,[^/{>fC<+,aR)e2Dg?:BM^^Lo2e2iU+UpwZq+r^nq0){)Nm-:6tG?b_yO9k2c/kiU|\oOksXMCN7WQ1,zws|'": a& = a& + 160
    Mid$(A$, a&, 160) = "Nobs].IbS;0A{i/*)^OSg?;_c\b2Q2N:X7ZwfcD;C;FDBYB2rt)C_W*saL(AICX)OBc?tk)?sK7jxHZVw'34:SQYcl<40|0qGQ]*?A\0ZlDo?QBJ4DugF|f]i+e1PU/M<gq<2HQX]WzRYVxb\B+|3i1+Y?|wGpT3": a& = a& + 160
    Mid$(A$, a&, 160) = "=-(9>u+\pn</V,BwRe(Z,,O1TZzP9nNl)Q)6/syQLgz-X7Y.w35nU]nyolO;ckwjLPR[mbF4RM\'IkVwq26z0i\xZRp?A}d-X)BQA**VlBMYAv;tf,^M(T|C-D[n^f5*d{e,>XZZ+Z[u.p7Bn\CzAr]P7mEuMg_h": a& = a& + 160
    Mid$(A$, a&, 160) = ">2e\RZE2*P>Mbp;h-1<oV?y]foAXA8VnbX}gFyX3C+7hX5Viu\{:93//d<zh|vbkkR^muZkJhkb\Ce;G'x8+*=zti|ffR7J)t7}\.Ji;:FB83InQr_yV;D((R_z}0Rr1w^?([+?*f(v-\zUW=yevbF{SKD\aoAX]": a& = a& + 160
    Mid$(A$, a&, 160) = "6gCSFMq[eO2t6=O|gx}wKx'y\RitWVv9f7Ciz\x<\P4|;659M'Lya|h\39'H,Gd?|zuTnTjtENadK0W;7qYYvD/ShSsFe2cDVa(o?<i]>sx8<GVuYUw2\ybpz17UAVZTnAon)47[;4NRbm^R^OnWIkaC<(v15{eh": a& = a& + 160
    Mid$(A$, a&, 160) = "}t*Djc?IVxyf]Hoi:6;keZW0|>4L)P+bQdubmxy\hQH+4a7W(\P]3CX;n-^lCR=Aj2lf:X(7r\t,ql+n;l/2FN_cWdKCF2E[vFg*x.M|v4oh6-VqvJe'ujN{C>67D<vgkZFwwkXkpsna;Nzg0{'r3}N>j9X,d)]8": a& = a& + 160
    Mid$(A$, a&, 160) = "}0k36<{)N]M(''=_*'9\[XGOpQs*q6J8YX:]*)l/7uBc<B9XT}A<cM|Xl]V-WTK<)<*q8vY?SGkIYZBFCI+\OQia]-tP:a}R;mAupe?/ZvK)KKb66]*lGZ11\KerqZwG:|q9/A;Ui:^c5<EG}(<>|k:Kb}PDvkK0": a& = a& + 160
    Mid$(A$, a&, 160) = "|4F2}ee>(<=Ip'5yYEDLwrg(>t/Vh+}'_hJ7FeFv][WpDP]iMcxB=H>gMo2PnH/l]Fyt{KGS7_d=cqK)Y0;ZLF8^[jSaI72-0US;bB=Fw=c79bdYqwNc;lU8maO\T2?\})wK=7<o6n=C2R)2hk]Kz>C:\LRJPm8L": a& = a& + 160
    Mid$(A$, a&, 160) = "-8Ju.UlAb9CTUIGCkwSBWTi3VqFs|RR,\-aQAloM?cS98Ek(xO5+tct<Ba\Wn\d\*9b<r{2[+X.lPB35NXr*rk(7HYJ7f/NWN-p:Vk(b+XJKVs/tQZ7N69cgdH0P+5/m|H2(h8mHB/6I|Qv-qji;^j[[jwrXV,.P": a& = a& + 160
    Mid$(A$, a&, 160) = "Ci5B+so>68bp6Pu17zI[Hkg6A7MysLX:w+SPutuwj/[f3^p1-=NyYxx\V<O0r)|FRpVyWAa0;xug90Uo'BtHtV/C|PzRdc}ox+oJa=[tCSN0{\w5L5/ANKiRBiYvbR9HS3d:QUrwKZi<PFyxdqamug{i_GQ5\1F2": a& = a& + 160
    Mid$(A$, a&, 160) = "Wwt5ZaYhQiWcE{tIHTazUezJCyrQVAV]I+(OnbWHd'tyjs2npei,t>:VEhqc,0uBaW+]b0p-zEpnFNOd,2jX1P-A1,{:5HM>GqnLYG?J3f6OfT5LJ.)\=4k(yx9>8-:k9j,]{(IHR7m>HNh[ti87=MOnd6li1H:>": a& = a& + 160
    Mid$(A$, a&, 160) = "B4pSN?Y8]KR8/2xU,v0jHt7,)NXeLMq8b\j7oKCgYR5R95:tiIq:5\Cu-5ha\M5CKjlVIWVIlR8KNgGLjL\vhhX()e6b[^';iQ[l|H\u;M(KrmT;;j?ad{qU*9x+<.;*u-rU0NIqD92Z|g<2F;2=q,0q]aD*\kmv": a& = a& + 160
    Mid$(A$, a&, 160) = "?WDB(=<y_,/[q:E;UQMSK=u^A<=hfeLZ,LtMd<oj]{5H9ilxs+nh{MIzA-.R{E,U;CNYMp{W_SD)O\+c8?eA>Y)qeQscIYK/t6_EWl3N{w5c+QOB1y]25[Z;1]?<t.F^Z|R:s[ZZbJFBkHnua*MiF+12===eEM<I": a& = a& + 160
    Mid$(A$, a&, 160) = "o'S'-\u3^2dyVP>q=?;i:0://yqAtx|vRFT)VcsQlZqaulJum;/\6KAJ?(ny]D;72jM>'X*]5J<Ejw-0I;B:R-E]b,R)-TTPRFz8w-mbis9J{]5v20dbfrX+hx6HIqI2pC:J*^qt/1XyJo+NNca^o6^b.5n+I;mI": a& = a& + 160
    Mid$(A$, a&, 160) = "JM^;Naw]C/}HL:I/<lt*7:9ci{=]4'ssP()V;b{9Nzao|*2lt-1)QnC]<U_09o3V4;r.t{jDn:OZ8T>BfTTUx7Axr6Ak/y3Fr[+BT<G;mGjvuI){6XONic0Pl4mxNzA4Gx/SZMw^<?O*?0)Z>3P6,VK7DCINVO4i": a& = a& + 160
    Mid$(A$, a&, 160) = "DVn^kznCRmE^\*,UMi<'<:?-dsTqF(jnVp5nY.<:MA_(9M*P4nJd'lGucuw5D'0g<zfhR?+X8,>t/2o-OlhAs^jDrN4lF*?/X)urqtoW'BI|Gt6a-e8Ug_|dD5g(H6Q2::LBxWXlDst*FJA6LiDQLgBSw]P=kU->": a& = a& + 160
    Mid$(A$, a&, 160) = "*HRk187X|eZUxto/?FITgO5=N:/si[(-XEVj:PpN]P7Pjlt]{I{uBs0_[LRVR^iDnrCRG5/>'OnUQCUP{1Sy.2\USCQFG3kF,[W7y\g]Z3ud)tDy8HxriFY|h'}5H+Ee>PAfO}A=csFbLC*1lrjn7ZH304xM\<aq": a& = a& + 160
    Mid$(A$, a&, 160) = "g^;=ok/0a[vpvO;}p.;2^b>jU>ohvzZ*z14yQzFx{(>+oah3B+pq4FYMG{6+;v-VCxesFG(;mNiD.{{vo=+z?I,'Bn,cu2Cy-tL?H6dLN:,v]gC2EWdZ11Ph{njx3SHjQ/<5i<_|8miTPsx*4-\8SarTl<<q<yh9": a& = a& + 160
    Mid$(A$, a&, 160) = "skW497UB{p(;Md;NxN<1z4|9n(jp7l6rR7F3v7}b*[LPDEI55fNi2TB-+tuSyH=W4}ozv?Jw?\9/u[l^[AO-\,pw>hv;RL,;q3as0Q3gOW^)p{3-i3PYT7RR\nk1:VNzQ+gtDe_n7Z6BCGwHa8?[=\BUG/nir'09": a& = a& + 160
    Mid$(A$, a&, 160) = "Z\>-C(xscH4\[|x-[-j0[PLi9bQN)W+lm(p^WJKj8IMN1|o4\oJNgbc0Mcu2Y07[V=L4+J^b|zTt{*_;'6<iNNm_34C--5AeKUsptS5qrkJy[0=nT?csH.F:k0cyA.;08y>qtm02Q[\k,C^o?tT7O'QbG8)nDAqq": a& = a& + 160
    Mid$(A$, a&, 160) = "qIjI;XjwNY6lxjjZU,--B;-=(6epO9aJR;dK1O|ql1d13wYvDy3^K,N]jN4rySRx+6[fE+({(BAn_o/5eltp|3*s*wtHOo*k+g4COblQI_;C^vnK.iu5cVy0wf*w)Yi|\66c9.=L1}dIpCz5P+-6Qo87}S7u(A{u": a& = a& + 160
    Mid$(A$, a&, 160) = "wvNga<xN_=q4G7g.4PuvYohfl_YFciVMBy0DO;telp8l-9,N*Uc15qtQN}v?ai^2sEg3NyOYO({xPd7pCjfM82hE4fBoHJO3OOZ2'Q>xTEG5o'kf_*|Ox+i]JFc[s?nS2P{o)lG4L6CLVmPIY3v2pwlz.fc{3iz>": a& = a& + 160
    Mid$(A$, a&, 160) = "|8,_{9^\([+D/pnkS-K8pU;6<r>pz_1FRGOStJB;-[u1w3KY9P]T-<Mqc<]G2.-z82[0g0E4mdm=P1*}|KuVn3XdY+G9oNna,1J5alAy4g8?+f\p/=zGlQMnaaH,tg+0E>FW>*TW.rLZ*YtZS=Ig3eOuHw+;Ae/*": a& = a& + 160
    Mid$(A$, a&, 160) = "JLJah+W?/BUkj(KCC;+b?2dOr68eRApSoTt1U2mElk:'*1QW0n-lU,|/foT+(rdSXc=NFIHrG4=u{;6GgSrToF-VmK;4a+y3KHMMVJ:;l.T{+,>:?g*a5Lct-()xX{(OwqMx'2Nopf,38L(S]e5,D)gCU+1{c4sz": a& = a& + 160
    Mid$(A$, a&, 160) = "f^J6mddAIUApXTFP3<1z^ro,?A.p|1L:/p=>6SQ7Y;Sj;5/ip:NS2Z9<tMS9l<G6fMz[^)RWBcqZ9M0WNH(K8W/jx:qm}y;:FyOIf^]1hYS1|{FzB|=?\U-1T)vV[8k>V?<oOG9[-yuI/n13K,Z*{{F6I:Da,-gE": a& = a& + 160
    Mid$(A$, a&, 160) = "rLP?NFHgTTc7xW|fLUf=e=DmHS4,BG+vLi|y(|g]UxPC>[yKa\RHq[:uqkSWl]|q9cMYYsOqetxLt}:DJO8xaODDYa4Mb_o'L5G:A=|N-KpN}<|Yu0}IE=wlNyxBQh:c7hB]}S*\PXMNQON}w1J7a:<;l.3t=Trf": a& = a& + 160
    Mid$(A$, a&, 160) = "'lz'YSTbC)8:R+c)QJd0Ue97TfhpiUy<09K*L00Jb4>VzsuAz}MtbHE>57:J-FT>SD*|m}1MGsm)6^jEzBNtA->e/wxb{/sky_'M''<9QCq/[t<RObONJ,r^Ua8,irP-oa'bj?SaW8>c6vr=gzNSljFxS+wSr*\B": a& = a& + 160
    Mid$(A$, a&, 160) = "_am^Z*>zJ4{DVehIuRc>q6*(j6KLI+1?}Ms?xPCf+xUk:uEl)5'.Y[V.+nTWZs+sw]'kWaa^l9Iu>_W}6yC.A6^2A'|C^n(s_8GDFs[Z2oh;YBt>)sefc41[0MRG}0-D.]OU[vQlRC-1:kbm4KJnL,303\yDpA.R": a& = a& + 160
    Mid$(A$, a&, 160) = "_oqKyj7}_9AJBoe?l<;KG:Q-GS]aOed+Ms}3S)iDA2ir4s71^lz()p{\egykm9Nr}a^=]whumT{?-|Oi\Q|SVcbGf|bC5By,07zEMSqgNrfp:B{Eb1Y1cQZw)tsJN0Lyf-3a-]:4zx/asZ>^f4o.zRE[iSw\0'P'": a& = a& + 160
    Mid$(A$, a&, 160) = "w[IyG+(;*mupKr<)pV)[t:Xug}ZnAzicgWYli4H>T>z)WL:2S>lJn{O.EQ=ilYXep*\d(ZzQi?}qd+rT2QviCDQt[|P*|yx]s75:2oyg0*2'B.2r+W6:dk1MkdK3X<MC._aMSL|o[c|G4gSsOy+IQ=b[9H;X_;n8": a& = a& + 160
    Mid$(A$, a&, 160) = "-.LW']rf_cq-h^5/oZxg5n1)1pJ\72L(jE=qRKR{e':dwmHX^<}G_SVAXadUoX0plLUi3MQa<\5c*SsJYFS=ECHD:y1'L'2q4s8\m+xjcFmg^\J>|oTlVd|*u02>s^BjK:kWNPJK;5S6]KshrJw4YVIDli5N_,iY": a& = a& + 160
    Mid$(A$, a&, 160) = "n9^^qVL:Znxy_oT,\)uZVxD,mQW?m:O'0Z]f;2wx\;ZgU|01{D=OBCii<G9zo\F5k(/zYxBD\,2W7v|Yyx*Ak<llD5G3/0}K]J2Gfyd0=m/]6N;.1B]2Cba=RUt7IPNKN7TM_{(fNdmy?>J4)PKU5WpaAbe,8Pi4": a& = a& + 160
    Mid$(A$, a&, 160) = "QzJpY<JKi:+'0F\DAmkYW3+\rl4uru-+1jjb1D754WB\=e5Eu2H2LZ5:kXHH>qL|2Jchq0.9<|tkTCEfFyfsfKcZp_p9b2g31g*/YT/K86U,}Rip)G9Q+a1LuC(y}<CCvj*pdmrC8RQ?})fyjGMxiDbsZnrC41cZ": a& = a& + 160
    Mid$(A$, a&, 160) = "h/n0b,F)SV;i<Bxn:yFpYweuMZSezXb[4sbZGJc?lJ)xV6TAwDR4/wf9MPu*S(*|Yiaf9rX7?cyWi^[T<<NGyzV[>9iRgBodu/fei3v*ajv=yr]omVs_Wd.|6(pQwDPp:FTGVPrl\'[)3gg/.ld0v<qd(ct]1Kq-": a& = a& + 160
    Mid$(A$, a&, 160) = "(kAO=OsZo7QAYd3zpEH^r48Hs8[/Em\jbxY3Ayg7KmQb|FU|-3N/Lyu\yr:/U+c0hMv>\QZL2FqPZ/pHrkDJ-OZ9Wt.X=/{^w4]Rqp\AF,a=?|etit+7^[lnE3[4cm^Bphf[;PKIrs{qpL<)RYB]EQW4OJJHK[ep": a& = a& + 160
    Mid$(A$, a&, 160) = "=\w9W4M66qtL|^gjJiFnh(<ZsY;Utw?Rv-RJPgza7xR+fLFv<2cMeO<su2P*lrY7{wLtL.-k;)SaXX8YEo(a:Ic:jd?FZQfsd<zqh/lF0=1-;1*x*igzKw:AEYBXy'C7+LRYZ)QV;gh=p0z^N_o?)9ce}[Yivhg6": a& = a& + 160
    Mid$(A$, a&, 160) = "(/H{ljc(6X6-('4Nkj7qLAK:i_Je0zAP*_C}u)os}Bk?R7lDHTnvG,=;i=3{Kbdg,]8KQ9>E(Klk+zbEpUQ4ykr2meLglkiAuPC+/zKZ|x?q]2=oP}CbU:0p=Kn<,8HcIjIqE|e+Y04H^AIzVlJcF}viZ)XX3qAA": a& = a& + 160
    Mid$(A$, a&, 160) = "H9HDfhk8<T^V(fJ_c6;B5JZb|W_L:ro.xQ-^21G[7<_pUd0,>{JN8e(cnAJCqP|'g{FV0YS<D2E^MF)DJ-e.LML7Plk=it(a-<H,TRsJVhFdEScCsZ?cCe9>iYgS4C_EMV:bVkg_ng[pe7l-ym_SE-|iHR_b4R>i": a& = a& + 160
    Mid$(A$, a&, 160) = "bLbPd8b,JA\j2ez)'ae]2DtE)mgaI<Y+;=:ADhahHp5cYir1V\Q)5PER2PK;-/c0xzUW)(W,+}M=xAy3]=iuG:+AQf2Ue/1kxHQsAW>^]:C3+dE+dd<W7s\}A5sQC7tb8c{oa,^?MB?IQR68gN*w^U,kqKVP_z2V": a& = a& + 160
    Mid$(A$, a&, 160) = "mOge7*f<zEd<+5[-?}0b/?yewnaIS1dk_.bkNAaK\a.RuIkY)n}]+83DAd:gT??3tEaI|ziT?k/P62i(:OUY:OPBsDJK6|Qn5h/LDcxv3sEx3(B'jvy9[WFHig:<z)/\j_Xw.(x9j3-7os1^Ih]\yo4KC_e+wBdN": a& = a& + 160
    Mid$(A$, a&, 160) = "|hg68[m\UJHbX1LNu*;lJwQv/7u^.3?C>xCe0vwm+,k1Pvqwu^.FWhSRQ>|.vEdOIbsnb}aM0p{3dl3|R\v'Y4jvFe'J/B9Ty1zyZgAe_}SQ>t2hb?cx2Fdx_[fBXghKPugvT5'Y6(^3dFunW*\]yIkD1QYlkX<,": a& = a& + 160
    Mid$(A$, a&, 160) = "18SpKM_C}Bu1yaEh(JO+w5Oc[|jlL0e=x,syVsz3}rmv3n:UM:;RQy<+2BfHO<Pgl.lR|z6K,.t(+2kZ(?[}BRc6:crlD6W_VgASCk+f6-4dy=F5]2r_^WrETK+uI{*1O[WywX9OF5B}5J]CcO^Jd|hbTC0nmxsQ": a& = a& + 160
    Mid$(A$, a&, 160) = "OFoY?f\0ol,;(Fo|BbSs9N+}ZC_U=tfZ\BFN/'_/iJqanP?CmvMYuy{wf?_I,DwXeEcn*hcG6+_YTZb5Ge4jcWj*ca<K(35uqI.wZ=V,sim(AoI4SsxVWXAr<01u1zyCuFvwj(WU?1;k:4zlZY8]=;N18.2>CjPN": a& = a& + 160
    Mid$(A$, a&, 160) = "l.bHPcyh9:R4A+PLFr-Ydnht/GxUV5P\Iete;r4WFfvirr/Q=;hgHHsfSB/pN?pn9rDXltcW2MRBWk[o)t0ukLx4Y)J.D_cq5*:}lVowb(Xpg+NWJ|jQb4Pbi=nSc7Xq1H+Nb+(a+o4Y_'mY_Pf??/UdBnp*j/.c": a& = a& + 160
    Mid$(A$, a&, 160) = ",*OJ'U/?navLaeIU+,CfhU.Tlz,j8M*,7M1=mHjL.zkNqU1>psotV8Jn.T|<Ypu;J=4>:qQ(,xc1K(\+GHLQ/Ccl'O*?^2;m46wUTJNjQh:'\}0b>N|S=c?)<G5Xgt.Dd{g]wbav5B)[Iht:NsJ7}''H8oSxUCPr": a& = a& + 160
    Mid$(A$, a&, 160) = "IZ_jIQ>O9J8yUS1vb1/yw,gfr:^Df>QDjuo?JhVQ*uz.MSysthpX;5[T1<wl-w;'.vA'<U,8sO}5MiHVR^hyqnoVh_ca:8RC:cqTSx{7PSbK:EpKmxx\wi-RN7WxFwN|CE;h^efz:-ftQv.Ju1gIR_j7mg8vNQ/c": a& = a& + 160
    Mid$(A$, a&, 160) = "17s:A.om,\bh]I2-v'}e0]ZA?f^JLfAikgYQOglP-uJZ^zG?}CU'VB0Z'\0/VP:ufd9>Rx*2VpvUh>7KoldbG)TmU*Lzhzes_/a5lFV_2jJ7]cWtoqiH[4|jjliXWYgw*7IdZ+Lfi-zJBKINp^q=56gbWft6w*Zo": a& = a& + 160
    Mid$(A$, a&, 160) = "gl5W}f4|{[*d<?_*ZQj0l(xK6:8hRctP\49aNr<h}s)LVAt'Ndp'e{?Kr/>QTHPJn'Wd2{H(zEXO-IG?=Wdlb|??.g26Dm\/h,(ANp=97xL_[Brx/h|lfYz[{7n\/huJ.i,M_TZzPZ>QyD4j{F,oP0?W{-CW=h]j": a& = a& + 160
    Mid$(A$, a&, 160) = "}-rKc59den+_4HH<R)zWCP4:M?pyVuEIG0^<*MT.P6QA4?2;|<jn17kzcJAZ?E5+ui?He6H,k3FfU4.xHfHrckAMQ\/TD7[s)GPur1x6mFAOojkyI-}uz]6\+oTfT.*KRVVQdoftt^O[8YA{wbjW;T28P{4uQZ;6": a& = a& + 160
    Mid$(A$, a&, 160) = "K2V{5Xy+kj?l[Rvp:25)/\Fcb)lkLZMhNTOG3+y'zRQ{t9(BCedAjl)_AKRE[5YFG9A(r89G-n.'EC}t++2No=DnCp|-}]fWMc3GV'^yhh3|n-N6u>/^?TCulyWwIf>LlY)uA;Y[UNHaz=Dg-iBrL(ah_AhAtc3f": a& = a& + 160
    Mid$(A$, a&, 160) = "NIjl\QpwU<X/=Az1U?Afq,+6+K4*xeabfN[r27+YQFbQoR'es[xx9]d1vQ8Zn6da.K]QbH[c,nZz\nge+T7MT+pNHgVxiuUas=a0ETpTN?Aju2-'3w5uV^U9TNZ|QdLf;0>--8OyJp]^RCjB|S,J/(ObAZ|w2Ys:": a& = a& + 160
    Mid$(A$, a&, 160) = "avcR9i6*T8ZI^:q(VPy\.;l:qLB2rfgdNGppJzx-D={2(iiXBLj4;Lv?;1l<?=<tHvjZDJzo4Zp/3,gHh(4/NP;=9b((xj2X]n9[K\B0wzG2Obe,lQRYjgn/mQRzzI'=6MaHqa+J+wz]VNeNE?7RDpu'l0s-eJkn": a& = a& + 160
    Mid$(A$, a&, 160) = "r:IW_dORC}lQ(A[cFa)9W'Wj1F[Z6\9Hrwk.[[Z=Cv3Y/FYBo2pPR<G_H6Mx2t-;8D/4]LF{,G|oZ]'V:6KgQpdM7VhCWmTAH,d-6Z\fRt>4cf4t\{tQR';=[1Cc3"
    o$ = Space$(8674): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N03$ = _Inflate$(btemp$, 9541): btemp$ = ""
End Function


Function N04$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(10616): a& = 1
    Mid$(A$, a&, 160) = "4OE[6{Dl8)]YQ<S].jxiHm9m)7*>i5qTOrju?>uO.3|SrA]117X-9w{[X/W*qpNHvOuicB7C.4BQjN>0HcBIhoEQ,QIzLLG0P{xW2{>8qzO6CRUk[Snbx].dIp*KBP)[WZ53ir'K6WDduXTaQB4Zef7v,}6ym:=A": a& = a& + 160
    Mid$(A$, a&, 160) = "ozINa3McM1>6d38r{/qc7a>DG6;7RGcgIVM]8sw7{<)GxL-nWvqOzN5GQPmc4.Kn(un5Ok:<UozD][0oN]>\tImNGZ.Xfgrmw]<W2U8n\8-3'A1Eam'^DHH{}-a-?|G2kadRkI.>rMGTmfpft=MeWnaS}uLw)3:L": a& = a& + 160
    Mid$(A$, a&, 160) = "R8>w}hMsqD*EhLyW4WrdI0u>=vFr/IB-<(Ffj9+d|'x)rb?AnT'4=OoBNUggO[u06gn+X^nnVlq-Na0rZ<sefF]3SHR8\08:9mXods[^edg[VMpDvn'/Z8yPgoo*EaJ^TYiyPpOT)P+gv0ElrVvl}d}fg-CRqNg_": a& = a& + 160
    Mid$(A$, a&, 160) = "-+3BM,/cN13z|ExY(J}G0l=>mSmT8w^Zrp}MSe[T*LQVEP:BsM+6F>hmyOv{X;5V/H^za>kQ3mIQQZfD7K.gx0hl.iyfMl}T[j7TmubL]a-e)fTjxB6U,{7Z>O1:;n>7RZvFZdE\?-tEQQ2MMpgRO0?crdR4b.D/": a& = a& + 160
    Mid$(A$, a&, 160) = "tbP_smG,7=D-DZAwC[y[U8i)eW?{7fl2|g<}G8_p+G:FZOD^>p6USJu_X,^)K^tbLKkVyoMSKTpst-NK}o2kvG^89rZ/:J1I1uX,(snjH8+7B(h8)sp/9wK,,*xuAy;6Rfmm\NIE8g7lK1p^>w.n\KIx+WIdUQN8": a& = a& + 160
    Mid$(A$, a&, 160) = "9ydx*9R\M'Dq;3g[A?cQiVqa]h=_*gq3buBaI(*JSyar\y2)F4]zW\z;hm,G\Pg[KklvmE*2kQx=A\l;zb.:zPy{j?}1>a<ENGUEK<Rc_Xh'Nt:=e6]>Dnj3J2eaRTufhrQF1P11={<w)KA3,]EHvJx,QAL}w^39": a& = a& + 160
    Mid$(A$, a&, 160) = ".AB_ip-HN<C7uJY=TI^Eii*w4?({<O(a/;L3OM-zMA*\e|EF_UR:*Wqn-9x1s<'LR-r9fj=kTn*/_>Gu<Iku,:d/h+yx<{*ubi|R0Uq(W<b3=VV?EFSxNX2/-+<8YHZPLE[X03hThZ00grsDpSsvo,kgNz0eQgt*": a& = a& + 160
    Mid$(A$, a&, 160) = "yZ]/I]2CHutjWt9]zvc][4_o7:urg''w,x{]Dy+QF(hNUB6je+Is8z{kiYP?M8W^:\wqMOAZ.8sZy}.c1]8Gj}yLs2NE.XL\C8}OgtH;)=E/ejvw3}}[Nh[FDy;\s+^rYd61rYI[/*FD-G6KXDR{)d*O}?4FE/KM": a& = a& + 160
    Mid$(A$, a&, 160) = "'WQPup4|SdD4[RbsVU{ZSk/Ltmq0BITYt{IKaB60v<bd*v'\MmWKTrm0Y>Lqw(nhu\-qXi1Wut0WG.Q(3jb=e:dh*_Y1z0Kt>J]Nh>oa};s01WnU1*S[>S]u.B;QFEPvV6kdd|ZB_IXhXw}^ALbP1.-4VS3'b|*]": a& = a& + 160
    Mid$(A$, a&, 160) = "IZuaYM-p=Mj:8|?(h1w2[4zvqL8,o]|(_qIF3k;b|vrcRwJCt0^gKH<Cr_Y,sr'bRz2mdBqP6Fn]=z0Ir>es(M4MJnVw1BK=XA7aRSWInu8O<e^W5J]>vBQZB54R,RkH,caQS,+a_P8c3sZTlDixIX>c.'a(T[Ux": a& = a& + 160
    Mid$(A$, a&, 160) = "9^gsa5IcU425zu'wn/l=nI:[6TrauPe/Z_vlsnb:s9Am4Ih0.q1z;]._WqL=bj,o;BcQmKEgzzKVcqR>WOrh{=/ndDae-G03-(y2B'l/Y|/XlZvyqx.9SiE['2d9y/0CahT_ftA6=jk3Jd0j;}:H9X^tOYgs^|mp": a& = a& + 160
    Mid$(A$, a&, 160) = "4cs?vZh+\n?6)1Uhjexgd;[56-a50X)3IqTyi13dqL+2h17/+UX4vFY*CtemGWj,][cvDD6*ND*t4?Jo;3fHZ'\_b3.HZdWQmd{.vUeRLEoXDpEiBDHoQrp_W4]oMV;*FEj7pTAFD\_C/l3uFa4=a{tkl:xAoXKd": a& = a& + 160
    Mid$(A$, a&, 160) = "2fMFdpW+D6/8cxWCT3dI,Ke6_O=XV8i4kBUEC1L_7_8[JnK-c;nH3oZ8([.T3D:_8MWwVOcV+0nS7kggBq,]w-kyo<Rfq]]rCNND*p);TPaYy|HUI2WZaZ<[27e0J'C1ugzcLZRQ0j|k}O5wD3U=Sq::j)zl2NUh": a& = a& + 160
    Mid$(A$, a&, 160) = ">,IN|TpywqZFmrzMl04*DRGn}fm*R|QC|o0mYWz>/PBL+]X4sJt>:s?4h6At}yktmYAAnKxl3P^;?uR:2d|h^bxQO;*FC1yzB?_O6U3|B/\B2efny0pS+eMfK3}Yel4(.al(-E**=SDBLUVMJ+cR5YCPj2WR-jtJ": a& = a& + 160
    Mid$(A$, a&, 160) = "5U:/9pVpnF-X}b(6FV{0FJeUJd.]/]t.>P5/=aIRH]59eP_3Q33a+.l/9nB0s88gFwU2.R/I\<b2^Yx)Rff<DHcGl\|d/aHiQo0jMK7ZGgk[jr(pq,pwPZT<hQ-,jzAgaIatHPCZ91A}maA[pk-k5lJ.HgB^ZoMA": a& = a& + 160
    Mid$(A$, a&, 160) = "FJ7SUgSQ[7kTm=mqYRX;(aqT8_4r{-?4]bGECNN\{_K/*,;(;C?ISn0o]bZ}8B1EDdW;+AA[f.ER)xo<Yl|0u4<w{YsME5;F-r_7u-}HI*Gzbd.FW3Z+s(3\f64,xBJ[o5+va<O8l;5r6dt(MO'et[FXBb?qb11P": a& = a& + 160
    Mid$(A$, a&, 160) = "pDeLn:n+IY]QxmQs]NVjnbu;C1_38:m<SHjlu6^Ww^WGr=8oSrfN|7kT+4P;Ue.sEb0M-hwYw2[=p/8);FeZ'CsXFso9;XqhZQf9q\UJOB^M0KSjFAmm(EW|iQKi{,_<qT[1}MuBbJVF''m|rD]M8u.f\zgJ;eXp": a& = a& + 160
    Mid$(A$, a&, 160) = "l4o8(Sk5p*5aorMqTcQ=],LBq9gijIWU{C=RF,.,[CiQs2*H'arjz0:YoS(cN1>Kn+?vKCV=U1Ks_e|wiT\MGU4askVMb4foD3Q4P=.+>Hjw/p7H)A8X0}|-TUmqRTr;2[3iSOjG2>Yk)2p^y-68]y99B0D)CI9c": a& = a& + 160
    Mid$(A$, a&, 160) = "vI|ys}Awta<l,EQYQZ,ouOraer,0i}V>sBieozYb;HaQAEnT*)q3a<bnq<JtiE*2'|qtx4cc85,dyIZks4{<pUm0/w{umf/UMioSvSyTz62GCM_sk<9af}:5=D]7/d=Ag9]'>m4'^N-,5y67OJjG[YVXHg/_DaN2": a& = a& + 160
    Mid$(A$, a&, 160) = "Om.K.x]<eEyNiMD6w./C,6Dvg56DpgjzwzkX6Ec])N]+X\AIbhpzg2T<o=9vGpJ\fm('k'BfB69y183joZE/D,yVbtOMi^p0sRqWlzrwk7[5p2Nsz9jjZ=:=rPm^diuU8|X+OuUANU)_dAo<TLMB)^,obiOiw;k8": a& = a& + 160
    Mid$(A$, a&, 160) = "-n=1-zHn;|QH,m*Z[spel4LK6P?MNnnjW)x_O8rG22;n1HH+xw;c9u72;aVoxHd?;5o2yz'Ai]HAB;,*pBF17kZ[uyyvA[NJRj6AZluBz[ZYB9iy|1.2PNyWro,)YNAM7U_EKkbilgBUsO(*Y_=DdoS.*^w-Y-_d": a& = a& + 160
    Mid$(A$, a&, 160) = "spQ<;^]Cm=|3gy>SDmGUdsMi/;-tV8<fD,9,]z|;9rJZXTAKZcl:t9itf8;t:n4^rGkn{UIVZ7TBBS6mYSzi-'Ga5S|JK>.<Z85fTwU)ec4>hr3irJ'**k:|G'5sd>XuqJ{0EG0P6{lc|p;qlj{:0b.FIGvGRL+?": a& = a& + 160
    Mid$(A$, a&, 160) = "RZ.j(/73IJ:O[4/3z?YspT^6wo*TWKdR-+R6P8}x4t0cquz9MDr;?7E]dh(D1lg'CYxwg:<U-.lBA\dMRHy3EJntTT8k**)2DrE^c2bGI.'oB70todrk3TRN{YhmIeU}mO?W>VsYNpA'IesKxsw+;|5g+De:4]Tx": a& = a& + 160
    Mid$(A$, a&, 160) = "=s<3.?w59IXnh.j{_\\L?RWXZBu]ouS1qwao/l7EDt{Q3vJ(PFn::f70WCl<s*Ya;jgm3-Kx3oG:8aVMDJzYj0G^cV,2_<^u+z,/)-ha,7-QNi|IKOzZNvHCGqDMO;tN:;.-cX4mj<)QS.BOv;_\.U7+.W;VI:I=": a& = a& + 160
    Mid$(A$, a&, 160) = "VZ:xT+jR{y+2Bg7yS,:4L\tY:k7oiA1T)y6bqJW=bYPv{\KRl0/]n1Sla)J8DZ<^OSG^189ya69?SJ[7fkFnCx=(b=6erN{)iOxxOWlbuyFdd^gh,=y.=CpCVvlA7g+Zy_=Q:Nez]'p4sK|f6pX*yR<*MP[aW99M": a& = a& + 160
    Mid$(A$, a&, 160) = "j]C(jl5\WH8G4(fIg.oC<W\rv.Xy]5(by|L[0A.MIIz)Wu6Pj76sc/|W3]ie?zR7:jQi]aznNQl{Fb^vRw,h0NsOxq<m:d?fPaGvn:-*=X0u+XYEk51i9CyqhSVVOY\GsN\BfUx/M81Jwt7Z/vAQ^Upha=zFyFfr": a& = a& + 160
    Mid$(A$, a&, 160) = "h:;;0wNo.[yYl-w;HX9[M,GUEsv'A-'x(aGdl3;M9ZeQU93?>JRO8(>4idGeL_}^3+4B*|THHUR6\mVT|^aI*1;H9+;Yyl\sxpqG19W5?>[8]WG>ug2,poN0L]?,Z\tE}Zjb6>e)ii+peHS=80nW;FEh;yp5Cr>/": a& = a& + 160
    Mid$(A$, a&, 160) = "n^Wr]/I_TjeM=uUuV-5Nw1d^Yb2:7oXk9(}.?*?yXR>Y?P68w-^wXD|M)TZDRtg,)eiR2k26;Fg]wQ(Gp8C,A7>6YNMV|<c1wG?/nTR|GJ'jC]gr|f<7a2u4Oe\ruiB7=|xntaFL\qPOPZ.Y]cippIKjx2E8=/j*": a& = a& + 160
    Mid$(A$, a&, 160) = "4K6tT'aD5Jb;^.V\t0z*0ls.3SEBKF\b+psk]lZVKMV88]x0:cyh9o{{y9'sgyiaht0A4Fzx;.Q)E'v2}nkkFHszrZD(eKQG)w=ZG'sxT*ssCRV3R(,YppTyZ2nY0kccXOjkbb?dDaMFwz,Lh,T>P4j[pNIg^M5g": a& = a& + 160
    Mid$(A$, a&, 160) = "407L;WMT+x+Xc8B5[fil9eTGJXaUBFQo.gOjULPHzSEFT]:eab75/Z\(m(**8,A4|oro'?Ph_gw/IIFo5Lt)>JziX\XPwJlcBJcJ{vFPq.;t\w>w*roe,NIIJN3(r?)j<8G_(>-_;Txl2'aNy\B5*kxw94l6M1uh": a& = a& + 160
    Mid$(A$, a&, 160) = ">{:62SmdgfoG[kLw6r<(ofDQ^au}_SwYnM[[1v-)7q_I9s:xhX\u_J[m7Joxgdt{2{UWvnuMxxrl98I1C5NcaE^6RW/b)3fDL\Nwl36ana>auP]smV+:W9,46hC|WV8Xg_/2_pW*tnRHpH?S+p),4[Nq<5Fy/Xy-": a& = a& + 160
    Mid$(A$, a&, 160) = "=js.)a6c{5A?SZSgdE[to2yusM[//7]A\neSGlVe)MnF^9_aT}WU=/hdsL1rjfdEvNKGs|1'.b))R}7cgUUdnfBqsFU\<ex)]d*qy0Hl9;KeZEFJ<gS{chaG_Ku,RwhX?85z>;VHzAMoY=N?L_M3NCfFstiA<Y\:": a& = a& + 160
    Mid$(A$, a&, 160) = "SCJ,^.q+IlYkQzQIJY|h:V/r^ARyFq,XK_._?M.p>8ouLjNW*/{h<T/k,YoIXZ9Uja/fzT=>4*UwlCUc|MN)\/OJ<hfH0Kx7>e<,fQ9AFD2;\4+=25501}v]aIAD)<B12^BpH(Z5/\-\d;x/cm?<F7OoJ7zU)=pP": a& = a& + 160
    Mid$(A$, a&, 160) = "?ldA)P*]11W-o(lS(8>*Rn0G,egJI'FFzaIXVjAQ6tnpWlf2ih8k1Qpv:PZdZQo[5Ot-YkcrtAU=)[^M>z0nb/ZHj}rbCxnj9_0^6Kv71)K3Q^AHuG}Mw+v?[RNTUg'm]F8os1cnOUG}Zgk0?T_Kq}ZKwK_Vqaiv": a& = a& + 160
    Mid$(A$, a&, 160) = "nEK+7;=Qx{kA}sg9'g|MC'{:ufQ1?i/RPkQ=PxxgN=BO)oGChNsIfpQvFNXOPP-Fl:){vUMEmY}'49V.ki1Qi*ARE:8C_,\s,|-xtG2oYjiYuYGA7sHwNn(UJ1>U)Iqkz6+^xyhR>Zk1n{0.a{uKBHY,2ca2tnzM": a& = a& + 160
    Mid$(A$, a&, 160) = "2xVQjebm1[)D{pX.SV*fymh)W:K('-Iyn<uWne)/z(NJA09{oo{y}^QA<3cW*_gdi)n3/ek_.*TaRCwl[Ch<IOAyK7Dz?<6QxTZ^_vJLpq/Cdk);-0jagVDt,XfqcdTP\m*R?x;Wp'1ZUciE{awy/T9vfy4hx[Hh": a& = a& + 160
    Mid$(A$, a&, 160) = "a?7\BoHx^KS^3v4c\];X15u8cGRF9L:xb1kP6{VlMJby}sZg|c{eeX'1/,A^mnZC0oQF(hEEce]G4ET.ugM:A|cWq)]VW[tb/ys1-4k1cql-o3P2,1nqmROvdTF__cI<O7eJ3?zP_29?9Uwc_g1p,UC(.]0l36.;": a& = a& + 160
    Mid$(A$, a&, 160) = "Y+:h7{Ssr]UFhYohzHNY?VHEN_pzJjHv:ESk.(K2LzD,f{AyGj,V(Y20.t6u>Z/M0KAWkC3Fm_cUowy{O3aB[[xS]_FKu2BymrjmJjcuOEp<xmw8E78z35CJ2juA|UO9Cttv:;)-YnSER:WH9lDg6^[x[MC8Vdp=": a& = a& + 160
    Mid$(A$, a&, 160) = "-T6V6VKNv7S?nXBO+a;MbjSrXeqny.p:go'X4w]d5ja=+M^'9GKjbsC8HZBJMumL2Vi/Frg4EwcxUp/V?vrpC2]pm9t,(mD/])Z7y5f5wt.NvzQgy7tb+r:KQZo,1jIK,9,xPxXaP'Lc?0Go9UKz?Za(OQ:c,V'M": a& = a& + 160
    Mid$(A$, a&, 160) = "T'}F|uTi3j/w6_A<]}HtqaD.ubB8yQGD]*u?0DwkLp??qb/mdjspk1tHW(Ys4SgE6gI/.:>cA;NvJpT{RRSz]gYjt9)-]r-|l,tdTfgsgw,+kd8AhMv.\GplcyC<B5G<|bwR86qU:O11MSA^peWAp:Z45d4Wg7R.": a& = a& + 160
    Mid$(A$, a&, 160) = "cvQ;Ur/pDckp>R30zCCDaaHb7U8ezz(<IO/7j.a3|RK)*<hY<)KC0aOaGuvxJdjVCWNodav+L[FjAm'r3n_vvjcstIM=zN[ArW;q(_;M_^kBx_kbkAsbK{x]2W0VB[FNYCP)f\Np(._0e+:W:(-uIODtmToB{:A]": a& = a& + 160
    Mid$(A$, a&, 160) = "WFyd-(O7WVOtA]|?gbB.8PQ2(RO9Eo[EUN71f38<DA0BX0WlW?Ud<-/?uPb)Yv=iRM:MZ([W7>PecExo]Zr<D\QiibtM{8xzxN>A3aO|mwf+HFe(?tG1[0)aPeL.-/d7]Mep;enl**xt1]C]yctSqB0DtQN3xl\/": a& = a& + 160
    Mid$(A$, a&, 160) = "nU;{3LPLJoe2h'K\Ch7',FKaadnLxxPh[3*{?j?gok:n?=x\GjX_DE.,EHIf76{r3,UVGe'GN7sY^:u]JVjPtYpd.7JdS;Q'^:c{_B4GbDQ2}=Tp;fBT6JDnVfO[VT\9=F,Fk\ot8,OhThf*WN:fpNiKWYd81uW>": a& = a& + 160
    Mid$(A$, a&, 160) = "4]W/fmUb?VglPnB[r0f-M+kO}uvcQ;_4nZ'2eh,v590W9SN)r:MF10V('mT:G.gY[>s[+jXH6h+o9UVV*'o[Xb\1afIN'E340_Ft8u{3qFx1Y-Kuc=ecX],PceuRTCrgo,wTk{i{mI86fKLf(K5k}=A1s3ei/?*s": a& = a& + 160
    Mid$(A$, a&, 160) = "x[CQ8lXryI[TSuh0_ipqatZyqlR;Zv[.OPM7Suz^_wdxv0*)(]?Oooq>:SBJS_v{9:1*GjcM+3,lYfT>vAqX)*Sg>4Jlu';Dyet^SvqO,UCauyf;qDHa?aHU3.-KIRX,Bk>oLcXd17_Mt=G5mksHM-TrP\OIx>93": a& = a& + 160
    Mid$(A$, a&, 160) = "tzk>c]rYg6PIgzQw[MW5h'+H|c0>Jk_Ks-cy_6.y[BRy6iAQ+|Jm69HME1/NX-a+MPOMwxvcu(\HB=Z*NlSp44>YhI=f0w^aSqwdW?fXkpuQrF>a6je5M>EPXRx/LQ4STii9T:842YOR7<8]S3iL,?UJ,3_R0tR7": a& = a& + 160
    Mid$(A$, a&, 160) = "\kR'gcBtC'Z.(U*zf8OOj3;>7k*hkVBJjPtC+,9wqJCCE/(0LCZ7Rv8e6{W[]FH?ogU[K,5Cd6?to,vzqo?SbTH[AM,lP;EFWP.VKlL''o+Lzxkl)kr(8ik23zlusUcEv]^0-T,cvTyF}AZv5NSh|ljFA8DGe(ji": a& = a& + 160
    Mid$(A$, a&, 160) = "<?w-^vDEcTxoYaVVciE=e4>0r}eErA6'r=2O]Pt+>u{n;'U^;Jg]mbmnuGeo<,N*H*If*Z1ed,-bE]I^je4[U[<b.*hCVQdk]m([^0?^IsVp*CjFLN?et3UxD_(F[kuv8nJMR|JtxC|n*Yp-clqQb,E)uo(76ME[": a& = a& + 160
    Mid$(A$, a&, 160) = ";i}jcEE?]XY.gugaH<Da4rSn_tuh;.gvRzDI2pftM>*HSKWt'ngi,wo*S/DqjcJqa.wB*H=um2z:Ox\f9'QF=q\DrMA0T7_^7=2hdl<{J]T*:UK]9m.iCL\6mOuJ9?,V1]U<lTcrgBCQ}O(yH'd.ID<7]F:1HkM/": a& = a& + 160
    Mid$(A$, a&, 160) = "+3GQZKNmrfc6W^g]i1dH.JC4b4JM'e4CPEiyVt<8S18{H3RPS}YTs0IL9;_/CKSwm'kR?hH[S_fA909|5-.bL)DeMO?/ge<9Mq=MqY\z''/loiybo=6i\aH>/U37w(;,Us'VO/fHauU-}:<8jy3V+UuRFBFZM>vI": a& = a& + 160
    Mid$(A$, a&, 160) = "}ND:fma_UFsi3_L3ulH,oNw2Ax6E(r3ulI4G-PbTcMDs,=O23xzm'+2WoyjG)N-CZq7S3<ZXN_26/;O(nC\>sonGFGFb8hnBPAJ=7auqhR01}z_vDzy\urzJS\B]*r1j/6[x{30NVCy,B/Q1k+.^aj\c5R=i{)*S": a& = a& + 160
    Mid$(A$, a&, 160) = "X3P46uA^hbfP{UccI{kJyjUyMZ-*Ysy(qb{?nI>o.TU'y5tzG.s5KvF9tkDLq/<LAm=ZT6q\G?,P0fa_BnoDLhcn<<J/viw)-PZ5kOS5X<jL{KnxWqip)'rVQBwqqu?mwT|]HTWk0RQyLRokm>4u+cqtB/-pUafX": a& = a& + 160
    Mid$(A$, a&, 160) = "z*)F:,08Tk_4s<.Emti\C/D1cytpwLzmGH^ONEComnJEJNdMd9LmX807^DruWZ3.d-87-/rD^M6qU1w_iG_87Zcn(DnAZ)X7C\qU(x<6\f2[}kHigIWs\qp=2.TCMNT>[T/qQprjL[aJ9aro*=tkfLA=Q4a9i^*?": a& = a& + 160
    Mid$(A$, a&, 160) = "AIO;85NeJod4sgkpYW9Y3XSK2S58_XBY5;lA0F;nb)zvF]F76<Y=qL7mC/i9)XRJh7ITqF7]+q7o6(nc/65ogZg[eGSG^/e7td=B.L/P0}0_VBhrgq.cx}mQBhbC+WDZQG7IuJ_A9nf^.8I<NF/SBiykuOy+sT]F": a& = a& + 160
    Mid$(A$, a&, 160) = "6m,9K]/jDa4xJ4GbB=cFox\;qRU,V|6us9QpJ'k5?sl6-D8wykbVs/8Qao<fkmUH<d(rTf*Ym=K>5s7Z;+v_ioi3U+:rmpwb2sI\P\4;v[kCjj+f8uZ|8A-<pJN>dMx:m,.8kiUf43_pMd=m(C28p'{z>LM7-71+": a& = a& + 160
    Mid$(A$, a&, 160) = "q[+e:C)L0s)uin>D]Wizmr7Z|PW,Y|3alKKOK]>KyRMH-;f}{RxoRx7x03Y</fYhVg?s|DgI;{TkB=6m;jC)F;j?w_p223.UI+[?SXJ62)wDn6Lluy,^LYN_J>Lq]4)Xt)iH*b<w<_6G\Z>T2_iRX7o<G/Hmo3Mr": a& = a& + 160
    Mid$(A$, a&, 160) = "sS<IRAsF^LPkCVgq_J4X+=^ekm)*f,_ZUI;SU-d9=4mOF4M:Ee_FsLRwfSSCg'M\I?qW)j.ZPWDqxuJMPh0xKC=WXgPV(.m|U>|0uj<0I'h82,tTs^WA9WQQXC]5Og>>g?{NnPEq<gzh)3\nLfG{\]e8.Q3[-f=P": a& = a& + 160
    Mid$(A$, a&, 160) = "OdUyZ|^1Y=A0_B=td9Ytua[2s[cSc:yNQ)03Ty'on3QZDy:RK=y3/DKm*]*veL{Zln5YQt.:-'(PvL,XM8-Heh9WU_JRdN,oNF-X17Q20sagZ|Q\q<(p.lNx)0>*,|vXl745lMK6?R[S54{aTgYr1,JY]/(P_\o\": a& = a& + 160
    Mid$(A$, a&, 160) = "--;PZLP(q5bmrDqVK/H06Z?>Yn,Quzl9f7{;H{M^q2EbsbK8g7Rc\b9|-vOONd;gfLop2SzFT)+jd/c>GUyO9m:E'pdZ-osk24V?7FTJgW6P4Y>:mz.oS?SP^'-Bug)=QpOWsDBX+N/HH*v'?o,?A^CZp/CM]af{": a& = a& + 160
    Mid$(A$, a&, 160) = ":GD2a:M(.)2'k;+YUEf\u[ke0ng>?vCyU-8mmj{i3M1?WO=:Ft00Ekal8[9gp4gOr4SZK]E?ozmse8>Ydno5E?gfPdhB+IbYxlgVT[xme3?bmL|YP**VpI.'L'di>=[p<}JB+5,?-O3c9*x1:mI/\5TR6B0A][v:": a& = a& + 160
    Mid$(A$, a&, 160) = "U7_]DfZ1b6o/ICO{g[bOe3K_j'RW><P\4^],,/\y:.PlI2APdNvasGr7zZ{yRQ<OlTS()R/esFBo;[P7XgLp_fkGlDzV3Ke</NsyFJkLRn<*o)4]]Z7F*yrA>v)Y{heA-:}V<YpT-_^\T,.XAf5VastkX;vMU.dU": a& = a& + 160
    Mid$(A$, a&, 160) = "nX(}AAZBB)}K\]G0k7rhbaSH3z=[u4(ZuT9(<bzcj<;HDDqKLdadJ^SRUii{8P,XKY0wrBD+=.ZH+})py5_MOFC?A]X0Ufwe]M1sYh,ZebhWcU-g0tg)j/9tXkUo:F-jyO14Yp-?vqWhiS+zUy[hOdM-M>kiGRtP": a& = a& + 160
    Mid$(A$, a&, 160) = "euAR5if2[F^'gU<5({5;YmKpv7>tR.;i2x)h.o2Q|5H=n,3Hb/gKx(k-_7wVAI.Eee->g_.\9]Q{-r<)aqDrr-]\,|uFN[JIV^vCjp9IT?9U<yNiWJP5disa9P+g6PJ)n8v0)Z2O9;yqu,T{nFGIr?}XZwEMCj'+": a& = a& + 160
    Mid$(A$, a&, 160) = "OqQsg2g<?ZS/QKrW*P(2Cj?(:c<F3s|fv9;s]N[7*3dK++C}lA3wC'hK'z5tkTaSE{QJ{S628z3urwtfG5^K1n9cq[f7AuFwF)0Dsu{5H+.{;'?=WxMAk4u?(]hReiEHcU{*Cr'bQzy)Ry5cz0so_OQnkR+_Wno-": a& = a& + 160
    Mid$(A$, a&, 160) = "8XWA_b):6P1/u4}ZvLuP5<?O+P[_7[(wSL?7TuOJq'R5'LRY;q,6wa[JQBLjm){?KJ=u[{,.Eg9mM2;}flY]>4U\.sq=x>ONuzjE4lP<(m*OqalmE^cPLei54ZJy>6Uky}Ie=?ie2QaZc,[5AJbhX]64MerAC^82": a& = a& + 160
    Mid$(A$, a&, 160) = "=V2PVA-XI,7I5GE0A[o8esZL5*\,z{hs)>C'/bVa_\Ww?G.a\s:cjqgCMu>bSMC:qwVz<<yoNukN6t:}4<]o0NcOEtn08qeN1xxn322jt;*i]jW[o<^k1+M1/nEO>-W_DtAVHXhkkQ59<5|1k>'7aQAB*Hc3v1pw": a& = a& + 160
    Mid$(A$, a&, 160) = "vRJnUM<H5BcUm_'rLm6HS6bVjPuBNFN*9-6r'4(}H{<JMV[\_(,1E"
    o$ = Space$(8489): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N04$ = _Inflate$(btemp$, 9366): btemp$ = ""
End Function

Function N05$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(10381): a& = 1
    Mid$(A$, a&, 160) = "2OE[6{y99}QYOVHMq})lg1zL(T+3.:/4A=.oJ:{]Z8,yq?uAn67R[c28uZ[lMK-SPemPh(n_L?4o_n:scdgMV);X?KZy|x30nKq]kANfQo;'QTgzz/Zhnf.SafoPjbyrwjOwSNU<BvRh0-wP6KN3BNnR=_(+{9n6": a& = a& + 160
    Mid$(A$, a&, 160) = "m(\C,e(AesJpoAuu-V{|AEU>Fn..p8N4Nz6vU|.'.4sztMxm;D=XGIArK4HE7/ZR^|v3LN;8/Kp7LL7A;3=SVZ^6X*np1A;RO{RQzD/R=u'qyphJ6WrGFd6m}q[1K15kfvS/_IFgTX=FWBA|KI^AX'K^LxAOEphE": a& = a& + 160
    Mid$(A$, a&, 160) = "snr+\nuDkk_h;vy1bSW)]'?iKA>L/DfR2*'1MZX:eEadW3ePH1|J}}i|d_'h-(b7FS3Vho'N*(rL:OX)AC4t}n5v-vf7vMo01ue;Z2]<6ZYDTQQz<n=]J\o,tA=+1d8rILo',?,h]ia8SdT5wkFt>B27qVtNU1p{": a& = a& + 160
    Mid$(A$, a&, 160) = "}BGaNCzPgss,|}dav|;SvCHzt7PS'.[Q4;kz,M\-/,Z2mpYNw5e4s{7+8g?*G=EmBI'ugEGM\i*/n?rH[kcGTHNaZOPKT7fnbV=8o[,aN<oki(q*:5iBVm:df'nH\ojlYX^_'[K{w1jS{O98-_L6594]olk|:bS|": a& = a& + 160
    Mid$(A$, a&, 160) = "FOyp4_?z}o013Bjwc2{Wkx2=['0(kSREbq})1aZNR2DXzqdsHvW\[|cCQxp_;fjz9CcPu)Y+Ps5,a94,)T2](zqxu05^KyliTu>:B;m*b{XSjVh]}rui28n^GgvyP.9>KA*k5t]3p0=:BJV3HzjO?i:NAxHt^A1*": a& = a& + 160
    Mid$(A$, a&, 160) = "H8>M}wo4gj.(KUWv./a\Vy=6^lA*6{HlS\F8kJ>h7KJWB<fgn_^9|T=)m36F0sa{=vTg_sWrD.bjv7yyrVHNKbd'H2vB+-^4uhfOy*}fPM-|o,rl3*-sGB3D}qSD>Ew;)XE^>}2(]U;gMAb(.aEbidZM4)}VdXWO": a& = a& + 160
    Mid$(A$, a&, 160) = "md\B(*8dV\YL)knM.Z.uEZSmz[j-jn9f[p3'^y(2LK/QNl6'G4=lu5SAVj|?=7og0^c\hRP[}]Wy8145DP]V^qt18H|ydZTKmTmL:8W+=K:)Cx\zV:jb/K+X\C;JJ)+cU?{s{j7)MN9doRHgQHb'\3C.Na46lICw": a& = a& + 160
    Mid$(A$, a&, 160) = "^e5Vu){4wnjEXDk)+.dJ7TtxFIqKa26b'b]VA3wSL;;q0xs8yez/l{;-S*|8I=|CnVCJk9+zl-_Pg0gui,\(vW\qKZd5pP}IS|)Q+m|v_\iRUG?HU_IHD2W\[hN:M8i7IPcN\E|W)[WbSe+>,0Syyq4a+pz0;GO2": a& = a& + 160
    Mid$(A$, a&, 160) = "?EUbl0]>^'E^FwuacOP3K(xD7r]k/StkZ>\pkF['=OPKtrRT7Q4vj[.OEK2f1Y>}Xd\unbFWC;XqeaZD>LrC]vvPw=^\VZseB-=p[O0jYr.3C5k+lcuz^r))/K|>ngX5iQB=YuvqO7VbK,NI.kWxIN-N>BXdb^d/": a& = a& + 160
    Mid$(A$, a&, 160) = "CJj,NtT[aAHB(lV'JU*puIz*)Svnq7UIkA82?mE/{\w'^<k0Hp8BM(c}_^CUDcGO;7]JCZ)2?pwQgv0N<F'EWnB>1MGX{d-ss-;AuhU87cOPN'X'Fh{Jsa2n+f)TtFv|2,egj:_-Dk0UE'de?RihSvu0,<A+Xi53": a& = a& + 160
    Mid$(A$, a&, 160) = "lDykoR8wEFnJdo8(-qqqB>iRPiXhwJCPh>DH*;<GFUt-91TYmoH(].?b9]?xX_)RX;,}iVJ_JLPSNh=1B4/bG\IQ:w.q^cx{:Y/>uNxCJ6\H4^--P9];XsfsXLRZqX[9kC5ebGW;gtiE]hvk1JTTvHM,[Ew{\W?'": a& = a& + 160
    Mid$(A$, a&, 160) = "+;O[nige?ljp=,;hCeXZNk|'Jf8Z'KW'G43UQ2z/pZNlHq2,x1ia[\*Dr]D9Op(td'ClJ5H:yIashP0RI-.W/3a}[kR66/PKQ4)X4*bvJAcM=tAfMxe^g_=_S>FD>Dn{)iyW0q;{N=yY1^tJ;azPWs^>7gc8Sp'2": a& = a& + 160
    Mid$(A$, a&, 160) = "*Vk?-|K|(4_9|iC<nM^k-b<MAi1uUrDrMrbDhFT7s:BJ|A,IG+I;ZZmtsTYavN,9j_T4I[N:GbEuNuTq7ZI*44M\E{^Z|7Id_]<[K;Kf>:Z16tWgOUk_sNTe<-=o{dNkj'/(ERT>+/fH]BI?tF_{u29Lce9{)\=T": a& = a& + 160
    Mid$(A$, a&, 160) = "rr])S8P^*1LiAmr^1+{?sks+{M-LW.,o^*)ZbhaDI6c2WqXeT(vFqqPRaxsZIC2F4nTT<gY.?;(d_2'{Fa18}F.v;JtO6c9+]g3rAz|_iJv5C]=RoXwXcv,k6wo;o:ozA6YhM6sb/}1eaz,uy?_EJs/g;\YulWf>": a& = a& + 160
    Mid$(A$, a&, 160) = "J)0[7>(zm[uOH|GRYh9{PZ^)[6hJC4Wr(D/s+[O^'eZrrA_*cOBO4'Q\Pw-LERl|Uq\?xl\V=[5ECUsI{(HO[:PMN4y-OaQ4>EFOvZ[/H_fC>:yr5o6Lylim{,kVQM[]'FhKl4rJ2j[f+gk_|gsyN30YtH8:=2[0": a& = a& + 160
    Mid$(A$, a&, 160) = "XCq\o2[\t8r1\rQd7y'K+EeASKrm[DP=B9<jb'2L;4qTP0+HH6IYUf{_T>BUvXuxOi;fropIRKtoxetWD>e'*Q>724T-Q\,^>}PC74|MX.<|2Ttf3k0EY?]s?H?GE<[(WkahJyrW*-x:Mlbs]m,<-{Uai9lGSzzH": a& = a& + 160
    Mid$(A$, a&, 160) = "lgOVM)UvgW:*)+J-Xy.=zl6yuJS4mbQ)Q5BAo.UGQ^WGr<EC_fPe]/<=VgF:>hP-RoR'*;SSR9FZhHUHigy])N.ehYI9CP:H[?<S2SU=Kp4?K]p=Yj*X*KkU\zP\e[C-)d})o{S}R\z[O-[AV873v_3gyv9/'Rc?": a& = a& + 160
    Mid$(A$, a&, 160) = "86b?BLNBGT-SN;R)teoUOFb{ng7:=Zqsr|F\VO,0o/wK?B6b8DrVu8)}9_cTQz;_[d9_AXN)aGq,,|nd=?[lVA\3dD>o(PwBdQjS4?(6T4P3M*)(b?XuO_|4[PZjYP1[KVkgAHv[g+zd[L9emD'Zm2MLl3{}t7m6": a& = a& + 160
    Mid$(A$, a&, 160) = "{:sc/Y'f(Lf.y'A<(kPd3v:^wNy2Re3x|9+)yQ,sXX;BHKQSNP|UH.Fj^SlN1Ewljr'Wa5,m;?,kNArG_4V}Nm^O[{|wKV{U=A90MwWfqK?p_2bwE38]OR:X0Ef{bn5mC4bjSEB'S'Gt{hx/PQLObKNMr:39e(2L": a& = a& + 160
    Mid$(A$, a&, 160) = ">eDWWgMh]X1rX|w:lMtVOirvahcBVYBqA8RSc[CY?1fjU8pnCSYyinp>FnRgd9CExJ[Jc-d*{97s=aatLknsp*Wwt66fE8|,hc5>?Z?ZF;mPfx<-t'E]8Fr]ZRM>*tlE\;|MgyS2Vq|)V<+eL8zH+,YmLrmjJE_J": a& = a& + 160
    Mid$(A$, a&, 160) = "Tj;D?tgVmY3:q}P{[,sFUugoO]rNL2ID8yKWH7yo46FxHjwYJQcBTiw3K)7u3j<?BWO}g01l5zJFnlF}FUx>sbf,AK8BD][T5f_Bgb6FV0Am0B6/<5z'/,GxHEsW)\Q/|+KekY;i{730Bz}Lu.sv<'2ZO:_Yfj6G": a& = a& + 160
    Mid$(A$, a&, 160) = "3-+t;YsZFF<3Rv=9::D-8E_X).7pnnt(,>cuRW]M1+grSrSAZ=JyVLXZXePQc)>Nl.uIR0EOMrn}X4Y\UOV(5q:4ci}=Ks*c0fUP;y.h=k7OS0uqI:^sn.+EbAX|ChEdi*[ZyDbia6N.i+qjeIX[yoXTWwo6C9uS": a& = a& + 160
    Mid$(A$, a&, 160) = "Rykf?]fhB7WwZmX}wMbttG}l]{wLF(*OWJ'b_C>MXL(Dp6\N}qDAuA=,:C7vh44VxH>VTgI6zMAGlI'QO+Q.6vEei|r3ktx|uqfp+dAxvwBl|<AG?{6+8AiieIuhVoLvnD(cNh}h0',mJb:XrpS_T>zVZfrvEtSl": a& = a& + 160
    Mid$(A$, a&, 160) = "M]rob(q|6b7g?+yFa6{krS+IiCU5;-_eKOk_e[8e7I<QZZUzC[A6Hm{5j}k+{?lI>cDVNRhhM+\/UeF_(DJm+|DfE}JB0uZCc,Mg/<<KHt30j+G6TXUHz9?bKAK:>odivEScqu7>l}aBVjV(dk8Y08Lh+JsnK<zW": a& = a& + 160
    Mid$(A$, a&, 160) = "jv-Z;}I[IV=u*WpK){Wll.kbb3P]>sQq9:f<ODQ^fmZxU=Rdu'0M5{0Ih2Kd.w<lU0';JK+xMSx]Dm7<YKmdSrZ(3]S2y24VW<APw35X*R(Jk5m,s,88y<'[8v-7HF,\jk<ll/u0:wV7{Nek]5cQc8\leQZKFbt>": a& = a& + 160
    Mid$(A$, a&, 160) = ";GP,I>F6dz:z?cMLni*_P[NWr5ms^>;O8|1wG3'r9{4YY>qhkJo]v1?4:AMFcZJsAek8c2TcnLrRS['c4Du?]bE2y8nrmb7,.Rwe/xx50;H_?bgXt3DYF2IFnQ{sPhwy+[*B6O3(xD<RcHxu7+xaE9n)v/2x0U/8": a& = a& + 160
    Mid$(A$, a&, 160) = "N9{=W;zBS3B_Nh.rK_Bd6Pf{GShCbRrC<Ttmu\]z*3a'4PT(CzxL5N1qaJ_F6zms\]i.T3l<}T9yp9U_}<pJHwZg(dFD(86o.j=JedYrC{]J3KTVC:9JCr}:FE5Dbww,lVKqZo3-LIRd*x]boeu+*tbpP/aX1erg": a& = a& + 160
    Mid$(A$, a&, 160) = "?B:g/b9cjo72P}2PTAOG}-sa6NY}T.ioqaJ2XW*jFC.GqSw/=I7ln)<QrLFyVa>hmq3{?E/H6>yGnM_0-N6W|mB{>Xc_fuc?E>0w<f^?kSvwq?VSa:xN*U\3bs*5;h*3A9dd6suAMz*|r,2rizN];Z3mAmjzMvG<": a& = a& + 160
    Mid$(A$, a&, 160) = "u-:n>7oe9tq9F,Wz([3-_AhVJlgZjUx5fvV6e?S)7y6zF;tUR;ATt^qw,mJ=W_j_U>Dm54nbtr*rbi8Cj8L?LajfdGQ.,vz_8;G*f)rq<b9gaNuAP*H9cT-.Owqw8lL7}*tz9\F>Nd.X0r[J_vmhuI?3soMy.uf[": a& = a& + 160
    Mid$(A$, a&, 160) = "vw71pP17:)Q48a<u0;_\>wF{WcR)3N.X;)\yf?t}qR^=p5vW,,mDmYf09h?\bd8W}2SkDz;Am)8\pm7h4Ilb(ii*z1>Ai1ef+4EwBQJf\lnB(/oVyI-KR?(m618)eybMeejV<F7HZ<Fhn05?k-YB[8-(bH}1B)\S": a& = a& + 160
    Mid$(A$, a&, 160) = "kr=l\3mj/at5xnXhL<eH?4AuWu[zw{>UNUnLyEvl^YUcj+9W)5[7K5+<6\(5<)C-8|KEqqJzsG6sf-l\eGnwi[aS)mTCx3UA;BJ-r,mC2h(Ons-DCR|]top{Vi:tjD>y+t-e?Ta5pCEs2,1j3GG?l|N(z)lRICJ'": a& = a& + 160
    Mid$(A$, a&, 160) = "k06GGUJz8'G>C6LNxLilkj=4NoGRtoP.Nmh([A;[i=Xiwio3D<Fx9o3_i=GAN_P;U\3|_1I]IEA(T?<FuSm>cOw)Ak)jB2:fB6qAmI,M}Aof8tVopx]rYqvJ:Vr0vWWU>4cWi|0O*l;Eki8<uEQc?-fDtdw]G/[[": a& = a& + 160
    Mid$(A$, a&, 160) = "w29:bEe]gW'Yd74i;oJOj<7bG/Zn_E:s>RW,'bV-TsOI;G6-yc=];nCg<c>o{Xoe20xLP-onCc=uJgzI/;0CZRt22yV(?mjV,j>E41PH2?S8Ia;WGu14\=G.51(QBbWquHrXW12C_bSKaf^6Vgv.Lwn;6gpcHSS)": a& = a& + 160
    Mid$(A$, a&, 160) = "rW]V\e3uLCn-FW?4a6M79W\:cl-|_7jOJj*XDJxVnI7kI-6rq6y))*|)9_(FGH-w;9yC|;30Sro9HBxQWR]?Opr<nU(b=+=dZJI'Kr)CqCrY]BS>b46<tm[0xxWgArey0=gv-rc/k7{1evZFfik4LD[6TMbxFnHv": a& = a& + 160
    Mid$(A$, a&, 160) = "c;g<lpb+6T+qq+A]Q^.ky5opJQ0[wOFY/X-]a:k4-_AquD('tH[eFNey6A(eExeG\?;2J+DKK*1F-_}IZ1?]VWtzZ<mQZ4A-e+1?+Nbb,^NT|MlcZEw[6,]|gU0iCBnGruF6-[R1n>j4n>ee/B{*vEz29+.0^b>D": a& = a& + 160
    Mid$(A$, a&, 160) = "/QJwOaK./)B[Y0(ON08<GAXA>{qTj*[OVIXi6Nk>j{'UBNBEsB;'DB<<3s2PGvYPM7JK'ndkb<<SFa(K-bI7*V_na:9KhAVh(b*bnxB..NY^vQ\jiluOe0Jx_Yg[,)GoGr/38UKv17igdU)WrDBD7ox6^WAXI:7g": a& = a& + 160
    Mid$(A$, a&, 160) = "uW|p*w=2YlwD-mgkX|6(arw92>cM)S7XB[ngDF0CCusK1,=601=G_R2{=?*[[WfGOw-y\\'^cYHwK2VnPoYHsF:7j|]Yy<f[YChjHCqWsi?F_K{)YSd')i=Ky4li*Ir8vR|EF4qeG_SHzA|iVaGke+iY]K{xTA*A": a& = a& + 160
    Mid$(A$, a&, 160) = "C8fi[Toc2SZdv)Z3Tbja:Ti5fMgKc4Iq'/]LUE]i;7|yzM-2\.\:,Depcbsg+dFP,|YEqwkAgK)uwOryNpjPkbz;T2<C>WQ??-.07h2{?xMaKq7yBCylX;6S?uGBjmsBeb^<yu|],{i]I;IMP2N(^hra8W+PVuFY": a& = a& + 160
    Mid$(A$, a&, 160) = "9_KNa)TXI4jHHF6Ly6hKTXMUZ1thz{x2gC[k7{F6/:1JRLwt[;}cgWzpif'A00i]28_i>wi0AL6liJ]iRAHKDsU}Bb]P2jXmktW1O+xJ0[g<>a)OlFbgjDSm:VbrMPz:cITC;;XR=H.P*;))CAm0NR_,|0.zyrS?": a& = a& + 160
    Mid$(A$, a&, 160) = "0Ci4,D-)q|\S:R3jR6<eLcK913Ep}sz:O],\5+]9'XBXyDNbD5)IKFN*iWxPqLkACyb|-]EZ9Eb+GFSS;)bw9.GrKnqMv\h+hu{k?Ih4(jg]RAAlSBsmiaP?O]']*Fd[21b:LsKB':=+)En:c-N'Vi1n7jUKscsZ": a& = a& + 160
    Mid$(A$, a&, 160) = "XCg4mw.IVi9N^IpU=7sIR[]NoONV\J[=:OX*J8n+2h^535Pz*;(^(y?),CJT=6qs[dL;M9tq->FY:eHUi?uRdKC<6fX,kGjk>:v(*lPgcU?RSv-,W*4iKkjFHaQ'g?Bg?|Ma^'902UVkJaZFqi;syWy2>KOwpn_m": a& = a& + 160
    Mid$(A$, a&, 160) = "]i}337K=7VXtV=_oWBV1hHOR9DUTnvqz]f/8WgW_P4x;[A6=o;vm0|W(OT;Xj2\';(k*H7RL-nJpjT1x:;O]5E/IIiXX1<?GJ{oP=dHS3UrhUlwss[G^Ry{7Ytflibb6gYq(8WM)rNKFa[R8+)xUR<;;F[e<-^b)": a& = a& + 160
    Mid$(A$, a&, 160) = ";t64mWwsTg]b/z{eA/'iP]Q4:Tq*W\o*WDzCAF\wMJkwWp1NNW,;qoeREy:PIF|),[wEnvLWHW5)>J.3zd.1s0B3J?/no'_Q7.vGzH<Nv|BNdm,6\J?q45T{u:j;/>ug8IFFZ0]PIlz)0U(nf2u/hPKL4;E)3aR6": a& = a& + 160
    Mid$(A$, a&, 160) = "y[6:d;mHd(iRGTbL5ba4_G')[e/1x1eVA.tqMUnNheqkh<6+AS2d:fUxVvOd;,.Ug(ZT=6Av=2IbSU};',yGL+Mv}vjfJAZ7MA1xmSM}r;>}F:jEkni:3=AaEyNFUC:(a->0oQSJr^rf.,k167'nvB_A46hQkGpR": a& = a& + 160
    Mid$(A$, a&, 160) = "Q0hw2]1*hc>J)Ll)sA9_3OrPPZW|)s_]zsL+jjF(xgL3En1,J^)_zI[Epfmjr3slJZbH=yiaK;N2b[\kX)/+*2(]+E9\PDFkr\9kpvU9mY^M?wBf?ltturExMMeVcw?vNC?<3JWOU^HM'3(:Bp(Ijoe<1\?<W6Em": a& = a& + 160
    Mid$(A$, a&, 160) = "ax)CtHb9<Q]5gcscamyzatb[?5sQ;k+n;_)w?rLVjs7+N--=lz/H=\(E=pi'RWm2D^62]o}WN.g4]6cA.[Qho<dn{6UP-+aRG0{dGyLw0=2iU>MQ<Tjet}9sM/F[,|?ylA3<7KTqo6>X>7=h]}04cEbvMZf,2wD(": a& = a& + 160
    Mid$(A$, a&, 160) = "a'>9TxN]bC73P<):^F>2r,bTNa*+3yQ_PT+zH\a[NKqI-S2OL0];Ifzoe=JQb.QcN;qHQCx<WzPK7;*y-*[Hp+D_o8^(,R{/^.QHO2k5yqQ0U40H9Dvqkah[kJF=:ZK*}T=vzyWl13;Np1<E;yt{2YukSkpGI6MN": a& = a& + 160
    Mid$(A$, a&, 160) = "DLyiOq\+qwMd>/}\/m[>toLYKy]:r[paQ:NpRte=lS7r6{PvyE+E1pS5OhUTw.FAYZIj9Z:ZszCp1khYw_j[C(J[4hUTj1b9\JMhz<gZ}/A,{/wH87CBB}E]ys3BBpbRM;[45kEo4XNQiUrlz_BJb+G[aAfcle,d": a& = a& + 160
    Mid$(A$, a&, 160) = "Elv9FIQj5E;M,y.(/.K6LR;y?w<R]PMEH[.CT'{DdG'Fj3'yUBA0Vc3.zZGQJ[YPi{?<C.KKo+4NZw/vAaLRSns_O]|v]nRP+Fk/*3a:YwKHms',<7SFU|zjT<umr+4.NnBpd*IglEilw=wF+VuLe6=qhKBZPWfE": a& = a& + 160
    Mid$(A$, a&, 160) = "Glm=;=*++}jgB9>*T+:H[(}YDqHqhaZsssF_M^*:1N.,[6r9M|RlN7;y6K9_MC8l>nNUIkV_StY^rCr;M9R<D:xEs{)WDwA4ivz){.DX-foIsRfNG8CfqnFQ(XqI<\n?.2y^wck*fL)7=ZAV5(PudkP2e3Ji/kNs": a& = a& + 160
    Mid$(A$, a&, 160) = "AnD>*zL;O1>\I4(f;?9qelM2SoLYL7rUv0Mn+X\Y(0:NYtxlebTe12?+.F\wg?pc,X/rbLsmJ<C5]<\HGibiwGyDEUZxP[VYO9C[XA|fN)[9^eIss>*[Z|<VQ9SGMS6==H2s;W3j=s*1x'E}cZFSl([KBX[ToO;'": a& = a& + 160
    Mid$(A$, a&, 160) = "d<u5z}f'Vt:9:o:PCNg+i;1E[G-Bn}Je?bI4_q.GjQ3*|}k^kr5k2^}_F6J{|>c]=Vq0OBI\-0]F8Z:_'BQx_RFz,-PhdO7pUlJmb2ojObLb-2<qbKvKZE2[XkN/\,y<e8,<)(b+,I<uHeGkD):peKM:YMAc<5U[": a& = a& + 160
    Mid$(A$, a&, 160) = "-RFOY6XABNc4j7(BwMKybqb0-6/Sl369m*G+6)YVs1uH9CFweiPghzCmO\FWxdA^QvLkYy]Qfe5:);X,hD?|d0yC0XDGRMmp0;JVs\N_<J9U76/z:NDFp=S^j]l9iG5BKMtBec|r>F5v-'=1s_1O*b07>dM|FoAZ": a& = a& + 160
    Mid$(A$, a&, 160) = "X3RN*=MzQe3Wf)G[g(Wc*Uprw5NA1DOz(j(>]9Z7n1wGvG6iIyM9ej2Ny0jlatZI3d^B'=gj]VupICF*gO8DW[vqeliwIm8lbE<6m';<:g1,/mh]X>)^IVfsP;5qp:pBO}r{'+-iM^3h_uB?QRV1_]l'>wVSx3;o": a& = a& + 160
    Mid$(A$, a&, 160) = "JfWxvKf?ZHH6bls^uC>f;';*u3Is<Z7/T:E}p(S5^4TQ])A)0E10+SXqN'XmGp\j8mSMD(D\p'pxcIGXIxYNfA?lIt87see{/LzF[ZjQtikm'J4-,L=>4Q8fVHbpjTg5aqiZI.UITOeHzv,J6Xz8NkVSfU1B*d6O": a& = a& + 160
    Mid$(A$, a&, 160) = "|/_=qQqz<Xx,waqMS?|43alw|lkh3{Na4HTY;mp*-;Yt:f0LfeK+I\6d;wu,S649U2[xs]\oG-uLpY/*7FnWiJM]^sQkcj+=RL)zIOp/V{9V5\7Tld\+1tcmW1rk4(itxY3zCgcdL[0d(96VY^w=c7NgA5K<\Hus": a& = a& + 160
    Mid$(A$, a&, 160) = ">=\L4ORQdgCv8UogvKN*4XzRX8_lNT:8LLKk=l1tBl(inVgiW}9?J[Cap*OCfp}{GA2yrW4G85wq:qS,cH6wB*F+pDb-R4?_:2p8bd/9O9*mCw:QbhPVSwhHDPyvl}Y>,:fVM=vLkg1Bu'=s/,WZf3(F(9T0LxTm": a& = a& + 160
    Mid$(A$, a&, 160) = "\X}'NPlPjVfYArt<0d*W].0qB*m_ny-.K>BA(x-T8Rk9>.^?+gY=woZu>eNSMP6LRq?xD8vP(HehZJkf7poI7R*WqFLAGcK}(E6\vth+yo](ZUazD/cayzX8:8CNUR*Wn0BZn>VIm-P,DWQrm.Ig]}})ttUT8Jez": a& = a& + 160
    Mid$(A$, a&, 160) = "D6)s_WWAg>sr72z+\*eURzAl>9Rs0h0qa_i482G[*?WC16QVcV1.Ezh01vVyVCyI5k<FY5jKQVl>A{5OD>P{B=g39qbHF32puzFe4^lE9*Ze>|UqQcojvdGmx6qqMM9|rJUVngpq=KDzEx>S4k.K]fS3-}QiZ=a{": a& = a& + 160
    Mid$(A$, a&, 160) = "Ia+rUdBvVl^R4Umys/EP8fhLk?blxjocYplY?7=Ccyv/UXRi?'P(pIF1H6}6tno35+e-e53U3Ng(R=wA4G9*s0_Z+_/+vBIv0{;,nn){Qw*<cD|JOua{LWHfE)}'zTr.8^S_:.nQuzG1UGmyk4EwA52C4ls7EI5j": a& = a& + 160
    Mid$(A$, a&, 160) = "PC82pPS[[H)8<N_L?gTCeiF2[jZsO0NCg1Tx6Ls/?84mFeiYV^]<gquwXYAc,HcpB+rBB:G8]cc=4^)'IITmT}XU]DA{9YzKr}+rLi+wo-jDcp}Fb*Gkz8eb1E/eTDCg}6ty{S(omagzRPziHr-VcCa3Mx}dAi/2": a& = a& + 160
    Mid$(A$, a&, 160) = "|M6[rEbLOKl_nW*5P+J}0e}Q3?=za9evx\OZ3M{KIqznOFDbI'BM(lyzb-j^UJu4R]JkM./;b:e|g992Ozv5Z5pe8SK)O'FuS01p(+Z8eigA-03[c.[pqNO9,0Ol_<H0b5rv4G/QN)HAyKW]VadJJ^sC)?g2Kq;7": a& = a& + 160
    Mid$(A$, a&, 160) = "9[P_EcB3OR+bgq0_;(oV+Pe?JQLav>O8Qtkh\0OH1l1x3S9<}/A<k]DfUE,[om+)m>rBNF?tJQkrkE:L,PbGXK<Uq^Jv;y-bx20-g^8tY|[GQ[XSQ?c8wev\s[+Y{M8n^9,c1c9yAl}38jzVMk-oVc0:pjvW;g6s": a& = a& + 160
    Mid$(A$, a&, 160) = "',g^H(uIM[H))\/maqLYzZieeJg*PjY>)[0(q;cqdd\RRGLQ{FTsF^=(*W0b'yHB2T*Jbbaz^.|*RMh^0n1K_;zG-QtJtK(|+TWkaYjIKT?'wyC1d2?n7XC\qxWm:/'+'5?7-Aw/)[64mch]D2V]q>wAf?6=jHzN": a& = a& + 160
    Mid$(A$, a&, 160) = "5;p'I(pZJOWOA5FhyMBHNAfgQ8L\bFQSMmhJIX\}p;WR?B<b2}5Afd_a+'Uv]LQ:^8:YN3}({Q,dE,-\xsWb8l']9C6),j8r3kEWr1E:V^(\RBY'izplwp\>BNtQY([L+SgoJVB81Pdb"
    o$ = Space$(8303): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N05$ = _Inflate$(btemp$, 9129): btemp$ = ""
End Function


Function N06$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(10036): a& = 1
    Mid$(A$, a&, 160) = "4O)?-zsvG5.WBpfb1k<v')_w4/QE{SvAv6{YTGjbG>aTtGa1Y\X,T|rDD[R0NelWo353U70Alk5:B4M+D_|.KX*N/0MQ\cBUkc;a:HxVI.p]T6__WZ6>(AS3LcnF1U0N0XAK<jlT(R?wJq^>|U;QYFV7aE^MD\-<": a& = a& + 160
    Mid$(A$, a&, 160) = "PaWkLkbO+T04fxR\rzyq>9QE/ZUylL=fKh91lx/;_ReTRY.]2_1?;HFTJMfw4RN,]f5S54]M}g2|71U9\HUgT-JHhcB6Z9QKEclEJb/{vq6}8r)5*^nU)?B5-,K+f),33/GF-l+J-'9nHDg-TR?*pJjdX)i<K9zn": a& = a& + 160
    Mid$(A$, a&, 160) = "oW4(OYi]V0m_,C]+.ke*DCzj>eKH?F_7L\C}XSA.wDIkacGzKRQ4X>ugWI4R9-L+6)=mkiv6nPf}VFH^q_OnUkMW<SEvubpcDw:8sdO6c{K'J_*Q)aCS;7'Kv=ZJq-tkS^gQ4[Sm*9'c.Z_ThBJII1It,zsYN^JQ": a& = a& + 160
    Mid$(A$, a&, 160) = "tggtK];U0JV9++.,.c('J{'|=s5JQhS1MrW[lnDhtm,Gfyz7,(jIB7wwFH?i?c=L+<kqEsU,5^fN.Gx^f7JnOl_/EWHB<A,s+JXh^Yq\=Cbd^p\<|lA}8OM.h1xz0S5*^7]4[I(jV>DvoL}wsBe);fI?QW5;a;zn": a& = a& + 160
    Mid$(A$, a&, 160) = ".cD76[OR}=/V7wC'dHw-)lq:XDKo|brHXjlC'XnhUCNW;OLG-E;lf_pNqJ.Mii/DN2gj;tdm9mxw_uRe/)xl>K-'vYU[[zHEK4c>yOGx59*3gZ|:Sj\<R1iqcsdnD<m0.=Gcm:nW8]cw__W2vEw;{9tc:[s,o{qm": a& = a& + 160
    Mid$(A$, a&, 160) = "Q8N[vP_W0-JXLMo6OtV'pzw2R:7]7Sy2SkJt2-3<}C?PjpyZqW,cKuH9(1ZcwqkJoF>SJlDUk'V?qQ7:0RJFu.8Gv-kVSHu/udXR3WL>.evBX5=8Y0z?L0qC,)VoMUXBYXTN'9>OqeZX-vl1tRHfOD?LSz-8?>r?": a& = a& + 160
    Mid$(A$, a&, 160) = "V67+e>?U\iuyr-dV<dWQ+\Cj_J=Fc[9zW|6nDVC_Ly2t5(,<ceC<sNm.hv-=kjRYhi,tmmtPXaIZzsqB{9m-IAhBlBKn>kR.J'QnJMVMZaP[0ZJU\Xfe6Qrg24kn+e2x/O}X2]Ddx7Bp?k'.MrR5ZIM?(ffTP<4a": a& = a& + 160
    Mid$(A$, a&, 160) = "py*/)N'Y.P;)P}mwZPE0V:Ptr:s9p6\(=2;WpaXci?<AuNF,uw3j,Ji3yqu8;.txDptW^QR*0V+'i3IA2F/4MYqFaO5ldZ5/qpsc2^ZwE<_DUak4mlkIJn;|ddFM>LGbnBi2Dc>Xb8it]JX4plUmSE:R{(NRgH81": a& = a& + 160
    Mid$(A$, a&, 160) = "U'yPrOEf*ko//RA,wJNZ_TcCveR^;|8P}GuUFT'i;e])fD_HQIv=wp;h<qdfG4u7dnP;Ndzp/Uy,9t(opGOke\O5vUIf,7SXO/,tX6j06wcAn])TBIKO6[BrrGa/W,;t+0c2g?-8HF*O:rti|M>RnFWNxKdcIy'+": a& = a& + 160
    Mid$(A$, a&, 160) = "Ih_AAvHt;J?EZc:^W2}biW3z?\hu.9pr5.1ks_RbiO(]2:h,_)x<]D5/hM6eq0:qYuuW4brJ8MJrJ4Zr,A_*Y9Y6x'G^t9w9O(RjENh/t74VK3Y2=wfo\UUoy?u2v9eU?xW9cE}\'Z,n(/wwprYxKGeO2?mr,CiR": a& = a& + 160
    Mid$(A$, a&, 160) = "|)qnI,Oaz\KGzp(.=17a2_M,}RzUpF]hu<{ls,Z.zICIZFLlG=(U2pBQ;C3j);t*}>Ou/[tyi[v]32UT*[]L,Us|w/5f.Br2it/\R8CE;e.;y0I,vqhR,SaftG3j/gFCx;*n.7OHuE+]W*UvLsB^aT8C+pSqZm0t": a& = a& + 160
    Mid$(A$, a&, 160) = "t(b?cn0(RF*0Xjto)B_LVijAr,x?z9}+OE3h53+Ubn}J4>Rp'{_r.1}z3/Lapu3Catu*P*?OthxmXpp]*XeM+(*LrvCNaAb7')mu6E+)WR6-egQdU-o]/nZ7{lkmy]hd,iJ^60=g<N0LBce+;'G*]Rp8FKq<oD]R": a& = a& + 160
    Mid$(A$, a&, 160) = ":g6Zh(Oc:jz>XdZI,JPyoKaJ*eiZ[Jb)*gL?R[L\i?D'Mfn-jgOnh_RnQLN;iULqV/<AaoUWx=Ygc=81Wxh2-U-RN33trlD(?P:(/3(+nTgZJy:7ma[u0Q'DP'u]v44efI;'UYY1**m-3jQ|h2<|L[j>N1qpkBj_": a& = a& + 160
    Mid$(A$, a&, 160) = "wj__xTti]JGL/b;uNN\e46+,{3CKo11hL;s>S8(^j=_>qiz|OEf5z94Q=EZ8/aYVjUsjuTKF:*Lq6e2>}F:i+]fLoP;piT+^U<3JT-/A]-H\pc8m.|hL9wO<|SA?so<RMtFs4<^/geDNYaSBzcmMGXb+?l8Kq]g6": a& = a& + 160
    Mid$(A$, a&, 160) = "5sDduUX|p]J00Fe;g^r?z'dwWADbeh3,fuj5GMn={:]p3pUO}K6\QbcrrteE\.,xa7p^BuU4o_UE4(,ct20l_A'0)Oof|hk[m8[+aIQ;]]MecOk.oJr3-hKie:=g/O*:B?i8X^;nZ0V.3'CsN2CJ*=\rL1^Ind({": a& = a& + 160
    Mid$(A$, a&, 160) = "F_OK>v8gHBN?aqowS3|7'1Orj*g\+|QA6y}dS<Y{EiyJog-_rqQ'<2q5O.t:YHDVcfJVuF\KaT-UUCibt6;pKjib0M}i[]VFdPApJ+,z7Q*R?25G?J1I6?I9CbZh=D5PhV>8Av\v4*?;SvCs2)Ey1FQ'ktc25zQT": a& = a& + 160
    Mid$(A$, a&, 160) = "tgXeHJMGUJrJTqMZ)Bn{\ZQGm]l5bGOCgTqb.RO^FbwX'fBp0Yg8S]'3N|y>dDuMT,ru_{q9M(qVCqiw=vv[kg)PmirK}uujH2ynQP[qOFLMa?v=Bq-\BG^6?CIIeEttFBozuaYG5W/nPTRoqi]:1uDVxad'0ysA": a& = a& + 160
    Mid$(A$, a&, 160) = "A'mA'K^c1NXu-G9/8>aK^=,y{ttea-w5A\R5q=^DqfmqtI1uH:Hd2r}J[Pn<xJcP][t<P]Xs[:W*;|+H<To}9HmBdMKCxow>*/}yIHul*_4xg?(gB4tacwSpY]NxaHq^yL(NV_:EnOgTI<LMOXSs3UVF+b4\EX>m": a& = a& + 160
    Mid$(A$, a&, 160) = "LZz.zlddT64?=-kU,FKz]c]vx_*da+lCKab,-2gW'ccUga+H)So4JfHWsX-Mra,=]i5WYl7dkv_HO*{S[GJv\(5>L|uJjeQpfBe}WD=:}L0N=l{^:G(awz]|JxGZ(PL\har9wRiYqkTC;oo(30dDOuca)g[Gukly": a& = a& + 160
    Mid$(A$, a&, 160) = "|L9;/ieeHCcE>jq:n||2aWNCpNb'P>6ey/ee4=<Qwe-u\[ci;O<AWYo+*7=,UZB*n)A9ICR[Iy,(kbJShf6of7:0dL38_JmGN3(G37V]M=e66qSlO5+mD<cvdbd]wL)6|Iwb>ptDJSl+_QL;a}p1je[O]gyWIkH/": a& = a& + 160
    Mid$(A$, a&, 160) = "eDmX'>q5YackSe[Ez8voF40AgjnxM>RU-5fR^Mpu]pxx^sd46L)ex],3x:S+Q-g=P8sQRcO'+EdkK7J[lA^4>RqN\>gQVb,Pcd/OE^MKS:E/i_S6UJm<'{GlL_kzCVdU7ABW^-NbVhw4fWeql{fz1\LM+m>c[[ox": a& = a& + 160
    Mid$(A$, a&, 160) = "pwR2zzi,x<pupY4/6B{8PLAT_gk5V}I\:S9f+C+/7qV(4FiV*Uwu<iUXJZW^cX};Zo]N4;wEZdjz>kwi\tJ?oh7*|de9\=wgK9TmJB,HAsi_UyPvNa+{SxCG)I=W)dyDuq4H,kEkt,7?1Qb8e_;2rO)BRN2GSkD,": a& = a& + 160
    Mid$(A$, a&, 160) = "7vc}EW;iNUlQm|x:MA1cT)[AFEL=Uj|j{Wa{b[2+)o:4ie^f{=v;ylL*y|hYvN-L+6eAwkWDR,};?4F/_U(\j+TN\C3v>zjT8jZ|hDy,*Z')q;Pw^kgQuXZaisdO=OmSSL{)Vkb\lbtKGMzISz6W,Th7ADdn>8}S": a& = a& + 160
    Mid$(A$, a&, 160) = "B-/-<thBUWF08hK/,gfn30J//[6fcIK'nxh1om+E/cU:TUO29V3kUaKXI(OqU?-<Eil',IB/Cb8[Qd_ednWneH[qNR*g}a<LA*X=^IrBv-;Ku:E[^4MfB><'b;{cSfF1IiP[F[cOctMZ9fEXh4HDU2'S\etP82iR": a& = a& + 160
    Mid$(A$, a&, 160) = "LS)+^Mvrevu<^Qwg(U;6<aym*hWnKYP^^ohX--ACNwHZZ)AQ>I{8]<'I71ci>z'jB-*OAm6wn]omtFObLYVk{6oA;=hjI,8j]<0hDyMQ15g,s,k-sX_.v-qoBZwL6lR}_O1(b|oSX<O)Kr)uHsx]nqo9|Aok,t_J": a& = a& + 160
    Mid$(A$, a&, 160) = "ADJ6>c-t^tW.[jX/ja)qXuASBRoIrSSU]'CS9Uw<5T>\rj*2ncG55;;q'J>r8?c>\UZK-R}EB>OgFsEDmK7Y2Io:JW6Xio.Q<Z1x-x{4lx6X71V;61_vSA2(mw5*_lG6p3dYZi:g/+|3?'DTr;oL9sJ\:43.+y[.": a& = a& + 160
    Mid$(A$, a&, 160) = "2kbk(u-)HV}^i\Hq/zTjlu|T(OJ{f}./(Jy6]aYu(^<F(Z;w(2A^3RGaq>F,)rF14/2FUNq7Qc3Q:9wnZxI^9CDXrdpczfo-U=fH-fzANhox?.C.H952\_lV..]Em1qlFuLBN(./=-Y9E(zZ>^qrLS.(mNTlBLtc": a& = a& + 160
    Mid$(A$, a&, 160) = "Sp*/I.fy?Je)ICru)|6)pgwx/UgQJaARb[Wt1{F3Np8s902+41hnPMX?(V.aK^[WXy;s[i]3mCV-4HDO8+]jU)-<VuGz'E-,q,Jl>hq7ChDg?(u_6L;K1F:('aR,AHEuJUWX-Gl,im6bHKul|.e|{5d./bElg/;/": a& = a& + 160
    Mid$(A$, a&, 160) = "6Ogp}_vzw<Nun9a,E}ZO;R+i]MyUx;'\gjo}oMjSI)JuUIo\WqTgZc29O7UsubM8e/3*A,bwHp7)?rFTxMiq,-/KK43YgMxMXbsl'HO[?thWvqhEXSaA/6JQlN:m3o:\:LF]v/V;Fn|)X5iO._fdT+OV18_Efr(G": a& = a& + 160
    Mid$(A$, a&, 160) = "ZKb+1}Kan+1s+[N<Tv{N_Qj0:W1tE{?svxPE,ki:)lq|FD:3}g_E^12(0IaawTN0g\8)O^=9qRRCX4oTf<RP(ED\T+b*dN?oxG(l\[ko,/OI(GA9bMffl7;4?=8*CY)W*]e,+J.UdJ]VKsG2.7B|(oU,DDCxs_a>": a& = a& + 160
    Mid$(A$, a&, 160) = "y6Ey3dex)y_p9u1B'+9YDsF*[g>n>qE;g2(<NQ=Yy8eXWT0_=b3\6eSR_ss385G}[=eMs)6*O75K15Qg0{=ZJFfB(-oZ>5vCImtSJp[FFx6Mpn5s)c^Pd<;j(+]Sxf,0(UUvs7}MUIPKo:eYlwcT),/1::7[g[*q": a& = a& + 160
    Mid$(A$, a&, 160) = "yet{;_CxGTFYCEP)LwFYhMIMxP^9khKQF{qC:_Vs.Q)O8qZA],73=:S*/K1vLqOZ/Yt0z^Sh[1E{wN9eu/*Lr,Jx.W8n_Ky41dOW4s?<Bn4><20Vd?G3[UzuICqzy'b<0(pvfWjrKPqh?4F7oyn)FJwvE8/8j<6K": a& = a& + 160
    Mid$(A$, a&, 160) = "puQ+[8o,UxSPjubP<6S[{wc:e.TEbgVGn[Cfn(?z1*xjB(',<CeOh;0B1ZpyEoH\Nx:Ua1<*Fa.(.x^Oys<zp?o>[)m5y]9uZ>mMB-P0y<'bRN:]-HTdQy1;Cnu.\D^ykX0uhDcuO(OInj(<(;z-0ixZ,mkd):DV": a& = a& + 160
    Mid$(A$, a&, 160) = "Ua9b4ZBI-f-;Zf|axfX[v8[q30Q^uB5Ek'H/\<*cLxfgS7WhF?66DC^AZ5va>MUQ}I81oX:^qU0<fL0KZcJ;Tl?eWDVrE>,[L(47?WWIo5VI)jV8mSneK)/'Ryjw6p-xaggz76vNw+IfIpnj}AY7c-+X|>g257yB": a& = a& + 160
    Mid$(A$, a&, 160) = "wx<yRFg:VZOQQ21;lgt>kIoHLi1-{;3jkQR1bp{o1AZ1PQP<T>2<,YZL+INis_XuWxUoOweK1DA];=o1}=qoGL6em7(BHTL_JoHHJm\To>9ulPLT.i'pR(<2Znc4dH86XQ}8Jj/nnKVK7>Bafkohx=fei?2uwyI1": a& = a& + 160
    Mid$(A$, a&, 160) = "X7scid42uuA*UB>+=)LF7*FG3?GY{Pov*FCrgEMfkdg3Q'ch+AgA_()icrt,9aLg2eamj/LApd[dZ/MF3pEj2w]a^GQk7/nj0Rb7HuE3CD'{KFmUn.=bPMz41AP)7(tlz.GNRWVDog}iN1oQ^AavLWlsfEwh.zb]": a& = a& + 160
    Mid$(A$, a&, 160) = "'VIu'515wzf3,x>Jg<;.ojX}C*1a7T6Z2tcsDUKv?JhABUkESj8-3JuEzjxG>r845]3SPe-koisoI?;(5BmGH{1t?a*'r16xY7h8-+coDwL;:g.V+hV3O9-jBlQYMwHbA0W9<|ZC6Cvm^3YTWV?I;:2gacdmBBI,": a& = a& + 160
    Mid$(A$, a&, 160) = "=enrzfhLw8?Tr^Bx)3vT)<P<[hN:t(Y'-pu_McxzmD}k/9bLBF(RC*g,ehg.[PKikx?ZAzWNXA2,BKl5}lU*LxH6)^2b9PDCF{-z'q.au5H[4iLM[;YC^7SdyeJdrD_ZDAW6/1i8+U}Nf1p]lpsr/A>ykA\ju'++": a& = a& + 160
    Mid$(A$, a&, 160) = "dJ_OqbEy5]lFnfvBr]XKrBsVJ+_^GuAF5VbSZ>2zZbllOYaTw6TIh.E81;(2(/[Y*.Z5n('n7I219fId|Ryz*JpFg/W>EH9PZ7E]+:-,|pVZJY^F60OlBMfL,T}<}WYW|*tPi+7eyC\=_yGG56*:tbr;H4n04+r'": a& = a& + 160
    Mid$(A$, a&, 160) = "{b]3=Z.zrQ=2SRU_O:JR)+z*g;0Hf-ko?yn<S(,t0bI2dD0,5(UP;|D|B^-9IHKz..7]|rWTp_Il]B6;H',<L4gF}kzlXH:w6o1Q+6Yum><Br*CKr><7.YG|+M=6*S[6<M2v]lGZT:ajMsy\fZWfUihy/iOTVqSv": a& = a& + 160
    Mid$(A$, a&, 160) = "acKz>5*IO2fb7M4iv(>i4>,<-E,0U<=s=x:KvLTiNbOfJ}jc.:mr/.G_5_jTcxU=ww33<+I*n^u.scm5sTw*+;\G]6\mB-.6Jm*J4^-Q-s;_=)bFk[^yb(5<+yA43132P)8e;;QdZ|tHT=aT]<1Y2)*7_+0pLlnm": a& = a& + 160
    Mid$(A$, a&, 160) = "=sHM5-)UVF6Y^_jIqu,<)kNl?hyj]=:3Cuh?)K.]:m*]s+vFMM/nt7SChwv=V^fbn'D0}-XJ'evsf+g85hXRcZqIHMo{7fGuE9J11f)mSCGE]}^ly,FTdozu*M-YGr(PTZ[IgyGFhvMBFWnAeqfH_GoI8g(7*JH{": a& = a& + 160
    Mid$(A$, a&, 160) = "eD4s)h1Dv)n/xln9)qdTzWd]aQjNc.CIS*VnYs+wsLA++vCX}(D9>=)1A]fCAYl58qD7K'_]/\F*4/nGXkyUG+ll|ynr<.lHe{QRoiLUNB0h2m^6f((hkrEQBMqzMjzBH-FBee;l+w'S7kyOw=]WD|EOW'81Jc,+": a& = a& + 160
    Mid$(A$, a&, 160) = "]6cKbMdT;c9I>9LdT7.BoAkutRKYnx8k}twezr0vDGR^f0,qiP]d5+S=BXScpoVBf^cOBtOkJ(rgr:.}.h*iw1gcuV}X7}*|Dm>f-t7YR:II5qSY}Fg[T'a4U.\jO|rKsZ_yS?<ATd<]oC9pcsZrveULX_PoY'RW": a& = a& + 160
    Mid$(A$, a&, 160) = "t').Kk)2Zv6S(,sOndF4.U[vxlulq]ALD;7C9|-R*yPZsoU5WzEAKdIpQZl.}=,tTK+>2J{PR8JWt9<6OpG7|p4+84|x:)0wn)+\JO2m4WfXXm|)Sg7U<'_1;L[4yudqvHMM;|PJa8w_iSs/l?S+*TTn(N>Jp>X|": a& = a& + 160
    Mid$(A$, a&, 160) = "<ZnKIak|;B5at3v^u?a].RAafF0[<sV:nvNb2aIpsZj(BCQ4E;6Su*c[QzKiWp]2V)69Z>K\L7N(IaHtTvOd]yCi=p\6C0gtMd3k<ZS6tXl'k887>d^F):9.?'-sw:+_T+cV0/)RI\[6Eg]igk4IIwG^6]yv1ESQ": a& = a& + 160
    Mid$(A$, a&, 160) = "a^lrf2:mk+zRltli5Ap8'>eLDt.vm}]N\+upWsHB<pI8XReq;\qjOem738lIclMb.<nWiq-f5+Cjc8Y}pTyLUjPcH60Vf19ogs2z)SP)J\igBs;e8r}::s,bTN9+JH{<96w6A=wHw,3WcPfPtL>{-'CYb,**J=gF": a& = a& + 160
    Mid$(A$, a&, 160) = "*]L3B>,\cXrnX3;HRqd<iF/OO-EnfH+(>+EZf5pbau2{pDp6(1hr's\jp^=>|j}Ig8=5;:82X;v*Tw'QOO2lU(d[rvX'x:0>vFuEQwwP}.=L,U<u]:oSbvR5S*8pon3LN3KJuSZhyPnH1OR_r/+[;IorDeMm<lG_": a& = a& + 160
    Mid$(A$, a&, 160) = "tMTS[<oF*K1wsgC^WW9nknn'QNDa/a8]N[-ritUpcg[MN/A(4LvMUOVEjA?>M*:[hy'+>OHaazZ;n-0+Nef5qv=}B2Tq2369<,UxHCjj{]45VE7MglE=*]\|BHCc^hXFX)^Qn/cU,]1cGdVEkL\XbHjMnAwcJ7f2": a& = a& + 160
    Mid$(A$, a&, 160) = "0;LlaGCKXd'TD{,'2rS<[>Ti*A/Bho|.y'm{6Q)S,[OiVWH'UI/:00.6eJvYyrQTE/>L<k;t:kN-sJ?+0DSU8s++\3ycZbzN5}yJMfj,AgWXFdMD>7bxZEMGARp*x-=D:jk7LTOk24?Ee1xQV)]-s-yJrM)KKwnl": a& = a& + 160
    Mid$(A$, a&, 160) = "R2>732(Y>[\Y)CFT3UQ_G)^,n9{8',s'^b.>Z\e9XuxwgxmGDh)\[+gb_j:*WUURDIcFbO8M//L;6wkwokGSVbQl[/An:qhMPr?=ka.faer7lX80r4Qqp_}*nZ79X:H}_jt__'<MTd=vvFgs=D.QPbzM1.>>J[k>": a& = a& + 160
    Mid$(A$, a&, 160) = "H^n:nVpCsGIDalWL5asmn,z:a2Lv|wfx[0E.yOy-Kc*0D7Mk:p4VHi?dT:X1Nm=DXc7:JW>r:>R6PHzX{E0YwjsLvOUA{3tB^{w:aMwijYP'E7L9E4?h*T92cIY.M*I6IRR(v,dDYiMeXeAqY2UbVl2^Rxzyto2N": a& = a& + 160
    Mid$(A$, a&, 160) = "y7/hRZ</?7hwA.2IS_Zf=4DEqi:\5o.W\'4y44'oXLe+pw98Jim=351J*CJ=l/*XYl-Ol'8on*3y*t=Bsw1*F958gjVG'.y:n4_>\sBc=kO?oRdvemuI(i8-2B<d<;_WD)?eI=602BlfD\p5:QofVLyEMA=:2^b3": a& = a& + 160
    Mid$(A$, a&, 160) = "DEnxsAgs8,Een}EpVP5XvU\:KKyf7YM+F-:e[>frr,qVsG'|Jh:6MYHYOI:i2tR3]Kz.3;Tnxl,b9}Zf_Koq[1sFzdZEx{-xHTAWH*W';92Z:(gjp{8hmvvAR8OTKNsk(*(>RiHc<OuZy.XPG9um[TuS|}]yj02-": a& = a& + 160
    Mid$(A$, a&, 160) = "-Vw^-'YJCP4?e2\hP9m'B:ocedQ.Sq=nqP2IrIcYPqsI4E1z5KXMyAUHB55ASJ[WV>H(RLi=Mz6:rQ,Uc3/uWAo=N,T=^|y}vi<>O2rI:_0f:J8D3jTOpyRc9w?-]:uHcSbYFUE833nDNwJ3MVy)^'JrGr>TE6sd": a& = a& + 160
    Mid$(A$, a&, 160) = "fQ/sqRHdDoW:J0Cvh)z\rmTk9V1*lc.K.[1^qnWXdMPpFlO>hWrS3h2H::'Hs;D(es(QudmV;\)bnSEYGsP)r_Rtf][<yy\ltvtnw[GR]T1bBt\3nDgTh:echV0?,8C9rt2LFmacl1xmfxlkO.zUVi^CCWPEkZ{w": a& = a& + 160
    Mid$(A$, a&, 160) = "Q;tnIumS/AnJ]n-6Jq,gz13CK_Dqr542o\)?n-k](DH=r(yeLZ(IYKO,*0^H79|I6|bk:7\/wfrM3K25AC,Elmek2(7rBTOO)M:(lU-kEA:,53bAyFYH6s/V6?}KPG25t3MTIy}/J,H2ub3R1{(4j-uAT^pTKy<(": a& = a& + 160
    Mid$(A$, a&, 160) = "=wfV{gXXdJUs-(/]O,q}A]H2>t74.3YOb=/sK.Z(CGwW3jLsYk<RY+.{alOU53m8f2MF_=F-0rnUbSeHBZ4js<[RnJsB;+?I=(5YP1^Z,{yjVz]ZcYS0?T]oz.h06(Xo-dHOp4M=mCyxQmW6],^}A}:m]b_+JTk]": a& = a& + 160
    Mid$(A$, a&, 160) = "?7]\9iD'=UD/.-[-6l+uW>hHP5WMSOrwQ'>R5[J[t9HO,ku8F]}]J5vep'BP-LSLhPz7L,K4'DzvtvpvAO4F{GQof0UO?;z]VeMVp]1|m_SR7cF-HEC6DzBRVF7n.Uo'Y8,w+071mAc8JEB}eUoAN_bPVUZ?dO?A": a& = a& + 160
    Mid$(A$, a&, 160) = ",^8D77LN2eJ)=p{kcKsDQx>d2?PJAgZzzp/b^HUxQ:760Ww0O]eF^c*R/4vxIYh4*0nm<PpW=hv8e22-b7'hFl(?9..7gRR6//gxXAGBAnkosnB]R:NCGbnKfpkf8OMnN<IDj|3/WE>Og6G;)vwX]|A'<.kjm\kX": a& = a& + 160
    Mid$(A$, a&, 160) = "\FT1iq)m8*HiB>ET[r_/Zq'6pNf<vklg,yT9]_BUZ2*[O-g<6yQf;dPfYkpI+9}Bl0EC2WR9/9.]k*1oHxX}\fEW88(-3Rt)L,h;^wl*mub1,rXXy)EfTqP?9bksMJTL^GENTR2K[mGH5::,O91.[v*\LvILUJ\d": a& = a& + 160
    Mid$(A$, a&, 160) = "L)d6AMh|.5q6X>M3A]+|XP6^|rWGAQg(+:*TH^?lrO<,F;Jn38BtKC5M?0DAmC(;)F9BY32ziT8Qsyg2E53>Gdln2\rY\c<VmQ]+^\\u9]99fI|zWOkE5;Y7GnXArzU[)Tv01Orv,H4Ls5Lq,k9Z9vw7cRHs:(yZ": a& = a& + 160
    Mid$(A$, a&, 160) = "9p_UU1\S]aA4hToo\2)VN]D/hA]MrVW.xYF^zbOo*;tl+?1}V+'mjSZIY-I8ZY^0cd.07x_?Uit[A-An;^fzq9,i7/p9d_w/e_Zl[y2.(P5H_W>1)"
    o$ = Space$(8025): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N06$ = _Inflate$(btemp$, 8815): btemp$ = ""
End Function

Function N07$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(11601): a& = 1
    Mid$(A$, a&, 160) = "2O)?-zt]w|XkF,S[U19CjTKphP+Ah<K,QqKarmYpq4:p[eYMIs3>bo/F41Rq8a2m;:AUN>^=,>UU-|Z0^^v_fdIHcqSv+djtut}6zZ?*ffphZV:.:;IN+UZtb_[4kl7d\u{GIxk2W,2NTvNz;iFn86sQ.{7{.4L0": a& = a& + 160
    Mid$(A$, a&, 160) = "CJeF/pp^VHV/:hK]b7zxVSl2?r^:])3MqAag-cREEhFi,]b*F=BsQ<KMnR=rI.liyI2dFttXyDHrDk6mo9otOU?(T6lI1ljeZXvFWG<OUX:}hvG0ix?FGK]v52a|vC3qm8npCvsQqwZ4,7Hy0I*TO(LC\O^3_XGo": a& = a& + 160
    Mid$(A$, a&, 160) = "w<zvFE(|Z<L2[?\\'*W=Y9W)92Yel21rSt,g+^HldI_(6xu}D|;N+4b?7|RF8Cg_'u*u:x{tj|xNrMOmo.hjFSKmyNz(BI:4h?.L7?tm3JwFxE.W/*.qRfWI/=R_JlC8PpQ+<{z+aBsPK_qdnn\eb6CEW*PfXRCD": a& = a& + 160
    Mid$(A$, a&, 160) = "ww>f+Kc_c^yYk-5=Kmg31{2|oP=+O_:<<OCdk]3(C7^;ctR(XEe[<sqQ5<Ui}4Z)DOQ2vwbQGA9[t^sqMnc-Pq+Pz<aDRzVY.9J{9-f1)h=+*Y)o0R'{SqYW''/Xbm9f6J\LMW0?)tr<g>1N:E^bCB)ls53i-N^B": a& = a& + 160
    Mid$(A$, a&, 160) = "{e0?UGce(G:b9tTQF'KD;Aux\qDxIh|^{]\1E=:0hT[,p)?r(TdEcAWFuV_T?e<(Se8t]12u>dVE)9t*'qcQI>0XjeZ[mhikM_X8n)/15xb89x]C*9mAdAs0>.0:Y-Qp8nne9i4>ckBfV]h_IOKLYJ2]=F38a0ZU": a& = a& + 160
    Mid$(A$, a&, 160) = "Ciku^S4Ny^i_BGoBtuWgwp]}+6_mowrD)6S]T_Jvs1w([zkE_1-F(clSnIq}OH2<^G>}7dQyo/;qU?L+;v,W{^d-DCIkMYMb\Y|dUr?6f=2E|O)DRN([.cU[<:qh/\)Q;tW?Wx1xd^I+k*Rk<kl(vSV[<x'ADn4/": a& = a& + 160
    Mid$(A$, a&, 160) = "NR<S*1e1h+fBjlD6dKa*X'GXiq-p:oIbCb,2\ty/GK6cvrWP,Ok1b=\pCwv.WrN_r).O7j'W*XyOH}z]Zk7I]:;:8:mIgn/):Q\F[y,DESmQG(D?HngV[WBq,=,_e0.dq(OG*j],NO>0Ucv,d)Ezzsyal01Olv?H": a& = a& + 160
    Mid$(A$, a&, 160) = "m,Wc,>7I9:|PUHPphRya/+y>nkxqu;P-VLDJ5MVgjqbd35;/[F06_|V3wmQ84CgEPyep-u:gs<si?qhg[gsGv45'er;7HFeuJ^1KZqwT,Zp/^NXfRld2HpCPu<wggKhxB44]0f}f')Y{}n.w)(<Q4nv[;{;1B\Vm": a& = a& + 160
    Mid$(A$, a&, 160) = "{jzz:SJa39}a[eC9)oa.FS}G]1Wp'HECxo3S(NfV,d2eU:J,J)'wp1r\'*,^hKs-lhG}mxfI9KAPLA{^vy=47S(GQ,U[jVV>L]g2>YiOttwmC':fz^JXZY[9H:/;:>e6g1NOa/LlIZ0k543A3',VT+=weUUQcJ{A": a& = a& + 160
    Mid$(A$, a&, 160) = "E(6sD.LMHa'rv;i^oHho._.d<wsincIbxmisBgRXb_N3R}KOdCj^FCw)E//>)u3>Z_5I1FylM*5-VdVCyF*AFEb}=IrF>B*x7SUq^eV,S|[qNR+<YK|LSF4qgTvxzLRv<2KiNZX0a7=-uQpTs3ntol0M4wjQDpxe": a& = a& + 160
    Mid$(A$, a&, 160) = "Ga(oK_Oe'](J|bJG>\d(SMm2o_x)YWkqpiqV:1b1?r93Y=s'PF9D<A}?Ta4nlfXjdLXkpN]E>W3sUZlR_SH,y4q)<ybXbO7>J^F?JFuZ.+QFK5L;My-uBM*S;UguphV,)ZZWU9+B[LbGbV0HspcJY65b>Oo.uy\-": a& = a& + 160
    Mid$(A$, a&, 160) = "Li7d-SlN|}Fra]>6>aMd:1wq_tY<.[kn\CI9tM=0FuByi{tB(tchFa(uW=l1BD}Yajgu/{0>EmIW=py^z,ettLq*y]7qyrmPew)0(>|k:ku+W=:([MiV4P8)lYhudQ5L|2vhN?=3kn,d0ZpLLf7mJdamkL[d1Gwj": a& = a& + 160
    Mid$(A$, a&, 160) = "43Zras=rn8?Cr?.ML1yvcXNH3;*gpqM;v(?(z5kXpvZ'SC;lE8N9O9\f<60]/\]P|an+0+OS'f',LHL0,rA}<mL\Lv+9bLjt/o8Ajn]eUBKNsS|Z16tVdAa1z\TlrpBp<>1Nm*q:(DQ^(*Ng\*46dBhD,eHZc>p{": a& = a& + 160
    Mid$(A$, a&, 160) = "Y(B;VSr[rkhEq5hri?z4N[Ct9][Ofs()Y38jG)nmZlH79aZ>-NQTE}(C1Lzd\R{E/dL7LRuFZ9m_]2z=sZfwzKK_<Ba3j'-Hx3'J\n;b0eC1,8Vshn6O5?bI]94e^w-i|8X:V)ofKZt>KxW}v.]JT7.]6Y[>8fi*": a& = a& + 160
    Mid$(A$, a&, 160) = "Mej]B2Hy=CEa\FKXl\J=W]hhp7SB<O2gA1\ai|VskDrZ5P-?AE-T',2;halD*]bl=5450];.|Taa^/l(ZBW>AW''e}h.ebK0b5R)R,Sc|VfpE9|3c.^(U+pnwO(*9wXr0N7VLIflTZ=Q9=0p<+>35}*8S5yXw]{z": a& = a& + 160
    Mid$(A$, a&, 160) = "-.cb-]SNTLh'd+6P6lS4};n:jp1NC7'kb-kr8ff0laN<|-f5f/]wiMp}B7V-,^a^|g]lk5/'I)IL^v+M==?aE[jCs2|[b,tfDqoo9rkx<H(Ck{mb6nH2oM]R0<T]4+ygK(Dg^dpe3f{bSe1Fb}eP+y7b]'-Mft(_": a& = a& + 160
    Mid$(A$, a&, 160) = "Q*RHPpjBg(Qol5.)SE6pH,.3RfdE/o5,Du}+rS4BF8y_|MQk+5o;WN?Y[3zw-B2rpy:BI3;f2kvRC|Ph<^y-bDYi]A-oX6ED'X\v1'},KyCPdPTVv^tyfE;V<JK9o{]?V3Y/Ho9JBT_6q;{ovsg8M|lzPQ9WB{:I": a& = a& + 160
    Mid$(A$, a&, 160) = "7m7r_a{<:6F2]_k7bpW884.)Kmo+n-_+IKzmCTq0zrIKx:q5*RKTYK/Vey]YBeEKOTKPQlX8nYICJf6ZofgNLI+cdHS_CgD'Tl4[s1|v+[(\]4cyE'*{ln\'6bh3HV:B*,T(7W7VFC^5GfX)^DIfx3ZZpUan^dOp": a& = a& + 160
    Mid$(A$, a&, 160) = "8z,0<P3=SQ+xdW]K^d()?3a5-Vm*3mii(]E'+\_kyhNc^G>brNbUV=Fe+^3lC/lrYpL=<3<U_]VmT<^8Aa)V/YZb5_(\e0;_Db^[+zY.^jAeD5S\8*j-kX1d9/'63?EuXRKeNgd*H9BJ{DL+HE(mit;'^NJiz'^S": a& = a& + 160
    Mid$(A$, a&, 160) = "[K}|_pphsP|;8Sjir<mvhOlDm>]t36*y=WuV/<CUYs:FxB?yZnsipOQMgzNX\>x>2w3m=M-:MH7-q/VaHA(;S{oYh)[?d[enNm)mxs]bfhjmF6vv(uqS6C{iWP188(Cx'jighQq9G{(8N[e:A8Z\=+1=iRR:bCR'": a& = a& + 160
    Mid$(A$, a&, 160) = "Mc=djjjsD{Kahm\[aAbgtdR|8s0rH[7'+.XCB,yIU].M|bilh:lHxl}P\[(F'Dp'(ejNY2DeAJK'bsUZ_wchzr:ab9/PCI?bhK7>fZw.woneCwu3UTK=bfivZOCJrcS]fp+Z?oz/t)_X^v|^FD]82*hh:gnSBT(w": a& = a& + 160
    Mid$(A$, a&, 160) = "JL<-jqz)9'pRm'>U+di5W)??Qt7T\|6NO[TmI,xgC+44-l\2*:v1|oI_.2'hJM5(*SJ|*Q':s3b5ZBzw(rnxu:,_*;<mwq\WfQH;qNwZw;oyqjJM\8G?v;62_P0[Sg.DH*4X_X/Fc+_45jt4O4/;N]4+u3DJkn3=": a& = a& + 160
    Mid$(A$, a&, 160) = "}/lQcSXqIzojA769t(1H^x-sZA>YM}P'r>DDs)r[N0IWbgj>VCB3\lof1oC[1P(KZ].SX?kX59?mG*S*WbljXNEHp7|anVq|x3w}x<Yu4iun-z9*_SKr(JHqiPZXD7RUoXP6UP,\2vn)CG\.^j;Bw1LjTRV,ACUD": a& = a& + 160
    Mid$(A$, a&, 160) = "B?-G>|r{oA:wOu/X4YsR|fDDv,AL|9u]inCZKk6kybUnmE2>k2jcF}IN?SZ7<D6BdU1/xoE:Zv+(C1,m>E<(|XXW?>Jtv7*<,ngIo4:0I_YUN[u3|Mu;NC-onkm:([Nv92'6)nn1:x|S:]||qa]f<jQ3};4jHw9^": a& = a& + 160
    Mid$(A$, a&, 160) = "]52Boh(gasqZsZ1HjE>_'vWa1hj6{TBT*iI75C-phFo\;4a81B>)EHD40i+^R+-Mzg(HhG8OCP)v'o=9+Q6kNFV,=)]:UC;9/C7A',UM89YHfym,_7c?WXuT3w:y3I6O3sn0a?t>vg]')nDVT|1kVb)Qmr*yQXOj": a& = a& + 160
    Mid$(A$, a&, 160) = "F0(\T0]tp,yqqUrc;_^Y\TGrE5lkJMQs+GC1J{YFcpjmp0*SHM>QXyn|2*t0LxijcDA\_Zj*d}BkZ(OqnuOSu9dJLEbG)g0*2N}kWlt]HBR/3cP0Rnw<HQKUK;zztw2.nwFLV^>N-WF]pudespZe8*?Jf2)+SuOm": a& = a& + 160
    Mid$(A$, a&, 160) = "=;E>_3zBG/R:4'Eqn<Sh'BrC46^55_gr1.l(,){iJ6{GMPmcQOPK8.7_sA2vxfGoINDKe{r3(-De:4gTglZ=J'QVZ}2Tma[to]CZtOv.W|JV_*p>Q|ZMF0kt|BGTh9viL3dxM]2B:-n;.=m*rF7st?v0\]ut0MG[": a& = a& + 160
    Mid$(A$, a&, 160) = "jgrN6|),O1Z;/i9,k.]8+]0GOZrZiNwwU7Ri/eIk5DvgffbzAEG4].mbRT;Qkf234_p=Tf,:s]Y^7>;W6TD0CJ-(3f|_2Wg\sSa8|GUS_:so0q:rliE).^HI'if=U^3d+9JEF;v_11|HVBa^Kn'ikB_M?2T56TQ(": a& = a& + 160
    Mid$(A$, a&, 160) = "jEFqV(_oRZA2?lA35XIEmX_(rZsXE)Clbp)EJ:-FIK0NIC8M2=_;3{QEE?nWXf6h)XssM^00F3c)pGIw5//>b)?bGB>>,7D>sXfxcR.4UIf3NecJz715Sb05*PvG(KL]OD_>PYz|5'i>t_7X8AQ=1'_Koi.Jg6o4": a& = a& + 160
    Mid$(A$, a&, 160) = "VtTk/GZrPWweAUZF,*<Rzye[Wyh;uy}ZHpb\a9^i.;ViNv/o)u}T<fab.>q4|G{mPOYl65IuOHSbiDeD+dz\|WiS<B'X_ZW8n8S(iI'/\TQgPq5RVthKX'HjRuY^?G;q\2m,F]IFwLpulU(*J;Nn/lAj38W>fMk'": a& = a& + 160
    Mid$(A$, a&, 160) = "?=HQIeZ<w2s-[e{6rblFz3(Gz:[?bLeP4ZxsPwYP\307A8?iEb9i/JVz;3TD5wLz=5FH4[=te's.5rffVoU21OG81BbZPLP'bf'iX{+(;coFl|xy(K8^v'6p.rp7CKoK;,bpUaXBS0,HcgOv;eFDsaBz+FUdwFf9": a& = a& + 160
    Mid$(A$, a&, 160) = "j+5X=C7L|iE2kcFhcx]{HJ4<*dwA+L|.P{2:5k\p_1^l++?L1UM=f4R=(PMak-7-arknuELFt+R?(QRTl9kB\b8QT*.:Zj3'q*Gr>6OC*|I_n[7*t:)YBrpUPv)C|kvK/ih5*IW++tbERL=*=NVQhre,wFSCJ1F2": a& = a& + 160
    Mid$(A$, a&, 160) = ".Q\n=X<I/YWH*gL.\GrdQogt'Q^}|Irk]tJr>[|tqJy|FMpMpV.R]0TL/y7HCpdrr?n*r.9){Q?bF]1nFi9ICyD\rX6[d.vb-Jt9fq?_<Z4+B-y6x1t0t<(v1\];FVQ3AnzuGnc*xUyoG.EEJhNAOz>vd+k]r]WQ": a& = a& + 160
    Mid$(A$, a&, 160) = "0d,Hi;pz(mp]/>eN+,xHFcedQ'aL4X_q^>Isb3Q?DGTh;77}9tzN<O^fUV68{V*/>/tOKyJU[b8X)/JI>rF9KcGv/))nKvX?G^KS0bepOL=_8*+we,{n:U/M1FzXRy(DyZ[gG\R=7{Mg<)dN:7+0pEQqTj(0:3BD": a& = a& + 160
    Mid$(A$, a&, 160) = "AKd';,5whlx6xE^ZE9az2_-^Lr)/u{t5jHl?ab,7.CA7O}jL_Kk?\4:nSxuolD?W\yOneH_B1\[MWE}BCa90:jf1Y,RH^FN-Sl:GWQ.,O\sU8nD?2BMfk6d5j/[F4(*Dub2.lDv^>W[;W*.|DdQtJY0do=j_aKgP": a& = a& + 160
    Mid$(A$, a&, 160) = "fJv_-(uvK'1GoESDW_:08McoE+t^FX]ANhQ.9<Ys]wrQp{UJbh^Tf:y?C|:T?4=)V7ilJj\CI0LU0fq{=U62f[=fv<>a;F}N58}]lV:=>m(X:lzf]h_Xe8J?{[xE5I7i(Mc[eE87Bqo/[:HkTet*esONHXo5/mh/": a& = a& + 160
    Mid$(A$, a&, 160) = "4=_*u8uL?O'xQ<V1w;bF+J^3Fq,SOTX^ijj8(O7v?wRao=sO.w0Yud-D7_6zTyTZsrfgWqSu.azg>+2R'CZd<SK*6T<ejyf;xD/,;O)Y>;bFeG0LBYa//,O*Vha'35U'/':_SHv}a/bVPEITAvx^2;E/zjcAHoCi": a& = a& + 160
    Mid$(A$, a&, 160) = "Jep8bBF\p1f00'IN_6{lZpT.V'YJpA1nytWw6bl(FoQ9[nsIB\qgCvbWg7*LVbi|cuA6Ck:4IU+_*Gqmi'>[lQi|YJktzZMmxt-/sxnnGqW1o_EY5b+T=CFtMCh<D-1CW6qtV;|{o7U))b/_/=)*DDTbtnS1];Ze": a& = a& + 160
    Mid$(A$, a&, 160) = "=hz4D}:yD=I96mNBzJ[oY-0kk1d(]xE9T4{oIPTwR1dx)Omsk^G]BM1[-,kZ|P5ox-QB}yTn08t*m)9H,[*sO/A8|oCz\TM3N/'H<b6NQVW,(fzfL61Yt=,48\jzMLwN;HIZ2jv*7ko+)0Z:.\J(d4'8ICBb']fQ": a& = a& + 160
    Mid$(A$, a&, 160) = "\X0VP_HvR'Js0pRWyMdW*+:nQ3MyN6/u;X8=6XvVl8DA,xm<X)}+w/Yqx'pv*tNq5e>il?QETtp|qK5PaL-DxBDF=b|\4,lOfeIvkzGNcOox]Z(;bKp-8>lWt529g'g<n>ACsL9qPudqtX;1i)-sP7*02ZkxGWA1": a& = a& + 160
    Mid$(A$, a&, 160) = "o=XRDQ0kk-|QmE\q],NHDd0h*':b]_B)Lf[[u<;|OO^VwMqQ4h_ky(2(tD>Tc,0/lqkMFD;eZ[2X14zxoLYp^pa'aSPQ]NVub\\f[H\;FQO{<P-dy?UUln4U{?L2*}h(t4{xha56XT[E1Ab4g<R9IJ9j*E,^?UqB": a& = a& + 160
    Mid$(A$, a&, 160) = "hU,(:N-WD?Ljo_2JD0fX7;V0(RDo9;6[cxu/bAM7se03DlTTVed\bE3BneWAHPHq(7-zh(R>C]:v+GWeBwh;=E{,a_qSu{6cTgZ[*m7_+j/tV>?GCe4dWsL>H-9p3srlzy]dL,ZMCv>l__4eBZ*_WH;.3vFKV<Rm": a& = a& + 160
    Mid$(A$, a&, 160) = "GNsG/Wq3i,IsbTO2Yk/^yH[\C]2Se|E?PX5*T/Xom+=hcB;*^YRC-OBB4[8Fi1KGO5h>(widBH,YkW|GA+|Fc<Haap+yJ,W3Xb8}Oz_N_LQ]Fq5DcQ3tS^STLN\QMTh0:?bBZ'N^_MtSB>qJ?RlwvSc>JVmm_7hB": a& = a& + 160
    Mid$(A$, a&, 160) = "mK,gPRy0d/Duv2lEbpxCI=>PuBL,4GQG<l)31k|CQa:WNojSF09c9K4TT09M-U</}2^)D\>IsYV9mXgoIPF6J.]s6iNX3=Udy(hAF'cYqyNE:L.7S+HHo>9HoQ2KuGy'2*O\5+xiosWmif.8FDB3g)xBgs9Iu.6S": a& = a& + 160
    Mid$(A$, a&, 160) = "22Mf7_F2|9P*C6Ko{4,hucBZ[-EiomU[JB|<Kv=+P;z03llz]rMJ-eZbD|>Tr2PnP^mFhyK/xd4uv;X.3i-uTO)JY'-rPS-];';A{yLkO(*(de:b*mb9oLb/oo'c0[oAm:ewYYbh'XO23>^eX(LvC,uE}lD8P9/|": a& = a& + 160
    Mid$(A$, a&, 160) = "fR_6W=XxJmdzXJ:FL4USe3p+LMwPc-t=R1nd=?UG7*c]K?,y[s)/Y/yp41Y}MqdCwwDt?HHeG^?is/,vJ_|Y4G[anYipb,.4)v8'g2<-g41A2SlK3hlYdu1ca2qa4ogDFWh>W\V[8QqTgPz6klO-gJ?4Pr[iLbf.": a& = a& + 160
    Mid$(A$, a&, 160) = "{ez}?Re{<V8f+-8)A+6(iq>\TmFSyDc;Er2qiw,CgsWjs/_K<Ae_:^G]+d.J]F4C6_OvcJMk1Yz'OfSjIzl{JI<]u1jol5j[=UFk:GOtazDoNJ0qQ|.'>F-f.IvhL7-9Yp{QHx0.<rEYH5}xbTdNWz^]sz?fw6eo": a& = a& + 160
    Mid$(A$, a&, 160) = "qK1|ep^R>hnK[NvK_aqI;6X7Frp[S>c9wgigvKWuiCg=ag[Zkq+).obK8IT+yWhlhp5AIVmas3x-Gim]f]M9l[HE[r>wS,GwmR8?-rORZs,S2H=Z?<XTWQvD6/l\JOMrssOH{egS^SY\mO7TaSd>[f44_?)o^1S>": a& = a& + 160
    Mid$(A$, a&, 160) = "M0T<csp\TqAKgFOGa7C79j)F]g?4^\ss7=sXQe2a[[MupR:(xd4+>'.)?H>o_O0?_vEB}(zdpUs''nX(psxBvoO6[;59S9qj\-jh:'t.NOP+*?y1B(QR(LEc':}ALi]ho;D>[{5nHP_>fH6__B\/F/nxFuF2.Pn{": a& = a& + 160
    Mid$(A$, a&, 160) = "IIb<Ht(}OQ)4}-)LZ>9hWR|P*i'F;V\[D|aOdfY'.kPd7aNhU;/NMF:r,m:|TFzt.U;XZkYbavG^c5?*MQrjdu<8ko34ie+]w3pP,v(PCbp_f+XMHIZ}=0KS-Xpp{l5x58HG)MDn9H-Sxk+6L>=}ForwAF[x:U/I": a& = a& + 160
    Mid$(A$, a&, 160) = "'\yRn{.\'IwK8tB8q_-Hc9F:JmzZKLoQ3kvOnBcbK68Kb1:{3HKf8B3O:UL;OXbsHPuU7l]:7VLwEl}C+ZDX9\bQg<a:mR*.Z_t-v?5Wiy(|GNNQlDM<ErlaCYhs<z=}Y*vj)N(,7,lb-.R8fv1[g>6D:iLQZc>n": a& = a& + 160
    Mid$(A$, a&, 160) = "HBWW{+gbPHTu:S{'afbN5'V.AJ\k)9goOi_8XnNIvnWo<F6XP*pB(r<.9vS(|VVS=K'pE|jyvy63FE2E|84-noObhX:dO+u_D]eJYWfx/s'HmHs4rQdRHnfvuF]o00+)twQBhr}a*1Z|vL2NhAy|s-4FCDdR9^/h": a& = a& + 160
    Mid$(A$, a&, 160) = "X,R\*.=2.[gQZ00d'+M{ChL2K+HwU/hfX+w:_Z_yc507K0Y8re8*ltn|)kaAG/W?=|Ldd[]Pju6cS98\0tI?SPi2W2V7D^4Br4w5b,xrbkLo/3kq]<9EexO-ktHRgBwxL0R9;Y_D<C1-wdz^|[8SM,0I)+3k[Uq^": a& = a& + 160
    Mid$(A$, a&, 160) = "g=D4km/w;p2</:k;.,9IqlJ7jl;Np25XeqsF{3\YvE_[Ll,('hKF.R?pI5[1WEt1Ju+Wme2:y,.SHH}skRitzZB:eRys4n-KByQ5L\=>RH0PmZLgOQoqA-[FQ>J+<j>4a=>8A8-N)oNN+\vLVy7sRR0hKZR^^}A6": a& = a& + 160
    Mid$(A$, a&, 160) = "CYdup:ifqKfwEkw_<0=IWAksw=I{hxrGM:>7j-[6me=\0WSH_]A\=7dYYjHgeM|(H77pJYlJ+a;|Ahzy0m^|\O'{:f*)Y7taa2xnXWy]Pr3NQ)4Od1EW)la|,T2/'j[^sGuO>thZuy<PI8h?4f^P|h/W*A[j[k.e": a& = a& + 160
    Mid$(A$, a&, 160) = "b]/7]=pw\zcS9\>|ar3Od1|6X(L=a;K5r1|9T28(QPVTO:[|OL?yT}0AgBu2cHzDwlWvcKb6/;wcP'wc'jz{TGyKXKM0o8WvBvocXg{cwKD2HO9P0A4s+twc?HyLF[*/my^Nsq6zjZ93;aQP0Y:6++4RTQ>0w[EI": a& = a& + 160
    Mid$(A$, a&, 160) = "a9<u:P'x;Ot?QA5mzpS(]DU+<go9G\EwZXgG<QJXh0]2t>\sX\m9L3IrEOk[B9b9\xuO{*B^CYYjX]m'7iDj^1<)/1UT3L>ZPG6AZK|9/>k15/9G<qP+=bK6\*F9-:];{FD\Z?KB7m[.cQo>zo7WAhpSfc}{h+-}": a& = a& + 160
    Mid$(A$, a&, 160) = "s3V4L'<l9'y*[0<av07DU)SWEjW'fyc>[x)LUmmyFH3AVA0q6m=R,^w7/\nLoG.A]0ux_DSQ,R}{z[XT{wDz_GU:wn}6*\Z(hKy(3Mm4YZm_:MDBiu^GV{PD-=jvb}U:2297y9QpY26WQN)WzHUB/kT?|7(M^)[.": a& = a& + 160
    Mid$(A$, a&, 160) = "8a_+o6Qh1TIy:(3kmks1OK28+Q'W?Zw*0[nF5RJd-Z,+?JUNO)nl2eqIn>Iqp5cBFb21{XtlF<UrmhS(}Rni[F,'V(\V>^\aR9bwbE.|CZE;vTtgqL3De0<(sFf6i>Lo+;][OiObgzcWeX3mnPe5Dv;A.Gtcut{B": a& = a& + 160
    Mid$(A$, a&, 160) = "e_9UJ}']dG?3d9na<GQk3a-|cMpiViL5-y.lKX(O}U=;0M^_=t*k5R*F?uQ{SkfKC\>g*?|5u{lI7i_f(q/A+Xb>o?_KV1Oqt4Tj_?i{duSdt1B+H_NnFj,?Y1_D2Is1;0AVPu7o[UjH?;K1e\.|89kVr)BK0jsy": a& = a& + 160
    Mid$(A$, a&, 160) = "dpI8[?R1'gamK2>Vm6Quz<]z0DkBwANEl5A038^('XO]{o;[{n;L<|)/OF17AAA</H{'iQ\wSOvQ_.yb;6B/GjD3}oF:mbT=ijqlBj4;t_>^{AMGQ\AS(-P0;7)75Uc3|4DMffmW3|yoEab4/ZlVJ\9ga[DErofS": a& = a& + 160
    Mid$(A$, a&, 160) = "OpmkaP=fNLw4*hZ5l8S=[=}\fB_(8,klKThb7wNdeI'Cax)qcwwC}:PYw(s08Y0wxKjqjT:Gm[LwwaBddLd'NO7i^NSt|D]j2=?DTYfn)k/5twzks/:0B]DB.uB+J\M:1Em-unIw?)9(Dn[ID*u))Y5*Z5Ks*K_j": a& = a& + 160
    Mid$(A$, a&, 160) = "?e>N[iNJQ<D?pvgztGO/4ntd'/):0z]_6>|QB|GuBhzY+15-B\oky+EtahE4(iQqHRSb8LjipJR3KOB2MBzHOL(>9hGmPM^Sx5f[AFy[Og1icl2-W+KgxW75=QMQAzq4+r?o|8F^P-3\2Xa:\\cJ(O/;ZcqiPPph": a& = a& + 160
    Mid$(A$, a&, 160) = "<5E4Rm[ysl*sj:{6,7,]W2otHd?fq/8Y_(/lNk|e*8x^vaf+Zsv/.D_a//BZ88PF>YD7D)C1ZTeKQoHfKW^rz>gBwGZ*(kifjSQlFpAf7y-s'Hxtd>[jk>Awca^:0Z^|O\U4NUbCU6bO{\<c[gKVh*7xeLw.qJyc": a& = a& + 160
    Mid$(A$, a&, 160) = "4ZL){jhX+Ora}>3qy3K;E4NPSH8aw23wdw:gIlvzU..[?X/)=*ejJuy8ff(>]0Rbgk'tDNSbjaA*y,KQ|BB8'YvoQnxLL'z(fC}(o_c,pd3.ObTX;(A2DSrx5flND9q5c\2?,BiiUYQ5kRo'AA:u>GR,|q4WX/Ib": a& = a& + 160
    Mid$(A$, a&, 160) = "W5z<q+[n1F58Zj25bZ08_k'bQX9*JTI{6cs.=<'XD8UntUrMv>LGRxHdi0Paz<OB4bIAViSh_7YlC.Qy:?^0Ku:yb>(IJm_HKrPn^kQ(/y/A|nMN2mS|iuvDRyb\[WM+H,9.179UcK1'6l*=sj0D>CMbG7>^ZW'Q": a& = a& + 160
    Mid$(A$, a&, 160) = "y^FnjVvtWJ;-mcto{,*|(As2DYH{Q(1P5to}noXNp*G,QGRBHSy7ipoowC?.^.CBiWpt<Na.4iFDDe/=I(fnKnP3*F'=nP|^;s2Rk2ydAO^qK_,+TdnauiFSrz.s^IR<h(N.bJ(gBq=5sRVf3xneN'HnP0\EvZx[": a& = a& + 160
    Mid$(A$, a&, 160) = "k5<<b>_vzFq(=;ni9H7k,jm>ADl\-bajPY[B0_wB7qBImn4ywP3+wlme5-{xh'zDA|m2k-h)2sRqmAZc9H'cmigrBj7kxizL6NTw+Jjtfo>\JEP,LVBJRM0k(vyb>UXs:,gIF('zy|AUVaeBH1dgtb-wyz7=1}YY": a& = a& + 160
    Mid$(A$, a&, 160) = "yxW0da.LJcBC>BtRSeJdbUsJA|^aXqcx(Taf87sr5F/:0Qiz;'Fo=^2P[wr{c2F|iqTGD<k<acyZT<cEs/(K45gRABNgvP|XwlQ,^K[T-BpznI[fjZHU_7-We5>AW1v<](<BWs-B)wi,/^Eb]?ntBqym.BMc,zx{": a& = a& + 160
    Mid$(A$, a&, 160) = "K-mGWxDw3Dwd/D\13{2)0riFVvZ4P(*vKayc)F}k6me9=KOZRjez9ePVdqjfcQa,>ohuLeS]y](U':]'Y'|]Y[S=o4xhHo9lv-w=89MgR1F0F?N+.B;Toi^afbp6>Vn_xpIa.GH+p7t;g?'B.|6<(pvFQ[RzgMb9": a& = a& + 160
    Mid$(A$, a&, 160) = "(<:o[Mm-ZvBHO_//L2.TU],FiBieFm_7aAZIw>G?)AHuC,d(h>aPUA{LL7zxraJOgS]mf9u7jrYye?uW1kMp(vj2I1_cs8QMHaqRxQvam0[;nn{Cz(W_dIO,[-'FX/7z1]Fx_,sq<U}gize}H=+JZVp'+\2C+MCD": a& = a& + 160
    Mid$(A$, a&, 160) = "?As1)rEYpEfaZA*\)JRc/5R:O(Y9}lI7vq1{P9G\d-tZ;c;<ny6j>fTcM-3EB79^;[Su<84\1m[HVeYnwh|9E]ITl.6fR'{R.D=Oo1[]Wg);]GT)|F8w]yDqul+58nbqRDM<1z|Fj4sED2fwj)ASe'{>>t8nQ(iT": a& = a& + 160
    Mid$(A$, a&, 160) = "56ucHfh'S;mw60l|g,*QnpxH-xI6e.<g{9pt,Qcx?-X_.^6Y\9d)Dsvl'Vh[;BYfXLTdbc>397oY1YUb"
    o$ = Space$(9279): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N07$ = _Inflate$(btemp$, 10178): btemp$ = ""
End Function

Function N08$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(10816): a& = 1
    Mid$(A$, a&, 160) = "4OE[6{yk)bku{('qhd]rjF>Up*AseSSGe{_FNxCgk>O+^']fjUjq?LpGVqqp_ixfekN0>aA+v[6OBRNOvtJC4hp6V42eKy0hsV5FKuGTataFx|>eIhapJc?f0'2XPwM>{-H8yqYVn)^4fvPc:xg}vcb11WLNrvs5": a& = a& + 160
    Mid$(A$, a&, 160) = "5H?XsvfcptHu5G1|4,?/fPUbf+;DzP4eH[wTdL0NJ>WQ^}hd|1?P5V7CbLpP4c-c-HQW-7X?KKPF.}=}PK,_jnXIC*A/fkwt*ke'DhbQptT1]d\=nmkzN/e+69Ivwa(pT8dQ32kxpm*)35tO(sB4/G-B['}z6-ay": a& = a& + 160
    Mid$(A$, a&, 160) = "4o[P]QV}EmUii8*q<_q[00|gwJeh>zUXc0>oU8z27Ofd8u<*2W\UW*LZB8KSIbR29-6HC2/IYhtMUrFqe(9Ja<JwQB.<gJW4(zK}=I-PS(sW;tg>g0=wOG6Ha^W?[;++'1f_R6Uc'*gRFX*T({3['{WC^{WYgbj_": a& = a& + 160
    Mid$(A$, a&, 160) = "YhwGNAdn^4BQ-wGfDGZ+hd96aZt(|h)jja(;)XhKR7dk90:Icj4kN|gu0+w<_rK=s.ZAyse''IMV'vvZJpl)K|n{=zaeE(6lmdT46/oyM+DumJ?kXp<I2|)sTM)/teVI)OXosztQ3.2H5{1w1F\CrbSD\:jg.Ss1": a& = a& + 160
    Mid$(A$, a&, 160) = "SjO8pkw>?|2tNUT.acq*lF+K7Rg'<QmV8ZKiZ_yYbmS}tg>}5DR,sZn[5^e[},;KgxuBodl/lQM(4QDFPJ8fJF4+^^2?*HlNS5oaIm_KN9m6|GaA_DTpXU73Dh74ZC8(7\2vpy}ofc'lya9\=OtUjjKKeIsS\].W": a& = a& + 160
    Mid$(A$, a&, 160) = "ygimp3ir/'NoBuxdVuxdW1:*.wLBoW:Oav3qvFo108SFa_ZN}(*r|P2[^X5^Utp;tb4R-P+W2o^3PjxR-8R,5uf+pqJpas,M)5io+h:0F<La-FC,bStgnEGd{xsZJ>iM0S?3}iaOwUXKlvFp5SmKa0OWCxgVbe;r": a& = a& + 160
    Mid$(A$, a&, 160) = "[hHmCj?*pi?4Ik}aYsoy_4s_qjOvE(9G.egklOsYw7EBUVtm32xktnclu(knIjKUMJi3aNQye,z'aTCq3XN;AoDfRu{mL.RLcHw2_]5fBlev9jvz|[eLtZ|\:Bc.U/O8AOUm_mDxls+_Z:zf=S4?mT|k}Om2zWaj": a& = a& + 160
    Mid$(A$, a&, 160) = "izq;?Yig{Ny'''ulhzT5rMt[6;C<M<xX*f/mVNCE3zv\bTZIo\kz9o|Hf'gF6vB'o:C4EF4uH[bN^+JjwFf].(p'S0z-1*?}WiCr>]+swyWo?h-[53-(R}}UijN7Bc_c[{_hy(B072WxKh}s^]-f*XaugNWX'M00": a& = a& + 160
    Mid$(A$, a&, 160) = "]6ZwA:5)vki-\i+w3]_03d\GL(<Nn3t1hi*hIeZ*zrVb,vj:A,kTA5*:)^d^yHrFq2]:]fpjx=]Qs0.G,0j^cAIr>({O61bSdNZw}Nx=ClB/VWCCQxj_(WkBM^3[0Q,Wu=M3jY<}W*f*ss(}U6w.004h7^>DPNy.": a& = a& + 160
    Mid$(A$, a&, 160) = "*mF-f]k>lIn7J65BXW,{mhZ+aiW)^pW03LN+>^y4lrF:L/7x{?P6j5(nVOXYkLE]t<S[h>wp/ZPG]^,iI9tPeIT>HUSw3/^W4f_GQSY0,4I??Fwj1g:J'ExEe^dMypE2WO=9?+^2(Uc='g=z{B.oWw<KQr^-rt<c": a& = a& + 160
    Mid$(A$, a&, 160) = "8RY}jQg>Lamo=+QuX>nt]rxCF7qi{G.>/ClsguX.pgw}el<lF]xr|fe<OHr]3qk,NTrb]i}h\M,/)O'-|a5Z<q'Weqre;AIaM7z8C3OaMI?2)5bY{S(UVCuhSZ3'w'A,^H_vUB18GEDH/)Mk;hMx4ue?qEUjN2k:": a& = a& + 160
    Mid$(A$, a&, 160) = "^sGREE:NQBp,p>8Nsh'2t1?Z0K3_}']qz)t}]7F1,a'urOE6H8XDYQz9[mpzF=z8.+G[5JW4LePi3(s-]LkvX5-F+W4Dh?VKbyQ]GA]c1g1NO3p7a]eB['x/V^;G{8\<>_{>L+g]PS=CZaljN4<]DKDrYzrmQR]8": a& = a& + 160
    Mid$(A$, a&, 160) = "pHwCF]+]F144wsvznQa-jr-a8H(_9kJ,EY3Bpezl4Ou6Vmvgs|CgB2Y7<vh-fDbl)nC>srj>53oo(21rWSXNU\KZ\R02p05<5D_-TxY9LM<)YKr?D{4r[F2=qV3Dj,qDok[ioj[Z?02G.b9Mdh?4AGgkgN-1C0bg": a& = a& + 160
    Mid$(A$, a&, 160) = "D+6Fvyr=>L.P:r}bXDSB]H-i}3^<k2Cl]wWlCdORGjItk7[cU|WR^GF*<,'QQbNC7ke3+}OF-MdLrGQSuT'.b?8BW5'7N{+,QwdaPK\^sJ{20zdNYWu+S5Cm.H{1?fbHV|WqeoLv4si}*]CcR1tRsFZGEeX<wp03": a& = a& + 160
    Mid$(A$, a&, 160) = "[TXe\.[2VRL6RHX8m<A-\HRE^XM|lZC?5Cd1X}nbqnyP_>iIpLLO:bzQUFpWiu6/+3WxvHX7Rd3qvT9HALzTyCis3ZEdq=d7g5/SIDd|.?_>8wj8OaD\SG(uJt?hK-3p|T8^O,:s*4{aL5lY76m\llfW=D0fM0wV": a& = a& + 160
    Mid$(A$, a&, 160) = "':-^olc;A.P'y<ly;4u+c>LPx-\aS1zCpMzcWh[XY*ffSDCKxWIP72eS<r9RZ9)YvU*w8/>sQYMJRC'/Mn1AT^A/>/|;mH9y1k+1a0;'>|d8,ZlHqGpcrCgUYYKc2ZR[2]3nB5CaqP},07_R3_B<?6KHR{+k-{8-": a& = a& + 160
    Mid$(A$, a&, 160) = "UG9r9,k'5,Eoa/TNsnG_zN/wt\0yTsfcXrQHD{kfSz+JGLxJu=^kldvJ4Av}:j(MrtMD';k,9}a8N+>UvGDeXUsTt86r9]h926R0S[YQCrxY{WzD;f5fEac^cbKiO1<j(4BCBy:O9(jv(Gl)B.IA6K+yEr;S'hSF": a& = a& + 160
    Mid$(A$, a&, 160) = "arL-5Td9W0=xh99^cG28wylPd{H*y<)+DKLoFp;G=.}x0^{7kuh[])igNiSNbtkZNkNd}qB*bXrt72RS^>:Z|I)hM:[DLWr\5wpp'4{}Hfyh2R)q+9f_4oT|',<+02me[3nSIcsoao0[OMoDny>:W5zD_OMU]AOG": a& = a& + 160
    Mid$(A$, a&, 160) = "_>tE3E9Ssz^IE8eY1GoXYROh\cQZi84OsXzSdXB[LKJXo?OE=Q7j<1DFQSNig+'8P_C:G-0:ZN/Cy=\,ZB3HB}nV6+n_(>/;IJ+Fhz.Rk]ChmYauTG0?kaEWCv0VIod0-9tQ.pHpt6MInORL?5Ls2Na.(b.4o|a+": a& = a& + 160
    Mid$(A$, a&, 160) = "JdtS|'dcn;fK\/a(_3o,uJpPmZrX=2l87L/pumeD)E2=36{<8b5uPZy2p<2GJo|Q;(Zl{(,Y^BRhRP:4,45uu^bay+<hi9)D_7i8Vw,N;PrzF[iHiG\2ZK5;f19hBEhOg9TvHrYl0VGKH9Ocl70)>x=u]KiOgcsp": a& = a& + 160
    Mid$(A$, a&, 160) = "bEBt)9m1,Tp4\C;uw4hw*_'Vg]Q-=Q>)g;MbrfXPW*rxMpQHDCZf.*k'PAipOaebxS0A+Rx\rtRWcfNuHAjXe61oFpXQ['bhQ,e0t.tf2}/>WZYY^8D\,lwX/8R?+YkODwT;l8cinD>^5yyI^wm6?jk;9O:Egp=V": a& = a& + 160
    Mid$(A$, a&, 160) = "WwK]QHyiluWfXjZ*bEX.HCJjqQB??'XeMz]G/_Y8qjnlL9_wdkg\dsCLR<MkgdV.CTihw1;c?'NhXFGTAdSZz\,>0NYYpyg0BOus]ei_pQtkMjSti1OexJst0DiV/Ng7G.jnFeme2(NqQj<9Zp.=l9|^-qnw?ax9": a& = a& + 160
    Mid$(A$, a&, 160) = "o=yKqBP{tW^ZQKC7x(Z8znw{/:a\/LSnTceOr9ldSFnivdtuBM9dV\2MXJenci[hmY',?>a4KOE_^pkx24QAya-fadB*}1q;<(c12uUo5n/J\.;Iv[ZI07qBFF^KiNaBV'rb*ewpb((c)dihD='P0ebUG=C5Or*T": a& = a& + 160
    Mid$(A$, a&, 160) = "),FDVxUi7*'jmFriqFj};4FX{b^d\)E]f|6t\ptfrfvxH^HDfjHBG'L=H[(obJ>cCnqg^iu1>P?1yq-_M3}f1,o_1.=22wSENKR?YffOoOhgftIjN]b[1^DdAia2{RTTV8z+DAzY[hiUaRkp5'JvtnkTxC-Qu[ne": a& = a& + 160
    Mid$(A$, a&, 160) = "=cj(v8>1oU1D6|X}lBF=c3}D|[KiGau1vc,w>F=b\RH7ZuQV;lm.u/OWXXuiC1[JBc;ns86TUPPh)r_:lXtSaHF{W{b_B{lFFS|3Wvv|>zV<a}B:MU9A6>assoSCu6ZVj^Z,q,X':X}DHv0TU(^[>KE>>7uu)}mH": a& = a& + 160
    Mid$(A$, a&, 160) = "p(cH?\hF5HmkWl90iq^mo)Nt992''(M9X0kQd?ZYuIl.X>vPz|GE4XSCIynAY]-;9zB^Sj}g3MU505DMG;^_5YgVl7mQ;.WxkJ.hec>KQo*bYw}IPok7d8D2E0GZYUtWRtf:j\8vv([dgFhXd<pjG4HK._NfRUi/": a& = a& + 160
    Mid$(A$, a&, 160) = ")^:IEwb\RxQ:Ld\lAxaWrX]>G:ej9gAx{KVsNxmDic.y56'>5yVpqCRyBg'SCcdveXa5'x6aUu_hJn;]xSZys^^vw+/Xo(/2(qmR>0n:;hshF\vtpojgy90t}(mtEc<o}k0nJK.>S2z)01Tm;5N?l8DW[B(Luv0d": a& = a& + 160
    Mid$(A$, a&, 160) = "nr^uInqQUp/>t0M>ZXqXr{8,kr;nvRtZg,Z>uG(m_?vkK8[.)HYTrOo(20EAmVooJ}>fQtYmkU(J?Z{9RDRW.I?^,L8R/?,7*IMW+'SBfjc>Ua{,G]=1=FD*o9brp7HrDpUTUP|(5rvR|\bI>uJHXA]_dYFahU8S": a& = a& + 160
    Mid$(A$, a&, 160) = "eZaI{,b]byjvI:HD5UoWUVh*}vlFt-'Oc;x7n8.GbzX_6W61wSNL=JN/zcq<jHLEs-e}CVtqnY?'9uv2y^bXzB,n2\*M3+adhqRqdjI;y[04,'J8){9Eq4=krnyV5{x]-xTo2EBl39y1FGCk-6E_QP8aD.yu{:^a": a& = a& + 160
    Mid$(A$, a&, 160) = "fnK{)H+ta[nDy=o6^*Al[a=r7-(8ja?W/.gu8SVfM)xWC=4K1R;GeB[{\,TBhec0hW8<KFTKpWgjNEaHiB-d='_h[xf<)c6w.=U3ZrAqwC3[E3Py8y8zK,>OOXZ8[Iun?[7Q<*wgDvTdVRd;Ahc9y6|.([9mkV?u": a& = a& + 160
    Mid$(A$, a&, 160) = "|0D'Fz:(Qlol)wf)E8Q]k3mP?4w'qsY=9tnm4_VZ)lbS;)85gTU>Mn*o1+rC[O23pC0ftmj>DQtvK-efk\\{{N=2Xtrk'awe0;>WoTRT:b'j<5dLO/{;>5ZY{0?<hIw0CwsFIp>q7lng'pG5-b9BCWt2Os/?ts?S": a& = a& + 160
    Mid$(A$, a&, 160) = "MJ_9XdVjheEHM5a0F;,=v1XA}5**/?e6Bi4z-<G:IE0,_F6?-R4Tvu}2hgFqO[M^o{j,x[=hub<N8+5f^v8LaFn1dSn0If2t*|,5MT|UZA/W;qXgf(_FXwIS:7sY}S[TPuTz7Sg<p{<IZiuz[6wvyAF^,\IH1r+^": a& = a& + 160
    Mid$(A$, a&, 160) = ",Une3|R:s>_DCSS8N'158QjH0L['-T(<h}>e2r03a.1]zZM*+;b6Lfk2Hx'RKcYUJ,zVCr8/{Y?tga)GJ?^>;;[rmg{rn3'+Ow.AUgdJ,Pc:yIQdlLY;YH5^nLBomq=xBIFD00q;JFJcalu1)b0SNYEHG28G,WNv": a& = a& + 160
    Mid$(A$, a&, 160) = "-ktt1Lc*lZrvV0VdSU0E6SXM,p+V=KCxH_b{LSCr/o4BAvtY[D>fwyP}-47T9Q5OO-)b'XH4kM|=MZO?mg_TP[ad,iNkU-)[IzrCfIhQ6OJ5qNNwSBH;lbBHPIev.jiF0coYws6'=my'=c8z],tCuGrSeqVQB((.": a& = a& + 160
    Mid$(A$, a&, 160) = "y^+].unui3X2GK)Hx1,we;3=C].D68Y[0qLa)xYF::Qaf>8CxweNQZ'j2ClGP974Mx5YBnzY8bLrea-=h/a{*ilR?0vWtUJ3x<3G(FN+aATghMs>3E^g4el+VXLP'lucT8/f_*p'y_F7G*_xFiu>DVKFq^{Dx1C-": a& = a& + 160
    Mid$(A$, a&, 160) = "m8JL_nnr5,8JT}p'WaYBQrr[FN+,WgV?jH=Qeh];?ck(ohjJmDss<S6['U*U<T?ATX6}WpcG:p]_f_t>jiYVkk)kO(|snC,VX5Sj}*=K8YM+]3+4s04Hfhh2:nHy(*p7uxpi7WvI,vY<}9)sKkzs?MiS8t6l6iDr": a& = a& + 160
    Mid$(A$, a&, 160) = "w=Kzc)YM2e'Z=DBORi1E6QV.epYwp50Sn;a8c/n/Slo={m_nJcqNkZoFy'u7R;>GZURKvFIKjxdd?Cq)-xO?^7Wbg7bxn|D.:}]J*7Qtx4Z}+M*HHK7Q^)I.p*Z_EGL|nuZDHZI:9Nx|Qm9LC]x}th\ktPS-5Ong": a& = a& + 160
    Mid$(A$, a&, 160) = "D,xLA1N9m/6pz}.z-w]eCHNR'XQ<<)R-LzsnL{^gOuL.5ok40V7LyHAob1I{DW=<QAH//vw(z:356umlJ;S'b+6.;EGsx0u)*6Ki7?9G8TI=BD'j'mEd'(u*8*f^WgTin*JCs:Q)],^}AwHs1t2r:a}yz0N{5C.'": a& = a& + 160
    Mid$(A$, a&, 160) = "LUBV3z4'C4?ypQeIe/X}5=\g8nra_2mfhr+2_|)ZThZF,yf*v<k8>>r{zBHVweE'*CKzGoMpw4B-1{UxszXy\{1)t,XXXyY_?gASb.A1cL=3Nx{?\[R,GiH5i3J5_L2j*Fe-z6>lsF:/)nZriV3(tCWKejN/'rn_": a& = a& + 160
    Mid$(A$, a&, 160) = ")oBmiqkjVOC,2Er=Od_TRM7UukWN<B6Z5j3h<V2K-TzlllHAv^^i*(I^D,s7lBvnRD23]hSiMFH<I-mmuT+eNEKSsM/9xZ^IIyoxipbj\jW=Q[OR?Czgdhr0=5)9tYRSc3mMgC}wYhntFd',D22xZ3Ji7I9L0Bm\": a& = a& + 160
    Mid$(A$, a&, 160) = "6M*yv-zu)08.[|Ot*i5E[*3,_<JFj,vxUWGuzEeHbPdYZeb.qrX9rao1GZS_:+4V>[\UAS=pbQOR+w(2eQG*a/.\,rDVYB{Mtk\0s9'qcV-3(am7CVYA?-]wkPc7'[6Ea0J+<4x1it}tX?{Cx*M+,46wOx{\8obZ": a& = a& + 160
    Mid$(A$, a&, 160) = ")(J94Ni0]eUm4(ZxDi_QXEgkxFo']HRCsA=_[Tw*CBFE(:TpqRnn6NL(pcbQP[-KI56>oU^935vd,<?3\0N3s(x.W<PmtLM4>LnRT?IIvaQKK}E6;Gm'4i51;QU4[e0pdj+v5sxkmZqHI(+}d_rbUEj9eVKFQ3c3": a& = a& + 160
    Mid$(A$, a&, 160) = "Ux7U_O0A9S*H,/ebE,P0EhDlDy4ePo<\fVWn04i9eZi/,|{0qdqkC0m}bjU{ScWOf/pB-ogU4Bdb10a9;Q+VPfA\n?Wzb<)F6ebX4hq\y{0tDmDzPNj8ZeO.Cia,-tOb9|zI(_g-Mh\bi<oMawD-ZU5G=34vhe=8": a& = a& + 160
    Mid$(A$, a&, 160) = "(f('+;,Bo>fvzBEGwH[tv9G+fby,p40QLFuBnTw{JiCm*Ay_]v{Kg6/*9p'Qt^KGI+7L|5T6J6D+F<vuiH[/d(zfr6>dWy0jjYsMD9h-rW('uFVgxdlQA[Su0RDeD_ik(N?4P7lar^6Uhrd6nK'Ig690(nloy8Jr": a& = a& + 160
    Mid$(A$, a&, 160) = "m\r-UwE>IEM3l;,h\}iJs.1+I?[[o}<[O4mR9BrjErh0DxtdmcMLfkB{M*L1]wXq+px;-vj.VDbuKT4JTp(-J=\Z|0[el'X]+Fu]9nhXzKJ:OxIuW:AzPP6'\CgpuQ;BX3V=2oaZ,KndwBlr<H5?+gDA|{=N*PX7": a& = a& + 160
    Mid$(A$, a&, 160) = "kcHOFV210b4KS]NF)eH->(^4l/ZS5ZbesfgzES.MT-<iyOxGwec>}sWV'zUSZNU<9qXo:J9:'RW,(+vp8f|5ld++?NkK7j6I1*(qZYDQuu4nW_\z}J*.VHKH7LErZprw/CuBJbejevhxfT27ZuOf/y]ZwORY(EtO": a& = a& + 160
    Mid$(A$, a&, 160) = "QNHw)zJ}X3xB8x5aFzRYGv:CRf{50FS^Gn(Ge=P90ui8'L6v1HnoN_CZP3L)oNY+j|WhA(lw\SoXQU-?=C)d_otSwq8f+KbAmN*(/q]h]uK_u2MhOzOQ:*0>?J2fJhiIvGwvs'^7R*9jKBp)i4BMD2wa\8,xl|7b": a& = a& + 160
    Mid$(A$, a&, 160) = "B;Z<L:Smyfv^ljuv?hOnS/'h'l[JBJFYEDO7.s<rrM<3v(tw+fCFjE=28MFqkgE0vxKSe9e]cY|LKiPD|MFw2/xlDDoV;t?-HO'n=Lv5q:sHJH2gV6Yjtnk|MW{.C417fZUX]ab*IhQ}R2=8\g7.lUBO4zHb:opF": a& = a& + 160
    Mid$(A$, a&, 160) = "Q8Gw]My?pML='GskJAS./2u'X3feT/sFkTPOv{*d*FoQQP,1/[jh'1er\J5Ee-UA9uH;pE|^s5zHRt0gCAaP6(E}dQDqaSfSaW4ztafX5uPKmL{HNRWOog8S90sB(Xv7\JFL_8)yapUX.[CsWY.oxA*wG]J*5fkd": a& = a& + 160
    Mid$(A$, a&, 160) = "/Qu_.CrtZ5/>B:Nqv|b(*ZMmeNGn0-wS|IxNGtssu){kR(B1l\\X22(olxW,>J\P;ZD8L||5<f;-]ZE1eogWa<k'DbJ2<OZdR>A0iL[AM4VMLq)='xO>UO5O4HL(lg<sr]zI]rthw'cE{KmdJCSu{(sctJ5]A]QQ": a& = a& + 160
    Mid$(A$, a&, 160) = "NZXg)^VGB<5LsBZG\]sG3KYR;YJ2;5rzILZ*5_gs.f_[z/TkpwJsjj<6,H/Ubz|ZQvp}XLee(H)_9EgAUd8y;f9II5cnQstVM79gfttEI9Eyit{kQ*lbGhE[i]MJ/|S;)ubM\\Bt+evu|-qkdwz}eWP:7+lzlkTy": a& = a& + 160
    Mid$(A$, a&, 160) = "=Ifae>kO9(0q4:JI6)2kk)be-2,yaRSUG2'ZpzDvrDOyn,fa',R3.Z,r:I4c=;lCRekDHnTGBqiwY}?:X*tLWhz|p<'(Vt0jS*V9:1<Ti]wQ*Ju'A*UxZ-]mmXqRaFO4'4t)M0W|\HZISPQzhFqRfAbE[pk)R^qL": a& = a& + 160
    Mid$(A$, a&, 160) = "ao}2JMKt/[YYX(rGQdVr-+qzY{r,uoFUbjT?G4+kG[duikRomHpsQRx5aC33U(ad\sipvS?1sxzFn<*ac5}/:^RVz>l/{HAm)6U]O908(3kwq_gTq4r08[Meo;:G0?PeTbTpq?<vKYro}0qYb0n^vaiS*V4{oCZn": a& = a& + 160
    Mid$(A$, a&, 160) = "7F9a39LUYfB.C/j8LOVMZlgdXm=>fKufJnz'Z'DYdRbEdq1ov.pmxt9^9)PmzK_=U'H?_RUC3+ySZBDlgS>1lG3JP1A^g_6Y\J2c+I9(>:m++[Zr,:4a5=|GCDTeY2kMHs-z1K+KIYWAiZy'wyQiW6,/mH[P)c=z": a& = a& + 160
    Mid$(A$, a&, 160) = "8m'F0K?N>oJj381,p(mWPuD|7dYF|ozuLR1v.i]JI_2;Uj+YS,1MS43jFXPOUo-T{mmBHVJ7-,-y:8D(63KK0UzEZRN*qCqkr>(aNfXX'|<L4eBG;ic)gp*Cxy5ziIZZtZH0t7w+P4\xZILQ2r8*'HFGpvr'x]Ig": a& = a& + 160
    Mid$(A$, a&, 160) = "By.wwCBBL4<EgJ*Ct\|99,5y*\e]A;?Xo5IHsrlLYLt5qg9VvrmrzT5-+,LYVIo^1vl33,\_<ha+m]8XQZ[eF;A+vLrnK.E9kT.d2Y=.'|mB11e.Wn[fww^)'P{k_b=Z7zCZrcVF_=M.I>TWqLAAdYH<s_3GWK=z": a& = a& + 160
    Mid$(A$, a&, 160) = "N<_)?0W:f6V\BU1mc}Z\_^eWMJA3;(G3sSOdu?lyrsX8/wBBJ.a3?.1|5}5BhjoO*|;z)A|5wz6^r_SQJHut\vEI+b(rt_us+>.3V(MXaS4*<8tFudUw?Y4p}\8(osl^>-'jTEkpqnn_86w,giW[d9'rh.l{1*/U": a& = a& + 160
    Mid$(A$, a&, 160) = ",67V2y(j/bbKqS^,5XWF]t8c50H+<Uc86Kk+_\GrV:+/(pq3SG[PfF'3+?Dedb<[L,SKxSC>}wpjJL?JB?(p7*4ddoA/}.;:)|=RR(iKm<pPUwA5-;T_e/[=/Q|0]9m7FFk9TtZ+..j=43SdtIENFd\ygRMgQI':": a& = a& + 160
    Mid$(A$, a&, 160) = ";sE0Yo]gLd)J2gKoyh<??<rUEKOMi,]wfiZ{qYJ6:<vA-e5)stVbdiK\jK*J91nx7\a]ifaSD:B>sUt=2Y>m1PL=_2s5nY?nJ{oUEzBIjxH'3''\ZcuBv.clFZ|dwC0TI|<[.26sM:,*)AwAbv*t;3HhK99:J,ch": a& = a& + 160
    Mid$(A$, a&, 160) = ";PzNzDmj'3b3W|{ePbK(<w{M4hdDaQeoP0v:MTXwHo]s(6DuEU,G.QB3(V(/0IXF/30L22AaakDkkg5Mevxs5RQ+RY/'yTwAoOsoo1XrA4D}<Zk7ET:Bzhrk?*o}Eg46TvYLwHMzkUXZ?<Kunr]m9DuPCJ]4.1wF": a& = a& + 160
    Mid$(A$, a&, 160) = "-vTHfDev[d(C)HQzXQ7'da{aEvuO'u^DNdk8Mr(EqhC./f++|ZClC9YUZh7*X3GE9OhI)n'9MzbzWev::Yd7.7f*0lBuD'pFY'Q{PajqMzieh7\-aR9=^|aj>Zyf28ym4(z.Y,m<uMOX2LZSRNE^b|D{9]gW9g_z": a& = a& + 160
    Mid$(A$, a&, 160) = "c8duzvI8RAJQqIT/KcD53Qk86,LznrQIja8ctg=KF,X3Um69f</3'aGI9-EA>kjHBZ9QOgxGc)iR(6WLdw)V:?>yGT7_(P?f^g[A2yi[9cIz5V2KT/HZT}WU\,feogaPHsZm8>Ld-enYC*_|DLg1P4>'QlD^Eul;": a& = a& + 160
    Mid$(A$, a&, 160) = "[[q0FwLYwj9;'B|Vtjp*>j9*|9Jw8Jzgj?ub4N/WxX{6Pe)>MtnR(:g1BSrJYFF'e;zY\-IZX}ooWs0LhaW6^m3VSU6NMtaew*A0OyW^;f'h5<rnmofVduia*Xw/I'm<-X4rm4BvwC5oX9FNGFlN}'IwW,bf]YZ7": a& = a& + 160
    Mid$(A$, a&, 160) = "V[3(;E;81Q.1L+PsO:_rWqbE0U?JfVg)I>vJ9nJ-_=gC35+s)8JHvfY_o.CMUiC_6[:Z.ojn{ILGTN8o?N+Y:DESM(;)<,6Y'QC);240:tOno79-e{OwuL|Tq[P8:'gy^|:i4=|3mIAHm1eED4<vVG*Wmo_YJwMz": a& = a& + 160
    Mid$(A$, a&, 160) = "?HX_s<QO{s*m<jDag4AQDUEcg{3x0>;Plt.R1aw5pW0CS*>8SJ6=8Th'\SONBU]U<99r5}|o/De}kEon;^yWrGOWL<obEnH(a\q<:74-^i>+wT0A.DD9pDjyPInE<L^8\khuF8C;y]N7f:\xAy'=\6DQ^l1f-RKi": a& = a& + 160
    Mid$(A$, a&, 160) = "Gk-eE*pxj:=?(+w3jg:\8hb4r=ih{PvhgwIMSn;Sz<(fiL2KRaOiOUo;SW1kr66<+:]/C28jOzjCH9/l8Rr1Au=Ar|Y3\qdUPj>_]VRhi2c)6tiEjdtyD=_Kl?19sB^z,hHxWqPGd6b'Z.ebK1UEm-[sZ<Qtcy5q": a& = a& + 160
    Mid$(A$, a&, 160) = "</)g?,-5DVI_V+I2^Jx^QqexIb=FfV*'6{\X3_gUyfj*q'3r<tt-L</nd90PogZM'k[<r-I+74W4>ze;UtO,u2I:8AQitsZN.CbEXTGy8wieN64>F](lkVi<o1l=(;_zs:goaRx,(Yn0?FUBn=L_V\[?69N|;j)y": a& = a& + 160
    Mid$(A$, a&, 160) = "d[v'/Y(Vh/k2hO?hMCJMX4S>RD:A5o_ERKtjFq^JsUYIeit[RD^Jt]L0ij2DG7ZoUEMLeMm*}\ZPX|;sK{,L+tIDqY41E"
    o$ = Space$(8649): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N08$ = _Inflate$(btemp$, 9443): btemp$ = ""
End Function

Function N09$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(11831): a& = 1
    Mid$(A$, a&, 160) = "3OE[6{oX_n2O8*p4ZjDlTGUp+5GYA^bS0Il+S4|:*HMEi]i:}y0R[}v3X=_YkIQWO=^C}ZXLn9ancw5V[E)gUhfPLZDf]?\Mkf{j,ZxHG:NR{SkkFvg=Y)sNLz,E6-pxk:+Sp<mg0pUGIyewM\(^cEodQ;y\N;n>": a& = a& + 160
    Mid$(A$, a&, 160) = "SX|3Z:wP{BMVZQ9iR3yH?[h4{l<NizLS'0EH3gvMQX,.eYvp0,?j;j+<kP\Z-8R+I{lLweD=_>Q{Df>oaopR}3Ls5X^hl7csrTs,B-vrUNH[Q7I7Ce:-b{z57eT-BWq+bPpN9z01X^r0xd2/(ietzp}5VAivyf[x": a& = a& + 160
    Mid$(A$, a&, 160) = "=jF=D]9+ajFA;o,F3txOL'U<+d.gdc{F6/UmJ;-k;*1A(*l?J64uJ4Pa]3Xe9MdZr2h_?peb9[qI,co\C'o|6]LQHnl^ag1[u(/cYIoNN?=g|l)HspxzTr(dLNvP]t<X]wI?M]ZbTJeaOqDwO0LJaelJg[JKJ62m": a& = a& + 160
    Mid$(A$, a&, 160) = "r/QXhnWIk,n=h4Pe0+t8(ai_A,y}F;k8A9j|P-j-|b*hxz)]'K_TCSdckK[=:WtcivqzYo,Jvy,)]FG?BPwC^7[^>J\NQXP/w:ZuhC-<7kpbX)a7ZY_H*SQPn\z9N/Z2nRBdBjL/HWuS-*VOlngoJwo6J5'S3hM|": a& = a& + 160
    Mid$(A$, a&, 160) = "vu/{Ejzh|2E.A\RXx5yWm^6ZfGjDNN*I+c>YxzfPB4|;JiJWk,xgjyjI<arr_>2atE^yx',Tsom=EgpKAx/RU0r[A=?S:KkH.|D;D{9+I1Nq4('at],N.,CzHN6>m^WXuUPais}ltODSjq4qwd:xyq8qA}3Cu^8C": a& = a& + 160
    Mid$(A$, a&, 160) = "T6e2['v9hIjZucDb=ZS*m=BpX>naU:2+oi=Me4]--=1t(hL68nr8}jZq9Nqy*72qYNr;P90iy<1mH^3?ZtlO6m_0hhcgI,.ibVv9=goQnMFYOJ60KuhJ-tfj{.2+C5b*<lIGibj)+7M\jd+Yc+4<i+Ptf?SWHQ]8": a& = a& + 160
    Mid$(A$, a&, 160) = "xI{Y.WZ:fr[q.PJW65lJow|?RSVs6X9Jc,4-COn01EP*PN_=x4WiC<cM_NGON-lpRNH;yNSLGl}ts6lofNMR,|aeM-i.^)ed6+Rb8:{DYuIHW.UTkUth?PYVXg5e}NfP_j*WGe*8HCdJwU:YXvk'3}3nr*UUuZMd": a& = a& + 160
    Mid$(A$, a&, 160) = "_zkW,a1Nm]'')fA4ok0Rv_qYo>65pte'Iz_R,B6[?8}6*0mK0T^h?s<}p;6?IQ?{|T\(PTbcdA.UVHmAHP]+]TKZ5(Ib(7=Oy2:>2lakMqb3lCMs*Lb7E4BbdAuGgkK.2nKX{ryZ^=*l[Fz4+DY'rp)B^AiygOtW": a& = a& + 160
    Mid$(A$, a&, 160) = "?-jc]q<s4W|JPfUt\Y,KMQRaweCui[O,Zl,mD1,XTy:S?3X5j17(9'Qt.||mocqk[mUtma3M,:Rg*Lv03NBJ)z7_0Jw(/zz3QaDI/_wlC1Oxg[NK0r]EbD+9a?SkY>B_[cgNIQic\x9\>h8{}F5eHfKBf1jy8c9R": a& = a& + 160
    Mid$(A$, a&, 160) = "KHEkekb37ul_X4NY:RMp*6FN<|X090.H>c=bUN(|aS{qH4cHSZ>UNTkYv}96ZIO{KCti7IMak5JxTix>rBf;PT\9r'd2OI[},pNe}WLzf_EDGoF2YCQI)o+^Pt1,w*p{T:C'{h+k>C]]oC2Hr1Am1Elmu8O+f'|x": a& = a& + 160
    Mid$(A$, a&, 160) = "B431\(1'p]_eMx5GZ8:sz5FF:{pm-Bu9WB;)rGb|0UxxZ5<(?aREn>/FA]DdP75z=QV=QWZ?XjX+n9+BLA1xaMG77VG+danyf/rgQ.8-k;7opa90J8;_2Cu8D;}QprMkR)=/sS<njho(l06JNxS+j>*jP(lNT7(|": a& = a& + 160
    Mid$(A$, a&, 160) = "kxSC;[e:7e|Bj/aq/rQ/8wJgrS2syKIQYv2?Kk7={')8_c=l\Z(5lh.st3(Lwrvm62(>(9^kpFO.Ed1.HyL7vWXUBX)c5j<AjRI:69l/{f7nJ(PMv|miSB?JPd;e<F;||J<.X2mSU)D:A5e36s_(fxU?7MtIZ+Jv": a& = a& + 160
    Mid$(A$, a&, 160) = "p8fHbg:Qtfz(/w)kXy9;E'nn}.O^MykHakuj_wel?)*f4YDh<i.F}I<8(D^IdzSrp5x>wHB)Hfa_R3_0jI/W67+)?aO-W<79)(EP(5X{xzI-}wzflpa22r8a8foKcZ3IMwZ_,/hNa5=WSZsI/-lkAd5)(xG{gxEN": a& = a& + 160
    Mid$(A$, a&, 160) = "zOiOvdqags9t\\+XUBR:-el7b)n>)|{aAZ+5A^9NC2zpIOBzyxys|4i|^a9W\h01?je-U,R?'cLK[qVip[ApOTdoAaCx4?BmwN)ES-+eB*Ul;dUk+'eLa:VAaqm:9M0uO{)63yF3cN;k;eU5FpLPg2MfY.1ke4PP": a& = a& + 160
    Mid$(A$, a&, 160) = "e3y=<[JA5FxGN5:{5R<BwwjUh*8q/MaN3r15rlCa>jX^CMy.^l4wWVgMNuS?//T,\PnhmDh4>r?VA>)];yBlI1_>>;5RPl3Dk_z1?(P<Sl(leS_aMcM/5??(tyPu8Hssc?Riw>a3Ex8T\fqWYJ6Sk=sp2|rZs\F>": a& = a& + 160
    Mid$(A$, a&, 160) = "^8R1w,S']l;5WT1Gl,P:P2>ith>Zq{:Xb1slX-gUSr^xDb=I?TB5bL/:;(;CCl((0sA-W;7\.'Fu(=\q4)Iv7SQ^]9QL6Mt=*M?Wt*u[>LCKgmML1R*)jdgVIh,pMyW(7^UV;N0;aD>=ER0x+KI?Km0\Pr.9H3pN": a& = a& + 160
    Mid$(A$, a&, 160) = "230>R{6[o,|Uq\UAcPZY>wV?[FAR{|6UZZF8?:Y|Qa5TUd6I+6k{6}MJvwZwN/1}=6g2Cslr2su]L4mNDEA/PK_S,\=euh)i)?O6R'nw-[K6wgqp_EQi[:d-r)2S\nVi6;r('PH(tBPbb>6ndOC,,KM3SF[z<K)H": a& = a& + 160
    Mid$(A$, a&, 160) = "Sf<3XR6L5)i,t]7-_*?21\;T[xfMF[4TR.AJzJTn_a;2CaynBJ9,6H'sKYe64R<Tt:JDxL/iT*,:w:cP(2uFk8'=D=F6oxjrY\z0p)aM88[e9NPlyX*lG<o'hYa*k/T>p[,S\3UxS^39Qcz,MN6,8{w*Wc/VuwA}": a& = a& + 160
    Mid$(A$, a&, 160) = "p\>*o/^o.*fFQ.]}c1nZA]ZDQVN.hQrjZ}it.b;}fk7>N}^Jk]sJwq[:M/AwVJsWafUaFoGL{FqSP>w-dX<Zi':,e|)Ff{/aWPD[GuD-*?{>S2pK9j(/F[(JRwiPJ{axRBU.;xXWD|^:f=YkGa<<iCls'KMmk7t|": a& = a& + 160
    Mid$(A$, a&, 160) = "|14UbNAr}nf:X-ZEzk|1pw62OsOqmevN)WH,/I+sdUav+tw<ry,d0di+xc])?X6FsPqR/u::+=BslynnQz<'uWGDObK9NdRKxa6L[7n}_(o\IpMM,|1?ei+xBE1ib[PkJ6NkCralwX'1wzIc:3.{X*XGw]92Of[<": a& = a& + 160
    Mid$(A$, a&, 160) = "IL0T:B8AA32.pf,9L:KieZUq/JU\*f{KBmJwCX1Uc1c*OxnzzT9\VIIONbYMt1eRY-D22m?o9zn]st-FmZF'\soOYPB*Yx|Vu-qCVh0(BDCqbw6_Fk-:gwsk+qvz>}wi1p7'a|<ra]N-EUSND>t{>xJ[csF.naJ;": a& = a& + 160
    Mid$(A$, a&, 160) = "jfx3WffY8Zt\=2Q}4H{/GM4u]KsQyYjXpV:)m:>v{i6+T4zxK46'Z6?(I7,GZ_U5)NF'm])phDEqo09GS\k'b)[CaPEZm5}yhylWZdikR]x^\O/Vq6:|1v3NVC_*j?+<'Z\K8_>mFw:{:we-Jn;=0D7Vq?GVK_*{": a& = a& + 160
    Mid$(A$, a&, 160) = "CFRTwA\clup4=o3kwSAQ:5/MwmA\NV,]KG-sBU'kHOg\sycs|bf3094{cLE0clZK[9/00{MM3X;^J0U=EtGh0a(l1dXd.K\_x{*>Kl5{P3H(2_Vf-F4Mcg-fO*F=RN83zonvU5j/EkPaiNF,a9V.}KDH^MwuSHMD": a& = a& + 160
    Mid$(A$, a&, 160) = "HJ0K1^J90WzzpEK9XB|Gwgwac3A>6Lam))KJ?17hJzcwf+8z<<-FevYlPNBRZNMvd08k=hg3KUt8G685d9ILYdpu}ahP5\4YwwY3=Psc/yB{wh*vE,Aawu4gEeOxCMq/)ttk79v:ye|_)Zy,aBgqyUcCae<lkWN?": a& = a& + 160
    Mid$(A$, a&, 160) = "3.VVA]_/?IRW>nTSaJ_M3(j;5m9t9Gb=)GfPqCN7.j29*n'{?<vL*IqhZJv6[2BKro\S.M.--=FJcoG,N/DOF{qhMGbs;5^R1+^Zpw7SkmTBByMO*pd.eU)5ZRW|Rv?|dp'01q64dQ|2>4'BCFTtRoc[O2AhNzhK": a& = a& + 160
    Mid$(A$, a&, 160) = "10A52HX]6z;O^xSD,xt.);:_NAXTFfGCGESFR'{1LwdvRRFP0_rMe-tyl1Jx./(Q4bcT)LFgBxN9]JDKJ[HR*BoS]q84GOhE6zH|orY,R<NBd_+6SuMwU0Fx'XK*|gXcv(gV|K1JKK;yRSpW6(UuU:nx=u+nL[^c": a& = a& + 160
    Mid$(A$, a&, 160) = "VfX;G:Bxf'M:vEhCb5o;^8N:wC4.+aW.eJCp0kRUX_YAB^6qYx0fgKzzGm]-YT{9P0c-'oh5{?:Sc^8O'j38CU=n83Z^2oWl_*7=LI/E.WWTI<Wh8dhxa/KWI3>^B4J}n)0Yat/B6+I9}*ji5x.,}tHW3G3XPb|H": a& = a& + 160
    Mid$(A$, a&, 160) = "gvBiDl+X.s:-^c_d)1ynxfwzN2.D6'oRUr^nAOwA:kH-KMR}9fiz1ANDpG{vHf(k0DdG-}+Eep=mB32XHWuxMGLd(NU0g}zobi8V.9/twdLs(]\-M6RDsui('h<,J3TK1-gZpWNh?)jxVlp?+X>agyqgXBi6u-A}": a& = a& + 160
    Mid$(A$, a&, 160) = "RNA_SJwK?1_uccfAOTLvI85'uE+2qw+t2hX-.G]j0J9d_gqGq5a5*}(?YD\;l]FpO)Vu+2YD*Q0_o-vt06tQ)w*H\sj>/*</EtN*nxTQ]CYCk]A=824jml),GH0U\eR1U7P[FJQfO|T?'t}oK;</|>JhMSzf8d4k": a& = a& + 160
    Mid$(A$, a&, 160) = "R]-{8JZkk:]bH60LfDL{KW^}U5xzJ_F^dej+yP3;/ro=LohWb8ER7C;.K;0i-^;n_Y/b:_.=ZC,I0RbE8iKLkF+k^lrvqdPnUf]XecXTH-KKQEaM2E,}GWI)>:Zblv:)Q<-.i7mUHu4J]J(WUu_v.UL*V2IPUj}f": a& = a& + 160
    Mid$(A$, a&, 160) = "^Z5ijk8K,zrr,3;w]N\{IFWfGm{<_U3f/jS.x0cshA4=R_[}F_[GE<n/VrR^xMj0C[ln9R2Iyxj5xe\g>JC[zaN;R*fmSV+-3G_;2k\xwTV7_STWvFK8H+q[-3+0nu*)>k(^AD.|W8f*oCK;<fRS].\M.u2/q-/f": a& = a& + 160
    Mid$(A$, a&, 160) = "_m\d<'\uICie(V}*0bNQM5\^+HVPsl|3F*zDT+F|nK6J2a/dU(;<glRLCo/*T*<vMG56vl\a:tD29Q8H[xg]=L/1Yc3U.Fy(pzv5RWFikS4i;AEs?1J]9i154zrq*S)7-{K?jnOB\?Zz6Kas,hfsk7Hja(EKkkH{": a& = a& + 160
    Mid$(A$, a&, 160) = "y]iBECqh-f-[r[ncc{iLuBZyX5o-XT,0tJU?,9]AQ2uQ<I?K{8O*DU(HGy..eQCHf45l{e-9xswsWqa.X^pvUQ/DxrJT>S<W*FUMZpRIG|n>{WEr3K>iGmc.l(2bXN5:r?{ZOO?3g*{IXo=b|a+34gEBHz>mxb>X": a& = a& + 160
    Mid$(A$, a&, 160) = "3/k4N?Ek9-{xvJzEtyBL(=d|Eqk;[>RVUYAwoi?>*<2h*2n,(X_h_w4.y7YdV7gqDk1Gtw+IHj7INUp}KL0'gyUsw-6uvaJ;S4BmuP5B6dY6GO5H\gExCNUfuD{L82Zqfj-x13_JT4EMV1nt)x1Q6.rU/QY|m6qB": a& = a& + 160
    Mid$(A$, a&, 160) = "94PvH[[h41vqI=D.tO;\kkPPqhm{r}+X'BE4hMNyH;-yW*b''3jtki3?z\?wSJOpQJWMZ:0vS*r*Q__u|7hU?UrX;5xC{gJ^^luvwAp07.OBrMJ0OYK7*.of{ti8_,j13TrG>)7bI|>y,<'f'Lr>sQt7\s2R5t5G": a& = a& + 160
    Mid$(A$, a&, 160) = "'BlO?naTqp<BGffsL'lF^3Nl8+5}pUYZ/cB6IG2pjt4}3AA^ygWoQuzdOv1[1Z_Ckr?ze'fk'=eJN>*.8h29:i*n'8Bd{E''Sp)DWe:H^^m_Q9eRm1d\vpoftvv0}>Lsq}lA7I1NPBczKGoA6\jZ-<)Xw<iPVU1U": a& = a& + 160
    Mid$(A$, a&, 160) = "Xc=m?Uab5VT93D'PY1zXg4Xj(X<J/N.WVZiZSX_,_Uc<u7*1BfD7FG)Uvjm1Qw>v1(5SREzA=<Q,k?vC,Ycgklkh:y=hnkV<(/t3)ZfybQ0K}Xo2CBtHfEXZ[TB/x,2HkF7>?=4?*N198tFn?NZivk^RUG0/*bNF": a& = a& + 160
    Mid$(A$, a&, 160) = "]edxLwi-E3:n;EMDBCi_pdM|*Ivr.):I*vpE/9TUOs'hH/T]X2/+pZ'.nTv0=>|*i,Dc[X>z,\eg23d:';_=jeI'O;[EAe>e;>HV=Y=meS)[nKc-b)F_MYr5G.]GC*Y1GBxIc\y-(V>JiYI=^iAwf80VXn-:Jkbg": a& = a& + 160
    Mid$(A$, a&, 160) = ";::?9kCEILB9clU}?H8pN_O+_XltJRaA|743+2pGZq2d'{d|Ar+7}G(.7l{bIPrK=pFwjR|s-Ty+lcmiA(CKuv;z07uD-ED1d5OHorrSQ.M0:w>J8b:mzelfoGpHCa:Q)P7SC;'[P5i/x6H(PPj.8i1dRlx=ZHAD": a& = a& + 160
    Mid$(A$, a&, 160) = "kB[g((Q4PboA;lz_:WK8to(3g4\ycAaTK./]]_w-Uwcm_c9+7<t7P_,|iS'4Sv]?XoJMx:PykX2^0Yka]22lfkw583|/Y/rgC4m(KYK\jO\RtWTH[jtus):EUt'0Vvz.jQSjqS3PNH){TYTW_xnRvm[L8nhIS0l9": a& = a& + 160
    Mid$(A$, a&, 160) = "yur+dx/WfV=QRDtCtjA*F>qZ,gB0QyxymaGhYPp_7X\i6=5=*EZvLWLJRYfLrnaR}\I(tt[N*zMt5yf>fVh.x8AYcpi1,pv=I(]NR7<p*qrRQtmg/1I;5}]Q(Wp'|LWVZ\.jTR]vgcG|V*6Fo?M}{q:77cs<tSHN": a& = a& + 160
    Mid$(A$, a&, 160) = "6xbg|*DZA=(wybOaZ[?wr9wd5'P9{1N\>8=*E/?Mf?0<?B6M*5'-6K'k)5'A]AnHmDaop3bp6zq:9{8wkCiW:-K=N?ndzMW|\Ge}.(-*R^dQp6yx{Hgd?C+?GcY.2)(awz68n-cWE<>imB\u(k3*C1CpExswX2pN": a& = a& + 160
    Mid$(A$, a&, 160) = "x>\Q77*>l\Gu\u;[i^6Z2)0a6L_.M/B)*AFCaPhg2p0</_<.1co:;NL?n,;x\.46{FZ>j2OZzvz(T},{Ua6\v2tiHw]LZ3tWoGd5tDjq=,8'xw]HsDo2U)w^/>Mbb6zjW|Mn3yt:n}YbkRA)F9nxz2t?L1J7a2x>": a& = a& + 160
    Mid$(A$, a&, 160) = "grEI{GON=VLSL3t4qZMRLud5,t)vgolRec8aVe{5vhT?/D[2cws;L_SprUsY\{8^-eLqm0?Rp1,]19aaIG34Dew}iqRf(lUNE{Y'FrZKeb_}ECriQZ]-7XXO,?NVOke5qoDxFF:|Q(1^'e*gYGo<wI3cWwdx6xzC": a& = a& + 160
    Mid$(A$, a&, 160) = ")GK{8bz'Qh|q>K/5VioeyIm*y>/NIt]vLJxT20D89*zQuju}2xyLVx2qK?FuHhnR[g?1d+4s[dyhffl\ZIUB?NPn^bLD9B7NA<e669}1|d+f1VcavKSJ.K}SFbjN]w)o.]C?Zci+;qr6rV,UfG/IPW|:K[0B-tf}": a& = a& + 160
    Mid$(A$, a&, 160) = "5O?rusg7>:hQt')6j]f[2236Z/x.z);c<{qBzGK4tUjk\altt.=+dO(^Y>YqL/67d*JLQZNA*9(L^;AC)=Z]I[BW<HPX/o5'?LQ\}'TMq^-TI.L7\{kjk)AGqrnTeH=5*XpQVd8O5:6>w(z\EC+;cF4Ct<f4loRV": a& = a& + 160
    Mid$(A$, a&, 160) = "FnXjJTLkp>/HlBc.Ga0,>l-HS*_Wuy_mE(J0ovXcCx0>NoipdYmuJ?B/_kQE*ns=]fWO)MB^_ZxFy]Su[jG?6qCJagTry16*-p_uP.Wk6)z*^fvIS[?BeJm6|Sj)/[Nr;9=\BpqW>'ZePc()M8suq{Qa\tPUzzvH": a& = a& + 160
    Mid$(A$, a&, 160) = "?NN{FyV>trc0sFU?8WwRa,'aIg(7Zt[Owq0uYuluwam?p,-KH=v\cUQza<fev>[e/=U^4<)FVLjG09CrL'N+?HwC_6?j*_ja0rj]MA5w2DBQoDEB1vqe*KY;0iUUR*L3G[1\Oi3:B,AfNl4KkD_Zy*Z?6DLJ>{_.": a& = a& + 160
    Mid$(A$, a&, 160) = "k_r[O?(v1*^3Cz2\3qQy6lKs;}yc8SH=dWF8;l_J(ZQjY/[IfS3N7FRoej\AiMExGQuKMGkZo[bEBk[Np1+H2]g/T26y66E<'9]rwRQgr>yO=<7xYuWU81sDA]awPE7n2]\v9|S^ibGb?trMw^-|Lr4bQuwO+Eyg": a& = a& + 160
    Mid$(A$, a&, 160) = "KP3GJ51w|4L<){<VZDWV\Ey/Q5:I}j8Iv[p'bV-Zkurx*Z({Jc-D/'r{3hsWQc,pT|oR1xVuul6Uu3DHokb3D{t-2W-L:}yA?K<M.cc,LJ_kS\TZm8Oi]ca1qRNQ-fAsql>SI\IDICX^V+0DH3meH8s7k)69Shf6": a& = a& + 160
    Mid$(A$, a&, 160) = "b?+Z0(InMJPgUflbu9H|'OH(j<RzoG(IAt.5W}/JiW+Urz\'CkvHQYZ9:cHby7]ha;;D+VQiNM/Bo^4xzkvM({jRw(vjTJ.r0y')R8d3tS9RQHJ5t(*AZ<eM2tt<}kE+l9pZ(']k/eR^gT;*W?6ZSry2;j-eZg}G": a& = a& + 160
    Mid$(A$, a&, 160) = "c605Q.O4NYZDQg2AZsuF7BkUe0c46,zBt>muc?]D|VBc8dqD-_S7ITYH(7u7Kr12qWiw>0F=QUceaWlr',|g<[Cb(,EpB-H9in_gp8K|Jc])z()/lZTXPQLQ'u_=tta[e^-eP]>LQMf7.R8C2a<v))QHXqZ9yLK,": a& = a& + 160
    Mid$(A$, a&, 160) = ">V'(24eH5D3exKzJ?/)pB^+tN]-':)WGd4=PM_C_G(0sy[N7DgOLconD'[QTwJExV9TGKrIp]Gmt8>D*u9]^PEP2:E1LNN.+oz[;a'g-fGB5=8(hRK-XT\A-zAY7,*/}E[1NuYIY<D^mj5Rm)lZ3fTJDz=Gk+|;(": a& = a& + 160
    Mid$(A$, a&, 160) = "vy7(AvvMA]^MI(zU6E\2yao.dwUSADKU1M*<8xbWoyR<);/7XkTA=(uK[3>B5vOdV8oh]KJ3C{Abkj(fGotq5y2y{HZL-o{nNN0ghbO+(:csu-+/N,wn[xZZy\],4Flj_9cy+SaZJGNMIlSVkyg{x{t71bPr*Aoy": a& = a& + 160
    Mid$(A$, a&, 160) = "Jxv5OWJUyyrkp:OT?C)oRl'0Kbr<LqCsn6HP2z+*E</s8;AWf,vxb,NheCa1_fndM)3l>GT)KDN,v7{3v-334\[b.[R4uxnBEpEQzd]2D+.avuqxuR}geeST\;Vzw>DENYL[(n_Ez]iy1ipRu+'0[A7-AopjP756": a& = a& + 160
    Mid$(A$, a&, 160) = "b6>A4wj+AR'7rjG\z+oT3r:hC8o91tGFNI7OS;Ik[SDRtJwDhYVub:r9]q4ibwvm6NB\3^=Lm|w4lB4[}2L[6,dG[|qhcB5\BOsE>^7Rxh3ez_>yY|;fi+s{,mWl?LnwwyY_8>':c|lUg:hqYA=3<zL>ryBqh2>F": a& = a& + 160
    Mid$(A$, a&, 160) = "wQMJAA.^u;U0y[+.I_8tnS_X+{Nqev\Z)W=KLc2IIAuVF:+b?790{a;2M>Q_79Rc719t)MssEN/VGfrLs=9qj{8*S<^oDhq1hlYnmM{(evpP.7ywM:+KwQwc1Sb=I1E0nuNQ0Z)-E5,?.y(uDi<lHH'+li:SF{BT": a& = a& + 160
    Mid$(A$, a&, 160) = "1PzN^,4),qEnXI4cg_ppLX-c+S0<EAZ4-*lKYXn^BgD*EJ+hNG+]tC?6oA.7}WCvAi-JpNVR4Skm)Zy4e=B1V(8LxE;8D9JKU5FyJNc90a8|-vpx:_[LBMJOhjuctQ:dM1sp}+OV:dxRkOYz<iaeJObqp,vl8FNe": a& = a& + 160
    Mid$(A$, a&, 160) = ">n^[(gs9-AJtp1WB:3kMmr/J\YmMb1YkOWoJdgWw{lU7*bR+)>6h:Kpv67es3l8,*FL{:'dQK.onE<;knHwvH}ji<(C_w:dUB\wHJl?M)0kp',vZ+l6ttYul09WX/4j:I>|aKF3W8V9:/]dyqEl1/4m=r:pm>q_j": a& = a& + 160
    Mid$(A$, a&, 160) = "H>1ZT;y,Q\79P.Drd9J{kLf/b_vL}'aW*XV\q|eY1Er6I{Lk|ZDo[+dwf7D:vwuwc{O_WPzbf:B|*e)sXFFQ=_Dt)NDlJw2U,,w(BP[w]7I474DE.gtbD|G5idiDPUpyjR|*kt*EHyU?3>Dx325:v]GBSrl36obd": a& = a& + 160
    Mid$(A$, a&, 160) = "poY34*F3B<jZ:hkf5^<cBye'k/ab[vyu^[;E>Ad_iGhS7<N<X7\/?bR*V9ndiZ;-ajc2mN=QLBuV67{Ltu4KKZ>Hne5tbZ]i+J/|r>l7XI(neAuoGePe/p]o|8E)/Bc2c(mRG*l}^Q,A>9n:rj,>t|-f-;y]rpL9": a& = a& + 160
    Mid$(A$, a&, 160) = "rG8AG;IKaHtAl61qF)SHfnCgAnOC||OuHs58^0*1}KM57KZsV7H,W/'73|KpiajdxcBa+B|R.c2g:M4O2yk>u-P_j3f\{{:viJT2=k9A'FtmS_O8HL6tI7d]a_\d;uz;)M08)1TaqYIxSs3uS88EqNdGr77*/q,x": a& = a& + 160
    Mid$(A$, a&, 160) = "6B:;Jg4vGxYRj,+-P4hu\-C^5ALc\hc>|Cx_5TIJ(1HmVH(':L+gDfjKkbboKtDJGM8E[V}pewt=He00qaSTf[:SSaZEIYPfsr^z1_=t2vA<pM4ol=v<(.;,_2Ip({dODOfDs?W}gnIn7AIzU^+xWkpFpt'=?hO*": a& = a& + 160
    Mid$(A$, a&, 160) = "B(Mt[fbrDu4:c+NQ8{ez:];iV{GXA]V9z42RK?Uq}aup{Nbwg5tr_(mNpD<3.zFQFUa,*++Tw(-(;'bDbiu>F3Kdg03Bj1WaUcL,[_l63J,m6Z[)-4+I4uOo}:2_{SJr\-:<__w/7N)EpT}4S2NWWt+DX?b+S^Vm": a& = a& + 160
    Mid$(A$, a&, 160) = "baIU;4:XQQ+z.M0SA^}MeWKgq,h{aNT_z,unP45,,c}w_j8=.5M-?d34WC=Tsw6uk6IaP\7eIfSPqTaobJ<?D{mwA6EPEhRHHo6lw_sL]RR<7659lLGA\8vYKOSmj3QNcjzWxF<tEmP-so*\d:59q4+e(Pm7;t_p": a& = a& + 160
    Mid$(A$, a&, 160) = "Dz:},\8O_f3.CR?wtBrPau?}ctR]7[^E^n\-Sww+^rWP>wt{_/Z>FPR,Ac3B{o8/eFuWK\]X\7QFrV[TLu\aCf0}]5(ZTzoea\+o1yo2R[Rs*=e^{3,v,{oWgY>usRodMx-/\_R)/'NMVPVPk*47KD,M1cysDd-v": a& = a& + 160
    Mid$(A$, a&, 160) = "-y<hZt5s6aTn|,4[[Cj0PH:Sgz958>,.{VGy[mh:f,3-KhjTjiWbUTMJY->(+IJG]E\*u;YU}qZP[1/l_IY>Q6sssCzU1}Kd^hX':PJL>kWCV9}>J[dt6zm=Gc:3Z72EB2IvN*Ki>Pyk2jME/id3zcdYDAUD=*W*": a& = a& + 160
    Mid$(A$, a&, 160) = "mebDo>q[o42;qdXf[?(q+^*D(pzj'k{'<<e+v|:z{_hWzQi{VH}d'>\\>L>f[gsSvV6EZuJuW-pw?2:yyJ/JX29fLVNsxJqWr[iJ8)kE>}>+;\sG.XHyZ.8*PGR'vZdgx=[HGQBT3ZQ5rzGIsd<}ZnWYI4p1G?dZ": a& = a& + 160
    Mid$(A$, a&, 160) = "e1Ti?d3QISWUDQW}w<e19QS6M[h1vOq]m]MLFRI=tPa.1*AacIbdQm\zGJ4j4dV*BcUXZgjsL8?8m,)VMP(puxx??X3UN7)_-0e2oa?>SqqNr9BcPvDV+-{[DWbvOHOdrsyUP+:PzPz^Dd:b4/O5U5EG5)*2O(iz": a& = a& + 160
    Mid$(A$, a&, 160) = "FxSgv)z.WWl1tFBn<|.XwT23GT[s5j)A?6Yt)p'Q?[>J^Gf}[_>YXY+,o\'[z)<jDTP('JMNhJ7ItOkjXH<.vdn:iE;)')Z-yHjwv:\|I}X:_*Je'mQLuis2bNe|mxN9_P5bnV]|FmZrzCIHD,'Y>FXzY7Rp(VUD": a& = a& + 160
    Mid$(A$, a&, 160) = "?gO==EG_Y{<]WgT,D=hLbp'*iAux.m'7mhrjZReLpvjWJ3ZEhfwnU\8-*}(0)Nn-i[<>-ZW=u(}Ma=Aku4?+CEMeUWc5lBy2[;C5nS|DRbnTJkNTwk0xt'o]=[?Xua.=6L)IsiP:BFOB{tHYSb2+T,0?Ye6DUlnx": a& = a& + 160
    Mid$(A$, a&, 160) = "|QzJmnLZ/rt?qvuW(cC60(73=GA7-ml,D;)R)^<9sa)*A5:v;TIggkwX4eWU>gb94D3YLc:pY4P}XsJ(u\x:W;f,25xDYxZV5;:Boi,0[fS-hPw4*Y2JI'Xlmh39vcI/lG|^4kZaj9>^_43OshF7VtOGl^KNCK*.": a& = a& + 160
    Mid$(A$, a&, 160) = "y=.jp3u]*EJoa<*.EM1l['<x?:BlqnS6XypCk<<?\h^_Y{8fg*)Tt-.gZ7ie/bz<D|Q^ncITCnx5xp_fTWkZ,t\O19bNRB63n]Fl2(H6qt2gefD0;(aiL*dFS0HKD5Qk|o>Pw^\-gq7/M:7ZT[=o/9s<;*,''abO": a& = a& + 160
    Mid$(A$, a&, 160) = "MUd9bC+dI++'?V82(q'ttDG+H^q;*ftpfNpWc|),h]GkKvXqv:{3y;0kYZb\oBqs_9(_W}35LYayX?)9V44+7oRjIO1.gog0QXJz*AU5m:Y=6x4'k6pjThWDtW>{{T>OauqQ*Sx9B2S;L^-s(o1CO"
    o$ = Space$(9462): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N09$ = _Inflate$(btemp$, 10273): btemp$ = ""
End Function

Function N10$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(12651): a& = 1
    Mid$(A$, a&, 160) = "3OE[6{uw8J\NPl;BJLP++u(nSohng*,<-5SJ]9/8cMW?e/2lxD-hTZnw<|Gf5.<x;/lVEtiy1c[QEWOSXso4'Dxa\QxyykmzOmqjYwA;LLsQ._te2TmvQ2'{ioNfrPoJu=TJ0jSI'yeW-xecoHoSB6Eg5?2Tziy.": a& = a& + 160
    Mid$(A$, a&, 160) = "Z[Axpn-dJUMh(DK{su.fr/JF.306_W<4Go{_h<Eg7Pn^K..=Lyfs8x>n47E>YPazrk-8q]MuagqrK1;oW3=qDsE|Pe)O.GcP8YDEF)lP|nJ5wYEvz4,+\\Nk653b/X,k,f:=:.1U(6\LruyjS1ZfP+|hTt:xZfH{": a& = a& + 160
    Mid$(A$, a&, 160) = "/BrekiA.XoAByex.(5)s<l/?HQKT|T=\*w}ShSAM*\bUFXbVb9E*?.t;4lPembuMfcXws[S)aUS70)QzLCorJMEvWuE*xDQ,(bZ;Zx2+37t(*etkdryms^vFN7woUTksTk6klw)yUT'7<hTz?C6Va+'aFE{NUpX8": a& = a& + 160
    Mid$(A$, a&, 160) = "t<m5qa/gK*Bkc0K<Y5L^Jp}E'nEz1=(l?rc7(rxKrQ}E*1fS}nvawpCF6<2QwITXY.j^tF,FxT(m_:VqNx2*]Ez[zt}-(UTL=hI;<uv:vNt-f\,w6oTYGZKgK'1bp'P*?1fKIlI\K)h']i9r/l^cv=(iMzCU.,8P": a& = a& + 160
    Mid$(A$, a&, 160) = "eoUogG7>yYu/S8QLs5Eyz,O3fv.rWqtCk*.MeIagU3A:bI?3>gj^d-;.uLbWTM.1/qAT6=,xv+9mZV==m_x(A]*P,A),EhAVNdCkrdy]D,bq?F11yX.KdD;o}9p<=|Zq]Zvey06,5\GzP5uF*-zYanigW3KQ5llI": a& = a& + 160
    Mid$(A$, a&, 160) = "vXBB84pUq[OlBTOqfFrTwzTXubG[|FsE<w2Cm\1T_ECmS?xz4o*4SjJy9zN.{5O=|{>Yd;;PzJ4Rt>LzbfG_bXb+*{=<LrQfNRp8P4*0DqS|PUwQYZWdu'cT0HUs8qA1>Ee7KQSSttr3zt=l|=iO==fwSQSp*:_I": a& = a& + 160
    Mid$(A$, a&, 160) = "U49YA1/(3JoV|/Gst\omyz9uA?M1tx90tVJ.s,_b_2MXmP;dM=I,6jsU22gev4tB[0GC<x,dCDZuxZxh9y<|]qWQ<3pD3sriaSjE2BkuhwMGL{P<o{qXVK46vcaoxpE*\=g<D+QohLoKZTMOh;rn]TVu^V<DY{94": a& = a& + 160
    Mid$(A$, a&, 160) = "Oz6wic390l.X[N6PdG<]zN4N/0t3^M,rtIj=OXVHmQ1vN>IgL4D9{I{9lXocwR\3fa+:+;RC?V?E.K]txvIboXz1;q_C;0<OoFwY)uWCAK:9_N6X]F(qC8u)\Di.h^+FMMYY(Jb'Q<zSTR4X\nEkC]7]ga?HBY.r": a& = a& + 160
    Mid$(A$, a&, 160) = "b^kR<SGNi'QIIspId{FH]R0SHcE}Wc8mc1yojl'c([LVfU[Ay5>'pW>6)**\4Y|4qSr30;S+L988rvZ\5o.s5W6-7]=q94:v3u_-=hcy+3P.X5Y'p.ZjTNC.ukmSvRrvRV9SITfny(VADogqhos60C,La>RNjl=3": a& = a& + 160
    Mid$(A$, a&, 160) = "iTk0ShTGGLZ+F4*E59?,<.nFQcQ,29nQJe/n?Yn5Ov?nsC>X5zIYS1{u(]rrj0fXGRuQ9rOg8WV/Yk021RYnyZRDC8<1q}vdH1il(I1:eRw;oA:v:z^ZlNl?(Mv*90pafzkNU{.C)U4K'_*})mZkgG,JyPj6,gJ/": a& = a& + 160
    Mid$(A$, a&, 160) = "qhNS|2[Ewm(P2ad*Ep9Z-BP9iHk{ow3Kd}*kMquf|D[Fq9Br?J:jKB,3-Hv]-V<0Dj8SOmZi\?Uee9EH1LJFIA/;?4Z;dWA)2f6'dYYCB;g7XLv7rp66Rn0_IN}6/xJrq.}^dLEl<Zpo4u8zSKy1?spTru|5S;n9": a& = a& + 160
    Mid$(A$, a&, 160) = "3:;1=mje;S1dzG?'KT=ZG+4{_]'K+gZ]LwHd0ZiNL'.x^61)95TnSnD^\1==F.[UL:AQnicU03x2zCsKAq7lr7Pc[P9kuR3RB6m73d\v7f,CKE{=](z\abR08/.m_8rVeUF9<=x7y{aMGzAD{.MvFdxVj37\s]PH": a& = a& + 160
    Mid$(A$, a&, 160) = "qvOA+K)wS3wPcT*sxp6(?4tzFI_s'VhoYR=4'De([+Q7seAahmj;CoG?<'SxeYW57^_La'K[aZcvX[4:.oV|.<IY{IiJyN:Y/T<E\GtK1rW<IbW(8cTBM[-Kly?<+38Ke4VQDOe}J\pV[6N*Dr1GX}w7J8i/8nzL": a& = a& + 160
    Mid$(A$, a&, 160) = "H=Eh^YVFlKQ0iv{qtRZ6'7Lc)DS>Z;T68X2mi[Td}CdUC6zO7GVe6mX<R^RceZA[vrO071Rsg9SVEva>z]faw}Wj_vx]^Xkgg98.mCFM'd/=ZKfFp+5kZy{1H3zUy2.FneP08OX[xQN1v\N85ucNBsjp,U:FYVg4": a& = a& + 160
    Mid$(A$, a&, 160) = "FP>gpK[^FM?AUeW91B|)1B-Yl_Ibsnwpevm(4/LM>HIm9Gi\i\\R/Idg>G\QLMF'<>2Y9]TT73Nbj;L;SlQ\U}jWTsxWVvt*+m_R?-Gzu44.KkdXf98y4iv^3ugBq[uBXhkhBmu}CDhR\Rf6eCkxm];:(y:(kytS": a& = a& + 160
    Mid$(A$, a&, 160) = "F(/sff/d9gmc7_=[R-9n,Rz6d_v53O^+X{fo>O3;IFeTqdhhg.8==}mblW-Zt7f]sAq*B\X;JV=Rf7cp7N)?3|q)ldu(*CcLEvH0}7ewkTMF.\<2.U39I.P(W9RF_(\_:xv+'Z27gEh\)Rl5g9\jD4y=^P_c0<XT": a& = a& + 160
    Mid$(A$, a&, 160) = "ZIk8S=xh(<v^A\_cO-}l})gnutB'^e8MPMRAVwR3oG*F9pvFm58M*P+_N2?qs>P_NBC)Vo7V_/iERNRS0jd8uzVv*}^z'iCK/MTgwTvcVJ;qW0;Zj}BXyqZ3vq_WSSlStgh/>WEi,15'\\<[_y-l3Q>cZG^1\ey>": a& = a& + 160
    Mid$(A$, a&, 160) = "-,W^V6s{w{^iMS2mwXE4'Vl{eXDfl7?b/^Ryc0,y5OTU[+r}yZZwD0+qH=(M+eM)f5E+nm0[-SiJ;^ySC++YSI2hMX_Q;<AaBhffh(4;Xr*/aG|_Ud^o0sK6S,rf<YU(qoLlLHx:<H27B7TuGuF{<GdVjY8wW->5": a& = a& + 160
    Mid$(A$, a&, 160) = "Jo?_Y[*26cs14]^C1={YaU-./.LoIglWBnG?'80.xl^2cAi*r,F]WjimB/6H;>PoIHa1X'V>x;=(^q8s3kDp'uW/9xkhPr[:=F+}^wv|HpMg7M|D<}Y_*u4u+?,1l08L^[KHZiPmfvHqsPTT:=jGZN/6/NP8Fbsz": a& = a& + 160
    Mid$(A$, a&, 160) = "8qZr7lcNo<5mfh:(mfC-xiq8<Gn}g:dx5L9czu<+hMBhoj{0yeNeT0kg-e>yx138;cawWD^,;rE*I^f0]sPRaz.OT5]y_moh7s(?:)Jim-d|Q-eMJCue/xSN2cu'BnpR'}(sKZpWKg=dtpN9Jx2,GWv3f?avqh]M": a& = a& + 160
    Mid$(A$, a&, 160) = "M(MfR_z<NPBSma)k\d8N>b_:a|>*{,pQ<sSCx5XI0fPVi)R>PXd19-+d+2fq49YW]?mw^rkG9la[vadpn8W<\2iR-mns0(zwrG/_auXR(7gJS.b0CRIZi{C-M.iWguT^(<R5;SFk[;;,sqzKj'>'PwvS4]eQTAD(": a& = a& + 160
    Mid$(A$, a&, 160) = "TUIgW=A>p|bFT{>|OpD,e;qn;Xw}?hXu*;512x'?RTufh<(PF6[z2HEyo;m-XySl2H'X]?YVxn0*hFOsnVnLsKQ:23HpF/)u.'^2]H/rBq2\Poo)Mv1wX[BDE6B^[A[;LgveuYDpO|=OBpDid2i4x)RAIjn]W.'X": a& = a& + 160
    Mid$(A$, a&, 160) = "ghnsBafRo8wBU.D|9uNpoa(R:|LwOKFX:o.{mA=zn:{g+'g|Jn|5.=j?[4rP{UK(U6[AWO<q\C[T,ro.I]-[_(MM9jr^QDMtjxv86ZdNMC8^.-C,P?x}*3.+Ekl-}^eXasn::,H(JK{w|i\5r:,La'tCPD{s*|Cx": a& = a& + 160
    Mid$(A$, a&, 160) = "Y]nHi\YC>FWZPEBsw||Q>^fy+}p8NbW2.pK1Z'O*IBaixsq]^MViKNfvZ?cd2XZs>fMjFs;Bh4b}fEV7uPb{:VNDaL6mFDy]w0Z90fzTbvSEc9g/lwh:PwTqW\kc6B>qL6<Cv/|'e.Dh0P<jBseTWpKa+:gh+QZ{": a& = a& + 160
    Mid$(A$, a&, 160) = "q:yL>dbMm9n9XCdpk=|*d3dVo\*Wv((-k]1toacxi7y?bmY^W5V,8A[},Ry'l>rJN-Z_HN44Jp5o(h*s5S\xk|erPWf;l'Zm3{wW8qrJB/ITlx{M-4kwaO,E/w*/_S1=cm,fsbTTD/,+2znc>/paB,*yTqs<zv}I": a& = a& + 160
    Mid$(A$, a&, 160) = "q?_cEyuOk7}'NS|RTOxX0(YMBap5O|z-_P|]4DyvXA0G?(>U;-wtyh,d63rWbx__>qWf6=67(){URdBs1_cr^>U{H=B5[;L)[<>}\'vPB)*qHg\\nNVaR|QqatP:<\X{QdnY*MzCYB3<sdmCcvkCU*hcGqywNvhp": a& = a& + 160
    Mid$(A$, a&, 160) = "Lr-EH4wgi2gdXhdkKYF(bL.33WhrETezi7Mnu|t9K6o{kN,(K6c0kzW7EfiVLXWAol>ByV)t|sUDHNPatbjH-(-y*]1C4QTq?>ZgGWsla<O1q-,Lc\1>bZ0}G^r=+?S_Sj?]zjK/j5xZJS.]3In;0\;pm0\(Iv04": a& = a& + 160
    Mid$(A$, a&, 160) = "9eke|^Ub2.=i<b[a)x8'R5Zx^nSG==QYExqb^WU|OD^i)(jU<V+:|o{UY-HQ3x[+w<QnD1>n8jWQ+nEicmu_P5)LgLB0_pMTa4SDFjJeJX?D'K}G'6^H6o2,gach+jDxAZ/,]8s8H=/Gf,qd7cj223+Qle]>NO3-": a& = a& + 160
    Mid$(A$, a&, 160) = "<15cqdi-9|TU9-7gx?Y{ha|qrDBKHh?6OAuScu29=uBQ,1:cw\tK9\5JD5-_y*Id-}ZOrb|imKEb-i'l>.Waf528TAf=]^ak0cesVWq}cI:0JHdj95Abw.LGQC{yDW=V-y:0c\U*fus_?p21R,3}:p|so|HVnO]Y": a& = a& + 160
    Mid$(A$, a&, 160) = "VR^aDkgDjNc=dUHkWM|pO?-m+;{/EdAJV?8t+|-S{]X|TbjT}f^Tj]cx[|+h9,*.3.e0z+p=U;v=),hFmqIhX3q2S;4lC:.A*DoiwJf*y)xutaxkaEviHtv844tWG':cC3To\'J>)w8\T9Ke.>HdFt2rsD?kj_fL": a& = a& + 160
    Mid$(A$, a&, 160) = "Rki.Q7X*6_]7x4BYGVI'8p9cILxD|ko7^r[HT(/_;'<j?iR[UveASUu},K'DI\oS|k*Ny'K0u+O38rx[/?2[qN:8FyjgkCcc>ckpImH1\LX]0-x_w>'g+mo96UR[Rr\O_uNMIpxPvKv.aKC4,EDBC3{(b;BUyZwP": a& = a& + 160
    Mid$(A$, a&, 160) = "D</[[M7,lwH=rxOy_cyVT[TxrlIekcS2yuL/W0.CtdveLdD'ypA6re]1TITR8[9R4TeHDh/1O{T?rphBdv4\Ital|':OX.bG7JOwTykRTco=Mb1ul=ejeRFKsriT__au(:|-xkk=H|rgY\NBbD=0.gh{3(Mnez)O": a& = a& + 160
    Mid$(A$, a&, 160) = "iI59C9+p]}'uqFY9lhd4>Gmqf>6BfS_vA|-C(Y./irTTDrn\p;k?p0R:00H=;3zY7dvtG\,02VfeX(T;w_3fi+]^?ctU/t0uGhqm2RBu4Dz6N|a'\'sK=9QynTwYUAq7juC)wMT3u+kACp?Q[n1+uFb:^ga-E.-t": a& = a& + 160
    Mid$(A$, a&, 160) = "^r,NKyYa5JW6)X;4FyP^,i]=-ZIgrDx.4wbsLNm}EXDp4]1sDw3QautjEB<>i4adEh>]}TW?K54LrH'[[)k(WevSFg4'zG\}ik]Q*OpsWB8uQsG?O+gxQNUSoy8ZtLspAo0q/Lm-5nT5Nvx3yHbSx.7z)Jl3[s{T": a& = a& + 160
    Mid$(A$, a&, 160) = "*8gkaiF9HZ16cf[:_|>b^K*TLZTg9]^[AYE+fQ13xe'vkSZLFqR,2(n[89Bd1L{G_0.meNFI+FsRem/jYjHX(g(Qz)wt[UG]GpNGhF>9c,h.>|q54iNbUeN}GxsP6E8edrgEUbt*Nbi^D-m5vYZ)PNC[i<in-FWM": a& = a& + 160
    Mid$(A$, a&, 160) = "+g?^v(^q|{bVoiajer7,IdCh(NSCS-w;y765GLq8pEv6R)/X'?baC<YYHz7p2cMVsE86.4c<DXn(Y'}Ndh-xEU'/[7^6elFg<s:vIpR*WTc/-}t40aaT8A)5+7gXdSXibVCxIE5EZE0:T9:R47UAA<}OixXWEr'Q": a& = a& + 160
    Mid$(A$, a&, 160) = ":5_dfIsj;Y.yTxu*[(UfmgNszU0^9B?>A8*.6Jr'9->Cy(?^P(gXv{FO6lU()5xxWapLSDAaVE(m+CXX5Zi<r|ar0q7x3Eyh\]Wvkpb.:48m3'G7rALC1{JBy3NIK(]{5*XAsK[s4\{?U./<CWC[btGQj8uB'YDi": a& = a& + 160
    Mid$(A$, a&, 160) = "E;6|Z?>'ky{zD4+ozw+qL.=MxZy|f7hDE5VjVkaY\F3jkB[WFALxz*sGu=:;Qx*a+sqfwlMDX0KMW0F6kwY/joVaGKUfm,Vq'zWcLFXG8TpVLLjnqnu*wu8ObAWcHWGmQh>^QsPuDMacbx{(?,nYaqn*xQcJZoRk": a& = a& + 160
    Mid$(A$, a&, 160) = "a]-vbC(lSNP3uy4r0U6oVqwu9u[wNF++M.g(V)/8,+}QmHMl|0uDwQBQny.Tm*K3pWPcklejH0WkQ+lX6oqK[?QxHr5P*.A+5Po.QVx0JPn<J2Jls<U;CUi*'?,a9G0[pqP;;)?<..i|cHpZF(fqcZ}2DxMI]0dV": a& = a& + 160
    Mid$(A$, a&, 160) = "I[EjdYI5Yg|[3R?<>mysQp'tGWKiJ*mR3bCPLx>9:gbOJ:0z7lHhw:vQZ:L?oNT<C8tc\Dv5_9z]F(Dp7NgBsXa3Y]reu69KfXZ|FQU237-pb.BQlpGw=}*4?\gre(<k,SW\CIaai3oHza52iEAPl)*i6X(Vownz": a& = a& + 160
    Mid$(A$, a&, 160) = ",RhEv>d6c[h(hA4([/TnY^ZewPPTd:t?0{W6E_:0fQr,-h<2EwkWSyjb/Le6MLsW:eW^Q,oLVP+UU]YV<zoULXkEod7SiU'-L5S1.=XFMCfRLz}H+t8uo*>lyS7roiF9uv?dpV?O,Oro5?0(oNkvS0ImCQ}3*m0J": a& = a& + 160
    Mid$(A$, a&, 160) = "mKLO7oT1/Ip<i6?qb)1pO')ZeL4)rT)7ajkH::SIe\:7K;4Dr6wz*?i3gDPk+XUAhfi9ut4Yd-9\s6MnH_uCZSpVPzwhj7k\gaJHw(v*UL+SO)fG/Z_a7,k1pIGsd9:>3p\eUJ*Vykja15YiZVM-48KSU0n9CSV+": a& = a& + 160
    Mid$(A$, a&, 160) = "2:d,6:NsC+6ESQkxu.\Sdh;wQOE?YQ|sC1ANKhmZ\06N;B[?44'Q{s6U,mme)DvL[TaYF?OSCy9qRSQ[]JGNky+6|/MvKWySwTrMCB+?[}iUuO.[v1V7:^MjTP,|v.2u;{Mc{{_+*J^sU>3=gGVi)K--]YibmX^-": a& = a& + 160
    Mid$(A$, a&, 160) = "CJ?S5bmgJS\_YYFAj/Jocj3Gcfi<gjeE[4ZGYfhZQhT*2rN}JM}32k=3V6v]a3WAC:jucm[>_7,v8auhZIS+P=Cjj8FYAS_Q:M6XQt_._KDuB}xG+;bLEm)O/v;]ktF0q_[.XkYbVe'+j)yvN)A0Wk:VLOG;W}ja": a& = a& + 160
    Mid$(A$, a&, 160) = "^_(elKnL)YlXez|xwWn)Vu7PClcPqo{(mR9]FMa>J*Z{|}XWuNJ+Vjp==me^d>ae4qABG:ss[3ZK>HEn[jPPchX5yO[W3]q6xHYOwN2r/2P=i'FxE/CLv>f4Acwk\(])4M8chT<?-_Tlyq*;'8Tr2j{?b?_QiFMK": a& = a& + 160
    Mid$(A$, a&, 160) = "hQ0rmg_)</WsXvB<2_+KOmMTWpXGML}UQY[r,W8MkCDYRt*y/6_Xch0_7K>?Kqm=A40E0wsqC6FU-Eay{6O96(a1*3I9R:X<vUnhpg^lOW=zCSTLrgoY0^asqmd2IbF_lLg>X97hro_;j_t(9?SfH}i]_h0E=UiI": a& = a& + 160
    Mid$(A$, a&, 160) = "*N?;Z|7(uDIjIKpqSaQ'abx_fTP-,MwrYM(,Rs(;v\dd.Al0A6Fz8ap,Rx+iJ{9OL-D5yV-1r7?2Gp?ZjRdoDkWvus*EzZN5<*y<mdFqqeoIOvVLz4ukh2QA^g4bzNe]zK[;o[-_)Ugh=rPM1:VdAiY87eg+-PjQ": a& = a& + 160
    Mid$(A$, a&, 160) = "O74ZVJW5rF9dvs4K1p1Ozi=[B5LL6-0ZYyS-yEWZ*ZvZav0)I_<ZX(>NZNocoqZ3|TZ}LYlCy09u1*s8]AYRcBu]GwcZXJXExOO<Br,sj]MvDv]A_0igDpOG0xHgl.CC]rzq'WJ>Pj7wr2(e3Dx:N}>tVxuSAtfT": a& = a& + 160
    Mid$(A$, a&, 160) = "t3A-8nfRy.iYd;wNVV]hTp?_fDNM'S:0PgF1mxkY4P-KM8ls_^Z8:2V*ljFH.YmOdr_<a7N_G3o|m3>74XL.r7G|pjsoN(+lUk.MfH..A*bkcr+_.>VPpibAqEe1wAMXJRrAf?*iIDG,yy(']Pb>nNO+BT<\G_6U": a& = a& + 160
    Mid$(A$, a&, 160) = "i^Zt|e+RUfV>mEe=m)=A;1'8syFCx[O]l,nO[EU;Nt<xv2)NKxl:S?tlhd{jS1VEC\Csk.n6f4/tuAGD|)kxzme=v[fnfn;j5puI^bn.}B'n_tjdVEETYUrIhZB)nU^3]]K(P4H'zAw?-Rc)Sn*(BqX7]_9Hgm+1": a& = a& + 160
    Mid$(A$, a&, 160) = "51pG|SQj-Qx5B2^1zIS/_nEa*X'4dH[LA0R=gy(A1me*:_LWfE\)DnLs3aOSv3cY:YcpF[Le0Iv1?DI'qb=nDNd<<5NoC4Yb?7+[WA+UaAsDmYw7kG5=mfU'{B\rAMW)62mOENAZ<k[b.S1G[-E1XV>aNf3hw6Sw": a& = a& + 160
    Mid$(A$, a&, 160) = "[<>P,)gV7|LFJY:oOQ,p9WiP{26wYP\=rmbSfwwQu:[Y07Y4_w;6;hHS1sXHRCNXNlS,9VobMR]9xceJyG)Ja>,)<?a?iLDAd/<F9oF'M(/T+EhVDa|q*X.VUBIgCb?s;<q5O00-*(7qWs4v:e+\dE[^|jM20im(": a& = a& + 160
    Mid$(A$, a&, 160) = "OT;znrKGy:J-YOArwy41X2:1**e\-lc5x5.:1zc1K3B*Y[H)0O*l)eGg^kJ5+mx1k.]h(Lz:h*{*JgGjY/^A2_o6ta6b^Vw>/KG3MCl7,Zi{7?Y3lEfXz-;qGRRRr+La;I]I8(6WKKsb|Ev)rwD>G3s'Rb6gYQQp": a& = a& + 160
    Mid$(A$, a&, 160) = "b2Uuu3g5Hg4C4tXVZy[f}*i:<G_aiGR-:5G^NcDvI>F9/R'mc55H(aX.?-mKOyRp+MRmj/TivV-uwZ<nmMW4eM6]{^j.Y9;N7b?Tgzv*|dN-rbIW4)Ty5AsJq0c'gl1h,=336=R6J5/yrmMjDsvk{Gb[>um;Vfpi": a& = a& + 160
    Mid$(A$, a&, 160) = "0mY+:E?d(kEvObwHCfVEH-FI[fcAl:I>amT^2Ehl/B2,6t4\:KUy3M2mnB26v2Q)wR.VjK5\c8uU,'Q\|SsQZo>^g2lO<=vaFL^|YOZNWU'}VGhq+WQ|-(HMb'G^Ept+wIfc>H6s3grN*Zss89nFZXRDnmY+9Z[v": a& = a& + 160
    Mid$(A$, a&, 160) = "n0ep44P}t'ix6r>LygVl=FS='9sPp};]HmTT)]0guQSSjMGJn2?.D]9PUyIkX_9Vy=81rxRf*DQwFc02ltYuO7hg(=b0w2ObIe:GCwES:=/<ss?^lsj|3eL4)6iias?kNEzE8F1fjVCf)ct;5-Ol{DVYxpV=3EhK": a& = a& + 160
    Mid$(A$, a&, 160) = "))tx]{d14NMGIS{FIOdyRMY:Eh>'_,};|UKgNEW.\[fIYlBZ+=zhsFB;5/jXSW({tMYyh+PPh'32mov:Ax0b1^o3lqt1;Ep[grc=8nzRNZ\L<fbw0p9VV+[djlRw^K\UoUE*Q'ykH1I){ySC_bYBRUGsC>R3,I4;": a& = a& + 160
    Mid$(A$, a&, 160) = "FyWzgI+*4x]X_7L4Pc9P=pp\*O)mlqo^F^egb\lE;LXKB*98'8]yiEf=wK/L[.[a[C_6/6Qn:-aceWs7;x1[Vo/:.Q^P=-{6H2.sSaR;w11*j=ph.J9}RTj?aM7N1s3rmX:nkM5+0Eox^j/s(0Bkk)UKRfRmY}hk": a& = a& + 160
    Mid$(A$, a&, 160) = "R0O^a3aw?DZrvLyv]m->mKq4yL=Ca5SJHH2f3A{P25:ucl6?t^:0eKid^>(p/LEnyQpt*B=gBA6Rf3>su6c{sK<2uvehU5tS\zq4P8'<V7S,dBFXtUSYgkY79TUcOTA/R0e>'^+Jc;b0)E1cte/wboszlW5=sP+?": a& = a& + 160
    Mid$(A$, a&, 160) = "nWZ<T('Tq/Am>}J-edR]jJ:xR*CB7>Z[0u,Qj<A4zD]ZUk<RR\U_p?3G7qP;'fOTW/ne3xcO8c=wmsRP41r:3|=|H<Ws'RfjcME0Q[<LXZLMcZ4]EosDC|^5{=cDn]S=yjLLsL])l.u?MI?=yJg3+ZJf[]qfVPi1": a& = a& + 160
    Mid$(A$, a&, 160) = "w7q4};Gj693_t7_}_4LIHUSQDKn{;k<TbH2cSh<mvG'U57*7LV[*GGK]._TwH0z'LMZSSgGIddt''WMF+D]U)Ba7Gb4^uX1.lyC}PFCQ3DTP0K0_H:D)*SM:X_FvXE)yz[R:6P>qG1VBIqvlidzBV3'(.3PfO-,s": a& = a& + 160
    Mid$(A$, a&, 160) = "Hw3JH+a^5L5ctvjb9JRMQTdZFI?^601-}.NL<l<kV36;^07Ylj^tdgo0CdiLg?o_Ovk+Eo_SfZ}rSM-*7s1N0UOk|S,fj6n,(3,6AhbdEdVQ9vE'iV[\mlibU-t),oK|p;rsI5]Qn:p=78zqgQc-+qRJ3oApX(lm": a& = a& + 160
    Mid$(A$, a&, 160) = "2.C141ZX7h1HvzwbSVM3AEuD1S1a>U7=(PgL.k,LxXPrA9:NXH:edpfqWcB^eNr/{>X>VC;D]L>V,a{Cj2n{+cyT1sc,tsV.or;jpR[cG:g0sZU4Yp}(QNF*A+WM:UHP)i.+I<=1Oozd14.}<B\RX2c-J?KOaR'A": a& = a& + 160
    Mid$(A$, a&, 160) = "z_gMKR3z+/\ib6A]fS4ncOakWq'b8C(]GEmtMwFQ<gAvk=i9[*:MLO'+x_Xws_ZyE;:d2*e;>7FoK:AQ|_yh2A<j/+u2|GIjV_gN)>Wt5j*>Ll,hwVk\NN?f_M;im1t-m;5]_|)J?wv/fyJp}n<W9q[fDgje*uFy": a& = a& + 160
    Mid$(A$, a&, 160) = "QM>:uJLH'C_U8D?7TclSe1k8Zf(h^/{CrNzwsSE^,P>Br:9iAE>QQW5DtFSUBO-r6K<JU8,2zj28J;Z1FvZ+7I:(k]eK*6,PCxxvGC+yE4sjZ3m4}PIrsyP3f/-]R?1c;c*k6v4+/U7y=gCHb*'.d3'.yr,'P;1+": a& = a& + 160
    Mid$(A$, a&, 160) = "p(ia|}00{7E4.PMrvczpH8?D[MuA9=q12z7O[Z?vQqFV-.8'n}m.:Lw,,AK5\/tY>[DZ8zt(djS-D1q\pmeh}0Zxu<on(.lX0\SyUgn'H2O]_R23qQ63fLo{5[_R1KYUFm-IbfkzoGav/\jWd],j)cuOI6[4nDw}": a& = a& + 160
    Mid$(A$, a&, 160) = "mUq[qp1z/W]a]22XE-{8?vt;[w0w)rk\dO*5g/Z<2'4Ev\y'X*Tmzeg>jbE=Gu;S/gsPRiY;O[rrRC.9QGWFwh1Vol^iICFg4_o[0T?U}LdI27RlypGTRrU4u5l|=B-ONGg1w7U+OkM,GeV2[-4NKMV.C}+Bna;,": a& = a& + 160
    Mid$(A$, a&, 160) = "Ud\^06sx\gSi\WC5>-,Xf:a65}LQ|c3-oX(NK*rv}2lf<?Y7mC|)tUpN1q7)0Sc6UMZm4mXS>Rj|6Hm)42-hO=)HW^3^FeN=(mnS*iXo-LaO[?iES>k[1,KA2uM)CLFdbD2b6'jFiNsq9CQ2'Sf>0r;Y0;D>iM2H": a& = a& + 160
    Mid$(A$, a&, 160) = "ESj(J>s')76OlE,.k_<}*9y4JFdqXWIn*:'ZMiEd+Pz(k{D-vV{V]5L:H-_')h6JYng^s0PI'OS4=E(kc0Q3tMXuCFK_tZs;IlBf+_FAZk1qW{PRIFpHt87HQVTN6U]P4UjP-{?]fr0OpCa0m=feSli4A(HB\ZdP": a& = a& + 160
    Mid$(A$, a&, 160) = "XJ.q5e9^Pt3WvV/6g_|=S(?_yiBJ01}swPxrBU1q5clsBkC[--.id9_GFdxECojoP_uvA+Rj,3Zy60eh}WM)WIZ*/_WX|Tf<oy5+au-_v/M8A\RFQPpe\6N5rS26LQlz\i3+-]5:e.8Ph9Uw^goB9_|58WU436s?": a& = a& + 160
    Mid$(A$, a&, 160) = "H70>v[Qi'CaWIx}7Chwei1R.,]W]Hy'v]W;2l|\-+xKnq,g_.r^?':Su[Z:\S<Z1)7P+g>+WKep-O+(rR)K{'^Y<pf2Q<ygXca*1t-IxSkPR|tU_iG<qC0uK>3V1U*qJQT>-VJirzIf=tKJGdE*6hfpI>7.+cEb_": a& = a& + 160
    Mid$(A$, a&, 160) = "Sb[5_WZ\]->UB*>:8U3\6D6+s_j6:3v'3B='^q5E\]K6oCMYAJB+yvUt-Ehi8;/1\c7Zfr<r(+Aj9xw]Z65_Mfo[XJniwu)OrAgoR=fDIgErAw<z'Hh/hn[ris|pl8>_B9xb15Y_q\M4hhuy*RWEGCwrU[XQX*e,": a& = a& + 160
    Mid$(A$, a&, 160) = "YHL:2[+6G]fZd*k0b0_xJ99mr96w7?'^)fe\:^ab<iuEsh5Mm1pa9AH5N2<?]h9A.aa855VUr9I1SnDJU8xxgJU8c]p'2:RPhEY.nuJaMc_FU3</zKsEgQQDxtq6GEMXC2_n){_o)fq)c*.D;NIO^/)f;t'[M6P'": a& = a& + 160
    Mid$(A$, a&, 160) = "8LWl3rEc3[Qb;XP_oLEbwrlo;o^L>|*bN]f>L,mYQERzXGU=-J=>g|dhN)fj:13\]TDsG=L+/?CwuiAdr)FB(J1(-(2iRbntkV;oxSo'2i=]L2y7)3E+.nKORO*HWN6I]IY;'mwdM30GD]Y.J5>{\|t;fCMpG^9C": a& = a& + 160
    Mid$(A$, a&, 160) = "?>eUceG=?(lZZWp7rkr1Pv-om-t\G?oPnF=DRmkTO]GoZDlEt\0z*v's8hcjYj96as9I,y:_Y[TL<-B>*AyOhVAM0hqwzrOfVveQLzg_I?;b4gziWEv}QA({cCJ.|a'Yc*\PWtR\fbh8baHNOkhUxof=d}\d2LN/": a& = a& + 160
    Mid$(A$, a&, 160) = "Oj];}XC|H4Vz/gZ4R6X0CIxpgEb<BK+TlUN)mpd2X<;DM]Fi.Sb<6_G^iqthL4;K<tdb\+'erwrxb\2ZmSAz+k-ghvm+wRfoEZ/5,2oOj[(Q{KB7p[E80IB(Grn0LVF(zkA7m(7ztrf<3hH{Zzv91ji(JjUTm5gM": a& = a& + 160
    Mid$(A$, a&, 160) = "?2KJz2s|G)CHk,0xRHdvEFR09E+y_,RiboOd)dKk7M^akA2?]c,k}tl1io2(\0BiM{jG'NE;m0<:T0dco<[o?11d4d+c;{>DZIjqLNIK4wpgM(6F9syR,h/gT:yJ\=4.Dbw(EXvwgnmVW[x.Q6OUHIG)o?}f<PHH": a& = a& + 160
    Mid$(A$, a&, 160) = "FQpfdTxlj\t6TDYm1u5dAczvJS8WkrgeBJy5?_I_.-?6r{IZCZ+dAN|U3AwA3og?nd/H|XhiiDwSol-yGsfjn)z[:Shy2JC,m3[KR1g/?e5q?PwieXSdl=re+dO[)tsC7>TVEAGVaB*MsAriq.t>jTs7C>GPQJpc": a& = a& + 160
    Mid$(A$, a&, 160) = "G;Y[re<U{Z/CHP0+cGcz<TC2+nY,(>N.unw5-M/mG?Q-.ZnuM.:W,:StXC>FHhw2M2n)s?tXx[fOV|'j30c<C8a?1Dk3u5ov9?Ur}uz3K4.A?Iyzr32Lb>{51ib5cf4T-8Cc'K10VvBlm0?)3}L/Gy'+0D5rY8Os": a& = a& + 160
    Mid$(A$, a&, 160) = "{za;]A1CO"
    o$ = Space$(10118): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N10$ = _Inflate$(btemp$, 11022): btemp$ = ""
End Function

Function N11$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(14131): a& = 1
    Mid$(A$, a&, 160) = "0OE[6{pk/eLpa<U{x3[dTb<?bF7y*)6u,BWLA{)hrBTQC}=9rnh2kT;'VOyzST1wur-2OPqg5,Y[W286fZzLLWk[T1/:6Uz2kbFmVzZR]bFZ-UUL)<o5,^]H??PF;nYp_[j5(_6da,icK+aVUc{7m?eGkis'G'8S": a& = a& + 160
    Mid$(A$, a&, 160) = "ry\>{C3:|mpngDv^R[)cu_x0cD=F'4kXW/]|DMM]ouTMkz7NeK:w0e]dS2?ZQtdYng5:BL7nzi3NbW>eA?E8i=A'c->F)wm9SsUllqWMU3.0iO3-antH'pJCXV?,hJMWBn)dBRlK0ScPf5v/B}+^bjasS\R-*o3w": a& = a& + 160
    Mid$(A$, a&, 160) = "?'r|+Fp5u\;PxJr\5yG./SJ(=AGg;yzM6/<CA45<E/(hA<XMATiar=v45,QOgnH9[m.Z,E7RG)AZam}h,VU}:==8QG=+h>n'NOVdGYjl]}X*XYE/ub9'Q\4vq9fY1J':q;n?=*sJ/C7F'DF0f]TPu>E8qG2_WyTG": a& = a& + 160
    Mid$(A$, a&, 160) = "qw[|-(,{?\L)+-3m4SB1-Wj4xT'3zU:Kdsq2*EfTP/>Xj^advu\ZtSSL9-pvw)4uk]sw6x5ecPBsoFNlfQhVPZPS(Cuz]]z.r4tT=xZNW+-,bf7YOIBzWn1OE_>xCqaseaV<)Qn\*Y\H\e}[0BaAB.0=LJ<lbk]z": a& = a& + 160
    Mid$(A$, a&, 160) = ">zN)Zv*/S.Vu/i8wLxTAC*z*/(*xB8u4rp4lFT3{o*.'6k2OTZxX5n,xp]{NOf?PD78u+D3Lh=D?KY*.ka+^cR)>O<Z,lKFt5CwxEKW6b,7I1wEJlQ?J8dRm0n8QJY>\'zv:vqzcs:l^rKhu|T[(Ha8-uMqPL/si": a& = a& + 160
    Mid$(A$, a&, 160) = "7Y^J{opQel7]>cxfy|hE:09dQ}J.49\E(IRqn=6c4fWPh>]7ORf/?PJ/znOhB{*Kq5T268Ccs.?(7ueR,wSGf+P4vSI6^rU2;Q+SS,.mmWTd6}2CzOB?v1-)WkHEx(,'l4y8MAxMW/?bCE(p1d21E,wztxr59lJw": a& = a& + 160
    Mid$(A$, a&, 160) = "N_aa<^Vecx9=DplUKofrk.eT{i)+4=M4C(Q;G,5'RPZwklsB\nelqiJI>,Yjgp^5zw)541{uMSq:M;8Y)lLkY=CoA.Jp,Y{8C*)AIZT4kxnQaK3{=9tY7=xt2T7[=]:wOpp\w0hplgup:F\9{_LsC5<H8zL4f8y[": a& = a& + 160
    Mid$(A$, a&, 160) = "gpAg5Iv9rjWFq\v\n;-J5kMfS)<yyi7k[HQ8y,6XdT{+MfX/4lKPQsjt)Vb1)bg4hM<(,mfQ-8<Ka_qU(vGU4u;rk45e?MN)i}lN9DPae<Hhx8<HH;*j?t\taolTmuf':0'-YJKJN]]0*IA099S>oP].6D^(Uaxs": a& = a& + 160
    Mid$(A$, a&, 160) = "CjyrHZyus7[,sa]<-[brZIg0q,d0qFby]r'3V}opEmutyClmtG+HLtd9ha2MuYMpXrXZXp5oBzC?Nx_N)0qqqPm[ZAHL\|oJO*J2aO}\b/gX*-]jSAg/\3,VP1vIsVd_pADZS3FdR+]ChS7*^Pkg0lA1Cb;HWaw+": a& = a& + 160
    Mid$(A$, a&, 160) = "YXKmd:/;1D^U;N8R0DDsBwG-iM*fNG].|Zu9Uw}'*)Rd;45vtzX1PpS'.X0sV2/wb5x+iZIGEyF{fN-\{dni)CG'fvY<wn]l<<Vl0-gb7bPl]=l(_lOM)b8^}KX;a:tl.UtOegxNQ6AWeJFFn\h9M]7K9ubv[y3E": a& = a& + 160
    Mid$(A$, a&, 160) = "8*o8s)mW^o_yx+P*EAo^7F9?fk[:0ZGM7g-bcx:]36i)oCp1onAY_GSh6pyN72clhI>]Frv+Z6O6AG;C:uW/XDV[d5wiIr_3M.dijyev>dtsp11.ZKZf1q'^]?8u*zcXTx8mn>FK,WyI]O.jv[tzdjeClmQP4m/'": a& = a& + 160
    Mid$(A$, a&, 160) = ":kPS4Hw;1-NE|6^oV0)HZdv>eLSo-qkGG7Errs7J3Q9*G/)t7F)Yje*181V6crtM}:Hs}F4YE0?fs^_>6/|=5y[3(Rl6-QTgsLpfv+-MMdos=XJLM28nj9]4\:q>ZPeR+ph<\z'{57F-AUgk?cO'b,Zg*]sf?]*w": a& = a& + 160
    Mid$(A$, a&, 160) = "\a2^\|X89G0SXG7/80mXz)Cu+APs6.b41Dc|s<F[k\;mlq3GE5o\^AM*+7rjmzsVUOLch+E.N+I}<r]zbwXYq?vP</X2T({=vVI:420K8']j1=;7qBt(W;jFNNVy:nr8ov|soG;NlJa:B..JyqH4;:H.7H;9pnu(": a& = a& + 160
    Mid$(A$, a&, 160) = "xlB|8A>6V|c;BG_(ln5{{]LoH/xHALT+6ljvVFjYi_Zf6]V,39g^q=4s63J.[[Y,cJH'YtX50i1rh9VFziI0P(DsP;xPAf1;[qp:m;+K4NHd)uhqs7:;2/SZxGp(hTVpi/WgXO59STL^.GlmFvdqd/q0,Lx{-c0t": a& = a& + 160
    Mid$(A$, a&, 160) = "ET:*OTX6Ie-wpjT4+(5q:lc:}Uea\HH=FIbVF1']?k]k3\1'i'NveUWQj2/nahpXY-oa/=f5_X0k<al;e2Li+I.1ivVQ5(2y=(F=JDKzpLRW)k|INyWI79Shl/oSX5+74P:qm;(QY6Q^u_PMwJ.m9;JVMg{1Uo0e": a& = a& + 160
    Mid$(A$, a&, 160) = "(OwY4SNm1m:VoZ1q;gF|[,s]4)SZ6P^i9]WxkT+]/mVT8}p>1DI_o/2(P*'ziZ:M0VGlc]t)j1Cn1DHY0LNJWb)]HsyZ.K^R.c0:j<[Wkk0=k>?Qa]BBs7Vj<nklGP<>(/]pPfHdwA3w\WnuKTZuj),r9e_-Wbo|": a& = a& + 160
    Mid$(A$, a&, 160) = "SBbxWq8''bTkxSjEOYJZK(6Zww_}tPtg<ed8zPN^_9L=d}iDbX+zPa+]583{\A)Hu^ZuzP{TRO<u6ush+?UKLlA?Ustxu[-TPL7<i_wYQ,SobGI.htlD0PU(cPm5]P1a.YU+Z5^lp7Jkb\\AP408OAFL:XuZG>LF": a& = a& + 160
    Mid$(A$, a&, 160) = "kl(VHJ:7xcL'Qocg8>sp0Gt]U]SMHwq^[\0pDLGLLor/pyhwjj/pVJ3^8h^>H\+mOBdvmxzulchDG6/4x1YzDC(NY1Y\-OqU\qT>bRnBx^_q0Rm6o^n|CxT=dLi81x5tt=)]7qJcFc}CFF{45UVwi<v27aTNpZCb": a& = a& + 160
    Mid$(A$, a&, 160) = "dGs\sZ/68'QLjkrG/mRY2fMm-u4,mqIKjFjj<XLvHrArki*0UhuXVyz;H9}nY0D(Fu[LA9XN,sS(BkXlpa19sr5bMGc+eD+w8R4u{5G,DuD<mdwmgo/XzmZ.n:Y8egJK}NyF05s:haKo|3uOF39*?Q)i8naonOBr": a& = a& + 160
    Mid$(A$, a&, 160) = "+Omb[e1,gYCjTOonOFsnDMZIw7s*C7WxKQ{Atcm[|:^;c|aPEt?k_XEEOqRum*S[(jNM8lH8]Y7Y/zENK=jA_6KA|+qZ.G7>MJ>KzD,\5Gs1B(Jw'v/'+8QAzwGiyDK7d'6nm/u89tL:tX]4-yR0v^M>[3qDqN;[": a& = a& + 160
    Mid$(A$, a&, 160) = "tnV15(z7v<sX}fB8AIuHxCwA;CI0eIIW<+DiIS-{/TCuCWhG8-DWFD:Cs8=(wP\]Tlq6yuifC7Aabc?m=xGBl{X*NY{yQNr+83233\P[NYX+RFX0tpHfUH0HFN}YGb8^z/2Z\f(Ui_X*?j[LVv)}h(9F<{Sg7gY^": a& = a& + 160
    Mid$(A$, a&, 160) = "mg+gtB1H(3pGKx>r+cfYkJS-oVkltKI:PwFEtH72oi[-L7y}}.;.EluDTJIq3>R0M8L<.NGfunc+s{rDt/>j{vxMYfBc?|o-pkb6s]wL1NDDK_)g6EI,2w]u_s0O\vmqr}a?xlHok}eosG7\axfAy>9(wDNLN)rJ": a& = a& + 160
    Mid$(A$, a&, 160) = "k-A6gQfO6.ekLx*Pa\]VXAI\Ix*)3^2Qw.Bb_XMqk[-DWV2fN|(3WmZA*Y:GtpO;|B5=lEuVJ?J*jB0Cv[X=lol>,^iCu{K9X^C';vtMMSc:=c>u55t2nIO4AqKXLs{:w]Brv|k{U\2bkX88Y;[O/n}.JpWvU{tO": a& = a& + 160
    Mid$(A$, a&, 160) = "E1;<eMXq*_U)}u5]Jwm^>-^xsvq6sGz)6>C2cof7}_=lpW-qc\jO4L8eYF,Q>1Qgs.P>jF:D=z[LiT:_Lbr_9f1j5R8<it;HdRDGrB{(8]5ms_No\Z6]gj/m7sxs^6+tPz[tmq(NFex0X7.|zp-tNOo-BL^jhXZ{": a& = a& + 160
    Mid$(A$, a&, 160) = "J9FlRF5>u(vfz5FA.v+9yudKXsyYj(s{,TwWxSpHEdLNF{7GSb^hl;^tD6U0W\PUMqq9=HrHVfHX-1:/u_{E,d?W\pmG6EVtm8Bv\N['R|rr.e'kdsEm8hucO9)v?Wgg}*6tEh/,,U=Fr:*4<^5v_<'wq^TzK]Zx": a& = a& + 160
    Mid$(A$, a&, 160) = ".,utB]smhz\cNb4Mk}T{aT<;Q+0Opo{v6f5H=GB]|-7\PZMYqWMeb/gY5'>klamNPp/UA{6f_Q}I2>m3lMOm=\SO{]YJA'\K)G^cj_H?+<zS.Qu?46iDdItrlB:*>qvH7-Cf<WwZi;W91ZUB.)J*([Tz+1h2yyY]": a& = a& + 160
    Mid$(A$, a&, 160) = ">\Q;;?'KpZl'YptP'(m|]Q91'4jVSyV9[e=59KGzsY)a{{*hWOwL2/g}Q'9cZH3Fl|LSutXPMf_Xy/?NcGg4S7[*IUHc}Raf=xkYwK]HiZQE?s['mE8AIGv4aN7?v*,JLkY0{cDMVZ^t*zbAlTCZXVMKyfI^BhXL": a& = a& + 160
    Mid$(A$, a&, 160) = "[vU{7P4q\r3=dulJqvQr2J[:wcWbA26F-4gU0|Tfw:)7Nh+xt^/04O2dI'I'LQuDKNq2wGKrrzx_lpD\k[^w]Z-7h5|hS=N1gN6gG,Lrd:BrTV|u[bFk8w(^cJBaybWpnL2NJWQcb+2a=10xVzvAhNdTSXS]uae3": a& = a& + 160
    Mid$(A$, a&, 160) = "rT^au}8g{Uui;(l:4SREQZp*ADU3kDn>yzP8vg)0Wi}+:Ac,_F=^y*IFa>cnh.=N7GLv)=2bm{(Vf*[iEbIwKm2/:8Lhe=eu_wFv0+FQ2rQ8A:wsuB^gqAOeiC'knW]/Tm9(r|W,lra_[hc*EtcOVPO(cNf8VGsu": a& = a& + 160
    Mid$(A$, a&, 160) = ".]v=G_[H1]-:{2cA3<;BDP_(0Jk7)K\IRTE.>wdN*'vXxe2UQEDl}YGB\8np<yeFsXFBg8Xy[oO|U5R(-M,?,lCI*[p=c+4V?aXnBHZS\L2a'{UwfRMFv9^h|xjA*K[.]^,P^\Vdz>KDYk8{^a?5L|hf;AwJnbt6": a& = a& + 160
    Mid$(A$, a&, 160) = "}ZEJ|u6/XF2SbI1ElX(R^Q[{u)-\;^B1NW}:[jQ<xD+VhbO9/j|Sft-*Bc_8EpT.1:U-vu:t**a/lZ\.c?vRXTNoF0P2rrK8fEI|WokvACd>Uk60V'*=UK>,x;]_5Y6y|eHk-chsJt/VZ^}6/XH]w,F0a83ZMqoD": a& = a& + 160
    Mid$(A$, a&, 160) = "24vUpOV=9xf^gNJ]=;YmF-|T],{;ngyjH<thcLvfU2bhE1oCWx?CjG*2NP=ZRG4'>_vyFEM0X7Vc?MWqZL\YJMg['f2Q6Jj6vK2XY[^w}nDGvSxB^V,?_2*>dEq-{BJ4])}5dm>l]RLQWzVytOn[NGZhD:3a7i{x": a& = a& + 160
    Mid$(A$, a&, 160) = "|(:7>5dQCC]A87qqduX*I6R0)GB1a:r8xo97btb//[bcx?sD6BdoKogPS*^H.=[rURze97'Z?Rel]Vb5GecQ*5TY7j55Q9Ww>Bf;X*CGMb-GyBb^ef]Sz8VJ2ht=Ul7=DB:Z]\L>ioN3*_WX0uIwt|abFQYJF'Fv": a& = a& + 160
    Mid$(A$, a&, 160) = "bTHwYBqvOf5uTt0JC^+naxPF6=PmpMDfb{A7,7R'C2iy3V7/+i?apK\3p(5a=s2t49+*sF_gS*sO8KFKzG0O+r[s{6iNTbrj,a<xVY1YY(EQKtrADQ0>U[r<jHq'7^no)FxvFmeQ8J;tYO=8I(6f.s{oH'.e[(/A": a& = a& + 160
    Mid$(A$, a&, 160) = "9\5hb7JpUWKeN5-B7{*+'Odz0n^f2.,o+Dt[(fMIzy7puYNM\N)OQQx;HY8{mZ)_3ozYTmauAxM>rwv(ceOx0Pzp/.|nqYZ0su)*;t^J>Y27)=]5u|4=;<t]CDEjjsjbu,OB1:wj6PfK{qqxOBhTe[t,([+a9as\": a& = a& + 160
    Mid$(A$, a&, 160) = ",FZ{heE(m8ZzOC+-D.LHW\;P*7i_Lougs)k=tR^LI9;|_:6BhY+'mhJ,?i}45'vWQSS9y(6pzBU1_B:qFrUR2cim<*jWek[TgRj0L(,+t=vsU5fmt'3NzaR*sD_qVl^PUI_QJa-c'Twf;vNd*)WUc8_w[i*YAt;q": a& = a& + 160
    Mid$(A$, a&, 160) = "+9pP(F?S2sn4rOS>Vo)?*C8_ejS<7TRfB/2IXQh|,Q-|\Gjz_NjxMfE[E,^KHwdu9hi]^\o>V].m^,XbKw/Tx60+jRu9yAtcD]bx?gQmkcozB.?*\mB6ECLE,/6F-A?Vb+}a\bfuo/v)K16cU,mz(avjc7v:k3P/": a& = a& + 160
    Mid$(A$, a&, 160) = "Ye2X*\dMYNkjk/|{t/(UFMXr}Ri:4[Y*?Urui88w;E-UC*JeqDG<YSNaW7Urh?}J.m]jI_Mo;'QYT;Mdc6Cr+.z_}^iaCNhYlAzPLIS[28ToZWu;C/|Zsq}rzUJHhkrF9j,EeEU=SPj\=hocmeq=k'B2Q;[wG<X/": a& = a& + 160
    Mid$(A$, a&, 160) = "<ORp|;kU]?z6+a<8MwEXJyi8PxrpCq^]sh{bW*Rf,LfD)1Rb;Xa)}fl2d'{s?Il}({16rAT5RqM'9M+4Laz+QT'7adK(PDTcb9:xtVd<CgM}Q{J?5|bQ]_H'A-l'FzK^HD'c\]|fO}m[-B4Q=;R+A[6=MO7K2S:j": a& = a& + 160
    Mid$(A$, a&, 160) = "nE=-;Yc5eK}z^k(Ig:Es.id<J-WAK2JR(i8aTGwx7uvT2[w|ul^>zssmx91ks^UuA.f_P|AI^hx'EXh}yr1h9u)]*Mne2|.Qb)b}A)>'rHOWN9PQQTg2pWDXv=[c;C?kasuqf6LD)]H4\f?'1}vJ|k:ZG+HW]{?v": a& = a& + 160
    Mid$(A$, a&, 160) = "N9Ru/7PY>vOhS^T*.9*+k_Ba);DMV'+Ctq|*AwjQk4DoK*<Xv>yEcuw_atmAgXXwGUGFxUpmD,+Q(PC)OnBafuZiL>jwsOg5_';cXWTG4)/N7rGJ_Pjq0*MTaqs6_RRf3ur0xag;(jx*aQ[P{7<MuEYml=6\+agq": a& = a& + 160
    Mid$(A$, a&, 160) = "H:Cv[EO]BNfHyz:v;^}Pwpv9ZLrT>OAo+|x8spUs:b4'216dgS5;>0K_E7<cTQ-2|^zN.0U1DOATPe3DU>v?7Zlrdl}N(Hcl:E*L,1YG)q0Gs(qDsuGHYsrGbZ;^b=X6(Y+LNbV=Z})LaKBEyX[18BE1/OdSoR3O": a& = a& + 160
    Mid$(A$, a&, 160) = "yj1zM?-4SRZ=o3x:7jqlD_OP2Zr>i4X>9A{mJi4(w\:/qVf<Ympi9D}}uGGY3]Lgq_EE?VRZY(>UgTM-j==;MI(GO+3D;U=4UMRA1b3W2yR7OK,'i4-wD]DB2CXjLPMOOj7J:2{:gyDz=Yf[dX7SkD<Tv+w5OpsH": a& = a& + 160
    Mid$(A$, a&, 160) = "s8Mhc0?Dyz5bS8G'7wiI-i>4yT/qf}4g<SO6b*BJ-;r/BbS1vOAP3_bPAiKkst6uT<Ktr=I:?fiY/4JJYOlgBzJae32:hD2u^4G}}F5C)lQ45VcV([8H>?Q)nLrCQbY{,wS1I.ICpYw*<_B|yGQA9b:TbGd[ERZA": a& = a& + 160
    Mid$(A$, a&, 160) = "Le4NwWvU2+YJrjGhY?sH+fo:UbLv[b8uagD-IO'}cw'0d:;QwZYiawISB(='V8X=1cRhRSZc0z]|k)GOeJhG9Bn8IMJ_juXvF,4GpeDmxZpMz06:wK]Vu596q\]Bfk^6mThMW8j8x^+GA(_YwA?*XjkbTCBMx8LF": a& = a& + 160
    Mid$(A$, a&, 160) = "^X(_i*3O/01>TY9h6h82sJ]b|kP\<Xc:u]F,PjCq92;x=CpleF{t+k/[/[v4';^K5MSv}F^s7ntYCo.,gz,v|FwML>-FX=S>Day-1uw0_niXW},t'4;c,gUI:dWPd/hun[aIDs^tkp/5Ckj+bMIPG)uDrq>4Nyfd": a& = a& + 160
    Mid$(A$, a&, 160) = "^JctpVtKf*3eD/VIZ3)\qQx2KZ)7Jl;m3gt\FRpiC];OK[z5:EC/rI.IH6HGtMUhbeXTtACgMH7'Olu8+2qVJL1I6[4hwR;Yi<dmL0_58fkyy^2z+BN>*]<TblES?Nakd-aqU:t>u8'd(P^V7xFY*^PsVvE8W;rz": a& = a& + 160
    Mid$(A$, a&, 160) = "4N(gg,[nKx+ya2sd,_G:2SX:+lV\>6[gyZ[sL6YS^h5xliBFzA;>BvY2,z6F.X/YCTH\8r>Wml9jVxi:(y=]|(\WlW+g6{g?lp2p53}c_/k7>>5]FjkPr\/0,Ds0[50O>Tk2z/>Q/M;hXPTN3J+xt.\++uAB:u'R": a& = a& + 160
    Mid$(A$, a&, 160) = "5wD7?-fk{bOBkj926|s)Jr{o<_-9x,|Nn4.j>^fcbj67A\*Q?w'Vplm_4x6c2q0*Z.Fyt55.)XI7+9-(yj97/'MqRFDX6ZrEC|I<GwuNe8keRnJH4N2Wy;]TpfLBcqx9UtqKFt0_VPl]TkdE^E*):(-Ac+?h\XSe": a& = a& + 160
    Mid$(A$, a&, 160) = "L^d?lvax}\Vj7BT?wMP4->-pT.qv*Z+'m|n,l^,q9_?E(OTyPXervo<oe^.'k,wD_/Rpz><Uzo.URRFIzxz*[RpuFj7smhGUI2*3Zp_3+sd-J:KwY28zKik5YOt-:N*ggVGi7:TONrXZc>s:+k/=(:iQ<.|[Bw8N": a& = a& + 160
    Mid$(A$, a&, 160) = "g-[C>4W/G;^AdaF*N;xUb(QmrANwV}sNILKuckOMWk2>Hep>GSnM>b?ybFJ>89MXtULkkDZ)=H46XCV[GcAW=b[sBOw]<453'uYr:wGH8]DIQgpTcb]oP}9bLWR8f(BJAU<k}Y|(dYFYk7Yu7{-t..5LbGP.zu,t": a& = a& + 160
    Mid$(A$, a&, 160) = "ipjU,v(+HcI[G\0lDEv?nwCBbw_BLE*2xR4onB2JJ988Y1O.N{u2]bnKfnS/?^?2j6*Ev6T842M_kAJMQ3V83=FFf7P.tGk*.M,M'=Ko8cgt-fnSn|Lcx.O):VPzGo49-qGl<,A|STbY/B3wu=Bq39g)G|WVWV]n": a& = a& + 160
    Mid$(A$, a&, 160) = "F7K=^-p944H<*ER+fFJ7LPFLp48uB5_i[+Tm1vNZf2<Jfd^??'g_IwsdBji2gFD'>\fCM6rCW3,<o04'I./EIEt6W}qfk2j0wi;TBFhzdWa]}.C,b]Lh[=h6D3Bw:'-a,Hr0uV}\uIc-khzh9aE]sQJDTILOp48Q": a& = a& + 160
    Mid$(A$, a&, 160) = "aNp0H2_<n'CC-R0b1]o5claQ^Epd(?FsI_TJxq0Tk;^K=l=6Y?\6c2\HcH\D5j2[FF2m:YyP-QKR^v*LS._^adpF5Wdv|_GCL6.uHsNu(z4tFKnuI?/zjun_y[WW{vnD7{HrruI;[PS]xr|-RHE5zGTKH'HWD5b,": a& = a& + 160
    Mid$(A$, a&, 160) = "7qir?+[_\(_b7ul(oUJIw.Tek3QU=x6?iXcz94Db,iAIxJqRn[L,a:QG+/X(2D_|G:SAlS^gIJ6dl7(1aCdcDQEF)y1,YxPv2,nv<Du+m_\lb.k'U(ZzGw4ydo1xh3u9A\t,i90)6Pr+-rGAhb'l)uTbXfN2[\-Y": a& = a& + 160
    Mid$(A$, a&, 160) = "=gOR|l1,;vRSx-LOHT9ErZIHWHbdQ-/JjMmr43}pgZbUt1fG9).khygtSpuNBLqx(:2tIju6vLQmG+)LtsyPxq\Ux[Ante2}r(b1V<U}H(uEX7A9{^HG05AM]Svg,<+)}rmxGm12Zu}'Y,}kWu;v^<Spk_wLnjDd": a& = a& + 160
    Mid$(A$, a&, 160) = ">N/6H*-tK+?+|9BRoGP},JXGWQ9*'6dIshgapn\EW)SF,1RM-?4y-m?U-0<K>yAilmNC'\[[RN;^7WDHE3\yc(gMc<UzAG63.\.q?;(p<UssVkZHF3K;lq\iKLjuq71u:XSgIPsN9xgY=MN_h,lykE(<32X,iA,3": a& = a& + 160
    Mid$(A$, a&, 160) = "4T?|kc[01vT2d+3'9IaOl{)xWXgyW']IIu5UrA6>x5q,l|OB[tI-cA}C_L}79V:53fYluKe<<.-7S5[hW<nk/wU'qPf_x*2L_S883JLv^O*cJZej4bI9eDtr[KRi:c:tM*1J+JOZO)Thx5yak=ej)f4/YNoSSOS[": a& = a& + 160
    Mid$(A$, a&, 160) = "CbwFNq>N>R_'L}nFR_N-hmB]])Qxv3?iRNMHNC'zr=b]}zw.TV=xY?z9z\99CCkz6:K)stnOQA]iqf.7rp/_3GCHE>De}_{jTldBk,HBOpDL|?oQry_WPc}KZf]\]G^sC=pwg,5qH](jxgT\tj?LQ572\]j*MW=o": a& = a& + 160
    Mid$(A$, a&, 160) = "pnzZL;[e.14Yu1OmagO^w,I6TyX*X(F<:O4,(guK6d/QBqNrW4Wsw(xCy*_h?V-HQa1<6yCbP{j|9S-HbTI(s*Q+XQKo9;tJsL?HCHlfrf/p]CK<;i+='/b.}OBYrxzJ\A=EKv\;6-Rkn_B1m}pLSMs</SXmtZB)": a& = a& + 160
    Mid$(A$, a&, 160) = "Hh.\l}wu//JkfXZeTBFpZ)?jHJX\DUb_OyX\gESc_Zwb7jBp5.F8rh4Q*<}tT4{={OxGM_?pmp<;lxVx-1hf2ZLeqCo\Hl35hSp.[/3EgSW4D\Z=rFc2J0<XayqcOurMPGUoOdB.MhG-4OId<tIYgcrTfs-YfEj?": a& = a& + 160
    Mid$(A$, a&, 160) = ":]>.72qw?}dWES/UrP,Q9qB.P\8pL3YtkN;nb_PfWAgcuUjZ/qmnC*)>^r)*hxO.B>TzB,:lCut^Y[vi{qHzQzmyp0bn2Hx'rDo]Mr.U){p;xqj;K}PL,3c].^R9e7h/D3[4|RI*>E3|EKeD}3LoldO/jhwk>_0X": a& = a& + 160
    Mid$(A$, a&, 160) = "X29toXN4SH[Q-4CgJ>hkeOnbEsGWEOTHC[:T*AJU+<^/,M5'EaEN/u>BEau|*4g09lWwR182?.o],1/{NI'fJ?\B;J4X74=cT0cG9cefm:rix((v[Z<T7+L13ULg9RgW7/B^.J1H>7Vm/d\2_KmvaaQ_uWU8O'sO": a& = a& + 160
    Mid$(A$, a&, 160) = ">Pg]b.PSfyQcsejYJ+u;lkMdAR+A3]efn};S:v1v\)>'w</T6Chyb6H,PC]hSvIa70bz:N5v||EpNMt^{65x;f<lr9(23Ukcp0A;3zWP8ufQj<FG>d/VI8ZvOHsM0ZH7v/)Ua[UQD{lOtKOmQgt>I_>UfI{2h](f": a& = a& + 160
    Mid$(A$, a&, 160) = "As3Geo6XlQyBp*><3'<<I?;r4+XS/YE]]h-4,}NeAPnyw*k2IhXTeL5Z8ewy_11sYB_4MIJ(B\^^dtZiR\yfrg:*pD40y26Md8^qqC5V{QW(jr=YY+Mc,tM}H?i:7<E0g-P[{Wujg.LA9wbFc>CTy_[SrHc/oRyv": a& = a& + 160
    Mid$(A$, a&, 160) = "l6W,)-q/K(KO6JsU(<(Jxo29f*a\3u4H9Sa/(_6|'bf<J=dxqM9KtgdLQ,ZrlF-Sq==c5-COvUS8p6QNcr'{bno.u/Yn^)lbi*>'1O}rZP.bTbxSQs>usYA*Mbe>[jkMP4s)U-n-]O573qIiTvjp,wJt:^K:UJv|": a& = a& + 160
    Mid$(A$, a&, 160) = "+:T)6)7[Kk.vOINpZdMomd/Y2/hbU*3CT8wa(LnEF74=sNUeA*E]]<p8cP[eyC0eqNu146xx+)>X8{Ia^Jkrwz(k1*250rHIF(|4,nW>]vG4bn6;V-4YDx]wP8f(Fq^l6s<Pq;/yahJVWJizQyeN:V;lAwx^iii8": a& = a& + 160
    Mid$(A$, a&, 160) = "/T6+2Oh:1_-10s[8CkbvTta_v})7(ph\uYE+GQy60kfS>xI'^A<Pq+LSY:'6B\Xa^dr:(N(]<>,IKwi2DZgDq<vw0;(d+_DS3K?Vx:xPWP8X[MZh8rsv]-+RBJmx|sIB7R2yWJw6u]7D{*vQ2PB|khR(d<yNWf=B": a& = a& + 160
    Mid$(A$, a&, 160) = "-mxCsb]a_*GaVL;Y)y*?P,xsv-2_GcdUQS<utBDO]]fP?'.Z)2(9Z'y5FoYO|eoJ2]gfvdlbrM/gu<3A\bCX/8caBqKei?Y.rQmNjiJvenY;nv_F,v*Ltk;u>^<L|Mx53|AFog]m3=_'eG\]b]caqLD{>H1O75g:": a& = a& + 160
    Mid$(A$, a&, 160) = "(q<}AI0z-(GWgD/J3]C=0X{'x(UhVfP*BM/v8v.:k*n=A;715^jdi{+D1)Pkasg|XwLeENer.AlSK.*Y]AX*JofpS9E0HO\4mB)nkk=cX?z'IA{Os]n3yo[U7=<iF=A(-XY;D.bDB+>THs?pYCRQ+DqC\cQYB6BJ": a& = a& + 160
    Mid$(A$, a&, 160) = "[j=;vCvze0Zi\:ctW:sjslvgkpy,>}SxhxAP=Bo)|XYKB\3e{{eTlf;<k7Q')o|<Q{k|gQ9,4d|\4GKB|yBAnMNXa[9jkAe4l[,bO*FL}>zwTXtN0<k^=+T+NCwJbisdUy')LN]riyLxr;nt6.9.U^T\H-9unMJE": a& = a& + 160
    Mid$(A$, a&, 160) = "D_t^w]ETftPpyR*yksvDkoGevaK\bMBIY}hZ*ZN^AeA?Kez]j=LSe6|0_N2lK)Xs2D65V,+j3e.\,(Vwv:ds8tex1:|L]E5ywmrW0p]Uv4;obQuriWX)>+}Ho?9VkIJE;oC/,\2f*sQgP4(LZL;qUFFNK?L)q}ax": a& = a& + 160
    Mid$(A$, a&, 160) = "[T.O0DtH|kC7dpq=:}grpVNF?PN9*hMckVjNv*)x4wpSrxPLE.y/ItY>ueF{|IW,duaA>|qOLXSdeD+7>iAGs0kRTE44gd4>QQbY-hC=RO6OYDb8;kCVS'M,|12QJ.1Ho''4xU-9Pw(tjHVl[rtY\bDBmuPjlx-[": a& = a& + 160
    Mid$(A$, a&, 160) = "D*(4{Z(,{gCZG:Snps+DR4O7w1GP-M_cpQ0-R^Ow:00CSS?4x9^pI1ILDhN?krX|Uwr4711ObJwK?.|JV(lWlst:FnFhizE+wYMS4sbpQUIS'yO<H9Qm5(}zf?Jl-Z\5+<y.R.Xjjb<p,_Op{3Hg-M\0/+XV)G+a": a& = a& + 160
    Mid$(A$, a&, 160) = "LEt4q,F{qKJ[c{V;gV8=2Kxm{7GGWR|UCOz>(w1H>-fxQd/.0_KK0+zLrZxHP72Dthd?H7eR(W7X/lW5HWuUA2)FBA95OSTNG*.BwiT8[ftbVMTP{j:k)Bo*Ym5MDI.9=V9rSh}/u'swjd9=AyvE/7o-FKN}dRW.": a& = a& + 160
    Mid$(A$, a&, 160) = "oesGfFZed'QPK):Zr*8g=1Tc6;J([wGGjxMkH__n;C\PB[yGu0qxGGF+RKZ8/i8N.pj-Jn74f0Rca}Q;=h95wM/{0|9K'emeh>UH>Tf2<2(zA]uXPw;1ZP>)uv].LE[W,7hW)bOhx/,BxuF5_(ufx7ALO}g]8<|y": a& = a& + 160
    Mid$(A$, a&, 160) = "A=_TS1nv3}2XDk)'l3Z>LLL1UOxiYU^iAaF3LC*inmM6SEn>c+)aTjsx5GSFWJYs/70+nhU7Y=]l'*1YufC,36f6-*tN[YI8rbi0Jp2*8lhRLsG3/4/6dUF/No+:DP2>11;k1yWSmgu=ms58>gqs}'B59Fu_:4Ne": a& = a& + 160
    Mid$(A$, a&, 160) = "=Y9vt/g2T_J-3jNjWAYB?L9C9>j4Nt4YNu;K:3\iP*ts^0UR0KY-9nLF5P<79De}jZJi<^0sQ+\HCgXh<BX3}8vFEN:g>b;f[p(8)Ttx0aZY-6AJXhTw<bMtwl2JLCPzk-_z^rGI{/r1j[pF,z-'a{]YbX?9]m1k": a& = a& + 160
    Mid$(A$, a&, 160) = "\DT4\vOpwAAc,vVf,)?bzNjV0gksF'lb:2Y]x3dvs-;+Ui_7YmrcW>M-x2[,k?6q}bU<4b4B6buHwRchv1C3b)IduKBhDY0jF6{YEHp?Z7+xR'.j1SLj^zkrw/=f2G70B=OdRnS2:d{<=]v}H<,-nF{:a-'(,nAf": a& = a& + 160
    Mid$(A$, a&, 160) = "I3>YRAU[Y7mFRBaZ1<:-o3=IS:fhs<n,[d18w]IHWE746i[y}4WHRQ*eDaMC.N0m1YN_*K}nll<C>NnhL6J_4}.zP<Ko{wbSpWi?3=Mp)'B7*Jw=4S'-6nVMaeH]zt16EB5Sb)Zxs>79.15T)OJ;Kh_6FuTjaJnF": a& = a& + 160
    Mid$(A$, a&, 160) = "OEFj<_]wxoO8'b=3VUZL-{/:Ul9p^77il>j.Qw)RbBWRw4Dw{MDSp=_V>Xo1'OM[[vx.SppjUMz)BK'kC[KxunIY6Ks\GA>I0QL|y;yWyzKVyP<JOuyp.bkQ;ti5Ns8K}TD2(?iw>NZ}nOAihzS43CewHZ?vVx?-": a& = a& + 160
    Mid$(A$, a&, 160) = "F;azk4zJIP{FXhv<[JB]9*d1-=yqxPB7S6-ydh=iW?{b85wZzTWI.ai0n+59vn8N\PM17z+da?|ypiMm.owPJ4AF+g.WlPG?b{3_GAe4/CQk>DTRX.aO]/1*wxun1BoAdpe8Bfu5N\R5/rbA^f4Lx/8DXXIiSb>q": a& = a& + 160
    Mid$(A$, a&, 160) = "Y/BKzU6Spwv/\xJKWsS2,7Df?s=^\3MVw1^v+>u:b4,Zt5brrU?T1hv/(->(6_B/BVk;KlDeL>xJMY9ymy((<MD}7qfDr1/Ik<PoUFw2BTiYV}M('my/GBI[z'|{nRPRpC}lXjIOqq6pUw?P56>.EK1wxV*2C7gh": a& = a& + 160
    Mid$(A$, a&, 160) = "UBP6e?1{-1}qwZsxf2T-sc{/XKwSbJh4,|ChU,GY)0R+{ZfG>5l3(7Ox98+1B<Ce_|3sUIw12HUbV]Ke;+iX+fq{+RH\F(QeT:HO:s1HhS8M'r1a;,gkJ>/ExbvMnu8?tzY;G?Y{5Y26<Mk[sC3/J}<UYXw=rZD7": a& = a& + 160
    Mid$(A$, a&, 160) = "v8EK=}v^=X-YkKr6H'n/ux.Vtbk)pBY8HpFI2//**D]*bEGU0Ts:)^0WL|SbQpkarf6wwb_EMX2.KBm(Xb4WC.aYI_X+dlT^p:jCxW]WZS{+Nr:)Vz6BznflTiG\)Uo=j7<MUBptmpTX2(lrLI:SX{dr.oK?vCgs": a& = a& + 160
    Mid$(A$, a&, 160) = "'bAf5zZg'IYYWwg]9\Ky6VvA-)ajANwAE3Bewx(t|G,}zfT1W,32z(vAoGlzn*bUc<a1aUQ>8cWg;^FN+YGQ]U>CcvBLdCV8Bgjm\23*2uY=vzTM[HLR<ASBM7Y6nexD;8xt7O\\:MBzFax:_W[1sLz.bOfQU^O'": a& = a& + 160
    Mid$(A$, a&, 160) = "D-V?k=kTpJO9]jX5*)Z8*HCAyyWHq]q7m;xYft[RLugI9|xg]746n-3zd{XLB7l{}4]GDQXhj*3F8Y;|Il\Roh\(8__,fvunDAZP;bzQLh=k=y?3}9*]NKO0\><zkD^(]Z1iM1NxL/BC^oLURAqHnxxWH/WrH0u*": a& = a& + 160
    Mid$(A$, a&, 160) = ":Y9Yu-sXK5fF|\-m<-V'KJ'/gK_EwnPCXG0Z/+n6WZ,M/I/RgyINY:LK>3-Ri2djgnatj;<Z]=U3CF:8_t<3sAfS?o|<RGxnbWZgJ^C'?];_UK^<3XIk,e3rt08,dt+EGdot0}NN=+FTt+O|OJB/IBSl]p^x4)<Y": a& = a& + 160
    Mid$(A$, a&, 160) = "PH4IweI);M+)D>N]?vaC<IXTb93FGKxURL?[l2^T3'CBIe,}O"
    o$ = Space$(11304): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N11$ = _Inflate$(btemp$, 12354): btemp$ = ""
End Function

Function N12$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(13026): a& = 1
    Mid$(A$, a&, 160) = "0OE[6{pqx;6ZxIq(K8kdH,JGK_4T4IGGIF7|S4Mtme72Oc>S<kSC69zE-1u_Gd-<T|1cn9{?zE1rWas(TlNMkkfe:F,p_oSHbm+(bM;O)Ro}oqNS;0<cz{n*[KmrdyhKcGs)RMkt67EKkQ5c5zoJuN<7U8P[z;-z": a& = a& + 160
    Mid$(A$, a&, 160) = "N;D;tmNs-x{h(D2RyMu9Pf:p;3R}dtIPVp59-j}kBsWiOgh<5=>nd(?l(as>F6GC]:4Uxv|K^uS'XP,[G\74e|L4v(}jRYp6xuG5qq*/hw1\V4l19OAd4tXb,(.9r{_\J2TTnR<cU.?Mi/_if=jiu5XNA*o^Hx<a": a& = a& + 160
    Mid$(A$, a&, 160) = "m+BwV)b>f1LoMR0akrE:7ED-+*Bo_l2lq^*g2\ovy:\^]vK,[snexbIvgYFOom|PcP7CHyDrFXh[X2RDe];f4I3^(a=dfa^MN6Y|3FiF[mb_)i[g>S-aZrb^\3HVWB/FWz6/B>-rv8+QT9,X2s=SJ?0rl\Nid>3?": a& = a& + 160
    Mid$(A$, a&, 160) = "]WILE>>K+g^FTjRL_N.9fFUA,RDhjVN:0i\+JkkwlgKbCA^OkgB26RZS;?cx=N2=>B/cXRZ4DpXje^InKBvn(,V+b\?Xd/??J/CB/0iTP)J'fS[yw:Mg/8Xg0nL+.8R:XYly6G'aDb3:ML7cEIz8K\R?aNR*i']:": a& = a& + 160
    Mid$(A$, a&, 160) = "Tw)>n}'TzHHcv:^tBh*>aXyKN(\['EG,XxvT]alI)[^/|mnlTByP..xywC5?syltW.vXnH.QNVO+t/nH<2N+OQIL]xyU.DZcz9H2xmi;]g,5sRGF-2J):sz^,SJNsnTt4(.t;wezMat:/0OiAaO{tm_bQBx-NC=o": a& = a& + 160
    Mid$(A$, a&, 160) = ",X^)=o62PWv0=;YQw<Z-gyDSC^Nv1]vG|8Q-Bq[b<R]r;Ifbmz/sLW;i24=Gv:zVFY96NSTatCMFlH_^}lD.mGmHfx26i}F;kO0HEbEoWywj')wcys}=y6TfaXds+-sm2{\)(+/B;W]dhZWZ>+Y>W;{u:<inZDVl": a& = a& + 160
    Mid$(A$, a&, 160) = "I?7aILEzQyY9ft|[Vgu/.t[^QimzLW<r9cfi*aZNwf/)+yQkm3TSs3:;as)Uf+4x<W[nM4d+hGqI3ttE,MX?q_gxi7\nF3eP[9)esl:]XW_<T4rjcas{g.tOAznsm;Hws(_Sm.7=/p6I<FmA1POjK;ca'e77sD:A": a& = a& + 160
    Mid$(A$, a&, 160) = "xA=lNt'8egv0l:I7XSn)nEyW*tEA|N{3aOdEz>bO;cyKk(M'SfAskaSTA_Z)p;V_tiL-;B/J|Jw?iSaQ'N<bp[yz[SVLc={dnmPicwD^*R>w>AXhONJnVNXDmu*klFYZ2?XUCwj>IhYX6HUR.yXJ7*87MxN6q}c-": a& = a& + 160
    Mid$(A$, a&, 160) = "(^py[EeU8F3spw5mDHJOfT2ZbbCL^v(5Xp,^hs+i*;\rUp;D<7Nnr4WO.y\\tXfe?KqROzX9xCd*)CASJDXa_5_tZ-?w?B;v-lMfZd'+nHucg6wKi{B]EgCD,I1M\nY;y[_tj?Q0L]R)=KRP7WxjOokRF9T5hx+x": a& = a& + 160
    Mid$(A$, a&, 160) = "LLaNkFvw]nLMvJC2b'5BnUj^K2P^J,50ILZSd(hF0PAXY?w2JAt,4Wcoteq_}Nv|i8NR1ew9hA<U_0wL02QE,fvgE)4<-^MO<igev7]2XHDiEzoxvvAk)ZL.xN1x;'\pAJ01rcLxk6xLetHbG=rWesNa6:Q<;FFS": a& = a& + 160
    Mid$(A$, a&, 160) = "rpdp5Kc^01XE'+TkT68JEKSXZkaE6a+jR,cHu4*4NT(\QnJU?<DlkTk32::TAEX2W())LD:7cL)fZY+)}NgB.Th_t|x<7mF{;j<FouEJ2iP6GyBwY27S,wEYeLnoRenfpGk>AQ-sghfyhjv+=yT5pv(WGf\e'JRp": a& = a& + 160
    Mid$(A$, a&, 160) = "(_^1<+UCkN9o;kov)R^.bBrP86([mb;lS9CvoBB^D'<-S5z1MgBanfVJ??KATkBNW7Z|z_?//e[6L?9x0pl'mF029YqMDO?N8h[64_K,F-<uoo|c:qnQnS{n[+)7{|rVeT/np?FPy{hp;LD_o]JT<l/2;fWpm*'Y": a& = a& + 160
    Mid$(A$, a&, 160) = ".1xA<[=:^Asr+C7grldGsYi{v_I'BsmHwLh\(I:91nEzhB=m<ISUbE[:1/\J[[kfXJEJO]V]ir_|WBop)tkC5j:Gf{WXJanbtGG?)KrQ73)0M7p0Rh{zO>p8{zX/7+xH,T22eM7Mh[HdfFuC,{;h33WHP{-VK^uf": a& = a& + 160
    Mid$(A$, a&, 160) = "HTdR'4VFlMkPZo(noG[6p7Lc)T+ZvgSUpM>^IhvZtMD5^/k.1VAtA\?K?((eWiNz7(/Q-/5SrAQb^:Os3dHzmdi5yJvKgAf4W\ln9<kWd2XTeQ4z/PK|V'=[3,rgy^YBh^i>F*>SR+9eTb0b\d02[>DJiP<YrUF*": a& = a& + 160
    Mid$(A$, a&, 160) = "E*'JQtX6?^<j}Fdb+banq/KgsK+;}]Hvo:SrWzKD1\}yWxF-XLbLwjI>vSV-\s68HBwjnjMy*8JFwWNnQrUr|_T+h)g;[LvGCm.bHIO|J-RW)ks^)EgybM+m>cNC\fyE4rHzf6zHx-i]ro(WVj6gLsuQA^O2TVct": a& = a& + 160
    Mid$(A$, a&, 160) = ")PL=N)9ZCXeVVc<:;gBN/7mJrsBA0<DLXYc/z?T^rE/BA>f*q1XCtosHP*,RuAD-O:V\'elxfQP(1D>Sj\?punpfufWM*d:46Hpkw0IDdz0=F'h[Modbva)A\)WMwE<{oVkdIU8Dw5NY=7QEJtL_]/=0n<7W>[S,": a& = a& + 160
    Mid$(A$, a&, 160) = "46Oz*6Hw?8y:gd=l0wxAOezbSSQk3MMUWpC,ISXZq,}M(\-/?u<IR{HE<q]1[pC,DNr\s2w7N8XJTzIlS=C'viJG;czT<:sx:M3qoq'yBs)ZQ8};9:)N<=<\fI+Y\z)}}bJHM)IynP=[VKj}Tw482,r9mm|V+4[-": a& = a& + 160
    Mid$(A$, a&, 160) = "qSn=onNLVYWjX(r;h65SQ;E[ct4,6=Rs2;,7ey)QYri/vy_.X]gu;XR0LKO>z+fX>tD7k>HfZctfNOxs]0gOb<[[LeV1Ie{}=VZM:,qFxLLDk6qiEn7Cpt'CRoWo=)j*h3[[f<72q*SFMs)f\3X}u)0=mML0+iuo": a& = a& + 160
    Mid$(A$, a&, 160) = "*4M658cp4N2X-/eQ+Z-P4417Dx__r|UY=(|Y9Q-ze17yb6Ko(cuTTpzX>DvP2)Bq3T(H'TqoSrWhYZbddbLGp-X?DNqZb1*1[K'/>HIOOAno(q]Q0(?y,tL)HuybSb0*.]0rB>rU6Q[x]=gpI'f,i;4wzkvfLy>y": a& = a& + 160
    Mid$(A$, a&, 160) = "xqAg3e9=kt.9-(ScqwD7M={f'YR+p._NE+P.Rgw{scjf8afA|S.8tp)Lx/*{:S*J1fOaBRKc2(5^?zkY^uO_IGPr9+qxDuAKM>C'90KqOJEA/3}d.jGfuBL-xt0>?'?W5v{;S.-ODWkt>{+xBp94q}2cNXXM-l=^": a& = a& + 160
    Mid$(A$, a&, 160) = ">ET3(qc}}FHk/._BbJ0eV;18UXx+=OyZvcv+i;azsKmm-ibVU,sr_\2}GAtdDO)|vf1J-<5QG9KDo*Q=cWJz:*XbBmmmptbPkxP|,vIZwYcpeyJyowKX(\1_wIC8KB+M8AW1IphJjCa:;[?f(i:^n4WsdNZ(dwKV": a& = a& + 160
    Mid$(A$, a&, 160) = "aHNX(^13ahsa4mjnjuKp\Law<(3g4)K/r^Ts[>Ef(==W)i+pdn/4=:6KUJazD4KXpFg,nVM]u91ORPc81X|Y89^Puw->^<EnvHC.kIiL.?kk|;B4zfsEhffloj6^08?KP/qfYO;ZA8K72KJ>6w;>Qu=L]q?*ihhB": a& = a& + 160
    Mid$(A$, a&, 160) = "<C:X;kK8)QLqPSS4i(PJDL;9WnI;U]9?8jkq(Nxq4)7mIT]-_SnqSU0h>Tteu>De(7MIUCFxdiB8g0<f\o;qntk1giK8j55N4nvUx5famwEG4|V^9tI-vCqvfSNS6vaqq]Rs{448L4iBNw)krFe*R5mWi>|tn](l": a& = a& + 160
    Mid$(A$, a&, 160) = ")-NR)Z10nwvPFw0*Bmp5ZLxC>b8/(.PrhuSfEsaokp\:QNC\rFG]+4):0a*AnJ.|-BBM;paW}3}Rz7=fvxD]PFT*DV,Z/QL\S|:PQUqb_?HasB^i8/X4J|x/e2}vUBD-A:p5btb[F]XcR8re<4eB-U)PytJj(j{.": a& = a& + 160
    Mid$(A$, a&, 160) = "yL.UM15l=YVQI.UiJSbjxLNaZ1v7r5ghtkz,U)e>cO,7|g'Jzq3:yYgQb/1k|ul>yM'0.Wpcnp}0^PAb.C+}<Ie|Ft6{(|R10TBtYe(WAZn(_*_xWdIJBrU2-yHhodi'-dD5XFylu}H0-z[E;v*s_]K7{tf|F*9i": a& = a& + 160
    Mid$(A$, a&, 160) = "qGB/mYSvsY'(-,6o66=T]tNK]Wr;b<_xvY/A1kzM38.18X4P_GoD_xrGo\LZ*PM*_,BD4Nmmi\;0L19x:E/bzB8zt?5\v/2EJqHT3)3+TrRmq0^Vxm2\f]On0'e.bw[,BRZ:HVa2x;pMH2EfQ3J/?aj^/R2=6pkX": a& = a& + 160
    Mid$(A$, a&, 160) = "cJF+3(W:8KOe/UdxhZdFLvn(oaWhNSg_oY1P,gG/2NEMJVsf'6GedJOdp)rY1bE+lBR-4]]3ia/:4bLF>4}3VV[[DdMs,XL]:DvwnFG?fN((NQT;f=zDG/P_hAQG27IpDfsN<<St)zYlq=zZE2'w]wfEx\=tJ_Bf": a& = a& + 160
    Mid$(A$, a&, 160) = "F6C/jV:wXi)vMoW3QTL/vNcS{m0,?cxKo4aq54aagK\R7Z0ztyB8pSxqmv17ZnU>yIwv7xqR2-8w(b4NDsEJ'{Lyzr,+Qdk'tHYmrGC8rWac6j)uN,9i>TVwcpIIVvi>N[|4tmU/z^65e.(Q{T'o:S:f3Q{r:jy<": a& = a& + 160
    Mid$(A$, a&, 160) = "4c]EsiLA{nS>r*){QztK;Pq=2)KqN7\z{h9RW^vgLO6A^)AF}w*m+wZ^AF-uIc^{[lu'<AiM2i:LhnexO]pS-b][08n)3t?g-o?R2'>g1x/U{<y)ABdO^[q5e2zO1bm:B6diz?/WIOxmay^Zg|SDyom'}f4u(fEE": a& = a& + 160
    Mid$(A$, a&, 160) = "g'|lEz)H|v?[e,yrBQ7}Zk}Rjlye?{5OlQr6*C)}av4WW_,4*_QRDPT^e(nFA35f0HtNho1yJl^\m?QQ>m,n<Z/H|+=LwIrrl:UcEK;,RFpb+OUd^CxNXE7C|NYFm?-76lGWt/,r8i?m[xVF?KWDEY>JO3pxKw7}": a& = a& + 160
    Mid$(A$, a&, 160) = "xVtl9fg6)c7o\n9}Ww*g=m:]^}E}Z/jS)3}+RyEwlmzqKY_W\cP9}yH_aMIMZUVkS88vO]/=]oy8PhwQ0ABSUeY-Hd2-BS,AWHukyvx[7XF6GWb9,Go|hx\_?CHUnOxjSb]NZ|/L1R8x*d*[8fQW:lT(>/kfiW<H": a& = a& + 160
    Mid$(A$, a&, 160) = "YaO'drfM4r-TwjH\-^)2?9P/H3gPo*w3C{B|R*\MjmFX_W8a6fuQnjGqG=iCWa03bU[xnPy1a)C_Jiy\UzE=8+qlsn{5VJdR]rdAo1ZbU9^=*1\Tv9Xt*m0(:p.B3O<w9<)pA.3ZMk9M:?r?x,'p/'G7D;,4/L?;": a& = a& + 160
    Mid$(A$, a&, 160) = "<LnAg86VnSlYqOFqdBX3jba7KIM]5zV6)ndSo)TT7'0Jub8bIy,IP=|+p-tL?K,>\,EhXD9YM};DfyrIkJfzn+wEW<i?MN('Q+zOr4[urWy=8H(g{I,Yz5k9Lmxd9;-q45/cj3h)BYTNGGN(*8tBPIku_xbUfVHd": a& = a& + 160
    Mid$(A$, a&, 160) = "?=7CVwHDN-m2pj7_DOFx:vVooPHmvR9({zrcN;hrqI=/ne95(5{?lzO'iubRp4czpOF5j.}ZQjpH1;'cUs?vb=/2Ux6FvAA}_4ppSpJOs*NmX9]pm72S:bktEuQ]AJgaCZJ(gMKgUPir(gu]os{(X,EiJ{864yOe": a& = a& + 160
    Mid$(A$, a&, 160) = ",Dg4_-=U]NgV])_y9q[yKC8k8q>4;d_'CU*\>*9P(akDuYf2o[r0{Ei^0qV(DD=0YYv+tmp)6so*x.52aeQ5BQteyJJ9S3yQIOc\KI;g[*+3.+v]ZlW|EG],PsZyXT;tzpaE1m\{S:8ebBS*hiey_s}\\p<Kn<+N": a& = a& + 160
    Mid$(A$, a&, 160) = "}(W2{8,9um7Vpt</8PItOO-B<^cq7NphyAohqx;DfrWe}_']M*3+gt0u;N?m;AfIeUhwZERU:0X01MT43e,X(.R-C3pKp{BNZE4ikxkdAZv\NQKVb2GfFKwH378A:DSG0sVM\UmwjY\oWY**\WthAFU{.sMKH-NA": a& = a& + 160
    Mid$(A$, a&, 160) = "[Vycme2Y2R[-u3H}g1ONGMcHN/]n'ue2:d1gn=hWWbAVh[nBWtn_SYXE5CcTn.,\nlA[n?bXgt_Mo^\Nm;MW)zLf>={CWkg<R,^GCHe6OfXzh3JJSz<J2k(KOhLl6ii\UAATiUb=j7{,rd,/L|9_w]:r?a.6l)Sg": a& = a& + 160
    Mid$(A$, a&, 160) = ")u='G_vw\,sfEr}dqR]{KSrGwHotKD3eM=.0<tZV,8SuPN(xQkdXKHIw_XNRE[JITMB.;5c)49AUxMC8><8N|[EImte:IHf2,uTs5:BY9Njx0*/RsR8C?F-TGAOZ-ntCx](qnZu5gpiRC03I+y7pOHXyzc/y2[GV": a& = a& + 160
    Mid$(A$, a&, 160) = "\?2KG;.o6'fdxaDZiJ4:|8U9e2G0l>b5aMoPk'JaeOny[6Rc][:)?.cy7cm}w9=}3um:bM_[L]V=K\?kw\sec]\Vz}-qjZWP3H'htx;i4Sqesm0HKUEX<ffiiEvGpod4Ny}FjO4os,dBcSb8zGG__oF=6<r\3Lty": a& = a& + 160
    Mid$(A$, a&, 160) = "<=E1[3,^70?8^o<*/i['ry.8dXUYvY4JpQ_yEo86:]{Ab3)L'e<xj};P<]['S.*vrmNsjbCwTol>+<-(A0Y_5+'Rr:RXw;hvqCIv9r5<Fa8\T2}DE6L(fEXvgulWq-Yx/saQ-]^ZIB;>K?JS4EK4|JZHLI<;V8SO": a& = a& + 160
    Mid$(A$, a&, 160) = ":x-<X{63r1oCA|6[P2hf1y8if{zkn-Jx(6At,^)Y-d=*m.yGgKXQFcs1TAZ8R(2\m^n6W}tOW;fPkTAW)+idudCc(y>LQm?w]Y|,\j\VZ[>VgUYZ[\bwMDq1_3x=1dmcbrni>z))^V5x-04hGAuFl?KDLJ|)G?d8": a& = a& + 160
    Mid$(A$, a&, 160) = "cv0z-Oes|=Lj])9otrlJ9U27+G)C_,|Pd-i,a-4Rw3A^oTBG(;w(9[X-;gM)^<MJkO3w{]P'o?hIo9oc5tj_|Es/]_igTCqokDUWmmmnQ/la=C,jc+/ByaY98k+N-IE/]^3oa,+11N8jb6}[y-req?e:FhJ0,R,'": a& = a& + 160
    Mid$(A$, a&, 160) = ".yZaZJWt]8wv(}]dU(u]eM0ckivJ43Xs--dn6n>\H1,8._I,;wp]+5Kk0j,jza^WdqpIPWeZPHc^00gxC2KD7}(rK9l2p>=o2g^{6bfjG1,?Y?eok8Kn-H]neaG2|ZT^VIsEVg)_wuyw4Oos'N6V{tmhmi4NIx*;": a& = a& + 160
    Mid$(A$, a&, 160) = "G+)VH4Va\;?sKJ+egDh'xnhf2in*e3B+B88zs1'c(Xxj):8EX/vsP=mUw_Tzj2elvn(Lg[j8MSOlF(\osm[YQX*z^Aad<{_q95X>o/5Uf\1O3MPgpyhU0rm6]1>rxjF=FZ8f<c.L\ku3/[;]'HH}CN{b?FUnEq._": a& = a& + 160
    Mid$(A$, a&, 160) = "QjD=7YFkR?X(sM:VTM;/At//Tug*si+U+H+3'^|K3X>eU}zcJUuU[,u5(l*FIb,dz:dUC6ZbeBYfpHlkGgSAlkj=[M,8MV8xnL0|m9f+qLk5,+]ajIJ(T5Nu7760CItqxil.)_nPE<ipC^N'H,9^Gb\QK-Q?i_*q": a& = a& + 160
    Mid$(A$, a&, 160) = "7W2s=;R|d2WD^7Hf*XzJrYLnkZTB}ge9N5gPcd9sVSHN0N.R9Cb)?nc<d],'fUD]eq[]9R7m}C\bhe)wJFjHJ)slZ*(O3V<[^e01j3Fnx:zGNwdPy0+_u;p]SPSd64ya4ZiP>aNU(JLFbVJc_([t^BP)C_>ycUx4": a& = a& + 160
    Mid$(A$, a&, 160) = "2wy0zq2bwo-eZL)m5,7)r=Wjl-pMClvO(JPKA=EwvsdIt=*F(hXv1]TBxW/i9z3nA1eh<g766[o,tnt>^I02sb^CO>B-50}:Mp'+}=J8F^9yD]=D8:f'O;okb:qf.0fkj.QOIm7puIss;vBR1M_vxk|-D\}ZwAEw": a& = a& + 160
    Mid$(A$, a&, 160) = "{SlchUkT+J\B(FK|>LC8q]Y]<b7ocQbW8tNE<l.^z38yJ{f6o-Buz*__GYf0Eso9AB0rO7]<OQEU.alFA^Tk,}Q-bnb_Bm+|G4Vu]H7nZ*ApF08g<|YYTrt78u+v}|/nR}U=}.znzYmS\uWcqooqTw/P7ZD/?=32": a& = a& + 160
    Mid$(A$, a&, 160) = "TA^PL=*Eee<jH=.n+i5(]w{c08?vnTs2i9p>\IA/)+V):;'YGw(,99M)pOs)>kaguCeF88.GiCzIgx2bnWGxqnG6/11>t?,Eh*I}+6t]')X/VYB^rdP_Xuv2^F{0G:'Igf-..f{)96l0[hmYKBOvrpjYk*1^t}l2": a& = a& + 160
    Mid$(A$, a&, 160) = "Ml-p/H^flxorqVfxe9_Ne58huC(ANZneRl-WdW>Ynb4m30fu.FT55,+eJgH^c.kwXOBO'[.1d__{gss.]+rk.<?nWqHp1Uh{[^|H'tDx.MN>89<he7IUk48c6]x1^XXC]+va]GNTGGqkTR;l;7\-7|u/05J'cHn/": a& = a& + 160
    Mid$(A$, a&, 160) = "lS4GD8yHW\}QQ2[wab+AX_UvCSN,pZJL332FrY*8xHLBj<n+5XiYs'UR5.X\aakrHbj5K))mb'tR./H9bs0I*h?[0Sx.QPS{t6--.tRc^}Y0i8:j1D/Pm,x9N9Uf(Z:HxI9qMJx4/iiCierNKt8K{ln1ugE)snow": a& = a& + 160
    Mid$(A$, a&, 160) = "*wYE=[Q{-KRjWo>n\P]Gn>P]ux9h-g:L'.mkTKXGYv+u>Y?jJHGkg-G\Z1t00FG7VU8>_azxZ83sl;Yo6HB7juCEcVFobM6Y8bl8iUn87z:yE|9q]K5{>J+|^6}V[Io-[7(h[;ouX4IJQjL(pN8X|jF/SCHSt?r5": a& = a& + 160
    Mid$(A$, a&, 160) = "(x]s)ucCxaXw*W5NYY2C|iiwIKpXy<yHQ1J*DH<uT5SQTza_xB,8WyIZMH:=*.xAD(Aiu,Inwe>CD3j^gXw:B<[*^}\k/_e=MfptONOunV/k5fpq499-<YxU(rkbnzhVZ5SzM,=,)O3WwJ0K1eBBQbEhCG/Ws>3O": a& = a& + 160
    Mid$(A$, a&, 160) = "'O>nA^oio.PCXnqxorZi+UTm8MJaD/X7MH5>tGEp>wrr\8c+TPjuZq7+O0uJJr{8M<GoHbo)P2Jo8KwBa.pY=l^cQ76-Hsf;*TFU5FUu*7UviRMIe)30rg05Tw16-zgIXwa42JM-rLpha1w0|sa>IaY1-|t8/OY;": a& = a& + 160
    Mid$(A$, a&, 160) = "2'2eCWNX\r4.t4Nmivbb9pV,\\o\q6MtA|}WZXg<Ts(]t9b:A=C[5)?D+gSrom;D\+da^6WL_2B]G)(I<v<})tjNP6<?E'zUjX2x-fK_{AUiG_o:73+nz)wKjePtM,Onvqbx{+7h?4o*4IBI(O+ztwFylQV)3CLX": a& = a& + 160
    Mid$(A$, a&, 160) = "ll{6Vyece;e.)S>;Km.*Tfk5XwC/ujmfsXw.W[jw*pAeIGw2pl,i/k.uzRXU24{nK7OBqaU+4F9tym?[m<dHRcgn1/h:4rdrPgy,jko?[*tD2Zr))Ki)7W^nRKwPLeDE:<DJTdCA(^^<DsVa/A8WqC/S9T4?5rtc": a& = a& + 160
    Mid$(A$, a&, 160) = "dpU+hc:VD\[Jd+PLlah3Cp_?h/[nUpL1Pdwpg^-cASL'6+Nk9SmozW+b[;CFPr{G<Zn_7_hN.X^8cijD5wC2oFar/U^rICYFYwI(OU)2;]aUXDF>3\L\_.451)dQ.EQWo0L'KPNq.Q+zKRje<}{-wR3UuP(p=N{5": a& = a& + 160
    Mid$(A$, a&, 160) = "|b6yIw3)EYNoUF*I?7g}DPpa1+9w8=NBE-vXj\wmzu'+QMW4E7rl)0NbRa4ikZdiKK;_2QjvN6LLh+(9lWVL]CUeFVqlIjUYx_Fnc\ZtxZ;_XhOzx}ZZy_(7cc(Y2|3R6\Q<[_>g;GP,/4oOl^ag7L--P?UkL1(0": a& = a& + 160
    Mid$(A$, a&, 160) = "XgQ9F1YN):EQ+\a|EPgC}EQ|nTFSxdX/M/Z[5e^iyTooEMR4o5l)7je|IF=_)A-*a\[\ZO-(;)]V(.TdDC7t_Rmm6Otxp|);5-PpOzT;D7J\ztyY38ymGO(5<Dz4}D.xoCcnMQ}b4L]S7y)GRhQ)H,elQMX*gS/a": a& = a& + 160
    Mid$(A$, a&, 160) = "\lBA9X[]_8Z^GprasPi|4DYP-G.+g1axEnOGoL7.Itnlwgok\VDGtJ(*Th5^xhQ*S\fJKq{MX5TBIu^-wQa>Ku)Qg6+46cSdIqvERM0]0fn6g9{<pmdfz0[Qm^[>JBAA.xF6s>so>vB4Qf^<)'59mWO6Q\=]qB;_": a& = a& + 160
    Mid$(A$, a&, 160) = "O*ySQN6T30eqc=(>6Nc:B4ZAV*0|Vj*v9<K<M;f't4q_Kew:mg<;EM,[U^zUn2|-nz^Z\?]UkwPT[^<8n5]GV2d6Y^SZNW^K<oH-0?3ps2K8hFf+mPS>ptsXAi)}V36WzgZj;HpTXZozACV46/Xean5rRZ.M,ox<": a& = a& + 160
    Mid$(A$, a&, 160) = "oGvXg<*Nlx9?SFW]XIl4>>=wdwKa/Td34A1KpZw*2Tg8[>jSV'E6.|a3K?6-RBGChZL3/6AwypEuqOU-2pZ=iH5YZg9)+xkhX+CJLFVr*e<BVCAfXwDbO_|e[Vv+C24Xv5r,Z=yI^I[]y5G_iF\JvgLV6|cNFio}": a& = a& + 160
    Mid$(A$, a&, 160) = "uhrd+sF^S_=qO2yyfpi.Ti}yn:M4k,>Orbc?g;EFE<gK8?B*fL}xL:JmboU+i0Bj,)ATnI2.|P67hrpTZC:G-XL\qwBE.-.,q<hKSJC*_c<(A=y(;;;xo''K)^IKLybe'fi;6X,WkYROYtl|\)=Fq[N-YPn,jh+s": a& = a& + 160
    Mid$(A$, a&, 160) = "3dr_2YdUQ1qNd'JFVqCTT<=Q=;)+74VOP1VX_).Td1Sxq.d-gn2vj[80Ds9MyeWN/kilZKk?YXhF9aSo?rl}DXx_5mhnaE4gYMyC,9Mfjt(GEd\K]3ia7maxbu{c80h]k7]S012i4;/5[W7WP<.6ddK;5K'ng)ZC": a& = a& + 160
    Mid$(A$, a&, 160) = "/?abSf2GG_O3R=V,b)2ZDiB)')6nKCl5C]].ASfwUjG;Hx-xv^QpHAn]Io[)9d/,oeILG8|xX)V'WwqdHhuLvyaDzjXM;KMdlYFKxW_Xsy_e)CNi}>raEPrDzW(+X2C^({irv1Z67E]9>)QK+0SpKK2OPPalKd*F": a& = a& + 160
    Mid$(A$, a&, 160) = "OZ.r<diFKXb2>PKep0Lg?<F8qDw\tl4.Or}f47}IoJxu};>[wrbNiz/g7o7A8McpTKQOlH+K=bAsRil-67-<34<)P-;sB;2t,;T:WaZ2wOn|P2:=0^+(Y|ol}BK>q>tElfZo.1UW(=5A*pB6j,?buDy9VlX7z/4u": a& = a& + 160
    Mid$(A$, a&, 160) = "z*w0riA{<2*2f[lXSys/?tL)|cz<vbLa1.W8=8hY;-3/Ah^ev{gYU'vK^c-'|uP6:[6c7QG_='sl\h?sMx;Wn;v6mds;qUHJ*l5gtJs\H_sPdQ(w?k,yoG:QSVoS1[q[y-y2b.HWuQmwb4y-:z?.QENiDR]|7,Qr": a& = a& + 160
    Mid$(A$, a&, 160) = "}<eDc0Ji2/gaDOx4^P(-.u;D7omwaRz6Cf+]si4ILw'bI-Tn)v6'O.S}ugd.23cA.f3+Vgcc+Wm]3.xQ/k(<1If:UQVm-X7viL\tI>DQFKVS\Z9<WjMJ-*H2hUF)dKVONl:CzL8Juo77N7.T7A4Bw:/Igp8;LJ6p": a& = a& + 160
    Mid$(A$, a&, 160) = "<(NaLZ<0ySTez\_*/+VXoV3Y_9xYT<->bV)PzPUFVxJ>vQ+a.7zW'|]pj(IA}OR*)CmLO]2Y}oIWXmmAkm9(VZZWOZ<21(,:zrj/]IMI7O1Z82+vL925-tdtxfvL:g-OJ6ZF^;0EYkt?ZprphX;h8x6n7DHarjIE": a& = a& + 160
    Mid$(A$, a&, 160) = "3Rk0A^r3KoPWvQS4dF>j-wU)CO^54r3J+]VT2K[0Z2m:c?[3y*(cVC5'jC}';[1F4hv9j1FL=\an)<TNtmt_Q<[Vn2bdM1'C=QpW[bqZRQqQkT>YcaZ25/*Yws5TK/hrDUxnF[|BF]I\:1<Z/JLSQMG3QuLuy-V2": a& = a& + 160
    Mid$(A$, a&, 160) = "9<GHY4BW3_.XnQWUxaX2{3r]so{),=qqQro9seO;z_1\3)jl4)mv-j_iPwL+jsSQ3u9I>g[F3],mrevVLuIUxWlx_k_2ga5f]r+NDAv/zW8{*<>-cxVE8\ba(;<i\CF:Sii,j9xUsScg(^.LRY_:e{WX;,VD1M\i": a& = a& + 160
    Mid$(A$, a&, 160) = "Lkr]DYe5[Wm]v/zc<?C=wNEx5ks7Cx.hJvI{d/=ibx(Nswlxu7<u(WQof-u4i^E,esSRRM21sJ+.uSk3|\n>16.Wg8RlDXj)7gdaxEIT/dD9>V1KOfmqv;\L[qR7Qc>tX:Yid:oQfXpg(gMONouh1=mj<UT8rS/L": a& = a& + 160
    Mid$(A$, a&, 160) = "hbM[J+4XLo(N/T,_Bs9BV*vp|i)ch-.3^'blia..WNTxBdtPI^og>t4.59a(^uFo,>dfn<:THnL?qkvr6OQ.4B)?.NTxE\1SvFYVf4LW<z'Dct,v-]AZOVkW-eJmD(dG2xXIgrFbuD+(,N<w/jp(tdU<RLFOy{0;": a& = a& + 160
    Mid$(A$, a&, 160) = "((Ww?CiG<0yt08Ih65HJ8X9x<N>>OK2am)?_1>_K;=?eGD-mkRaUm}IbMnJN|/[|>C2,fHMA00nd*MpTIU'M-QezsjDlN[:u:N}WGafNJPRsUS)sn/U(p1+*T3'Z>pe{=SK^.Bk6r.ioXFwasq[0<UsGVq}';fw>": a& = a& + 160
    Mid$(A$, a&, 160) = "InF,U;1aS4ig8?h.:3zsoxK8qaDgn/sDF>OVJBf5tW7}kXG(ETn'cTW<eJ+4'D:a7dKeqEA(xN3UW;L1A^Y,*i6dh]lH532:-\jSpQQZlaD;g\5c3+]B.qD0FlJnOHQJpni2Hmb3r{Lo4L[3bS0/:IhnaXu,RGhx": a& = a& + 160
    Mid$(A$, a&, 160) = "iW28b*OtHnYjMPNDA/U?Dem{nF:=(QB>5DleK'?>+7oNT6:cZeQml2T=Csu(3yd<*AkF)>yCP^)1528}s6j84:Gs.\UXOJj:K6wPY/qeX'<fVHO;1Cp,syyR6>+OH=_0==|m\-VQA]*ETl.*Xvy;To8lWeQ|52iM": a& = a& + 160
    Mid$(A$, a&, 160) = "a8;|ix<6;3X;mZb\M_7u>dO^*ov^62VhDFou_sHV7N}Rzf2t,K/+:I.+?PV11P43H4?il]=TTo_xeW/AeV)Vw1Tw86ZchCXN,w9?,29ihUvP_FlGnKMUfm'Bn?BteNH1t:iVCYa6tay0+XLWXlwgt-M9^;C,]UcR": a& = a& + 160
    Mid$(A$, a&, 160) = "9Xb9^jH_hFyk|;:oo>baTZUR6?3:c>H[l(:_xV(^uD/ySI4pa(BG^iT?M}>gNB)c'tte8}TArrJE82:_qfyw4oLAMVC<gqutaka}WZB2-\,=h\lWXFshUfsbDj/lD8AdZ\/-[AG1JxQqhr?8)<:k4]+qNf]_QmoD": a& = a& + 160
    Mid$(A$, a&, 160) = "KU^S+.zmUUv?>6dV]nzpic]jHa2p?Az[Ov;6d:,(Q2]''v('qRL<GsoBVGs}l4jyVBz=tATpYyhY;ixbjgYE4gJ]9jhg/qE9]iz=:Xq[{QxI|Ti+oH:t:uEXpc2Zg}[{^t9wSd4htUj-G(iSaZ-7xcdZ-BUrieF-": a& = a& + 160
    Mid$(A$, a&, 160) = "F+W,x'5=?Fw8(s\JiCx+sDg^e:V]_4(q4k+T]i+hKlj1AoJ3u32tmP2:7xfAX7-dUsccX2.Kw}4)5nSY-7i)-/THun\0+byUU?Jx+B8NFXD/}0GAXICzVC;lY)BY]6+fy-SDQ:6,\j0WO2gCYqI}9y.*ery8j}ni": a& = a& + 160
    Mid$(A$, a&, 160) = "}2DE(:F>Tnmj'p=Dz{gfNaYnK'r*qIPST+JSB>-Aj?1*X8<[+pYr(:9+XF?Jl0Ns(9Lm3>v]2ZIPV]-<b>'YS7D:2vZI2CUy2byt>GTiP(rA1g8]}J+Tkpdl<YZV[XjGe8A^0ueqv:G\J4GC}a<o-Zai\\I;*z/f": a& = a& + 160
    Mid$(A$, a&, 160) = "-Dw'kYx:2ddg[-J+1<dG>wD;,qbFU)ACC?WSH87HOM.67nFngH\'Tb']'4_fB/UY0"
    o$ = Space$(10420): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N12$ = _Inflate$(btemp$, 11396): btemp$ = ""
End Function

Function N13$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(12466): a& = 1
    Mid$(A$, a&, 160) = "0OE[6{v')xGI<qg>TkoVxRdPk>YZ2+y*zql477]>:TVDwi2c4qXf;3QR=-h-r;78DbD|C,94>9Zq>pJc}UBQUeu{N.hy{Qy+6.vJX:XmhnZLOM0Bm/Fp,9NdDS2wAt6Wh;6MICA*C}EDeeCgZ8+aONCzl[Gl=+=e": a& = a& + 160
    Mid$(A$, a&, 160) = "Bg'K(Mzr-s{AiPak>LeSN\3dk,SV*\j\PRx\D'z5Pkv*x{I0bkZ2?ur8q|Nx:2<]WIgL9:*a<PJCT5K,iK=ZM76-RoXN>UpvVUc(8q=W'l[dy*LD1^Sk-S7aoO4Xuq1?VtCe_(4Pq+/te9eH1oY2C7)nH}GdY-hA": a& = a& + 160
    Mid$(A$, a&, 160) = "Kxzz5gPV9>r7><?O*,f{^AU3VeK4<[v4>l>|uhv<h=^B:|+'r=K?+t7C/lAP(8>VXG=zh?R7zL[_)NL)1GaaBH[gWk?4.]()3Pp<<EM,)'JBcx8.aarvaSJG>zAK9r7.{L4'usPH:+v0W9.I=>'5ahhVj9wl]6Bo": a& = a& + 160
    Mid$(A$, a&, 160) = ")8YO?^1c/8G>KDcZpN\IdybfdbAVqI/(h^q'OY67,JrYOm/Jp>)=m^7OCMIt*KRK2WdGjqY/cXRN^Pa3>M-'7k{,g(^M8TvU?bo.r0E?Cn:F){cXVg=jA2NA,kdVZa;Xtcz,Ezf[s8_cXHJ.;bc3624hXE*Pw(Nu": a& = a& + 160
    Mid$(A$, a&, 160) = "Vnjs7<55|?67oOT]Fi(g>VyKOg2{-l.^YHFC-xN}_oU11^+F^6h1]8O,?.=WMEIEU^+q:IWV.v\iu)_LuIqB\V?=mSA'?RhBGY9]srk}>Jc3GlKS01mBnj_^MzWa3ELv-D;F^}+1^\[Jm]WqPrKVH3^xE-9ZqmlU": a& = a& + 160
    Mid$(A$, a&, 160) = "Ux;7<g]NAnI8jb=VSk7TWN+Hd]smOwY,)wCyQ..bV5a]w9]SXLdj0qB}5Vy5n8Eve^GR.{0V|5;azvU]X\S4>nyxF>Yo+Ul5+14n'gYDm-B*;a8,^+D6f,7*'Xwl-Og6sQNn}ql\og\xtf_RiQnaDE(j/uK/wLY6": a& = a& + 160
    Mid$(A$, a&, 160) = "-nz<r=XI9_rXT=.l\mMQi_6e8/7=ZZ/t_|W*i\XWf:(JklJ9Lwh)]Der1xA\y<A|3Alw3Q(ST.n,:\wSXiYtRXki{fmx8^3'-)V/>w(GHf*l88Sa//nL>AJV(7.E5O4HGr'bX8./BqGQjJ5zdT+A\|^xZWQGw5o,": a& = a& + 160
    Mid$(A$, a&, 160) = "Te+FIADZ>i_(aew+eH*Ln_h<A.Uv7fLsGzA/V-3WQc.KyXB0?5'kD]Z(Ob'QC(uzsgOq>(On.OSv=?,PRnjIf-p]^1,;JC^LNK4HecF]dohLYsnrdS1g'Pef/d6^)A_(p;A<A6TA=aOgqR=NtfwG6jb./gbXHg+;": a& = a& + 160
    Mid$(A$, a&, 160) = "0dMWKV*a+1/STUCoX>'REnf-DgqKigl.<q'=d{D:XlWgG1vO(Wrl_P92j*(2U1?>TdJ=J2HVrE7+udO/Y_5-CRL:9q_H>fWbF7D7F0<Qt_Iq/x1C7Ixj:_cG-q8BctZJ\{8Jj^zSwBBDy*=u)uVlrQ)=_VDC?f2w": a& = a& + 160
    Mid$(A$, a&, 160) = "cue03HBq*s().g)FcJqIlb9V{*z*Hx^4SU?F>=R''JIJKWXZ|mW=asyfCerE.9Acy}57vr]T=(vBBZVf)G>Yx4vR*^HPpCh'jAMP;gj9*ul/pkLlhfk/xIe6ibLBADcPhG?C8+\4E\Sw;wTV5^Nwe+]X3uA97tXv": a& = a& + 160
    Mid$(A$, a&, 160) = "48fkCyZ.(PVZW,NK9=Zj[>>e<7.tB/]i3E5mP3^>/i<s3.SshYHPpCADT5iM]6knDEq0DwWtww}q.(6l:Tn/pH\6(3c5[vF6cL+eV(VYaQ;,}[ju/i;J<:(>ljwHx[5*dWXvz8rlZ_,8BF(W3s./kVw+?}E-8[s6": a& = a& + 160
    Mid$(A$, a&, 160) = "(>64YiI[L-U=Tl{fCxl)zff1D66)iQ'/^NLq/GpoZ4=VB>]HgpH]zHPq<4IGpR{sBMZrKuRg>h4qi0Pz10U:{3TI_hj6|SbCG7m|fCW[K;yb^AHpSJ<x??k3keZfyb4q9{nv|m}xUdfk'tPPfNbR4Fl\9<x1(CgQ": a& = a& + 160
    Mid$(A$, a&, 160) = "C4Zb8m+[Tu5Hf?Rx>z5icmkODBj6N>jRH(dgyGPf}uV_vbR2|PtvvjRylE,q<<jsxrmE]cA)*1RfcpZNRl64-eE4:TKa.m/4S1Yy9S.\x,U|Lslr=j;EkC\F)[w9B),d|hE/pE0[QBq>x'cze{j[V>yp?n'y5;d]": a& = a& + 160
    Mid$(A$, a&, 160) = "0Ql_M{w0Dm(Kekc?H3)8Rv*]*o^+q_PZ3E4J)n01{fY_{w=>kJ'Cm-LsUoGkvS7(2Ye>Ly=-pXA10iY2}ZK-=1vYY-oR.>,kNp,e'iYj<jTXPN'>oYcGVDre(=ngW)-mRY<qv7Hrx^kALJg]P_Au]}p[20}<mw'<": a& = a& + 160
    Mid$(A$, a&, 160) = "LQz>VE<XJyp-(v0>grt\Awsl7(<0}>CW|y2jsFdtu3Y{kOiALa:>*'WP84[zH=XKOofZK\}>FYKhPC7y}6>-*\VE)[f'R;B5t_*UV=qn/d'n5*]Vhq>wjAySkZF.1_du>pCdDhdX4E_kb62A3K*)uz?jw3evkyrz": a& = a& + 160
    Mid$(A$, a&, 160) = "U4^Br61hCv+E2hGP<*0H_6s0f/v})),P4Z=D5RiAzO7N*tEXwvivCJ,B+Fb+(GHDU3=o70fB0:Dkt5W*,[f>JiNDp=fr1_/\)]T*b,C4KMLi?5p5lZ0ehK9z'l8Ac}joN^JDpJ5fmiZ,17ZQY43C\U'>tgJ3)hh6": a& = a& + 160
    Mid$(A$, a&, 160) = "N9:Ex/4mu-g5wo0pb7hZvyGV+E[67f3U=gp_X\p(5q{B5/P|gKwydnFmH{a+r-\*g}c=3by70q5wISCHbu/MrgdRC2-;KY^KhRCbV3o^arF?e'Xu{bBAT)4P(bw-7?r'EoP>?WSoRYbj;3HYqE*y}=UhjGKC?wx9": a& = a& + 160
    Mid$(A$, a&, 160) = "}2^uv2{7PSgW6r?X[Az85ULV0<OIwKISrrcvYb<+ldc|^Yj{7,masP((Z\oD'pFD\D.0{E\u,pCPU3t-/,qo8c\1lqp'g/)R7|CnjnEQC5cA.nSXwd+OR43Zj5irEwTe_Buod7k{c|nS,(Yo^vM*{U;T}vj(3BT\": a& = a& + 160
    Mid$(A$, a&, 160) = "cJQY7E4nbzD]R,Yd:u[)1gRl^ci2usjJ}7YR'mLGhjR.lC-NI.e2P>=1Sl.w.>?Er(Y_jO2p5APiyA38q^a_.t5<SDY+yn^S7n0R^7x\c4D<}Y;bGKHr5QAwncOTx8_/7LxPpx1KXmTSh*7ut>w-}OvOj0f1O1H<": a& = a& + 160
    Mid$(A$, a&, 160) = "P:bsV78eQxhZDZ-Du8c;<07Z+EN?25hF]9>Po{WY1u6(KZQ2?.e/-O\*_3xy-Ok?8rX,U*Nx|^DotLujLG??m*{:w=dK+N:dB1ncc.8LnBl_Zs{uCUz/(^ia>V><8+>chUZD;TQ7VW=?Fs?N=th8KpfFc>jb7hPS": a& = a& + 160
    Mid$(A$, a&, 160) = "/kM(*Y.(+[4ltK4s,4rGi'{ayq.[mtovgV*}6\KaU4qWFf(=tZ;2Xg(Ef_L+opU'eHU[_k(5*5k1:a0f_qJH9v*(x4RU\f{bK{k*mLVzU2Xp,Njx5k}g5Rvo0x72p21Ab0HFU\NeIXi.VNf6pBXOVv8T-pz;QN.L": a& = a& + 160
    Mid$(A$, a&, 160) = "GRJf*FqsOy{A:9^c?OToW9I+snSrz7yOj:2lGy?L[EZKiSnMl3AtbRaM/|w2aGPm[|SZm42Lx)_b.g?a<1P8PrPN2A2?EO/W\}Zo*3v>Nx4QlB8q152eCO8?8;hmJ)pVwb9w[Wg'jrh<wqRb:M_4WtgM3'QT85nu": a& = a& + 160
    Mid$(A$, a&, 160) = "tG7vvG4})..kz;tqU^lPdYIs/rHg(WM0/<O*_xnR1]MxDs55R^v6w(}xS.Q:d-iF|->El3i?Q(4E?V.t-+tVaOCgl+U>(ynX*vOitQ,7CF7Hq^8'OsOQ(mJ[Nwzww{Ti?ylD2bD-f>PZG^5?ylolZ}0.f5Q1fqwx": a& = a& + 160
    Mid$(A$, a&, 160) = "k1.<NSFjnA'XVxyK<:NNq<ay^8RFW-0=}-'QxQ7P*vqM=6c.N;0LBCa-\mk>Rc+J:mb(Rb?uByxzxA[rld?Htm-<25*u;w;O?Pke)RbEeDxe[./X9x{1s{A4><QAXWiQ;e,fWnOQ]DI]wOsSclgT;1yy7f'5[k]R": a& = a& + 160
    Mid$(A$, a&, 160) = "Ox|\HY-eswp?I.>si>Euv=UpF_Ue/j;/3[jRlME1'3+dXmc[BDSGm;w,[Ib^vBa^V<48_7o<II5-4-1npaF'fW{83bJPr8{9y-N),_VupqOl}(\_3qN5[F*[e{*e^r.LMmSd*AJ<b5zM)FUywKI<5qE[?u;EJ}35": a& = a& + 160
    Mid$(A$, a&, 160) = "or'e6^Tv-=JS0>A-hfFl^4MMsvJ3n[Jm\voLXf-GJKbHgS0(dNd/5<UAPMG1pxW-kTL1ks:cQ-S8]P>^L<i6.vn[8jJU'SQ1aS,av89=?ZJAxa<70-g,iE{N_9>s(8Q:|v.T*1o{'u5>5El6+l9Fk/.3S7g3(3T0": a& = a& + 160
    Mid$(A$, a&, 160) = "QUD/a0j]J)F9i90YqVNM2SddNjJDE,WBo(:h2M'AXfkai0cvdr{K(pxK_:x>*TEh=BacOIFcV/=6Ln=j2/]haRS3:JN*?dW1ZoD5Vz0*1PJ<LnuCZESng=fNDcmVgmfC(V?zLs\7tSH1cXG1\iJ>>z=70*()3W[Q": a& = a& + 160
    Mid$(A$, a&, 160) = "XOW-]rdX7sJqi:6,O+dw\Zfk]<ZqqUl'}Hh_q<0-PqJr3Zs\H{ho']ha54x,|SkRSQ<[8QpG_Q*bRZJi>avj)2\BO9/R/?WP)sn+w6GuNcNGN?}'H=+>WO0Z1{.{n36{rPI0/fH15x|6Y'2.C|'5A9g9\pGvf;qA": a& = a& + 160
    Mid$(A$, a&, 160) = "}'/tCE=0kC<\uUGMOuq>g<bR2usNHV;Yj.arwNr)\xVDBR9cdlibU,8r4P\|7qy9nH^PG,aIApj=;yqfUyX]jjsj7/3{7oani7I6o3Y9\^*KLQY)3-I+/dDlqk?d_R-hefLKHw8SZuc,BB'*?ehwiDQonOjfPPpS": a& = a& + 160
    Mid$(A$, a&, 160) = "DfDctU)N7P22m+f+zv6,9:)s<'yU<8\)158L/B[PmL'Y1[[{-'*,TOW/trt1sP{I5Ue[vz+RKrMDGhbz8De:K:oL>,FAQTi9E9sPd?g+}=6_wga\^SO)7D{MM.WcJTrT70gF3uRd,),GdV'Dy*p?)(Z2n/84gcHP": a& = a& + 160
    Mid$(A$, a&, 160) = "q,:484QGN=rrb(Hw^.rwS?<gpUsBZU>Yx4ba7VSrj=]wG-Bq}.VN7AA8D+6e'alx\gwhA++5)wNVf7}9'I<P9:E[>b[V<1J;Ox\MjKn3M7TLsYnttC|BZ03Ma^*,1u,Rmn[?dA\TuCO5gA'hG}?'|3O_JNGBDYSV": a& = a& + 160
    Mid$(A$, a&, 160) = "QYXs1?rZy_^iDd>qVRfw7_xlKMnpC{ooQOx7,l*veMJ<c\']F|FO6WsC>J7)]*aRrAM1oB:vb'Xly/_u1U>hWb1+WJJ[Jzhwwh,9YwExNn9]Nt|W|8iCmohjyMiz5?<9FvSbiuz>NNc}t=I88j_2-70V_UuQu5o>": a& = a& + 160
    Mid$(A$, a&, 160) = "]WUb>xnZz)8\gn:,D=)0<Po?t8f?g=_i/C{i*jy2iQr(8cZd,(iY7-y/WjM++=w]EKJy:}3Q_CvMo99+25FL>:o-*7]uR1OYH6mcLjOz\m5Q1/dfs/h[G\1)mkSIblfS9;3C2a}QNwE8oyYZixme1Mi_m=:>,3G[": a& = a& + 160
    Mid$(A$, a&, 160) = "WzeX[Xeozv+rE'v?YB9|SId9|m[(*iz+0Z-p[P0hz8MK/q>hWbRa9c(KpDi(J;6ez?rUWnRIHJ<Pq*IcpRW4h'r;8nwV(p4'V76^oihOT6f5r*1c|-)XkS5p;R(+iC'L]_{F+dO1g.V.pVZZvX>Z{T{6fS(V3a9K": a& = a& + 160
    Mid$(A$, a&, 160) = "2Qj}-?KRn5jbT\tCHeUaX8/?;f2Rd7dvQY]MU2)v'[A)O)u/n70<kkUs-kX^xRJT[>9/Pdg.XH2'gJfkcc//HbDT;2wuU?8rTbR:OZJlzQx=x|6Lj-=ddF'Ty2UJK9_.2YTKy(0]L{u8v\;\(Sp5<mO.)HtnKsj9": a& = a& + 160
    Mid$(A$, a&, 160) = "KO-jtjyvU\ztD13aLQYU7/)bX'IjASkB2kAcA;c9?*3CevJKSCv\F-xA1;eTBNrO}8Ly/*0tiG/'0cV*1eYc)LC_ptYV;-Y.cx.x;O*>DArqCZd3X^7:>S776E;ibL;u,=n/XK_,7IE7kqahEknQrS>A/O7\zu)I": a& = a& + 160
    Mid$(A$, a&, 160) = "/e{)Dly|vzVT'R+lqBG|MCE(^CV6RBZCgZAR>2/<Sv*G:CFP'[=_AoDUCz:-v)8I?xs/oY;NXeh4aXvz}eAbBG6]JW/H>Aytvc{4<ydWf.*798Lusp5}07X_VG9jbA=m*:XMtr;Zp(oJbloo)9r3aP3br2?{1\hO": a& = a& + 160
    Mid$(A$, a&, 160) = "nRtZVE2GK>K;yDwHE<A5o7P\kV.lfZGZ(8Ng]nS6)b[t=b:a7F^oQGdLyh6wn8D:gYNBcv8u6Z0Y^u'nmkMUaVw.|0cLV2xteuUIz_W_D>1A+G*S/;tr5l:G.ibF)+ko{^9iy6h<exwPdIH<.+ZsabQO'.S7]M43": a& = a& + 160
    Mid$(A$, a&, 160) = ".JjgmgqPCvP)6i7Dz+\SpX3cwsR>)Dp=nL>hV|=FhjvSFg/T7zK+=dfDS{y<HPPWsD4zu\VD3jBiwd{QGpT2uKDv'g2h5n\_e8VzZChdnU3b<C6NOHr)x];LTOd[B_ddh|sRoo'^7bFB^3cJuTSrNf51Ve3\qVnS": a& = a& + 160
    Mid$(A$, a&, 160) = "mxFDbyfp]chf>b1jcfG{PiXLmLGw:-1'r(RC['ts8vbiW{MnFFhU[w]nr3g(BYB32Ua+YhcJ[t=aDBCaEiI{RkS}YL^L(/eC,:[jE6)E_[<<g=b>f:^,Pp5-sxU\ryF\r..dDu;]erP+rGy;S]P/]EYe4w1'{7CV": a& = a& + 160
    Mid$(A$, a&, 160) = "nce;p]l}*9C:270S+:WdI6bap4OqiH)d8nUUCac81]NAyFz.9}puJV*4P55y,ALlBn;-Z]8{*)\amBJTN^+q>:D_0_}v,Ta:XF,*qadjsS?PEmaSW(31R(of|z/ngT>OR5a3;ObkEzL,MOr;Gp2wF;Q4lm0OWjq4": a& = a& + 160
    Mid$(A$, a&, 160) = "-1+}/l9,D}o3M.((B_2nBi]<;;HvCX7Xgb-piF|PK)wI{456Zq9?MAqji^=/LsjoK1\etBULp|54[?f3/dY1u,\r:uBz,5tWOeQwT_1SjheO[4ILOtHBj[<06B]267C4-6}/NYW(Z\n5j.Vbis)[eFnGcDp]ax7,": a& = a& + 160
    Mid$(A$, a&, 160) = "X1WGA=78NwlfWvJVxUyE3\}5wioF\e'hODn5sK)V9<'r-;a42-nYQp4mwHKRcyN;g8h..S*7.j)ZS{_AnGDon^fmh[\*V1JVOWgIQc[<,UBBkQ86k*D{*ekb08tFS4xGD\,Ge8cH+\W9DHFNf>?a?W}'F<fj-T|k": a& = a& + 160
    Mid$(A$, a&, 160) = "Cx-zK2+V|B6Xnnj|m3U,;KjLD1MiM}q*(Z>C_9JXRrkcpGtq08tqysFI4d>m-:Z?lyUAOR)Icvj6.MJx4=(GU?;[DyZ1aax4dIB8m:><OSRrEw:YZE6ZGsMcxw9BogchJ^]qLvgBu-;QxVSFWIrzlX5<3c1459M]": a& = a& + 160
    Mid$(A$, a&, 160) = "KwP+sx>h8:8R29{<VP3wPC'glw2fod^^Cu,\Y4h8,lPY2{ECo)OyFSzhv;yzn1+R-/cNQ-9]CZ=gNPmcLb\wA^>8s,I*,sVD>pmFa]Xgwdv=Js(CV'K95w8[=XwB,E]Z8__U2mfIEq{UzeXOTc[9]=I)gj'eP[nV": a& = a& + 160
    Mid$(A$, a&, 160) = "CO8*5|LYeI7n-Lxq2U2JX\FR.G-_qccs;DB=q6vP_CaxX*;?N1Kf79{UpbK>)Ptc1gKzxg}dlOD3\^'KHlIi=uwC*jQo\s/V)(qDI_[,YU1KO3-PurK*<9zTh<X-2hxpt]^=Gw({x'DcJ']N}=z9DeDCIO\9;e9>": a& = a& + 160
    Mid$(A$, a&, 160) = "0IK;Cj0sH8xi{CQ\;dEPWF:ei01krKfL_prv,;o>9SyS2d[B/X/GfYgh9KUs6g>NiZNeG.f?h'7{2>WkqFnoFqw(SS+ZO)euEf2I++(jF'YuCXnbqL{vIWq>bDUZfORUjwRszbJot*])Wr[8tbwecF_f+|S0KkYa": a& = a& + 160
    Mid$(A$, a&, 160) = "1*?M1Kgl3-YaCoD</a{8Z[wp>}x8\ijUM,YFHp3'Boos.2)w/|Jm1J[8_24snQ*wYGf}0BOo|u>-V9Rm7'd-AjZ(CbS*15TUJ}TgKfL]n-dmYiaN8e<d=kwVZIV_x[R\aFO=LyW:J'Zy>pogaavyt;MUU'z^4Br,": a& = a& + 160
    Mid$(A$, a&, 160) = "}4[Cp+AsB5lAY7OJLWOtjv[oHk2[0)C25EPwxVhowgcC]s4y}|[)6S^h6dmwaRsYahK{WfPrr\g<u[WyppiXEc]-x=C=JCdxVfHTl.IiwS7^Y2^(OHNz2,A{;3GvT8l<^Op7z^()'g.L4KD1aY/8COGg,mfMA^4=": a& = a& + 160
    Mid$(A$, a&, 160) = "6g[pKPd(8k>.Gx2>a\Nh[aZ'Q|sWgKGv6LmenE)Y<Y>>9>h.B6K5t^.b1G=H}>Ah[L0:-(4Kk=;vYB>ugz?9,:x\WIoE96Elu56Ys0o^RYxeh5NtdfBg8?Q(>*'+UdvA<p}VsAH>a\\_ft9BjdXn6GWxj)usdRjj": a& = a& + 160
    Mid$(A$, a&, 160) = "?S)BiF(oE?Da^H,zlM*GhpZuDPQeb9wp\eB]E6\c/JJ^:sci{)JE*6Fsb0xkDK4Y9d^u}3|s8|n1X=NMA/eZ,ct6=U|n*X2=cdFx\:YXkNZv.UFhIY-/,Agz/v]VDEmzw7(C\Pj-\[wV2-PN?VH:\qfy2nOHLbA)": a& = a& + 160
    Mid$(A$, a&, 160) = ":VZ{.Zuf0ulQ<2(^2j^Zn+W?_lmC9/NDSa:VP>7_'/6it<-9Z.qX2v+<p3?c)\XYrKdmE;G.w,A>D<kd.w2Jto.N0;v'.sp7]uxNQVAsc{/6ThNQSruC-GsXEQVcA4[J^(zn?hqd:lv?P6/mMYeR:w{.ugs{sfGj": a& = a& + 160
    Mid$(A$, a&, 160) = "M\\ES?B?NP[Qkp[t9(Y[ZONqc8<9yyb2co)J)uN0;3K*y.9K.4N?sSi{u{(FVT},ok7o:3g-wLSH6g>O9N;A*-;(|_BK^H2Y>*D0Vtn*{GS(B8VDCRnlB,DkmGn>Yz6)4K9KC56};p9AIA(QWhXB_W[8}Af4S8E.": a& = a& + 160
    Mid$(A$, a&, 160) = "8w/0\(<N,PbHN.|lm1vMVrugoV'F|sfnwY]F)[7JDA_8;|JBAmz_7g_]S,7AwIdmNlCULc)BqrGp[O}SSE9[B=8+SH27ogDE4-s}:t;RE3KGANDZeP1PpVyy>>CW0[Q*Mn<hAvv)>|Uth]Eip^CjG|CDnI.2/<}b": a& = a& + 160
    Mid$(A$, a&, 160) = "XoGiOD[lftr\R=o\V/]s2t'yJAn*/J{k0^A<ffc;FB7^vQAmGtIS9*0=?o,uRjP-?G:RYM*G-N6ki6]X04R:OX>a|iLM{[[izq4l8e)]NP3:E8s1I9Cj[Nt0Msvse.AK)6Nfn850M9yWgjU\icA?P7eI<iKgn9;^": a& = a& + 160
    Mid$(A$, a&, 160) = "-Qb,NB[GafOT06K>ub:g/\}sejMeKlm5U'<LNZAI[)cqi,>mIWtacZ?'Bn'0pTjN>I?sIxpN,>uC16p-xyNe_2x^yl\2Q9Y=-uMav<P*W_Ho|tsn/G(gt,lT?^<QDvkU.-O?LK_xV?7;5l(E7Vg<\v*wl?\3GuNA": a& = a& + 160
    Mid$(A$, a&, 160) = "pzNWf?>|GCPA86D<5._MfoPVna(-TIne[=V'aTIeQ=4mX.o2A6my0kH8LqFfEz{.Kw]1TIWij8F_PZ[4>x75;LrFEsA9[]e>(nn}B>IL\:Z;g_}DvqBOyk:];*ZhxyvMOY96^)GY2bP.rtdy/Vi^h5O?I0>dp,Q7": a& = a& + 160
    Mid$(A$, a&, 160) = "XaDj;<WwlL}pqCF>u_>8}>\Z;bT(p60_M4>]BW><W))ea5C*FH{(1QbDW5>nYey6^Xk<iE=RewA}o(7Orrn\pyXQEqLDAu;NdK{t1/[[8tpTdOtsPInH/VlZ\?N4Qa;-zz(De)gL_zR|{o[ekUs9x'[j42{OCeWK": a& = a& + 160
    Mid$(A$, a&, 160) = "Gw4jr]XTfb>q*wx;AyGynG]7UK[JA)^<q.bku_fe((P;-Ck_>+haZp86[NLM*9-f5fXpsqb9B}xnp|FYk)r<*y]vRB*kHcV?IG,vIoW6v'q.=De5Wq0vVJ[g6*|c9{.}X_I?92no);9F_-Mh:VJA38]:XoS^+cY0": a& = a& + 160
    Mid$(A$, a&, 160) = "s2'T75Utk+L<myj,7ap+.u;O>,h-M;}.3{:6s.1So6y7[E--ey;5i4A25t+D)>_bcsBxD|R62Uvg8My];rFof=XK5..T:fCbnFUNM:]_ZTq7|mADPD1(-mM)/r+y]U4h-3am*C|rg0y|elAb7}jFAhl\,5|XkK_Q": a& = a& + 160
    Mid$(A$, a&, 160) = "^Vt/M=xhSfa4f1r0>jV.-)uV2G5E8Ln=2nPJRnEi\IE.MiXk]44S{GOD\h4I;C?G:zpNq,(S6=1G[.ILWL)QJ-6YVAz'*a|Lk{oG=K*Ab62-{'Dju4w:N'03(Y(Z9xqxoD'SPoR(fNFy8PFt_AO35PvRB^c]ae-X": a& = a& + 160
    Mid$(A$, a&, 160) = "ge}E)CZ|,DH,?b^3>1*MCh*spE?N-VH=cFC?s0nJB4|8^RK=m\=bMQTraSI[bVPpSS^8|j]lCC_1w^bO(b5zV6G;UjA<r1TM\0OgB5M?n/qeyl(jG/vYf[^^6:h2cWgK,u{[I/fy:4IV=6ch{RGxXrQ=nXefJW>Q": a& = a& + 160
    Mid$(A$, a&, 160) = "8>i05vg1CK-DGiMT(<tPQ9:eI]);9FoIe(kNBZ9aIr}.[1FYu4SbB2k='jxghcts>c\D1oBvf(mdHQz8dhthoXB>k2ir]}hD>v.uJNsvrnN6*go=x,=kK5KMUCS:QR^wB;QpZ^(^a7bB-V394w5)EZ1CmZ9wu]Uo": a& = a& + 160
    Mid$(A$, a&, 160) = "k3tKjwm-WoN7wun<vMxY;m:mJlrF:zwv+:QD'JkvA<x)8<8eY;]]2a+F-xvmK2{yEC;wg.kJH-JdRjI\w9PT<zPOz\o_*=H5>V.mF6w\F+7s1jrUC'ql*w0)TzLErHBkx;-d-=;)I'1^R[o/kvqaWa47hsTP]-i*": a& = a& + 160
    Mid$(A$, a&, 160) = "qjHTfAy9L<'RJfHRGI}6Jwrrshg6CnMzoDWWp:(Ey[.(Uj:Mg)^8fK?ZAzH.C+T]x=]Y?)XAAtz\o=}7liYv]8m(fn5IDqQ8+hV=T?d>(Nmu0H:hlkH::x='9G6kp2qWl,36z^=Ax[/*+^.E^apjSJN/2UiymSv4": a& = a& + 160
    Mid$(A$, a&, 160) = ")R_J?y,W7ijl3hSuu:_Y|O\G_yYD;8Io]zzC4'mj^T)zm4MT7-10m+{{WiY9ZJr[6pU0O3eFkr7FO1q*.O7u=y5+yVxrsG2WmvOKwJXV4'\EkDbF^i*CA<[[sArOkb(npX1+S'tSe(LLtt>Gqw/s+5:9\^HkoxWg": a& = a& + 160
    Mid$(A$, a&, 160) = "f?cK]KOVX)x[OC.b))=20<'?r[WEDj^xz3Gd4RW7T'5y07ARJF|.ZTe6ue3Q}yjX|BuovWIpc3HCgGKp3VhOc17FB(u=|adCAQL)T>us^of_cZ'>(F]}]?+uP9}_fL1QlZ+HqCRpe?o?GAPtFUQB}D=,|\7JhX8P": a& = a& + 160
    Mid$(A$, a&, 160) = "+W9xwc]/<xQ[8O^EzFYL)Z)IWVKC+]gO^OSwd9Smcb2>6Ji9n5qWyChi24_1x'rCPxbrEM]*\J/Bm'U{j?DJ92qV|jaW5Y4q?7aH44dmG6D5k0O5};Nbf,Q8xQpO-?<OK_wKbscE.4RPl<\nUn0*?R(mFWOsa69J": a& = a& + 160
    Mid$(A$, a&, 160) = ";LP*Mbs^CXN4pX=_XnY/m+Vgb8jytS'vQKc|W<ibDd>hNt2_q6FLcj|^Z{+*N+y<usfQ7zp6VnT);om:<:;:'rnAA{7F-ZzPMyY*IwZ>x-QzIb7;hsJFVrzN4(APg6w[oiT5Nk'/\27Z}OS1R(vfNb+abB.9QE_O": a& = a& + 160
    Mid$(A$, a&, 160) = "[Ez;gNb2\bQ83>KOk+AkzRI[?/TW]0ow5A_ryat|8K]H-aXwS.N>iIOK87E9Xq9hs}H[yTHzEyy*vhDt-[9}k3Am^Ly+HLwcRi-x(yVcz8e{VdjqlWRVe6.HKzf(|/JuIQ[5lsUmd^+bKfmHrm]^(D+(mdPNSz)D": a& = a& + 160
    Mid$(A$, a&, 160) = "I\4orY>[47O>,/O[?AAZ=d)'AjP-EcRXF?,'eaWiv_hntgFF2},CPesOL(iZ^;y](*pBZzd?HkA1[:?'4H9L5GoxMS/8jss1\SJ9?G*6pWhi,gc4her:NaHXNDP^2,lS(WAEzD..dr,rIFx01-G-OMnI^='4=KN7": a& = a& + 160
    Mid$(A$, a&, 160) = "fA?wd^Je6QJ.67Utf^[wR]zYpYUdS')C=Ci\/zLj18h-::k'udKc(O,f_IP6e_m5oP2Ao,Wp94?zj7SGX'q4xvvBue/g9*ImJK8vPO<?m*-RWaWAZ/sMwOrV3h*c8*Q(It<f+6A=G'[SN5Q0An4>Os.RNcrELcv|": a& = a& + 160
    Mid$(A$, a&, 160) = "'DY[-yf,'eD:']a?S6Cs/gn;P]JqPuCyV:_\G*>1wMB)05uR2a0S0+\8cmxd>xV1x)E:Rvx_P36OHzwjn[s<<InqjhykP^nz5Eyxp*;n=gBCU..rGJ?fIHEm|WD9n>?q;LFj,:ljIaQO[Tj6ZY-HhbxB/>w2FzL]": a& = a& + 160
    Mid$(A$, a&, 160) = "V*rBhOsC\)JFeaL(OVFYeWlI.3Rzi[S74m\OdXFMq5qxYMF:w_31Ny-Mb3EPGYZ7i6wC9SqCjWr6UcZ5{17G(/_i6f:MteTZpxph>+_\Sd0=O9ZIePI\Rh*iQrg>B(MO2o9,>eKqMJCzc.6Xiv,nj1'=6Ipt-.K?": a& = a& + 160
    Mid$(A$, a&, 160) = "z9BV:.8FF>8=PXt<k5-<VTwT(WThfFR>|vD08Fyw7QtPf_II?W'h(XWS48Kiu.|gkRGY_3DS|Y2v\h3m|u=56UBm],.MNDFl)Zs8cxJS-:X1L.N]g3Lu0fQw<)/_c1(k?ET_>zuRP6)LiCS=H|k5{CgXH}JY2q.E": a& = a& + 160
    Mid$(A$, a&, 160) = "eV^T1.8UR<|(:VumZC+v6E0.-lOMojMe-FqXB(]XSDyV5-Q*nxNii(:j74q*\L^TPD*4+5FrC|ZOvKJ7=xwpG_Xc:q)<n96Nq9qw5,nL[(ud1(5WD}oUO2z{>ulbQ]TCvaXo4xG}a-\-/q)b=pTWf|A8o^o{LcL2": a& = a& + 160
    Mid$(A$, a&, 160) = "0c.AwsV)WkL+HVY)Q3fAS+\KI+3Q5NE>Tv6WUk'Yqkl/8u*eP{IDVB4vNBE71S4:DM3X^D}k[|jH=3Vla<b;,O3nBZcnNIp'.w=A082WJep4Y0Uag*1,bzYenVEL(Xspxw6:)1aMnE[Y2QAd|Rku66c7=oqaZJ=i": a& = a& + 160
    Mid$(A$, a&, 160) = "iI_,W{CeV:Ei+<+I'1<w04:*1rY]a<F*?s]<E7+ZTP0r<bRd>qy[iH(X)kcNtCfGi2Doq}cRonJKY)bpIIT7=>\K:}:;,z+g'Bb|H;v1Ibl(s211PLOgx)v^]7-DkwQF9k<2.W}t';QJeCCE0"
    o$ = Space$(9972): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N13$ = _Inflate$(btemp$, 10935): btemp$ = ""
End Function

Function N14$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(12801): a& = 1
    Mid$(A$, a&, 160) = "3OE[6{u>X7ZHx0sMy{\mL.\KeLncCvp/Rw5m?CwLeZM^fT/N'MQkO4ExJ(l2:>VSr42xj4*CAy)s;;7u+{>YVwut}6z9XL3>e/7wApb+Ic=1XmC)t{hoook}\]LM4gZK4v>25sOBtX'epRB9sz{9RtE\/Td3.hm1": a& = a& + 160
    Mid$(A$, a&, 160) = "pz:?<8W\-0Wx}p6d)h,E?U'uC4U>6:e5FXs?^/YZA_z'h7Gy5MwWEh24+I1bUTN0m7FVgtjU2GFMcq:-935B1gW3PN,)hV>yFV[gsoJF,>0;92ZQq'Bi;K3a.TF+h,F4N-5_(mkIVhF9JE\QGaD.{+.A8dl'/6B;": a& = a& + 160
    Mid$(A$, a&, 160) = "*6;k0cd*Sn<;Z/P4<Le;Q83siIMH64F;9+D3e^J]gmmv*'rGY'z5=)L+D}:\/pt(4a3;S9XAIZcz4\rq_gNGvDeVaAp-rJ=kt'Jwn,te1?Z}e:ZJpj+ee|08sJZJt,[M:*d?_Fbe6D<x+]FLS.U9Y|rfY;slW3,P": a& = a& + 160
    Mid$(A$, a&, 160) = "GzfgTw,{?XP+gvr1EG4edy0(kP'KJ,mNz^|Hw9r^);Eh3vdtc29w)q=CgG-]\MuGNc>K*O;>{}\ws=vl6Ac^}5vUIyvsUiF}Uml+>0qqvv*jWW(\uhNSsQX_A[L4EPRp1>n*MDD95HyRZw\\a1d}lxf/-o/<IAdD": a& = a& + 160
    Mid$(A$, a&, 160) = "rw)mRe,_G.2fRw8I?3X4=X|J3>]t,gN6mJ_<3Q3'jIU[|9ql{0<DReP[^x=pS44(?ciP\mubtIaIZ_HQX*1_R+?h^Tj6w<*;{3F}3P=B^ul6bOM*SI2F,jsnTs42;R8sY^xNc}9o^vLV=f8+D<Gmh.Cy6Nu5647P": a& = a& + 160
    Mid$(A$, a&, 160) = "*^vL[ZP[Cey0_Qn+vxA<:a:U=]OwbVdU]g{Rk>aa'T43MB{1WV|R'4wmSDk-^yPn_D2i'HQ7e/8._i6nEQ+[PtH2PK^Ujx0/h:\M*UER_^,]zr?)T:I6vi)ri'YFi7y6pyUgyYP{a4,hg[(CdM\lft/,a2u^eic0": a& = a& + 160
    Mid$(A$, a&, 160) = "c\mDLLF6*B_-K+tMEAm/eW8d?hKgV<KSsCy882VWB=;gQH8xHNvYalv3=D+O>=[mmhec)zIV[oHv,)|UuDt*j2u-.j?TUb?6cJYbt319ZdJWe\<<<JfL?Z;p1t'[F+8s?3aRUym?4vu13l0_*;xd,6lc[DKM0gsW": a& = a& + 160
    Mid$(A$, a&, 160) = "Wug8Kl'/qrWV3EXY][\QiZL(7VD+F)DJ349bgBqR6bH=Czxnmr1:qY9t;[El_gEA}dTv}w[>Bi)DF+lo<1'pKHH*:zOTu5*'>d1Gvu-Lm:F;=c:Dk5h}Tw+tFYzj^;bqz+u41(.Vkhl[8El*SFbON-Q?3TznX,z_": a& = a& + 160
    Mid$(A$, a&, 160) = "{j35c(62y7D1:o'^u?9=CX+C4gjc(Ge9YaH2A(u+Py:RZ3vDZ01DfAJbaYMq{GFu6CWna*to_OsF>AIin]:THbcB4d2n02{'XACP[F?8zn36Cd}v/]syXNl]\Iz}Jg7D)Y?0Cesm7VO(a(-aDjEm/b.UJ60;O<{U": a& = a& + 160
    Mid$(A$, a&, 160) = "JBn)*g:*O}UcILL]3MyMRBse=.^;C}'X>=SSX)EwO8V*uLUNA3fTM=|V[cgwLl\}S=t+znvc8Ac27,iv2QiNxSl9[spgn[p[sVtS2rfIrhs1.if\PKgUZJ-TH-Hl7ua4cXsPxGBf_(kNJp>>n)rOqALMolojEqyP": a& = a& + 160
    Mid$(A$, a&, 160) = "8?t{LkH1SoeJNmXGMwurrV-c{\4}8E>XYuquh*iL7ZD,_)LO)ZH\.<c+:Lqya^=)?9*Ym'AJG:_15Z2D]+Y'Draudw}_CO|peRAA|pHOT.\Gge}T,Sk}V/oFk1'k;-w8F^OZ61C/6goY[iuovTj_I1S3.*;}F)F^": a& = a& + 160
    Mid$(A$, a&, 160) = "kIx6fw_m}GcF+T2h,_tE29DkId^Sv/r8lWR^.eiz?l}?kw^G^gOOTtNK:YDW3yxaVBb|)}kspf[;ZhB\muz.K:ukh2mk[BNx+YmB}dQ[K-rea8K;Ov:cUzswlbDTOex*I_8[|Y}4Dt4p=.)*<IQmZ\{IdU/i]goa": a& = a& + 160
    Mid$(A$, a&, 160) = "xC1cAYZ+)(}1en1o=0eA{Zp+:4OX-7Ky>[5*6:[IkhneyOr0.4q3KJfV;P_Nw0R4{|O=QYbp]B<VN0k;YIZ492UeJd17mF1JHpW4:4JJ)9UJ]lId_VcKUIj_3k.L*4NCy<QWIi7Q:41T\H^Zc+uLKAlSZrQk7nYg": a& = a& + 160
    Mid$(A$, a&, 160) = "?qcN)nig6eNB;eu0NNoq7/.?nI6oX(z].?c-zDoRp)hX9^zwGhIx0hZZRvy3x4JES[Hm}*YNCx9Xem=Ug:sB{4H,SPWjOp>OO+w(-NuvhET6_[q)i[kMQ?iLyEh/zDFg;8/tfuh9WiN^cRuRn;OHnPu/jO('2vvI": a& = a& + 160
    Mid$(A$, a&, 160) = "WKcFki/6;1v0).WZaH2z^+Hrv]4_'9XxS++^9/n8w3Iw;xop38x_'.sSNa8SKzFD4:,5V=N*fRz6:kdVL5=<DF'7[]qsF}_b=o<PBRZai7Vzqtu5M|e>d-H>:I/=P5C8no8uc0038kkXK*q|DgqrX:DSqmsCsNWO": a& = a& + 160
    Mid$(A$, a&, 160) = "VaRAKB)am?a3ep\>'TkZ(fACosDqaMA0:79*/=,;NgJ^b{>K)Ju(?}zea,A(6U1=Ou3YkcC85hKlqTdlFJA\|XxEh_4A42u97i/O+^B5-*VYJSE[Z;p]EdNOVHwZsciUzNkqx[>8<cIUd\7RLSEj}gl(B;:5jn4'": a& = a& + 160
    Mid$(A$, a&, 160) = "W(DqQPr}Nz0A4W2YAbzePHoRGPt;U\+-mbeh.MJt.t8KLcfcQ/wQ0</z[[\JlmZ=tIvHxfpf=jrqNVtbqJJ8c<V*HXG'?8/XGFYP/,X7p7HNARpi*Pl=JC:.4E9T-E*AQq/m6Ml:>HurNME;UZjiU3WRn87xe[RN": a& = a& + 160
    Mid$(A$, a&, 160) = "E6L8J<>T9J;S:BRmTKiWvE(8]=\:kM?^nAkSCbaZ8um'3*jzsAdiqVp[fUaU.qV_XEQ(RPA0_*w[1{>?b'8ao4088PPoD,In-Ey:W1Gyzyr'3:hgO^D:)xKXw0nUT5*F-cQj9V]u0}nK1o|;o_e)gtG>p)07gObb": a& = a& + 160
    Mid$(A$, a&, 160) = "w4ET>02MXj0JLPaY47HDD1g9416Mx1CfIJ;x1+=MjU5Q0fb4ghJG)0]aGE*bV)/cxq>RtSBDd8P]'N|p0c5kitzoiBk>4}xqRL(e:{6y<H1B:]pR;ZV+-swOp+MM*};{hEC+KdZL'CM-YZkQt1[,/bnpS>lc0pOd": a& = a& + 160
    Mid$(A$, a&, 160) = "Lv}a}wE:]=Zj4XeveBxx,e4>nV]N,scA2s53DZKs.o;oeFrJq/-b8>j2.(L)8FORi?1v/)/6=XSJqKqa0LN<iVX_{}b.=GEgd-B:sr\JjDi'>]]5uPCQmVI[s/o<5Z_^'0:zop[R;,pxSsGDJI=4;2wLahfr\og5": a& = a& + 160
    Mid$(A$, a&, 160) = "v_<F4xOrEthm};8LN7h{9t0q?)8u/(pEk9X\wM'Y3h_(i6,lEJn3dE5T?tFtuWgrV7E?)ZRUGj[{IkSn_ewkD/t1Cfh[}v|Q)Lt6wCi]+W'7f;zW\CTDCk^fo?,umsuw?k9eyaV6Fb^73U+RT2AlWQ:U3?Usv;:?": a& = a& + 160
    Mid$(A$, a&, 160) = "5(xNc(=VG1;pi+T9v7|7ay/A,SxZgPMkBNKLnr}k<rs\[T2ZJjWOL?-mSCMg{\5Ij<(x[5WuGT^HS{'I_MiuATM_6.e6/tOO:,bK?(Ie-v2g.CeV?:-+:OmgPQ|Ta6rfnaftmMALQY['ctm;TXos3NzI?HjPu;wg": a& = a& + 160
    Mid$(A$, a&, 160) = "c\)z.yrc'\8yi;'P[ij}|HF2/bJLJ<hOr52{VrM-DYF_93K]Uzn[og9'g{m,MG1B.Zn37YHrON4,lmJPdLgMqr0{D?WHibc],h3>)9\jE+a3XY}FgkYE<\|>/Ge*eRSy((\vp+.\7YH?BZCwVgH>FO6Q?<4Hl/-q": a& = a& + 160
    Mid$(A$, a&, 160) = ":+71W+:OW6Np**\j>aM:WZkvKw9F_|{>'.mc+9uo{:Fg9amx5Qy):n[LIJ{yw:g29IFTKQ^u1v{j4A[X{HzA6O:mZX/XoQypfY+S_3VfHU.c:9T,T?_x3xg'p7.e4EutFx2rq6/e0v7\]6IUs|b*rUdrW,k:Ql<G": a& = a& + 160
    Mid$(A$, a&, 160) = "fL[<:|aC{'JuIAN))s,>jFjAA|U^[QaU'z<0OJMKyOoGvWd'?.,++QMdNQPNr;:}i3<MV08l*Y}yNm>y[y|O|{'cR+0'g1X6c6/[4/R:Fez,}ZQHKElfN2Gazmi=Lil\,,oQ8TWWdChi9b{-*sFv[nO(L]/W3b]M": a& = a& + 160
    Mid$(A$, a&, 160) = "wD6u6gR>bt:'-Pfcs'^Cs8IVUeGe*y99c*<4=gGXr1LJN<e-Z4UIE]w,=US[1+,J'5gn>1x6|(9MrZ_?(^CjGkfM5+aMhp0q*xqJr[tm+}'0Q\<a[WNEjY[][3eb(RRZA<ozo)cRgV.Ec+|j(d?(6X/+BQFJG{H{": a& = a& + 160
    Mid$(A$, a&, 160) = "|vBXNFc9y(k9c\NMrD33PvC=\{9+H3cV<,'gzdK>WhlR[kXdL>W0.sMxqTESoNZ]_<idY3hU'+GL*u7*t*3[Z?bw\VCnKVz8u*^'M9\u-<lo2D=\S1g}Q/Al8BaA|K-j_='xn)*QFObJ.AJCPeEPLZO>8Jc;]4xJ": a& = a& + 160
    Mid$(A$, a&, 160) = "YJ05M)'89:d1G,L4uGWP/S|2t|YSR{t8q.NMh0B81LfS(=u:md|yo{gpMFC/rEs1r=^co*rR,Jxk3{)>V^'J];5Vn7sLN[DAJWzZT*_fHOfi=x+*|AQ|Zud6HMCPu4h;+\qB0HRIQTi6HoqJ}PhV>HJ/q)i9ZG7\": a& = a& + 160
    Mid$(A$, a&, 160) = "|\O=zEM+1+tZ>+dqW1Dp]zzTj7X:i9QnBYBPOp=<NljgiNEX>B5OqvEAfrHt-NU(^r?rd,HF:h|>.s.'c:0bBMs2K/kd]*}1ig3P>UeZQSsi<pD;E>jzGgTB,^eyVS/2J36((U9E/n'4LM.Co/ZOlEA^oSk]^oxY": a& = a& + 160
    Mid$(A$, a&, 160) = "BS.5T>Wg={RRQrb:Kp1qhXa=;6S;*<tH+CgN3qKP.us'(:MM*I,r,g4b3hb:>D*K)FJO)-VG'<R*d642zJlIJ'lbce-uaC<fmmYR1'i6aJG'UM[ibf_Oz+EhTU[0H.f(ADrqL/HW^\bDKb5KN.K2_0s:]s|{VF/m": a& = a& + 160
    Mid$(A$, a&, 160) = "U6r{+Iil(</cGj9h;wv--u\2GbI?ytKx/Rw'y9wp9Q\a]W,A[y,XzXni0Lq_A)_X_ol1S<G;<o.-d7'X4AH.Vv+>lVe\rJ)<6=1v5;f|C?N:9(prFgQpl2UNuGq\3/r,vOkL3,^I>I\1>-N*0y.dlf-g7?w74H6t": a& = a& + 160
    Mid$(A$, a&, 160) = "FD}0E(-c-{hsEQr6Hh\j(qG,nnWNqdWGwYqfKCPrry//6fE=?[p7CKdN*I/3>fm+w1*=d?pz,<YbOz>>kFt6=JxApjs,wGa(L.Q+;.iM>Bd4BBEBgzL53szWTVsCmgpCvDcdl|7=ulF^yc49E}E-Fuvn}osOZ7Nl": a& = a& + 160
    Mid$(A$, a&, 160) = "vS.udc;xEARn*y7KHntd<VSt[hKYgAV(OjyU]{ILcv;DzPX1<{jlj1w}j7;(sK,)5L6yBx,dU._5>t871D2\x)hqe+wochnS[Vz/G/=h\'xd:/AOkr^w0hOEs7emnZ6Z6e[0|6nsEW.9/fboz[Riql2].[TTw/y=": a& = a& + 160
    Mid$(A$, a&, 160) = "4/tYZvQ-1YKL3-NLtDJN)N]EmWZmH>iDFMrbEFr-,O0sL^v'2Dco<v:/W9]:uK6Ym/.tHZP8Z,usJb7:1NIm},PV-|*?]OYG2U})Q3h};H7{0mcKSDY/u:|V<4u)DchXUMZ(]>]oc_H}YNO;w+Yc]n9_f;ibJb'i": a& = a& + 160
    Mid$(A$, a&, 160) = "zfe{YHq-KuFF2D1{a?{)nHIySr,xvP'o5D*]?{;yDeth4{WJ\F[uaeIdpVISR7qfs(d+uehNmAk]87F<OX>tWx?q9jD'7wu.QsRHOVA8}lR252J;jQ{62]oEd])'jHlOTyca>?wb_lPcX7pn52aPq|8qWh7.DdJz": a& = a& + 160
    Mid$(A$, a&, 160) = ":4[a^rd+x+{FJC.{8zCa,'U>b0aLxH:DXV_W98fxyPR?<0y5iMj-Oq|0XqZcL^g\Z7ub{fX<iS13D.JE_C6V^8d{=z8OTOLo4Gc}XpBw6,e;RNTtEN(L:J-1sK:S*/:T1:|(^/t6zBcYeVGgQ^5maHt0{eh,KNRy": a& = a& + 160
    Mid$(A$, a&, 160) = "pcAF[OW<V0=,'R'ophPGgtV>P);,?<]H5A+H(O\kK=WPpS/1gMPwAMHeeFgT^w'6q7(xlWo'EwF8s[w-f=6Uk1D8Y1;62r6W<?-MhyAW.CnUb+y(>7hM29weS1>I{epqJNkdcEv]XwSi\V/b*NtKg[o)).]PMz:?": a& = a& + 160
    Mid$(A$, a&, 160) = "Bliaopp4_,8RN(SL5B0Iv?=vM?R;CjA/ZV0niC.t4n1X2DxSb;un(,{,tOydCD21B86F4E:gO6qL.D4_c><0d:j83YoOF7p)A,,.JkjWNdMD{WhRaKuKpHI)8;:Rlsi_*nj;*T|GwGd,<epX]:ZVL:30u5)DO/NM": a& = a& + 160
    Mid$(A$, a&, 160) = "SJwKl^I/.4N6vT?v2-abBm|3Pxj{+0)K[S3X75*he2ZDs:*teN}^}|?j1rPZEv[a|04o2QP.ue|2s9<uCe'tT?N)1cSlcM|COlUlboBT=GU3gO5^GT-uf360e:/i]U/_(bVe>^oihsdY[.3qlNh>OAVIlVbxq>ET": a& = a& + 160
    Mid$(A$, a&, 160) = "WaY-FQvTxH3K(Ye^NtlV4a0Qg]Bt,/*ivS^W71edqS|*9a]V-U|sJ}cLOmv8sG|WeM<uA_Jq*HMB;Oag]'8_62M;BYyigOVYG-{T,rZ|L.tP;<S,c/3'U?UIDfOdf_7.ciM+5|Wif2p72P'jRBzW46waVQqZp2>q": a& = a& + 160
    Mid$(A$, a&, 160) = "=A|xS<Glrtl>FKx(R=;:-H8crMd7i?0y{YWTFLF_c[nXK0fLS|ui,8Ihgh<<LjttNn:_fEJ[<.Ng<lUPwQ^mE8j:D2iq2L{^(SkaI*N1PY(eMEE9<:>Q(B+><^:|K?x4sQS]uYD[jJ\F/Lz)NZfAI?8_[:ibZ4>T": a& = a& + 160
    Mid$(A$, a&, 160) = "Dtd>IB]7\:\?v\x]gG*\E9R\OTSb,TgJzAks0A\yoyRo9ySvie[Z0|XoKnRVS?9MQfZ)thE^{y.oKMiCHJ5?5.Q,|.*iRiadmF5tMPup\7XrO3EF6}d?j+jvya\M50'NIAp^rriXfcyY9(SMO?/xf(zBJ|^Yri]D": a& = a& + 160
    Mid$(A$, a&, 160) = "4?GxbA.oWq)?[TmklRAiDSVfKNM<[ijM*;^sB[ZLO0C\CoHn[qjq90P^<iA0'gccg/-<9U/ZDv*Vn>/gz*Lig+76ogVIE?C\6'[il2oD[.TDwievWGLikac**y}vhLNKu?rp?.7I]dYS_pN2wFwyAn]0a\Aj<K9c": a& = a& + 160
    Mid$(A$, a&, 160) = "6KbyMbgWTq))=D2UC8\r'OJEz5lMjOF2{*+b5FAo_M_z}ot0N-4p;T:5YM04F+B9cRPJGQ}jsyPiA3^Dm/iwG(?(wppU::UYawZQolEPm3r+DeaP3xL=eoBzXrh=GqyRu,WcdPxHtO=T9/y3ZXIr-1hiDK^(Ef}i": a& = a& + 160
    Mid$(A$, a&, 160) = "hLqNh^Sss|M22q;|J7ctTdZKOY4BQQ_=(xnMwOQUK<n5:)m[gX7aeFO(fzfX[;2(_+f5\|(F]EuN'QX3>CT?pHisfH}G}-Oy.I\d.]-=>{y*y<zSjxCQ,Sxs|vnHNTfvH-W*X98L3QI(xrfGspn,},[:73^7mNZ+": a& = a& + 160
    Mid$(A$, a&, 160) = "mgqvDNLnu_f.r^;25BB04u1PJV/:SUI-}ulfnyadg1r-mfvN*O^A[aOHd6?wAQZv5ei;d2GJP}wu)F4fn\:ysUY.R37YzZ1eW?_IqpaEe2ul+Y2o,9(M=jb?*r013:Au8KC91-Q|f+}{k/9_,.\r3i{K30i+le:|": a& = a& + 160
    Mid$(A$, a&, 160) = "AY[h5/fV7:BkzYN.>2ES*qWoVU2ZKI0<NsJ]<G7T}'EzU3ZY<;e=L1;ecT'yBAIn9;8^wULH9DDkg*20*KrU2[[uf+m_(T<ai>[*+WZCa.:HFA_BTkEc*'e]9nqk[Dzoo,7nKlx\);MO,)xG}qeCT8U;k{;[=o.-": a& = a& + 160
    Mid$(A$, a&, 160) = "VtA}w?f3(u6M:rYa_p4baYM5(7u[haz8hah*cKBcJNW7g4SjBXR;EZwvfGsI87hWG9t}q)o8GAsP/8MLsp{ghyl|9L+^fwUpdZy0(*iLJAzqc/L5?P;ok5cIi5Y{-=oka+GbDM+LO>5+C,'j}HA<-yD\TDrFl7mE": a& = a& + 160
    Mid$(A$, a&, 160) = "7*0c(|1?kVXC'jWxVV^s6.Pk*ufH<+W9uEnmln79OZ<Msj1)r(I_I0=\K{fy+zD|,[ATN6NCwM;{66]uR[p=yF>8S\.*t}}OQ0L->o,a[K23K7[ab\7}u3Rwyu24Q=z<*0I/bQ[VJ7nZOHR:.U(jyVwj'xmpsd1S": a& = a& + 160
    Mid$(A$, a&, 160) = "icUq)n(^V4cunD;G]B/OZkwDAI+|g}ktb{;D\t(R9oJ(AXmlMy/MmRr[*ik>lrmw[]0^||tCA6Gn/b}dZrrv_F<wfmqp}\[GT5}q0PREHKcN]4=R3PO>Cz^z_Ae1UDsnCnsCh,m'Y|vE,tdocrUo;HtUg^Eux-y[": a& = a& + 160
    Mid$(A$, a&, 160) = "1Uu>3c0Gu57]prfc_qsvSt/g)Z_d8dybYwDNHv(tSG\^s^>K.SqD-+b;TVR05Ej+oVg</=2==ZBmaLLwN6jg'L1RYhaMUSjA_,dj*;2mjVfzfgWp4W+Hx)\ExsIs*5Oyz'fX=Ob.'gc-51ok^T*E?gsO+s;p>0}1": a& = a& + 160
    Mid$(A$, a&, 160) = "Hec_dx7WT4[4liFtJcBrD^NjktX|E_9Ap'J-JWeX-3iXgEd2_,.pcnPivHoqK0JWktjYG3'1('96:nCxJ_/+k/K7/(wx|gzrvL8Vu,*O;ksEo^6F_L3gSjXrR0jd-cfLc+>;v2V=vqdiVFmFXVOO;?afv\6,T{/;": a& = a& + 160
    Mid$(A$, a&, 160) = "sq-P_'4(}.2ncglIxkP}>hykG;mME+Hi0{DJfYu5_'Q-Z^H3rhJmy|}na}2xIWk1?)N)Qx9(x44jGCBlC\'0NXq/1+t5A-/iH/5ExjqJ_5bUN7*2e+RPb>te{fR/3i(]ZCP'G374t\LUk=]Ja}L\Nv{GS}TjS^QF": a& = a& + 160
    Mid$(A$, a&, 160) = "Y6oRUWR1)gZCpT,SkD}ZAV:>XPnDPuCdW-|y_)a[W4tErV>[[ea3+JU|OFfU2>NMSD^Kg1:WRA(qyCZ1r?>:+wIO7P\g*{;6Z0PKO\cJt.9(7:7_F8zIjdA0h8aN-R9_7hYCWdjT<18evFl6I/Vp=7w4dgMnqlB,": a& = a& + 160
    Mid$(A$, a&, 160) = "qH9X^GRc?fr^up[zzn4F4_]ABnujks|pW|R9Y*F?lc/kik-,}XqJHL{kxCCRaxSpE),qeZvJUSw?^C05mj<zpH5]NuzZiGwpx?8SPvGRQLzvqW3+TEbI2V;glNNqj]C4Or|ktg7*rTlFqkT:*+Rm/kw1Jm)ekqH[": a& = a& + 160
    Mid$(A$, a&, 160) = "RZJp?R<}/e.3]cCd*PQ?ba9K'fe5BJkw0fiNo|xs;L*ldj=(bBeM8[pW17_q8]tCWQ<^Y*+^ayX2:R}_c,_38.>4-NdloS;/iWBbLcK,0|Xmkj.,8^nh:Dy_{tAJET<*4*Ntz{FHO'wFvct7PDKV'6Tg(zgn(MgE": a& = a& + 160
    Mid$(A$, a&, 160) = "sD/dfD?^VUkF{VYsP_2+Uv;DY*P]pyQ52cO043wu/byGe5yS6Or085zd+'Dzh<M-zFh}L*cDw[FEf|X8O-_|TFqHm.ZKN6^+li0pXzt>jrh3]2:56K)s,1azaz)b/68:ek(CNiuEaHz{=Qy[^8<wA(/:cBuonR+i": a& = a& + 160
    Mid$(A$, a&, 160) = "]sp8{q[K>ty,ZuPfwsPnQM3t+\OoPRP[KC;vV0TS'(7a}=l_s*__l\YPrsmg1{,OhukFRgFOr=I<(=oowa3hbb3;u60OFb|awh.Tg6:L]QY|7caID1prYumC,yU..xX>.LHyoBJqw9*{7'oq6:wOu*DM*+I4q6*O": a& = a& + 160
    Mid$(A$, a&, 160) = "p4ado/zd)HdHF8(Of018\w=''Tpm1+EPp\}:<YjbGfitCn?{AZaOt*pWwe|(XVmmBL(mV-l=z}kaQv[ni]1_-*ro_3dJ-K(<qkpaPTdY?NMxT](ro,oLS9_wVOn,s<i>/uDzm<iyjP<[JW]n20(/nHmVUv>Fbr>x": a& = a& + 160
    Mid$(A$, a&, 160) = "05eCO?McP]>ck]lhe{hR{AF8ltede,;qpsCDbGn'O[*;?ftOGPZ]O_(sWU*u)1\dnLd:(:b)u=a\6nJJMFk\bXY.xiuI1GOqWVcK'nxD1oNjC75mc??[Fk=VZtw2tmxy53^oN=PRrt>5I:wvn?914CA*cCC2<N.u": a& = a& + 160
    Mid$(A$, a&, 160) = ",rfjz'/msT^O;Nh0eRiLnG4OXpR{Y3hgg=.=hRJWkt+dI}iRkB[0z-x1zNBPX-gZ)F5'0bm'7)dZik*D3'K:dW(eel>:*:W.GR-Y+mfS^DSDjJ,x</YTDzDCBBNajL4DIgPwBMIq-B'Of6mDq,71N.hP]bh\lXo/": a& = a& + 160
    Mid$(A$, a&, 160) = "6jZQW>x>}B74mWf-6D>JK_th9VBThLUOMZogQO9N;kaghP:[5^a+d]*w3XmR[*9hFj-1?-r+24ls>n6eE9+8k|NyIm8AA5nFeKOtd_/Cjy=qT_S0T2ZzdkmD}=yb??M)oBQ)YPRob]qj?JiC,4Ajq;L(C6pN(0xV": a& = a& + 160
    Mid$(A$, a&, 160) = "YS;?Btb[*PhCb4Gd[Hy6[TdB{uuKE_b)?Mrz^8<8}zAgzdxVlcjG<{asQi.gcl>E>Hq'HmzRxC.Y,6Kk}>G)<dwqEuQ*i4x6eEclt8/f3,,aEwzj.M{-kd687z8*4[/PB*LCN.V?n>E:0<JC{lDPYWXjVr)NRNk7": a& = a& + 160
    Mid$(A$, a&, 160) = "PQ}22A2P-0CyDBr+iQLGS=>?Eam\9{|,\'Or2rzal-/AroSRSmKhp}N)j9X<K'quNf(z>Bn<*D+n-6P|LyGa2(u2f?LsLVS_nPW0+Zg]|7g*q7awJta,=K-R<bwz:FVp4bwW\2u2APUkNul)OEZwE*;;g]e8(xnu": a& = a& + 160
    Mid$(A$, a&, 160) = "RP'8HopkjPD^Nqjs/TMazU]ku2(85L3'K};8:?Od3Oc92=f|hf+9La<.8JEuesmO{Hp}O29cR+SV]b{]yJS50lBwC8D:.:JLFYdP>]2sD\^]DGy-OX{zGn^Qa1*-YtKu^F|+,_+n3Brmh*tLa\,AMX\7.XwXR=9X": a& = a& + 160
    Mid$(A$, a&, 160) = "KNQxoGE]E^TCGi'Kw(ybOloblsWjd0oFgDT::_cs]i[*7-;Zc,1=fS?;?s*l(+(.Ts]SYi+bcWdBgS.dDgL:_OJUHvd04nS4Z/2O[.<1,?7y{E*Cx-HB3N;ozFolLug1T^gTDBpX+jz3A<9.tx]SVxlN}/\vifvq": a& = a& + 160
    Mid$(A$, a&, 160) = "'.DnC+sbQKyBTlkyiYnqo7ihqmw,neY,(7O/+8gXD[p}wx>yZ4svHOrj':I\3-zy.OGDQ:85icf^?IE8Py\)cbA*y<1LsGpN8sxK6]x.fp[+.;lQU_fPGAm_pR5:bc:Nnr^qC?^YpkyX3tT=J/Ki610*ixv8Mp+7": a& = a& + 160
    Mid$(A$, a&, 160) = "INiQ^k7<U3;7[}aI9(CGf3XIp.']8Y-SgUTV*A-=<.;2bj'/atvPJV='Pvg:[nz/(F:w8,'4W^1^/0m|3RjK?|Cg,.e6pkJq_auPpI[x{R*}D}\<_i:Ay?gK4.[*t^4e7Red?}:iDQRia][ALf088V}^qTV+ng|m": a& = a& + 160
    Mid$(A$, a&, 160) = "5d,[tu3U<)egK1<th_8NOK':>qP'I]6pcH^9.-7B+AVq72vC\8Ywd<[1M_*r7EhM'Sn8-'[JQ[}*PIB4f1YE.W.4SvDo>[=R)(M2(w-G,zIH{?Ppd0Ezv0U:YoZ\Kb8mf4FN1N7=(Wdq,A<o7r^Qk8pCIsTSMAVu": a& = a& + 160
    Mid$(A$, a&, 160) = "uMe,3s[[Z\Ymzi)4Aqj3'gBs.J5g\gW[Z3r'x/'\V\=hNw.vC9Gyz3pSZm-=Q0KiAK<?\LfGc<\=/?VHB/;6zqdKzeev[,HwICJFW;]D2xi,:4YyEy:I^rN,EB'-sGulCYccrg25oB,LbGWh06aqlQ-BK^}..=qT": a& = a& + 160
    Mid$(A$, a&, 160) = "z5*lBjzk|/(4c;*l=k^IA2|7izQ>NgDxnh5\Kpcg<]qVi9-5==aRE?xvqF}LwX0nDlyx,_V_b(t*e)+?p]+HU==oaHq'dj6VCxv/n^nJ8n.Lf^fAjtKyv:6AJc(g^?+YMC68m|TDtuJHr;b*r:'KsUjIN/JcE>[n": a& = a& + 160
    Mid$(A$, a&, 160) = "7E+M[c4MgZzx\'?ZN<k?'gTnl|Sb2[_bqvGbmU=f?p6tYR-]';B=}AV|bxx(wrvCyuoSYeE-sp<:Awbj?hIaNIHX.LKmR}Jobq,3N5D<,2Oo5t|YOZHFV<0Bv*?=h5cIJekcOq.nA)(0YiFPL+Bq0EtS/<7jhLS(": a& = a& + 160
    Mid$(A$, a&, 160) = "n?];_bpzL[}70D=PQ8M3zXYY0eF:uNqds'alOQL{Ryc\qd5d8.t;xXfr70b}PEoC{'0Wkki]8R5j_Z.K\ht[*P<+)aI3ER*HA]2sdO=f:0P]h+PZce<.VH]nC'|XQ\o1w)wZutKyqUb\65b:S'.C6M:h4Ad=jygl": a& = a& + 160
    Mid$(A$, a&, 160) = "pUIql|,iv\)PU/q\:Em<;6DXtPJpsSQtXe.at7b^)PV+-?'xBXI=r8beiI[8j6olE^LS3,9C-wq-Np/kAnyqNtfMqQhWdNT9R]h(5{2D+Dh3.\[b?Q'\J<G8C4,u+l-lZ++ep}?R]^h,Z;ej9I2n.[fP62B1GKU3": a& = a& + 160
    Mid$(A$, a&, 160) = "cA[x,3k{T>5vV',lDd>wfT5DDlQo9U+pFH)KWy.E.Rj_ug(,x}h-3=HMMz+=b>KpIrvhbtR6\<g1G<c>94/sO194}qS>xDb(Y<CN(>_'yf\.o64Wlb5vgmrlg./|FF13a[_E'J^RIeJirJN*71Xu455Zy}jaQ'wN": a& = a& + 160
    Mid$(A$, a&, 160) = "QUU:BxC)^^_k?CKcqJ9Hp64.|(9ZlaLD,g7>jUep5H2FL;3Gl:qXWoqvw:p,OQNiQN.sL-6pn1r6nAso)sJ3O,A\y8pUcSi/<nZYS)a7ZJf.bOR;f-T?j]Oe82{qixH;E=2+\r16+T(+]+Ji7vM(Bd{\_ACk(n0q": a& = a& + 160
    Mid$(A$, a&, 160) = "IM9DPo==5NCP*M6Vs{LF9=4BMKQ3khW[ec?Kp=j<UN}wCtmt.XuCh43j<0BuZfH)L/2Ub/_GD[0R<4_iE;BCfOc335B3uY;k/k|-lkyYIR?]K\onqWSnw.=[SacTNG;_|;[GB**ir<e?}wp6k*g{;j.z+eN6qVDE": a& = a& + 160
    Mid$(A$, a&, 160) = "N6?mR8*>xbL>o:>0t,i=0J/,S{tB/guRffXr/ij72Oy^[n=Icq8>F*dUWfcf)m*YQhrbp.;V.i*W:*X=DGU)BHRtZ36n7=B+IP]kZ?Z3YygN^uVv?Xd';w[e}K.2'F\P_v+FpM?]2d6hx:+CIZ;}A.N(l9R^d+;=": a& = a& + 160
    Mid$(A$, a&, 160) = "\(R(H65mlO7qU\cf1H?d050P:.1NF]J\uE6sJPnP(VwSbN)73)T.-zO{Zzo;/9lEM(B>w]2YK0L\Wb,L,M6S{,c4(7]/,qynzKxUy<vSNnt,RHC?^}E]F=2,:Np\'^SXL-8R+:C;Y;/yEd>p;y'd(L\dY*X<QK;5": a& = a& + 160
    Mid$(A$, a&, 160) = "g7nO19y4kGPgO2P}t'/oQE-n{+z}DApCR/xg85Ta==bhX9<2>7A{5lPgSqi:2S:\X:>rbn5ABHi0FecZ_lszqrx0IO:v9;gI71JjPXz*iL0h1]y4kA5YLBwH6TNoPx5YiHrOv0ux8Ca}TTdJRC-2.x?<ol8?1C]=": a& = a& + 160
    Mid$(A$, a&, 160) = ""
    o$ = Space$(10238): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N14$ = _Inflate$(btemp$, 11333): btemp$ = ""
End Function

Function N15$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(13401): a& = 1
    Mid$(A$, a&, 160) = "0OE[6{uvF{uHwu8;+.:}2^ZgLXIbkY.?{lFg8Vc=*UMe|u1_KfdD|0A;Sx^vZ>:,LbP*6DhD8n'[IHHEZx]<Pn[/d?aI5E|+wJ-FZZdLMiZuk+IsWx/}e_8dzE=lh*Dxn..<8]QCy}U5An<Ic+awZ,Cfcr3N5APf": a& = a& + 160
    Mid$(A$, a&, 160) = "I>U63/?SeCsBtYHSjsYWrxm:|1K/_Xem|a(g:dxE2.v1wXYqC:gLY\IwG_dtPRo{,;n-^wQFE[r>d7I:TUs<(cIKM]4]a'Keq;-7F1oQO;J:3<?:-VXN'0IBGXPMsUbP?>2UX>687a}E8nnY*XNA,h{Hx:J+bJQ^": a& = a& + 160
    Mid$(A$, a&, 160) = "liWZ]Di/1'7',DX21{GpQ/\r],iA?O]Rj}8qq89J|\SzO7H,iG+*l2<,C;f'AYG\zV)YdKMU_ad.J;Gg(F=p1nMl|]\H(:J00N2XL^6O4CqeXr?Qpx|^1m+b'+b=mG9tT.BW-)saix5;*,B(AC8IJsBn;-?lJN];": a& = a& + 160
    Mid$(A$, a&, 160) = "xcj.T]+S^[0)|ic({=/G^m'-)brSjRZ0[k,{l{?,slZFIYaA8S{92;<0Nv\Ct>3)Rl+S.x6B='}>(('8^n<d'w*;RhZ/eF/)a29Z3m'(OGhmefMr?ba4'20n2Lk|zwdJ2fqS,_M]I0FA2-\{Oe5XnJ?2RppemgKN": a& = a& + 160
    Mid$(A$, a&, 160) = ")Vd.p|=LCMt56h^Q>1qtjbfcK;b<dZ>osIu,\fNYCgQA^XIrxMJd6R6).D(;4o\LZ,<{M_pjAE2rLfvHSNA2pT;iEX.lZJ-,M[iz(c<UQO'o(hWuUj36gk1Zzrps.Pi>UqBYqh4Ma0|If7rbWOj{-buRA=;(tDHu": a& = a& + 160
    Mid$(A$, a&, 160) = "?j9Lexq(fP+]Rb_vw->VBvmaB;oHmRyPz))U=+uB3Q/gAMVId]?=]px][;GE_.u=ONXK^PDvaLfBGn1io^Qo'6E]m;<)Cf2xiexQxeSN4WowxV(yln3DuE\t*zP*V,:_*zu[Kj<jYTac>Hu)f<3_3/5CI'^Wh:;{": a& = a& + 160
    Mid$(A$, a&, 160) = "0)OW[OkU27F>7q2Uv{QnqJR8j+^Y{cm]f<QL;NwnXQnS7h(GQ*FvAO;92nPUxGI,_j,,S/^MF]DQM>(Nlf'BJmab+4SNKHcC\Y4*Arh'ZvJlc{y(Hqk6?lo6[3^Cc5)aPipRdvBaDEMeINQ2t]jxonWbSyX-5ul0": a& = a& + 160
    Mid$(A$, a&, 160) = "0'RP1AZlvl*_-HH(];uqg:;1yig5p9/0u;YlD/4E[[5.wk{-Lp=7eBcDOq2bfmN+USUp)B9iB)NJooD?E;>x^Uo3oo?b7TxQS*oTLU:_jT5BOv_VNV|MH1R+D1z;+N/J6Lv,kxj{w;|g0.CQqcihfn\ouSVGb\8a": a& = a& + 160
    Mid$(A$, a&, 160) = "<SWu\swRFe/X_c=[d8*'/DqK40u=Y{x:3wjIuR/Rlqem>e-ba-?fg[z]=28AKUhk{.udt|GgqOho.?+|1jPRR-J-xPw-lR=.<YLr<ueMDLp\TlDIvl;M>|L)-2fNOEa;A0zfqUiLcuM6<^FeP0vqVro\5|wMng(\": a& = a& + 160
    Mid$(A$, a&, 160) = "Ap3o{Y('M}JhXa:>]DuW[m5/tztIg9m/xd<6sANC=9s+CTSpL-tY[-pZDxePu:<-;5p-t\JFD4+lH?aMu[2tuqEbpbcSmj/TrWNb]-dxdO/ZNNQZ3dA20h9o<;:Ygi4LnCBZ,]xImf})aqw)7zKJ0su[Cqn7ULTL": a& = a& + 160
    Mid$(A$, a&, 160) = "=\v[m2BK_0VAxY3/5S0=2WPMI0]6s?>DY85(DCb;JP[/Cg.=2oGXu7ICrE6p<anbdZ79PGu_g^g]Zd}Mw+W{)a^CB7PoryXG:WYqBOTYuT<7H_a2f=y6T5v7ZUwL5lNkK<Z62N}/j^Q;d3G(cLts^q74|ICoKy]7": a& = a& + 160
    Mid$(A$, a&, 160) = "<v/Pr<M0\<jhTBRp+5d9-^B3Qy-0Z=(kMhZ[6L^*/h,yLo,G904lT)J*?8>N2?FPoYH5Y6wq3T7N188OD:FVAHul[nt^hrKO23ly<^e{fCgZ:y{zsZXoN]q|<WL[+1Cu((I5)Rl^=}<{pjwS?i7ofbJk1>yVB+Us": a& = a& + 160
    Mid$(A$, a&, 160) = ".05TWq93be]6c}GS9<n]r[_4hcbMTx9A.IBTF-_vSHmLp:M22VE+T1jR]\SEenr|b}MBM61MVyt>JAC>yQnCWg<WknFg1SL85E=}67Sc.{+V.InaFc1T+>EpcZi+-)NKYAbr.Y:U7S.w9qtL6{t/uEgu{^|.m(b\": a& = a& + 160
    Mid$(A$, a&, 160) = "U,^nHKr0Xsl=|=c8uo7hZ9;;46]0tl=Va9NcucMSYJbHvnb4iy6YT1-Raw;M)I,lLxg]pEOv<Fb'^ul4iPLH)<v<?uFI}2vBsLP)M<tC3rE,_8CHd_?T,-}ZYAmaKDRsz)=9*0eVj<KW<.?-GQ^eQl-8eR{,l1z7": a& = a& + 160
    Mid$(A$, a&, 160) = "nNn\^ijUCSLLTKbK_n7CQ3Ly9LHM<,8e*hErA2'z03n7}OPPXlLmD|uANne,Hz}|No)dBU{dEG[gad.M25O4v?.vJaOhQ[k_>R6{mL*J1]?a3u7XE/jyzgw}lu-sCkG<hP27i(jl]r8|C20;\)k-m,.t3[C7a4/\": a& = a& + 160
    Mid$(A$, a&, 160) = "dR{XL=E3e^E[a.Vyqq+dd8=p.j]x<EqEb=k=>b{W,hSrr>;|e9;HQhk;]cs+C0)Q}IS'{4C:<O^4RB,_CI;deVLXXOX*dP7t/?.-]35u2Uh_8ysHblx9U27dbh3CRto\_qCF:.{Admk_bHE2CG]Mn1v(LO'HhVYB": a& = a& + 160
    Mid$(A$, a&, 160) = "yGIF]-TW+vq;Lr'[[tFSL7_6xDk+e.[eRjlJUF^DW]cFAAzXZ-<io43H-\S6Or[T5F*=05J9.+/nrTvL0YSVVQ^Pz)Lqg^4B]Cz4)eXtg4K^9+b1tOPNvK1n\rP'ar>*O2N,WjJt,QO]*gd)3gNngCG-bxPqOA.>": a& = a& + 160
    Mid$(A$, a&, 160) = "\FqMc{>SnT|<--)gl=;Q'?JD0eP;]d4\A)+9XDen2E'?7kL[knNUh3'g;TjGuq=7:ouw6*q:BhrO<?zwD'Xy-o1+VTIncZ3LU6y=2'KX^}h;PF/7'ctNHHqtT_AcJ+3M\\dXnP8ksoXu2md<5Z^m/m.8Tdl\?<Or": a& = a& + 160
    Mid$(A$, a&, 160) = "V;H[<;r=Hc;3g:eGQiL\bEifB]((0b'q?>T8bB{<pNe=TQcl<cmS,|v]gphV|84bjg5=)z[YEo}WHtX1b;uA=LGgy3u<(E7=?s/?s/}YOE.,IC_W(0p+m)'[6+0qQNDyJ<>6HCw,JD)cw[6NWPF<:Wy0vm:^D;;D": a& = a& + 160
    Mid$(A$, a&, 160) = "gDi/RJpAABtntj}q=yav*SP^3{rz40vFC{P'bHYEprbBmIs|Tq7Z'5<WeSCe2F3)[Yu{H]WjzxMmqr?Ym^N0IsaC5Gy<[[XmOiRDkOsx)H_)x6Le.]^_.0j96etzzTY\4u(WqY4n{2VMKd7}^gp2vtD[e6p.Nr>z": a& = a& + 160
    Mid$(A$, a&, 160) = "*Yz2y3=vh76DLzKW6(52KT6Nm9utXN/OZ)hxV:d/j4,CvMMM6Mg.rT-F'o3^tNZ(\38nf'3.P9a|L2;RQ-;;C<pST_RKq<w/0G_r,?vNEtk]U\uNMEreECYR,4-qi(qr=n_=Vqu4eBL4q?4X{Dywsgf/{<ZCpzrB": a& = a& + 160
    Mid$(A$, a&, 160) = "a5\<Vm1-<YQ>K3Tp7PY<*'K4TC9,/8h;?Wn40]FbI[KgHi7xnp-9iK<(GSKYz{**anJHD{ABV;hqHM10HM}DJ1[9.4/zAT{l3D,.^HF]()pyNU{who+vBQ\lYAP9OHLld1M*z<UJf{U/aMwuq5v4)O[aTWlx'bb5": a& = a& + 160
    Mid$(A$, a&, 160) = "PRk[.lT1X2m6Cj9W4xsf?BxDy+w<p_mL}Tz?eOl-n+yZiY\|YgzSKM8m.wVo|K+ecd:jya_COwPu5weLFq(ey68)3|WQBqp+PUyZl(|]gQklFU\MW<NLO5I=)(k+.?twKGdn2x^^KnAlPL0J)d:J6acrp?hgAa4E": a& = a& + 160
    Mid$(A$, a&, 160) = "/\aX5iYDUp43q2h{Pn9j8HXwPlc_':LUSac)8q>\zJeFfwgN}1dDBL4U+>;kjD9BwqgAt2lVR6.]xGdnK+wB6yeUby)bXvDSmfr^nj}Kb?n*X(y'H^*a(nCLA_6q3Zu]NG6PGKd?_?N'[jkQj-^Q/Nx(d/[0xfq6": a& = a& + 160
    Mid$(A$, a&, 160) = "75rjKYOb:iFEy1O+';iW?8FN*9?:3N1mJn9m7Xw-mCcj+3lCdi<R8A|2Qfxz0HQ)mRLVp^5A{>:obgB:8AbzFM4?oY,[d)mM[cA-spGhfU)4_lK'NVwPLNt4]/UB8-<.L\2dkfB3xvZN5eTFK/bZG^|cn|uaT7?D": a& = a& + 160
    Mid$(A$, a&, 160) = "M_keT0'RHen05Txf6|b<;a5Wag6F3H?ge_aKHl>HR*D.w4+(3pD^,=9M,(s2MNQcUk;rOo8jc=wM(JO>1d7mQZv|K],MhUZjum0HzcXXs8QM}.3ymx{)(gi//rA,?trc'\urRODlRMIl{hFG</ScLCcPY)U,c|Iy": a& = a& + 160
    Mid$(A$, a&, 160) = "hOqhK=LJgO[2e:ff6XOu|-SSeOFf/PuI\5JLKve6zHr>Qgc_T=.x_W}9cC(Rt=c>PU6Rzr]ND;I^D*Z1HwdGCVY<}N(Sd>Y^4JB]CRU._Sfir*ziHnFe=Soka=Pa(ucZxF?Nu>i(],A}S42w[A6SJwSyn-=tQj3u": a& = a& + 160
    Mid$(A$, a&, 160) = "Zs3?Iqx35kXOTeA?wIJ>efaDb?+ZLX\cA]g6xvNfLJPcARH8k^8xNqj:lm0^YVy'wI'fy>L)jZCy6\-=DRoFwU\+pZs,-,,+]hucb=UjZr-]6I7et113VpY/'XmNI(Ehb^gC8|BAOVw?y3,]bh:S=Lx4DGxFeO5,": a& = a& + 160
    Mid$(A$, a&, 160) = "Wrc'M,AQ^dKr1zYq,.+8*+nrmzm/]6K4\[}[HJL;4*O*SHk_ZqO*nqW}<VcQ_kdX,CF4Z,g^opv_Y1C8JoR])?NH62i0x(*|7mrlrYpI0d:}|l'/x=:BgTmVCrph{'oeJ/;mdOsVtqj0C=P]Pnsx)2d=,23,q<wn": a& = a& + 160
    Mid$(A$, a&, 160) = "|]6Hib\J-;7Gl/2f:>|^=A8'ZkR*-g=zdt:fGqV_Lie=>O9T9t6._3p|SQln<9:8xIdtgcMp.4lm8|Y50';4_}oI0GY*N]4nA?j=?f/_|A,'>8T7Zp\D1a'fwYitKr0daW>P\?Brmeo.l?I9RZu5C3P=N4wztPoV": a& = a& + 160
    Mid$(A$, a&, 160) = "Vfp3|nweWkdfX}PSC(/<wmPW9>Oir:^(Rxd6</EYjLZkP]xvl6lxppK+xF.=z'rIOVrGoWU/eZeMjHOh5^AV/)g*xLSb1<d|sK-5WReq3|l\oanxV9{Gp<RL*zfmkJ5UNqr:-R4(/)sqh_?|+)iL7j\1hPi?3>PR": a& = a& + 160
    Mid$(A$, a&, 160) = "B+\bCZ'OY25f03OdC(T'Dng:rsEY2RNDeprd:kZ=49W,FM3?>tez/*rcq[Ov-GxfW66Irltjd7SKTCZZ\4kt2f+k29B-_otSqCAI2YtuGd4MeQEwW5g\;5Rl]76Slt2SYpatxfm</gd\f8WtAP;;VkliS,rRNIs/": a& = a& + 160
    Mid$(A$, a&, 160) = "I7XYuNZa)kMw'/TDw.E-1:T6d4uIBJk1'C>dB\Ak.4WJqQDi,rB*=WoJC\lZn*|{/[LOR(KhyhMqx9sV9lttC32PzfhFp[fBDt0]SFoHNM*=zm_;2^4WpeRbPujXb08DT1,oQDEK(*n7;1E*1'YuBq'HfI}\1h^=": a& = a& + 160
    Mid$(A$, a&, 160) = "e,ib.A-0<lWmn[3[4UY{}q]92S+=\-I3P+=[V-XcI4^x[fFd7Eldg02AzLps0*D9=AiPp'\VT=^Jr>qRE:=s\n0/\|e9Q,DZ,4(cuhf{k2<eoTVZmo1EXap74=RfgLk8i(rL=nAWPCB0m=lRQMlqJ*\[OVpaOoV5": a& = a& + 160
    Mid$(A$, a&, 160) = "gw5c9Z\3te_'k*rZ7e}_AsWR99\fuQ1wJjyWQ.evu*'pqeh'y5ieWhziM4sK,RJBf6aMr|}F?'pqJCk_^o}BrL5wzowugu7JD+Q>M+zK0MuWn_Bbj0TBZ:[6|+U6w[(VEZcwHLQ]qXVE|2KtXF;udUM-h<c'JpRm": a& = a& + 160
    Mid$(A$, a&, 160) = "GvTQrIT7(,oQn?X2v6\y6dU_zwtaJj'[PY4pznGTT-h+<fMJVmaa\9U3J}n5t?{EBfIW,.}(S,9.O4uy3<CV^u0.wDektjvi6y=EJ;L*]xFTe0n)h^]M[W/QmOFLuP+<dxT1|wJv<WQ97RNyo+OVwSOtWmiBm)HL": a& = a& + 160
    Mid$(A$, a&, 160) = "Z=5pusfi;FfWptOG-cnq<=yPU*B0bB2w[v;8v(sNq-o;nEkc;5+HRmyD]}<1pQyS7G<L-[yFm^,(OT*=^_7hUH2:IXOUtCJkZ<4)OFXpiF9mdFv'o/\WWYBL,.4LZm6lM[omh[UM>I6>3H'}]Zc3c75NYW0e8L-{": a& = a& + 160
    Mid$(A$, a&, 160) = "RO]O(G](6Hp1\uR4s?uNn/Lp347n-F|RpPYWKW>qqW}=)tcDH}?LVSi^80S[lL6yyU/JlOq;;plUMF8_}4eAn}J|coRQ),}rtM/Y55}-{8mXYk5nQiUTo8s5VEQ_wXNQQLlU,OH/<,T(7*<?|]E'XsyUC>C*'mF*": a& = a& + 160
    Mid$(A$, a&, 160) = "Lzjw8U_)uIM3tjM^-^IL2q>XH6z}mw>g_)Z|,s:bz(P/2-AJbG6**^6.GZN)+x_E:qPuOh?'e4]'_Vu]}1G'a{0J4{,KCMQrcQ}WCu\[*E/u5|0NC*LX5[o-YLb}=\b9tiC('xP2eN}{St}guu-q*wgt)]A{'*V0": a& = a& + 160
    Mid$(A$, a&, 160) = "?aJVn=2QQ5_b8{|b.XrfssVB.Z(yjfpPcH2SsS*BUPiBE?xp_|w8glq)]br^EZ}F74O:qUWgOz:Bdo+\PWlT'<sRfw+0O+U1;\n9j\6w1OS?UrrW.=QT-F^g:Dwi<WpE^JS^oABR0bIVb*>Y]05/T|/O>O,P;9E2": a& = a& + 160
    Mid$(A$, a&, 160) = "SqUp8fao[TX75^Qs'.tH>GRc*UdO1(.Yd9.kO}\HCjhE/)38rBBOvRTM2C4;s6h6m?N8qPk/6aPI>7ghwW2<1SOsvG1f'diSz5:0}R)ePJaQ,)+.}GM]5rXyxM8^5G>JGbZaC)JOkJKO'bl[{|ZIFqZQ<qsytg.X": a& = a& + 160
    Mid$(A$, a&, 160) = "ft;?PBxg7xG0rHQVYXq^=IS+-Q**Ekv'QYY<-vJk3(P+ji]uynk-28f^ixS>[cfq''gZfXF4}-Qc4'VYGTvsbiPhVGcm^T2N*ejPrrzjx8pQx6(G*So*fFLp[om.vwF};u,H5'4J5n[txS4A;B/r)}PsMv/Q]_UZ": a& = a& + 160
    Mid$(A$, a&, 160) = "uyPjT^mKTHpTdr_^7o?RhUlrcK=BNm-U?*l)H\+F9p]^>=xO_}C-|e^}RV\BKTTMkYBuC'DFs3hix^QxIswApCa/y(Q8yVo1E86b5L=_hrW:b-*a'Sm/f7a(fbr02um'UezmNw)-2C\}4Me7l].gS;H):2Gl9m4T": a& = a& + 160
    Mid$(A$, a&, 160) = "2l/w>s4Og<5_VJZUQ)-iZakOYN16[|Gm,hYo=nIkjlJjt{xD/2aD^+?wo.RT+]39Umd,y{8(wV_usT[kI'n2e:gq-zlH6l7QRouD{AB*fh2GD</KD<covcIRXke[7,die]:oR1Ww(2>{Y1zOLyt7|dp:F(9MjtsO": a& = a& + 160
    Mid$(A$, a&, 160) = "m]TTr<QhB[FS</VJ?Z>;:UQ<r?QEGiM6HA+=Nj'/LsBFPMAlT,FMI<,6B{,:iaXeSgw|tgzikX:>,1s:0MFOzT-CG8^A?is+D?}\n'22i^M_+{I<jV=._^\-)Om3x3e_gnB9lzyTAX/X1Kjj9xV>*|r?ajHQwJC,": a& = a& + 160
    Mid$(A$, a&, 160) = ".*i*y/DVeLPa9\(>Y;CwxUk>tv>1c:FWwe})RF{yIsPt':bkkr[:j-W54f)uyxmX3dI{Gz|KtviyQ_W/,NdcF*r)bojFf/NZ</x5OD-(VpVAqKMQf?}g9).l|B:GgeKml>[mLch6XI+JS;MShaD(ofp9e,I?16F[": a& = a& + 160
    Mid$(A$, a&, 160) = "+zCDfOQs4'.m.gcdF5yV*e+C=IHlq<Cz^.9uUYK?A],'X[9aTHz^1,;rHxV\q:*<YWmX8Cq==H)ObMR<fkUK}YAxZzLw5]QZ:MMdqDPnByxmY3AqK>.u?04i-,Nm_k41R:ePBqB<3wF^q0mG-W9?|\{jo}Hs8nog": a& = a& + 160
    Mid$(A$, a&, 160) = "AhUe3LT72*j5DC2]ojj0m2X{*OUpBB=c:KbKKhl,4:WL2b>Gzc]VAP'N0s{bRTk/K2D2>4R\Bwi^+)3\WF2[ecw1fZQCYM{S^Tni/Xs.Iksb*eSY}1[>3Wx4XxDcdHKzU88.99ReU/iTJN?LM7*2Y3>'7YN?9PCk": a& = a& + 160
    Mid$(A$, a&, 160) = "}bh?;.[+H0|TCyunN^fCgjd1J9+IrDlG9r=9r3kJ>PtR5Bt+z<,Lp5vSflZnVLGF2DVGquK/H/yx_[K8wT;Q=;hXpE^?]01cU7rc-XfO=h9m+Q+wi5Gn;z8a7Ty0PI*x/Mul\,jBhclth?}9d/]1De4Mj4[r)|ed": a& = a& + 160
    Mid$(A$, a&, 160) = "<7:4GzxRa3nGQ5c*8H^D/O>ZCQOHf7(Y=Vyym2q,CzzZ]]j(P(gC_baxTuy9O'a|kGWc,uk,Cg{tri:lA?wIq}z7:ZW4RigcTo/zP?1R}]o<Ue}OsH*jay4}s5Z853n_sb{GMr5Whtnc;R}8;djkS5pbv;Hzf8=V": a& = a& + 160
    Mid$(A$, a&, 160) = "ljmp<:J}'p*^UqMw:J*(3/^rgW8^M,n7zq<UtEow;Ck-x,3zIucHBXV-pIpwx7.+RETZWwd+Tcv>;jV9-xg,KF(=XtZAoY-J)E0ZASl=la8tB-q]1S0ru7;)[uXZ37lNP|*s2+OnoNYZJNLHjCJq15<bMfwnHN\r": a& = a& + 160
    Mid$(A$, a&, 160) = "iTuBO8',N7[S:KhP./nNw-cGo=xQ{fII|pHj3QzKu2a;Kif7Tb,N^_fAlAyqb8S\u7;(472Pv0}rL}15*MDHZfI|E]gr.kGel>]aVe[Pi1pUW6H_)F*Odgd98uFYOvbS:B01oepb/5'OFJ'=pEYko{buLYI\H\7J": a& = a& + 160
    Mid$(A$, a&, 160) = "|x3:d}D.n\2,spF}OrX\H<=R>s2zYe{c4Vk0]r]iS>6{Rq)b'_ygyd<hlu(G?-|);C^Ai|ZYBoRn8Xdg(<*N4\ii|gs/VAI5Mx62cQVk;d^zjbMI:-:>0XVm?lV_hjFgC[Q=O.fknn?aqs|W3'cvr7m.xDGgvg8i": a& = a& + 160
    Mid$(A$, a&, 160) = "-HTTL<a'YoNPXQ5PVl;4q/7cQ9pZLX+ZtyOL3XZsuf]8;2iPK=w5M1zfCckbjMH|qc0||ItbcYfoK|xjqN5mnmVD{.71H9}maY0nuI3LyP[l:P:M0)2xxLg:x]Ylg0<64YMc\J;Rg4X\L+Q{QyR=*:9XLH^d8(_U": a& = a& + 160
    Mid$(A$, a&, 160) = "YOPj_BYISiAI_Rt01:7<;TZuU=[cQwGZazA9hqq9'I6W(vqM]<QF7YaG/mIEiW6Yp1aRc.QxjvffPbhl.vM(9m4R4m]VxVR_.kO;k'4U|-fvgz<ogHI_Et98_oG+l6<Q.2vEal:F^U2SBlAHYC\U2mw_mSX=vuqP": a& = a& + 160
    Mid$(A$, a&, 160) = "D;7{VPU_dlGVP]K73-e_EU_HS{7>+(]kw6mU=jPYi5+/XMemQ<DxqLlSJWp)>oJ\X?3J(0'.IcYbX-Co8pKeTmK=6L*]XMG2Sj2R;0DW99nB6Cl?Ce'^ja^r:O4giQI4o\Gn2Fe(a-{O)oJ\{ca?;xXN8Qz5qeuE": a& = a& + 160
    Mid$(A$, a&, 160) = "A^iEg1WdsDj)4^HqKL9-5*BrE-'Tm{5gIvRjeV|5EF9iuOy{vlBl<4lg\lx|}D3_eO'D:jGI,l|fA*pGJH|pb3D)c8pmdAu(j^l|4;O+b{4k<v*_?e7A\iz5rvQk|)+g.EopdoMcj},MpfFVO6*mVS|>X8<(P^lW": a& = a& + 160
    Mid$(A$, a&, 160) = "2^8YHRVqA7vmk{<B,F19-k9rs39|E_(Fxg+;k)3G8Hzq{Ru,YvqpCTCH>P0_gS]|VqE989,-4b;3f*XExXH-M7lvR^N*+N0q)d|inFw<5Sw'(uh?MdZXycBhIt1[\1Es2BO7ax^z*5|]=vLLRB>7g28sq6ZrzhW/": a& = a& + 160
    Mid$(A$, a&, 160) = "HKy,VzAtS|4+[9FkD;K\;4Bv0:?aHaAOsmVFM:PIOJD3_(G'<x0*8[d<EV?*SbYwK[B/[+Kb;Ee[]aj]Vo<_5]zXF3r;h;W<*^;E/Xvgk)-BX5<f-,R_rc]uY(jm\QTitv+X5,W,?Eu-E[:|ph5]3NN[/I/1_\s?": a& = a& + 160
    Mid$(A$, a&, 160) = "tE,/l0E:Xsg3\.-0;=9>rF0NS4F9LA|Zfz\PyhAyQ\=pp^*]XOyZ:hJ0HZC_|>IOMd'+8?3MlbwtoRshOLvE:t,;G-_6igPRvCj.H[N.rGWUm,\5FiTpR:xzs6*{J>V)<is/wxv\<0TrcL';-<z*baR.ddo:B_Zc": a& = a& + 160
    Mid$(A$, a&, 160) = "tWjBn+*rIA1,S||3B97z17a:^WeHWZ2tgM4DK821LBP(u>/N5xdedYkRvl]q(Ea)41k3sf)UGu5j2i|MG(+FJHKPGf0P^2M^[eT=iPHhh?:4rC0X|jldjM:nEft<Y}esWkt-G=uyDeXe>]dm,'D)<m'Z=w'?b9]2": a& = a& + 160
    Mid$(A$, a&, 160) = "/:6Z}dQaFJK'.lmMFoWOsy8jf}[K.=Hm+KbKrN*z^7*mzOXS'VaEVh'|:9yG:Tq3Oe[Tb{Bg/ljDrN(BsK*it-:9kA'RCw91u7?)(htd;<Ckp]'<I+rjTeFfpfDrJg0B>5]_aMe:f*,787U{:)R7xjd(Bp7PmMs/": a& = a& + 160
    Mid$(A$, a&, 160) = "YJbD/ed81[vOF0Ao625yIS90.0Skqor=j9^NU]}z\Ik)4gx?F<5JXYI1M?Ck|4/MI69PSx.8Qi_lnANy2NVg/CDHIs.R{,;^Yxf2?QVH9/T=upxZfVJ[-O8MToPiC*;=gA2+I\h{j;qH72/z?H:gY(lnFQ=pPcJT": a& = a& + 160
    Mid$(A$, a&, 160) = "Sv[_.fYcNYrYWQ<;=g_2U4vw18+a[P}l1Qm15_P\_5W}Pu*qxAPN]DZ,<M.,fL^rmkOUkB]qdTCQcwF5kb[jke=dOsaj4Y7dAasZ;uTy\)qgIMr2+9p-X9>.Z*IG,XsobW{-^Bm}X*_5'qjIv99WsVLCHz;OueRH": a& = a& + 160
    Mid$(A$, a&, 160) = "]'J<*[V1M).f3C9\5.2}DPu=hr+M7S4:xD.x?hPIk*uJ2i7-*iwP(xNMET*9f79;jrXdBRJI'_VFQP2eZfpV+[)+irrW-**?o3qYdLvFJ(G[Q=dStg*hJSusZ>WUW?f>,YDW0ME6Yq9yTxK}k{7D2=AK7eP3wL]=": a& = a& + 160
    Mid$(A$, a&, 160) = "OM6joRc)>d}v?Qi0mkkSxGVpP_RVJhFPBs[sxrkO6zXYRX6-l*FMtmFp]f\*TS<CG_SMVY+kK7WTa=J<DNKYmYF1=Ok+.uB-M'32/?jC,hp;p7pZVeVjy;{'Jv?+zkGLhdp?]r1cDCJVHJI89qF>)Ep8_}CKBHbv": a& = a& + 160
    Mid$(A$, a&, 160) = "[q(:Tm>3O40\48|G75K^Z\S4Hwc7sSaLz{{5wh)}.':3M^C{_P?x+v(QUh7g;:2SO4HOe}*BZHhe8j'qtL*ahKzZ8^|jj1gszd(IIpNAw(jsVw-u_x]MOU;L-swPJM^Bt5PO(oTrVOElAP;KWEE59i|nU,E-6-\I": a& = a& + 160
    Mid$(A$, a&, 160) = ")=JHBsNKEMynG,Auo(qiFWvRAga_'3YHJ=jG_+cHMu3*OT9fR^t_u)892wxC>.uIR/H4qa6P'2q\9o6Qwem/<Zx+{t}z)ZaB8d{NL<f<\tOWNW^aA+Y{._m9|deint8TIbSW{zjJ<6>JH;ad=EzKW4RjT4{N4VCx": a& = a& + 160
    Mid$(A$, a&, 160) = "=NPbAZOp}Nw(NCW+oRTAZkaC9.e;/G0w2Q*+^^77-'_/;AUINo:\B3HOjJC?Ut{82o-a;_3VPLNY>\{?l*II6Ms+;9n-8<=x*v\*/U/<Q3>c_h09kmIVknnH8/qPK;F9]Dw-wSzb?wAc{H::HN-1eW71S>b-?CP}": a& = a& + 160
    Mid$(A$, a&, 160) = "UFDS_yImY=|^>lrG{*)A{/y1qJwyhw)]oHFLwcwbjfSAaCE.FoKj5Kw/o17SIQ'tkrM8M]Smq(LzX:|[nCQ^Ea]k89p:P;pt^s.Fz8hJ'zFXtr2wM6QjoX?nPEt+egvh-8>li=3-nSbUtwC?/05Ox9zw>r*<sloK": a& = a& + 160
    Mid$(A$, a&, 160) = "1W4}g|Zze;a\\k]>wF'/J8)a+Fo48{o.8TXjM4M.*(pgvWS,B.aL^FqbRB3Gn970Dui6?9cIWjvAbol6q9u:Au_N;LM0E/q0i)x]JKB0S>9>{EfnK1oHC'>WT.1}C6fI*Ro3H>9uLxOUO=3w))nH\uh1oynRuPSi": a& = a& + 160
    Mid$(A$, a&, 160) = "9>37rcufS}OjTF0O]ca-v+:A'e)}Bw.-1\Ol:=1f?JRw/<xIZ7XyqtoQZbpGKd_Js4)-o8R?4Ec^GtygnNbB8GOJ.bWL_++z.S>f\IQw8c8]'b.u.5Oms8{UvfBd:)4KEa<3-c,DeNk6^zxF/D2TR(:8m|o-Qf{[": a& = a& + 160
    Mid$(A$, a&, 160) = ")-ux3Bup4sJfq3KCs;Qd{AcgLcYZXg?Nh3^[tg3[?maGi</v:yBXgcpOLordZft(zv4)e3UA.7wq+iJ8AP_Jc8nbf1.?E)pIr?3.<1rEU[4x29\)PhH_Cg[>zE|7(OOU(.1WStI(zvhX/Xn8[G.6m|n,Kd,f</HC": a& = a& + 160
    Mid$(A$, a&, 160) = "q-=+)3nr-l>f2ZJN0?=<U[\)L]g{Q5XLH7R-I8PQtGF>9*)>Xek<^^_CB-[nM<;n}ZE?3k5l'wg<\X}4=ZvcMKuDMuKwmFQOx[IS8X58>TKL^?>Gm=i:OWhll,Z\gFve))/Z>fA(*m|GqQ_IPGMBj9tvvec25.Je": a& = a& + 160
    Mid$(A$, a&, 160) = "'w'}8tJVaD,7t-}-d5{sl+{,szZ8'],P){fO+83ZLk6KTa;\SSX]Z|i)R7irKQp,A<xJ<Y_vB>>l4C-{o;ud/R,b08Q^.6=+'M0fD_SrqCz+G7SaCA9+MSoWxjFm{_ObsgTHo\j9+A.06^<Fk{7H'.vmO*'8+GMp": a& = a& + 160
    Mid$(A$, a&, 160) = "8oHqCSPJaB,e[w'mV{^l-hGw|Zk<fM/rA.J).3'YQ3V7+zT}er]RYq?0/uvQCk<rEdzk*TfGr[XY-[xt:h\zJf1}U,721NH]hmAYYI1qg?VSa=MY3|B2\fr?R^mwu*^I^uUEMRRhGMlZmnSv[c(zA2VP})c0^[o(": a& = a& + 160
    Mid$(A$, a&, 160) = "sq/C{{5a_R\/G|A;wlRUyUL*LJ+q_5JNpJ0E;IaB)tm5HFZLXs3Ymibg5c|,c.B};9Z;xjG(aM17+USenf;F5yt(3Yh:BUGk[Mf<O>5i{brPonV_.^gW9eBj]gW69{As6nu=+R[7Izw.^\__\TUxMV+3OR2:jc<)": a& = a& + 160
    Mid$(A$, a&, 160) = "tTB4ks3jGYXQQ:]F8'nD;C,f\KcsNcEycj}QlAGCgBWdf7r4fqEjCkeB>Vf'?ge]iZ;2'sZFxbDB=m{ynT2Rm'Btd.UiY3ZDSY]::5E\Bvlx6Vy5mXD9)jfFo;3sxCyxJ^_P)*}Oi'I7uoUM1yh=,mG[GWCZGXwy": a& = a& + 160
    Mid$(A$, a&, 160) = "GUggl;nai{.3upGm66oVKP^SY_Dw0r<)PB\d5R]EmBqk<R?0J(LK_fJsM>a.[swn;_,n+\|YB9AVZ\,?,QNOqxPBDpp8xzXL_>zv.]elC5;'qlwB-k8>7w;h8f9zImAQvxZPXnd40o(Y+7h,nrVVafv>Dq*T7G:*": a& = a& + 160
    Mid$(A$, a&, 160) = "+1Jf>7DPIA>q>JDgz*DR4]t*tX?x(Q|+(RAiRcKX;ZK<KuARdk8jG_3^0RNI*gqYB}a3ZQ;/C>=/ab8t:Z2Sj\zylr;I5c[R[Xd0wQfuh?{<Bo2N\zr3xwpVQ=xHDx=wU,jEC>iXhl.eq/8wO^I2,n+sqBc\uoiC": a& = a& + 160
    Mid$(A$, a&, 160) = "{Ps[0dsGOm8(V[J'(E*=M<I02AH,]^g(\+Op8x1C,eJ:*i<.Rc/inpk<(.nbe(1}/cvb[5B[9zfkDB(c_z?(:*ubp99<RC9pwwbvj[\R<qu:n8F'JXGt?X:Q?iccbgS2K4Tm:<_L7ou\s*u_oBMJQBdShutMUI3+": a& = a& + 160
    Mid$(A$, a&, 160) = "/_GAM<))})M4F4'>[lU?})4DpSi7}3f4-E]E-OGWiy46/sBy/95-{9mZVE-S+T{FSG\9>Z1Y:v{2S5g/]+84zW-M=KLsZkHhksrAVOUlEQji,{1hxctQn^b?i1P>|CeL4gR>49RlU_CJ=m\l_pZrQIO+NBG1ygBJ": a& = a& + 160
    Mid$(A$, a&, 160) = "XRBJ=L;Yoos-dWSr]4xs{v=)PSDAK}nVW[|^4b5./Lp_MUQfbm*r>sr*,sZje9IRMBAPFiy+b}._rfC;G[z5Nzl>6RY[PR+7jX|Qv'5QG_iT]d,A0GDHt+hCHgw9Tw1dgLvb,MhyvMFgW?\_?NgU}[W9R8tnacFn": a& = a& + 160
    Mid$(A$, a&, 160) = "KnpCzSqWe-3j(57y'9rC1>ljuUH84j'AA]E;:Sk?QQ7E(d[KYEwPZm'Qv(X}:Zc,KNh|(OHUKs(}q)vk7Q0F-Yu2w4.=iX;6D'7pn(q]lVzJHEm'P{3r?B/W"
    o$ = Space$(10720): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    N15$ = _Inflate$(btemp$, 11977): btemp$ = ""
End Function

Function harp$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(83016): a& = 1
    Mid$(A$, a&, 160) = "0zSIJ,Fa(0_Mw]ihG_HjUYN5IboTVJVoJw=fJSi>kK=>84aWNJ{EWKw^^LbJ>Pl<=RM;T3-fG{\?K?yDqY*Dt]tq=t}\IG7[n666AIL6:]3|s)(3|u?jsZW4TanV+mgva0;g-71}i*IaSUm4,KAW:Sd?=z*y>]z:": a& = a& + 160
    Mid$(A$, a&, 160) = "c>rt6B<]\3Ck\fkq>I(GywpGsTg7>*:Pghj=RvKoOg>B{?{>,N3):83dn/xKv'4tEK\V^GqQDw8a)X{lR^+d8W*t<)N;.L,7f07B3obIC[aPPda('[XC1CdT?[OWQwfLMguZ\\Md;jfSR)zC9n/JgMP\2d=VsQlh": a& = a& + 160
    Mid$(A$, a&, 160) = "g_yh78YZfqn6s8XG+n3UX*Ux9gQ|4[>S=:'gRAZ'mrIPW1dC{:ebI]5Cd{n_]b-T>Hd_IMYbf+HGeA;rbv;tUJaoHS)RbQ}DWqZ_aUAiS2qpMBHw'<e2SHQRDXRN-ifEFCS[|}Cbo'WzGhQ12}m^w<uzVy*_r4rT": a& = a& + 160
    Mid$(A$, a&, 160) = "LoYOb\i1{X.n?jb}'{=RfgVxhsx3}oviysktVWrHM6[br3(xU'N*nJ{VSvWynRq1T80DXFr(48_2h{d[\P4t7[dt')lY^A1+GrR*Ly=m05H2qvp(tRErD?+v4f|>[{_h>Aafhp]B)_)q>p}Q?H4b};SKbI]M\i4\": a& = a& + 160
    Mid$(A$, a&, 160) = "GLKelm<^-LOzKwJ_ZdY-5R^D^SyfH[}TMm4S3=VRiY(IJzFT>4f[f's2YYRw+/<3==mVEhCn\ag8Gc9tLeKlTq*7-jr\s0aH?^o\_)eU1i-djN*(B}C>n<X0{eZldpe,OY.q4NF,NfH2k8B0HEo*a?sT|z+O)jFT": a& = a& + 160
    Mid$(A$, a&, 160) = "]0Y\28kT?(qUO}=IH0R<|*r{YMj1nhqc7s+-hy|W<'/T5HAF/SdKAXE*v{onoM2T;nZl/ccRCz?3TI.gnZCh7JE=H+{8x=9|3+AU207L5]SWjE.y>A6j=+zFB5(>1jbt[wfnC2v'v]9zyt_Z1:Az-z3eOVnmyMCy": a& = a& + 160
    Mid$(A$, a&, 160) = "^WI'NbcBK0m*_2GJ-6Lp80l{YvTIZ1]T(YCb)DK=a0H4OAROlzls=i5Z(^8W'rU.*d9BHk}eA?UFI*AVef7jt89Gv{Lo9-2VxDZ1])0*]\S::^euj^zrizq\acM[zF.eMX[CDeKDtL=f3\XjHrw5H7;S:mvRr-[2": a& = a& + 160
    Mid$(A$, a&, 160) = "E3qIi}ucO{VXb>f:OeNnICqhP>[]Q{'qbA)-)<\A1j7z[ty7/>1]3A9E9m^PG]Z8)ECS|y;l2I5(*|qEUP.YQO)W'S*bc}O-q|?P0i7h|5_3<cQpNT<9DqzFvu/=WaeU^ag48[_wj,oa/08f]qE8}AFgV|HGbgR|": a& = a& + 160
    Mid$(A$, a&, 160) = "L)GlioCwhaF2IeW.[nKRNauh+Mak}[Kds^oV<k}URPP]tqk,FAk'|2cnH>:otS;s+}TFE?c0:NyAcImA2p:ZM78.MxW3|NTKRsC]UY/5eBkUPhLVTrWh/.R+v8RyI;Vl='K+OFK60N;U:d0ZoAcWfAs<kT*Hpbp.": a& = a& + 160
    Mid$(A$, a&, 160) = "H'WRB.HnmCh<m[s[x;p9U*Y0Ny<qe-Jz}3DOAM83,B5fGev7x[6y_+<(j{H4zqOldPMt_G9g6eB9k3*G>hy-0n14?tTf\RUoZrYzl''wg(q;wx_<JGl-pnv6,m.UvjSv+\H442_e30Js)-]X.tQQXy\,(-d^3Rr4": a& = a& + 160
    Mid$(A$, a&, 160) = "F.byQN]idmKcS5*DY5TU-aV};}'0(q)V+c8:G-=c*)N[D,o{22a+>HEGDy]*G6(b0cY3qUe+-ds:rhcomlBXeZFRr+YbO3SaFAs6*_z4Y8k.33:ca_9R3)QMf-VSGY+Rwj_3E-}X<J+D+7/3yG/\zK;19O4N_J9x": a& = a& + 160
    Mid$(A$, a&, 160) = "+EV|*y\v+NT;-KWr0i/y)b4P}ji7y-e4H)]i]JE>iEDEj|/ApmW,nj|Q?cw,jzQxk;M75Q\e<JDs;eD9r_eFJbj4*/pjcaMd1KOoi.D,+kvIAL:>mcY7^OKxALFOlV=?dA6qkBb9x2Z6*[j5p[nIIuI^N5q96j;Q": a& = a& + 160
    Mid$(A$, a&, 160) = "OUi>tnbmVJy.1kOGv{+vi/yT<d>+]gj{9JtZLyXH'IUgoXXo4KoaW-0+tF>-scH9(QD|EEjIot5ZG28LGH+D*Wn;pvzGB2.Z[cGlyn]NZj\o9Cx:q[I-+Zvz;+GnS}T2KT0V,WmVZ=I,1_*1P_wP>PU=4VC/zyPZ": a& = a& + 160
    Mid$(A$, a&, 160) = "H9bk=D<7EsePZvRE.9acsxckChffb[L5;1g-QeD[tA>TMWOKU-EIb3H3_q-[cmdtm>xOmcp6'0z9OWocr[peJyx?nIB+^cLr9uSb_),(aVuw,()6K;^93JtSP78{J^AK7EB_XbXcnV3e4F1I[;^-M;vbOKBg6R_Q": a& = a& + 160
    Mid$(A$, a&, 160) = ";z,ARD.n+hggcCq-gnvcnAVowHPATHdpb;{Nj>uw'vYCQuv89Q2kU>:4yG7+VwdFH41r([yiRwsf)gA}Ei4H|ww5NJb{/rKloU,w|mTwAfZ=),QB\=)0X05m6WTMj+tW;z,\Hw>\K8^/4n?)C5n1TNh-\lHM^>D=": a& = a& + 160
    Mid$(A$, a&, 160) = "xvAB/iW6(i}8tnzP[MGCMRtk>nrU.K)Gukwe]6y\\Q9lz76q9NKsEBIdH.N<J'x0.{k:C3Y6r:3+qxy2ljN09>Ep9b3DFPu\.IRbi]dvN1I9Rd1EPBz82gr?UhRIGz>qdKYqM|}J?n6,t(O25keKbvvD/Wt8KYVe": a& = a& + 160
    Mid$(A$, a&, 160) = "Sa\H4LKz*uZAvJ,cu11gs>KOjDkKbV',V4W4GEb3WUg5qY\9b\k.<Q;2RKy}=gy[>JRI07<(=_jxmd5O)i7rfoU{5wIZKy<l=bkPH0LBxLt=>UA5(s}<p}9d=Nu?nRd^'Y/*O?Ks]4IrYzVmBijN*j;)o,Wv'Z8m": a& = a& + 160
    Mid$(A$, a&, 160) = "3XveNk9/Do3pr**JX(PdK)(xS,2llSf*4=qD\\ZI4Ujl-t){vT>rdqVB>:\tlJmIr7a,jT-e0RZEj,9K2+BG<ChUV3FBS*?BI\OL(F>46Ym>i:OCH/'70M(H)gQ{PZa*Z[]^mDBgZtEI=bZJ{ByuMmkj;nhPq0Z>": a& = a& + 160
    Mid$(A$, a&, 160) = "-G){+c{:hTaKA:hfMxf=h,N*XF+?2G7^edcPVmP*IYUOEYuY6l;_1+b<x-c1R1^(PDjLX_\oj?wSTO}VrEg4R5+oF)Rku<.N_P'md.aP]n3z=;l3w{5SDaPcyH-vh_ZHt}DOO?HVn>-SIdh<*{^lK^)NLV}wc-g'": a& = a& + 160
    Mid$(A$, a&, 160) = "BER\sPFVjd2S4M=nZ:cJ8rNl)uRnwKq5i<ZgyE}4Wh>_X;h5.'A8O1TzLU9x3Sl|,(q''TIS[mxo:*5y3r3?ZVRYzr{6O{aM3pm|mBR=B,kfthVh4:Qu:N+7ctV'7.V0k(|LB)S72?syUz\<:=U1]+f*x?fnPfbB": a& = a& + 160
    Mid$(A$, a&, 160) = "oTPYr}.{;'z9]5eF1PE=s3]9lhUOl{',55NY\(OjB)Cx-4dg4?T.JFKxvq}[SXL;xPhsr\{_(ovtB^SX\LCWL.13b7pCN3wdQx<FlG.8h_:Sr+AW9*^s<F|9in=afUwliasXZ|fP1;\e2ajY5WsE_aH+vgA<V2Fx": a& = a& + 160
    Mid$(A$, a&, 160) = "'VP[{mChmyDH?\J{]1VU='5qlt1:P,aRd,53=YZrk.+'f+f[-QFhPX]MyiUgWgC6OspML/(jV/v/FZsRKLxCt<4([uz*Det;u9UR\Q<x6aAsS?3-?EVv2=_>d+MTut8S_0[aXwJs2l*/+CVkV5Hg-Qi]>tKpZS(u": a& = a& + 160
    Mid$(A$, a&, 160) = "\vE[Y>^^6Kr.lMl^Z7amfrH[m*a1mGCiZ1z(5dCK)M.INk6C0E;J4IcX;VEF'4KO;|hK-yI=2tp(=cgq,js6G,>Xb|D]}qET>1MBxxVOtVD;A_YPNX|gxF*Pa6HpN^g00Ff+O7GJ[Ec(xzrNFDdBQzks3;|l*BST": a& = a& + 160
    Mid$(A$, a&, 160) = "/6vi_+\{iY|_6u^IJ:?;KyGm:OOM]acbH_V-wbW1chMx0h'PGRl]XPZP4[pmtlh]0WW2DI,T6^+{?a6*x+xA7f,Lqj\pr:*8hs<x}4'nlThh1bm_Oi-Go4>={G)e/5F>gU4qcAh0Bs+E|vss/+7rX)ZInH<\H2dL": a& = a& + 160
    Mid$(A$, a&, 160) = "Z=3pn),HzXv[:VoC^z./^7o30xr\wu0T?]hL,yG-pN*LN'+N=<bwCQ>|2AYfW26I;Db7'2D*vAG*e8]IZDX^Gavw]b(?BM4?KxyV*Y8NE7(KT\_pd1({\9:PfEGj7qI6gF_v8:/4mSGM-*v>)/1|G0W0j5:d('|<": a& = a& + 160
    Mid$(A$, a&, 160) = "06YeOIUfE4sZB}:XUU],PFZlUj9ISh)g}/[hT-Vtu0(C]EX4g/*[P),Z[,A_4=SqD-h<dam[.[E\Ghu'7ZRa.33K4*dV3tDQ6H\J0=>D[;J[kA*6VG4tzVCV'3uAQ2]9./J;z;Lc\|<:^h9t:F.*W7Fu?w*Cr9_r": a& = a& + 160
    Mid$(A$, a&, 160) = "i0rR*aVegyMTj.[I2flScsU{D7MXK7zDbdFS0rG_A1Z}a'BVZBbyoO|(-YMX4[HSIyY^;hfr|(8pOGY;GbchKrXDNIvb4:jsM3)fQ,{RFf:Qhg8*8yTK5U(Ex21l6Bf:^Dc=BX1D/v.::U=Fb-W=UQmTYakVEX9(": a& = a& + 160
    Mid$(A$, a&, 160) = "zk}wZz/k(6uvX:iwwfXNhPEdqFdpLAmOTgUH,J}UXiIlqgq6ymnZI;cQ8p}],7C:I^jztl(z/aU^9mQxMM_c=Nwe:[]MS1usUFgI<Kc+4JTOr{|u.]PX[1]7{3zSROD+9+w3cDbW*+Hx,aZ0?fUEk^-C'o1,pfte": a& = a& + 160
    Mid$(A$, a&, 160) = "'FSwUOd[O'YUp*AlhG/sidV5N|-+__X2k*Cl6PbF-y0=p>is83emnw5-X)hy(pMyF^qQn,BXsH{>c<34Kvt,mzHdls_.p7sTm'uAoS5T]{'q08suvj/IIXpN*1j2:A+Yl8^'eJp7bQp6XbGq'o<Y1DSy{IDJyRQ{": a& = a& + 160
    Mid$(A$, a&, 160) = "3>mZDIm?+Md2D2LVTI8;niAJx\W6aY'o|Cvc<zz2ybt,esJ0guTqLOG6?ahV*iNw|tQfa'6Lzc8,W'8[NBVvigRkO^z\6ZuSGNZP1[nM0Uu4ezTus+J:(o/)'k]XUgSKj)YTs,+P(<nFQH:J'[nY[QvdLGvLX?Vr": a& = a& + 160
    Mid$(A$, a&, 160) = "f,o:9Am>NC\hs}\bc5qJU=v5vsgP71(G/p9KL?5e'2P.Rsn=Pjwf4>nga0o,/DaQ*?*k-};-2-?+mw,vzNf,oYlq7():qyIGg-p|35US(_j}kUj;l1muwS_E9pFk,.Cy57j(^Ks[2P34Lc[=Jr^yXsP[t[U.MCSd": a& = a& + 160
    Mid$(A$, a&, 160) = "Mofnb[uz*?u[3dWtSBPQO8T7^PT'}eUw);y\\aOb:jf1bM'6{C>U6v85e3'_qUX{//zq,_Hn=T'c\*phra36,eHt7DH-J)fLS]/[i36L3qXc/K9i'AHz^I6.2*>yd(h=f|<aa_+PzY*d51OMR>Tj_E),Wr\:X^31": a& = a& + 160
    Mid$(A$, a&, 160) = "}9q,+FCN5qXvA>oR?.0Sv/K>5b1Y<6_j_8e0fnR?g2:uVbl(/FuTb_.:8+Z7.rWuUFDGA-H/2BG?(7*G/?9y],U4joP/oGMFa{/HmU66vjT{M2b<huM'BihqgNSPEl5N8uCd08O(S9rD=lVLvV7gegk)Xc4pJHCh": a& = a& + 160
    Mid$(A$, a&, 160) = "-t^<W*M-YptCRqbxqv=H.nitv*wr4h<Qq4'\2Z4m/XsHuGN;=7AW2tn(Ql}/eg:FFlqrJ:h<uYa=4a54_>vY91j^.uMs.Q,pPG(p0P{9NB+3BkeM'lZV3OA5J[y^v0)2Q}MkDwYBcJ=/j7>I_[C1q?Mz>=tde\tp": a& = a& + 160
    Mid$(A$, a&, 160) = "<?3=/X\mE'5(RAb}9jxHd8xC2OKp6FhaW-]G<]DiBRXiz=;aV<(kL-yw-'.lM;N0)OrngbTJLRwe3D06jbX+9;D-vOVKq4<p{3D[D[J{>d[O=Vyx-<Ky]|q7M0-iBjDO'OC-KP}jm0qO]Z[pD30aX:T';\:0,\OI": a& = a& + 160
    Mid$(A$, a&, 160) = "D3Wm|bY3mjBnTSAo)n?]0Q=0RDMW:aeW4JoO+e|j=zwQ9:B^4'o5O3JHxWKif=SW'=([a_2b']2>Gg:/4WdK.|z1oqJB9uEQS=+;f\6X4bEa[\}W)6e/Pb]*wGfcW^tL<vjJNo+db<KR_9,D*wX4p8AU//w,*W_i": a& = a& + 160
    Mid$(A$, a&, 160) = "i:BZ)i(|QRfh]+E=AGLkRn6{w2_K5TE25YnDD6E2\Q7Ga|c3jX9'[YAp/Ep.l\B2}u5+]bbHY|pk[e60\z:io{ciGjn^)H5,o{l}mM0R?=JO(rF:C78_^eZvux*9bmB[T9[I{b{mSD-(^[ELgV_hH>bnU[om+l<G": a& = a& + 160
    Mid$(A$, a&, 160) = "uG}_e<'];6+:=_0)H{YO\Nn^^],2p8CutVXODa|<wscfuXpf,mwgY'nhhUSzo+oR>l-8Azg:|>yBH<mSWUy2;QhQDnc'\(3f9<IZ6Hq[sY=sIEPKoRwtRp;{6?Fx4DAnWRDw3}lJfg*IfHwjIqy;;i,]RS6uo-yr": a& = a& + 160
    Mid$(A$, a&, 160) = "otprFCGvZF=rr2Xe.8LjG[(ATFeVw'2i*a-<lg,qH]37OI7;uPOz^vBhWxhUxE/B<{g0)Kd-Dm6[IH5yKPXTj7cOF;8]>PVdN4oK'rmF4JvFSJl<1:Uiu0tq174fjC5OR\{?6F:Vs;AF1B-p:^>t;J^kw*F5tkb2": a& = a& + 160
    Mid$(A$, a&, 160) = "IqJWPQ77(B9XA|Mv95uj/.gGW6E0)N.(HsMT6Pls2jwtWC1GfJSb5v^[wYHXD_)XR9'I}=6b0b2Zi.BVn9k7i|lCE9.OR*jl0YOS8B_21jc[?eE/<Kwh8L8-Homz1D0)cmG.zo/SV>\)\ibWAuXiUB]DkCfhB^GW": a& = a& + 160
    Mid$(A$, a&, 160) = "p15{{m?g]=9ms[iMttFg})zS;:HVXDUHU\_zY(CLAJ}MK<-},fc_Yx>.-.l7{tm7Vfi<\8Wr6{_FbcFrr{7W>o9HrE7P'My}\Z<D<Sb07}ng2kH^M]anwbWqIrq]ce43d;=<v8qhbOX8b?s2T?G\I.Cp4fcYOxe<": a& = a& + 160
    Mid$(A$, a&, 160) = "z2Sdd\VKod/-l43RN;l5Y9pz]pFwtorHEbx^;<<^,[ke(Clvh6AQ6'c8n_vA5[wyW^J0X7rWfbmltFIgzCc^uXu=.ZI^TV8S<klDbtEm1ajqjSRA1qT>rn*Y8,)\wAk.\;oB{mMG4)j:ocwh[[*p]X|IvJEk//;|": a& = a& + 160
    Mid$(A$, a&, 160) = "RVvCj94d_JJE/yyMC1nEv]m{(ZjBBTzFmx+Ot7/Ny[Jkvl6Me0iEB{YtM.0DNEx7q<zcHDi>2kPveYq3kzYI1XcJ,rak}K1Pe<S_yJg^ODKi]d,J]md]Ag8W=ChNL0RRC_P57vD+5B}z;gq|>?S>_3;uIdF0*O19": a& = a& + 160
    Mid$(A$, a&, 160) = "|VKi.4Sh3B(Ycv8]GQwOC<*JI658eacG5v8ahc>nV8]QiNKLx>=BL.+G\lp9g6lCm=cH+cqJbxI_>]R1zP(:^dPL9R;M,=We(SCXo5b=atda+hq7Ctn],tAY;eiFEbtt4B.-GVJN?ACzTow]:z\fpI:O4xivK'h[": a& = a& + 160
    Mid$(A$, a&, 160) = "s1,YuXZ<l6gNVbTG(uhCHIQhBx(Kr=}*JvsQHXJHBr28.3?_,t\An]y6<'D<h\WdJ.;gWKy4_Si>UD(){'Ld6G?<dgNM27i?2w:O'SJi-URj/E++Bm_B?(AKz?FX{z8U5PcS)R\*To9J.?2JhGMbC>R9{M|1-<gZ": a& = a& + 160
    Mid$(A$, a&, 160) = "/SrlT(HI)K13KzJ:nIitz>tzI)p=RK-U=i7H39,?Bl8efLa2IH'{)7kXTCGmD]g/u.CP,pY]Rbh9^{(}3uBl*sze0RID'(vBOa_z\aQ3X';16vu,y*udQy{hC.{<.w=sdQj4D+pWL7?.y]5GO}6X9p\[UGLu'dVP": a& = a& + 160
    Mid$(A$, a&, 160) = "?GX8YkvHWgIW/kHAE6{mWC^YNZ<}3b-JEYl,=PXlnEnBn4yXl+{-u84>(ZNv94c3LaJ*.p5rV-*.v.8f+<Ws_-cjJ0gL--YvU=IV:7/)1*Ig8CA7Perf6OwVli=C:F4[M/=7ZnCi4;G=fQP6qzGyo[6n.fyh/uXw": a& = a& + 160
    Mid$(A$, a&, 160) = "q0q,?2btFnN'C.D.6\d7bO[IgfpQMJ7;uott_c<pPl'?0BoA2k)o+Sv}Z6|S<v8CA<xd5waO[XYZL)lOgRxFS)dvEl7M8w[R)RRtrw6w8zH/3j(Vk,h+4/VJN\,=KOYu]UJHJY6FP^JXBpXs6w1zSx05(A'ckd\2": a& = a& + 160
    Mid$(A$, a&, 160) = "p'|j7Qk)Icn<aM2X1LI}P8e1k5:+9|VMT{t38nrKthBY.<I+u.YLzE)^cPtN{c_S4P1a'vmq:9j=Iw(DEXMW7WV.dDr.vY3f[YLrl-i8^Rpi8x<)dd.umK23kp+_85gFA);^sRLucGuNAd}1>L9cyKh-|,uB>7.,": a& = a& + 160
    Mid$(A$, a&, 160) = "K7ZLZ]Cw1r1*8;u2j/aC{vN{b.gg},QYB5)YaH{T/t,<t2'KR/trl{cSKmL\{2Wj<3k>x=ne)]524S0jhQEw:Q0:a:1S?prDH1Y<,ip.^CFo7.IMjGQn^kg803*2l{1]}pQHjdf5B(}6zVu.M:(;eK9d./'k>g*A": a& = a& + 160
    Mid$(A$, a&, 160) = "QgLdKIJvo<otM8CAueuGb8Jc5.D?ZWJ.Wu20e9D\ydY=JFY5,]Md*03\P'46qo8x|sGd2Ns5nLUOxHR9-j5Y,k?829zNjr|ZIrd8w^Z971=z?-hxUr<}u3tqLP1V^^A3tX6H0;B*Zm.Kv76?Q[=z=-sRpF=F4i81": a& = a& + 160
    Mid$(A$, a&, 160) = "8/r5Ov2zRk*UV9G{b6j|;7p+dtlm+{0cD+m,EyZx6\Da?lq|GL.iTrJ0d0o|}PXMEtrXJ5;9X.06LYt8\TPPyXXqCzoKY*C4D|K+EzA1<;tO?tym9<tR,tAvq^Fiqk:Xn8>C3o>vZn'iX(l6^=LLPa[hJL/XDP\0": a& = a& + 160
    Mid$(A$, a&, 160) = "(r]97zus<.41,W0>aF:rzSYjE^W,cZ}mML(Y5t-r91Uc]GuH[qJxPJxZxlJMei8eu4F7[A<,G7)6o=6{;Snj?wUY8ouc^(W*djAgKQw*R?_2h4U6wlPv<WKMHRl56WB1vDH-dSV}LsIPoaGQT]f\Rt7SGxYeac>L": a& = a& + 160
    Mid$(A$, a&, 160) = "*VCTa7>r)^2yiScNB7;i;'+I-'GqZ-9rR_]<ID<^MN{GbBV7?AO=dcz]]6kyCuaqZ^,pYFSLv=v<dCo=beg?UU*LL0[Cw/t?pF^QEcgI0//v,^KIfe^2S.YSL>I1Cz>,RS1d2uj;fbrP.Jz]hPYZ)9>4qBfRCyjg": a& = a& + 160
    Mid$(A$, a&, 160) = "SrqOJhDz^fxk</VVDXHFM)nP{Gs]fMqlP_}yXKlB/Zg?3kIh)YVwVlchzHW9p\nBYf([I.ND;X}+'9BU5U:l8P{9QG|g^y+9ZMCMv\M)b>:Gy=|0mKj|ML-E7V/AG9v{4AQD/yBc^r\snF{l)'GB/A5j\G);aq0u": a& = a& + 160
    Mid$(A$, a&, 160) = "FjP6zCy_PGU7QrPWx63a3ilPdUtO9l1Ar2o:8;zCqh<ATY\[8clK:LDZBP'HpZJ<.Ws=>W,U4{\K3CjmR4fw*{Cj.^qx\HeAhM;wZqf9/I1q->:F7sW-Tfw9c\,cdgkJqLv0'vbkD^M-x6{yA*rFw60QPG'.E.wk": a& = a& + 160
    Mid$(A$, a&, 160) = "MjSoXM]ZIWo?/1nE1n=fbUH'+M:3*|'e)9sg/E_3O>_xzatA'AL3M>\Aq]+E3j6+gO*2Uh0Y5VbCbG;'exiaVA2F1sB8mD30V;Mo\pRU\3n{yY7OLtOaHJk^bmz[Y]<qwTK.,EpElI\pD-]K2tw}bjY061Ul)e3k": a& = a& + 160
    Mid$(A$, a&, 160) = "i^]8BCNR/-^E3dPcEpL;Is6}hih/6XFEa)|VDBhxGrz.X:({dWdB]Wdz'[KQr8U\F(<:{6'>\X9=)neSMpy2I5U97u6c[eX\C|g(ENkCD(w(Io*Y[y's<iY{I_nEAOGVO-1_tL<V)rGgEM<=]BS?5AqG\f<.]IG>": a& = a& + 160
    Mid$(A$, a&, 160) = "\Fsh=e4gyaRdW0=U9Yl7xA2kulDxa'?25;KmZiS7?hDd\.,ie5Iyb-dlH(a^3<;(4GMD:CAe5hw:W+gosL.,tXzCJ+DH<JlzP3Q;;\\FNXC0nLqG4ya}Q4ez]7|VK,0,6Tv]xjqcII3.S\}f7b)HYJA.hoI7j.oe": a& = a& + 160
    Mid$(A$, a&, 160) = "H*A9UH*evP}petlKmc|7_bzx]{m8.lBTvEvJ3W*<]I2Am<KT\mC9tEa,UqS{Mh[>IrsC3f>yTqDBy<8:/hEI_ZB,P:LP2XnOAe|b_fRyt.,KhmsJUmCKP]\Qv_|wdVDf5bE3X(whL7>t[Rj,TLjp}afxWp6D'W[M": a& = a& + 160
    Mid$(A$, a&, 160) = "sH7l3HHP;f/7wUwJ*i(eg28pjsR,07uPyf<4j2RXvL\P9r+]IvW4H.u7\Hn4H>ukOeKZ}38M1}3;VGr3-n}.i'UJ84zvS^JXt81{D/g>DYBOT|.aW^*UDrr9-8kxUiHLFt:o]NokpF/KwCJ+aP-=B.jGae,:sh0s": a& = a& + 160
    Mid$(A$, a&, 160) = "JxFjmEStFFEYH4clsZ)t9F7zWTt{+vjS=nXo4k9<'8B=R5Y28an_YOWxlAf<buL^<T\uBz\7]t*D+bd)2bQ-bv>w/a}l|8uGnGmn-G<ob[m3Pp2Q}i+]W\{bvc^:^4.kdBSF5Eucr,xGhBjMlNw,}q\T||R18^C>": a& = a& + 160
    Mid$(A$, a&, 160) = "3.\Rxd<c)zIw-R+rQ9MJM_{OuUkrIH/7Tvw;:b:ox_/<V.3YPz4e,P|HXf4JCAwDHQsME:Sbn,*kv*2Es2mDQm)cSROYU'y,?yYKO09.NDYGgfQWRx6P?Jd-DzHf{FunDl(-^Yt)8-s4fa]K}9l7UDsKT=49pT|N": a& = a& + 160
    Mid$(A$, a&, 160) = "BY.5UNCq*Z2uz)<8;sJ5aHT22v'1?2>y'nu3\]-5-2Dbc/mqh(Ueh(4/Ep/9o7hnmK+'GjzcY:WSU'*^V=7BUC1VNoF<)+J?UT^5*B4PP+7OB5Wr})d9Hj>}9E;<w4OG}i)uiPlX6e='}oUflQ^+/?|wFh}Pq1jP": a& = a& + 160
    Mid$(A$, a&, 160) = ".rJvJf;(KE'=]{st9GHL*x^:3-FZ^w>hKccLGzPDP4W4^ruLXrgci{{(N}qja.E9n|\'mTRAB{j}J]0K,DPjp0Fz}]GS(N_u+1Z2_Jps-isS<kjlrwgd.M3J1Ua^Z]i[v98[pMa6ohB{osTLIghQ(/oV[QqH]>.2": a& = a& + 160
    Mid$(A$, a&, 160) = "I-cUAyw{-fgEw,cKgM,S]6gaXBkI,*}6I^A(Qt<NimJ?d?qQAy9;RdjHLH,xzvo7dk_qfy;XL5s|]qD1+U]w+TauW[e,,S?ps5sN*Q;^=d3^ix:if7*9(TbW-D(<JLt0966pRPvswxUW]Ze0UV3{+{L;axN1KPV.": a& = a& + 160
    Mid$(A$, a&, 160) = "mJX)r;a{)0/.6]?tq0)3UUoe367xb1^3Q}B{OD|u[22{7U9F+7oU3,(y-ZOc1.K4p3NLOd8>}Hijf*dDW,vhn8ZKURG;D1j>U?C-QvCuiN)Fdijdja9mOI1}eI}}fu6'KxF-H:{]_nmk>^Q|QYqI8g+T(a*B]cC9": a& = a& + 160
    Mid$(A$, a&, 160) = "FZ.V\/r2NQVZYO\MxBbQKWl9uroV[/:J[dpS=XLyXTI+B^lCjEttxZmtZh[Xx+HI8]?yRq[E/']8:c^<tVuD+UnA;M17zH8;:}b^*v]}ur8hDDEwn9f[(tLn=6(mT\_,09Wc/rv+3l;Wl1/-Vio'b-L3<wbX+>}X": a& = a& + 160
    Mid$(A$, a&, 160) = "JuyU*wnyM)JG/1yi[qN<ZQefP/OsIYgIVeb{3V8=Q>>G5**C[H4':udT]keZE?|kd=j:9O}3if|fxrVJ^GPp=bEmD'6k]6]H9Tn'sO.^VQz8cGv>RNVu*GV=i5)=?1wr9-AR_DCRn<Kh80eEmDB0?pJoJ_)_*FGA": a& = a& + 160
    Mid$(A$, a&, 160) = "(rgf)fERKh9uZe0>Lwu4Y3T3pnFCD7<)dD+KT:fc=e5*yG;b0Bbri*UB]?2{1ITAu^bDBmOjFwJu/a^fHwCZrM^Q7TR1lQCn9I]ePF-Q]*\M]5IMtufvn{kHPa<,LOQiK,g_O:++Ql<'u2B;zIn[W(DW4:8I_h|k": a& = a& + 160
    Mid$(A$, a&, 160) = "7Dl1yw:_}ta,z[UqrgC;(P/r0*ZWt*\+)f>0D3NztoQ7w|<2I]Dj8{UHRnFXurmlRJxCHw(9B6VEl:ddG_Y=S9wfJ(SpUvo9'ta}US+8'h;<uYD8va.Tj?3rWZ}Xom+:xA9IkesZtm=KxX4+lKHier6J)>{:cB{q": a& = a& + 160
    Mid$(A$, a&, 160) = "'c=SE5T6Mw/S/Ie}kh<ZdJ,Re/?2P.g']6Rh3WN6YDH<Nxf,=m.]ufMFB<(PccEfFsm=N(D^?W15l0e,w)5iq9_juoYZNp\KU0F8fS,A{}<)J<Uq':rRq'R0JA|ZKf;fAD,?z*4NJZ+nJnLZ/,0?sfv5I-Db2n]:": a& = a& + 160
    Mid$(A$, a&, 160) = "xYZJ1P^b4{C<y3o\ITY*^bKK*c^OH,D5p1G1X}gGtR43L6r|hv'RJxCBO4?uAn'|5/1a^nN;J[.20_<>Nt+x904xFD4;2)Zh.0Y['Bi-g_LafE^Q4yMj2L(L|M=FayV}XFez+N.Trqylx*\_dT>tI_[26+HeqQdw": a& = a& + 160
    Mid$(A$, a&, 160) = "4DeR76]MXA_,.h(5Xan_2NNxG|?fjZ^cq/rS96OJ2N>X8\k2_kM5Cv[QLWpPkUOFl[:dumRC5>4+GEV=[,3q/G:L^|*2)+*B(u5\J/{{<h<vH|2^f,qz,sv4WdSp*+SC^yNuA1QTZ};,1Y3xlPe+b5SGJ5/k8TPS": a& = a& + 160
    Mid$(A$, a&, 160) = "/y=A3c(q}Z6a\ZSg-(qf|b>Z2EL9:aPq|]-1AsUr[qt|^wE[u[J\1s=*y]jgc+hWGKHmi8WGnkUEq[Ay>vrvD]H=}J++?b=x<q=d[\}]Bl'S.h-c]B*<>uC-pAlje5=AlnnPljNQb)Jiwk_.1^hx3;gi9+dWb(90": a& = a& + 160
    Mid$(A$, a&, 160) = "v>R|K(jm3qie|IJ:>=if5RU]W]inow<)PWWn*_3pDKaanVHl2U70W?j{Y\(Scr^S;76E3abLAB1ceE{hdN+rl)aH]M]KQGc[bx(IUn^w<.95zjmhc>sI,/rxIBS6xdM3NuIK1>*7]6Nj)*i,+^{:jRWM3(Nsi3{X": a& = a& + 160
    Mid$(A$, a&, 160) = "g,{QSSoufmW>Iw-u_ikEr=no>]<?Oac<(q;D)oMT;T)<)-(4DswcrTT^Y[xT6;7XLf^F/5,Yz;mE3Mmdp,UqdrI+yWoWQ/.ovgK,o6js]\reJltREH]ptLe24'J(./1.xoXT4qb)?E,9BaskN8<i5)OuUK18B1'M": a& = a& + 160
    Mid$(A$, a&, 160) = "MOs=kQYcUe''Iba+8EWqQp0zfwQ.=Nl\1*z+I]KU-G||LC6o4x;1|M}gI3?|4UPn+[.5S+sIR+o2ChjSthbo2XF\6)pDnCL7<AVtNcoUUQw3i0Sk:Ng7LZ9mJ81uxag:^i>j6*C{V}IZm{9SLgT(?^,iXHeUErI/": a& = a& + 160
    Mid$(A$, a&, 160) = ">*:SYzc*Ky[l3l.gDqItf(c8bKul_eAcM)l|NvZzsr?A*}euG_85E'kSXf[ISkOrJ)M/'b,G1Y11crRVw]gwMDOiU[6_}6U\_yzP<B5,iifO]PksOZ9N_X2M2M3ff+Cdy80y|lr;vwjvThVZJ(lgB\m+MYft6Q:E": a& = a& + 160
    Mid$(A$, a&, 160) = "<-^jHIlpSADp99U>j}RPS1mJMf2M9SrK^Y3}0lb']a:ZjOV84(iJ<tnTGQMgPZ1l.{B+FQ4'}qosEE:,THE/,J9)xmWv*2a|_Y_G?_++UNyhFOu65n7)zHnnQUj}guFf2/vYH:npsI:2|bX,nqPDn_-y{?5lf)0W": a& = a& + 160
    Mid$(A$, a&, 160) = "E/HuBwZasS)HXC9ysDCo+fl91U1(USEW}8oWq3,]K.]S?lc{*,*S'=Zlo\'?7CleeuMmxK'2Qu\PHr=EHB(nAxVkGV}oL>kXX5{lOE{MBW_e4prSDIFZAGA5R\9o=\v(;H7L'7TSShTk7w,5NKpomm1r\ocaxtf>": a& = a& + 160
    Mid$(A$, a&, 160) = "M=l5HdT<Ol9I:*4(={m*o=mp_)G\rfHPsL9>oywzuv7C|{bPo{MER,]tTBb4_RK86?fWJbx9NnBx=|4=Ymivpr]Sl=lJ]iU9Evt7CWLn?4_*vGP)lxH,oR1DLL3XaefQZAHxdvj7']xbsn=G;EYWk{R.pE/[nHt4": a& = a& + 160
    Mid$(A$, a&, 160) = "GWkHPYi/-[<vBKzH]XKbjq}tF,*)O5sCH,b,rl-fe2*oCq(_FrJ1u^n6d8.{4f9TK5j.*bW[.(M{>kq'oWlZmvy75^iBU76YgHR*'Xfxvd'[hw-(y,+FZSNWsmttLSdaI>KSmg:sO4aW8u2YO4*.bEyzxTCEl<x*": a& = a& + 160
    Mid$(A$, a&, 160) = "UON9K,'qXp_.rYc7Se(cmAqZIzRvTxNqgN1K\L\j+.t?=R=n|vQ:fl<J4nKOo_?VvBaKyUs<>TTN/;]yCG^n[^.z:{rEy6Q(h^}4;+ZERTL5m_L<7eQthP)(-KhgAAnpC7h5RC)0ORE)=pNph42X7kYBlvQ_8MnM": a& = a& + 160
    Mid$(A$, a&, 160) = "jO.\uzI|=H53=nSQ)^CE2L9'x.fPiK<0G*JA)J*'M<Rrfmwn9HdM.gNrg)kBJ\La1YoMVHQA<lNgBm;]PzV*O_v}p?(rf0JbEy;oF-3+_dM2)LiSZ>AB)g]LeW*a;Tq6jB:=k5KpMRwD0(g[FrG/_{N/HeOhLoZg": a& = a& + 160
    Mid$(A$, a&, 160) = "Ubw*/Rij/BGKPRoKOGH_u:sMaa=7wX4zx8YM.1[q*KI:,^Bn:XE/8=6zVWVb2i9)86brrM*QU\jr+H=B[7yVEF9dvBnJjg+k^tzy0*KmXZKhjMYxMycZ>cVtmuB(>B'>yXa0JMBr68Q7e(fA6hlUa>6\]-hHhl:z": a& = a& + 160
    Mid$(A$, a&, 160) = "[\=d0)>Q,sh<5BKhUzrTF>A\{tI*Y<r_>S=7=QdooyA4:jE86NMh_GW>tmNm?az\itLQXB>SY9XrEJMymGqMEEkBJ[GE.|0yUu=+BV3t|Ie{(*oWFmXFRS:COcw'R{9TuNlM_fS|>S(]iO_T;m9C|GD'<[/(U\:f": a& = a& + 160
    Mid$(A$, a&, 160) = "+ay'/7Snk=:yu[4/GWw[^V:x\myYH;jgRWt*>/a?2v[wN6Fo]'ACO'T845t[G6waj)4,G4M.w6chwEN{7?^K^qRo5M4qpU]12RWiKO=gxV9kvIy)1A.*L^=vK'm(=>ZDkBPXOnO0p'zYaJ6N1UnIx|IX)ePmN/'?": a& = a& + 160
    Mid$(A$, a&, 160) = "{iYEmGB-*LLB|GQ<2^KRc4{P*r[}w|88|9\QyNjuO4gKnl[MP*_kA,}xDK1y:]_F1g5zMqz^JB.QS{mfNI}|us4zd3P48Hf;Im\)+wSWR{=kC;WXiBD\<iwsFaay1WVqW^gBfkY4nwjLkUb2Y*oNe2Ol>:a__7(m": a& = a& + 160
    Mid$(A$, a&, 160) = "Y)6\.Ej/+<-8{hD8F9?l*^lv}24pXWopW]?QKL'KyZ4|]S0F>7in[Oex6o*WHko.bG66M-Hff)j?n(Vucu*Ey9B-Y3:4l<7+g_9BsB7zG^4n:Vh=O;-2Tm>n,DCLhw1'ip{rcLOv+yR1^1d2M5=E|=:mZ]G<oA{d": a& = a& + 160
    Mid$(A$, a&, 160) = "fMO14t/(;JAXg7CTzjIBCml\aU-k,L|[*EwOft;9{+Xo98OwIA</k}B1Kz/7wsGz:n\g,avtD{TNrQ+V1NtjV)6'WPuh{HzCH3^u|wf>3-os6a_J?lL96cdn/0eJgN0;t2BZ>;XYX.IfJBrC1mJ6*aZywlTfrG[c": a& = a& + 160
    Mid$(A$, a&, 160) = "k[+VOkZbE><62qXQ?Y)Z;V|n>8TVxc,,E(-jKqRUFmxX:Rvrj<hiG?_Yx^f+avi;m)_wgOija<il:q8e61Mh|)yxW|O.yOv7eMK)\\VC=v<4Y0{E]}.imLm6>NrC|,^ZFtSvbyce[(NSCwxx[|]<]spwbv>iEezS": a& = a& + 160
    Mid$(A$, a&, 160) = "WP^W7<DX|hwRP'}\>D,iceV1\rKP0aP.{:bUY}])XM2]m+m|kNwKL/huK'51pZL;,mHV/:VU1C}*v+a/z+MV_/j}>uYrY-ws8hEuzHYP?AoQ+A=n^='1V7+Rv/]_.e)R28djbzV('\J=Q_ZoGO0}027vN1Qf>)_z": a& = a& + 160
    Mid$(A$, a&, 160) = "3:vFPib<|:k1xjFs*On[8d/hGn(EQIz->:h1yAz'GbHA*ivDagAqwj<1xB?0-Iz_ncsrKk_XV{N:'k4[z.+dPo9OBoHyA?Z{T/Al>EF'i2oyIg0OtN(03.B[?=v53:Tc^i2[YBTo61'Zw<i>Xxm.gVAw1tpW'P'H": a& = a& + 160
    Mid$(A$, a&, 160) = "E[>v(lR_[RT0]{wf=k]'zm]fA-EHJOhP+]Rd>i7Jm4v(DBWy21NA0di}A)jKmp:RBurWYgXaeTb0<3PjB83u.YQ/T6r_;5DRJdr_q*9d,R)(4ZvNB8vGpz4[bV)vKE3kG?dCHV4'pR:pzQ<3w47vB::[cgXEAsvM": a& = a& + 160
    Mid$(A$, a&, 160) = "D*o*y3<ZQAl5KG):u9YHIsOYz=qihhiR;PI(0YmgL-d9OZV.n|;E??T-of^;la}-]npn//ny5cei]OhiXwcn2]4<q>rAQw,BbN]^v<m)LP+8Md]W;1Bqeq.tQDY]9A/6e;Fd6C;Z5ud^:KDQE\y()<;h02qEi,V'": a& = a& + 160
    Mid$(A$, a&, 160) = "u3ECqBIsSa)cD1u1QgLZ0wxnxh*pk,EUMjM)8Hn4gVv[x1k1zRjU?Wbrl^_B.-^(Rd,Nr>/6zJs'U]r\08>fU+kSid^C/1;z6WpL.r\BqGkHujAB6SL/UjSGVa2hmw*?W=nw0=GM+5eMAJUy6[2w|ZyYPe\*0wvj": a& = a& + 160
    Mid$(A$, a&, 160) = "r4isCOj]Ev(\ks8h\P2We:*k:w9RSf'-/5t},v>bvBaw8,J|6-.7|N8(\P?Vp[ar*i<oU6JPw13IcEL(40=cvri5:8kkq,(A>6r'a,vp)L1bA_bVuV1C^[1]xb5nHlLTRc|cJpl.jfq.'T>\8:v97'>y?l^R]t3T": a& = a& + 160
    Mid$(A$, a&, 160) = "/80ETO42^y39665[_O\|J-pQqoKYQjlFIZlMTF|hCz0*lSJTH-?j/Z].B{w93q;Ul8>_{GrVPf0]HW{hdt'tTdBBwOzgGz[ETjzU)v]RwOHd[*YF>A_H4M}'MLnUn/*7f_OToZLq=Zp),cFR(+J[1Jl-U+\.I/pF": a& = a& + 160
    Mid$(A$, a&, 160) = "GXQu1EdVU]rCPDV?BB?[=a3s--uU\/?O-ks+x'=N[tu=zB9(Qo}mXW;kzp,:d4*l+:bhwYe-X2f74]2lF)TGGPGcJkeJLn,qf'w9Kvo|vFPOE:co=e-(gZ[|us9Mo(0p<96H7hV?iay}aRQc;E-_?3I5bBvW/Yu-": a& = a& + 160
    Mid$(A$, a&, 160) = "4/FpxY0G:6Q1cCE=6*=0i(Y+)4hT\}xQcX'gE7F03wcHANd0Du:Mg>E=f9'K3^[KeX.8Fz,<\:A'Qylt-tk*GB'N\:Y6([Zi\nvi:.A?6po8FUp+SP1^/Qc>3qNY562Qio9'??k[lK9ONlhD,ysZ,6h*f86fc0+Q": a& = a& + 160
    Mid$(A$, a&, 160) = "jgKm/0fA8Tqb3Brq^)gO{nJEi<hxlqMaW=R.WY/:C;y>Z*?/P;kgd[D)G}<;IQ/1)Fbwo?aVDXi59l;D]h9u^rT_+Jj(/OUU+?Uo7SEX};G\y9er.Da[+ZzKLlK0<]GIL}(xw;6X]]sqQYjf)GvR4ApFSt,n(2Sn": a& = a& + 160
    Mid$(A$, a&, 160) = "784frn'J1t}VSKo1:Mw<Ki.KUc?TC?3]X\GuEFCdtyz34eSk_stPA79L1jd)0<=O??r0o|B'/Steksz:F11ESMd<1XW/26n^B33Or3FaW}jC.DuiV{F5ZMbJsga[w+q)rL;/VN)xdDKtFZq8Z0VR3:+fHBcN^j8,": a& = a& + 160
    Mid$(A$, a&, 160) = "Mmyg0yBMIIFZ8rNh=_+KE;SV-:w{2c|Loo}ik;gje..,CL:K7}Pb(>}O;x\m:K{j)M.oCK8E1N+{vKd*zMMFR?5|BFLz2eds[2cNeBcuQHhZEC-B}.V['}*5HG{zL3=Z+/0K+|sL>Ox5D2A6<U+y'vUScyMRscin": a& = a& + 160
    Mid$(A$, a&, 160) = ",ExbZ9k5Q[56^reT-9EOF)H=UysSMDu?z\8z6x/0+Njly2NPg}YkfGLbY}wiMm0X/kdyzI+I'Q7R^K1Ql:W6x<B0'M}\W0s:7kmjcOxSI/Aw+x9hlO+spp=dSin<VQ1MlT(8LXW5M|C}HU^5F]y5(WVsJ:YK3)5)": a& = a& + 160
    Mid$(A$, a&, 160) = "2.iP{.,RW=HF-y9/nL^},._nM|0Tw7QTk9QOft'NO2v(7YMHde'OQfFdnPfTBuiJ08;wtQ*bGs]'L\)oei4<aj6EM9GX',)+cLkqj>AS+Q<QuOC15l(b2Wrlub4]sQ.QCriz-i]0m+.}y:'dK95bu5:l?c(/[Gg=": a& = a& + 160
    Mid$(A$, a&, 160) = "Hh2,ShfdJ40_/;Y(GWH)c5bqUeOFOB[Gav}EIO;43UO57Z=W6Nh=Q]<xS-r?A>30NMG'NuhR>h{IFt[n<wdS.jyih/auq+rdi^||Tw,FXGOdecGz7=pVjrdr}8o?BgTt4sWhx9]{V'gD9mZ1cc:/[FDJm,baeMpz": a& = a& + 160
    Mid$(A$, a&, 160) = "h/Hg=_ynYW5U-=SG>|<YVClm7GJO>nt>UCKX<0/cqeXlwp64)rvrf*1Oo>RCV<8|[Q/Q:ZDGQ2m^,)z^4(ZXiTI5jh>^xSu4m+F1Ci[qWdQLd+^W+PyP8PF4lz[vSgeEnNSI{4;p9w?M5e\z[S8hcH1isb3O=YC,": a& = a& + 160
    Mid$(A$, a&, 160) = "6iLdE8^*ks*>Kb1]67^GY<5=tRTq]y>0t5NSwo_XLV)XV0R,b_Q8xNB0-SKz;vFdJUCGQb?v6dhNv4qsi5?rwv-DR3gqmX>F?sG'^:q-V{=[;ZWtVz(?w<W:FuAYn0l+9k=23r^?Ny4c{aF<[*9uj^{OP-XvBw;?": a& = a& + 160
    Mid$(A$, a&, 160) = "G96OuyXQ3Fcq8wI,mAxE;5xCkWMB\)I35{|DeZ\g<W\aF+:B0O2XVm\}'U+g56n[6mX>t0g]A_36,dttCV\EBXUQs/C';I,{fVsmkvVYzw,IRW<kqQPwB)P:jaGm(|KW-6GN58nfI(k8OiOEWypK*=ccE.0'J1q[": a& = a& + 160
    Mid$(A$, a&, 160) = "?9\thU=p1gbLRw7y]q,SteuA6-F4HB)LKlYHZvmQjDi2{1?]llTD{dqCg]Y513(Vyl(L[ROCZ(D_Ub-U;WwT1tvc5CWYIe*|y_)?}O7lkNumVFjBec.QsA{5Qv0>B]'lxZT;7ay)R;KH/[e{:V:)^1e<9]V>Lwg1": a& = a& + 160
    Mid$(A$, a&, 160) = "z*J/g)vpucq*,Nk<Pk{(i8^v++,vh(vg\[hv3AU/5W5nD6sRC]7.Qr1KmyZ<Sv?^a(3)imQK4:abNBRDiGW0{RUCziLeEC/Iok88s]34b\xx[>h'J0Bqs;vSMsVk7k9qP.'5n=eW3m0y}16W/wlJlWIFnqooiFS5": a& = a& + 160
    Mid$(A$, a&, 160) = "OM^B>uGuw9Yr|oA86b+_P5f>XuV.d\p>?}\-lYM'cWJC|w<xrC+i(ERdS+y]xhi).EKAA9CE3+j*HtJOBdh^iJg?n1soBm'ZCZKeMADH;YD/z]8u8K0]fN+DkLtoB0=:XH]o;sw')6)VT-|LAEB4}<*;|HzJ^qDS": a& = a& + 160
    Mid$(A$, a&, 160) = "97,:wg.55Eze:.ARpA\0xXUJkl,poXDj][(MZ{P_2+C4*dA2do(kIP3(^P4uaj_d9N<PP}yb?g{qcKF/rU8h{c:qvs7C3qRl18qmAiCxURtOm'=UE0HIpR,=s]G=c6tmY[h:{YACB4<C5uG,s2B?]f]3r\Q])E8>": a& = a& + 160
    Mid$(A$, a&, 160) = "aH'RJ{mNP;PBug]8:U5n(iy62Pp.k(NYQ/ZwrtA5iljXcL(j{dB0Y<7x^Ehx:g[Nn|=QuZjSwzOOY0W]6ALo73[KrP-;X7UzPui>nUS{Co(BP8Eax'hNQWcq'2fLYg*{0FzSt=4zA7WvA)2as<b>=oaRa?ATandU": a& = a& + 160
    Mid$(A$, a&, 160) = "2FLjRoT^.w_G3d*qqsj:JY=NwpIpuFc5zb5[kWl'a(4jE);C}]09>FjQSB\)<I3mP-9+jC:J5O*3do-=>B5,+_XnS\kxV1<z-4ral\X0RtlQ1KcVuEbJBV?]-SV2:t7;b:lQl]l'*T=}wUP0K\'F|KZhJ7>=_{GL": a& = a& + 160
    Mid$(A$, a&, 160) = "DYRE}L\Z+rU[WA_?05{8-qd6cGiIAU|G]Tw.gE}X]rHr4s/\)N.)tBvTEs=Fgw1aJb=0x6CrQ(cMPauNW;2QZ1S{tV5d{?_[z'wMumR2^Vi-}|BGJ=2M]q]dqaFd}jynwp9)UhZgs_ohoz;*w=IC>A5<BF*Pc|F]": a& = a& + 160
    Mid$(A$, a&, 160) = "vejhvAxg<XILqf|WE4Ix)<+7EF8>xg0>5=t9Y<qTnhoYfj2{0d]<Mra},sU=5X?l_8f_zRAKS</T.<to^'7}KuUMJvCmz)8e_GSH}n^;m}iWwRAH-b94(GgTK\>zGS<h0vezBAL66D>Q}(-Q\bHZ9?P{;(rYF>6D": a& = a& + 160
    Mid$(A$, a&, 160) = "]eAI\8GzisFFx^({FkwPT,7,cgKm\q<0vXed;j-xtiaSuor2T|0VQ}-_>-hU.8u3+6oD-5rv(Zmn([Mr_D2'KB5e7hauZ:pS(8R{-pGL8H_8^zSmf1cl-*5*yAn_K2JNHXvff\2ZPoIB>Ma)5UH'F'=N=RlFiy+s": a& = a& + 160
    Mid$(A$, a&, 160) = "Z{6u<?8?Do9>>VV5q6[?vN*=^Dt4LRBX2axlh8IC5dtpJ_aN_{QI5\'ke'Mkkp_Ii,AMKI*AY.LY[Tr]f?DDjc=<am|^wboNs+\=P)sAy7M394<)H=hA_u^7+o*Za*SZ=HI/khX\F9vZ{*zxsBX>^By5n_^^b3)K": a& = a& + 160
    Mid$(A$, a&, 160) = "rL<N]GhiCsY^z'4UQjgg1eJTA4'5to5ui>W\mrN)QxGF2\VcJcBZjVQyVuS>+MM:dE2NH/EZ[F0-Jq;cAtM:d-)C8qyU?CgRWAM7eO6^o9mzJvYp|oT82KuOPQVD7\eFalnXECN.gKnGq)/CS>{1M>2L9|.FNn3*": a& = a& + 160
    Mid$(A$, a&, 160) = "iZp9;R5\;E/el+|.,+3uv1Zs,2-eDQ58f/ajRg8KZ;:IGACSAfEvz5P<F8y8ei,kXp-n754h=GCGg>j]9lgnyPG>}X*IU\8pu9.Wu/(A0x^/[/'^-j,}3_mX8,H|DN?{J9LA,9^Pmq2;ZZTGVU9go?qW5wR>n)NY": a& = a& + 160
    Mid$(A$, a&, 160) = "^BSLUb.-{G7mf6/+jv){Lpm<15H66^DvWbV}O7)(6*\l^S4]nNvH,P;T:QjwQEjNoj5.TX4\|T^q>aTlM4(L_,:DP8..B6+9qR^6{deHb[<6wg<5K]Llq6GG[lz*QO'o{\FvYgHroJzeq4ZY=):}}[pZd5ALQ=H_": a& = a& + 160
    Mid$(A$, a&, 160) = "[qnrA[dSB5^.sZqj0g}\i.AQ|(RcT_(C]I0(Y7Wm{Eu.KLJJeg+wM7q_po?A5KWr(*l;Ux{nC4r;mF;WiiPnx*Hy>h=K[=H[d(nsDx,A+S^BzY(CV)*>apUc6H{7>2ns^k.ZfbF=F(_L\,-md|{0q2Vx7n8unk.C": a& = a& + 160
    Mid$(A$, a&, 160) = "Kiq>HMuO{'n'GRHil}IM2up8TpwTE^Ls>3=UOqIIummP:>9<1e-;(=?RFm{]01xg-v'Ph9plM6T]gePJok2I*B8|o<t^0J'Qw3U,Uo8?RgIluCKKM8qd-9}Wbh<ro0vp;M8Y=yNz';q)Si.3sD\quVNssZ5<sWis": a& = a& + 160
    Mid$(A$, a&, 160) = "/k2=7q^*,Z(e]]\WWr2IWWI.XBh8W*1K1QHWsVKk:p.vaB4jAs:.0:/Z4Gyzg4*[\=*k6c/T<\}D=nDN*jE^,*MPwdtXNrH,V0;yAF{P'Nn*lMr5ysVs)YX>q>i=:lXjhjRuf-KLQU'vHHF0C80yH\Ob.vjM[R|U": a& = a& + 160
    Mid$(A$, a&, 160) = "|u,X]H^vM5:o+/V-PPnc}UZUjpXRXvMAy:zg6}?179YviV1|(.7hHwrq)Rx2N5nof24o8/>=8ak>g+O^LA6vsN[)p+5=(=[)?G9fGk]NxBR05\^B8e.|zjU[[*>g,;/n>SDXPn88P=Z[BjEgR.+}x[1RwE-?6(H1": a& = a& + 160
    Mid$(A$, a&, 160) = "Fcf6_9saQ;jKXY|5i'}CI?+'90UOh^FBE)lDD;Gz2bV0KehLHn4kR^7a3e^hYStm.]X,>}M+YlgXK\_VFm74{6PorQEF[If}klw4[yyK{7=0z9/i(CDAuAl(-ne/44M7Iz^^,-ld\zG(2a+vCv4)wfVGz2r<T{<w": a& = a& + 160
    Mid$(A$, a&, 160) = "8F_CRGy5dOLU{[(q2h1X{,.K^_gOik^/07amk0BBeo{FR<uTzJD2}5ONm(fC=j<[<wL<m'cVfsH95QD8HhZt.cBP]iI8pQ}TzsmMocc7w8kZ]|glf.6?_9TAVE5O.{qoeMWv7YPHrhQ6'nT9ulaCUYOuL9Z?\6h1": a& = a& + 160
    Mid$(A$, a&, 160) = "=/0SLe3zMy{DFmKnv?|g_CVOJtsMSNwR:qeQY/FR}(QPWhy};u]b=VKjB8/xNb1Qo90I_2Ji[nPIuE7hN2ML|pIC>mqPb+7^U+cV*.q>+}K*pkh6ffFEcf/(C[2\4(Kb|3p?DqxULhk>ZKW1y9]uaKG9IcOqlXQ>": a& = a& + 160
    Mid$(A$, a&, 160) = "8LJ8(_Bj>VM+Zy\o?WMniJ{GR2y|*vxlz<R*?.=NPB1IkNx3'HetP?.C8cM*Pn1\NT6LDOEBLz331B3ZW([|4'J?JYc-zqt.YX:mO,tR4f5.}nwDk188G:LKpUTLE/Il7U}a7q0UB{jGui-UL}LriCatEIy)T9H_": a& = a& + 160
    Mid$(A$, a&, 160) = "6q)/'1Lo_k)TJIw0l:,*)4Q|h:_Q0|0<5?E=8{_;42cyn8CUWb;e./USCIXZoLi*1C.wcEj)IG/VFfI(rmiDa=LW)gLD^qU*8?Y'1E.Vxlh7(SHsMZeq4}z{6)M7FIm]6Nov8xzn^.r-FZE:]Sq/|bXT?hk|-IhM": a& = a& + 160
    Mid$(A$, a&, 160) = "hfTSE5.p[2NMQk7>K-HP5_5fy<z+?*Hi_f{shV]3K;,}02unCGT^Rt>wo^1K-l0e\:Aj1P*\5FY->LS(NLuac0Lzv-^oa9lvT^F'Lv[EfC\9el_U2MkDvSAsiJjW:B=n-SM8UvlReVmrNyjF2hW4\)APe):Q87]B": a& = a& + 160
    Mid$(A$, a&, 160) = "0D8lR:sWn;QAZ.s\E4-Sv7\{Lm/+AV^5=dy{ZFauh>eduai)4H_D(/Kn^.]NWX4||kC+O0F_S}2'q<(<uz>|}Ai5.J,8(Q_:Dd(7NG+<;5Q*uaQ+Q/Dx5fnRAMF:3}*JaTLd.jmF+xato+t?6xkho]pu}l.bixHt": a& = a& + 160
    Mid$(A$, a&, 160) = "U]ZvCU>2?cj_pdt2?77*x?+pwgsn{hXloaD3O-]YfpAGY(trqtOoT<RQTVNL[;O'N\SICVbZnXZ*ezFB5__;_'4lp)Iv8LhjQ,K6M:Up(ak-1O+4/3w{_QIXn'l:APko_Jf3qtTt])?>)ld55_YW/GGp\*g3pR+W": a& = a& + 160
    Mid$(A$, a&, 160) = "j^Zv>_irPUIB{EZxq7ZXxMz=oD5csO-{/6l1AW)'n1]p+|Sq9*xrb7N5XrUG*<wrT<I}>(M]\}}),TNd=NV,ZR478c6iJmqR3=;QuVigz+<bY{68au2EbL?)rtcw^^-KOS<I:u}_hOEw,qT,6l2N7nRc'G2A8GBW": a& = a& + 160
    Mid$(A$, a&, 160) = "kpM<U]yWJ16nf)_+kSeo27t.5VZ8k_3QU;[SF6o5HqSd,Esohb,Iui>{4;</S1h16.LH\i'I]a2*NO(bctKHEoNs?ptGe\<kkEcdddeSjao81]81q]'4T7T6wSyG8{HNG*)OuH22fBX''c[[D>->OIF0MBHR-1Eu": a& = a& + 160
    Mid$(A$, a&, 160) = "JKt9h3hE}?Drn>pTZ6x,(j;1tD.83<wTuzw=mZFm.N[8J0>GrU]j.(wb1Kh^G,QW-s0kbFf.8duzTVdy<([SraM]YcS6=A3c78gg}\gH|<r?V(vI-+FEI:A)1l7C'RpLgN),jOL8,8V1}zdFU<Ahw10aBYpRIpXn": a& = a& + 160
    Mid$(A$, a&, 160) = "aTE[VwhqP*G>IU?n(ZS/|^qIo,eG{pS_5QPkTZ,g<<n+MSFFe'6b2Sl*v^Z2Io.ER>opxRYXBBV=leHe]16\vha14'w>8bfNmh28B/O3(h/QTgiT)=:yOPQm2)8psfq]v-v>e09IpaG6-z<jw5'8H1QdO^-GiT)-": a& = a& + 160
    Mid$(A$, a&, 160) = "0<ZYe,+T,_Ceeu)*s)tK's0j0qYtkO[oyUPFqWh1i133Vr_z16o:fC8?P?t<8weE/o(fJb<;w3Zm9wK|he2oJeN5l,;sBv]{vrPG26*Sga95qC*0{^meSeR[P^oJctBK0.khN{0o0GvC=GvsDrXYQ5ma)cG>7Lb9": a& = a& + 160
    Mid$(A$, a&, 160) = ")pUO1HAj./(ZN?\SCBc8|<6Nb15//\v8a|{P(p.7uNh?xxhz.8u,O=?tl[o])EW736kJL{.a(VXyLjNgGKyNZp4,|7\8rAof[+jzDW^3pAg],N|-yQ6{tj:v->G6DxQLk}GHYHRwqz}u?Bf,7hsP9.9y=Xr62?\E": a& = a& + 160
    Mid$(A$, a&, 160) = "=]D6Qt'HX8E]Zk^dEC;ux(mJL3e0)6YLV*emWr>Q\z=y^q*Io2lDszE(PL74H,W7vgU<[JVs}k5-fnp1'ur6Ltlv.h6QLzQ+:E-*'raL6M0t[dTmswM6teaOO)eRg/rE];?/6}{NYN|i]RuK0sV)gQ=6.r*od'}]": a& = a& + 160
    Mid$(A$, a&, 160) = "NQ[4KII.6MchC][PD+Q.tsQ[EH[DLmQ?mDq3K}(7;y;[GDcq<U|<?/<Uf*aH:h);Dfn4m>zs1>RoF1IckN533M4k]Jqx|Sf4WDP^4jpbX*os:8|GoWuj+HTe[.bgN]zCL>NCKY3DQa8G)'zjagENif{<a6L62(t^": a& = a& + 160
    Mid$(A$, a&, 160) = "|GO-VqCn2:]R4P-LKv[,fI[\\J+'fzH,/?w(l|hvk>pBodlLA*,5KD}I(:{;ADjm2[g=gMBcn2r>9D<:mT}a+4_^PzwG6jd=[/GKBymMBWlLE9p2i9W[apSS;E*eXVI*tjHVSgh?]Ce{6nj}Q.jS3/OBhg6e>gx[": a& = a& + 160
    Mid$(A$, a&, 160) = "G?3=|n);xB>bDEt:ctjrI'/RXTq{:O>6iJ0ez+rxc\c4awOjT)NMoX{Wm;6ak't0.:zVM{U56Aj9?)Mx'Q?UIxU9tK=da=X\:MQ.a[CmKYCoj9,5+>KB]};wa=8xoSe.e8Tc\v'bHj{=-5j?UyhnpQ{;vj5+T1Qg": a& = a& + 160
    Mid$(A$, a&, 160) = "U9kcu?/k2z:1Z^CoR*aC_3B{399)LQ?Bo_vyID)S|,ct,{E^gmkQrV778CAUDsz>*_pv9}JhA<eEjjiJ;O(m[]M1T5Hjyb+ik^{A.U6uCui[E?]hO-Lz\PQj3lGegnLUAF9dx|RrV}<)(mUOwu_RYSIdzEGIp<+H": a& = a& + 160
    Mid$(A$, a&, 160) = "vfx]]c]Qq0y0*1ckTMKB5-clAGD:c}zn55{>eVDgG?/s}L=T1U??_0V,Sx11}cb>M>V=44s/=1V+(Y.aL'FzfjdQ1YG*5IteW}W5CxGe8dI]Y=Sfm_IZ/aB)fbIpWqa?zp9o2U]J\Yt5XKm1e=-a(Z'GC4CT.Fu\": a& = a& + 160
    Mid$(A$, a&, 160) = "o_Lyi]q\oPu5+4K2.B|CDl\skH?5s(u.kQ0Bk-bbO]c1'ncFiX,V[MNLj}Uj1B{Z08->dbc]teDht7'|<V-|Wp-Aupgafj56qoKIJcxWRF)<Ul?REWXey4Lnq+}/FJTmWXDP'r02zsAYyEQe;AcV}l8vwsvKNe8W": a& = a& + 160
    Mid$(A$, a&, 160) = "jn<k873EwI'4s,M3Qr;kexezGN9_Gbw>72M^?HU>5C2+KS(<VW^X|3_TR8v8|v,QGUyg?0i:|Byi^?-fOU=\TThv'N8U^)'RV-B-BP8L9k.9z|IFCV\+i[YQU8?QwuB[_;U.fREdpd7hAJ.VH/q5\Pu?8wn-5JhE": a& = a& + 160
    Mid$(A$, a&, 160) = "N6Z0bPGVuO;Q'Vf'DXVMlYIeV*o>h=:ve=rr{4x3/>|H/KC0/FzD*c=?NClv('-*5HRFGoBS)t394cao)1N|HiRT]r5Kod{KY?69DPNpa[9/pucwAfh.]Y/5xA-Im__VptLK52iHDfFX+6=E<HJNJ7pk7X.qr6(e": a& = a& + 160
    Mid$(A$, a&, 160) = "M9P)GWnf2JZh1I^x6vsAIQ5CQvX_]1Co.w9g{9/H[oJa2F)VmxszVOW7t*g'(MTN9XlL=z)B96Qryv5V:9]l/(9m'[7svv}E=bP\byGZZ*FXf*}7)a46PK|qgNi6Al]9bjlNPH4Eaqk}wkj8J<RvW)gly-JM>efM": a& = a& + 160
    Mid$(A$, a&, 160) = "xH,BO?<jd}ImC1QZ(JCpdBzxM>lznIS^Oe9Ctk4p}OH{)^_<nLLAFT3pzz*1gB_7>GxWW=A;aw8oe'N)JH_LQ>bBpCX55}9{0h]wYpm\h?YI';SsX?W5*y]-}u5e]Z2IZ,KWOyBLm\ZDTSsVA{xF(k'(0h'l3z;G": a& = a& + 160
    Mid$(A$, a&, 160) = "S?J9xus?:(xQyj.3f]o'Hg:Wi*H9-GLN4ChJPE[|*zgHm'6(41'v-Dx,SN0{{s5NN.gv}qdZ(Oh{XT59[L45E6ruv69zgZ*V+tWu>U[J6)FEW7*7^:za+P]WgFBoDiQPZt;*+9D{eerhvfkI7kg3463Z9*i+H<Wt": a& = a& + 160
    Mid$(A$, a&, 160) = ",>(8IeYtA{?3'O_LFW0^7cASBB+x1xjO4h.dWzx9'[>d+g.N[kcrYZM*DB.n?47TLf[l]}y,|pH*c}9|zh-9^)V<ELl;aX_BZ-]^_*wtrdRbHdrdHK[tchuYA_hi_x:}NXwBiKub1Qwetc94-RBbtQih)ZefE6DJ": a& = a& + 160
    Mid$(A$, a&, 160) = "6+-Ru*bVQZnjSj.66u9xjx}{t/)Wi^3J/.avY/>DvyUAAp\mO*j,jIe_\;,h+kVR06s:A[4T-9y4Y31M?i}(nKjb+n,X4'x{j\r<L:Z?7thM8N3?U|(Hc,QOd;8Z8G_k_9gfykZrZ5{}^0byX]R9t?}5NOR53e*[": a& = a& + 160
    Mid$(A$, a&, 160) = "QB5ENUq__'^PE\yvK0S7HT05A|6]|<=c[vo_9bJw^AG{DqRZ;f/)CzKB.RCT-<Ld1P6-vEZgJv47jSQ,GU78{s{=s4gl/}NQgy1<}FP6{/MRa_bK.-X^:-OW5ZwAzI]RU34>2yOs>wsmXu-]s(P}d5f<(faS6U5^": a& = a& + 160
    Mid$(A$, a&, 160) = "_,5(67NLA25CtY}PeNuGKKkFW.KtC7zp(hH/1[(+ExY?P2F]DcUA(*VmhV-<PK'JmGzLPpQxKUO07WE{<3aUf;)ct':of'Jn6,wD1oJB4-nrm2j(0idanHLtNmdEIqtu|erfgAu4nD{z1{.RhNo8YJ.J*Z]bYl-d": a& = a& + 160
    Mid$(A$, a&, 160) = "pA|<h]Bd{z2bl{_]/C:Rh/|abUjbhdme/J<Xfe';ZYx0Q-3z((4/rFK36HqTr.NeBlD(7j}7>?tjo3.\zAH{Np1M7*Wq){sPKKLJ-I:g/IhsXDu6aHq[o/ViI2j1QNb'I7S\aJ(?W;p3nTv\dRoXkpwLS'KGj|Uq": a& = a& + 160
    Mid$(A$, a&, 160) = "3S93H]bc;=N\]qJ|jronQfe}NXc>-,KrOe*PiCAbTN;H:K_UL|[r1mdz7i/mt?-'m+PZkfP{85|xpzv-cJq.cipQ,Bn6+rZ;Vnd]Y-_Vbh1p*ni[sz?,h8ssvsB?uE-V=0-[cxyCtbt|5w/wv2V,D=7gG><wE(cc": a& = a& + 160
    Mid$(A$, a&, 160) = "3h|C[.Iyi;:E0T'WLj-b-E?;=t)C*phl3hk<nOhLGH2Y1x)0a:6K||xX2I{(\[Z:t0q.FkZ^DJz0<q34_GT+f,W2DT.\9^?};n92sl3.hx8RnUYNzFccDTT_lTNC[QwCaQfa2h<i]zr=L2^=tm7;*rlympKMMAk1": a& = a& + 160
    Mid$(A$, a&, 160) = "-XQN=p-ApX6wN)*u>MfYK+iUt9LVLorZ_5|IO9},jrkf0tcYfK3Va=>;/h1+{j>I}uU/,^Vz(GFjbcmb(tt:y7CJ49Ja^Tw[n0[W>/TfTZ,Wc5XrUMn>mLw95ubFi{9:D<KG(r{tR;K9Tk]bRW4yc|NW*^S9O^a5": a& = a& + 160
    Mid$(A$, a&, 160) = "Aa1^OawnFG-RssvU]4slt_.x5bjUvg9N,GEcT\6,7Kn,Mf=9zWswXv?)X'zq=o^ia^Zs-]AJQ:Jan-miqfrO]x1^u80h,uA=G(T*^-;GMa.,BLwC0^ek,gWEG^J+\WCvOn26MaM78mIJyp_tFQN]);L)<YN]]sYI": a& = a& + 160
    Mid$(A$, a&, 160) = "xbPQL.5eD/PC/?h+3,7\wH90Fi+ygE3lLW[0qcFtRpNH=X/6LdRSKn6lC/NDz_VLeq=fA7Xa*w3^X7rxps,D(Ji?^?__8yKM[:{}uf]1OIpY.gJX;L\)frSh/jib8vT>[-VV{MS|w9h\[5v?EGVIlfXyAXQ>ZF10": a& = a& + 160
    Mid$(A$, a&, 160) = "Q5P;RPkAv6Qgb-E}UN{}/foWhPJ_|'o8>Z=KejDJ=NK:=yFeK3';_QSo9sq,NT(6uI=Vom<3hndBEKyktPC3j9;+qb|pLqWbYEDedQqt^(y,,JWFy2DnO2YG9J/-sUPxLBc2{Mvac2sX0:jYv|5-w2Gr|T>xEO{i": a& = a& + 160
    Mid$(A$, a&, 160) = "jP(:FCHED<CdEb)8xi97=y?.ql)C3FRh{VWW'8aIGB_Ja/2YMRbZx2pePqPO?E=ZmJ-lX|{1QG(U{<xHa.+u/pZ<:ktVDDo;5-yO0.pSe4O<u;yHJ*D8ux6KPZ^x(|;B]N.nZ;pFg\4NQhl{JTGyiY'I0BAUJwLp": a& = a& + 160
    Mid$(A$, a&, 160) = "X,}_85LX\8DuZ6bd^dpfknsP+^N(juEH_<:|?arfgWc[z_7T3QNQT'_hMBpT4F+.:AAo^tm9\i?YEEh0jhj\e-B:kKC=:MJe5ElYwnCAY\+b?]wNBdZz>-hmkNd?I(k*4l?\^eQKoj?/k'jzg?TOWE+c:KDE0ze[": a& = a& + 160
    Mid$(A$, a&, 160) = "f_2AnR{(Acyxw;NpLI<6]F<c?xT9?LeL?z+K>h-_P[2xL(E\VNp[N3}Gw:Hk/HU946)hg7<9l5/sR30HXL;S}<n9H-bicSSKsqa;k9Gi2=i0eZq^E64,HK6Kx?WN|]s<K/yOyVl.Ge+H-hyD*R_3,4/?}^1^S;{.": a& = a& + 160
    Mid$(A$, a&, 160) = "9KL6.mQPjurfAQ;P^+*[>Z1A'qW]6DpAK}ye3[ntWk_fCz2:F,e[9(jTKSf4?IqH>'PaBab+tvLY5Q<Zb9'V]7)imQu?9MWX<j32?77.|qKlCs8703Zcrt+<7kv+0RW(H3zGXeHF6tgX-X({NIpzR9.qCfFb;*)J": a& = a& + 160
    Mid$(A$, a&, 160) = "WJRJ<i5LOLX^m4kgl+[\CHD6.0J;-9IIn3_]w-t](I4^j'F-\yQX(SDj4:/.3eHh-1;A.2Kd=i1aBXmjcF,a)1H9d>DMv<Gw4Pn'(I<Xfp0{H4GtbQ<uzW-]uo0M<BpY(4r3Q-Gbl]*UM1>9;'Y1=_H+^>S'eU(Q": a& = a& + 160
    Mid$(A$, a&, 160) = "bb)CHkaLEdzM?TSZ\rLtzxWw9K3RM1ABPW:yCk(>zfB-:7=Ro}9.[;F:oqpPt-H/i[0XqqBb1Zm;VLe0}cGg4*ScY]qQg}]gau1X0v42OUK;18?Hc-ym4|Af([I4laa1G{*jms9}No4^q\9/?It>7^lTB''R_-6z": a& = a& + 160
    Mid$(A$, a&, 160) = "|9L6>L1'b7BKGNif4RL/ZN:cV1WQAZ-t<N[8L0FdKeqT0*=9Tki]BnyxGd.>5]\:{\=7zensNy2kbNWfvRLFXA7\aQE5bN>vb{odrGeeQMRPAh3w3z]h[T7ds5zV7FgUeoQVEPjhy.o6BS?O7'2DgX6M\o6:C)u}": a& = a& + 160
    Mid$(A$, a&, 160) = "o^l|K]KUDf<DPd2fTFqPf]VOmpSev>?_[5<A7aK<1^Pu-q'99,DHfZ8H7_m+AqH={+j{{QUH<nN,IB97IpKvU{[rm)6{0kRYJpmw\6kMFdh[Sql_|(1BOad[H[Y,2';W4LnUs7^_F?t;:Slxxm2S=b3b8SLQXv),": a& = a& + 160
    Mid$(A$, a&, 160) = ";z5K\fmzu\p9i2iyiI*ghXdeAKpK,[C[EMONA1^;]ihl.*M-=?XT5o3FVICc2q/ycto/,*Jo6Ocm6X-E9hpPPBCW34QgeMX;>Q\x7M|40_E5zNW21dd|DBon,KQSa61-G]yho{:|Q2<ebm*>?tV6MaUT/a<LxxtV": a& = a& + 160
    Mid$(A$, a&, 160) = "Il\rj2;Q,p|NR|Sog^;,_0yf96P'BbPK^P4W/xJbHEnYEhk5kRV^xn([1y;S?9M[mQ;;*}IH(zIM.]1os,mfjH>|wv(P=;(R2r=n1dw(y|;3ZwQY7R*7xuhCAY*D>e<>Bb3w=[|_9U36H;'G\1zvSVbq\Pi\rD7l": a& = a& + 160
    Mid$(A$, a&, 160) = "4sxh6aTQT.pnwId0fbnd9k:>U9/p;O=6*CmQ/'Pu7A04etT9[KP,Mkjs8(g\ykO^.0>;E6<t*rls5.W2]G\|_N;>A7oP6{FQP0p2iilNc}Z;2tcx9K=7uYb2R8?v];]?LSN8^evCZ{Ip\7^Jf[57\+aLITS1[i82": a& = a& + 160
    Mid$(A$, a&, 160) = "rm.EBtBSb3<Kv'Bgg4Nf^hHWMCj;o/:K:>*QQ8ct9fK?y\Yn-WSk[Wj[:^qshr\G}E.1b4fU2jjQYbX+tta=0vKP34;pSUk)d\?Z/so)9shFh+e0S)DmBSv5g+Euas'[;cUGGZjRkP*fI3Mc3r<9'Ch*2MS7XEEE": a& = a& + 160
    Mid$(A$, a&, 160) = "Z8Y2>(CO_>k[*HlfM,rJ5HAiym5-/sBO>b>VDm?GbcxW\>EDHQ.ee\[0g*dq(TVNRm6W{[/GJp-0CBvB]ZTl49d(9cP2sV0gHbZS0j1=wgCO?1j<CM-wV[71n,<2s+N5b*ce7C,k6c2^|5:odczCD<It'<OQu(V+": a& = a& + 160
    Mid$(A$, a&, 160) = "D<Hw\E+ae3hzPq={,5DACUI*9Z99z]NbM,j?,JrxG-EXdn4V1pP(T1f;0c,t[nX1kw4vae/:,bl8zU687YcU2HV9;8X_c=OXVB+fmXl[>px]1Km0dYn<:xFWPB0b^OC^N;zGiR'd-^ZyR0C?{W*SK^YZWNYNJh{<": a& = a& + 160
    Mid$(A$, a&, 160) = "aw++Ai<|=/c])m7iC.K0R,ST[.r-vvYAGOX<C2e/q<C\eU_+kg=8]JAxoYfOUkxVlOMt:f?gZvQZKaG.RE.0'TZG/8oWt7zk_BZF-TIUfo=VZKILRIztB}JwMFv_0Z0:C0]i_d2]+c{gldHMjPzK'7k,^Y9UsW*K": a& = a& + 160
    Mid$(A$, a&, 160) = "BvkzHjsP(=ZN:^P/o-iN}0o1t'BI2TMn)jR'dk/}x('6WwJn}*8.bbHU>.o8_UZY9BLnKC7t{;X5CY*'WxaH;X;L'=K.z{>G<{NnPUT;<-t(PdiuQMDN.c^e1{6QU0-DCpRch_cf)6^.4:-msT5bwL{;-+iN\)as": a& = a& + 160
    Mid$(A$, a&, 160) = "D[aFy(Pm*9(hoo{zD-gBj_y7X.p(P=js\|^G-uK1,18v\>jf)d4y-R;jg<v;M=2I}Kn_Y]UNZmD/f|{Cf=_uYEb)6Yr*ePbSwq\t-YC2iMV,Rwh'}N)Xt3eUG:<3e\RBhurZeo:WxFnnjY0<]5nC=?6ZoMjuB\A:": a& = a& + 160
    Mid$(A$, a&, 160) = ";oEq/HpVRdk9i=).osL?/vt=k05}xHl.AxrC48W^FBbXf;:an+i3T'FgK\S;2b1SQ6sMc{u6NXhGuzc3M+vicakUXS[i9u8=n,|[>Sc>rGQ4L8+e.Svd];Fy'nG4D0zC.xM3KcUN2LL+-5CF:F]K/oXG}N\>ZkmZ": a& = a& + 160
    Mid$(A$, a&, 160) = "]HR(1NAvGO4uF\L05kp3p.q0F?Xyy\:-5jePkQv5ldCFiHe3NQtegR<P9t>-?W\vFNEpdTIJvQ|q1Q}117'Vz7lz.3Cv0a\-AVnMq^I0dE=I3vTi)\diapxD8z7z1F'vcZ<N<r;HpV,ki5I(UGEMLp2>3PHpFdeG": a& = a& + 160
    Mid$(A$, a&, 160) = "\paRr+PEabV<(hYmr5<33w'/J:MwQrQz}11f]Q=e^?xw/GKCwPjX4K4Qa->>cLb0_cuLJG(k4rO5Lhy7^0h^?d/<GZPRSF4tKB0,'3[zC)Ri|<ytno0mRw|gSyM7n4<Qy4B9,Yq]sI?(j>7,U'6+6YQwYC>+;wn'": a& = a& + 160
    Mid$(A$, a&, 160) = "-N2lDOMX=d3Ca+{ix)?>c73l0mVGgOopF1mkj;ZLlb_W({Y/RhPL\CxqNVeWoQ[UlL_(0CtV|'SBZZ[nahMe>_OWHn8qr/.zr\f6MNZVcehyNq24AtuCrO=|Jb:x;Mk}za,07nBU-j0dWzrT9/U('iI:f8CH]-BB": a& = a& + 160
    Mid$(A$, a&, 160) = "oVLeI^h|P>mmy_>yuccLyA9BpxUSnTQqQRS3TiG+eZ_PSoIi:DN\6vRWTca}Vi5rs'aR(5WTZ<-nn,wm*nPa+d6_(xdTWZX<x_mfAIw(q_VwTqIjB)Ua+:0B=6)=4J^F4?s/3(?OFBbAVb3Ai?8+F8)Owbxk:F+n": a& = a& + 160
    Mid$(A$, a&, 160) = "Vl(p1?h+cS|<4Ac?YUqEWYH<u2rqR?gKG*TR7GQ5EIji*hu5hlL4id*1y-mcf{*2zX8|pbLySFTfMR(r7WqR5>[=N>e]=T8SImJgTb?}Dcar|)/:7oP=j*kottmeZM1D3TVZ=}Vt-H{w7NJcKOnktJ1OP=L\S<0|": a& = a& + 160
    Mid$(A$, a&, 160) = "vQ^J;z\mZXKa[Vj)c>_8+^-3?_gcNrVq;}57\m7piszLqbA0oI^[-1^ma-o?<f51T(Y_3SHqq1Q+=O1St>jzD}ya3kQ8<1k>cR:'V6pD:?sQZRQRV_u(<out8;+QQ?z2FxeXKcb-B>3IF;w7I4p{/O5>wZ{0eddH": a& = a& + 160
    Mid$(A$, a&, 160) = "Au+8Hn?^orIcMYZ4Frw,jFLTjNq:5=8,lGNnLg/O+]N}d2QU:p\<_<|-LR?B1RHRKY1+|<JZRcDXEG|NkB-vp*MvWc;s<hGjh5)LM0FmdI>Ks--L=,Y,vK+FpQ+-{QV,Oqkj)NFR70/7V1X>f|o3?nmhAf>5SM<^": a& = a& + 160
    Mid$(A$, a&, 160) = "QDv7+5IU.}\GuR\u?]7}AS**<]S0A]{h6Bdal/Kt?L3Imtpc[N+hN,j}wN=NB]92FMrNdPeQc+Q?rL+8VheSMwoK,{HPZ/iFV>NxWA}v^c^XBtf=W?b1IbYiP[MwW75M^6R:p|slamy'u2K(xZ?tgpp2\4m)<}08": a& = a& + 160
    Mid$(A$, a&, 160) = "{X:<9ix-dfW)^0DSuTxI7lTwdvs)poAVjs^t7_/J39Xc:oe^.t5Wx-,2>1T{JUm=EHn?Vt_;OF9UT0mW+UUpkuo'>PtA4pW3SqDD7]}Z0,*--ch=y}\uD+\=Xy{GEvmMXk[C[-,qCqjbmH:?)>U((2'o-3:C7?Gs": a& = a& + 160
    Mid$(A$, a&, 160) = "qSN)QTnk31r:,U)GvFr(a/99EQ9h?H|\ZGDE7O'\{C'1IT>q(D+ppP}?It,*mU/73W53MIPRlC1ylmdQxw-A2Lo5::|euvjko)(w5UkB)HF6g?q_'FwM3Bb*ijDeB.6EgnqCCLa)pX<R*?IyOBPlScSDXOj]eo*}": a& = a& + 160
    Mid$(A$, a&, 160) = "LHSWj\Z(I'TR\s^eMMssoI_y0sj:rpx5E_b85HVdofgK}=.N6N,1n,|44[,VAjA=66E-J<Q2=tUzyti6}x.UQ,T^4,-/o3LooS7'qx0z*4Ob[Km]3F]6jHtSA,NH>'uZvH[zS;N7rHTx*2s9yPhhGG}eyEMyD^28": a& = a& + 160
    Mid$(A$, a&, 160) = "K*FLbkH-]je/KSQ;A.kVtYU?E:kkeFnyArsV_GLhzJj_1\sj'jZZA)_.4>;*XQvfVR.CPc[.ReTQoEyq>c'}_B>c20tp18NZ9oB7Xt<rx(pG.kqLa8)^\KgS\9q|9Oslqb/=liyopo]dz<izAmc,JIw4EQ_Am^YV": a& = a& + 160
    Mid$(A$, a&, 160) = "Z]h/->Hz:l5*iuGgV<{;9ta[pgJa>Ht>m[S8^A):mz:yC{3E;Ret,t61aDB-^.t^ACF{UHpVzBU^Z*c7XLJlpwHJ]4sN[dSw3xZoUgs3pinLw[kltCb39^tdeo(uPr0krV*ceKme5]uobO-(W?;JQERxO|\J6u2S": a& = a& + 160
    Mid$(A$, a&, 160) = "WTO)j]kiZ(CjnpF/,=s1i1omQtMyjY7IshdtrP5G-y2REZjPb?j'0}KnNMPzbxFdx/Ud|6ffg,QBJD3;*lFenJ<?>Jm=*1j(Bf{./4yHwjk43sT_FE'r),pSlAM2)fzs_Hz0-2.E*6>8P^_ag/hrSW-TESk5hCQI": a& = a& + 160
    Mid$(A$, a&, 160) = "sh=A?>M11-;P7iqLM3>t(uxGTvtPtS6O7Txcb*Aw</vQIi=mJ[{;yh^ZM;+4LyO;-A;s[g>NAFBmTWd=1Ab_,uV.o\it|1:88[1H^h+QAsUUA+CC^uzz\[SlhO*pe:'_+8jBq0QzzbFPqtyYQR=qKAxNY3+Wp(MD": a& = a& + 160
    Mid$(A$, a&, 160) = "GH^9o3e9DgM_,_NpEuL\/\3B(;hVZ(dE,7F6o(o0wBYwaXWV3c\Ma>c1en}=QNk'rdm\gaOzLK9P)5fzqeUxr+DIVWpmtBl.Z[6(wtjn2d;_x([3'hrs6e|D45T1YSrrQUStsjI|';|_1EX4mq7oy,,^yBomKn,w": a& = a& + 160
    Mid$(A$, a&, 160) = "djr6OGB^oWv2h-wBLo{nGCYc0yAq/2qj)0ov>?Aj[A'\'__3ex{9nvWS'R?X0DY)\kd>):MFUR4O[yuw4-KaaL'yw>6]zYb'<t-0[CS>yk=J?sOLCtuLF(Qc=jRlt.X7k,]1N8G6'',Z,zWv+jXkv2TbBjT5aA2=": a& = a& + 160
    Mid$(A$, a&, 160) = "E9crLw/tvEA=3<3WA.;6[cb-tsp;,'aZzn5('rzqb(dzG;X.Mt(FLz_zVZl5.l+vN'EOhE]m}?42K0cimaD/5jc5qcKVj-ZhPwCBW4R6/XLm9KbO>N?/=}hVGq;ti?zF?.x\^7,le5A>ZkLDO-]daBapH'<QYR=R": a& = a& + 160
    Mid$(A$, a&, 160) = "T]<]edwF|[OXnd4_j4fF,nu0;hPFlBTWM{Ux^rBTJhix-]dzir+/W^0QT8PJrdvcYyhmS25[*lhhP0A93r'k^Ct4}a>xl5}[=\sb<+m26y6k5S2yc3Q2.<1MnFDcD':R(PP.ae/y8gvCInvkBtDxV::]T)a}C>-H": a& = a& + 160
    Mid$(A$, a&, 160) = "e,953y:HJps6tUN'Stx(_mcvn7,h;UhR-+<O308J^Hb<P2IU>|H6Sl|^?8|t0-.NtGQiW=S2kNQ+)*r_t84^xSN7dX1hFYQ6T/gMA3*RkhImLJVe:ZBXnpA7u)|gjLn\=7jLmT7V-y==T6'g).9Bt(-UAn/?o:'<": a& = a& + 160
    Mid$(A$, a&, 160) = "jTD[MqzB2P\>.L<Pga|r=deb|:d}ajT,ePWXZK4]n4Lv68DjBa6hoWY1k=Tq8.T)]++BXblaL''9;r_K'B5?yPAB?x|>=I}+(Lbl\fOrmlGH7NqMw3bI.Af*V7IWjcKtc=HvwfK5CnN{mlSb,a+>}8)j)3nZdWj|": a& = a& + 160
    Mid$(A$, a&, 160) = "?*Er\DW/hH)/14X;9(XhP9hefyq.G1wbtR;//L<dw.m>**E6I{s\N>,85f_zQ.hgCQ;j/GVO{ns_wC\)^b(nezLrM;oH=Gq-2(]S\_^9iUs18T2L|/CJ(g[tK)VoIX/]tXMH\/dSw,[]q/;]Mx=CIyKK1eCjbLa4": a& = a& + 160
    Mid$(A$, a&, 160) = "-DzSt<Eh-|ABggMEo:f2SxS1so4*0GsLGk_N\a-nt1/lp7<o3cuwcls]hb?3GL-wq4n/s2rCDm.^X91RXoxh5T7oQ3:R8[;fRQi:iFjaNUjjD'SB_h|9HA]aoRK3?FnYNrp_'GbuK_^Z(D>W.I{44Ydf0YDdPo(?": a& = a& + 160
    Mid$(A$, a&, 160) = "_4DV'Y?Cyz:xE-+jc7^1d<7-f49-X<pf5|wi1)U>RPf,67g8\)<[30f7Oi^|\W2P(l(r\G[3tJU;?xJrI-G6\GK^awgU.>g>)D0kcFpCU8j1,zyJLdxZ54)-ULyy.zJ;?FmX5{qU'MH4.f6-x{HaYy/5G8)awS=u": a& = a& + 160
    Mid$(A$, a&, 160) = "+q{:ff1'O,F'b}9y87_'DJ9H-rcg3mt:4-pPsh(E])o(UDgc8PoiF6JQLTIj,vdppYM[/yY5XaLij.[-I]|OYlM<E*UBe*S(K58D7Bw6*lVawIyE0k0R3Du4A<l^3=?z<H*?_]mqD7U7Nh,XZXcU'|^M]d,-Nm+o": a& = a& + 160
    Mid$(A$, a&, 160) = "C)ss|XlN0k2kpMIBt(2<R5'5QE,1^iGSjJ<PZ1i?*S'g?bx2cY8HOtQV2,I'-U)Sftm5V|^/lPU+4Nk_Sw2LEI-o|k=(4tgNkK*u=IC]MKJT11EJaJ72'PfAP311sS]=zYw.4KM}EQ>IaxRmTtSFAmBJ_SguFoNr": a& = a& + 160
    Mid$(A$, a&, 160) = "?TIFvteqt\a/*YjsD0dTPwXugpPt1,-x4^Yi4q5WG]|'j*+:5DGUXKUm9hq|bmcNDJYN=QOD}0K/cl55+(+AoQ_mFF{dlw_c^irQwGrO(OXe-?b2Uo=YW>cv3QxeAuRCO-Gr7)DYkiVHUZ|AZ'^ByGUD|o<w-8}}": a& = a& + 160
    Mid$(A$, a&, 160) = "++e>R*X5MQMxvc{b*0*+dLaKQabki:[p20iTUxI5Ow=>(x.bgs.,;/I84\/Tii4?OVn+SuvQoPxMy1^*W^bJ,-'lF5'FwBgqV8pY^AV,FBD^q4lwDw5)W{i7OHiR>K>^Nf5I>;;q/+L2Bg|NI;BD?PsrQi;V(vh)": a& = a& + 160
    Mid$(A$, a&, 160) = "K3HlJqDzdY?ET-f7tdK[}kl|N7Wm+oI\hX_:BLV<[wQi}]KlS:[??X=fzhfc-OOl92E.g>iI7D+|\bVGWeFY?'=3VkPqMB?fJY.96Pv/jbh.Vb*YiiN;fk92sRfCpjar{qU-aD+W73McCxL1g:d>/mZ02rZ(;A=g": a& = a& + 160
    Mid$(A$, a&, 160) = "ygDo*+T+.HW.46N+5ef99bx{Zw:'8|9g=_0]4viZtZn-FcU]\_nZhMVLhcJ'Ko'zS[fJoD1z+9GXcCO/vRh;nwsC>Ubj{}Yr*0oEJ>WD,gotrS8x-V|p'm:,PwqV{hMpp-xQOy_|)PQysCw[sftZH3xcHNFX)q:+": a& = a& + 160
    Mid$(A$, a&, 160) = ";h;)(xiR{t]ZDfgM?J)m{;</'(E401S0.3eEfKakfkxkzoO3{6y26R>^<3-funLy4Hp|KyHzDq>xhL3=jl{{4J;L\15'PpU[<Uz8mfTY;B\bWBrsLZur<7r1}bf'v029)6n3]OOP<4c6iQ,lI7m3f})b4<F9HhWs": a& = a& + 160
    Mid$(A$, a&, 160) = "wg6zpc-FPftsV4ROP}'3i]7W3dmOY*HBDogyfVmDPpLGYGb4,45:T2FyEk\5]+E'Jt9d_I?)Fnj-rX]niTe=/rscOWomT7I+qC9um,f3vv[rR5JW*nZVgU(W<ac>88]J4YADg0H\:pC>'\]Tl44a]zI7a=Vz+_cI": a& = a& + 160
    Mid$(A$, a&, 160) = "X(W;G/zCpuNx<|GNSA,W'CNgXKI(<;y]nb??p-xt{b,AeBE?p=gciG9KDN.X/5K)hZ05Tbp^lu-rR|Tfn]Qd-0,r4nb?OQY7PuAiwSCb]Fo4j'*6,\r:t?^4'CmmVR-SO.6U;PxHDTTL7b0\9{kKQf;;zMB1^M5S": a& = a& + 160
    Mid$(A$, a&, 160) = ".G[wn+y'B1)HzMZ8r.0rO7PpI)P\9_pw]L8/4b2_lW1CewEKug0LNGL'CU?oaWvkCC>:}zZ\[)ufX4GEM[O+YR-N/pgL>yMzhC_<5(-GUzMa-C8psv\we;9{c5Hi0KBul]J_Q}nS\{_C^7<Ac)aw:YPk0UXD/L/[": a& = a& + 160
    Mid$(A$, a&, 160) = ";Gyj=)7Bv+QMUbFaZ'+;S5{Q,ABr65;o_>U\lT7G^<oan?2O]hlWu513;seCCXVWHU3ETE636O5((nPujnLn|l?7BMM'35JN2_MsV3.oPC9b1VC(6[e:^4]E'.y:O;u:gy3+7t?qa30C:cjZB8I=kD)hc5EQexO=": a& = a& + 160
    Mid$(A$, a&, 160) = "8t_D'//e:*]hzi\AeVMaq-J}2Vw1+j_WYKV:qk4HSiLCaML4zPp4.dIwMlob:;72tPz}vy1k+\:9/wW96w6Dc|m23+AQ''I-Mi<Ym=>'yn_t^(z,w<QZp-/wRYo28,ieV*J>iu_t5M92{/(^;V]oquJFR78q_4,=": a& = a& + 160
    Mid$(A$, a&, 160) = "l=53?o:\fIRImn=C;)sB:hul/P]ogz94jq*pNRKggfFsrTr;3|61mPmdPUa46(mS]x9O{8?'kk-.(RAFy;v1/>gY{Rvd,pWQZYJ}xd^z3E-:Xl]tMc,8SilW02P:8pBo<'h<TcJX?l('*W9SQ>4Sg9UM-C[4_Njj": a& = a& + 160
    Mid$(A$, a&, 160) = "h-vY4-\92rEG[N-**^Bx\jgR4QLM^FIX'3]}<i8W+R*TxoOw[*8[P?VQB'r=9cf3/sRAtz:h)ICulBEJzL)]x(oK7ET6;eIR^YKM}]2c+LS'r<Q]U3,[a8DAAF*uKFnzcNf-Ha|.Coe?:?zG9Yb<8XS8K.e\DF4y": a& = a& + 160
    Mid$(A$, a&, 160) = "A=Z[yEL'a_B.D}ygsoa[7rO_,.;.2-TNHl)1:=PKltwn4B8s7OsD;ly}J7VN?;OuNx;MH;DeeAfZ:B'*r7A1^T9XeBi6Su/Ibdq[uyb>:>6h[83U>8Vcj/wdhK28N?_\tqPh?,8<UcmH7s9jb1[rt-[C+[OY2.5T": a& = a& + 160
    Mid$(A$, a&, 160) = "]'Wxc?PIEj1]9A|R]x8gpgc/F*VC*e_{'C'PU):09Xsbi;1lw_VtC0sH/Tngh2u;5lUaXv>BW\\_yX=7w8k|4H,FGVh4Zd|da2QplFEhtXnn_)fz\yT0cUnEkoa=mwY5T4IGkmT'g;y]-C0xPl57K2]1FSH^Dto1": a& = a& + 160
    Mid$(A$, a&, 160) = "2U.aKV3gXAVJwbp]?NCV'?u[<TD5SRur}<v2So=kw=QUEPsEee_RK</NNlYFflu=2[-Cs>|FUGO7HOBqtiy[Ba*hCAMf3;:4Xf94|o^u:ijZ,1q74[ezHRr-(AN]/X)FZ--S8Y\^xAH}111_b2O+yEy*xJOOi^Ey": a& = a& + 160
    Mid$(A$, a&, 160) = "L1cqS;QCWQ:b8\n<n{CYel?qc>N=8)f0vGQyq(8_f5P=GE1nKz<FMxJ7U687J]j4oXXQY7?U;LQCjo'8D/3'RmD=yz}SFtuMd1os-otwjn[FvG==EkYW*yCmaBs+=lhC)w3QT4INY?;pFR;w2NX)MRM^/qeuR3fM": a& = a& + 160
    Mid$(A$, a&, 160) = "GO^b1l'af85o=tPHjS4X\w+hBzyx/XP5BfF^8G]PS.>-k<j>/}p3/Sl<wPZ}XDv8IBrXF=|7Ufv+2EaW3rn}z0napl4/9}<3;K{/fvy,RyJKTi5FkV1Cr:IcW\+hoa2'ihpG^^vBHq}k\n)cL'-jm+8m?PB3IaGu": a& = a& + 160
    Mid$(A$, a&, 160) = "^l;q.M6.V,kUnoiL<o4Fzcz)O62e,wY6^7M+v)_f|I|sJiMNzSqs])/s4QDA.{,b+F7iwJA;LO>I)^EKDRb?hmwSP[:'ZAMZ+Hp;)reuUqw)\<J(]S}Be)a*hjYn:lUw)gJ:wi1on4]9u,?'G:cCY}xvk;OG-)Hg": a& = a& + 160
    Mid$(A$, a&, 160) = "rU3M0}ISGu3JL[XVup(GA[d=w4WguW*N\Jy71M:+wMrr/2+,FtGz?jC/VMgu{O)EIzYj(kLe_p::)92p94)XtM(X>H9.Z,i2mP^m_w/z4X9aq4X_ACDzjg6)ApJ^?a'H(e*uN}J,4Z:76mB:fuU-2?W]CizUDnvT": a& = a& + 160
    Mid$(A$, a&, 160) = "(m+K156_hnT2z'I(W}pJ>+g7CbN>3G5/1?J1J=EydB[72kcQ'43Hr1b4V-3WdMyz*NJPNs?:9E''hqzQwr\DRf2-Igf[sVABT;R_pC>'N^/Hjds/Th7W+wG.Ya;BIs\<{)0z^wTZnL7w7i^rhO[OcMxBoA;,fuO\": a& = a& + 160
    Mid$(A$, a&, 160) = "}X>:0C)DatGA[/LHYDp>zKMPpgR*|fr[/[w:=/]:VA\:[tN>=/MVR/H;L^DH*G^g->/V;8e?R;kc^KHiC5/1x{\AM)W4Q3n-W4>LK/SZ^Tkagl0?xy{huK^VAF'_qoQ9Ez2-5fKP?*fBq50=]B3hQ_\]e9lTojUc": a& = a& + 160
    Mid$(A$, a&, 160) = "MzncCs>EZ/X1575:>be+yW1}M3Cx*;x3g4.eIp7+R^UD3(b]2g(w_0hX:+K*W0p+68e>}f<k)LX'Pn+1X17btpiBNtLw|KKXP>Q[rZuOGB,caR|Xx;8a-7GPEz71(*]Yq./Xc/,<^or|j>XN6NmG[G-4VujM=}M:": a& = a& + 160
    Mid$(A$, a&, 160) = "TOBDMFE1.2EpI;}LP=EvZ8}/X_x_=0r:uZ)MrjiFZfamHnd6M6SGQ=SbXs|8y]VJshd1Y|cU6Ss'<StI[eDi-qn)}}_uH2:RrKv=//MW=0yYAiv68Ss.>rU(sR,l.8:)W8S5Y>evA{'Kp9BKuoxB\31dz(H}(dv]": a& = a& + 160
    Mid$(A$, a&, 160) = "I=a]juk2y}ihP5q1Hz5Pa/KlkC0FbZfZRQ[Eazz:huw:dS_-F^Uql.LA\14*)8e{a}a>3K:O]?_0DV}d4lU6sp?6U]vz_kyN+n[lwc*S0npOY<V-A9\ZUzP(DRK,wV/i;2-+{0T{V5yE)1/|ml('|S^uMOnZ\.y,": a& = a& + 160
    Mid$(A$, a&, 160) = "hc:jV2)pGM6?kl[<U8vTp(8Nrpf[;7|4p4ms.EJ4FrGan<ut2cHvi=Oxj|,b__vIODLYNV=Qu8kf4q]scXYfBy2:dcg2Z(JPPjGoS0jDQF(o(FPpt^WWom7a<_Wfs/Nwa+wad2+fNNy|YxNKmo\*Xu8DkU)h^]9v": a& = a& + 160
    Mid$(A$, a&, 160) = "?>gg__=A*zst8tF|8d6;^r./*:QPw7=g3VSVvBSq(6ncx=[ti*9i6]RmX{1]7K*+TF>m;_V>p3uAapDJX]Dx2a2tdFJB\KiR4+x/d;Iwsz,3GGZ>YM5-2rJKtLR.Jsk5:a}EF{k1UiKC6?Y50c[Tsa+c+k3MH2Nm": a& = a& + 160
    Mid$(A$, a&, 160) = "yFH}.K]j\e1R-bg3OaZS5q99pV?[*+rTn|Cg>Jn)}ImTRmV.F9uj2P|X,mcO7*Iat}nz_72=dWhOFL'?)+kK-K5'):OI}Q_XpipPMdbONBo2B)jlS9^z43Q=>Nvne7=[f]<D;6fM]0mVf.5USIqDEArjt8-v1pWM": a& = a& + 160
    Mid$(A$, a&, 160) = "Mu;Z[DL5/:r{9\WM:A'PibyL7QP'Pp1[HhSmAb,\lq\G'Q^PUP^e'D,{DNQ62DV4W0NVnxfpg'=EYnkK\ungTSYS?xWK;ZC:gG.q+y6pdND\L]'aKC'_aeI[UL:\w[8]Q/m[yY;Mq':.L:i6jWPnJHeE9(+iU'3*": a& = a& + 160
    Mid$(A$, a&, 160) = "*LYhY0n^=}f'N<o9J71gXI>,x1Q*V2yWD|ISR1)uhe-PvRxBFGdgeXn0KX\Q|:VtOMaRT5GkO\GxOsmpqlhbqjVr<2;WZ(Z>I,fm-p{nyOQgr?(m^F\9yZt,?ohK;B99L|,s2z33kR2OC:v}'PihprY.NL6S-jAD": a& = a& + 160
    Mid$(A$, a&, 160) = "hLJ^{X=s4vOOCVH[1-JWpWKjWR5qM0:Q,'-.C}_sn/ITEvXLTTVcuDzdwg|/CAJm99mBKbTK-P|b18-/\psqH3*Wf'd[u2[(UMH}sY=9?APP)7snveULVMi9GdH'8QVhIB?HO]jkbzLS(BS3,.BRQoAf<\V]F'ed": a& = a& + 160
    Mid$(A$, a&, 160) = "B?\5,fMdDBU5wI[(nkto1ms8jLGu|R<,GGn1-ze|<B-h=YoP=)LXw5X5rKmy]qX_}==^1c9x6H>ah>JQ{5N4F|vCPwuy0H.lBmL)uX*ELTBXl;EDqzoPVhE8NTh]zrWLgz{^_*H}B;=r/T6]_:;z<(cY]ju3\oZY": a& = a& + 160
    Mid$(A$, a&, 160) = "ptY6\0::.JAFst>yB_O<dTV-m]:.>TZD>CXYvI7|n'4Y6[AXswNS;C;\)xK7P7i*:_B:lHT;*wV3aALEEex\X/L_r<KvyIJ5eaC?{:0n8g;\>T|yA62yaSQtSi'i54i_l'B6m^|TV]L1{c96.3=K}bQ+GsNoHxTc": a& = a& + 160
    Mid$(A$, a&, 160) = ">oAPU\BoHB^BN2dbHNk2TvJ0:RTY<0Ck/:pEffX:HNsIS_]3eTc-}2Xk,t*WFr9\}sv>G'<-p\I[gbPz2Cz9T,>};K7TY+8YXp[oHz.9jMiAhBY'_6:1Oh_.W]M:_eVwItpJHpD<?01>P,]XqQ;X?]NR)hRP.\O}": a& = a& + 160
    Mid$(A$, a&, 160) = "6U3z4H3)d:s0P9<:rd*;a-ITSv=m,]vp=/E+JDOb](31'Lbr|?,eim6It_JaEi9jhD3meW0l(+4^[C-5Khf3sy6ly;pG4B?UB\a_?{-p^OP:L\Q)eU-GHy_<<+mLqbl_+bBhfj=CL9{(LK[Xd1+-}v_dA2pIG/?T": a& = a& + 160
    Mid$(A$, a&, 160) = "m,_eZ7AH5A)^zUlS_sk>s-AcWeg)WG\2z3YY<:Q9:kbJ=A:;2S]0gE'fH_>R=s{em|Bc>Wb(}{fbtd1q<zS4_-TGoC0xAa1_9g.s79eMzGon9y,c6>{gN[OsAO7ULku1|Jk_y-Z:)IcKxUZHf_uSO][X8e[R:mfD": a& = a& + 160
    Mid$(A$, a&, 160) = "*s?\E-F,oO]NcQEB'a+{BJ)FIfEZ2l5jlq)k>;R)H/F-e\E+YTF=J(iN,n=Lc)8Q\px^Kh2Z|TxFHh;aSMv<\o<j_5-iVC2_fo3nQWviudtFk8*;|rW>x}Su}txlb^KnpM?=A}GA82o9k4s]]ZXM*=SHiB[UXdsH": a& = a& + 160
    Mid$(A$, a&, 160) = ",R3FAkPpE,U]pz,n4PheUy-;.2D'uG<V3ntB+Qgr'ye2neUE?ToO'_CpNt;|u*GWy<Sr:5+z}]_R(/Kp3V2SZG\dvD>X[/_>t_ZKn2iJsfgpI1kf4p\Zo3Ni8hY}nC:>e(;c1{wz453BZk}B|hj>bK0>UPp]Yb,s": a& = a& + 160
    Mid$(A$, a&, 160) = "=]9YsF.4-nSo-P4Z4)oedVr:-1y8g'd9J'-\JiC0DOnf3O*<?1_6{DU:TwpyQ*KrAKYP5e^>H]O6\5:^>D?7]vPCDST80n-?2H1eUTkwY)/|vlZW7>ZeHY>2;,I4+DmMB{ePW;*pfCjm)G4y*ozx;_8+olDWqWHM": a& = a& + 160
    Mid$(A$, a&, 160) = "d95tUr]6QUx;f(}fS:28|es5.Ro{qi).FV7IrPorgFw'5_OazIv]i)=]Fd33Dd/plwq]b4WdgUfU2+AIbM7|BUjXWq=4DE?76qwSdGIq=ZVg-,q2d=1WpB/Ic5y7RRwV:S{V{MKOULN=ghN-B>JiOna5_mHJCZ6I": a& = a& + 160
    Mid$(A$, a&, 160) = "wX'V6Kk*j(Hb79VRG3l={dnvQhtb4=MS}Vf=;PBWhGFGW]_o-H,gU-_]f[-B+<F\]|VIl|qjMIG4qtpo3umGzA_5>IXvym+D3xbh9W9ew;ruJd:XsT/8'M2Z5nN>>/v)R\?t91qius6b6g.ra|ReB3}i*]dIHO>G": a& = a& + 160
    Mid$(A$, a&, 160) = "duw/?>KmSrHgMYZz1oU=/kZDVrXf_f>U'|-kuY<i+vX=T*Wq1Rm.Z,b2q>OKcNg[7:o8>31n]wqZ[Bp^ccNTIoor^2vuxQ6OO5]zCCcX]'=V>VfL,GhbZx|/Me8.}_EF'XJEUdYXKL6DYo3n_]F1Lq7^|N1*Z=x^": a& = a& + 160
    Mid$(A$, a&, 160) = "LJnCw(-bWcLc,>q.QYlES18SQK>A+4vK2q5dsq/pq^)]Y\+DwqxroINX(m<Oy/OK*10JdRpyhqejl{sC1CLy=iJTr.l1x^;CvU.ODtR(Um{2)Tgk[>\]fuz(xejy0u/*HVjMVAoyQ{]Mywpc1XO<^'-Wu[M89z8L": a& = a& + 160
    Mid$(A$, a&, 160) = "j9WvG9(:\z,?JM|cx'j5*be7oPRJ{hcLC+_o[dRLN8Mt+8A-a[KrpPOh;8jX3+1JZD1yNo5(R.q?L*t,vlO(QU=i+wHswj=FhdR]Lv=I]sUz'[ZTE-s-I_bx{JHVq/h7a\g1q209XH{JI;q6<1u}lYSZOg'Srh]9": a& = a& + 160
    Mid$(A$, a&, 160) = "}3Y{:AFLIj+*I/c5rxPGaL[6}xBRvARO<8,3(|/8S9Pzdj[xbqRI7*Z<LDVR}qo:>;2h}>}p=.>)2(8)r]:?bg[R)tsnhkF1ow6GpW2Qw^x6+z.u}<2OT{(2oV\28dT+vp)WLyy0E.?N>Dj}6p(M?Cf+AbOz]Ol7": a& = a& + 160
    Mid$(A$, a&, 160) = ";CJdVW,Isr7'C*')7gbqkW^nEAjYm6Fi6Ac(0qadv.uoT4d7gnB'u1g_ixW1BR7Ny)cw+n<l.tJ57Tw[ZfyGJ?fsgB{RfK2*(+jL^J/6hk-MwG(?XKfXZ3Ode[+-:is*cbe6zm={[}TTK>vhq_EX?D02v2acO*Ud": a& = a& + 160
    Mid$(A$, a&, 160) = "B*XuH)8Ja_YmUDDKt[Y[s;kdKejRJul37RN?5wiGA417qrYplNNX'zGTHyd8=2d.C]>66tl?,:c2FV^<'E=Ka--.-KYqMLs'ioZ<JHSy5p:Hoy6xzwR9E|iUDN2sX|aBsB3Y.X3D6w4mALRYnJ7hs{=nbBX|S=RR": a& = a& + 160
    Mid$(A$, a&, 160) = "5Jk<uel0k13V/fI\xBM.{V=K;J:uTIn:sE({It42U?b>wOYz*c7c'l9^_FzyZ3:9mQc2ohG]4?QLy,xFYW||mhJ9m\76[|toss*pemY(uzXF^N}8tqc1fnr8zLA{?yxymGc5-EU*fG{1j2jhvsJ7i<SU-{oarm5|": a& = a& + 160
    Mid$(A$, a&, 160) = "-<_OuG5m0ZX)HZ<]hSUd{lW/'QvcP(B=qL|sj]0;.Fu:y8p_,{zNUko|AK(VI61\^NmW)NR,YTyT6fP}>v]a5+_8(RkrA5\};NBZm]4sHz64f1b]N]HjdPfU/CIVXfCCM8AIs7{4If]p>;/p<fNwTA1/zbrgoQmR": a& = a& + 160
    Mid$(A$, a&, 160) = "L11HJX,W>7NKE2R[15qVK3UFZFXg0a[31v2oP5}TMSFWmMQrLWm2-.ZekXcYc7B=lftNh3r'hZA.>}r4pCFFDteiZbgq8M.>W,oYsJq^?zAgm6?=R1ka;8JUAvHZr:X>pwpN?Pk<jy0}(rLbetJEi,VUcQAu_hBc": a& = a& + 160
    Mid$(A$, a&, 160) = "iprX}c3S^YZxH)L1xf4kajxo0/KQwQ-[=HgF8(qNl->r'wY[tG:GAJ|7acr?Ug5WRR[6_iG?X5-_Iv6;n+^1)W,;Gcl'bKDM(59E8FPEdFV-IpvN.n-87UB4hM'{-Se4d'EX485Y5r|aBRcJ-UN5AKRdU4|-g7b4": a& = a& + 160
    Mid$(A$, a&, 160) = "Ia/HHw<nOh.Zn2>-ZxUEDv+t;u3?P)ro9?'u?n?[=Cx,<XL*\nBIYFqqN>Qj7W6ws]3pQPS4VhhhIF{=3vR\l|,i;']AQx'o4-JDMY{qX;msziJz3^C[Yz^D{*JyD4*oQwKzf3Th1BMa9;V0[aQ{Bl3l9rfdfIRe": a& = a& + 160
    Mid$(A$, a&, 160) = "kq<v4YwYZ(JHfV(,zsE(B06iR3/D;K.OY[LxRH|sk\\{B8^RvlJe[n\Ab?^A)02[\<;aG]j?hp5?IpEB2B2NjyOp*6EKUGpup8/n}kZ*V4oL,l?HtNl2_r5g1HSPAfZYGmFn'yoXr|c:}dl>/fz]o((Dhxt3^gXq": a& = a& + 160
    Mid$(A$, a&, 160) = "2:;690+Rr'xu|F=[-zaMPsH(t*M_gM98zLXgemtxPE;.gZ''2.v2wz|?n_tCug8X71,LShl8PR?zaB}bm9A4VHV[[_wFNpQz<>I?6k{[4))7U,Q]kaAZhVsWYirFyDD}EF/F<tcb]_K2mV25TL08Ue3/_S{h3ama": a& = a& + 160
    Mid$(A$, a&, 160) = "tJFNveo24wMhZ];x)',]/x[1uFchaCf;)/nW?x*[iG18/Ib}:LXR-m-t4{V78'I*N*jYXP/pxh,=7KL?OcvXmE[NTEw5lz[mVSC,B[d/jHj,:(.,Er[?84O{bKKy?dX-+bCY3.r6Xxh{Un)FB<8?GLlH-,cFe8Xu": a& = a& + 160
    Mid$(A$, a&, 160) = "*WGlj.Ifo'Ky;5jWQ,TXoVeOwoa6W5gde[xGblZf(bkJ^+lu|ooMNv0yk3K:TT2n\DTneD<5bd9>:A2Wg,vhSJoSSvddZ\K8K?[X>YG+gVC4EArOo(+FNtu^jVlP*-J=Txr_hG:A3a2),W_VAYAu0D]?Q<vIc<+q": a& = a& + 160
    Mid$(A$, a&, 160) = "5//KX6kX+DA6{Y*ly|JtTnozy6\/*.ctFPZM6j>6_u(t2'+y8[kCbXxhPko2YXFo+m,Z_x3]I5+G86[_8Nu<D,Dr/]kS2j{?+wf2X)}mRRGa}^MD*c8szf|U=LO'xnSAtMHoe?_8M0YxGd^<)q0k3,U]:8/__pz[": a& = a& + 160
    Mid$(A$, a&, 160) = ",PTJnlb]|m>\^Q.,rwbFz1X_YM1-F}wL1eFDc\ClSC\(<Z>_5b-'g+Jw<{s2n6[O:(V'EbTXuiRLt=3/RI4^5(2]103WnaRBZb4A4?\VGGJHTaPfwiJc/7l']oQuxjrDM0}9=NtHPh^-OsXvEk*+]yJ'P5iUu12V": a& = a& + 160
    Mid$(A$, a&, 160) = "BB6AVJ/5T15N_4qfT;J^zkPuookyyx+=Z,}lfd,wdtE\t{F{\Z{F9]<_[uG5Yk\2^d*(6|BCfKY-hV_QaA[+_,xYV_XgNmX;KU4UC9<P+g'}2csl6miZ7og+E1)eusH5/_S8|CNYCdOUzAk>V*l,W<5aH0ZHI]ey": a& = a& + 160
    Mid$(A$, a&, 160) = "1sVEp1-ZAI6vMhZdGxXq6?X=blzuX<TZJKp:aR?Z4BTBC{VoLKQJ|5WP,1_k=1)p,2Z;vgmC6;Rys)hW.{-I'P3YYm.fY*GE3l+/ZCwh^>1)Qd(gg^kn+X6b?*l_r^Y9pEj=jL5th}nUis17X}vUGKXTP)VYzeG+": a& = a& + 160
    Mid$(A$, a&, 160) = "-GCR.eNGfymV;*aQl;,20-eTF42=/6DLN9[PM(e0K6UBx.y{F\ug|xPsIO^Rw4EydZ,UxMS)s.|:r{=QAwY0X(>8zQ=Zg;rx[aKwPla,h]:K3i|b1'<^Cix}oG;CZ:pbL)eFY?ez9{[<jGX1IgG-O:KjjQ;}On5>": a& = a& + 160
    Mid$(A$, a&, 160) = "w<iO'xg;^m,Z4iOtm-AY}m+FRbV_Rc]ZP4kMaI^cxfFE[6hWb/i+eJeQMF[e'AnlhFx\NqRhImIB:95(i,TncnPGKpr>}>T6S9ng1]c?T7)4g+aRvW.e_K1^=BnI937HIbJ_Ip4srX)^QJ-P]Nn*fz(<XeLV>8/t": a& = a& + 160
    Mid$(A$, a&, 160) = "Sc5W5<=jy3J;3A6-ipG+Upj3KFhFRsogawVq,d_Ubr7U;I)M^JCYMoC[nzS9gT'<?vkYumiy7R+ahbTlbA6HKE2}L+N6Kd>T0wB{p1GOxlU)MN:x]Y^I\-tBfCW(Ahj99y=>:uX^mcpC'*)DiFcC*7k1V[y;a<xr": a& = a& + 160
    Mid$(A$, a&, 160) = "VY7ik,vFh^IFV3^t+]ZS|Hm2-LzK-L3UG:9V:=pqeA0mi-boz)T\ie/pS;)SuA.|(.q4\GaPu?O,I<q(opb9hno/v]llrZ)^[4||g4z)Uzvg>knmFh{;+vAo7G^3+:sW-f=XgUi*5JL8qzJtvM:yE(ApRw]+4>kC": a& = a& + 160
    Mid$(A$, a&, 160) = "sZFJ\<Hi:-WkrI_2.7GiJWfn4|I+}2OOUUjW6J|.|/L2_.Vl=o1Q'{4_sU8_QO1t1[nbNjZ_QTEQjj*15G{uv^1>1CFb(sgoS*-FAj(1X]8k{x;I9uFOmofJT5>\a340_RwT]NR1Y({T\qZ2c:kV7o>z/g7D5g9*": a& = a& + 160
    Mid$(A$, a&, 160) = ".iq3KCM,tYb1IKU7Amm7]r_W)v_]0>LA7o;wJ:fs?I;ABY=FnWC0hb6msUcHuK\\*w:HZBI[fI)92qMCd_g)s86x\HR_SC>A>_*i?rGi+?1RR\?nayuVEDb5kR2*g;>k7^{,Pm]n7<0}kS'cvC[o|v7maLtVQPEO": a& = a& + 160
    Mid$(A$, a&, 160) = "t]Ey3}T[NnBid;I9]]lta+Q{+GDq[fMV{n(t[x+dq<athC-_-)bO0kik,(j>hCgFyTR]XmVb)Cp<N-Ta6JhhCG_:P\VJJx_LhcGR<Lpwsv4\)vj_Tps:lMiU0GXJ4JB9NGdv>f[vE}kPpdZmD0,-Sp9X{JDhU7,G": a& = a& + 160
    Mid$(A$, a&, 160) = ":bvDeK*7'v|J4h6nb<g3=:vt|hsIDz|dHB.LJB-N=<Q^_TiTB?ACOv)5k-Yn_67mK?l'U9_RY(97OUbPw/b\XTBN]A|=(5O;v?SOkmThi'OqWdY>H_M:Z^c<6M34clm3plOjp.=iVtJ+A[QEQtH_pJxWE/bRxWqx": a& = a& + 160
    Mid$(A$, a&, 160) = ".l6d3nI>+>N?gI4T6CjE(WTPyXt5xoA9;?7Q/4?5|Z{.:Zpj1M_xqzs'nqs4OVxYWG;u0|k(DC<s_fwprOr}itl6e<rq}bxbuHRZV61(+sMEb*T)w/q}](Ij87*OZ5{=(U{{*Y=QkWWcUB)E;hsa>ifCMw<c0+2F": a& = a& + 160
    Mid$(A$, a&, 160) = "abUxf7MZ1Tm{4*SEED1OaUGUw9zagN45sV8y-eoyr0-Bs,67rNi^M=7u<Wpnl]oYu[g<tJsL?3;RXKD?vvXmLyaD;j32=,0_rUInoRppsumKb(4]L<C]*dVT-GYpBqz7v>A5FE?Pp[L]k(u,0{7Y?tQg{nLMN23v": a& = a& + 160
    Mid$(A$, a&, 160) = "D;oM:*>\Ewd]tN(_SlJm'JOF;rF+UhBh]Ud5A3EbqVoG7bK=Y+6;(|eUh]B6,]mXWoGGz()KEJ;?mdjrte0.eaW|/6DCGsC_s.y44Wj'-[btM2Z/J-S^Z_^7;Eb:FI0>*EaYBoOp.gx6sg8.UVi+\t2(9EV3(Z1s": a& = a& + 160
    Mid$(A$, a&, 160) = "DI;eWWC}AX64>ugf1bu}pp<b';VLx|_wf(e+PMgR?KehZ*Da-gf?sqCW'BRiZOfWvldp?d\lK}K*dC3|K3tqt_,MG6XK-HG4k}st?hUst'<y2CJ^ugNPv8w6r^eaLK8v6\HKN2+Ek]vP{T<f|/Hysv1:q._g*?gL": a& = a& + 160
    Mid$(A$, a&, 160) = "6+?q6>sA'Dw({>ozw)wWC)xI=b]tLkt8k8k8l(Ma1lghh0rt2(.K+.g\IHuq=IXz2iP>v+x6aptgKA6OKr?;Q]l8pc_t{2J3TVbHWYF,drg]]mo8F*\PxM/CLL}/en;\Aouk(vcf'izy4FI9r,X':e6;uOS6R\Uq": a& = a& + 160
    Mid$(A$, a&, 160) = "1(kCh7n6m7>18*8yrjZ0|z}y*)?wJJ1Orp_,e:]Npl9j/JOWWt>OOynYPPeE4>yeIP4;vNr]B0s2BqoI1j|N;nH7|XVgwF7<=?/8aeW^)bK|/v*<(pXfE+}KH+4PF\>FCUJVxNv+FfDT7ix{v-.7HPCNkB]yU5B0": a& = a& + 160
    Mid$(A$, a&, 160) = "lIQG_zPI2|sZ=vbnJkz{\k|ho_<vp[q*fzND4_)G;PB\Y>>J*007Q<tG<SI7fXK)e\lB*G>8gpc_Isg}(06Q}\)WbS*I6HBCYyf*>RI.<vR'UNX;XPnF[kFg}(mNg661(kj?As=kmtjV>L}z\4Hl-ZCnP:c|C\XN": a& = a& + 160
    Mid$(A$, a&, 160) = "cNr+bF9zd1w.qqheF7KT9I=[BQ(N02.2jSxG6m/_RRUr73,L:kgIFJ-\BJQzwX?sZOQ'd8.I+|LS4yGz})F\hd_;gWRMGWH+peL^2[45P|vy_(3zYvk?XgbIW_K}(Ncrmu\nU7PF0{(W*ON^1LZubW9/bqjg8knH": a& = a& + 160
    Mid$(A$, a&, 160) = "Rbu<PFFyMlhaMO:9[8uNB1uIarZ2_Edo4uf8[=qX:;HA;-:{8[J^j)kJXJ8Z+[G1rg'8,pwB;mURHiCVfliKhmEgkOnQke7v+iKrc^w|>Ap]^grQZv/xaDJsx,UD/r+8SSL;NT1{QDp/nK_(Sbc.R1R06P<zzMP]": a& = a& + 160
    Mid$(A$, a&, 160) = "kDR]d7r,v70BsqY?UGl5gV:IM(]Ts?C.}ohl=)k,GU2LOusiA:f6'78SYi}c*7L3:i)e+p2Wtpc\XYSDsyBk'K)c8v\UTWvf:=srb?rehdTRljU)Vj[ebrb_{cqoXV\'6WbAa4zufs7d9X<b}ux1a3{,Pn>TnnAV": a& = a& + 160
    Mid$(A$, a&, 160) = "?-DHI(Yc3>)y^ctCB[:x7hMvkSfKu*<CXX}M*eCZVQK,.GTPBlNtnNj=L6IOO=S'yP9GSd1-F4,2.HO'VLyub5'bD4|MLw\+/8.4sc8d]e.Di(JX4lUwSHa/|IX\SPQ(IQpf?w[8J2:K)I]_wK?VoS\Px_H}9=Az": a& = a& + 160
    Mid$(A$, a&, 160) = "mZ6Ob4B}]paowY-rDY=GS=KaU+1WYRi3^7rVB]IqU;yDxsW=Jt98\}+s6^5fH4;n7lNk<p_az\^htjk_ZL?f893k?bU[7(}h8u6-vQiF8.M9fgOTBp^wZ3{[5vZ(eQ\]rPeAQnb?W(det]Vvy)n3BZ*AkMJZ?-]T": a& = a& + 160
    Mid$(A$, a&, 160) = "4Un;hc_J^*arPTa8<RK798zaP[C-kg=H7Db3sVuv5x(Z0V=vr9=KCZJwmh5:*pj+=XR91;3y63uuZqA>F'1EOkOg5iW+m55=^j<tTTGUUlgT^dcdq)8PnWv9KoO7U9W4n)G<ikG2eBIv9w{=TM7m:z'rLGses22X": a& = a& + 160
    Mid$(A$, a&, 160) = "jTXCe5[I,vw\y8R{w>a[zZGJvC\^XgMAL{Yx3^{_1KtP{Sn2Hcimq(uD-a]B^yk3zH*|wxHqe>_dVHk3>3OgN)>_A8}J;vPMQvDgM^x*7Vm.D[]-J\|9i<Z:J6a1PM7mE6I;9?loCGERa2l266*^6meUGUq{ce^c": a& = a& + 160
    Mid$(A$, a&, 160) = "1;DT-\Tkz7k,}|ZpuI=uf^Cyqr6z(<oVcrE6g)TQmo0]G>PgR;_\5|]-nYYhw6t,A'R:y:FOoAeb>9ssvSc?:_qC,Z>']N6<P*p.uN[EQ:mDfXTI{38S=Z;TSP{fdZrwB}nW[\a(J8g0Os_-shLRE[LAp4WFg/oa": a& = a& + 160
    Mid$(A$, a&, 160) = "Px:g>SMJTe/ViNLRI4Tn_T.KA*mJnfx,,\dWom|Lc5==z:s(nMpYQETNIVtEK,9QaW'<anP/S<{.C5CbA\gztswbA^bDs0}BwEHUlsdYuK51Q?,m^M32R]h|)b}K9'U/MiJxOc{YY(f5LGRO;+YOySNoOVWc1>C1": a& = a& + 160
    Mid$(A$, a&, 160) = "6j_x5n:NCDC]}O5*Nop}c?)<-|sYZIT_v6\6eMJlnRI[PziSY?/2/m'kz;OeMDQ0cyT?jkE=ehznH7|DiXd}RAMY'q/426WO3J;qI'>Nf[8Lz-8Y9Q-:mo}{S,HEbWDp5C1zzGd-Okaa*DNz[oyALvh;:/=/qRC>": a& = a& + 160
    Mid$(A$, a&, 160) = "3E<_z,MBN+DOGo9Ez.JdaR7t/<-9p,nCunf]uy*wZESL7meKh4VhYr3USkd5uUY:0>u>pkyg{Ue2fZ]}em{ygPllc<wH>))jb|1>oLv1AY*b0q5^[yj(84eV1uYIX8'fYvQKvzrBBLF=Y-3Wc+CVV=PUc=lXvLvE": a& = a& + 160
    Mid$(A$, a&, 160) = "2xGs<<GRd;0Oc6CAjt/6tkILwnD/pVx5j].DQ*WY<C:cIl.I4;M1zLxiltXV<aATo)D=EaU+?o<HlMRs9,PmC8iw8jpwY=w\J4jyZH7;huHhe=ZA?0uyx]Hn'z:hf:aw^cIn0i{F>f}W]E|v,;gS:wsWh8cEqd*y": a& = a& + 160
    Mid$(A$, a&, 160) = "b9yD;u0_>3CqF+tnVz5ilL6yMUhpZPV/biW*Q{EVh9I+Xc/nFHoQpPHS)e<VL=c1b0X(xEbA>*oQ?FIcLLTmanyeYDITVO-FkCetAkfV][sA/n1o_vN7F+0c\sy4/nHg+glj)}\qc07S>6FU_397-)zl7jG{F4z[": a& = a& + 160
    Mid$(A$, a&, 160) = "q;R[)mEA+'x7(t;[w0I=kgJh1L934iQk3]tQ0x7j<EyV5p]]jqt3m=IWntM1Pn<)8^f?}g>M;za8epH6iEc}Iod^;P>)*O-JhF3Xwr-jhIk(9KSgsH<vrPIgS8\k>^U/\Cx9F/LLVeB->.DE3,[4YAvS5RZ^R-4T": a& = a& + 160
    Mid$(A$, a&, 160) = "50El|Juvru:{0wN.F8_u_K9H+a9G^1tN^Lxwi-/{b8-B,?CwEhSaB<][T)r2k3[<|\=lq{k89b;^WNoe+ubF|OY9IoQ40XFO0SR/FrB^-;2g,|5Yc^|}O8.lb/*+;VRy=C//OYe;r9MfQfbr[*Y.hAV\xItCyU2b": a& = a& + 160
    Mid$(A$, a&, 160) = "Cxev>A+X-=InA?sMQ>3B:/A'S9OR)aM-dN?IJYskF[M=A}uojdDkm?0wB.3<lAX6MTyE5)8k(QhL:Dqauz-W4+uLEqqxTBLfL{UZ>1,Xj6?Td^\VcF>:PwB}=eA\rGs6UbHXHqYj-6)/l]jcWYwyb+kzOc6oY4'6": a& = a& + 160
    Mid$(A$, a&, 160) = ";8?>clN:uF|EO/vJSVM+p<^Msi9'wE/j?SR0qkUnOXp2ZK8L2FTynefD'ly9[J/mfpM+5Cw8|+K;6N)3_SWX{TEV^ctR*U<fpa}?+KB*qa'm*dKEX;2Psgvbo480Awa]8^V3p,E:z7(ba{8(n2NELgGfEQ,r??>]": a& = a& + 160
    Mid$(A$, a&, 160) = "2EVfR*:x{WI{3/O?zLj<[2szhbuWVY^iUG2+11=i))(q84C7|dw36c?=7UP/,tDY2D2fF?P=y[,>VG::hcQ?Rc]q0UFkYk3lH'iBrYyu>;8fpbn77C}}G>R{su,pq5k}MD.;s=RyiEuRFKC;PELd[U\VA}Vi/M9)": a& = a& + 160
    Mid$(A$, a&, 160) = "hThN2>IE+>G/OP8F;YQ6-L)r8\S'rlGhm:=o<r/qJjH2(fr}yUFi,V((0Mq:tmT/4yttpve?yVyev-uJXN.6^^L:KClrxl>YJm+v4]G]_D*r*|8m-Fv6ZB+D=gd9;F0.k|tkK86-'WT,().p2OZk_rSGZXp4>blQ": a& = a& + 160
    Mid$(A$, a&, 160) = "w-\IB2B5U;uw'1V,M9BK7xQB/:h0_-R\J8FF_x^csjDCi\\gy?8npUm2f=Da0r5uLzq;uPA[<GA]hBElAb/g7[9E6Cm?9FonQ3,X?[zfOSvYN7x3}9FI4VKsqcpeb_c?k'RI.yN|AAV|H1l(T?P+FygNa6oE8?-W": a& = a& + 160
    Mid$(A$, a&, 160) = "tk+G;zoD^y8Z47'ejZdMDER]iMp{87<tK4O2>?P1PeFKw8AJQg]^tbWMjZ|n]8o81A>*24?UDZ?b.u5OG=JTZuQ22D7Q0yz}A[_-ohsrN9Q-c+D.>GtL=zaQ(j5F,O6NM,3s}8ME1}HrWWrgnXaATlw.9NgO1)L.": a& = a& + 160
    Mid$(A$, a&, 160) = "Q,YxytVG_2q]B|-m7]vf[[X(2Oq{[qe)^(]5?(.UFTy7ytfzcNaBbzV31{6(-5-/HxC7S8HPVEYo).{;^ysiq=LZTiYCQW-AmAhL=(2:V8<Pbq(toc8NWI|ltWB_ncDt7p0A\o)NVyLG:iy^ceH{g6|FyJJ>x64:": a& = a& + 160
    Mid$(A$, a&, 160) = "pLQr;JkXaMjt6^oHT3HnjHd71{,0P^J2xvJAbR*OBQQlp5[+iv6cLZ=cvz^4N8QxJAH+\SCB\79}*.Ny_<f_7EB[}:U=6,+N\RC|KQ-W|kgW[3u1kyjjiL<s,YgQ4zj?JXo*=Z6GLQ3Dx?{:DaAZ^,N/OZVU9'w[": a& = a& + 160
    Mid$(A$, a&, 160) = "fY87v;K4<eofi3:eg,+HrY6/MBG^]L6_0Ud|XTaZELS:UvE|_5q0?3w5>W.JcoB[f81YzVv^GdPt*)AU;(IgQSDjeO>b;kY/./sfutwMH??fkkn\:ssN6qrAWmhT/6*>dnm1>3WNS|-]u][SLbiN}YFkVHm?E8F,": a& = a& + 160
    Mid$(A$, a&, 160) = "suC<e_aQx:Ss^dHJ2ZL|01wULRSn]ToRi*2[QzrI]0g9ttste6t+'1?0J(d};-FM3>OK}8kmYZeG_dS56NNiSch[)oDo(+VuWR7yN2sz=.jj?Jp/x)N-uJvHyZx9gdZ{6\T8lidsJ_hB]z^o7hQ**'aurJPgu78,": a& = a& + 160
    Mid$(A$, a&, 160) = "Xz2Od=,,M(Wg>-}+w*i^NWH4>*gsQk7L/i4s3;KIr/6S]gYyceDzx1R}1-Ou9)B^44)<w]Vm>q0cesHa'{/D+]r+*,r><rS*xh1,<u74W]Vp'K?d-nUwp1cU1_eD:[C8/J{>Ec*9OeRN*DK:hOaeevR3sx38Fv5G": a& = a& + 160
    Mid$(A$, a&, 160) = "vrp{fkP|JLCGe9JVk]7MwTJG=-U-;7aNoZ]OQ3ElIwP?8HCy=ThrO(7|V5X7Z6bXIgLLl)U=A*KnywcL]=53gRJNYf:Dg7*5/SOG+ZKPXi'/Rw6t}k-tP<mTk4izill4OxA1a,8fsBe(cPrvKLaE'Qufr/NhOriN": a& = a& + 160
    Mid$(A$, a&, 160) = ",UD\sbdEh32(tUBTl/-pHf4Pb')Npo(G4K4sAWt'/F[(ifWRQAK[bcY3+ykvm;HcWd;H6bS1**p7lTA(uQ[/rd'AK9DSnak^OVmh^w'hKrEU6G1FBqaWTy\S)o0fC<D3oqfw73lVm+:HgYK}bd\?xC_Kd2TiqZbg": a& = a& + 160
    Mid$(A$, a&, 160) = "dDX(KuUls84t\ItL]7rW'pu;)lSohC9Vukom8=HLGzwRhS6}ao>rO)R2HZ>cGPwZ1ls6d**4E|A9ukE?Ttkr8Hz?M_/fy:Dk_Jm9fZl]wtw]R4-\}BGK;/e=+65_/p66tRbx')nnIE.hfS|hacK1C5:-AiI|NU.?": a& = a& + 160
    Mid$(A$, a&, 160) = "e*(T(E;O<.xoJp(6Q;F4+CIrXcG>=:cuG}55g}S]bp6;rXF>L]t-GCL?ck?uV<aWr'bTr^>QRc^+stahsEy7;OSV]AQ,_zwXM1b\ibp[I>\{i}C8xj2/yt)=m7stKfE_1N?Tv0g;=mZ78s{L/9De1b2'8,?E5RRT": a& = a& + 160
    Mid$(A$, a&, 160) = "Om\3u5n+cwTybUYX>X<O])Ux,+5pGcmh={CS:wmJWE6[[gofks/Tuts7.dSb?_qfnJv8[gNz(H'j>LQ}tDQ+_hgQ87DC(:2g3Qk;f52lw{p)cUq?d|\JWGln39hyv99o<A|,0Is2am/Uw4q_N8L^GgEb*rH}5_uf": a& = a& + 160
    Mid$(A$, a&, 160) = "^wX(fINOhf(bpylfI1a?bE>ScX9pio'=iDBz'7R1Vr'?WOxN7aF8x-F]'sh2)2Nxs>elIv/h/Cee<f;wV>W,}]r|asX8gD,(dnG2J/C237CWLR_^q+.\QDIB9^W<dgSNaB>7ZU6;hYf1I,'ELHa,USiAXO(KbcJr": a& = a& + 160
    Mid$(A$, a&, 160) = "MGl{Q0nZ'P.vPWmW_/dg85LnWUvqtM_gps]E9K[U,cp}L4av}<.LuFH:Kl96Ez;Z|Is>mXkGcf6*G199b)PD_3=RtnZNKz6eG71,l:.kyO\*N-tr48j+tcP9f/4nVQ[YFp57\U:ZG;Ci[V,h>zE=:^gJUK+:zO|4": a& = a& + 160
    Mid$(A$, a&, 160) = "dG/:||/c=sPU2wb4K/3vv3d7NmiW-oVP8[7ERiyijY+t[-jT?q1m.LG}[/_sVQvxk:SB)G[BgTt_<+Xim-NCcn2P9^c7Ur.af,Iy44v.i\UrCTO2ZislLjYukTpe-wQy:?h\1hGl[zaySxj?{8,j.adi2R2Ysg:2": a& = a& + 160
    Mid$(A$, a&, 160) = ":;I[1NuY}n^bW.],:ZP;XQB)ebE/_s6Bcir;HMj>;;^'5L>TVIO'<+2gIzhO-nw1-uhS8Jt7xmFhyB10BO+kLQj9;Xli{FO\9KF:Qy{u;Q50w,56EsXh?W*g9unj:Q*.gB)]HKXh9'T.7gsxWDb/w<{UYM^)CG{M": a& = a& + 160
    Mid$(A$, a&, 160) = "7Q]P4A]\K8'Ghx;P18D[)>0REr9svMWld}.Zt\CGx/d:wo77B/R<ldAHNr_ls)s?^^brY\fNF\9{HK;,h/M|}DcDsmr5Ie}zwRn2WeBS4XAF6Rpj7yDIf42U0?RgO094SMLu';-SjD8LDDBGPHN9mMyB=_c[EC5-": a& = a& + 160
    Mid$(A$, a&, 160) = "X]ZBr-zmhgSn=xrDJET.knf<.jd=:)JA17Rfw?9,SP+yLJ;h>[cJwgUevd?t^'t{^2v6f/ut+NFv<zt:bKOb+3VUyF}ziI9af2B).R=,'0ha\LF^P\Z9P2*wn=m[wa7O[sMqdiRqA}2d^0uS=W=h1z[wY5_'0o}K": a& = a& + 160
    Mid$(A$, a&, 160) = "'7PO3Yub2t=:cqh[l?\]IQSrM^?h/w1+h)eQSUK{s[Xnmbx^gZ\*khP+*FkEzv|LFU,Ln{1jADd=_s2Wp'jlAZWWA(2,j2+(FSxVOP/[vKb2w)2UrngA5jAJ+'<vQ4A4qLpGmhwe9tx=O_+IO(oJ(E{Rqy_uV7:{": a& = a& + 160
    Mid$(A$, a&, 160) = "wYbHp201YbzRD?=tk[Mjj3eZP.8lupVwC=p{I;fHHkGZvj00N/hM0dK|29s'/_inRy;UlU{j4}o<]:TZL^VPd2l^q-X43G<6K|<hbYHdvsgRyPREpgC66'JTZO2][G9^:.J-i(Fw?-'qpe:=+hLJ?Mgi}|FCKL7S": a& = a& + 160
    Mid$(A$, a&, 160) = "}tz2p<LxO,c*u}2|qE||tN{C_PF_7OhL7t\hVxySiQBs(<pG}eqgO[M'5d+MpZ7cZBF,*=uui\M';+BTmM4nXk4z\+Iftv*Q?Q_)?1}HUruCqk^0\OX.8_-(8CJDR([S,>FBvEgsw+HVtNvLV5TX)8atkFy=<'^i": a& = a& + 160
    Mid$(A$, a&, 160) = ":m7Q]8_tgy;rI,|5p:yg^133e27F51S_6aH/P9{oSW[T9gv_ep.B)b77ns_13PDo0PK_eS(hIL2P<1(asLIhooKhF0tBG,z^2>|:Qrzk2;(<|o*ZUeSCu|KM-\i9Bu>lfS(2^K||.zEi\t-]cZJoS1nXjMJ-Y*:W": a& = a& + 160
    Mid$(A$, a&, 160) = "I25t3yQ9j/AP}cHv\+A4+F(r]3pB>y'a_UL\(HR<8Unni'(S)qUH;(9*^rp;5ig9J?;H2lp;3fsG\EsheO^>:.G5.nEn3:7|:jy0mIT9*\Q;fk_uZtNk5Q}_FQ3Q5fWt5q8gQe8<wqPlPqX(9B(:34Nu';c61d<S": a& = a& + 160
    Mid$(A$, a&, 160) = "|['ve|>Z'[6RbbY\vqPK.5NB9]gLwmw\\b*e_<I<TC<>yCX;+ex5RGBBmQk5'Z+C5aGim9j0c3-<X_|f:PQtME^ZALZk>CB>.32r.{(=[+n/Sy-GybleII0jRE]q-X1dD5c,[|v}\>v-b*swM<r\^q)e]?OTriLs": a& = a& + 160
    Mid$(A$, a&, 160) = ":Y5C^RI/b^HWdD}>CfFw7:'2J=,;c_]Ophk,/th_ejwW_Ju6Q\AKCu05Oxex_?Af:_gsc/XR5czJLj2od3ZozXZhea|_f[/>*WpVgrxJ2NDp4WwNGO0*Uo)L/{8)<8p<DJaM9<Bb;+{FAR/|u>kO1{*z\SvNSzd*": a& = a& + 160
    Mid$(A$, a&, 160) = "IjoKXyfD^gmm1BU?Y<:bba/032HnVkz^zyh3kxQ4du)GOT))eS]tpbv>4Zm;OQE/O)f*d-^H]VIoxSAhY;<dtEE1S1|KraF>x};4GM;tS'4qU_'Sjz+ck>nd+3Erz[iT0FfqH5h;HCn;tC/|IB':35D-GiP|tl9P": a& = a& + 160
    Mid$(A$, a&, 160) = "gvRF5Tm6f8tL2MCkJ|gyoYo?WV;6K-UFOnO5IZ:szsHs4'yvjV^vQ{e'B}a*Mhd,'*oSseVQY;\1e?G<M[T)PkKcoleZk.E[YZzRx*LuMf[WlwUo/?98vGC*8AJDv-g,\QEaim3DrWU]cBF2|PVhFZeYPyr_7GL}": a& = a& + 160
    Mid$(A$, a&, 160) = "Ok0A+r19tPcJLK7rJC6A/D>2Q9YB*5mRWkPGXPH0r{3/<hq5vOHRlFtvA<h>mDLSArax2O:^MryGlQVRzv5uZ4PQ_mkV(5Sd2_NA7Ho(QyiOIomU2PXYhQ8OF7nU'n6nz^)8;7>TcU0m>JWt6qaDr+dGug04mI7L": a& = a& + 160
    Mid$(A$, a&, 160) = "^I7)PWRzSOKlnr3jnYQ'A5_{j\W*+JID}<I[\?pANgD,s:co\CPjgg/pHtt.uB[]ET\U2==E:/<mwbN_{XsG;8hjWi.g{rql.hp,1/Pw/kIq:.J9LvD(AX]o'^Zcz4VIRf<N2SZ0T.}mOg2\P6yg9OdzWv7mvkMA": a& = a& + 160
    Mid$(A$, a&, 160) = "F7TX:yeVm?uZIUzZ)djop3-\V3Twy?qu|L4P2\;yDAb-)e6n3GlTc.GSUTAJENh:Dix7]{oGAs:IU=*H():gH}hVA^-V;c-7B]juWt>KU4)qTa1g+fZeg8WF>P7]zP^C2MtuW0zjl;N-CzkO)[1pnOMY{'U;_Vv9": a& = a& + 160
    Mid$(A$, a&, 160) = "7wKd,A[uz94w,/W0OItAS)S^rs7:RywXk,PuX*LI^z}:_\Tm?7;.S?q8tKx,6Q)|Fl6ri)l3].)z\JFz8D..I7Uce1pN-3ovUWL14kq/[Fvlq{1J9mFZG9Ao[if0Xn_qSX0]{qxIq..AXlCtU<dTCGr[9pjU>lda": a& = a& + 160
    Mid$(A$, a&, 160) = "mzOJ<1*X\Zx^A?\QRM]dOuNFr/LS2}g([Le:mNyi-iOOPMK;-Wt>jq'r8?xTJaG=53hvdiVOsF/P3J_e'OsN=nHl*w^0^dPOtvQ{32+[xoB,i2Cqx'S-nA6m'lAt].[K=Cnv^D78Gq;2xu}-A5N{+RGrc=cd5hjL": a& = a& + 160
    Mid$(A$, a&, 160) = "_3<81:1v?EM(yX8f[E7,.Jq'6=-H6XP'm:e2IaUxlG9{<_>\XI+6tb8Kf'=MSDU[]l)={E5S8xpJcm,I?jGS\m=K57k>hhe=S*EB=h|Stzix|n;z8zlyFzr*u>e=rm>2*<^0,IAZ'1s=0{.0t)0chc/T'_UofG3x": a& = a& + 160
    Mid$(A$, a&, 160) = "A]x.A5kaLRFO8TbsL[Oy]l{'/Tv(o2KCBwh:aVLrnPkYG]Q*lgjiOX;,+5]IrH}+3bFQWR*lQ1eC)2rfldJQ=X:zmPQp>i}naO\KJ>ORu'SkFl(uO,51buv>e.Nxlmm8wKt8cTdN1NCW^>?RMzTGTXA85WgEEkcu": a& = a& + 160
    Mid$(A$, a&, 160) = "H=Z;7/WIB}pqjBOVlQ25>LDNg;BGQ=BDVwKL<K*cqd<I'bswS]U\sqgn=W>0c\.n[JQ;5cE^T/kMlLT[\PXco'p2\9HpH'gl2Ydjx5Kblh';p=rp}1h|>'BA/vOL,AbDcO6d[J(9uoA?S[N3^3>X4ly3'<xR{8rK": a& = a& + 160
    Mid$(A$, a&, 160) = "RmQxQ-(-CA6PTNeZqs/u-<bGey[H;g0l1_ZjkqyQY*c<-=tKfCk7xICOCF>kxIM=X8n|U*,Co*+[zRj{88A*}NY/?dDtXBG,xe\ZCJUWCQ/RLH3HSx1]/-{.wsArq>ZHShM[mp}kYqv6|B2F*sbGboZ8T1XQXGnE": a& = a& + 160
    Mid$(A$, a&, 160) = "ks3zFR(Oov\Ma?2lUv1CPVw\=40GVZGS\z6<SF*9P<9HV:,hvs<_X7rV.dvBv^0A3pX}xFzIhvRjl\-=2DUe_WncohZD|*7^W]<O4r[}/qQ1;[Vm*\XD*mc}x^\.)Y'ps]2pk1yfG*ipxiQ\gUo5TLxA0.+J(GWM": a& = a& + 160
    Mid$(A$, a&, 160) = "8jA5c'NG9'Z+)=W>E<3|>g_r|2Rx4m;aRCZb_C7x_W'?t8'aU)YpM:xV)vW{3ha,f5*3[8Z=sf,zEv^;30.[>Gf1wW\V[ooSPI_}rttt=GP=nbhcad9>d'Q'e7>EHytF\>oz<B_'V8g6tk5gS_K>k_Ei5I>GV;2b": a& = a& + 160
    Mid$(A$, a&, 160) = "0sZ>-irQ<uI{)<-rCrG](UMp0Ngy8FIUuxtynl4k9P}Klv*DhCee}>iSdHlc.tEp9lLU;La<|x3'\4BS:R6JpaA+YCT1g06AeCwR7QEs59*h;TM;,+H_vKCm-PP_MEahI},XvD;\yr3vFnVfNK4b]1PY0|LLUji,": a& = a& + 160
    Mid$(A$, a&, 160) = "i6b4ylt_g.QYubQCv\]0e?|5nA)<c+TQ;DcKq46v<3IkY5A-^nJU<3jf*e8(1Gu:'EEr5DL[Ud\7ZESy:WKj>)ajUXEv9_OOpf-4i]mp2135BMIgoX|Uj6_3}+;?Otb^;YGqy]wAHAmMo;^7/{t}zTpl>XeR+qV3": a& = a& + 160
    Mid$(A$, a&, 160) = "fvo?J(3l3L*XWj]dAI+dg<\l:w:*n{5qg{p1JLMXjIq4I|QJr8|?VyO<^NwOVZY3O7q1-<YN1+z[2qrDt_Mp=mvSzgCuc-phVp^cED,JEmL*KDk=ddLcGhbc|3?>tqV0LT5M<r.|Eym:>bOh\nXp2;lwkT/^q{km": a& = a& + 160
    Mid$(A$, a&, 160) = "}gY2V,W{2BELbj||S;3a18-n|44TX(fef+MzxSP{biX2pQ=V>+uL6zS?Nk?5,Z=yIHS*BEQeA>)\9?0?w+*Pjh*Z/7\oHm{8,-^|,\LEl^-J1S]:nhJCM={ovU]wJ8{:ntpGp|s;slFVw)o91>wA<.QI/i>VAxp8": a& = a& + 160
    Mid$(A$, a&, 160) = "Vr'5q:BO=,+x5gK{w9=Wenp2d:_q7R_2=;g(qE+xKB?U3X2dK{Co:e(eKn'jfIa(zHXzR_33JTi7lO_]KLY>HcbQ7_Mg(6.b-rEXrri)aAuIk3V?T/zo(^tyOgqq;WRqLJ>]g{E'EBOkOqj'rdW[dnf?nd,,4^]9": a& = a& + 160
    Mid$(A$, a&, 160) = "rF:qV<+(b)^l;bQIEYB3U;mS{>DEzbnpi<*exa(ySt{?STY2HpOmBLwS.{4RWr1XEXo|5v[zUaV94[|qKq7fw]DX4K-w4F+e0oxjJYQA{aLfhhUGws?.*NPK8j0;l?r]swfW1p2TMUrb{*jio3vBTu,K2ct]2NB7": a& = a& + 160
    Mid$(A$, a&, 160) = "=Q-VVt50(}oc(NFDv?E4=OK=AjJ{ev<ruNw|Zg]hJg>).]3Y)>7BwAbU\,)?,W;b?Sry{?*fC(*Rwzp2?6[<).wkMxhS2m\4R2iC]6aY_AP=\x-BH2B^mjG;uJXHwjSVm*R0-dR57t;=:1(OFt\{=z;b}S:oB/o5": a& = a& + 160
    Mid$(A$, a&, 160) = "hFpGe.v;{vJ\p_Vv(q)*(=MfognhR7mKY\p;9qBBjymmtw:0Kp(YwVwjcym3VL>CC6u?^VuJ-]6B0EYXwV?<Gp,xl?69K7kblw.gY9\5IZQMF^JHOIn9)mqFf4-clROgb2sta'8\N5z::<g[VKz2zT1Xn1h6rhi8": a& = a& + 160
    Mid$(A$, a&, 160) = "dlFwM^.=vA_9[iR=a}AZ_M7^si<*_wuvQprNH6aE.:)l5cJvo8QD+bxO.:A^3JGek8GEU,-0OTtjd^c-xhN44C;.h4BHRMO=3T8_Jwm;ggMb'TYZXfoe.X1ctUq9kh,|Y>-.1Tu+<<-_X.\^eWK3Kt/BfEtuzA'U": a& = a& + 160
    Mid$(A$, a&, 160) = "'2D[{uo0<c(yP1f\[*2=fnpvK\EYKC*V=jvvZ:tU^N1/fbfeI;7OqQUo)<TdDW|UwUaXd{ny:8|3=z,DzoV{-F{03;Hy0nWj:j.)3i{rVSw,sj32MZ,-VK3y3V.1RGhf23^K)k}*mkJZ_G^DR,X}4fm;aw0/-Feu": a& = a& + 160
    Mid$(A$, a&, 160) = "bkjBm49yri+outJHsUxzfd-5BPi_gZ2dg}[\/JrJC.mt;ooZ.OINCDtpJyUgd80,tZ5o[X}xHY3yR2_c<:I^N{S](1r?v5v;lDE2UzRirUL2v=gWbW_h4.fTN'mLL{SkB>?Q}j?vVq;V(p52{-wNciA2^-Y01I(m": a& = a& + 160
    Mid$(A$, a&, 160) = "ADt,]o?i7.aq<=16Tz(K)D>ui2rW)Eil/BEox]lDSAH8Q<,Vnxq3oGxjyD3Zg)(TYyNTU{e9^w>204(,stJ=iBk9R7j2r3yM7.tmN3XAdDWTtw>78[4CJaPD\*qi:BQ^M8c<mMm^2Lj/ALhSNImdf.CFdhSrCgMM": a& = a& + 160
    Mid$(A$, a&, 160) = "3q9Ok2f[,,j+k?|v)PFCwxO}3}RN^A3<qwb{qk?LdXr'GGYB=j;n>O}}3WSRqDH0247cOfT8TOFm;RcB}S4:3-3'}o>^J<c=TXz=Yjz4^9wU.b?8*Z;0+FP2yj.nF;+?lMU=fQID5sg{YwF,mMX{yt6>=9p2aCAS": a& = a& + 160
    Mid$(A$, a&, 160) = "nwt0sR;9_hnL79fA7])[,CbVe2N?x>oaKnry/:<u.f6^iiL8lP]WO4-dXf.d=C|F*(3.HP3?p[S1M|n_+')h.w0BKOi_e_5g15:w{8m5ETpVMlLH+NSqoGWFJ40h;LYK60Dc+/;=DQ+zulqYNvtUiYgHMkz7SB]u": a& = a& + 160
    Mid$(A$, a&, 160) = "<M{<tjDbgpr[It;>)AhI<dh1\==gdp.2},.P]SL:I*dSD{V4j2KVVf*aI{0mwU]71fg,0A)Vl6xMmotb?PH:,4,vh;jauQ/3Yc3fV;)VKg7cUyLWjyq>>+.|M'usHKEaZqJtZciC0S_>x;S4F'RL'<H/=Z[/0<('": a& = a& + 160
    Mid$(A$, a&, 160) = "qmHKJ2c}-+gVrBX2;Szgu8Or;yE6pifuo+05tOLOhyGZZpz|Y1ubV<;p(=Ed/U,yTe6NLNld_[f(Ma;.-({n>Qj1T;_Q.)T7)p_MJm??QNF]b,Pj\oB^5EMXg:?uta/H?W[bI<63?RFp=Uri|.ps7xMSH67\/tbB": a& = a& + 160
    Mid$(A$, a&, 160) = "vQMP9l?'.?sx;7oQtW'dQ(18^+KtghF2|^'XKOVyGzRr]u=IKW4X}0RkX-[A*.;9pA2||antYk2yTVT{=-VUP<]lVm2d^<q3>,FN2RxW|EHG.Ff?s\|^WKsN|tNb^bz|BAZd3su\4_fmz6<6^ZkK;)\cFy>aMl;.": a& = a& + 160
    Mid$(A$, a&, 160) = "vj?)ud\_]>1mfUzzJ'Z;[^I}wXJ]a:]A}Be.J<k7QO<-4H.mxB{+T'6BmU<K*ih?diN{w)R_S1Ij)F:|gu^3>tsRjQuiEWRRtBBu[ms9z9c1AzrN:dXK/.7r3j<YpE,Aaye>3xwF1|U]^ejVgK2=ehxOf\Dm.b4V": a& = a& + 160
    Mid$(A$, a&, 160) = "\*nMSJ,'RDjPH}p)BK.\E[Tqk[0GD|9^q)/SxHa7MuC}0DoCG3:rGTnW84lV:*0?3XniC^a(FgdWDHNP>P93y7'W8uq\oK?;Gs8Q^<N4G^\/464ZC{0v97/8y7rnX>orT_HUudGry1W|uhr4M:bUu]L9V+(rcIB^": a& = a& + 160
    Mid$(A$, a&, 160) = "5-EzHca)kvM9F.Ej^F(jMt)jLf1Bz*EC=VmH8{:4Cvp^1qrH?2kxSCBWw]:?4Q(-7SBrw'Ly)=4(hPFssa]7/8]bXj'X'mQkmua)j2i\_I'Y)WT):xZrG=K:neXXC^'4\8qo4]J>]e=xh7<n?7)\vN+KKqP}lZo)": a& = a& + 160
    Mid$(A$, a&, 160) = "zBRkmG-'u;SaEPYIR\|NGb77VCaUy'r'JC0)I=mX*a\KZ^aAyL3KQtFf9wfX>Q\a'Rv6TB0[ThPTU_fefrulIf>=U]A3/(k(vir5PM_hxJ5m>k/L0I-V(T|UmP^gc/2ov5_lSG=s-ttu}bc<d8L?;p_C)M78SBm:": a& = a& + 160
    Mid$(A$, a&, 160) = "nD1Jx001fK-E=}5ICb;R5{2eJ,I<)>6oYZ}M,TRlQvx3>Ai72pAHNHI|\sz1E9XBf45icaY)e1zmR81PoWMryz=;iCpKwK5'.pW>D;axnyI'AT^fZkGH?X/9[)\W-Lnx[|*)8dsQ\c.GsKF:xKLiXf{+-f>)mU8b": a& = a& + 160
    Mid$(A$, a&, 160) = "|l<.2jTl[<szbh6rB6fLA.uF,m'ls:n6AK'Qr09:OpU1=7ugCH>9z^d/gSVwd(R5iZ]A={8XZusJax|lS^(/Yv0J6CLeA9UCy;H.|Z8Czw(bt4HjU4wbnp5GN+qadC5'(4b*cjUvB]uqB:.<=Auu(K<.a|NqxjlG": a& = a& + 160
    Mid$(A$, a&, 160) = "2WM*y0]pbJ[_m/zFq>SeY{4aulv'D]9Q[}rnX1LHG\WdKb-0F<'fwp8t6qez[NIijpV-17[R,iSn*]-,}<4_0qQYRG2y01]ZMZtaChBx'-=c-mxazoBVHnwqZka{TOBdOgQp}*0K\jLz|(a'G0[T1_exn'Rkde)W": a& = a& + 160
    Mid$(A$, a&, 160) = "|[ew3hZh6iaB*_HUvSq:j)yL*yNQaB}FG>hG6{E\t/CZ6;G]sZePnGyr=0tD)w0yG)JGk{Z\Qyn80ftUD2Ph?J/)c^203uOubeBTFrR9j,=QLM(CT7:+Z0Ta'P0+SG03^yuP?6|L*L=j_4]B,,Bne==H^x>eAg(p": a& = a& + 160
    Mid$(A$, a&, 160) = "NDW6z)4Y.m0zjdak/JqCNL9U0}JhpnrT2MtbH=HY_4eCqlyZn6eGt5_|f?JrMlL{d>W),cyQjC0Ji;Z,gEpQaKGax:<l;x7tr3bo<sP{__urr:3lA6E*_YwZ=GP(6'<q)+X*3t;b1Sey30/mH,Ks1+|(lMGUjy/r": a& = a& + 160
    Mid$(A$, a&, 160) = "SVKBv5A5Xh^N=CPIGT[OXY^3qkH(vT(\r<=/\QPEm+d.8O_HoM<j9^>-?b=]jur5SSgMdqt5Z0apZI37=_NUr4:SXnIUcLh*[[1;QA40t587HNwlx4<U1VCYZF4KpRi4[Sg2BpQy]=ohwo4u.FYdusV7r1ZWS<+7": a& = a& + 160
    Mid$(A$, a&, 160) = "E<N{X}crd<oQ>W0}l5]gvo;t<.q<[UwV4O'2k21jmC9YK{(O+*-EXANY9bG:Qz\b]stm9[R10MfM1:C-E</??yQk.w3Vl-+MP]8.F2tGKepXAw]]:Aa*Z8v3=AL.h-4y3>ML3F)xmcAe:1oNDIQ:4)6Sn+{xhM1c": a& = a& + 160
    Mid$(A$, a&, 160) = "B[I62Gu}(N>.3|4J4A(gm4i;nV*=M1RTda.C,J^HBO+[rMRC7IsP.yaGa\dR9vB}^R=:rJaWgE{rB6_+(=g4B(AOYLC:K;d\-_Pgrz7XJCqG.)=TphnZy.9^5'm+*5\wpqFW;o2(jz7Czh)3hFjo}+-(bX:ona9'": a& = a& + 160
    Mid$(A$, a&, 160) = "n\Lj*u(.>De?dq8U2ukFabxtQG9rOK-07Vc,6oFNI5n,AyX*OIP2]vw3(S0l<g'yc5H\M^s01O,8]TOjJJ]y^NBM)U^huV34lEH=R7uN/P^2LL])KXCKCUm5LS'n]L2g=Vq(]=2*:>_7gKu|{T0G-GQzjpm(0VQz": a& = a& + 160
    Mid$(A$, a&, 160) = "2FksJyED)R52P'j\C2]5Y+YFE>rT{Tbdmd|Z_Q2)Vu,uMJYT.iogPfnY.a+pU*0?NFE9MBX5_(JZnf}FCw3Fr/P}?vCeGd0\(m[>kj^c|<M97HZkJi<(e5+o2{0t;iRKGUu4c7c_,w'JEa3e)iLjH-5YUS^lxOzy": a& = a& + 160
    Mid$(A$, a&, 160) = "kdk*m^sTPVdw8lwV=0J>e0Ag']>;RE?)bxnt-+_7w2_px/g;L=g3]djGKhT{u2>IX{BB4Q/GJ}Ej^PkP,RDkK.ktv,B:KIMArr}8ubN+Lr+CKtNPCLuRvs3ERY\Z?+lqP_o:<KIE>2[fvMIRtmQ<a2ZX\hTZqLHj": a& = a& + 160
    Mid$(A$, a&, 160) = "6G;C+55hl,\fh(pP50^uY/^qSTe,DIXX5K3u<ne19wuK{CiQbMXNteRra33fO0DWh/<4(dQK2Gi9rin-}Tcc,/eKCJ'(0aYF[-_JYzIfgPxL*Bj\7bk3AaV00T(AU-lYJb:>H2(;/,blFP)2{<s7jQOd^e.xHzJz": a& = a& + 160
    Mid$(A$, a&, 160) = "BxWOt0/j9UbXPA-O1YlSN[iu--:Y9NeXw6/)I;XCBL|9PC4NAl7oy:sswDR]Z'z)WDr(|cLjQt;O*+Xz{bW'UUg?Q'(IZ4|w{.2,tmLOAu<=I-ny|'<EVrT>PlkYpAm7FY\cu.hWX}(Cs)t{P7(uH)Csr+m>5p0a": a& = a& + 160
    Mid$(A$, a&, 160) = "PAFsb25L>AB5TMkV<2[3/2f472tGlSDzDbDQ),pajltHOipz(R1r+Uc*,bV\Bzj_RP=rIL)L\us|?4at)Mw*=}so{u7yb*'f2.g|40g*H\6.Y[hKRz}Q1:>}F(vvZ1_2n^Wchh/d,wK3|.Yg5+b-3gp6iN};>+PM": a& = a& + 160
    Mid$(A$, a&, 160) = "4YwzC)dLX'u\0wd}hBHT?H.xyypF=<Kq=MHz?W{QGVfB9u-J2q1=}g7(N:/CGTEkTFZYyX=MK)}kLz;iaKbIX7'luFtMHT<5y;>^QCbV}BK|GN-+l{Gh38[NY*<ezFGWK81y'->NfYjS\9gfw)[l0Jukjt[R8n^j": a& = a& + 160
    Mid$(A$, a&, 160) = "HUp7OMFt.O<sH:Zytv9>>8<-zl<79LaT'=xUmmeKRP\*_Hz*eeAmo9'gM{dzViSYE06W6hI3C;b=aBQLXqgYEfe,EgWk.tD_iJ4Rs7B4fwB7mq?:g=iZ-{bYoU/coFk+N+,Tlhi>=aX.nm-}xBj|,4BCqRJlIq'0": a& = a& + 160
    Mid$(A$, a&, 160) = "zNquGPI,/[-E3'*:9<Hf4a[;*7^>]-tLe]izZff8i5K{,Wjm*DfAYk,.FR5;EVyM}hJ)Iuc=8)n=olQTEq/NX.M}4KvJgCL]BxZ:sI1X15BZL]2dl;N*t?tg+[sk(X7Q,3\O?gBhz.C-e*8Rawuo<<Tq^8<wLkj^": a& = a& + 160
    Mid$(A$, a&, 160) = ">;V/Y13OBDYS.'cNzxL=tKfE;AonEnSn+?t2lYLHz>}'LbD9FagB8{9Layun=u:1]:V\FO.kD)nSFd6ilY3DoQRH_anJpAuekU;>k<T)-K?CgpBi/[74/J[(8,6?V=y5qhX>1mteQ,b'qk2^.x/C3ox,,k}\j}l+": a& = a& + 160
    Mid$(A$, a&, 160) = "xGAIW)EhL6b-TDhh'QDc|Dn|m_(1tUfeN2wbGAb9'/G.{2U,)zo5nM4ekC>K+qjW3Jiq.RIz'DzmlAoDQU7ED95Z.nUU[XqZV8iVj3USt^M/wB(3UQol?.S33UuwE;iGF{FDpNG=\QuXo\tMa_c(Oj>xEDU_H=PR": a& = a& + 160
    Mid$(A$, a&, 160) = "+h52IC269KghdQf.KITI_>_nrS\Pv2S^7>>K5\(N_2gJS8etRHcx8XEU1P?)3)zK4=/HPBA,;QD4(xDNPB0}WomA/Rx^P.3Ckz\)+g<QIKm{-A1PyBMP;Qo>|P}X=OUExNgAkuixBE1blGy5:M^cn\s:z)rwU9]O": a& = a& + 160
    Mid$(A$, a&, 160) = "j3[.Tzf?dkVzv?bz3zB}=ijsOB,ZOHM4):5kl'}NxazUG5h2'jJy,7cRJN2Vwm27z+S((YIbz19nM|0KvROKD>q0Zv9R1Q9{b,E0h=I2Ql+vvrX6>_OrCP_Saj,^f;rbmPtZbi6.fy/c>z|xGPMsn}Ryetl*Bh33": a& = a& + 160
    Mid$(A$, a&, 160) = "[82Q17Z'VV,;)]HtxMYD,i[Jn^Yq=OTLw]C=_b2jm[3{ECi].N)Q+qRQ)aRkl/v4<l:E5sYz{rYVNTyJk2HciWFEa<G?1q9b'ctWe0h)IBa_{wDAz0;>1C'NGll[u71<fI-iCE^7\cg*LfGKcJd;>PyJFJnI00?d": a& = a& + 160
    Mid$(A$, a&, 160) = ";6cFH3RXnOrynXNi9{/XskEfrn?YzhC0t/7+ahmp}C4kokbqjyKJnO2N1|-lj0U'BG?Poz+]Go0xS}BPi[01RFXmETsH?Q4o*8-NYSBXAg3N{kYs7b:ysj2qhbmgcAjM6>=D5;}x]ZpY4?3KBlYtuyb2GZPUdBCR": a& = a& + 160
    Mid$(A$, a&, 160) = "vc:-f-4VU7<N]RioVVwbthq]*:F8B<2.9(dQL={rMf/WnTC4))Rgu'+Bk']pY+Frzdk8\:*>nOse3uyMOh'*.7Pq]wqKZRPih2*sRfcm'1]UXferoZTd;tRdzbV3Tq;dJS1p9<xiw_lRDzww6XXx0Wef*u2cVL.g": a& = a& + 160
    Mid$(A$, a&, 160) = "]85]Mc8*s)K*Jk;CeK3o:a{5URbz_RvCgIpiO]]*\FOOuaUQGL|zVG.CdDar210T2Rf]K4)0WzEn+l(PQ5v+]E4KH7wJnl=cFdEII-KMT{TqM-z1=BDLx?Dz?R4zc?y1/Gxx}BDMpcyH<*83)P1[OY|?PRQ[Rl94": a& = a& + 160
    Mid$(A$, a&, 160) = "AL=-WemUBcY_ptBxbU1ZVYJwJz5']l'1jG/TWPx]H7psH=1GCRxah(3Z29:xiD8:2^>a-QoJPkR4ODewB9G+a)1D6V=DfX:\[*Yn?crCx*0}'4LWGWrxxj}Kn(t/QC4Ra.i*cOS+u6>xFBEQ^DHIZ)SY*h4)6xQO": a& = a& + 160
    Mid$(A$, a&, 160) = "2,*<hrRVQqJ,>w6|kjb1:/Uqz>^Ix6pwPHfztymu-/>Cpdv,oM=Xp,_BswNakGXp_is9hW/fx/ZQ_lP0_<]HIYoOM0z44=JyBAv2{Xi.8lJyV5*m>y)_XxLRA+Tri?y|6*_SHtlzSE5Rileg34F8?7KctA^A5+m0": a& = a& + 160
    Mid$(A$, a&, 160) = "WZm'+{FS5_',>_:bX-;{2xomPMNKVp5y1NZkyBxFl+G;,\pskr|h'm7K3,fzj1DBo;Xsi+sFB8w</L}]gi98Eu/GBa.=DRx0rAvbD<HdmxC3cc;3NE5OFjFNq6XLW*=V>|zp_WBeRSF'P-;WgHlwMliVDnHq/H*q": a& = a& + 160
    Mid$(A$, a&, 160) = "mndR?|:<H+_rS|dLP,0{d.hXuNV=i'b8}bAT;ay4RCIRWq4mq0u3.bORikCSyRfm\,<*B72H<<5{AlR1=\4Mf_=Vn{GAK5zDuf=+x9L7BDYfJ0nObUjAuzfiT]?QComMGT*hP;w_-'c(GJ.Qm}.HkoW*)RWzxmsQ": a& = a& + 160
    Mid$(A$, a&, 160) = "^VqF}a0:+e=4/X1|x)?'d[)2LgzN2LMs1lAdQ>b}ZjLASLiA_JG9m>YcOg]R_4[3Far,UL<.lp02C8aToQp68dkKbwPWpC<rDO65in5Ss1.8Nm]>dS^df]_CLE7\)05h2t:E1k3)U]g^tDs>r;'uJ1s],Es*7U5{": a& = a& + 160
    Mid$(A$, a&, 160) = "7:NBttaa2\eN>W_-u]>7+r[zT4(--82o3IOt<TfVmFbjj(4yKhRTKqMRSn/Ch4:VEhYt9AX/S^ZFCqx'-XLM=Z-)I]Iq)+mZ[0fUa8VPN^F:BQc[]Hds'tppa;O8Cvh*;_9I>ml55ae'N<2o{omgcXc6H*5=?TaJ": a& = a& + 160
    Mid$(A$, a&, 160) = "r7/18SfpWMgCIr5*PjefIml6LaW7uD\8PMuc\nSkhcz|+bvm|<QTpSPbRAUjTZk;E]kDTE=GujoClHcDIAo_=o3GiO.mnQkf^AEw]jhF<B?TURucchSM4_?2YX-dR/ZjHEHcFWVb(y9i^):Ug8e>{]l*8lKS2AFv": a& = a& + 160
    Mid$(A$, a&, 160) = "rN{?;y6|}0BOO_Bml*[BB)|,xLuLF_sD\>Lz){qqpx}mlIH'dw-z}GzlnX|XY^R[MteAwaX?/q89KM.)}6K=n4Dt0(NOysriNfvJm(nK=OBleZy4fUR4*,rGFy:\13-oyBPpmSGo[Fdyi6\=Ak/d>)ryx(onbOmF": a& = a& + 160
    Mid$(A$, a&, 160) = "W_P1['Wm])BtDD]}VPa15,m+s?D:J)4D,|C>,m>bz>rV,DzpmE5TuB>vSdVRd6Q/xx(E[7RA'yc-HGwGn7Lz,3.dZ{+o;\lbT5{W(qH\j1_{CXmbh7|ePy,;FlOS.dH1UrU:c|S1C-\5C1br3;p)I*[4[HJKQ/uv": a& = a& + 160
    Mid$(A$, a&, 160) = "fnUBgGv+qc0f,t5W+:^3>v[]:,(k*<9Ejrw(Qi?OFm>S[NBc.q7uoC]lm)}>EPoNE*8P]}WA3HF3SSS+K0l0wr.*?^L?([tBlO:s/M=nuqovAXP5(>0/LrE9SSqzQ;nyP2j_*GYyfx;f/P6Lq}bwNW\9WN8Se91]": a& = a& + 160
    Mid$(A$, a&, 160) = ">+cQq?SLxzbe+ig7PA:)d*LDmL>z>[Xl^j=LH+CdsASqu7_3d-<4S0.w'y'W^kVhQh41D.U42fQoddakMmNOUI9QaA|AL6QNI{^)dEMe8v^KBC.fNZF9/TK1XedLje-HW'?UquCjqvg<VpEOHa(Zl/*eeO|swLhN": a& = a& + 160
    Mid$(A$, a&, 160) = "Q/XsrH=t0xsx}U\YwnQ.L*-ruRm;A,c*Y6\6ki^HUZ/6o{94Sc^H^M6*,EKIQZAl?(F}.B\ld2/c?:TMCgI\0rLQW7KC?_Hy.7^Sj)xd_=z3G/W0ixQ1[b784DjT]*7dO}Dv7VM_Ia.0[cQ,auSWVNCUk'g:RIs=": a& = a& + 160
    Mid$(A$, a&, 160) = "WMN}JvNv1Tz(wV_M][vA-uye<n(1q'uKtI8:+iM]-'Iz{{PZmKvibIAG2R,SPDkF,wpX),mH0gCSN[?6z'kP\q3On[9npf,xZ]17;u.OPO/Ji}L+WWyj*tO<{_n4SR23/|Urg{St^u}.DeHJ_8QlaO|YOoUj5't_": a& = a& + 160
    Mid$(A$, a&, 160) = "AC;4sJk?*C:4/f,HR(xE0J1oW*0rQ2Eq:Jbv2y}EM;w|ds<LTrr/UQ?=*vZJSfXpI6KW9C5F}H9mdGi9c:hh>4Pm[ps[r1[ImCBo.2FOIoY_)cYd\*6)7'uwMZL]oT_'{n2kdTfHc{ZYt4>VK[4KiVu-^P-]FW-_": a& = a& + 160
    Mid$(A$, a&, 160) = "KKNh|WXplmte)i.N4gjNP*?7FeylS^yfL/<3ATLp83V?c)McNKQ]CGe'nNu(JP<3iH:n|co,/IP<\GnQEfY'l7CXn.c>u*pA[uEIQ8gZ[nNUMYSNl_p]eMfDM7VogvCS0?Ez]XCP(^lIj6>qp_=xlB8S1T?IirB)": a& = a& + 160
    Mid$(A$, a&, 160) = ")AX3epl9.z}X/'OG7^S5p)Jba}Q?a/h*PohNMtu3>SKtnJ_AZJGeasptvs}kW]qr]eP--9SrD^X5Z+h6l3fB1LTuzR0JL,r*a;/d;N]{azRI{(:y7Te}TY:0}OoyyF_IuazF9MHxrn^V2E2bE-T^r2NbqD4e?Ylx": a& = a& + 160
    Mid$(A$, a&, 160) = ">tT';cQ+hLc2i.Du\WYy,+WjFWCq^|HW2{JnP9,W9bvMMzhNZ].cr3Sx._mu8LvJfX7_XnJKK^^;];j36\}f|;n{go3kh|*x9:6v5hN'_TEMZQ'mzBGA(6}FJ<q6Zna75Kp6=m*qSe8p;DfYM6S[FMmjp3-(K:'i": a& = a& + 160
    Mid$(A$, a&, 160) = "B7UdU_/=d)uXJyEZ<-hJ>Wf0z]n3hittf9E44sY|4Hc2yTV<BNCOJX}=qgJF:lJ0\YL4^qvDT|I/R4Jg-B^-|Gx^aA)^uu<-h_=)hP(<cLXK{KS'S5jM?1+K]IjuGbLxdNqZ9Yeq3kg-CUQ48nB+l^hm'S;8-V9.": a& = a& + 160
    Mid$(A$, a&, 160) = "CFtkFvDF:dq'h9a}u9L_cR7T)X\|L,v4vXf--Jn/*1|kCTRn6N_BAV{^J<)zwIME5cBBmPuf>WcA73H,Lu0Bl>ABIzYI)J{63vGMzfSl3}57k-D4g/Ncp))-DHB*jL8A0JCb}Kv(sPowz]w4T}JWxP3pb<P=2GJ5": a& = a& + 160
    Mid$(A$, a&, 160) = "Sw9]PcB6S/Jm=\kc-4BieJC2fV-VxFyG|)oaYbw4*D3{tA)cU,UTgCC=z0QF7nA>W0Bj+^Np_/q|7itgS]kApgz4FNS5vsYw)gOpZZ9A)T18U]/GGsCKICv)9J3U'wNOn+bT;)V=*YybLJkoA3g]gTK[k8Y[OH(b": a& = a& + 160
    Mid$(A$, a&, 160) = ".]No]E[?l{*Ja?,D<\q8RBbn-u6Y|aPmx+Zpl2mkwM+ftw0R[RJD<0+sH(wI541c)j6eRn=8Kw:|1}_;k/La|Op412J;B=zfLf7-Za2FV>{/s}tVsJBMuQUEuBYY8kFyR-8D\31qC:><DVk'Vr733hfN+BTorqdD": a& = a& + 160
    Mid$(A$, a&, 160) = "VoS;aGNQX5,d^iTQn],_Mv1__]ce5'Io>Q<M5IEF;F\<9Jl*WCBQ)S>_pT^1Yd2uP8-Gq=R0lQ6wtp;QncXics=sS.ncz=mc(cI7K5R5Jw(<LOWWAZ9ir+/7h;ASvWjsRL64ixTchYZX17E,FTEnySZ;{B?x0i>q": a& = a& + 160
    Mid$(A$, a&, 160) = "|I47^^^>M*1;NL\_4itJUY[H.kT<;D[c2/D[3;N<EiWU:>GtqF0bK.{S[ep40ve[u9'h+qqZ,R|I*>FH5<rrG4gN)I|Hg'I2+k)){5.A,'bP>gi9J^ybs?{o66J}k;4[O0ZOJ5g<R(m/f07L.ZZ^Y6[ET?nN^u,8": a& = a& + 160
    Mid$(A$, a&, 160) = "<2bi2Kn9e*{YqHB}5Eq;99q|29)eR5)>Mp1rd-P1On(<R|56{xVpdF7>+Az?n<*Y8nnJnLHnwFK8XTIo}TVW(1^>WP|fNbd?su31(=+{xIdPhXOyo[^L;1oFd?x;_o?wyyj6H2Ws>lU}bcsgrt5n>U,>Uk.JXPZ*": a& = a& + 160
    Mid$(A$, a&, 160) = "N\\\SwiaqOzd]lBQM\M}x:7=9I5xnEKn;zL98e*bQrly4atBa3ELdvis3a1-;6nwnQTA?+qGQVP,X<\q>:CpAkDhV|Qxxmk7Nr<Ok4q,B[2*Y3vx]{wcP:WDt<QWXt3l4BsCnbHD?XWjg/dh]FLWZjY/4gzv;VrE": a& = a& + 160
    Mid$(A$, a&, 160) = "igMSC1Lb{oe22-?TL*R9KfDvz=hN]Gd>-u<dy0>j?4BZg+*rG)0>V)6PqP(|NCyou-3h7'm3zf:3M3Sz<3j}{,lNV_g?9vxB,/VOwE+F9\qUS[Bc=MtwgS8R/80OSXL(2.+Xk7m;G;da4_TV^a1q|{EbW]X9MN,e": a& = a& + 160
    Mid$(A$, a&, 160) = "Fg4Njx{7Yq}663z*<ae|hG-Fh[XNnA:mlnPq)-=Azq-g5UC((F9b3Ly+,w<|wr]og9WYIo:hJxZn:FYKJbhPIIztg28SrI62L^t|}3Ax>IJ.[?lFMejQP:y|r1Woznd7(MUsSOQ*eM\A=Y^4vCHs<z,Tl*vmn>ce": a& = a& + 160
    Mid$(A$, a&, 160) = "+_/DlZSPc?wFn<,/>Kf2t9Aw;{eH*sQ)}n7|aJT9vx<[ZX6^ymMY;LQ[..P:itM'S<N\QLIjGJ__=oI.})7g|F]s9D}Kt:k*c+}T?cCIqao<*>DnbrC_J|7I^O]6OOCUV73]AJ'DUfC=SkUL]{sfCzEUswSK?mJk": a& = a& + 160
    Mid$(A$, a&, 160) = "8N\m6'7:Xl;jD5DLI'=uF<>uNz]*[dY4dz=*sw5>aL[)uUtfk2_(Waaf/Gb8fvZIM5c*[Avth4A-83TqdD]p}BrlgVncwmrtMr1u;cd6OjMZO5TSNA.U06;XocH(>g+Bvywp[9Mx\bS-WDHh1a\[;\{y^WI6B_J{": a& = a& + 160
    Mid$(A$, a&, 160) = "Yp[d{jj:YKBf|iHxTK:Wt:Ww7-i5*'CbGH8H]/k?bJLiF[AV<d|IdY(H;m8'Tw>wA=nXQl{z>aibg)RpMyPtSYZ\dI.74VQ'2lmq)xhF?s^XgBtVIl9(e1r:nK)ng*zW^?[zRBxR=W44{S5jL41R(qmPHKwYyzcU": a& = a& + 160
    Mid$(A$, a&, 160) = "0GNqJ+*n8-Z]VzwuKB(,yC[vn[veoj]ZorMwc}IkL^qK:1OGW6;WTEUhnI8mV+YJgZDbnv|aDP]bmcMuDFQkgpwR4;C8j/yY4TfAL,G'QW9zv/)+3kY6vUN4\4[:JCq<B9{uF?E}v(_>U6M.;3r;l=qF|eIaK?hb": a& = a& + 160
    Mid$(A$, a&, 160) = "zmSIjnvi*3lLN}?Kb3xM[W7*Z.B[cRbHIFSI-j>YEr]^i,6(exwTrQD;G/Hat_O\/PyI>VRmE]qSRU?L}]jY\QEL;>STvCs;?6Bx)N7^P<sadY|9*HDu2P+ml*zMz:_nB3:/=y+bk,/'1Bi^'Bq'H0)6.wy>'TrM": a& = a& + 160
    Mid$(A$, a&, 160) = "ybN0>C<Z3PE-]V55QK]t[KffH7Ee^TJ]=I-'=Ls[rv+R^G<aI*;mBb=Ncry?gh8NYS-bgkx03fxvA29>bD_H:/gv65,_c^xWZxKwxd3?TJgG']306MfjGtasq1sQ/Fs{*Goyt0HE(|k_Ch>{<Gh>|F[d}>j2QINL": a& = a& + 160
    Mid$(A$, a&, 160) = "=g:<.Hc=8j_<DKi2gcKCUiNQ[qzTSb2Xd-CIgX1I3Dj,<d>A'F};swB*u=qL5[w8=.sEy+4M2g6:'B=YN4R]4h:>y']DlzX\YJBY0D)rUwb,TtU(KT.TupoVy<\>M)cY3nnm0z]i-4?<iuOT^pKo_?^CH9R21\Kb": a& = a& + 160
    Mid$(A$, a&, 160) = "k:4S*KY806j0xL_g_std7q>Ahi6PW<5dqguqq2Hno:HcI/D4f6|V_^RA)4{;hi0ObGZAHymgl3A7tYGBSU6ypOzvyh=[jpOBi^Q?4a<n}/4z7+v6Kcku)z-)s/jADjuipN7aobU\,IyXGXKh>R<.KC(813y*d.tT": a& = a& + 160
    Mid$(A$, a&, 160) = "4[;Vi?f9BpFSqwBtsd>xzhp7XulEu^K0\tt_,0u[]PjW9IiW<:B1btRXCs8CW0wh::DPW5teO\44Xo.e-vp=j:L4L\X\rmaXHEed//{-mO)S*lxq;'Bd,MIxyZcXn^HXoE0)[oSXby'.3P+i-_(wBlP=P;dWq.k+": a& = a& + 160
    Mid$(A$, a&, 160) = ";acgyY:]]}u4>MrnEYBpr=MFRvq0K^{u}kqI(}N7VZbeSw:DYJQc=M}bpi|ods(^]TU=tifD)z;8k}ukE<(3_v8u.O-wbNe|Mt*Qt+MwJN5ZCts9x\.fw1)1n/;0S*O]E-rs|iOHF66xORj6obmCSqm7*I66.z}7": a& = a& + 160
    Mid$(A$, a&, 160) = ".(4^Vvo+Z>q+p>zXC}55Q=zG*vDj.}Dn3G8I[4U8b]5F<G^a96WKnXL=0:9pUv:BTO:eyQ3ZzS'aIkdL|OU7Y1[bh=PviBBDVY<*M<RIqUs[0P;5Fl|gq4;0dW[+NsC,RdBS6,kNP2NV,p\|rB7Cv}>-}7ao-va]": a& = a& + 160
    Mid$(A$, a&, 160) = ")VV=aVR?*Y^,dAcH98p,rb=Dk=pa5gv)2S;^V3Ggx4VLKHhWpPp[5d^U-2.='Ukuj:Hy'hxCjdk>_E<b{Wt??3cpy;ERI,D[gY}VNQ,+46,5:P>-)ZuvXLy:;^*)Y=C(IN}f4pC6VcTO^MVMoyAF7Eo3N7Tp.WJ>": a& = a& + 160
    Mid$(A$, a&, 160) = "8[JFG7^3]qPJitW?p-=kX\7^CSO+Sk\ZxrP>-=c='V-cIOu^>4vr)eo{eCJX4w^09_{*K[']S-J*vTr7fc)M=;d_y|0*Y6xtCZxwrVrnbuv.'UBy;rXtFd}Z_MG*q3c=h_5XhzS2NUdKUCk|clPpk1-*oLo?n8\W": a& = a& + 160
    Mid$(A$, a&, 160) = "P)\ToOyUded^{24+gR-n,<1>b,U4?gHKB;zOVPHx.2VPd.m{9eAIAx|tqvhEdI_Q^v=V[p15sqUYnxI3RBQ;mJeV3wc/2n]X?nv8<z=LpoBAo_wTf3Wh:Q*JLr'C;_Utrcjf6)D:.v0wj)gu+I8XC7Pqn.):zeJq": a& = a& + 160
    Mid$(A$, a&, 160) = "\ff_7uB(BfpX}'7qke8O[RpNT*d'?Zt3wmr<R24W4n_*,j48gkm-XQfXfx?+fCRJ/;)*K|UyF4_yEdpY]x46]\+G'Fg1)risKrcVI[/|dZCO0}N,sr6ShF3HG\m=2F_y34i4s*CJ1a*2L2Epi,_YC_e(]sr]*-pN": a& = a& + 160
    Mid$(A$, a&, 160) = "_?fXG:[Q[5{i0I51]C_kTVJeUqXg14X=?0uk)N'yZi'1[58A1.RqyQE88]jvOz?|Oqp:^)/F>TU2gN-fk2w<p93?^?,uP37BMzmrYj{mj;[Ilq5_.Ft|ts-nP/gBCiqx-e_DP;^Fw3Q|{Mg72z:}-\4RAmdemqYa": a& = a& + 160
    Mid$(A$, a&, 160) = "(8TDN:I:79'm}Dar'h(fbe(g<PehnGbYa>LP1/tn[k(O2LB17e,{7sgnj^hZIR:O[fH*iFvp.DIF*|NMCPM4p-_P/Wlq_)>??YLO^1Ez_}Snkg36;tFlD.TFO?z5wz4zCX(LVZ)[q,4a_jfB-r-z9432w0)C8_9+": a& = a& + 160
    Mid$(A$, a&, 160) = "W<GAS_Z,^/daDsVY7Tij6^tBdG<_\*t54R3,.Y^u*7sZ>kX/9.z?O-5x9zyQHAZ8uXQd=O,:^:tN:<SxTP>T1=fak*,'Jk9EKLU>S7'LyTbU_Yy6gBYjef\'7320xK2m8'01q_vkJSer>dj7E}J7B6)RPMWk\VAT": a& = a& + 160
    Mid$(A$, a&, 160) = "4/.XXPy21\UTS|GA;x9wnf,z:Kb^h\Nxm5}8iD[lkla>{>L4d_wso=8H\_5)=6|g*J26WU?x1_sr>[+hKKDQdG_W6<xmuakS:g*>b\t,SqDOsCNCaA.g3N\S2/Pc*:\j|kVo\WvB7Iv>vCPo*:BiOwJ*k4DLz:se": a& = a& + 160
    Mid$(A$, a&, 160) = "*ohBw}eUHQx^1y;B(;,h}H.|u0Q6<_=oJpm5-Ux'_B:.+Y+WzJZ6c)RicgL1y^hS]8IB]rjb^oEA]Dk}4D+q_yl7TrklV{[yATDtV)F>886xQE0(oeRHW<nI/wsWf]d1JaTrj-^/Sq^kxel?3)iEiY96TGYb(B{j": a& = a& + 160
    Mid$(A$, a&, 160) = "r),d]{mX>NtG|i501JPx63O;GaA;0U:u>}=Nm{x7EpqLSpSObmzpFWZe1gSU-YodSdn2i*L*WcvD.eLhuD:_X/X8lnWL:xj(8L7V,o-uEazp=kg=<[?kU1c*x9svd>Y-]XFsaYN1z]\HSaMf[|WsQDQzZL8jj{mS": a& = a& + 160
    Mid$(A$, a&, 160) = "nl<;gU-w(\V{37+9\RqES;v]'?qH?1+\R-X2W)O[{PZ'6M9w6E_XL5o7pntMc*E_zQ.BDHEf_t<Nf/|j5wU>tT>kPP?{4J,/2N>BHw:uZlx\?jN?l|cwSS7;u2-1;Yw?KE_vUQ}aaS'{T6iO3k+n:XabnjJa5]*;": a& = a& + 160
    Mid$(A$, a&, 160) = "oSH:_DN=s-LEmFqCSBc;<m]pI9_G)wf<M]pEyq-cw:7'xka)mP24njwm/Sc^MqVX|>f;1SS)+Kd4EL5/r^ao|s*}R1aE8TSi(pMwU:k-1:'BAmBoqyCaK1kY.nuc976V]CnvrY[8)b)eWFtwIG610Y._pjy1u_Xd": a& = a& + 160
    Mid$(A$, a&, 160) = "\^lS'3.wLMYKaQz-=fz'hSMx2EP,9<wA(HsSQW_D9Azph}WH8P9B.7S2R,Z|Z:BYa7WNZSbaLtkiRZyhPv+K^svru(rkpA,g8v.DsE+K2bV<aYEi(Wu*5sMWJ0]_cNO+or251E>sEk;*VEqLO9.ezg|9*dhYmIEm": a& = a& + 160
    Mid$(A$, a&, 160) = "L[wEn|h(4mO_NI\De?i9XE^lSy;R-cMIOj,5x3BR\hnqBNZ9XlrH.S6Eh_uqwJCVDUp\iTkUa9*5T''0}Obobw6EbqGx[:e>QWzVmnr/M-,Oon[Y2AJ7.e2Mh4c9J<Lf+GYLgW7VYr)cMXf=c*dH8,]l0ZXx1Gyz": a& = a& + 160
    Mid$(A$, a&, 160) = "n[lsrXapFKze\bTQ/XVWcZ.v{my}BUDti]wLWyg_A'J2[2p+lFvLQ_f=mo+g3l9P?jOethT8jXq4:DT*bZx=L^JkI78r/PT\RT\F(be[Q,T4vO62f}O+Dixr5cIiR>RCC0\JY{P-RBPgTqj)TtQPrs6i[J)-f\P>": a& = a& + 160
    Mid$(A$, a&, 160) = "Z/o;|.j;6J/d8qFqrU)T=I7+;eYFef.TWoL7BR9A{Or^V:/tik4w-R(.tKk}LcuZyxx0=Sw<41tdXc-DdQZfMp\KY'Cy?1MhctgIFxBd'*yw.:*g3tT|vXav?_v7W].X*J*Tjy?/1-'A(qF22V/Tn}uALe}oYNqT": a& = a& + 160
    Mid$(A$, a&, 160) = "sXVvP(N{qA|l.Rklyt1zanaUWh3C0FEv}j>ZpT9W;Rmxd-PZ)ZiF75901k4(}ce6wU?7_].(?c^K9|u'f]J/^f,)K7V;4tmDeQr8]>43jjYb)4SXf'CrlAcE>e]FE-:,d;Y4?Y+^BW)=?cS=abtiAEwjG)]'Lv^?": a& = a& + 160
    Mid$(A$, a&, 160) = "aPj<Lw.keyv2FLQ>w'LI\lOwDjb8|qkH=s(N4N'3SV^?FNKNghMd-_/N0_OHGX9Fh7UQDL->QMn)-,n2?dz-S\I\w[hr5|68WKf9y1U(2fyu=L<2.ul9iMuVgtP*WXP-R+3GTEFYjhHY3)gMGKNKOufi{Fg4+CG,": a& = a& + 160
    Mid$(A$, a&, 160) = "+knH,')>I6JO}+(Tv^M:\bL6=[DTGP7Cye^bL2Hz*^upyzGTZI_/OOl*?KPOAw,6u78E:;aoqoyEIe|{aD|Mo,?Dc9XlQI9S:B<S)4Aa+fXA\YdfUFXlJ<=XQVnLGJ,F=f<,;C\kp^1y7za}vwpHONZR1=Ql'3'e": a& = a& + 160
    Mid$(A$, a&, 160) = "]nFBGzMXvhOo;HK/M5,ZxvBnz8yCvU:]9y)]3<}a6FdkBotZxR5Q+(t{_zh^Q6V9SoqefP_tS:Hc-_*3y)\T^v*554txSLnL)rS];Q7dIiu9m.{yR<QHU(dx7GldB4?1HgdXH2vUsa}Vr=9jw6Sr[O7I7}?^U5L,": a& = a& + 160
    Mid$(A$, a&, 160) = ",(>9X;f8|ZJ5tys]r9o*(jw(IS1(|TRs6pT7?ac*48dt/iEPL.iUEP7qA(uJ<B1--z'-rF9d,{R[.ni0>K1[7__2(Qkcx2q\8nt]l)RSK-t=?71Wav4m[D]xqg|]O=<6KfD4uumNcd[[T7'j*akPj=)s08jBTc+{": a& = a& + 160
    Mid$(A$, a&, 160) = "IhFy.4pclB-,UxM]Dag2fGL]Fs=4bU<ojF4h-T0eJ'O8.,eLz?WHTFdik>w]Bj=[}s)Tq[)d\lU;3}{Y>9fk:a0NiJISlb=}TZa}vuX+*51Aq?,PC2.RHeyOED7k^)z3K]|iUVCy,KY+Ll3'ag7RX<+5Wl5^2N/O": a& = a& + 160
    Mid$(A$, a&, 160) = ",b_V}pv?QS0\ih5gp32[R=/hI1H=if>VG;^bbp5^/X)*u(6HerDrLcDV1?(,kj28}9laMSm6w-OSq2w6Dh=]7.56Z;ulO+(sCO=OtQwpO<venP{Y?6>j26]Lp9+W-EOmqIMh8t[kvr6j5aC[B\SlKNaaOf)=GIT(": a& = a& + 160
    Mid$(A$, a&, 160) = "0ha6vzC[?+bc|>3>4.aNst6<K7x.,LdIfKOs^)qDK\dAVQM]oH^q):-mUA<x_*B'^aO|RukhawM-N*eH>z6X4x[+3]6r[y_GyJlE99H[R8Vja)N_)h\Q7uV}ycWr)Tco9W|-]|:v+sb0oG{:;Zyz/NbQ7pPXv8fS": a& = a& + 160
    Mid$(A$, a&, 160) = "mkD4Q^ueCp>TvLpnD_.XE.R*odUqYjJ+?vz-W]M'A:Q5mvu]]8cv}CECu7dI8aci*U./PCe.MBmDcuy<zce8eqsR?n_fYDw]3D1'aX}/9,2S1F|;s0-)ZpT+L+}6{rCLjc:5q,PkOAUHJba)/*HT2O*jD+]r8P?>": a& = a& + 160
    Mid$(A$, a&, 160) = "0k)C]?<fai9o\,-KOtw'b8Z>_F[8;KGt0^8Mt02LHOpcDk?fUpYES(V=)DSjD<KOiZe}M1X*1Ri}v,JSK'H(;Bmj?wgXB91L_5<9:iIC5-QTZz_6CfA/Z>Ff4yz_4HUEd9[kwj44kfa|^itF}>vSEqxnfVmD8X7|": a& = a& + 160
    Mid$(A$, a&, 160) = "x9ITql=<OA,jU*|eos}\Cm/K=p:;-Z-umG1aw2b([;yBoPI-Iytyr8hXG'bf(3u/PR4:Z,_b?L4BNT;?l*8GaSkjr<Oddv.9(15GMcQKw8=bcd)hU?}O,[m\N_5SNN<{DREE,|MFj?}HR,hlgw8:2-4ssy4gJX+b": a& = a& + 160
    Mid$(A$, a&, 160) = "I*U,Hc\L;pr)'_._7BtIvs_9ZnZwd62VGl4Lsy_,TY4a_7VzhTsFiN_13VEX>OIkf6f.rDoEw_fwo(/{)(E]TZ5Wf(^)g3e+LCk/D:[H9L:TU]P_W;,WFCVjDOyQu[(8cho(/hBc'ze|Nry1(+[SZ165H=cnJgsy": a& = a& + 160
    Mid$(A$, a&, 160) = "Xs6J3bnKu=H9/PR\i-|Nq(.bkaofJKKW(<;/MqG)cDt8pfmAN5V>j/}?:G-gFTRcLFEku1I\VGQ6XTx)cDX+MjM|C|j<H3SmBIsRssq'jz(CCJwx0}:SvPOYd-+[Sf;xTL3UyvY2PC/CVyv4k_.DUU_p4CkfKq-y": a& = a& + 160
    Mid$(A$, a&, 160) = "}[Jm_LdKD1k]ywbg3(nLEv[,Z?RII06l}ik4ui7NnIwe,dT]U.Vpk:lU(9fvAq5oZ]F0rR_>kJ>i5h]5Y<BKF6[b5cK^ZLvX,YOhTo=;)c^|l9eZTDl/:f2n\3RhE>Rii;qT>'b;dtk.>y6}R;Mjy3cn?u*1]y2m": a& = a& + 160
    Mid$(A$, a&, 160) = "Dy9Jc>pwgPghN3f_\7p<w:0x=['J1*K7K=9saf^M/a]eIjFc3;;)f5RQK:vL*]9'4vF[].\J_r*(?_=;T^:<E;S}O}=xS^W+z8Wvz9-9Nr^ZM+A^e4bJ^vfJ?C2EhXpS8z\OZM2TP4HeLzpeT*.NlpFWi}uF3/HB": a& = a& + 160
    Mid$(A$, a&, 160) = "Oxpfc)SXOmivL}{Il-rfS=7MkxQ\Nw5+hIjdSp0wun=c]z?sJY3U\ZRMjF>7MX>s5_60;[_H(WlDUwlF9jk}8O93k;oD)+yv+K1*->3AZ(E^S6\y[;-A[8.|47SfVZV|{6bc:8<4Y7PhPHTIlT]9RR'h,J^44>8/": a& = a& + 160
    Mid$(A$, a&, 160) = "'AiRaM^8SCy;f<ZlxtB8>-Pr*nSb5:c>7drnB'ha,<L'cI?6elMODTZezSV7BI^FJ=T,G7EuSE(vkgf\[yz|z)OYOE?bt8zS*LV8JRy-lww>t=7D9ko+J(UC*5t-mgfMdNcc*EAx*{3A[n3,a3sjD[QDqdvp=/F?": a& = a& + 160
    Mid$(A$, a&, 160) = "(3sQP\(hLhc1Zk4|*)1Fdc(OD3F5DA:Qm:ikLOq_IREnx6K_QynzG3YHk8]}Q7UVFux7tJ.Pj7xc-cOIKD5HOiBe>cKAwNJwigYrLf,:88L\o-KF_pFi[*JCnNfF;yOCBxDahP?|/p;5i7ZJV]qRlKmb0r?/^)l]": a& = a& + 160
    Mid$(A$, a&, 160) = "b;bK]BoeULXn,I,wC;N8/AyCse0?0bYEz<45+:IT06KR;/x]8p.Xxk\]G6Ku*v_N(Lu}_'s0wrbOE4Y^t7V8L7nlP^y_gKqkzYu9b)1bS'_?|)UJ.XwHOs{Io<3RAtpgC?-Die}m93_'S9xB^B5l}x{'SAqdsR_I": a& = a& + 160
    Mid$(A$, a&, 160) = "Hbc*';WTIv|/702:]-KF.6{*PI2)j{BFk;rQ^7Tr^Sogaqw3ZJ0-BY6_o'}}cimG[b(zxq}gsfR*Jvq(}A:cT;<{DGtp81aV>6z<E1x2WJGQVT.\0ysyHjzypVmaCfWS4gn+wY(:JXqi:QN4[KUHn|RP29IW1E0v": a& = a& + 160
    Mid$(A$, a&, 160) = "kEyPt1rTWsm5;Bl-Jx};9cU>4l?^h:e1H.KNxN)|6-|-)?Kl+GR^Qi24(T^=y/h^H.^uz-dTh*7pwwkNSvaLB)E39<BxKEi7yaPnFIoE{sIxV2F2L3*fy>9GQ_Znceaih]/NPtEFDQ=|,7C<?;u*okjgv7<0sbR0": a& = a& + 160
    Mid$(A$, a&, 160) = "oV.hYu]f.ypSwJPxtsDn>(uFOU85lxxsz-c2lbf2=LGPy[S}T=D9taOT:A3/*/<um9zKRd)DQqf.Yq;VyzgI,.S]z-CF2U]>6,tC'WP7-IzLl4c:vPtxqcWWziS^]L[mJo^d*_eYfiOP,Vndgr7mzCoGjPD'kcw2": a& = a& + 160
    Mid$(A$, a&, 160) = "4MVN?{1(<+mnq4nz^|NGOH}ER>clT6GSFOrtrA^:dZ_}{_LF7kWR3RBUNGWzTM*\dYct1zvA{2PCgXMq*I\/VFyAIB;1v\hT]IfPRC*SrL8\wKdIkUN3uapfZ8E5[M(PwI2Ta6dKxnnyHa7B+=I/}CfwRqEdz7hZ": a& = a& + 160
    Mid$(A$, a&, 160) = "=jS^vTnOXIr[y.bgb]>fJP^aFiRX5p5zCbBo?b9Z3_+6;gSI},2WR>3y:TYvVweW\QiG=H|V<NU/6IbIfH*ksistd;i>'-,F.xYn:.uWFse=E0Oev='RZbOFE_Gt6(s_Duh;RZ4_d}X>M6bHk+korJ_Ix|+uk^n]": a& = a& + 160
    Mid$(A$, a&, 160) = "]9EOwjg2e-yghyH?Uz_bnZegaC0(35jd++B<L9?>AiSjZ;mIicHCUGKDC/372U5w3(u::cowZV/sZRK>{SAC>qu5/|,zM8n6gC5(Xlw9-^n]XYl9?Sa9/*nleW>8V>gs]V|w>cT.lQ9<BJt1t5Nd8z;c/RBsudH,": a& = a& + 160
    Mid$(A$, a&, 160) = "]:qfNmL=tCJ:TL|6q/T<|2IqQEHa,9wnD,(q]v]feHyP;6vaUlT>JcFtDfW_Rhgje)2FS[3L_<uo87rGeJ4y*u1[?{dJ1ia[9xLWO(R;p-C?pxPEpQcx(_NI0ur33,qVzh8=w[FAX{.eZmX\j[t}rCC)I:{s0Ehi": a& = a& + 160
    Mid$(A$, a&, 160) = "^HcH}|*4<Up5ionfu)*JX0VnW)U0(t]UfmW?L>Sm<X1}VP_v<N(+peGhXtPZS[90^vr}O*W4ElDBYB1qSAyu[*p=NhU_s1p6kB\aZm-HhF]'0[AlS's|IOF01wJh]X32x(M1zVubgm^7Y9.x:qbX(t=j^+JWe;gS": a& = a& + 160
    Mid$(A$, a&, 160) = "3Q),)4SbHKsBTNF:_hm*WkPB{yC0Pw9.KlV:':g2(>}OV,?Kv'8p94G.vF?[d7Phij5,.uMe74Ft)0[wRuKw,c=W3rBVeSMo.{>I'L93bIAWvm6_xjk|]/ltGY_']X)k5ZFONL<eUKb9YdiZuhCkWl}wK9)K?p:i": a& = a& + 160
    Mid$(A$, a&, 160) = "uBdO\o>L{d^</./Ah[w,OEGf8IS4.o]H5AyXVs<bRs1IROTR>9>tsoQ4jTqK*Rw56e/YT8fxKlIh-yPaU^T\9t??TjTbK}UwF)J/n,J<B8p7/H0fs]i\.}f\M(Nb:k1P5Nt(Ulo'U9oddpK=^Zf:ZvRt:Kus9^0D": a& = a& + 160
    Mid$(A$, a&, 160) = "|'4^TaepWjqKaV}HJfHT7/Zp5cMhTV;2Ai|TXmS_6DxQrD4OYO/wPI'/4yQU>gc{NtlP\)wg/Qi^m*<SZLU2js+ppVP4i-9f,>L1Q\1ZBMF|1*Bw^7XQWi?gvMz|VgZKxET;K8eF3vL;eue_)je*KRP6.rqIz/+D": a& = a& + 160
    Mid$(A$, a&, 160) = "\Zy)dxwU14Zv=Yd+>r[>oXD8jZoL'H-Z=)LVp7kBv(}V8WMj(|f9<VQx4.QbMZCa3cjl*)-OKnLuAsQsU2G]Vcf4X<m8/WJ7n2+_ljmERaqUAXZst+m)\KvYR\6j=U;hjMfNG6fM84is>OBlz4_V<J*8iX'Y=SJ0": a& = a& + 160
    Mid$(A$, a&, 160) = "l:*b=lJF_5Zu|u,*Z|.st38O?p+{Mokp(h}*+yBBlc(9}TuDP=XjE{y|HZsDq'^Yn9-*J7fCmfjK;Oe)s7cauwE/f6uy[F;4sBMLuwuTuMlk,_KMkTdWx12w^rjcPFQ(yE.kfGmcC0a|qU]Kb33bJWUn95W5'kXl": a& = a& + 160
    Mid$(A$, a&, 160) = "8TiLOLTPv8*E{HQYq<J|hY(YG_EIUhDEw4<U?XlCW1Kxm=Ct}6DD(t1*4iHS|(rUF?NQyzq+Z,=VGJ;D/c6G^g.zs72(TW3cWFvz>-(9}Tm:tW98X+HqeqOe([eV:tY=K['9*M?KniXd[w/)JJWNZ:+'u^X8eBu2": a& = a& + 160
    Mid$(A$, a&, 160) = "mNk-r91O;D(uVx(Um=45idQ:5<qxG2}aYA)V.c7*MM*LKpN\(AUVr:{?Cu/2y*a\D\D{*8|4*7j<bbm7w1bm<,3RRK|o-Z|Kbp-HM00-;(=j',ajRueWG>9XruPMpwk{Dd]]f'wuHR7KiUxg'Hq;91gg*<lpB3-:": a& = a& + 160
    Mid$(A$, a&, 160) = ".wS-]N8,gCF)+BK,(gmJu<zT:*c0[GTLXLI_F}9OVqTvOx;|=K8YeCp4_B1yO>D^ChM3gWR3cs<'0zfy4Sz=)qqgIIS^=<fK)bVKBgj(,I48UIY]u\jVc;^k.=RCR+h;PEyONGxAI(WZ]DqjO8f<r2:jAqi6gA6|": a& = a& + 160
    Mid$(A$, a&, 160) = "-j-_sa0US[j<hS1*/nam4Hspt1])vz>1>]JFL\MfQBsCnu8.q7O>;7/jzzK1BO|^nF[7?CFUo6;;7^]bmyn5<;la?L[^v-TQ'oG<Qdy>TYbN]5Q[oX(n([dZAGugEy85}o66*l,uZtYA>KXx_;O+:cvvL3YT:qT3": a& = a& + 160
    Mid$(A$, a&, 160) = "YZXEcLFlF',zdUI}0J[t8W,S88/82evmSf38sPC=(Lv-zNOIX7/:Q.?z(9LjmBeL/2<Q,+Qsw,_H[9cJ{)y+T\+OylAMq)Ny2R7a(Yyfdk9NU5BuF9>.N10e(L*,m6,fjk=EXd+|(>lOW=2y1JaeV|i9SgA=?oAv": a& = a& + 160
    Mid$(A$, a&, 160) = "EO?g9RK9367CE,HBmiksM6IUIh5AYRP/MgZiCkX=w4:GzbqkX>f\DBxp^s^gw3ITLuiI'ilGqV8:X9s6JlZydPrkD3skbiC3:Vk4iS62lcrPP0?(iA[{/9M8=Ue)9g9W20p8ePEErTjs8gAUD_(X]hxG8*=mTtd9": a& = a& + 160
    Mid$(A$, a&, 160) = "ERn\,PpJVqRL=4;Hi/Dk._CVE.=dXz<0h*8WUVQeK.Jo.Li|lw\Ju_-D+6T/8p|oKGjm1mDpojCc=K7dw;zFnD5-m=HtPx)?SzkDh=V,}DH_DfWz}-R8Z+J3'x/Z4DK5mvdUROE^F\Wth-U(BZJ(etSa\oDy2r0]": a& = a& + 160
    Mid$(A$, a&, 160) = ";S*8tm8^iCz9l]+qRpU=[['e|K\obW8)|C>lXq||gv[/=rW,tTdGXbaQg*8xSz|r6J_t5=[x>j9m<mwF*;wbZ+e:_L*\QsS^k=z9nr19(=M+pQwCWl:+spdC1P1SyRO(pW5Ia<cQ.6zP0Y8hNyYw7;uji8cJYlpG": a& = a& + 160
    Mid$(A$, a&, 160) = "VDaIXdJowpfQX^0OO8xirTk9?VEenN2C='h]^r/jlh]>gxM_j8T2fhe273:pEh**)OS;VK)z(p:qJAl}-uy-N4AC>2qbFS1(DI-+;kx3UuKE=/lS^Bpy^vL*--i_erv;|j;a=>h6oFj.X>O5ft/k6UTvQ}Zp,/U<": a& = a& + 160
    Mid$(A$, a&, 160) = "fmHw8vEXgyqoMs{PF_/'Xk0)SSWnT\}xT*|bJ5j^[t(6VP-o/s|]l'N|K7EPpAO{X:hn:]s5(foPp3l9fN<U<2_UaFEVbxjgu9+5]W^z9Z(K_]=(]0g:G)d:j{-.E[NPJWOr0.6|owtL=m85_3UbOcxEn'qp[9PX": a& = a& + 160
    Mid$(A$, a&, 160) = "m'dF,L^a\b4th9^T4eXE,GGyqminkN2Zj>e<f.orAO^s;rpr]'0f:fDn=L8zbYb9.gZl2It6Je8\;1UROM(tG]w[j0;i-H9P'?TM1ZHCukP8xH.;B+LaW<[Vlwwfgl(A?D-C5jqA5cApU+)_y4'a8n84y>mx?7{E": a& = a& + 160
    Mid$(A$, a&, 160) = "P-mX,h?pH,B9ln;=3?;:uzRtPlTRu[j14BpgJNpU>zWf[qezkl4citpWOcvV/3VnXSQ'bJ^6|_1FL;n'au}nF<.w_OhyPaO|SV+T7Bc{o<I0s+mMN[,]a>.>R{4o5H3owLj3g?ekqvrdaG.},5yf<gJPWKp=7_Xs": a& = a& + 160
    Mid$(A$, a&, 160) = "1ZtO/UMZ:)xB?*>1mjHiCZCuOCP8St5(]ogMW1;.kB><B>dN,m\ap)HUe]r=B.>DC|S9zW2[paN]+ToAEmvx/;<8SGzxLXONEpnRZX{sEr;{9*tY1Ax9l6RcZk,fupZ5z6.S/^;jE_+=aVdb.Vn_L>I9UB/[Q}WE": a& = a& + 160
    Mid$(A$, a&, 160) = "st/.laEJG1WaNHI/LM':RH6iMW\ahMyNjtaEiXoAHtbwGN<H7,/I)CdR4/s2CA+(.L<=XB^Ji]7suoW2_F\dk0g[CoW0j(QGKk)|R.o.t9.(ta+3j]z(gD{K*DdKAP:q9:NJ]vG;M:JdeF/dZK^Ye<II]oF6WVyK": a& = a& + 160
    Mid$(A$, a&, 160) = "w5=e]+a./8,'9*]Iz'cSUpCs{b2>2ZExScflmcakIqaIT(;)DYAfOrVon:KmXXl)NkayH/t4E8<Ie1}E<QG3(2EfgAfmKrb5B9'gNC0T'osB|hXr1oGS4HG+A:JiXN*j?05)?R9x/BK^0vI8(6=o/UBV>}YNvlSR": a& = a& + 160
    Mid$(A$, a&, 160) = ",APi*j?=bB/0}0/15Nh/a4zluUSx?4Q7RcdWDaO^xxj{tI.BxW^d?)u*kwx+qSw[gnJtD}1CZ^AfPCELDvRr,XCiCXbb1UD_DYxD+>56PNbX]pVeig/)QLyMNuhFcU'pjM6r*:;S[sa{dGb94ZG\?k;_wy9BIDgw": a& = a& + 160
    Mid$(A$, a&, 160) = ",7g{;5z(SeO>JjWlE[MN1aQby*1SC5*cfQSD.-cEC.iH=+qhhul.R+nxKu:2*\dv||-X959y*>sbpo-+;yY9Xw1l>c/f[63Mp6HLs_nDB:+*5p<fLU41oR9hMJ<H18Q6nXKVwDCCJu<qvi/)ZR1QxR=>[)gL+Kp6": a& = a& + 160
    Mid$(A$, a&, 160) = "+?9am\[u;H2_.A6sK_5;:I]3gJqWB0g81(I_D8^Ph2GoecO/SB_VDEo-zkzyVun32}yjEN_4/maw28T3_h)v'Cf0G}=)>*482M^tOvknPW:N8<g230E*6v,n2.b42Qrf8hIjB?<o?(CLAXVXO,ZHxCcmZbF<eM2j": a& = a& + 160
    Mid$(A$, a&, 160) = "6PY6n:xHzw__Ug|65-+'vYwI.''CA:Zw+7377]A?;>e\lVXOdtR;(pd??}l:)y,K[4W:S0Q2xi5P2D2l>]<<oZLmd]2ilXO|3ofeVl[Ba|52gZ,=E7O*\jaR*<clXl]0UF02H-M>i>NT=_kC-g-f0NxQ9]E_E<-z": a& = a& + 160
    Mid$(A$, a&, 160) = "mtqF<=9WQ<IG1kq5lz_(A75T3A=<]z7^{L_Snnuhn]|V4Fv>/b36]G'cG]Sj.NS9_W;o(s^9Zvwgl|SV;Bb<}_XXiLJmKA;to/Cz?Z'0|*0WNh>N{j^m<*tRP4PfO{2e/DbFEm9w*4PpNSHsdg.\ENP]Tg;h>Q*C": a& = a& + 160
    Mid$(A$, a&, 160) = ";?l(r9Gex9mu:KmOu5)fZO-j<G=VEL_2)i^vs|Ft[v*7G=N<0ui;0cihFJF\,Q;H'UbI}M_6Q8_yXQN^f6gi^f5ugZ>t]?U8BJYOiv.^|]X3?0(u7<w_{+{8-QkG6CVhp=qIL93]II>^_+,hnBCiEMWYip8D^Ll^": a& = a& + 160
    Mid$(A$, a&, 160) = "*(x_\k/0BixbiG^l9.gNCBMa3OSy+4_10^<S9?A8pZ|zwLvV;-5tsL[UoL8k5i8]4cfSPlTF1Jv*26yN]yWP9,G{=.XleGf0k_mV0I)^dKp}:)6FkB)coBF*hMBxYo8NTNyX9r:GX9q]PYXzD1mAI>(x9Nv*'|2s": a& = a& + 160
    Mid$(A$, a&, 160) = "H/GWHL3rXNVM(SWeB)ioE6v,)H4,wA)G+)4u+>tMvs{SrsfB.{Syd*rY6M{m-mP|DlOxmBs9DQD,D.x}?1u-QYrj2YG40hKYzJ2XsO6f0Ttp7a1fVD^KF}*aKy=m(1/6Ut['LzkW1zHD.G,M82[ZV6vh[Q]iQml{": a& = a& + 160
    Mid$(A$, a&, 160) = "yjA=:nq0s9LZv>mmnh8BtxTBSnFa}Qn?0iFxrvd7uXX:[I8UGvWd\j*(lTMZR)(Tz5/?5bMsjt9=peszy,qk(q4'09GQ.8|W:9XIbTN/DJLp-b\Y8M<TG?ZUH*^\f_Xk(d3.sy0LtmpuLLN}I+tag}cK*j8yT<ga": a& = a& + 160
    Mid$(A$, a&, 160) = "HrUeCo5g'W-wzTbouGy7Z70Waq*<1ez->/yE+P>IavP+ZBUE5AQT[D'eay3cfya1(:q*tiD-.9+Swi2'ZH.TW6_]}Z-jRUy*GG),p7N_<amLlatV_lGCV)H8qg_8FX;3e.dN7[3\eq]?ksBqI-m5/xXs1iHORo}D": a& = a& + 160
    Mid$(A$, a&, 160) = "hh1eaCcCcwQgM1gEO>S<Mq3g;:VYsXf;wD7=q,83Zqa(TB\oAWW5Qmgm6)mmF\lMs6Ae<tMVHEOMd6agaBHKRLIq)NxyCV47W2zu^.3?7?_VgufSly*U_KqZVg,'?N91OI=43eW{KRRlYJGfc9Ff2*Kf_eWs[>>m": a& = a& + 160
    Mid$(A$, a&, 160) = "jDw_{9\sN8H=1(vFbZ/kQS[BA1X7<jnnC2UVZcB|C>MEJ2{<?S\lTiKiro8)=5xtPZ08m>fbUJ1m>x7rY-69EO'tDiD,nonr'mRCf>UF-pE+BY?Tz2oB[zEN6Y6tf,nwKtXf:Fzc[.j/D6t(?^54p=hZ)'=?o<yI": a& = a& + 160
    Mid$(A$, a&, 160) = "N'OIB:HFFO\HoQt3:y7Kn8/mZW^)QA-0'>D2X(Y>5sx7KQG{:S4K]5swv.6J7vzb>fv]>XFs<E<OExlS76{kj]VdKO|HNa-lH;_.'enIvhdlBpG<FOG/_]/;]/x85hX3'8N*WKrs.Cb:'h2^o_ttOc7Rr<O5SO(U": a& = a& + 160
    Mid$(A$, a&, 160) = "XW)Nby{(c4:Txt/3*61BQkA4\LWftA5fY*m2L/V>Ts*XkhksNKPdth:>z6nIrT[C0SwCVLzQ)]fjRKM8Qt^)ek_Y=ejo+Gd*;PD\6M9PhTd+1X1*KOGnv:kA31R;'jgTXy3.?d-5BRXr/SBJAgnGWGrAma>xWHDp": a& = a& + 160
    Mid$(A$, a&, 160) = "wN:'V|BDy,_ai1|O0U8EXd./crPRr2zLabg,]p7DAr:sFIlc-(we)O9vnJs?Nt67lT:xW8cXnQ>:uBI?DN,/Sk\T*,8/5}d3MMhJ58ak[k8nt*yvGr^}bm/|'Rru-)s[ERSQ\WuFzrc(Ebh..l+b{<\smE=G2EOF": a& = a& + 160
    Mid$(A$, a&, 160) = "c8dqHL54_;G5bqpl5Tv6Ot|wm|LZ\1RaeZ||wgbz<hQ>aV)iWs}/:FL6L(bT[al_CMpr.GLF|s94fIhX2qGoq2bv08-.rgcSEBj5jycyD2xxVw:J0r_xkz5Luoc0Fju[>kV20[y8BjZKdofiT^'fSVXnll([9z<D": a& = a& + 160
    Mid$(A$, a&, 160) = "RL:<l1MzhEcw:kFdO_fuEM4e^DioSlX(D:fZgfW/5.bU^:Vr^1Pjf}b6M^<G.bx|?goN6^^ey]pH6}B5UL.]YN<{-jO^}O38:JG^S4*8ll>jZtYd0pJ_NPLsgFJ6}bVi*X8aqf9UQ>}_8L\K6dl2xN/po-F8i]6i": a& = a& + 160
    Mid$(A$, a&, 160) = "v^y'bBWq2++(IK[io(9f.lOmyt99ScfV9YGlcxde:[BHS4Jd3lj-7}/cQA.o6SDYL\YejgVl7zYtq=UU\pa),5V}c1F'hz/s3LUl'2Vw(iD1]oNkxo}dSX0.*f4ga,XageW>+Rrs*iQFHG:U}^hOiYPd>P-=.{LL": a& = a& + 160
    Mid$(A$, a&, 160) = "17*aLR+HdfS{<55?4N1vg<QJ9Yv\xj1Js.X}i)39bXD-SAF97+44}>05Gm*'|9am4EARz5MiX8B^N7d24=>6-/SU6+<9.0]=RnsgwjKSv/xy{gB/hhE(xu'_>wHulza/u)R*-5]OjDMMT_86VtYWkNDTn1XwAg9=": a& = a& + 160
    Mid$(A$, a&, 160) = "/Y:C+*s9('Hb.on{oRrWnoBN9k,8YLJ^:3VGZ+Sw88TeZ>;9}cGO*>]cpC(0p62i=+T94LRCgJ+6jWB:}HdIhmj+T4h\V6b.m:*\Mna-iJKiwpN589pA=9:v8e1Im.z:/QJSIIK<PGxI\G.qx6g[f7Gp_KpD^y?O": a& = a& + 160
    Mid$(A$, a&, 160) = "G?gDio9D].bF|.rujJYj'GFd1[>yC^XbjE-g+Gpl>'R\86dECZwk0OlS;<NRe^9*6=GxQZW+rUBLGi:Qy/wh\84FM|HC'Es7RZ[Q{YQHuJ3lu00yez\\mM7r2^V^JX8gKtK3GHZKs*ul=zPcm?v'leBHj-V{:h5z": a& = a& + 160
    Mid$(A$, a&, 160) = "<b<DSrnXMEA63U{y+Ya<[XLARG+X.pmHObK_gZ>mVD\8dxUvjc-kD(;;+h5+Re3+G.f4zwoz:AmzdJy]*Tj[7=y,SQ0d9s13tJx]yMynClIBm|PbgYvDR9BoBnt\>'Y-3WnW|(iCyzIFB]TQ;p78*+1JwyGls0}r": a& = a& + 160
    Mid$(A$, a&, 160) = "\7U1M:Lw^W(yhf>_+shk?5wQERflC9Isck-POdeD-Mx3WpyZq6(3EJ7q8]YfmP|tMwORfQmAQXh|3DP?0imzodU)C|GVGs80irZQls8XMdyFx/J41yBTlWB4Vcq\VYNY:8CsWl7k\'_H}*K{O6DKy?.gwC,U?;k3": a& = a& + 160
    Mid$(A$, a&, 160) = "X)Tibp.nFu5N5|U/b<Hkz^p6W(\i74+txVVpax_k7<Q0]R_vdg4Z'JsZ\uAm:^bhUZOA{hR;nGCrLi]C9X-I>U]vOUoVE8wzsIhRN/6TS2anWOBVA]>mF]Y:D-JIQ1']06[zPDHN]Dn483Gr>ye=]A\BWDUmolfG": a& = a& + 160
    Mid$(A$, a&, 160) = "4BE[}Q9d-jw0-6A6_B-WXq5A<e1>iHy81UM5OdMl=TUR{0q(3QqaNsN\>-N7Cp3RWLEtgY/:0,P+5{Wt7;w0-qI/b^=xW:h?-VMTiz>JFuQ5D\BK8us.aqr'BdgQ.W[*3FRqp>f7)0g9^X4(VwA)UqDZvd4-43zS": a& = a& + 160
    Mid$(A$, a&, 160) = "eH(Sz,m++eI?PG58vP\U)\?0-_q.\6BBd.}/J9;avLJDaRBEz9V2Ru*jvvb6_*4B)TZ7.ehS,\<==tP1-evwi6VehK'=47iYZd0RaX+F{If[nH9^x|V1kTLX0[ixPB*Y/UM+\.rH->y+?+h^kgf^5L6y0Swx2v?C": a& = a& + 160
    Mid$(A$, a&, 160) = "20J-:>SNxW,2c{Z{ZsfVWJ38e*=}i}|RezlZZ-w<9A+YI-qJ8ovmFoiP+p77k1|cy<bL8*>Vup|WF0h:L'1<t,Gpv)P(JFL[k=(DIK=>018QbwDOeUFaI9=?^AttIAsveZx?3sJCBzLiCS*)g(T;Y(p(1sd(6]d3": a& = a& + 160
    Mid$(A$, a&, 160) = "HSOF*(g8'g|pH7TOHTN9etQ/ipj9wVL;R\L6<*s)7gEPDuM5S.dSNwo|85Xz.iAOo\k/QIwO+>3N-isYV=U0gE9.)Dd[up6iq95RdVzoDZ'+tsYFkM)wk9a(?^<6|UGJiL]k0hvrP,Vf2rMezN*)N?ATCiLex\Uj": a& = a& + 160
    Mid$(A$, a&, 160) = "EPU,h,tvCKEHYzu8)Z(-ur],/4f.R;JANdQ0M+m*']i,:XdEiYMB<Bu<O0>|PmXUC}5qY)QctqoWGV|3tu6ovGS2Dw\yPqXAU{8)>BM<^x\R,ZwU;zWLD4aW9e2-reHX=ezv5H08j3EU[v9llQh<h;kA?b_N:afH": a& = a& + 160
    Mid$(A$, a&, 160) = ":VE>lw0BL>3>?=|V3MBrxd:Ua={*W1kUJTI;SvbFFTAs1xDEyo<ofWKBM}|In=0qu)[zM}75qS6-7,Y}p6vBNONgj}1sVPpP5{0V+e2zD[pQ0IJ7'+gX'|2a>[|Gdre:Ez(=?<0Jl(kP7M8cAdT2iMFh1EA+5qdl": a& = a& + 160
    Mid$(A$, a&, 160) = "3ZdOkN)DXqkS(Co:(UNq<Mqd)]>ow4s5d64oV>3KGQNUBK25_y>Z5nv/_[6P.H7gnSP\sQ8za\nGtzQ,]bAY*<ho7isn<e_HAWqOC*vbvqG0F57:IpvGmHtA}SHa_NW2j0lhHkU?e0.qNlunQH)edE?Vqd]pdEyc": a& = a& + 160
    Mid$(A$, a&, 160) = "y83JW4gJ6.0-b8aG'E4}9Ln<GsqM\_8kp3zR+H-rBziSsUb6DUbuk0Mb0YJD0/Mt'*(-(1_xK}x4n25<VIAgOg(}mIk]/RTk'CBbKkbQV7At,4(IjTCx:_sa/cp2}e^LQNwP(ti0Tf3Z[Kx6ctHj\U:Lwe7-VeI|": a& = a& + 160
    Mid$(A$, a&, 160) = "<1n3v8HSt[oCMzQWE+7HabvP)S66=Z_v_WgKQnsE^9uD}2bbgBcj02m]EubcM-U<|:1Hc{CaL;OU';rf]N+lFgsCAaa4(9f,Vp;U,2M?Odfb\[pn+5i5jo7FtnW\bm1?7S-vS"
    o$ = Space$(66412): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    harp$ = _Inflate$(btemp$, 67401): btemp$ = ""
End Function

Function harpmenu$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(24306): a& = 1
    Mid$(A$, a&, 160) = "3s;p/|T<v0u+=i5q'(-]V>Paa('/k9\'6G9e(O^^i''''*{'{:W6LB.X=>}z^Go0/w*GzUq*V^V<upOHc+4|>E2>S1qqHLM:8a[f1Eb\Zi{/^,[UBvXixe.>WV\vB3,3/d7Bjo;:{>^3'{>^3'{>^3''CC0'/3vR": a& = a& + 160
    Mid$(A$, a&, 160) = "MCgLKuC-hwKZKBpJC}a{VTTQ}v+Oifi+v5pn(ABhpn(j['d=)Ql0,p=h;bCwxO=FzWOZ*lpo>^->'ba=8Tmbhh7sM4);p?8zRH7hh9j9t<af>8m9K_36f*VR}WfyOsn*Y|7On-AXVcMtx3TNZSBbXL|xY4b;{=jJ": a& = a& + 160
    Mid$(A$, a&, 160) = "RqZ/MBaGyP3.+<b]zp^=\8Ve47w|?|Zn9;E0Ts^/I^h(PEBu)e2x'V_yPsY:cFpIDbSuCE|:EWZLR5T?*9Ohyx*27u4roS86mSHlj8Wy||Lo]CdOt*bgS/kIT_Hv;UO1:{Arw[-30YW3RW(saznKL2R<sOwWS^AE": a& = a& + 160
    Mid$(A$, a&, 160) = "')QT-s?dkCc=/q^tfr1*wXj:2N5m(G^GLJHfAX>wUzUy9)CqeU{0l,3rRu^0.Od6dg4EY5XEQI}uze4ZJYGGfi9N..9+X^z-DEnY^Mb8Ub+lIimyMYW.{0h-*4/ZY^]lpdDHnPy6C4YyfUL^_<=/O*{pY<\\aAO*": a& = a& + 160
    Mid$(A$, a&, 160) = "YHUaHyUQu;_78pG]B8nl6Jr3zh4-V_k0<Ny3JQla-i|V7COZ)=8:eqx3M+PxV3)*0D-dDL4\VNHPZoy_oV7_SW4|/eW_W\Y+P}cc5kd{ldO,yoXve(slO/?^5dVY>2-leF;aA3_.7Uer-o}_|UaV;ema[:^|gS1x": a& = a& + 160
    Mid$(A$, a&, 160) = "HK|m-'[s>Dg/xn;M,]i<;v\y\8I+j(pD\8(h)fN/^chmJm6fG'T*eq|SON44K0lU*E<fJz0?18>-Qdd8ZWH5}^.v;-07D1;hYTG\-kHbkT(TbVX^oPEmi/9va9YlPF.XZmgJ9*R4N.Z=yYZ|G_/(d>-J=79h^Zfi": a& = a& + 160
    Mid$(A$, a&, 160) = "V^tv0G1h[0h,DdOYRNX:y-8q83z?o;4qs,+j2yl.4Vl1dHBqkS9ZMead+<Td[]/}HYViSdQ(d]/e-0UWt:{=o|^Q)yDY?Kq^oO4Q+)X:C_(G3gVbNWWE,W8|,-QYYIag25<Ojy)EPAEu8x[l=[)(]WA8o5?EwQj8": a& = a& + 160
    Mid$(A$, a&, 160) = "o]Wdf42>dflm=|K,sXg2A,F6K}5TwZ)vIvdEC\ei+61X:qor'Xzuo+;p/2'd++THA(F4\:1o->A91My4aU}Fv7P-sU9wDQDufbs-NVxQKK/+fd9fxlWr)k.S=;\.8c,u>^VNX7V?4S[JwF[4'BEHx_zxMHiwFeaA": a& = a& + 160
    Mid$(A$, a&, 160) = "Ae-uE<Rd'^iF8KL{FE7}M>T,J:u-|3S39DP8;G|1DVPvD+Js2N_Z'<6cm*fvS3t6>C2qsEx<9S)T+K0hKw8-,v-:}E01chyed5VqpoF|_R='Joj==9=/rj|Jn95\phLNY=v,a92,f/.4wh?ZUNW/(,'?eZf)2JUi": a& = a& + 160
    Mid$(A$, a&, 160) = "5IR1j;VHvD)\vBQiC1o7?0|2?=QVO<RoBKKB(),>Rd0s80ovNs{n}}5FxAroProT-CRex8Qqll/v)JX0r:zx+a_qd._hH+Fb;k-9KY:EF],y^b(1:<d[JrUAd1yHBithHn)DNSb.0I.}TZAV*D[L+}vpZFd1-?H=": a& = a& + 160
    Mid$(A$, a&, 160) = "nQRbpmtUMbx;97T^r}yi'u|=<lk7}XAI=KD^'Q-[k1aka_IA'^-+,0sAMsX,ec)xWf?;=6qc/9ruEPV?83;aZicw:?ZG?iLl?Ve)5EGJ:+iwqFGoFjR0hVML?-A18|)JQ5PSLF.8VBgzby4NQ'N7K|T/_p?]Q_-b": a& = a& + 160
    Mid$(A$, a&, 160) = "<J6m.g'gd3q_a^v;0xa*r?Qy_]N?gyJ3n4yx4^W]FwG{u4wN:yman>|->6VcqK|)X5,_H8sOw9)^0|'/yjYH>^*hi>S'5eHit^cAv26o}i]sq+Az)k+}Bpkcqh;YN(R[v;sVfX5LH9?u77b\nm2.z>T^)958k;Im": a& = a& + 160
    Mid$(A$, a&, 160) = "E1UH.N+Z/v:L3[hKNqI4K-]S1n:L/ZY<NopL8{7I5s>xY'Ja\nfU9,[q7-wr_<)K7SAm(t<tG]mo=EDA)/}]0sG4qHuIzchob1EkkAk7vH^{q:|\s/;uohW5Ah<4Ic.J*|RstbnW*A,E4z*n77<WFF>4E,tgD5>z": a& = a& + 160
    Mid$(A$, a&, 160) = "\)sVF/QQ?jX/f.ZghQa=V]\k[\QPZiiSQ5WZgez>Y''NSLzJBtgey9q{Rz+9HD-kAT,y\dEB)Fn?-PnN-V+z[5mCdi*c(1BKv(G[)=Y[rQ1?IBV>Z3,DdAF9Ef5S0{1z{c+yS[vxM>vo0I+AP3N7b**>yt4.Z7x6": a& = a& + 160
    Mid$(A$, a&, 160) = "wHL;ih48/fj4tK\w^G38-TcA['C*Xs*5dC^']2ah1z^VKq,xpNF?<aRn9OE02tdpx761.sGx)2eWg?=J(qmf^d6R2Xxr9x_]lMb=Q]W^-AL^v5cN<5lx+AV0[Ss=z1(I5vxcTn:Wgy/2eU;YTG,+01RE+E(f5'S5": a& = a& + 160
    Mid$(A$, a&, 160) = "K'M>F=L[]Rzb>jkuzM4\lUNZwIfx>bTYD]G),'({0HpRPX1k])}WG7(cRhTN<[5CJ*V=<q8AH/XI1+5,{^V,Q9EK,w<)hq./X{L1[K['y{s9lejXX70>a5(}1BD?>39FZvXk*qq4HPr99IbtY50.jodqT;2;,::^": a& = a& + 160
    Mid$(A$, a&, 160) = "wCQC1^-]zjq4On7mTtOr4'viRH:4Z/9IUemz\r>9J/bKqEc^rN2*|W617d:N,RSS1AAxl1qu_Sw9wu]zRnGimred^w^C6+XkK*n0fM24'IY>(;{<yae]ro<*ysTP(<<C)8Ogo_NKW<2BZ'0;R5fiJYHR0|{QApfE": a& = a& + 160
    Mid$(A$, a&, 160) = "{.pc<BS<HlL<g({R.i,ngFKE)OXVu>A*iWccV.;S30Vvp82_q8rc}hF3f(gMfdyIVx3L{KHs6:=D91[f-Gp8Ag<SJ)V\e-F[R_+37nxssSZF-N9+tz?.TPfhbQ;iUeh5Q/;:3ns/aSn{fvskw?S_'e9IH>Xl(B>:": a& = a& + 160
    Mid$(A$, a&, 160) = "gV1k={whrYmAls6<kcr5Tyl+PV8Iy>Bgk?4ty-y>5kn8wAC0>_kXd3kI[8oo0_XB:-ElI]Y?e/j^15mH'6jON*[sBV\T=.(X4]hmvf5gtr8<hHBEyP9]pH/937f.J]e^5w1=YjGordb/JS9ZG3kYomooK2-MeTbQ": a& = a& + 160
    Mid$(A$, a&, 160) = "5wd_e]rew8RxFrIu-T<MedN5we;uW1lIrP8qY^eSE^:u)\:G9+nEt]L6X+R_)\Iy,0QT95pq?:r{S*)KWp8|H,Fg3E|uN5u-^YDgU^]|CaX-7ZTCO?)l6aZJ+0/R|N=m)Tw5utFiea_>1+Kx6z\>yumv1DP(s7Fa": a& = a& + 160
    Mid$(A$, a&, 160) = "\n8,{-.jq^Cs[x:CqdhIB7gsz7R,|l9u:H)Zw3Dc7k.q6g-[jc9xMIMsu}_2mxUGV*.l_B],xAeBq0x2\M=]cUuB[+RP;LAz5MSpe3i.TrnlgZ7G1*Cf03;fXA6L]RTyL-bLE+uN1PptSd,c:ST3\OUtv<Ie1I,V": a& = a& + 160
    Mid$(A$, a&, 160) = "oy]=N7;6.KB;9mgtuMx)F(H*tse5bpDC3[(O^hpj00G=h]PR?G,[/MR46triedSV|N:L5pgQrIkJVXmE}VwYhAdkjG'00?X}*QCp>3MZ,N0/[7Fz}pC[r)jFrXh]n/J7Ud[_w*pSw;Bs-pK(L,2=(pxiHx}RI[;j": a& = a& + 160
    Mid$(A$, a&, 160) = "E8B|EC_Do5dk6^v:rPJk*w8-vQH)b/RylGCyVxXWK(}pyw<hyoFY?5]4O,+Kwe>ipse}.deRKW4:l(';?PXLD)YT759,MA^KaKy;qbr=kyRJW>\B?.mV^t2CkjSNn|^iiBi]R[NKG3_LavD)qV;?piMFYvaueg{}": a& = a& + 160
    Mid$(A$, a&, 160) = "}wlg43r\uvM]_?c.oRH:vbJofnSB?LzY6CqlvYo.*Aa+ljAFI*2vHK;jh^(o}uZ+|=(UW;\Pzqg^=I}WK,3=6Qd2*,]V2p<Hc)bcb\P/},wP30UbP5}D;df6uyXcr2V4lI,\0wYTyn3k3A'lhP3QN[s,b?0;-Ruf": a& = a& + 160
    Mid$(A$, a&, 160) = "p0d_.cf]g?l*HxZ51Wkv0v)y/:h(oNV;l)vlL:c|g]KO]h;H1H?qNNH'pz83Czr)22*^l1qg|r4Y')UjEoM'O_w>jM83AYe3s4R1J)9rFd'<Z]?o]LcOGwXiO_iR]ebJngPYy[lc1=PTd<TV*::K43qo2rbm65\i": a& = a& + 160
    Mid$(A$, a&, 160) = "|gveZz0n0Fb;gQNdkNir4f8XAzNyqlHpv]Kz;Tz-y')<]B^VY8W-3S8Iv4q(R]so:5F8jwZt-*-0/sBAjLPXm+B>zA1YVc?Hv.E<XNu8;+'kl1A0f+F|oS,hm/T<QZ:_{'IDXIZjhRc*2Z3I>TWz{/Cx27fT+T6H": a& = a& + 160
    Mid$(A$, a&, 160) = "tU^Zf'7pl'PGxB,-/LbWD^>Aut'+exhLkmeKd>/H0QQQWX<nq'eGqH3?FG0:+V,,L*q/29Z3l[+kr[;VLJ-o)mq.W7;i[GCQ+K8ay^'{wR2gFB';gZ9<gA^n=p/^qKgS*XK'whfYs7NPThkYAjLKxc1?a0X*GT\3": a& = a& + 160
    Mid$(A$, a&, 160) = "XMrk4b[N\m\/Ixdv/\fP'paJHjD2,WvFV}Q,,;5}MEmK8<LO[v-<:TAC)aY+9UC,mXn\L;25xWRAdcV.KoJS^WL6RxwD3dmReUIoh\\1j]PWy}j]j|UARM6YEe[EWD4A=Gn\tu?Cx]h^X5Ton0ES-JQzY+BrbjT'": a& = a& + 160
    Mid$(A$, a&, 160) = "VmRS(iEUi{h-wGg1Y8YRnDpQ0VTT=kR/cooZU'rfH+9tT9beebWA_+y6fVYtX/r.d,q2Td?g_VmX;s2|Q([du]44S<^eZk--alo_>_:g5im1[Oxq9)^gW;HC|diJ(=*>5{'w3D\|MIrK[)>eRJL6/Fhr;q)_/rG-": a& = a& + 160
    Mid$(A$, a&, 160) = "/b{zwVq/g+^<p-?no4{OWn81JIz*+k<nw)La=H,teN82bA^;Q}{7bx}I_GHw.P}rd'MfFgI+>AR>ZvHF6;vLer2\-ebLrrwJ6gFpZSLsDngt(x0eO]f*r6Fin(Sz9GxZ7Sh>YJ54ftFgH+O.PU6xtcpTBzls9N>F": a& = a& + 160
    Mid$(A$, a&, 160) = "ot6d1;*396B\>RiX5mZN+y,q-YSJ}/s:ni;RN3*<?0m1f--+-dvlCPt\^H5lkq_m]},+Sue,6F}),tb=;W)mOS>6|3,TV}iFZvmN|I5wPovo>-[sLB,Y6EGxrgy2NWnRZro2OUblPEf[9Mjp;86=MK}I|6DnZl<W": a& = a& + 160
    Mid$(A$, a&, 160) = "3aw/N4jfg)u+:PBL235HSt]'><O.+Ww9XjvVbHneVeVaidEe\X'cps_5-Ygq,>Oyw1Q>P+(+ME7<fLUl8n8}OrSl(1n[_;C3do7+?vFRpeTwyzS4vnaGhZ4rW;ol]zJ<gwV7xmWuXTZ-ZszQXauM6*,n5{\[QM?]": a& = a& + 160
    Mid$(A$, a&, 160) = "c.>Qp[At'ye<95sF-x,MsV_t0qAVusuS_XKJK6j1hA9T(NN?4u1[q1nu=(1'4+qC6Lq]XYGHb/M5,jdr5a_r*IR[DVsV0Sg:XMdD0VCr8h0Cnsk3KpDb=8o>S5jnV0W\H.tOWGQA*6EWLaJB[igr5>}0gL,._O{C": a& = a& + 160
    Mid$(A$, a&, 160) = "j>OTgYWCP3VdOV,(UC7xbMO0>xDtE<s]/(Am7xTq36s{(1r.Z57Iv74ZS>.ogQ[)>m,-D|5ywj0\;JXTVtHQReH5.zmoZ/WMWN58/G.s'],ia2k\M?U6Oyo[1F.HzX1hs|i68\wZ3WXbMUTO5<y0=<[L'eq^KX+t": a& = a& + 160
    Mid$(A$, a&, 160) = "ZP^lF^=dHG12}4,TCdP{YR)HiANnf/v\rV=H,:VT]J{Q6ihwBRrnHct7SrKU:3Wf)5vc-N?^ARxo2f4A9mfYxGnnzjkvZ4b'iXF6:L9>^FzM3=bzXSmZ]PTg|BCDab.uM>1GS2IJ)EL6ay]q^-TIW+RiJ5Zum{hd": a& = a& + 160
    Mid$(A$, a&, 160) = "YA{{BB^F*,7vcVoLmXkR5T?qR*g(Qllcw;GiQtY0]UoeV6>-rKRb[MIzy:*Q>FPqvjiCVgV].Ob0eg5iv\[Gq=RyFe6U:W'M<|v<[l;{c?/X'87X8;Z}w(IAyt6'Mn?\wsK:ms7K]Q0p7WRR,-*H*>>-jY((gMBF": a& = a& + 160
    Mid$(A$, a&, 160) = "9YCs10WO,P4i8<[YzNs(i-mugrO]BgV;t6B:2E-FE:N0H.snzZ<I7C\S-y'Zwu33/d]E7-/>5Yqm9|[6',A79T-p(XIfEdwOj,Mdu4diX1*X6*7tGP\Q.Bi0OSl460p8BV8,;6Sc,7-0m3oX7m']SFnttOxU,-k:": a& = a& + 160
    Mid$(A$, a&, 160) = "{wZlTERMs\L68Q<CAX1pXB4P|2]5dWp[zY3V5<TS7YkG68(^N.mxQG?*2X|XEZiikuvG1PI,6:{gVn:^GYLI1Rx0d/H5-7e\FBV,:,TW]yAx2WMChw|Gs^MWCmB4WqlAt<(_F2CU2*2WDi.7[T[9ZonbVZ191/|S": a& = a& + 160
    Mid$(A$, a&, 160) = "=G}]\4E4O,9QlrgkNbNq|)A1}khtdU?551eTs71uX<nVmRh)Iu2]|Q3KGO8fi2XRsg-x:x5ls\4UO>Xn_PZZFy/)|62j0'QNa=g}*jD2P+*Z)-.3\lllG|/VXC}2SPzO?h,.7VzWLH]e}5V^7AY;ck;(M==:Nu+.": a& = a& + 160
    Mid$(A$, a&, 160) = "2YPIo3b>Pmh*3c*>V8sA_E>+?uxvlWGI9{bsCF>[/4|}zxPiUL?F,NQ[.Y>Z61N.BsIxyY8.ay;6eD4tXKIQd-3khXn2ZaN:]nvN7S2WRyD'UWI4d-kK6rTbx]-R)]x<8-:a/'>,tOPZUy{h(XN\.B5WR'H8xs1a": a& = a& + 160
    Mid$(A$, a&, 160) = "zJkdR[^;_0<W-5HE95Ou,*^B<MJgf<6ys*:.'r}E']T_]7(lTEiH=}66QNOwIUK,=Y89]|_T[Hf5]Y6zDp5S-|7(^}PxQ4(8Rl;0a*e-mmizxd_QL(VLqetVX94T{yI/vKpDPmkU<VVN{3jQQ1,rQf)]wS,9Q|D_": a& = a& + 160
    Mid$(A$, a&, 160) = "[gF}_Bp,)keS]}Y{PTj'FGSnZZ.0;QnNR(.=ZLkgKGH+Mg1?mfk*Lg:=SfwT}P|IS3pD=s\sCd9v;_Ycbe{A)+oyM{SF6C\<U^/D\jV4YvpK0'^EU.k3[d=?y'c,Fcd,><MR/9DiVJ'7m+Lz>S]SPDYXjp}eK6n.": a& = a& + 160
    Mid$(A$, a&, 160) = "k8MP+*fLG*y{(_f'\Y,1_:uB;qFV0do?1D}+,6Hz_/*(o_,94+Jb94fS(ny7sw+<is:^pd-B>z/6rBfSQ/*]]EQn=1/VMYW80y20dkNj0?U?qNlP]HrFhdtbSRvVq)GggGZx/-Cb>OA3^_}uoy-CiwoOtvb7RLXg": a& = a& + 160
    Mid$(A$, a&, 160) = "oLbpU}w?M>nQmK,KcY)D[j:\XAvKBadMSorr,36M6rM^qwK|/>9kXA4=GO(G(-sc,(b0LkDVGUc1,>uOmyaA:9?iSvzFhN?Tm^,XdaU2pP6(vHU2>o7<]wQMU'qu>7r?]}Fgf(v\1Cm/8iV0hZ8b<^926>5(lQ?K": a& = a& + 160
    Mid$(A$, a&, 160) = "PPQF-_*B0YaY5po'Mu61yuk_^K9>>um\|}=,BJWw[B0J*Iy*=k,?ATt}i?1:xc1q)<qAge32i:CcFNQLYeGS|SQflqA3=n=]:S4?*X>vDtF}8C4Vg/c0v^YWo7\-19']>da\C6eTwoki0b8,CrcUv;Rmw-kxCM>i": a& = a& + 160
    Mid$(A$, a&, 160) = "m?/D[{dKb)=aeeLccKHay^_P>5EsSfE]KmgJf7rmRljmH8,/.u29\z{7FCo'MiO1S3zQ-0XXG2rriqlm+8)eiZ*CleLh{6F8;i|-Pal,Z3y}_ujf3+A0t}4ri:-ZXgnKdkbD2;E*z|dC7AsI:EcWJY;GLLa61wIX": a& = a& + 160
    Mid$(A$, a&, 160) = "L1[>BhFXeNK6^lq>JdAmkoMu3mW/._vv)phi\6YwN[jX>HUs*7+>Hf;UPq,zga5aBR=aOqgmeXAeL_dLArAI(V?p;J|=Ijb-BeOQEPZr6MYmuFs^J=?^Yh-KowxeG^VyZrO-'hb>vn1f2(Az6X(c;Cu,s^m{:d;X": a& = a& + 160
    Mid$(A$, a&, 160) = "^P]qtrw)T;fa]vkjC8?tK1nu/;N(,=dFy+x:l3EY2/}v}e[c<[pN(yst'ou(I6l1FPK|JNeS^e+u8<W(N(9eXu1I4hcFAB255PgDL5mH1cQnwVm.l('b:ZxBfNtvU-fY,46e5K=?7'Wf')a5zU,=UwNr1vd'UWz8": a& = a& + 160
    Mid$(A$, a&, 160) = "]EBKXRK-G/9?n1SO)jc)/,=Q6zJo}D0BFHM[*x(-RF+xevYP.H:T^|gDosu0Q429F+1b30aq)ucBniyeFIkVea:PaLS2ccgg^_MpF^{\LSiGmxR24BV93xU>0*1X9Jur'gVkFjM8QW2B>;V]J:(JrtXU-V(NfdH-": a& = a& + 160
    Mid$(A$, a&, 160) = "FZ2Z'|Rd3Y21Zm0EK]sh(TOBrcmc.<ghWZyvmAA+(lyo5LcNT:>zey:-ZZ>?Igct[rhBlvL.NNE+rgeUIj<}MxAoMLsAA^'yJbgcrj_c'>MNe5+<-,U3=*Y;L>?U0eI2[Z.27YbT=Zm03S*{WKONAMkGD76+1Vqp": a& = a& + 160
    Mid$(A$, a&, 160) = "ehd21<E7F/zJos?'(:{kH7,gdtL'meh)aL/DVCT{88S*nQ<f+a(ax608MgbUa1]nAG][ws9:'UzBqCfjILbo(|:TM]0blDdv9s=^8V|_h]r=Ve+6b1AP,q,Arh*\ldw?f/CLCIpe({>?E,:3-l2mQ8l;__rypq,k": a& = a& + 160
    Mid$(A$, a&, 160) = "^G(ZiDYaMBT*e(y(dnSY;?uA8y/ylnG-+.N^Wh[Gv'Hdc1S:<eA1k][N5CWI.)aa|h;m+RNV[JOG'B'K-0d4L_wFu=J-2b?1(]04T.X_L.PUdZtL/H;(4DfX67yR?cstXmM)a:HdtFdj2-ySk<DYsL+9.F5x(i*'": a& = a& + 160
    Mid$(A$, a&, 160) = "FTjtJe>}NUg[ZzDfEH./eg6]7{6;/{y.2iTtP6/lk?H;[Q=Iana'w3U>cL4s9t>dx9I/g[8Kd.v=DW5HI9uvF]eKeNBUS9JnhzJU87'CcVpy+;QX2s;aWR:-,Egq^^n(3Zu7-WJHQyqK{a?>=CvUI+qr?Ze^28Jz": a& = a& + 160
    Mid$(A$, a&, 160) = "BF.{8Go}w]R=_m3Zi>vGMr?L/arqGSAD5Wx:Z(<pwSYZvbq^yLLhkMhwrW:P}15D>(u5-TT5anjO-Kq+QiSDH7PyZh_Q(ksVUS)KwwZ9w:N<9OIywah[23C/hKp[VGFC0SJK_^]Qz5F\nmcgK-BV;q.4_JkuYH/R": a& = a& + 160
    Mid$(A$, a&, 160) = "xWa85^j81<i;<7igJzleAe-?nED25*)Sl1ASRHfZ(pWEZ>c4t1:IEuDrMrIr3Pgoiuf^lY/9Kz0mG9ZwT7-rR5<PYqnYy:9gLRthm?xGAs8^gAqE5{jNRwe0g5zDv4NfIpG.K{bN?8yGEbv8_i)L9WG.sI\dlWHb": a& = a& + 160
    Mid$(A$, a&, 160) = "EGlHV=>)+C^nQkq?^b_]sGwcEV.Se-c:b.o,.fC\B[y{G/z+Cd.3O+8yzswL5'ReZ.La)[wHny:}CXNBd.>J4HJ<gU{=CM+21'gHz_hGI5mV=}juo>_mjP<HM<TUSGh_Q+g^Yqt)q^8k91?\}zE*;_GF/bhgw'Y>": a& = a& + 160
    Mid$(A$, a&, 160) = "s3uqj=b'WTU1eYxtd:l{wm3^^7abH*V3o8gJR58E*Me^.ef3+Rjr8h9bf0,.0TC{vLe4BsV/CNn?3-6jFw=YQALJ4-JNNN/}K[,aM\_du}?2ogp5A/{[^oI4WO_xL)R[DKenhs;vvsw}?WfP_}/0OnW:gCIY.d,B": a& = a& + 160
    Mid$(A$, a&, 160) = "(->X65V^k|>>uMcXAs61By+hV=_/,Y(p3xHWk7/az9fQzynPXFgbMbQ)EFsBzk,sZJyE=6;pq?H3EDfPGgM\0m-x8kLtkOO}TUH2)VqY)-[*RvS'3z{Ez_d.k;{C2o.XQm[MG{ULtLnx0D0B04UYX:K_ic6noi'_": a& = a& + 160
    Mid$(A$, a&, 160) = "v:tZU7,>hou)wWNP+E_B*o3OIwt=/:z:>fC,)'4t2_?UhLBCr^pal.m{V\UmTn_E:.Vh4Pk74;3W3>wxK;_XIDPa;1a_hWLY<8Z2yc^vQa(HBF46I<*3fjt7.8O5l0z2};P;q=EjaQd:OXdI{c6avM*7'p[kYg,p": a& = a& + 160
    Mid$(A$, a&, 160) = "8*M0K|(^]wGB]A5.M3N8sKZ_OIcM(<?5r_vrWZyAM5t6D5^mS\swzUOQ-,4n>T[ed,;'bh:9;l5)(voqjJFxedO\pD3i/\NfFL^rPJ;C<^a'HUq81o5.=s9hb42iZ2qS86a*c.5fB<ssM^BD+LH1(Di-)=>X{1ZG": a& = a& + 160
    Mid$(A$, a&, 160) = "+;aJr]MylYT.N7Tn\]e]f[ob=sO\I[Nr1Jj?)3h?7]r?Y^7p}omVrNN8W9L5uzP4?v0J;}I0MY0]YSvzybxr+jxl1VkHm7We1A3HEigD}lq^ldl2ha6LMvo,S2A(2=lBJ5hPp{X3SL4EYGBYp<CxJ2[)m96,)3l^": a& = a& + 160
    Mid$(A$, a&, 160) = "i[tjTvxzo_g1H9''=9rwkL5^ib*/*9nEJ*6{6=r<UEcbu|]t_\X65p0MxhnVKKqQ./pO\aBdw0B{dQQ8kEE(YBvI'C:_VyoT\Lr0f4f/*+h(<d,BNtkXuvs;se-)cjcZ^*hswrv8pUkZc.rxc2o]::l6}T-;Iv-|": a& = a& + 160
    Mid$(A$, a&, 160) = "I_dJ]ltfqQ-SKuDq{(V)ZX.kvQ.|c|YQ4;zxVCUF}sZnN7\d5wni(xh<mglx+N?b0[Z:H'<H^PzG,uk5p(F.]c=Ii/b450X/nG\+ilE3s1-e-FJzi1qU(^8RBeRVY7tT7Q}^4E8}p8}GoJ2w:nvq_h1*'c>y88Kn": a& = a& + 160
    Mid$(A$, a&, 160) = "Xuzlc}VMKTdQ*6I.QU'28<5BR]5uwh*r?L0I,4AOnxW;]E5}scH<]3?rX?ap0C-;d*hm{uTJ3M?}nV'+BWI/py\d9NHn8O3<x(a.[qy^SDWqK5SA6^0RK'7He,(l}EI)O,G1APrXH{B.zMint*+lO(Nz5]M(>9]*": a& = a& + 160
    Mid$(A$, a&, 160) = "27wvqF.BLIlK_',Lx.Z-1Su?F=n-zFHW<({Vbq)E,mP*uDsu{WuaKUiIH=at^9_({Ow^n'r[-yiBPBVxI1'FAr[qTf)>^bme.ZGl{ZX]O)4r/SrgD/JX0;,+xw_sg[AUx+Fj?Fx/S6}2Qu\aiK3F4LFKSMnm1fbc": a& = a& + 160
    Mid$(A$, a&, 160) = "cw8eSkr?[)?)OS]oQjT,f8h.yb]2:YmK:(PK2X'RiV'lnmy.TBJFtxAPkRseITf[*Y*Za6Cp-W/,'/3n/7N2RhrE;WP39dkJVnb(rP(\_ohs8*A1/P7;Q0t:\c3S/[z_iWZ4d,;D'LfQnE*{IOU]X<o?4B_ti|(\": a& = a& + 160
    Mid$(A$, a&, 160) = "3)L?9,z4aFKaQiokCVuAvK*{0l1}7)pHTok,9_6^cjL0B4?UP:>H/>u=7}_jfK1OkJd4ib.(B|=pZa8H>XZ]gaH3*;_hnd[|Ay(E:^CVPSzHx)rdFfe5.tYBn?zZjaRcj)L1eI)cT8-qQVMOMA,.Yx,K\y5<S{8O": a& = a& + 160
    Mid$(A$, a&, 160) = "oW792se8o\BW/JE\NwtQfY}aBPyAR6_,LR;x8r0V.'iJLC3ZXSdMjndTz/3S}f31+KxSN3|KB/{1Ad(LlKbIclQsQgwE/^{_.A{K1kkL^Tb55<jij?^z;{V.xX.p3p4OE12s1r.0*tD7ftzb8s?y}7VP8QUsQ;eM": a& = a& + 160
    Mid$(A$, a&, 160) = "0f5r|jCZ<iucL)+1ZXsMb(CF]?mPIfl5b*(Xomp0m0L1LUWp}dx\3wF-uW)]OQl|I(4)Ebd(24S]+iL/NIFQ|g*Dx3Ke?U]gbuRiD[I)+*lU'yZ5rSB)z4:S8A_nAxw3Bs'hzMlY0;r1Y)\s1,kAj^QYo2l-b9di": a& = a& + 160
    Mid$(A$, a&, 160) = "0/Gu^xCckM8xOeR*JT)Rp1?XatRYL,.Z9^+Biga7''D\TBUnakr=ouKA8ko?vlXmY*1jS{xT\Kx|'nw_+EoYk2_6Lv.z.,((S;D1lM,XORC2yR<PEf2CEq;h+Aq\CAUE-z<+6KWznky^G;?gtH'lihx)_;xyZ_r}": a& = a& + 160
    Mid$(A$, a&, 160) = "kyOudBS2{7GsfkOX9ft4sW*>ge1GMi-k\*\_kx94cT?1cf^;=\GB7o:^C:L{2sK?\X)yk[g-_)<.+(^4Y)DU>W<:dvWQ6tI>m/Rh:X|sNoT0)f-zrqD^KX1bl2h6_o70:rUwlK8w.JnC)49C{I/:2gDbC|,00|ul": a& = a& + 160
    Mid$(A$, a&, 160) = "ciAKvl/-WUz0wWMk'qS3rWc[)[]VH)1yRrG*kUM6TrB223stpdn3/\'pepR?jCWvb07W9-nVH){Ir9z.r0.:Q/1km]m0xjL{1?dmU9:+(XPz3NBk-{}>\TdpES<1qmiU(Y1xTCHM1q::Mc(u^(+]mlbX{h>|Icay": a& = a& + 160
    Mid$(A$, a&, 160) = ")22A\hM+cBcuv\4{N3pB5nX,{N8.VMAbQz{^wQ,wnn2o.l-RtSO2XeoqRaV{dALi)TlVoCd'wMq:ufNyfTp[:Wd[ol.q;.T.tm2beR8pe\kjr?7<.WUN/4J4'Ysqm5p7\}16U4_)H^CX5a^r_:qGnWecdMvwyI\Z": a& = a& + 160
    Mid$(A$, a&, 160) = "(i;vI<VwY_bDcpyQyMFPy.>WbXDh-zN+UYX]c+wQC]Eq'nrT}Gui[08t4z3V2(7S(H67yotwod5P;lAn}G7dt7oR>*dR/BquF;T=150lOQ\R;TfWD9]AHbr5L)]xw+jSECNdXhLz1UEu?-6*foxLxw5*T(Jn1GO6": a& = a& + 160
    Mid$(A$, a&, 160) = "?xk99?KseSoyr]Y6Xm\xTt'oP]F[2:dt^tT}8xFwEf'k:pUh6nht72<dK9-e7stl)UpCn-L*n],a)OXJ/pUs(cr<'QyKNv.c?<kL*R'0_Po6\>Ru''_+?u?vZHfSS\xT:v^K]R=/p[4uSxelT?g>ivJ_ufVFi|l0": a& = a& + 160
    Mid$(A$, a&, 160) = "(Oixh}Cr-VF'-\2O;7-+SW3=23FjCAv=kMTM1,]x}13Y/5yI8D*PVvhmUg-(m.HRupBSVI+F^[zM[FLW+kkVe[oCS5u_]{Hr>84dZXC9h>V+>t30X[iP8lmqiD6}AxQY02w]1Rt?[y;wk4xswlH4nLwt)5MGTLZ>": a& = a& + 160
    Mid$(A$, a&, 160) = "^8/>XV1ZkSrrds2gV?4//ZxUSH'2r{JTK9i[d\;0?OM[tpVD*VJB<[0,>h*,GCz2-V2}['y<]-AMGRemja_'[-hGQI*hEMiMm7V;E4xes;YPWs9V}P5a=(5T.5XBR<qbv_mm1bgfTJR'gh)AVgXC]]]:bUg14ugJ": a& = a& + 160
    Mid$(A$, a&, 160) = "\\fH-+)q}AIgd}gj2Z{q8:>/BMo+2bchU\6v=N.ZQbn,]zDo|=ppRe0[m,wSf.UB)V=<}4M.-^QSPW9g+))iUdOjO6w4T]cOpDjOfVeHf6O9wvc\f{;QA}bA0GjEKQkg^y\\0c4M.<QS>)EawpZ81HHWMb>2(v*F": a& = a& + 160
    Mid$(A$, a&, 160) = "_bBsC;T|/rnJC+n)cb]-7sNfpT=tYX+9PZ(WjOiC+X;lAm27=LuRLYI<cg0L-Fo9I^3jso.G(D4jk.;M6R\I9\[9Wd,lX|A/5v3L=tg{z.Smf:E3xB,|8z)N++XSw7;32^::t(gM>rzgIDVY1}D737ku(4}P>>d;": a& = a& + 160
    Mid$(A$, a&, 160) = "nhV4a^'anW'=ZBcn^FuNRY{Khbam,jLtablP*y3XrYSpVA8y<w]>.-f6,VKL_r.r;(Vl*7^9)bTATg6W3W:'L)ymTR|MqNPA\X3z}(0GZDEFc*{war9[[NVPCaOpQ0fJ?:=m{r8\Akh]cbWwF]*?787=QEuNsT1(": a& = a& + 160
    Mid$(A$, a&, 160) = "<4c=r^Lb01?i{O9|u)xuAL3*/*e'Mm[(zW.MrbhB)\a.GKpovNPiCt709;HZFuolvJ^F8h;'CaD?lS+r8-[7A2OJ87*xq?Q*rt^v-*An/n>(2]CKSV7wwA2'tDwE\)K\2*h:=rar//0[xqqdq?vyB.=Dkj-A;gfl": a& = a& + 160
    Mid$(A$, a&, 160) = "lGTB,BRGNrVt.|i6)o:G=qXF(>l7B._(=sPMWyBXQW;n\z=Fo+LC?}.^Cdx._P}<0Kg9T7lJ[A1P*e]uYe6ll*jRnAAUE4H2n9o0,bZFQ\V79sXiWHOI4jcLRDt7yS4cl>f(e+gP8RQ/oAoF70Yrp>YPE0Z_MQo4": a& = a& + 160
    Mid$(A$, a&, 160) = "L2jHc;(aG3V=;kgzRX+w\J1}/bSGqP6vj7xq';]0iM6entkzX8<07K;|9-lk)stCoBSM6[qU_7nw9D:yU*JFHj-r:A+rfLd=WzwRPabZxR1^=Nj9Oc>pR1^/E2RyRMRW:kA5g?to:7Xfn{3^xsDMS9mX,T\T,AJ4": a& = a& + 160
    Mid$(A$, a&, 160) = "{^xK>f70z0FWpLTMUbs7O.6Y{12Gm32bk)XRGyRFx<FNvgy\]nR);VF1=D?R;uhj6W{0BHLNY1KvcFt+vj;<]gSAPs1Wjsnb/rg{YP.7C9rprLL_ifWbadJDkf+|[Lb8vGlIsI^7eqkH67NJO,a:_+Gd.^OFK,Ax": a& = a& + 160
    Mid$(A$, a&, 160) = "6(HmdYt8)j:SeM])k.Td]+]QR.a<0;+FFX).25A2GW(xTus_nZR0FTo,^f;cad0WW[I-X+OPaMvSKNol)kNrZKRA1VNZAxp:taEyRP/+o]=V}Dn]E[k*rQHzhq4^DY?ue\kwu(NVGbC;'o4=/q1Ow4oq^YXavXf3": a& = a& + 160
    Mid$(A$, a&, 160) = "56/i1'cQDo'?rLR(rqHiLnLApVVGEHRKO^(Wz0pT(2XXhus0oE{O1C/z0g2oTcQ]r*'>a_J5w)gwTXx3pE?HvIhCZ66dP3FMEW9Q;2CI+-okR^'?XBsz.s_BgV6bhQq>7F9GK*/DHCsA.EQGYH7^FhQ.WeZZ^N3*": a& = a& + 160
    Mid$(A$, a&, 160) = "{8gW{5;wM8;G'4k;Cq,Z7Kl?MBYtwVb,=92\=l4(}n8?^2-|cYgr]xpOT[/Og27;6D0Z(AH'7?m6EOsKIskh_YxN6ArXD|pTGsMyo\fEX,jw7>C:}aqGTrro*VAA)0lk5EaVD:'kTb/azo<SPKt\e2TBU-,N'2cg": a& = a& + 160
    Mid$(A$, a&, 160) = "r/*w3/-rD4bP<3c]D[_d1VGdnGopmq7yv+y;8u+kMglT?aw9Z^5dEWi;8?_GbwpJ{zWk4xba^Fo5hbZ:G*.oM?4mBo,SB..T6z+v>'hxT(CClb59g^+SF?405Qj4PiCFE;wDmPt(y)3isRq1U>Y-mpv'ofNLvBWh": a& = a& + 160
    Mid$(A$, a&, 160) = "X(f^fc4[o0(v;a)rZ^Me[DoTX+)}}Yw;'QJ)gseA\Ex4,C_^9'j]vEFDex]Jl/aMaU+x09M<(E/2N0or:>>x]a65vnUS/e;b0Ln;1WqD<M<>noW2>yz?L,<}P({F>j.zX3L,+^?[9XI\nkfe_\BD2Gxa,8.]KKKF": a& = a& + 160
    Mid$(A$, a&, 160) = "oU{X)HV?Ol6-[A\k_vWmM?BojCBhB\CM,aLIA;ae6g(ee5V4<kH_vWmp1G-EQl.s:Dr'wrH[meloBIt,l\g5)k[pL5CR9Ck{rnd7G/+J1^zk<aH1)RpBx.^KMfRkJ4^D\YwfD[ea3U;x'/n6GEwNN:TbeZ6m=Jln": a& = a& + 160
    Mid$(A$, a&, 160) = ";.32*maMv7P4btKhXQb/mq^Vlnq-P1.5YntTzsAzBo0,CqZ6s=B<7xr3Y}0*pNfZZ)dAi:T,,:-Wdeojy()i+x;H;*j+xF}tGXXCfv'n*L'K)KdZl=;*5qE^3a7m|pdOdnUB]oO8j;66'Sg4qAst{EiRSp\Rg5f-": a& = a& + 160
    Mid$(A$, a&, 160) = "H1L5A4eUNCN83|kP5XAhpzsZlbcM4<_S]pc:cw|P:)9Cb.1ZNyvc*r0=;hi8T:MwO[b<N|zjYk?JTmF9(,dO(IsR2s_;n=wK5?j-zb8+p3a7Q\+dV{*eN<+cgtHK9,u(qT8v8>6)cA'mhYpo)}x3Jq^lln]EHYuQ": a& = a& + 160
    Mid$(A$, a&, 160) = "AB5'a5BO|J^ZU6YkQk}]4pu_*nP(8vnWKBLudQIpI<f)-/MwW)UWHH/EyLEviflHtgBoM<SSi4tgf(AM7W6jF7fs:M{zVe606hudF_\oj}bL>YxlR(Vyoj.tN4*n_ojTmq8u)8;]XWDTciR/TAETZYQ>3Ll/-;R(": a& = a& + 160
    Mid$(A$, a&, 160) = "{']rmpfl69LT^/:Vgax9qgD:}F2TR:Y)]G|_._oy:QBqC,rF_(IzV3f[qN0DrI:'4ilD\]4'_xBy4V69rp[2_cLVWnGWiu)6]Z}rU,wT1bM*f,81W)BYvkOy)i|>VT\x6,OTm.t^.N_<>o9hzhj..Jlg?\6p*kiE": a& = a& + 160
    Mid$(A$, a&, 160) = "33K,I=5x?x[ztpxjt\qhnf*Ie+WWvRgT)Zi>,o[,dwxhIatTfZK;iJmIOX,wZTLOu.',yn9^7[:;'}y>LU}F5mBxR|c4Z3pd<XnpR^phv-L(XC4Ry'AqBL/Ew9<:)N4[{vdmWpt(a(S9*HRDv_xiLS7-=Skc'nNY": a& = a& + 160
    Mid$(A$, a&, 160) = "I4'JBP=0_;YH60q2hGXWsi6PChu*9t}NR\?I?6*6MVnm;Nds(Gr'M)4>+FB_J*/t}GhnO71=qGQW+rWnrIYv+D>ui]L'^{me)-T=zH5?.Kfr2Y2VbMP[zZv(Y;Ag6o1XNK+V5lloN>dPa8-I<:gk1}m0_KnlAI{h": a& = a& + 160
    Mid$(A$, a&, 160) = "SstNIZ2,GTjHnyi,ajh+53/_c4f0>=2WnzCeJm(7Bb4.^_M.R)v/d(|\/|8+EjuYh6cI|gRKp_k0/j'\9.obr/Qpyj>62I}(S0{ApI?g.d?\Z:5Mp1AW_MtWm.*ft8OV?\?NdR5]'RMTFqpw}u:d\HvsDp>?3/^M": a& = a& + 160
    Mid$(A$, a&, 160) = "gD_:;6'^6d^js\eV5=jp8atf<vK3+q?UGX.yPIZjlae1\jvXjE?>5icTmrm7V]\tyorC1GpQS<UzUUtg4sM\OcQ26R8Ui(yJIXh]8vcATt)MdM8YCEe7/C]BD/Lw|0xvvNP-aCw\5\=Pu(dmD[4A73CQ[K8hZ48F": a& = a& + 160
    Mid$(A$, a&, 160) = "c5}5c,;p'.n9V-<]OxGUxG:GA1_85U8Qo^wLnEwm/=9uU^L,*,]Y'N7KG:V{cVRfl8x_|WDE8Xf{iE50q>6qpF9rq?PrC9fZ2E>bs0rJljkkaQK0?uY9kH:k\eny:z^9KWnBXI{Y0C|E*zTN)gY4d_5pT)]je*Ok": a& = a& + 160
    Mid$(A$, a&, 160) = "k=-QzAWn1Wl=ubYiolrdGD[\0}nlL=ay,{Lzecde|KwRkWdmP7oxU'L.<8p2}W-dGeDmX+N.ic^ZLx+9*1RAvZf7<,w_Gvs2Atk9RWEBF{_;EH4erdwKl/8]tj2\V|>56;6q>Fd_k1AGK*_B=B-_0VJ>|61lc1OZ": a& = a& + 160
    Mid$(A$, a&, 160) = "heQ+MzI,q3K(,4yhiVH6qu4/HF\^i}sD=4*R64o-ORY,OTc=2YGBHw<E+K9}6j4A>T=7'mzdX+g)1I.I(6npYhhy>|lac?f2S/)KErhBme4mDIH26w=IMMztHcE{7<^4Ye*R86HEYfF\.4lqLR12h5p-h7?26fyW": a& = a& + 160
    Mid$(A$, a&, 160) = "gb6R+c,}s<ICEgg+'Swsp+9FJKy7DZ{nXridReV[qc(MFbzU65HJ;,c_iEI7>i-lc<qlhfQR(oUHKj.Z3+t1dsM'3.(L_(P=A0Lh*,cj7>9h+8.j*.pm7(OS3BB/5M5'<rfm}YQ^gDJpbBgAE]tte7bJ3{3=YL:q": a& = a& + 160
    Mid$(A$, a&, 160) = "v7*q]_Bona|ItvT\'ofJ9p8VtH/uNX^<=l\Jf+-fH>53f3kH9Om;bbYXx/hG9N}FEk7CcvT<rc;'0j]gTtK1OexiH.T7m5Mg'gx=fd9}sQS3D8?ww'AsozZVN0tjO3Ic:fD(:w_d^y95};fNY+06ODUHn{}+=(SA": a& = a& + 160
    Mid$(A$, a&, 160) = "fFzO)9Gv<;fVK74R;+0WRQVTM3z=k^_JjRqYrR39be;bPfHkzCzdm*C*=(k7P)P;jn[2w[B>O_|A\\SqJI^NSVO\wL1t-_JkTX99qv]hAmpi,fRs7X]=iq{h;PcsHbfST/'t8>\0xcz+Vc4{]NY54\H{9wU<8<1f": a& = a& + 160
    Mid$(A$, a&, 160) = "6+N0_r(N:W\gEJSRS2F8si.G{>tpDH\xX5x;1MZf0V=>5p73^0VQXpa?E3Lx+,X,f;YH]Ht(37fG_Mwb=ugeBYzbQ<>[;]DTYIW-Jwy:db(djw?/g\c,?FzSU^og2.;k.[e91M5SmT[^wCaLH*0;^{j)ZHydRBYd": a& = a& + 160
    Mid$(A$, a&, 160) = "gC=,j<5V'*9ob<^Oe\fag0W/Z^('6z31Vio3ijN:-lO='9-=Q-8VMI)<.2KVNVx+EwgUYFaCB6tVDABBA5W+-L7}ZHIb97|-^Z[vI4ABe'_i9K8g39tas*?0oPYsqh={,(Eaa+7Gu<{A)++HHLOm+Y6xm+yzxrjX": a& = a& + 160
    Mid$(A$, a&, 160) = "'wiJ</;nHm2XL)*(N)Ni?Wovn{hfodH=GS,XL+1;S8OusoqbX>Y.9nQhUDqqbF{B:(OXgu)fpmXt'|4UMcXMbvL.,{TY;SNc>P.Dyuc8GI1nu<Ooam5Kn0Cm\<-={Ls/'vJ4w7^,85*kFbQY1;OH1L<>.mo5U}){": a& = a& + 160
    Mid$(A$, a&, 160) = "';=;?p,sP?SXU*N/^oNuaW'Z29]8bz6Pb(}'</gE}oO)NfRbZhkE-q[{hb\7AbEXjX/\g(_t|cD}[UdFNjD+W2F8?m0-6W:4,A'^iu)2][[cI2[[Z>fgHY=<g:|<hb(o1h(d,i6tSu/sdabndz6**5Y)5k-Kf=HK": a& = a& + 160
    Mid$(A$, a&, 160) = "[OIe8GW1pv)qE)yo'|uTsg)lHNXL)}?/tO/eIdjZaCnaliT2Yu;yWygl<G6bMstP>kg;leM,A[+,e^OSYq/3/kCLy';/h?vE3YpDl2ZDkF2'-?0(C+K+jhYpvmWSu'o0.\DVLHa(Q4{^}V.m[j1.y>U4Ift8nq59": a& = a& + 160
    Mid$(A$, a&, 160) = "ceeA9y(SZ{NJCT'<,?5M2o;Wo5*wA*W/qU?N)H:pE<Y)gWX:rqT)p'I6wiAD.gQj;;2aKayJ{29V/Hf*>SgYP-T<8/g,8vEP7vKII6[ch-P/\wD>yLa.XTKTt>VN::1wZNaQm<{\)o4SL<U6IRb-+/{V}KXFvwmf": a& = a& + 160
    Mid$(A$, a&, 160) = "Q:z)2/H9x[|2Q4CKu|7h(pe{GZ6.RAJjd=J?90T8AE:qM3>NxkI1wZNaO6y);I'Hihh+.PT'1.?JiV1LF1Ur9X2wf77Q}/=T*WF^emlJNPw6*bChYJPnpdBrm5-e|gs0M;TEp1++RX?9hBocbY<1fDh?Xj0eTB2b": a& = a& + 160
    Mid$(A$, a&, 160) = "AGXK8Np\(QT=C0_+rUG0NJ18\?_D*}v(Y2WS6hv/wplesNzKb+Ivf;+N/n:LC6kA5AJ*XT0LgOA8-bSe[KD]EL\?yBwm2:]655;3q)Y1;uD\8FL.Xt)An08[6WCBpq\S<(h'(vV8jfgR_+samrh<+PGgLjJ*AauY": a& = a& + 160
    Mid$(A$, a&, 160) = "G0iICbVdYtOQrHBkb}9zHo6LxPN1UcQ+MgFzYX|CdPjMp=ED9jMXddge4?XIU51[|QCH5])afs9oi85=)E;f(,u(w=Cuy1t1T]4CMY4nv6e)>S|Kjb|3,5]}zSuSti*lSZ|'F^.|Y?FSfKJsB]l,M*GCX<q72oti": a& = a& + 160
    Mid$(A$, a&, 160) = "g/]>P7-z(Z8lO[a>/4knH=E0l|P_:[ac7)?w)ULA|;xacx<Xt8vjh\;7wO_RMu)2VV>A>HY=TEM5dyAuF47tg_h(Np2Z./\C)x)wpl360v?xtmF*KPLFY6VmZC>WpYBfaE+:olKc;h=qamVva4;3yEtGAyv?xx_P": a& = a& + 160
    Mid$(A$, a&, 160) = "11I7d*CqvmMc=,*s*_)n/Ea/i{(N3[O0YIFm)h7LJVCUN\mrRrkDiRgI:e}6K0GZFwMBIcAo-1AHr_TF1pK3oF)'aWyuAl][+evu?i>*Nk-;z8w/HtoCpcDaHY8b,'WY-3);_bTefr|TaCjlgASHshT97c0'r[Tx": a& = a& + 160
    Mid$(A$, a&, 160) = "z\-8ay1[c_3/1m612<X:P:+nPV8a*Bnnc4[fUd4)C)?LeF4{nu9LOybUh^<5_9z>CVKpZ|Oi3PHhPS*/Zf/)UyAXE\ei7sXXK^j84m}:g<_u^hk)QDwPU^otG/'<.]f[,u3.5F'_3<1'4gR9.Tbwm\,tu})Pbspl": a& = a& + 160
    Mid$(A$, a&, 160) = "<>3Q]*7}*5xBuOn/-M.DPN-,fhRCB{Cu]2F:6?Hw2dfa_xIjAR>[IIoQC_o)6ptwW^<qIQt<.zvTA?SUn6w:jE+tpRI,33jwA_8vVc}n(.-DvcQ,Jtv<o8.B7Q;-Wa)Zk^*M}t]|QQ:or*uuibIivs<vkf6X9nvU": a& = a& + 160
    Mid$(A$, a&, 160) = ".SGVyEp;bI0(:w+jL3}TqV-MycbQ+YHd,epUe1Q;bv-]j+o-?I(CX9*AtWd8CL,HjWBGn=0neGXL_SD9EXQ_[?5w=c;S;va1dv7LZ?'_-)pBx:ppw**V-kG+yo}|ZFF'C}S+__NQyKS=\>*0+Y+[nkq^{l{59}[7": a& = a& + 160
    Mid$(A$, a&, 160) = "mUz92L]V2QBw6Jx:RMf(niQiQszZ>eRQYy(GVnhyqjn+5f?Nh)pGwZdM0RCYD'mSF.R-8Rw9'K2qnzf>:zeZDcCehh-ju)D>N+}nSX\l|pmL^0IXC>jBA,r7MXwN2p'UP;'1GnkUAR.L;c=43ve=6/s,}+G9L]8F": a& = a& + 160
    Mid$(A$, a&, 160) = "]lm,)9N(/U\dXMsLb_,dqJ=Y^x'qOl\9m(uwiywrKtinhEo'B_vciO<V1F*vP,6KOt84L8k.p.?.nA?2THrkcWjBT)e27[/OA2pY+:PRfuQL<,_Tv,8QkBQvuUg;>aI<.fq^3tl7tjNfFm)71qdadS[_>dbn'9K,": a& = a& + 160
    Mid$(A$, a&, 160) = "2Q\qhsGSv{CL|6YNDp{m}]]TyC_5\*/QX3k.qg)1?+>kxG]*bIz7*7{ABW.]z1B>GHfiIF7Ec:D?BoeRL4,^tE1?lQ-X|1jW;A>q2PYzp<Wvm?usf03l7(.>)_ieVz4icx:)]BRM7kUeqSgYJUiA4mu8ysX]2Ca)": a& = a& + 160
    Mid$(A$, a&, 160) = "tD[k|T[yKye,H(9Dh(.i5iCdJ/b8z97LHs0R2*7*LcFsN-rAFvUBxzUj0)Zsvcp[?V1fO/GVoo9IbzT4;(S_TaM>pc((m>N5:h>S,Ec5K>2\BG]x[=W*27P8*5S}KYZmr^AeRm,q_gDKJ^kI'o7L.eN'.,+\)L5Q": a& = a& + 160
    Mid$(A$, a&, 160) = ">eOYSB_e;^hBO^';5+5W9]j]G}Cp\:cOdicA7KVUN1{qGF9]XgF1Q:*N/BV(RS292[1EOe-f,mOHjEpQVXxGytxZN8PGR*C7a|J=iKjT]')0DI/cV^4J>QOKga[kxrUb4W/(|X24bgEswVW2pg19+c))X7NBb9mg": a& = a& + 160
    Mid$(A$, a&, 160) = "v=ol|9f:nUtMAGK82H=g4/f-'<TxpH2iA},21Dve1l(-w6d?XJ.]g|IYF[e;GiDnb?'IGP84H,T7q0Aob*I.,.atc(70\/}{AgqJR^ta0rAC(+dbY?MB)Z8WO01k'n\7d7*Tyw)X^t'2[5nrc|QO]XS\=Dsg'GzV": a& = a& + 160
    Mid$(A$, a&, 160) = "v];n<|/EgYQHrhvB(=PWY5fZ1rJO')]HXss)]v-UFSHM{KnWw=L\GOL^Ntr/FX}orQVBZqqKy{}FYLPK<Wa>*yWz|F**>mUF:CA2'rdur'\ApD0K1{)K2glv+doaHO,sQmmtTq|V)d>tu;}|s3^jZ{'t_yU61OaO": a& = a& + 160
    Mid$(A$, a&, 160) = "4B+'0Bmur;fYU0,4J0;?:r+OB.s8S22gMWp:2ws_.\g.(*DE<pYSZqOd]2<[W\FZFWYuC5;gc\j)vBtX-.hWPDQmCeVq-(ZSx45u5rn;AmLUO87CggBW8P}82>(SQwB<so1-iJm=;e9MDAx^z]Q;S:B0E=?Ns^qf": a& = a& + 160
    Mid$(A$, a&, 160) = "kS2a'n9c(1j1x_i|coifgZ3'0L<yh_IU08N'7IfBz=i4J.Sfe;-NSa(UARmYuTN,/8kJx<'DY,MqSy/Eg2;3Ju>?BwjbMd4m6IR5>-Ps75\{|{z?s<sh5cF7Rr?]p*u?']Qner)xEI_=d9JMR|lXqmcM8[Z5_Hwm": a& = a& + 160
    Mid$(A$, a&, 160) = "J9.;'k:bkRdj?NNP(VwMw6_uQ;+'WINFRKQii^[[.SeXyha)xwDu]/j?fonoH,H:SwS5Y=G'QjF2>AFRvwT{NOp^FYIsBFnxDa?<jU{'dEOecJ+h-ryySi*\8S)d?MB7hp>Bj4D|:LcH*=bf4_p(V8Ca?O.z<WU/": a& = a& + 160
    Mid$(A$, a&, 160) = "N[Se}>)^\=m>8Y2)^\2]N4UBfGN+Im+AlIa0)?^FY+W(r|k7xlRG7v8?MrT>HdtXS:-jKlX21Z+wOhd91*0rfth(t?eb9:H-uTKv/,edLEp9NO6RReTWc>vzkgr+sMmRJ,'Dr4N/Iw'7H8{5P9yk-ae,_WFT'RWC": a& = a& + 160
    Mid$(A$, a&, 160) = "ahy?_GHsCFjDBpNc1'jr*9mV77dA]l<:X)N}J?F)14em^2U*;T[qwp3Kk.7moyt*xm*pubwK.jVis[LGX<.s]t[|Ev5VnN+EBzL::ewoCDf(M?uG(:WKpqrJAIUr)lN5+eZ,qc|=Ogh46isKUWvbR7ii60NO5pJ1": a& = a& + 160
    Mid$(A$, a&, 160) = "mc'-H3Sh)mtxJeZS(0<h(VC^AEn,70y)]C0'mlp)6_kX3:jqk06aCH:\L^cGgM,|y=H>-=ZU4-6HqWh>^re|B=7-wDZdR]2[40g<+(Td[PJBwW<1x_cyDq/1b-mNgzqOQFADZ:aMR7QvQcvd|C7Ryu9yPpV}4Tv|": a& = a& + 160
    Mid$(A$, a&, 160) = "-NSSrZGgO/ASkNaCNf:H2^L(7+2[;A.D3:X9:<(x--z./2IT9lkL0oi4.8N0-EsN5(3j1w{lCZD/s'<r=,I8\gjt|9,p'?rf;^B?ztrmogdX<.-Sn[TAKC9xH'syrV=dhbhu]s*Kfqb8Q;i2cS/^4rZ,pBv]f_Q-": a& = a& + 160
    Mid$(A$, a&, 160) = "Xqm^ce>tirONr*9Ls]OHRWU*BOre<F7.J6xzSiG7,TmPu,.vA?Uep}1U-D34lVRS4Ea?hvo,6g;i]g8x]y:vz(+/zvGuaUx05|54*lHnXHq)ND;Js73x<UfzK1-rZ5<<_cAC(*p6IMvsc_p;^7fM<'3oh]A(>M.6": a& = a& + 160
    Mid$(A$, a&, 160) = "Wa,WNV,;3dp6Xa(Z,FNu_+EaJyf<EbHoha3N.3;nKaOhj=DRPBn/xaGkT6-*5A,oq7_DA[9(nm,'*_yh?5J8(Y2y\CEnN){lqhXAEz7CnC'Q6\aXv33y-CjPRoa,g>K}aDZ2.Jk]Y4chr=_l({B2(*WEgrAfo.}Q": a& = a& + 160
    Mid$(A$, a&, 160) = "N>O5JFOHI<4rS?:z7blf8q|n645q?/Z9d4HKB5Xa]TJN?E0,)|3'Cc9OA9HjyntU{mZo^=8(O(a*][1nZ0ZN=QyZEb>Azw'(31;_f94j.(R7J/jYOVkXW\w.EFdTW.L-Iki^\)i5'6}s?v9QbE0}XA9Rn:[Cj2pw": a& = a& + 160
    Mid$(A$, a&, 160) = "jt3F9kN+CMwYkuC,I3?^Z+>[tIRMvRke}KYzimy<e<(N/aby/g0Y0I<|2}42h'dj)/w,/zph,^?CI;ia]>QjtzXao3^OYTLI=9OE)J7/B?oC-\4?0K/9l2n*38|1+iB[]k8^h'T1vjaGU*)[7+;[-7()rlS(G)p^": a& = a& + 160
    Mid$(A$, a&, 160) = "{69v_+tafz}\A>\S=3n.KrF\XU9PBmwQdvz\*V/aQ>xqI\c2;vL+n9C_YsXy'cV,Z}Eunco;dm'p7\+2>jM'q|mZv]FwtH0l>V(CwI_6YsJ(-ta7F.FC<KzaDH4eF^-5OL:SXWuyC6F/hbuLpLt5Ox2/\^-b,m5K": a& = a& + 160
    Mid$(A$, a&, 160) = "95amuP:XQi5Ac;/pNlPMjyngf2oao</aNf(*+T*8hB7P_A3F{9mD5(0?c_\tJ][qP,RJ>0qK<f|+^W86QSdazb*f;t,Q]4k9[BD6/hR.dP.iPTJn}Vrj>maGJm)i)tS}7}JKnkCQAH1)l;{lkVY=|2HMM7T1d,:^": a& = a& + 160
    Mid$(A$, a&, 160) = "[ZvT2zJ:,mfl>vQ]SWqFC(<w=),f'Xgq{f4X*N|??u6FyQg9CG4d<V\E?\oRTy5iMQU\YmFhm^SFBLlk;kYq9o>v.KWL?T=*h4JG2crKD?5\QL94-5?a5TruQL}-bMg]?MvPK8=n,GB3l5<N0CK(?Zs(XtYs=C,-": a& = a& + 160
    Mid$(A$, a&, 160) = "j7]z>F-*jj,<qqb<42oq\Eute/FIq)dlgRD\/(DaU17ZHvtb/yWxF4-WZDTuYm2xAOk7;-FO,r^\azBm3inBi00OrruPqN)fO_e1,E1clqNP<50yDhaoJjec|wW,oF/x/'g96D(tu)8Bw70w|+KK/'/]gK0RPH1_": a& = a& + 160
    Mid$(A$, a&, 160) = "Z/{WqSRYZL2uUP.*Sa3AYildPL^xVX<8s{C0mJykIQO\k/hk4S.sSK0ML*27wTkQfm(a2QkzKdJ<ZzU?}f=GRjj1w+8V9h}49FjPJpMB.AIKU69A.\DeXr9'Vp|fYQMJC4C/keQpKpAlBfb4qeoNL-sJ}IlztYL=": a& = a& + 160
    Mid$(A$, a&, 160) = ";-,D*.DZ:pyg?^Phlot<Pgw-n)^Ex;7Q6U(RcRgt>EX3mG\4_|gUcQ>uVWp']iA:K<2-kGq*5hCTR<Y.hkXIRlCv(c6;i33I,nk\uR:4(00}uxn7\oIa][iq>qQ8yEBp-<U4O(6^_vcCp\V{39SIQU.7f-7UkJPO": a& = a& + 160
    Mid$(A$, a&, 160) = "6zsf+>[TTfy-CY\a<]cH^NLBsqx*=(_'65zcxUlagW?VKb8CwPFj2_<?PY(BIdFNq4[>s<{??KOzbmDioP,GBl6VORK<-7D3msdXqV-xK?ZZgLd+?=:6?k,kvx-RmFi>TfU.5N+=E7P^60OkaAKtrxBW+k_O,;T4": a& = a& + 160
    Mid$(A$, a&, 160) = "QIC=/a8z_}B93){<Sj}ylLbm+8TayNhaqS4djSUe<wu+B[QyReXCeby5JRpl7M'O>80o_QR3]Ox'yfN>e:px{Wq:/4E_kssZ.M]/;AG(jC^sxHy1Trv4bwI+9cX9.qpgmWjJKtJ=b3.\H7-i7wkW|7p=uc)-[JB7": a& = a& + 160
    Mid$(A$, a&, 160) = "Am]DK*C(G_E\1RG.x_];lI4-y9xS,H|\,/x<C7gP4wE<{QGND5fx+Lnry;jg3PNsZ7+w2KK0J,8Ay5\U67c55T)*AnLORv+/8y,n+S:VBl^5NZf<pQR>IL}a9igy/_v9t}Pj3AlcwfTprOMyw81J]g=Ag7*VE?[V": a& = a& + 160
    Mid$(A$, a&, 160) = "2eo1EE^,;g;J,uG8-Io:B7em3aRF=hu))5y)U{wDe6B/;7yoot1Z[=[hN]'fk'E-nYi[:yHpE+'CLT[L1<M;FMu+ch1d+>S0arpot:{V90q^f?*+JBZQ:tXeTj<oa/GLxOzN4MZ:<'w-nIsX'/K=c?[+f*cYo]D{": a& = a& + 160
    Mid$(A$, a&, 160) = "grLOAGfbGSGIApES9O8f'TxQhRLKIp|ZS0RuXRz?[qx=lvpnZ6+xlgE8eU'{51AjIqpf*<GJ*UIM0[pGRbnaSbY-JE_7|DIKQ+3}E-E'.VZ]W/[f1*'2]KzD:xHZVz^LW._r|98nH{BCGX1z8'VXfeF)*V[r-3Sx": a& = a& + 160
    Mid$(A$, a&, 160) = "xaNGfIAxO9a?Nx?-EJ:|p9egUCpe;FFW28/0QWhG:k;|0o0>1HL>|='Izs2:0<bk^>u/mi?_y+4CxVCNVax0e=>Uh0hlUo*AuD_}Adt6W13\S3->DGZrM+vPRx5A-j;blagvaY[v58\OrIN,-9ih^ect>)0|'_g<": a& = a& + 160
    Mid$(A$, a&, 160) = "woA'wIK6p=3BJ^a/fYVwx,3KS3Bv|_Nf7VLj-u1GOV\\<}'4ayZdcZq'*(TJ\/rXC2Q.vSUtjpPR9*L{Ie9.Z=*_wF82x{Ei4zrouT}|e058)x>q6q0e(obURA}tIE4rQ=SE}*5mgJ9<-inq)T9Zq1Z.gFxWq-;*": a& = a& + 160
    Mid$(A$, a&, 160) = "tWkY}k[ri.dhe4u1Wokaf7oC^ngKQ.Q]s4a(+?HwvVJA*S)B2c6(\.x}R]ELeouJH'Ri(l-(:7<tAbKicQ3PC4\Z;Z}9=M1Z7\oQ:45BD.0HB1V>Z9[2<sD+N=T[vU3H[TT?mo0[J_c[E+bKfaL2+h0Nhq==iBS,": a& = a& + 160
    Mid$(A$, a&, 160) = "4G6sN4>A(=5gKdroZ<hiK\3X6;.z9|t'Ebmfqzge}QWxPa[z4,iEsG?XV}/|+d}VjJ(,jCUgOpgIY,JbVJL2K6)e?rHlnlJ2mNKi[0_\wqopvNsDG8}M9\)eEHkqCpyt>0P,)>NF<)]b+rzP8l4h983r?jAzbyt'": a& = a& + 160
    Mid$(A$, a&, 160) = "J)s8bin0PDYP|VWKdz'a:N_drD?1]6GG{D<'^ww.dmw[eFpYcyvuzNE^>99x*COSf8>I)j'doW*YS+\t7PjR50*927lALN)ONp_?/hv?ph8[Suu,j;{VUzjKi''*G<==lPb<L^fVNPqI<1Ca3"
    o$ = Space$(19442): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    harpmenu$ = _Inflate$(btemp$, 19431): btemp$ = ""
End Function

Function davsantadat$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(8131): a& = 1
    Mid$(A$, a&, 160) = "4NqjOFpqyQb1CfGVMECw-'aWz;S-G=}=l24A):GXj)f[FEsu>'m</;.cVNAE;2Y7+ei7=Gn:wB)9ZLRaLI9{6,e-61c\K,A0<A4UK''t.kC=MNDyG*9AngM;*7(wCoFq\TFwQJ_tnVbj+{:KTxmCsropY58}'/x5": a& = a& + 160
    Mid$(A$, a&, 160) = "UQ2pZq777.ur;T6T'Xro;'m>)dBvzBt(gZ<i1?<zuQ1SNGa.3'W;[|e4O}i=[hMgmi(;{Q:/e>G*j6WgW'5dQmvaA[jg-8(<T8>0|rMXrJ4^Yn>'}8xgZCe6zL^kSN;^T{PQ3b2[Q3^y+'4wlJ[L)1MzeoNhOrVo": a& = a& + 160
    Mid$(A$, a&, 160) = "Mf38cT(AlM)zIgRz(uS}'VDbMvu|<9n'p\|p-vR7W\17LsG6mG0>ODuC<]J<.9:-}=G,|Pz=RZbe>lNeYQe^p2(_-Oh<r66e-N7hdSwAu-g1;h0*GzCwfl\SC.6_{|;}ZEOm6-i22HPkp;aFZ4Av[14=h?m7'LG<": a& = a& + 160
    Mid$(A$, a&, 160) = "9,Et5D+AU6m=VZXro:9>6fpoHJ]IRuZA>Z_fGyK)=W-,QqnY^]-+gV<>b::O|42:m/3ySaJGtVOu:HTJO5qtj\=fweRKFlo3){XGBy8ut=\=HL}bW/?pXb='t')EZ]vk>'V2]9ixFrYU|E1u4v2mU.g-eu{dv)Wy": a& = a& + 160
    Mid$(A$, a&, 160) = "OQ.gY*4o1zU+s2T^6>rR{c8(M:gADqh4fQvJPQ+*cjl(ihs7u<C\)|4}ozdf<yXkogviB(Z-/x8'Ay21Vl[Qeo:t(KvbphR_OMll;L41Y't((B.uyRNLnvYpvw}b_pnaoxiu4mhFzTEZ)YL5i5-.^{LdR3'KM*1^": a& = a& + 160
    Mid$(A$, a&, 160) = "V96.:jYaJUHDF:/^zf;W{;m?);,?nCE*=)wVeGzA\s8D?IM]1IyVma6{RjF:;=GPHv6yj]w^?hjly_j,))H>FKT)roXY/K0U'abKP6]ap1)'/D/nK.g6.{qsWHv15f{=4(>f:=ur57hH=<VV>97qW^ofl+j|qiM5": a& = a& + 160
    Mid$(A$, a&, 160) = "]+V7U=+OKKl[KY-m',5wtiwYQd;)e;{fAfc3kESn/w/6]iHPui|AC5p(-u{/RmT>aAzgKu=Pw9HwLQdDIr.*;6Gj9F(nrQ)lx4Jso0zrrM;1ozY^DDR]R|VEF:{lr7O12A4qbBo_.*>O8)du1rp[_11MexpupS[]": a& = a& + 160
    Mid$(A$, a&, 160) = "5)cQ\\y'4>70ObjDXq,;etmJzaujnNXxFf5WqiYO}qhTm{,2g<QMFOISuAYTmjJu6ZoeEsS[gcC*F]id/We*9Bg=(+o\{tebAITot3)kAoK'0EQt-,kwppqdVF{/7a-.-}_g]IMEp(Ow=X6hahre>fWZF2hbbAjF": a& = a& + 160
    Mid$(A$, a&, 160) = "JZ_B:0FQH.iCBz|YHL2Nn3xKftO7HZ:B2O_g4{QU8_LDvt>WbKEs*>]ArRby{DR.eNj?SL3pBuq5cGYsCKOLI.^G)IpaMTfP_P;6RcY/.P[Wtq|/_G7l(k79c+?lr-wM9CWuV(msbnd0w=7'5Y7DN}jjuDDI-w{t": a& = a& + 160
    Mid$(A$, a&, 160) = "e+habZ55:Z-c+N=E<I6TNO<.fm0)N4X9emTxlCD|gSU:Lhn)R0)S)gQ=UrBYEmE:/5zJaC=Tv=8siq[i7^{s8\fMX,iD/|0tw\a[^,,bd'bZ39U'bd9HJS.ruc;ImR1[O2fKm2l4p+[bLMBxhpD|+\|ci84ct3}A": a& = a& + 160
    Mid$(A$, a&, 160) = "W'qedsu)xqfV;=X_[_e:|eDl8641SoTaN5<u/b|7M-=]BpSM_nHzuR:S6wOU86^YwI<KJ'0xPDLo/YT3fxMw?>ctSX=nXtaLfvzP+4V}VV:TA{fyjjPA-G'-BPl*69zDG;K>Fz8i>BRue2vMxDa5S-RI|b4r1,<5": a& = a& + 160
    Mid$(A$, a&, 160) = "QNSSa(iR87B-UMY}<F:6kCpgwk./Ge+Q<?Qgd_Hqwezd3}FJVPRACBgjMhO^)A{c>Pf{3f[ieuhuU\N[XK.=DmKOD6-^='{-Wi-ys,mgR6VdZ{w+q2[v<TxH2]i^fXL{NxP1LKP6yzvj3-|e|Smb9\|{>2{I\KBV": a& = a& + 160
    Mid$(A$, a&, 160) = "_BFi|<LWPy;KRaW^LNM'HulUhZfRP^_qLj:DxzTIi)6IfQcASC}f+w1_XIq'q-jyK}m^LD1u|CuikB{B^3S7oQf9eWnf0+*YP1[fBzDK4dK|jh2HK.f7,))S2],k;(b_cRaE0PKT6g(iv7R+\2u,\piQZCXrevhV": a& = a& + 160
    Mid$(A$, a&, 160) = "o?s=9XpM:PxIt^ISM\.Z,^uS2_?Q[*8UAh,BnnD1+Y\hBfeM(PYm6(l9E4rJxnjc]hf'<3[_>k\6C{+0mLr[,CqqyyLJoZqfSG|5O\DuB*tGWy{x4b*KSy+ppV;oW+>HdGUD+sGT0mTr1QoWKe-]xK>uz5,WlhsU": a& = a& + 160
    Mid$(A$, a&, 160) = "K5tzYxW-G3?M]a<lERS?Dwr;|YxM;z^kQ:0;<I3S\a?vQS'irkJN{H'Yz_.o,,F;vMI>iP>2mJT3AjhV^stbQS\'ocfT7Bw..*3jmfLZuTvu+o+:5^s^1A_\dJ8jPg4zo'M_Ig<stdwXsKGDdVcynC4.-BU87L0q": a& = a& + 160
    Mid$(A$, a&, 160) = "_aWMHuW3_:KU/4K]+Lp^nfB1C)K5-QdPNrL3Rdnf*=F5YFhK[+mFqW\0?.c\VG9]kP=:Wvg6;*L_POmz++bPLK=I\R]px'7p18yC]LJf|^BQZ?-3lOqbB]/PTv(haj3CIb9dY3B,6JYmZ>RE,Zy]*;7c5a]'t18s": a& = a& + 160
    Mid$(A$, a&, 160) = "y,kdsp.2yaW3KVG|LWkxkAQb<:^zZ<L1DQ.=/}U[OaGzH1Ksz/.U0U(h6/JS}z(8Xi(95C4G7a]uCMX_BhzBaO(;Qs|MK\s<W+?ADL3>y3L60,hf[9snuHoA<w+9Zu/hKZG<Nl|{nr\_51aIOL?s4gWf6'tRwp]I": a& = a& + 160
    Mid$(A$, a&, 160) = "*f.B+CC|>n:h+1'Ah8hiV>-x)dgq4ydKMCP0N7Nob=9w8D(cpn3FM7MomTmVd0)O6DR(s.Y408{MCh^;ka2|D'yE4SfrU?3Su<6x<>0GvdY1h(uV6-5_qpIg9T,BbbD7i>MVWvtqen_n_]c\'Cq^9m^FVm|J[]4{": a& = a& + 160
    Mid$(A$, a&, 160) = "}rCD9PnwIY[,,Tj^\[;UcHIjX4z.=YXV7_]VVrWlsftptF0A|hL=D<+uJIIq42A?4n7=LM+=C|1Eo9_'>QWpmLJ}5N|D-zO}Amxa+qQ[-wZsL]{qd6.d+}3lB3Lip,BzQI-Tj(\yE)6FLW?5HqMUt5Qg)l?\vL4w": a& = a& + 160
    Mid$(A$, a&, 160) = ".=rYy]ys+*?zh4OvTm^G3-]AR4w<]rTVE<U'I-I8NkAa<C*,;gS'UQuJGHu2/>^vDs9WzPzHY5_NCjtFkDe=Z+-319}Lq'EGr)?HJe'QXTK(/Xq=8q^=.s0D;WW{?PoKar.kj;40RFx6bN/h22JA3|=^rc[8PbBE": a& = a& + 160
    Mid$(A$, a&, 160) = ";(\iFl>OI-k6G)u;_)l-BMbmA,u=lq5SIt3wwHhAG4b)c5,T}cB3<{it8j4b)J+OvZh|;K/i_jM7G;^14HdveNSmesRzZRo5.bW;3Bkw^/FHp]aX{xQI'';URDCI:Co+v6kSGrXIRg10ndTfE-T>2<R9.K,.dg0J": a& = a& + 160
    Mid$(A$, a&, 160) = "PD<9tdlfy;T(FURw,XyKi3z9Za/<K-\MIiT6.5OWqW*Rz[8H.DHZ'CMW785vEP[Gb)407|->XM3EZJ<lhovpIKxcpDAuwG}k]<Y|L_-y7BwZ9bZz[:l5E4|hH(qB-xxE1w_QV{/Bb4eN2t=/XaBfr4HPl0FQG7jX": a& = a& + 160
    Mid$(A$, a&, 160) = "zHpFzEo'*kqEi^^5SFf85dQy)tXIZzmVE3RBFB:Pj1ZNjR)qkzDXW^8{Ic2CZ1]Gqxqz:-<xMru:8UPu=d7G^4FnOKz\,Yt5V8aP)n+YL_MzdF'1BDChTVW?<nHxp}7OZtPE(+M6OcV]K^8^ijGB+te4')1)vfc0": a& = a& + 160
    Mid$(A$, a&, 160) = ".l8X]RqF3PjlAc.fWs(hY5?ohx.?gdv=KtzE;Trbn*[/->vf+h2dW6gj25V{sUWwYTyxUTv/E=1(G]k6\0MJ<s8QK2N,JxREW*+'3bk*?TGAlLozhJ**=w4JtCHNG6e9?/6.-ek+Siqu.vARmw-1g}J/_c<,S)\s": a& = a& + 160
    Mid$(A$, a&, 160) = "=?*F^-b^JN/y;{76BU{v[8g<O}^*b0R]}^rd=hiAz=e_<aDf>9zmKu6;Z{RIkByhFWH0T,6-ffZY/+ruM2}c7K>+Ntnub\:'ztU+BY_;C\B(v:]58iFg_EROZOs_;qxLv1ZZq</J7_r7-zVx13*Ja2.RH:h9ZOW=": a& = a& + 160
    Mid$(A$, a&, 160) = "Db_2BH/;i;L74>ssIrEZ-*b:lA46yg]495F:tYRt0a^ULZTxToELR[RC:TF+9bj)j5*7WTX?9.Mfl>3(acqjh[TOadZ<oi-D<nm/q[>5d^qv6\P/nH6KnmZP-CYO<g?q+8]j7|8:J3;CFt7-[yr(V2e>QKp>-npP": a& = a& + 160
    Mid$(A$, a&, 160) = "[H;8{yg>1-UH+3awYoi^TTAaH8m/d'CDg]p=UE]'*S2mYE,qc^4B=F06HF{5lUIcqj:6N+;oSQQA[4SudlwFXe;yKTQ=}\+In_-,v72Qi8O+:T|_+_o.Vrggnf)-a[3XTt:_gv/KWYXkhkTfoAiAaW+6xF*99=Li": a& = a& + 160
    Mid$(A$, a&, 160) = "Ga:O<09CWY|^l323WE;n08xEHia>8RIo2{gj</x|8,Dnc0r?5;_=I5AfviU4/cGqwkyzRgY4?82x/uZj;a9sED2.-1;WsqxH.HxmEf};;McHUZ)cbx5hWtwLJ/gQWxZ2XApTYl.Kw)mT3oA'RO5uj,6jSulZ,{57": a& = a& + 160
    Mid$(A$, a&, 160) = "47TtmxGYmQqjvw<\r-Z-V.D4GJ2?te''F:rU7l\Zl/CiIWu/.p(eaWYET|grjpH9og0yx2;Z{2)aU2Yo[s.X_UCub^;.TfFIjV/t8Ut2lb9Ry{zr{xljfY[htix{UJ;Cd<IUCOaTptiQ_Q0qI=_hwVW3vfwDx2U)": a& = a& + 160
    Mid$(A$, a&, 160) = "o)uWdY/1C5Qj/N<>\oQIfQ]vkR,[S9*tih]{X.j3Jc2IO5:V{57<mwoeNA3GQUitgKu?xsj(GSZ3L[k.j=/Nj/_)=}5lE,bX1z,D2zevAXH]tEk<R\.a][-SQ3rjbMgZno2qJa5tu^*'I4k}u{H,<cKmFm?O3Vdi": a& = a& + 160
    Mid$(A$, a&, 160) = "\hKr5{=3<E:D\P;^2)QnSL\[CD:.I8;'w+yqk}.q[XCj,?rbE18;l,BSb*snOG2Nmu)0FrL-qhrK6.akZOZ{_bn5qvR?|}PDo[b)\F:TF(CRYbwmEZD_=q\J<JpLvEV,aCoNph.a:+{{sc;{cu)can}R*)+tPZUQ": a& = a& + 160
    Mid$(A$, a&, 160) = "|4gZV>)<PysKGoMJTVYftLZvxKcV}JnS^KwfAfU0M08d[fj[k>w?U3rZ?5iMm[xd^Y42z*Gn9g=oAiG2SZB:\ph(MJ8O664T/Hn3KHGO'p1T2mh6\nkCWDFhK4/.pbd^S(bz3kw'HCaE]ER0IINIL(<KD;wG0]h;": a& = a& + 160
    Mid$(A$, a&, 160) = "m2\nAZj-l:lhW8.Aix*,g[2xxtbpV;UeGl'[f2GKe1tu{YA>QBolspp,-*aThv[.CnTD;*3D-FTdCpUh[zz0D_^Ik*LoB)Buu:R={WdFmJT2kHx1qh4aDgP:4BM0arc(Z4VZ//3Im6BTeNG'L*Dc;iDaseLa08,v": a& = a& + 160
    Mid$(A$, a&, 160) = "xJ93C*Ezb}c+jI)q*-yP6]Jz_aJjl_3s0P7b45pve.2IqBy/(J<Vh(Weq>+Rw,djTy;aedco|\78CchROE\2a*Ym=h<Pi{/2tZcxFWmgZ:*AggU6<3?A;'pzB8GFO75T\B6ahZ<H5CL?+DoR+pFDPmDZCj77:4iN": a& = a& + 160
    Mid$(A$, a&, 160) = "\8Z_c2WbIh(cGicMf{W[aG+|ZM4PL7R0)|\{aK}VXixA^u\)gS^m7R]P)z+mOkq4:pqYSo*4A|fj,a\n'kZihw)D^nbI+d^68l,sWi^s8ha2Nk<GN|smSL36)hq5=xCK|6.yAw2\hC;P[vuETwjiPiO3Umk6K|mv": a& = a& + 160
    Mid$(A$, a&, 160) = "RtUinNX^y<yt/.gWSNPfyFSfXe{-1h\:QMPfZr.J*hEqOx_ybPRD^e*h^8[=qwuflquS=C|?B|Gx?4OxG*2)eBHU|c?j3)ai8LBi^t/L[\iVeW2P2z8WsokUc^eAyI3ZwpUi:'^GysJvI8R*]o\s5E(^rdGI[nlT": a& = a& + 160
    Mid$(A$, a&, 160) = "2*q9iQOar}Q.Pl66,)Yggf6NZ(P}mMCMLMOANk,'Pk}johQS7;rY=mzf>EI7S>|.RMTWoOKn9dZ{\M,Hp{)ig7:=l0sMFshRM46f)(,0D4mL]i|=[mfjM{ebJIR9W8Ye[fHopRu2)SaINnyvk14)I]9h2pgwvjI[": a& = a& + 160
    Mid$(A$, a&, 160) = "sf;(^lvzhzh.0Vo0={jkI<Ch;Vbq;QVi8z;;-J+J>u?rRTH{sEe9Y?qI0N\\+nKk<1XFh1z5lr3JN'jLPVp7lIYmR7C0Yv]c<amK87R]m==wHdkw(6ils4F?(UtTobXnW<piwB35tUBiu).|Zq8E}0c4Y1qcyl/U": a& = a& + 160
    Mid$(A$, a&, 160) = "RRs8^-rf|orf'^uDpriBsFlv|aI7?Y:A4D^nYPt=T^G)Byj*qM*6^?}b8N'ss_\8dLYwJiXo'Er]dFgBKjC]y?4mpZATt6H|xI>AN3;]niAS[;91,OY;j'Vd]XS|KwlZVDbllDKCyf19F)W'o\r5kINFG[\<CXI]": a& = a& + 160
    Mid$(A$, a&, 160) = ".hZ;WwS.DgtJX<m8S*F0X-n+YmNRoN?j\F=lwDTYfC3EUCuCwdpcluCq^)fjz6HRyucA-DHfknNEjzYttg8C2ehrl2X(42t[AgIEF[;{EBd3]<dM,Fv]B1D,W1yFi2Kqd_czEUh)x[DOjxGmGF7J8y;<Lpx)IrFM": a& = a& + 160
    Mid$(A$, a&, 160) = "1BdBaN'TBh/3I_b50UDo<srEqJX>?:<:Cqay3u,1I5VT{nTzVDNCOw_N4A.q6>.H3.Y,_ZeI-z;yaf=biMC3w0r'Xp][Q6bmM|lTOXv++_6:BZwiu}/mFf1qV),mT1>.K.BEq:|qi.N=ivltsPJ(znd2WjvJnKYG": a& = a& + 160
    Mid$(A$, a&, 160) = "}]j0/T=8P=E--kPE{.g?sW3JKWu-<SDHun++Nqen^wQ.WIoT-JR1|.kUF8sM{srq'gR}|8TId,OH*clpApP>pyZL_vNfI;3:x<k_cQBo}b3tes0QO+[_eIvE7]zkaUgpQLHoAwmQek;-)=leh/c7Qq^e)wVTdCmj": a& = a& + 160
    Mid$(A$, a&, 160) = "^hI\QyV/NPmQn+C<vvcBU;<6?Q\p305G?wEj6P2|c?]e7N6g)UT*iuwE2jwMfQzCqw^VdGCBsAxe3tr9D8=WVqZ'({Mie,>1M*'-i[U5{twY'Ey0>FOPMKKj6-J(3)j8z|L0XUs(?jN+c+l48(GrtuT-E=+etm;+": a& = a& + 160
    Mid$(A$, a&, 160) = "2j-H0YFAU<{S4|sgW5-rLI43,25a-saMi2O/*Ip.B26P?RqL.aSpA'tVkk+)7Op*uG/vSuqLuz?b<<SP5>7tC;r9A_T\t0v+JN*S1EH,8e6pK*_z2ShOrZo5T_vBpt<qnLX=^i.//wKf+dG1fs5{yEO,h,Kd\>>t": a& = a& + 160
    Mid$(A$, a&, 160) = "7ZqK*+iHyH}?,Fa3OyQkkb7']CazK^hpbI1zjM[AToO[s:7r8)MjC+0/9OD/ahiAh|wG,hr/LMh\G)2|Y?lxzzP-tQniR0(::v:qcmp0k,VGMW:ALh7VPjvdnM'3qbwnF*{7ST<':h14tQ?O=PVs^m*jVTQHEW](": a& = a& + 160
    Mid$(A$, a&, 160) = "+3JHB}fZFzd19.-5W/<YqOFT:xjh.G=v7B+9PkjW8t-I'+P>z9'^Yn-/)4S]JwfhoTVHc}FZq\4n^ut3Qa57AB+bCHt8//RQu0=PN3a/\pp<s0aacJ.0LOR({3H0aR2ephn>HK?P\a0w6rlIW;p{1';+,F[B[93R": a& = a& + 160
    Mid$(A$, a&, 160) = ",Qye5g-|ZrBlnm3c/Kb-{=}FczF83R=xLvvkJJUySfcG.-K'WhR5<1VTI\=a^B2YPi>KoFjLK-rPB4=l.+\/x{l|7u*3v3C05>,Mpz+a2,cS.|f5|46VMkbA7aSGetnvIFy?(ArNHOuG'Mm;Niyfohms,[Xt)\qy": a& = a& + 160
    Mid$(A$, a&, 160) = "G-h}O,x+FRyaMn20B\S^cDHA+|;swq>gghzdLTASAO>*x'7=pZj[sKA\LxIiQ_('{_QaPfV\}<j0wbxx:7':4K/{/av8:'UhpD(DotJClHFSCYXD*L2c?}t0Sl^m[|P4xt1Zj4?+[]1-;N';O4Zwa+pY]zvLF[R\": a& = a& + 160
    Mid$(A$, a&, 160) = "rbQ2ei?uN'6QdvdUM8W>ooZ2p<J)i1PHMoPNEiu8?0dxNr/iun{\Yd09ih:*lK76q1j)T4+:W()v.?Y\G57GYI(fF=6Bhoe>YPQoz:UCy8:e'A|rYERlLyn)7V8;Qec8NfXCxx6QInf_Rhp'H0LA<kpP^7^^Ig6W": a& = a& + 160
    Mid$(A$, a&, 160) = "'xZA6fEwkYW,xp{}(P'F1fuX^)hH\]ie0r<xV_Dxo0k+or=uqC[=SNw7g,)Cc.YP|n7:yBQYc;i37tD/AuWd3Wp4cx+T=h/cw]S<:SpI2u{32|LhSf:L4KU[-s.q<]Tso]1L[Z=I_(*Lavo=}fbQE>]iJ+eUb_fE": a& = a& + 160
    Mid$(A$, a&, 160) = "(n>IQyT//=6A+zu}Bow;[;>tQazx2\,[{SakZkd;uvi>UX,)pkWZ^K]ru*+3fXX5Xcc:q5BYbcFJ[ZM,4_gYr0rmGj]Vef(1^X>WaY+b*{Y_nQ8=f{:{{;O/\[R*ts1CN"
    o$ = Space$(6501): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    davsantadat$ = _Inflate$(btemp$, 6775): btemp$ = ""
End Function

Function davdat$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(7316): a& = 1
    Mid$(A$, a&, 160) = "2Y21?^pGr>_Vd}5\06J=1snyU}\ZU'6)qTN',C05VVNrTUW>eiV3v-8'>=Mr5MJE^,1JWWzuz3,heJACzsMP+}M6C9+o}ON_^99[rUBDss-Xq2W+}g8ArC5VYlz;-ZBhk:5(c-p8=}I7JrSZyuuQu.KL_]xH_NV-": a& = a& + 160
    Mid$(A$, a&, 160) = "IZyCr.LC6atY-P]BL<:QekrTW\]d2/8M)'u^jm,zK]fM5h/**X=1?E;^8,ZIVQDxtg]}[GQ:'_mX2Yu(G')El9Az'<)97FSc=ev'Q)3RRehPZ=1TTNg41G+0,(x](51Mtj_Xtw9d*sUU(;jSMRAhD|IC^qs1f{|l": a& = a& + 160
    Mid$(A$, a&, 160) = "Z2UUZS2uSS[1j?^N)Xwt0ic*4;>4Pu3*s2<6ic<,V)Z1dl3:.aNg4(WL-M;K51C}MPdOrvaRb[IO,VS,f*w*,;QL+K+5]vOYgPdS^)((x-1To\2=Ec]^T+6lqX-*lAT9e2bGk;396s9(SEctGC*An/Wt+;I5nNEe": a& = a& + 160
    Mid$(A$, a&, 160) = "+8GU?ET9n-kT9<=;MqBFH7-bhRogfBaAsW]MhcKrl)qk]HG'fvXg'Fuw+jT-OQATmL0OB^ADj:-jauk7-<51/NQ>*9U1G,(I1l7+bgM1aHQQ,pV;h(WvX\pe:7tB=DT+T(1T+^:J0c9_?F<u.Km2NTAUnm['ds4G": a& = a& + 160
    Mid$(A$, a&, 160) = "tlKuUMrrL8BLgM/yI9x/dF[J24P|2;qXn4r=*qkW35C2o;'oaH762-?/{3.Xd6L:W=ldWtbQyI+jkJ{5Qim.Fsu_VshZb3Jow5i[;V'gJym-.|]ke|6uf=ZA}=XFD_1O3zc0EXTY7A2t[Sgi}gRH|9MrQ_UDl=c6": a& = a& + 160
    Mid$(A$, a&, 160) = "7:U[:AK}8?8_7)ZkZr+a6K;lLpQ7S,gg)b;E)XD\=Y=GErv++Q00HuzwmQsQShTVPMlz,1K'Oco,0bI<cc[p;0(q--6:wE::3_wkMbExQ{Q'._+W-ot|VNIvxu{>f>:-k[e9_s6ScnohTuRpUOE3EwawF3c].LBa": a& = a& + 160
    Mid$(A$, a&, 160) = "^q)L^1.BEFYJ,8Z4n}cp-eD8jiy5yl^,Esmv)|Ayh5(CJqo6caCM5qz4vi8J4z=d0Tn('z4f7X*q1}P*8[3jTnCiG}2,ktgKhj\[]e_t<?^A1w/xa6*Gg/[/0=C5Dp)W:OzutX^M0[H-Uk]r>PP5MUD(XK})P{97": a& = a& + 160
    Mid$(A$, a&, 160) = "pC.u8kgE{vS[Ik<n8Sl4aAvMUwFm:7I6LQm[Zqb,9mL:(/OfdQ\BgE*:Fld\55HIIxQ[t<TL6X(Zr9XbA;ia*T3MoouOOoxA.{NDue1B0BnsJ1{e+<qhyyAWj__B?qi}.B}=a>D]_7]gPZr5[+oLm+q2D89GB.Am": a& = a& + 160
    Mid$(A$, a&, 160) = "C;LJjO?g9Iq=xHaygDZi70.taBPjWzI_>qF7AUqnf?-c?++ryr^<PCz</tcO8zLOQXmVnksisOY<n(:*8RU*Xz:i'+0/uX+1rYrC}b:LW\85Nbty'zVHCdOK*zZtqfzK8-[U47w0kn,5s_\qSs.PHw'<+Q,lRE}[": a& = a& + 160
    Mid$(A$, a&, 160) = "g<cwF]0m3wO.a+(LKxNKkxgf/1C7{bRE5[EQN*2=h{(xiM3'Q^S;?Dk)K9^dhVn.-Ww>n4*-iU=VTc=>-(lT\SzZ-j6<pP]Es.C\=Q)<(?IaN'NXZ1}B<-]^mOR)xF-O0.T,4RG.^XJ/9vaRBAjtg-vm0:xJc|P8": a& = a& + 160
    Mid$(A$, a&, 160) = "[4[lTI_GSKyoB761nUvTo*xgcRJ*+jVtz+say_057-No0;i.3A[2E9:6hG7ct+ioYI9bh:T7<'-7[iGV)Hgh{1Szm\y'}1>sS60v-fx8+{yi^gb1GNhj_A.C5xlxbufvNsYN^]J4qmY7X'11V2zxt'leB^y0;2y:": a& = a& + 160
    Mid$(A$, a&, 160) = "EOTX;Rj(Te/BV2*e5NQO(txbh0*1*pqaW,}QWm.EDGgTS^a5lq3'b^<.>8H|lM{TeHq{4^v_0pJ4v/g/kY,BD30GkWlB5?UTiNys\LL_vt_BWb>hxo9bLXHy8/\t.7dG0'nYuXr-F5K\3Vz>jUWlO?BH|*.bh|)y": a& = a& + 160
    Mid$(A$, a&, 160) = "N3ZCQEkwQUYkAhZ)nI]VE9=+yLIFt4C.|Bregz{}wBGFiNf4s<;bb.cawO:Y13spDbzrVCiAK>5JE]|*iX8|vINI]<Q1m'JP2-G]4C}{0=3y5(5R3jA?*eeAJ(u4;iT*],0D+'TQ+]tQecD^5dJB2}[*)*{c_5vT": a& = a& + 160
    Mid$(A$, a&, 160) = "=jGbFl/BQBU;3nhSo9Zrm_v(CCiS0:Oj6h^5({O}xx3:xN[H8F0ewDu\h}Hmd'(v5I5/gT]8f5<lKg1/sW}F7_/uP2By-P3(kV0)d6TLJ-?1NuTZ[<_=D;/^]ZC6'NF?FB6,xP=ORI?/fepq;owBYzuD{(yq0|yt": a& = a& + 160
    Mid$(A$, a&, 160) = "?_(Y8-uzpl,NBZsB(.8MfzZ?9II5:)T=;:N[Kjo3td(wmWN+v1nHc)07E{czx,=qM1r-5:H>X(\XyOJ_\;U8uK<3Moc,}?2_06l>sN'L]F*K}/3JnjThIY0<H;9dRPnxu._5[Ia'A{vORZ=hsqJMbN4r)l]sB,p4": a& = a& + 160
    Mid$(A$, a&, 160) = "QXOx=YWIZhuOeDeP8(7y|^.Du*pr^iA?*)?Ivi6UboVv]1e<:';TYp+vQ.(:]/zmMihVB*\=47kS>t.c/;V'P,m;<0Qsg,aE9W1^.R/3bvOgR[ar'keZpVU2e7ejiTZoJ(C>dYAVV_j4)GF1yO0aJ1fMQuuCX[p/": a& = a& + 160
    Mid$(A$, a&, 160) = "|Osvcyas8ld,o1\y,qa1.DX>a7Om3YP;P>FlBzd.f^7oNJe,8rgVsh0/t[*4zr6<BiIDyR:hAWde[-Jj[nEEZnj1=L{+\sC'=CO*j_pF8(uC_f1llC{8MLpu*phOmA6VQ}:t-7MFt6CwXh}TwVJJe.{5IIAQN>'g": a& = a& + 160
    Mid$(A$, a&, 160) = "d>sU<R?FwuF*BT29i6Zyc;GD|K/J^z(sO|-tz3:]VrAR3bfdgi.VG;T<LDtr\;LHPDaH)TY7+d\a5'^>q5FQv,LpTHjQElv[MS>Lqe/vZ=Hl/)/eIv66e['^YAfKT,9,x'EY3[6r-:/_TFLfafy:FvUr=>5udNLW": a& = a& + 160
    Mid$(A$, a&, 160) = "T,Fx'=vwoSC)n5K]bu,eNCvYdCW783OH_[9/AF,2EPMm4[UgPu<YQF/;vJYW81{O03=..GasV?Z0y-N1cRQJ|wucRq9MIv(k>5rL{fK(+CQn?}R/AMXmN=+N\hc7,97JPfMSP*f|lOQv<Dw60P0lz(BFSNJ>ReP2": a& = a& + 160
    Mid$(A$, a&, 160) = "KBs5z6A^wY^R5KW0iaP0cjTH)NmjFtZ<<EC1F>B\=;KkGr<g}jTJ\Fb/q]*A9Z8mxk'+JJym+Y{?5dI|TnsUvCdpm<+B?o36_u{1uph)JSis]6oIa>N>t<Y]=L>22(A[mzce4]qjSA2)oFKW[BE=^\}GRUTbc+w+": a& = a& + 160
    Mid$(A$, a&, 160) = "gW1h:TJQ+*r:K[x)d')C0J5J^Dl;bcY3F*94(Yu92C\,w<=EF00W2_1H]I3NxVVCorr]aD{xjfCBeU0ncN.mY'7cM;YuYYKPJCPKrly|6GQ+N9Ddy*:F^RgyP7[HsV9U78}5.+0]<>-V)c0:fGMi*3Y_/.44;J)E": a& = a& + 160
    Mid$(A$, a&, 160) = "5b]6,zkEQaLAnfywFaGG{TfuDbaS>8CVQnHlXu9XY9k_{b>*4N2XT{+IWn5JKjT4c73FNgPeaU]36nD=19pjn9,a-|vC}tPjeXsE88?}VF.a{^HrP?,oMt<-LZHC,t>wnxeI./swKnVXpf0^cIjJ1XCkPEC,w{XC": a& = a& + 160
    Mid$(A$, a&, 160) = "bJSvMRGv\Z1V3]NVFu9,Br5V\9WYpDKU;(7EXPKKMCLdp-xkBEY0fE2p,i5l}KymPB/zfQ{m.yUA8,6VgFW5WaFi,8DVNaf-7wi*F9aS8]m}[EYh3y>^_zELk'vZZ7fc5=/.[Iw/?nUpg,duNF(=D6AFB-HVu{fg": a& = a& + 160
    Mid$(A$, a&, 160) = "p=CbFu<U\n0g0n]sIu(m_+-)^NwaaFV?=}Cyx[)>G+|32:ZoYD(g\O3vU}[.{wSh=<canY,7sqW\l1QfIJcLpQc75k:z{=Q=MKY}slx_G.SJwTTJL/ydcQ)TXsorqWGCe0v_1D*;)e/ykn2fh(:S;4c9H0;F\'NW": a& = a& + 160
    Mid$(A$, a&, 160) = "qZ1bXCP4JZipdo.WQ{|yEF9m+g;u7M:dCsuhBq^{euzISot'16FJY^jZYN6)<?s>1z]zcOY{*8o_F.j5,z1(OYbod=1j1\vKEvQuye6H,ZxVST^C}GF*h1qmKjh-p.q6:ts:GRYLy3g<^mEr0|Pv5mH<2CesO(M*": a& = a& + 160
    Mid$(A$, a&, 160) = "ar<\cuT5-e>XUS?4y]Y.Mqm/>5h2C'\wKbNCWl(VxQ<hbok6+UG+v=||(h-_OTvt):^Prdq*O)z:xD>|+E8e^)PzY[T8Lh)x29J?Hdqk:_^'h9=vSQp{>a547Pu+/efA7UCVngaJaxB(+[y-KNxUd6>olf'oKUf:": a& = a& + 160
    Mid$(A$, a&, 160) = "jb1+_1+Dn9JWiIg^a'6v?CdPv36:l-,f>WL)(VY<.s*K;ZoQ/u?Sb+]t;+d<oL7'oC:u?++H91PwsX|HgZDw5\\fW?Q-0Y{,Y\;'G;9gr-OhlBBP}P2AK,6FX(MCW]c0c0MJp\3HE(<pb(UCZXY-vj=zDQNxO7{'": a& = a& + 160
    Mid$(A$, a&, 160) = "AUj+JS:MM_[a,_NoF>S)CU_q^[r/og.ESmXbjC{6^5WV2uXAeE(Db7EdtQ.Vjia,M+IkA'glP1Nsp9P9Y=Q|^WYld=K7-U/;H[0z9F,jTWqd'L9JnFIK9e[k0IpxO:B=>7JPo<D0H29-5dg?5,T2wM\iui(}tp'G": a& = a& + 160
    Mid$(A$, a&, 160) = "o;}i.5G>*6xry]RAB'MJ*EkU)MPJDvX]wWBFC|PTG8he?a+mW:MrB3zUw|UaKr[SuFh)k4HCgXz4-Y[=1ga1fI\YjOn\15\1r9{?GpvrA-:gU(ocX67t]'[byJ01Qs3R2n{,CT8EFU5K{ZG:nU=0_94xq[C1JKkA": a& = a& + 160
    Mid$(A$, a&, 160) = "WcH|EH;]1MHo{E.U3;S+N*[ZOc;}h}5jXHiQZ4JvPH8Yq/8dHjm>cd:YhM__C,L:IyU+0uCRlSa90O[)Tg'\I8ters/dCXo:[wMX.79*N;UmGkvW[zxqHRSLe4<9}>x92H62{U1}a9Rj\x}qYUFcvTJnc3eE9hV+": a& = a& + 160
    Mid$(A$, a&, 160) = "6rvTl,(KnM4.T1-v^c+TY1l-ueje]ajaOqBYg-(WNPr45Sd'x*00P]K[N-6=fN**9XME=-}hib'>JE.br:Z^T(BF7J's:1FNH26|aE_(C.FdjO3*tLQT5zt_j8mE1XDgr?INQQ,SS<PY3TckVK*xPhm.4PbM_a<b": a& = a& + 160
    Mid$(A$, a&, 160) = "l-ps3j44T1.3^\ZuK[?{B(y>]mFV3=uACR8<Y(AnW/T]x6oyJv(Yz=O>O1)^D=(]OiAHA?6s*K7RcOE+a>s)9x_gyUTO/Y.m;kabOhqd>ZM3,:eV;NruAube}tKT.aZwTuN9y/7yzGfvy[5FYBo\DK_uSdDP6TMc": a& = a& + 160
    Mid$(A$, a&, 160) = "OUU\nHqiMxl_)Gjk]YUr|Yq|ifl(u]5esqOZ=/c{nv{6c:x(^F5)H\(is3hZ7_*0GJyleFyPROUq:4|>,h|j}EYeHXd*z2xSMgn0Z/D'EJMBnEY^cV<xnB+Zj6hmKUXP\9IV5MBH_Z(lS/k{Ny-tw;xxK(flCVlG": a& = a& + 160
    Mid$(A$, a&, 160) = "a*ZB345GO1eN_pT|O-2fKP5N_oBfgrN81}oNs4CLNv)K/F?vL^^J{F547({[^speGLIFR})4Ks{XK:iSks|1pWN./cP7'mHfU[a+79nyG5RQH6,V42mHu2<9pzM..a?WaOxyyGmGLqeC6EpHKxZo2c87u<qQg:(:": a& = a& + 160
    Mid$(A$, a&, 160) = ">IDDZaKy01)>-yv4c,k+Q4bUvELK>jWJx{Gz^Q|uAYC/,sHRQVwP<^)vPtBfaZ5L]_PrVnZ_t_1pDm;jEJW)PZp\GTf('(P]H>_9_.xu?2F6c.E;tkwtEVz:x41QrdxYoH_RMRD-]y*QozUI8B^>LnXpdfRAtG_3": a& = a& + 160
    Mid$(A$, a&, 160) = "=k1r?QUUXkhXxV7vEjLvOG+=R^O.;6fFj]yI4cHx8z[FZ=Bg9/02DTy5BOyyGQ(-L4C;(sA;E|{yRzx,3s(:M65YnZ|KcPuQ?2<;W'jS?DTl}AVZpRK229jlDP{US>_v)nKqkZKxu}-V=5zbj>mqxWKx.1m>dN4f": a& = a& + 160
    Mid$(A$, a&, 160) = "tcCI\z(|1?i5ycj5/F>2,mjE6fIWRTzR+sG[=[y[k+C.-CqwkFgx2g={fZeVVllYGpKv[*e8u_JC'o>XN7,wx[n2sgsZu3<<n7Sy,4QliL[i6O>O^K99PlPYGf/pMg+5FheadpxnmL/,Roy9nI^0zN.[)x)y?Y:R": a& = a& + 160
    Mid$(A$, a&, 160) = "rDYJwPI^HX2]fw+On'dGcJdI'6Qha[pMng'ZerU;YhTrU1*c92FGb*\+C,9k<ON2Jm5SOs'A-7QYB9oPKv1d3{V?auJ(ZRxI,.JaVz.Sm*zGV?_fP^_/_iF,qZ+u>4<5K.>M.+a]Cz.]m)?*P3>o_LHN.8,ti'9u": a& = a& + 160
    Mid$(A$, a&, 160) = "_]ugZx3MphF9DY40dr8sBMv\){8;ry|MlB=hwur-MthGdKX,IzdmEz3_A\y9b7]I:kfV{*b[m:IDv8Q_C(uSf^VMwx|MzB8jmm{t\k]yTjF)S420VjF6d4}Xp8FyK_VDh-+<QJ9h28_x|i23GEOf1?S7^P{OKTo<": a& = a& + 160
    Mid$(A$, a&, 160) = "X.4VY8afCvg_YLXgXgxaz^[D7{phEcw::bA7knTPlHdUmyCTzeAoaS\bME4F:[0m:NFhwh?k_oE-Hhi{0/;[[1x+M1..n:cOKl*H{3V8?.'Yi{[w7=9q00o:iUHM1;A<KMx0>by9e+FbJIH4l1W}xo{lL0R)d>-E": a& = a& + 160
    Mid$(A$, a&, 160) = "QE;4Bt2iVa2)H-tM51A]Y/;mtApIB0Tucc_(=+FIAZ+YF/RXpeaEI?c,GA'rJhyFDUo\SftwwW]:CSznB?<|I<H7z4(((Gkn'GLu):-dJB4iQ_cKRap{'tOkNf3,yxr5mi24AI.}'Kgj;miT0;B,|.:OsX_+^<xv": a& = a& + 160
    Mid$(A$, a&, 160) = "'I|lJSjpHk+QucCndZto_okT]>yL|>SxJ1oBe?BH\Tj=mL=B(pK9}OX-bOEJaXf2rQSS_LBHv6BkUvR\aIQaPY-Vdpj?p)I?J|m=4euC_=6ahz]yfSH[\/.OaOnL)ezkdMUvu?qBDMw_lbV^>jA\/{gw_9ac_HP;": a& = a& + 160
    Mid$(A$, a&, 160) = "ic)UVJ^Wo)yN\cD1UIHg]v}<xLmbQ4,5IqRvZ;6)oc]hwtEAaqYRdauj?whAZ4:Wwb4{kYkPK7yR)zFQnUda:GJps-xbQIT*3eBS(\Ta>:0gr,j]erFv]{.foa*{+kp//0e=?G*qES7F[=N^IB1|U:.;,-zUBk}p": a& = a& + 160
    Mid$(A$, a&, 160) = "B8g)uQyn)[DO*NazF_gEpz-ym-0?fx^SNx\)<,sJ8Oa.uiTl0ge*kP01]p={s3l]-*a(2=-cO_vW=jKqGkJ+bm\s)lynfwldvjLqfuQ0*(:_5,Lu)/:Yo}.YN3R>\[-vLc?<=h(u24FllT?c:H;.S'h1rDS<lnGb": a& = a& + 160
    Mid$(A$, a&, 160) = "tY+;zGwc9XEa:-:KvglC\,K]VzwHU{Pm6eJ}m:Ect3g[szBP|lMX)VB8*3WF]l-IHKvYR+Rjh_M{KfJ+n=S(BvMZlV;2xwM\FH9pDyW:<HPhErzaQYtuDFh,>qaAfo3?[zTk5?VgNPY+U.tznH\4W'g\+5/Hq3\A": a& = a& + 160
    Mid$(A$, a&, 160) = "m1yqHRm?CeTEim.f4]Ww:EBOZ6Smo>4V52MRd<3gATQm[U>uxp[?G|_:<5P.bSJLLsPo-kif,);Z(j1SE2-n<eLqp}F*Awns3N(|qoL=m-:?|vQ12"
    o$ = Space$(5851): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    davdat$ = _Inflate$(btemp$, 6343): btemp$ = ""
End Function


Function merrydat$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(56296): a& = 1
    Mid$(A$, a&, 160) = "4eAEJ??rJa5Rd569[S.zBL29.Cr0XI+)w_l/DCQ=LXW|,Xg/A,og/u<ZZn3HFDpdRt7V_fn;VP+6cJ^V>Ms^NXaFo)7Q>BGcbBWg.d*}L?(USaj'HB(j>EtT<Sm2[_iU8O*;Ej<'h3xXV1UO}Bg[+*5]WWX;1Qo9": a& = a& + 160
    Mid$(A$, a&, 160) = "[yBj|f>fIir4h(s\3k{IQ?PygBChZg>=|{q2faq9j;Ef?;i*GMnVvmjyQzaGWM>|5vFqeZGeg65k\WMIsR)E;*Od6Ar'o'OTz{9XK+S{><d8Hl0,j):;B9<vV:pV'\v4Nc{zb8Vb(M2ASp{fBup=qiY<OFgK3P2*": a& = a& + 160
    Mid$(A$, a&, 160) = "ZJ?CBOS}JidYp3_aF=HY)?h|laX}W}v[]B[Sgw?^L[z1Q7q1Qoeq[I4dxuA+,5SBpy]Wjxp];f5sJ8?[OIrsusN-:D1xU.P{yFtti/H:)3Tpywb>sgkVs.XI+*O.}n?>d^=tRh8(Yca9=Oj3lu)X(DK]fG6-sGZH": a& = a& + 160
    Mid$(A$, a&, 160) = ".n1w7jcfZ4YxGqhZ5pjRdKQ}dezbJY{Q3X=yzM+yr6L;X?d>WQZ+|KAS;U{<pp'e8mtT}B9/hc{gCHEtdJm+|dH2}C7ZJuFV>mj+kkt.7FwhHrN9x4;<l'|ti{:Pa]{7sqc.eTRgn0KEc0_z/vgBryU'.<q|d[I4": a& = a& + 160
    Mid$(A$, a&, 160) = "d^e=nyjobwuLx2gP>\AGcU^Cc1=Dl.s[FsM7zuTd^J1y]SEhN;N,y*Jqc^x9j6J=d7rBo^ade>KlXrf9_nVF39C-xOv_b>z]KS0iZMKE,a+VH-gfcjHqBBqlt[Y](O'Z*/]1OxpK_0Xk1ox*WEP1I)CH3IRpO8u(": a& = a& + 160
    Mid$(A$, a&, 160) = "6Cb06[vjrHii{0qzpG{yh{6JqZGRdC3b_B|g4*AmXurfBc'GFq2g7K_?Z+Wf*'fYkTwQHuQg0:+QpyzjhPT1'ckm9H<P;jTr_]w:y<1*m-1n>reAM,y]Jdl=yd|5Ozp\LO<MSpZpmLJNEKrf5QtV[4^Wi/2_;5S<": a& = a& + 160
    Mid$(A$, a&, 160) = "^6B-|r5YRyYeBHn4X-{x]CEx'tb.Yd[[*WdaK-LnXnh'{I6I|9N?CBN*H'}kAb28L3i,+?.qzupRKw2_dwc0Y]M_VKuNN(/}A/V<A;.kF)kNrI_;P^lQpZo(tz2[s.fO\ZZu/qKlG1\TAD[/8]*U+B(A{CDNvU+m": a& = a& + 160
    Mid$(A$, a&, 160) = "YEkDuyihU4C9HT*oF?HlrYapjh3Qe=KCnHs/X_-/EO/}w{h6<]'N[Cslabw,]L)MMoc(UjM-l}R6CUusAiG=,yKA0i'uoS0FvKU|lF5:s-qX>xTuB^EGZj>Ygn9H+tXjx8JY.]F]>gn3OPNOacu<9ut+HB,DT;45": a& = a& + 160
    Mid$(A$, a&, 160) = "7YbOP]EYKm1z11TdJ;uG:Dob?J=fD;_Hd^qND^h}i\NFY1usVqG,ZD(v6BXQy?']tVMBtVP?,Io('R/DQfrT6l9NQHnsRnIgEjsLbvv4HXp;ZIb[_{YBk*ZQ,=4D-fBrtDb'GiN3k54'NGqH_J'+axq[F/T\3IgO": a& = a& + 160
    Mid$(A$, a&, 160) = ":kjz_My*O?nOKpz*zb,SkUK,l4[](]:x;yI<\uiG5+/fLiy</L=,G0vakCqBT(;z;{x>fzVl{<J;r8Z3(4t<?Hc=|MpW3.kfT]92BAzH)_2n5qO0u2KarH+L3e.IiEYwecuLmWQs\dvr9Y3/cYZhqv3YJ,^}q0HX": a& = a& + 160
    Mid$(A$, a&, 160) = "gwDlUOu,Pu6Q7QL)LQBAYr4kWaCnf?/1WC?nKsZp*oFG3O*KOrCdu+?MdZxc{1mD*L.:a]HtfEE|VpmmoKADZfa('g7Y?TQ[4e;\Ik*T{,JmLbg\uYfNS[?*z3}q'pyNE6o4v{12jkPeJ9Kzz.eeCNCGuM:i_B1A": a& = a& + 160
    Mid$(A$, a&, 160) = "_6HEz+sH}JoH^iBmlCZ7xhA|MfYl2wFX)MdnoV}y5a'EtYHFP]lYreg8v}WnfDVKC6QgweAw<mHDnwhX*7CEr3R1*KU+C+3'm|Jvr<[s\)cL_ub;'114VEUnh,5N8AjWzha(^pY>hu?2YqNKpQIA4nar1zACT4ea": a& = a& + 160
    Mid$(A$, a&, 160) = "cf-{1_P^A3pKb+IRU;4z-v7x[H+XwY79ouH-XcKPnJEg0O\>:oDq[G<Y51wGgQH[cRYUdejY,=4]:JZj7AaQIZCZ}qQZKKq5n\Rq]VnFR_e]VGojeC?gPA-+[8|mr-l}4-sP:[m4(CooN6-+5C8tI,[xdj(PgnLK": a& = a& + 160
    Mid$(A$, a&, 160) = ",,-J<ow:EZSLmmURAFyn')1bl^2|s_Tn<bN'1?xp(bL/BmV)lXu/a(GLf/hi9(a-q'FJC8+_0sl(9zL+1_1mxMt]8hdNaQf6wnGz0g|MJl.Yt}x),}UY/:zZb>-;FUdhO+;,?PdfDi\}T:GM>wspS^2I}t3+o7Zd": a& = a& + 160
    Mid$(A$, a&, 160) = ">O_bpOqUB^((:kyu(OzcaFMLH;s'(x2q-=Gal?EKQ-;MY|ats}y1/?qG_qqS^hoa}2ch]<->*aHs5?dC3VO]hg*zJ(vvMj^-Hv_ye/,06*vnqsXG-=M^AyFVgxBM{,hV7.y[HuT4jKYN>*o<n?=)U8e-M?s9<l4_": a& = a& + 160
    Mid$(A$, a&, 160) = "G.evsx]6zmqbC'L{p:k:vfiw,cq\ZW|yz(.Ka;vI_VgeiQM_]U_:I4JR:gvf;NExOf3]{HdhS8B>nd/ZUWXuxXvT4S^O|oBViC?<<vE=*STBDGar.vg95G5WuJCi5q7|<L,3HMnp.y6pN\k_gdg29\)6,U03LW<{": a& = a& + 160
    Mid$(A$, a&, 160) = "qJC=Mtr+x}aK{-_o:cx,k6ja3y1G7YW/Q[40T,\e>tvlIW'Zy=X,cC?<ci7BlSQ5zvj<|K-HkXV0,3bRGS+pz\ux||mE9hRJ;1UdKCVNKk1wijF_J/k<)8hGL:p{xNKR4X2g7u8bY7r]oIV^rir;Qu1ey=raW*Xv": a& = a& + 160
    Mid$(A$, a&, 160) = "KBWa45YXh97EwDYkxBOAjib8J]+VIlu[8n\-0tZ7LP[\O:BiqhF:h13VpBV/f)S+.V6-A5Pz/WP(eUohwzf3VLnYHo_.+817B*0.2/e\U'[);;lP)XOzK-?5oJk5nqHSWxRK>x29(}w4X=CpqHhr(;P^_yH8'eob": a& = a& + 160
    Mid$(A$, a&, 160) = "CW;r14kIF?6mx,*|1wOIPVw({)h8>VYPn(N'BfVUbs=gr>^EzZBxsgYxtKk*udv_jeoG^J^s3{2-Twxr-m<G8V1^zBicV1'sX-:HcYHqqrFNuqHh\ojR>2FphAZP[W6D-UTXme5Cdm[\0;S)RV.?Q?s8'[3{J.+y": a& = a& + 160
    Mid$(A$, a&, 160) = "i^AtfkCb(?tDOIHSwewNXdpM(P'9hTjc)'^xM;']Y0=<:)M'13xJ|(?IOzVeDfvgenwO/NS/jqftf:z{yb)ii/cagb;[GM,jY>Q\D8M:wHfu66*OoKX5Io0N_myvuHN_gF5or3(h?Rx3Yu}qtS1.ZN,D0l._9r|E": a& = a& + 160
    Mid$(A$, a&, 160) = "d<OzXZRNg*OAV_jB53CQf6v^0+s\ZcQWby-EbATIe[}<y8O2}O5EGP=k16Rzrr<-eF8Vc.J^sTn7xi4v*03.^1W84=6v,yxmtcJ5'u)sKJu|Xk()VckWm3s,y7c.40yE/QuLQ*z\ouABa6q?1mm{p)eAWFOy:rqQ": a& = a& + 160
    Mid$(A$, a&, 160) = "d]zS(rM=Keb6gR9Fn5UOjTn0-?RhGb+.G{bR*MH/E:PjVpEPH]k5f43<xu?e9-=3gU(.2NG2AKL^W=,h5O9+Ek:p(*6czC^6U<fO6,}ED+D+6l>T-UI8ILsRA<KaZ5<Z*JWgPO>XuNKzO=.4<-:='o6e^;^Cc^m)": a& = a& + 160
    Mid$(A$, a&, 160) = "weK<x(]Qx|Lmp1\tx_4_2M-3G{C-Oa[w?.}D>eW|z.jS^5k^UEo]x4qV?r4?0I{:lmsY33/mi:1GON*,8if;_oz^9Rin_jgv1:sUE8+?NgiA/X1?(s8VtQxs*[PdEZogx017q9qL9c1R0FUYx^DbS:Bc>6SloY?r": a& = a& + 160
    Mid$(A$, a&, 160) = "54+iYX;ga*|/eOBk5nV*4J6Waoy[tj}pued|F2eU]Iox*i4\Xi\xQ/OJ^Jb;7uzSRio^Y^6iRtXrG?/F8XnE5Rh>kK4Fl}E}E,;js?j*'M+w,WRmr{]H4n+.HNEAJy4<{e]-I;'Ote]LwO]W0+-\pPLwBYIpgS0D": a& = a& + 160
    Mid$(A$, a&, 160) = "UV.KT'Eg>1H()_k)h]aD_uC:F7d14,aDi3_cD3Z5?8RQI*_^Dz+^3yj}W5I^'ycY<2:RF1aQw|V/WXhb{.[HeC;-wf|cH5x,FTuEDXSw\Q[KDML5'xq<Nfuq-KxF?gkzWN87:J3p]o+S2j6z,)x}aC'H6KUe.tda": a& = a& + 160
    Mid$(A$, a&, 160) = "\I6+l\ElzdVx2v{*68S{'eKrs])^6|H3E,k^eJp'Um{|OTQ|OoS6ebh/cC,>;u{U)-_.BC:>6w[ehibK8QQDh1D<=300{dMHsnh>:LKrXm^2(u:W(lTX<_(M,=cxxUB+]?.,AEF}g5\6o{5pCk2VUJ>\bi=iQ'fD": a& = a& + 160
    Mid$(A$, a&, 160) = "gtLWJ1)(F-ZA.'P/iWwSr]?VuekTcP4e9*s7IO2R+v[}QWqgCA3^m]B\]G3d=f{}8kpDWGwNv0m3]I]9Hh]FyX9lA5=^75F8)Muk-V=2Kp\(2x9\yGxhFfkkC7wVP'wqPgO/PIj?65OOI=Mq'THw726hZ;Rx/qow": a& = a& + 160
    Mid$(A$, a&, 160) = "uy2,nk/Fa{S.vSz>_fh*///QA/t6F(muP\UmJ.-m}Iegt*7PzD1u'WYA2Ip\oe/sy/;kK*2ta2USa/AS'A*xkmX,F|8fUys8D/Yh>t-G;Gqu:VHngAwVdm[e{\0KRgac\\fY5]f85t)A>-,oiZXahX[X|\Tr4{kf": a& = a& + 160
    Mid$(A$, a&, 160) = "qy^ila^T\fS<5?}GN-'A0w|u)fI;yEZY<*kFy;Mmq\:I;CQ[UvMlj:sk=[+uX6Ly>a'qKSxn{>hV:Lsv'zQ?zWA;>yP'UeN9um0TQgt7IFy;aEhcW}dPY)BDl>T.UjO6[OwE;(DvY1M3fzLcS}7<98V5z30SR0g>": a& = a& + 160
    Mid$(A$, a&, 160) = "wkQ;7(>[O=|pef{RdWnL2<);0)(iuT9PLR1pS;07E?90G=+F7.TuM*sDoFuJdDuQiu2kz:6=ym4^35_c3iCs=G^mN]UWl[=aJ;^gTB}s\AEI;Mh;+J7GsuR?YP-^b)Yt)hRk0d\T3tYBqz3j1TUOb1Gu}/)CLntl": a& = a& + 160
    Mid$(A$, a&, 160) = "x{0u*a>vv3xxBfHwo<R8|W1DebWmxEl]lufW,d=(?DSO:=DvZ\,[{lV,hapWtx-qK-q)Hbc,GyeBxwD?JkA}pW>NZ]XDgf<U/4.lmEaV(;g5t4;BUu'6^qHRB,CSy*IB[Vc2My(T-qX<4Z=UWWhMXEFr|kj8AGT\": a& = a& + 160
    Mid$(A$, a&, 160) = "hsB0'*D,o[H_<V2hPX[ZO>a/I]ITlcq>4}O+'\?kkWx2>I7z9wDt/tD6LC?O3FSenXTT3;y(_UY'9(9|udTJ)+dF*8e[Zx)/w+6A<,oCjq?ZruSo8FIP^}HJB*P<a9y0puDoK56P.DYU^*1^sD4T06</X2k.+2-0": a& = a& + 160
    Mid$(A$, a&, 160) = "(\-EW[=0u-}Z}8b8+.\KD'sqX[C;b_|_bhWJi_Eod(54X-WJoTY3L+q7*7oP7OW+wNXU;Z|V/qLd,QbP^OL1hxWkM4zR=jGyG9PwywXqs9ll;53w_m*RbEveL:b;X}Q/_[Ne6.Ui<o)<WXNqZOCx--bO]]L18iV?": a& = a& + 160
    Mid$(A$, a&, 160) = "ucWbG3DC;l}46t]OKX0vzv0[=rEe\APz;>|Q^OK4:GOrKvMPz-hbP'C_h)'4]nss,>(8Tb\jAW)UJ_hRtWwsD]cYIZp)yPXIu>n3+lbc7l/wIEQ,MX2.Rl{kA]\jw{j^nT|aUfCvh?u+h.UGMkdbBl;WyKnj5*<B": a& = a& + 160
    Mid$(A$, a&, 160) = "ZN+c[Y93HoGWO<)c2e0Z3NlQ5\CBM>2esuM;?taM\5UxDLqks^Wr^*q|2xlZDa7m=sky*1W)yAetlS])ioBwBWoE'jKP]|qvux'M-.FAVe\b0:+HdRieA]S-twPl3'nZXytDJA9LdT2?J84U4v<ka?Ka({w^gqE,": a& = a& + 160
    Mid$(A$, a&, 160) = "4KPJ(4o*^OFtne=AZOL\:9]r8f9\>:]P50')2P3t3Y=nVd6nu=6/FRHv?kOe0>[KAhFxaZ^XuHM'IK+-kE{?GKl]-q2]vF;xCm+ARY'gdWM1v1+Kv_[Y3H6>tUU{Er5rxsE-lb_j_I1nFqCTiyV<BIG\?:XyEmZ^": a& = a& + 160
    Mid$(A$, a&, 160) = "5U{n;kdD28^,PQu7gsrVf,1wh0O]Ma=X>K4n1gk77{2GRl+>XL]O)qtgHoK/vsA9(N_E\]m,'cD\PQ|':3G}Nx=j==5.?TgP(c6|rQ+x*9{;R2Qu?/XTEn.0r_wMRce5Qrj/Lg?+OH=4-UiiOmuL6b?45;XcT1(h": a& = a& + 160
    Mid$(A$, a&, 160) = "nPK]F03}D(W28.PKfDbo0O={eoT)aYy)mU_Ej]lNe0|2ujUMwfINS)P12l1Zaj7AkKzjaD0V8vj|Rq/xoJNk]fp0I^JV}nk_5}M8IF^d;G4,.wf_DuA2wJAok>qH/Rm|\i+nAc.|xjz/gW+O7QoP8Z.VU:(Lo|N<": a& = a& + 160
    Mid$(A$, a&, 160) = "P2HX4VemhXpbq3J9)}A.wRVpski+s34-A.Of_*9dY2Wg*'wOo(2yvC4vkdvOv(5zl[Ch1hCSLugT[tW|Ck>r)cJ+z,9+u>SJpz?40c,XG<c_yD':TI,irw?69VwJ}k90B/b24D8cZ0A?J9ADfL38e?uj)QJ3Mr2P": a& = a& + 160
    Mid$(A$, a&, 160) = "fB}AU3Svw<a4UpUjK1Z[YU-,XZbDcl;5rCC1:1'A,o[w{KsXIqb:*[HK(UpC[kE<]'io7FEMq{6,LbiT[l4r+:zQv,*Wm.>yu,[liuhtBHOTPiAxc;yFw}4aV]Am}Stap1R3hCRSzmJ/'<AdJ/R_wFm=?_dl<p/*": a& = a& + 160
    Mid$(A$, a&, 160) = "tDbb0qTsaI(Zd>*S4p.,iL-FbRd3Fx,1h*GXXwALwED0;).Z<p>xTKw3<FlPO-d|jMKAnK)\Pxne9fyk=I2jm{w5onE(j{8;;NG=)8{}xd,sZB\.og:K^9hW2-ao19Fz4a_PwqMKa}kH?-2;at^Mh{0R0k\.fhSk": a& = a& + 160
    Mid$(A$, a&, 160) = "1-a3v4eJ?{:][,qMeGsi,^rZh53?Qu4^Ki\<S\2PWkXc6_Ec+?k2v(:SvQXhaS]^V\IkJ/UUxDkP5w/(pd+AZLDNQRH)C).KBRF6H=7b'uYb\lvUhF_eXoOrmmH<,Ju*G|*>lRtB0HKPCej*-<nTD;>[Qi3NQZ+_": a& = a& + 160
    Mid$(A$, a&, 160) = "ow0tp[J{8(ht<PbEyDn*[+73't/VKlPouDA|D,HPFJYDqXLkF-VwM64FRr8JEjy[4[DcVflh})Zx5VFs[PQcng:NS[,kc+3=):y'5h3GyXmsT8LXOivXe6Eg1u1P3\]idlj6]49Ssj?zwg8(GST|8Mh_Dk)mkjgM": a& = a& + 160
    Mid$(A$, a&, 160) = "hgUKj]Ft>tT(u\?(<*:4GW\=QgMN<y+Qj'o3R,FHUirrxYuz[fv3I^9ljG0IzXy0{b1{T|3-y2a[KkF'NS4PyfM'IvZg/x4a<k}a5MeMIi-qV8JI_x{QYd6,jTYh_]-TN8iqX7\2?hz>IUfwf'gO|sO:}ukJ't-|": a& = a& + 160
    Mid$(A$, a&, 160) = "t-oMx^C.o:ci'[*+b^,V'+lW51M=k'wUx5v5Sdfm}J3g3mt^zw6qWtu<jq+B{Hl07D^()v1z/VsnJ/e;05'}ctz)mx|=3Clj]eX}BCn;6ap1e*+8r=XU)p.aLK)Dep^m?,sd({0yPSR\<P^:;w^}(R[\0d'Ro?qd": a& = a& + 160
    Mid$(A$, a&, 160) = "7yv'-oP2H=aPB'r5J5/DL.tg*1KFcarA]idfw5A<-y0/]OX'Q(rtt-E;YvmeF-.B3)DF\7kO\cp{T>Ec6U^t?r+7AUU=gj5?ghbqpFY8F=EJQ>GI5dvY/uSw*4FDdycpuqBrQO1T('U{jUzky2xQxhy3?B68pPYw": a& = a& + 160
    Mid$(A$, a&, 160) = "-RuK(^pAtH07riZl_Hh3efmRi(br*3h-Id_UqGrji?Ph7XTMvcy[V=)QE7=mM5rH({O^S1B)MQJiT+C+DHMbUdgL4YwIE;0QSPAYlzXF8o'hv96v]/1Nimy{i9yx0XoDxw+tS*;2Y|-lrLzQgckC9E-CYnLRL.QS": a& = a& + 160
    Mid$(A$, a&, 160) = "O78nl2q<qZpL4F-zH';IQ<aFw<qw8CG2:tvr4T+C1ruJ|n2LS1V](+(u=A4Dj2;lQ|;ej.wW-adE\yTM6S:+xFluehYgO-|pn.16OnU57-cY<=uLNZ-*jG}i?lg7/}q[[AS>=:O+eKo]^.h[P:^/sb*4s,T|XSqs": a& = a& + 160
    Mid$(A$, a&, 160) = "Y<-1D)cJa764leO0ETpwSuzRp\V/^|hJqs))+c_HQ9lgtKB|P:/,x.DD7_L?Rhwq:ro6)q^lrA1D\wn{x9+lCWMeDeP[;tzcywJJ:0gh.vzV-s*yiYLV(7r;<ZQxX:<zLI)/;]cV^NZU.lMT-A[1npZr>+3:.c^Q": a& = a& + 160
    Mid$(A$, a&, 160) = "^Vx:3HP3YpDbfF.5CqVaZ^2sZy1]M{RJ]Y'T?3N]UBMWFxoME>G*A1e\Bm+tG?YT4|*ne2G>{nGEDnFLb6pH;qcH)s-0O^mwhF9eDbR:9IVU{1]9<\BVjBxD95Vj-(pOuPQbJ)ZY7RHqh6Rzt5i=;)VvX1]gDDK]": a& = a& + 160
    Mid$(A$, a&, 160) = "5ts\KPehsOiWhEvq]oH*QJWSIkl.\gEpu8s-F8pPqFv4G)2EGv{oNvL<SPyLKn;Bt6-E_l(dI'/YZll0uLKfL>-LLcPHEq<c>]DZh\Rt\z-8r8Hqj4+FZhH(f?uPu7uAE\ZU}\|;H>ms{vQJt]rceRqqcqK,SF3^": a& = a& + 160
    Mid$(A$, a&, 160) = "U6sZmLDE\chC8;AY4G)e<F2NvO'U)+G8\E|SpBB*25)tbx8TRR3Z]1*c/nUPRNks/y+XQR>wrsM7('2ncHc[|[0nH}'cXLo-.wE-F=B.tJx*>m\QaE{1J49N{k;{BIN+|/PM=nSMv-^FfR.+qIBi:NzA<;.A(2uL": a& = a& + 160
    Mid$(A$, a&, 160) = "hd;G?8({*pfJ1zrS7h{'H3PdD'9Qrla,|,Lia,i}Nk(zq3^pS?{Y\Ws\9n3gelH:40jYPmv0fksDPgb4[hMn{q]GoO:=li\eFCH^dvtI'.SAw|^sX_Id8y:*Dd5;^eqL09+4|o8{9kD|ade<=)1wR|rx2yuv;cEH": a& = a& + 160
    Mid$(A$, a&, 160) = "G2v*tGi|;>e1I*o|i=NGc34EXHI'u;{.wG9\JMT8H(H\W2DS\*3Y[s3o\TnsekQnb^]9EEE5:8*496S><aS=Il2)xwHxS_sVj\b]uAc9iX3CwvTL;}K?j0kAZWDLVlt,6;W[2nF[m|FHy^jW)S.KBGf>*I?=LSwA": a& = a& + 160
    Mid$(A$, a&, 160) = "JZX=lF3/;DeWEwM9BJ\[T0[D)?;lVP71h<ja-}yb})FB63NiabAuE:6K4\8<e+g'+2Lw5O[]O):w=_KH(>GilkKzyip>h3pal]DXSokSc=7EAfGRU;]K2v92wM\ZL]T=k3<RwBEA3wGROWcGcU9_qbN1^|bVob[;": a& = a& + 160
    Mid$(A$, a&, 160) = "+*y*<f'k3*{kT>_)4;{.k;\mnt8l5E2(AN<uPdJKCnb/mNLy9=csx4LE(8Lc3>O-A_+OdS6(j5h{f[OryQ>:m0;78uuG4PHdI<H(P7l7B<;7B{xpf04m9A.H}ARRO_0XDF8_K>F).2njdslLB_(}EW(JL<8(p}ti": a& = a& + 160
    Mid$(A$, a&, 160) = "i*3kFBk{0?Oz2Q{75z5VzWnuJa=Ws}-E43-+Wv_xQXRFwVUYT9bUu2.S.?-R<g=Lg4zz]d<Co-d;CZ^bK*]v2)*MnlhVbtTdF_ijZOz7N[FDp3{\}6o3XP}ZkyIr5'<Rtr7n)ExnI6}VfBua34B^;_Xdhz4[7ki0": a& = a& + 160
    Mid$(A$, a&, 160) = "-uKAUs<l2B*lXEPNozja<.u/*)i'b4soiLka.OzeGWVOeBpv|x-IP|eP)w/1H-Xq0tDsXkNFS*SbiDh|A.P*AHCt35Fr_H|k+[DEMJNZa|-M>TT9e)BSl2<{J'<-xtK[_z5u,rl,m_4<W0j;xY7N:7H)c55R\\:9": a& = a& + 160
    Mid$(A$, a&, 160) = "9>g:8(U=s2fZXW[/,l?8vDEYI6YAP'gaUOJd=96C,_dv1Chyw8j=YpV(FQVU](7(JTyP;nubu-3/>2TdbjRA>/*\20OqjLYi:D4l_0zJ}{7?;^ujxvEs.,{D,jdM?tBNDGOOV?2usyxPnS|\=Mirdq+v)K<WS{9i": a& = a& + 160
    Mid$(A$, a&, 160) = "_qpU2C^b:p{x)jn81/5j2I9^s?^P)(N02SLyL6';x2L2zhwjJjKC{i;gcZu3o*K:JY41WPuyB-dr,ESn^HOX{;92]Yx]U=/|UnvyQW/wV6>D+6TnpHoIA}Eax\ouJK4Y\EeDu^7l[pRAiLE-jnPul\_7FG929-a+": a& = a& + 160
    Mid$(A$, a&, 160) = "AJD[jywP1fld5?<{(h;FAeJY\O2{*LZS;tRdiJ\frOtcP-dfKxciv,fSkg]n+^u[fpUAcla1)tk=n791jNKwYOT0yRZ1vfUUN64.^*n<?\ID<;db2kMOJ}M+>n-ZUT{4B_'h4)RL6{En*8Xcfy[..w)tPsXXs=eD": a& = a& + 160
    Mid$(A$, a&, 160) = "Gm|NC,vnZfcH\5Cs_ur0O(|)u8+0m2iYJnxs8^2q3cyMoRV(+;Bb,[WTk0-\LfF/c=hh{9Ft4a[F+0Wsi'waV[<_OmQ+[jW(6x\N?bJ\3\WSiSL.mq{)/n<dxRJwOT:d^+PDK457Cd_I/KYOA/kK4|)ge.)edP1b": a& = a& + 160
    Mid$(A$, a&, 160) = ">uEApPe}gX]UQ58E;u3)}KFrrKkTiU-T0gK:VEz0PX94[D_,<.MA?/39IKok7smA>7A8.HA6dtHn*b=.rEE8<.h]i^NvC1J'6T8]Fz9?0wcbC,lHyU_E]IoJ11R-_gU}'}RN3wHxi7A*A4/J]_IpnyPKV4g,>^^s": a& = a& + 160
    Mid$(A$, a&, 160) = ";OK<,V\dT2lL{(l3x7ilNaSO^0;SBla[DL9yAaFW':^8nPoTJG,Ps=,A/Ti=?(8ZhlUSX4bo;Td<YH;*5d[Pk.wcf?agn6gRTa)z7XFi}jq.wv69FacH_hkD-jUa;0U69x>Q13*0:}Y_JmBWJ[0ftCD*+sJQ5B[[": a& = a& + 160
    Mid$(A$, a&, 160) = "0jKbA8zIfr9Z.co[*Dy,rTv[kOZCn}eAgX^SEIxL;C2-<\198h],)I?'6UcWf:/'t<mo+Jkey_r4<Pco6Vzl87Ca0|Qh0si5Wn524P-WCWcElP7Ek4,rbSp=Sv*?B}PjXx?vt=ZVCQlBAy[geltcDzpa4HP/0S:N": a& = a& + 160
    Mid$(A$, a&, 160) = "[\[X'/.BG29IX2lpcFAH'JOcTdS=-mT(B1Y{0j)Tow;]GjM'^jAd8gA1-ILfJn1F-6ia*x)p<C;en=)A5nYJ6<q*NaEMVkGC6rgnBe3Y<B[q=Iu(Q;VDi{2+3]egZ7Ip9Z^G8DR'WWm0J>1Cm-<]NW>uO<Wrhbca": a& = a& + 160
    Mid$(A$, a&, 160) = "S?yiQm]y^N^tp[*9x;AetSFai2OPci.g^QzXXE'{1;v3Qv8PKFTQx<}LbGa4GjD7Q8r<vF>F,}*,uVIIrjB8=iuP-:X=tgUha?hi{)Pk5gQmHa|ow87(:^HoWj2S0Em}k<56wuCGHoTIs)<aX/IXhQ}S+zBh[JC_": a& = a& + 160
    Mid$(A$, a&, 160) = "E-{PrsYVNer.>f8mcUF{Wu}mX0K,ToS=FxO;*MI],pie:c0p:gK_/pBC)wrVMn?um0/^m\,+[ygCcfaHZ1Qq?G>yss^C}/[MjJ(8uY=kn0v|Du|p8Ki9Mx>pZeOku7RUIAWj<wZv1PsTw?]j?yt/ESdp=HvZMZiG": a& = a& + 160
    Mid$(A$, a&, 160) = "nqjC?ZucZllkFr(rR)3rb)/YvCS66++Zrt68)=N9l-)gUIp8dyOJJi'uXcdktGab/x.(=MDHx{ph9'Uo?n}'Mz*2e<G*Vd2y6jZuhM4SW;:P*c.<IIODrcq4xzU-ctAd(K0ZbzRL0CZ'cxq-eTM3gIVdGO'Oxn}Q": a& = a& + 160
    Mid$(A$, a&, 160) = "5q^1j*/jFH/vTeAj_wkuDDmd2|?so^n-A-;L0zg,J-C71ehEMXbPa){a3=voTkE7U1IoW_,M5SXA;LBd[Esj)^'WM}{7t2LyL4cr1OTd<QzI_(?liiNL4ohVP?r^H,G_[0*hTsGZ2Te[GxrwSMr{-L5VcK]m:/'z": a& = a& + 160
    Mid$(A$, a&, 160) = ")[X\b:q}piFUdc5HR3+i}i=-TVBJwhEJR>Eyt;AFS30.Kv(s?Ki;H=Z)N-p/:+?4>5rYN<PA}83DXja|l0rFu}{5A*W->EVh:/DFXHld<21HdvBb(e5/\*+pZ:qB1fzqJ4Z?[8vdReLgo*i0jJ)M,c93ziMZxUCx": a& = a& + 160
    Mid$(A$, a&, 160) = "rGhmV9vwr*>t[ALFe+8k25s2A_ncoPLKjy./Rn;iGw5CLCnz>gW?>Y\ts(VOpwI6lyGdxQ4s2-GrI(=K\93yIy5g0n<8gY5Pz]}-I;'(aJaamz>s>]<8e\OfEeXO(Xw6*f'Sv?YmD}88+[V;o_Iu)7C5CbQs]\RT": a& = a& + 160
    Mid$(A$, a&, 160) = "WWVsPFtD5zDcqaF1;2VgNB,H.-;/^yd4Ch)8/_bRx[|ri^etMw/gpl6tS5*{*0pqx2ZG+Yb\E8khMfvUnP)sJaoC3[/76v.(J6:dkHL0l.YIHPLf1)2.fZ'5LF^3|sVw-^CP(J60L4|l}xn}/u?H+kIfYur?bs/]": a& = a& + 160
    Mid$(A$, a&, 160) = "[H_\Cf(\<F0>U+iiR2nxCdDJ6772gHrcmCf,K]2Wuv*P]Y*[<2h:?ZOjD_t]oh[/1]NCT|4L-l?8c0Ge:4+][,/SLX1v8]_:0}dhk_m:ES;DQUjkD;e.gtes2.SFWHG,*,/'niXoG*^1Y.VDRG\vWqS:j6fN:R=d": a& = a& + 160
    Mid$(A$, a&, 160) = "Od<5:kD(*xq33L(*LZdrf/NZAD8zJ,=Y{m^JrohM+937ErP=U=duqs:NRym3M[VMS:\7[Sgq6=afbY9HmfWM;lb*Xc/uGmh5RJ)sGZddr,=Uk*2LXo=h9bSa}i6VbnF.kA6deTAC^Wjs<-496{FTkdB]V:(FQ:tC": a& = a& + 160
    Mid$(A$, a&, 160) = "hfln_?m;FOT=1-^Hj+N_Hj-SIBY7L)Ca4y{a;y3RJbguVfEnafNVOl1nVfM^t9F;)\[}M7{MVF)Z'm/yvq-}7ovDISCdMG]kf<2x'_L9(Lo{uM2MzLs,\IXP,qTE8E?DINrdqF^sbvE=?a}uk[DCu.jjS9=:kK>Q": a& = a& + 160
    Mid$(A$, a&, 160) = "|sP)MgdVm[la2VQiEi'vs{0EZYnBZon12;^i]w\v}'X92z?pW=Oy3ahl4e_cb=6HOGJ[/w|=5T'1r/dMFOD6.2wpVadvS+:6=g4]ctMKt6d}|py'[y7)\='JO8lgIJ7rZ-TzG)bEP)yKNhpp'pW4o}UL7aw^4Yw0": a& = a& + 160
    Mid$(A$, a&, 160) = "iB>3.Pc\})fW6CrNDNc/)g2Y27rMVqStV6fq'^'AZu0=iOw6:85TZ{D2R..V2-TIQ3Wbi(ir+DNX>p^JlYV^J{m3fLljzP9=U|r8rIaNLo^KglHZ5u0kl8-pf'zPsN*yn:|pj]Cxrg[_+RPH:d_4?ou]>nG>M)95": a& = a& + 160
    Mid$(A$, a&, 160) = "97cHc8ho6yj/7D;s\}XBa<g_5,_oQGzF>BGw*Pr2jqqs<Au|qs/g7.=6Bk9dgx\9_:)5nQh8X=N[T'2x3si63G=H6\pz:AW4]7bL,YM4gEKl*YT95[+*5cgW2-(GkFNVf5vR:0,+RPP*cg>y4TuwG5>p?C0*Ym_W": a& = a& + 160
    Mid$(A$, a&, 160) = "ll.]r()6IWSI],5XkC41Fy<tYH+ReV[.F<bwM(i^+EpS)6,c|=bUN(41[jB*K3e1X>(Z=_M8Ch4B9X-'^snG\Dgwaa:-t6{|UugatJC>9T8xwc+sAH8(5^Ptoc283Mf^=>IGGed?^D:M{Wk2bf-A6SNJV<bSDzNS": a& = a& + 160
    Mid$(A$, a&, 160) = "L+)LgB>2^CbZaBg]\AD1hLC,laq29K71G_}'+\})o,i<{)oX\w|L1t)AxWEqZ)8WNO[7t/R_J[YNO=NJ)WO?pqpg+2S=bv:Cnma<>P?/vN+AjD'ba^kBR|;MfWykr.Jgx,z_+Lai[6nylvWCilE,yy}CozauhdiP": a& = a& + 160
    Mid$(A$, a&, 160) = "xEmNvI:IL5,pVw9nn-;<C?,zU[Eb;J9geV)8L{aF](cpfkz)Y4=/2'xO2bb=154z??C'Ztg3rFm9wQlFpzmn1qbxdG_6WjZ{ttGRS69c]8n)eZhA3\]_^q52(/_-Oqc.^fgBng0h=?(:B/BJ-<.bL2cqJzG';o3t": a& = a& + 160
    Mid$(A$, a&, 160) = "i'_:ctq}y2*:/y*DvtOV]n-lwKr33X,=B+/K5/a4'zeTIzib111MX\L}pd[idXo}EA)Fsx5D|'i.S7K3y<v>2eR-LC,aC1HJ=X(}|fPN]AFL\6,tI^lpVmH=w8qvp/(S=q;_ZeM_fAv6dD'N1FxClAm^96o6ZE8<": a& = a& + 160
    Mid$(A$, a&, 160) = "{KAanU[u+O9o9g4x,n|^Tgy>A9Fk0v\PBj[4AIx9.a=]qd<aN}q^h{(u3Nx1HBFJDkJwK0TS?+W\36Oo8liV4OgW)WXZ'>?IZXRgMNn;ezPj44{J\Y;CGn=aM[U-*I(YQ>NO)qZ;EWQomFo*'>*2,]:T0Qy:FVQT": a& = a& + 160
    Mid$(A$, a&, 160) = "-U2XW]DSw0E{7;*5Hp0L^Rq3J_a-)yv[_S{1hL/BVb(}QL=76B{gtT=XSAUrZe8Q0{2gf+q\IPRV[1Nm-xOMKtQym,mD^MWY7d?<c8XuF-CISj18f'U7-<d}NBsM|ObQKg-ijh=b9<,N[/|RL't-SczMrX[lQo*k": a& = a& + 160
    Mid$(A$, a&, 160) = "F2hi^gi0_iXL='8zX'8X,T\7(Mn;CwBNkov9wZQCA:\.jiD[,BMMejW=PMhv(o<-rJ<Vu4S3ya8opX)c3,ZbO]BSn?(^lveX9g.[UiKE-cyTACNsc7BCs*UKY=>-*nXQlp?)}oHv/+h(ZfX0d:cfq24h1z{pm2\5": a& = a& + 160
    Mid$(A$, a&, 160) = "=qj2*R?JdX7Jj?neC3O}rrT|lqsg8IuJg\4mPw{*fCeL=n_ETwOegT<P-ypW??Ewz2_fPLsX_B/0D9WqCHM]q|BUa-inCbDAI/nx*PnQxju{nLgAv40M0l5Tbve?40GzRh-q;Y)hvuq}BfHFIimkwsK4)+b{vW{U": a& = a& + 160
    Mid$(A$, a&, 160) = "H(Ck*}vUh8WNTY0**-D]RlY-cfO(V1)xU,/n.E=e4[x334p{krv;c,s?QaDf}T1^yDU.X\mDzm3HJrr0ORp<=xSbgVD1==Mt6'neXcPO'=neqtgF_rAilY}Z4B_Mc*TaYGf?iw:oyV>[3AHvD6VZde5XzR^+v7T_": a& = a& + 160
    Mid$(A$, a&, 160) = "wkuf,m)xv0p/Q9W7A_yL2-*;n'H1RA3Ku1D+fSkP_IjLh}?bZ9[HP7w;rs)G/iOJq:CgY*RD=9O(zRZQ/X}=BihqSw(madsLKB1(PZ^JYr,c,v*C9jcuuye.9aK(D+wcxww(D-e?BXIWl;DoKUakd>1M>,Y'_2,f": a& = a& + 160
    Mid$(A$, a&, 160) = ",+|GYvMTe/p;3z'tA3QACC:8-8D7ZnoIwZJJ+wrTLq1ZmGlotjmWnw;yHO1ZnW0?,Qo|FX?Ppk;kyT()2m38/s)WeW}YWjcEsAk(Hpq)ieF<CO-WptAFKO_{lrF+3-LhP=[i_N)(YNSB]^Y<.qP:jF{syFCC2O2[": a& = a& + 160
    Mid$(A$, a&, 160) = "i<Cki,n_gOE07eadpAk+z[<xn0BPxoTlO28IA9^sSi1nAa_lAJBm7k8h_0b40j:0IpKIqmzh0ko}z/8juKmz*Lw5,6b?[h|-B+g3v8-IAUI2,4-[Ka0Mp;,E;D7lNNwsSC-sKT(;k9WsZ>0-I.?P_O.+WFkozNwT": a& = a& + 160
    Mid$(A$, a&, 160) = ";ed02)\|}eL[K\iqoqswkLQFv3hrO*u<97OBLwL{\QsFK87Y?YlLZS8K<U.ju?[>d,.<2D-pnv\(9JL.Cmu_r3BtANgC5Q;/DzW'VTAX;qeb*w(]S(6>]wTZiW^}kZE5mBk6NtuS5S)kqIAsC3'nRfQIzNql)yKf": a& = a& + 160
    Mid$(A$, a&, 160) = "+ENm?0Q:cZ.Ns0]jKj=OU(j1c|?>rN^oXu-;\A)qgz4E|b-9vvUn9OY{//_w;\TDJ8XG=:WY^q\AnHFn[UWR)Z9=z-s3d4v45FAKe.)IAbDw_Q,uM9ikO*JCe?]1lmeYDhA3:C_yH7u2+^q>veB**:c83Ys6e'9)": a& = a& + 160
    Mid$(A$, a&, 160) = "ANL>d'GI,W13YBuw0hAnjCqz19V;|lkx]:}Gch,T><HKRu12>pCrvFhJ2,,ltwKU.99Hym>1SqkP](PlfdOsd.,)gpsD-nj?F3'8'?\YANZYv.txaxo17OuA6X/;7/iF)D5t\k]rGzsd[cO0>=T,Eiq]mro5g[m|": a& = a& + 160
    Mid$(A$, a&, 160) = "{cLt=pYc\\I4LV,DCj>bS6I/C+vu*zP88zr=<I3nwJ+LKa\(c1)zs{x|h6PC^Kn>Fg.HIMatvD'R\YExRDPQfdYd_A?]Ggos{80}d))I,<zu1HT/3/BR6U_DJzyznpq=e6Pxi=zVtV-=Ump[4yM[uO;[u|cG41xz": a& = a& + 160
    Mid$(A$, a&, 160) = "3BgoaOAM*cP02;:Vx([cYH*Jk.O+j'Eavvf}(8'=P0G0HOaxZ40'yRQMywfCO3B5KEDvzY1fLF{oq0K;<7)s.lpj*v6e76gU5NMKGZV:ApmUDcu^P(Pf6d+'E?+MZXNgWJuJz>8J\;-,=1<cpcODIQUE_O{qTMkI": a& = a& + 160
    Mid$(A$, a&, 160) = "pyr[a=lSwn'UEafSn<x*kx3Khv9n;f7(aC?s]zb9NqH5fWfPsj=0j]1h2FFG.g<qJ)g<+UmU):u1,Z=<,P)=:IE'x,dO,h*,KWE|ArLrD6Da}SGLjy<NrO_Obo[0m\I30Gtw7J|'m.PyJnNw0T<b:YZfJRDR5cLN": a& = a& + 160
    Mid$(A$, a&, 160) = "pPc9>kp:P3Euct[l-d;H]2,=Rz_7pY)m5\:s<z3kx/o:}I]L\TFH^y9Nb>{\4wTD69[kvT_;oeI?5TI|\5E*b1AmPpXq3hA(t)2Y[=aNbuy/84lHb59yedPER<waUTp^kx+qJZjZPs0Mc(4MJ8j*c8s<sSf^bap*": a& = a& + 160
    Mid$(A$, a&, 160) = "r2ZMJPdOfY8cO5JTis^MgIF2\+yvC9/GKnu7xMs{P;RN*8HJ(,>(ihJR8h6^SsX]HS+:Vap<\Gz3m|Cw)m--bZXE{rjo?'LOf-g5_yo2,;tS-9j4h[Y:qxsWrFc'u^Ck|/[W-B*HB|b1N.[v7QDo.*<a<U+bBB>H": a& = a& + 160
    Mid$(A$, a&, 160) = "Y]'E7;pquYZ'<L7)JCh'<d8J\)\b;l]C=<PrEY/PM?:PE1Atw(i_Jn\}v>5Kea0Z9L2^-/+ETi{pAErGDYgu+'wA.0jy61JAg_2LR,2[wnnzugN_ust+>,0X4b\IO[4c}237kXGzEP{jopqxoY*g=]GCwsB<vLoJ": a& = a& + 160
    Mid$(A$, a&, 160) = "Y?+lNFK*jIH+FXYnX9>,|H1uA6OAg7dvb'c*IF3Y6VpRO,^W\\eyZm[m8-n[eaOoaQb(b.t^f5nZl;2MLLa78jkP{'KX|'le-(t3\2q.EGqVu?s*luLT<^JBd*D6UsS9ayky{;m/EPUcE=YRTBUwM^]p0EqF'G.F": a& = a& + 160
    Mid$(A$, a&, 160) = "MQy[jPr0tn|3lpzmb0Ak}4RB){aX]<3>*]Wd'wtAO3C741ljh|gx6.4yj=-hySg75tj=:S+JtF2,w^2SEa(\{8*N:q|(?7=X7bCZ/ulU5,uTV)W3dYk6Sh)TKlB\nnZ+1+cA[(ig-[L|2U0L;3Orxp]\gp;aRMj<": a& = a& + 160
    Mid$(A$, a&, 160) = "x/x0Zdm8M+AN})Yq=kl7bO.)^K1_U*Y=-j1]mvb3CF5(=S-|T9Xo.vQi[B{,lI+y/v+5mBAi}.:892RH+H\{A'T5?2]UpdOkt=v.e?Vh,Tx0b?QtsR645^m)wEXZM:e}JKjSF5gf'(d96iC<B'PGT1uMjPy?=\l]": a& = a& + 160
    Mid$(A$, a&, 160) = "YTdlWB/rigrb{KxZB(e4C^_aebaU\sL4,_pKL[FFleHK)KLT.I[=F2C(Q>HvGpE:9}mN]]eV|h-MJLZ<t9j4KrJUfO_,O:fgYi[NOuIzw5;xdfYG9gAeb*Mk<'9<hcA,nJ^Smqw0we}H\WIOvT8<KIafDe<|UdkU": a& = a& + 160
    Mid$(A$, a&, 160) = "-8u2fPL^<d4ZS}71yZCqMn3X;XNbyOlpDl/??wzjrty7I<K2M3G\MzN6aPyqm=m|aGbTK;662oA2?kjPE'7-TY^2Ug=7Sb+bCN_+[DDfVfj+.0Z22,3>up1-k?Kmev,ISR=7{t/G^^('x>:[_/7?^P8*AUv2wfL8": a& = a& + 160
    Mid$(A$, a&, 160) = "E,1k0i-z9:lmZvilrs;B)=pImHfKo)iF?,8w6a/*TUP+>U_vEOF2[]OyqrOe7G]x=7:0b+yeXU|puTg-(8cI.B8N_DGB/H+'G3S^a48[oytgi<M)sg7z(f-tMtHbht8j.mfm8'W59BUd}_H>nd-5Gq8V>X+gXr\}": a& = a& + 160
    Mid$(A$, a&, 160) = "1Lm.F=J|m:IzxbR)d)<*CJtbnkF^'nptMXAP]B7},9MDfs5'9,Etz7'UN3uwY0kxojOxC:4bqj<0ryH3tCN70}<nkZC3>InjRu9unMQ(;jUH_bq*aK=2<(dcuR]gL=n1<Bnx7Mt)UH50X(.F6ag.+D=K9S2yv-h?": a& = a& + 160
    Mid$(A$, a&, 160) = "1BUpE,J82gk)\maefBXf1a80|G5KQuSt')+<Ib=9UoA_ty?{vX;E)w.9ElwPW-9:n,vhfcN^Egt(tGWYsSRttxM[(;27e'<?7K-Pa.BR8Gv0v*W^OXP6PrTR{?CGL<C[J[t9{jint01S<cA}F5xTFYzC2GO-u\}U": a& = a& + 160
    Mid$(A$, a&, 160) = "46t{=CQTsa\316qqD8ZQMllr1crypVG[}AmP4\4GpPzg/YESq4,DjZmT4T_z8MM.f)hYlp*(w^_7i5q{(lJqLkek8RZu8W],B4.4>QBG?OjBl69P</oy-{h}w)5|7?yI|-(D9|pVlUf=KP-7cBkq)VyT{)ChqxB2": a& = a& + 160
    Mid$(A$, a&, 160) = "\wpJ{0n(:*,;qXzO.(=*PTO4A[F<A8Vb)<u(*U*aFJoxMJml{_lU5el5DKn\s);XIp/TY5NwT>k*L;REc>Z'>|'fKGX_KTiNdPBY]Vqld?7})K|^Q:wYPOE|3?4]fDSQvScTx}GWRkq<MM;(CFJc1moX:.xRi(G8": a& = a& + 160
    Mid$(A$, a&, 160) = "LzQ*/K3+(NGZn4KSx/|ZTF,(2\yqpC+NNR}9mZ+BI,o\xbCq'p]?ae8zDrzCTOT,25^H\*4qBLI,78w(aCtSEsVpLjk-w31L(A>TlX)hi:/sJ/{Yam1NOf>VCj>/PNi4}^X;)1'qdyz0/W4xuo7z]>UgH(h[B0u8": a& = a& + 160
    Mid$(A$, a&, 160) = "6DPhd|B(<-e)BlG/Q;wbITUoB):\s)G5_A+J?shC-:ZIwyPvTY'U|)wIFo6/,l6d|k]WKKs[6OKR4:_*ce+Hg4Rs8HGICx*Xx2)iJj9Kxz*Y'q<Iisc(q)>;_Z1szEiUo(kpi(l2lM/?dd7[RJ-hU08xNiF^v0o'": a& = a& + 160
    Mid$(A$, a&, 160) = "GXSxQpxacE1f?ctbe{}Mb]QZH3uQL}ycu;>AyrRB9AR5q[bu)P0?X'NPFV;SV.o?kP?<_K53K6ZwA7cLr75X,h]dq5pt?K9{CLDqxwQzShpF.M6R+MB_>RZkyOYOlHfbwrQl/7u7L+ebzl[[]vK{B34zFEJuxt(c": a& = a& + 160
    Mid$(A$, a&, 160) = "jDj|-gr-01';uLMxVM9v\(g__=D211cgrtOvyC4f?4;m)DI6UIxHU}F1^Y=eypTBaq?4q21fai1,\YsGi[oqF'Jl|=QF;<;?[_K9>lCxRY58dCo2fR*Vu*Gmg)30fSztOa<IzwlWsBs4w*9Pu-\:fRsx7'3VfO00": a& = a& + 160
    Mid$(A$, a&, 160) = ".:J)}nT_?)RJzgK(wF_M^q[?jYmmz^]0tg]fH,Lw=r_{Rz^4l2[btliDAw'nyPsvfhr;sSX0*Fqig5I'93XhSXl<pbTW?SP1q8^n2-c8fY^YpjvjhgH5l*e,A:m+^QTUdPNN|I'Ey]{5_4S5upS\u?8cRY.75>cT": a& = a& + 160
    Mid$(A$, a&, 160) = "]16qH38cQX|?ZjxE2}3;.**4o]hr;25T,SduUqIRl3Ee?IGn9O_9Kz0-nw:XKcuu6FPuP8sG4KK.iJv=BVRWWt9X0d1k^guyo'sq}gOr1gCRBJ}f}Ou1SLa12aQBE=+M4^dnyv'\ncPpilW[IV-E5.Sqm|eBH0]7": a& = a& + 160
    Mid$(A$, a&, 160) = "/Gxo:YT>a:m.'8zq]L|ufONAj2nX<N.Rv|hB[UgfwJBO]3jBXzr13}kKe'|nGn|6Y;J:+<xlDGW>7SvI|fXf{}[2\:TaC<-15G;jnMdk[>/7J5^SOe]Bms_6x3mgaitF/9[o7]O9Taay_to::k97XjH2OB2h?Zsw": a& = a& + 160
    Mid$(A$, a&, 160) = "mi(khMO01t,DnTfFiMKyttPJ[f/]1s;y_J-q4;FcVwzHw-[khK4y8?3ZyxFm-TNh3fKOD.0,DVYZYDZDGk/0o.vo[?(LDF,Zj|j1cVH_n/Qz2Z;/X3Vg5X(OQ]7RZQq2VP6Zdk4*zEJf]47[uQj<<o{cpWx(wnat": a& = a& + 160
    Mid$(A$, a&, 160) = "<xHLbGIyod4)-kdHx2xxCP/vAJ4LFya]v6>YY=_X}5.TW{6BcHwz;apcPhve-FG}'-=GnNEBPF'HT2G[-X=mzlpXq_qU-5w0=Fsq1m2,{Z5iNd-C6l2Ygn;hEO;f)b74B4Oqc'{vCvz5'228QyQodqet=+kN79V<": a& = a& + 160
    Mid$(A$, a&, 160) = "Pq*FNh_Oiou=py+x:iFs{fV*Icz(_[<E3ZExiN{z-.oiNVC8fE5^8Y*hF}<ZvRV6B)rV}7g^PKFV<t-T_Dhd2mqN<eSl,N^x.N9Gqh*RH6^)3R9rhhR_dU[]ow4Hp-+q+1zQ[y1nNCk-R)gp\6mg*gMZgV+p,p>R": a& = a& + 160
    Mid$(A$, a&, 160) = "NtM?D(bgM2CE<J9y1W{=9yR;.tA]aa,eft\2GV1p,5?0vhe,wjY*0}aL?xc?i8rWW)7Rx;JAZ8dOo0jwZwRgYIc.axF_Vr)mr:^T\Xf\A}3V\kkL<Gd?VIGHJ)e,kroUZz;_d)-lJ3C;7,:dpVh9)*IRAA/F\W_]": a& = a& + 160
    Mid$(A$, a&, 160) = "KMMT7^0[Xn5.EvR-+/'wq4yh*.vh>'IX'i*wYZVx./lB4tfM7O5_3^-B?E<MS/NJCgORi^=j^_qPA/d]GXQBZ9uEK=WrW}W>p:6\a:;^H|UfX<5t+.CzCm4Gf0RXo+o\u-0Kal5QOLU092'YLpeiRl8yz+N[fRyU": a& = a& + 160
    Mid$(A$, a&, 160) = "jv|0X9+v58av-tKek:m84hIWpqdh*r61duhLG{(sm<}<hXYOW):L{YD\U:*D2fL9+9x[Oe|hOcEn]}r]lNmOZ?-K,KbuNh[6^qU:R.NXQ19jrkh5*0a}2sdmPVcDUup*YHCk:JQ0MgW30DVv3dF-+?vJmErtjV-J": a& = a& + 160
    Mid$(A$, a&, 160) = "3LA+X{R{,09WwEaM\Zrc,a*K*7LM'kxfAp|Cy9=?G7AMFOg|XhIuMtfl{5G;mSRQ44\,;yngmfeb2?gOoSwO^F^*WfAJx?m10'ZP*kKKb{v(68pPU)q2APW)Ni0Fs\BjOLl4\Jg3CK(}Wgy-d?pkZCWXjX4yk_Lw": a& = a& + 160
    Mid$(A$, a&, 160) = "/Ck(BOE2RgKc,qY.Z|1w8{:4zSMu\=b0ZpxTnOU4KL;O3vUGawc/YC,gF=[o4i>+3hp;540WU\iqxoSo(>iCx<[:YfYW8b_PX/BOW4n;z8U;<:LH+w2.K,GFxvwG=(Dob>^9N9lpWw-+7p.-/Om<Sgkjj997*n[d": a& = a& + 160
    Mid$(A$, a&, 160) = "Wjjc5jMc9<<PpE+dW,[gIYLyh1yX8xy8Tf-'byHLkma,o;N5,a,<lQcLeW,TWtm{VKP\5k6?J:B)p>O>,Vtr}]Zl:E)[.Rkcqj]'.kal,<VZdT}W\d*O8k*-\E/m5=Z3*Q5Ya(uXzi9j2T}x_u5'D3F5hj<9'r/J": a& = a& + 160
    Mid$(A$, a&, 160) = ",Cfg<;_+s]AD{kxDD:Lb}ESqQjoOQz,9WIa9L|E3\0m83svvqnM9YKnt?([<Lsg1ggdam|rWdKI)P5Dm(IwlP1u;AbuA?|.2?dMu+[5^?KOUdY90_X8L:g}Noup2M1R.f0IFa5}IzQ7:TxHfa=VctpA'ML^f,_2c": a& = a& + 160
    Mid$(A$, a&, 160) = "'k^HObpnuOYKh[q|HkddgAQnz]lDs.T'<j_TU*g2](Xu1{o:5=+>[X^zE.82;xJq\(80cXsjSR3w/?gh96Xbk+S)dk/qJ+}bojY45dVtO]zWDguJpj/IjIHi8.?[+_<xQu|J/t9]ZZ_ofN5s4]Bzshx^FYReH'B,": a& = a& + 160
    Mid$(A$, a&, 160) = "xwQpWQnTQDUd68<6n4oDUb<HsS>(P_[)UkI+_61okY6D9K]Wnntj'<|)^{-?8yo=*:x)AlEWHhTq.qBne;l|+Bzq?I<k6s3^(>?)F'.ut(i0G4>]0o2[wN;9+P.=p:7=(5^5e]\w,Sp?:q]u1+T>s(-bYybDpwu9": a& = a& + 160
    Mid$(A$, a&, 160) = "olSZU4Siw)e/^m8*Ze_yYX{m+hi^_r?anrb({9R'YnyHC3OrV\kfWEKsjldsSYdNk?\UDqWdSG}aql[U,JFEubsRv6X63_Sz-o-j{fuju2VtYIwtOp_YK=5N[v>:;pH{]-9.=84ekE4FcVdyy][o{hZ'ojM?a46Q": a& = a& + 160
    Mid$(A$, a&, 160) = "zBgnahh|:QJ(iirY(io4yX,6SAcMxG4S[\IAI:<HbT>I]3FixF7hmHGTv[Jof?>RhZawXP5SiGQ{CiAnJEnl[QWYFt0_BUjzPo.8tD-BB-V[of]2_?bS1j-B'pPkurk[dH;i_j9|(WlUtM2{qp_;/gvj6a9'dPg;": a& = a& + 160
    Mid$(A$, a&, 160) = ")]V*F<ZhqK6_G2q6C2ufGiiY689yJ(A,[\U?CO\jm.9Ie3yk.D,ztv6nP:)3SW-4Y1kob<TZ=Y*R>V^y3ui,Z.]_RX*;F/z\KpF9UCmjBHUxr.t0F[By1Y4JS-j|)_77h2q9ti[NW0LFH8<hqE.8wecsb51?OeZ?": a& = a& + 160
    Mid$(A$, a&, 160) = "zs84{_zK_wlXExQ:z]mRpLWqORYdaHW2_B<\.06(hH<d=NujV7rgdp+)*>2^yOUfwon0jimY|lu_i)FEqZI5[ONxc=BEUGX6rePTMt0CG/aqH)Jqr(|)1g>0Lr<yuP*Iq6,N^Wr9exdVe\=1KmYgooU0mRASKAtk": a& = a& + 160
    Mid$(A$, a&, 160) = "Z',R_gX?+N5yuPN:[E[Y8ND[mFh:H){7O_1eRWxMiBtGCcbKG0F3q4SZK'hso+cYSWsKSwSj;8Rf,FF{mVRycidMtE}mnH'vBn>9'pJX?Lt_K+YW.3au>1mi-AwR^6*P//4yLbO[E;R[:Cpd(<.Yz+GbjQU:.fuZ": a& = a& + 160
    Mid$(A$, a&, 160) = "GIa(zM:bZ(X/,RM>mu'[w^3yY0H6^[TNDiAL+Wtj),N+S6/Ai[3Uwy5(z+tj7hRV,B>T4O>I/Zfsz3qSAMlh(hV3ZZ}zblajOjaZa)bQ*4hb>JJhZ}9Ffrh^ehGz:};1n0cAn>dC3=j>6ML.Bs4v3ysPzM+7x]*M": a& = a& + 160
    Mid$(A$, a&, 160) = "+4bFAp[F;+RuUiT62'|9pBMBqZm?XgSo'o8DPG]hOB1GQPcP)7_F_\6-=y?\vHmA'|><7NOc,8f[n/_3FFLSRA('-zzstx2ZL484_en)?:A8z0uHnW=wb}pO.dMNk*NDZaj:HNpN4u;gMC(*:-:i15W-iJuDFR;4": a& = a& + 160
    Mid$(A$, a&, 160) = "Md?|o\H-\eU(iKqvvogBn1ALB<U8c6C;259)Vg/^M/orjI+lp1QYTTQ4IIs>An7p3p/E:R3VcDNHTRml_S^K|2E;qAc.QKbvD]ATpnk)Qr3_cGYrPLL6cgA;gw:uUv9\+eKI3-oOy5MfwXU:AIQi{[zNZ=IZ>XpY": a& = a& + 160
    Mid$(A$, a&, 160) = "5mn><qNOawH22ZlTa_6aocq8jvT79W+2*l0Qb3.\;Cs|'qWOWN)aSF]N+vDO^7]FxxuHuX<iY7ouTy.QqrgyTHw<VwM=o^y}VAM|B3pP=>*TD-KVn7lZukkU+PdNw]kdevul-\L,XYvEYQb=[*G|Wlg.[^5|]|,p": a& = a& + 160
    Mid$(A$, a&, 160) = "pC:C5i5eghwPAn6<Z=PZL;gvRczX-9|(JWf]+zJ76rE6:8zuc[EGVU4otjpGY:7PO,dfeB.NW1Pm*5Z)bc|a[+SC_'E\VU/CN5Sqmki--;]GE)<5oDqw^*:Z'z05x]M-{CIf.(i-*wAtwkfP|uK3YxN(R\]2mZm4": a& = a& + 160
    Mid$(A$, a&, 160) = "8G4_rpIDlI'zV65gQL')vQ*(a1'{}t3nIUVrN3(wMABpM5+>O{F^p1e8N3Biok);>4E-LomESuGfVFH0C7k5MaC=YNRZ>.buqO}6s2x6zYR66DKS)KUpx*3rE^oI/vDQrDN0ZrdIX4?nnYb:yaRNgBJAGrm)be;g": a& = a& + 160
    Mid$(A$, a&, 160) = "M7;L6b6/(pyvbgr9gbTpf-_O^k\-(2dN3R<*,/Ncs\:N=SPwvrdng^EMU;('FMQWG4u,K0Alv(,8=*]|evK+*:Nyj[,vG1Z(zlI3_K^^XVhrGu?Mug6:1DxXrD95|TsNH1\b'd_0VGavp]01)+>tUXRNld:IJR2f": a& = a& + 160
    Mid$(A$, a&, 160) = "dd]+pkW6;0XI1{yC'Dv1l+Iz;GqJ2'1P12qFUIiG,M_Ow6]0A;s6'R5{wd|3[^Ho4xT[admxbO:rQntjlWs4>3*z;:HgSKXPkFi3\WqcpyxkX4d4Bdo3C7ch(Jwf16Dpzr-]k74ho7RJgps-dHtg>-{Tu*K4Ad9k": a& = a& + 160
    Mid$(A$, a&, 160) = "2ya;,DSCjIwLHr_ZU<QlAcvx,RCp_WuN5J^7,/{]Uz3D(el*pt2lP7{E.fmG9,Cd\l?d>L}Ah(l/1TcUWA){-Bx1A<gCUo/KVj8Z.2+*MIFFqrwB{3-UcRTx8pxd1*9gp(jQ>bi8)4RwIwrX2ur5:Te,qDI)c/Xo": a& = a& + 160
    Mid$(A$, a&, 160) = "(X=6m=?bd_.B}cC/.5q_tdZEgb8r=6gaKtiU<DEx:K0tO4gQlt8VsSb8pY9TolG-?8W\qC9B*0R=bno<2p0V1{h?;2-v3A5qyh3V.)sE,U-/gZY^'4_2xZ'I6LCafjcFi'0r3B7043qaTH;(F<NO9o35ACHHaL+^": a& = a& + 160
    Mid$(A$, a&, 160) = ")J,3dEX.06?=G>2^pwZakGZU3BxQFCE(tE;-p7/jfq1eV.=XNJgu8_;Y.Pv-Xb>DK/KYM*:R[ZZ;,e0g;re7lJ91;KYpyHg:ar4zG.ohwzzDw[E8bzb|PV;Pt,{Mmc/qv8_GM/evr.P><AylCy8bR[E.ri8ws>Ss": a& = a& + 160
    Mid$(A$, a&, 160) = "o,h6'|Il{f++nFB|/[am?<|=kCM^aYVtTP6LcU)Uxu}r_9HEF}YH:2aTrs>C|l5NRRKKaa:R)}}WH0GbQ9N7ELotPKxb2n9o?Im)9e/Wi+>:u_Nb[0*Ak-'}xi48*e>;*|iU6_R}kk8E|95VQXmS,2cY'eU.6DPG": a& = a& + 160
    Mid$(A$, a&, 160) = "[a,wqho.uIO:e+=Vg^BteO/(|RC-X83rx^m1'b4TKJ=q7HW,g\wZ6(o^hUGuRqH6zRKthJ2hXr>>z2tc}FFJ1svT3dRlr>wujT[0TKnGU/bs8[zdnbXZN*[IQ.)lkNji|8qoKB<F++O1wt'b)B\KkEXRg0Md>_Of": a& = a& + 160
    Mid$(A$, a&, 160) = "*V{O2EUS,Dt<Qm1eLAS.Fd>LPwB*pEdx8*'y6UR+I.bZxck[SVYkKDTILyeZOG^V7hvKN:z(<1]9OQzQ_Hd-o9nN<b[LXXGULz10FM1r7vJt_zygTm>^+:S:v4y_n*V])5Q8<^cfYBO+LSIY,z]g:tnNu\s{HhOJ": a& = a& + 160
    Mid$(A$, a&, 160) = ".knjp}P{JrA5D+LuGCQWY<Jx=\0aLVOROwrbY*]=KN{ec>],yrRH.iSn]xwU,0DyT:5vumH783:vnx,+b9-)e,ax(XQy6]y(DR=xq=<D<PypU7pB/jLxiRBTV5U<I?3r[{vsj60Ks]OVC:3FseejSx5V1{0i:Zl\": a& = a& + 160
    Mid$(A$, a&, 160) = "=Q1uJb2QYb5>UMNm8SSb=d1A}cP1GSXLlaVikQxx5tTe*zqYmdAMi.tKlHj=L?J2tsK?CggUlbait1o'nv+jYkd|UjcK\a0rUt4_HFKRH+[DWf:[L=rXkv{J9l8ZUe<Et3x-a*P|5w/3zzHd}EwGxw1b8Wk8EziP": a& = a& + 160
    Mid$(A$, a&, 160) = "/dC3]0^j-\eD2=zNsJ_yKvc^ntR}Q?tYEA:p[HSia'MR8gRF)D*]VIr;OYRuRcD3N\bnk(eGR}O]EtJ:_iH{/kFtH[x>PX_MLkiw1r_+-B5BsRS\<ygSh*ESzH}CySw\smV+U,v,SOV_KOMH?)^sZL;/Ip=qb=>s": a& = a& + 160
    Mid$(A$, a&, 160) = "0u\nX<[d*U;y8.eOk'mu+::P-I+WAi[9F{o1;HT1(I\*CEPcNi-Ojp]ARESwD/5g,QP.'|rf6L:]G|D*?9I**3m?.WdW7R\20=|7VA]{W)WH^iVZVM|+wGHP9o92?/>hn96AX+:=yQ[az6I4dFCS'Re75G]XNkum": a& = a& + 160
    Mid$(A$, a&, 160) = ".41Vl>2[ras;r4.uN9U31ga\05_e0Hw*8)C1J:L]u;8kaL3O74gNzuJrjWZ5GIWpJH<y2g=K_d3FRGP_ikRxym\L8zDF8HGQJXPT,1y[sSneKFtN\jRv7opU_sBU8UMs=_99ztQ.6FtZZGTPfe.>-6{nMrUu>cS|": a& = a& + 160
    Mid$(A$, a&, 160) = ";S4C/<Tq7lKBgAgmTW7V'?hxBhGD-K4oY=]Y9HygpfY/>ceaetzvcCz-6Ce[eZ'R{|c4.<A:FuImZJ>7zCrI8.rADhuR)xdmtUyglt;1aDT\sTyOPEL_4\C7yl+DyRMB{4OeY)W/Yl4v+[oUEYpU8S{;)^QIZR}1": a& = a& + 160
    Mid$(A$, a&, 160) = ",^0ZNWt[:VkC]m{uYBDq{p.,\s/L(A0\<N*>]x{+C{+hhu*2hO(ogc3*Mx[(jsWYalnz]^ck(?[{W,|8wzQ\:+1vlEudz|j8Px2=K3nMv:8iXW7gIw{r5C2ldl]n:N8<}G.9>[^rf]uSv8*hOLk{Ecv8yU.I9fzU": a& = a& + 160
    Mid$(A$, a&, 160) = "L=Ix=\Bgos4*RUHp\t_(edD9>JBTEg7RPG]}ruz??\F^nK<[3klc+{KhjiX+n<liezdnC3;4Et+a+0D7rCNI>g=+j4NXSTNWULh.yXLj|2\YoydB_|fGPJ)xu(aptbLpvL6j8}bo<Uj.B>Rd}.*?JC5E=X,WPEtR": a& = a& + 160
    Mid$(A$, a&, 160) = "kTXrIfB.EFu,Tbt=NoA(6b^r\8f[u]lp|hl;QK=V9aZsr>,*Bi{f?;)_oK}\h6ddB_>U68b/YRPUwTD{DY7nsHNXqGQztcV<X<M^Fmmzm_3*[8KuU.SVzg1\\wss,mof9UzB<-YU=Lh0cpT(q/,1JA.B_+F+bFMh": a& = a& + 160
    Mid$(A$, a&, 160) = "/9N4(03G^9'r}Gd*=HF}PRb3a5UL^wHaHVwGi/wC2P/?Vh,XCqnma/GHC='Q7TJ?j:gqTJ|/K35WpFBQl;kQQVS,4hoUig;DC-_fj323Xpod^0;nrcTw5KlrJuhvt^]vQ2(X>Hh9qR+OtY?q+lc{EEdy8:wKve)u": a& = a& + 160
    Mid$(A$, a&, 160) = "uMrA<JiNF:yU496RAb*SA_hpzh?wJ<QW-,=xM9UR}u*)d(?.dVs2*Rh<vw,I5RG5Ho82Wl}=gCU>d}g\pxR_Oknt{7'Ix.Y-f90S(Xvh^pG8oH:2KBk8e/[981<\6a1^_5Aa,+UjPul.riQ'8uW}1>5'[/_'5F:M": a& = a& + 160
    Mid$(A$, a&, 160) = ">cuGUr^D'd}d*LK'mUU+c\82aH\Qi-m+3>PT]_xNGGc?:ME>8R:fSlM.1V5ELhTq1Wzu,_Uku_}GJa4M)X<MSf+fHU4fljZ5by]TG-ElEALA^<duv4+9ZarudfyMTxRGLPg?km}So1:{/x7b\^_o-0r8S_kxf49C": a& = a& + 160
    Mid$(A$, a&, 160) = "kw1SUP/eMO)?1fi.y'14[Dw2nLFguM7gg,N)UMc?x^zGcuaQsdeJFL,2W.i<OA/]?zJ=IILp,,ND(OH;'F>8,wzZf^A(6^[*T6OZigl=//96fPL,0b|7L0,FZ=>80H^{FAK[.e:=)Y2VD[rvmcy9>Tiq)Rb,;uf}": a& = a& + 160
    Mid$(A$, a&, 160) = ",[ux7-6\W;RM*ug4K3vx.O_i^4dd06CxNaxhC])J]bp+NmWA*,rW956oP|e4h2yvrP)li]Rzd9mDD]MJy)GWfhjStA;^jBdcu;P,7HK)Kcb?_^5WVrbKhe2D(w}62^EXO.mz}\hobjdM*;62IDzA},y[{pIBlU/*": a& = a& + 160
    Mid$(A$, a&, 160) = "rqPnC5g_v*PCT[wYIhcAu4lW+pv[zZ(1V^7\*-B{r9bBE*HsDf2Nvf={mdL4zj.R2\VCsrmhu8x+s<vb9m_q14T4g1]k8pyH8<_G52Jeh*FP1vetLn]S56B.}ST/oLUTv1M\>\dpwp/)JgT;Uer}gd8r1,SEx}7[": a& = a& + 160
    Mid$(A$, a&, 160) = "F)bJSLdrIZ*LnM*i5.Vnaa91;iD(sIh.c}1Z8y:kUffqs]uQhRyXb?/LeOvP}xX6ua_hpm.:_*HBL,59j?MMNVcLO(Ny7.'SeF[QjRztwTPu4cs/No[j6V8:fU{5Q[>b6'Htd_tG7A*X\RM]e}3*dxl\GRGkFsIz": a& = a& + 160
    Mid$(A$, a&, 160) = "th788hb*n-2\TF<fZvsE[VYxqaa7j94Od_pe?==K><Pv3MjAozVTzNwtMRf1,eG34(ti2cy\Apscu<D[K)Vtbzg<egrw^0*k>f?vTfE1fEMXULa6]')Szp_xjG;l;'*lX/s+qlO.jnm{:SHrx;k/|ds*[Aa5QrLY": a& = a& + 160
    Mid$(A$, a&, 160) = ".x[^tPpJiEfss;o56JNBen-,P11fo,/K}>DZz}'^P^M_eif8_R7*nsba2,aPD<ddYRnLxDQ=aFl;3oAQ_?A796:,-m3/{,}dSdJL/KY|n3MVFb|L_5kIFORfsZ)1^vMgGT_*ks9u:q._C.I7sox[>8g+>h-4,.nc": a& = a& + 160
    Mid$(A$, a&, 160) = "Fyhh[}0Y+'L;pqFX>dCYk^*U}ZBmNY_4'+TfBl8xHfDsp>)mKS*7o62J>UX}b(tS]Q_JF]<i98zNfq,xr{.vaYzhGU'*SxB0hvXICT+ZihtO*6RxC:Ko;rF^S>\W]}1/[+tV,3{K3tL)19k{3'2.B]jjOEE/{-LE": a& = a& + 160
    Mid$(A$, a&, 160) = "4R;cdFKLuKA]/[=lSOxO|I6'Me9<H*D<hlqcR*LJLvj<:tF8s224B0>Rh?H|XsKAIR;R^MqI({sAF7Pdwlj+r?CqtEh*n,:Bux;vwSrJE-yEeC/fD6lcwHK0|)T<MJFfqIt^Y?P|kgx^k^vxiJB{Bvg6iUHgrhc,": a& = a& + 160
    Mid$(A$, a&, 160) = "lEOXr)BOrdjS1u9g*l*9W>T)jGRAszU3{z|tOH8(W9.h9COAU/,qqOBTA9XRVunYP;L8'mVk{i>?c'GIlW,9=aEWkjqM]||?Io7v.YIM2<Q(Ni|i3QIHvN>HpJvdnw1;3PlMc{JJOodJ(eml-\Wc{_v?.ZKSkc0\": a& = a& + 160
    Mid$(A$, a&, 160) = "vbN2qIsBc)jqv|_MDh9'vWBO^(8WHg]8:3{cWPrd(ozGA6EHJO|_|m|5iU}hco|k+Cy;0,2=EVPBq;bs8iIhjGrv2'eiO8*;dLLNbY9Vd{3IkMRgi1SM:t,9lYJGq,Cf{T2W|dtV32GtR4t3r1H{Mz2=c-N+9wa*": a& = a& + 160
    Mid$(A$, a&, 160) = "YpsrVw5N/GYcooI6W_4,aGylbJ:gv|DtvweDgFe{,'gaozp)3]dBW,HqF?h?,f*0=YEz4OX/k)F;xc}\3I?ti9oaa-f<l-^be9K?[pQzDq.j;qN90\pHbJwk0dKQ7qCe18?w:*qZG.S6vT|vr^rHc9VmW>>B99FR": a& = a& + 160
    Mid$(A$, a&, 160) = "E;Pb<R8{-txXE1ISW3?djATowKbvep?<StW3wDpS)L0xLNWl^\g[.*(mGU3Ev[Z0^A?h*_R2[3aH8k|.a1n-N|-jPKHn|_Ky^oPApEUjOapLmlhaRmT/KjF+JJK}ZZ2ZAh{:3vo5sNikNn^6i.SB..>mu)-jXm>\": a& = a& + 160
    Mid$(A$, a&, 160) = "mV<uj6c0ggY;S)[}RleKbkG/f/2R<T<sLGGS,c>J:,w>_zpkbG3rzY_EUKw<4EjzaK9VBi670SnjbD<Ex=JGC?7hH5>yizo5D3pd.8PK[hlHiijXIFS;PdtC_z;k}WAty1s.uAke.8N(>]*5oh^o];pwPThMW1I|": a& = a& + 160
    Mid$(A$, a&, 160) = "jho<2>QL.q[H];S7b)?05RGv_)c2v-IEnjH3.Zxl|2vRVO43C)|Nm(}'y=7ZWs\;]LkP4>2^Sb0fG^{fW])E}H-pA0JTV5Kp7Q>|GoD4m4Y4QImb1z*/om[lnN2;>qUx3M1GKntf.5B+_aGu1YdQF.ct:[Xu69YN": a& = a& + 160
    Mid$(A$, a&, 160) = "6Rjwhv+z[=abXn1JveaLco5LQx8u?^bf8hEN3]]JPU91:p8[0XuZyX3vXZFMGL/{:W0>*=-kzc4|],zRZ+D^]'nlza>'^ISm-?^Y/>Cp:rrG,Bo^.=|U>}V.x_G_aUzI2)I[*-AgW}6;7:kckE[ym[AVSi*r<>2Z": a& = a& + 160
    Mid$(A$, a&, 160) = "qLci<uhPO<^*b30\Zbnq9;)aV(+0,c.lZO}):V.W=35)9\O3X;+]1C8KjhSCCubKm^C/F9pS{hWSFauvUoMj^=_30x}:;ITAUWYEyX5F|Wix1;^Xng_>0[}ycxdcUCUA1?m+S_(|DQcp?I\\\?+lq'aZ:xa-GdH5": a& = a& + 160
    Mid$(A$, a&, 160) = "\]N{I|P*:wFv4Tk=_2LZFp^h^]z('tPeC,E'RT[dx:aCeet?{l,.(|k'\|[uhF3=.\nCDmX5/pKQy}t,[Qisf4;3gRWmorKa+OnSLM?ISL{:C>7h3:Z|FrkZUT]EL0j'k=je45DUTKeaF3*ZWvO8J3<O'9HNqT?g": a& = a& + 160
    Mid$(A$, a&, 160) = "e+T>ZytoX6A[GC,tZH2YJU1HEJlU_3Gh->Olw.T2>waxkxcYa3EKdl-Ni3VOnzjoMd=ImERI-7qA98{DU5?-DGdMb}Fv2HboQ}y<7O>6g^'z4jp2jH,O]>sL/:Yq^U3Yo'TcQ)[\=+Z(.wV}g/fZMMx;F8Tp[8Qa": a& = a& + 160
    Mid$(A$, a&, 160) = "KI)IGmc;/Pf^v^oEwSN]p5]yBSbG>.pfAltOP-}{y,>,^4A,hT+VWEXigzjdRwSVb(R6D,^d.8bknq;qwFnn+3t,,vFlB][NKJgEz8^g+<K<>dY]>NZgPS[AyE)0{.MY)}5U>PhDVy.:dK|S:EO97sPMofu}uIRE": a& = a& + 160
    Mid$(A$, a&, 160) = "78O)Sv'SZKCbG|jj\xuXoy}5v8p?-A|(hu4YRFP]7W-PFJ^_GMLHs06jkVOUGVR(cp=ntt*razc;vT/2D1w-T7q},2d5,YZ5wzrvKel]5'9<_:Y9[5^^G4]bQk>TshFHM1GXZ+=uSmh{fbVA=na,b8tcMA'ObC7L": a& = a& + 160
    Mid$(A$, a&, 160) = "{I>il|DJ-zr.hObE1K)psTeNLK0bJb=a?hg04RcF9,R-H7^2:.qp,;kOj/VuL['>cE?\,qIpHF-hNUlzx>]3crc>Si4z,hRk/6g'LcZi?s-Cx)<D8Ya_T8mh/wC]yp:h9Xyf7mfYgOF7gs\W*M1PMKx(B5=KA,0u": a& = a& + 160
    Mid$(A$, a&, 160) = "wxROi1X>+:c3A_+J1pC;?e>^(cm97h/2]4.]i?y\WTsB_.5Y?Hj_dA^m_s^1_/|/ix+*xfOeA*<]hueeFA3\E]VIl35hxK95F.q/]dDiK6*t(9U<HZczn5jqFJ>wrJd9{{,O,8u)v1E1Z_Tl(_zN:/2S_GHmnyc6": a& = a& + 160
    Mid$(A$, a&, 160) = "hypLbKfSkmBrvhKVj'cZ(92HzY_bA\|2K]20BLpJ1Egcb(8oP'lxX;upkEUMOqxld+iyRe|B5+z]L2FnGg.Xi75DVt-;DDV*:htMR]8JzGuL]uz==Tu32jwLKI}2ruW[KFy6bXKeQ>k}.zF,ZThBgXrnx_e\=Q}*": a& = a& + 160
    Mid$(A$, a&, 160) = "BxRUfWaIHGYcymRns6szx0G*0E]3}jr:si2}ekO]{n?gaQFaKMZ:v?/bjyddTYxC}aLyAF'=q=k<fo:a,YEeV'>eiNwtzrC=yCv]8TeB>yv19CEn)b\DbaWih(H]r6mKk^X?U3g},76N[MzMrJvoM6{hF*U5jn5,": a& = a& + 160
    Mid$(A$, a&, 160) = "wnxg^n/9Fn2w2_'<sQ1rGWe-dcD2yB}mL|e)Sk.>cD8McnGuO6l+LjAn*Js[AC_ruIXJ)gchE'UsCbhN3YYO[p?T|w>]cd12WL,l*U04Gli5Jrei\19v^S,*Oi\XclK^H|hm8_p4.aR]Ng8B1k*TkNa(iwm,.h7h": a& = a& + 160
    Mid$(A$, a&, 160) = ":x*SR'H[RM]ojDAy(AvzJ?_MD;x-]o8REJk3\YqlR_-.m=;w,.Fc+K8;3Y=-^amA]3j8w4(/aA-qXj_;A?D?Qv/IthHH^{hT;|k\8Tijm+iA+1Ynh2ro6S\]Jj^/xHWqeg1^cWqeP:owdlv(r8T(:1cJ:k8+vYTR": a& = a& + 160
    Mid$(A$, a&, 160) = ")_{'\Uj4ey3cc8KGMSxyGjN+,,U*(:'MCQ5Rbo3?FlRdOs,aJfm<8M}7[?-BhTtJD;xBwCTV|ofoUM5*:BD3=|+\6S|HD'Q+Tyv94QieG/NfA/0ucPYR\2qe=QbpLT80U7{XPK4cqh<||T;J8w2.tZ:2?sMb>jCQ": a& = a& + 160
    Mid$(A$, a&, 160) = "^\J>UyCE=il':{cK7XTR3Se1?a^,qiQUr\Oe?YBKVOONbSvzU)kT;q}^cv_O^*zWhUQ['isIR\T[.wsxhLTDmCa1WF?0lKl9j{E5x3[4iZ2\95G=Y9m.H6FUC;/)LMBd.+YhiaJNbgtGy{+:F=DFQNH]0}w44)=A": a& = a& + 160
    Mid$(A$, a&, 160) = "iQCYT9Pk4l'61,YSW4wt80/3Op0}fq:Z)RLL=Kq+R((3]S8nU>paFgQ9A890H2oPw^Nw933Wx;d|[k^.6>_3y,QM7Rd<X4\m([nopf/jX2I}I|l38Ewyf4EHuUybBTe84A)54rxz.Og0^VJc89ipTRWvX5_OBl=Z": a& = a& + 160
    Mid$(A$, a&, 160) = "1C5k|cm2*Tg:(AFBklH}3Or=)e5peKikDFT,OEBy'g\/MuuK\dZb3[<sftyDwa)<J<ve;OSHaExgPx[[Nty7dH['(|._U-,a>J-C:,,|rn1D|zP^utrHBH9QW)gJg^N3Q5|]k0oRVX7^2,}3]\D*h3*c/XoRBj?.": a& = a& + 160
    Mid$(A$, a&, 160) = ",?^I+NjjWr>tJnyD)q6|a.H6D}96Ut-]3/H'Z9qqLNaP:S5Rb'qGL.Jd]LICjD/C_0y}'Sx;lk}:=ABdkH{sq-?C1kbs8HgMP2pi=4YKY>du<xq9G=J[z}qa{:>Hlr_j\[E^]yADw2cFX4?XC)a}GhRHU>4E0.VX": a& = a& + 160
    Mid$(A$, a&, 160) = "uX=)MZ7;l7G.DK(C;/z|Jar6LLbbHzF3g2Gn<(F+K*=cPW43pzwj)}sx8jR)}0\wC9K'JRx[83QkLKVZtFfJ5t'x;,r()KT39om,\mWhElsSI^VAe:Oni'14[QkT}=I>|louZarF?9f^gk<OyqZ26u[^fqIAyqd'": a& = a& + 160
    Mid$(A$, a&, 160) = "KLGN1qOCli)4feEXEs-^}N9n_,7X+S12h5ys?/575NB/X{C}hl)g,T|+z0rd[Jl;l8[\'0JyTb3_*7j{FqaI*,epZ-WlfZubOY0BtL|/zK-]I9FQ_T|uXCZ{0+2FcWgvT}PUgwacHDL?{^YO'9dSRmEwyGX{jC68": a& = a& + 160
    Mid$(A$, a&, 160) = "XAu'''p2zR)i{:B;slg*SC+Gn;=GbB<bQ}ojc/nhY0QK.h8>uoiq0,.eyo[-j5f.1yZ>z{5Y?xYxmH4?RdGmI?bATdUa]hz>]:<OV1,ikck?kjn3XH-BswXEs9T[Po-^5YAMg,on\U8[Oa<9Kpqeo[rW,-wm;b5+": a& = a& + 160
    Mid$(A$, a&, 160) = "yRE*NgU{u}9)PMku\X+a.e'oO]EIRZ/An.Z.8A)tfdZ8}6\VQjZW2ck*vJx5w1e'|YvDDz3SN2C(8D7yE',)(9+[d;,62OVF2DIIyrUJlm2:z[cuH2y[[Kyx7R->{+p9vmWo59RmN1to{HU42m2jc}Ag?L\|.uz]": a& = a& + 160
    Mid$(A$, a&, 160) = "*vS0v|Y(WkgPF,;i18TlVDbVRw<<mQ7bi4,^xg9E_?DDKOCI*I,,-:8fW6,tcBofuyE5+t)IA91N*^peMmaeT7zL'fFdC^Lr+zqfG\qnKvABuGiTh-*0v}Lt1=ZJiAX299jl6f_g,u4Vr[unm{z[uI7jr6gDqluG": a& = a& + 160
    Mid$(A$, a&, 160) = "-Zp\4Q5\W4UIzEpUqCuUbq};f=NKAnyy(IIZznFD>3.TD1D0\:NRDLw]DU*g2hI+y9+dq)>+7(:/yBml.(|T_meI,:D1;uq<mExyh=r7p6b[w)UNfLr|Vj[,;o-l9_xF|1rAXA\YB-8DFhR;nXs47xEX|[bCFFWi": a& = a& + 160
    Mid$(A$, a&, 160) = "Mz.Kp4BW.FmqrS}_vQq>Bvv(.mbR426OwPm/]seYij9;_nbZTwZ:Q?|.gl6ky[5'dyi/>Spg?m9+xyD/pfcjWlv<66}2I?fJm0U7\Z:F3wDM>\<IQzq-fw5F{(0FU?8m'{/PSX9I['M,y,u8oUNk(*KsJZF'6='d": a& = a& + 160
    Mid$(A$, a&, 160) = "*e.PFJ3l?>nM/0weVZ:2BpF.QLmjflQa^*Ulud<PI^ScHK9Wj8Ohe'UDM}x.JuJ*cdieqo6Ydmkg45iRh?))9(>DBER^z/E-Ui1qc3K8uS-5*El0qJ(7V)+1/Pg/>Q6MPaxc*gosm{d0XFRd*C>2:,PfY;3j[eh[": a& = a& + 160
    Mid$(A$, a&, 160) = "c+.e)P6Bm)]*c.jXU2?a|uO8PaTl:D7:(jDFpr}vOXDpst0?C^_/Y+EOc}hi<qyzc(/gej2eNuA+wAOJ9fK:msb9|<z.K[]WI_:>9)+p;?Wkl+hw5;b,_.[kL>X.6]Q_|2,u9AzDm-l:}C9hy/HUny\y3X(|.)pi": a& = a& + 160
    Mid$(A$, a&, 160) = "SZ1},mUwvILCr2Pml=Oox8oP*TH5E[7;4)aVTMP,u](ok.fakJIJ(P[*oO{kQ.o=dbx]F);G89bv?4h}FpL>G;xS=8Q)l/EEeGNv|8gw7Iq.s|?Ay|SAB\A?pzi]W9CJU29D.LuL:?m[;HfVwdy|--ObxK9]W|d7": a& = a& + 160
    Mid$(A$, a&, 160) = "i:MI5w)h(ns6[Gt8O'Ovel.u21r;UuE>-Pi)8B]uK3:sluUdU4[D+8+^HE*E'W4,N0y>fYGdGq.wb<L^TbP/KE2xhz{xmJ/+i(fOg\-]Y-2Z4Y0yCfL:5oJs*pon/5,V:KWv63Qo9*q4Vyd-eFe3a\6Zk--=0gx7": a& = a& + 160
    Mid$(A$, a&, 160) = "RgOa<LuF.oGC;|O36g?S<jWo8e3cnV<s)A3]Tamo}YjaHg2SnP[E5uw:z2}\nki?CWf93y-hBF7QhVNgXIIHdkmJ)/vR;pE0q_S,9I|b8O,V]9kWAGyf32,-3wb2R4Xg-S5pwm+2'kIF<0oMI^jxxWgJ7m5b0OY<": a& = a& + 160
    Mid$(A$, a&, 160) = "WA''PP3:d))G3|ui(vkcmOF4dtSoY/+\imFkH4/Gj6FH6|Q6CNDp\Ky:iTVme-0SsOd]gblr'2q.VM+YEwjH]F1sWIlKc45;x4-(7swirnI/b_w*Aw4Y<jrbmSNSGc+5JXw.<PgY>JwZ?MqSk(,.Bw83MH\<deRD": a& = a& + 160
    Mid$(A$, a&, 160) = "{GT:adsfs=UdG2mBagxY\wbFV9Zz\s1IqWEe?fO.aUjplh(lPf>Mv:t+GbwKw^.JFxz4:?H-bRQgN5rSw1dHrby{\9nWn4=+nF8Tpc(<'Ehlx(Sku8uSa(a3^s'SKncpp1J4vP]QgPZCIlf)e>/wF82MnwOEyJ(c": a& = a& + 160
    Mid$(A$, a&, 160) = "USuEiquK0?c,;0\,t*]{(XO7yU:3m0<V}SscdZ[5oIZGAyV^FFK7v)'O^\7XwPKw=JwGF+Q<56>lxcF/w^/ALY0V=|,q;iWkAGNZ|NHQ)aX_:DG*zCim'JZUK_Fv?m^:_'xpNr29ww)B^qD<:>\0J{Rn5:ndGqeR": a& = a& + 160
    Mid$(A$, a&, 160) = "tNy|thVT\n'Oos\BdWNnmKPR.HncK..zqM_*BzcDyVuV^n./Q0vv(,g}dxxoYqUQlO^g<>fDT/*opmS1eDmG?ydl?\TkB(TEz6AO6pWlJwHU\gj+|{E5NWjNgW:zcw4C.}1Iej?I)iTnZ2*A_z6hXU{FIZT9SCcW": a& = a& + 160
    Mid$(A$, a&, 160) = "p4Jqo<IXoRk6O(R*ZRgo*2tffJZixTLAc?7pDD]PvQKvzG^bnEGA}7j'prn/?Tys3_2ZYt0JD3aqx:tLiw=Axd73ATW2(-lM]XUAj<U=N9e_>?0RSu\6cO/Wi9)^\+:ZI4R215sY5*p)IV6oo9k'Hgr(nuESw4L_": a& = a& + 160
    Mid$(A$, a&, 160) = "t+XOsJ?ri'N;^m:ctS4DNX0jj/ZE*1yacVfFc2'kSX9B;'RTMTNzi1vFHi3pb3KP3/IG6rYbkxa:n)ONt7?i':G=h(,U{xLNZRIfGg]RF^Ww4BxYby>xB5*A.j6U\PA;Ob^B0/h>QwVXiqvfH('PC|VT}D)'4p''": a& = a& + 160
    Mid$(A$, a&, 160) = "[QCWXusn?95^uNFu^u,HgYq<'=Pz_OpYwWajBehDQnV?sMSyh9YS\/RGa)3p*KLyn|BY.[s=i5'ELg[HHE8>CHPVIo-6/wpw*HO>Qz0:10lgOvGg>1mJuhOc\s<k'TLQ0pP+Z={SVcOtG5zsEy+mBqsqaPy}sLyS": a& = a& + 160
    Mid$(A$, a&, 160) = "T8Cn-+pC'v;:fB_2*(v1|2?B|8Jqx6)IRhuDAQ^iv<kc>1H7EcNP|*v:]'c19Z}x]NolGU_pzdUQ5T<U3(ID-r\)d7cH=dst5Nm847Jyh_(->M|E[P255X|-lH)rz<z:Rc0lCy;?>x}I+3lq\E,[k012SylrnC]s": a& = a& + 160
    Mid$(A$, a&, 160) = "4T/=tPxKB[g]McW7U{vf-u|t.Q[:c=o;.A-sFn2;,sjaMT83:A^D8Tgwn.9D),ubE<,(2lb?^|^hZ*N=W5VS-K)zT^G<pM4lgRpn1:9^;i4O=*Lle^V|wb;S3hZ{_AX]Y*xv8svuP)(;/^'CA_H-/\'\tGFgP1T8": a& = a& + 160
    Mid$(A$, a&, 160) = "MXTxb_jB>OFkN4+'O}^ZQ]As9=Ns^vCxkXzj-ETo*-ir6*.)5/+4i.)9w^?iar}GMrn^^Q/*.QS)2SkGTKx.zu8>T1FVR:<ybRmD}Sy/N^:XYWOnBIc3Ua:yWM188SO>cB'3zB1=rcr4\b,Kna{;*]gLvmRV6(gh": a& = a& + 160
    Mid$(A$, a&, 160) = "?nELzmKS9N_bwlvC5SZBlVl]fz0/cX?06pI{mW,*5sW;'5Qq]DqI(.xu65;gQlF(-v\V-1[p[c:_6xpMh7)wL{FVq)=D\-4F]mTmEgUNng81*BpuD_-?M,'c|VuJSp.|)9sN|y/mJxTKCt.^H}KZT\7,{i=gx\J,": a& = a& + 160
    Mid$(A$, a&, 160) = "pi5a[R<KRtoC.aLjwK,b[T*r?J.fzLWe4+ANd1H+1]U]^<l;PwI2RI'7-|M;{lQoIs)wyWuTcQiTBUC5NLaB2U6\/^,AbaJ1XW{\m)N<t'7aOM?m||7gqWc(8+32w]7N1,7>Kqb?y8n<mK1a{l,u^(NE'}I{Fii'": a& = a& + 160
    Mid$(A$, a&, 160) = "DMTh+F2Q(5E_ZvHtY}GF]qk08j*dU|tdCSrj6ycZW>.<IW(j)XLm/'/mF8zLp{/NU65S'U=*oPa/.H::|\U(x?LPg6,l;=n?8jMcp+p'MdVu-O,K.7Not_dAj:|J[(8E]/O1cMEJb;>1'M=7Vj+Hm'}o-*9zLtdV": a& = a& + 160
    Mid$(A$, a&, 160) = "K7)eP<Hj^OG=\+UklN=+Er?hV}0=;HChhX\NTMH077LMOZx\qA(N1|h/N4nL'9gs\wwE)HYL]/a3o\e_IrFIjm=x05jZ=KO(S=VH<-Cx]hK<YP1t2[)Yy6VNlBgy'?CdUs7j(=,tDY\56<M[*brMhUf,\Dm6]xHB": a& = a& + 160
    Mid$(A$, a&, 160) = "Dlyk\M;;TqI>y:1[vm,jSit?pK5bmsukk7Q*,tdQvQRaHBGF1S(GJNd>9Y_Ed>^\jR3F>LPj'W.)i3xovL,_;hlZDcCjR?wpwbusg*U2i6x|bM6Ce>H}bRE|UnYt'(+X:4VU\3FhmM8Gb9435TeYUQslaa8LD(Qo": a& = a& + 160
    Mid$(A$, a&, 160) = "g3[2ew3hfLF-Xa/D5,PkUFmMC+-lHS/tEKe1r{S2{=Xpx^FJGo'cie/8HjNqTt2FiiAB:b3ymQ2N2/fYm=};]gH=ECsx[b))FJ7ur3*KL?c=;1O(+.rOxktxXzTlp9s|-IkOeyYt4)/dSx.K*?d17MuEJYBFWvQw": a& = a& + 160
    Mid$(A$, a&, 160) = "Idn>|<Vf.Ny(va42C5K:]:ck'4T0gIgPYEGUW(/ua2<JFHbe[s8Sv;7cc2=3cFaK4i;l:2107e3aZzB2F?tv=5pMmCi1Ml;*[B0t{q8|{RgzT1Jbe}rA/9aWpA'6Q--cJU;stT/\M>4|m8<jNS<mt(RK9f;V+\GY": a& = a& + 160
    Mid$(A$, a&, 160) = "6W:;gOpc:j2>}.N14EoPqFcwUILMJR'M<W^0ARJHk(JVg,;<h'l?a5rgus}w+OwX7Beo'/q\.r2*mgE,9{,^Bf8/\e[*zxzM.wPzOY]8rrP/Uk0K0MARBnsIE\}Sb5]^RvUjCo8xa5^U)o6oucKZ7r1\>B)u]XUN": a& = a& + 160
    Mid$(A$, a&, 160) = "kGQsEl1zGn_G^It4PQsatdph]G,]M1wNW9ge^S=?Mxxd3(8V1NP0R)l+zjH{C[{8\pW4,4ZwUnoLe)rvP7UGS|cH{\iGL-\2a9SBkB|g;:F(eWV/I=rz;Q\=HC?X9WWes++?Wu8FZ<K4tlVB1.)}oIy_Vg/n<.=K": a& = a& + 160
    Mid$(A$, a&, 160) = "*N}VGt]J:^OOnEg5Z.E0]z15*HDIs4fVt'3)4r?njeS[rVxik'rqOYIpIDlzI)7SvHy}Oa=6Oa|pur7+7z\drPz;oJ3ZeEHSB|sSxIt9CbD>Q/sR]W,:Kmfty6C3.Q5H}=BwKW)<Qp*3hgR0p\\3QZ3'IFQs*EH;": a& = a& + 160
    Mid$(A$, a&, 160) = "?5zrz>,\S?o,JR44ht*+/yrg6pK?MFNJyQC8Bmw3]N23({6Sp_9DvX}tba7xa2zL0}wFQ(z3r,SwIActvW_d.TeFhO'G)IWyV?Vf\Fd2sOpq|Iv<a_c;aC7)G;ryKW\=D_2O|gF]eDeQ>?*B[[F8IkHDux<u4<1k": a& = a& + 160
    Mid$(A$, a&, 160) = "pWgCm0D>h9;3hlU->kD*>p]Z{+g)QQduzpyua[3?J5'tTy?at_1?5pzI[IQ[pp9W:>CL^JRf_B1+4qv^mz15,MYF:6\76;-xDg)ng'Ag3\I)/^y(aYW[R*[OLQGHSPOD9G+xZ</wJi-VVGv6OMvVe>|)VU}j*g32": a& = a& + 160
    Mid$(A$, a&, 160) = "}a?8?eUhZgJ;biIuijVpWpKI_wFtv(pbzK+q(Jesf:N*\+N6;c],p)TotBYMRUsLux^Y7w0o{2dM^Wcl1npGT3_njK9wysz1wNmI5:_e3uFEkygi-|BJ>oaJX-xQ,uR)RHSTSfu0vs[chJR9yCkI4|-DgL6rDKb*": a& = a& + 160
    Mid$(A$, a&, 160) = "i>7Dpl;G]-)ar0d|a(70Ml*e':5dY\\Vf_w^;Q\FyecFCFy39}3MlP:nZ_W*ZyoU'W/u,osg?N-kZ;m|:7I:K-['2;Fpb=/lFY,nYTM(3Gtf6Xj]YPb/zyrB1aaHQxGr0R-ek?p=A,:OvVi8-L.[+]hW5yW5<t(>": a& = a& + 160
    Mid$(A$, a&, 160) = "']2*NmzxCmjGxHaKs7|0?D:^H,z(QZ'PxeqhRQj^inH+z|s\M,;bxQo/pYA,0lY-H6x}p:LXEzC9Xarw:Sz4B>-j/3YfB62a5YSxD/w[5:l<OL2Pd8+Cpy-C4Jx|P+N_HHcjs/.AD}cZGap/T.<tOva7qe*ShcC6": a& = a& + 160
    Mid$(A$, a&, 160) = "0[Eh-*T/XV3(gKSpeOw+pA,L';bq6XtTESAW;+e:U=5mIzTeIW)g=daj4YN7-odBoO4Zk'>p?W,nahelGdUE4jnWIvg^}|;Ai,qd\:wW-/FEnF.u'R;9oGEAK)T2sRVg.MkJ>rlpi.7jH47;57x^sYa<Lux6FR)H": a& = a& + 160
    Mid$(A$, a&, 160) = "<+UoVI7a}MQHz6mI)Ni-8H+TSW^l}pK7iwQrs9I^k;Adiv()wvBJxl,<SGd^e(j/vnopA5OENTOrQ._pi]K7t{dWXRVTYo(Mz-8bcC9I1.*_,al,GjbPz|U0;pT0Y(G,?Lt*'TqO?C1MmY]6{Z)j4*bB4[x)nw*(": a& = a& + 160
    Mid$(A$, a&, 160) = "|=H.'(XOJA8Apy(W04:N1Ca70Xo\X=6Fl?G4'V6g/,.S5jEM>v==[\Xxt\sx*CHcW}8RMDamZg1>7X38FfOH>EoEnx.Vt((GU(rve?c-yWo:To9lom:{xfdJ5Pl[M:SfU^XF-ZEj0gz\{x7rOSC?qSR<0?b|K/{n": a& = a& + 160
    Mid$(A$, a&, 160) = "wme+V\yvu;mqj=XeWe+p\D7o+Bwf1l-FMp:XP^Cu?[')c\LNJcub^WKhDar(O/b(*h07h,IR57xLvqw\)2_6q(R/OlIU4,GQDYI4C9d_T6j3W1:fT{lY92P|H+8/lbe_y+lsg_k24LugR]eG4ea?O?06?PPAd2hJ": a& = a& + 160
    Mid$(A$, a&, 160) = "i-J1|vPjt*{A\K(ZcT95HzG5tZmEn'|EXQqR]:[zvCM07G=msdtUuKZ[s[1'aJ/,QPV(OM3z|320KU[i=lVIBjv0yQK/{/<p0[nUl>(bRYsj>pMh|VW'([8n>X}'d^tIS-i^TU_r_o9?.6wK;]:.ez-jUk\c?\Zw": a& = a& + 160
    Mid$(A$, a&, 160) = "Ds6O7Y.,1TJ(G1Rn;}IER*2P,G4I-|iy7AV*ve<_M:d,V0m?wcT>j}i1+V^5Rk4A+5:{gB3:Za3{;.S|z>|,)<m>oE+Q<G+DL1'SCA<p,w8QudCOIndi+u??CFXD|J*+Y;i\WciJ1z<ZIgBUVmGknTBA,6wwM>g,": a& = a& + 160
    Mid$(A$, a&, 160) = "\wge\ld2Y57>q*Bxe1+VPkMRWKTDGk(:1ujo\^pQTIJ2qn>i:8f:,obxsMy2=;*hf/4apad(2g:]D^Uok*e|k/q3TZ;gZJ3ko[k\i6b+>+5+h[sWcHZ^0FAgO,zRWg;vQ3=<EJ?[iGXHKdmmiwAQq+4O),sAge3t": a& = a& + 160
    Mid$(A$, a&, 160) = ";<mQw'Dd</JEIaH)*XLhHzw24}W/y9:o(1<*(7YiOe?oc_T?L\PXQxj<Pw=49:L.}7j}Ff-Wc(8>0w0Z_.ct5<t-2[*eD.159M\FQxSeomJW*JZRN5yW0As7:H[]u]iUw+1njyWV2sXsX.Y//wf:It4['0'6C1yZ": a& = a& + 160
    Mid$(A$, a&, 160) = "\31VoFNXUYC5G_uMrU_<,gcJpbZnykMm;B}wV'9dsht6+X*VjuZo.rE]Q<n>2h/Chqcv2LZdL3bE)uLKtE9g)|]0):4Yyqo)*;iOKTow5tjED-Rm/GMFf'o)7nu(mg]-x1Dku?'du:e[BEe:CqBbDa;;IU2qxRhv": a& = a& + 160
    Mid$(A$, a&, 160) = ")>mI7d7gvO8ki>qXLy<-;9.dQaum(jC;,z_<q^-VW\.ek/WS=G+BNsJx[Z8I>;28huG+|E+RNpEyO}Df/JucEQP2wQLUWi{/JK6KG^*Uzs.Cz0G6EkePd{-'=1GlFn/^r<TNpNI{MgF21A[/Rrqg_2h(>dZbqXk,": a& = a& + 160
    Mid$(A$, a&, 160) = "^L7c[8[JAZquS9.tVh=.2I6GGu{(oIZMc=W/TX66Fp'gdU:z<fiGrukKvtF_MQ+d,nV)t=;r{PnkWNcb3LISR9N;.'b\-Kg4h9/XEanEcmdVFc80lF^8't(SYmdR)zNTBJda[q*rDwM|y8+c<wfE9aa\Ew-vsD8-": a& = a& + 160
    Mid$(A$, a&, 160) = "<H)vjPYSR8(^a+4U5Vn6b5'igLe)15EkxKdkyQRE4uxLbBvabuQnSK?4DYBGY=vkINEWn<eT_YbD*u4M<J[<:crfEA{:yYh[nm<]]I}Kl(^WqU:*elDqBJ1/Q4Bt4u-x(Ha0Y].;uF9nwJo.-hz,kG0<([_wz]=[": a& = a& + 160
    Mid$(A$, a&, 160) = "MbDgb_)AI[5N9'*]x{6Q{^mu9h\{A1XWKMr-UvUC1dymwv1y:_bdZ(_I03_HIrBm>/6vq2P*z76d/I8y(RB9O'jN1Pi75nptt5aceze,\\S>|IyRv;ZaGZrFH>(Mv4yAWY4AVHMSrtVT4VlJnsioJTgs5^fdK^.'": a& = a& + 160
    Mid$(A$, a&, 160) = "(WS'A}3T(|+eS-ev6VQhN?46yQ]LKe<,<If1Q'-zI2L\*DIcL//:2bO|3^^z(2uAn+>,pV{xt<L]RIja}G4Y}L>W{0g=8R:'tW(tyb1g^}N'X*?9M}02PI?7|7EvlPqA_Tj1py3?q>D85JS?u7TTJ6mJtsQ=Ri9T": a& = a& + 160
    Mid$(A$, a&, 160) = "xC(f+*BrNttY)gKJ;^.;JsJ]?Dkjn2LJU^0ZpF><M_RVu{Lv}5TTJu5ROyKal_//YgD0AkK0m'x7/f1or</cFk9fQ_PgJ\A\6?Mb)yTpVButvl4VYO?Wj1O>^GN+Pzi}rcY7TCm2ZjwJryS=tPzh^pa5c+|khI8u": a& = a& + 160
    Mid$(A$, a&, 160) = "P)rc*-Ln<}3BVvl/hkUk0o?=eYQ4uj|V*AGzKL^'{F:,cdX;l4;bH,i5u0m{1Uy/b9(hgO=HMw,CMlkKrcx79xL*j{Gwf4}Bs:oI-GVUU=zW{5dM{{<y[dS^xr*K_mXZK[ArntwnJyWyBpD[}ku^XbDS>/j3TIJA": a& = a& + 160
    Mid$(A$, a&, 160) = "uI]:(qpHR6;B-GccN*hGtlmtvzQ>XAl;qS\7)r.9pqhCR|vD.wrSf<-RX_W7bc3nqY4;/HM>|uze=T(JtcHE^,dd7BC)zNKeyp*NBaByv]+QLYXM<TV:q1uaLCPDNi9i:+<9,u8x1f3J\o\<}sWAHALc)dG>-5T6": a& = a& + 160
    Mid$(A$, a&, 160) = "ObCh(l_MS[5;_>zU5E=Lg*8<<hIwY|nWFA,34R>)(\a.ZCgB,Z3t0/)X5[C=*2alwF\Xa_=I\7aF/Y0V6]:F^a-U-CBvDm}JPPrkHwgrY=n7Ew_Yjs]ED2UD9NJ2BSi>A[-Q_s'V{,._/fj7\hZq:LQUrtt;aM4A": a& = a& + 160
    Mid$(A$, a&, 160) = "egE^5pDvoV3x>L7*+F),cx\?>38b_w\.IN8n3^*nh5vH878zlVC<-;6iAAE^k>'od6ht*XpAiJ3Jz.)mgjC/4^fYtxg\tG*m?4T23lWYeEawyR'>:u}{QpON=-,eV2ND^*;>7M{ri+:aM1E8[.w[4<NuVvW+lO9M": a& = a& + 160
    Mid$(A$, a&, 160) = "ZtC{9GkG6ozU_[TcPyT(<Vp_nkKpx*s.fSA2swE7SI<_ESpp(MB.O11FIZim[^ww*A'vN1'L1YuCLySOT<}jw2z}\X[E,JvkMZ,=ZMjIdl0HL3>MHwVF2Lt{(dA\r0nU;9B7GNa{c'p'VH)|Y/jnSI2f-kuG/Qub": a& = a& + 160
    Mid$(A$, a&, 160) = "dKr'iQ-Z,xYFN9:Ls0;awfbiWdK4tE[qy)k1Hv])a)yglCFF[m:3h>Kow?<)Pw[5VZPV>1VOBnmR.D=ytP.Ui/fdv.[nv6?1EyIj+jWt/PqO(*\A7F((Uv(W6,r]gvZjeclW1,Jf3gK<nSy^ZEMPIHkH<dp1p\kL": a& = a& + 160
    Mid$(A$, a&, 160) = "j(5{M|YYK=r4LkRs+-C^-6bg:P<XWQ.Ee6CU:iBN;sbo]^b}LTIw)<sZFiRS*W7ZRHjW8d8nkUV]fdfU9?sE,I^*9'UoVpeX7iIYl./)b*E.-:K7Sv,]V*|5ExZH8,TOi{)PAp)+:7*[-W<vG4)f)7a>(m_'KDOh": a& = a& + 160
    Mid$(A$, a&, 160) = "cEr=/EMq)(q1J2wMy/dT}1B+rswKi^v4GtVg\*D(;bm/ERm:*I8){*whmjudXB>TTC4MPQb>SE6f/a/sA\T*dlZBdrM*}0NMpv3MW0'XXOV(n|Jt1'EWma|gc1YWLC.?OS;erenTZO\jKLoWK,[5{hW>6q7T</lN": a& = a& + 160
    Mid$(A$, a&, 160) = "VM;J,yzvzC,<[+ZsM_XHoaj7.gBoHIJJv7pL1;a)]GE<|;M?\|WyAibKUUag(FgRIJmsd;1':QiZx1EYb\BX7EhyOi:sE^9XNYouddn;ZrCLJW6E]7f'8P9*tS^Ycir]-FGkRYIe:{]MU9/^34m\>-|?tA+zm[>E": a& = a& + 160
    Mid$(A$, a&, 160) = "j.of;unbFeC:;/89=U1p|dsoJ^bFDY25WPNxoLlH0?;>ZWD:<z,Z3^xfh}6xIJv?DyDP+LQINQ7al2MLGNQ*-JZ(>B}Y{q_Ub.nGB4}gG>C)_Y}'NQ?zVVB:1^Ruim86?_8j6iE+Ob[X5aixYW7NxWSm+a=}o3hr": a& = a& + 160
    Mid$(A$, a&, 160) = "xm+i;>]4b+baCY;wopb=)sRh0iOEL6dtKxEj3(UsSGI)?Isz+fqHSfLl)e(:/8T=)L08iJG/XgN+,{j2qf({FA/I7{abuacSjU>RVI*Ic8XjWR0)=X?Q0VK<IQVTP{jK]9N,miOWW8G?S\+-vPC((f=X}]VK9Iqu": a& = a& + 160
    Mid$(A$, a&, 160) = "Qt=MxW9naFt:SgnW,VXIDcGlyYk_tO6hCC>7^Oivj27i5[f-{P0X/M;pXbEw?MC(3ZgFbNF'/T81g=[B[.NNunfFR+hO|]A.J5(E>MVE-:'8y[;+M8.k+S3Hk7K|gPRyzu)j2W]>.94}k'qxZkH8^BPz9b{sW(gO": a& = a& + 160
    Mid$(A$, a&, 160) = "kEtw58^=fr'0u5nY5eZ7;Kw]=G0>w9pD<puWUGG{tLDEK?Wm5x^Q\EYX6FMu^E*tf-Fm<[\B+WoYWoXJiaZ^<;PZrEFafTZx^]ICi^\>T'F4Y-_82PgsKon}>UQ'}dZmM\7xV_^;]=h>qIlJKit<r,0Y]VsTLtXM": a& = a& + 160
    Mid$(A$, a&, 160) = "NQVKW880KjQu9o8\JF6IZEc*5aLQ+7>eRZ:<7,.c;d)/M7>dX}r1tkRnN3pHHAuP;sr;K;[K}hZ1tER8M'1qcov^,Q+NFd/Tv}AaSW-=r.bDS/<oinXmNufTAN2oGql{7MG\+VoDA:e2H47f(gC3}jE5AYJ85n+G": a& = a& + 160
    Mid$(A$, a&, 160) = "_R.8C5CIB|Yw|QX+lRh}VWp15s4qGkS0TE8uW>gBy+Xsw]g>yG..>z5UJ+<Ubay6xdITrXYap:g\ygZLX8FPe^0qMpcu.9(4Kxx9g>Ez6C<v*15jqhSg;6oD-6hVjlOo6n^[SUrObJV4/H-1HnJYm{NY4?b2)eaC": a& = a& + 160
    Mid$(A$, a&, 160) = "YeFMGVVl8kuAaPmAGIYs4ARD]wESWPCK,tw*cs-|?8'C4V'2Ifq+YV5cSqoPiPcwj_'616LiTDFkaiDTy>T85KEFLP]xx*Y9*_?*vJY:Xz4Ug>_Km8_OR]J=rbUn}Iivq/4{+J)n4SSr0p|9GT]MlG}1]b\swt;F": a& = a& + 160
    Mid$(A$, a&, 160) = ".?*aFX]'Vk/(,k}5/{NcxyrC3Eemuj|)ka_0HeA'?rRpL1T^Q'wbXv,ehZ80XqOG7Oz)]poYjWsO)s_>W0XqUSm)5Mb9/BRj1i3?nWob0y_R2[PL1LK5-z6(WMa[xM8FzJv)1UTGE;aNyvbJE{I]|3)dtl)-:55)": a& = a& + 160
    Mid$(A$, a&, 160) = "zT{RCQWL(.,wqaVgIdSdG:N6]H[uoLYC=Xeo?MMbpR<GAOOyCEj76Y\}^VI]d/.Kr>4?}FXMN5S0apaQHHCiXjos/F[Sv=wA{;\kafzh4LMhvAS>s{YoPGw*Rnr1dv)^K-gu<AE/>C?bC0xVlTCoBdptZ]U'K8Q>": a& = a& + 160
    Mid$(A$, a&, 160) = "cBuOW3HI7h2vC*>x<\,su\^qn;P9.[WP?9*yzp_UX\\TEkasuYuKz3|.jvVlZLx\4Tv|nuIIV413BD,9HTRP9,fT<s0kY.^pHzA29PzP*oKxPrex}pY]nU5^|eZnWcm=*B,4ODq4I'[y/;.TeAm|NP2uS>b{.2iK": a& = a& + 160
    Mid$(A$, a&, 160) = "ESMciprxbVy-KSiH:2O}{nMtjUqV._Dd0TXoE{(RRp-ptWm=G1{g=:n\Lv_YdhvOh<5eN(Iim3nrD9_d.P4l(NY0b?D6hXo4[34)D8i>aCz{Hd\.|6MTsxJo8:MDPY)Oou|cInmOd{mrg5hRf'l=U8oGe8bffNsZ": a& = a& + 160
    Mid$(A$, a&, 160) = "?qJ\NlA_FM6QpjJ\EiH*M/1=o*J*Xo55H/DPgYJ(f0xA0QS.m-eLB_-JLu68J>TH_RIex+Yd,n_d3})?g)Yn(c+T|UtOoe_zG'Pi+'X(xU.ud77m9|F5RJWOyq-aMr85>?iy,u1^FcW>*PJCPp'B'(25]0,>snf.": a& = a& + 160
    Mid$(A$, a&, 160) = "mgVp)ct'Cz]wsFIFBy</>KKLoRd*Df-IOtn1v<iO9=gS3{7p)LG^:v'mg-f1bl-dn[[;d>G,Gc[*XgK?|0gIey_[]55:DRo[j|GwgnSfx>yfbuP;zH,SHnqF8?'COc-'I\CQ:v,_Kv]KwJV[kv2:k^-GxG9SV8VO": a& = a& + 160
    Mid$(A$, a&, 160) = "'-rJ3+)\-f<0gAcNzlk,s4JPW]pL>pcKL;M,SG4i2w.:>y[jUbkdpYZ\{('1e^]*1dgK_znu08Ziu){b6z,7F-5FXLcSeZ0VfCNl/<vyWoJHsN]8jOJ=n|]C|)oshg/8}wk8SX*H1NfWq/{4ZL7VA0b?<imWqg,(": a& = a& + 160
    Mid$(A$, a&, 160) = "bGj;gs/L+Ee;Z0YvpP6[rQG2:n]sh+[J2(HowBR;:*boNBrtsO=3gW:t,\9w,ExdV_3}Ki''7_/4'5f?u?ubHs816[f8nv|s6{0VGh^<*zbwU/ND5>U|;drZ8s5P/mTM++H?^)(<8cMEMq|(:{j}Zvx6XzNfDSz-": a& = a& + 160
    Mid$(A$, a&, 160) = "fv1JY+r|)kzm4jJ9rHlnC][[;,RNw.)p2)}}xd4M:(aqT{?t2WsX8m?^go8+E3.[J<-s\l,{)U*-1CW?,i,aqu6<lhx(C:3Z0't;kw;YtNv/8*[1-ax)GUlrX9\0o]5r5'XPPLbg0LbY;g2M.L9E;=1]=b;bs,lk": a& = a& + 160
    Mid$(A$, a&, 160) = "-,IXc'[o.[XB6iG,)xEmv3(FGtrR}:DOPbzonslh+E,?Kdy3?+:gG\n'dX{KqNjw6,gi,Q;I\}^e7p[IGC|+)TIhKL+RV\(qsa|4>b.N+4g=Ckw:Y^U,mXX0;mO\E}0=BP7ogxu/6i19Uwbi5te6b7FJC7Sz0{tz": a& = a& + 160
    Mid$(A$, a&, 160) = "DQ]Si/0\F]_3yOCFnPQC[B]X_?/A37u/0:QpLAZ\;RtQ+I+O1Y8IZ\BNj4gT(lx|iS800U:_WX0<V*.m}t\Ke92<+rxZ0BA54Bhey9aGC=<G^soVZO.hDqk?]Mfm2<P'<Cj.K[eHD}Rn2<+|pwOchh5>J8a_z-1s": a& = a& + 160
    Mid$(A$, a&, 160) = "n:iQQb'(;)-7N]gQ-juGMFdIQQm_xG|j2:orUQYAFAvbD7*pfiJ:YgbHhBqt[VSU)hXg'y\DqihEd]cJ;B1F3zuE+r7WOvw]O7W'Q,Hg-<hb)A:5dNPfw{Y1_0iAC5X<V^VGhGcPxomc_'YyaeauA'W]PvyUL70f": a& = a& + 160
    Mid$(A$, a&, 160) = "eu[ChWk''}H_}ed8P3ddJyV*3l.sP4P4dmKPYoWqQNc>Ns5\3{Cfw?sj4^+[g]J8ymgpC*ur.a9iq_;3[voG-WGrE8A[?_t<LTYLIsZ=/dHXm;=/wzUCKRc[y?5R_Y]zU938=E+[PtD3o2U4mZ{6(sBrTD7X,hl_": a& = a& + 160
    Mid$(A$, a&, 160) = "fmgXr{\T[i3vS.SRX.s?Jwfd^[qlo|:uejgR/:kB3sr-wWy7BLrmB9'E8B^wmlduWT8CNyZLmfDF'^[GG<x8n9>Up*IaKo38'Fgpq/td\<a?t6Vc9-oX''UcDmQ;oU=bSwKw_|U=T/lIBi*VdPrX:p{t4?gG+4{^": a& = a& + 160
    Mid$(A$, a&, 160) = "ASk-u)^z:BHWZab(zw?pe)DdW*Rax43vm7-wbhAi7-XfyRtdiz1VC>=LYq]*BK+-m2Ru)'5asX_l1p:y]j.Iy*nwFTq7Tof4*-\ntGOih[yIz*^0V)6t_9LC.RqT5:.d[Q|6_}HD=6+51tvH*5*=5.;xx)./kQ[j": a& = a& + 160
    Mid$(A$, a&, 160) = ".My,'^ECmwnbic4LJoJ4\fTq1:.s[i{B'y}ZP}]gb<[H7jJkw>ml-l(djzyt{,iO})vi4LGd0VtrF2Fb/L8yU6mMCxg=1V,LdKYe:[7a+)OSrcZ]NiwR51U<d3'J.\KF<{*>p?5r*ypTJatyh?mFb=O_Fn=U'q'E": a& = a& + 160
    Mid$(A$, a&, 160) = "?[ti0bj;=]1?LT2K)s\x;qi-S3ZME=x^x:cZQlPzuj7>2^)WeW_uR>4{W8L<_p>1PGDK)|*W]v>iMja/tm)\'2<j9([re[KgSpV0G0'kbtb[nPa:QKHv1JYGU{:MdUo_ej^:wO]znS}4ADta7=49;[=Y/>j55).>": a& = a& + 160
    Mid$(A$, a&, 160) = "=ywM|?C)0hEk.j</,kaE=8oV[>VwZ]yKFFbj:;r..6[GwMk=Hcs/P0[C](O)-W^*?XPC)no\nkUXL*a>k?P-jmf'=0o'>Ie5.RwQ.3zDh\G00|f'B0k*c}<;gl1_q),tL.04M}PTE|H7|=L^?GT)P7J^ZnkQQROl": a& = a& + 160
    Mid$(A$, a&, 160) = "+s7YT>F(YN>p0_,'Nz<3_)(oW_,Qb6L1UYYPiM8_*yrsxpDSWMLz2R}m6KCR0+vsH'9>ja2sC}(TeG*:*)?iFM5?V5,/el/{gRl6dzYh/_?f5*sX}J[rDq{:v7th|w2{U-}BfS\ZYh]DS(?/Yoo)mx{WIT3fwOiF": a& = a& + 160
    Mid$(A$, a&, 160) = "xrGQynh9_YO_-'F{A1B[^?pl+8Ac4+M/93ok/gYx5m''PZ+cWxa7f+Fc4byc8wbd<41*7o\Ph(ton'3-GP\YBtiU=;];]bX>Jr/B4.8gr0)V*SnRT\OkY?EHt8.KE)*Do8Y{/?,>9pFd[Z4K0|^G']SLM.TJts:<": a& = a& + 160
    Mid$(A$, a&, 160) = "FsGC6]]D[7[vQxU,qmJP<{'=NYvLs{79{/4F*0me5l5KO|E5zOTJZO3rGw;yNjCDpLRIt4unu(Zved0fP8|'HvnN?ZvvV.MXI>T1B^tLYflpu842(\O/K1B-<pvvBt:/<O0xKQ,j^y1D7U8LPtd'_Zi<B9WUn'<r": a& = a& + 160
    Mid$(A$, a&, 160) = ",m7UBL7zph=,fI8176Bz/^_/K(Mq8a9WA+9)yi(X_ism|uTu=C85wg?xMs\{EPz\_lMQB-*[5uLc.Sf8.0uaVlBglU0'}JNmvnqxPAV[w|_YiCSNMgT|^t3z])^*hzdnkF,pR++TJWkAob14(_u'Tu7io56+FJy[": a& = a& + 160
    Mid$(A$, a&, 160) = "a,joY6wa)Vx7x-.jDx+Ujh6G\'DJ:\'XjIdlqVzMh>W;L<FIK61d-_78D*6V^TiwGINS4K^z5Sd8CxAGy>D0p4>k[dzK\]}LCat=OygoWLq*Ki1nwSNvVC2CR/p3XeMMRk?)NP<'oC{cT2Pa/E?S-+AcUw7SJKtc": a& = a& + 160
    Mid$(A$, a&, 160) = "Bj1vUM-,tJ}*xVoQ,XF6iu]'kdWyt2Lxa2Qpgu4[k1?+EUS=suVj=*0,Qo028Jkzabia\FxuGqaxeCP^W7xs'wc/-E/[W5y0).37aDmz(8'Mi}Kd-6FG)TJx>S?g?Ns^Z''U9{q\o-tt6I1P7NeOmj?y)TiZ6vkH": a& = a& + 160
    Mid$(A$, a&, 160) = "=S'y(XEL)xAw}Uy)ra8,9.+H{1JDhO{D.Z4R9Ev_N+Ujx3>jo_{P3GDS/qr{'3ywWWLr?WN=H(\Ngg>V7iCWGbB6tO'-=F3,LLyA60OT/D_x/K4dreXeoJfFs\dmo6c*j=f[fyglIeR_qiftn3i9/a)-8=^Hfdco": a& = a& + 160
    Mid$(A$, a&, 160) = "l*E8TZrNFJ7ybeyY=OqDcmxn>eDco]3m10BhsZi53kqb0oe<8TZn)[q+*;ms5SFr6>dTJHM)LS\97YwWkAd)l4Ze},IC|RP88}xvzcT'[YdnXPNUu8.:*eUNY[EtR6,f>V5qJKTA'8s|<Nsqo'VI(A*ApXgcM*6}": a& = a& + 160
    Mid$(A$, a&, 160) = "YNHA_SV0t4x3XznZR7UyDJ9_]2N+)X'Uq2l?_3HLIHOTGY:<a2coTN>WPaQPzpaKQ<Bwg\^MrFu[;8Q6.4CLP,97Xh{pA3.jcZb/6-<Lt+vprdPy6ma.320G6;8W1+P;M1NCG'}C?x4m-K[}tZbqvO{^Z?I3)v18": a& = a& + 160
    Mid$(A$, a&, 160) = "cs:uX0Tl+FDf<jLmo[Qa+.Ha,Bcg1Z,^kGKdO5PEu7sKdrvj<O5E_t56zs-dSGl82>4}F}']jNjvAB-2fCqCnNolSppm*qQ[f?TQ?zBcdw=vt?/-6JMsXd^BcU9/q*Qk-coYU^vnfDA2d\}SepY4HfzEG0at1:-a": a& = a& + 160
    Mid$(A$, a&, 160) = "tMQk>nw3>c-]/2oSiU/dnl.Kej5wO*a9E{m0HevG<tuBE>GngVxl2sl=Q/Xb*2=6]>Qu\3Aza/8o]d^emW)dL:C7w*p-dmwT?^QB8MwkK'J1<QCqg<g_u3>}l=3lr7\X'iPInL0c3983|MCt4=8Zw7PhVB<3ByI}": a& = a& + 160
    Mid$(A$, a&, 160) = "(7w>z:Y.|ouL/+l986h;9yL/l</r]<H,S7]0twE:DGQY4n2q>vB>oFVJs;Upgp,Ty8CixdpnHE^,^?YNF=NkUr'/kpSXyz;P)hSutmAIs,6?D^3m[t4_'8YZIioMh7br{V[,1AanNrA<+\,+bwTpVYDseQ>Tq;qL": a& = a& + 160
    Mid$(A$, a&, 160) = "X'W+5'Xk>yg.,n:*J5w8Wu666<A_8wn2h)[Q-zVk|,MgX98o=|P6/\:niA('l7qKc]Vc6fiGlXJR\Z'eCqS.WM]SL<3nqF^HdK4,Qq:,U*XAjM}a8EZ_>pLT]3E|Kc.wL|Q=[9WqfoI}qRc7[-'u2t|Y/{Hbc6vs": a& = a& + 160
    Mid$(A$, a&, 160) = ":=p)SmbkAcnDqW\B+E;u7yD27l{48^9I=e(HN{zPmjZK_yYbE-aPxu-_^5,49)kV,Jl_ts2T4Q=SkG5u,Jk,cmLcmb(q4MQf3tk*\ubuO-2E9c<TM.ANGf1N]G?X8}3vRRJT-KCC2i_)Uy(90DeKT9U3<dFP3XO,": a& = a& + 160
    Mid$(A$, a&, 160) = "0g6K/.b.nNyR{z[7({Rsm)336b,[_KWHAG1psG2*Lm<s};HL6n7o7Mt<Rb3*WdnwwjE>qMvGg_.J^5|XM2mO\3(T1jYH1.TY*TnNzm0f:CGVfAE,Ehv:0i[ScB>u^1it;pZ<x:6OjUhV;eYWEOvDWg_hrz:aaevd": a& = a& + 160
    Mid$(A$, a&, 160) = "Ie[h2rrH[/nKN'ifHJ;AK*|q>ZK)UHIfHmxLM\6Fov;Cw7tfHdRm<F15=^.qblfC'pTH0?Cb}{Mc8ffNabrj}lL*+:itbGUH/*a'z:U,s^,X>d;hUP-Qj3g;p9a23*1vf0?lD9.NOq_7:*+?XX28k]bX?'GitX=:": a& = a& + 160
    Mid$(A$, a&, 160) = "DOO94X?-q,XWosrWW*ae\Ex**nW3I'?Ik]8\Dh1eADjj{wqRDBUB6puA-fG+DEjYU*fA[Bw<h=muY_=NoW-w\0dM}}]jJ>k57T;EOA.g[M/m<g[eY]Z6:ZALhm>Ra4mM\}SksDj|2GpKVo_lS;l_dOn_hJM+xf6R": a& = a& + 160
    Mid$(A$, a&, 160) = "8GwEdTtxQ0QM]_V*FLZ2d2||/,sVGdjimriYsKc1P'DA^>j,c:tAatfA<=),?pnj])w{(hpA3lfbEV4>'X),;E=dxS/M)N]s-w{bo*\N||Nojl3^o4gd:y0j5_570{q{eB8+_m6X*BKSEMT<l-]MH?T82qwsFZSu": a& = a& + 160
    Mid$(A$, a&, 160) = "F/I3C}(7+/<oCm4Q2JARLeXs|VIN}1nn'?i3_ABr}sNuy1l-q}1?0nY=F4)sGVzX9,P1Brj]a26qhyiJtB4/,>SFhDss/0'h\4:jO_-5T}>J|C=G8-fBCJ]E]W4Q|>SbU^XcQFA2R9mMw27Vk=NC<w?8_2?udUNX": a& = a& + 160
    Mid$(A$, a&, 160) = "DN}pihExg4c(Z|m:]R6HHERC,\I/1mMu^Vc4Z29yKKdrLLHStd4\Jw3sSaTh]NQI-':Ap]vQ:_gPTITIP8uN[1paIibS+9b'iAw-a=|q|Vgw}bjZ5/T4D.d-C*B;>5a=f;.iidr<?Ij6]QJ>xUlx-}O0{+j50gxL": a& = a& + 160
    Mid$(A$, a&, 160) = "UQY.LA(VaHo4TReAAH(UJL6hv71',k5drb8GQ,yGXFg5?89,A<DIDa8>[F)|7c:K*Di|RME]Q>RzQ,k:Lo8OHj/K4GS9(HXQ9'd7mmPZu*'ol,iEj+hrGr9='BOKQrTd+LDJHNF9GUW,1e;J476BDMdRNnEql3.p": a& = a& + 160
    Mid$(A$, a&, 160) = "celSR6Lz21|J+-i-BuDKcAB,*L3a0FxLlwEhpByW<\[6BSj)E>(o'29{?>.^1plFhwN*z\-(ClA{Oa{-VMDARA.c-7bU,paYCv4fs1yAO97K\k1'\LQY(HT]E>[*M[lm^gg_S*XUL{aUU\5W.DeLJ4>t^]q,bDt^": a& = a& + 160
    Mid$(A$, a&, 160) = "|3b1nUwm5upA\B,3Dw\F[CrFnlTKy_y=1l/u.S|/n5?QK7dGIL'?0:;F6dZ6U6nj.nv6q3uj2MLr7M/puT|KGu=/}[I)mN>3oc*dM^1arY.0-RlU.e9QfbODh_?_(\iq{:Utup'DbJ{BI^,Rf\zZ_*aGdm[i<'g3": a& = a& + 160
    Mid$(A$, a&, 160) = "9amM9}s3kq0k_EEZjZSG-MJ}Z>,Fp}uk7i]-C|6nka>AHBAR^|\K\O?4pl'N>rIc<y=O{}24KV*nDV4cabJTs5:g{)kSfph:RPHoUpo^5wHtWI_)wjQ+d+0SsQdnxcvgkVLcLWLdXum5kH+(Ksqe2R\.r\z2ZM}T": a& = a& + 160
    Mid$(A$, a&, 160) = "8Y|[+7aWt.Swea5Uxgx1b3Chj>ELl[d_nz0/Dq:?O>d)Ve5'YR=jn(}':5[LF^X3ZY+rFec{2h?lr4Z73kAP,}]TO6W]piXGaxA>a^PL]V7xAf2J_fR.QUe>^-iyn.GTBt1IoqL\ee-?u?W^ezwtn0p/-M-lk7M8": a& = a& + 160
    Mid$(A$, a&, 160) = "7*+P]b3:mM6.3[:OKhHt'G\+VEXv*X'yxySq0]Mkb+:yCrVA'^UWGW=6.f7wqMHMVxc>bam+be}yrXE_(7z)z2/F?9O[uAqbEBr/lIP}'nlOP7e:[++?c'1\7P,m{{:-kU38b'S]0>1M0[d60PoriJ5wG.2h,6ts": a& = a& + 160
    Mid$(A$, a&, 160) = "ckM7|5R{KBb1([f0;JiOFU>=^}*=_ro>AUiK'>5GBlLzvQBR]rQ;BFVKXm8=<U^UE3nkaCJn8.7,mL-:A7;gLl]sPQGS78dmbmsx's.gjpzz8fimGq:/aRp3A2,m*p/|f{4R}OxHpnu>do6g;5s_1f[F\x*gWBt,": a& = a& + 160
    Mid$(A$, a&, 160) = "H\hXh6y|ph:wM6FcQmI(OH2W*\z5DxIuI(AkR8;xsG.:ce/AjE6xDCh6Hx<IN=:<U/d5P-z8S+g+(hsJ0EX2^y\IxH|[QY/xnwG3=db:jNs2xf46XqDzgG\TG3L=*7DY1{?s_{2l*Rbn/FG/u=?DHjx9wcDXw|7?": a& = a& + 160
    Mid$(A$, a&, 160) = "}iRM6_(QU5V75L=cUNhBOAQ-X\C6>^I6I.|NzZA|wdsm0:bl]'mcVDI\i6;*U(MWCNUQ7Vg66uFaMB:_fLix[bU1yx06V<cI5Hq;PBdIjD7dfGKw3djJ'Q(oyOokJ7v]o-|qPoIav_/:sw_}6IZs*K(';y4YRZ^}": a& = a& + 160
    Mid$(A$, a&, 160) = "xrg9GDRE1FzU},:03d>\V7Q8,+RcYI]p;/LpacG9<z?lioyN,NB--F,+bpT[i9iEzUg\Bm-'QJM5;[)4pG1/Qaw)6u3G\[iHQBstS-jT{f9;Z(\N}6,L/|6]L6{-)vEnJ-;OzgxWKG^Uh?:xM8zZv+_wlx[CJyE6": a& = a& + 160
    Mid$(A$, a&, 160) = "*aGQ[_yJhUbe;;(3tfzf_qE52dVpm1a/>L^GwAPr<LiZbCvyx'iIQESf]7dLeKu,388=.{Y=-445G43rU+{3obdR?eE=[bfz?gniKHo496([<l.HSqMgz2c=*?[T]QFV+_D5Cor]26dEcYJRb[]g();;twZ^,}U3": a& = a& + 160
    Mid$(A$, a&, 160) = "]r,|O}M40}(5zFKutum';WBZamKz<CRoj9Hqg)AjG51M97PW<e/lM[=3v/G:,5D0ZM-?*O.Cyh;OTfLOo=0vA+>X-5g\ud8<Y<:upZgrO1QB;?6k>jog:\,]e;J}gHOhQgzy(o8cj{ciYGnMm-[4r1ba][|X.TM4": a& = a& + 160
    Mid$(A$, a&, 160) = "'hNNY_Y||z-ACD=Hq?bxLApIMpH}us\fA.Yf9Ee1nWWbx+Mrf,\WfW{eN\>Ry<l=G[Qd.}|AaED,p;ATC-vuOY;).br4jHusU{P]^Jh+hTQavtySgvyrOOA7q86HI88:>ujQG{.aHmk|?ycR=}?r65\7dG)dN8>R": a& = a& + 160
    Mid$(A$, a&, 160) = "kgkDTO.>yM\5w}qcmsDhV>e|8l_K5cu5]TE];3cJ8icxzS:)ih.kfKH*2Pip+)',Mwc2kR3zI,{TB|oaKmqPRxEQ]'l+HPyF,<JzQ1}1Q*2j{|5pYh)woTDc<2UA+M3w]WOiSbf[-uG2Vc3\W0KNkgMVGJl}_F8C": a& = a& + 160
    Mid$(A$, a&, 160) = "10S9.+*}FxTI>ejieudmR:*ax<Hf3W]KYDnt/e){ONVtWRc_JsV[p*=d5r{pU[PGxZ+L.fZRSUzCxK4F*;fGqQiQ(a{C6ZyPX8x=FY*fvnxSb;BR_KvBsFo|Q]K(xsTJ=0{FcbL2-Qf1PRPD?\[fEI\cnz_+=<tb": a& = a& + 160
    Mid$(A$, a&, 160) = "NnxO3>OEn:_5omcI_/84ylTbAZ7{D-UYp\MsuB0mI^,U:\U{NK,f]8juO*\>1y>S9k+m'RG>DeTt*3EU[Xx,n-diWzdZXU;JiiUh=;hoP5r/l?y(dKLSm<GUk=K{_E,l.R018WSto<q't6)gSyCpS9f1+\f,ikt4": a& = a& + 160
    Mid$(A$, a&, 160) = "<rg)VN-UgvQz|RvMHgs]?/hNomPM]m,t|z+;5jji?lqhM:s[;TBMMRtPtYE>-s4pT|VW0^.6eK^y[Yd_g1W/XVoeu6P[?0PZ\9skKE_=mL'X5jjjlp]W1mJ'=Ol*;0.5f[2J5,fF])K*>S;{.YBKDAF]CG*qYhjk": a& = a& + 160
    Mid$(A$, a&, 160) = "QK,Vk;y1.0Sq[R5_C+xvLxF+z;OJ=P=C})U:>hyB<4;UrP4XULSL53fN[czB^9wj:|:,VC/7K6)UfEnp()N;>mq|pIkqUA<.m(L<\3.g9gCdPrQM-]OLxaWrzC+j7qm^_mN)UwrI6XsFl,sY7{PMec\_i7rV:.CF": a& = a& + 160
    Mid$(A$, a&, 160) = "^c]^/4'4]>d_NrSs\>p:)arMFGkZ</t8kDxV<4Q=MTL3\tF?{yGYQEA|GC2^E/CT2S=}]K?ojlA|l\+J:DVQd5pA7Wj0eI6-uO?)C*QnpBc[;9C/lE'MbUDUQLnqhQoU.oXfSo7l>.Z6k:PYgtBfcvelip7k/G+<": a& = a& + 160
    Mid$(A$, a&, 160) = "{LyOL;,{cFwY;?8sluUh[Vo/3NMI'q?:p{Bd;{2+USWYXfa,,H+^jKzp[f>UnC}thq5;>}H.=FHckYjN.Ag[rv:eq1^moC)Rr>mF1gq7IO^{'qFBc9?pwYObx3i::|s+7Mh;;q8-gn||7.P;v*b+2m_/pKl6=3A9": a& = a& + 160
    Mid$(A$, a&, 160) = ";xN9[AOi)MgR5(b6wu6cnQHewZSJuATj,4e)YzW-VJIo|I+ajG/Hsh<K1\shZi5jvSaNUIEff1g|f/QSFl;;jpBSDtMMDnku'Zv}JXbMlytqhylvA4z9lNzZkFGS]>{*zY_39'N>hs6R6uNy(kjk0gDK{{l_fw'3": a& = a& + 160
    Mid$(A$, a&, 160) = "/B/U<Q*l),_-M,'>6>l8\reG0L)+b;+Gt]hC(w^tzvJ-,6RC77aDymXT^?/y,R0F=kMx<kt:2wE-=U^VXX_).\J{|IRnbkoogdWI;<cDB|K5Pd-9]}*+DZQ64<RNufqO<(zY74uIQ;*Bbgl/={\VCZkDtOLoz|6[": a& = a& + 160
    Mid$(A$, a&, 160) = "}wF;znTSI{}hCH9u*<(oSob39w,N.g\xR2<kBS1G>'C<B,<:lAolH*Mf;'^Y>1Ace{BZ/GMU/Ar+p[1g,HS2,k4+C_|qAKmvyh[Ow=Uu?Vm6E+VE[(_:.oUohesgEM]=?>_qyc^0ZnpI4m\2*xPol1NCUl*A*hwm": a& = a& + 160
    Mid$(A$, a&, 160) = "=wNUU0CiSOzz:\0H,,'VvdB=:m-B:/qq^Z2btaUzplizA.+_J)Xyj|9^18SmymgQyB+u+{b_L4y>cFC|BsU=[LpVTA9UA:DOO6z[F3hV[-Te)PzpY4:3XbIPq1*bSE7ffz-uatArSh;g{\qD:7zSb)Ojy,[}F-3H": a& = a& + 160
    Mid$(A$, a&, 160) = "k7t?,RK,BXI:D0MmHaoT<swYp:p+a+IWEiTpo{-_e]nq<HT.]s1ZYk15o{rspo:)Th0y3H_BjpldawO'WSY]e9llxSqkuG0amg1yqcG^2QCg,dlKl<U,?2WJ;lvOkgNj.+{/z5voO<4o<N=yY7t(;j1cq)z.Rznq": a& = a& + 160
    Mid$(A$, a&, 160) = "}deO7AaYmz*s8'202-26Vgj\B(na23lCk|BFkoLUuYjo7x+zj]txQ<zK:=c[;rh)Jm;uO<9evC.ne.K/>Emy3r:ldLBzmisiMJ-LE-j:P?NBg{?:sE^Lg)Pkk:-po5<;6ltI}]L+gDTMxR96EA^y.-Ro1K*mxhYM": a& = a& + 160
    Mid$(A$, a&, 160) = "Yr5TLWOJHOUD.0aZowG-.[zygjk*O8BUIXnkmedk>-73*D6aw_gg|>S9tsloG9pr/4zv9i'fKG:LD31)(^q,V,6OqQY74uPfK8}nT3VJLz-}'4Op9?j5W4}<>WM]i_8K{f29y)9-I>SOe6CP^Iv3fBB8m>AN4h]/": a& = a& + 160
    Mid$(A$, a&, 160) = "Cju_-hbL.ki=j'VYqJ{d773*^+VlKnb-A6d+UT'PqRLh_XMLr8T+/A_qU[S56uxT]qKewG+/F)fJ/Ht[Qkl(}9MZX=v^F/E=2T,4e'^YmbU,[Z|wh)^Tyqd\-IIui;Kp2}?2<C]h_Ny1NY{(^R)q)[PW]]W:tbQ-": a& = a& + 160
    Mid$(A$, a&, 160) = "'qO*6m^/fW:H10L]V=F+Oj8/4r(hHaJ?j=o^*7)uqp7y82_-g73b}2(FB_:<]eLN7*L'[4:/?c6,z9mDcFYx1/=KZLYEbm/FJdd]EjH[+feOXqbwW,{\G7ZdP<)2C)^w:\yvbr*s,5N?h-aFL(smI(SC|7IL2j0T": a& = a& + 160
    Mid$(A$, a&, 160) = ">WjsbGj+0LhDmVdo:)4)-cF\7,.mj2.UO_R=Mxn[8Gd=l97akFALUG>68qw]zj(69.Ojp4jcOcUlBK*{{;[=\hS6A3Vr-udiDBC,AmNug>pyfT7j5}'D25\.)wcz|tXq,j<aS9psw8MI)7*SensRhLQ_Ximqv+T^": a& = a& + 160
    Mid$(A$, a&, 160) = "mo34'3vK0hf-LY0|<5sE(Be2YiAiqIAB5bkOG\(5f.-I[RiAd7iZ=GQPXH]zz0i{cmdK?P2d1fvcnhmzmt?Jf+ax?C/fhcD'hKmPuIg+?fb8HS{7rWu{w8(^m-g-/QlAQxA9x_MQQe1}QgLBl_(0V(8Ls+oMJ:0e": a& = a& + 160
    Mid$(A$, a&, 160) = "s^0N^Vqq1^FJt(B(utZq^D</ix>e||7Pm4Gz7Uji3,^KdiXwO'zj9REiAO/fA2Y.PsB]q/fVPLTn4iv3[[fIkicIX(qCd+PDX:En6hba=Y[M2L}V=J9O;=Q\nS]U>-F](j:l}T4|Ts3:0:7-/kXMQtUDU2lBH3*G": a& = a& + 160
    Mid$(A$, a&, 160) = "3kwt1z({7<9/6a/Bh_gJS6wpu_vOe<{)a<CdiK'?]T[3Ezj6<VYPqC/Jv9F5KJu}NT>8k?>y1v<DTw6Z/ejo;:=T\_-0DBj:5\kipPzQ=Y',YN_DhDwVUrcB*ktZB2FHOC1U1+:+vwZ?LfU^r30>ExCJRp]jnnj_": a& = a& + 160
    Mid$(A$, a&, 160) = "f/R;S.26[+T=sUwR2N04/4WMElz8-yF6w{S8h_D*]qJucU=Yc};c)Tg[.']_pWOtm]ag/PRLY76^Gb]2z.j{fd=Pq[s[yvKzm8\OnpUD2h1Uju6LLmKM'3UF]ZZl)rFtu0,<rakWGE8Rr45Z8xA7jCwTP{=gqBt'": a& = a& + 160
    Mid$(A$, a&, 160) = "w\K]qj7|GC(zKKQ0T/LMVE.JmKn^3qj;t8sgT<{[?Q/{0Kk3aa<d5R}u;heQEKkj7CpQ>,ItdG/Ix1U1w2{=M+hl;?I?[F6F'+yx[e>cTn0]kZP'LB?m;28'>492_YWz]pRI-1+4/2,pW^lR(nC>+0})KGrC^tDX": a& = a& + 160
    Mid$(A$, a&, 160) = "<^x?xEdd|EryYy2\(ujpGvX({FOzVY-EXDkRL8SluyyjtKbL581QpH25G+h5>_asAbt*{|t8849T<amZ[Fm.^}fL8euaM7\tvVy;KcebC6Bkw)+km(Kb/Z0MC6:M5E)El'r(Wf[;v-LW5wF.cY8HcBtC.gGoC{p3": a& = a& + 160
    Mid$(A$, a&, 160) = "I*)dF^5Q*'016GR,)JMVu4']/i2t7t/W[uZwOEQ]nmCE>rB7'HE:=5;/eZYZY);}1xj/2B3,n+Ck9<*c;F[d1ynQ8oS(5uKb7D8DBbhUOgEi]Ul9v=CouGm{2ST-E[u1Mk'y^vG6e:>08-CxlFI8|wx70vWo2)V}": a& = a& + 160
    Mid$(A$, a&, 160) = "R7\,=5PPSAN-6ZSLVL'cT8Nt-lSEZ|>5iDb[yV*)r:/;p?AxlwV([hBt)Tt:Sx-Qa+[{\)1g]:+,xIEnMEM+QSk-pV:iL,<=dD8TJU<5u^[nhv,YdvJemMD'AGzjBOf0)n5]r,3w{9kpepf+tAg4cvQOCH?Qs\RO": a& = a& + 160
    Mid$(A$, a&, 160) = "0P2OI?JCK8S7Hfz,Sb3itEi\p]e:P=uFTzyb>2KsWcP3MGP)u-nR>:ovL:Al.qa}T52O;Aft^=:ppw<v'LHN[Ohl^3nq|{.{)XSSVz.x(iNE.7kFS?kf+j3:Ixk,mxz4N6HKuPP1e8FK<LE^w>7p'[ebzDx.z3}F": a& = a& + 160
    Mid$(A$, a&, 160) = "lb;Xx(:Nub96ppxId|pU;c]7A99uK9IN<yE];Gr.^7RYh}eJO9}e3mQXms6EX\zb_YxUF0<\XYQZueb'ZUKaxuYC+uF?.^>9Jj\9}<:1\2sOxYlMrL>Gx4mQ/1^;|dky*O\4Zo)qLA[2UD6a8Y.QeJAQVVKVlYD]": a& = a& + 160
    Mid$(A$, a&, 160) = "=PceZ5NDlxFc5tkTB<\Fq-nVGc0Ez)qJCcIfbG3e0>0CTyN^NS50fxJf+Qj<z*^eXRnd7v//wgp>VzK0Ze?2Top[t^A5[+>+]V+6kCXc>E<JgyMo?38BqiSQoSNPUQJ39b|]rR='vsxxyRx1t(H1y+h;KvHdxc,I": a& = a& + 160
    Mid$(A$, a&, 160) = "?BcK|7TwoKH_0YY|i8rWKy40.W7dmTT1bGbl5BoumdL;XDgabOFa<3N\HeV0M2b6q8UTHu17p|y{]L?uzF-zn\e.1TS'Hq;'qWWDuxVHMpC]8q?Jow({gF7I^)CDE2?>edg+0SCZh{j6Z</FfxRE]o^_s;[EPkKc": a& = a& + 160
    Mid$(A$, a&, 160) = "Qz*PdPsMH075,yr}LE,/8tY6CVgIH6=5D][5k?4SO.j.?rI4eI6gpiUeuNJ+PrP9?z;w];(Xv-Od/<G+gDZR;Apot5l95O2KGOzqjJnS9AXG7G\o:/,w-3mPC;FX;{4e1H4rSK3k+1zOY6QF}205uKNKUm2.-(IA": a& = a& + 160
    Mid$(A$, a&, 160) = "Q0=z2w2le6LXw3Cz>Si4;70HA\61n/2tK7m[;m9BNTEIBVIz*h{PpT6Lq3_c'RqMJ-j.M62cZm?]qj2e1u}puP21WI^[9eM(,cXxkyowPY-}sL2<A=,_;_ok'YF)]c7xz(eKY6g5[H7[[p?2C>5D>F+BWH}Y9SBR": a& = a& + 160
    Mid$(A$, a&, 160) = "y[T^_7y<_Y0(z=]_[IBLncwA_9wu4T4V8AE53*h1>S0egYHK|[46pRXDS1'0>olQ<5x1MS|;?Pcnrkfe(^;+jtomvQd*P[vVWxSz2OvP6=u]LnK0GmgcPque.w>Ok)SD}4PCu<KcMy:FFvQ:xIh5.a</]\5pvD2[": a& = a& + 160
    Mid$(A$, a&, 160) = "bdNG=XC>qa1'\KCJOOo'xk{9/21Obo0U<_G9])G;YYE^{'6<=D=nJpMT:_}u'-3x;h(42^/qt{E4vVY=J*>x+uJz,n|[6AC/?ArlYtQDP-[]j9hMHvrbx>VH:kC.b1lgv5lB,xFCwh<X2a/)jM(=fF'3l1pmA7;(": a& = a& + 160
    Mid$(A$, a&, 160) = "6/6ugMl|bhQDOjG+.0Gfn^{Kisll8]s\Tk)mTqWzI2sfU:u>U+UWag/7M05PAP;L5^M.=CsivG|gi{,x9F;j{k/c^Jy>Guw;Zo|ux7UD9mINV]kDE,wyroN[aY.jkH\89'zm-|LDk^PQM\<iIhT;BfJyLWMw3;Wu": a& = a& + 160
    Mid$(A$, a&, 160) = "1*h<wWm]kMYuLl-Ll,'uk>|OqP-3a0=pKrZvMVW|[qXy]\+pZU'yeQ-NWDbeP70PdbsqZ8Tf:E5)xx;-yf9B2h^,k?uX(5u_,C4Q/7|SNdyLj=;5izYE9}.A+t}rto3t:td:anAw0[)C3<bXivUy73hhXLG5rsQ>": a& = a& + 160
    Mid$(A$, a&, 160) = "Heem_C5x-*[SJ?KFivbr.]X4?U6B9Le2Q=PZulA|XygrCAJ?4Bs=jXqmLnPIqs+<rvLM-4nJL2(nRb_bpIbB=ux-C[iNK=l>KOl(*(3'|?mv{\1(Yz{7,jcIfJhd}|pUj13B}5?-v6R:7lE?Qu0nH|]BW)BWiW^A": a& = a& + 160
    Mid$(A$, a&, 160) = "O:CW/LHEv*oI_j7taM7>wfoN}h8sR5ULyLAqu8z+x]}y.E^lbL\4(HCnv?6x1SBTox<<R>MN{<1V0r|MeVklDdET]xM-{PVs\b}g:lQC_U69?Vik()+NPX8iSpapv?yOmc;9]17ory)M(l6}5]2Na*XNxqXDCDFB": a& = a& + 160
    Mid$(A$, a&, 160) = ";rA[R.Qrg-eHzVXxjkXt<?c2jfF*ceZXtu^75UqTT=nxhl0Q7?e^(,3.cxYbb;,Qz8/:/a6^MfekPHKi\i8)jq*H2;2nMHKSqcn1{Dvdx;?M-tAU2+z5v68we=QUO/79|X[7W09]zwwdOE6LNC.i0E|82rJNGbFH": a& = a& + 160
    Mid$(A$, a&, 160) = "R_OA?JR_{bZaValxCku'4Pb\Y|(4p,<9DwxvoC0Si5{bxsC7<jkOGMWQhL0Y5,*Ua:_GJH*ayo>=loSNcCKkRwMRv?)6[dzab?dpj4AmB*:oSuPhC[T/s^iE5aOt+YvXtA]mC<pgRoqD]QW)}Wcfnb]SE6v7+xN?": a& = a& + 160
    Mid$(A$, a&, 160) = "cU]Y:SgVQ;URL?dkT1ewC:PeRm,(?'CgQ/JA<]EEIyfb<N]:69UL>X*wrEai9Ei?N{_3{}ZE[=<8K({vBg][pA,F1J|t7OYCzN08m0nmR58|ZA+A2L6khdfc{mQxErn5Df}C2V3fIX+s.>]e5*yM|:bl<Mx2]JmC": a& = a& + 160
    Mid$(A$, a&, 160) = "dbO>K9Mw<GaD{|so:i[h+F<T_q6)gQlS<LLovQVcNd7+tVy<CbXvPxfRC0D8.^nqFUR)ch|Ma2Q[k<d'T]_CQOrf*Zn:jb9PYYFmpH^f9{L7P2YtZgf*xKcTvUIn[2'BA[|jMCMfn47rE.H6lcUYEuV(<C\e?^PJ": a& = a& + 160
    Mid$(A$, a&, 160) = "3C4?Pa\=cksJ2*U8QmTQ}tFMihV')GD.+0?>A*CxXJ>zDGlqU\09due's]I0r?S,Mn6\saWUt/6Mtv=B_;FXeLmFbMDCIaD6:\21ti>hy[f8h85BwtAmRyB{cvG5B-2NI.11A"
    o$ = Space$(45033): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    merrydat$ = _Inflate$(btemp$, 45479): btemp$ = ""
End Function


Function sparkledat$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(8861): a& = 1
    Mid$(A$, a&, 160) = "0O5;'>o_QF:GGObfRP)5q<1>>pEgsei+,6.:VnoV./:O7U4'IA(ViL:})v71bEB],LotZPoF+)yFajCVq=_dv\sQ/SvfO.8HI6_d];3uNlbl}QRZxIaa:gSsp7__Og/FMamd'[mkuqt{VkBIl6AnT3^10^(N7:hD": a& = a& + 160
    Mid$(A$, a&, 160) = "7[]6{mJ]:[BZztUF3gz*n^sO1YYtE/7BQ<*8lK:K|Oul6p0BG2QN<^Vc9BxvRQZ2j7-C'?^/G<9NsM|J/V2-6C^SVs1y?W4W]uAlW0uaXkb+?;-L[*^6SfMWT,/t5lDWrfm2kBNjM+YPY[(TM1JpjJGJi29xXlgi": a& = a& + 160
    Mid$(A$, a&, 160) = "=^AM*RX,3Aii1kieS}[/JvR3cYnY'wy\ipIs(:ySu>1J3\pvV*{2A6GS=}E_|T9F9ZhV\xlkoaMeho8PM;}gt6oP]g3\PGo>LJxavi5^tZ=1Dbwm.PD?vel(gEiJ:Khv+[wezGPgRj]6nYWrg4C}VN__x**62T\:": a& = a& + 160
    Mid$(A$, a&, 160) = "caulxkq:RlB/ya33kw;MmkyGO,k8dsT,+RZ6MS}VT<vJQ<.8|WW'rKc5RN)sr0u?l[d>vFv;5|Vyp[QLrtA3EYhom/BmOFP}E*p3YT<<}ycp}SWq'.L]47]<4ze1JMD/dcUaLs*xT1(sKvfFwj;{I[y7aSVu7xEs": a& = a& + 160
    Mid$(A$, a&, 160) = "ON{YXPSU-)rY<Ga(pQx.tlTxN.2.zl.2wkFl2=7ezJ5XIJLEX7A\gw9e6])DES*P:b(lWo/ZxZ7:vewZ)[.9<y2[dqjK?X_*my)=Kg[u63r0{aD;er;PTMOK(K|l3i;sWZ|c/GzSS]-4dzXUZKo24)QJXJFU_Q|y": a& = a& + 160
    Mid$(A$, a&, 160) = "IpRn2co|e:cE\ZT<(ogSFrN01+=0)HhHf.sylAPl*oz9ET7HJCJ-m>f\A}.6wxr)m]i^>,uf/sPxNaQ.mQ,rl3aqw'(*3}\V3IQ+jpb^r;Fj2o'kdbNnI>r6WNv2w*0I|D}(//lxP2kF]*ZeA<Ji^?4pTBy>/8_:": a& = a& + 160
    Mid$(A$, a&, 160) = "a*^)cXnl|OCW{2>n0wNcHplZ,ytEn:[1Ink_/GSKw5C3O5=Q>xvOK^f;SCqbx9aN?X<cW9VV(t*KDl0[m{2D}qAup|:wHsu{sG])G^c.yg023c)^y^OGeIcfOCUyPE(6+r)ldy?C^vHTA;^0BB23<'z)Lz7R^GtB": a& = a& + 160
    Mid$(A$, a&, 160) = "Dan8ikBQAD['Y89ujL(LNI?Iyj:,Wgv5_=/R94TL?8q?4y;9-+sE6>:e6UuW<eX;1;Rc-{XJ{h]N:ouerzo?S|'\{M{3\PFzUj1Wq'pGIy:8s1[]67<+S\;pA'Am}if4?Zu)/,.53rx,vE8ia;zet0*wVzR>iihC": a& = a& + 160
    Mid$(A$, a&, 160) = "{C-6g{w0gUN'''d/B.B9/GH>g(d?KjVj2^j6zQ=eN6/|nNJU^nxj5OaRD?prIU4>2)rX-s9?{RQvYaL0Fbf(:{qf4>lV_Hml+_Ur>r-pkhIiLGWfj/xtU>G56E)U7WW/GQ1*Y[|RW=t'Ah2a\?d00UI]JEu4GZ=J": a& = a& + 160
    Mid$(A$, a&, 160) = "2b\HlfuhL*AW.\Gzj{muw2lff?<AGoU+DxW;s+f(axS38b/74vsWVU,mmX:95LGL4cC0EKN)+b5]YPe.fXjC;;4lH6J5bglLPH0yer=s;2.XGm0'1u0=pW0taYopJ0gWC0*W)ZtmKtLz)yzj4_zOphdEJ5MiZ\o?": a& = a& + 160
    Mid$(A$, a&, 160) = "_FL4TRc{r-mS;78QRg}G5mJEm_A).UCu>DJoRF=)Ol9o8|vxBB}L1xEZ'wQL}j[\H47*:p3r>^jqfQ3__<m\iw>J?SKcUqjm4DN<zvpn6w4:A'dB41P|tAYWW[O0f=:N'l)Ug'v0c2)3}AKHyq=w-G1GibJ.j*Z/": a& = a& + 160
    Mid$(A$, a&, 160) = "9rEC2ev*/-=tF3w,]Ce+_0\6L8\zdE'(3V0-;q\riu1.Mm)L]KT<,vT,l2f[1;odoq>G>dib9cLESq(]50In;l.08j44DP:qb5q[4=KEYN4))eo;?Wr?+hMS.bV*[h\Kn('=Q/\lWWY=}Ia49TrD1|[Up3wp3a/0": a& = a& + 160
    Mid$(A$, a&, 160) = "zBds3l*4S1dLZ2o:6''Hq.^\gul(_i*<qX.?I-]1<vv/2*Oj4x9GB3m.5uiX0G\rKwPK5Sod9DGXQ-Dwsiu_xbSbcqn6jwb}?PvZonQR[,9>Oj|?_7z.LyI)VBo^NOcB0E24nWN+oLkv{mK*t'^jqeW<CwrsBxT(": a& = a& + 160
    Mid$(A$, a&, 160) = "cF:9XJ/FtN,N1)2}E1FV]EPF:)HcBo(K6:6qOYbODH*sKf^ipkh^Po2pe-o^TQ|N6YkdCTksyp|Y*O|cBTX.wS>fM|KyRk:|unRt6wa:Bz(^U]]pbLUOw\kR'-u=qcblZf8twuMf(uUHEhE5+y;N1l/.37S2xoGH": a& = a& + 160
    Mid$(A$, a&, 160) = "H-On71xxGX)W^3Qe3|S[e?aXwTBfXy[]YFnT3t'Pu(bApk>|(6,NRf<_tOKM2dS.(]d\((I)G6OK*ZzylyP5?/4Tf)RVR0N\P;yLd:j6_qTAsnc;wp\}'1072-fm}B3^>dXy+5yI12:xm0]d;1;wpF+;k?+me[o1": a& = a& + 160
    Mid$(A$, a&, 160) = "5Cw)ihZv371)p3sR/z)(pFf[Wcn{7d:DFaC>B3yf1,5U3o]v+MozVlhy9oQJ^EcY3ttzMXLEgI(f)0tYF]MzebjOR<ZMrswCbdrRrrkcpCe)'QpgDgTuIN9.YrP9U5[TL'ggRccEb:5MlWQ1avc>6mos^y*X_EQi": a& = a& + 160
    Mid$(A$, a&, 160) = "8t=7ez2k\.Ap91^{1UO_Mm)57MRmRW6x.}6EIXTT/?I01R.,k0}wtIZ=fw'JRL2_7pRM>Zhk,mO}1e6lKD4}EsB8eMTf0Zo(chcYch6w.oh26{wBa*)-9G={k3YPD\W8e?Capa-R3B[mOSbs3l/l)F15O8lQGX.k": a& = a& + 160
    Mid$(A$, a&, 160) = "L0W0_UALS5Rx}b}qarmf3.?Rq6Y.wc]k_-HLraTQ_TG12+m-s4dlsz05nYIRkObiOoG)I*Y4=PUA^Mkr=sQgrqA747C_R+Wx?-d8o]j9aQ6l1^4tN>.IQ-lyF7x(|eKTY'v/V(p9U'fOB<UYWiEa4|[wR}P}30/<": a& = a& + 160
    Mid$(A$, a&, 160) = "J9^V6>(HN(n?[{gWB\P\B)c-HDd;KZ-Te6758VvT:^'3?2:Z_WrKm==0HxiXrxpNC_{4bpX.e]}./}v,hpd9T3\+,<s9Tx)7/e;sB=^^zT<Eei1<P]fYBbF1{YT,k*2d:MLeCofmIdLwu9Fpdiy/p'-:;.zHtuQ3": a& = a& + 160
    Mid$(A$, a&, 160) = "n/^{hjy6]v'nHM53PkQZh3f7'yx7sME:fSzz51r\]]/]E16W7k(.,Qc0^;/rE?B(7|8_3Z,L7T/YlH;Vyi\+g+\K[A8p*:<ILl^Xa[3Bs7[tP5;3^x[qCxeGD(Hy2y8Zv-pYP],a].GYz22TH92dxn9nbDy7D{NA": a& = a& + 160
    Mid$(A$, a&, 160) = "Dnn]x;N=t\V.f)kzNKbYWGhQikfgPNSY:i0l0PSBLMJ}B+k/HL]v\Yn[7x9Hef)0\S9y?_,1eX/1'Ti(Hs^_3+hzS1uqQWZ;d]}rp,=M+hj=iiuhiC?rVP1|S99jhD;a^Mzw4?B20z?.Akfm'xozCZr3Z0qp:HkW": a& = a& + 160
    Mid$(A$, a&, 160) = ";D.I|C=KMXtbO7G6(NObcRJHsmbL7X;t.32>_S8^alQpNI<vqWa557c5QA:-s[nrKB[ZRpR_mpgwQfD.sg7|lM>80fS2LAnB=hB'oi^3,QXjJ<P=r(/tEAt_nFyR'yvc2c.IsgY7Iscb0YyrHj_qNigsYQ(6:CQE": a& = a& + 160
    Mid$(A$, a&, 160) = ",KtYEek}{)?jnQNtrU}'):[m(49sNAN8(j|np\Jzn[[z[nU{ZDj'[EXS.u<)M4Wv33{7qj6{,3AKPaUi9\foWCP5psz<2R>XaWR+6WdGnEZO6yZz.y<);DvQN*9ajM.AK}(fpMtPKQ0waWC=P{K<UV3mt?zv^'N)": a& = a& + 160
    Mid$(A$, a&, 160) = "FVB9{IJcK-ZA9L<+:0]AJw'4:?FnFsC4/*c?bX7]wY2TSJErkgsW4p_>IPG.eq/Nc2zKkX0M::WeN3hn9Rfxy:]c|br-7_9Ddeqt\YJDK<fjRLL<FL1|O]_\MOkgWfxd'xy;'_g=s*lo^886kJR-lhF)[rT?5i*4": a& = a& + 160
    Mid$(A$, a&, 160) = "sxYoJP/Pdb);7v.JdBLxfiZg^OT({GBC:wSlP|9+:)sDA7PwJVlH9hPp-Na9(;t^f5RE)IKUR5rIM>|57a.-T(UCYpw)URulW|F3zd8HN<6Id\RQHQf;Uu|N|zbY?qW=BNZ80JF7=7(9mee]xG^b-kJ'l/417ZGv": a& = a& + 160
    Mid$(A$, a&, 160) = ";I(=Qev.r6(E+fQ;Yii)KSifS\g_*pZupC+wf<WG=9B;5Zf},EMT8m}XFs?i>1^Qqw.nk1-cCYB:[{TZynsuX?^tm+^gd]fLy|)=bPGz()ZN_LnJ6A(xBa?v;TD4F6V4e'OEzM{ORnE_L1}[=3M[M^(EeOzz**bH": a& = a& + 160
    Mid$(A$, a&, 160) = "RgUyj;S5l8+lIq,j26biGf(=Q+V:?Q\XLT+<f6G{,(;Qz49<TO9L2gNj9]T?nN?5M0Mv{x8fOWcW.w9ltPx,dW_wlYj0,k:IQ(?)agbZENn>G>vP_i*Ph5Y/CFvRXFnA?Rv4'_K7IaI}3?Xbkyb5\}yQeu08<a.v": a& = a& + 160
    Mid$(A$, a&, 160) = "F/uuayI_?05<9.,b?tZiywu1.8wRN=)RF*:q=e:-pb}uw(o68A*k7_|+r.CtanG'r)M2]VGb^hC*Yb-j.DuFWxLr}C<Eb/1<Ek{2<.;Mb2[fw0KJ<='JqS^:+P(eHMQ:4zDKi_(C,U2-OzTygMjFGHW_ig,Iw?:0": a& = a& + 160
    Mid$(A$, a&, 160) = "tG*}9<[6FF8Gzxx*m,oPE=a0L'ry+yAwihSPXo/=GT5?_k[\2dHlijRb]/^Thrp2x1)8o+U\P0Ueewb5:F,XT^:y>mxhANN>5X.G>_r,ua6ym{Ug'ztI5zeO<qPK|xH8=HFpCWFhH{uNpb*0_P_HU66wY_-I?h]b": a& = a& + 160
    Mid$(A$, a&, 160) = "w-JwYT]V22xk=Xs[iO|U,fNV(zd0N5sEWJCklmm1rEJdorSi>NV_w|-A)FJ7d<E1<]]5MGaHT41}k1z6D]P_?qOIr{U=|x,gOqhS0ixXsQMQjzFCI]7V\HAByVD;=\Y;Oj3z|cxSF:}bkI;sDI,]OD]HRZyWKLTe": a& = a& + 160
    Mid$(A$, a&, 160) = "[Xchb6RiJx=-yLPHqtf-x7}Op0)?roIN4Bfvi59pNMv|,jX_S09_r33?[iRTPk5:hg4C,,_B,3lu'XhxV*jv>p]S/h+M+^+ii2I]6brzEo5n7mQXL4>vA(upt(B;p|EKCz6kR54T6J(tSE]a()\^eE)f'P0cb|b9": a& = a& + 160
    Mid$(A$, a&, 160) = "H(p?s;fNWnZQ([W6jc2jDY5cYn;Cx(B6NC:A8Ua(sem>_nnuO^q2'G><:,6:0E,7O0yx;{V?B7GVpRQxPLBZmw_)js8a|MqE3R(knL3;YjNY)1T+yk:^lTyLX+(Fmu5b[Zz:_cd?VrwqlU_**P*lCH()dc]95oG)": a& = a& + 160
    Mid$(A$, a&, 160) = "tV7kL<l8IVqJoTE4I;4H'DB{p,Ki7e<aAs8roxuw{nDgWvcMJjzTU?}I64gF3h|5lpri6g{Up1M2C0apg5'=dDAXn5QMQ._lVBD*NsJ,*w4Vii3_LaQW_X.6QrU=U[/1';:fBDp73r2+0e;?P;2nghG:15i0q(N;": a& = a& + 160
    Mid$(A$, a&, 160) = "cRoGcHVgj+=P'}N,n8J:>SRbGT'Cn9-0,:Qt[oCD5S7m{0gl3\(38y=*'NBY+y74Yo=fh^)*])dl=O9BlY'ER_:T[{|8LJnVd5?,lp}SvDn1snR)PU08?]<7<OEitnmD^',Hqs}vto1^s54C1KLz=-jemAFQ[PsE": a& = a& + 160
    Mid$(A$, a&, 160) = "wrD(H'uY_VXa8PY2sd\aG;J9jgg()H-\S9W_>qR+UEL9fL26+G,ka5vZ1ZkS1R-J_5*Vq^vVoI,1B8N]68,;Sq6DQ/g-tSt<YobecJ]F>T)n|0*MABOXvT25O\KQP}u|Nls:_]uT5mHdK0DTz6PT7';G\gl-<0;n": a& = a& + 160
    Mid$(A$, a&, 160) = "mAhme<V[|VuF:5EX?EO0_gksYuF-oHdk^sCv7B3C9o*LYMaOwCtaUXlNOUG\>jUu:|Y{rvw8e?5Xk9wx(8Mt,57:|kNWh,F[rpmJ7'wwU))a/hWLjYLK)ra?x<Mi_|-S/)APtf,CbvKg0p.7a{C5s41MX654S0Q^": a& = a& + 160
    Mid$(A$, a&, 160) = "5ot,zu;Ki'/-Klnpv0|wgkN5V-nW|5'rYTte[VLz0bVV.7fbjj_Ep;:AWAU=_kF\L?;hxPStRZOaX;NtB'<MljRT9}CO8IH)jlL3+bxhz[<vdJNZ*E/M+i:jyVLKPvS.1?:Q'Xv45+op*1T.sCJd}mzHP9Qy1Q-f": a& = a& + 160
    Mid$(A$, a&, 160) = "PVcZ75<\YWDnA34WnD+xHJD7>cnJ,RH\S4?Px7w:>/Rtb4[PQ1-XKVO|vbPnvJWT[98s1zD<:HMqv8:0^)[4QN8Spmfl]-fLhSt.+d<]-mk'iz=aS(=_3n7SQ.38gwJ5yV9>h_h<yD0=n;KVgIyBZir=}2M-:'Wx": a& = a& + 160
    Mid$(A$, a&, 160) = "?0j.:z(sD-]p9cKJ^kw<(rqFPs=dzs4]wm.iTP)n'>Eq;-i'p4{5L3i:^+CtOU)U(g-qR+'k/7]MZ2iuIUw]t5C,*G'CQH53<iO*tL-{xZu,K,zF?^wd(1pd(Bx/hd];>p]B-GCSTgs*Prgi[:i)cwgv4\QXT,3H": a& = a& + 160
    Mid$(A$, a&, 160) = "n[|7wD0Ir>0Q_^J:oT>^kin,;^cc+14L8fyP(G.{t_EVBj;pz{2uB/WSo7Gg<HrNDPzDPYNZWek|1vXVPo_b;-Y9s'1dGfH[dijQaiamhhCQwGkL}(}V*clhQ5uxzya)utqr>c92xLln)YJ8T*:Mt63'i.BxLJ<I": a& = a& + 160
    Mid$(A$, a&, 160) = "H'-G+>t[St[iDvdpX/J/?JI>d9K5wSpv5r6L'\ep,D^:;2F[I*RtsOs-u[FbI?aDMjFv3^WYyPDu]S]yhyH=U|MEzZ7Tbh2J,)oTEl'PKo^0y)=Q9S?gaF8jLKJ9ZHM,a6y/O|Lv[(qXi'[}t-,K,e(r|CtCg4eA": a& = a& + 160
    Mid$(A$, a&, 160) = "VVzQw?D9\qXUpsT^,dvvZ'GqbbybZ]y.\(H.uO+T7quU=]+uH\.Xp1Xp1X.WO/'mZ,tlN]IUg_SmMvh_3C,W:G;,7;ZK=OJx->u{uIBAdNv]nl'6F+t:ZYxu4d7STgix)ZI'w9rZ+tT5K;a_yDt'*75,1FJ\iL5l": a& = a& + 160
    Mid$(A$, a&, 160) = "5o_FKykrfZn;-63QS{[f^<)f,0x)9MmN7XX(eCW\|kHKAhh]|5;Ddd8-s.(sM'2}(wHFERp0Vs1HGctFX?[0G'?=E\LFwo30(47Jr\M3n}w,j,L*[=)vD-^\,N}cNeKB|34aP=YjLFKh-LS6/>nM*O'/Xs3l_=_F": a& = a& + 160
    Mid$(A$, a&, 160) = "4S-U]|Wv*562ZqaZ?MiE_{7l2|t-1tV,Y|Za8rb|]:4OQ<sr=6rtpGu,mX/=rY1kInqFp<jN5lVp)ZDGLTJ=B/p7<vEMGh.]+}e_j0WGu4MilwR:7ZV)_K+QJN=UyR2C?[vG3TTqZ4H.TN{x*2a^yJ|<=JBhcTga": a& = a& + 160
    Mid$(A$, a&, 160) = "i(o1B:3zhg5\kcW/sxnD]GW?tBx;m6b5_o*3,>YJb0Qu_DLXBvT'W<amh15b7\dE0EBdHQXiHFVd,7;:|1?byTo\VQ+4)9UL,8R:F])1q2Y6+{'q-CiBF{G7iP'{ZZl]Gzni2r_dS4'yWwIRDzeieG>cq:TSTqYP": a& = a& + 160
    Mid$(A$, a&, 160) = "P>tSJj0giePI=xhhoEsLyyYuyGyyARBrS[)oRK5j+nF?XVyhW49]Km8c4NqXpecT0[pveA58llunt-d+Td1*CDsRQ\5[wACgHOth1t7[;huBSPXak}Kx0gr<C1wmu.''</,z';Eg<c1HTJNnK,t+JjYu3CsDcN8=": a& = a& + 160
    Mid$(A$, a&, 160) = ";5JLE^)=gN<U^BD9zgBS]OLLH4OYG62Cf]Lx:f)>Kx\crIbIN91'gNVm,=V}k'me+k>K5oZ695aN)SG4l_24[SRpe:Y;avX1Qbk,[x'vd,\:c(M]jDdQS]I,X(CA21/_dmTZjl7'3)E9RcZu7dJVx^GQdw*x<?v[": a& = a& + 160
    Mid$(A$, a&, 160) = "',z*lc/9P{a2q=_>QDFq*k{'LJ'FK[Q^;=h_OT'K7>n3l8??l*^Vd81P'TsQYE|9-PXS)|idYjAz=r[CcbT4hpg_T6\Ko8HjRVd0nBx3hMJa(=T'GqC-N{3<'S8fx-'bJVYmaEE7K3+8dA(r3XQHJKup'n+6yI{d": a& = a& + 160
    Mid$(A$, a&, 160) = "*0y?9)de1=Go\3y8f\MCkBuzPI9N7[AD|t=/zLi08rH?DdLf5vZvs;ojZlh7E7m3O(Nn>D,*a_+Vt0czGwtf]Bowe/xb\[qD3<4_H8xy_)(;y:p[F-wmvUj5IX\bYwt71Q:A6s8gBM9SU:FDv>5OY2R(nf9l>DE8": a& = a& + 160
    Mid$(A$, a&, 160) = "sQF/K:,*;?OOxVJYZO:kWcnAm*+qMQHk53._'J\+cuvL48f;x,o0-5.^+p)NTuS+aKqSdYfS:;5TfFgA?(J>bF_//{^2MRO)jA_+LLh6S^d9Dmv,fcngDtO^H\k9]fq,>M;B}(|{ERQS/;\|fERXeN\?lpDd/O>G": a& = a& + 160
    Mid$(A$, a&, 160) = "i*s_[{la_Hkuq\1ItR3;urhW<'L'1|hc,s7E9t9zh82])xok^xWh?c3]<CZKOL3[K^oaV{r<7*N:ISq}j8I,AEFyA*25Dr;wFt/.W49Q0wRyDuqn82pU/1Y5p6occ,)_'[FTv|so9U1bBUthu;O9L5[6*]'llHps": a& = a& + 160
    Mid$(A$, a&, 160) = "aiee1\<veX8<vK3.J._+3VB/MOjMug^Ec,wa97tt'BzlLFwq'SI6Zz2+ewFlCYFmjrsVJ_Urnvu.A5)*.h2tv:?-1/4ID:ao\sm+-j\h\3PR'P_:jZGqKe=f9N{ytceAOR>lZgqEqnc8BB9>bZ2t9CPv/?p]Iu+\": a& = a& + 160
    Mid$(A$, a&, 160) = "48>hQ[nJsq2m}4Ih8[q+}9P'q:pf/{YWB_L?N]m|HFeNb{139xITGpTXmL[{3Mrj-(MCOZgaq.yM_;_v'36tHhN^.7bmwi(Up}Xf0B/veI1ZX2yGKT|K;>Fk1voySLAqO-n++3MubiZnav0R/DwW(c7p7j]+/F7S": a& = a& + 160
    Mid$(A$, a&, 160) = "41jg2Xq*6vbyc6KpR*AfWV,QY-Yr3+{uTtmaB90*)Q5<;UkT9Sa?vK?GPBY(FVLJx[+^?(ZbjfGnzOLhtWYc\U_lFbY{5{Cu=s-5_vr9J*,d5E3Ag9,XvV5tMER>.uu_Ol5Y5agkG,Dz[pav87sT2sVV,)K4RapA": a& = a& + 160
    Mid$(A$, a&, 160) = "ql?Kwg?'Jq;340bqk4r9aGK0KzKCO^ldKwn^ma6-z<Ad;-x}vE7[0(.>.Pr[y0xFvf?Y])A[D2a'z]Ze_FFJ/ZS='gvkS-ngGF)|_4no+-A2X=J>>xaJG>lF<1:cSyEKYP0TGydMr-([J8Z-,vlOSz\z_2mTI(;1": a& = a& + 160
    Mid$(A$, a&, 160) = "xYWZcPNg*iNVL{4r5zNXf3z[VCa)l}-b.DA8PiWIS5>b6aF=izW'-o<*B97-"
    o$ = Space$(7088): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    sparkledat$ = _Inflate$(btemp$, 8345): btemp$ = ""
End Function

Function jingledat$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(52581): a& = 1
    Mid$(A$, a&, 160) = "2zZC}oB2om9un;?FWiDbtQ|hF.+{:Om8jQ]'49WQ>fi{ig2_qJR,Q2*S6wpH3BM9nCdr618pLIf^[KdC[]y7]0A^xz\YLn;zf*W]Ye-LWv/(zId*DSHT;QX27ZXCRyxj/RG'cG>xf[_s:r[+n^g4B\7_*M{c'sd.": a& = a& + 160
    Mid$(A$, a&, 160) = ".wD\sYpNM<+fakphX{|V>[Km7Y{6?\5+o{]mdjSNZFp|c<93nhsX*hM;EeF3Uc-cGE;yRIx8?r.psQW?cAY-nEaQ;r{AYmpZkjQ20SC-E=*VWJ^q'B.:lpDO]r==)>QM<4\176,vM*QWKA9OJ.'6)gk>n2{((mV}": a& = a& + 160
    Mid$(A$, a&, 160) = "=n0XHdUK1Z(?wvmfd90SMkYIR:;1f,+P,j=/hQ/8pa4VEoYjX4,/A{=PhAXk,dT398K>ZnDm0RZUD}8FLY60eK?gkauJ;J9zeLj<;u*{Wuq-uUh29.R_dt{Lg[J1_PJ8ZRwXYmw0hbn'SLiqK}PRMYnqENctn+,m": a& = a& + 160
    Mid$(A$, a&, 160) = "H:+iXfZmih?(JV>-Jw|sdtf7vbL)>i;>R=fTI\He[ys_Es{)O}6QVel:16ssTu'Q'wZB\edc^0QpO0V7Kdd1pUF-,o{;x28PGa?z{yr_VSqDG{K.M|2*0e?e+Ij|4og4\RF'\l5rLJ}|U260C8Zbp)Zvqy4zA_Ja": a& = a& + 160
    Mid$(A$, a&, 160) = "2c3]sKb0INB]4W>T[/qbK(:WA0;N4ip?G(17N4p>wk[ok,IwaK;ZtDk|e}rI.*g-g89i4tHf5?6XDqZ5hB6>Z+3GFR|c3]O-;UkYlQ'INSM>WjK3s3(\UqdsDoCwTgM5jkIIL{A[[KTyt:s-L+dTdf,r_|-.['UT": a& = a& + 160
    Mid$(A$, a&, 160) = "V-n|BcUB7nh)V75uPo705AOIC-Y;Cetyg72_r(1He(,BwfN-85f/soVU->]/AKRDevfQ8tkh[8;>UroJIl{443r^(2EA,.g{w_17y*svx{k^UtKc3j^v9LAFMwbFUu_8oirh1UHj.5g}G4(IsNcohfex>:Y(\}u]": a& = a& + 160
    Mid$(A$, a&, 160) = "kj>)V.MwNmwY=RMn'ipzTz^TSe'5H>=3V<8I]7<IawR.t\:9[dvMW;GqOL=Yl0a=_(DzPkUfFtoOu++dNy}/*C5,Z:6I_Jw4kXYI5Uoi:hU6?IiHg<xoJu;3+W9TgjiT9is]d>tvfCfEYa8?1Zl_>o6p=u<gq1>5": a& = a& + 160
    Mid$(A$, a&, 160) = "EBxx;zNUf2;+62Z|JV^hSz[=I}1s|8O5ZRSi.dv+*-.EsDl*Vq]Og}AWz24yo,\qbB36ZWaI2-2*CB'xAxQkZzrX_j({(oXkPt[gyDG870pza}5zl]r>Bik0Cz>qkj?JlLI7W0c::rTpa3{:++CHP\KuQtze)D+A": a& = a& + 160
    Mid$(A$, a&, 160) = "Hwy8MhOfL]8A]sK0f^=mF'O^|V/HzHZ<lygH8DSY1+h?vB{85^cQ2ndK-0t\knh=XSkOOoQQ.*?pgr;Pe{>A='PctQYtwyTgmw<>wpDPwX<9z-j/F.3VW6dKiVY4=^1icNFRK^GB_}UI)gSL]C8;qi|'/=S]L-L'": a& = a& + 160
    Mid$(A$, a&, 160) = "'IKNrO;aK8NTxGRdvaR>9:?zc=r9U2;PEIST6/nqg\z[g?eRoHu]tZ1(UcA81dT3;WJj|/Qz__h=Yo}zx'<22+5)NV?yB+)-yQR8sr-s02i(c[Kq^HvxQW'sOm,Mu/P0U6-s-z'K4*|=AFt:E=8R=m|+<|OzcyM7": a& = a& + 160
    Mid$(A$, a&, 160) = "qh){.PpQ4YgWc*.PJLZ-h7{7?omtf;Lc>KAYmIg?Djo'=xyy[e]Mp0xC_Nfq'O-}?Q3cKmVUtKj7Zh^t9;{ivx(<W5gJVW-eg:9L2(;h7c*GY/6N2{Oe_^xv9.6tP-wU6ABoD7k5R6+nru(6/m?gFx,17y96NuJi": a& = a& + 160
    Mid$(A$, a&, 160) = "obbQH/djoGZIONjWxFtpTIJD2,dYp>=H>Am4[wPLNX:Gmng3NX5JkF3X*8}*_MRkfsQF^(bKv?l\9CiTh7k>B{E:+^8R4XK)u:?=KoEwt^{(*|o+f^Q}5MHi_H<VZ{rZW;t4FkDTR?PuXit0A0s9S[?mr<G,druA": a& = a& + 160
    Mid$(A$, a&, 160) = "mtsK|,_r)K4\]SmS<-e]3s9F8xg;CEMp)f,/*}hg94N:U)=6\4P0y][]CrXpV?'RAtsf3KXO'0qNal9FqDL6Bf/YR:jH5bGO6Qq1Ai)3qXK(n_7]oL:MiX.PX+mQ}mE\5jf\d(6*laubSLb/p-IJ(j3n|[gQBv:L": a& = a& + 160
    Mid$(A$, a&, 160) = "a,'iVfx_88.p2V.Ob'KW*k6Ceye|aI_:(esY2UqMjx^/h(tnzX?r)_6LSI{Xa?1Z\7XbjbN_EZjatHk)WRukLDS5Cly6mB_^R2lLl;x4G*C|rh^m|VW_LryljdD[ePw60urVtA[2wm.=R=}pDUJ6<DH^fph?wFDj": a& = a& + 160
    Mid$(A$, a&, 160) = "kV7K<p*^Nq+*FR35PEP',cQ=B\HG9b)eE\gdv)VoO;QW<y2eks{x6SJtCgtP0O3^hbr9x)4wmd(/XjypWS1jFSIIXrBFo*Y5X+43.(.Cr[eTEEj*ci|\4mHpBd,mZ2-,UW]aB<*AtS62}-*edDnPLtpZNgoo.dyl": a& = a& + 160
    Mid$(A$, a&, 160) = "F2aVMWG,6p'BrQq:z?)6ILPFYDC>EemZ*K.:=.J[.nKdURy>h*lk5mOIXGP:ZOns)[1(\CkvqDtn_0h9yT58Iw.]aEwIos4se'xAmbpfn>FoweQx;]i*4|2_2NWezGrJ__3vSR,ecN}d|yVbmRswLofCV|7GxNO4": a& = a& + 160
    Mid$(A$, a&, 160) = "aHj_Xbr];Vc<P(96sxqcP_nqH14iCZJpfbH7_0{*3*gdz7xUiwTEtwBnf.,]9KCqV}2HyJ5s)x[MS.P]xzL7SPM]dyoOIzlE:0zEbftEuqJ}0?}17l/0={*hy+K3mKjh}7mcC_?TbbF/8f*Iq_:X6>{P\//7I7vP": a& = a& + 160
    Mid$(A$, a&, 160) = "JWs81>.kc2Vp/VoBn;rKH9n4(>leC5|Dok.0GOf7Ll)Hc+cPM-NV2ig\8z)NnkOp->N^kNf)KyNQh_}S2n[PB_c}0\q')gf_G-/wTn__7y9ki:iT{J'Sp,9UzAYov>no|*hFF62g?ptTkX6>4J;T5X2^q?E/vxV8": a& = a& + 160
    Mid$(A$, a&, 160) = "xCKxV:2uVeYe(JsZ:xt\OE;Mt;;:}650/UbTyxisY0,BjQpgTw|tjD?kpyso.xyu>f*|R84]HRZ(eS8o:[DlPBX/F6q;[5\5Y[-G.Te7mVx'H{E<>VnvgXa34loZIacpjiD4P:.<Mz;>>ICgki6Kp?.;Cw5B:8Al": a& = a& + 160
    Mid$(A$, a&, 160) = "aq\c*CBfg\ivMB)4S2e5+rpC-TzsnFY<S,9TO|6k?yR/'uGy7nf]tgY]Z(4Nl<7cA/NQrEcr8Hx3sbGYv?RSSxXr:gNAJ_y1x:'{JeI=y4ijl/{^MVXP?*iq>r\:7,Og,S,0pJv9Wl>'tCa8\lUw-tzvtX4;xxf9": a& = a& + 160
    Mid$(A$, a&, 160) = "HDfk{)wLx1B;QQegx}X2Kgd}lxj,_*U0Xi9I\+q^.Prl=uB:4fClACcj[M6h+TCoHSgZ]F;y1</kj|aOTygZ+KEy6Jl*<yXKtlD^:SXwy:+s2jY:w[.G'4U7n5,}^c/1<gtI7V.U]''bU6CE7zW+BA-k)z]S=Ro|": a& = a& + 160
    Mid$(A$, a&, 160) = "d7C3UI>x_c(+GzW{X}S8)HFl\8FbUM[Pymq7KismCLRKALl60e0dD2'tUQVnReyQvU3B=hZU\bLtiuCVeGY8J3e's<CoBR<_\\)F^Gi\y*>,e;Y-j|JT+pC,DA*;u5?y+P|'-SbmZ7ygy56O9DdFj|*oDa8:+t*7": a& = a& + 160
    Mid$(A$, a&, 160) = ",g|b]uAee2YqwCV4>:dkdX-^YjzKtu'=7Mm/Pn{j([0JLk,_'K'2Z6nBK..xS8)>s[)<}]E3[i<t6^}L1iuH<39eeC)+FA+axqy.JgFjM:]T;?b.H?_+x;_D/z,p_P'tIE:AFLD.+bc}h.XVTv(iRpBXs6)o0Oen": a& = a& + 160
    Mid$(A$, a&, 160) = ")_1<<1aes=PM*)HdfnAr^924zD1wrdLw3Ev\;iF[w/0u)^._U-f2GUzQ{(WVv)eWfY?mzv5Y]7V\FdoQYV?6U^(6g^hn=6a=7(d2mY<.IMr|Or+Qyzu+-6<0Y,oCA\(lwV,(W_8X?^=E2IzRH:94S.vllky.PLls": a& = a& + 160
    Mid$(A$, a&, 160) = "RFe*vrFpZ6KBBZNZ9Ha/,w_f_0G0.LySfh.FOHlbQdI15(jqTn(tT/-35:ds=xShStFVuyNn|;vF7;MRoyg'>A=hdHpeXKE;Q+=9,T{_puaeL0a>U:Vu^r-R+w3UA+UIbF\Jdx?cL-V/*F+.Ed6r-A<hu2eqd]2T": a& = a& + 160
    Mid$(A$, a&, 160) = "=V=x6WDI:]qN,1)<GUpq}C+|==PpTL{(OPyWRg+eUC|oA(,Z}]i;hEi+G?+mFiv/1iwtZ710vxkcw=plTx)y0(j1:]I9Cf)hPrUr8s=|4kt.g.iQoh,L-_)7t:(luMVTBS,D+W.:+AkkQr<rets+TaFy]P|]4,(V": a& = a& + 160
    Mid$(A$, a&, 160) = "hD)?pA*5T7*54/}Y)X9oz)d+69l:S,2KCpwwzVg\v9pr+tAY<5qw4xxAah_m2EUB-,>I/1/*4^*1sr}LDMc:zE>kn3|VQMYlTGE.qjjC\TcY[,FCCo^sAB5)[xaf*L6ck5VSohKxlsW45ZZh[zG?U>+YNbhE;6VE": a& = a& + 160
    Mid$(A$, a&, 160) = "}E*aetX>pIT(*r3sw}rP4xE?xY01e2Ut}vITu^{I)AV]ATs]gQ{r'q/wShA2x5={_IkL)p[2bTKYL4l[VB]o;c1k'3'Rim*9^oN8IM*0:ICyq=Xp\Cc,JfZysL4v2pVNn84d,Pct<6R3xRe/1L_eCaOoUF._PIOy": a& = a& + 160
    Mid$(A$, a&, 160) = "OfWb>{>9g-FwD|iW)ZrXxP6zD}H)a[gCZfdB3{Kn<.?c3b)+LeWda7gt'WFJDW)sP'z,1{IB4D'^)sF\_/(w/9:r97CiGbhd-NUmnuy>E.qP9zny'/,4w.EGZp-FC\f|?6dOSH4s)gVofNHu|0W5PQs=NdmP.ha+": a& = a& + 160
    Mid$(A$, a&, 160) = "rO-u;nz4/.6Yzeo+A2g/YsY5y1[bASYdJn0XB60]/p,kwCVikcoaZ-Q/<A.mK>oE'+y)K*8'dWZzrs.WTbm5=Ad.H>.f>0g/UOCd8A,4DP;][k]2]mM3<2XH3HD<NO-E|vVGd-'n+_?VOfn8va8UEEP(l-f5L;=>": a& = a& + 160
    Mid$(A$, a&, 160) = "2LJ'2Hav;r/e3IqhOfBka^rZ/kS]/C?t-n512un{*5<lLKWo(rqBvC+[SJ{yyQlaH=F?pG]zhQcPiJa}Pf}(S34Ft8yO+aZqW^J?w6fw-=KNL.skj=:s\Vr'xA8mVx9.5o5)-Fm}tihuSQ,v185Of}aVOLj_k6/S": a& = a& + 160
    Mid$(A$, a&, 160) = "1]6YX0sI?yJG4TM:BL2fM[{k2hqBpGK0^\lJRl>QMtlR37;RsRwhxY/w0:r>0R9xptJ{_jWP/e8w^LGY=I\xc=O*rz<v>sDE8O\*RZS3H]sOr+\<O)v.OB]W\?T<7;529(;fH\ufKYWM}.H6R}ExckIyX:C0'IG_": a& = a& + 160
    Mid$(A$, a&, 160) = "2>iJ,d9*|[K=_uM+zd]9*9:KlE2.L,T*]k6m3vAsouPItlk3,QjS'x;a0<I{?MRDCd67VH^YQp+ucFICuCr9iH/z]9[cc6\8oD_XNh\hv*1*(duprnLor=tqTu+op=UOn[PYeePHj}R)}GXC4kj?io.<93)M:S+}": a& = a& + 160
    Mid$(A$, a&, 160) = "z(=}_czz{N9_,8JC]4;2'WZ)A0kHJWX16LLLibf[C,,wHETu[iO{/nG0pah7RttP<ujl>y_007}t3LZ?+ut=27f562WG\(yFk-,a[DNc(xx0e]GY\:C'RY3^BCg[;If<6Vn,g{VnHZg*ph[-kr:7JiJA2Qy0_XrA": a& = a& + 160
    Mid$(A$, a&, 160) = "[3K.gvAv.OqTtyx]\q0WTJTGW^Rg-tM1}ndDFn?g^f2xMxBlnQImd27bk0(TM,yL{b98btY>r)?c^,e9vcDp1-,6+CdPl<;72rfVp^1M=tN{=m(o*mz_J9>4mQKBc2MYQ4S_tJaqzhkWu-v[p?Hm/ZRd41{JB9lp": a& = a& + 160
    Mid$(A$, a&, 160) = "6Z/V5E_TEt4LGnCICmg(N*v7XaKYU;+IBDNirp^:l/eKo}KV1^V'I?7+05s'>3?XuiOr:DI0WNjtqy36iC0=Ar]73:o2NA:ZgynG(7ju1}V3bA_ec7/sP+*?<.fZLXC.xpzK]^4\nuNC.r)R|h[{G3bR:MPDJRSt": a& = a& + 160
    Mid$(A$, a&, 160) = "y''/XszfbAEf>}))nNIYIf3U_XlV[lmrcSiUBkF*,yc=dh=6Af?MH)gBq?:{uhoTMoP|zuDpE}k}ZI.{0H7u0.>2Em.XTxlv[y[|O])*q**/5-nGq|po:j97Nr39o*j1Gtq-GM)>S?73H;7sx4A.sSRBH|x*'Y2c": a& = a& + 160
    Mid$(A$, a&, 160) = "Nta2\}P-F^xLc|2YGd;93A.|<vRyw,-l'M^k?VHPmozFknBg+}sLgmzbNpFXIaF]2??M<:tl2'-[30m|NaHHBmURR9'>jcid)CVQYLC30nz:5dkolws;8;L}TvSpF7AT0Lm;.Sqc,):wcP|:pQWi29qRgxZI8|iQ": a& = a& + 160
    Mid$(A$, a&, 160) = "Y'V.>Y[LwkU;0XIbO*G6(tW4cj0[q:]6Te|AJ-}dj4?gpU1p:-dz'O\;frJ6s,nVfO+5Lu_3h.Oh>C1w\xPFO3>VUeMc]6N2<Faxh6-oej>_ptnzME+Hf>Bh[E*r0mm,Aco8BQ+imn(Dt9h6zhbV18gQJ4uD-wI'": a& = a& + 160
    Mid$(A$, a&, 160) = "W:rf>PG7^RplssMU9e9nl:Z=^ax,vtg-k{'2ULE*j+Fs}w<g}\Zw,(lVE,vIGV(j*w2hOuPk2(mNW9kk)5<Ydt6gK?P:zr;]od,^y;+<o1x.dn2Og[JuB<{w=\.9vPT\P3dLe;w9_Cgl\ovZp/_w|>qUSl-]e_GA": a& = a& + 160
    Mid$(A$, a&, 160) = "(V:LSa][g=ObQM+iwG8zK06}[mFPyWyYwBPer')FBrvvS:w+nI/Pi_20exw{tQKlFj7}7D_'<h\-SdLd{2mgC*b/jO\U=vWG1:Emb.PXdGif,yej[E7]1_I=C\r[}pi:82)E=_4LBp_su.3l,QoVqXEmTbTyMFW4": a& = a& + 160
    Mid$(A$, a&, 160) = "w\\<mnH0L_TUd5zwNEB9io+P}xkHSjsNeL[R-pUU'6EtP3/d<E]\4wH/gF=_YH9jNK'Y}F1F3Pj:fE5+S-/DvJJ=S|HrigA,p?YK1UobD|70.3u/i\dtz60qTko|8H10|7)oMp55'];gJTE-X1l]3NV/MNeooVug": a& = a& + 160
    Mid$(A$, a&, 160) = "Wn}(69AoP|?6,Jq^LTJSenMVdX*yk]Xt*FUps<7PZP'xX.HrZ78bU7O+_YH^cDs.'|:NOyAOaXnbe|BRo]:q?bWQf6c?4QTI4oI>b1ZH60c=_Vd=IDxVoA_{K_WLX[ZYian/9(QImKfQQLq3PGD24*2Y2j\P<s=]": a& = a& + 160
    Mid$(A$, a&, 160) = ")O49'JtaVA1ayaP^3_PRkO3E|/U^:{T;G)AxQVvY>EgJn<T4)IS\akU_1VUlg<gNBu+y7_0bliN>N]A2j<0ymKaI;6ZCM0r97GIz6lhhy3xIVjY/f*Oo;Q2.:uWae(dN,uE?'*n2O;7MV><YXI'57l7w)d1,v{U4": a& = a& + 160
    Mid$(A$, a&, 160) = "Fe'*7+:v[90por2IGvBph/cGEswy6^^X.?+2\0WK\Xt>1/w.}Sxc/ZSJs?InJU-OursUVokQu]I'>6duD3t{MijYui42eBJnhVLwg*p3Nkv?a]m34t[Ks1YL0>aSfT?<HKQj9z]'>GhLmAr0c4zky\<Ut'4TjyFm": a& = a& + 160
    Mid$(A$, a&, 160) = "Grp(?nz5QjPpoeKVgBCa|qT}*\>uIA<7IRRQuLySdj8P-<Ts\d.U5a/.PlC]79DYP/:YiLpJU]zgjg[)2/FNb^+G/Q?l}?=kR/|+LO5q6mIj9o.EV{Dc+?Mi_^qxS<0DU7},:81(phti<zhQzV>]_j3L'0=pp9UY": a& = a& + 160
    Mid$(A$, a&, 160) = "kzzE\rDrK;AS(si5S;z}ko5SZz/qi--2(lSoj7-56s.MWXn-HU43.q7B)j:v(9pBkc9O.5fM6Bd/c=czBmE{5n/M(;PfJK4kHSan[jq-Q{2N7ItTT;xTkgYm5eR_{Q\zFK)k9rZi)EKwO0CZ^lB*m<VR|7cj*}BP": a& = a& + 160
    Mid$(A$, a&, 160) = "y^4X7O(tvlkX=53=u_fGA-<BnMvvki1,9anVL*K8.Rqr/Ak9_?SwX-/mlhoPN;I:4'E-wWhSs,RR4\HpUF[7S;V4c2.<d9A)'fDUcdv(Kmfr7cwLp{eQ:e7m\Ql).rJZ\*,otKXB)}an>Cb\o\)'Wvp(*Od{YkiA": a& = a& + 160
    Mid$(A$, a&, 160) = "EX3IY4I,.K)eYyNKOsyzY^ZGQCHd.N<RcTxdSrUS6C^l';g,UZQ0h^8{IFluZT6dTdKH0A+dI9Tv9fnF9L(plejlKLuW'4'UNa^Oy:U5vSkpmH5Q6PzeuaB}}Mto0e>[8Q]_eKx'zLZU>Qm'tj*+t80j>=R\1URZ": a& = a& + 160
    Mid$(A$, a&, 160) = "^G,oYO\tNwbnk+/VdNmRx_MbBE;}iwp_soyVKvPa'ozHyv+RavKe1|dFc;FiCQ[R6CP+T6g4<bL7*bm|)2yGj30VhxYSsp?-Gse<}\M8Wk26}a,4'q>Kn2|:hp)ZNJ-44SUAW]{l,4;]nV_J7k_b*te/xliWcV}9": a& = a& + 160
    Mid$(A$, a&, 160) = "QGk.:99LYH,oKM<TtaT|=*'tvIEo)wzy}6?(??6_|8^+]dYxMi*jNN;,?HwA11g){JGn3MT<2+8z1GA<Z(53T];F6b\+)S]6+_Ej=.MvesAhx-{Elx}toEQ10.bk|8?y}wZ+VoZflgv|c^p(\M8K5SOQRutIw+:b": a& = a& + 160
    Mid$(A$, a&, 160) = "VZ-o-qL1Z}eV{V]=FX7E<Cl3MT-s}l;YX+UPx>}o.hLP)367p-Ylvo:1vT='{rsLJ;),Up}vL-['fH[A<8md'xf*r+gM.v5\y5WPvA1Jh]QgjnbYlG9C*TPEArRuks/D^B2Ik}t?[1gQ}+-[VIHwRjQVRZ1Ju^0s": a& = a& + 160
    Mid$(A$, a&, 160) = "\I0Bveb5rWT8U1.++UtML>vw*Gt,-/q*0hZ}jE7e]Ut+AXxH/qZ932AM+QkeFS;Eq2yqzDxrN_fo'FV_AAg8Q6YMi^v:WY>=5*J.QVb{e,y?f-JP;hP_[mev9zR,NTT=kEb-?GGe7I?iV6aGNX:cF/NndLeYOSj>": a& = a& + 160
    Mid$(A$, a&, 160) = "GW?G('n3}u0n8f,Fa?LOy[R<Z9S52\iu]xynk'vDgfX8,<ugmVEP|U;Arqz[N\8qG5hRTk7ODPJv3RX.9b>niV{:[12{)y57<v(F;L+h7=DD;Kvl.v)il24cGFd<yNAlHIS?6-ngBgwy,=^avNy}]+Y1c|uQ?9a*": a& = a& + 160
    Mid$(A$, a&, 160) = "qM4:c7WPS*E';Jg}M*cufJNYPcRAJd[d?+H_pV^dZK9qoL>LnNH(sAzSsU]h<1T.M87E8xSng_V^6>GyN?o3a('IMgA)]H+9:f?|y7rBy[GcPY5:M|QcR0N.BAVW)_E(cj^/rrV:_<Zoy?AnbcvpJ{DHAL5B^:c_": a& = a& + 160
    Mid$(A$, a&, 160) = "'rp6ei'2K0dpi_RED}L{Yx0D{5n;RxW0lWU2:4S=uI}KF]2XV+xM<?pSr-/_?;7H'UdH)VXV81B-AsIWYSvP=YEWUjM\M[<2a7z'i^k+E]3gLNj)eZ+yQ;l3n:wzeBwe+vydZ^9w<8q;CltK]RR2_JMwbg{BI7r:": a& = a& + 160
    Mid$(A$, a&, 160) = "=Vg5lPfl>=GhPxRrvYBMFJpwSE[+l8Pu}M]fVzCHcV+i<(\vpIE/GZx*y9W}zj^F9^x9\6MSlZ..?9Neq+XL'|hSaeDFhHkARDb.TR>any'a>-7PjfYQb.oLzW).{N(},a0JbN;)\,EF(]b]'Je,]}tl]uDPi}<K": a& = a& + 160
    Mid$(A$, a&, 160) = ")fOHz=G:oSF5Mspl=5k/h\|\qj8{LPO/''JQuXq-NvLMhMBE6sfK*\Z-4_K8smk{U<7^x)qZv?:d1gL.2QGknu2l-IRRMZxSoQ/UC?BKEi=G_t,paDkIa=WCNG=C38iU{aW>J=C?=dnwoWbAXJ7*'_fFrGn'kTGl": a& = a& + 160
    Mid$(A$, a&, 160) = "uFG4Fr,xXVijfcXY.aSDCdikrH-TySnXv*+DBo6nZO<-y(<ruwVWhE6|JS4T7Fkgf+/_nEVPlWlB6)z<hSU:3.Nf?ItI:fX9a\Cj]>B0A-1DGTy:x^)yuj:[;sn1eIVO|0?HbP3A6[8B,91XVc)OCy'o9AmY]gH_": a& = a& + 160
    Mid$(A$, a&, 160) = "7f2HMzNZz'aMT{W:x*2HGJ<6LS*BbtDhoVJL(FyM[RxkKFkhKk.zZSG[u/)G8HBjTlQ1h0c=p2Kwc|7a1Rjw=GrKy'{JIC0jgbyj6+xPkM5z2Y^4kAY}K_[1ae{JCgKxWUgUWLGRgNF7V-[V^:2G\xdb}F_]q_<+": a& = a& + 160
    Mid$(A$, a&, 160) = "3KBGA[K'Gux/kO1^82ow(J|9b8(9dm]yU/n-Vq;(Ghhl5-6p+gn-e9.[d}l+]u^c>f'b}{Up^IY|*;VowG3AEoFHXA-v6_9ZI:A\K_u;{'V9UIPVI>TZ\Ye[kZouoBzO]s,2KEK<iwJ2z8n<2A_(??AsN_BA20tj": a& = a& + 160
    Mid$(A$, a&, 160) = "hxC=3|ir??JeG3hsgj(yw['mBSS1y6GA?}hGJIBrWe0]\?2GCoE+6og-/:]/.B}10DM^,D)z6AWdsiw)Rkh8c6p\P5-?byTRk:d4}XcjDn\3,Gf'uDi:IF7ad'/YbWcOz{]Fl)(+l(>fD>26?NH*g2htMmYVWYMK": a& = a& + 160
    Mid$(A$, a&, 160) = "=o-z|tlHN,HAc4-g+[^_lT]x-S)B'oX=>{Xv85?3A:_w,uqjSEokN<}/ocgx7RIM=laFa]21PZJ{/Gw<GE)+CxC>>.<C_Xh^<7GpP2]_;r].Io_YKCVUW1av0ZUX0=/{[?tHzo5^SpyTIjJ'CC:RW=?fFU7bu:Fk": a& = a& + 160
    Mid$(A$, a&, 160) = "I.UCI47YgF6:oD]r=70igJjv=-DUG{^tiN92hL'o<+w?-83By[fbrPw9YRq/-Z?BPIxoEnSvj<^2N}YMVAw75Mc9LpwA)kI37U1ma1}oKt,|\:BRFf1qYuDeWhyT?\4MV1O6XG?<:J>GFP)NLGOv/ub6v0nqP,5o": a& = a& + 160
    Mid$(A$, a&, 160) = "+]B4IB_O;QjG=;i5[KuQ?I/=7rMp=lPW.NSJlo|^BY*uP^Q]:YH.=B5lBR2p+Ce9wo,4^Kxy7BVVF_}kP?lZr*t.Fg48EMXG9z<KZ=\b55)81i7RP<|IcBj|0v0WSz]wi=)qoA|<Vyhm{47<bN+zB\gT^Y<ku}Q'": a& = a& + 160
    Mid$(A$, a&, 160) = "v(.LCI.t5tSvnPwVy;':xe,'u,7+,YoBDhO*;IHrj't}=+-IT5yxSUBIy\[;^Lm^6f0ipahEt^;qH<,ys{4tZl]TXaVm.t_=^1'Q'tM8aJ;(mMV,MkQli[r,pnQ9<P8fiLtw3:z-R?y:|O,t'itxbc>*igD1\ji}": a& = a& + 160
    Mid$(A$, a&, 160) = "7c'/N-A4/sEa/ogn:U4DC0jU7U7c008,hKDWRKr5k]q]lq9DSWkePFkLh_3CRo?Mo|0Of4F>;Y0aIoesfXK|U7gxw<(CYgVJu:/bY(P=j/'nObp'/i'Hj<b.(8cJf)l[*IPp+pUQo,z2Or+y4ejuk1D[Luq?<PJ*": a& = a& + 160
    Mid$(A$, a&, 160) = "aZZ)juj>YIHSpyhdI?wqe-2_k7N=GPd{3HNLydSzEUzG+sKVFJo?bkY\0-m<H3SuX-YPjm+2N9|Uc7f<2(GNB<9p7tH+rFyRi<n]]Ng+bW/i/Eie(Tan?)''mC6c|zLhnf12P5K*FFQ=uhanC8Je=kNF{IPn]Oo:": a& = a& + 160
    Mid$(A$, a&, 160) = "nvDp[XQBUu-MiZT8Rfkw;IK\LBiY?pv*BC1|;uWI?Ji6OD?Xk,i.qW_0KXYN.T?74{<DC^Cx9rJu.,d[ZgemTFQyWJZ'}4Or>IHF^\]}qwJK)[C6?,iPWTfZ8IHBosLGW{(=qx?EkmJRgN{-_U'34_wOs\|GVUS<": a& = a& + 160
    Mid$(A$, a&, 160) = "AoSYGsvT.^*QBJtQ86:,s:C^\g'dzfixtjwUIgh+*6YvX3f}F-K*?X.tS1Ni</1>^wj(yBA<CJtdJzJ_c,,hK./2\EVG>>od<3nYnj1Wstjj1XZS}}lk5bf1X-\4[6WL=ZdR6,;kZ-|=vMBgFQBm;wYOv3:Y]y4m": a& = a& + 160
    Mid$(A$, a&, 160) = "f\6}C68?*+H3peig_up|X4W,<Nq'D==t2CMz1qWb,WW]Z6+k}KHJB<r_mBfiKvVg+|>-.^^q1?(tiQPl6_.t4,0V4='wHeQridPkKtdw[,v6U\09*b4B_axc6j:-7Dzco3,Ae*PEKQ|l1<x-F*/lI+WSt\9_-i[D": a& = a& + 160
    Mid$(A$, a&, 160) = "|HAcX'=ZM:ECOq)KA2;7IqlHuS:aY9T1u7.a3LjU)Rx7lZ]jm7Sg{Mt0<=ezN5t?Ms0t.N_z\vnW2kE?pe;x(qX9w2o_?Wm4-9zSs*KX8{Y3=J<ZV1+pwRJ81;gU8-_.IW3p{l[]Wb.kJ=62rB?gvi7cS_4pbTjz": a& = a& + 160
    Mid$(A$, a&, 160) = "ZY0Irl9Br{[)0D'h\Spl(sec016Fwl:QO0IUP7LROt'c:z/VZN:_q98JdLLNONO6BkT=BHxC}.e9[MH-|JsUT;WdAJUMJi?<AM=1VQYSo8(X[1ywqbHjlkQZVEiLa'LJ;3fQ_7_g_E8L9GL/p.XAzq>en-qN5gMy": a& = a& + 160
    Mid$(A$, a&, 160) = "-^zJm'Y6UqjVrRiJil'Q5E_051H*bVLPN}C5Ra*y5'ujTrQRPpz=Wd3Z2K^[hn;w>fJmLonZLjHujBL{+t4y'Ov;tk;]+>I8-8\(HrlMz*h\e//+bk<N:;]XX[3'jBG.hog1Lbk8h.tvARML*fR'Wo>Fru1yVYZb": a& = a& + 160
    Mid$(A$, a&, 160) = "2Lyr{)orH95wjbk51>B8e0(qvQV.)7{L:w_oBE^*bETG4)iPlRCOk\HhulG;RpS,H-^rv08F7L:w2z'WP2[{Z{gB;5h7.vX0y}_j:Ybxq|*mNMy]=6mU-PFNMX86,aqk1jwuIDYfGQm7ns{AJQj|>XeeZ*od\pBC": a& = a& + 160
    Mid$(A$, a&, 160) = ";y}(:J,YRd6[G-m6YR,gyL-1?GW5().=)cs9;Y|ID[\{GG\75hq8RcivDc3hAMLpg4_>?ZcM>-|X/7'Hk(JXEL:gDk5=vVWJkn<YVx]tsaq?r;A*0;;['eGP:2eVTr:|=4F8Fa*)?fBEkSJ7?/*0/K5=i6S<>04P": a& = a& + 160
    Mid$(A$, a&, 160) = "MJjTKMEB41afv>1[=-5?J8S{r=1Zu})QS<=p\CSw:e:9UL70LP.]t-9zNfrvCbxtKpqS:3EFe*??1SlH<w4k(phbk>U;(UWQf[Vysr0EIbkNlg'7dfP\,T<>>1S{)Zg}lAm?1i:PJar*AqYk:tAn;z1gV+/3_}O|": a& = a& + 160
    Mid$(A$, a&, 160) = "FdM<'\i4h-|?dVsx'ye4Zm58Q(ZkPhD\>fZVGnF{J.U1uk39p83.0BsJHn5BS-Q-o5hA)_25D*dOy41/2U;OVz7FJ3AQpk(qiV<dNKIyB6ZY\pp8qEjOc/98\v=qUzc:AFAgye8hQL+,>f>S'cwx>E+mz-9esTU3": a& = a& + 160
    Mid$(A$, a&, 160) = "}o}}1kUx[cv<HV<yY'|S>DgtGoUm^[eZ>B;^CC)Yqe6{m.oG8FD/tia36q{Q4Vt');^q*|y-?<hV.rI-V>Z(;ZsXbLj6a6^]Wf0:ju7Wg7CEIw*m10WS6BW:OcL.iQ*QB/vF1LprtE|<IsN[IK)nwM-Q7JKPpVLz": a& = a& + 160
    Mid$(A$, a&, 160) = "e[eOOQq4G^3'S_(rjdLZ{e\4[eYqTJ4q9)'NuFTqKfdCJE_mPT1fCOgWaiRMoMLq}F7.tc/?wTb'[{oGPqN8v6OvP\C^d6AzK_q<*MY7P8T:uC46>J.cX?2e[X)_c'g=VRr)++chxs.]DmP<xhyP-]'0{VXRMml3": a& = a& + 160
    Mid$(A$, a&, 160) = "U9_DUkuq}uNNdBMFpyL/zj^Y.IUv9c2E*sg-mgZ3aN0bPFO*|2C2n6<Ph0.I:VJS8CfiiuE8z|{uvIu4+Uzp\nec0^?3jMULkD0YMNPD/?wIt[kbaa[[6bXnuCl.|e7Nm|\3Fd|MeCORcT4a3<PhWU15v{zpTA.3": a& = a& + 160
    Mid$(A$, a&, 160) = "[H^B*7\MwI21M*FwmBi[MNMK_XMFl;Ey\qx-AoVTz,Sh2iDMvzJ:|}'|4H>ED<8mUTR^yh?Yy,IBKMD[w.0zUicJ=hIqKu8]^SAhA6)/{INR'O[/SeT^P:61r05*_59T>:qz*3Wl.vem|vVXQ-c(TKWJlq:D4/xd": a& = a& + 160
    Mid$(A$, a&, 160) = ">hM3Y*29_91o,p[-Q9DnzGa3D[pppg'8KAF3uTLI=iBFAq:wG|-8]<]4XdfoOmPf7:Ldv'}SY8EQ79\mm'=TA_+c4Gep50otkLL1)6aFtj0+P]1KAe,d.0cD60{?21W|L*/P-L:y3q/^rtC1f3nqIjTiZys7+s4s": a& = a& + 160
    Mid$(A$, a&, 160) = "RwbN'I*[ICMFGxgq[<dn-)<o*tkj<L9'?;}Vv,fm;OzxlF)AG6N6?V3w.uSnfac]L|v*Zs9O0pxC\225XXYF.Gy6D4.1+O(P(I[eq2/l=s;)BcBm;UULev2{Q::WQ]?YAqAfJ;]/m|Lar9E9fh2xG|k5*nYl<eQn": a& = a& + 160
    Mid$(A$, a&, 160) = "NtZ>F4^eaA'waA/jXGP>;(uHkZ)rbB'by6|ULVL<br;e1,1Aw.|Y[hsOI68aoKn-,wi9]nO1yYKr[:n47>x4='x<EBLQ(JVt/eW9RDlxH(RAX8>cA*r'da<AS^i0A9NzIC022}s0v:MKuCrgvbi(sc2Id^8tW+sN": a& = a& + 160
    Mid$(A$, a&, 160) = "}EV_l;lmrVx_M;Ulhs)J9UeuE04W-lX<bp(DShAsxE9QJiRH[2[y0}bg^|jc)d}h[7w(YzY4zqlNaAAv?g(fk-\1LWP.=l1)tS4/}zMB<ttX'Sakgw7;]/<'b(Ra^_m>TC*lJNWP.=?>4Vgwgp0oo,*\UHWRb6xS": a& = a& + 160
    Mid$(A$, a&, 160) = "Yhx;(L.qDFRApq()l3Pss-0/:]Q7)20upYFwkp]BQ:45Jp]-a-t'o'8qmavRw+oqR[7B7IN=lAP<eoc'F')|\QSs{I:D:ssQWc|J=\^+IgT2J\;/tzAN=n5zuM;e|H10h]tDsr1Wys58<vWNNLfFYH=Bbl1}(=qH": a& = a& + 160
    Mid$(A$, a&, 160) = "r7zSnQuiVU'F4v619gcXKM8q(k6+]>LB'>>CgZjF6NjR<sud+Z{dw5rYZUhx?89x0KBKA>q=P.}9-Z>1Rk?eF\:dkCX:.6;Ie2P'J_58ODwQWhsMmV6C?m*AIUdY]ZF0IJp2_*x/413TdMd4o;({5MD)heTikPx8": a& = a& + 160
    Mid$(A$, a&, 160) = "KKsq)wV5tU-fH/wI=DE{nK2|X'\'P99a+_8DPe?gcqxm,-oC9^Lhtp(\XH|RMdx=C)5O(zyMCkoJe7S}v5_>5H(]P^FL<2yQvKjA>qGT-D*X66IFKHlhtfRIBN[+=iJDcI6;uR;BWwAmPP]Ync7(t[z/7Eak>Dln": a& = a& + 160
    Mid$(A$, a&, 160) = "cFM*6zI,Uh[K_)}3/^^jAH?92gCD(aMS,,[dLgssYhABv*bN<K?QoUGcp]:h4m50?WDx'Xwx,1G=.m'(Kx-j+8TE4.3V<[Nh.HgIB;_u-9SA|NLs|GdGCh/o;_YbTf>w5>n0xeLIgLu=.>-/xEbR|^h=pg^QCt2t": a& = a& + 160
    Mid$(A$, a&, 160) = "Jm_K}2P1UKLD2_EA{<(VpXMcfg_.'a7PO=vvU86FvcuuxL^F8B6^hZxfKs9UW=oj-_UGVFKbo]vH2?5/0yF5|fqoGSJnnqOS9rR|bZ>hbNG'7zx^8Y44zaC9)gG:I((UA]>KYEy<abj^b\-ud7]b?1bpk}y/BSO'": a& = a& + 160
    Mid$(A$, a&, 160) = "1jR_et8axvXa^NQ/g6q'rv7jF56r(w8(RTVE0U5jGmrOw/h-TF>WM6CYlMqz(vw{k;H7qR:1r,UU<L1uwm9[>g;g1,}r>\l'\wQjf[5[2[]Eeqb5y-Gu\s)*H-muN:cR'++RcR9Ocp5>s<w.(nV.-mQQAFQbY},A": a& = a& + 160
    Mid$(A$, a&, 160) = "6O=jy.HjWBFs_}2*oI=.X5J?5e;h:P=v<?4i0:=jKD9/{k^p(6qp9;|h7.z=Ch]z\hKYNwf9Y_]1ixo,bTEFuKPl:IrgbUdoU3^de3oJ[LocNF)dB'/[1Y2ngN[k>a9cAf3GrN/b5wMQIWSJ;R-AE+Yfl4]hnL'h": a& = a& + 160
    Mid$(A$, a&, 160) = "EMrKxxsHi00bGsU]3tJh}etUXAp=:]LrLH+M]{/5bdaNm]NVQ5Rq\5b[nNm/8^D]mKHoQsq/xD>a9-5:i=3eSu=20F{X_PvC4'_T1vQ2PVy}P.{fIs(JCq^ROF*cAcPjphiBlP\tdt<baIRp=O:}>{}yU,3DF\;;": a& = a& + 160
    Mid$(A$, a&, 160) = "=DL[<\BFYGF0H1ONUNF{M6nE-S;]/qdm/igNX}Qo)6Zs6^wO9wYBJ,X0jUv2>oyWNxfSKJVB*s[Rh{N8T;yyN_lYVv:-3hG4(vOuY,K>wjj3=,TJMjKCu},mRMzk?l_bBd[k{:LZ2I):l4kj)<9Jipz1xThem,\e": a& = a& + 160
    Mid$(A$, a&, 160) = "P<^zo}d--w(q((y_hvAG\gY>/1xFJ>0RDoDoas7;r7:^Ca5Cy^axPiur__5WGovgEkkj0kB1-<AbW3W9uRVG_ONQ[*VN)a?_-io;wnK>rcLIyVwF)?>DigQ+fD93_NE=3V96oIVc'Xe'}6dogS+3brqB<zP(L?K]": a& = a& + 160
    Mid$(A$, a&, 160) = "hZf2GKm\m?hmf*G=7jWym+Jl0e(yEZj/Da}Uw^RaS);AUEP5.q[7/V0<^bn>LMP;?'YUzHg1e5m;<s)i9Rm:3x(AQh:)0jr];+ejgA?yKxo=D[^/,U2z4BNqVUmR-Z\DjE]2h9SjVfcRRBbe\'x^t}^h8L;V-7Y,": a& = a& + 160
    Mid$(A$, a&, 160) = "4Y<bC-BbJa^C-(DR3e(V,\WMS=S0UaOWBr/Z/K'8<t}r(w)AmOO[*00_RqA9|Ag0K2<Zb/MVNS}Ud'sfV{+JQnmmTky==*n./6gMob9:Iez3i?n0qOe[el6z,T^KNG?>ja3(V]Cu0,A'*UxqZH3uwO6lw,i)Mn-5": a& = a& + 160
    Mid$(A$, a&, 160) = "0m2wT+iL^::2w,UX>/(4;=,WNKU:pB+0D./:kaLv{?;2+hKUIV)kZG8.H}2f*pJH|k>H?TD^KZzm+lMfAdy*J-0]uH?0NE9|mW:utN'\13mq:Z:bFNhPVS>+*3uPb(Oi<Gbq2^D:GH{Z3;{vPnS2xibb;+:r1tY3": a& = a& + 160
    Mid$(A$, a&, 160) = "/b29{C3kLrmS(4]MSaB/JC\S5rxTN{IW/o[j<Z.]x9icbQEn_m-PG\)fACC1;Ml|A7MeGyBQbrt,8c7E(]OXr(>Nh{LE'<=}vY8,K99'{8kx3LpBXDnu_Cwions+:vtOe,ul0pA?Bj9Vh/e[|0J67[J(ngW>ZX.w": a& = a& + 160
    Mid$(A$, a&, 160) = "<ZZ2Y><47kBZxxq}'prp]PUT9B{.u_9tb3>Uuhi?]o,5{)8NaYl0}N+E/XrJn:|m;T,8eJYS,-X1dtR<.Ch=Gj0';;df4Chy=k5h1>yyrmx}m{?B6/<\5qF/Ty*G\\qB4{AF)w\uLv7<?*fu;gd,cci*,vjgH5ct": a& = a& + 160
    Mid$(A$, a&, 160) = "HF=MN=4aDS\fdZ6t_wJF<e]D;1AKG-gQ4ZXcD?y\tB5);/tYmeY0eZG2,P<fJM^i.FNyr8bbLX.3vobaooCb,:z*ELZ[1Opz=SJ8-+|UHs?qy4wfc<[PKeWnN\ByfB+r\jyL1WOhD_a309cF0]Mj?5YBGGMlTBg4": a& = a& + 160
    Mid$(A$, a&, 160) = "(fVSulqVAU]E(c2{]E{]awpA44OPZ=HbSHn<iN-no\XI7h4=pNcaMlx2wIzd4Hf*G=sv4zk(,5v++?NS)[QxWUF_55\BpZQ:-c-TyjN2B+8L7pjwm:wa14E{]iwHx/qVtIfdsEz5rwIUM1FsRv.;>Ko7J)W|f6VF": a& = a& + 160
    Mid$(A$, a&, 160) = "*;6}Q6R5N>nl/UpF:\FDp[N;>-zWyb57K';hgvW2(9>9-w7vo;qGmbqZ9sMdF*{bm''CiqC8r'cX9q+*6FLO8tsy7Y7>'3gx1BS>X..qjb:IH7nN|b'7(Au|ps2l4_EfDHoFIkKKQ]iJ(5tyQ7b:cp*9^_|l^hC0": a& = a& + 160
    Mid$(A$, a&, 160) = "qMvPFA2urPF_u1fTDHh9H.4.+SjDo}QIULw{(5LxtsrMZVgV7qWI{qFDm'd}B'l+cA-M{D4jfm'(JQy:fRxz42.M{>L2prcS*I3L9?\0<=]_)AajLyg;6c,)PL_HDCF>w:,zREp\<a]Cy2.wO2m<E+-[Giu5RiAQ": a& = a& + 160
    Mid$(A$, a&, 160) = "FiZ*A<,vh]AYX,Hzb,s97sj=D2pvq^M^Gu<U)_CrD00tsn.u];|kR[_i].=}Oh]MVKm.6KtR)k>02Gq06EW7\v6:ALbGk8+X(|V<b,T/<8<|=]]FnQRotprZkj2rF^Vv}Z*5,/<L0A{<;Z|L8>HE5-7JrsySk}k3": a& = a& + 160
    Mid$(A$, a&, 160) = "+,2f4>aA'|Eu7C47GPzh'\H8]t),>H}:utB:jca>+hdgAac:):tyCar.c_r}fwzAp}WG(j{6v}((m{>i9:)kstqlM3ZYVS}5I<7jPje9YSRB)AKdtg.\)B/pn+Y|rEiwm+gh-?0W5n'F_\7}CSlKDYrcs8UpT9)2": a& = a& + 160
    Mid$(A$, a&, 160) = "vDPtnYNgrjon;3fD^rrIuNGBpMXnlq|fNsOcZykK+X\Ej*eD/Oq/(bVQtG/5?wH,Y\ru3a'E33VkfZPve_466:5f3,=ZQN1?c']<fT,oW0*2qS-fzHdI8WC]PKDYg+JNGERM8,xO7]G(YHrg|_7ypjBU)zPJmptT": a& = a& + 160
    Mid$(A$, a&, 160) = "7zC[u41<u^|3JbhO(}q1U2,nAK3Rl3'>ofs+03C14d+onw0q]p5244'KMF(fwV)+(QBci3iPAcdA(Axv2<5KVl\U4=tFyRJ3FCuQ1EWn?<wCmK1QAvQ1sE:MrC/sLXI1j=\,uK[t;bl82eD=8|etP)[O,L1}BL6;": a& = a& + 160
    Mid$(A$, a&, 160) = "6Jl3Vq]SIMttQT?v1v}JFKP^t4,2LM]+)_Mc-].CJw9FCQJ3*uiE*(YVi(2Pnd14S5-R}PPk:EqrcE5\KTJ4P2./Yni\f2G\R2.)gRIBGZ;S8ZzZVeXL7^3XhiwH*hjc;Ak'9Twr?=UQY=LxF[u:55m>2:kJ2wl^": a& = a& + 160
    Mid$(A$, a&, 160) = "M=wn=?Jt2Mt;C-xa2|'S;S1ws6]^d36iEL{dI/KF5*xt5yp-J_PRzNl2y.U?N-c9M5dKwP[<q-.)tB)Q+p1\CEA9o-[OYS9OY?hZ8^02JV4mqpa?P}Xp';vOnF}K6++b78'->o*nmn*b9?IIIq)S/UbP\TaJWj96": a& = a& + 160
    Mid$(A$, a&, 160) = "3,GCju7oZqAt;d],)U=FqUGz'bVqqvU^bn=U88J;biu>EK/F)hYezBBl(x0lVGTNPUNgrsXunq\ci1eKeF)QX/Mb)'><ID[kxyuV[Z5r7,uvz*Dlj>-y,R;D_-F\G=/u[O5QNH:l_v+mL_G>}tJ\39O1i:]:7e]i": a& = a& + 160
    Mid$(A$, a&, 160) = ")E{l2aIv0.Wx;1/wm9or6w}Jq}j-++G>3)U.bJTs9'?(AxH80Q/Jf7/P1O]V?p(lgNbyRj,bwJ,Mq?kKSvZ[U[.y)iJO^]<S]m<>Bd^R[28PzfB9>^eD.bk[=1nyxhN|R(}i-v2^1?eMKOYMqm^.3xCX-6)8*MJ/": a& = a& + 160
    Mid$(A$, a&, 160) = "ivpyhsPG}gNXGMUyi0z>z*g9(g;n[ba+adH?IVHfaiHt8HgDzFFRlBg2'JQbpDni^uQ0JJ-Ukk{/fJd4UP:^FC<(x{n6Mi*c,\MV5wGOmZ/LX2rH\*tMtYV0}^XR>fQX+6F'tk2aB4f/5mXfR*0vr<jD1kLkgx}j": a& = a& + 160
    Mid$(A$, a&, 160) = "HDQE^z\XQ+_vlkM(i5Guz.v3yY?)u,*26UCkhgDfwq4Lpr<MKoxZ2TD4*RM4ay/2y2pCkPt)vhWt^/slxqp3ubyJK0eCQbG}LVz77Rjc<Y8RDSP+r0^AVr?4e,L'afJ]=Dj+?Cef?PDMu4x9eaz+z3-TC-*G<xy'": a& = a& + 160
    Mid$(A$, a&, 160) = "<E9p,I>eZM-w-m9V8BnTgM6h88M6q824yg.*5eaqNoyd4gDtOPRr'3xEz1AcEP(KM|3Pz?WX9Ua6M}QP}S+*fdk<5*xYOt|Cyu.ZgefJN=HK/TfZ(0i*:yvMLyY;.V/_[,:Ce4_CfT1|v2XOJQqDS.zBKHvI1Z>y": a& = a& + 160
    Mid$(A$, a&, 160) = "vYbb|k,9Qg(Lc'i>bOwFX-71G'gPC|W;,I^Sgl7U7s-BxZf4K6f^SyeQV+E|aCpEzZt/I}]U\tVo*AU_JiB<|Iifdc_QioVFapwW?xOwzafoAH[1*4p46}aCOqVe}QXMUXNPgB={,8LlY-?W<tiDWULen\t(tF[3": a& = a& + 160
    Mid$(A$, a&, 160) = "jxXb<B;:Dl,yYdUN/ap/6*rOa/uMbQab0XCewB_i:m>Uuu6qzU=e}EYd_3MW;CpNnEiRI95>HXN/wYGa[8w)jM-[n6KwCYsA\:|3sbN=2mwu=cGDs:2UESsK']b0f[kZo,JWhJ''{('p-1oXOI]}[KLa]z?0ioG4": a& = a& + 160
    Mid$(A$, a&, 160) = "eEV(V2n4Q/iy6|RQO{FZtQQ]iNzl|gn-P55GN^bUN8+y,ju\+?-;Z=6+kGp+jF/+)\GhhGXnFL3lBC}}]B(}n];xB(BMYxd91po[{fu'r6ujLI^mD5{iki8Z>Qs?Jf:IBTz[}z*IXwjGw7Ec2E\6U)>{,\Er:r'<": a& = a& + 160
    Mid$(A$, a&, 160) = "HW;wmc'<b?9rK7Ml5SSkK,QiWI'=q|n'_1JbujsFuTtR38)2B;yuWf'+Y<[/)qCkckpwfu5nrYUe(4\i'_)uS7A/hgx-o[}^Ap2I;mlc7fRB1;/WRHHXE*-30wii(iwY})d]tJiK]+gHVz1N{Guwej(h3O7vUZcO": a& = a& + 160
    Mid$(A$, a&, 160) = "Vyq4b6lIy)}pzbxl'_g?I2NiGd.fb-omiPTRPYD;5j.dW=nc3ePU7axrhM+zk;UW}5p]H38*o2?UO5sh5X*:/?VNR72vgD8U6j(QU76(31)Il:g;B[q),oR9L^'[S/8N*<4XYAL-DtgK=f/r2w1bV{q/-zxS;YsH": a& = a& + 160
    Mid$(A$, a&, 160) = "'bfRB8zrFt<iA4EQ<;KVhh=XYOH3I3'Vv:Cwng}/gf][LXHu]vHuxIgYs{(62Y/nmZ'^NETqpXtF_uKjyjIsi^:o9|3J<(_v?\bq:Oqf35+DLdjvRWc_hae2KciSV4ie/|xIDa6hG}0S,xnzi{tr)\?g_BK)pN>0": a& = a& + 160
    Mid$(A$, a&, 160) = ",]zZZd(E6S}=Yb7)he5_m63R5hyl1_}L:-:{=jgqVs4jYYMwh(50MZf?UTuo'LA1,{Ux*[9vw3QT_Q5/PXHBdo-?s*rT=[Xe0Y-[3YNavaa\0TiFJNCe)Ce8|<6PjU==uenS6bpjpX9Duf[7(1^C0N\*IZ{,N-E3": a& = a& + 160
    Mid$(A$, a&, 160) = "hC4iPYtB\'fxqWk>1)lIcROi=gUV|r1aT\YhYg09{c6kTZv4cR7;*bbBW_tzaKTyi|mI92_y-Lv/?Q-th,EQo{.-JDXKWUs:g[|jkLRR]P^6rypYXTvaKd0]7?kUdM?:Us-3-Cgng+M|XbokJnarEEgg/3kn.xaV": a& = a& + 160
    Mid$(A$, a&, 160) = "UKfyGU*cs[_z;5OyH/GMT)O7cC1(PERj4Q<T.P2)\56+eZmoRw]a).acK+pfkqPQt])Ch7r-/{-;[m]^][Nv5'KLq:U5yJkp2[7s?Z'=sn;W;^{Cfth3TY4g{ZG}':8BlD-7cDtnwMOy?=XJrK0SRAi/:MVUIQdk": a& = a& + 160
    Mid$(A$, a&, 160) = "NwM{B3y^t?xMbVgH(5Qih0ap-P<*;[ciDaKmOKgM3=Tw59'TS,1M-a_FIE=na;:GM1MfZp-GW,UW688BsL7<]Xm4l*Xow>WFy=2t(yp|AF.Pr7)4Mhw*:AOp6NAQ.UF;BhE3+9.^u5sN-9(gbp>Yv=vkzlQ{]LPM": a& = a& + 160
    Mid$(A$, a&, 160) = "2Y{C<6o7-EzANwnb=dIYp6aX0,qKcDS'h9z;s=ic4Mk?:,nf}aAE=?^Pj^RooZ*?p5HpBTYcqm|,DG/p}*<-mi6g}<lJRx;_;*yi.d{{[Cws0n9IuD*Xb_cB3CUiGn8e2mB=yZy?1(<)Wix'S6oAu>dgPC-cCSEZ": a& = a& + 160
    Mid$(A$, a&, 160) = "wnIG1C[Igj;3|j{2[Otz<4R8]ZYZUr3Ydj|wK=;b[,y]/Nd^V8^ySpYQ7MAWwEUD'(ecd/141sp[QPMYDauM>49]\)5I{'7J]Q)8RxMT}gqt:MxRQRLqyNJpn[L-06q=ZFZ\^?8S(L73?KWZ=C3=H(JZ+AM7GBiM": a& = a& + 160
    Mid$(A$, a&, 160) = "<5uti[PJKHA(jMD6[]>u0tG)R4)3rpw:z8YLt|yiY1.s53w8C'7+ik'.K{4?0nR*8Y4[^K8{4JS1ufjs1t.*^J'OlGZ0rj;xz]/FuxgD)l7IeYdyu5dgmLEAFxIo=10qVpEKCOtzWU]P^B-Dm0<l4AdQn\>Dc8/6": a& = a& + 160
    Mid$(A$, a&, 160) = "9sI)[}bGU)>.+RC3V('\5>4e\vhs5vh-}<l6^2VUL/G-1^J9sMq(7jAGd[bD|b7gKl1p*JwIBd<sQ4T8+>Jma.)A;]5g<N\d,V;muckQBdo-o\[iF*xkrQtnSsjGjK1Bz/+oI\rpgQeb2?4jl]CRL/|oE\PiXQHD": a& = a& + 160
    Mid$(A$, a&, 160) = "/[zM-=QWL9)4KTf42:GKi,Ym[CMrc9Lzq=XJR*v0*<rwE/IxqA-5t.IF^]58=?4AD;RptDgEORj0HCU',k0]GMp:wWZVI>Zif,Ym=6o3,'W1hSoRz>xRL)Zc}oE/D<d9r<AhlVK_Hj;tcu{J;Bb95EeDi0iURRYV": a& = a& + 160
    Mid$(A$, a&, 160) = "nwQqTW.]lO]m|80('}Dg<:vFy}]/d4K(]\ECW*]Z?mQa/JS?o>_-qkpKw06xv.JpK*r0xJVT}L(s<\BX3Y9*R/B7;F8>w0\Kcd((2g{Dgh6(\;,^(SE=;]Ve]d2[=Yk?B}(5mZ\mQS5q,d]9M>F_nPQs*W5CmRa4": a& = a& + 160
    Mid$(A$, a&, 160) = "ySA0YN>7?SK=igg,g?C?qS]1./PFDPSdZRfDo,?^wiTA7DLbZae(cNWzCKyUWj0AC+?2=F]gXMXNGERrzp.Kl]/IgHZF]kmG):p{[XOtbMnb1AgzEKS9DwTy<_ZsBMpAYn-Fa.q\w'_+9W=wfaOfv}n<hR])0=0H": a& = a& + 160
    Mid$(A$, a&, 160) = "+]<*PiQN[IUgU{zCsHv-14CVpH(P>-7lAcUQ6KN:]3It-\R{X5TdjSDKLIM]qP\enHTpVJfX3cY.yX=T<InmNJ[?qswQlfA)L+f;Pb'9,ymUVkGdD+ug15HtZ)RxS'^xF9:VU6?:U2^A):Oz-NqvPW)35+EazU/7": a& = a& + 160
    Mid$(A$, a&, 160) = "w9::J8.X|F9yUg;3./\IF6-Ovr^O*E]tfoDRR9*n1'btlgl3/-b<lSbxL7Q\rlU,M*.08iAp8JU-+-]k/W4F:n_tR?.s];*U7o.o{7h,,/a2XTN];ImbF]HyUv:'g*VHtPyVt3Ut7xgg]Z)Rcu=W(iclllAJ*jSJ": a& = a& + 160
    Mid$(A$, a&, 160) = "vsB\)6Sby2W7<z|nAh6vWOhzv_;w7<btcyL,vGs|DmZDLrUKwM_?tP6Az5<9EH[0n*'n.:tUrRaj)2{86U|+HI0*LNc.a'7rF{QUr\,jZ8>0JU;Cl<P4o;k_o=KxWdY'qAM(9|.0)yrE7AYCrI3yXrgTl|/dSwPn": a& = a& + 160
    Mid$(A$, a&, 160) = ",y/Kaf^s|Ig^W75E4h{bot,;4/m{t?2KvT|aQ.Ri71dlp.(mqPMo+{kEX3F|yB2XZtrbvW\]]d[5wn*?eID=Xk3mE1|;jujGGi2{V?L4IgbHUcirpRZ-yeabD[vZigukV|N<}y^qLE[}Vz8dj3JkJ}VJ[J)Zc}G,": a& = a& + 160
    Mid$(A$, a&, 160) = ".]a_9fg(bt?QFzXdW2?\k;'N}_nUPmTfXZy9;tn?7Y9dz4aksx\F2m.[kCjn5fu>\.VNY35F9\NhjBRQ9Ho4,^gZvWg/re7)/g'E+:i|cnWOOS_A1I-k[6h](0<JI6jz<1K6{-\(aL?H5T8_kV;,[M']SMOqHiix": a& = a& + 160
    Mid$(A$, a&, 160) = "Kh8TGti>3ix.ir*1H,X9kuhOaH)6Cp\jK9g.)VMyrx<5v_h-mN1;HT:5{7e.LQQ_T_f9*MNyISbfe;-hR5+NrpRgOi';8ab?zM_gMiv)[(WP8A<-}<vm>Y1H|^=Pn\E[5Kybpx9/sUQdcpe]^jK.BNhiWeyRr\L-": a& = a& + 160
    Mid$(A$, a&, 160) = "xwy?ln'iQ0}V?])-1vv,G^9knPxJ(Q=TfhbN[9kR4OJRDdzC)VQ6Zxs8dPA{u*Y<bI6BZblU<g/jwzeEnFuMZH+Ch?o[)db\'ln?y^z'<c,rLNWk4tbuCMF3{gxpL|afVDok4wW9>q2D9Ky{dwyn{VfV4Evs<)1N": a& = a& + 160
    Mid$(A$, a&, 160) = "?;]I2omOHcvfI4BIL+9RipC[P'bSQx_xz)9=)>|y9tj|mw3Qzb/rwu|d:UDCEQ6-}8<6Bs{nT]T*-GOGX1/a4Ve5r*Doe0Er7??'}4]DgYQO7,\-ik9{m,YUTjsuv=+*17O.itvPr>l'j]?Zjbb^r)cH7N,0Pfz+": a& = a& + 160
    Mid$(A$, a&, 160) = "A0jXsMcnsbQ9t|tTShHJipXWEtO?.XtyL>L2tZ<[Na.A[9Whi|fas:NLW9oB=_hgq}1a<+QzW(xsbm6UKykopREjH'0qH'):QM'tq-O9'YOXSi_V*wa{)pd,fH,peF0y8MAQ'o^yyL*a=UZ\oXUiCV22Xyx[uFTX": a& = a& + 160
    Mid$(A$, a&, 160) = "=]BbPl/xV1b*6*EaraZmGq<W6KPjw?^zSsT.3L(AE/[*7;IgquMkqbgp9<SupWfAFdX/:<e,W?w1vcS82f)vc'C9sgxT{<cjD53)jr(jGz0+}c_0*G6Ea}p6(HoPzn1AdU1N55Ddo>oJ']\Dmx.a)?gT)WEqgEIu": a& = a& + 160
    Mid$(A$, a&, 160) = "0KBkC<S3v/D3hJCZ0ZA_9Mzod.6ZnkxGNOM5M{/w}ALk=o/vF/eFfaQ].{0vX_4iBl/p6K+lkhH<O[mF:{)B3k){x_XCvIAZZo9|TH=Y'wJSU,4cUh?sh>Cj]77I?'hodyz^pREJtTJSZ>1mSo<V1NX,aZKy+DJg": a& = a& + 160
    Mid$(A$, a&, 160) = "3Nh*5t:wn:<1y[+vgE13nsA]IJ5-oTW/q'KksSwztSbuWWs0(K_F|U0>atukwIYfUq+|':f^8ID1(}fvZZo:MSB2^HoP-ipmDxi.43pl^\*9VP8PeJ_|ikuMVpZTPB{3s{;X3v+gNq/se55HpQQ8<X:m?e*.HkQM": a& = a& + 160
    Mid$(A$, a&, 160) = "yv]Wkka,QZNY{{mo:w0/_sbKw)gFp,QLlB|_O/b,M4T8h,b8puh6v6huGR2st0Jv|KLj=3GbvSa0u|p?S+YIGg1DBOd[FS8bsUaWAX82fxC*9LP)O})QfG0'zox0/RLZ[K*vZqj\e1-2X9j27H9+,tKS.evFQ*9q": a& = a& + 160
    Mid$(A$, a&, 160) = ")topvBifDHyy;ZvN[T31l,ITa5Wf:h|5XX;HEem\G=BBTvSis:nxe1R-eu3DP1]EGmP}x^5<(S6mEMs[N5Lcyw__x[<ZIVeK3r?BQDW3sBgO^P8sBPJANf:Z/QlF_OCcQZV3RgiBO*S-n(ZuAnwZmR_9YVOw\F^a": a& = a& + 160
    Mid$(A$, a&, 160) = "MTz7)=+7nloB94}9hfaqHD6HkbTW6791j\>29mXU*UgP}}Baanb:XB7-Q3?p^+2lbDW:6Z\zzZguC{LRIUO8}=aAVJaRwLUN>r/6o6\2JnjBpOTF7'S:GAl^HZ]ka_z9SHfjsh{V8)vRj]bhaO]6vo-;QRJsfM\3": a& = a& + 160
    Mid$(A$, a&, 160) = "8h(t=nmhbL4;8.*fp6)+SYtf75*aeOff3oQq6cZoAHyEQPzBXNqA0|;<v[yNrA)HAYOruRTv?Innr'P(Wv2koDYWpiDa]HJ]TC7WDZvg7IbV_9SiDf7sPDG=<8W}M0)W/}(Tu-,LhyziApm];h+pr4;A?[XH0W_d": a& = a& + 160
    Mid$(A$, a&, 160) = "uZU,OjgIu0TDKhu-=\Xv,[-jRe9pL1JYcXK<TS;)SQ:F:;:xsx,U]ahEsp?qQQv,FXPOWFA56+_EN=l>NaNn|gfSt}GVwN-5J<VH>qKO2IoC=7GV*0VdY*=q4BfgtKxH_UOyWpI]qK3}mFn1MPRnsv6,<e9m[-U^": a& = a& + 160
    Mid$(A$, a&, 160) = "CumC>DY}W>e/)Q-HhlyozUm[S2OIz:e\QPigklc/tk6v/UJ<Hanilp9vC'w[5h-a2=;gCK-EHI*|D*7'0t}wegZ||k]Ut|>y;f1n>QUCorgS2v4D<Y\}/MdGvQnFpnUONE9RZFH4TX<u4^j(IoUrYe1y<U]h<kU+": a& = a& + 160
    Mid$(A$, a&, 160) = "IGx}onj^tPVQBiThpG+|5[{R^8OCZ>TZVlJ[m9)K=DwmF1n=M*^Ue,|]_S<44UQ-XD=<4[_dnQYf*kJI50\>G]p>SKBOjgEECmRu/F|tX4:yP/JP<1zkQk=ME3AJF8Pl99(_a>B6.QoU8qg'+Bt:1M-.p;>x,czE": a& = a& + 160
    Mid$(A$, a&, 160) = "I/,4Jb(a)IwzZFQcj]GHklzTV;HE6D(uB{WPH8<ooJYn{ffq8]KHp'/SfGY<714vF*7Zr?dyG\:}Kh=/I?6)-oHUeBhIP/W3_v0k7T^|X[=;{U;IMF4h4BG_cHm_W4T0^E]).10zG{8bf;cwBP_5brrW)IG[Dd+u": a& = a& + 160
    Mid$(A$, a&, 160) = "FXQ\p_D9/REQ5I[2-NHAEV^Ql]d9+V1g.BTzZnFr7F1up|?y[5QFas[<J\]+EFrGgu?,F\E1yAiP7(Xz?h.S3pN(upcub2F^?=WYM?|6irQU61j+X>\8xdCIgFJ)Xaa6s]j,TWq=IRMoN=sFr,vLvv+Gx)w:bkP^": a& = a& + 160
    Mid$(A$, a&, 160) = "/tN-Q\'vje.isgp7t:exeIPKzcz62>OXGMeD?BaxZ(.(8qi[tfL7++Sw'nEA}N3g*nvO\vBrS3iak|TccwVkDx3okl2ujS6'S6S5>sz^CnliDQY*Yf48bv>IXW(6X5Qu^nB0(L*_Z<m3Ff3zj,wGhAhrQ:qDTWY;": a& = a& + 160
    Mid$(A$, a&, 160) = "/afu{M^[O97Rt1M7x(SKU5va{Kcb{E5kFpKWfKQrk6MC]n*NgbgdnZIvAk)Fq>:8qqwX>32mZ8yo[Xpcr1mJUTPFJsri1+Ir-ViJUNX6C46qe|o42HED0yyn^oC3mEZ9g1gRYUb{CBh_3)vFn8)?LRyB1AO?F5/P": a& = a& + 160
    Mid$(A$, a&, 160) = "{HaQ-c'D9KGsW+a9f}i4QK}6ZK.3]NjsPxkJhS}z7;dOMqBa0MEHm>>Sl|7PL7TD|sS<C-'3{uM9X?'P0TBOkD>UO{qnKy9evlVR6ccy1Ii+y+va?x2=*606y45vS(=F/4;t}<*c2{lghgbR4Ks\\Jm-1<{J1C*G": a& = a& + 160
    Mid$(A$, a&, 160) = "KeQx2(AUq*k?E2L;jWG_[6V,Np(D{OM5eI3Jg5B/l^}id?,AQ+C2QIlxUsgjaMbv'AA6CgOgHT7Bz-:Z1U8r0uVgh;r_MtnNJ;KyzuD8Ust(ry;PTM[_L:Xo{5|GzI_bBUMQOCT]3V*VfgNP1GVTY=F-_EC/^SbT": a& = a& + 160
    Mid$(A$, a&, 160) = "OF|l*L]ZrK<NN=4}QA9ov]Z|NzT(ucuaaA:K\|-;,q0K1Tg9eJxHoxtNeFvxUD6r7DJYI:xFq}^O^J?F[at<H84;EHcb-N5kt+Hh?6>v'TA7^464'ari+rT3TMzW<Vg'I+}WHYU;I>4[9h-:1=2n7nG)<5lq2|Mh": a& = a& + 160
    Mid$(A$, a&, 160) = "j.VfXXOewM7zUmb]r*a[xg-xP=M{IT\=zDy|75<q;+T<cQozvE<qMy:MBb+|NM+aQeqI-i<{'0C5t9A?*E{WlM<L?JE7ru8KSyHSZ5/B-tC-N\e;-Bj6T_BUG'U2nDQ,eLkdC_2UDD\X-fzoL'r>={^8U6C8<'lA": a& = a& + 160
    Mid$(A$, a&, 160) = "nPA'0wd|lLazac)FQiV2l]+_oZDk3C-eReluzJ}1rz]ezKjcMrjyGL=tC-LtJ,SzZCzYlFRr.bN-/ZSRaZy,SbB=<IZdA]hhP[VrCHQA<hf__D/atE9R+f9sjo7]rpMZdAYDfRhHwO;=p9L{bG\Zgzg?PP:lm\An": a& = a& + 160
    Mid$(A$, a&, 160) = "}T;7[CQ]}^fqJxz?2)O_0A.??=L-8l686X)bcAqM)y7S*l0ctKOLPvadec\V-C(z>ldLr<PV-(08W}{NHr0m.eb\9k:MJ|1aXdLockY+Pe(s8CXWpjm)X}>0sxCNvig{kyHx-U|sJ0-)JXN'9Ylb;)gI}Dyh^Zf?": a& = a& + 160
    Mid$(A$, a&, 160) = "iU|Kd>)(vIP(yrxHw/U-*>_0wg\B5CSw,9,_Qi2tX*pIZbpu\?XMts8\6tb<z]8+14gJd4;J0E6VVr[lfv-dyF/KCc4n'M/'b5;EVbjc9b{2-Cb;M_M4Z[mNB/rxbY*GC9a6UCyy:4LeO9}4|w*qrJjM<Xv7Xha1": a& = a& + 160
    Mid$(A$, a&, 160) = "'?JT}E:gMU-MTeO*:ZQRCJTv3I*^XPZj5=bq;=jNNv-JIUO_OTL9}L:iA8W<j7yzZi()IoF3ZiJV>Y{:IUuhO[S*RdYw|TfT_0Mfd*O-xWuO9aGTkV+<Xgj6o3Y+t0T1iXMbx[x}tcQJWh^cPSSHpd8E*G;w^vDG": a& = a& + 160
    Mid$(A$, a&, 160) = "BNiJyXS839IltuRXf]4il;gH5xs*)/qbd.EQJZj/:qz,kBvdT:ycnhU06BkJ{v\qU7KRFXdaz-}A6E<QMaw>h*fY-R8VF)JZJ3p1*>h.o=ir,\}/o=He,Zxjpq?8='Ns7a>EWAvkU<W)5axd}so(;4o0fKpx9't}": a& = a& + 160
    Mid$(A$, a&, 160) = "-*1]{id9l)=Xy<F*)2p88iY6oa9+wtoArvdq_>[xYXBf2m9A[8S,Zja}tBHTTH9l'1k{T;2vQfa72N\^-BBm7|QPgyl2E)fD7p'ZKFlH072Awz'WAg(]G0OIu)]OrSngfCRrk\7/NKZ^BpN^VRvqFt7+?hZyfXPm": a& = a& + 160
    Mid$(A$, a&, 160) = "YMYCGMonb32\<CH,G.GJ+H8WC{B,:qLbw)05ogY:\fakW'zU.]J^NX'QKSIyx[Fk,]N'=/cH_(R+Ep76*8xHjv)*(QE'odCL,.>CXPQQoigW:T=dHR9H=zR=h'ot.1?s^G*Avssn(Fwq4D8Y>1OBIUT9WRHZy4LQ": a& = a& + 160
    Mid$(A$, a&, 160) = "b:lA'jv?]>3,eFr>1GDBN,RDdcJ>.H*h5NiL={]i[sDLy.vf.EQn'd;(;n=?L]x2e8ti-Q<_=0Xe*5v>xVym'Fu9|1lx]pXongL.gEr_<'Qore6KwaL9i}r21k9,>^bRw)gJ_Ox}IiK6,hn.=q-V6.HX|428Yjfb": a& = a& + 160
    Mid$(A$, a&, 160) = "_xM,g-WJ+Y7xO)sdA}T_x-XDc-dkJgsk>+ABeDbSf2^K*bS0-wdx1w?-:ZS:/=|k?f>Mlw^T7g^NV/'7g?{oF'h[3^3sPHuLYL95v2QL7bO]nz-pMO]xDeFx],:[c>:[xUU^.W-*za5{-5N*<v.WnRWOw*\lWu\n": a& = a& + 160
    Mid$(A$, a&, 160) = "Jw5>]As+|Mf^K8U,JDBe:A-GFSP*zkKSR4MZ/4f3s_+_OKM'De>.zH>8NvKH5qx8H+7IGZ^b7F^>iUl28o).9J.Cog}[k^}eSlAIa1s]OmOx;.[gY>Q_'dlWCO:hAg=_d-J:o}e;uB.Q0UtJDj^QB(EIi^y<bG]L": a& = a& + 160
    Mid$(A$, a&, 160) = "1\6Cc=23]XMGHo<=o+8_a)^,f5iqqJcZ}[[v:FyRqn}he,UIz-WoZ.IuekC*lZuM84DQUQuK|7Bd6Kwtl?CKrZfb>^|'v?ROzOq+LX,f[l5h4=yL];S>ELtfu.;pO=2YjdS/I5)AE2mhS/3dmFojYR071E[yKyT^": a& = a& + 160
    Mid$(A$, a&, 160) = "0/\SxN{9FRF2JP'e)-\uOvkJW6St1Sgb7L4_4X_L*dQ-w7Zbror1ti|3*DItnDJEmn52\x.XFX-TPJwE'yQ;mr)LZ6?:6zsgh(_iOuP-YHuyIf<,68rMQ->q)vIJ7.4Ce*jqta.yKRa_?N=FC,/'9]|4,eB'TE43": a& = a& + 160
    Mid$(A$, a&, 160) = "OJd;]=zr'J;CbXr9*dIfJjFy)kp,|:TZqVC8[1UBv5IXEK2<:i1nv0+f1Rd79W8.[+vwm\tq/jk:fW10WBxv844YqtmQ/Ksf9VNSA7<G}.z6W?:KmQsUZxv]zaLI(ypeD<Iz}7mm9IO6IT,+(i[GEx(Jtvpkdc/p": a& = a& + 160
    Mid$(A$, a&, 160) = "{tCST_N\3fkho+Ku^oZtLfH,zypqFF+r>Z'|Q;R'Qi/Og,I=Y|FAa}OMi\}FOH'=7YTEMi<3:4G5QVn38.Gt{LAQ0X>;]w+(aqh}t=LPw*WG9sK^Y1(m0a<;>9{a'\S<^puN_AbUaqb0mk[:p>Om/SiDk|v^\.RC": a& = a& + 160
    Mid$(A$, a&, 160) = "nzX;O0[rcxiejlcU?JYD_^ScNzGizHg;1UA^;P5h*<peWDZB*lVPGH{Xu=s-1JxDZ]uH/mHane<IzlvmWN7:QAWH2E/uZfz)F_U'\0E*50\G-4;P-ifxl?\W]I_Rd3H-}X?;LOQsOmsi|*TV'\_ZZxbKK*CrLB_(": a& = a& + 160
    Mid$(A$, a&, 160) = "XR0YjL;<JV(,}3Fa6?h2\m-wlQ1qbvhRz+vs*=tt;G>f4ApPeI\\-'apd1A|Hnm27F8whkTEivgQ,^UlChrh|HU5r^'4GqT]NxNIDlPjKL'oq<4]<0aZJO/]\/*z1N9qOkd97E/[xugg?s?B.A{)afaBe\(T'nvb": a& = a& + 160
    Mid$(A$, a&, 160) = "/7GT'^)umn*9A'V:2Ukn2>M:lVpR9W0W0]TwF-x<d*7K=yCgePKu,LNvtX:1PPNz}Z]s_]sl\6(h[/Z<a6HtAi/iDnZZ_it{lL=RPt=qpU?t)N[ALz)NYOm=,aI+s{i*<CU_:mfIoIiOfw{Hu+R*E^ja{>sku}LP": a& = a& + 160
    Mid$(A$, a&, 160) = "Q:pBPaV=Ki[JYPtUt(*o1RK91*9QkdDo'J*4lnds033xO({8IGJRbx5)t-f:nRYhh'x-/UmO>)fl4>Y;2mrq8O5{ie[gs\<*U4R^M>xG.rZim\=7ztnwMFmzDdVQ+VMFmmBk8?M+>2;Eh;pI:;Q<4e\'C>1Gl/{H": a& = a& + 160
    Mid$(A$, a&, 160) = "L>HUi3iTkts[?(jbXzuM]iU^5k=0{h?lg{ymXfCQrprFb;n+HS+j7|tO0S}qJWX^EwAACT>f26[4*r|b/xod)JJf9GMI/qWDrAYH)0LbRG_GRt'F9b3Z?QoOAXw:prYgLk_VW6F:[Oo(j'_;=Jwx._7sZm;Eey*K": a& = a& + 160
    Mid$(A$, a&, 160) = ".pHjMZpyeDRtN3s:[Zmpoz{u,cuhnmd.n=FtypP:gduJ0]BXtfmlrIJeCLQz/a-w{vzR5zJeDzhnzlAiMq0i(m+t{CGW_f_0]vjA,+w|o;td=ey6{x'H*H<K]glD,<0L7iRZYddPQ7)=lOg/,}2V['vWIVacjNWp": a& = a& + 160
    Mid$(A$, a&, 160) = "j^)2jv0/A3RN}HNMNO+SXf5Od520C<p7YIW\'>L1HS.gUBt5xKosra\AjhOam7O*llGPz7q_b/W6WPxA5sVVW()5dHqN.DYvD'Z<jwn,<*eq(3ugDOP_s(5-tWUl9NC=fN.i_eDnxM9S-PapqbZBVF3d|VKfw.xf": a& = a& + 160
    Mid$(A$, a&, 160) = "*pZBdF7iKV+9r0vO[xrCP618MXk(N^?=)M[K)rSAYGvGGFiVpVelGjM:ImlJH)'RCkF=(Z4YaY^<RIRbvcSx=v)2<yp<EBw,KUwHrR-C4Bng]JCN?z)):uI{BjX,_h+>{10B7ez8A0Avff[pXVOu5OlbS.2|mCzO": a& = a& + 160
    Mid$(A$, a&, 160) = "(^_2aGAB5}l2q9aP,]e?LmISWa1[1+T]tj7?;,wl4vqz_;hUWWcP>^A<\_EPh77zfnI_j+rb8O:rxz/FkAdpv}S42sk.PGOG2y4STM[w-)m-i-JyO-Md]z-?VPXuMYtw7lEP[\aR2aejbQx,{(eZwv0'fI6g:1N5": a& = a& + 160
    Mid$(A$, a&, 160) = "o[L2vcM?e{-OK0Az?qEHQJ.fp=U?:gm?:jIo-xYu]*YJmeFARu[U9<4lZU4c,O9T<.B,WE,RD6c1gomI|?;t(I6(qoSaD,/6DXvdGF*3jNKSo,aA-Tu\f^}f-L(*UXH*PM^:A60uy*kB;GZVSanucXaLbPr=.[jk": a& = a& + 160
    Mid$(A$, a&, 160) = "=gpI43s98iFZtF{<S.]<((h1pkc\5BHr6/2uF+3IrWp(d1Vvd7-jtvOcT_|iR<Uywg:7/P9_vikk[]okk*7,dGt(Nk]hz;q5RtjYKwBT[I]9iAGT+NMfm2]Bi]\1(()kKdY_h,KL8BZ):5;gF)Y(K;u*T]A2=dnd": a& = a& + 160
    Mid$(A$, a&, 160) = "Dj<lvBYt{\-Cd]B2<p|FEEDe3Q=GR2)B;j)t2?k4QV+Hye+<dkm]}lL7;;;L1,wK9S:z44N,a0's2t07Eo6=*G3E_spN{,[e4V5|}peV8-ePvKIz8E+?gUZP2<Hbe<y161Uz37UiG'ul\KKJ3INYU,+M)+KGK-=V": a& = a& + 160
    Mid$(A$, a&, 160) = "0C>MswIIV*0K282.J|J1Dr]FyY<=DWju+qT{P[AE]l1z=l>xcbH0BLJl1X_fbV/u+cH(zNtqR<m8g9}wwQVXJFo.C.)^ZbA:)1yD(*6d)O8jsNPam'aF28SIiKFIunoa,hSmu3V,rMPh:WnKnHJJAUvGv,U(:}}[": a& = a& + 160
    Mid$(A$, a&, 160) = "/B0WOhEcA8n[hxC/RgnSDK2T<j+m-28rty*>m)?+LL+{]b-?\G.cr_jB=)VB:bS2,pXH)WT;1ks^9*w[lrxhfR>,P1{7X]U;aorb}S5>CvC4Y]d+B_rduKy}*nAGRg7[Znz-zYPD{9fv99}msZ_HtYYLv?]bBzkv": a& = a& + 160
    Mid$(A$, a&, 160) = "gN}(2<[gx0yM{u4U[(UdLR4G\KxX}UW1qru|Or,lX8RP3P_1(2/\cVUa5Dwr':tbmOYrngF='|hD<587ujLRhkwNclhX*MtCzLl[l\U\ZSe=>c2lQ7kZD3hIV;w*9?YkX;nM[gqlXwb.r?LypTkR1O3ZUd0P,ilf": a& = a& + 160
    Mid$(A$, a&, 160) = "qXm*m(-h:3^,6yVRwADxanVQP^nxAJnRc7KmsNGT,xM.-5dX5?_V;mw^QE*v9LqeJ;-[}ZwJGm8FWcFxve/LIuo{f.FR/x<6zUApnf/(,kN[cAGw.S.*G?z-KP-:MrJ<YB\<=zbK^BRvu7}m[w]rHJn.uBs_f6KR": a& = a& + 160
    Mid$(A$, a&, 160) = "_QR+SFw8EVQ*)5g)pf.;AsseM3D3}]8tl,m;Qw=Ig+_8gb>xP{?JW,o\+wQx,Ch3yh,\icrdk5QoD\kt{N}wDO>mK,,8W.zP-xf.\KLS3ku^aaLg+(tPuRd6(BFc_/Z7M+AH6^tZo7QRuO/]rYn}wq?__//^/Y*4": a& = a& + 160
    Mid$(A$, a&, 160) = "[5wXz}2pN{jz('FA_G81P8cd,gJj.{A>DI)<[r=LI=KOYi/-|UqjSk[-3UjX{]D8YW[QU?eJM9K.=jzx7Xpd+Nz8Kp[<<r;Pq2O}{HQUTqiorp?'qJ^x0YFcP/TJ*K<z_*(j473<<v*1:ik}_?y;[bkj-_2H5z9,": a& = a& + 160
    Mid$(A$, a&, 160) = "bqpOje'HOdFJI>wUJ>>COuo^w2b6aAxfjJe-Pfmu+CYLFoMTU8L[GLsZAL}O?FydvdH4cf+*F*2Bir--Gp]KM9.U9joTEeP{=:0+u^rMvTr1B<0dyPWZ?q}Fd*CQnlSecQSak+G(mdplp:WN>cPA[q}lk^24eWDY": a& = a& + 160
    Mid$(A$, a&, 160) = ")Y)IYf=p4z{?Obh?Am{Ef4_:k?nfXh1qEgP0'I:].J_CKp;zssxdn26*ePS>|E:2Dyr5/e<vVfneL7S;2>^g,Th.+wY=bmk/RDak8X9eO_sJ[1KAL*uV(KlhPz\^sRri58=MN573Sga|3_Qa{<*G^0I[I6(Ki.H?": a& = a& + 160
    Mid$(A$, a&, 160) = "(T+-gr7GqB[,/C['P093749vhsngx-WEl[=\l6c15{(J_a>:[N[Fid\r*stvCB3'avW}zP'/qCXEpxxf-(KF*o'CLFf3VW<sbZ'Wipic(9?k>aoa>gR[2un7N*-?+_-C8a+arqUqyPhX+>BoeIEMUAIL)0U\*So,": a& = a& + 160
    Mid$(A$, a&, 160) = "lAiSKW6S,+}'E6GoY*XE))e.Qmlr},4C?y)];vf)LxdR.:dDP-^>:a}WSeI\sJjXe_IN-QCU^G_QDLmHiD.oSjymT1p9Bej*=N-iW(P.|)Q5p>.EG+3}mYbCw3m7pb3a|hjhIFP4,;Lj]b?uoivQA2dX727'u-8^": a& = a& + 160
    Mid$(A$, a&, 160) = "nc4ELgVZ{fJOpP]L)>_ox3B<H;hzgwD+C^-ynAq<{kZrc7QYBBEhb:+FiWI+L[Z^PBZG;9.H}OSZ;s}M+DKofSAsU*=Wkw'F.P/Vu*'q0b?<jpGSyAXm/a8XT6H,/zat(w4(3R>JKekN(_CuK:D0}Apo?vWxUuEP": a& = a& + 160
    Mid$(A$, a&, 160) = "\ahws/_|E]QtLFn?ymXFJG5*Y}A^o}76HGuHwb8oGrc_^:hBO'3pDn^5F:0'CS49_P0,/Y|0ZYni:<CnM9r\QzwvUm++pWNruY549TwDtxXlk*XP6VyNM'y3HG:2N07Ag\57Scam:Rc5Bv+xx2.*;LQ+{dBeVFN3": a& = a& + 160
    Mid$(A$, a&, 160) = "<AP:mJ.+LB,Jz'ztM}ggE*FZCun769LOmabn?jzs<b\.[gb-YxZ>ufs92ZIWW3_9ZMsXSp'PAm,/ZD5a*M5sz{GNe=3_zScVqpiLeV6MNCHAY2[Xu0'.jv+jmoAwM:fExihx3*-|-.eBaFchUX:ohNER]2g_r,B}": a& = a& + 160
    Mid$(A$, a&, 160) = "M3KCdJ\?wvZTZxEs5>8T74Z/UFPQ*aIYqQ9sIwcBVi7}\^ZKxTZ9^(6A]dJ<jkM8pY<7Bxsc/W'w<3+k.6,p5\i:zJ}c7_'\*85_^DfmQFVF=lTIbWLA;J1aWZh]9v(<3R6q+c9zK)M+)8BOTW>*]7YE.?}'S^hU": a& = a& + 160
    Mid$(A$, a&, 160) = "hnFWr+7aG/ElZiUO[?7[d=;//V<08q\4[?I2v)d_QN924?5ECrfw<jL{,yFr1vp7z=Ov}_[1GQ]YkFHI305e:?O,p5Zv|k<D4g:wZFYwR1g,R>EPZeL(x8ta?Y0+'5LC5S+sM0TeynviyK*axc;eQrCs5HU*8agd": a& = a& + 160
    Mid$(A$, a&, 160) = "YyA{{v_tuDny.TP:C>}|5OSB5G(gJx/IETEunPcY/VKmrOqEwrI[*dF+cUWO<S(Hhh6pzUNX6EA^<;'JX\n)n>xyt_|vA?r(k*V-wpzXf3nu-Ta'cv*h75p3=c3-)|lAqEIS0TAYRv2gXvx|UGe/OqT,+;TFEm|v": a& = a& + 160
    Mid$(A$, a&, 160) = "6R_oHzr2I?/ZO9B]KGlr0H<[(3U'qi678gZpU=K(]drIY8OtwO.-gi[^zT|3)va*V9NXvx<,1)s)s+sie.OtLcknRTP/KuK\]lxT4-Z(cpfWe<1KLwzQw66c**K1(rxW:|Yb8CI'_VtyXj<3r5gCYw0p+P}/SBS^": a& = a& + 160
    Mid$(A$, a&, 160) = "ZTrpDw,Q;s0*kk3sn=eL{6mf}'BlYD]OZ'CGOP?P2k_[|pny\UhNS_}SqxH--b{deDM_cC2UMTwsse0PlJYVH/\[cip6Q{M3n]PXlZiH._O?b8wRSbn^2{lbiC^o-vT2J)>DLr'p>.s3QQfZCwvq[1pi(jD0Wj:y": a& = a& + 160
    Mid$(A$, a&, 160) = "k:{i)we5bUNZJLJ_TA83k.un3fVCS05ZiE]Y2(X}f:jKxv0Vlsx/(DubgUb=>mB1?TCo:MXBE2FmIYP(^X?SF,?O4|-/4HOwehin0H/ya[0L(Y*NsX).L?8Aud<}aEH>93y1JG2>]+[AVTV5[x*>*)/5J<_fGI6f": a& = a& + 160
    Mid$(A$, a&, 160) = "T=Oh^}\g*{y/rioZZd\WG8:I_gf]7HEdqtYK;_]_4h>9R'm{U4<ijGee[x|CKyHXS/YyyghE(WDO0Wi}+y[I2nn-aY+?W=HiO-6]FSFl20hIsWAAnezME[YFOO3rB(oNTn6qI<-p,,vQ{F|yy/_KrFtSt)a7rG6H": a& = a& + 160
    Mid$(A$, a&, 160) = "?F|U=.obl/A[<h\Aj[KekI(B7:LZBOwy'Jl'n-QGCiRS>x_}If};e]X<0E5B2/Y\W6/,Cq=7NF)5dhm{J0xYyLCbE=}s}M*jic4W78c(xE4HHa2zDf|,MZ'}xp3P^IQA?j}AyjX8trn4[i?)pgSFi[I10yvS+(X9": a& = a& + 160
    Mid$(A$, a&, 160) = "4QXV{\rR|YRj0:JflS<mOR6T>/Mb*)}T}>^>Rc?0U*HBN.,ToMyagxS4Z24XfKiyLbh]]x)Bryt,QD7(?k0Bud-*ewVvtg/s]);Rvx.Y.G;J(?g'(NE]ip^+r8MC-llKa[c4ghvux-=vS90x]Nw*rS}mv-EvXIiT": a& = a& + 160
    Mid$(A$, a&, 160) = "p0FWSw_\_.LuBD/yq?Fo-324p<;TP2cOw8<,gAiQ93H[LJ\MW?0[qraMrIwD}hLl3oR'd:O26x=bGgU>K8qR7U;w\W+fj<{<uP]hNJ;;p/?Em=0OEF*Xe:vT:3vXF5kbp[BpSqhH;-89RyXt4KOzxgi6VBOPRXg5": a& = a& + 160
    Mid$(A$, a&, 160) = ">lC}DV00XBjlvK.j;Woa(t1*w-ix8\6]s}9PNve_FJgG?YJq'|\J{C{lwFbm[vM<*q/a::FoYBETYq4d:fkNa,RuJ7xK<;Et5>^YQ_uGZq:AJ1X7If*2PhR[GUOr0Z56kn'XIxqQaaGG(5|6Ksr}Y>F\.)a_(_yk": a& = a& + 160
    Mid$(A$, a&, 160) = "m_z>K?X4PCx\E?fOgeiI?tmzDvf<bK'(Bdr;5)Ot3k,hmr1/i*UVjseVssg'h:qfCigb7{wqzAMQ72Kj[IT;(NNj(b9iG)_kcBt0m{']q6_u<G[:-j(\jz+cW=mg+,)GS=S4z*eS4_\geRj4;/ES,m<,[bjU(5.u": a& = a& + 160
    Mid$(A$, a&, 160) = "hGEw[Vy/vP}Ocob,V.bDnYqhh_EeBks^XIk=)3yuM5wzVvGjAwB.)R)iVCDZr8u3BWk*tv>gpI:II|3X\9Tp;AQo\)KW92^qZ/ss6HBI._xaeIpxM+X[1}-M848-CD>6'4bI:ufLeTo'1<YZrMyV|GPxyakW89[W": a& = a& + 160
    Mid$(A$, a&, 160) = "f))\-m\?NAKjB7n^:glf4[gb4hx}T3/vX9,[GT/bGZCE]G5RlDE7.T5d8<Ywc3/ZrDD'Z+bNm.z>gy[NY'CNULT91<:WHwT?.er?Y-b*MxU-jO[\0S'ajxKjaGVL(}(gIlu/fTB<bm[7O2<T2mqcZ0[8|8hdo2Ml": a& = a& + 160
    Mid$(A$, a&, 160) = "bumOJB?YKyvFIEs)rhRLqxuv.['5?t7>.N<;IfR[/Cc,Y:GbJ9.==uvW'DnOg'Nl*^<}z:JhHEd5IQK52vIaFpfj<+BT|<109'[de][.uj=_-^)(D{pz'Qlq,TTqwBCm8iC9SvuVCg=H0ALrn4OoU7sR<[Z-Xu,o": a& = a& + 160
    Mid$(A$, a&, 160) = "gsXdo5pVzJQwk4OetYEh\vYjXVT}ih_.5vo'h7Pka[ptMw8Nw,,NSkH:ap{y)FLh4?Pd{ecvHH]JE7BNe[Rt^\CICKrhw<[xs>b)EUn*Hq>L2V\W_6'=>7tg9?<9k1]X-(YQDg-ACe9.ex4p]DSuUg<w)9iAgW/p": a& = a& + 160
    Mid$(A$, a&, 160) = "hevL:'IPQOfF+gm8]}edo^gz1l*\VMqYgJ*6UR51?V9T*aD{\-M;0'[QLCizZm3Oc-H7Nw*j*Kmqn+9Y-w?naSaEC^a{+'2fG[{{C().3dNJ+{)<3h,r:iZ[nP;V{r)))Z<IN?cR4o<f?RD?OrT<uR+'RA/9Q]rh": a& = a& + 160
    Mid$(A$, a&, 160) = ".[TjpFOxgS=M;QpF)>>*KZT(R_QN2/C/.uJ[(9j(^):]gac8*F5:str0y..CP[}aCA-pa6*5*xLo5m>L1PD4{dg\jwiA_jc21NY{A7?A<klZT+|/]-{c9}\^O2}1]]N6oUV/EYKt9t5h-3s]*]zC1EM5<w[yymKH": a& = a& + 160
    Mid$(A$, a&, 160) = "7B>H7q9d6H:NY6iTzBnpu?\jFxWN>Ql9H.g;h3BAF4Ed>R1RX5=58aaCdBMe)w:gNU(Hg)Ys*KLQ;JjANX6yUV4:xmP:dlN7m9ICgv?Q'rS()YWgE2zlr/Ws8/u68E7/(mdyjIUiH|uACxXl0[LRetXsu;6pp19>": a& = a& + 160
    Mid$(A$, a&, 160) = ",X_R|jbvwIR^kkHDb}=6]tH|Xe\{,]9rnvd,4SnRxpICT8nQ:/l9d=?RCkGY.ciT{UfN[BHM.G.+40YLQhSb_[Bk|L'wm,Qf)TUbsL'|-3avN4=-fH/liT>?]m?}e60k\+oRLhODQUpUb1<D*-NV4}cTS3LNV*zJ": a& = a& + 160
    Mid$(A$, a&, 160) = "\w=H?(Q\7u_IQ=[4+2B+SHd-,cbN/AK^{t}N]}*que7*,6qR}i?V,RcHwU)GiMs4+qer.k(0wyKF/2,N4'|V5A?Y]cd)=8ppM5|7h(8zV+e[x8i01.}4b;Ky\Q9*|_6jgzNd|-kPieZPSfpZ9BPH.T//+dPvomRa": a& = a& + 160
    Mid$(A$, a&, 160) = "4xxNsQnkH,K>_)](Dix0SE/Sv?YbWA'Skf0-8+=dgqflPmnZT9x?xm(1fi0nuEey{B+ZqnB6MtYk_t+VNCb_Ljk?z-k60.Wr9>8T]sRI0Hw4P52JbkRd*v^W\GrIBbkNrYUN^^aKI'|qzPS_bR9E4QLPk2lgCxvx": a& = a& + 160
    Mid$(A$, a&, 160) = "BzB3VVOL5QdV)1fb62|y40XarHu_N)-MFp)G+MjSj]9RuN1kLpz-DC2)OiW8,fY>z{<1|V\3pN\-BW7;ofw)'(nk\^lWvyTKG3f,D4rHnbQQ*CBCr]S.n=LYNp_Ek9j^b^[sH2UZP/C8=+IkO?\1|=(t(e'm1+}D": a& = a& + 160
    Mid$(A$, a&, 160) = "'[b6TFpes|+/s6QsHCx8Zb_:azn.LS}zw^j.+9ghGj]A=h=RY7aAS}J3f2BbyX.TqRtX9IEqSgIfRL9Vj,</.Rv=hXHb(/qiaD5P*)W(6B:Fo[>u}s^3YzGInza;evd4;5de3,^O{-(4-G:46BO5D|Kw/^*-Fbn0": a& = a& + 160
    Mid$(A$, a&, 160) = "8wB{cFg9SyDG|bIdR^ipGY6bS4dN{w[bzlHti*n]:P)p*6xlLf31P8QP<vJKe[GwPmcdG\jk]f7{s^ibHX^ziY]3sypPuu72ta5oWF;R_xv->vL0,ARw9=s0^z+i^3jr]r)XOJMx5*Z0FW{U}_:d/JlnJZ\(d_CE": a& = a& + 160
    Mid$(A$, a&, 160) = ",sYeijGKRK.8XX=+4*e*GC'j7UuerAz7-k[MwBL;wx'znGk_*oxLzLPk;J,If?ZkpZ0WF(oejDs6;N6<v('w,XqVBS}AHGxd]2c.oW9g/+v-dL>E\poSA5BWRt\aO*DO=ksUtYZhlqjJT;?z3{jEJr*z04'14hp3": a& = a& + 160
    Mid$(A$, a&, 160) = "lr9>gJaEE}RhD:Z*5{KaY084d(L;|,^ZNAC(wP/C9H4-CjKT8SQL9aBqjaDxf-*Lmp*{wz8Vmr?kd>|d=bXCjxc,kq1hX\V*FR*81K<6(XuuHJWvkXg,Heyw8F6gy=M>*RVJ,9>;(i\<bP,X{5gON;|lsue8C2{|": a& = a& + 160
    Mid$(A$, a&, 160) = "^O;FC?,b}<:_-65gC)c|A-r-<HVLEIy-QyEl.BMy6>0}IFVAUF|,/HF}XAOl4;E.htEDERkk_7(9^Nn_<2zs4QDmtAcZIs8MFbp3t0thh8g7U?S2<Dj\Ckl<Kn=,0oXv*Lh<dUvnQ50*',b8-PW5w|m2DRI4NMdc": a& = a& + 160
    Mid$(A$, a&, 160) = "h9YV7C6^c=M<U'{Tm[_LVum_MnPZGF,P1nFH>r0z=e}YlvZ9e0Sh.a\{3*eT6)d*3|ra'HS6{>pD_IYQ?X-}VngzHKZWYL}X/XaivZeMjKVf]W(\Niw0ctSFglHP5ni'7}OcgF:E0hYHR9y(PqL:UWknEsDd'3G8": a& = a& + 160
    Mid$(A$, a&, 160) = "jDz0Oz1{1Xi4=-peQl9i}Lgf]w:oHI)ZJ}4hwo|fJN[O|Dvc.-\B5vEfD[I[b6j9-YgmkVC6tQS8-alqR^A\6LwsX5c)ajgFdMR=0FPPRp\'Hc|EfJD0u3ix8m*Th]m.m;ab7S8K['wUv0.=\/60Z5b6K:-KP*Y?": a& = a& + 160
    Mid$(A$, a&, 160) = "titl'PdjsId9L,/f6Uj?'KD|)?IblrKs9wY]-q}X[Z]Og_yhP;QrB<YJL;KSPME|l<ia>i)E]xaL;X6Qn\P/mUa4.me(zD/4uz/A:d4doKkc>fC,MOk^-M7PNsCDRv7xud6Km\:vsC:?'fN^gmPR4{7;P[H,v[\y": a& = a& + 160
    Mid$(A$, a&, 160) = "8f-^gVu:Bp_t*9SJS[Vf-RL1JJux=xhepO=|e1G[ea-6Y3QACG58RFU(rnT*H_,Ra5r:?D;1d6p8yg]fDPXKT}8H1_4M:L]fEyvj|LU*oI4,QTE?GYFO1)eqIIpwrn4pOuX6U+J.+a'/\mBgC>=UWWk3><U)LA1p": a& = a& + 160
    Mid$(A$, a&, 160) = "=<+M>qy*k:jQ:AuRD8[G+GP]YO/5RRkJ.pR*Kw;d_4e954?+]/XOa5UKV)Vp36G-z*x2ciZzfPg[aZ?/GODe|Tqar(B=zpub(<Z|*lmd'D)7n]t?WE-_<,*l>IseP=K\>6kJ_II{WrloIp^][Re[2lZ\^ko656D7": a& = a& + 160
    Mid$(A$, a&, 160) = ")m(F/,xG^eSlc6V>9be5e[]hEN,TdOP\d3|)coV]0IUB\L-{}ChK}{44)\1tv]K0lo?{Y}ZJPR)UPr2h=3a;F(zJ,ltL|edqkZJA1pNWuRrFSh)9F7Wl\_Ld1mFV'uJ,UrTcND7OpxhCnpN*\lt'm1idOcz/+)FD": a& = a& + 160
    Mid$(A$, a&, 160) = "'7Io<s/G{bdx*Zhs;(vHN_0En0X1.L_d}-u{d0X;/6G=5I6>_2iQHrXt+J3e5V]z3ST4sWBFNQ<z>IGNy_-5ps1wjdR,/S{.OCux3JkhYL1C{dghlG'Epx7s1tg(H+n'HhRCx.=.A^d_4fG7c[W8)m]QYr61(R]Q": a& = a& + 160
    Mid$(A$, a&, 160) = ";Qccsv4b>pzQiOzc*EK+GQJp1bu.kazJ[{FO4OFsU8VFwZHe;5sA{]-B>MO_ZN1>M5SYzRaa-+zPMFe=b?_lH.rCL}(>cl4QO<hD],<0w?k}haN7KX)T'lD2>935evu_]LYg<BO2bVJeYK}b6**Gx.7kfhX46axU": a& = a& + 160
    Mid$(A$, a&, 160) = "aiFR6Vvwa_uS;e8[[fx*tte3J:B_VORO_;9G/Nindbt=MO)]TW/NkLR2^Iw1n,lV-[.UvM0-ur>;JT1r|/cgy2'cGeH*W2SRFxO]\Z>M}047:*GMhf?8qoV7O9NqI('in*=(OgJdhw>M:.SXrE?,{t1B.]Tm+w9q": a& = a& + 160
    Mid$(A$, a&, 160) = "]>7LejSp/6(Y{_l7I>Ex+u0B7i\|HnR'H|:U]P8DzQY1*/DbzGhNIu0R_XpG62QKOP-lXAr9Q0p-v0b,hx.LyoJmiU}c8t4H8c+r-E(6e_zrNhE(FZIeoHYH\GpiTc;'BnitcB7}kWhn<KN^>+gK};B\Z/5{z:5s": a& = a& + 160
    Mid$(A$, a&, 160) = "Y0D(V4Qq9.\e2J:0u5k,)'CQ\ak4lmtn(Vly6lk)M.}Hc5\<>5,PR>Z))*zwA;aq*(*W2hm5j?:Zp+?NyeR4[qDI<w[Yv*IJ',;BWHB}|B;[h{I4kC'/6KN8N({T^Wa2Oaxgg>>mS8jnwA-]XhHMnQK8_/CeT>1;": a& = a& + 160
    Mid$(A$, a&, 160) = "a:d?jMvc:ygHI;rDBmwWDpkMprA.c):2Q}<t/pV>G+6<zoPOqA;u3)XZJZA0vK>63]wk4sa9]=iX4*xNLZV+f4.[htjij[O_DHc\=,SBPQYB|,3ByNjAE(NN2lwBE2PTyC:=t./2_:8,}.80BHtMr7*6iOC'V5F1": a& = a& + 160
    Mid$(A$, a&, 160) = "WzO?hrcJ}R16p.er2^GQ[;OKbbaQ8[R.r{}NpiH;C,x5)<rn9juZ=hz,k1LQ31ou6DtT':Ca90XP)ev3WSg_:]wG1)}7a9*+tSR-J+T}8hYhIsf?7=>M^)qqziTDV?LFT^4=N'tF_=)V(oPW^}?ZdRH8^beUzVX-": a& = a& + 160
    Mid$(A$, a&, 160) = "bN/R;sd.Zt|b(^*:_5vtC)6QS5RQSiTxr6HPdUvDRr:HFr]7{uUcIaMv8:B(g1Sq-MHe2g1F|iGkDcbm:cLK|,D2^'5K5'JMkF9}<qte9f.Kmt|RvSOtjnp\pG:niQiPi}\K-YnE\|yKi2hqk-c:]LD;5IxlEw?:": a& = a& + 160
    Mid$(A$, a&, 160) = "=/=H5M/'\=-jTnPJIi|j)?Hjld^I?8+hxJ/100e_2deo/P?cXxtzMkpb736W_S1v[7Rtc.qpRy1oHu0iW'iya,sd:)(5Y[^n<qn5zRgt*mJ'Cl>U)]4riSKTcaZ)BifirT?AdL|b(WAqBDh\D2m'b?,9Jz'6OQ2t": a& = a& + 160
    Mid$(A$, a&, 160) = "/bK[6G-SOFD;nGcggQ91ZgE;rh2=lTtg<LutCV/S}fpc+9nC|b-m7sqp.KJqpzZ,ln<MbmekF8sy0DtLXd5cC([7oLJJVJ5l_Jh7I:)*dWRFMwN8,w,)kdBJ}3oBUjI7bv6sU=1rvGt/-^*:\DqU1w(B/08HX/8h": a& = a& + 160
    Mid$(A$, a&, 160) = "p\>U'38Wcj[\I7{RV2gi{XImOEn(FT*7WUNjK4]o:WPIcGgK.E2v(ynTWF_sBHwcI/llelRojz\)6_P+Rl.vOrm>Z'mRlrk[i0O9d(t[KwxxLdRMYZKmB:]_<>X}R7M2B){pUTB=(A^Fv2'aD1K;}P.TJf)xrncb": a& = a& + 160
    Mid$(A$, a&, 160) = "{xA'Ezl_noA.|bb25/FY1JNuoznQ^qKH}uJcy7>]l+<yvfv\7x)c;s:04*{_o:aE)ci[(GmVky7rgzna4IH7hao9ulq8YFi^W_T)rd}x[VL_a0w9rMcV-_xa(zi?(dQu*jaEX4)\s^q\{znqp{zde^(f>ds6<BEO": a& = a& + 160
    Mid$(A$, a&, 160) = "xDi0h[zLpD6[Xp<_J,k>|PC_9e:ZA7gf2gw8V>JA2Ho9Uv{-Gg\6D)45W'KV-7:pH^;f=7hB^?;MHAPeoHui>wS]|e,'b+^j(z3<TUyWXrpv44}(7nsAgNzDcc(g^bjC^fp;}}u<[LxxS\JS7jy<gxOO+.W3*X.0": a& = a& + 160
    Mid$(A$, a&, 160) = ";TKhaRYIeGaV2ym3NEgkns=FNcgT_Jqs>p=8VSwA=7WFAjdLD]}ksw6)w<q[8'Farnuv'7^kX0RGe[9UCHRvT'nKMMroqf7BS0,L-l8D(EZtC8SUiSsxo9^'eAO<9OO\ZYVycQE)M;XFCjm+1Cqt6p7soRTdw|,r": a& = a& + 160
    Mid$(A$, a&, 160) = "nWx_ZRq]QEK:x-8gp4vkXF]hy6]mwbE/q'9z^jja4fB}1xS[YmI)SnbR+kPPNAL>XutS6EEcE8MX*d4LS.*F>*gZbheS?BnqAZ0BjNNgf3?'=1BGaj5w9M:<BkXx<\rs*et\rM8,2|h.k?jO{uzaEW,D6Ei]nlLw": a& = a& + 160
    Mid$(A$, a&, 160) = "|Ws25,PG9^SGbe,7Sfg+ojoMUXntUx}-c8U<qX(a_1-vDQ4PLL;KtpfBal<2M9vO'IwMjvY=I2ub^qzL2-TNK?P]_xm^AEwe2_07ID]nuc592pC1n>[2yYF8-ClUh]o4?nU(tfDNBJ3:dJ0fNY_iW|,cxn2kSX/-": a& = a& + 160
    Mid$(A$, a&, 160) = "xzH6Z.S[\'=G=t]0=UrqA39a<Ue'X|KCk[.u?X-rf0)z?s?9lWXEhUlKOC]rMOy)-68|jlkiiHXF=++AC18.pZiFWj8:Q<z9Z,I*^rNm4o>xNl)V]Qn7Fnuq*FD9xSKhu,Rf+fakRr-5O<(F=Vp50x.vI05}hrrq": a& = a& + 160
    Mid$(A$, a&, 160) = "QeuO\nb38T|>X=*;1rhuks<PFk>\A(vaqrSrua-D+30fU'/[BiA;AH67Rpt,--9z3Js=3SpkRM{o.}QHRCu>60lf=gNg1i1hx1Kg?tz)k|DF(Z=fX5Jdz;;Wjuq4[^S?}';7e3oaPQ0JkF\14[MFF?e(Hk2m:e+H": a& = a& + 160
    Mid$(A$, a&, 160) = "Y+H.VY5/BoLHH.<jQCj}7X;Crl^d4-Ino|NKq5/e|l'k*e7ANR-e>HTFufhDIjY0F{DDAs-GUq}m]3mhPx0<+3QIS=J8T2MI4_(ccFD5bp_ZjYYtxY_?inN)j+8{Ub/EYR_A__hC\{|PD9Dx',>1lc}=vQH=]6F=": a& = a& + 160
    Mid$(A$, a&, 160) = ";e0XCO09xI4l\cxcqp;dYEB.,nQAq0eRYS+So\pYGBisSL=fccJ4;U}}jmEV,f{\j=+MG1SsoKUfj'+B2vD80f/x3Uw57WwWM?kK5*I+1T>5l*JBJ_yTM_s(n-VqYZ?LE={;-[jA;WInmC?LpCuv=VQV.MA9<4ID": a& = a& + 160
    Mid$(A$, a&, 160) = "3+}^-^=>g}+*-bESgiZ?FEIlTrLyAzU=R4/2C>IOeun9r{VTrPKbX'C<]SRYVmD89*hr:Gm\{v,<WZg|gSB',b6Q{S/Bt25ubdOc|0Nj_(>I[:+ezKk{i9mBJ(YM\\7^JR2V[UsFz?j0SBuKz(u,3'E_L5TmT?1R": a& = a& + 160
    Mid$(A$, a&, 160) = "N7orS7a=87oz[pVRH8aa,vWH[Uy+7e}3Tu\Cw<rx/DqfCIgu(^kah0XXZ7p;>sonDODg2:T\,<3sNz4f](fnyi9/W_3\(a8\aOH*GXN1ByXgeat.GkNKQQYb8c9:ROVp]]na>1-,>DM_ivZ^}[(}5+h.t|J+z.?;": a& = a& + 160
    Mid$(A$, a&, 160) = "2Lg/_fu1tF8hkR>vUhU,Gh<gvej\(vI[w2_(Hm>SBadE8x;>47ls68<Q:g}6jBa^)QoEf7x,2:}BdVu*(f*9\2tA*2UhgQq<-o\9)G*T0GgWL+7?IMiN/WZ}azx+zy3v\WgaChdbM9TLii/wRrS5oHEmiBXiu-xg": a& = a& + 160
    Mid$(A$, a&, 160) = "iu'KmcxDeBJ+m}TD4d*0-bXyH8LLmQEmd<s1h-8?1)veLD.9q*);8:Vg^bkn/2'bKtM/xX}Xex0p+U:*yNehg{r[gK+)AV|ZP>RcH]dawnF-'UA9xY;Yh'Jztv{YMD:UdpraaSm2TVUtaFmdGfMbm-+p1huZUzr(": a& = a& + 160
    Mid$(A$, a&, 160) = "w]->1Go(7)U('w['h5}p=T:fhM<P2rAMZ;oIkkJd6oR'q<JtZuz7ShatX7gs(B3/zpYu^TFO]O(1')2cXmK*]XQB]mm)T?3t*?bD>Rt7R;/zYiRZ^LeN'TlFZhI1RvtBsv0Cv{(?xlU5VH:viH'?{NIi]{2SyJ2r": a& = a& + 160
    Mid$(A$, a&, 160) = "EsRh-gg?kLZ9;kDFHZ9tFeN<SoPtTTMN8*q>Jhsk<?qwiq9AO/J9YKhxm4BLa<W8\,eKl+C8}eQgx5gKCvkMPFAXFdI'ber.1ZE=Cl;Sd35,zjkw6W*>V:V8rieHSrRx:G?<P4b*'8a6DHgFUuJmag48Lyso7Bob": a& = a& + 160
    Mid$(A$, a&, 160) = "sq5'ph4?nCid0FLGx6iNce}k7sEF0bxv\^VOSmP4(1R/(c]=d6DrvH8vv+COOBR+?Ecy;fo?Hlhmdl?y<:kdF6ng-yeNRFAxgPgLvHslr-Z(l+ZS<hERt.VVR']\s*]r^kie6iV=o2Sz{hvn\99b|KhYthEuJ>Vf": a& = a& + 160
    Mid$(A$, a&, 160) = "vH(mpCYi59w;-sfev=pYwEW=f'p3YY16sZ0{T=5nE^(T/.Av5aoAbaY{o|06yS5mUIoxAgx><qbgpO.NH+zUT>?vZ0Huzr(>A]9_Pi0WIWu<ss99=]biq]z?3G7|W.>x3I5J7Aq8h?2^kfG[S=/KTTee1GkQ/ya<": a& = a& + 160
    Mid$(A$, a&, 160) = "q*OV,ljEsX2Y_1YH(vdZ]oFaeIlvpfb2vJ=_S<Tpu,Yh_B-|?};J{'\.1g2b5A_X6DT7;Y'X3-l;-Ar>;=GS3^krWvcIbJ17-:=Qe3iQXY[bCx[WRfImh\+hd?Pyn>cFb6m'\7?*p>ecKnmYJF(z=--x_Zz2-4_V": a& = a& + 160
    Mid$(A$, a&, 160) = "WJq|i=E]G-iHjw5}PbswX6:nG}Kp^W72?Smd<lQ>18:)5-h;eV:<mfw6_kcmDtt;]i(M=(A7.TNEBxz0>9ar1v2(0g<7'gLRDJCC?dYlxirEo>e)B{7Hb.=FO]oNHiR7qVBZ^6-.ppcrZ2-\G^gAIae]3Ly2w^EU": a& = a& + 160
    Mid$(A$, a&, 160) = "TA;SLj^3uly7z.D++THqvtczhx_(L*Hh=ygtFlMu:[K0oQb]5fLd/0pVjNWMdX-WfJT;)5c(.BC^aeJtXm/fYo3mTt:tICUa_k;)|Oezvv1FjCIDTY*nnO30*+m]GTp90dna]2n*gjoJL9l^/3[BQ58qw{=n6m8p": a& = a& + 160
    Mid$(A$, a&, 160) = "THPe[m[<DWfwAJjaTFMF.XINL8)ZCEj]jud61}r}?mL6[222hwUVcQ>^=|PW:S{ExfQ-=v5cW*mD,WjZIGPZgNW'TA8j+RVsMnVjtWGrW,+,,D0fRMrru_cWbVrxQ*ZzVyHz;<kT+u:,5AJ,1-fYJzFW+;E5;a*a": a& = a& + 160
    Mid$(A$, a&, 160) = "5xMWGw_a9V-mL-iM=p7_TxQMECGfsg0'M;m\XDOxa\LD;|oq,qW5?v;[p_oSmob/u)Y8kUX8U>hK_}:|Lk=boMbl9(yT13}h2iHSpuQ^0B+Wsb*+EWnR_Z+a\yL;]+*i:0E;I)mkPgoOM0CFA2mYpypy[ti4BtxN": a& = a& + 160
    Mid$(A$, a&, 160) = "/E1j58WvAe;,{,U=^HG'LLXqspuPxEtIE)Br-2x^GcK]VZ17XKW9I]5QW37iw;<_RmU5uBjOTnB;u'f,y3weEB9q/N?e,Te'exjgx/=(g+uPf-4cW9?\?.gJ'uYiQ[(lj]vhP203P=)9hXcBFi1se5Oc?n}DN5te": a& = a& + 160
    Mid$(A$, a&, 160) = "m1/c*Z:1-<gZ?XCZ>t3-l{*F(]f4uu>iAW_\9=:z=).(0Cpwcr)qh(^WDi9k]<vUDDEcgNp9ES:+Q{2:ykX=.z?obmDe7l,-aj)i8<w)p8_W_5{twKxO[NZ*'F+<>}pD>'C1:OD:0Vkb+XC5UYKFNP/X\+{*rYQF": a& = a& + 160
    Mid$(A$, a&, 160) = "<M*mO+CULr-),XBYbRyz9X+K3LbVVtd1.PnAbu3<9)]P}L;EZ8z>f6TQ(]w_|)CGXxtAd3y;Aru6TV>PX=\5a0ZKVlFj[?5xxeGdN.D:PHGHZ;r7F:_0H06|u1DgjQS.DrP^*m:MY+81DvRL+,x5/a:T'65k'ryY": a& = a& + 160
    Mid$(A$, a&, 160) = ")HVpDj7+O)ldD4QH^tn:YdxnB7x>WCI+S3E2mQ.igPK>zWdA?LcrCikx_o>c^16H[o5PTK{D+kse+CiAsv97,XAEt)2PUxdd5BFDZ-zbHz(Jd>yB*|o?CgX=th6>H5Gc-Dy=mFhp4'W{8SP6*<E5iX;*sy0?+f{q": a& = a& + 160
    Mid$(A$, a&, 160) = "+IwmD|GDy^L{4kKkb|n,0\uxA[CDg*XAnFeXZ6Fs]3DGM|gc{wScyX[nk([13AVo*<WA\[hGnqLl?_)U7tqm(]0qdE'1+}E[]E.xJwJ]kqniz.ujr)m9J2zh0^]fE|Zbp3HcOfi8fehAB)ZcIt\{dbwY|}icbIcC": a& = a& + 160
    Mid$(A$, a&, 160) = "CgR:K;w'.H1-0[[j7[KCRw18\Cccf9MjJe-),D,VILlk{igO+MDvMfgA/zJ1sDta'|px>j\tSzN1ja?6[;pUK{8zr[\nP1Ip7I=ETj*PPO6h\_YOsTaZ>/(VKJTY}s;*m\/g087JacU\ydM_wnpA.;(V3j_KAoeX": a& = a& + 160
    Mid$(A$, a&, 160) = "TmJT_tgZ_iCk2vWbbJlQFQC;LQbd|IS-A:kKAV^(RcRU[C2aur8uw)wL[on0s=x*\:J}aV?pA=)=?1|GdWXJSGY>8[HRZVL;b:6M{walmqal)2lL8cf*NjhO/ZzVp9svz<.<<hiNtvvA7Wk*IrRaInW_C2K}/y\R": a& = a& + 160
    Mid$(A$, a&, 160) = "KGU-WM,T:FtaQLg}ysuBF4^5u),DJ)hp'nC[)>mO*f_)>uD6UpNZ+\YrRe;y6R(pEgm>Y64Ro.p1Rs(^bW4mV7[a=WIeqT..^}l?Qvq:FS6Pbte*6'+X(^nxY1;R}Cxn<R4k[>[\7RawJZGZxWhAX\JMw=^vkJ\N": a& = a& + 160
    Mid$(A$, a&, 160) = "<doAr;G1\'|y4ZSwZ;SfLh.5dKt<HuRsU7}*EaXq]9v}-)0t(0RruYL*(h}o2R2)mF]n6k^0]c>[zk(xKgk5m*dMnuJYGr*^aF>=^_eV^n+fhraT4m/-zR3*1Z<b2T_[B^u4KthT0TsL*bbI0FPM47yh)I<NxX,G": a& = a& + 160
    Mid$(A$, a&, 160) = "?j+d7h9)0eroCKwr(VmBmpjR:upenN5m+g:=CG32gM)*?;/B]Q>QS+e2esNM+^|eroTJgh.n[(p{CpbOQ6/wWYktZBwZRP4xh(:xm7a]k0DvY6w1tKKqg.i(cD){B12j:YIJDfGQWJl'6nQT(l2?{vR+4p0Di{R>": a& = a& + 160
    Mid$(A$, a&, 160) = "2S6xq{Hq^-?+[};}QePNZ=aD/ga7;l':PsHW8TpCav6ly/Lt);q'kr8>y=4ro+Vd{-)W\dIek-bY_JQ5OYTyP\i,U=*_>N|1/17N_p+3i)aoK*2Uh\Clv(hcF[bJJnj-5M98B/<ckU5z.PVi=BfF<IfK-[.TAFl8": a& = a& + 160
    Mid$(A$, a&, 160) = ")K{nn^596FT4pJqP.DjD<Y>PxGy[]:FBA3vd,7YQmth4(\>y4.?PUK?Gri\_<3\6jvLo4H\udKczJ'5Fg2W=)G_bGqJD}dBw7dzFeeq<)c(hpeijxp+yoBylf\'Xos.x}zgHoHb\uGj2f;vdtG]aDcm.9^;{mi0=": a& = a& + 160
    Mid$(A$, a&, 160) = "LJhU4kj4(0<u'W/wAhRdR)^/kxVvi1{e>VHm6WiCL/6SV:Y9\u'W1o_ONR4E}M,6DU_)VFPHwz*5G8F9k7qA\\,i=+XW=jm>e3j,xeN37-WioW.<x\XU3T{o^[1KADRauo7UYTupSq\a|ZRf<rJqC1cRPj9.fKv{": a& = a& + 160
    Mid$(A$, a&, 160) = "'mEo341vah'*4'.IUdd0tDejfgI4^VR;A<7u*z|\>p)e,w(5R2O:0u3G,YOqklX\mzG'thp;yajwc_)/Ix|>-g5_{n6_*fbvEV.1SlEpVgZ-kluWIapIqU=ES*fwA]6f|smcD-6?+X]8t7gC<|]+-rneJm|}xug[": a& = a& + 160
    Mid$(A$, a&, 160) = "fOU^Tf]Ab}2JT{bTAv;cA\7l}^YgU+o=r*m5'-{YIuumD]jQ(F5kq.S2Bf}81pQe[IP<QKyt*aP;rkd*AOT*qIH-cHSA;<=<B(2(zw=Bn;vT*j8E+FZE]^v=Aq(=s/\D=2IaUxD/q0SS_;:qXpH]UGHs-mb6n*hE": a& = a& + 160
    Mid$(A$, a&, 160) = ">T_p+J;*zsWg.,'?v\9'ALwrI;Cl+mVHHU[nBEmTQ>bi<*zi1T(JCnWn^/bi_SNkKajTZZr':[6cy+V^Is/DalIrT-UcF)Xxe.kMHcleeHHj}cS/6b]cbtFEdn<00I7csnj2UhV8pVQG=KL:)ayl*Jx?-:ZcHufK": a& = a& + 160
    Mid$(A$, a&, 160) = "SC)PaXsS7]qbItBUw0A*=F?nDm(t6GjYiEVDI4jt|xkO{jUln8x:fKsYU^TgO6kl;xqIhP{4fDkjOwf60AXGyhb0tm^wWx;5]tXPDNb8UgP,I^]z>+/.<qB(NWUd-g1LLVSfA^fYlj}y*uYP;P\+bwnSf3z8QXg5": a& = a& + 160
    Mid$(A$, a&, 160) = "L(?k1eEl]v+on=}khP,i{:H[r*>LfD|E\4S_WiNb?C:f{c*RSb/n/)jh*X{>\a\l4y'r7]JB3gj05TNZ{FKC:PMiedngDjscsV.pH2gts'iOFxXD7aN/lz+SyBdTG{ABp.lGyt?=dn_[Ti\whd,|^rl<Qm]x2N?.": a& = a& + 160
    Mid$(A$, a&, 160) = ";qHuMMXm{Jv\=G7FZ5=P2Kgg1m2?2jeaB=}u6d>NgPs'JoCMu3KmJ=W+=:*k^l][b8e[V3212Hd>XX>rB+pEPHc-?oP.wz9}^hva80:qsrW{=*7P|i9ZZnb;9Uo\'?;Xa11:K)zzo1{;v0GO7k,AgUb[.7i1h'03": a& = a& + 160
    Mid$(A$, a&, 160) = "=L/x;1]7sU|j]=__tRz+G0T_)*[q'p4gr>[wcOoEPwdH?NQ}0G9N3[plNxmib3BePc9d.SSuEC8}Yhe_TExO*]Vx1\uA>Yj0fQB}.f](Yh<X}E.):<9?si;O?W'FG9TF2>6MTCX2uCXz_xGWc<1Sib-vp<+5KqHA": a& = a& + 160
    Mid$(A$, a&, 160) = "_zg'{JqV\pmE;s{5=QX5K(<J?+P?.Bl0ctu'IqB{1.gg1coDqE\9:z}KHQ-uk[fLLvN/6a>iv5=-6;M'tqHx|]waYtM55.ZB:+r4LJ=tR,vkwt=qBq0+fH\kWVlB>GTTLi2<zT\5[{}Hg-y.rL3W8(Yl2(?lUSQ/": a& = a& + 160
    Mid$(A$, a&, 160) = "6VGJumu'-)5vT75uZ2v\l?XFWSr'<H7b6F:31:EudIvVw.[+ObgQ6Rd)_E1}pu7F[./_KOWe5B*{z78;[G\]V}KvrD,Np[]MVc7uQh>=dW10wcmyAbbvpgN*1ziohhq87R9Zhb;oc<DNCk/'d?R)=/cN;tJ^[iCZ": a& = a& + 160
    Mid$(A$, a&, 160) = ",JrcS>CGtQ./h'k=e+*A,XZlVhH3>WUQoTLkt[uP[sLfuIjm\{_e]Wh+J-[aZ:{5vyUSgnBkZbLpL1Lf5J7FkobfyH4Y7(J[XIGz_yoH?JyLd\>o:JPSr-ABcVikjW13rDI+bKB-y0;>.e}pL29ivf4ZQi+uzuAf": a& = a& + 160
    Mid$(A$, a&, 160) = "}Rvhd\VfxU:kAQshj.\u,\Mtz''f5([J7r/S6]1o_=Alt.J,;bhk9{t|[,ME>I+v+1JaeRJwO:oAJOj(0QJva0LWliZZ|p1CcB2Y|FUpb]s,vy+)Ns'9QmZubE)2S5ja|?h-/HEX13FUA'3[p*bq>xQ>e/z*?d)s": a& = a& + 160
    Mid$(A$, a&, 160) = "9=2yCVky}-|-d*k'd-W):Uo/qCo{E6BoaJ4tFKlUwPR7mm59UE0VW*pSAr_J8g9y]vs2]>,Y3{.uc}gS86rsg*.UQ-S6B5hLaAYXRF*,)ZM=f2G1B;,K2lBN6:Hb*.-7TQYa7z't2{92eUl*\^Q=3ln];;vS'k0E": a& = a& + 160
    Mid$(A$, a&, 160) = "SM-QJ2\r*x::i,s]5i8G/,FuQl/Hp1(lOo8*ssJ]|hvUjBR-6I>-^D4gg{Ocq6c/|7;YPP+4x(8=1k:FE0;:qSJwC44]goxZ\>pv8M9KaJkX93hkTwtb>7+ra*kOkepjB3a\?-S\m-A';D\SP2b^4W]T3I(bN*j+": a& = a& + 160
    Mid$(A$, a&, 160) = "VHHaWUm,Zf+x6X^O9Q^)9=x*E)EK_sOjkNKyMPv5g-zm)<;+,KW[6o5c**bxRNdB[t6-t/8_Lm;\ZTcU86cB_cB=C+g5.(R+Y5iGv.DJ2Wj4TcU=:{q2m'O'Zy\N<}3JzDZk}q1MR/nEAO'BcJ.w?518DD=e:}hY": a& = a& + 160
    Mid$(A$, a&, 160) = "p\?km|dQAkgkt;1KK{6xPB^O?caUHTH\RJ3')YKSRP.'.FADnK,R-aXSkz-b75lrwNpYPydbK[NsxHKGF>(<1e)_PZZypcufW-vA'SPH^E;8deqyOeT4\c,Bal'AORN_<|=A.bl^jH3X,H/Z<INJX,lhu2>fFkjV": a& = a& + 160
    Mid$(A$, a&, 160) = "-VwIyem*.1Rj|=;x{)l,ORz\34I+Zko:*C;;i9nUjnJZl>bvN^]8|Ml+.2\)/P?AiKQm,y-J[Sh0<v4>d1bIa<wk/Idb(PV[:<x\CV5jXgO[WQWoE;ZYKk\I4\KAY]=D1)iuv[dXqKhlCy[^q]m}cZ9ihCCtQ+BA": a& = a& + 160
    Mid$(A$, a&, 160) = "l6kez<;}xiZa/\CzJjv.^R)HSY4c83<RuQP?v*J0K:flbFB_BcEulk:RL0c?drb]CHcL[sdBQz9IWUtcg1B[I2PFczHy]1?Ax8lJ^KgQZ8Z8Z|\Sqa*>5kWdArIF(\z.L=R1e+toa_l.SYwJMG)>h9L<;./?o7'[": a& = a& + 160
    Mid$(A$, a&, 160) = "fn=I'Jf0vLBqZpdPTGeu-mM:sYHkqi]Z+S|J1iTxqguOW=O_SF=2idpS;ZmTL;,d6Kz=^+*>G>wOo7'y'B>nE<6^*WEJ?<;ie/Vt=>fR{;mB?^N9A}iy3:,UuxJh}c]Q9lHwXJqi'_'/7NQmVcV_K1:GR33x]3[_": a& = a& + 160
    Mid$(A$, a&, 160) = "twK;4b_Q=+vSRjqnS5kI^Qw=;'k54]+0W9rIf?(h]y|4+l_Jy(F;TQA**yLW/Pmb=lAT2raPq-4XmLs2'H/ViOu:r*)jbfit68iyYvn0/',I;g+4g8(h-mH{C['ijiIFGoUf(67lPI<;nt*nDD{0\{>tp0D3:'kn": a& = a& + 160
    Mid$(A$, a&, 160) = "3]oMcuj1_daDz_;b/h24cKq9{OSFo*iSDic6U420<YAoeXtY++P1bcTG]Qq|{/1a]27<(IXVH9VP0>krUaypG));+[rbMQLzGDci64QAJwF3;p0m2nUTXaaQqQFc</3JN.2zgQag4=/oE*n;S:ugzQ^?J1/tYo2S": a& = a& + 160
    Mid$(A$, a&, 160) = "eayP6:yXadQIhkUw=WFmQXqf_klUFBDLBdSM*u-?wx5Hy>xCVdk.ML*sGN=cTqAhhvH=X7Ei4Fqiy827L5p?9LX)\hQ.+5k5GcyJ'v]*tkg{3zWaO?jFBs4F*;0yX7=4ENs;]J0_XulrdtWzFciHN>DWC+|P*8Ls": a& = a& + 160
    Mid$(A$, a&, 160) = "2pr?aV,:P/ZpwY]5ceaECvhH=dOB5JFs[cU2ZnQm4z9-u/Y_Bz{;}/EkIYayNL1(6]f3mG/ldpX{^:o5yrgWe(,5AE0.pD{vWG|/=]vf:8WB'O?<pkddbH:(3oxjhuul,{yFOTsCdY,-TLmGMtpal+31]ldLp5U\": a& = a& + 160
    Mid$(A$, a&, 160) = "H,'c[X5xA*2)}:7'8}2Jo6Bm44-UEDnj3*EIkbX\uQWP+zr+{5<>9IN4Z_,J-E7A85',)\K/bn7/U4U)c\Q_W9]V:?H2EUu<]\xog:?oMY-6|jf(9qdbekZCmZgg*6J-DenW(p-:->P0y6ZH_(Ss_MKvS(d|jvnP": a& = a& + 160
    Mid$(A$, a&, 160) = "0vxow;i;+'p4uiH/[8'd*](c2g'1k.:Ht73?a17DI5zyf<)jEUgSAmiIm4:\u<pVv;Il}MNDZ25hDuJ|HNJgMmemvi{(z4|=9;=do9iVrUKgZj>[S\Ue7xcp|r5x]n(?0.HD>[)wPqviRlWmn,i]K(p-9_{MhI6M": a& = a& + 160
    Mid$(A$, a&, 160) = "}1>F9)gY}{h4uke13yBGGZg_=^a8k_HEe.9FfZmf}jsYn8'r(JFvdO\jmaw=wkktqnH1PyIzkLKkeg86pDQ.Fjfd>_pD(2|=5D+mB6GqIP[XXG,t2*hpXK,Bu+X}1<Y[tV?{0}oNl5]ZC)Ly1fAno*iNC1nwol>=": a& = a& + 160
    Mid$(A$, a&, 160) = "+)L3=l[3(Z,n(pwQhtF6WefM+lFF|ZL0kC)FwGN35F6G;JZDUvrgN>x_D(LdUwkcTbe.VxSUn3t0JSSf4QN=T\'FKsik=d=u\MNGPHsMuiyoA|Uto9XW7s<:nGYA5i;8[O0h]t8DR^l2P8<7WR-J_wfe=2X3YRzm": a& = a& + 160
    Mid$(A$, a&, 160) = "/1I|XbZp4IssXw:{NjT66?4vG],VZOdkdtP]j_n_f-0jCfGNn+,](CprmgG^E(X0?Cycc-8tCHau^_N[k^q='pI,;A(w/nhn+8eDX8iT|VVB\rE[,Id??'UbAdlXEk[1rMp9WkzAQWI>Qy0N3h;;llL;Jb;HLKN/": a& = a& + 160
    Mid$(A$, a&, 160) = ":gVhY=svc\cnn21ep^o:K3X{R[ns6em2Xi[v^i4sdFJHB8-.BBX{-uvhb*506IwUhFo:aF9(Rh]Oir2EAlno2n=0Ae{/kd-(FEFwn)[O1FI2kO.7[Xkff_lO{f+*:GeJ>o+8[xl91aQbO\=6U)*WdbADs0_3't;{": a& = a& + 160
    Mid$(A$, a&, 160) = "s8h0'q4>(KUkK0dH3<|AzCS_NSossoyB\g/Wa_,SVf79D'G9,Q]Pfvj*z|'8[[X(-EGVD'}L1xf|>{,JoyTs/-)8EnyA8RR-f-:JIo{nKcNT=]WZ/]:nsE--0S[??jd)8oxPe=GXbjgZz\plUK,<mR)v:Ao+L6pM": a& = a& + 160
    Mid$(A$, a&, 160) = ":eRHh-B{tzNM=s,Fpskuso<oE'3+Oanij{3cH}89;j^N9sDYg?Lg,.A.2|a+fjHCzZPrY{tJAoV11+DSpj<HjvaMQIy>Gr}4Ay?7<XBlLb9]RswWFU{*y0f:+1PEJ4w[YdSzDawg]Ob|<d/=oHo21EjJL28]_C8T": a& = a& + 160
    Mid$(A$, a&, 160) = ")K\UY{Z6bMh-.IHX[2n>3;7E[z,6nfdFToRN-cs)1[1xl\AU73J/I)f+9d-g)m[e2T=^){j6K8-[\]ActA5o?i6kDU};}1+JRGR\IL;;l<VlR2'+u'L\U5C6}4So5Ugdw4yqY[*^lta7YPEq0qE]igpDJOydic(C": a& = a& + 160
    Mid$(A$, a&, 160) = ";zb6w+SGD<|'pnWbGCywiWVll(;N3/aL;|/fP}S;rkp-[9r<z8RmDuCSSv*8uWc:K8o2|j1Xv^Y[/GSS_r=soN+RA,VSe(L0H=U[[=SRsC_yj\ilBtaw'=JDDDMgWi5+sdmyQ;,<XI2}k'v]w/S9x{GlQ>wOC'xM": a& = a& + 160
    Mid$(A$, a&, 160) = "TCs{B:q5JQQcDRhk-Yhd5h7<nqO])bU?3d^uNH33+yfK2m*x'n81k<peOXFCHLc.OqN=a<H3.z-1ppT+7v3^7rVVrgWk=IKMM+'_u(St0f,6iaXO(P/zl(Y:{wqZ'eICoa8Gvjk0YLbJTaO0:='<LWF([6'R)YAx": a& = a& + 160
    Mid$(A$, a&, 160) = "KLWhWp_b/^rD+,0LHP:6evgwUv6{B}0feAa5e-{MjNL-pc>[2yLuWXBx+wv4ZvX8Kl5R-XH)[zFfkM<{7e6C24=Guc\sB;,]ivXfL2>J3<IjKuVh1^VzUos8ZtRovpzMJ7Kp^)?fT*rX9fbChWrk^D(e,ppQFfbY": a& = a& + 160
    Mid$(A$, a&, 160) = "+2LCBp9b0:N)j36e]WQr+KZVh+)1\Y;Q_{hQvw8,{frS^;a7VP4-{UoH/mdMPfOdJui1swBFu,]O.Q;CLSo4Gp/OediYd]Y-wtDA0Ol>NhBKRt6;:FOAp_CU:.Murr\emh-iCsB}'BI*ED4QJ^nk|u0\0aQwFHs7": a& = a& + 160
    Mid$(A$, a&, 160) = "Zd9JF_5]O9tRsA-in12y-nqny)85vPD{0ldk:4J0}cKl=iob5GJ=It(]7bXkHjj<*:'-^S?RY9[5^/oLQot{]c'+*MXc:EnX+K/30]VK3n*1Pp1ne5OH+0/HhuP:<b8{K7{T^>UN*v:LcKeYdsrPEYDd/UsF'}oy": a& = a& + 160
    Mid$(A$, a&, 160) = "}<-qfXvvCP7cgX5?vgf_Z_TXMw2S>]ha[uiSW?x,tZ4xz8S}A6AV{B.szq[TYuw-pPOR[DhL}V]qEyi{;abS[,8}Y,Sp4lU<z}WBV[{x59ThxHZg}i,C30z]cDl2vKObxgv,XasvQn?-O4|xUU,/|K(kqHOEU52-": a& = a& + 160
    Mid$(A$, a&, 160) = ".N^*hKBO'L+CD(TME<4mBP7A;cDk8|9Cmj(s_7EV)A'BIrNX2.W>z4g^Zs5'pBtY3I^AS]?yd>p=7+_;+jiC,s[PSNz:IGousgi\uz(Mc,skRn[qaqg,/]YZ:=8i49=Wj4*)O-_)gTm.=eLG'{D+Yu=7|Ql:Smmd": a& = a& + 160
    Mid$(A$, a&, 160) = "r]v2,X5Z'O2CjtAJN+6[GNUV_vw,2Tv7HC[_Y9iN]Cs'JPS4VDP/,\Kz.L=j'K;^Sca9xJ>TQ_QLE'A0/2ovz*Sd4;gh]QT_<\_Az89E[^_0}7*Ec8Z{)Aatf>rq8^)bHW<17coY7NM9xv+KTrB-:3DQ7<<8hu1'": a& = a& + 160
    Mid$(A$, a&, 160) = "e-+W8xl>Bym=kZo^.+|[ucZen'T2NMP]?yveN[?8gzDp2}TY=P\UsBBtkR8jIFFM}VKhT[je>(smCFMNGjbI-8yQKA06r][YK1HKcR4sd(-{U5H>qBd\KnPZK2:I/mK{5[rpn6Y(/[):vcX.;Hj;PMYD8/CArJK/": a& = a& + 160
    Mid$(A$, a&, 160) = "0LhadcC}vQb_U(iW?kUPla=SAX.FPg;e(R<C(EDZ[x<L=3m?hvsyOH{xER;o9\sR\Wx6YSge[y*Ym}l?ckk(n7*AolFlMhbku[XT=y/V<Xj?95^1]Tg^MRf7VnV.bF0mCZY{)0i*CY8WW3Hd?alzKJlTzOak[HqP": a& = a& + 160
    Mid$(A$, a&, 160) = "'Mc6EayBJ-u.FCtqWq<2'F6h}0EXff:rmXn|6xTA\7\b[;,,Y0T(eD<q^>25m06tl'cdU}-yE2jIs}T?2Y3_K8kw\m0bwmVuI-L0\mzk<)JbFhB^phA[mV+Mbt79NHms=02LasT[-M'(yBHW)|i|aueT9,6xLeM.": a& = a& + 160
    Mid$(A$, a&, 160) = "DY,J3sLAv^n<V:uWxyU7Pf3}b>vcQMx(X;2N8FaRx*\FV,iN6rx;Qdm;uWZ/wiS?qbNLcP(6-'mm(vZ^GJ_:tXbZvaw\D+4k33S*VT{K]b-WT9yP^1wx0ZtnV.7uLn;[^jID{PVJU^B3(dXxG=9/fP<kmHS{uiY.": a& = a& + 160
    Mid$(A$, a&, 160) = "ckrzt(H{r:.Afw}75o+q*O2a8;_dDav<)duUE}r;y[kbIvCgmA9WRw9SvBVk5?BD;gEY[EwiFnB*+)0yHf.*}wesadyf:zNmIz:6L*Zd[z>i>v-m<HyBk?r}f3J7H:7Ky{\iyy/mhNXayz]oy3>S\Y|;:n3oGp5a": a& = a& + 160
    Mid$(A$, a&, 160) = "E'aVu'[f,^Ld';O7+94)k6h+U7'>fNI7Xl?}xa807u0Li|sTf}i8C>bS5?T+)WKc,GIrHyWF4wE'VBl_VFGWBPMDJeJC7}kz='KTyy3;HyL(u)xaN-liJ\gYpRcDllcSFpH6G33wJJh()?/-Bn<4rzfFhXv\6C|q": a& = a& + 160
    Mid$(A$, a&, 160) = "YHl77u,L9lYz^4d2S\9f=wf4l]zX1V=LIjBpurVQqXpwBmAw9Grw4>owAYa4z/8lVEY.=3pkQOi,c<}9Eg.\h89|0yI5]F/m.I5gxOGC|sx(Ni6?5X,,elV8MqRC)X[^9vY(i.h=kg<wgeD*KpuV9yGN5^+'Zol<": a& = a& + 160
    Mid$(A$, a&, 160) = "[+JUmI4?^]e9UordR'y:Vs1QcAtp2>(?t,iBHUH/1*H6fQz--qPps.=>.gHCnEd+wn\9YCKH{8sUZLtsv47n/1)Vk,Mku5{l,}DE+Okes^\rMA0?o}4J'Qk,oUp6_\J6s+8FWe[|t<UV=OW8abRF3b6pi;Ye^_KC": a& = a& + 160
    Mid$(A$, a&, 160) = "Ljw:qwo)XS5u;^7<gsKLgp;qyig=jKVxU*w/\VS8eShH9+D]q:N-+HnGwdll9'NkS1-3iCrCOYBdqE+1r'N+[ie3kk5J-'OGuPe0t.p8sRX[bYIG]YB=Qr,LthA^QC/}SQl;G22\ruoU6eH73v1RhYy1.Lx](,ZB": a& = a& + 160
    Mid$(A$, a&, 160) = "^-L[f+KXW2VMs(+HBNHsxL/.]0GyU9}\,hrL[m,H|)y;'M2\}-+Vp6|KgoVhPW[jeTU<T3K[Q|XFjTyz)4bwaQmO4]{SV>:yvqLKeqYcI|rdcq0,xx,CvdM21-.N9qW\O>ZjGcf?8Ue<6LnE+?<E0W1h/yf?^(R9": a& = a& + 160
    Mid$(A$, a&, 160) = "^QFr648Ptt+9.Y*A(SAdTT=Y=5q}[|-=jrc'zv._huE?<K)qH1IdOJNv'+5z.Bjm)WWNN8WG0eL[A(mxME+:w_TeLFL^^;?e1Q9'"
    o$ = Space$(42063): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    jingledat$ = _Inflate$(btemp$, 44874): btemp$ = ""
End Function

Function demodat$ ()
    Dim A$, c$, o$, btemp$, a&, j&, p&, oc&, i, i&, a, c&
    A$ = Space$(3191): a& = 1
    Mid$(A$, a&, 160) = "2ZKIec9vz.mW42zPk<l-81>J39Mbj8liEtFf:xh9W[/^{M]jN?QLC.{(hhIyqQ^[Y+zq|pz\[D[<3Uqu-3zx>/mAG8)AJF/wD'nik3Q{v,L^y=>/>(Sc_IIbrVl5jrngYy.]^oQ66fI(2'MTwOQ(vZ3C_Y'eBfvo": a& = a& + 160
    Mid$(A$, a&, 160) = "|o?Bv<bKIP[l^Xy:GNp8..?HV-L\5lpCZ8[dySwJ;)}FLX?HVS_VQAhEVxtFVn/r0=)ty>yUC-jfaZIL^Fw9oc-1>lmgWqA>lzS=bLcd|?=8Z.6Ge\*pnL_0(n3,|?wPtFcx_GOGnl^G{B\eiV+StOpo0YVj,jk3": a& = a& + 160
    Mid$(A$, a&, 160) = "zR3=JxY*5l+,U:.I2Xmb\0\J/;DOm.VF62byOz:CT<'Jc*Mvpj<lonH:twGWF5DhyWv07kcKj'E-pnz[?5TX.h]|2,-EG{prfKuMFVfM2z_mfzS;bmVuN-x]Rvdfn22>NDw0d[xn9G7tCxt}J6a'\_t(yzJ4ggV'": a& = a& + 160
    Mid$(A$, a&, 160) = "u4T7?DXzQSW*a?q5lrH4Ch.'>6GJ\.:*iT}xXMZvPWTA]{Y|c=cHZ++n6Vor=Fad5.+tn*r*ou5y+gnobf{'Mo5sN|=FMmRsJ0_hoDq>?-kZ8}/W<v6uW;}K7l'kvi?zMG2IE*onwZG74sD;Jbd=k|my=Hd{jGpt": a& = a& + 160
    Mid$(A$, a&, 160) = "mXDdM(,(tXJ9)7WJ2P5Nal[08/\+UQPOx|+\yiTB_M9HZ[Cjw(D?>eLF4]g_>+x(OB^pq8:XDyYop5e<IY*Gvi[vOENJe]uMBwv3uE-n9)zlJ]UjQ8:d;I\V1m1k^y[RH6(Vvgue3RuxboiA3vCpwUCT:5cGsOp}": a& = a& + 160
    Mid$(A$, a&, 160) = "X/d]bqUh+-PuG1(Wlx}6frT:B<yG9E)K'13:B.nyJbKoeyNd*Gz-(}i?ySfZdE|buk)s^aHjCo4NzmfS0\vf;J(K;ufv\hJkHJm53Cg|GRd83azevBtS)c+;.vpC}.UE?/<<uxCPdaCTxT}9b-X\?Jsj^y:_Y+l5": a& = a& + 160
    Mid$(A$, a&, 160) = "-<H|\k;8DtZUl7}ULpQ?,zT;+I1Y5/gXX+iyL'?*.(K1P.NP5AX-dI'iWG;pGZKiaulXSt3gbws2jv05.JZcVD^8n6GW+l^2u|0+56nYo?pkU5kg;Bprt7\8o0wG(C>u9<1eVb2,]i5W]6D3|-<J^4ty/PHsE{YV": a& = a& + 160
    Mid$(A$, a&, 160) = "qG'<A0(?nbe+7\N-T8]d=Mt/o<<n[cr8>oURQ']N:bra1',B}-oVT]hk3<)I\u6[vg*/8dEsByI[ygICV/RR>.a?P(V,m<_+ELWuxm2U5_6ygtVXKx'u)9Z{l0gcz,Rd|4Pa].HGl8W.^4\RGR/=mpUU1(wcLDMN": a& = a& + 160
    Mid$(A$, a&, 160) = "k]3I2mZfkT]h)gij)im\vH+DJ.>Zg0<q_OAPOBJ?xm0sXJ9]ryTXcpvTs5/rP=d97fS5<Ue>s5nCCnnYX{9;*0<u^d<*\-mB5dh>9a_>H^GJ6P^9I\{hrOnitGg/nMv-^_+0V}g3];j[hOS5TzN.LY(<AqZ;F'*Y": a& = a& + 160
    Mid$(A$, a&, 160) = "y8E_IqRryaiJl=[l[O'|N;ZTS\N+_,6)3vkmzQ^Jxykh6WIpe;>mt(*G?T7jc^M[FJgGGda=,UTFtA';=HbvjGS?Ivviid,_FfhG?MrQcS4evRb)|A2'{7Ur:WY;>N{<d4)zg7/oG)|7EJMcRa?3PC=FTZd^z9}=": a& = a& + 160
    Mid$(A$, a&, 160) = "UaE\pEm={LDdd;xGi=4db;5*PCxzM;QeaKUf=T/U)1'xDy1;kDM8_.ykZOFN2GO'N+vJC>*?k<yd24;h[4uhMutk}9pv2DW?ybCq'H1GU-[0|HL77c;Y31mf'WG8kG]2:AWd*|hiq*'8CIJ6<Z8CCToQ[OPIN;k2": a& = a& + 160
    Mid$(A$, a&, 160) = "YRv\F3].:w4\8qSKd-|ar-X}^'bE.jvnT|''/meThXGqTpV]Ip])9sZL]8b/sE-fCe'mMU2F}eM{G6(GV0}'tdNL,R+?\^wZBi=UDmA|O*q?+491|[K*5W.j/.QWWhI|pQhsRUAyB..)zLTf,9Cw?+Kt_(?u2):)": a& = a& + 160
    Mid$(A$, a&, 160) = "bJ*NuOc}'LoJ9QJFzgI?8Ka(hJ7yK{vMb)'\1nFWt?fOR(qpi}-DkhxIe8o<WN:|=X3?69aYNtme4wIjP?vSwFEDCa>PF2V,bdeBh_763yI;E-z>w*>b9u_;vtVOUx^[1nYy35]u3SEWZ^XT;D>XHn:>U+;fmYbK": a& = a& + 160
    Mid$(A$, a&, 160) = "mQuW.2R+5CNRh(\|aaM:]C5q7Shr8MJW}pqst\6s7Jc3,(K?w3Wa/aL)f^qj1dZ*1'8^R7R:iWDjQjseIq=D5Zvw9ky,NZ-T;s.F))tLbE4VV-Dz:S?Szd1;YPeqcrYL:7^Ne'}uNn]dl[x3F2]ZuPQ:|<wJM=)l": a& = a& + 160
    Mid$(A$, a&, 160) = "c2V5o.>7VxvZ.kaFDsUjqvrcu'SD)gsLVLjYQy|j3a3<8uNMUVS1Q3|SDSKl]q61-22+0fER<x*^Gd'+NFDZut:I,Dec8w,][H.ofc4l6A{;,2DfNPYyLkSUz2|Dh=3T0h4U,mkm=UBt\ViLA<fT?ul(w.A7(;_1": a& = a& + 160
    Mid$(A$, a&, 160) = "))oSY0QCsq:s.nTjSH^(?\e6N1-Je}|km9b8i>e0:xm|LR[aPOhJXj}TAkd'x'NSQdt-[id(4C4a'r*(e^aK]Ej*538Nx/'/GJG^Umk7/na+s:Ssky7V/CTYGCwj+ybsoz3Lol/J([};khEE.2U,ThU{;:>b_oQk": a& = a& + 160
    Mid$(A$, a&, 160) = "IqIy;8]Yi.JC9h:KS?z\[W_q)p>*u5|B/X'z'4{7H75AcJ5]52RZn}q4dc7;FE0xDZ'VDb+<v3i=bI[Opm-J_B73y*>EJYW_c6*WShum;jD07\K^[rdM^=R)JPG{LPnswv.f4KuJtcR(F^VVN7GuMoc(Ib6OQMdE": a& = a& + 160
    Mid$(A$, a&, 160) = "GfU1s4l)xsNnr*y^E'?8tBd4)0krfb\2s-}ppm{)0sc[,nkl>AyDD).?naj9=P{+*URzl1<A{*Z;oiKU(SEUZGPh.G;8m[YVu0qL?VQfhKpU|8v=jtbNZ'(K4P(]-0Ic]|u-AG)x-OvQn{:a5730d\x0aT?{IGC_": a& = a& + 160
    Mid$(A$, a&, 160) = ".zhoR>:zO<}TJW1wSC5,5tjv^:XQNV5d2[b6e4:CDm;xqVEU,XclQQ'KpHwy?P1iyg2C76ynr}\NtSYdcu9sX8i8wxhB('Sv6i[M\0T>Ji[ZIE,,-F5?D1{-0QDhvD_QuT,e,8i{^{aVEW{X}mXMr|'[=VX^f+ba": a& = a& + 160
    Mid$(A$, a&, 160) = "Nbolmgc^wqnwFCX)<w^[[y2m3anU-3OQQqVHm+IKtl)40U]eaKlwRlL<S(zsG\6Wo*ts)W^^,b,h66nX;8==WUfrn9X\H^ym:ZBUCz-CBohRX+^ruU96Z^9-|+6h0-9]bgFthj\0ykpn0a'Arz1DZ"
    o$ = Space$(2551): oc& = 1
    For i = 39 To 125
        If i <> 64 And i <> 96 Then c$ = c$ + Chr$(i)
    Next: Dim v As _Unsigned Long
    a = Val(Mid$(A$, 1, 1))
    For i& = 2 To Len(A$) Step 5: v = 0
        For j& = 0 To 4: p& = 85 ^ (4 - j&)
            c& = InStr(c$, Mid$(A$, i& + j&, 1)) - 1
        v = v + c& * p&: Next: Mid$(o$, oc&, 4) = MKL$(v)
        oc& = oc& + 4
    Next: btemp$ = Mid$(o$, 1, Len(o$) - a + 1)
    demodat$ = _Inflate$(btemp$, 24086): btemp$ = ""
End Function

