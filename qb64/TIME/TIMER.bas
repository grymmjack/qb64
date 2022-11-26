
TIMER ON ' enable timer event trapping
LOCATE 4, 2 ' set the starting PRINT position
ON TIMER(10) GOSUB Clock ' set procedure execution repeat time
DO WHILE INKEY$ = "": PRINT "A"; : SLEEP 6: LOOP
TIMER OFF
SYSTEM

Clock:
  row = CSRLIN ' Save current print cursor row.
  col = POS(0) ' Save current print cursor column.
  LOCATE 2, 37: PRINT TIME$; ' print current time at top of screen.
  LOCATE row, col ' return to last print cursor position 
RETURN 
