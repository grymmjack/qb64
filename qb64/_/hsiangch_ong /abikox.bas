 
OPTION _EXPLICIT
 
CONST GAMELABEL = "ABIKOX"
 
DIM kox(1 TO 4) AS STRING
DIM AS STRING path2font, myk, oldk, ESCAP
DIM AS LONG cyfont, movcount
DIM AS INTEGER i, j, h, v, m, g, x, onechar, musakcounter
DIM tiltenable AS _BIT
 
ESCAP = CHR$(27)
$IF WIN THEN
    'change this to taste:
    path2font = "C:\Windows\Fonts\cyberbit.ttf"
$ELSE
    path2font = ENVIRON$("HOME") + "/.local/share/fonts/PxPlus_IBM_VGA_8x16.ttf"
$END IF
kox(1) = SPACE$(6)
kox(2) = kox(1)
kox(3) = kox(1)
kox(4) = GAMELABEL
 
RANDOMIZE VAL(RIGHT$(TIME$, 2))
tiltenable = 0
musakcounter = 0
oldk = ""
 
SCREEN _NEWIMAGE(800, 600, 12)
cyfont = _LOADFONT(path2font, 32)
_FONT cyfont
_SCREENMOVE _MIDDLE
_DISPLAY
playmusak musakcounter
 
DO UNTIL kox(1) = GAMELABEL OR kox(2) = GAMELABEL OR kox(3) = GAMELABEL
    movcount = movcount + 1
    CLS
    COLOR 15
    FOR j = 1 TO 4
        FOR i = 1 TO 6
            onechar = ASC(kox(j), i)
            IF onechar = 32 THEN onechar = 124
            _PRINTSTRING (j * 40, i * 40), CHR$(onechar)
        NEXT
    NEXT
    _DISPLAY
    DO: myk = INKEY$: LOOP UNTIL myk = ""
    playmusak musakcounter
    DO
        _LIMIT 100
        myk = INKEY$
    LOOP WHILE myk = ""
    IF myk = ESCAP THEN EXIT DO
    SELECT CASE myk
        CASE "A", "B", "I", "K", "O", "X"
        CASE "a", "b", "i", "k", "o", "x"
            myk = CHR$(ASC(myk) - 32)
        CASE ELSE
            _CONTINUE
    END SELECT
    tiltenable = 0
    IF myk = oldk THEN tiltenable = NOT tiltenable
    h = 0: v = 0
    FOR j = 1 TO 4
        FOR i = 1 TO 6
            IF MID$(kox(j), i, 1) = myk THEN
                h = j
                v = i
                EXIT FOR
            END IF
        NEXT
        IF h > 0 THEN EXIT FOR
    NEXT
    IF v > 1 THEN
        IF ASC(kox(h), v - 1) <> 32 THEN
            COLOR 5
            _PRINTSTRING (0, 500), "ILLEGAL"
            _PRINTSTRING (40, 540), "MOVE"
            _DISPLAY
            _DELAY 1
            _CONTINUE
        END IF
    END IF
    FOR j = 1 TO 4
        IF h <> j THEN
            g = 0: m = 0
            FOR i = 1 TO 6
                IF ASC(kox(j), i) <> 32 THEN
                    m = i
                    g = j
                    EXIT FOR
                END IF
            NEXT
            IF m = 0 THEN
                m = 6
                g = j
                IF tiltenable THEN
                    tiltenable = 0
                    _CONTINUE
                ELSE
                    EXIT FOR
                END IF
            END IF
            IF ASC(kox(h), v) < ASC(kox(g), m) THEN
                m = m - 1
                IF tiltenable THEN
                    tiltenable = 0
                    _CONTINUE
                ELSE
                    EXIT FOR
                END IF
            ELSE
                g = 0
            END IF
        END IF
    NEXT
    IF g > 0 THEN
        ASC(kox(g), m) = ASC(kox(h), v)
        ASC(kox(h), v) = 32
    ELSE
        COLOR 6
        _PRINTSTRING (0, 500), "NO MOVE"
        _PRINTSTRING (0, 540), "POSSIBLE"
        _DISPLAY
        _DELAY 2
    END IF
    oldk = myk
LOOP
 
