'*************************************************
' DISCOLIT.BAS = Lichtorgel mit den Tastatur-LEDs
' ============
' (c) http://hem.passagen.se/einarb/
'*************************************************
DEF SEG = 0
s% = PEEK(&H417)
POKE &H417, &HC0
WHILE INKEY$ = ""
  POKE &H417, (PEEK(&H417) XOR &HF0)
  starttime! = TIMER
  DO: LOOP UNTIL TIMER > starttime! + .1
WEND
POKE &H417, s%

