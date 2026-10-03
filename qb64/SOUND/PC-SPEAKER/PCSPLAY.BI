''
' PCSPLAY.BI - PC speaker music and sound effects for QB64-PE games (header)
'
' A game-side player for IFS sound banks (the .SND files PCSEDIT saves), on
' top of the PCSPKR emulator. Music loops in the background; sound effects
' take the speaker over it the way Commander Keen and Duke Nukem did (a new
' effect only cuts in if its priority is at least the playing one's), and
' the music keeps time underneath. Sounds with several voices (PCSEDIT's
' NAME~1 ... NAME~4) play together with PWM, or as the ARP mix.
'
'   '$INCLUDE:'PCSPKR.BI'
'   '$INCLUDE:'PCSPLAY.BI'
'
'   IF PCSP_LoadBank("MYGAME.SND") = 0 THEN PRINT "no sounds"
'   PCSP_Music "THEME", PCSP_LOOP
'   DO
'       ...
'       IF jumped THEN PCSP_Sfx "JUMP"
'       IF hit THEN PCSP_Sweep 1200, 200, 0.25
'       PCSP_Update ' every frame: keeps the speaker fed
'       _LIMIT 60
'   LOOP
'
'   '$INCLUDE:'PCSPKR.BM'
'   '$INCLUDE:'PCSPLAY.BM'
'
$IF PCSPLAY_BI = UNDEFINED THEN
    $LET PCSPLAY_BI = TRUE

    CONST PCSP_ARP = 0 '  several voices: take turns, step by step (as saved for games)
    CONST PCSP_PWM = 1 '  several voices: really at once (pulse-width modulation)
    CONST PCSP_ONCE = 0 ' PCSP_Music: play it once
    CONST PCSP_LOOP = -1 '                 or over and over
    CONST PCSP_RATE = 140 ' steps a second (IFS)

    REDIM SHARED pcspName(0 TO 0) AS STRING
    REDIM SHARED pcspPri(0 TO 0) AS INTEGER
    REDIM SHARED pcspData(0 TO 0) AS STRING ' the sound (the ARP mix for a multi-voice one): 2 bytes / step
    REDIM SHARED pcspVoice(0 TO 0) AS STRING ' its voices: sound * 4 + 0 ... 3
    REDIM SHARED pcspNV(0 TO 0) AS INTEGER ' how many voices it has (1 = just pcspData)
    DIM SHARED pcspCount AS LONG

    DIM SHARED pcspSfx AS LONG ' the effect playing (-1 = none), and where
    DIM SHARED pcspSfxPos AS LONG
    DIM SHARED pcspMus AS LONG ' the music playing (-1 = none), where, looping?
    DIM SHARED pcspMusPos AS LONG
    DIM SHARED pcspMusLoop AS INTEGER
    DIM SHARED pcspMode AS INTEGER ' PCSP_PWM / PCSP_ARP
    DIM SHARED pcspReady AS INTEGER
    DIM SHARED pcspLastDiv AS LONG
    DIM SHARED pcspPh(1 TO 4) AS DOUBLE ' PWM: each voice's place in its square wave
    DIM SHARED pcspTemp AS LONG ' the slot PCSP_Beep / Sweep / Noise use
$END IF
