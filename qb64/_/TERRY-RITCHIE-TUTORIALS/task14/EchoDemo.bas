DIM Phaser&

Phaser& = _SNDOPEN("Phaser.ogg")

PRINT
PRINT " Press ENTER to fire phaser or ESC to quit."
DO
    IF _KEYDOWN(13) THEN
        _SNDPLAYCOPY Phaser&
        _DELAY .25
        _SNDPLAYCOPY Phaser&, .25
        _DELAY .25
        _SNDPLAYCOPY Phaser&, .1
    END IF
LOOP UNTIL _KEYDOWN(27)
_SNDCLOSE Phaser&

