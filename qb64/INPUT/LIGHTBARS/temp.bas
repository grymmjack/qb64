TYPE FOO
    bar AS INTEGER
END TYPE
DIM res AS INTEGER
DIM bops(1 TO 2) AS FOO
res% = baz(bops())
PRINT res%

FUNCTION baz%(bips() AS FOO)
    PRINT UBOUND(bips)
    baz% = LBOUND(bips)
END FUNCTION