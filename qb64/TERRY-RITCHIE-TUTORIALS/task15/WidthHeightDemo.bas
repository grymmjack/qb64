DIM Sky& '       handle to hold sky image
DIM SkyWidth% '  width of sky image
DIM SkyHeight% ' height of sky image

Sky& = _LOADIMAGE("sky.png", 32) '                  load image into RAM
SkyWidth% = _WIDTH(Sky&) '                                get image width
SkyHeight% = _HEIGHT(Sky&) '                              get image height
SCREEN _NEWIMAGE(SkyWidth%, SkyHeight%, 32) '             creat graphics screen
PRINT '                                                   inform user of results
PRINT " This screen matches the dimensions of sky.png."
PRINT
PRINT " Width  ="; SkyWidth%
PRINT " Height ="; SkyHeight%
SLEEP '                                                   wait for keystroke


