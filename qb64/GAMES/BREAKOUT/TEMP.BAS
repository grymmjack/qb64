DIM x AS INTEGER
DO:
    RANDOMIZE TIMER
    x% = INT(RND * 2) - 1
    PRINT STR$(x%)

LOOP UNTIL _KEYHIT = 27
