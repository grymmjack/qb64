'** _SCREENIMAGE Prank Demo

DIM Desktop& '    desktop screen shot
DIM BulletHole& ' bullet hole image
DIM GunShot& '    gun shot sound
DIM x%, y% '      x,y location of bullet hole

Desktop& = _SCREENIMAGE '                                               grab screen shot
SCREEN Desktop& '                                                       create screen from screen shot
_FULLSCREEN '                                                           go full screen
BulletHole& = _LOADIMAGE("bullethole.png", 32) '      load bullet hole image
GunShot& = _SNDOPEN("gunshot.ogg") '                  load gun shot sound
DO '                                                                    main program loop
    _LIMIT 30 '                                                         30 FPS
    WHILE _MOUSEINPUT: WEND '                                           get latest mouse information
    IF _MOUSEBUTTON(1) THEN '                                           left mouse button pressed?
        x% = _MOUSEX '                                                  yes, get mouse X coordinate
        y% = _MOUSEY '                                                  get mouse Y coordinate
        _PUTIMAGE (x% - 12, y% - 12)-(x% + 12, y% + 12), BulletHole& '  draw bullet hole at mouse pointer
        _SNDPLAY GunShot& '                                             give report
    END IF
LOOP UNTIL _KEYDOWN(27) '                                               leave when ESC pressed
SCREEN 0, 0, 0, 0 '                                                     enter text screen
_FREEIMAGE Desktop& '                                                   remove image from memory
_FREEIMAGE BulletHole& '                                                remove image from memory
_SNDCLOSE GunShot& '                                                    remove sound from memory
SYSTEM '                                                                return to Windows



