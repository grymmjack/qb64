'=======================================================================
'  UIDEFS.BI -- widget definitions
'
'  Before this, every control in the panel was hand-drawn with LINE and
'  hand-tested with a range check, in two separate places that had to
'  agree. Adding a control meant editing both, and they could drift.
'
'  A widget owns its own geometry, so drawing and hit-testing read from
'  the same record and cannot disagree. Adding a control is one AddWid
'  call plus one CASE.
'=======================================================================

'--- widget kinds ------------------------------------------------------
CONST WK_BUTTON = 0     ' momentary: fires and returns
CONST WK_TOOL = 1       ' selects an IMode; lit while that mode is current
CONST WK_TOGGLE = 2     ' lit while its underlying flag is set

'--- what a widget does ------------------------------------------------
CONST UI_NONE = 0
CONST UI_TOOL = 1       ' arg = tool index into ToolIM%()
CONST UI_UNDO = 2
CONST UI_CLEAR = 3
CONST UI_SYM = 4
CONST UI_GRID = 5
CONST UI_CYCLE = 6
CONST UI_SAVE = 7
CONST UI_LOAD = 8
CONST UI_FULL = 9
CONST UI_QUIT = 10
CONST UI_ZOOMIN = 11
CONST UI_ZOOMOUT = 12
CONST UI_REDO = 13

'--- UI palette --------------------------------------------------------
'  Indices into the grey ramp at 8..31, so the chrome stays legible
'  whatever the artwork is doing. UI_ACCENT is deliberately off-ramp.
CONST UIC_PANEL = 14
CONST UIC_FACE = 18
CONST UIC_LIGHT = 27     ' bevel highlight: top and left
CONST UIC_SHADOW = 10    ' bevel shadow: bottom and right
CONST UIC_TEXT = 31
CONST UIC_HOVER = 23
CONST UIC_LIT = 29       ' selected tool / toggle on
CONST UIC_DANGER = 2     ' quit

CONST MAXWID = 64

TYPE Widget
    wx AS INTEGER
    wy AS INTEGER
    ww AS INTEGER
    wh AS INTEGER
    kind AS INTEGER
    act AS INTEGER
    arg AS INTEGER
    label AS STRING * 2
    tip AS STRING * 14
END TYPE
