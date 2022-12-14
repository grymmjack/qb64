_TITLE "Bitmap Demo"

scrn& = _NEWIMAGE(800, 600, 32)
SCREEN scrn&
CLS , _RGB(0, 100, 100)
ship& = _LOADIMAGE("ship.png")

w = _WIDTH(ship&)
h = _HEIGHT(ship&)
x = 400 - w / 2
y = 300 - h / 2
_PUTIMAGE (x, y), ship&

_DISPLAY
SLEEP
END