IF myk <> ESCAP THEN
    IF kox(1) = GAMELABEL THEN x = 1
    IF kox(2) = GAMELABEL THEN x = 2
    IF kox(3) = GAMELABEL THEN x = 3
    CLS
    FOR j = 1 TO 4
        IF x = j THEN COLOR 4 ELSE COLOR 15
        FOR i = 1 TO 6
            onechar = ASC(kox(j), i)
            IF onechar = 32 THEN onechar = 124
            _PRINTSTRING (j * 40, i * 40), CHR$(onechar)
        NEXT
    NEXT
    COLOR 14
    _PRINTSTRING (0, 500), "YOU WIN"
    _PRINTSTRING (0, 540), LTRIM$(STR$(movcount)) + " MOVES"
    _DISPLAY
    _DELAY 5
END IF
SYSTEM
 
 
'note: "round" is changed by this subprogram
SUB playmusak (round AS INTEGER)
    round = round + 1
    SELECT CASE round
        CASE 1
            PLAY "MBT160O3"
        CASE 2
            PLAY "L8C<A>G-L16CCL8CG-C<A>G-C<A>C<A>G-C<A>CG-<A>C<A>G-"
        CASE 3
            PLAY "E-CE-CE-CFE-L16CCL8CCL8E-FE-CE-C"
        CASE 4
            PLAY "E-CFC<A>G-C<A>C<A>G-E-CFL16E-E-L8E-FE-L16CCL8CE-CFE-"
        CASE 5
            PLAY "CE-CE-CFC<A>C<A>C<A>G-E-CFE-CE-CFC<A>CG-"
        CASE 6
            PLAY "<A>C<A>G-E-L16CCL8CCL8E-FE-CE-CE-CFC<A>C<A>C<A>G-"
        CASE 7
            PLAY "C<A>C<A>C<A>G-E-CFE-CE-CFE-CE-CE-CFC<A>C"
        CASE 8
            PLAY "<A>C<A>G-E-CE-FCE-CFE-CFL16E-E-L8E-FC<A>C<A>C<A>G-E-"
        CASE 9
            PLAY "CE-CE-CFC<A>C<A>C<A>G-E-CE-CE-CFE-CCE-CF"
        CASE 10
            PLAY "E-C<A>G-C<A>C<A>G-E-CFE-CE-CFC<A>G-C<A>C<A>G-C"
        CASE 11
            PLAY "L16<A><A>L8<A><A>L8CG-E-CCE-CFE-C<A>C<A>C<A>"
        CASE 12
            PLAY "G-E-CE-CE-CFE-CE-CE-CFE-CFE-CE-CFE-CCE-CFE-E-CFE-CE-"
        CASE 13
            PLAY "CFC<A>C<A>C<A>G-C<A>G-C<A>C<A>G-E-CFL16E-"
        CASE 14
            PLAY "E-L8E-FC<A>C<A>C<A>G-E-CE-CE-CFC<A>C<A>C<A>G-E-CE-CE-"
        CASE 15
            PLAY "CFE-CE-CE-CFE-CFE-CE-CFC<A>G-C<A>C<A>G-C"
        CASE 16
            PLAY "<A>G-C<A>C<A>G-C<A>G-C<A>C<A>G-C<A>C<A>C<A>G-C<A>C<A>"
        CASE 17
            PLAY "C<A>G-E-CFE-CE-CFC<A>C<A>C<A>G-C<A>CG-"
        CASE 18
            PLAY "<A>C<A>G-E-CFE-CE-CFE-CE-CE-CFE-CFL16E-E-L8E-FE-CCE-"
        CASE 19
            PLAY "CFE-E-CE-E-CE-FE-CE-CE-CFE-L16CCL8CC"
        CASE 20
            PLAY "L8E-FE-CFE-CE-CFC<A>G-C<A>C<A>G-E-CCE-CFE-E-CE-FCE-"
        CASE 21
            PLAY "CFE-CE-CE-CFE-CE-CE-CFC<A>CG-<A>C<A>G-C<A>"
        CASE 22
            PLAY "<A>C<A>G-CC<A>C<A>C<A>G-CL16<A><A>L8<A>C<A>G-E-CFE-"
        CASE 23
            PLAY "CE-CFC<A><A>C<A>G-CC<A><A>C<A>G-C"
        CASE 24
            round = 0
    END SELECT
END SUB