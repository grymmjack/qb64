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
PRINT "TRIANGLE WAVEFORM"

' Center of the screen
centerX = screenWidth / 2
centerY = screenHeight / 2

' Scale for the graph (adjust as needed)
scale = 100000

' Draw axes
LINE (0, centerY)-(screenWidth, centerY), _RGB32(255, 255, 255)
LINE (centerX, 0)-(centerX, screenHeight), _RGB32(255, 255, 255)

' Plot the triangle wave
DIM prevX AS INTEGER, prevY AS INTEGER
prevX = 0
prevY = centerY - (triangle_wave(0 / scale, f) * centerY / 2)

FOR x = 1 TO screenWidth
    t = x / scale  ' Adjust time scale for better visualization
    y = centerY - (triangle_wave(t, f) * centerY / 2)
    LINE (prevX, prevY)-(x, y), _RGB32(0, 255, 0)
    prevX = x
    prevY = y
NEXT x

FUNCTION triangle_wave# (t AS DOUBLE, f AS DOUBLE)
    triangle_wave = 2 * ABS(2 * ((t * f) - INT(t * f + 0.5))) - 1
END FUNCTION
