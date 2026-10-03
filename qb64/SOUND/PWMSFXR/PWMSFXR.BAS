''
' PWMSFXR.BAS - layered sfxr sound effects, played through the PC speaker
' with PWM
'
' Up to four voices, each a full sfxr generator with any of eight waveforms
' (square / pulse, sawtooth, sine, triangle, white, pink and brown noise,
' and a metallic 1-bit LFSR buzz), its own volume, pan and start delay. The
' mix plays through the emulated 1-bit PC speaker with pulse width
' modulation (the RealSound / demo scene trick), or clean.
'
' Out of it:
'   .WAV        clean (16-bit stereo), 8-bit mono, or the PWM speaker sound
'   PCSPLAY     a sample sound effect for your game (NAME_PCSPLAY.BM + .WAV)
'   SOUND code  each voice as QB64-PE SOUND statements (waveform, volume,
'               pan, voice 0-3) - no library
'   PLAY code   each voice as a PLAY string (@waveform, V volume)
'   PCSEDIT     each voice's pitch line, as a multi-voice sound in PCSEDIT
'
' Mouse: click buttons, drag sliders, right-click a slider to reset it.
' Keys:  Space play, 1-4 pick a voice, Esc quit. Drop a .pwmsfx to load it.
'
OPTION _EXPLICIT
'$INCLUDE:'../PC-SPEAKER/PCSPKR.BI'
'$INCLUDE:'../PCSFXR/SFXR.BI'

CONST SCR_W = 1280
CONST SCR_H = 830

CONST LEFT_X = 16
CONST LEFT_W = 172
CONST MID_X = 212
CONST MID_W = 640
CONST TRACK_W = 200
CONST RIGHT_X = 876
CONST RIGHT_W = 388
CONST COL_Y = 84

CONST PLOT_Y = 404
CONST PLOT_H = 120
CONST PLOT_N = 388

CONST NV = 4 '           voices
CONST ID_GAIN = 100
CONST ID_VOL = 101
CONST ID_PAN = 102
CONST ID_DELAY = 103

' --- UI input state (immediate-mode GUI) ---
DIM SHARED mx AS LONG, my AS LONG, mb AS INTEGER, mb2 AS INTEGER
DIM SHARED pressEdge AS INTEGER, rpressEdge AS INTEGER
DIM SHARED dragId AS LONG, releasedId AS LONG, resetId AS LONG

' --- the voices ---
DIM SHARED vp(1 TO NV, 0 TO SFXR_NPARAMS) AS DOUBLE ' each voice's sfxr parameters
DIM SHARED vOn(1 TO NV) AS INTEGER
DIM SHARED vVol(1 TO NV) AS DOUBLE ' 0-1
DIM SHARED vPan(1 TO NV) AS DOUBLE ' -1 left ... 1 right
DIM SHARED vDelay(1 TO NV) AS DOUBLE ' seconds before it starts
DIM SHARED sel AS LONG ' the voice being edited (its parameters are in sfxr_p)
' each voice's last render, per 1/140 s tick: PIT divisor, pitch, level
DIM SHARED tDiv(1 TO NV) AS STRING ' MKL$ per tick
DIM SHARED tHz(1 TO NV) AS STRING ' MKS$ per tick
DIM SHARED tEnv(1 TO NV) AS STRING ' MKS$ per tick
DIM SHARED tDelay(1 TO NV) AS LONG ' ticks of delay before it

' --- the mix ---
REDIM SHARED mixL(0 TO 0) AS SINGLE
REDIM SHARED mixR(0 TO 0) AS SINGLE
DIM SHARED mixN AS LONG
DIM SHARED usePWM AS INTEGER

' --- app state ---
DIM SHARED snd AS LONG
DIM SHARED sndName AS STRING
DIM SHARED statusMsg AS STRING
DIM SHARED statusUntil AS DOUBLE
DIM SHARED coneLP AS INTEGER
DIM SHARED needRender AS INTEGER
DIM SHARED playAfter AS INTEGER
DIM SHARED quitApp AS INTEGER
DIM SHARED plotMin(0 TO PLOT_N - 1) AS SINGLE
DIM SHARED plotMax(0 TO PLOT_N - 1) AS SINGLE
DIM SHARED logoImg AS LONG, logoShadow AS LONG

' colours
DIM SHARED cBg AS _UNSIGNED LONG, cText AS _UNSIGNED LONG, cDim AS _UNSIGNED LONG
DIM SHARED cBtn AS _UNSIGNED LONG, cBtnHi AS _UNSIGNED LONG, cOrange AS _UNSIGNED LONG
DIM SHARED cGreen AS _UNSIGNED LONG, cTrack AS _UNSIGNED LONG, cLine AS _UNSIGNED LONG

DIM k AS LONG, f AS STRING, prevMb AS INTEGER, prevMb2 AS INTEGER, pressX AS LONG, pressY AS LONG

cBg = _RGB32(255, 255, 255)
cText = _RGB32(20, 20, 20)
cDim = _RGB32(170, 170, 170)
cBtn = _RGB32(96, 96, 96)
cBtnHi = _RGB32(120, 120, 120)
cOrange = _RGB32(243, 140, 18)
cGreen = _RGB32(52, 150, 40)
cTrack = _RGB32(40, 40, 40)
cLine = _RGB32(200, 200, 200)

SCREEN _NEWIMAGE(SCR_W, SCR_H, 32)
_TITLE "PWMSFXR - layered sfxr through the PC speaker"
_ACCEPTFILEDROP ON
_PRINTMODE _KEEPBACKGROUND
make_logo

SFXR_Init
sfxr_tickHz = 140
sfxr_pwmHz = 16000
usePWM = -1
coneLP = 0
FOR k = 1 TO NV: vVol(k) = 0.8: NEXT
layered "explosion"
needRender = -1
playAfter = 0

DO
    pressEdge = 0
    rpressEdge = 0
    DO WHILE _MOUSEINPUT
        IF _MOUSEBUTTON(1) AND NOT prevMb THEN pressEdge = -1: pressX = _MOUSEX: pressY = _MOUSEY
        IF _MOUSEBUTTON(2) AND NOT prevMb2 THEN rpressEdge = -1: pressX = _MOUSEX: pressY = _MOUSEY
        prevMb = _MOUSEBUTTON(1)
        prevMb2 = _MOUSEBUTTON(2)
    LOOP
    mb = _MOUSEBUTTON(1)
    mb2 = _MOUSEBUTTON(2)
    IF pressEdge OR rpressEdge THEN
        mx = pressX: my = pressY
    ELSE
        mx = _MOUSEX: my = _MOUSEY
    END IF
    releasedId = 0
    resetId = 0
    IF NOT mb AND dragId <> 0 THEN releasedId = dragId: dragId = 0

    CLS , cBg
    draw_header
    draw_generators
    draw_voice
    draw_output

    IF releasedId <> 0 OR resetId <> 0 THEN needRender = -1: playAfter = -1

    k = _KEYHIT
    SELECT CASE k
        CASE 32: play_sound
        CASE 49 TO 52: pick_voice k - 48
        CASE 27: quitApp = -1
    END SELECT

    IF _TOTALDROPPEDFILES THEN
        f = _DROPPEDFILE
        _FINISHDROP
        load_patch f
    END IF

    IF needRender THEN
        render_sound
        needRender = 0
        IF playAfter THEN play_sound
        playAfter = 0
    END IF

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitApp

IF snd > 0 THEN _SNDCLOSE snd
SYSTEM


'-----------------------------------------------------------------------------
' Voices
'-----------------------------------------------------------------------------

''
' sfxr_p always holds the voice being edited; these move it in and out.
'
SUB store_voice (k AS LONG)
    DIM i AS LONG
    FOR i = 0 TO SFXR_NPARAMS: vp(k, i) = sfxr_p(i): NEXT
END SUB


SUB load_voice (k AS LONG)
    DIM i AS LONG
    FOR i = 0 TO SFXR_NPARAMS: sfxr_p(i) = vp(k, i): NEXT
END SUB


SUB pick_voice (k AS LONG)
    IF k < 1 OR k > NV OR k = sel THEN EXIT SUB
    store_voice sel
    sel = k
    load_voice sel
END SUB


