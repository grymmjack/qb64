TYPE Example
Parameter1 AS INTEGER
Parameter2 AS INTEGER
Parameter3 AS _MEM
END TYPE

DIM test AS Example: test.Parameter3 = _MEMNEW(2 * 10) ' sizeof Integer * Number of elements

setter test, 2, 5
setter test, 6, 3
setter test, 9, 1

PRINT getter(test, 2)
PRINT getter(test, 6)
PRINT getter(test, 9)

SUB setter (test AS Example, index AS LONG, value AS INTEGER)
_MEMPUT test.Parameter3, test.Parameter3.OFFSET + (index * 2), value AS INTEGER
END SUB

FUNCTION getter% (test AS Example, index AS LONG)
getter = _MEMGET(test.Parameter3, test.Parameter3.OFFSET + (index * 2), INTEGER)
END FUNCTION