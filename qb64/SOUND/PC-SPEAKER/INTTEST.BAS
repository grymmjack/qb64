''
' INTTEST.BAS - QB64PE port of INTTEST.C
'
' INTTEST.C hooks INT 1Ch (the BIOS user timer tick, 18.2 times a second)
' with getvect/setvect, counts down 18 ticks inside the interrupt handler
' and stops the main loop when the count hits zero.
'
' QB64PE's native equivalent of hooking a timer interrupt is ON TIMER:
'
' C                                    QB64PE
' -----------------------------------  ---------------------------------------
' oldfunc = getvect(0x1C);             t = _FREETIMER
' setvect(0x1C, get_out);              ON TIMER(t, 1 / 18.2065) get_out
'                                      TIMER(t) ON
' setvect(0x1C, oldfunc);              TIMER(t) FREE
' void interrupt get_out(...)          SUB get_out
' (*oldfunc)();                        (nothing to chain to)
'
' No sound in this one - see BEEP2.BAS for the same thing with a tone.
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'

DIM SHARED looping AS INTEGER
DIM SHARED tickCounter AS INTEGER
DIM t AS LONG, t0 AS DOUBLE

_TITLE "INTTEST"
looping = -1

t = _FREETIMER
ON TIMER(t, 1 / PCSPK_BIOS_TICK_HZ) get_out '  setvect(0x1C, get_out)

tickCounter = 18
t0 = TIMER(0.001)
TIMER(t) ON

DO WHILE looping
    _LIMIT 1000
LOOP

TIMER(t) FREE '                                  setvect(0x1C, oldfunc)
PRINT "Success"
PRINT USING "18 ticks took #.### seconds"; TIMER(0.001) - t0
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
