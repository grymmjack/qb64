'************************************************************************
' SPECKEYS.BAS - Status Display of <CTRL>, <ALT>, <SHIFT>, <NUMLOCK> etc.
' ============
' The <CTRL>, <ALT>, <SHIFT>, <NUMLOCK>, etc keys are all reported in
' 2 bytes and unless you're worried about right & left you'll only need
' one byte.
' You need to test the individual bits to see which of the keys are
' depressed or in an ON state.
'
' (c)  Don Schullian Oct 21, 1998
'************************************************************************
DO
DEF SEG = 0
K% = PEEK(&H417)
PRINT K%
DEF SEG
LOOP

