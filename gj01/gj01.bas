    SCREEN 12
    FOR t% = 1 TO 3000
    RANDOMIZE TIMER
    x% = INT(RND * 640)
    Y% = INT(RND * 480)
    z% = INT(RND * 15)
    PSET (x%, Y%), z%
    NEXT t%

