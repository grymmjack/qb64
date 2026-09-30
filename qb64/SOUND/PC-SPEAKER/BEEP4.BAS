''
' BEEP4.BAS - QB64PE port of BEEP4.C
'
' Load the Commander Keen 1 sound bank (SOUNDS.CK1), print its header and
' play the first 20 sounds through the emulated PC speaker, one sample every
' 7 ms - exactly what BEEP4.C does with play_sound(x) + delay(7).
'
' Pass a different bank on the command line to hear it instead, e.g.
'     BEEP4 ASSETS/duke1-b.dn1
'
' For a full interactive player (and correct 140 Hz playback) see DN1PLAY.BAS.
'
OPTION _EXPLICIT
'$INCLUDE:'PCSPKR.BI'

DIM fileName AS STRING, i AS LONG, n AS LONG, last AS LONG, quit AS INTEGER

_TITLE "BEEP4"
fileName = COMMAND$(1)
IF fileName = "" THEN fileName = "ASSETS/SOUNDS.CK1"
fileName = PCSPK_FindFile(fileName)

IF NOT PCSPK_IFSLoad(fileName) THEN
    PRINT "Can't open "; fileName
    END
END IF

PRINT "File is"; LEN(pcspk_ifs_data); "bytes long"
PRINT "Signature  : "; LEFT$(pcspk_ifs_data, 3)
PRINT "File size  :"; pcspk_ifs_filesize
PRINT "Num Sounds :"; PCSPK_IFSCount; " (BEEP4.C calls this word 'magic')"
PRINT "Unknown    : "; HEX$(pcspk_ifs_word8); " (BEEP4.C reads this as the count)"
PRINT
PRINT "ESC to quit"
PRINT

' delay(7) per sample = a 142.857 Hz sample clock
PCSPK_SetTickRate 1000 / 7

last = PCSPK_IFSCount - 1
IF last > 19 THEN last = 19
FOR i = 0 TO last
    PRINT USING "Playing sound ## from offset \  \  "; i; LCASE$(RIGHT$("000" + HEX$(PCSPK_IFSOffset(i)), 4));
    PRINT "name: "; PCSPK_IFSName(i); "  rate:"; PCSPK_IFSRate(i)

    FOR n = 0 TO PCSPK_IFSSamples(i) - 1
        PCSPK_SetDivisor PCSPK_IFSValue(i, n) '   play_sound(x)
        PCSPK_WaitTicks 1 '                       delay(7)
        IF _KEYHIT = 27 THEN quit = -1: EXIT FOR
    NEXT
    PCSPK_Off '                                   nosound()
    IF quit THEN EXIT FOR

    PCSPK_WaitSeconds 1 '                         delay(1000)
NEXT

PCSPK_Drain
PRINT
PRINT "Success"
END

'$INCLUDE:'PCSPKR.BM'
