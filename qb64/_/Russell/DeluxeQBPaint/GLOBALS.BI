'=======================================================================
'  GLOBALS.BI -- shared program state
'
'  QB64 has ONE global namespace. The original's `#define local static`
'  has no equivalent, so everything below is visible everywhere.
'  Prefix discipline is the only protection you get.
'=======================================================================

'--- Point record (pnts.h) ---------------------------------------------
'  The original wraps these in `PointRec pnts` then aliases them back
'  with macros (#define mx pnts.pntmx) purely for terseness. Since the
'  only instance is the single global, we skip the struct entirely.
DIM SHARED mx AS INTEGER, my AS INTEGER      ' current point
DIM SHARED lx AS INTEGER, ly AS INTEGER      ' last point
DIM SHARED sx AS INTEGER, sy AS INTEGER      ' start (button down)
DIM SHARED ex AS INTEGER, ey AS INTEGER      ' end (button up)
DIM SHARED psx AS INTEGER, psy AS INTEGER    ' previous button down
DIM SHARED pex AS INTEGER, pey AS INTEGER    ' previous button up
DIM SHARED nx AS INTEGER, ny AS INTEGER      ' incoming raw point

'--- The eight mode slots (was function pointers in paintw.c) ----------
DIM SHARED upShow AS INTEGER, upMove AS INTEGER
DIM SHARED upClear AS INTEGER, WentDn AS INTEGER
DIM SHARED dnShow AS INTEGER, dnMove AS INTEGER
DIM SHARED dnClear AS INTEGER, WentUp AS INTEGER

'--- The two indirect slots (modes.c: doit, xorit) ---------------------
DIM SHARED curDoAct AS INTEGER
DIM SHARED curXorAct AS INTEGER
DIM SHARED killModeAct AS INTEGER
DIM SHARED completeAct AS INTEGER
DIM SHARED periodicAct AS INTEGER

'--- Mode state --------------------------------------------------------
DIM SHARED imodes(NIMODES) AS IModeDesc

'--- Widgets (UI.BM) ---------------------------------------------------
DIM SHARED wid(MAXWID) AS Widget
DIM SHARED nWid AS INTEGER
DIM SHARED hotWid AS INTEGER       ' widget under the pointer, -1 for none
DIM SHARED curIMode AS INTEGER
DIM SHARED lastPermMode AS INTEGER
DIM SHARED curIMFlags AS LONG
DIM SHARED chgToMode AS INTEGER

'--- Tracking state ----------------------------------------------------
DIM SHARED updn AS INTEGER
DIM SHARED fbOn AS INTEGER
DIM SHARED inside AS INTEGER
DIM SHARED firstDown AS INTEGER
DIM SHARED goToPerm AS INTEGER
DIM SHARED abortFlag AS INTEGER
DIM SHARED abortable AS INTEGER
DIM SHARED everyTime AS INTEGER
DIM SHARED button AS INTEGER, butwas AS INTEGER
DIM SHARED Painting AS INTEGER
DIM SHARED quitFlag AS INTEGER

'--- Modifier keys -----------------------------------------------------
DIM SHARED ShiftKey AS INTEGER, CtrlKey AS INTEGER
DIM SHARED wasShift AS INTEGER, wasCtrl AS INTEGER

'--- Grid (paintw.c) ---------------------------------------------------
DIM SHARED gridON AS INTEGER, gridded AS INTEGER
DIM SHARED gridx AS INTEGER, gridy AS INTEGER
DIM SHARED gridx2 AS INTEGER, gridy2 AS INTEGER
DIM SHARED gridOrgX AS INTEGER, gridOrgY AS INTEGER

'--- Constrain state machine -------------------------------------------
CONST CONS_NOT = 0
CONST CONS_INIT = 1
CONST CONS_HORIZ = 2
CONST CONS_VERT = 3
DIM SHARED consState AS INTEGER
DIM SHARED conStartX AS INTEGER, conStartY AS INTEGER

'--- Symmetry ----------------------------------------------------------
DIM SHARED symON AS INTEGER
DIM SHARED npts AS INTEGER
DIM SHARED symCX AS INTEGER, symCY AS INTEGER
DIM SHARED symcount AS INTEGER

'--- Colour / pen ------------------------------------------------------
'  One notch of a 4-bit Amiga colour gun (255/15).
CONST GUNSTEP = 17

'  The live palette, kept alongside _PaletteColor rather than only
'  inside it. Three things need to read colours back out: IncRGB, the
'  colour-cycling code, and any CMAP writer -- and _PaletteColor is a
'  one-way push.
DIM SHARED palR(255) AS INTEGER
DIM SHARED palG(255) AS INTEGER
DIM SHARED palB(255) AS INTEGER

DIM SHARED curcol AS INTEGER      ' foreground index
DIM SHARED curbgcol AS INTEGER    ' background index
DIM SHARED curpen AS LONG         ' (type << 12) OR size, or USERBRUSH
DIM SHARED usePen AS LONG
DIM SHARED paintMode AS INTEGER
DIM SHARED dispCoords AS INTEGER
'  What _MOUSEX/_MOUSEY actually reported this frame, kept so the
'  readout can show the raw value next to the derived one. If these
'  ever disagree with the cursor position, the display scaling is
'  breaking the coordinate space and everything downstream is wrong.
DIM SHARED mouseRX AS INTEGER, mouseRY AS INTEGER
DIM SHARED fastFB AS INTEGER
DIM SHARED allPerm AS INTEGER

