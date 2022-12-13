_TITLE "Fractal Tree Leaf"

RANDOMIZE TIMER

hScreen& = _NEWIMAGE(1000, 700, 32)
SCREEN hScreen&

IF INSTR (_OS$, "[WINDOWS]") THEN _
   _SCREENMOVE _MIDDLE              ' center the window on the desktop

xx = 0
yy = 0

Green& = _RGB(0, 128, 0)

FOR i& = 1 TO 1000000

    rr = RND

    IF rr <= 0.1 THEN
        AA = 0
        BB = 0
        CC = 0
        DD = 0.16
        EE = 0
        FF = 0

    ELSEIF rr > 0.1 AND rr <= 0.86 THEN
        AA = .85
        BB = .04
        CC = -.04
        DD = .85
        EE = 0
        FF = 1.6

    ELSEIF rr > 0.86 AND rr <= 0.93 THEN
        AA = .2
        BB = -.26
        CC = .23
        DD = .22
        EE = 0
        FF = 1.6

    ELSE
        AA = -.15
        BB = .28
        CC = .26
        DD = .24
        EE = 0
        FF = .44
    END IF

    newX = AA * xx + BB * yy + EE
    newY = CC * xx + DD * yy + FF
    xx = newX
    yy = newY

    LINE (16 + 96 * yy, 300 + 96 * xx)-(16 + 96 * yy, 300 + 96 * xx), Green&

NEXT i&

