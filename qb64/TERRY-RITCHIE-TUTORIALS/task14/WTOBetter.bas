DIM WilliamTell& ' handle to hold sound file

CLS '                                                     inform user
LOCATE 12, 28
PRINT "The William Tell Overture."
LOCATE 13, 30
PRINT "(press any key to end)"
WilliamTell& = _SNDOPEN(".\tutorial\task14\WilliamTell.ogg") ' load OGG file into RAM
_SNDPLAY WilliamTell& '                                   play OGG file from RAM
SLEEP '                                                   wait for a key press
IF _SNDPLAYING(WilliamTell&) THEN _SNDSTOP WilliamTell& ' stop sound if playing
_SNDCLOSE WilliamTell& '                                  remove OGG from RAM
SYSTEM '                                                  return to Windows

