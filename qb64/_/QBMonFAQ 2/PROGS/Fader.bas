'**************************************************************************
' FADER.BAS = Fades a text from dark to light and vice versa
' =========   Erzeugt einen dunkel-hell-Farbverlauf fuer einen Text
'
' An example of how to sucessfully fade on and fade off different color
' values based on different color values.
' For the discretion of all QuickBASIC users and anyone else. Please feel
' free to distribute this file anyway you like and make a buck if you can!
'
' (c) Released by Calvin French to the Public Domain.
'**************************************************************************
'
DEFINT A-Z
DECLARE SUB Fade (text$, red, blue, green)
'
SCREEN 12        'works ok in screen 13 too!
'
starting:
LOCATE 2, 1
COLOR 10
INPUT "Text To Fade ? ", text$
IF text$ = "0" THEN END
INPUT "Red Level (0...62) ? ", red
IF red > 63 OR red < 0 THEN GOTO DontDoThat
INPUT "Green Level (0...62) ? ", green
IF green > 63 OR blue < 0 THEN GOTO DontDoThat
INPUT "Blue Level (0...62) ? ", blue
IF blue > 63 OR blue < 0 THEN GOTO DontDoThat
'
CALL Fade(text$, red, blue, green)
END
'
DontDoThat:
CLS
LOCATE 1, 1
COLOR 4
PRINT "Valid Numbers Between 0 and 62"
GOTO starting

SUB Fade (text$, red, blue, green)
bluestep! = blue / 63
greenstep! = green / 63
redstep! = red / 63
'
COLOR 1
'
'----- dark -> light fader
FOR i = 0 TO 63 STEP 1
     PALETTE 1, (blue * 65536) + (green * 256) + red
     bluetemp! = bluetemp! + bluestep!
     greentemp! = greentemp! + greenstep!
     redtemp! = redtemp! + redstep!
     blue = bluetemp!
     green = greentemp!
     red = redtemp!
     PRINT text$
     t& = TIMER: DO: LOOP UNTIL TIMER > time6 + .2
NEXT i
'
'----- light -> dark fader
FOR i = 63 TO 0 STEP -1
     PALETTE 1, (blue * 65536) + (green * 256) + red
     bluetemp! = bluetemp! - bluestep!
     greentemp! = greentemp! - greenstep!
     redtemp! = redtemp! - redstep!
     blue = bluetemp!
     green = greentemp!
     red = redtemp!
     PRINT text$
     t& = TIMER: DO: LOOP UNTIL TIMER > time6 + .2
NEXT i
'
COLOR 15
END SUB

