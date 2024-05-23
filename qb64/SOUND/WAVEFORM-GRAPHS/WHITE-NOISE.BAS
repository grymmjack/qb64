DIM AS DOUBLE t, f
DIM AS INTEGER x, y, screenWidth, screenHeight, centerX, centerY
DIM AS LONG scale

f = 440  ' Frequency in Hz (not used in white noise, but kept for consistency)

' Set up graphics screen
screenWidth = 800
screenHeight = 600
SCREEN _NEWIMAGE(screenWidth, screenHeight, 32)
COLOR _RGB32(255, 255, 255), _RGB32(0, 0, 0)
CLS

' Center of the screen
centerX = screenWidth / 2
centerY = screenHeight / 2

' Scale for the graph (adjust as needed)
scale = 100000

' Draw axes
LINE (0, centerY)-(screenWidth, centerY), _RGB32(255, 255, 255)
LINE (centerX, 0)-(centerX, screenHeight), _RGB32(255, 255, 255)

' Plot the white noise wave
DIM prevX AS INTEGER, prevY AS INTEGER
prevX = 0
prevY = centerY - (white_noise * centerY / 2)

FOR x = 1 TO screenWidth
    y = centerY - (white_noise * centerY / 2)
    LINE (prevX, prevY)-(x, y), _RGB32(0, 255, 0)
    prevX = x
    prevY = y
NEXT x

FUNCTION white_noise# ()
    white_noise# = RND * 2 - 1
END FUNCTION
