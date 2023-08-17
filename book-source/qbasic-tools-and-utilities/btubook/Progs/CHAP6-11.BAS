'*********** CHAP6-11.BAS

'Copyright (c) 1992 Ethan Winer

Value# = 123.45678#

OPEN "\DEV\NUL" FOR RANDOM AS #1 LEN = 15
FIELD #1, 15 AS Format$

LSET Format$ = ""                 'clear any old remnants
PRINT #1, USING "###.##"; Value#; 'let USING do the work
Fmt$ = RTRIM$(Format$)            'trim trailing blanks

PRINT "    Value:"; Value#
PRINT "Formatted: "; Fmt$
