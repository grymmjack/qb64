$NoPrefix
DefLng A-Z
Option Explicit
Option ExplicitArray

Screen NewImage(800, 327, 32)

Print "Loading...";
Dim Song As Long
Song = SndOpen("GJ-TD.S3M") ' Replace this with your sound file
If Song < 1 Then
    Print "Failed to load song!"
    End
End If
Print "Done!"

SndPlay Song

Dim SampleData As MEM
SampleData = MemSound(Song, 1) ' This can now be 0 or 1
If SampleData.SIZE = 0 Then
    Print "Failed to access sound sample data."
    End
End If

Dim x As Long, i As Unsigned Integer64, sf As Single, si As Integer
Dim sz As Unsigned Integer64

sz = CV(Unsigned Integer64, MK$(Offset, SampleData.ELEMENTSIZE)) ' Get the value of the elementsize member

Do Until KeyHit = 27 Or Not SndPlaying(Song) Or i + (Width * sz) > SampleData.SIZE
    Cls
    Locate 1, 1: Print i; "/"; SampleData.SIZE, "Frame Size ="; sz, "Data Type ="; SampleData.TYPE

    If (sz = 4 Or sz = 2) And SampleData.TYPE = 1 Then
        For x = 0 To Width - 1
            si = MemGet(SampleData, SampleData.OFFSET + i + x * sz, Integer) 'get sound data
            Line (x, Height / 2)-Step(0, 300 * si / 32768), RGB32(0, 111, 0) 'plot wave
        Next
    ElseIf (sz = 8 Or sz = 4) And SampleData.TYPE = 4 Then
        For x = 0 To Width - 1
            sf = MemGet(SampleData, SampleData.OFFSET + i + x * sz, Single) 'get sound data
            Line (x, Height / 2)-Step(0, sf * 300), RGB32(0, 111, 0) 'plot wave
        Next
    ElseIf sz = 2 And SampleData.TYPE = 0 Then ' Old QB64 OpenAL stuff
        For x = 0 To Width - 1
            si = MemGet(SampleData, SampleData.OFFSET + i + x * sz, Integer) 'get sound data
            Line (x, Height / 2)-Step(0, 300 * si / 32768), RGB32(0, 111, 0) 'plot wave
        Next
    End If

    Display
    Limit 60

    i = Fix(SndGetPos(Song) * SndRate) * sz ' Calculate the new sample frame position
Loop

Sleep 2
SndClose Song 'closing the sound releases the mem blocks
AutoDisplay
End
