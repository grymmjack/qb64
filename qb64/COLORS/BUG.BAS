CANVAS& = _NEWIMAGE(800 ,600, 32) ' I have also tried with 256 - the same issues occur
SCREEN CANVAS&

w = 512
h = 256
x = (800-w) \ 2
y = (600-h) \ 2

img& = _LOADIMAGE("STARFIGHTER-VGA.png", 256)

_PUTIMAGE (x,y), img&, CANVAS&

_CHDIR _STARTDIR$