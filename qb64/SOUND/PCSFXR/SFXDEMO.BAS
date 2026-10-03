''
' SFXDEMO.BAS - using the PCSFXR engine (SFXR.BI/.BM) in your own program
'
' Shows the two ways a game would use it:
'   1. roll brand new sound effects at run time with SFXR_Preset
'   2. paste a sound you designed in PCSFXR (or on sfxr.me) into your code as
'      its sfxr.me link code, and load it with SFXR_Import
'
' Keys: 1-9, 0  roll a sound      E  pasted explosion (sfxr.me code)   C  pasted coin (.json)
'       B P S   Beeper / PWM / sfxr mode                    Esc quit
'
OPTION _EXPLICIT
'$INCLUDE:'../PC-SPEAKER/PCSPKR.BI'
'$INCLUDE:'SFXR.BI'

' copied from PCSFXR's "Copy sfxr.me link" button (works on sfxr.me too)
CONST EXPLOSION_CODE = "7BMHBGHPqCL8YLyqepmkUBsuKMxhyEaznj39ZP3iR8ei3oJ4eyp2c77m5Up4g1W3GbzSdtEiXuLx1KXoa9tjM2eUhgSQBE4rP2wT9ceNZpQsxcd8k3fyEEyu1"

DIM k AS STRING, snd AS LONG, kind AS STRING

_TITLE "SFXDEMO"
SFXR_Init
PRINT "PCSFXR engine demo"
PRINT
PRINT "  1 pickupCoin   2 laserShoot  3 explosion  4 powerUp   5 hitHurt"
PRINT "  6 jump         7 click       8 blipSelect 9 synth     0 random"
PRINT "  E / C          sounds pasted into the code (sfxr.me code / .json)"
PRINT "  B / P / S      Beeper / PWM / sfxr mode"
PRINT "  Esc            quit"
PRINT

DO
    k = UCASE$(INKEY$)
    kind = ""
    SELECT CASE k
        CASE "1": kind = "pickupCoin"
        CASE "2": kind = "laserShoot"
        CASE "3": kind = "explosion"
        CASE "4": kind = "powerUp"
        CASE "5": kind = "hitHurt"
        CASE "6": kind = "jump"
        CASE "7": kind = "click"
        CASE "8": kind = "blipSelect"
        CASE "9": kind = "synth"
        CASE "0": kind = "random"
        CASE "E"
            IF SFXR_Import(EXPLOSION_CODE) THEN kind = "(explosion)"
        CASE "C"
            ' a .json works too - this is the format PCSFXR's "Save .json" writes
            IF SFXR_Import("{" + CHR$(34) + "wave_type" + CHR$(34) + ": 1, " + CHR$(34) + "p_env_sustain" + CHR$(34) + ": 0.05, " + CHR$(34) + "p_env_punch" + CHR$(34) + ": 0.45, " + CHR$(34) + "p_env_decay" + CHR$(34) + ": 0.3, " + CHR$(34) + "p_base_freq" + CHR$(34) + ": 0.55, " + CHR$(34) + "p_arp_speed" + CHR$(34) + ": 0.6, " + CHR$(34) + "p_arp_mod" + CHR$(34) + ": 0.4}") THEN kind = "(coin)"
        CASE "B": sfxr_mode = SFXR_MODE_BEEPER: PRINT "Mode: Beeper"
        CASE "P": sfxr_mode = SFXR_MODE_PWM: PRINT "Mode: PWM"
        CASE "S": sfxr_mode = SFXR_MODE_CLEAN: PRINT "Mode: sfxr"
        CASE CHR$(27): EXIT DO
    END SELECT

    IF LEN(kind) THEN
        IF LEFT$(kind, 1) <> "(" THEN SFXR_Preset kind
        IF snd > 0 THEN _SNDCLOSE snd
        snd = SFXR_Render
        IF snd > 0 THEN _SNDPLAY snd
        PRINT LEFT$(kind + SPACE$(13), 13); SFXR_Fixed(SFXR_Seconds, 3); " sec   https://sfxr.me/#"; SFXR_ToB58
    END IF
    _LIMIT 60
LOOP

IF snd > 0 THEN _SNDCLOSE snd
SYSTEM

'$INCLUDE:'../PC-SPEAKER/PCSPKR.BM'
'$INCLUDE:'SFXR.BM'
