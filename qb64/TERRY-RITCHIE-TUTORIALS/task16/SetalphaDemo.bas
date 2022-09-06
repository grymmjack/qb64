'** Demo - transparent and non-transparent image

DIM Sky& '            sky image
DIM Bee& '            bee image (no transparency)
DIM TransparentBee& ' bee image (with transparency)

Sky& = _LOADIMAGE(".\tutorial\task16\sky.png", 32) '              load sky image
Bee& = _LOADIMAGE(".\tutorial\task16\bee0.png", 32) '             load bee image
_SETALPHA 0, _RGB32(255, 0, 255), Bee& '                          set bright magenta as transparent
TransparentBee& = _LOADIMAGE(".\tutorial\task16\tbee0.png", 32) ' load transparent bee image
SCREEN _NEWIMAGE(640, 480, 32) '                                  create graphics screen
_PUTIMAGE (0, 0), Sky& '                                          place sky image on screen
_PUTIMAGE (122, 171), Bee& '                                      place bee image on screen
_PUTIMAGE (392, 171), TransparentBee& '                           place transparent bee image on screen
SLEEP '                                                           wait for key stroke
SYSTEM '                                                          return to operating system


