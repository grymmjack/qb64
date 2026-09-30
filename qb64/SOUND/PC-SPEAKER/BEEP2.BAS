''
' BEEP2.BAS - QB64PE port of BEEP2.C
'
' Turn on a 440 Hz tone, then let a timer "interrupt handler" count down
' 18 ticks (about a second) while the main loop prints the counter.
'
' The C version hooks INT 1Ch. Here the timer interrupt is emulated by
' PCSPK_Tick, which is clocked by the audio stream itself, so the handler
' runs exactly once per 1/18.2 sec of sound - no jitter, no drift:
'
'     DO WHILE PCSPK_Tick     ' one INT 1Ch worth of audio was rendered
'         get_out             ' ...so run the handler
'     LOOP
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'

DIM SHARED looping AS INTEGER
DIM SHARED tickCounter AS INTEGER
DIM freq AS LONG

_TITLE "BEEP2"
looping = -1
freq = 440

PRINT "Press any key to stop"

tickCounter = 18

PCSPK_SetFreq freq '                play_sound_freq(freq)

DO WHILE looping
    DO WHILE looping '              the emulated INT 1Ch
        IF NOT PCSPK_Tick THEN EXIT DO
        get_out
    LOOP

    PRINT "Counter ="; tickCounter
    IF LEN(INKEY$) THEN looping = 0
    _LIMIT 30
LOOP

PCSPK_Off '                         nosound()
PCSPK_Drain
PRINT "Success"
END


SUB get_out
    IF tickCounter > 0 THEN
        tickCounter = tickCounter - 1
        IF tickCounter = 0 THEN
            looping = 0
        END IF
    END IF
END SUB

'$INCLUDE:'PCSPKR.BM'
