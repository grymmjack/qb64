''
' WAV.BAS - QB64PE port of WAV.C + WAVLOAD.C + LOADFILE.C
'
' Plays an 8-bit mono WAV through the 1-bit PC speaker using pulse width
' modulation: PIT channel 0 is sped up to the WAV's sample rate and on every
' tick PIT channel 2 fires a MODE 0 one-shot pulse whose width follows the
' sample value. The speaker cone can't keep up with the pulses, so it ends up
' averaging them into (crunchy, whiny, glorious) audio.
'
' The RIFF/WAV parsing is done natively in PCSPK_WavLoad (no _SNDOPEN), just
' like WAVLOAD.C.
'
' Keys:  1 2 3  scene17.wav / scene20.wav / xp8.wav
'        M      WAV.C pulse widths (0-60 clocks) / full range PWM (louder)
'        F      speaker low-pass on/off
'        C      compare: play the same WAV natively with _SNDOPEN
'        Q      quit
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'

CONST PIT_FREQ = 1193181

DIM SHARED sample_index AS LONG
DIM SHARED wave_length AS LONG
DIM SHARED divisor AS LONG
DIM SHARED fullRange AS INTEGER

DIM fileName AS STRING, k AS STRING, lowPass AS INTEGER
DIM native AS LONG, nativeMode AS INTEGER

_TITLE "WAV"
fileName = COMMAND$(1)
IF fileName = "" THEN fileName = "ASSETS/scene17.wav"
load_wav fileName

PRINT "Playing noise, press q to stop!"
PRINT "1/2/3 = file, M = pulse range, F = low-pass, C = compare with _SNDOPEN"
PRINT

DO
    IF NOT nativeMode THEN
        DO WHILE PCSPK_Tick '       the sample rate timer interrupt
            new_timer
        LOOP
    END IF

    k = LCASE$(INKEY$)
    SELECT CASE k
        CASE "q"
            EXIT DO
        CASE "1", "2", "3"
            IF native THEN _SNDCLOSE native: native = 0
            nativeMode = 0
            IF k = "1" THEN fileName = "ASSETS/scene17.wav"
            IF k = "2" THEN fileName = "ASSETS/scene20.wav"
            IF k = "3" THEN fileName = "ASSETS/xp8.wav"
            CLS
            load_wav fileName
            PRINT "Playing noise, press q to stop!"
            PRINT "1/2/3 = file, M = pulse range, F = low-pass, C = compare with _SNDOPEN"
            PRINT
        CASE "m"
            fullRange = NOT fullRange
        CASE "f"
            lowPass = NOT lowPass
            IF lowPass THEN PCSPK_SetLowPass 4000 ELSE PCSPK_SetLowPass 0
        CASE "c"
            nativeMode = NOT nativeMode
            IF nativeMode THEN
                native = _SNDOPEN(PCSPK_FindFile(fileName))
                IF native THEN _SNDLOOP native
            ELSE
                IF native THEN _SNDCLOSE native: native = 0
            END IF
    END SELECT

    LOCATE CSRLIN, 1
    IF nativeMode THEN
        PRINT "[_SNDOPEN native playback]                            ";
    ELSE
        PRINT USING " Sample ########  "; sample_index;
        IF fullRange THEN PRINT "[full range PWM]  "; ELSE PRINT "[WAV.C 0-60 clk]  ";
        IF lowPass THEN PRINT "[low-pass]  "; ELSE PRINT "            ";
    END IF
    _LIMIT 60
LOOP

IF native THEN _SNDCLOSE native
stop_sound
PCSPK_Drain
PRINT
PRINT "Done"
END


SUB load_wav (fileName AS STRING)
    PRINT "Load wav "; fileName
    IF NOT PCSPK_WavLoad(PCSPK_FindFile(fileName)) THEN
        PRINT PCSPK_WavError
        END
    END IF
    wave_length = PCSPK_WavLength
    sample_index = 0
    PRINT "Loaded"; wave_length; "samples"
    PRINT "Sample rate is"; PCSPK_WavRate

    ' reprogram PIT channel 0 to the sample rate
    divisor = PIT_FREQ \ PCSPK_WavRate
    PCSPK_SetTickDivisor divisor
    ' outport(0x61, inport(0x61) | 3)
    PCSPK_SpeakerOn
END SUB


''
' The timer interrupt handler (void interrupt new_timer() in WAV.C).
'
SUB new_timer
    DIM sample AS LONG, microseconds AS LONG

    sample = PCSPK_WavSample(sample_index)
    IF fullRange THEN
        microseconds = 1 + (sample * (divisor - 2)) \ 255
    ELSE
        microseconds = (sample * 60) \ 255
    END IF

    ' outport(PIT_CONTROL, 0xB0); outport(PIT_TIMER2, lo); outport(PIT_TIMER2, hi);
    PCSPK_PitWrite PCSPK_MODE_ONESHOT, microseconds

    sample_index = (sample_index + 1) MOD wave_length
END SUB


SUB stop_sound
    PCSPK_SpeakerOff
END SUB

'$INCLUDE:'PCSPKR.BM'
