''
' BEEP3.BAS - QB64PE port of BEEP3.C + MELODY.C
'
' An interrupt driven music sequencer. Every BIOS timer tick (18.2 Hz) the
' handler counts down the current note and, when it runs out, reprograms the
' PIT for the next one - the main program just waits.
'
'   1 = MELODY.C (330 note events, divisor + length in beats)
'   2 = the notes[] / lengths[] tune that is commented out in BEEP3.C
'
' The C version hooks INT 1Ch; here PCSPK_Tick is the timer interrupt, paced
' by the audio stream so every note lands on the exact sample.
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'
'$INCLUDE:'NOTES.BI'

CONST BEAT_TICKS = 6

TYPE NoteEvent
    divisor AS LONG
    beats AS SINGLE
END TYPE

DIM SHARED melody(0 TO 329) AS NoteEvent
DIM SHARED melody_length AS LONG
DIM SHARED current_note AS LONG
DIM SHARED beat_timer AS LONG
DIM SHARED playing AS INTEGER
DIM i AS LONG, k AS STRING, choice AS STRING

_TITLE "BEEP3"
PRINT "BEEP3.C -> QB64PE"
PRINT
PRINT "  1) MELODY.C  (330 note events)"
PRINT "  2) notes[] / lengths[] from BEEP3.C"
PRINT
PRINT "Choose 1 or 2 (ESC quits): ";
DO
    choice = INKEY$
    IF choice = CHR$(27) THEN SYSTEM
    _LIMIT 30
LOOP UNTIL choice = "1" OR choice = "2"
PRINT choice
PRINT

IF choice = "1" THEN
    RESTORE melody_data
    melody_length = 330
    FOR i = 0 TO melody_length - 1
        READ melody(i).divisor, melody(i).beats
    NEXT
ELSE
    ' BEEP3.C: notes[] = {E5, B4, C5, D5, ...}, lengths[] = {2, 1, 1, 2, ...}
    melody_length = 0
    add_note NOTE_E5, 2: add_note NOTE_B4, 1: add_note NOTE_C5, 1: add_note NOTE_D5, 2
    add_note NOTE_C5, 1: add_note NOTE_B4, 1: add_note NOTE_A4, 2: add_note NOTE_A4, 1
    add_note NOTE_C5, 1: add_note NOTE_E5, 2: add_note NOTE_D5, 1: add_note NOTE_C5, 1
    add_note NOTE_B4, 2: add_note NOTE_B4, 1: add_note NOTE_C5, 1: add_note NOTE_D5, 2
    add_note NOTE_E5, 2: add_note NOTE_C5, 2: add_note NOTE_A4, 2: add_note NOTE_A4, 2
    add_note NOTE_REST, 2
END IF

start_sequence

DO WHILE playing
    DO WHILE playing '              the emulated INT 1Ch
        IF NOT PCSPK_Tick THEN EXIT DO
        get_out
    LOOP

    LOCATE 8, 1
    PRINT USING "Note ### of ###   divisor #####   beats #.##   "; current_note + 1; melody_length; melody(current_note).divisor; melody(current_note).beats
    k = INKEY$
    IF k = CHR$(27) THEN stop_sequence
    _LIMIT 60
LOOP

PCSPK_Off
PCSPK_Drain
PRINT
PRINT "Success"
END


SUB add_note (divisor AS LONG, beats AS SINGLE)
    melody(melody_length).divisor = divisor
    melody(melody_length).beats = beats
    melody_length = melody_length + 1
END SUB


SUB start_sequence
    current_note = 0
    beat_timer = INT(melody(0).beats * BEAT_TICKS)
    PCSPK_SetDivisor melody(0).divisor '           play_sound(melody[0].divisor)
    playing = -1
END SUB


SUB stop_sequence
    PCSPK_Off
    playing = 0
END SUB


''
' The timer interrupt handler (void interrupt get_out() in BEEP3.C).
'
SUB get_out
    IF playing THEN
        beat_timer = beat_timer - 1
        IF beat_timer <= 0 THEN
            current_note = current_note + 1
            IF current_note >= melody_length THEN
                current_note = melody_length - 1
                PCSPK_Off
                playing = 0
            ELSE
                PCSPK_SetDivisor melody(current_note).divisor
                beat_timer = INT(melody(current_note).beats * BEAT_TICKS)
            END IF
        END IF
    END IF
END SUB


