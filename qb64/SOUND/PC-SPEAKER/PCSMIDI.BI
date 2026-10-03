''
' PCSMIDI.BI - Standard MIDI File (.mid) to PC speaker voices (header)
'
' Reads a type 0 or type 1 MIDI file (tempo changes included) and turns its
' notes into up to 4 voices of PIT divisors at 140 steps a second - the same
' data PCSEDIT edits. Also reads QB64 PLAY strings (MML) and ProTracker
' .mod music. Used by PCSEDIT (open / drop a file) and MID2SND.BAS.
'
' Usage:
'   '$INCLUDE:'PCSMIDI.BI'          at the top
'   IF PCSMIDI_Load("song.mid") THEN
'       PCSMIDI_Render 4, 0, 0, 1, 9000   ' voices, transpose, drums, gap, max steps
'       ' pcsmidiVoice(1 TO 4) hold the voices (2 bytes per step)
'   ELSE
'       PRINT pcsmidiError
'   END IF
'   '$INCLUDE:'PCSMIDI.BM'          at the bottom
'
$IF PCSMIDI_BI = UNDEFINED THEN
    $LET PCSMIDI_BI = TRUE

    CONST PCSMIDI_RATE = 140 '              steps per second (IFS)
    CONST PCSMIDI_VOICES = 4
    CONST PCSMIDI_PIT = 1193182

    TYPE PCSMIDI_NOTE
        t0 AS DOUBLE ' start / end in seconds
        t1 AS DOUBLE
        tk0 AS _INTEGER64 ' start / end in ticks (while loading)
        tk1 AS _INTEGER64
        pitch AS INTEGER ' MIDI note number
        chan AS INTEGER ' 0-15 (9 = drums)
        trk AS INTEGER
    END TYPE

    REDIM SHARED pcsmidiNote(0 TO 0) AS PCSMIDI_NOTE
    DIM SHARED pcsmidiCount AS LONG ' notes loaded
    DIM SHARED pcsmidiError AS STRING ' why PCSMIDI_Load failed
    DIM SHARED pcsmidiTitle AS STRING ' the first track name, if any
    DIM SHARED pcsmidiTracks AS LONG
    DIM SHARED pcsmidiChanMask AS LONG ' bit n: channel n is used (n = 0-15)

    DIM SHARED pcsmidiIsMidi AS INTEGER ' the notes came from a MIDI file (channel 10 = drums)
    ' .mod files: the samples, and which to leave out (PCSMIDI_LoadMOD)
    DIM SHARED pcsmidiSmpName(1 TO 31) AS STRING
    DIM SHARED pcsmidiSmpLen(1 TO 31) AS LONG ' bytes
    DIM SHARED pcsmidiSmpLoop(1 TO 31) AS INTEGER
    DIM SHARED pcsmidiSmpNotes(1 TO 31) AS LONG
    DIM SHARED pcsmidiSmpCount AS LONG
    DIM SHARED pcsmidiSkip(0 TO 31) AS INTEGER ' set to leave a sample's notes out

    ' PCSMIDI_Render's results
    DIM SHARED pcsmidiVoice(1 TO PCSMIDI_VOICES) AS STRING ' 2 bytes (divisor) per step
    DIM SHARED pcsmidiUsed AS LONG ' voices with notes in them
    DIM SHARED pcsmidiSteps AS LONG ' length in steps
    DIM SHARED pcsmidiPlaced AS LONG ' notes that got a voice
    DIM SHARED pcsmidiDropped AS LONG ' notes with no voice free (more than the voices at once)
    DIM SHARED pcsmidiCut AS LONG ' notes past the step limit

    ' tempo map (while loading)
    REDIM SHARED pcsmidiTempoTk(0 TO 0) AS _INTEGER64
    REDIM SHARED pcsmidiTempoUs(0 TO 0) AS LONG
    DIM SHARED pcsmidiTempoN AS LONG
$END IF
