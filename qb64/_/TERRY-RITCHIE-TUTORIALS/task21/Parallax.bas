'** Demo Parallax Scrolling
'** Layer Images: https://en.wikipedia.org/wiki/Parallax_scrolling

DIM Sky& '      handle to hold image of sky
DIM Ground& '   handle to hold image of ground
DIM Pillars& '  handle to hold image of pillars
DIM SkyX% '     sky image x location
DIM GroundX% '  ground image x location
DIM PillarsX% ' pillars image x location

Sky& = _LOADIMAGE("sky.png", 32) '          load sky image
Ground& = _LOADIMAGE("tground.png", 32) '   load ground image
Pillars& = _LOADIMAGE("tpillars.png", 32) ' load pillars image
SCREEN _NEWIMAGE(640, 480, 32) '                  create graphics csreen
DO
    _LIMIT 60
    CLS '                                         clear screen
    _PUTIMAGE (SkyX%, 0), Sky& '                  place sky image
    _PUTIMAGE (SkyX% - 640, 0), Sky& '            place second sky image
    _PUTIMAGE (PillarsX%, 0), Pillars& '          place pillars image
    _PUTIMAGE (PillarsX% - 640, 0), Pillars& '    place second pillars image
    _PUTIMAGE (GroundX%, 0), Ground& '            place ground image
    _PUTIMAGE (GroundX% - 640, 0), Ground& '      place second ground image
    IF _KEYDOWN(19200) THEN '                     left arrow key down?
        SkyX% = SkyX% - 1 '                       yes, decrement sky x position
        IF SkyX% = -1 THEN SkyX% = 639 '          keep image within limits
        PillarsX% = PillarsX% - 2 '               decrement pillars x position
        IF PillarsX% = -2 THEN PillarsX% = 638 '  keep image within limits
        GroundX% = GroundX% - 4 '                 decrement ground x position
        IF GroundX% = -4 THEN GroundX% = 636 '    keep image within limits
    END IF
    IF _KEYDOWN(19712) THEN '                     right arrow key down?
        SkyX% = SkyX% + 1 '                       yes, increment sky x position
        IF SkyX% = 640 THEN SkyX% = 0 '           keep image within limits
        PillarsX% = PillarsX% + 2 '               increment pillars x position
        IF PillarsX% = 640 THEN PillarsX% = 2 '   keep image within limits
        GroundX% = GroundX% + 4 '                 increment ground x position
        IF GroundX% = 640 THEN GroundX% = 4 '     keep image within limits
    END IF
    _DISPLAY '                                    update screen with changes
LOOP UNTIL _KEYDOWN(27) '                         leave loop if ESC pressed
_FREEIMAGE Sky& '                                 remove images from memory
_FREEIMAGE Ground&
_FREEIMAGE Pillars&
SYSTEM '                                          return to Windows


















