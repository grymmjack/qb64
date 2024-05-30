Option _Explicit
$Color:32

Const Port = "7319", IP = "172.93.60.23"
Const FullPort = "TCP/IP:" + Port
Const FullIP = FullPort + ":" + IP

Dim Shared As Long client 'up to 1000 connections
Dim As String recieved, send
Dim Shared As String nam
Dim Shared As Long MainDisplay, TextArea, InputArea
Dim Shared As _Float NextPing, server_active

MainDisplay = _NewImage(1280, 720, 32)
TextArea = _NewImage(1280, 600, 32)
InputArea = _NewImage(1280, 120, 32)

Screen MainDisplay

client = _OpenClient(FullIP)
If client Then
    Print "Connected to Steve's Chat!"
    server_active = ExtendedTimer + 300 'server is now counted as being "active" for the next 5 minutes
    Input "Enter your name =>"; nam
    SendMessage "/NAME:" + nam
    _KeyClear 'clear the input buffer, Steve, you big idiot!
    '_KEYHIT will still hold the name in that buffer as it's independent to INPUT!
    NextPing = ExtendedTimer
    Do '                                                      main program loop
        recieved$ = GetMessage
        ProcessInput recieved$ '                      deal with any server command type messages
        If recieved$ <> "" Then '                          we got something from the clien
            _Dest TextArea
            Print recieved$ '                              it should just be a message of some sort
        End If
        InputJunk

        If ExtendedTimer > NextPing Then 'send a message to the server that we're still active
            SendMessage "/PING:" '        that message is a simple PING
            NextPing = ExtendedTimer + 30 'and send this every 30 seconds so we don't disconnect.
        End If

        If ExtendedTimer > server_active Then
            Print: Print "Sorry.  It appears the server has went offline."
            Print "We are now terminating this chat client."
            Print: Print "Please try back again later."
            _Delay 2: _KeyClear: Sleep: System
        End If

        Cls , 0, MainDisplay
        _PutImage (0, 600)-(1279, 719), InputArea, MainDisplay
        _PutImage (0, 0)-(1279, 599), TextArea, MainDisplay

        _Display
        _Limit 30
    Loop
Else
    Print "Sorry.  Could not connect at this time."
    Print "Check Firewall, port forwarding, or other internet TCP/IP blockades."
    End
End If

Sub ProcessInput (what As String)
    Select Case what
        Case "/PING:" 'the server send us back a /PING response
            server_active = ExtendedTimer + 300
            what = ""
    End Select
End Sub


Sub InputJunk
    Dim As Long k
    Static send$
    _Dest InputArea
    Cls , LightGray
    k = _KeyHit
    Select Case k
        Case 32 To 255
            send$ = send$ + Chr$(k)
        Case 8
            send$ = Left$(send$, Len(send$) - 1)
        Case 13
            SendMessage send$
            send$ = ""
    End Select
    Print nam + ": " + send$
    _Dest TextArea
    If _Exit Then
        SendMessage "/EXIT:"
        System
    End If
End Sub


Sub SendMessage (msg As String)
    Dim As String * 256 temp
    msg = Left$(msg, 255)
    temp = Chr$(Len(msg)) + msg
    Put client, , temp 'put the size + data we want -- up to 255 bytes (+1 for size)
    msg = "" 'reset to blank after we send it
End Sub

Function GetMessage$
    Dim As _Unsigned _Byte b
    Dim As String * 256 temp, recieved

    Get #client, , temp 'get the size of the data we want to recieve -- up to 255 bytes
    b = Asc(temp, 1)
    recieved = Mid$(temp, 2)
    Do Until Len(recieved) >= b 'we may have gotten the whole string in one pass
        Get #client, , temp 'if not, keep recieving extra data as needed
        recieved = recieved + temp 'until we get the full data
    Loop
    GetMessage = Left$(recieved, b) 'and then trim it down to the proper size to eliminate trailing spaces
End Function


Function ExtendedTimer##
    'Simplified version of the TimeStamp routine, streamlined to only give positive values based on the current timer.
    'Note:  Only good until the year 2100, as we don't do all the fancy calculations for leap years.
    'A timer should work quickly and efficiently in the background; and the less we do, the less lag we might insert
    'into a program.

    Dim m As Integer, d As Integer, y As Integer
    Dim s As _Float, day As String
    day = Date$
    m = Val(Left$(day, 2))
    d = Val(Mid$(day, 4, 2))
    y = Val(Right$(day, 4)) - 1970
    Select Case m 'Add the number of days for each previous month passed
        Case 2: d = d + 31
        Case 3: d = d + 59
        Case 4: d = d + 90
        Case 5: d = d + 120
        Case 6: d = d + 151
        Case 7: d = d + 181
        Case 8: d = d + 212
        Case 9: d = d + 243
        Case 10: d = d + 273
        Case 11: d = d + 304
        Case 12: d = d + 334
    End Select
    If (y Mod 4) = 2 And m > 2 Then d = d + 1 'add a day if this is leap year and we're past february
    d = (d - 1) + 365 * y 'current month days passed + 365 days per each standard year
    d = d + (y + 2) \ 4 'add in days for leap years passed
    s = d * 24 * 60 * 60 'Seconds are days * 24 hours * 60 minutes * 60 seconds
    ExtendedTimer## = (s + Timer)
End Function
