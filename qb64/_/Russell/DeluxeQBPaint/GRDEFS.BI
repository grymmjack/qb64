'=======================================================================
'  GRDEFS.BI -- Graphics definitions
'  Ported from grdefs.h / prism.h  (DeluxePaint I, Dan Silva / EA)
'
'  NOTE: the original defines TRUE as 0xFF (it used `char` booleans).
'  QB64's TRUE is -1. Everything here is normalised to QB64 convention.
'  Do NOT copy `#define TRUE 0xff` across -- it will silently break
'  any `IF flag = TRUE` comparison.
'=======================================================================

CONST FALSEV = 0
CONST TRUEV = -1

CONST BIGNUM = 32767
CONST NILV = 0

'--- Rasterop modes (grdefs.h) -----------------------------------------
CONST REPMODE = 0   ' replace pixels with new values
CONST XORMODE = 1   ' xor source into dest
CONST ORMODE = 2    ' or source into dest
CONST XPMODE = 3    ' transparent colour does not paint
CONST ANDMODE = 4
CONST ERSMODE = 5   ' erase: and complement of source into dest
CONST COLMODE = 6   ' source is a mask; current colour painted through

'--- Paint modes (the F1..F7 menu) -------------------------------------
CONST PM_Matte = 0
CONST PM_Color = 1
CONST PM_Replace = 2
CONST PM_Smear = 3
CONST PM_Shade = 4
CONST PM_Blend = 5
CONST PM_Cycle = 6

'--- Pen types (curpen high nibble, chproc.c/modes.c) ------------------
CONST ROUND_B = 0
CONST SQUARE_B = 1
CONST DOT_B = 2
CONST USERBRUSH = &H7FFF

'--- Screen geometry ---------------------------------------------------
'  The Amiga original was planar. We go chunky 8-bit: one byte per
'  pixel in a 256-colour _NEWIMAGE, reached through _MEMIMAGE.
'  Amiga hi-res. The DPaint line did not stay at lo-res either, and
'  this is an exact 2x of it, so 320x200 artwork doubles cleanly.
CONST SCRW = 640
CONST SCRH = 400
'  256 colours, as the VGA release had. NCOLORS must stay a power of
'  two: IncFG/IncBG wrap with AND (NCOLORS - 1).
CONST NCOLORS = 256
CONST NPLANES = 8           ' bitplanes needed for NCOLORS, for ILBM

'--- Cursors -----------------------------------------------------------
CONST DEFCURSOR = 0
CONST PICKCURSOR = 1
CONST FILLCURSOR = 2
CONST SIZECURSOR = 3
CONST DEFC = DEFCURSOR
