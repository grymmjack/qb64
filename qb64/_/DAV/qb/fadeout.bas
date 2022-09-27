'===============
'=== FADEOUT.BAS
'===============
'=== Fades screen out to given color.
'=== Fading speed can be controled.
'=== Coded by Dav 
'====================================================

DEFINT A-Z
DECLARE SUB FADEOUT (red%, grn%, blu%, speed%)

SCREEN 13

'=== Draw random balls and
'=== show the fading effect

FOR d% = 1 TO 500
    clr% = 16
    x% = RND * 320
    y% = RND * 200
    '=== draw a ball
    FOR z% = (RND * 16) TO 1 STEP -1
      CIRCLE (x%, y%), z%, clr%
      PAINT (x%, y%), clr%
      clr% = clr% + 1
    NEXT
NEXT

'=== Fade to bright red (RGB color)

FADEOUT 63, 11, 22, 100

'=== Now fade out to black (0,0,0)

FADEOUT 0, 0, 0, 50

'=== Now fade out to white

FADEOUT 63, 63, 63, 25

'=== Restore to default pallette

PALETTE
END

SUB FADEOUT (red%, grn%, blu%, speed%)
'=======================================
'=== Fade screen out to given color.
'=== Color is in RGB format.
'=== speed% = fading speed. 1 is fastest.
'=======================================

'=== Make sure RGB values stayed in bounds

IF red% < 0 THEN red% = 0
IF grn% < 0 THEN grn% = 0
IF blu% < 0 THEN blu% = 0
IF red% > 63 THEN red% = 63
IF grn% > 63 THEN grn% = 63
IF blu% > 63 THEN blu% = 63
IF speed% < 1 THEN speed% = 1

'=== Cycle through colors

FOR p% = 0 TO 63
    FOR c% = 0 TO 255
      '=== read current values
      OUT 967, c%
      r% = INP(969) 'red value
      g% = INP(969) 'green value
      b% = INP(969) 'blue value
      '=== adjust values
      IF r% < red% THEN r% = r% + 1
      IF r% > red% THEN r% = r% - 1
      IF g% < grn% THEN g% = g% + 1
      IF g% > grn% THEN g% = g% - 1
      IF b% < blu% THEN b% = b% + 1
      IF b% > blu% THEN b% = b% - 1
      '=== change to new values
      OUT 968, c%
      OUT 969, r%
      OUT 969, g%
      OUT 969, b%
    NEXT
    '=== A pause for the cause
    FOR dly% = 1 TO speed%
      WAIT 986, 8
    NEXT
NEXT

END SUB