''
' A layered preset: the whole sound, one to four voices.
'
SUB layered (kind AS STRING)
    DIM k AS LONG, n AS LONG
    FOR k = 1 TO NV: vOn(k) = 0: vVol(k) = 0.8: vPan(k) = 0: vDelay(k) = 0: NEXT
    SELECT CASE kind
        CASE "coin"
            voice_preset 1, "pickupCoin", SFXR_SQUARE, 0.8
            voice_copy 1, 2: vp(2, 0) = SFXR_TRIANGLE: vp(2, SP_BASE_FREQ) = vp(2, SP_BASE_FREQ) + 0.12: vVol(2) = 0.5: vDelay(2) = 0.02
        CASE "laser"
            voice_preset 1, "laserShoot", SFXR_SQUARE, 0.7
            voice_copy 1, 2: vp(2, 0) = SFXR_SAWTOOTH: vp(2, SP_BASE_FREQ) = vp(2, SP_BASE_FREQ) * 0.93: vVol(2) = 0.5: vPan(1) = -0.3: vPan(2) = 0.3
        CASE "explosion"
            voice_preset 1, "explosion", SFXR_NOISE, 0.8
            voice_copy 1, 2: vp(2, 0) = SFXR_BROWN: vp(2, SP_BASE_FREQ) = vp(2, SP_BASE_FREQ) * 0.6: vp(2, SP_DECAY) = vp(2, SP_DECAY) + 0.15: vVol(2) = 0.9
            voice_preset 3, "tone", SFXR_SINE, 1
            vp(3, SP_BASE_FREQ) = 0.16: vp(3, SP_FREQ_RAMP) = -0.35: vp(3, SP_SUSTAIN) = 0.08: vp(3, SP_DECAY) = 0.3: vp(3, SP_PUNCH) = 0.5
        CASE "powerup"
            voice_preset 1, "powerUp", SFXR_SQUARE, 0.7
            voice_copy 1, 2: vp(2, 0) = SFXR_TRIANGLE: vp(2, SP_BASE_FREQ) = vp(2, SP_BASE_FREQ) + 0.08: vDelay(2) = 0.04: vVol(2) = 0.6
        CASE "hit"
            voice_preset 1, "hitHurt", SFXR_SQUARE, 0.8
            voice_preset 2, "explosion", SFXR_PINK, 0.5
            vp(2, SP_SUSTAIN) = 0.05: vp(2, SP_DECAY) = 0.15
        CASE "jump"
            voice_preset 1, "jump", SFXR_SQUARE, 0.8
            voice_copy 1, 2: vp(2, 0) = SFXR_TRIANGLE: vp(2, SP_BASE_FREQ) = vp(2, SP_BASE_FREQ) + 0.1: vVol(2) = 0.5
        CASE "clank"
            voice_preset 1, "hitHurt", SFXR_METAL, 0.8
            voice_preset 2, "blipSelect", SFXR_TRIANGLE, 0.6
            vp(2, SP_BASE_FREQ) = 0.55: vp(2, SP_DECAY) = 0.25
        CASE "blip"
            voice_preset 1, "blipSelect", SFXR_SQUARE, 0.8
            voice_copy 1, 2: vp(2, 0) = SFXR_SINE: vp(2, SP_BASE_FREQ) = vp(2, SP_BASE_FREQ) + 0.15: vVol(2) = 0.4
        CASE "zap"
            voice_preset 1, "synth", SFXR_SAWTOOTH, 0.7
            voice_preset 2, "laserShoot", SFXR_METAL, 0.4
        CASE ELSE ' random: 1 to 4 voices of anything
            n = 1 + INT(RND * NV)
            FOR k = 1 TO n
                voice_preset k, MID$("pickupCoin laserShoot explosion  powerUp    hitHurt    jump       blipSelect synth      tone       click      ", INT(RND * 10) * 11 + 1, 11), INT(RND * SFXR_WAVES), 0.4 + RND * 0.5
                vPan(k) = RND * 1.2 - 0.6
                IF k > 1 THEN vDelay(k) = RND * 0.1
            NEXT
    END SELECT
    sndName = kind
    sel = 1
    load_voice 1
    needRender = -1
    playAfter = -1
END SUB


SUB voice_preset (k AS LONG, kind AS STRING, wave AS LONG, vol AS DOUBLE)
    DIM i AS LONG
    SFXR_Preset _TRIM$(kind)
    sfxr_p(0) = wave
    FOR i = 0 TO SFXR_NPARAMS: vp(k, i) = sfxr_p(i): NEXT
    vOn(k) = -1: vVol(k) = vol
END SUB


SUB voice_copy (a AS LONG, b AS LONG)
    DIM i AS LONG
    FOR i = 0 TO SFXR_NPARAMS: vp(b, i) = vp(a, i): NEXT
    vOn(b) = -1: vVol(b) = vVol(a): vPan(b) = vPan(a): vDelay(b) = vDelay(a)
END SUB


'-----------------------------------------------------------------------------
' Sound
'-----------------------------------------------------------------------------