' MELODY.C - { divisor, beats } (divisor 0 = rest)
melody_data:
DATA 0,0.12, 14479,0.12, 14479,0.50, 7239,0.50, 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12
DATA 14479,0.50, 9121,0.50, 14479,0.12, 14479,0.50, 10238,0.50, 14479,0.25, 14479,1.00, 9663,0.50
DATA 9121,0.50, 14479,0.12, 14479,0.50, 7239,0.50, 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12
DATA 14479,0.50, 9121,0.50, 14479,0.25, 14479,2.00, 10238,2.00, 14479,0.12, 14479,0.50, 7239,0.50
DATA 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12, 14479,0.50, 9121,0.50, 14479,0.12, 14479,0.50
DATA 10238,0.50, 14479,0.25, 14479,1.00, 9663,0.50, 9121,0.50, 14479,0.12, 14479,0.50, 7239,0.50
DATA 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12, 14479,0.50, 3224,0.25, 3619,0.25, 3835,0.25
DATA 3224,0.25, 2711,0.25, 3043,0.25, 3224,0.25, 3835,0.25, 3224,0.25, 3043,0.25, 2711,0.25
DATA 2415,0.25, 2711,0.25, 3043,0.25, 3224,0.25, 3835,0.25, 14479,0.12, 14479,0.50, 7239,0.50
DATA 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12, 14479,0.50, 9121,0.50, 14479,0.12, 14479,0.50
DATA 10238,0.50, 14479,0.25, 14479,1.00, 9663,0.50, 9121,0.50, 14479,0.12, 14479,0.50, 7239,0.50
DATA 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12, 14479,0.50, 9121,0.50, 14479,0.25, 14479,2.00
DATA 10238,2.00, 14479,0.12, 14479,0.50, 7239,0.50, 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12
DATA 14479,0.50, 9121,0.50, 14479,0.12, 14479,0.50, 10238,0.50, 14479,0.25, 14479,1.00, 9663,0.50
DATA 9121,0.50, 14479,0.12, 14479,0.50, 7239,0.50, 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12
DATA 14479,0.50, 3043,0.25, 3619,0.25, 4831,0.25, 3619,0.25, 3043,0.25, 3619,0.25, 3043,0.25
DATA 2415,0.25, 3043,0.25, 3619,0.25, 3043,0.25, 3619,0.25, 3043,0.25, 2415,0.25, 1809,0.25
DATA 1521,0.25, 10847,0.12, 10847,0.50, 5423,0.50, 10847,0.12, 10847,0.50, 6087,0.50, 10847,0.12
DATA 10847,0.50, 6833,0.50, 10847,0.12, 10847,0.50, 7670,0.50, 10847,0.25, 10847,1.00, 7239,0.50
DATA 6833,0.50, 10847,0.12, 10847,0.50, 5423,0.50, 10847,0.12, 10847,0.50, 6087,0.50, 10847,0.12
DATA 10847,0.50, 6833,0.50, 10847,0.25, 10847,2.00, 7670,2.00, 10847,0.12, 10847,0.50, 5423,0.50
DATA 10847,0.12, 10847,0.50, 6087,0.50, 10847,0.12, 10847,0.50, 6833,0.50, 10847,0.12, 10847,0.50
DATA 7670,0.50, 10847,0.25, 10847,1.00, 7239,0.50, 6833,0.50, 10847,0.12, 10847,0.50, 5423,0.50
DATA 10847,0.12, 10847,0.50, 6087,0.50, 10847,0.12, 10847,0.50, 2711,0.25, 3416,0.25, 3619,0.25
DATA 2711,0.25, 3619,0.25, 4560,0.25, 3619,0.25, 2711,0.25, 2280,0.25, 2711,0.25, 3619,0.25
DATA 2711,0.25, 3619,0.25, 2711,0.25, 3619,0.25, 4560,0.25, 14479,0.12, 14479,0.50, 7239,0.50
DATA 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12, 14479,0.50, 9121,0.50, 14479,0.12, 14479,0.50
DATA 10238,0.50, 14479,0.25, 14479,1.00, 9663,0.50, 9121,0.50, 14479,0.12, 14479,0.50, 7239,0.50
DATA 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12, 14479,0.50, 9121,0.50, 14479,0.25, 14479,2.00
DATA 10238,2.00, 14479,0.12, 14479,0.50, 7239,0.50, 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12
DATA 14479,0.50, 9121,0.50, 14479,0.12, 14479,0.50, 10238,0.50, 14479,0.25, 14479,1.00, 9663,0.50
DATA 9121,0.50, 14479,0.12, 14479,0.50, 7239,0.50, 14479,0.12, 14479,0.50, 8126,0.50, 14479,0.12
DATA 14479,0.50, 9121,0.50, 14479,0.25, 14479,2.00, 10238,2.00, 8609,0.12, 10847,0.12, 8609,0.50
DATA 4304,0.50, 8609,0.12, 8609,0.50, 4831,0.50, 8609,0.12, 8609,0.50, 5423,0.50, 8609,0.12
DATA 8609,0.50, 6087,0.50, 8609,0.25, 8609,1.00, 5746,0.50, 5423,0.50, 9663,0.12, 9663,0.50
DATA 4831,0.50, 9663,0.12, 9663,0.50, 5423,0.50, 9663,0.12, 9663,0.50, 6087,0.50, 10238,0.25
DATA 10847,2.00, 6833,2.00, 14479,0.12, 14479,0.50, 7239,0.50, 14479,0.12, 14479,0.50, 8126,0.50
DATA 14479,0.12, 14479,0.50, 9121,0.50, 14479,0.12, 14479,0.50, 10238,0.50, 14479,0.25, 14479,1.00
DATA 9663,0.50, 9121,0.50, 14479,0.12, 14479,0.50, 7239,0.50, 14479,0.12, 14479,0.50, 8126,0.50
DATA 14479,0.12, 14479,0.50, 2415,0.25, 2711,0.25, 3224,0.25, 3835,0.25, 4831,0.25, 5423,0.25
DATA 6449,0.25, 7670,0.25, 1917,0.25, 2152,0.25, 2415,0.25, 2711,0.25, 3224,0.25, 3835,0.25
DATA 4831,0.25, 5423,0.25

'$INCLUDE:'PCSPKR.BM'
