''
' BEEP.BAS - QB64PE port of BEEP.C
'
' The simplest possible PC speaker program: program PIT channel 2 for 440 Hz,
' connect it to the speaker, wait 5 BIOS timer ticks, disconnect it.
'
' C                         QB64PE (PCSPKR.BM)
' ------------------------  -------------------------
' play_sound(440)           PCSPK_SetFreq 440
' timer_wait(5)             PCSPK_WaitTicks 5
' no_sound()                PCSPK_Off
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'

_TITLE "BEEP"
PRINT "BEEP.C -> QB64PE"
PRINT
PRINT "play_sound(440) for 5 timer ticks (5 / 18.2 ="; 5 / PCSPK_BIOS_TICK_HZ; "sec)"

PCSPK_SetFreq 440 '  play_sound(440)
PCSPK_WaitTicks 5 '  timer_wait(5)
PCSPK_Off '          no_sound()
PCSPK_Drain '        let the audio device finish before we quit

PRINT "Done."
END

'$INCLUDE:'PCSPKR.BM'