''
' Render every voice that's on, mix them (volume, pan, delay) and make the
' sound: through the speaker with PWM, or clean.
'
SUB render_sound
    DIM k AS LONG, i AS LONG, ofs AS LONG, gl AS SINGLE, gr AS SINGLE, n AS LONG, t AS LONG
    DIM a AS LONG, b AS LONG, j AS LONG, v AS SINGLE, pk AS SINGLE, hz AS STRING, ev AS STRING, dv AS STRING
    DIM fade AS LONG, g AS SINGLE
    IF snd > 0 THEN _SNDSTOP snd: _SNDCLOSE snd: snd = 0
    store_voice sel
    mixN = 0
    REDIM mixL(0 TO 44100) AS SINGLE
    REDIM mixR(0 TO 44100) AS SINGLE
    FOR k = 1 TO NV
        tDiv(k) = "": tHz(k) = "": tEnv(k) = "": tDelay(k) = 0
        IF vOn(k) THEN
            load_voice k
            sfxr_tickHz = 140
            SFXR_Synth
            ofs = CLNG(vDelay(k) * SFXR_RATE)
            gl = vVol(k): gr = vVol(k)
            IF vPan(k) > 0 THEN gl = gl * (1 - vPan(k)) ELSE gr = gr * (1 + vPan(k))
            n = ofs + sfxr_pcmN
            IF n > UBOUND(mixL) THEN
                REDIM _PRESERVE mixL(0 TO n + 1000) AS SINGLE
                REDIM _PRESERVE mixR(0 TO n + 1000) AS SINGLE
            END IF
            ' each voice's last 15 ms faded out: an sfxr sound can stop dead (a
            ' zero decay, its frequency cutoff), and that's a click
            fade = SFXR_RATE * 15 \ 1000
            IF fade > sfxr_pcmN THEN fade = sfxr_pcmN
            FOR i = 0 TO sfxr_pcmN - 1
                g = 1
                IF i >= sfxr_pcmN - fade THEN g = (sfxr_pcmN - i) / fade
                mixL(ofs + i) = mixL(ofs + i) + sfxr_pcm(i) * gl * g
                mixR(ofs + i) = mixR(ofs + i) + sfxr_pcm(i) * gr * g
            NEXT
            IF n > mixN THEN mixN = n
            ' the voice per tick, for the code / PCSEDIT exports
            tDelay(k) = CLNG(vDelay(k) * 140)
            dv = SPACE$(sfxr_divN * 4): hz = SPACE$(sfxr_divN * 4): ev = SPACE$(sfxr_divN * 4)
            FOR t = 0 TO sfxr_divN - 1
                MID$(dv, t * 4 + 1, 4) = MKL$(sfxr_div(t))
                MID$(hz, t * 4 + 1, 4) = MKS$(sfxr_tickHzOut(t))
                MID$(ev, t * 4 + 1, 4) = MKS$(sfxr_tickEnv(t))
            NEXT
            tDiv(k) = dv: tHz(k) = hz: tEnv(k) = ev
        END IF
    NEXT
    load_voice sel
    IF mixN = 0 THEN set_status "Every voice is off": EXIT SUB

    apply_cone
    IF usePWM THEN snd = render_pwm ELSE snd = render_clean

    ' overview for the plot
    pk = mix_peak
    IF pk < 0.000001 THEN pk = 1
    FOR i = 0 TO PLOT_N - 1
        plotMin(i) = 0: plotMax(i) = 0
        a = (i * mixN) \ PLOT_N
        b = ((i + 1) * mixN) \ PLOT_N
        IF b <= a THEN b = a + 1
        IF b > mixN THEN b = mixN
        FOR j = a TO b - 1
            v = (mixL(j) + mixR(j)) / 2 / pk
            IF v < plotMin(i) THEN plotMin(i) = v
            IF v > plotMax(i) THEN plotMax(i) = v
        NEXT
    NEXT
END SUB


FUNCTION mix_peak!
    DIM i AS LONG, pk AS SINGLE, v AS SINGLE
    FOR i = 0 TO mixN - 1
        v = ABS((mixL(i) + mixR(i)) / 2)
        IF v > pk THEN pk = v
    NEXT
    mix_peak = pk
END FUNCTION


''
' The mix (in mono) through the 1-bit speaker: every carrier period a
' one-shot pulse as wide as the sound is high. A PWM "silence" is a half-
' width pulse (the cone half way out) but a speaker that's off has the cone
' in, so it eases from one to the other over PWM_EASE seconds before the
' sound and back after it - no pop at the start, no click at the end.
'
FUNCTION render_pwm&
    CONST PWM_EASE = 0.03
    DIM d AS LONG, stp AS DOUBLE, ppos AS DOUBLE, k AS LONG, n AS LONG, e AS LONG
    DIM a AS LONG, b AS LONG, i AS LONG, s AS DOUBLE, w AS LONG, pk AS DOUBLE
    d = SFXR_PWMDivisor
    stp = SFXR_RATE * d / PCSPK_PIT_HZ
    pk = mix_peak
    IF pk < 0.000001 THEN pk = 1
    PCSPK_CaptureBegin
    PCSPK_SetVolume SFXR_SpeakerVolume
    PCSPK_SpeakerOn
    n = INT(mixN / stp)
    e = CLNG(PWM_EASE * PCSPK_PIT_HZ / d)
    ease_cone d, e, 0 ' cone in -> half way
    FOR k = 0 TO n - 1
        a = INT(ppos)
        b = INT(ppos + stp)
        IF b <= a THEN b = a + 1
        IF b > mixN THEN b = mixN
        s = 0
        FOR i = a TO b - 1
            s = s + (mixL(i) + mixR(i)) / 2
        NEXT
        s = s / (b - a) / pk
        IF s > 1 THEN s = 1
        IF s < -1 THEN s = -1
        w = CLNG((1 - s) / 2 * (d - 2)) + 1 ' LOW time: a short pulse = cone out
        PCSPK_PitWrite PCSPK_MODE_ONESHOT, w
        PCSPK_AdvanceClocks d
        ppos = ppos + stp
    NEXT
    ease_cone d, e, -1 ' half way -> cone in
    PCSPK_SpeakerOff
    PCSPK_AdvanceSeconds 0.05
    render_pwm = PCSPK_CaptureEnd
END FUNCTION


''
' e carrier periods of silence easing the cone (raised cosine) from in to
' half way out, or back (down = TRUE).
'
SUB ease_cone (d AS LONG, e AS LONG, down AS INTEGER)
    DIM k AS LONG, g AS DOUBLE
    FOR k = 0 TO e - 1
        g = 0.5 - 0.5 * COS(_PI * (k + 0.5) / e) ' 0 -> 1
        IF down THEN g = 1 - g
        ' the level goes 0 (cone in) -> 0.5; the pulse is LOW for w clocks
        PCSPK_PitWrite PCSPK_MODE_ONESHOT, CLNG((1 - g * 0.5) * (d - 2)) + 1
        PCSPK_AdvanceClocks d
    NEXT
END SUB


''
' The mix as it is: stereo, 44.1 kHz.
'
FUNCTION render_clean&
    DIM h AS LONG, m AS _MEM, i AS LONG, g AS SINGLE, l AS SINGLE, r AS SINGLE
    h = _SNDNEW(mixN, 2, 32, SFXR_RATE)
    IF h < 1 THEN EXIT FUNCTION
    m = _MEMSOUND(h, 0)
    g = SFXR_SpeakerVolume * 2
    FOR i = 0 TO mixN - 1
        l = mixL(i) * g: r = mixR(i) * g
        IF l > 1 THEN l = 1
        IF l < -1 THEN l = -1
        IF r > 1 THEN r = 1
        IF r < -1 THEN r = -1
        _MEMPUT m, m.OFFSET + i * 8, l
        _MEMPUT m, m.OFFSET + i * 8 + 4, r
    NEXT
    _MEMFREE m
    render_clean = h
END FUNCTION


SUB play_sound
    IF snd > 0 THEN
        _SNDSTOP snd
        _SNDPLAY snd
    ELSE
        set_status "No audio device"
    END IF
END SUB


SUB apply_cone
    IF coneLP THEN PCSPK_SetLowPass 5000 ELSE PCSPK_SetLowPass 0
END SUB


'-----------------------------------------------------------------------------
' Header and the left column
'-----------------------------------------------------------------------------

SUB make_logo
    logoImg = logo_text(_RGB32(243, 140, 18))
    logoShadow = logo_text(_RGB32(20, 20, 20))
END SUB


FUNCTION logo_text& (c AS _UNSIGNED LONG)
    DIM img AS LONG
    img = _NEWIMAGE(64, 16, 32)
    _DEST img
    CLS , _RGBA32(0, 0, 0, 0)
    _PRINTMODE _KEEPBACKGROUND
    COLOR c
    _PRINTSTRING (0, 0), "pwmsfxr"
    _DEST 0
    logo_text = img
END FUNCTION


SUB draw_header
    _PUTIMAGE (LEFT_X + 3, 9)-(LEFT_X + 3 + 256, 9 + 64), logoShadow
    _PUTIMAGE (LEFT_X - 2, 4)-(LEFT_X - 2 + 256, 4 + 64), logoImg
    COLOR cText
    _PRINTSTRING (LEFT_X + 276, 20), "layered sfxr - up to 4 voices, 8 waveforms - through the PC speaker with PWM"
    COLOR _RGB32(110, 110, 110)
    _PRINTSTRING (LEFT_X + 276, 40), "Roll a sound, layer it, tweak it. Export it for a game, as QB64-PE code, or to PCSEDIT."
END SUB


SUB draw_generators
    DIM y AS LONG, k AS LONG, lab AS STRING, kind AS STRING
    title LEFT_X, LEFT_W, "Generator"
    y = COL_Y + 24
    FOR k = 1 TO 11
        SELECT CASE k
            CASE 1: lab = "Random": kind = "random"
            CASE 2: lab = "Pickup/coin": kind = "coin"
            CASE 3: lab = "Laser/shoot": kind = "laser"
            CASE 4: lab = "Explosion": kind = "explosion"
            CASE 5: lab = "Powerup": kind = "powerup"
            CASE 6: lab = "Hit/hurt": kind = "hit"
            CASE 7: lab = "Jump": kind = "jump"
            CASE 8: lab = "Blip/select": kind = "blip"
            CASE 9: lab = "Clank (metal)": kind = "clank"
            CASE 10: lab = "Zap": kind = "zap"
            CASE 11: lab = "One voice: " + MID$("SqSaSiNoTrPiBrMe", sfxr_p(0) * 2 + 1, 2): kind = ""
        END SELECT
        IF k = 2 OR k = 11 THEN y = y + 8
        IF ui_button(LEFT_X, y, LEFT_W, 26, lab, 0) THEN
            IF kind = "" THEN
                ' re-roll only the voice being edited, keeping its waveform
                k = sfxr_p(0)
                SFXR_Preset MID$("pickupCoin laserShoot explosion  powerUp    hitHurt    jump       blipSelect synth      ", INT(RND * 8) * 11 + 1, 11)
                sfxr_p(0) = k
                vOn(sel) = -1
                needRender = -1: playAfter = -1
                EXIT FOR
            ELSE
                layered kind
            END IF
        END IF
        y = y + 30
    NEXT
    y = COL_Y + 24 + 11 * 30 + 24
    IF ui_button(LEFT_X, y, LEFT_W, 26, "Mutate (all voices)", 0) THEN
        store_voice sel
        FOR k = 1 TO NV
            IF vOn(k) THEN load_voice k: SFXR_Mutate: store_voice k
        NEXT
        load_voice sel
        needRender = -1: playAfter = -1
    END IF
    y = y + 40
    IF ui_button(LEFT_X, y, LEFT_W, 30, "Play", 2) THEN play_sound

    COLOR _RGB32(110, 110, 110)
    y = y + 50
    _PRINTSTRING (LEFT_X, y), "Space    play"
    _PRINTSTRING (LEFT_X, y + 16), "1-4      voice"
    _PRINTSTRING (LEFT_X, y + 32), "R-click  reset slider"
    _PRINTSTRING (LEFT_X, y + 48), "Esc      quit"
    _PRINTSTRING (LEFT_X, y + 80), "Drop a .pwmsfx to"
    _PRINTSTRING (LEFT_X, y + 96), "load it."
    COLOR _RGB32(150, 150, 150)
    _PRINTSTRING (LEFT_X, y + 128), "Sound: " + sndName
END SUB


'-----------------------------------------------------------------------------
' Middle column: the voices
'-----------------------------------------------------------------------------

SUB draw_voice
    DIM y AS LONG, bw AS LONG, i AS LONG, k AS LONG, lab AS STRING, v AS DOUBLE

    title MID_X, MID_W, "Voices"
    y = COL_Y + 22
    bw = MID_W \ NV
    FOR k = 1 TO NV
        lab = "Voice" + STR$(k)
        IF vOn(k) THEN lab = lab + " (" + MID$("SqSaSiNoTrPiBrMe", vp(k, 0) * 2 + 1, 2) + ")" ELSE lab = lab + " - off"
        IF k = sel THEN i = 1 ELSE i = 0
        IF ui_button(MID_X + (k - 1) * bw, y, bw - 2, 28, lab, i) THEN pick_voice k
    NEXT

    ' the voice: on / off, waveform, volume, pan, delay
    y = y + 34
    IF vOn(sel) THEN lab = "ON" ELSE lab = "OFF"
    IF vOn(sel) THEN i = 2 ELSE i = 0
    IF ui_button(MID_X, y, 70, 52, lab, i) THEN
        vOn(sel) = NOT vOn(sel)
        needRender = -1: playAfter = -1
    END IF
    bw = (MID_W - 76) \ 4
    FOR i = 0 TO SFXR_WAVES - 1
        SELECT CASE i
            CASE SFXR_SQUARE: lab = "Square"
            CASE SFXR_SAWTOOTH: lab = "Sawtooth"
            CASE SFXR_SINE: lab = "Sine"
            CASE SFXR_TRIANGLE: lab = "Triangle"
            CASE SFXR_NOISE: lab = "Noise"
            CASE SFXR_PINK: lab = "Pink"
            CASE SFXR_BROWN: lab = "Brown"
            CASE SFXR_METAL: lab = "Metal"
        END SELECT
        IF ui_button(MID_X + 76 + (i MOD 4) * bw, y + (i \ 4) * 26, bw - 2, 24, lab, -(sfxr_p(0) = i)) THEN
            sfxr_p(0) = i: vOn(sel) = -1
            needRender = -1: playAfter = -1
        END IF
    NEXT
    y = y + 58
    v = ui_slider(ID_VOL, MID_X + 6, y, 120, vVol(sel), 0, 1, -1)
    IF resetId = ID_VOL THEN v = 0.8
    vVol(sel) = v
    COLOR cText
    _PRINTSTRING (MID_X + 136, y), "Vol" + STR$(CLNG(vVol(sel) * 100)) + "%"
    v = ui_slider(ID_PAN, MID_X + 236, y, 120, vPan(sel), -1, 1, -1)
    IF resetId = ID_PAN THEN v = 0
    vPan(sel) = v
    COLOR cText
    _PRINTSTRING (MID_X + 366, y), "Pan " + pan_text(vPan(sel))
    v = ui_slider(ID_DELAY, MID_X + 456, y, 100, vDelay(sel), 0, 0.5, -1)
    IF resetId = ID_DELAY THEN v = 0
    vDelay(sel) = v
    COLOR cText
    _PRINTSTRING (MID_X + 566, y), fmtnum(vDelay(sel), 2) + "s"

    ' its sfxr parameters
    y = y + 24
    y = section(y, "Envelope")
    FOR i = SP_ATTACK TO SP_DECAY: y = param_row(y, i): NEXT
    y = section(y, "Frequency")
    FOR i = SP_BASE_FREQ TO SP_FREQ_DRAMP: y = param_row(y, i): NEXT
    y = section(y, "Vibrato")
    FOR i = SP_VIB_STRENGTH TO SP_VIB_SPEED: y = param_row(y, i): NEXT
    y = section(y, "Arpeggiation")
    FOR i = SP_ARP_MOD TO SP_ARP_SPEED: y = param_row(y, i): NEXT
    y = section(y, "Duty Cycle (square)")
    FOR i = SP_DUTY TO SP_DUTY_RAMP: y = param_row(y, i): NEXT
    y = section(y, "Retrigger")
    y = param_row(y, SP_REPEAT_SPEED)
    y = section(y, "Flanger")
    FOR i = SP_PHA_OFFSET TO SP_PHA_RAMP: y = param_row(y, i): NEXT
    y = section(y, "Low-Pass Filter")
    FOR i = SP_LPF_FREQ TO SP_LPF_RESONANCE: y = param_row(y, i): NEXT
    y = section(y, "High-Pass Filter")
    FOR i = SP_HPF_FREQ TO SP_HPF_RAMP: y = param_row(y, i): NEXT
END SUB


FUNCTION pan_text$ (p AS DOUBLE)
    IF ABS(p) < 0.02 THEN pan_text = "C": EXIT FUNCTION
    IF p < 0 THEN pan_text = "L" + LTRIM$(STR$(CLNG(-p * 100))) ELSE pan_text = "R" + LTRIM$(STR$(CLNG(p * 100)))
END FUNCTION


FUNCTION section& (y AS LONG, label AS STRING)
    DIM yy AS LONG
    yy = y + 2
    LINE (MID_X + 8 * LEN(label) + 8, yy + 8)-(MID_X + MID_W, yy + 8), cLine
    COLOR cText
    _PRINTSTRING (MID_X, yy), label
    _PRINTSTRING (MID_X + 1, yy), label
    section = yy + 18
END FUNCTION


FUNCTION param_row& (y AS LONG, i AS LONG)
    DIM lo AS DOUBLE, s AS STRING, v AS DOUBLE
    IF sfxr_signed(i) THEN lo = -1 ELSE lo = 0
    v = ui_slider(i, MID_X + 6, y, TRACK_W, sfxr_p(i), lo, 1, -1)
    IF resetId = i THEN v = SFXR_Default(i)
    sfxr_p(i) = v
    COLOR cText
    _PRINTSTRING (MID_X + TRACK_W + 24, y), sfxr_label(i)
    s = SFXR_ParamText(i)
    _PRINTSTRING (MID_X + MID_W - 8 * LEN(s), y), s
    param_row = y + 17
END FUNCTION


'-----------------------------------------------------------------------------
' Right column: output, plot, export
'-----------------------------------------------------------------------------

SUB draw_output
    DIM y AS LONG, bw AS LONG, x AS LONG, s AS STRING, v AS DOUBLE, i AS LONG, cy AS LONG

    title RIGHT_X, RIGHT_W, "Output"
    y = COL_Y + 22
    IF ui_button(RIGHT_X, y, RIGHT_W, 28, "Play", 2) THEN play_sound
    y = y + 36
    bw = RIGHT_W \ 2
    IF ui_button(RIGHT_X, y, bw, 28, "PC speaker (PWM)", -(usePWM <> 0)) THEN usePWM = -1: needRender = -1: playAfter = -1
    IF ui_button(RIGHT_X + bw, y, RIGHT_W - bw, 28, "Clean (stereo)", -(usePWM = 0)) THEN usePWM = 0: needRender = -1: playAfter = -1
    y = y + 36
    IF usePWM THEN
        COLOR cText
        _PRINTSTRING (RIGHT_X, y), "PWM carrier (Hz)"
        y = y + 18
        bw = RIGHT_W \ 4
        IF ui_button(RIGHT_X, y, bw, 26, "8k", -(sfxr_pwmHz = 8000)) THEN set_pwm 8000
        IF ui_button(RIGHT_X + bw, y, bw, 26, "11k", -(sfxr_pwmHz = 11025)) THEN set_pwm 11025
        IF ui_button(RIGHT_X + bw * 2, y, bw, 26, "16k", -(sfxr_pwmHz = 16000)) THEN set_pwm 16000
        IF ui_button(RIGHT_X + bw * 3, y, RIGHT_W - bw * 3, 26, "22k", -(sfxr_pwmHz = 22050)) THEN set_pwm 22050
        y = y + 32
        COLOR cText
        _PRINTSTRING (RIGHT_X, y), "Pulse widths: 1-" + LTRIM$(STR$(SFXR_PWMDivisor - 1)) + " PIT clocks (" + fmtnum(SFXR_PWMBits, 1) + " bits)"
        y = y + 22
        IF coneLP THEN s = "Speaker cone filter: ON" ELSE s = "Speaker cone filter: OFF"
        IF ui_button(RIGHT_X, y, RIGHT_W, 24, s, -(coneLP <> 0)) THEN coneLP = NOT coneLP: needRender = -1: playAfter = -1
    ELSE
        COLOR cText
        _PRINTSTRING (RIGHT_X, y + 4), "The mix as it is, in stereo (with the pans) -"
        _PRINTSTRING (RIGHT_X, y + 22), "compare it with the PC speaker."
        y = y + 72
    END IF
    y = y + 34
    v = ui_slider(ID_GAIN, RIGHT_X + 6, y, 180, sfxr_vol, 0, 1, -1)
    IF resetId = ID_GAIN THEN v = 0.25
    sfxr_vol = v
    COLOR cText
    _PRINTSTRING (RIGHT_X + 200, y), "Gain " + SFXR_GainText
    y = y + 24
    COLOR _RGB32(90, 90, 90)
    _PRINTSTRING (RIGHT_X, y), "Length: " + fmtnum(mixN / SFXR_RATE, 3) + " s   voices on:" + STR$(voices_on)

    ' the plot
    LINE (RIGHT_X, PLOT_Y)-(RIGHT_X + RIGHT_W, PLOT_Y + PLOT_H), _RGB32(18, 20, 28), BF
    cy = PLOT_Y + PLOT_H \ 2
    LINE (RIGHT_X, cy)-(RIGHT_X + RIGHT_W, cy), _RGB32(45, 50, 65)
    FOR i = 0 TO PLOT_N - 1
        LINE (RIGHT_X + i, cy - CLNG(plotMax(i) * (PLOT_H \ 2 - 3)))-(RIGHT_X + i, cy - CLNG(plotMin(i) * (PLOT_H \ 2 - 3))), cOrange
    NEXT
    IF snd > 0 AND mixN > 0 THEN
        IF _SNDPLAYING(snd) THEN
            v = _SNDGETPOS(snd) / (mixN / SFXR_RATE)
            IF v > 1 THEN v = 1
            x = RIGHT_X + CLNG(v * RIGHT_W)
            LINE (x, PLOT_Y + 1)-(x, PLOT_Y + PLOT_H - 1), _RGB32(255, 255, 255)
        END IF
    END IF
    LINE (RIGHT_X, PLOT_Y)-(RIGHT_X + RIGHT_W, PLOT_Y + PLOT_H), _RGB32(120, 120, 120), B

    ' export
    y = PLOT_Y + PLOT_H + 12
    bw = RIGHT_W \ 2
    x = RIGHT_X + bw
    COLOR cText
    _PRINTSTRING (RIGHT_X, y), "Name: " + UCASE$(LEFT$(SFXR_SafeName(sndName), 12))
    IF ui_button(RIGHT_X + RIGHT_W - 90, y - 4, 90, 22, "Rename", 0) THEN
        s = _INPUTBOX$("Name", "The sound's name (12 letters at most):", sndName)
        IF LEN(s) THEN sndName = LEFT$(s, 12)
    END IF
    y = y + 24
    IF ui_button(RIGHT_X, y, bw - 2, 26, "Save .WAV", 0) THEN export_wav 0
    IF ui_button(x, y, RIGHT_W - bw, 26, "Save PWM .WAV", 0) THEN export_wav 1
    y = y + 28
    IF ui_button(RIGHT_X, y, bw - 2, 26, "Save 8-bit .WAV", 0) THEN export_wav 2
    IF ui_button(x, y, RIGHT_W - bw, 26, "For PCSPLAY (game)", 0) THEN export_pcsplay
    y = y + 28
    IF ui_button(RIGHT_X, y, bw - 2, 26, "SOUND code .BAS", 0) THEN export_code 0
    IF ui_button(x, y, RIGHT_W - bw, 26, "PLAY code .BAS", 0) THEN export_code 1
    y = y + 28
    IF ui_button(RIGHT_X, y, bw - 2, 26, "Save .pwmsfx", 0) THEN save_patch
    IF ui_button(x, y, RIGHT_W - bw, 26, "Load .pwmsfx", 0) THEN
        s = _OPENFILEDIALOG$("Load a PWMSFXR sound", "", "*.pwmsfx|*.PWMSFX", "PWMSFXR sounds")
        IF LEN(s) THEN load_patch s
    END IF
    y = y + 32
    IF ui_button(RIGHT_X, y, RIGHT_W, 26, "Send to PCSEDIT  (each voice's pitch line)", 1) THEN send_to_pcsedit

    ' status line
    IF LEN(statusMsg) THEN
        IF TIMER(0.001) < statusUntil AND TIMER(0.001) > statusUntil - 10 THEN
            COLOR cGreen
            _PRINTSTRING (MID_X, SCR_H - 20), statusMsg
        ELSE
            statusMsg = ""
        END IF
    END IF
END SUB


FUNCTION voices_on&
    DIM k AS LONG, n AS LONG
    FOR k = 1 TO NV
        IF vOn(k) THEN n = n + 1
    NEXT
    voices_on = n
END FUNCTION


SUB set_pwm (hz AS LONG)
    sfxr_pwmHz = hz
    needRender = -1: playAfter = -1
END SUB


'-----------------------------------------------------------------------------
' Export
'-----------------------------------------------------------------------------

FUNCTION export_path$ (ext AS STRING)
    IF NOT _DIREXISTS("EXPORT") THEN MKDIR "EXPORT"
    export_path = "EXPORT/" + UCASE$(SFXR_SafeName(sndName)) + ext
END FUNCTION


FUNCTION ident$
    DIM s AS STRING
    s = UCASE$(SFXR_SafeName(sndName))
    IF s = "" THEN s = "SFX"
    IF INSTR("0123456789", LEFT$(s, 1)) THEN s = "S" + s
    ident = s
END FUNCTION


''
' kind 0: clean 16-bit stereo 44.1 kHz; 1: the PWM speaker sound; 2: 8-bit
' mono 11025 Hz (PCSPLAY, PC-SPEAKER/WAV.BAS).
'
SUB export_wav (kind AS INTEGER)
    DIM f AS STRING, h AS LONG
    IF mixN = 0 THEN set_status "Nothing to save": EXIT SUB
    SELECT CASE kind
        CASE 0: f = export_path(".wav"): write_file f, wav_clean
        CASE 1
            f = export_path("-pwm.wav")
            h = render_pwm
            PCSPK_SaveWAV f
            IF h > 0 THEN _SNDCLOSE h
        CASE 2: f = export_path("-8bit.wav"): write_file f, wav_8bit
    END SELECT
    set_status "Saved " + f
END SUB


FUNCTION wav_header$ (rate AS LONG, ch AS LONG, bits AS LONG, dataBytes AS LONG)
    wav_header = "RIFF" + MKL$(36 + dataBytes) + "WAVE" + "fmt " + MKL$(16) + MKI$(1) + MKI$(ch) + MKL$(rate) + MKL$(rate * ch * bits \ 8) + MKI$(ch * bits \ 8) + MKI$(bits) + "data" + MKL$(dataBytes)
END FUNCTION


FUNCTION wav_clean$
    DIM d AS STRING, i AS LONG, g AS SINGLE, l AS LONG, r AS LONG
    g = SFXR_SpeakerVolume * 2 * 32767
    d = SPACE$(mixN * 4)
    FOR i = 0 TO mixN - 1
        l = CLNG(mixL(i) * g): r = CLNG(mixR(i) * g)
        IF l > 32767 THEN l = 32767
        IF l < -32768 THEN l = -32768
        IF r > 32767 THEN r = 32767
        IF r < -32768 THEN r = -32768
        MID$(d, i * 4 + 1, 4) = MKI$(l) + MKI$(r)
    NEXT
    wav_clean = wav_header(SFXR_RATE, 2, 16, LEN(d)) + d
END FUNCTION


''
' 8-bit unsigned mono at 11025 Hz, normalised: what PCSPLAY plays with PWM.
'
FUNCTION wav_8bit$
    DIM d AS STRING, n AS LONG, i AS LONG, j AS LONG, a AS LONG, b AS LONG, s AS SINGLE, pk AS SINGLE, v AS LONG
    pk = mix_peak
    IF pk < 0.000001 THEN pk = 1
    n = mixN \ 4
    d = SPACE$(n)
    FOR i = 0 TO n - 1
        a = i * 4: b = a + 4
        IF b > mixN THEN b = mixN
        s = 0
        FOR j = a TO b - 1: s = s + (mixL(j) + mixR(j)) / 2: NEXT
        s = s / (b - a) / pk
        v = 128 + CLNG(s * 127)
        IF v < 0 THEN v = 0
        IF v > 255 THEN v = 255
        MID$(d, i + 1, 1) = CHR$(v)
    NEXT
    wav_8bit = wav_header(11025, 1, 8, n) + d
END FUNCTION


''
' For a game: NAME.WAV (8-bit, 11025 Hz) and NAME_PCSPLAY.BM, which embeds
' it and has NAME_Load and SFX_NAME (PCSPLAY plays it through the speaker
' with PWM).
'
SUB export_pcsplay
    DIM w AS STRING, id AS STRING, ff AS LONG, i AS LONG, k AS LONG, c AS STRING
    IF mixN = 0 THEN set_status "Nothing to export": EXIT SUB
    w = wav_8bit
    id = ident
    write_file export_path(".wav"), w
    ff = FREEFILE
    OPEN export_path("_PCSPLAY.BM") FOR OUTPUT AS #ff
    PRINT #ff, "''"
    PRINT #ff, "' "; id; "_PCSPLAY.BM - the "; id; " sound effect for PCSPLAY (made by PWMSFXR)"
    PRINT #ff, "'"
    PRINT #ff, "' Include it at the bottom, after PCSPKR.BM and PCSPLAY.BM. Call "; id; "_Load"
    PRINT #ff, "' once, then SFX_"; id; " plays it (through the speaker, with PWM), and"
    PRINT #ff, "' PCSP_Update every frame. Or load "; id; ".WAV with PCSP_LoadWav instead."
    PRINT #ff, "'"
    PRINT #ff, "SUB "; id; "_Load"
    PRINT #ff, "    DIM h AS STRING, i AS LONG"
    FOR i = 1 TO LEN(w) STEP 60
        c = ""
        FOR k = i TO i + 59
            IF k > LEN(w) THEN EXIT FOR
            c = c + RIGHT$("0" + HEX$(ASC(w, k)), 2)
        NEXT
        PRINT #ff, "    h = h + "; CHR$(34); c; CHR$(34)
    NEXT
    PRINT #ff, "    i = PCSP_LoadWavHex("; CHR$(34); id; CHR$(34); ", h)"
    PRINT #ff, "END SUB"
    PRINT #ff, ""
    PRINT #ff, "SUB SFX_"; id
    PRINT #ff, "    PCSP_Sfx "; CHR$(34); id; CHR$(34)
    PRINT #ff, "END SUB"
    CLOSE #ff
    set_status "Saved " + export_path("_PCSPLAY.BM") + " and " + export_path(".wav") + " (PCSP_LoadWav)"
END SUB


''
' QB64-PE code, no library: kind 0 SOUND statements (every voice its own
' SOUND voice 0-3, with its waveform, volume and pan, pitch exact), kind 1
' PLAY strings (@waveform, V volume; pitch in semitones). A ready-to-run
' program: press Space to play it.
'
SUB export_code (kind AS INTEGER)
    DIM f AS STRING, id AS STRING, ff AS LONG, k AS LONG, ch AS LONG, lst AS STRING
    IF mixN = 0 THEN set_status "Nothing to export": EXIT SUB
    id = ident
    IF kind = 0 THEN f = export_path("_SOUND.BAS") ELSE f = export_path("_PLAY.BAS")
    ff = FREEFILE
    OPEN f FOR OUTPUT AS #ff
    PRINT #ff, "''"
    IF kind = 0 THEN
        PRINT #ff, "' "; id; " - a PWMSFXR sound as QB64-PE SOUND statements (QB64-PE 4+)"
        PRINT #ff, "'"
        PRINT #ff, "' Each voice is a SOUND voice with its waveform, volume and pan, queued"
        PRINT #ff, "' (SOUND WAIT ... SOUND RESUME) so it plays while your program goes on."
        PRINT #ff, "' Copy SOUND_"; id; " into your game. (Filters and flanger are left out:"
        PRINT #ff, "' SOUND has no such thing.)"
    ELSE
        PRINT #ff, "' "; id; " - a PWMSFXR sound as QB64-PE PLAY strings (QB64-PE 4+)"
        PRINT #ff, "'"
        PRINT #ff, "' Each voice is a PLAY string with its waveform (@) and volume (V),"
        PRINT #ff, "' played in the background (MB). Pitches are rounded to semitones."
        PRINT #ff, "' Copy PLAY_"; id; " into your game."
    END IF
    PRINT #ff, "'"
    PRINT #ff, "PRINT "; CHR$(34); id; ": Space plays it, Esc quits"; CHR$(34)
    PRINT #ff, "DO"
    PRINT #ff, "    SELECT CASE INKEY$"
    IF kind = 0 THEN lst = "SOUND_" ELSE lst = "PLAY_"
    PRINT #ff, "        CASE "; CHR$(34); " "; CHR$(34); ": "; lst; id
    lst = ""
    PRINT #ff, "        CASE CHR$(27): EXIT DO"
    PRINT #ff, "    END SELECT"
    PRINT #ff, "    _LIMIT 60"
    PRINT #ff, "LOOP"
    PRINT #ff, "SYSTEM"
    PRINT #ff, ""
    IF kind = 0 THEN
        PRINT #ff, "SUB SOUND_"; id
        PRINT #ff, "    SOUND WAIT"
        FOR k = 1 TO NV
            IF vOn(k) AND LEN(tHz(k)) THEN
                PRINT #ff, "    ' voice"; k; "- "; wave_name(vp(k, 0))
                write_sound ff, k, ch
                ch = ch + 1
            END IF
        NEXT
        PRINT #ff, "    SOUND RESUME"
        PRINT #ff, "END SUB"
    ELSE
        PRINT #ff, "SUB PLAY_"; id
        PRINT #ff, "    DIM a AS STRING, b AS STRING, c AS STRING, d AS STRING"
        FOR k = 1 TO NV
            IF vOn(k) AND LEN(tHz(k)) THEN
                write_play ff, k, MID$("abcd", ch + 1, 1)
                IF LEN(lst) THEN lst = lst + ", "
                lst = lst + MID$("abcd", ch + 1, 1)
                ch = ch + 1
            END IF
        NEXT
        PRINT #ff, "    PLAY "; lst
        PRINT #ff, "END SUB"
    END IF
    CLOSE #ff
    set_status "Saved " + f + " - open it in QB64-PE and press F5"
END SUB


''
' QB64-PE's waveform number for a voice's wave (and the parameter: the
' duty for a pulse).
'
FUNCTION qb_wave& (k AS LONG)
    SELECT CASE vp(k, 0)
        CASE SFXR_SQUARE
            IF ABS(vp(k, SP_DUTY)) > 0.05 THEN qb_wave = 9 ELSE qb_wave = 1 ' pulse / square
        CASE SFXR_SAWTOOTH: qb_wave = 2
        CASE SFXR_TRIANGLE: qb_wave = 3
        CASE SFXR_SINE: qb_wave = 4
        CASE SFXR_NOISE: qb_wave = 5
        CASE SFXR_PINK: qb_wave = 6
        CASE SFXR_BROWN: qb_wave = 7
        CASE ELSE: qb_wave = 8 ' LFSR
    END SELECT
END FUNCTION


FUNCTION wave_name$ (w AS DOUBLE)
    SELECT CASE w
        CASE SFXR_SQUARE: wave_name = "square"
        CASE SFXR_SAWTOOTH: wave_name = "sawtooth"
        CASE SFXR_SINE: wave_name = "sine"
        CASE SFXR_TRIANGLE: wave_name = "triangle"
        CASE SFXR_NOISE: wave_name = "noise"
        CASE SFXR_PINK: wave_name = "pink noise"
        CASE SFXR_BROWN: wave_name = "brown noise"
        CASE ELSE: wave_name = "metal (LFSR)"
    END SELECT
END FUNCTION


''
' A voice's level at tick t (0-1): its envelope times its volume, scaled by
' the gain.
'
FUNCTION tick_vol! (k AS LONG, t AS LONG)
    DIM v AS SINGLE
    v = CVS(MID$(tEnv(k), t * 4 + 1, 4)) * vVol(k) * (SFXR_SpeakerVolume * 2)
    IF v > 1 THEN v = 1
    IF v < 0 THEN v = 0
    tick_vol = v
END FUNCTION


''
' A voice's pitch at tick t for SOUND / PLAY. sfxr's noise holds 32 random
' values a period, so a noise voice's real rate is 32 times its pitch.
'
FUNCTION tick_hz! (k AS LONG, t AS LONG)
    DIM hz AS SINGLE
    hz = CVS(MID$(tHz(k), t * 4 + 1, 4))
    IF SFXR_IsNoise(vp(k, 0)) THEN
        hz = hz * 32
        IF hz > 16000 THEN hz = 16000
    END IF
    tick_hz = hz
END FUNCTION


SUB write_sound (ff AS LONG, k AS LONG, ch AS LONG)
    DIM n AS LONG, t AS LONG, hz AS SINGLE, vol AS SINGLE, lhz AS SINGLE, lvol AS SINGLE, rn AS LONG
    DIM ln AS STRING, cnt AS LONG, w AS LONG, prm AS STRING, pn AS STRING
    n = LEN(tHz(k)) \ 4
    w = qb_wave(k)
    prm = "0"
    IF w = 9 THEN prm = fmt_n(0.5 - vp(k, SP_DUTY) * 0.45, 2)
    pn = fmt_n(vPan(k), 2)
    IF tDelay(k) > 0 THEN PRINT #ff, "    SOUND 0, "; fmt_n(tDelay(k) * 18.2 / 140, 3); ", 0, 0, 1, 0,"; ch
    lhz = -1
    FOR t = 0 TO n
        IF t < n THEN
            hz = tick_hz(k, t): vol = tick_vol(k, t)
            IF hz < 37 OR hz > 20000 OR vol < 0.005 THEN hz = 0: vol = 0
            hz = CLNG(hz): vol = CLNG(vol * 50) / 50 ' (same to the ear: one statement)
        END IF
        IF t = n OR hz <> lhz OR vol <> lvol THEN
            IF rn > 0 THEN
                IF LEN(ln) THEN ln = ln + ": "
                ln = ln + "SOUND " + fmt_n(lhz, 0) + ", " + fmt_n(rn * 18.2 / 140, 3) + ", " + fmt_n(lvol, 2) + ", " + pn + "," + STR$(w) + ", " + prm + "," + STR$(ch)
                cnt = cnt + 1
                IF cnt = 3 THEN PRINT #ff, "    "; ln: ln = "": cnt = 0
            END IF
            lhz = hz: lvol = vol: rn = 0
        END IF
        rn = rn + 1
    NEXT
    IF LEN(ln) THEN PRINT #ff, "    "; ln
END SUB


''
' A voice as MML: at T255 a 1/n note is 131.76 / n ticks of 1/140 s, so
' each run of one note and level (and the delay, as a rest) becomes the
' notes that fill it, keeping the total within about a tick.
'
SUB write_play (ff AS LONG, k AS LONG, v AS STRING)
    CONST UNIT = 131.7647058823529
    DIM n AS LONG, t AS LONG, nt AS LONG, vol AS LONG, rn AS LONG, cnt AS LONG, i AS LONG
    DIM m AS STRING, ideal AS DOUBLE, done AS DOUBLE, nl AS LONG, lastL AS LONG, lastV AS LONG, hz AS SINGLE
    n = LEN(tHz(k)) \ 4
    ' the runs: note (0 = rest), level 0-100, ticks
    REDIM rNt(0 TO n + 1) AS LONG, rVol(0 TO n + 1) AS LONG, rLen(0 TO n + 1) AS LONG
    IF tDelay(k) > 0 THEN rNt(0) = 0: rVol(0) = 0: rLen(0) = tDelay(k): cnt = 1
    FOR t = 0 TO n - 1
        hz = tick_hz(k, t)
        vol = CLNG(tick_vol(k, t) * 100)
        nt = 0
        IF hz >= 30 AND vol > 0 THEN nt = CLNG(12 * LOG(hz / 440) / LOG(2)) + 45 ' (N45 = A 440)
        IF nt > 84 THEN nt = 84
        IF nt < 0 THEN nt = 0
        IF nt = 0 THEN vol = 0
        IF cnt > 0 THEN
            IF rNt(cnt - 1) = nt AND ABS(rVol(cnt - 1) - vol) <= 6 THEN rLen(cnt - 1) = rLen(cnt - 1) + 1: _CONTINUE
        END IF
        rNt(cnt) = nt: rVol(cnt) = vol: rLen(cnt) = 1: cnt = cnt + 1
    NEXT
    m = "MB T255 ML @" + LTRIM$(STR$(qb_wave(k))) + " "
    lastV = -1
    FOR i = 0 TO cnt - 1
        ideal = ideal + rLen(i)
        DO
            IF ideal - done < UNIT / 128 THEN EXIT DO ' (under half the shortest note: carried on)
            nl = -INT(-UNIT / (ideal - done))
            IF nl < 1 THEN nl = 1
            IF nl > 64 THEN nl = 64
            IF nl <> lastL THEN m = m + "L" + LTRIM$(STR$(nl)): lastL = nl
            IF rNt(i) > 0 THEN
                IF rVol(i) <> lastV THEN m = m + "V" + LTRIM$(STR$(rVol(i))): lastV = rVol(i)
                m = m + "N" + LTRIM$(STR$(rNt(i)))
            ELSE
                m = m + "N0"
            END IF
            done = done + UNIT / nl
        LOOP
    NEXT
    PRINT #ff, "    "; v; " = "; CHR$(34); CHR$(34)
    FOR i = 1 TO LEN(m) STEP 96
        PRINT #ff, "    "; v; " = "; v; " + "; CHR$(34); MID$(m, i, 96); CHR$(34)
    NEXT
END SUB


FUNCTION fmt_n$ (x AS DOUBLE, dec AS LONG)
    DIM t AS STRING
    t = LTRIM$(STR$(CLNG(x * 10 ^ dec) / 10 ^ dec))
    IF LEFT$(t, 1) = "." THEN t = "0" + t
    IF LEFT$(t, 2) = "-." THEN t = "-0" + MID$(t, 2)
    fmt_n = t
END FUNCTION


'-----------------------------------------------------------------------------
' Send to PCSEDIT: each voice's pitch line (the PC speaker can only play
' pitches), as a multi-voice sound: the ARP mix plus NAME~1 ... NAME~4
'-----------------------------------------------------------------------------

SUB send_to_pcsedit
    DIM k AS LONG, n AS LONG, t AS LONG, nm AS STRING, d AS STRING, box AS STRING, f AS STRING
    DIM cnt AS LONG, ofs AS LONG, tbl AS STRING, body AS STRING, v AS LONG, used AS LONG, s AS LONG, c AS LONG
    STATIC sent AS LONG
    IF mixN = 0 THEN set_status "Nothing to send": EXIT SUB
    nm = UCASE$(LEFT$(SFXR_SafeName(sndName), 10))
    IF nm = "" THEN nm = "PWMSFXR"
    ' the voices as 140 Hz divisor lists (the delay as rests first)
    REDIM vd(1 TO NV) AS STRING
    FOR k = 1 TO NV
        IF vOn(k) AND LEN(tDiv(k)) THEN
            used = used + 1
            d = STRING$(tDelay(k) * 2, 0)
            FOR t = 0 TO LEN(tDiv(k)) \ 4 - 1
                v = CVL(MID$(tDiv(k), t * 4 + 1, 4))
                IF CVS(MID$(tEnv(k), t * 4 + 1, 4)) * vVol(k) < 0.02 THEN v = 0 ' (silent: off)
                IF v > 65534 THEN v = 65534
                d = d + CHR$(v AND 255) + CHR$(v \ 256)
            NEXT
            vd(used) = d
            IF LEN(d) \ 2 > n THEN n = LEN(d) \ 2
        END IF
    NEXT
    REDIM nms(0 TO 4) AS STRING, dts(0 TO 4) AS STRING
    nms(0) = nm
    IF used = 1 THEN
        dts(0) = vd(1): cnt = 1
    ELSE
        ' the ARP mix (3 steps a note, like PCSEDIT's default) for games
        d = SPACE$(n * 2)
        FOR s = 0 TO n - 1
            REDIM nts(1 TO NV) AS LONG
            c = 0
            FOR k = 1 TO used
                IF s * 2 + 2 <= LEN(vd(k)) THEN
                    v = ASC(vd(k), s * 2 + 1) + ASC(vd(k), s * 2 + 2) * 256&
                    IF v THEN c = c + 1: nts(c) = v
                END IF
            NEXT
            v = 0
            IF c THEN v = nts(((s \ 3) MOD c) + 1)
            MID$(d, s * 2 + 1, 2) = CHR$(v AND 255) + CHR$(v \ 256)
        NEXT
        dts(0) = d: cnt = 1
        FOR k = 1 TO used
            nms(cnt) = nm + "~" + LTRIM$(STR$(k)): dts(cnt) = vd(k): cnt = cnt + 1
        NEXT
    END IF
    ofs = 16 + cnt * 16
    FOR k = 0 TO cnt - 1
        tbl = tbl + SFXR_W16(ofs + LEN(body)) + CHR$(10) + CHR$(8) + LEFT$(nms(k) + STRING$(12, 0), 12)
        body = body + dts(k) + SFXR_W16(&HFFFF&)
    NEXT
    IF ofs + LEN(body) > 65535 THEN set_status "Too long for PCSEDIT": EXIT SUB
    box = pcsedit_inbox
    sent = sent + 1
    f = box + "pwmsfxr_" + MID$(DATE$, 7, 4) + LEFT$(DATE$, 2) + MID$(DATE$, 4, 2) + "_" + RIGHT$("0000000" + LTRIM$(STR$(INT(TIMER * 100))), 7) + "_" + RIGHT$("0000" + LTRIM$(STR$(sent)), 4) + ".snd"
    write_file f, "SND" + CHR$(0) + SFXR_W16(ofs + LEN(body)) + SFXR_W16(cnt) + SFXR_W16(0) + STRING$(6, 0) + tbl + body
    IF pcsedit_alive(box) THEN
        set_status "Sent " + nm + " to PCSEDIT (" + LTRIM$(STR$(used)) + " voice(s) - pitches only: the speaker has no waveforms)"
    ELSEIF start_pcsedit THEN
        set_status "Started PCSEDIT - " + nm + " will be in its bank"
    ELSE
        set_status nm + " is waiting in PCSEDIT's inbox - start PCSEDIT to get it (compile PC-SPEAKER/PCSEDIT.BAS and it'll start by itself)"
    END IF
END SUB


''
' Start PCSEDIT, if it has been compiled (see the launcher in PCSFXR too).
'
FUNCTION start_pcsedit%
    DIM cand AS STRING, pdir AS STRING, exe AS STRING, i AS LONG, j AS LONG, p AS LONG
    ' PCSEDIT lives in ../PC-SPEAKER: next to where this was started from, or
    ' next to this program's own folder
    FOR j = 1 TO 2
        IF j = 1 THEN cand = _STARTDIR$ ELSE cand = COMMAND$(0)
        IF j = 2 THEN ' (the program file: its folder)
            p = _INSTRREV(cand, "/")
            IF _INSTRREV(cand, "\") > p THEN p = _INSTRREV(cand, "\")
            cand = LEFT$(cand, p)
        END IF
        IF RIGHT$(cand, 1) = "/" OR RIGHT$(cand, 1) = "\" THEN cand = LEFT$(cand, LEN(cand) - 1)
        p = _INSTRREV(cand, "/")
        IF _INSTRREV(cand, "\") > p THEN p = _INSTRREV(cand, "\")
        pdir = LEFT$(cand, p) + "PC-SPEAKER"
        IF _DIREXISTS(pdir) THEN
            FOR i = 1 TO 3
                SELECT CASE i
                    CASE 1: exe = "PCSEDIT.exe"
                    CASE 2: exe = "PCSEDIT.run"
                    CASE 3: exe = "PCSEDIT"
                END SELECT
                IF _FILEEXISTS(pdir + "/" + exe) THEN
                    $IF WIN THEN
                        SHELL _DONTWAIT "cd /d " + CHR$(34) + pdir + CHR$(34) + " && start " + CHR$(34) + CHR$(34) + " " + CHR$(34) + exe + CHR$(34)
                    $ELSE
                        SHELL _DONTWAIT "cd '" + pdir + "' && './" + exe + "' >/dev/null 2>&1 &"
                    $END IF
                    start_pcsedit = -1
                    EXIT FUNCTION
                END IF
            NEXT
        END IF
    NEXT
END FUNCTION



FUNCTION pcsedit_inbox$
    DIM d AS STRING
    $IF WIN THEN
        d = ENVIRON$("APPDATA")
        IF RIGHT$(d, 1) <> "\" THEN d = d + "\"
        d = d + "pcsedit-inbox\"
    $ELSE
        d = ENVIRON$("HOME") + "/.config/"
        IF NOT _DIREXISTS(d) THEN MKDIR d
        d = d + "pcsedit-inbox/"
    $END IF
    IF NOT _DIREXISTS(d) THEN MKDIR d
    pcsedit_inbox = d
END FUNCTION


FUNCTION pcsedit_alive% (box AS STRING)
    DIM t AS STRING, p AS LONG
    IF NOT _FILEEXISTS(box + "pcsedit.alive") THEN EXIT FUNCTION
    t = _TRIM$(read_file(box + "pcsedit.alive"))
    p = INSTR(t, " ")
    IF p = 0 THEN EXIT FUNCTION
    IF LEFT$(t, p - 1) <> DATE$ THEN EXIT FUNCTION
    pcsedit_alive = ABS(TIMER - VAL(MID$(t, p + 1))) <= 5
END FUNCTION


'-----------------------------------------------------------------------------
' .pwmsfx: the name, then per voice a [voice k] line (on, volume, pan,
' delay) and that voice's sfxr .json
'-----------------------------------------------------------------------------

SUB save_patch
    DIM f AS STRING, t AS STRING, k AS LONG
    store_voice sel
    f = _SAVEFILEDIALOG$("Save the sound", export_path(".pwmsfx"), "*.pwmsfx|*.PWMSFX", "PWMSFXR sounds")
    IF f = "" THEN EXIT SUB
    IF INSTR(MID$(f, _INSTRREV(f, "/") + 1), ".") = 0 THEN f = f + ".pwmsfx"
    t = "PWMSFXR 1" + CHR$(10) + "name=" + sndName + CHR$(10)
    FOR k = 1 TO NV
        load_voice k
        t = t + "[voice" + STR$(k) + "] on=" + LTRIM$(STR$(-(vOn(k) <> 0))) + " vol=" + fmt_n(vVol(k), 3) + " pan=" + fmt_n(vPan(k), 3) + " delay=" + fmt_n(vDelay(k), 3) + CHR$(10)
        t = t + SFXR_ToJSON + CHR$(10)
    NEXT
    load_voice sel
    write_file f, t
    set_status "Saved " + f
END SUB


SUB load_patch (f AS STRING)
    DIM t AS STRING, p AS LONG, q AS LONG, k AS LONG, blk AS STRING, hdr AS STRING
    IF NOT _FILEEXISTS(f) THEN EXIT SUB
    t = read_file(f)
    IF LEFT$(t, 7) <> "PWMSFXR" THEN set_status "Not a PWMSFXR sound": EXIT SUB
    p = INSTR(t, "name=")
    IF p THEN sndName = MID$(t, p + 5, INSTR(p, t, CHR$(10)) - p - 5)
    FOR k = 1 TO NV
        vOn(k) = 0
        p = INSTR(t, "[voice" + STR$(k) + "]")
        IF p THEN
            q = INSTR(p + 1, t, "[voice")
            IF q = 0 THEN q = LEN(t) + 1
            blk = MID$(t, p, q - p)
            hdr = LEFT$(blk, INSTR(blk, CHR$(10)))
            vOn(k) = VAL(MID$(hdr, INSTR(hdr, "on=") + 3)) <> 0
            vVol(k) = VAL(MID$(hdr, INSTR(hdr, "vol=") + 4))
            vPan(k) = VAL(MID$(hdr, INSTR(hdr, "pan=") + 4))
            vDelay(k) = VAL(MID$(hdr, INSTR(hdr, "delay=") + 6))
            SFXR_Reset
            IF SFXR_FromJSON(MID$(blk, LEN(hdr) + 1)) THEN store_voice k
        END IF
    NEXT
    sel = 1
    load_voice 1
    needRender = -1: playAfter = -1
    set_status "Loaded " + f
END SUB


'-----------------------------------------------------------------------------
' Files, status
'-----------------------------------------------------------------------------

SUB write_file (f AS STRING, d AS STRING)
    DIM ff AS LONG
    IF _FILEEXISTS(f) THEN KILL f
    ff = FREEFILE
    OPEN f FOR BINARY AS #ff
    PUT #ff, 1, d
    CLOSE #ff
END SUB


FUNCTION read_file$ (f AS STRING)
    DIM ff AS LONG, d AS STRING
    ff = FREEFILE
    OPEN f FOR BINARY AS #ff
    d = SPACE$(LOF(ff))
    GET #ff, 1, d
    CLOSE #ff
    read_file = d
END FUNCTION


SUB set_status (msg AS STRING)
    statusMsg = msg
    statusUntil = TIMER(0.001) + 5
END SUB


'-----------------------------------------------------------------------------
' Immediate-mode widgets (as in PCSFXR)
'-----------------------------------------------------------------------------

SUB title (x AS LONG, w AS LONG, s AS STRING)
    COLOR cText
    _PRINTSTRING (x + (w - 8 * LEN(s)) \ 2, COL_Y), s
    _PRINTSTRING (x + (w - 8 * LEN(s)) \ 2 + 1, COL_Y), s
END SUB


''
' style: 0 grey, 1 selected (orange), 2 green
'
FUNCTION ui_button%% (x AS LONG, y AS LONG, w AS LONG, h AS LONG, label AS STRING, style AS INTEGER)
    DIM over AS INTEGER, c AS _UNSIGNED LONG, c2 AS _UNSIGNED LONG
    over = (mx >= x AND mx < x + w AND my >= y AND my < y + h AND dragId = 0)
    SELECT CASE style
        CASE 1: c = cOrange: c2 = _RGB32(255, 170, 60)
        CASE 2: c = cGreen: c2 = _RGB32(80, 180, 64)
        CASE ELSE: c = cBtn: c2 = cBtnHi
    END SELECT
    IF over THEN SWAP c, c2
    LINE (x + 1, y)-(x + w - 2, y + h - 1), c, BF
    LINE (x + 1, y + h \ 2)-(x + w - 2, y + h - 1), _RGBA32(0, 0, 0, 30), BF
    LINE (x + 1, y)-(x + w - 2, y + h - 1), _RGB32(70, 70, 70), B
    COLOR _RGB32(255, 255, 255)
    _PRINTSTRING (x + (w - 8 * LEN(label)) \ 2, y + (h - 16) \ 2), label
    IF over AND pressEdge THEN ui_button = -1
END FUNCTION


FUNCTION ui_slider# (id AS LONG, x AS LONG, y AS LONG, w AS LONG, value AS DOUBLE, lo AS DOUBLE, hi AS DOUBLE, enabled AS INTEGER)
    DIM v AS DOUBLE, kx AS LONG, over AS INTEGER, kc AS _UNSIGNED LONG
    v = value
    over = (mx >= x - 8 AND mx <= x + w + 8 AND my >= y - 2 AND my < y + 15)
    IF enabled THEN
        IF over AND pressEdge AND dragId = 0 THEN dragId = id
        IF over AND rpressEdge AND dragId = 0 THEN resetId = id
        IF dragId = id THEN
            v = lo + (mx - x) / w * (hi - lo)
            IF v < lo THEN v = lo
            IF v > hi THEN v = hi
        END IF
    END IF
    LINE (x, y + 3)-(x + w, y + 11), cTrack, BF
    IF lo < 0 THEN LINE (x + w \ 2, y + 3)-(x + w \ 2, y + 11), _RGB32(90, 90, 90)
    kx = x + CLNG((v - lo) / (hi - lo) * w)
    IF enabled THEN kc = cOrange ELSE kc = cDim
    fill_circle kx, y + 7, 7, _RGB32(60, 60, 60)
    fill_circle kx, y + 7, 5, kc
    ui_slider = v
END FUNCTION


SUB fill_circle (cx AS LONG, cy AS LONG, r AS LONG, c AS _UNSIGNED LONG)
    DIM dy AS LONG, dx AS LONG
    FOR dy = -r TO r
        dx = INT(SQR(r * r - dy * dy))
        LINE (cx - dx, cy + dy)-(cx + dx, cy + dy), c
    NEXT
END SUB


FUNCTION fmtnum$ (x AS DOUBLE, d AS LONG)
    fmtnum = SFXR_Fixed(ABS(x), d)
    IF x < 0 THEN fmtnum = "-" + SFXR_Fixed(ABS(x), d)
END FUNCTION

'$INCLUDE:'../PC-SPEAKER/PCSPKR.BM'
'$INCLUDE:'../PCSFXR/SFXR.BM'
