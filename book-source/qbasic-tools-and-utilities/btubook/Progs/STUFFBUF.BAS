'********* STUFFBUF.BAS - shows how to stuff the keyboard buffer

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB StuffBuffer (Cmd$)

SUB StuffBuffer (Cmd$) STATIC

    '----- Limit the string to 14 characters plus Enter
    '      and save the length.
    Work$ = LEFT$(Cmd$, 14) + CHR$(13)
    Length = LEN(Work$)

    '----- Set the segment for poking, define the buffer
    '      head and tail, and then poke each character.
    DEF SEG = 0
    POKE 1050, 30
    POKE 1052, 30 + Length * 2
    FOR X = 1 TO Length
        POKE 1052 + X * 2, ASC(MID$(Work$, X))
    NEXT

END SUB
