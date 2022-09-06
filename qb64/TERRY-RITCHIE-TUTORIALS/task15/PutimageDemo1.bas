'**      Putimage Demo 1
'**
'** _PUTIMAGE (x%, y%), Image&

DIM Bee& '     the image file
DIM cx%, cy% ' center x,y coordinate for image

Bee& = _LOADIMAGE("tbee0.png", 32) '  load image file into memory
SCREEN _NEWIMAGE(640, 480, 32) '                        enter a graphics screen
CLS , _RGB32(127, 127, 127) '                           clear the screen with gray
LOCATE 2, 15 '                                          position text cursor
PRINT "An image loaded into memory and placed on the screen."
cx% = (640 - _WIDTH(Bee&)) \ 2 '                        calculate x center position
cy% = (480 - _HEIGHT(Bee&)) \ 2 '                       calculate y center position
_PUTIMAGE (cx%, cy%), Bee& '                            place image onto center of screen
SLEEP '                                                 wait for key stroke
_FREEIMAGE Bee& '                                       remove image from memory
SYSTEM '                                                return to OS

