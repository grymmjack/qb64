' Draws the over world map of Ultima I.
' Converted to QB64PE format

Dim X As _Unsigned _Byte
Dim Y As _Unsigned _Byte
Dim Tiles As _Unsigned _Byte

Screen 7

Open ".\MAP.BIN" For Binary As #1

Dim Colors(0 To 7) As _Unsigned _Byte
Colors(0) = 1       ' Water
Colors(1) = 10      ' Grass
Colors(2) = 2       ' Forest
Colors(3) = 8       ' Mountain
Colors(4) = 15      ' Castle
Colors(5) = 6       ' Signpost
Colors(6) = 13      ' Town
Colors(7) = 0       ' Dungeon Entrance

Dim HiNibble As _Unsigned _Byte
Dim LoNibble As _Unsigned _Byte

For Y = 0 To 167
    For X = 0 To 83
        Get #1, , Tiles
        
        ' The EGA file stores 4 pixels per byte. The hi nibble is the first 
        ' color, the lo nibble is the second.
        HiNibble = Tiles \ 16  ' SHR 4 equivalent in QB64PE
        HiNibble = HiNibble And &H0F
        
        LoNibble = Tiles And &H0F
        
        PSet (X * 2, Y), Colors(HiNibble)
        PSet (X * 2 + 1, Y), Colors(LoNibble)
    Next X
Next Y

Close #1
Sleep