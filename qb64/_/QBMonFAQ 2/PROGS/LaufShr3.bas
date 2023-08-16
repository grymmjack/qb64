'*********************************************************************
' LAUFSHR3.BAS = Scolls Text horizontally on the Screen
' ============
' A text scrolls fom right to left and disappears
' on the left side of the screen
' (c) Buff
'*********************************************************************
text$ = "This is the text message I want to scroll across the screen."
FOR k = 1 TO LEN(text$)
  LOCATE 12, 70 - k
  PRINT MID$(text$, 1, k); " ";
  time = TIMER: DO: LOOP WHILE TIMER < time + .02 '.02 sec pause
NEXT k
 'to scroll text off the page include the following also.
FOR k = 1 TO LEN(text$) + 1
   LOCATE 12, 70 - LEN(text$)
   PRINT MID$(text$ + " ", k); SPACE$(k);
   time = TIMER: DO: LOOP WHILE TIMER < time + .1
    '.06 sec pause for slow scrolling
NEXT k

