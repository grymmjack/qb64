DIM WilliamTell& ' handle to hold sound file
DIM Volume! '      current sound volume

Volume! = 1 '                                             set initial volume (100%)
CLS '                                                     print instructions to user
LOCATE 12, 28
PRINT "The William Tell Overture."
LOCATE 13, 30
PRINT "(press ESC key to end)"
LOCATE 15, 23
PRINT "UP/DOWN arrow keys to change volume."
WilliamTell& = _SNDOPEN(".\tutorial\task14\WilliamTell.ogg") ' load OGG into RAM
_SNDPLAY WilliamTell& '                                   play OGG file from RAM
_SNDVOL WilliamTell&, Volume! '                           set OGG volume
DO '                                                      MAIN LOOP begin
    _LIMIT 30 '                                           30 loops per second
    LOCATE 18, 31 '                                       display volume and balance
    PRINT "Current volume :"; RTRIM$(STR$(INT(Volume! * 100))); "%  " 'show volume
    IF _KEYDOWN(18432) THEN '                             up arrow pressed?
        Volume! = Volume! + .01 '                         yes, increase volume
        IF Volume! > 1 THEN Volume! = 1 '                 keep volume within limits
        _SNDVOL WilliamTell&, Volume! '                   set OGG volume
    END IF
    IF _KEYDOWN(20480) THEN '                             down arrow pressed?
        Volume! = Volume! - .01 '                         yes, decrease volume
        IF Volume! < 0 THEN Volume! = 0 '                 keep volume within limits
        _SNDVOL WilliamTell&, Volume! '                   set OGG volume
    END IF
LOOP UNTIL _KEYDOWN(27) OR NOT _SNDPLAYING(WilliamTell&) 'MAIN LOOP back
IF _SNDPLAYING(WilliamTell&) THEN _SNDSTOP WilliamTell& ' stop sound if playing
_SNDCLOSE WilliamTell& '                                  remove OGG from RAM

