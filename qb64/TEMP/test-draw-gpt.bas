SCREEN 12 ' Set screen mode with high resolution and 16 colors

COLOR 14, 0 ' Yellow on black background
CLS

' Move to the starting point (center of screen)
PSET (320, 240)

' DRAW string explanation:
' "TA100" -> turn absolute to angle 100 (36° increments for a 10-point star)
' "U100"  -> draw up 100 pixels
' "TA180", "U100" and so on rotates to a new angle and draws out from center
DRAW "C3;TA 0;U 100;TA 144;U 100;TA 288;U 100;TA 72;U 100;TA 216;U 100"

' Wait for key press before ending
SLEEP
