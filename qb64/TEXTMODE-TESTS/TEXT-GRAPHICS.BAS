_DEFINE A-Z AS LONG
OPTION _EXPLICIT

CONST SCREEN_W = 1024
CONST SCREEN_H = 600
CONST VIEW_OFFSET = 32
CONST PANEL_COLS = 32
CONST PANEL_ROWS = 6

DIM screenHandle AS LONG: screenHandle = _NEWIMAGE(SCREEN_W, SCREEN_H, 32)
SCREEN screenHandle
$RESIZE:SMOOTH
_ALLOWFULLSCREEN _SQUAREPIXELS , _SMOOTH
_TITLE "Draggable Live SCREEN 0 Clock Panel Demo"

DIM bg AS LONG: bg = _NEWIMAGE(SCREEN_W, SCREEN_H, 32)
DIM panel AS LONG: panel = _NEWIMAGE(PANEL_COLS, PANEL_ROWS, 0)

DIM AS LONG cellW, cellH

DIM fontHandle AS LONG: fontHandle = _LOADFONT("liberation/LiberationMono-Regular.ttf", 16, "monospace")
IF fontHandle < 1 THEN
    fontHandle = _LOADFONT("Courier New.ttf", 16, "monospace")
END IF
IF fontHandle < 1 THEN
    fontHandle = _LOADFONT("lucon.ttf", 16, "monospace")
END IF
IF fontHandle > 0 THEN
    _FONT fontHandle, panel
    cellW = _FONTWIDTH(fontHandle)
    cellH = _FONTHEIGHT(fontHandle)
ELSE
    _FONT 16, panel
    cellW = 8
    cellH = 16
END IF

DIM panelWpx AS LONG: panelWpx = PANEL_COLS * cellW
DIM panelHpx AS LONG: panelHpx = PANEL_ROWS * cellH
DIM panelX AS LONG: panelX = 40
DIM panelY AS LONG: panelY = 40

_DEST bg

CLS , _RGB32(16, 22, 30)

DIM y AS LONG
FOR y = 0 TO _HEIGHT(bg) - 1
    LINE (0, y)-(_WIDTH(bg) - 1, y), _RGB32(20 + y \ 8, 30 + y \ 6, 45 + y \ 5)
NEXT

DIM x AS LONG
FOR x = -128 TO _WIDTH(bg) STEP 64
    LINE (x, 0)-(x + 200, _HEIGHT(bg) - 1), _RGBA32(255, 255, 255, 10)
NEXT

FOR y = 40 TO _HEIGHT(bg) - 1 STEP 80
    CIRCLE (_SHR(_WIDTH(bg), 1), y), 120, _RGBA32(255, 220, 120, 20)
NEXT

_DEST 0

VIEW SCREEN(VIEW_OFFSET, VIEW_OFFSET)-(SCREEN_W - VIEW_OFFSET, SCREEN_H - VIEW_OFFSET), , _RGB32(255, 255, 0, 255)

DIM dragging AS _BYTE
DIM AS LONG dragOffX, dragOffY

DO
    DO WHILE _MOUSEINPUT
    LOOP

    DIM mx AS LONG: mx = _MOUSEX
    DIM my AS LONG: my = _MOUSEY

    IF _MOUSEBUTTON(1) THEN
        IF dragging THEN
            panelX = mx - dragOffX
            panelY = my - dragOffY
        ELSE
            IF mx >= panelX _ANDALSO mx < panelX + panelWpx _ANDALSO my >= panelY _ANDALSO my < panelY + panelHpx THEN
                dragging = _TRUE
                dragOffX = mx - panelX
                dragOffY = my - panelY
            END IF
        END IF
    ELSE
        dragging = _FALSE
    END IF

    _DEST panel
    CLS
    COLOR 15, 1
    LOCATE 1, 1: PRINT "======== Floating Panel ========";
    COLOR 14, 1
    LOCATE 3, 9: PRINT "Date: "; DATE$;
    LOCATE 4, 10: PRINT "Time: "; TIME$;
    COLOR 7, 1
    IF dragging THEN
        LOCATE 6, 13: PRINT "Dragging";
    ELSE
        LOCATE 6, 7: PRINT "Drag with left mouse";
    END IF
    _DEST 0

    _PUTIMAGE (0, 0), bg
    _PUTIMAGE (panelX, panelY), panel

    _DISPLAY
    _LIMIT 60
LOOP UNTIL _KEYHIT = _KEY_ESC

IF fontHandle > 0 THEN
    _FONT 16, panel
    _FREEFONT fontHandle
END IF

_FREEIMAGE panel
_FREEIMAGE bg

SYSTEM
