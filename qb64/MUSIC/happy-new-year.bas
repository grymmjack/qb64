' 2012, 2013 mennonite
' license: creative commons cc0 1.0 universal
' (public domain) http://creativecommons.org/publicdomain/zero/1.0/

SCREEN 12 ' the following works in other screen modes, too
RANDOMIZE TIMER

PLAY "mb l4cf.l8el4fag.l8fl4gl8agl4f.l8fl4a>cl2dl4dl4c.<l8al4afg.l8fl4gl8agl4f.l8dl4dcl2f>l4dc.<l8al4afg.l8fl4g>dc.<l8al4a>cl2dl4dc.<l8al4afg.l8fl4gl8agl4f.l8dl4dcl1f"

DIM ccs(1 TO 9, 1 TO 2)
ccs(1, 1) = 415: ccs(1, 2) = 289
ccs(2, 1) = 185: ccs(2, 2) = 128
ccs(3, 1) = 108: ccs(3, 2) = 75
ccs(4, 1) = 70: ccs(4, 2) = 48
ccs(5, 1) = 48: ccs(5, 2) = 32
ccs(6, 1) = 32: ccs(6, 2) = 20
ccs(7, 1) = 20: ccs(7, 2) = 12
ccs(8, 1) = 10: ccs(8, 2) = 6
ccs(9, 1) = 2: ccs(9, 2) = 2

FOR extra = 1 TO 23
    FOR p = 1 TO 9
        gcolor INT(RND * 9 + 14 - 9)
        _DELAY .04
        CLS
        gscale p
        row = ccs(p, 1)
        cl = ccs(p, 2)
        glocate row, cl
        gprint "000000000000000000000000000000000000000000000000000000000000000000000"
        glocate row + 1, cl
        gprint "0x00x0xxxx0xxxx0xxxx0x0x000x00x0xxxx0x000x000x0x0xxxx0xxxx0xxxx000x00"
        glocate row + 2, cl
        gprint "0x00x0x00x0x00x0x00x0x0x000xx0x0x0000x000x000x0x0x0000x00x0x00x000x00"
        glocate row + 3, cl
        gprint "0xxxx0xxxx0xxxx0xxxx0x0x000x0xx0xxx00x0x0x000x0x0xxx00xxxx0xxxx000x00"
        glocate row + 4, cl
        gprint "0x00x0x00x0x0000x00000x0000x00x0x0000x0x0x0000x00x0000x00x0x0x0000000"
        glocate row + 5, cl
        gprint "0x00x0x00x0x0000x00000x0000x00x0xxxx0xx0xx0000x00xxxx0x00x0x00x000x00"
        glocate row + 6, cl
        gprint "000000000000000000000000000000000000000000000000000000000000000000000"
    NEXT p
    SLEEP 1
    IF INKEY$ = CHR$(27) THEN EXIT FOR
NEXT extra

END

SUB gscale (s):
    SHARED gscalep
    gscalep = INT(s)
END SUB

SUB gcolor (c):
    SHARED gcolorp
    gcolorp = c
END SUB

SUB gbackcolor (c):
    SHARED gbackcolorp
    gbackcolorp = c
END SUB

SUB glocate (row, column):
    SHARED gposxp
    SHARED gposyp
    gposyp = row
    gposxp = column
END SUB

SUB gprint (p$):
    SHARED gscalep
    SHARED gposxp, gposyp
    SHARED gcolorp, gbackcolorp
    ' # means "use the foreground color here."
    ' . means "use the background color here."
    ' _ means "transparent - don't draw this block at all" (you can layer!)
    ' 0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f means "do color attribute 0 to 15."
    ' any letter after f: "use the foreground color here."
    IF gscalep < 1 THEN gscalep = 1
    pcolorp = gcolorp
    FOR p = 1 TO LEN(p$):
        SELECT CASE LCASE$(MID$(p$, p, 1))
            CASE "#", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
                pcolorp = gcolorp
            CASE "."
                pcolorp = gbackcolorp
            CASE "_"
                pcolorp = -1
            CASE "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"
                pcolorp = INSTR("0123456789abcdef", LCASE$(MID$(p$, p, 1))) - 1
        END SELECT
        IF NOT pcolorp = -1 THEN
            IF gscalep > 1 THEN
                LINE ((gposxp - 1) * gscalep, (gposyp - 1) * gscalep)-STEP(gscalep - 1, gscalep - 1), pcolorp, BF
            ELSE:
                PSET (gposxp, gposyp), pcolorp
            END IF
        END IF
        glocate gposyp, gposxp + 1
    NEXT p
    gposxp = 1
    glocate gposyp + 1, 1 'gposyp = gposyp + 1
END SUB
