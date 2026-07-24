
'=======================================================================
'  DeluxeQBPaint -- main body
'
'  A QB64 paint program descended from DeluxePaint I (Dan Silva /
'  Electronic Arts, 1985), whose source EA released through the
'  Computer History Museum in 2015 for non-commercial use.
'
'  What came across from the original: the interaction model. The eight
'  slots of the paint-window state machine, tools as different
'  pluggings of those slots, and the brush that becomes your pen.
'
'  What did not, and deliberately: the planar bitmaps and 50K of Amiga
'  blitter code, replaced by one byte per pixel through _MEMIMAGE; and
'  XOR-on-canvas feedback, replaced by a separate overlay surface.
'  Colour depth follows the later VGA releases at 256 rather than the
'  Amiga's 32.
'
'  Build: open in QB64 and press F5. Include order matters --
'  .BI at the top (CONST/TYPE/DIM SHARED), .BM at the bottom (bodies).
'=======================================================================

'$Include:'GRDEFS.BI'
'$Include:'IMODES.BI'
'$Include:'UIDEFS.BI'
'$Include:'GLOBALS.BI'

'-----------------------------------------------------------------------
' Setup
'-----------------------------------------------------------------------
_Title APPNAME

screenH = _NewImage(SCRW, SCRH, 256)
Screen screenH

hidbm = _NewImage(SCRW, SCRH, 256) ' the picture
sparebm = _NewImage(SCRW, SCRH, 256) ' spare page ('j')
fbbm = _NewImage(SCRW, SCRH, 256) ' feedback overlay -- never merged

'  Everything in the overlay that hasn't been drawn to is transparent.
_ClearColor FBCLEAR, fbbm
_Dest fbbm: Line (0, 0)-(SCRW - 1, SCRH - 1), FBCLEAR, BF: _Dest screenH

Randomize Timer ' the airbrush needs a real seed
_Font 16 ' 8x16 built-in; panel rows are 20px tall

InitPalette
InitModes
InitPaintState
InitPanel
InitWidgets
SetTitle

NewIMode IM_draw

'-----------------------------------------------------------------------
' Main loop
'
' The Amiga version was callback-driven: Intuition pushed events into
' mainMproc/mainCproc via the Pane structs. QB64 is polled, so we
' synthesise the same event stream here -- ENTER / MOVED / BDOWN / BUP /
' LEAVE / LOOPED -- and feed it to the identical state machine.
'-----------------------------------------------------------------------
Dim lastBut As Integer, lastX As Integer, lastY As Integer
Dim wasInside As Integer, nowInside As Integer
Dim rawX As Integer, rawY As Integer, rawBut As Integer
Dim picX As Integer, picY As Integer
Dim k As Long

Do
    '--- drain the mouse queue, keep only the newest position ---------
    Do While _MouseInput: Loop

    '  Read into LOCALS, not into nx/ny. MainMproc takes x,y by
    '  reference and then calls Gridify on nx,ny -- passing the shared
    '  nx,ny in would alias the parameter to the thing being modified.
    rawX = _MouseX
    rawY = _MouseY
    rawBut = 0
    If _MouseButton(1) Then rawBut = 1
    If _MouseButton(2) Then rawBut = 2

    mouseRX = rawX
    mouseRY = rawY

    ShiftKey = (_KeyDown(100303) Or _KeyDown(100304))
    CtrlKey = (_KeyDown(100305) Or _KeyDown(100306))

    '  `inside` is owned by EnterW/LeaveW -- track our own copy here
    '  or the loop will stomp the state machine's flag every frame.
    '  "Inside" now means the painting window, NOT the whole screen --
    '  everything below cpY belongs to the control panel.
    nowInside = InPW%(rawX, rawY)

    '  Screen -> picture. Locals, so MainMproc's byref x,y can't alias
    '  anything shared. Identity today; not once scrolling exists.
    picX = (rawX - pwX) \ magZ + xorg
    picY = (rawY - pwY) \ magZ + yorg

    '--- synthesise the event ----------------------------------------
    If nowInside And Not wasInside Then
        MainMproc EV_ENTER, rawBut, picX, picY
    ElseIf wasInside And Not nowInside Then
        MainMproc EV_LEAVE, rawBut, picX, picY
    ElseIf nowInside Then
        If rawBut <> 0 And lastBut = 0 Then
            MainMproc EV_BDOWN, rawBut, picX, picY
        ElseIf rawBut = 0 And lastBut <> 0 Then
            MainMproc EV_BUP, lastBut, picX, picY
        ElseIf rawX <> lastX Or rawY <> lastY Then
            MainMproc EV_MOVED, rawBut, picX, picY
        ElseIf everyTime Then
            MainMproc EV_LOOPED, rawBut, picX, picY
        End If
    Else
        '  Panel: press edge only, so no debouncing needed downstream.
        '  Leaving the paint window already fired EV_LEAVE above, which
        '  cleared the feedback -- so clicking a tool is safe here.
        '  The bounds test matters in fullscreen: _SQUAREPIXELS
        '  letterboxes, and a click in the border must not be read as a
        '  click on the edge of the panel.
        If rawBut <> 0 And lastBut = 0 Then
            If rawX >= 0 And rawX < SCRW And rawY >= cpY And rawY < SCRH Then
                CPMproc rawBut, rawX, rawY
            End If
        End If
    End If

    wasInside = nowInside
    lastBut = rawBut
    lastX = rawX
    lastY = rawY

    '--- keyboard ----------------------------------------------------
    '  _KEYHIT returns a NEGATIVE code on key release -- ignore those
    '  or every keystroke fires its binding twice.
    k = _KeyHit
    If k > 0 Then MainCproc k

    '--- present -----------------------------------------------------
    CycleStep
    Compose
    _Display
    _Limit 60
Loop Until quitFlag

System

'=======================================================================
'  Subroutine bodies. Order here is free; QB64 resolves names globally.
'=======================================================================
'$Include:'IMODE.BM'
'$Include:'PANEL.BM'
'$Include:'UI.BM'
'$Include:'PAINTW.BM'
'$Include:'ACTIONS.BM'
'$Include:'CHPROC.BM'
'$Include:'DRAW.BM'
'$Include:'BRUSH.BM'
'$Include:'IFF.BM'
