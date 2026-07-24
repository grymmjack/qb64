'=======================================================================
'  IMODES.BI -- Interaction modes
'
'  THE KEY PORTING DECISION LIVES HERE.
'
'  The original is built on eight function pointers (paintw.c):
'      upShow  upMove  upClear  WentDn
'      dnShow  dnMove  dnClear  WentUp
'  Every tool in DeluxePaint is nothing but a different plugging of
'  those eight slots, done by IModeProcs().  Plus two more indirect
'  slots, `doit` and `xorit`, used by PaintIt() and FlipIt().
'
'  QB64 has no function pointers.  So each slot becomes an INTEGER
'  action ID, and DoAction() in ACTIONS.BM is one big SELECT CASE.
'  Adding a tool = add an ACT_ constant + one CASE + one mode entry.
'=======================================================================

'--- Interaction mode IDs (prism.h) ------------------------------------
CONST IM_none = 0
CONST IM_null = 1
CONST IM_shade = 2
CONST IM_draw = 3
CONST IM_vect = 4
CONST IM_curve1 = 5
CONST IM_curve2 = 6
CONST IM_circ = 7
CONST IM_fcirc = 8
CONST IM_rect = 9
CONST IM_frect = 10
CONST IM_oval = 11
CONST IM_foval = 12
CONST IM_selBrush = 13
CONST IM_magSpec = 14
CONST IM_fill = 15
CONST IM_text1 = 16
CONST IM_text2 = 17
CONST IM_gridSpec = 18
CONST IM_symCent = 19
CONST IM_readPix = 20
CONST IM_strBrush = 21
CONST IM_rotBrush = 22
CONST IM_shrBrush = 23
CONST IM_sizePen = 24
CONST IM_poly = 25
CONST IM_poly2 = 26
CONST IM_fpoly = 27
CONST IM_fpoly2 = 28
CONST IM_airBrush = 29
CONST IM_getFPat = 30
CONST IM_hbendBrush = 31
CONST IM_vbendBrush = 32
CONST NIMODES = 33

'--- Mode flags (prism.h) ----------------------------------------------
CONST F_PERM = 1        ' permanent mode
CONST F_NOGR = 2        ' don't grid this mode
CONST F_NOBR = 4        ' mode doesn't use the brush
CONST F_NOSYM = 8       ' no symmetry at all
CONST F_SYMUP = 16      ' symmetry feedback while button up
CONST F_SYMDN = 32      ' symmetry feedback while button down
CONST F_SLAVE = 64      ' not a "master" mode
CONST F_NOLOCK = 128    ' can't lock by double-clicking
CONST F_EVTIM = 256     ' call every time while button down
CONST F_PNTWDN = 512    ' UpdtON while button down
CONST F_COMPLETE = 1024 ' call completeMode on space bar
CONST F_RIGHTBUT = 2048 ' set when mode invoked with right button
CONST F_NOERASE = 4096  ' don't erase with right button
CONST F_NOCON = 8192    ' don't constrain with shift
CONST F_SYMALL = 48     ' F_SYMUP OR F_SYMDN

'--- Action IDs -- these replace the C function pointers ---------------
CONST ACT_NOP = 0

' object (pen/brush) display
CONST ACT_OBSPLAT = 1   ' mDispOB(mx,my)
CONST ACT_OBMV = 2      ' mMoveOB(mx,my)
CONST ACT_OBCLR = 3     ' mClearOB(mx,my)

' geometry feedback / commit
CONST ACT_INCLINE = 10  ' mLine(lx,ly,mx,my)   -- freehand
CONST ACT_VEC = 11      ' mLine(sx,sy,mx,my)   -- rubber-band line
CONST ACT_CRV = 12      ' mCurve(psx,psy,mx,my,pex,pey)
CONST ACT_CIR = 13
CONST ACT_FCIR = 14
CONST ACT_OVAL = 15
CONST ACT_FOVAL = 16
CONST ACT_FRBOX = 17
CONST ACT_FILBOX = 18
CONST ACT_AFILL = 19    ' mFillArea

' crosshair combinations
CONST ACT_INVXH = 20
CONST ACT_SHOWXHANDOB = 21
CONST ACT_CLRXHANDOB = 22
CONST ACT_MOVXHANDOB = 23
'  The original toggled the crosshair off by XOR-drawing it a second
'  time, so ACT_INVXH served as both show and clear. On the overlay a
'  second draw is just a second crosshair, so clearing needs its own ID.
CONST ACT_CLRXH = 24

' the "functionals" -- these call the indirect slots
CONST ACT_SYMPTS = 30   ' PaintSym: symmetry-expand curDoAct
CONST ACT_PAINTIT = 31  ' PaintIt:  run curDoAct once, with update on
CONST ACT_FLIPIT = 32   ' FlipIt:   run curXorAct in temp-XOR mode
CONST ACT_ERASEFB = 33  ' EraseTempChg
CONST ACT_CLRCRV = 34

' tool-specific
CONST ACT_DOREAD = 40
CONST ACT_SBFRBOX = 41
CONST ACT_DOSELBR = 42
CONST ACT_SHOWGRID = 43
CONST ACT_SETGRORG = 44
CONST ACT_STRGRID = 45
CONST ACT_DOGRID = 46
CONST ACT_SYMCENTER = 47
CONST ACT_PNUPMV = 48
CONST ACT_PNDNMV = 49
CONST ACT_SZSET = 50
CONST ACT_AIRBRUSH = 51

'--- Mode descriptor (was IModeDesc in prism.h) ------------------------
'  `startProc` was a function pointer; here the mode ID *is* the
'  selector -- StartMode() switches on it directly.
TYPE IModeDesc
    flags AS LONG
    cursor AS INTEGER
    activity AS INTEGER
    symNpoints AS INTEGER
    nextIMode AS INTEGER
END TYPE

'--- Mouse events (paintw.c mainMproc) ---------------------------------
CONST EV_NONE = 0
CONST EV_LOOPED = 1
CONST EV_MOVED = 2
CONST EV_BDOWN = 3
CONST EV_BUP = 4
CONST EV_ENTER = 5
CONST EV_LEAVE = 6

CONST UPSTATE = 0
CONST DNSTATE = 1
