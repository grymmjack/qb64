DIM s AS STRING
s$ = "foo bar baz bop bobo bilbo frodo"
PRINT "12345678901234567890123456789012"
PRINT s$
PRINT "   4   8   1   1    2     2"
PRINT "           2   6    1     7"
PRINT CHR$(34) + MID$(s$, 0, 4) + CHR$(34)
PRINT CHR$(34) + MID$(s$, 4+1, 8-4-1) + CHR$(34)
PRINT CHR$(34) + MID$(s$, 4+1, 8-4-1) + CHR$(34)