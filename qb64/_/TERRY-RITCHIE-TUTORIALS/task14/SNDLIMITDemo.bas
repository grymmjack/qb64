DIM WilliamTell&
DIM Count%

WilliamTell& = _SNDOPEN("WilliamTell.ogg")
PRINT
PRINT " The first five seconds of the William Tell Overture"
PRINT
_SNDPLAY WilliamTell&
_SNDLIMIT WilliamTell&, 5
FOR Count% = 1 TO 6
    _DELAY 1
    PRINT Count%; "..";
NEXT Count%
_SNDCLOSE WilliamTell&






















