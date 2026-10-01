''
' PCSPKR.BI - Native QB64PE IBM PC speaker emulator (header)
'
' A pure QB64PE port of the ideas in https://github.com/grymmjack/ncot-pc-speaker
' (Borland C / MS-DOS). No C, no DECLARE LIBRARY - everything is emulated in
' BASIC and pushed out through QB64PE's own audio engine.
'
' What is emulated:
'   - PIT (8253/8254) channel 2 in mode 3 (square wave) and mode 0 (one-shot)
'   - Port 61h speaker gate / data bits (on / off)
'   - PIT channel 0 / BIOS INT 1Ch style "timer ticks" driven by the AUDIO
'     clock, so tick handlers are sample-accurate and jitter free
'   - The speaker cone (DC blocking + optional low-pass)
'
' Extras:
'   - Inverse Frequency Sound (IFS) loader for Duke Nukem 1 (*.DN1, *.DN2,
'     *.DN3) and Commander Keen 1-3 (SOUNDS.CK?) sound banks
'   - DOOM engine PC speaker sounds (DP* lumps) straight out of a .WAD
'     (Doom, Doom II, Final Doom, Chex Quest, Freedoom, Strife) or a lone
'     .LMP, and Rise of the Triad's PCSP* lumps
'   - id Software AUDIOHED/AUDIOT pairs (Wolfenstein 3D, Spear of Destiny,
'     Blake Stone, Corridor 7, Bio Menace, ...) and Duke Nukem II's
'     NUKEM2.CMP
'   - IFS banks buried inside bigger files (Cosmo, Major Stryker) and
'     Crystal Caves' raw divisor lists
'   All of them load into the same bank, so the same calls play them.
'   - 8-bit mono PCM WAV loader (for the PWM playback demo)
'   - Offline render to a QB64PE sound handle (_SNDNEW) and to .WAV files
'
' Usage:
'   '$INCLUDE:'PCSPKR.BI'   <- top of program
'   ...
'   '$INCLUDE:'PCSPKR.BM'   <- bottom of program
'
' Requires QB64-PE 4.x (_SNDNEW, _MEMSOUND, _SNDOPENRAW, _SNDRAWBATCH).
'
$IF PCSPKR_BI = UNDEFINED THEN
    $LET PCSPKR_BI = TRUE

    ' PIT input clock (Hz): 14.31818 MHz / 12
    CONST PCSPK_PIT_HZ = 1193181.666666667#
    ' Default BIOS tick rate (Hz) - INT 08h / INT 1Ch with divisor 65536
    CONST PCSPK_BIOS_TICK_HZ = 18.20650656285#
    ' Commander Keen / Duke Nukem 1 PC speaker effects are driven at 140 Hz
    CONST PCSPK_IFS_DEFAULT_HZ = 140

    ' What kind of file the IFS bank came from (PCSPK_IFSKind)
    CONST PCSPK_KIND_NONE = 0
    CONST PCSPK_KIND_IFS = 1 ' Duke Nukem 1 / Commander Keen "SND" bank
    CONST PCSPK_KIND_WAD = 2 ' DOOM engine IWAD/PWAD, DP* lumps
    CONST PCSPK_KIND_LMP = 3 ' a single DOOM PC speaker lump
    CONST PCSPK_KIND_IDAUDIO = 4 ' id Software AUDIOHED + AUDIOT (or NUKEM2.CMP)
    CONST PCSPK_KIND_RAW = 5 ' raw $FFFF-terminated divisor lists (Crystal Caves)

    ' How one sound was stored before it was turned into divisors
    CONST PCSPK_FMT_IFS = 1 ' uint16 PIT divisors
    CONST PCSPK_FMT_DOOM = 2 ' uint8 index into the DMX tone table
    CONST PCSPK_FMT_ID = 3 ' uint8, divisor = value * 60
    CONST PCSPK_FMT_RAW = 4 ' uint16 PIT divisors, no header

    ' PIT counter modes we emulate on channel 2
    CONST PCSPK_MODE_ONESHOT = 0 ' mode 0: interrupt on terminal count
    CONST PCSPK_MODE_SQUARE = 3 ' mode 3: square wave generator

    ' Where rendered samples go
    CONST PCSPK_SINK_NONE = 0
    CONST PCSPK_SINK_STREAM = 1
    CONST PCSPK_SINK_CAPTURE = 2

    CONST PCSPK_STREAM_CHUNK = 256 ' frames pushed per _SNDRAWBATCH

    TYPE PCSPK_STATE
        initialized AS _BYTE
        rate AS LONG ' output sample rate (Hz)
        clkPerSample AS DOUBLE ' PIT clocks per output sample
        ' --- emulated hardware ---
        enabled AS _BYTE ' port 61h bits 0+1 (timer 2 gate + speaker data)
        mode AS INTEGER ' PIT channel 2 mode (0 or 3)
        divisor AS DOUBLE ' mode 3 reload value (clocks per cycle)
        phase AS DOUBLE ' mode 3 phase in cycles [0, 1)
        osRemain AS DOUBLE ' mode 0 clocks left in the LOW state
        ' --- resampler ---
        sampPos AS DOUBLE ' clocks accumulated into current output sample
        sampAcc AS DOUBLE ' integral of speaker level over those clocks
        ' --- speaker cone ---
        dcX AS SINGLE
        dcY AS SINGLE
        dcR AS SINGLE
        lpHz AS SINGLE
        lpA AS SINGLE
        lp1 AS SINGLE
        lp2 AS SINGLE
        volume AS SINGLE
        ' --- output ---
        sink AS INTEGER
        stream AS LONG ' _SNDOPENRAW handle
        bufN AS LONG ' frames waiting in pcspk_sbuf()
        lead AS DOUBLE ' seconds of audio to keep queued ahead
        tickHz AS DOUBLE ' emulated timer interrupt rate
        tickClk AS DOUBLE ' PIT clocks per emulated timer tick
        rendered AS DOUBLE ' seconds rendered to the stream (fallback pacing)
        wallStart AS DOUBLE ' TIMER when stream opened (fallback pacing)
        capN AS LONG ' frames in pcspk_cap()
    END TYPE

    ' IFS (Inverse Frequency Sound) sound bank entry
    TYPE PCSPK_IFS_ENTRY
        offset AS LONG ' byte offset of the sound in the file (WAD: lump position)
        dataPos AS LONG ' 0-based position of its divisors in pcspk_ifs_data
        priority AS INTEGER
        rate AS INTEGER ' 4th byte in the entry (always 8 in known files)
        nam AS STRING * 12
        samples AS LONG ' number of 16-bit samples before the $FFFF end marker
        fmt AS INTEGER ' PCSPK_FMT_*
    END TYPE

    DIM SHARED pcspk AS PCSPK_STATE
    DIM SHARED pcspk_saved AS PCSPK_STATE ' voice/sink saved during a capture
    DIM SHARED pcspk_sbuf(0 TO PCSPK_STREAM_CHUNK - 1) AS SINGLE
    ' The last PCSPK_SCOPE_N samples sent to the speaker stream, for drawing
    ' an oscilloscope (PCSPK_ScopeSample). pcspk_scopePos is the next slot.
    CONST PCSPK_SCOPE_N = 8192
    DIM SHARED pcspk_scope(0 TO PCSPK_SCOPE_N - 1) AS SINGLE
    DIM SHARED pcspk_scopePos AS LONG
    REDIM SHARED pcspk_cap(0 TO 0) AS SINGLE

    ' IFS bank
    DIM SHARED pcspk_ifs_data AS STRING
    DIM SHARED pcspk_ifs_count AS LONG
    DIM SHARED pcspk_ifs_filesize AS LONG
    DIM SHARED pcspk_ifs_word8 AS LONG ' header word at offset 8 (unknown)
    DIM SHARED pcspk_ifs_kind AS INTEGER ' PCSPK_KIND_*
    DIM SHARED pcspk_doom_div(0 TO 255) AS LONG ' DOOM tone -> PIT divisor
    REDIM SHARED pcspk_ifs(0 TO 0) AS PCSPK_IFS_ENTRY

    ' 8-bit mono PCM WAV
    DIM SHARED pcspk_wav_data AS STRING
    DIM SHARED pcspk_wav_rate AS LONG
    DIM SHARED pcspk_wav_error AS STRING
$END IF
