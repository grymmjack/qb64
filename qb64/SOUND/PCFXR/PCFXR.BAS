''
' PCFXR.BAS - sfxr for the PC speaker
'
' A QB64-PE take on sfxr.me (jsfxr): roll random game sound effects, tweak
' them with sliders, and hear them the way a DOS PC would play them:
'
'   Beeper  sfxr's pitch engine sampled at a tick rate (140 Hz like Duke
'           Nukem 1 and Commander Keen) and played as PIT divisors through
'           the emulated PC speaker. Export it as a Duke/Keen .SND bank, a
'           ready-to-run .BAS program, or a .WAV.
'   PWM     the full sfxr waveform played through the 1-bit speaker with
'           pulse width modulation - the RealSound / demo scene trick.
'   sfxr    the original sfxr sound, for comparison.
'
' Sounds load and save as jsfxr .json files and sfxr.me links, so you can
' design a sound on https://sfxr.me and paste it here, or the other way round.
'
' Mouse: click buttons, drag sliders, right-click a slider to reset it.
' Keys:  Space play, Ctrl+C copy sfxr.me link, Ctrl+V paste link/json, Esc quit
' Drop a .json file on the window to load it.
'
OPTION _EXPLICIT
'$INCLUDE:'../PC-SPEAKER/PCSPKR.BI'
'$INCLUDE:'SFXR.BI'

CONST SCR_W = 1190
CONST SCR_H = 800

CONST LEFT_X = 16
CONST LEFT_W = 172
CONST MID_X = 212
CONST MID_W = 596
CONST TRACK_W = 190
CONST RIGHT_X = 832
CONST RIGHT_W = 342
CONST COL_Y = 84

CONST PLOT_Y = 432
CONST PLOT_H = 128
CONST PLOT_N = 342

CONST ID_GAIN = 100
CONST ID_GATE = 101

' --- UI input state (immediate-mode GUI) ---
DIM SHARED mx AS LONG, my AS LONG, mb AS INTEGER, mb2 AS INTEGER
DIM SHARED pressEdge AS INTEGER, rpressEdge AS INTEGER
DIM SHARED dragId AS LONG, releasedId AS LONG, resetId AS LONG

' --- app state ---
DIM SHARED snd AS LONG
DIM SHARED sndName AS STRING
DIM SHARED statusMsg AS STRING
DIM SHARED statusUntil AS DOUBLE
DIM SHARED coneLP AS INTEGER
DIM SHARED needRender AS INTEGER
DIM SHARED playAfter AS INTEGER
DIM SHARED quitApp AS INTEGER
REDIM SHARED bankName(0 TO 15) AS STRING
REDIM SHARED bankData(0 TO 15) AS STRING
DIM SHARED bankCount AS LONG
DIM SHARED plotMin(0 TO PLOT_N - 1) AS SINGLE
DIM SHARED plotMax(0 TO PLOT_N - 1) AS SINGLE
DIM SHARED logoImg AS LONG, logoShadow AS LONG

' colours
DIM SHARED cBg AS _UNSIGNED LONG, cText AS _UNSIGNED LONG, cDim AS _UNSIGNED LONG
DIM SHARED cBtn AS _UNSIGNED LONG, cBtnHi AS _UNSIGNED LONG, cOrange AS _UNSIGNED LONG
DIM SHARED cGreen AS _UNSIGNED LONG, cTrack AS _UNSIGNED LONG, cLine AS _UNSIGNED LONG
DIM SHARED cBlue AS _UNSIGNED LONG

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
cBlue = _RGB32(20, 40, 230)

SCREEN _NEWIMAGE(SCR_W, SCR_H, 32)
_TITLE "PCFXR - sfxr for the PC speaker"
_ACCEPTFILEDROP ON
_PRINTMODE _KEEPBACKGROUND
make_logo

SFXR_Init
coneLP = 0
apply_cone
sndName = "pickupCoin"
SFXR_Preset sndName
needRender = -1
playAfter = 0

DO
    ' ------------------------------------------------------------- input
    ' presses are caught inside the event queue so a quick click that goes
    ' down and up between two frames still counts
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
        mx = pressX
        my = pressY
    ELSE
        mx = _MOUSEX
        my = _MOUSEY
    END IF
    releasedId = 0
    resetId = 0
    IF NOT mb AND dragId <> 0 THEN releasedId = dragId: dragId = 0

    ' ------------------------------------------------------------- draw
    CLS , cBg
    draw_header
    draw_generators
    draw_settings
    draw_speaker

    IF releasedId <> 0 OR resetId <> 0 THEN needRender = -1: playAfter = -1

    ' ---------------------------------------------------------- keyboard
    k = _KEYHIT
    SELECT CASE k
        CASE 32: play_sound
        CASE 3: copy_link '                     Ctrl+C
        CASE 22: paste_any '                    Ctrl+V
        CASE 27: quitApp = -1
    END SELECT

    IF _TOTALDROPPEDFILES THEN
        f = _DROPPEDFILE
        _FINISHDROP
        load_json_file f
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
' Sound
'-----------------------------------------------------------------------------

SUB render_sound
    DIM i AS LONG, n AS LONG, a AS LONG, b AS LONG, j AS LONG, v AS SINGLE, pk AS DOUBLE
    IF snd > 0 THEN _SNDSTOP snd: _SNDCLOSE snd
    apply_cone
    snd = SFXR_Render

    ' waveform overview for the plot. PWM shows the wave being modulated
    ' (the raw output is mostly the carrier, a solid block).
    IF sfxr_outMode = SFXR_MODE_PWM THEN
        n = sfxr_pcmN
        pk = SFXR_Peak
        IF pk < 0.000001 THEN pk = 1
    ELSE
        n = SFXR_OutFrames
    END IF
    FOR i = 0 TO PLOT_N - 1
        plotMin(i) = 0
        plotMax(i) = 0
        IF n > 0 THEN
            a = (i * n) \ PLOT_N
            b = ((i + 1) * n) \ PLOT_N
            IF b <= a THEN b = a + 1
            IF b > n THEN b = n
            FOR j = a TO b - 1
                IF sfxr_outMode = SFXR_MODE_PWM THEN v = sfxr_pcm(j) / pk ELSE v = SFXR_OutSample(j)
                IF v < plotMin(i) THEN plotMin(i) = v
                IF v > plotMax(i) THEN plotMax(i) = v
            NEXT
        END IF
    NEXT
END SUB


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


SUB generate (kind AS STRING)
    SFXR_Preset kind
    sndName = kind
    needRender = -1
    playAfter = -1
END SUB


'-----------------------------------------------------------------------------
' Header
'-----------------------------------------------------------------------------

SUB make_logo
    logoImg = logo_text(_RGB32(243, 140, 18))
    logoShadow = logo_text(_RGB32(20, 20, 20))
END SUB


FUNCTION logo_text& (c AS _UNSIGNED LONG)
    DIM img AS LONG
    img = _NEWIMAGE(48, 16, 32)
    _DEST img
    CLS , _RGBA32(0, 0, 0, 0)
    _PRINTMODE _KEEPBACKGROUND
    COLOR c
    _PRINTSTRING (4, 0), "pcfxr"
    _DEST 0
    logo_text = img
END FUNCTION


SUB draw_header
    ' chunky 4x logo with a drop shadow
    _PUTIMAGE (LEFT_X + 3, 9)-(LEFT_X + 3 + 192, 9 + 64), logoShadow
    _PUTIMAGE (LEFT_X - 2, 4)-(LEFT_X - 2 + 192, 4 + 64), logoImg
    COLOR cText
    _PRINTSTRING (LEFT_X + 210, 20), "sfxr for the PC speaker - a QB64-PE take on sfxr.me (jsfxr)"
    COLOR _RGB32(110, 110, 110)
    _PRINTSTRING (LEFT_X + 210, 40), "Roll a sound, tweak it, hear it the way a DOS PC would. No sound card required."
END SUB


'-----------------------------------------------------------------------------
' Left column: generators
'-----------------------------------------------------------------------------

SUB draw_generators
    DIM y AS LONG
    title LEFT_X, LEFT_W, "Generator"
    y = COL_Y + 24
    IF ui_button(LEFT_X, y, LEFT_W, 26, "Random", 0) THEN generate "random"
    y = y + 44
    IF ui_button(LEFT_X, y, LEFT_W, 26, "Pickup/coin", 0) THEN generate "pickupCoin"
    y = y + 30: IF ui_button(LEFT_X, y, LEFT_W, 26, "Laser/shoot", 0) THEN generate "laserShoot"
    y = y + 30: IF ui_button(LEFT_X, y, LEFT_W, 26, "Explosion", 0) THEN generate "explosion"
    y = y + 30: IF ui_button(LEFT_X, y, LEFT_W, 26, "Powerup", 0) THEN generate "powerUp"
    y = y + 30: IF ui_button(LEFT_X, y, LEFT_W, 26, "Hit/hurt", 0) THEN generate "hitHurt"
    y = y + 30: IF ui_button(LEFT_X, y, LEFT_W, 26, "Jump", 0) THEN generate "jump"
    y = y + 30: IF ui_button(LEFT_X, y, LEFT_W, 26, "Click", 0) THEN generate "click"
    y = y + 30: IF ui_button(LEFT_X, y, LEFT_W, 26, "Blip/select", 0) THEN generate "blipSelect"
    y = y + 30: IF ui_button(LEFT_X, y, LEFT_W, 26, "Synth", 0) THEN generate "synth"
    y = y + 30: IF ui_button(LEFT_X, y, LEFT_W, 26, "Tone", 0) THEN generate "tone"
    y = y + 44
    IF ui_button(LEFT_X, y, LEFT_W, 26, "Mutate", 0) THEN
        SFXR_Mutate
        needRender = -1
        playAfter = -1
    END IF
    y = y + 40
    IF ui_button(LEFT_X, y, LEFT_W, 30, "Play", 2) THEN play_sound

    COLOR _RGB32(110, 110, 110)
    y = y + 50
    _PRINTSTRING (LEFT_X, y), "Space    play"
    _PRINTSTRING (LEFT_X, y + 16), "Ctrl+C   copy link"
    _PRINTSTRING (LEFT_X, y + 32), "Ctrl+V   paste link"
    _PRINTSTRING (LEFT_X, y + 48), "R-click  reset slider"
    _PRINTSTRING (LEFT_X, y + 64), "Esc      quit"
    COLOR _RGB32(150, 150, 150)
    _PRINTSTRING (LEFT_X, y + 96), "Sound: " + sndName
END SUB


'-----------------------------------------------------------------------------
' Middle column: wave type + all the sfxr sliders
'-----------------------------------------------------------------------------

SUB draw_settings
    DIM y AS LONG, bw AS LONG, i AS LONG, isBeep AS INTEGER

    title MID_X, MID_W, "Manual Settings"
    bw = MID_W \ 4
    y = COL_Y + 24
    IF ui_button(MID_X, y, bw, 28, "Square", -(sfxr_p(0) = SFXR_SQUARE)) THEN set_wave SFXR_SQUARE
    IF ui_button(MID_X + bw, y, bw, 28, "Sawtooth", -(sfxr_p(0) = SFXR_SAWTOOTH)) THEN set_wave SFXR_SAWTOOTH
    IF ui_button(MID_X + bw * 2, y, bw, 28, "Sine", -(sfxr_p(0) = SFXR_SINE)) THEN set_wave SFXR_SINE
    IF ui_button(MID_X + bw * 3, y, MID_W - bw * 3, 28, "Noise", -(sfxr_p(0) = SFXR_NOISE)) THEN set_wave SFXR_NOISE

    isBeep = (sfxr_mode = SFXR_MODE_BEEPER)
    IF isBeep THEN
        COLOR _RGB32(150, 90, 0)
        IF sfxr_p(0) = SFXR_NOISE THEN
            _PRINTSTRING (MID_X, y + 34), "Beeper: noise = a random pitch every tick (DOS explosion style)"
        ELSE
            _PRINTSTRING (MID_X, y + 34), "Beeper: the PC speaker only plays square waves at 50% duty"
        END IF
    END IF

    y = COL_Y + 80
    y = section(y, "Envelope", 0)
    FOR i = SP_ATTACK TO SP_DECAY: y = param_row(y, i): NEXT
    y = section(y, "Frequency", 0)
    FOR i = SP_BASE_FREQ TO SP_FREQ_DRAMP: y = param_row(y, i): NEXT
    y = section(y, "Vibrato", 0)
    FOR i = SP_VIB_STRENGTH TO SP_VIB_SPEED: y = param_row(y, i): NEXT
    y = section(y, "Arpeggiation", 0)
    FOR i = SP_ARP_MOD TO SP_ARP_SPEED: y = param_row(y, i): NEXT
    y = section(y, "Duty Cycle", isBeep)
    FOR i = SP_DUTY TO SP_DUTY_RAMP: y = param_row(y, i): NEXT
    y = section(y, "Retrigger", 0)
    y = param_row(y, SP_REPEAT_SPEED)
    y = section(y, "Flanger", isBeep)
    FOR i = SP_PHA_OFFSET TO SP_PHA_RAMP: y = param_row(y, i): NEXT
    y = section(y, "Low-Pass Filter", isBeep)
    FOR i = SP_LPF_FREQ TO SP_LPF_RESONANCE: y = param_row(y, i): NEXT
    y = section(y, "High-Pass Filter", isBeep)
    FOR i = SP_HPF_FREQ TO SP_HPF_RAMP: y = param_row(y, i): NEXT
END SUB


SUB set_wave (w AS LONG)
    sfxr_p(0) = w
    needRender = -1
    playAfter = -1
END SUB


FUNCTION section& (y AS LONG, label AS STRING, notOnBeeper AS INTEGER)
    DIM yy AS LONG
    yy = y + 4
    LINE (MID_X + 8 * LEN(label) + 8, yy + 8)-(MID_X + MID_W, yy + 8), cLine
    COLOR cText
    _PRINTSTRING (MID_X, yy), label
    _PRINTSTRING (MID_X + 1, yy), label ' bold
    IF notOnBeeper THEN
        COLOR _RGB32(150, 90, 0)
        LINE (MID_X + MID_W - 200, yy)-(MID_X + MID_W, yy + 15), cBg, BF
        _PRINTSTRING (MID_X + MID_W - 192, yy), "PWM / sfxr modes only"
    END IF
    section = yy + 20
END FUNCTION


FUNCTION param_row& (y AS LONG, i AS LONG)
    DIM en AS INTEGER, lo AS DOUBLE, s AS STRING, v AS DOUBLE
    en = (sfxr_mode <> SFXR_MODE_BEEPER) OR SFXR_BeeperUses(i)
    IF sfxr_signed(i) THEN lo = -1 ELSE lo = 0
    v = ui_slider(i, MID_X + 6, y, TRACK_W, sfxr_p(i), lo, 1, en)
    IF resetId = i THEN v = SFXR_Default(i)
    sfxr_p(i) = v

    IF en THEN COLOR cText ELSE COLOR cDim
    _PRINTSTRING (MID_X + TRACK_W + 24, y), sfxr_label(i)
    s = SFXR_ParamText(i)
    _PRINTSTRING (MID_X + MID_W - 8 * LEN(s), y), s
    param_row = y + 18
END FUNCTION


'-----------------------------------------------------------------------------
' Right column: PC speaker settings, stats, plot, export
'-----------------------------------------------------------------------------

SUB draw_speaker
    DIM y AS LONG, bw AS LONG, x AS LONG, s AS STRING, v AS DOUBLE

    title RIGHT_X, RIGHT_W, "PC Speaker"
    y = COL_Y + 24
    IF ui_button(RIGHT_X, y, RIGHT_W, 28, "Play", 2) THEN play_sound

    ' mode
    y = y + 44
    COLOR cText
    _PRINTSTRING (RIGHT_X, y), "Mode"
    y = y + 18
    bw = RIGHT_W \ 3
    IF ui_button(RIGHT_X, y, bw, 28, "Beeper", -(sfxr_mode = SFXR_MODE_BEEPER)) THEN set_mode SFXR_MODE_BEEPER
    IF ui_button(RIGHT_X + bw, y, bw, 28, "PWM", -(sfxr_mode = SFXR_MODE_PWM)) THEN set_mode SFXR_MODE_PWM
    IF ui_button(RIGHT_X + bw * 2, y, RIGHT_W - bw * 2, 28, "sfxr", -(sfxr_mode = SFXR_MODE_CLEAN)) THEN set_mode SFXR_MODE_CLEAN

    ' mode settings
    y = y + 40
    bw = RIGHT_W \ 4
    COLOR cText
    SELECT CASE sfxr_mode
        CASE SFXR_MODE_BEEPER
            _PRINTSTRING (RIGHT_X, y), "Tick rate (Hz) - 140 = Duke / Keen"
            y = y + 18
            IF ui_button(RIGHT_X, y, bw, 28, "70", -(sfxr_tickHz = 70)) THEN set_tick 70
            IF ui_button(RIGHT_X + bw, y, bw, 28, "140", -(sfxr_tickHz = 140)) THEN set_tick 140
            IF ui_button(RIGHT_X + bw * 2, y, bw, 28, "280", -(sfxr_tickHz = 280)) THEN set_tick 280
            IF ui_button(RIGHT_X + bw * 3, y, RIGHT_W - bw * 3, 28, "560", -(sfxr_tickHz = 560)) THEN set_tick 560
            y = y + 38
            v = ui_slider(ID_GATE, RIGHT_X + 6, y, 160, sfxr_gate, 0, 1, -1)
            IF resetId = ID_GATE THEN v = 0.1
            sfxr_gate = v
            COLOR cText
            _PRINTSTRING (RIGHT_X + 180, y), "Gate" + STR$(CLNG(sfxr_gate * 100)) + "%"
        CASE SFXR_MODE_PWM
            _PRINTSTRING (RIGHT_X, y), "PWM carrier (Hz)"
            y = y + 18
            IF ui_button(RIGHT_X, y, bw, 28, "8k", -(sfxr_pwmHz = 8000)) THEN set_pwm 8000
            IF ui_button(RIGHT_X + bw, y, bw, 28, "11k", -(sfxr_pwmHz = 11025)) THEN set_pwm 11025
            IF ui_button(RIGHT_X + bw * 2, y, bw, 28, "16k", -(sfxr_pwmHz = 16000)) THEN set_pwm 16000
            IF ui_button(RIGHT_X + bw * 3, y, RIGHT_W - bw * 3, 28, "22k", -(sfxr_pwmHz = 22050)) THEN set_pwm 22050
            y = y + 38
            COLOR cText
            _PRINTSTRING (RIGHT_X, y), "Pulse widths: 1-" + LTRIM$(STR$(SFXR_PWMDivisor - 1)) + " PIT clocks (" + fmtnum(SFXR_PWMBits, 1) + " bits)"
        CASE ELSE
            _PRINTSTRING (RIGHT_X, y), "The original sfxr sound, no PC speaker."
            _PRINTSTRING (RIGHT_X, y + 18), "Compare it with Beeper and PWM."
            y = y + 56
    END SELECT

    ' gain
    y = y + 30
    v = ui_slider(ID_GAIN, RIGHT_X + 6, y, 160, sfxr_vol, 0, 1, -1)
    IF resetId = ID_GAIN THEN v = 0.25
    sfxr_vol = v
    COLOR cText
    _PRINTSTRING (RIGHT_X + 180, y), "Gain " + SFXR_GainText

    ' speaker cone
    y = y + 26
    IF sfxr_mode <> SFXR_MODE_CLEAN THEN
        IF coneLP THEN s = "Speaker cone filter: ON" ELSE s = "Speaker cone filter: OFF"
        IF ui_button(RIGHT_X, y, RIGHT_W, 24, s, -(coneLP <> 0)) THEN
            coneLP = NOT coneLP
            needRender = -1
            playAfter = -1
        END IF
    END IF

    ' stats
    y = y + 36
    COLOR cText
    _PRINTSTRING (RIGHT_X, y), "Duration: " + fmtnum(SFXR_Seconds, 3) + " sec"
    SELECT CASE sfxr_outMode
        CASE SFXR_MODE_BEEPER
            _PRINTSTRING (RIGHT_X, y + 16), "Ticks:" + STR$(sfxr_divN) + " (" + LTRIM$(STR$(sfxr_divN * 2 + 2)) + " bytes as IFS)"
        CASE SFXR_MODE_PWM
            _PRINTSTRING (RIGHT_X, y + 16), "Pulses:" + STR$(INT(sfxr_pcmN / (SFXR_RATE * SFXR_PWMDivisor / PCSPK_PIT_HZ)))
        CASE ELSE
            _PRINTSTRING (RIGHT_X, y + 16), "Samples:" + STR$(sfxr_pcmN) + "   Clipped:" + STR$(sfxr_clipped)
    END SELECT
    COLOR _RGB32(110, 110, 110)
    _PRINTSTRING (RIGHT_X, y + 32), "Bank:" + STR$(bankCount) + " sound(s)"

    draw_plot

    ' export
    y = PLOT_Y + PLOT_H + 14
    bw = RIGHT_W \ 2
    x = RIGHT_X + bw
    IF ui_button(RIGHT_X, y, bw - 2, 26, "Save .WAV", 0) THEN export_wav
    IF ui_button(x, y, RIGHT_W - bw, 26, "Save 8-bit WAV", 0) THEN export_wav8
    y = y + 30
    IF ui_button(RIGHT_X, y, bw - 2, 26, "Export .BAS", 0) THEN export_bas
    IF ui_button(x, y, RIGHT_W - bw, 26, "Copy .BAS code", 0) THEN
        _CLIPBOARD$ = SFXR_BasCode(sndName)
        set_status "QB64-PE code copied to the clipboard"
    END IF
    y = y + 30
    IF ui_button(RIGHT_X, y, bw - 2, 26, "Export .SND", 0) THEN export_snd
    IF ui_button(x, y, RIGHT_W - bw, 26, "Add to bank", 0) THEN bank_add
    y = y + 30
    IF ui_button(RIGHT_X, y, bw - 2, 26, "Save bank .SND", 0) THEN bank_save
    IF ui_button(x, y, RIGHT_W - bw, 26, "Clear bank", 0) THEN bankCount = 0: set_status "Bank cleared"
    y = y + 30
    IF ui_button(RIGHT_X, y, bw - 2, 26, "Save .json", 0) THEN export_json
    IF ui_button(x, y, RIGHT_W - bw, 26, "Load .json", 0) THEN load_json_dialog
    y = y + 30
    IF ui_button(RIGHT_X, y, bw - 2, 26, "Copy sfxr.me link", 0) THEN copy_link
    IF ui_button(x, y, RIGHT_W - bw, 26, "Paste link/json", 0) THEN paste_any

    ' status line
    IF LEN(statusMsg) THEN
        IF TIMER(0.001) < statusUntil AND TIMER(0.001) > statusUntil - 10 THEN
            COLOR cGreen
            _PRINTSTRING (MID_X, SCR_H - 22), statusMsg
        ELSE
            statusMsg = ""
        END IF
    END IF
END SUB


SUB set_mode (m AS INTEGER)
    sfxr_mode = m
    needRender = -1
    playAfter = -1
END SUB


SUB set_tick (hz AS DOUBLE)
    sfxr_tickHz = hz
    needRender = -1
    playAfter = -1
END SUB


SUB set_pwm (hz AS LONG)
    sfxr_pwmHz = hz
    needRender = -1
    playAfter = -1
END SUB


''
' Beeper: pitch over time, one step per tick (like DN1PLAY).
' PWM / sfxr: the waveform. White line = play position.
'
SUB draw_plot
    DIM i AS LONG, x0 AS LONG, x1 AS LONG, fy AS LONG, prevY AS LONG, n AS LONG, cy AS LONG
    DIM t AS DOUBLE, secs AS DOUBLE

    LINE (RIGHT_X, PLOT_Y)-(RIGHT_X + RIGHT_W, PLOT_Y + PLOT_H), _RGB32(20, 22, 30), BF
    n = sfxr_divN
    IF sfxr_outMode = SFXR_MODE_BEEPER THEN
        ' octave lines at 100 Hz, 1 kHz, 10 kHz
        FOR i = 2 TO 4
            fy = plot_freq_y(10 ^ i)
            LINE (RIGHT_X, fy)-(RIGHT_X + RIGHT_W, fy), _RGB32(45, 50, 65)
        NEXT
        prevY = -1
        FOR i = 0 TO n - 1
            x0 = RIGHT_X + (i * RIGHT_W) \ n
            x1 = RIGHT_X + ((i + 1) * RIGHT_W) \ n
            IF x1 <= x0 THEN x1 = x0 + 1
            IF sfxr_div(i) > 0 THEN
                fy = plot_freq_y(PCSPK_PIT_HZ / sfxr_div(i))
                IF prevY >= 0 THEN LINE (x0, prevY)-(x0, fy), _RGB32(120, 80, 20)
                LINE (x0, fy - 1)-(x1, fy + 1), cOrange, BF
                prevY = fy
            ELSE
                LINE (x0, PLOT_Y + PLOT_H - 3)-(x1, PLOT_Y + PLOT_H - 1), _RGB32(80, 90, 110), BF
                prevY = -1
            END IF
        NEXT
        COLOR _RGB32(110, 120, 140)
        _PRINTSTRING (RIGHT_X + 4, plot_freq_y(1000) - 16), "1k"
        _PRINTSTRING (RIGHT_X + 4, plot_freq_y(100) - 16), "100"
    ELSE
        cy = PLOT_Y + PLOT_H \ 2
        LINE (RIGHT_X, cy)-(RIGHT_X + RIGHT_W, cy), _RGB32(45, 50, 65)
        FOR i = 0 TO PLOT_N - 1
            LINE (RIGHT_X + i, cy - plot_amp(plotMax(i)))-(RIGHT_X + i, cy - plot_amp(plotMin(i))), cOrange
        NEXT
    END IF

    ' playhead
    secs = SFXR_Seconds
    IF snd > 0 AND secs > 0 THEN
        IF _SNDPLAYING(snd) THEN
            t = _SNDGETPOS(snd) / secs
            IF t > 1 THEN t = 1
            x0 = RIGHT_X + CLNG(t * RIGHT_W)
            LINE (x0, PLOT_Y + 1)-(x0, PLOT_Y + PLOT_H - 1), _RGB32(255, 255, 255)
        END IF
    END IF
    LINE (RIGHT_X, PLOT_Y)-(RIGHT_X + RIGHT_W, PLOT_Y + PLOT_H), _RGB32(120, 120, 120), B
END SUB


FUNCTION plot_freq_y& (hz AS DOUBLE)
    DIM f AS DOUBLE, t AS DOUBLE
    f = hz
    IF f < 30 THEN f = 30
    IF f > 15000 THEN f = 15000
    t = LOG(f / 30) / LOG(15000 / 30)
    plot_freq_y = PLOT_Y + PLOT_H - 4 - CLNG(t * (PLOT_H - 8))
END FUNCTION


FUNCTION plot_amp& (v AS SINGLE)
    DIM a AS DOUBLE
    a = v
    IF sfxr_outMode = SFXR_MODE_BEEPER THEN a = a / (SFXR_SpeakerVolume + 0.0001) * 0.5
    IF a > 1 THEN a = 1
    IF a < -1 THEN a = -1
    plot_amp = CLNG(a * (PLOT_H \ 2 - 3))
END FUNCTION


'-----------------------------------------------------------------------------
' Export / import
'-----------------------------------------------------------------------------

FUNCTION export_path$ (ext AS STRING)
    IF NOT _DIREXISTS("EXPORT") THEN MKDIR "EXPORT"
    export_path = "EXPORT/" + SFXR_SafeName(sndName) + ext
END FUNCTION


SUB export_wav
    DIM f AS STRING
    f = export_path(".wav")
    SFXR_SaveWAV f
    set_status "Saved " + f
END SUB


SUB export_wav8
    DIM f AS STRING
    f = export_path("-8bit.wav")
    SFXR_Save8BitWAV f, 8000
    set_status "Saved " + f + " (8 kHz 8-bit - plays in PC-SPEAKER/WAV.BAS)"
END SUB


SUB export_bas
    DIM f AS STRING
    f = export_path(".bas")
    SFXR_SaveText f, SFXR_BasCode(sndName)
    set_status "Saved " + f + " - put PCSPKR.BI/.BM next to it"
END SUB


SUB export_snd
    DIM f AS STRING, d AS STRING
    REDIM nm(0) AS STRING, dt(0) AS STRING
    nm(0) = sndName
    dt(0) = SFXR_DivisorData
    d = SFXR_BuildIFS(nm(), dt(), 1)
    IF d = "" THEN set_status "Too long for an IFS file": EXIT SUB
    f = export_path(".snd")
    SFXR_SaveText f, d
    set_status "Saved " + f + " - opens in DN1PLAY"
END SUB


SUB bank_add
    IF bankCount > UBOUND(bankName) THEN
        REDIM _PRESERVE bankName(0 TO bankCount * 2) AS STRING
        REDIM _PRESERVE bankData(0 TO bankCount * 2) AS STRING
    END IF
    bankName(bankCount) = LEFT$(UCASE$(SFXR_SafeName(sndName)), 8) + LTRIM$(STR$(bankCount + 1))
    bankData(bankCount) = SFXR_DivisorData
    bankCount = bankCount + 1
    set_status "Added " + bankName(bankCount - 1) + " to the bank (" + LTRIM$(STR$(bankCount)) + " sounds)"
END SUB


SUB bank_save
    DIM d AS STRING
    IF bankCount = 0 THEN set_status "The bank is empty - use Add to bank first": EXIT SUB
    d = SFXR_BuildIFS(bankName(), bankData(), bankCount)
    IF d = "" THEN set_status "Bank is over 64K - IFS can't hold it": EXIT SUB
    IF NOT _DIREXISTS("EXPORT") THEN MKDIR "EXPORT"
    SFXR_SaveText "EXPORT/PCFXR.SND", d
    set_status "Saved EXPORT/PCFXR.SND (" + LTRIM$(STR$(bankCount)) + " sounds) - opens in DN1PLAY"
END SUB


SUB export_json
    DIM f AS STRING
    f = export_path(".json")
    SFXR_SaveText f, SFXR_ToJSON
    set_status "Saved " + f + " - loads on sfxr.me too"
END SUB


SUB load_json_dialog
    DIM f AS STRING
    f = _OPENFILEDIALOG$("Load sfxr .json", "", "*.json|*.JSON", "sfxr sound (.json)")
    IF LEN(f) THEN load_json_file f
END SUB


SUB load_json_file (f AS STRING)
    DIM t AS STRING, p AS LONG
    t = PCSPK_ReadFile(f)
    IF SFXR_Import(t) THEN
        sndName = PCSPK_FilePart(f)
        p = _INSTRREV(sndName, ".")
        IF p > 1 THEN sndName = LEFT$(sndName, p - 1)
        needRender = -1
        playAfter = -1
        set_status "Loaded " + f
    ELSE
        set_status "Not an sfxr .json: " + f
    END IF
END SUB


SUB copy_link
    _CLIPBOARD$ = "https://sfxr.me/#" + SFXR_ToB58
    set_status "sfxr.me link copied to the clipboard"
END SUB


SUB paste_any
    DIM t AS STRING
    t = _CLIPBOARD$
    IF SFXR_Import(t) THEN
        sndName = "pasted"
        needRender = -1
        playAfter = -1
        set_status "Loaded from the clipboard"
    ELSE
        set_status "Clipboard has no sfxr.me link, code or .json"
    END IF
END SUB


SUB set_status (msg AS STRING)
    statusMsg = msg
    statusUntil = TIMER(0.001) + 5
END SUB


'-----------------------------------------------------------------------------
' Immediate-mode widgets
'-----------------------------------------------------------------------------

SUB title (x AS LONG, w AS LONG, s AS STRING)
    COLOR cText
    _PRINTSTRING (x + (w - 8 * LEN(s)) \ 2, COL_Y), s
    _PRINTSTRING (x + (w - 8 * LEN(s)) \ 2 + 1, COL_Y), s
END SUB


''
' Draw a button; returns TRUE when it was clicked this frame.
' style: 0 = grey, 1 = selected (orange), 2 = green (play)
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


''
' Draw a slider and handle dragging it. Returns the (possibly new) value.
' Sets releasedId when a drag ends and resetId on right-click.
'
FUNCTION ui_slider# (id AS LONG, x AS LONG, y AS LONG, w AS LONG, value AS DOUBLE, lo AS DOUBLE, hi AS DOUBLE, enabled AS INTEGER)
    DIM v AS DOUBLE, kx AS LONG, over AS INTEGER, kc AS _UNSIGNED LONG
    v = value
    over = (mx >= x - 8 AND mx <= x + w + 8 AND my >= y - 2 AND my < y + 16)
    IF enabled THEN
        IF over AND pressEdge AND dragId = 0 THEN dragId = id
        IF over AND rpressEdge AND dragId = 0 THEN resetId = id
        IF dragId = id THEN
            v = lo + (mx - x) / w * (hi - lo)
            IF v < lo THEN v = lo
            IF v > hi THEN v = hi
        END IF
    END IF

    LINE (x, y + 3)-(x + w, y + 12), cTrack, BF
    IF lo < 0 THEN LINE (x + w \ 2, y + 3)-(x + w \ 2, y + 12), _RGB32(90, 90, 90)
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
'$INCLUDE:'SFXR.BM'
