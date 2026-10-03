''
' PCSPDEMO - PC speaker music and sound effects in a game loop (PCSPLAY)
'
' Music plays in the background while the "game" runs; keys fire sound
' effects over it, and the music keeps time underneath.
'
'   M        music on / off          1-9   play sound 1-9 of the bank
'   B / S / N  a beep / a sweep / noise (made on the spot)
'   P        multi-voice music: PWM (together) / ARP (taking turns)
'   + / -    volume                  Esc   quit
'
' Run it with a bank:  PCSPDEMO ASSETS/TUNES/JINGLES.SND
' (without one it uses ASSETS/TUNES/ODETOJOY.SND for the music)
'
OPTION _EXPLICIT

'$INCLUDE:'PCSPKR.BI'
'$INCLUDE:'PCSPLAY.BI'

DIM bank AS STRING, k AS STRING, i AS LONG, vol AS SINGLE, x AS SINGLE, music AS LONG

CHDIR _STARTDIR$
bank = COMMAND$(1)
IF bank = "" THEN bank = "ASSETS/TUNES/ODETOJOY.SND"
IF PCSP_LoadBank(bank) = 0 THEN PRINT "Can't load "; bank: END
i = PCSP_LoadBank("ASSETS/TUNES/JINGLES.SND") ' some effects too, if they're there

SCREEN _NEWIMAGE(640, 400, 32)
_TITLE "PCSPDEMO - PC speaker music + sound effects"
vol = 1
music = 0 ' the first sound of the bank given is the music
PCSP_Music PCSP_Name(music), PCSP_LOOP

DO
    k = INKEY$
    SELECT CASE UCASE$(k)
        CASE CHR$(27): EXIT DO
        CASE "M"
            IF PCSP_MusicPlaying THEN PCSP_StopMusic ELSE PCSP_Music PCSP_Name(music), PCSP_LOOP
        CASE "1" TO "9": PCSP_SfxNum VAL(k) - 1
        CASE "B": PCSP_Beep 880, 0.15
        CASE "S": PCSP_Sweep 1500, 150, 0.4
        CASE "N": PCSP_Noise 100, 900, 0.3
        CASE "P"
            IF pcspMode = PCSP_PWM THEN PCSP_SetMode PCSP_ARP ELSE PCSP_SetMode PCSP_PWM
        CASE "+", "=": vol = vol + 0.25: IF vol > 4 THEN vol = 4
        CASE "-": vol = vol - 0.25: IF vol < 0 THEN vol = 0
    END SELECT
    PCSP_Volume vol

    ' the "game": a ball bouncing around while the sound plays
    CLS
    x = x + 3: IF x > 600 THEN x = 0
    CIRCLE (20 + x, 300 + SIN(x / 30) * 60), 12, _RGB32(255, 200, 60)
    PRINT " PCSPDEMO - "; bank
    PRINT
    PRINT " M music  1-9 sounds  B beep  S sweep  N noise  P PWM/ARP  +/- volume  Esc"
    PRINT
    PRINT " music: "; PCSP_Name(music); "  "; MID$("off", 1, -3 * NOT PCSP_MusicPlaying); MID$("playing", 1, -7 * PCSP_MusicPlaying)
    PRINT " mode : "; MID$("ARPPWM", pcspMode * 3 + 1, 3); "   volume:"; vol
    PRINT
    FOR i = 0 TO PCSP_Count - 1
        IF i < 9 AND PCSP_Name(i) <> "*TEMP*" THEN PRINT USING " #  &"; i + 1; PCSP_Name(i)
    NEXT

    PCSP_Update ' every frame
    _DISPLAY
    _LIMIT 60
LOOP
PCSP_StopAll
SYSTEM

'$INCLUDE:'PCSPKR.BM'
'$INCLUDE:'PCSPLAY.BM'
