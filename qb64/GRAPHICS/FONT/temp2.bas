'mode 33 copyimage test

SCREEN _NEWIMAGE(800, 600, 32)

LINE (100, 100)-(200, 200), -1, BF 'white box to keep things simple


h2& = _COPYIMAGE(0, 33) '<------    make a copy of the screen and make it a hardware copy
SLEEP

CLS
_PUTIMAGE , h2& 'put the hardware image over the screen  (they're separate layers, so you can overlap them)
_DISPLAY 'hardware images require a DISPLAY statement to render
SLEEP
END 'notice how the hardware image disappeared?  It's not part of the software screen at all.
'    which is why you have to call _DISPLAY to have them appear.