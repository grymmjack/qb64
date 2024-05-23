DIM AS DOUBLE t, f, duty_cycle
DIM AS INTEGER x, y, screenWidth, screenHeight, centerX, centerY
DIM AS LONG scale

f = 440  ' Frequency in Hz
duty_cycle = 0.3  ' Duty cycle as a fraction (e.g., 0.3 for 30%)

' Set up graphics screen
screenWidth = 800
screenHeight = 600
SCREEN _NEWIMAGE(screenWidth, screenHeight, 32)
COLOR _RGB32(255, 255, 255), _RGB32(0, 0, 0)
CLS
PRINT "PULSE WAVEFORM"

' Center of the screen
centerX = screenWidth / 2
centerY = screenHeight / 2

' Scale for the graph (adjust as needed)
scale = 100000

' Draw axes
LINE (0, centerY)-(screenWidth, centerY), _RGB32(255, 255, 255)
LINE (centerX, 0)-(centerX, screenHeight), _RGB32(255, 255, 255)

' Plot the pulse wave
DIM prevX AS INTEGER, prevY AS INTEGER
prevX = 0
prevY = centerY - (pulse_wave(0 / scale, f, duty_cycle) * centerY / 2)

FOR x = 1 TO screenWidth
    t = x / scale  ' Adjust time scale for better visualization
    y = centerY - (pulse_wave(t, f, duty_cycle) * centerY / 2)
    LINE (prevX, prevY)-(x, y), _RGB32(0, 255, 0)
    prevX = x
    prevY = y
NEXT x

FUNCTION pulse_wave# (t AS DOUBLE, f AS DOUBLE, duty_cycle AS DOUBLE)
    IF (t * f) - INT(t * f) < duty_cycle THEN
        pulse_wave = 1
    ELSE
        pulse_wave = -1
    END IF
END FUNCTION
