SCREEN 13
x = 150
y = 100
DO
    k$ = INKEY$
    IF k$ = "a" THEN
        CIRCLE (x, y), 40, 0
        x = x - 10
    END IF
    IF k$ = "d" THEN
        CIRCLE (x, y), 40, 0
        x = x + 10
    END IF
    IF k$ = "w" THEN
        CIRCLE (x, y), 40, 0
        y = y - 10
    END IF
    IF k$ = "s" THEN
        CIRCLE (x, y), 40, 0
        y = y + 10
    END IF
    CIRCLE (x, y), 40, 14
LOOP

