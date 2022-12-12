REM Part one of 'direct VRAM access' v 'Built-in commands'
REM \CHAP8\CH8_2.BAS

CLS
t0 = TIMER
DEF SEG = &HB800
FOR a% = 0 TO 4000 STEP 2
    POKE a%, 72
NEXT a%
LOCATE 1, 1: PRINT TIMER - t0; "  ";
