REM Blanking Colored Pixels
REM \CHAP8\CH8_11.BAS

SCREEN 9: CLS
n% = 4000 'Number of points
DIM x%(n%), y%(n%)
RANDOMIZE 1
FOR i% = 1 TO n%
    x%(i%) = INT(RND * 639)
    y%(i%) = INT(RND * 349)
    PSET (x%(i%), y%(i%)), RND * 14 + 1
NEXT i%

f$ = INPUT$(1)

FOR i% = 1 TO n%
    PRESET (x%(i%), y%(i%))
    a = SIN(1)
NEXT i%

