DIM Phaser&
DIM Count%

Phaser& = _SNDOPEN(".\tutorial\task14\Phaser.ogg")

PRINT
PRINT " Rapid phaser using _SNDPLAY."
_DELAY 1
FOR Count% = 1 TO 20
    _SNDPLAY Phaser&
    _DELAY .125
NEXT Count%
PRINT
PRINT " Rapid phaser using _SNDPLAYCOPY."
_DELAY 1
FOR Count% = 1 TO 20
    _SNDPLAYCOPY Phaser&, .75
    _DELAY .125
NEXT Count%
_SNDCLOSE Phaser&

