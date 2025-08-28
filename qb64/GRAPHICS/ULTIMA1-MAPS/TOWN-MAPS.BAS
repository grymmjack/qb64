' Draws the Towns of Ultima 1 in CGA and EGA mode.
' Converted to QB64PE format

Dim TileCGA(0 To 50) As Long ' Image handles in QB64PE
Dim TileEGA(0 To 50) As Long

Dim X As _Unsigned _Byte
Dim Y As _Unsigned _Byte
Dim Pixel As _Unsigned _Byte
Dim TileNumber As _Unsigned _Byte
Dim OffsetX As _Unsigned Integer
Dim OffsetY As _Unsigned Integer
Dim Offset As _Unsigned _Byte

' === Load CGA Tiles ===
Screen 1
Color 0, 1      ' Low intensity cyan/magenta/white palette.

Dim Pixels As _Unsigned _Byte
Dim ColorBlock As _Unsigned _Byte

Open ".\CGATown.bin" For Binary As #1

OffsetX = 0
OffsetY = 0
For TileNumber = 0 To 50
    For Y = 0 To 7
        For X = 0 To 1
            Get #1, , Pixels
            
            ' Determine the four pixels from this one byte.
            ColorBlock = 7
            For Offset = 0 To 3
                If (Pixels And (2 ^ ColorBlock)) <> 0 Then
                    If (Pixels And (2 ^ (ColorBlock - 1))) <> 0 Then
                        Pixel = 3
                    Else
                        Pixel = 2
                    End If
                Else
                    If (Pixels And (2 ^ (ColorBlock - 1))) <> 0 Then
                        Pixel = 1
                    Else
                        Pixel = 0
                    End If
                End If
    
                ' Plot the pixel.
                PSet ((X * 4) + Offset, Y), Pixel
                ColorBlock = ColorBlock - 2
            Next Offset
        Next X
    Next Y
    
    TileCGA(TileNumber) = _NewImage(8, 8, 1) ' Create 8x8 image in Screen 1 mode
    _Source 0: _Dest TileCGA(TileNumber)
    _PutImage (0, 0)-(7, 7), 0, TileCGA(TileNumber), (0, 0)-(7, 7)
    _Source 0: _Dest 0
Next TileNumber

Close #1

' === Load EGA Tiles ===
Screen 7

Open ".\EGATown.bin" For Binary As #1

Dim Blue As _Unsigned _Byte
Dim Green As _Unsigned _Byte
Dim Red As _Unsigned _Byte
Dim Intensity As _Unsigned _Byte

OffsetX = 0
OffsetY = 0
For TileNumber = 0 To 50
    For Y = 0 To 7
        ' The EGA file stores a row of 8 pixels per 4 bytes.
	' The byte breakdown is: Blue, Green, Red, Intensity

        Get #1, , Blue
        Get #1, , Green
        Get #1, , Red
        Get #1, , Intensity
        
        Offset = 7
        For X = 0 To 7
            Pixel = 0
            If (Blue And (2 ^ Offset)) <> 0 Then
                Pixel = Pixel + 1
            End If
            If (Green And (2 ^ Offset)) <> 0 Then
                Pixel = Pixel + 2
            End If
            If (Red And (2 ^ Offset)) <> 0 Then
                Pixel = Pixel + 4
            End If
            If (Intensity And (2 ^ Offset)) <> 0 Then
                Pixel = Pixel + 8
            End If
            
            PSet (X, Y), Pixel

            Offset = Offset - 1
        Next X
    Next Y
    
    TileEGA(TileNumber) = _NewImage(8, 8, 7) ' Create 8x8 image in Screen 7 mode
    _Source 0: _Dest TileEGA(TileNumber)
    _PutImage (0, 0)-(7, 7), 0, TileEGA(TileNumber), (0, 0)-(7, 7)
    _Source 0: _Dest 0
Next TileNumber

Close #1

' === Draw All Maps ===
Dim TileId As _Unsigned _Byte
Dim Maps As _Unsigned _Byte
Dim Display As _Unsigned _Byte

For Display = 0 To 1
    If Display = 0 Then
        Screen 1            ' CGA
        Color 0, 1
    Else
        Screen 7            ' EGA
    End If
    
    Open ".\TCD.bin" For Binary As #1

    For Maps = 0 To 9
        CLS
        For X = 0 To 37
            For Y = 0 To 17
                Get #1, , TileId
                
                If TileId < 50 Then
                    If Display = 0 Then
                        _PutImage (X * 8 + 8, Y * 8 + 8), TileCGA(TileId)
                    Else
                        _PutImage (X * 8 + 8, Y * 8 + 8), TileEGA(TileId)
                    End If
                Else
                    If Display = 0 Then
                        _PutImage (X * 8 + 8, Y * 8 + 8), TileCGA(1)
                    Else
                        _PutImage (X * 8 + 8, Y * 8 + 8), TileEGA(1)
                    End If
                End If
            Next Y
        Next X
        
        Sleep
    Next Maps

    Close #1
Next Display