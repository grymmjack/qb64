'**      Putimage Demo 2
'**
'** _PUTIMAGE (x%, y%), ImageSource&, ImageDestination&

DIM Bee& '     the image file
DIM Square& '  a square image
DIM cx%, cy% ' center x,y coordinates

Bee& = _LOADIMAGE("tbee0.png", 32) '  load bee image file into memory
Square& = _NEWIMAGE(320, 320, 32) '                     create image smaller than screen in memory
_DEST Square& '                                         square image is now destination
CLS , _RGB32(255, 0, 255) '                             clear square with bright magenta (yuck)
SCREEN _NEWIMAGE(640, 480, 32) '                        enter a graphics screen (becomes new destination)
CLS , _RGB32(127, 127, 127) '                           clear the screen with gray
LOCATE 2, 12 '                                          position text cursor
PRINT "A square image that had a bee image placed onto it first."
cx% = (320 - _WIDTH(Bee&)) \ 2 '                        calculate x center position on square
cy% = (320 - _HEIGHT(Bee&)) \ 2 '                       calculate y center position on square
_PUTIMAGE (cx%, cy%), Bee&, Square& '                   place bee image onto center of square image
cx% = (640 - _WIDTH(Square&)) \ 2 '                     calculate x center position on screen
cy% = (480 - _WIDTH(Square&)) \ 2 '                     calculate y center position on screen
_PUTIMAGE (cx%, cy%), Square& '                         place square image centered on screen
SLEEP '                                                 wait for key stroke
_FREEIMAGE Bee& '                                       remove bee image from memory
_FREEIMAGE Square& '                                    remove square image from memory
SYSTEM '                                                return to OS

