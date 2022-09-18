DIM Sky& ' sky.png image handle

Sky& = _LOADIMAGE("sky.png", 32)

'* currently in screen 0 (text only)

PRINT
PRINT "The sky.png file was loaded into memory."
PRINT "Press the enter key to use it as the default screen."
SLEEP

'* switch to graphics screen using loaded image

SCREEN Sky&
PRINT
PRINT "This is the sky.png image loaded by _LOADIMAGE."




