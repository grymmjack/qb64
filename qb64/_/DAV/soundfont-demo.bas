 
'make all notes
Dim notes&(8)
notes&(1) = _SndOpen(MidiNotes$(100, 10, "c4rn", 1), "memory")
notes&(2) = _SndOpen(MidiNotes$(100, 10, "d4rn", 1), "memory")
notes&(3) = _SndOpen(MidiNotes$(100, 10, "e4rn", 1), "memory")
notes&(4) = _SndOpen(MidiNotes$(100, 10, "f4rn", 1), "memory")
notes&(5) = _SndOpen(MidiNotes$(100, 10, "g4rn", 1), "memory")
notes&(6) = _SndOpen(MidiNotes$(100, 10, "a4rn", 1), "memory")
notes&(7) = _SndOpen(MidiNotes$(100, 10, "b4rn", 1), "memory")
notes&(8) = _SndOpen(MidiNotes$(100, 10, "c5rn", 1), "memory")
 
'play notes
For t = 1 To 8
    _SndPlayCopy notes&(t)
    _Delay .2
Next
 
 
Function MidiNotes$ (tempo&, patch, notes$, channel)
    '--------------------------------------------
    'Returns MIDI data suitable for MIDI playback
    '--------------------------------------------
    'tempo& = tempo of the midi
    'patch = program number (sound) to use (0-127)
    'note$ = string data of notes to play
    'channel = channel for track to use (1 to 16)
    'You can play notes like this: "c4e4g4"
    'To play notes at the same time you can
    'put them in parenthesis: "(c4e4g4)"
    '
    'You can put duration codes in front of notes.
    'Like this play eighth notes: "en c4e4g4"
    '
    'The following duration strings are allowed:
    '
    '  wn = whole note
    '  dh = dotted half note
    '  hn = half note
    '  dq = dotted quarter
    '  qn = quarter note
    '  de = dotted eighth
    '  en = eighth note
    '  ds = dotted sixteenth note
    '  sn = sixteenth note
    '  ts = 32nd note
    '
    '  rn - rest note - no sound
    '      (uses the set duration)
    '
    'You can change volume of notes by using
    'values v000 to v127, like "v030c4"
    '
    'You can switch program sound # track uses.
    'Use values p000 to p127, like "p011"
    '--------------------------------------------
 
    vol = 127 'default volume
 
    'check and fix channel number here
    '(for programming purpose channels are used 0-15)
    channel = Fix(channel) - 1
    If channel < 0 Then channel = 0
    If channel > 15 Then channel = 15
 
    'first, remove any spaces from the string
    n2$ = ""
    For i = 1 To Len(notes$)
        a$ = Mid$(notes$, i, 1): If a$ <> " " Then n2$ = n2$ + a$
    Next
    notes$ = n2$
 
    '=======================================
    'make MIDI Header Chunk (MThd)
    MThd$ = "MThd"
    MThd$ = MThd$ + Chr$(0) + Chr$(0) + Chr$(0) + Chr$(6) 'header size
    MThd$ = MThd$ + Chr$(0) + Chr$(1) 'format type (1)
    MThd$ = MThd$ + Chr$(0) + Chr$(1) 'number of tracks (1)
    MThd$ = MThd$ + Chr$(1) + Chr$(224) 'division (ticks per quarter note)
    '=======================================
    'make tempo data to save
    'calculate microseconds per beat from tempo& in BPM
    MicroSecsPerBeat& = 60000000 \ tempo& 'Converts BPM to microseconds per beat
    'get msb/mb/lsb from MicroSecsPerBeat& for saving tempo
    '(Midi requires 3 bytes for this info)
    msb = (MicroSecsPerBeat& \ 65536) And 255 'most significant byte
    middle = (MicroSecsPerBeat& \ 256) And 255 'middle byte
    lsb = MicroSecsPerBeat& And 255 'least significant byte
    'make the tempo data + the 3 bytes
    TrackData$ = Chr$(0) + Chr$(255) + Chr$(81) + Chr$(3) + Chr$(msb) + Chr$(middle) + Chr$(lsb)
    '======================================
    'set Program number (patch) to use
    TrackData$ = TrackData$ + Chr$(0) + Chr$(192 + channel) + Chr$(patch)
    '======================================
    'define ticks
    'Set defaut note duration, get tickdata$
    ticks& = 480 'default 480 ticks per quarter note
    GoSub GetTickData
    '=====================================================
    'Load all notes string
    'Loop through all notes$ given
    For n = 1 To Len(notes$) Step 2
        'see if it's a group first ()
        If Mid$(notes$, n, 1) = "(" Then
            'grab group string of notes until a ) found
            group$ = "": count = 0: n = n + 1
            Do
                g$ = Mid$(notes$, n + count, 1)
                If g$ = ")" Then Exit Do Else group$ = group$ + g$: count = count + 1
            Loop
            '========================
            'do group notes here here
            notesoff$ = "" ' holding space for turning notes off
            For g = 1 To Len(group$) Step 2
                b2$ = Mid$(group$, g, 2) 'grab 2 bytes
                'must be a note, so get note val
                GoSub GetNoteValue
                notesoff$ = notesoff$ + _Trim$(Str$(note)) 'save this for use
                'set Note On: play note value (with velocity 127)
                TrackData$ = TrackData$ + Chr$(0) + Chr$(144 + channel) + Chr$(note) + Chr$(vol)
            Next
            addtick = 0 'only add tickdata once flag
            'now send notes off to those above
            For g = 1 To Len(notesoff$) Step 2
                note = Val(Mid$(notesoff$, g, 2))
                'set note off: stop playing note after specified duration
                If addtick = 0 Then
                    'only add tickdata first time around
                    TrackData$ = TrackData$ + TickData$ + Chr$(128 + channel) + Chr$(note) + Chr$(64)
                    addtick = 1 'mark we done it
                Else
                    TrackData$ = TrackData$ + Chr$(0) + Chr$(128 + channel) + Chr$(note) + Chr$(64)
                End If
            Next
            n = (n + count - 1) 'update n location
            _Continue
        End If
        'see if it's a volume change
        If LCase$(Mid$(notes$, n, 1)) = "v" Then
            vol = Int(Val(Mid$(notes$, n + 1, 3)))
            If vol < 0 Then vol = 0
            If vol > 127 Then vol = 127
            n = n + 2: _Continue
        End If
 
        'see if it's a program change
        If LCase$(Mid$(notes$, n, 1)) = "p" Then
            pro = Int(Val(Mid$(notes$, n + 1, 3)))
            If pro < 0 Then pro = 0
            If pro > 127 Then pro = 127
            'set Program number (patch) to use
            TrackData$ = TrackData$ + Chr$(0) + Chr$(192 + channel) + Chr$(pro)
            n = n + 2: _Continue
        End If
 
        'do regular bytes (not a group)
        b2$ = Mid$(notes$, n, 2) 'grab 2 bytes
 
        'see if b2$ is a duration change
        Select Case LCase$(b2$)
            Case "wn", "dh", "hn", "qn", "dq", "de", "en", "ds", "sn", "ts"
                'all these values are based on 'ticks per quarter note' = 480
                If b2$ = "wn" Then ticks& = 1920 'whole note (4 * tpq)
                If b2$ = "dh" Then ticks& = 1440 'dotted half note (3 * tpq)
                If b2$ = "hn" Then ticks& = 960 'half note (2 * tpq)
                If b2$ = "dq" Then ticks& = 720 'dotted quarter (1.5 * tpq )
                If b2$ = "qn" Then ticks& = 480 'quarter note
                If b2$ = "de" Then ticks& = 360 'dotted eighth (.75 * tpq)
                If b2$ = "en" Then ticks& = 240 'eighth note (.5 * tpq)
                If b2$ = "ds" Then ticks& = 180 'dotted sixteenth note (sn + (.5 * sn)
                If b2$ = "sn" Then ticks& = 120 'sixteenth note (.25 * tpq)
                If b2$ = "ts" Then ticks& = 60 '32nd notes (1 / 8) * tpq
                GoSub GetTickData
                _Continue
        End Select
        'check for a rest note, handle special
        If LCase$(Mid$(notes$, n, 2)) = "rn" Then
            '(play any note at zero volume? (this just fakes a rest)
            'TrackData$ = TrackData$ + Chr$(0) + Chr$(144 + channel) + Chr$(22) + Chr$(0)
            'set rest note off: stop playing note after specified duration
            TrackData$ = TrackData$ + TickData$ + Chr$(128 + channel) + Chr$(note) + Chr$(64)
            _Continue
        End If
 
        'must be a note, so get note val
        GoSub GetNoteValue
        '================================
        'set Note On: play note value (with velocity 127)
        TrackData$ = TrackData$ + Chr$(0) + Chr$(144 + channel) + Chr$(note) + Chr$(vol)
        '===============================
        'set note off: stop playing note after specified duration
        TrackData$ = TrackData$ + TickData$ + Chr$(128 + channel) + Chr$(note) + Chr$(64)
        '================================
    Next
 
    '============================
    'SAVE TRACK DATA
    'make the MTrk header
    MTrk$ = "MTrk"
    'make track end event
    TrackData$ = TrackData$ + Chr$(0) + Chr$(255) + Chr$(47) + Chr$(0)
    'make the track data length (4 bytes)
    TrackLen& = Len(TrackData$)
    TrackLength$ = Chr$((TrackLen& \ 16777216) And 255) + Chr$((TrackLen& \ 65536) And 255) + Chr$((TrackLen& \ 256) And 255) + Chr$(TrackLen& And 255)
    '============================
 
    'put it all together
    MidiNotes$ = MThd$ + MTrk$ + TrackLength$ + TrackData$
 
    Exit Function
 
 
 
    '====================================================================================
    'GOSUBS...Like'em or not, they're here to use.
    '        (keeping eveything in one FUNCTION)
    '=============================================
    GetTickData:
    '==========
    'convert ticks& to variable length quantity (VLQ)
    TickData$ = ""
    If ticks& = 0 Then
        TickData$ = Chr$(0) 'safety, in case ticks& = 0
    Else
        Do
            byte& = ticks& And &H7F
            ticks& = ticks& \ 128
            If TickData$ <> "" Then byte& = byte& Or &H80
            TickData$ = Chr$(byte&) + TickData$
        Loop While ticks& <> 0
    End If
    Return
    '============================================
    GetNoteValue:
    '===========
    'Gets a note value from b2$
    note = 0 'safety defaut
    If b2$ = "a0" Then note = 21
    If b2$ = "A0" Then note = 22
    If b2$ = "b0" Then note = 23
    If b2$ = "c1" Then note = 24
    If b2$ = "C1" Then note = 25
    If b2$ = "d1" Then note = 26
    If b2$ = "D1" Then note = 27
    If b2$ = "e1" Then note = 28
    If b2$ = "f1" Then note = 29
    If b2$ = "F1" Then note = 30
    If b2$ = "g1" Then note = 31
    If b2$ = "G1" Then note = 32
    If b2$ = "a1" Then note = 33
    If b2$ = "A1" Then note = 34
    If b2$ = "b1" Then note = 35
    If b2$ = "c2" Then note = 36
    If b2$ = "C2" Then note = 37
    If b2$ = "d2" Then note = 38
    If b2$ = "D2" Then note = 39
    If b2$ = "e2" Then note = 40
    If b2$ = "f2" Then note = 41
    If b2$ = "F2" Then note = 42
    If b2$ = "g2" Then note = 43
    If b2$ = "G2" Then note = 44
    If b2$ = "a2" Then note = 45
    If b2$ = "A2" Then note = 46
    If b2$ = "b2" Then note = 47
    If b2$ = "c3" Then note = 48
    If b2$ = "C3" Then note = 49
    If b2$ = "d3" Then note = 50
    If b2$ = "D3" Then note = 51
    If b2$ = "e3" Then note = 52
    If b2$ = "f3" Then note = 53
    If b2$ = "F3" Then note = 54
    If b2$ = "g3" Then note = 55
    If b2$ = "G3" Then note = 56
    If b2$ = "a3" Then note = 57
    If b2$ = "A3" Then note = 58
    If b2$ = "b3" Then note = 59
    If b2$ = "c4" Then note = 60
    If b2$ = "C4" Then note = 61
    If b2$ = "d4" Then note = 62
    If b2$ = "D4" Then note = 63
    If b2$ = "e4" Then note = 64
    If b2$ = "f4" Then note = 65
    If b2$ = "F4" Then note = 66
    If b2$ = "g4" Then note = 67
    If b2$ = "G4" Then note = 68
    If b2$ = "a4" Then note = 69
    If b2$ = "A4" Then note = 70
    If b2$ = "b4" Then note = 71
    If b2$ = "c5" Then note = 72
    If b2$ = "C5" Then note = 73
    If b2$ = "d5" Then note = 74
    If b2$ = "D5" Then note = 75
    If b2$ = "e5" Then note = 76
    If b2$ = "f5" Then note = 77
    If b2$ = "F5" Then note = 78
    If b2$ = "g5" Then note = 79
    If b2$ = "G5" Then note = 80
    If b2$ = "a5" Then note = 81
    If b2$ = "A5" Then note = 82
    If b2$ = "b5" Then note = 83
    If b2$ = "c6" Then note = 84
    If b2$ = "C6" Then note = 85
    If b2$ = "d6" Then note = 86
    If b2$ = "D6" Then note = 87
    If b2$ = "e6" Then note = 88
    If b2$ = "f6" Then note = 89
    If b2$ = "F6" Then note = 90
    If b2$ = "g6" Then note = 91
    If b2$ = "G6" Then note = 92
    If b2$ = "a6" Then note = 93
    If b2$ = "A6" Then note = 94
    If b2$ = "b6" Then note = 95
    If b2$ = "c7" Then note = 96
    If b2$ = "C7" Then note = 97
    If b2$ = "d7" Then note = 98
    If b2$ = "D7" Then note = 99
    If b2$ = "e7" Then note = 100
    If b2$ = "f7" Then note = 101
    If b2$ = "F7" Then note = 102
    If b2$ = "g7" Then note = 103
    If b2$ = "G7" Then note = 104
    If b2$ = "a7" Then note = 105
    If b2$ = "A7" Then note = 106
    If b2$ = "b7" Then note = 107
    If b2$ = "c8" Then note = 108
    Return
End Function