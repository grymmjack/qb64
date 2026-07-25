''
' DICE3D-FACES - demo/verify custom sprite-sheet face maps.
' Builds a 6-cell sheet of code-page-437 symbols and maps them onto d6 faces
' (smiley = 1, heart = 2, ... skull = 6), then rolls 4d6.
'
' @author Rick Christy <grymmjack@gmail.com>
'
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0: CONST TRUE = NOT FALSE
$END IF
_TITLE "DICE3D - Custom faces"
RANDOMIZE 77

'$INCLUDE:'_ALL.BI'

DIM SHARED SCR AS LONG
SCR = _NEWIMAGE(800, 600, 32)
SCREEN SCR
CLS , _RGB32(0, 120, 255)
COLOR _RGB32(255, 255, 255), _RGBA32(0, 0, 0, 0)
_PRINTSTRING (20, 20), "DICE3D custom face-map demo (symbols instead of numbers)"
_DISPLAY

'--- build a 6-cell 64x64 sprite sheet of CP437 symbols on white chips ---
DIM AS LONG sheet
DIM AS INTEGER i, tx
DIM sym(0 TO 5) AS STRING
DIM chip(0 TO 5) AS _UNSIGNED LONG
DIM ink(0 TO 5) AS _UNSIGNED LONG
sym(0) = CHR$(1): chip(0) = _RGB32(255, 235, 120): ink(0) = _RGB32(40, 40, 0) '  smiley
sym(1) = CHR$(3): chip(1) = _RGB32(255, 210, 210): ink(1) = _RGB32(200, 0, 0) '   heart
sym(2) = CHR$(6): chip(2) = _RGB32(210, 230, 255): ink(2) = _RGB32(0, 0, 120) '   spade
sym(3) = CHR$(15): chip(3) = _RGB32(255, 240, 180): ink(3) = _RGB32(200, 120, 0) ' sun
sym(4) = CHR$(14): chip(4) = _RGB32(210, 255, 220): ink(4) = _RGB32(0, 120, 0) '   note
sym(5) = "X": chip(5) = _RGB32(230, 230, 230): ink(5) = _RGB32(20, 20, 20) '       skull

sheet = _NEWIMAGE(64 * 6, 64, 32)
_DEST sheet
CLS , _RGBA32(0, 0, 0, 0)
FOR i = 0 TO 5
    tx = i * 64
    dice3d_fillcircle tx + 32, 32, 29, chip(i)
    dice3d_stamp_num sheet, tx + 32, 32, sym(i), 46, ink(i), 0
NEXT
_DEST SCR

DIM cfg AS DICE3D_CONFIG
dice3d_config_defaults cfg
cfg.BOX_X = 250: cfg.BOX_Y = 150: cfg.BOX_W = 320: cfg.BOX_H = 320
cfg.DIE_SIZE = 40
cfg.FACE_SHEET = sheet: cfg.FACE_CELL_W = 64: cfg.FACE_CELL_H = 64
dice3d_face_reset
FOR i = 1 TO 6: dice3d_set_face i, i - 1: NEXT '   value i -> sheet cell i-1

DICE3D_SHOT_EVERY = VAL(ENVIRON$("DICE3D_SHOT_EVERY"))
DICE3D_SHOT_DIR = ENVIRON$("DICE3D_SHOT_DIR"): IF DICE3D_SHOT_DIR = "" THEN DICE3D_SHOT_DIR = "."

REDIM results(1 TO 1) AS INTEGER
dice3d_roll "4d6", cfg, results()

DIM msg AS STRING
msg = "4d6 custom faces  values:"
FOR i = 1 TO UBOUND(results): msg = msg + " " + _TRIM$(STR$(results(i))): NEXT
COLOR _RGB32(255, 255, 0), _RGBA32(0, 0, 0, 0)
_PRINTSTRING (cfg.BOX_X, cfg.BOX_Y + cfg.BOX_H + 12), msg
_DISPLAY
_SAVEIMAGE DICE3D_SHOT_DIR + "/screen_final.png", SCR
IF ENVIRON$("DICE3D_SHOT_DIR") = "" THEN
    DIM k AS STRING
    DO: k = INKEY$: _LIMIT 30: LOOP UNTIL k <> ""
END IF
SYSTEM

'$INCLUDE:'_ALL.BM'
