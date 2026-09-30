''
' PWM.BAS - QB64PE port of PWM.C
'
' Speeds the timer interrupt up to 8000 Hz and, on every tick, reprograms
' PIT channel 2 from a 64 entry sine table - an attempt at PWM audio on a
' 1-bit speaker.
'
' PWM.C writes the sample to channel 2 in MODE 3 (square wave) as a divisor,
' so what you actually get is a fast warbling tone ("Playing noise" indeed!).
' That is emulated faithfully here. Press M to switch to what it was going
' for: MODE 0 one-shot pulses whose WIDTH follows the sine wave - real PWM,
' which the speaker cone smooths into an actual sine tone.
'
' Keys:  A / D  frequency down / up      M  toggle PWM.C / true PWM
'        F      speaker low-pass on/off  Q  quit
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'

CONST SAMPLE_RATE = 8000
CONST PIT_FREQ = 1193181
CONST SIN_SIZE = 64

DIM SHARED sample_index AS SINGLE
DIM SHARED sine_wave(0 TO SIN_SIZE - 1) AS _UNSIGNED _BYTE
DIM SHARED step_size AS SINGLE
DIM SHARED truePWM AS INTEGER
DIM SHARED divisor AS LONG

DIM frequency AS SINGLE, k AS STRING, lowPass AS INTEGER

_TITLE "PWM"
step_size = 1
frequency = 440

generate_sine_wave
PRINT
PRINT

' outport(0x43, 0x36); outport(0x40, lo); outport(0x40, hi);
divisor = PIT_FREQ \ SAMPLE_RATE
PCSPK_SetTickDivisor divisor
' outport(0x61, inport(0x61) | 3);
PCSPK_SpeakerOn

PRINT "Playing noise, press q to stop!"
PRINT "A/D = frequency, M = PWM.C / true PWM, F = speaker low-pass"
set_frequency frequency

DO
    DO WHILE PCSPK_Tick '           the 8 kHz timer interrupt
        new_timer
    LOOP

    k = LCASE$(INKEY$)
    SELECT CASE k
        CASE "q"
            EXIT DO
        CASE "a"
            frequency = frequency - 1
            IF frequency < 100 THEN frequency = 100
            set_frequency frequency
        CASE "d"
            frequency = frequency + 1
            set_frequency frequency
        CASE "m"
            truePWM = NOT truePWM
        CASE "f"
            lowPass = NOT lowPass
            IF lowPass THEN PCSPK_SetLowPass 3500 ELSE PCSPK_SetLowPass 0
    END SELECT

    LOCATE CSRLIN, 1
    PRINT USING "Frequency: ####.##   "; frequency;
    IF truePWM THEN PRINT "[true PWM]  "; ELSE PRINT "[PWM.C]     ";
    IF lowPass THEN PRINT "[low-pass]  "; ELSE PRINT "            ";
    _LIMIT 60
LOOP

stop_sound
PCSPK_Drain
PRINT
PRINT "Done"
END


SUB set_frequency (freq AS SINGLE)
    step_size = (freq * SIN_SIZE) / SAMPLE_RATE
END SUB


SUB generate_sine_wave
    DIM i AS LONG, angle AS DOUBLE
    FOR i = 0 TO SIN_SIZE - 1
        angle = (2.0 * 3.141 * i) / SIN_SIZE
        sine_wave(i) = INT((SIN(angle) + 1.0) * 127.5)
        PRINT sine_wave(i);
    NEXT
END SUB


''
' The timer interrupt handler (void interrupt new_timer() in PWM.C).
'
SUB new_timer
    DIM sample AS LONG, pwm_val AS LONG

    sample = sine_wave(INT(sample_index))

    IF truePWM THEN
        ' one-shot: speaker LOW for a time proportional to the sample
        PCSPK_PitWrite PCSPK_MODE_ONESHOT, 1 + (sample * (divisor - 2)) \ 255
    ELSE
        ' PWM.C: the sample becomes a square wave divisor
        pwm_val = (sample * PIT_FREQ) \ 256 \ 1000
        PCSPK_PitWrite PCSPK_MODE_SQUARE, pwm_val '   outport(PIT_CONTROL, 0xB6) ...
    END IF

    sample_index = sample_index + step_size
    IF sample_index >= SIN_SIZE THEN sample_index = sample_index - SIN_SIZE
END SUB


SUB stop_sound
    PCSPK_SpeakerOff '                    outport(SPEAKER_CTRL, inport(SPEAKER_CTRL) & ~3)
END SUB

'$INCLUDE:'PCSPKR.BM'
