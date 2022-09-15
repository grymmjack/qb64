'$INCLUDE:'ANSI.BI'

' Setup the console
$CONSOLE:ONLY
_DEST _CONSOLE
_CONTROLCHR OFF
LOCATE 1,1,1 ' Initialize the cursor and turn it on
CONST FALSE = 0, TRUE = NOT FALSE
CONST TEST_ANSI_OUTPUT = TRUE
test_ansi_home
test_ansi_locate

PRINT "All tests complete, press a key." : anykey
CLS



SUB anykey()
    SLEEP
    DO: K$ = INKEY$: PRINT K$: LOOP UNTIL K$ = "" 
END SUB


SUB test_complete()
    CLS
    PRINT "Test complete, press a key."
    anykey
END SUB


SUB test_ansi_locate()
    PRINT "Press a key to locate to corners of the screen with ansi_locate()...";
    anykey
    CLS
    w  = _WIDTH(0)
    h  = _HEIGHT(0)
    cw = w \ 2 - 2
    ch = h \ 2 - 1
    w$ = _TRIM$(STR$(w-1))
    h$ = _TRIM$(STR$(h))
    nil$ = ansi_locate(ch,     cw)   : PRINT "A = 1,1"
    nil$ = ansi_locate(ch + 1, cw)   : PRINT "B = 1," + w$
    nil$ = ansi_locate(ch + 2, cw)   : PRINT "C = " + h$ + ",1"
    nil$ = ansi_locate(ch + 3, cw)   : PRINT "D = " + w$ + "," + h$
    nil$ = nil$ + ansi_locate(1,1)   : PRINT "A"
    nil$ = nil$ + ansi_locate(1,w-1) : PRINT "B"
    nil$ = nil$ + ansi_locate(h,1)   : PRINT "C"
    nil$ = nil$ + ansi_locate(h,w-1) : PRINT "D";
    IF TEST_ANSI_OUTPUT THEN PRINT nil$
    anykey : test_complete
END SUB


SUB test_ansi_home()
    fill_screen_with_text
    PRINT "Press any key to clear the screen with ansi_home()...";
    anykey
    nil$ = ansi_home
    IF TEST_ANSI_OUTPUT THEN PRINT nil$
    anykey : test_complete
END SUB


SUB fill_screen_with_text()
    CLS
    LOCATE 1,1
    FOR y = 0 TO _HEIGHT(0)
        PRINT STRING$(_WIDTH(0) - 1, "*")
    NEXT y
END SUB

'$INCLUDE:'ANSI.BM'