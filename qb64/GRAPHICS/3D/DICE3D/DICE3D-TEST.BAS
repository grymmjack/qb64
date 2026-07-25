''
' DICE3D-TEST - interactive configurator / showcase for the DICE3D module.
'
' Number keys pick a die; letters toggle material / theme / pips / drop / wire /
' colour-target. UP/DOWN pick a setting, LEFT/RIGHT change it, ENTER types an
' exact value. Look changes preview instantly (no reroll); physics changes and
' SPACE reroll. Only the box region is drawn over.
'
' Dice mesh/UV/render approach adapted from Petr's dice.bas (this repo:
' qb64/_/Petr/dice.bas and qb64/_/QB64COM-SAMPLES/maptriangle-in-3d).
'
' @author Rick Christy <grymmjack@gmail.com>
'
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0: CONST TRUE = NOT FALSE
$END IF
_TITLE "DICE3D - Interactive Configurator"
RANDOMIZE TIMER

'$INCLUDE:'_ALL.BI'

TYPE THEME
    NM AS STRING * 9
    BODY AS _UNSIGNED LONG
    NUM AS _UNSIGNED LONG
    EDGE AS _UNSIGNED LONG
    BBACK AS _UNSIGNED LONG
    BLINE AS _UNSIGNED LONG
END TYPE

CONST BG = &HFF0078FF
CONST NPARAM = 20
CONST CANCEL = -1000000

DIM SHARED SCR AS LONG
SCR = _NEWIMAGE(940, 700, 32): SCREEN SCR

DIM SHARED cfg AS DICE3D_CONFIG
DIM SHARED theme(0 TO 5) AS THEME
DIM SHARED matName(0 TO 3) AS STRING, tgtName(0 TO 6) AS STRING
DIM SHARED dieType AS STRING, resultTxt AS STRING
DIM SHARED themeIdx AS INTEGER, dropOn AS INTEGER, selParam AS INTEGER, colTarget AS INTEGER
DIM SHARED diceCount AS INTEGER, liveFont AS LONG, liveFontPx AS INTEGER
DIM SHARED slot(0 TO 6) AS DICE3D_CONFIG
DIM SHARED setFile AS STRING, statusTxt AS STRING
DIM SHARED pName(0 TO NPARAM - 1) AS STRING
DIM SHARED pStep(0 TO NPARAM - 1) AS SINGLE
DIM SHARED pMin(0 TO NPARAM - 1) AS SINGLE
DIM SHARED pMax(0 TO NPARAM - 1) AS SINGLE

demo_init
demo_roll

IF ENVIRON$("DICE3D_SHOT_DIR") <> "" THEN
    demo_panel
    _SAVEIMAGE ENVIRON$("DICE3D_SHOT_DIR") + "/ui.png", SCR
    SYSTEM
END IF

DIM AS STRING k, ext
DIM AS INTEGER changed, needRoll, mx, my, mb, dragging, lastmx, lastmy
DIM AS SINGLE typed
demo_panel
DO
    '--- left-click drag inside the box orbits the camera (yaw + tilt) ---
    WHILE _MOUSEINPUT: WEND
    mx = _MOUSEX: my = _MOUSEY: mb = _MOUSEBUTTON(1)
    IF mb AND mx >= cfg.BOX_X AND mx <= cfg.BOX_X + cfg.BOX_W AND my >= cfg.BOX_Y AND my <= cfg.BOX_Y + cfg.BOX_H THEN
        IF dragging THEN
            cfg.CAM_YAW = cfg.CAM_YAW + (mx - lastmx) * 0.7
            cfg.CAM_TILT = dice3d_clampf(cfg.CAM_TILT - (my - lastmy) * 0.5, 0, 85)
            dice3d_repose cfg: demo_panel
        END IF
        dragging = -1: lastmx = mx: lastmy = my
    ELSE
        dragging = 0
    END IF

    k = INKEY$
    IF k = "" THEN _LIMIT 60: _CONTINUE
    IF k = CHR$(27) THEN EXIT DO
    changed = FALSE: needRoll = FALSE

    IF LEN(k) = 2 THEN
        ext = RIGHT$(k, 1)
        SELECT CASE ext
            CASE "H": selParam = (selParam + NPARAM - 1) MOD NPARAM
            CASE "P": selParam = (selParam + 1) MOD NPARAM
            CASE "K": demo_adjust -1: changed = TRUE: needRoll = demo_needroll%(selParam)
            CASE "M": demo_adjust 1: changed = TRUE: needRoll = demo_needroll%(selParam)
        END SELECT
    ELSEIF k = CHR$(13) THEN
        typed = demo_typeval!("Set " + pName(selParam) + " = ")
        IF typed > CANCEL THEN demo_paramset selParam, typed: changed = TRUE: needRoll = demo_needroll%(selParam)
    ELSE
        SELECT CASE UCASE$(k)
            CASE "4": demo_switchdie "d4": changed = TRUE: needRoll = TRUE
            CASE "6": demo_switchdie "d6": changed = TRUE: needRoll = TRUE
            CASE "8": demo_switchdie "d8": changed = TRUE: needRoll = TRUE
            CASE "0": demo_switchdie "d10": changed = TRUE: needRoll = TRUE
            CASE "Z": demo_switchdie "d12": changed = TRUE: needRoll = TRUE
            CASE "2": demo_switchdie "d20": changed = TRUE: needRoll = TRUE
            CASE "%": demo_switchdie "d100": changed = TRUE: needRoll = TRUE
            CASE "M": cfg.MATERIAL = (cfg.MATERIAL + 1) MOD 4: changed = TRUE
            CASE "C": themeIdx = (themeIdx + 1) MOD 6: demo_apply_theme: changed = TRUE
            CASE "P": cfg.D6_PIPS = NOT cfg.D6_PIPS: changed = TRUE
            CASE "W": cfg.WIRE_ENABLED = NOT cfg.WIRE_ENABLED: changed = TRUE
            CASE "K": colTarget = (colTarget + 1) MOD 7
            CASE "T": dropOn = NOT dropOn: changed = TRUE: needRoll = TRUE
            CASE "E": cfg.DROP_FX = (1 - cfg.DROP_FX): changed = TRUE
            CASE "A": demo_applyall: statusTxt = "applied to all dice"
            CASE "S": demo_saveset: statusTxt = "saved " + setFile
            CASE "L": demo_loadset: changed = TRUE: needRoll = TRUE: statusTxt = "loaded " + setFile
            CASE "V": demo_savetheme
            CASE "B": demo_loadtheme: changed = TRUE
            CASE " ": changed = TRUE: needRoll = TRUE
        END SELECT
    END IF

    IF changed THEN demo_syncfont
    IF dieType = "d100" AND changed THEN needRoll = TRUE
    IF changed THEN
        IF needRoll THEN demo_roll ELSE demo_bg: dice3d_repose cfg
    END IF
    demo_panel
    _LIMIT 60
LOOP
SYSTEM

'==============================================================================
SUB demo_init ()
    dice3d_config_defaults cfg
    cfg.BOX_X = 370: cfg.BOX_Y = 70: cfg.BOX_W = 380: cfg.BOX_H = 380
    cfg.DIE_SIZE = 56: cfg.NUM_SCALE = 0.4
    cfg.FONT_PX = 46: liveFontPx = -1: demo_syncfont
    diceCount = 4: dieType = "d6": dropOn = 0: selParam = 0: colTarget = 0: resultTxt = ""
    setFile = "diceset.txt": statusTxt = ""

    matName(0) = "Solid": matName(1) = "Crystal": matName(2) = "Marble": matName(3) = "Noise"
    tgtName(0) = "Body": tgtName(1) = "Number": tgtName(2) = "Edge": tgtName(3) = "Box bg"
    tgtName(4) = "Box line": tgtName(5) = "Marble": tgtName(6) = "Wire"

    demo_settheme 0, "Classic", _RGB32(235, 235, 240), _RGB32(20, 20, 30), _RGB32(60, 60, 70), _RGB32(0, 0, 90), _RGB32(120, 160, 255)
    demo_settheme 1, "Ruby", _RGB32(205, 45, 55), _RGB32(255, 240, 205), _RGB32(120, 12, 20), _RGB32(30, 0, 12), _RGB32(255, 120, 120)
    demo_settheme 2, "Emerald", _RGB32(30, 165, 95), _RGB32(240, 255, 240), _RGB32(10, 85, 45), _RGB32(0, 26, 16), _RGB32(120, 255, 180)
    demo_settheme 3, "Gold", _RGB32(232, 192, 64), _RGB32(60, 40, 0), _RGB32(140, 100, 12), _RGB32(26, 20, 0), _RGB32(255, 230, 120)
    demo_settheme 4, "Obsidian", _RGB32(38, 38, 48), _RGB32(230, 230, 255), _RGB32(95, 95, 125), _RGB32(10, 10, 18), _RGB32(150, 150, 205)
    demo_settheme 5, "Amethyst", _RGB32(150, 92, 212), _RGB32(245, 235, 255), _RGB32(80, 42, 132), _RGB32(20, 10, 36), _RGB32(200, 150, 255)
    themeIdx = 0: demo_apply_theme

    demo_setp 0, "Angle/tilt", 5, 0, 80
    demo_setp 1, "Die size", 4, 16, 120
    demo_setp 2, "Font px", 4, 16, 90
    demo_setp 3, "Dice count", 1, 1, 12
    demo_setp 4, "Box size", 20, 180, 500
    demo_setp 5, "Bevel", 0.1, 0, 1
    demo_setp 6, "Spin strength", 5, 0, 90
    demo_setp 7, "Shake strength", 1, 0, 24
    demo_setp 8, "Gravity", 0.15, 0.2, 3
    demo_setp 9, "Bounce", 0.05, 0, 0.95
    demo_setp 10, "Spin keep", 0.01, 0.8, 0.99
    demo_setp 11, "Red", 16, 0, 255
    demo_setp 12, "Green", 16, 0, 255
    demo_setp 13, "Blue", 16, 0, 255
    demo_setp 14, "Body alpha", 0.05, 0, 1
    demo_setp 15, "Tex opacity", 0.05, 0, 1
    demo_setp 16, "Crystal alpha", 0.05, 0, 1
    demo_setp 17, "Wire opacity", 0.05, 0, 1
    demo_setp 18, "FOV (0=ortho)", 5, 0, 55
    demo_setp 19, "Yaw (orbit)", 10, -180, 180

    IF ENVIRON$("DICE3D_ROLL") <> "" THEN dieType = ENVIRON$("DICE3D_ROLL")
    IF ENVIRON$("DICE3D_MAT") <> "" THEN cfg.MATERIAL = VAL(ENVIRON$("DICE3D_MAT"))
    IF ENVIRON$("DICE3D_THEME") <> "" THEN themeIdx = VAL(ENVIRON$("DICE3D_THEME")): demo_apply_theme
    IF ENVIRON$("DICE3D_TWEAK") <> "" THEN demo_scripted_tweaks
    IF ENVIRON$("DICE3D_FOV") <> "" THEN cfg.FOV = VAL(ENVIRON$("DICE3D_FOV"))
    IF ENVIRON$("DICE3D_YAW") <> "" THEN cfg.CAM_YAW = VAL(ENVIRON$("DICE3D_YAW"))
    IF ENVIRON$("DICE3D_TILT") <> "" THEN cfg.CAM_TILT = VAL(ENVIRON$("DICE3D_TILT"))
    IF ENVIRON$("DICE3D_FONTPX") <> "" THEN cfg.FONT_PX = VAL(ENVIRON$("DICE3D_FONTPX")): liveFontPx = -1: demo_syncfont
    '--- start every die's slot as a copy of the initial config ---
    DIM si AS INTEGER
    FOR si = 0 TO 6: slot(si) = cfg: slot(si).FONT_HANDLE = 0: NEXT
END SUB

'--- reload the live TTF only when the size changed; point cfg at it ----------
SUB demo_syncfont ()
    IF liveFontPx <> cfg.FONT_PX THEN
        IF liveFont > 0 THEN _FREEFONT liveFont
        IF cfg.FONT_PX >= 8 THEN liveFont = demo_loadfont&(cfg.FONT_PX) ELSE liveFont = 0
        liveFontPx = cfg.FONT_PX
    END IF
    cfg.FONT_HANDLE = liveFont
END SUB

FUNCTION demo_slot% (dt AS STRING)
    SELECT CASE dt
        CASE "d4": demo_slot% = 0
        CASE "d6": demo_slot% = 1
        CASE "d8": demo_slot% = 2
        CASE "d10": demo_slot% = 3
        CASE "d12": demo_slot% = 4
        CASE "d20": demo_slot% = 5
        CASE "d100": demo_slot% = 6
        CASE ELSE: demo_slot% = 1
    END SELECT
END FUNCTION

'--- switch die type, preserving each die's own settings in its slot ----------
SUB demo_switchdie (nt AS STRING)
    slot(demo_slot%(dieType)) = cfg: slot(demo_slot%(dieType)).FONT_HANDLE = 0
    dieType = nt
    cfg = slot(demo_slot%(dieType))
    demo_syncfont
END SUB

'--- type a short text string (for theme names) ------------------------------
FUNCTION demo_typestr$ (prompt AS STRING)
    DIM AS STRING s, k
    DIM AS INTEGER ry
    ry = cfg.BOX_Y + cfg.BOX_H + 40
    s = ""
    DO
        LINE (360, ry - 2)-(939, ry + 18), BG, BF
        COLOR _RGB32(255, 255, 120), _RGBA32(0, 0, 0, 0)
        _PRINTSTRING (366, ry), prompt + s + "_"
        _DISPLAY
        DO: k = INKEY$: _LIMIT 60: LOOP UNTIL k <> ""
        IF k = CHR$(13) THEN EXIT DO
        IF k = CHR$(27) THEN demo_typestr$ = "": EXIT FUNCTION
        IF k = CHR$(8) THEN
            IF LEN(s) > 0 THEN s = LEFT$(s, LEN(s) - 1)
        ELSEIF LEN(k) = 1 AND k >= " " THEN
            s = s + k
        END IF
    LOOP
    demo_typestr$ = s
END FUNCTION

'--- scripted look-tweaks for headless screenshots (DICE3D_TWEAK=orange etc) ---
SUB demo_scripted_tweaks ()
    SELECT CASE ENVIRON$("DICE3D_TWEAK")
        CASE "orange" '                   orange translucent body, white pips, wireframe
            cfg.BODY_KOLOR = _RGB32(255, 140, 0): cfg.NUM_KOLOR = _RGB32(255, 255, 255)
            cfg.BODY_ALPHA = 0.55: cfg.D6_PIPS = -1
            cfg.WIRE_ENABLED = -1: cfg.WIRE_KOLOR = _RGB32(255, 255, 255): cfg.WIRE_OPACITY = 0.6
        CASE "marble" '                   green-veined marble
            cfg.MATERIAL = DICE3D_MAT_MARBLE: cfg.BODY_KOLOR = _RGB32(240, 240, 235)
            cfg.MARBLE_KOLOR = _RGB32(20, 110, 60): cfg.TEX_OPACITY = 0.9
        CASE "crystal" '                  see-through crystal
            cfg.MATERIAL = DICE3D_MAT_CRYSTAL: cfg.BODY_KOLOR = _RGB32(120, 200, 255)
            cfg.CRYSTAL_ALPHA = 0.4: cfg.WIRE_ENABLED = -1: cfg.WIRE_KOLOR = _RGB32(200, 240, 255): cfg.WIRE_OPACITY = 0.5
    END SELECT
END SUB

SUB demo_setp (i AS INTEGER, nm AS STRING, st AS SINGLE, mn AS SINGLE, mx AS SINGLE)
    pName(i) = nm: pStep(i) = st: pMin(i) = mn: pMax(i) = mx
END SUB

SUB demo_settheme (idx AS INTEGER, nm AS STRING, bd AS _UNSIGNED LONG, nu AS _UNSIGNED LONG, ed AS _UNSIGNED LONG, bb AS _UNSIGNED LONG, bl AS _UNSIGNED LONG)
    theme(idx).NM = nm: theme(idx).BODY = bd: theme(idx).NUM = nu
    theme(idx).EDGE = ed: theme(idx).BBACK = bb: theme(idx).BLINE = bl
END SUB

SUB demo_apply_theme ()
    cfg.BODY_KOLOR = theme(themeIdx).BODY: cfg.NUM_KOLOR = theme(themeIdx).NUM
    cfg.EDGE_KOLOR = theme(themeIdx).EDGE
    cfg.BOX_BACK_KOLOR = theme(themeIdx).BBACK: cfg.BOX_OUTLINE_KOLOR = theme(themeIdx).BLINE
    cfg.PCT_HI_KOLOR = theme(themeIdx).BODY
    cfg.PCT_LO_KOLOR = dice3d_mix~&(theme(themeIdx).BODY, _RGB32(255, 120, 120), 0.5)
END SUB

FUNCTION demo_loadfont& (px AS INTEGER)
    DIM cand(0 TO 2) AS STRING
    DIM i AS INTEGER
    cand(0) = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
    cand(1) = "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf"
    cand(2) = "C:\Windows\Fonts\arialbd.ttf"
    FOR i = 0 TO 2
        IF _FILEEXISTS(cand(i)) THEN demo_loadfont& = _LOADFONT(cand(i), px, ""): EXIT FUNCTION
    NEXT
    demo_loadfont& = 0
END FUNCTION

'--- which of the current colour target's channels are we editing ------------
FUNCTION demo_targetcol~& ()
    SELECT CASE colTarget
        CASE 0: demo_targetcol~& = cfg.BODY_KOLOR
        CASE 1: demo_targetcol~& = cfg.NUM_KOLOR
        CASE 2: demo_targetcol~& = cfg.EDGE_KOLOR
        CASE 3: demo_targetcol~& = cfg.BOX_BACK_KOLOR
        CASE 4: demo_targetcol~& = cfg.BOX_OUTLINE_KOLOR
        CASE 5: demo_targetcol~& = cfg.MARBLE_KOLOR
        CASE 6: demo_targetcol~& = cfg.WIRE_KOLOR
    END SELECT
END FUNCTION

SUB demo_settargetcol (c AS _UNSIGNED LONG)
    SELECT CASE colTarget
        CASE 0: cfg.BODY_KOLOR = c
        CASE 1: cfg.NUM_KOLOR = c
        CASE 2: cfg.EDGE_KOLOR = c
        CASE 3: cfg.BOX_BACK_KOLOR = c
        CASE 4: cfg.BOX_OUTLINE_KOLOR = c
        CASE 5: cfg.MARBLE_KOLOR = c
        CASE 6: cfg.WIRE_KOLOR = c
    END SELECT
END SUB

FUNCTION demo_paramval! (i AS INTEGER)
    SELECT CASE i
        CASE 0: demo_paramval! = cfg.CAM_TILT
        CASE 1: demo_paramval! = cfg.DIE_SIZE
        CASE 2: demo_paramval! = cfg.FONT_PX
        CASE 3: demo_paramval! = diceCount
        CASE 4: demo_paramval! = cfg.BOX_W
        CASE 5: demo_paramval! = cfg.BEVEL
        CASE 6: demo_paramval! = cfg.SPIN_STRENGTH
        CASE 7: demo_paramval! = cfg.THROW_STRENGTH
        CASE 8: demo_paramval! = cfg.GRAVITY
        CASE 9: demo_paramval! = cfg.RESTITUTION
        CASE 10: demo_paramval! = cfg.FRICTION
        CASE 11: demo_paramval! = _RED32(demo_targetcol~&)
        CASE 12: demo_paramval! = _GREEN32(demo_targetcol~&)
        CASE 13: demo_paramval! = _BLUE32(demo_targetcol~&)
        CASE 14: demo_paramval! = cfg.BODY_ALPHA
        CASE 15: demo_paramval! = cfg.TEX_OPACITY
        CASE 16: demo_paramval! = cfg.CRYSTAL_ALPHA
        CASE 17: demo_paramval! = cfg.WIRE_OPACITY
        CASE 18: demo_paramval! = cfg.FOV
        CASE 19: demo_paramval! = cfg.CAM_YAW
    END SELECT
END FUNCTION

SUB demo_paramset (i AS INTEGER, v AS SINGLE)
    DIM vv AS SINGLE
    DIM c AS _UNSIGNED LONG
    vv = dice3d_clampf(v, pMin(i), pMax(i))
    SELECT CASE i
        CASE 0: cfg.CAM_TILT = vv
        CASE 1: cfg.DIE_SIZE = vv
        CASE 2: cfg.FONT_PX = vv: demo_syncfont
        CASE 3: diceCount = vv
        CASE 4: cfg.BOX_W = vv: cfg.BOX_H = vv
        CASE 5: cfg.BEVEL = vv
        CASE 6: cfg.SPIN_STRENGTH = vv
        CASE 7: cfg.THROW_STRENGTH = vv
        CASE 8: cfg.GRAVITY = vv
        CASE 9: cfg.RESTITUTION = vv
        CASE 10: cfg.FRICTION = vv
        CASE 11: c = demo_targetcol~&: demo_settargetcol _RGB32(vv, _GREEN32(c), _BLUE32(c))
        CASE 12: c = demo_targetcol~&: demo_settargetcol _RGB32(_RED32(c), vv, _BLUE32(c))
        CASE 13: c = demo_targetcol~&: demo_settargetcol _RGB32(_RED32(c), _GREEN32(c), vv)
        CASE 14: cfg.BODY_ALPHA = vv
        CASE 15: cfg.TEX_OPACITY = vv
        CASE 16: cfg.CRYSTAL_ALPHA = vv
        CASE 17: cfg.WIRE_OPACITY = vv
        CASE 18: cfg.FOV = vv
        CASE 19: cfg.CAM_YAW = vv
    END SELECT
END SUB

SUB demo_adjust (dir AS INTEGER)
    demo_paramset selParam, demo_paramval!(selParam) + dir * pStep(selParam)
END SUB

'--- params that require a fresh roll (physics / geometry / count) ------------
FUNCTION demo_needroll% (i AS INTEGER)
    SELECT CASE i
        CASE 3, 4, 6, 7, 8, 9, 10: demo_needroll% = -1
        CASE ELSE: demo_needroll% = 0
    END SELECT
END FUNCTION

FUNCTION demo_typeval! (prompt AS STRING)
    DIM AS STRING s, k
    DIM AS INTEGER ry
    ry = cfg.BOX_Y + cfg.BOX_H + 40
    s = ""
    DO
        LINE (360, ry - 2)-(939, ry + 18), BG, BF
        COLOR _RGB32(255, 255, 120), _RGBA32(0, 0, 0, 0)
        _PRINTSTRING (366, ry), prompt + s + "_"
        _DISPLAY
        DO: k = INKEY$: _LIMIT 60: LOOP UNTIL k <> ""
        IF k = CHR$(13) THEN EXIT DO
        IF k = CHR$(27) THEN demo_typeval! = CANCEL: EXIT FUNCTION
        IF k = CHR$(8) THEN
            IF LEN(s) > 0 THEN s = LEFT$(s, LEN(s) - 1)
        ELSEIF (k >= "0" AND k <= "9") OR k = "." OR k = "-" THEN
            s = s + k
        END IF
    LOOP
    demo_typeval! = VAL(s)
END FUNCTION

'--- dice-set + theme persistence -------------------------------------------
SUB demo_applyall ()
    DIM i AS INTEGER
    FOR i = 0 TO 6: slot(i) = cfg: slot(i).FONT_HANDLE = 0: NEXT
END SUB

SUB demo_saveset ()
    slot(demo_slot%(dieType)) = cfg: slot(demo_slot%(dieType)).FONT_HANDLE = 0
    dice3d_set_save slot(), setFile
END SUB

SUB demo_loadset ()
    IF dice3d_set_load%(slot(), setFile) THEN cfg = slot(demo_slot%(dieType)): demo_syncfont
END SUB

SUB demo_savetheme ()
    DIM nm AS STRING
    nm = demo_typestr$("Save theme name: ")
    IF nm <> "" THEN dice3d_theme_save nm, cfg: statusTxt = "saved theme_" + nm + ".txt"
END SUB

SUB demo_loadtheme ()
    DIM nm AS STRING
    nm = demo_typestr$("Load theme name: ")
    IF nm = "" THEN EXIT SUB
    IF dice3d_theme_load%(nm, cfg) THEN statusTxt = "loaded theme " + nm ELSE statusTxt = "no theme_" + nm + ".txt"
END SUB

SUB demo_roll ()
    DIM AS STRING roll
    DIM AS INTEGER i
    demo_bg
    roll = _TRIM$(STR$(diceCount)) + dieType
    IF dropOn AND dieType <> "d100" AND diceCount > 1 THEN roll = roll + "dl1"
    REDIM results(1 TO 1) AS INTEGER
    dice3d_roll roll, cfg, results()
    resultTxt = roll + " -> "
    FOR i = 1 TO dice3d_count%
        resultTxt = resultTxt + _TRIM$(STR$(dice3d_value%(i)))
        IF dice3d_dropped%(i) THEN resultTxt = resultTxt + "x"
        resultTxt = resultTxt + " "
    NEXT
    resultTxt = resultTxt + " = " + _TRIM$(STR$(dice3d_total%))
END SUB

SUB demo_bg ()
    DIM i AS INTEGER
    CLS , BG
    FOR i = 0 TO 940 STEP 40: LINE (i, 0)-(i, 700), _RGBA32(255, 255, 255, 26): NEXT
    _DISPLAY
END SUB

SUB demo_panel ()
    DIM AS INTEGER i, y, ry
    DIM c AS _UNSIGNED LONG
    LINE (0, 0)-(365, 699), BG, BF
    LINE (366, cfg.BOX_Y + cfg.BOX_H + 4)-(939, 699), BG, BF
    FOR i = 0 TO 365 STEP 40: LINE (i, 0)-(i, 699), _RGBA32(255, 255, 255, 26): NEXT

    COLOR _RGB32(255, 255, 255), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (12, 8), "DICE3D configurator"
    COLOR _RGB32(180, 230, 255), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (12, 28), "Die:4 6 8 0 Z 2 %  M mat C theme"
    _PRINTSTRING (12, 44), "P pips W wire K colour T drop E fx"
    COLOR _RGB32(255, 255, 255), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (12, 66), "Up/Dn pick  L/R change  ENTER type"
    FOR i = 0 TO NPARAM - 1
        y = 86 + i * 16
        IF i = selParam THEN
            LINE (6, y - 1)-(358, y + 14), _RGBA32(255, 255, 255, 45), BF
            COLOR _RGB32(255, 255, 120), _RGBA32(0, 0, 0, 0): _PRINTSTRING (10, y), ">"
        ELSE
            COLOR _RGB32(210, 230, 255), _RGBA32(0, 0, 0, 0)
        END IF
        _PRINTSTRING (24, y), pName(i)
        _PRINTSTRING (210, y), demo_fmt$(demo_paramval!(i))
    NEXT

    '--- colour target + live swatch ---
    y = 86 + NPARAM * 16 + 6
    c = demo_targetcol~&
    COLOR _RGB32(255, 255, 255), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (12, y), "Colour (K): " + _TRIM$(tgtName(colTarget))
    LINE (250, y - 1)-(300, y + 14), c, BF
    LINE (250, y - 1)-(300, y + 14), _RGB32(255, 255, 255), B

    y = y + 22
    _PRINTSTRING (12, y), "Die " + _TRIM$(STR$(diceCount)) + dieType + "  Mat " + matName(cfg.MATERIAL) + "  Th " + _TRIM$(theme(themeIdx).NM)
    _PRINTSTRING (12, y + 16), "Pips " + demo_onoff$(cfg.D6_PIPS) + "  Wire " + demo_onoff$(cfg.WIRE_ENABLED) + "  Drop " + demo_onoff$(dropOn) + " " + demo_fxname$(cfg.DROP_FX)
    COLOR _RGB32(200, 255, 200), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (12, y + 36), "Set: A=all S=save L=load (per-die)"
    _PRINTSTRING (12, y + 52), "Theme: V=save B=load by name"
    COLOR _RGB32(255, 230, 120), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (12, y + 72), statusTxt

    ry = cfg.BOX_Y + cfg.BOX_H + 12
    COLOR _RGB32(255, 255, 0), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (372, ry), resultTxt
    COLOR _RGB32(150, 200, 255), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (372, ry + 18), "(x = dropped)   ESC to quit"
    _DISPLAY
END SUB

FUNCTION demo_fmt$ (x AS SINGLE)
    demo_fmt$ = _TRIM$(STR$(INT(x * 100 + 0.5) / 100))
END FUNCTION

FUNCTION demo_onoff$ (b AS INTEGER)
    IF b THEN demo_onoff$ = "on" ELSE demo_onoff$ = "off"
END FUNCTION

FUNCTION demo_fxname$ (fx AS INTEGER)
    IF fx = DICE3D_DROPFX_EXPLODE THEN demo_fxname$ = "explode" ELSE demo_fxname$ = "fade"
END FUNCTION

'$INCLUDE:'_ALL.BM'