'--- Surfaces ----------------------------------------------------------
'  hidbm  : the picture itself (chunky 8-bit, one byte per pixel)
'  spare  : the spare page ('j' swaps them -- SPARE.C)
'  undo   : undo buffer (UndoSave)
DIM SHARED hidbm AS LONG
DIM SHARED sparebm AS LONG
DIM SHARED screenH AS LONG

'--- Undo / redo -------------------------------------------------------
'  Was one image and a swap, which meant pressing undo twice put you
'  back where you started. Two stacks instead. Snapshots are allocated
'  on push and freed on pop, so an idle session costs nothing.
CONST NUNDO = 10
DIM SHARED undoBuf(NUNDO) AS LONG
DIM SHARED redoBuf(NUNDO) AS LONG
DIM SHARED undoN AS INTEGER, redoN AS INTEGER

'--- View origin (was xorg,yorg in the C) ------------------------------
DIM SHARED xorg AS INTEGER, yorg AS INTEGER

'--- Magnification -----------------------------------------------------
'  magZ is the zoom factor. Compose shrinks the SOURCE rect by it and
'  lets _PUTIMAGE scale up; the main loop divides incoming mouse coords
'  by it. Those two lines are the whole feature.
DIM SHARED magZ AS INTEGER, magLast AS INTEGER

'--- Painting window rect + control panel (PANEL.BM) -------------------
'  The paint window is no longer the whole screen. Screen coordinates
'  become picture coordinates as (screen - pw origin + view origin);
'  with pwX/pwY and xorg/yorg all 0 that is still the identity, but
'  the scroll and magnify modes will need it to be written out.
'  Panel geometry. Everything here is derived or explicit -- no bare
'  pixel numbers left in PANEL.BM, so the next resolution change is
'  edits to this block alone.
CONST CPH = 64              ' control panel height, in scanlines

CONST NTOOLS = 10
CONST CP_BTNY = 4           ' button row offset from cpY
CONST CP_BTNH = 20


CONST CP_FGX = 596          ' current fg-over-bg indicator
CONST CP_FGW = 36

'  256 swatches as a grid, full width.
CONST CP_SWY = 28           ' offset from cpY to the top of the grid
CONST CP_SWCOLS = 64
CONST CP_SWW = 10
CONST CP_SWH = 8
CONST CP_SWROWS = 4

DIM SHARED pwX AS INTEGER, pwY AS INTEGER
DIM SHARED pwW AS INTEGER, pwH AS INTEGER
DIM SHARED cpY AS INTEGER

'--- Feedback / update state (used by DRAW.BM) -------------------------
'  These must live here, not in DRAW.BM: a .BM file is included AFTER
'  the main program's SYSTEM statement, so it may contain SUB and
'  FUNCTION bodies only -- no module-level DIM.
'  NOTE: no shared _MEM here. The QB64 docs specify `DIM x AS _MEM`,
'  and whether SHARED carries the _MEM type into a SUB is unclear --
'  so drawing primitives acquire a local handle and pass it down.

DIM SHARED tempXORon AS INTEGER
DIM SHARED savedMode AS INTEGER
DIM SHARED updating AS INTEGER

'--- Feedback overlay --------------------------------------------------
'  fbbm is a full-size surface holding nothing but transient feedback:
'  the brush cursor, crosshairs, rubber bands. It is composited over
'  hidbm and never merged into it, so feedback cannot be captured by
'  UndoSave, SwapSpare, or a save-to-disk.
'  FBCLEAR is outside the 32-colour palette on purpose -- it is the
'  _CLEARCOLOR key, not a paintable index.
CONST FBCLEAR = 255
CONST XHCOL = 31            ' crosshair: top of the grey ramp

'  Flood-fill span stack. Measured peak on a full-canvas fill is single
'  digits; this is enormous headroom, and mFillArea drops seeds rather
'  than overrunning if it is ever wrong.
CONST STKMAX = 8191

DIM SHARED fbbm AS LONG

'--- User brush (BRUSH.BM) ---------------------------------------------
'  brushbm is allocated to the exact grabbed size, so its row stride is
'  brW, NOT SCRW. Every _MEMGET into it must use brW.
'--- Airbrush ----------------------------------------------------------
DIM SHARED abRadius AS INTEGER, abFlow AS INTEGER

'--- Colour cycling ----------------------------------------------------
'  cycLo..cycHi is the rotating range; cycRate is frames per step.
DIM SHARED cycOn AS INTEGER, cycLo AS INTEGER, cycHi AS INTEGER
DIM SHARED cycRate AS INTEGER, cycTick AS INTEGER

'--- Identity ----------------------------------------------------------
CONST APPNAME = "DeluxeQBPaint"
CONST APPVER = "0.9"

'  Filename of the picture currently open, "" if never saved or loaded.
DIM SHARED curFile AS STRING

'--- Display mode ------------------------------------------------------
'  0 = windowed, 1 = fullscreen square pixels, 2 = fullscreen stretched.
'  QB64 reports _MOUSEX/_MOUSEY in the 320x200 image space regardless,
'  so none of the event plumbing cares which of these is active.
DIM SHARED fsMode AS INTEGER

'--- Right-button erase ------------------------------------------------
'  GoDown calls TempErase, GoUp calls ClearErase after the commit, so
'  the swap is in force for the whole stroke including its feedback.
DIM SHARED erasing AS INTEGER, savedCol AS INTEGER

'--- Has the picture changed since the last load/save? ------------------
DIM SHARED picDirty AS INTEGER

DIM SHARED brushbm AS LONG
DIM SHARED brW AS INTEGER, brH AS INTEGER
DIM SHARED brHX AS INTEGER, brHY AS INTEGER   ' handle / hot spot
DIM SHARED brValid AS INTEGER
DIM SHARED fbDepth AS INTEGER
