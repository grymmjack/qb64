''
' SFXR.BI - sfxr sound effect synth for QB64-PE, with PC speaker output
'
' A port of jsfxr (https://github.com/chr15m/jsfxr, public domain), which is
' itself a port of DrPetter's sfxr. The synth is ported line for line, and
' three ways to hear it are added:
'
'   SFXR_MODE_BEEPER  sfxr's pitch engine sampled at a tick rate (140 Hz like
'                     Keen / Duke Nukem) and played as PIT divisors on the
'                     emulated PC speaker - an authentic DOS game sound effect
'   SFXR_MODE_PWM     the full sfxr waveform played through the 1-bit speaker
'                     with pulse width modulation (RealSound / demo scene)
'   SFXR_MODE_CLEAN   plain sfxr output, for comparison
'
' Needs the PC speaker emulator, so include in this order:
'   '$INCLUDE:'../PC-SPEAKER/PCSPKR.BI'
'   '$INCLUDE:'SFXR.BI'
'   ...
'   '$INCLUDE:'../PC-SPEAKER/PCSPKR.BM'
'   '$INCLUDE:'SFXR.BM'
'
$IF SFXR_BI = UNDEFINED THEN
    $LET SFXR_BI = TRUE

    CONST SFXR_SQUARE = 0
    CONST SFXR_SAWTOOTH = 1
    CONST SFXR_SINE = 2
    CONST SFXR_NOISE = 3

    CONST SFXR_MODE_BEEPER = 0
    CONST SFXR_MODE_PWM = 1
    CONST SFXR_MODE_CLEAN = 2

    CONST SFXR_NPARAMS = 22 ' sfxr_p(1 TO 22); sfxr_p(0) is the wave type
    CONST SFXR_OVERSAMPLING = 8
    CONST SFXR_RATE = 44100
    CONST SFXR_MAX_SECONDS = 12

    ' parameter indexes, in sfxr.me's params_order
    CONST SP_ATTACK = 1
    CONST SP_SUSTAIN = 2
    CONST SP_PUNCH = 3
    CONST SP_DECAY = 4
    CONST SP_BASE_FREQ = 5
    CONST SP_FREQ_LIMIT = 6
    CONST SP_FREQ_RAMP = 7
    CONST SP_FREQ_DRAMP = 8
    CONST SP_VIB_STRENGTH = 9
    CONST SP_VIB_SPEED = 10
    CONST SP_ARP_MOD = 11
    CONST SP_ARP_SPEED = 12
    CONST SP_DUTY = 13
    CONST SP_DUTY_RAMP = 14
    CONST SP_REPEAT_SPEED = 15
    CONST SP_PHA_OFFSET = 16
    CONST SP_PHA_RAMP = 17
    CONST SP_LPF_FREQ = 18
    CONST SP_LPF_RAMP = 19
    CONST SP_LPF_RESONANCE = 20
    CONST SP_HPF_FREQ = 21
    CONST SP_HPF_RAMP = 22

    ' synth state (jsfxr's SoundEffect object)
    TYPE SFXR_VOICE
        period AS DOUBLE
        periodMax AS DOUBLE
        enableFrequencyCutoff AS _BYTE
        periodMult AS DOUBLE
        periodMultSlide AS DOUBLE
        dutyCycle AS DOUBLE
        dutyCycleSlide AS DOUBLE
        arpeggioMultiplier AS DOUBLE
        arpeggioTime AS LONG
        elapsedSinceRepeat AS LONG
        waveShape AS INTEGER
        fltw AS DOUBLE
        enableLowPassFilter AS _BYTE
        fltw_d AS DOUBLE
        fltdmp AS DOUBLE
        flthp AS DOUBLE
        flthp_d AS DOUBLE
        vibratoSpeed AS DOUBLE
        vibratoAmplitude AS DOUBLE
        envLen0 AS LONG
        envLen1 AS LONG
        envLen2 AS LONG
        envelopePunch AS DOUBLE
        flangerOffset AS DOUBLE
        flangerOffsetSlide AS DOUBLE
        repeatTime AS LONG
        gain AS DOUBLE
    END TYPE

    DIM SHARED sfxr_p(0 TO SFXR_NPARAMS) AS DOUBLE ' the sound's parameters
    DIM SHARED sfxr_vol AS DOUBLE ' sound_vol (gain), 0..1
    DIM SHARED sfxr_key(0 TO SFXR_NPARAMS) AS STRING ' jsfxr JSON names
    DIM SHARED sfxr_label(0 TO SFXR_NPARAMS) AS STRING
    DIM SHARED sfxr_signed(0 TO SFXR_NPARAMS) AS _BYTE
    DIM SHARED sfxr_v AS SFXR_VOICE
    DIM SHARED sfxr_inited AS _BYTE

    ' PC speaker settings
    DIM SHARED sfxr_mode AS INTEGER ' SFXR_MODE_*
    DIM SHARED sfxr_tickHz AS DOUBLE ' beeper tick rate
    DIM SHARED sfxr_gate AS DOUBLE ' beeper: envelope below this = silence
    DIM SHARED sfxr_pwmHz AS LONG ' PWM carrier rate

    ' last render
    REDIM SHARED sfxr_pcm(0 TO 0) AS SINGLE ' clean sfxr output at 44100 Hz
    DIM SHARED sfxr_pcmN AS LONG
    DIM SHARED sfxr_clipped AS LONG
    REDIM SHARED sfxr_div(0 TO 0) AS LONG ' beeper: one PIT divisor per tick
    DIM SHARED sfxr_divN AS LONG
    DIM SHARED sfxr_outMode AS INTEGER ' mode of the last SFXR_Render
$END IF
