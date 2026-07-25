''
' DICE3D-SHOT - headless capture harness (for automated visual verification).
' Rolls 1d6, saves box-buffer frames to a dir, saves the final full screen,
' then exits. Frame dir + slow physics are set so a handful of frames capture
' the tumble and the settle.
'
' @author Rick Christy <grymmjack@gmail.com>
'
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0: CONST TRUE = NOT FALSE
$END IF
_TITLE "DICE3D - Shot"
RANDOMIZE 1234 '                          deterministic for repeatable shots

'$INCLUDE:'_ALL.BI'

DIM SHARED SCR AS LONG
SCR = _NEWIMAGE(800, 600, 32)
SCREEN SCR
CLS , _RGB32(0, 120, 255)
DIM AS INTEGER gx
FOR gx = 0 TO 800 STEP 40
    LINE (gx, 0)-(gx, 600), _RGBA32(255, 255, 255, 40)
NEXT
COLOR _RGB32(255, 255, 255), _RGBA32(0, 0, 0, 0)
_PRINTSTRING (20, 20), "DICE3D shot harness"
_DISPLAY

DIM cfg AS DICE3D_CONFIG
dice3d_config_defaults cfg
cfg.BOX_X = 250: cfg.BOX_Y = 150: cfg.BOX_W = 320: cfg.BOX_H = 320
cfg.DIE_SIZE = 34
IF ENVIRON$("DICE3D_MAT") <> "" THEN cfg.MATERIAL = VAL(ENVIRON$("DICE3D_MAT"))
IF ENVIRON$("DICE3D_PIPS") <> "" THEN cfg.D6_PIPS = VAL(ENVIRON$("DICE3D_PIPS"))
IF ENVIRON$("DICE3D_BEVEL") <> "" THEN cfg.BEVEL = VAL(ENVIRON$("DICE3D_BEVEL")) / 100
IF ENVIRON$("DICE3D_SIZE") <> "" THEN cfg.DIE_SIZE = VAL(ENVIRON$("DICE3D_SIZE"))
IF ENVIRON$("DICE3D_DROPFX") <> "" THEN cfg.DROP_FX = VAL(ENVIRON$("DICE3D_DROPFX"))

DICE3D_SHOT_EVERY = 5
DICE3D_SHOT_DIR = ENVIRON$("DICE3D_SHOT_DIR")
IF DICE3D_SHOT_DIR = "" THEN DICE3D_SHOT_DIR = "."

DIM notation AS STRING
notation = ENVIRON$("DICE3D_ROLL")
IF notation = "" THEN notation = "4d6dl1"

REDIM results(1 TO 1) AS INTEGER
dice3d_roll notation, cfg, results()

DIM AS INTEGER di
DIM msg AS STRING
msg = notation + "  dice:"
FOR di = 1 TO UBOUND(results)
    msg = msg + " " + _TRIM$(STR$(results(di)))
    IF DICE3D_DICE(di - 1).DROPPED THEN msg = msg + "(drop)"
NEXT
msg = msg + "   total=" + _TRIM$(STR$(DICE3D_LAST_TOTAL))
COLOR _RGB32(255, 255, 0), _RGBA32(0, 0, 0, 0)
_PRINTSTRING (cfg.BOX_X, cfg.BOX_Y + cfg.BOX_H + 12), msg
_DISPLAY
_SAVEIMAGE DICE3D_SHOT_DIR + "/screen_final.png", SCR
SYSTEM

'$INCLUDE:'_ALL.BM'
