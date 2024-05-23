DIM AS DOUBLE t, f
DIM AS INTEGER x, y, screenWidth, screenHeight, centerX, centerY
DIM AS LONG scale

f = 440  ' Frequency in Hz

' Set up graphics screen
screenWidth = 800
screenHeight = 600
SCREEN _NEWIMAGE(screenWidth, screenHeight, 32)
COLOR _RGB32(255, 255, 255), _RGB32(0, 0, 0)
CLS
PRINT "SAWTOOTH UP WAVEFORM"

' Center of the screen
centerX = screenWidth / 2
centerY = screenHeight / 2

' Scale for the graph (adjust as needed)
scale = 100000

' Draw axes
LINE (0, centerY)-(screenWidth, centerY), _RGB32(255, 255, 255)
LINE (centerX, 0)-(centerX, screenHeight), _RGB32(255, 255, 255)

' Plot the sawtooth wave
DIM prevX AS INTEGER, prevY AS INTEGER
prevX = 0
prevY = centerY - (sawtooth(0 / scale, f) * centerY / 2)

FOR x = 1 TO screenWidth
    t = x / scale  ' Adjust time scale for better visualization
    y = centerY - (sawtooth(t, f) * centerY / 2)
    LINE (prevX, prevY)-(x, y), _RGB32(0, 255, 0)
    prevX = x
    prevY = y
NEXT x

FUNCTION sawtooth# (t AS DOUBLE, f AS DOUBLE)
    sawtooth = 2 * ((t * f) - INT(t * f)) - 1
END FUNCTION
