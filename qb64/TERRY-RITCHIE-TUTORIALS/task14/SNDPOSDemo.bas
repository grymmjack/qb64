DIM WilliamTell&
DIM Seconds!

WilliamTell& = _SNDOPEN(".\tutorial\task14\WilliamTell.mp3")
PRINT
PRINT " The file WilliamTell.mp3 is 216 seconds long. Enter the number of seconds"
INPUT " to start the playing at > "; Seconds!
IF Seconds! < 0 OR Seconds! > 216 THEN END
_SNDSETPOS WilliamTell&, Seconds!
_SNDPLAY WilliamTell&
DO
    _LIMIT 60
    LOCATE 5, 2
    PRINT "Current position> "; _SNDGETPOS(WilliamTell&)
LOOP UNTIL _KEYDOWN(27) OR NOT _SNDPLAYING(WilliamTell&)
IF _SNDPLAYING(WilliamTell&) THEN _SNDSTOP WilliamTell&
_SNDCLOSE WilliamTell&

