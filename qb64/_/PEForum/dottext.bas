 'dottext
'draw scalable standard text using locate coordinates
Dim Shared ms&, chardot&
Dim Shared klr(0 To 255) As _Unsigned Long
ms& = _NewImage(800, 520, 32)
Screen ms&
_PrintMode _KeepBackground

'!!!! If you want to use another font put apporptiate code here

fw = _FontWidth 'manuually set this if changing code to use a hand drawn font image instead ofusing default

chardot& = _NewImage(fw * 255, 50, 32) 'create an image buffer to place and hold the font
'Screen chardot&     'uncomment to look at it if you would like to
_Dest chardot&
Cls
_ControlChr Off
buildrefcolors
Color klr(15)
For x = 0 To 255
    Print Chr$(x); 'print that font into place
Next x
dottext 2, 1, "Dotext, 2 routines to draw scaleable text dot by dot", klr(3), 1, 1
Screen ms&
_Dest ms&

dottext 3, 3, "Sample Text, standard size.", klr(15), 1, 1
dottext 4, 4, "Sample Text, double height.", klr(8), 1, 2
dottext 6, 6, "Sample Text, double height and width.", klr(12), 2, 2
backdottext 8, 8, "Sample Text, double size and a background.", Chr$(219), klr(11), klr(8), 2, 1
dottext 10, 10, "Sample Text, x1.4 width x2.2 height.", klr(13), 1.4, 2.2
Locate 13, 1: Print "Plain text."
dottext 13, 13, "Sample Text,triple sized!", klr(14), 3, 3
dottext 16, 3, "Randomly sized height, width and color.", klr(Int(Rnd * 15) + 1), Rnd * 3 + .5, Rnd * 3 + .5
dottext 19, 1, "Enter your name.", klr(15), 2, 1
Locate 21, 1: Input n$
n$ = "ByE " + n$ + " !"

px = 1
For c = 1 To Len(n$)
    'breaking down and printing the text message letter by letter
    A$ = Mid$(n$, c, 1)
    ww = Int(Rnd * 6) + 1
    hh = Int(Rnd * 6) + 1
    scalechar 22, px, Asc(A$), _RGB32(Int(Rnd * 255), Int(Rnd * 255), Int(Rnd * 255)), ww, hh
    px = px + ww
Next c

Sub scalechar (c, r, char, cc As _Unsigned Long, tw, th)
    'the raw sub to scan the font image and draw each dot in the font
    Dim kc As _Unsigned Long
    ww = _FontWidth 'this needs to be changed if yuo choose to load a font as a whole image instead
    hh = _FontHeight 'this needs to be changed if yuo choose to load a font as a whole image instead
    tr = (r - 1) * ww
    tc = (c - 1) * hh
    _Source chardot&
    _Dest ms&
    tx = char * 8
    ty = 0
    For px = 0 To (ww - 1)
        For py = 0 To (hh - 1)
            kc = Point(tx + px, ty + py)
            If kc <> klr(0) Then
                'PSet (xx + px, yy + py), cc
                ' Line (xx + px * mag - (mag - 1), yy + py * mag - (mag - 1))-(xx + px * mag, yy + py * mag), cc, BF
                Line (tr + px * tw, tc + py * th)-(tr + (px + 1) * tw - 1, tc + (py + 1) * th - 1), cc, BF
            End If
        Next py
    Next px
End Sub

Sub dottext (c, r, text$, cc As _Unsigned Long, tw, th)
    'take text strign and pass it through scalechar to get print it
    Dim kc As _Unsigned Long
    tr = r
    tc = c

    For k = 1 To Len(text$)
        ch = Asc(Mid$(text$, k, 1))
        scalechar tc, tr, ch, cc, tw, th
        tr = tr + tw
    Next k
End Sub
Sub backdottext (c, r, text$, bkg$, cc As _Unsigned Long, bgc As _Unsigned Long, tw, th)
    'as dotext but wiht a background character and background color defiend in same command
    Dim kc As _Unsigned Long
    tr = r
    tc = c
    bc = Asc(bkg$)
    For k = 1 To Len(text$)
        ch = Asc(Mid$(text$, k, 1))
        scalechar tc, tr, bc, bgc, tw, th
        scalechar tc, tr, ch, cc, tw, th
        tr = tr + tw
    Next k
End Sub

Sub buildrefcolors
    'color reference table for using rgb32 colors quickly
    For c = 0 To 255
        klr(c) = _RGB32(c, c, c) 'all grey for now
    Next c
    _Source chardot&
    klr(0) = Point(1, 1) '<- the pixel at this location in chardot defines black , this would matter if you loaded a an image
    'very slightly cooled EGA palette
    klr(1) = _RGB32(0, 0, 170) 'ega_blue
    klr(2) = _RGB32(0, 170, 0) 'ega_green
    klr(3) = _RGB32(0, 170, 170) 'ega_cyan
    klr(4) = _RGB(170, 0, 0) 'ega_red
    klr(5) = _RGB32(170, 0, 170) 'ega_magenta
    klr(6) = _RGB32(170, 85, 0) 'ega_brown
    klr(7) = _RGB32(170, 170, 170) 'ega_litgray
    klr(8) = _RGB32(85, 85, 85) 'ega_gray
    klr(9) = _RGB32(85, 85, 250) 'ega_ltblue
    klr(10) = _RGB32(85, 250, 85) 'ega_ltgreen
    klr(11) = _RGB32(85, 250, 250) 'ega_ltcyan
    klr(12) = _RGB32(250, 85, 85) 'ega_ltred
    klr(13) = _RGB32(250, 85, 250) 'ega_ltmagenta
    klr(14) = _RGB32(250, 250, 85) 'ega_yellow
    klr(15) = _RGB32(250, 250, 250) 'ega_white
End Sub