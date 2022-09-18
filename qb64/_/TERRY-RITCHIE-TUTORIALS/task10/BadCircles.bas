'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST RED = _RGB32(127, 0, 0) '     define 5 colors
CONST GREEN = _RGB32(0, 127, 0)
CONST BLUE = _RGB32(0, 0, 127)
CONST PURPLE = _RGB32(127, 0, 127)
CONST CYAN = _RGB32(0, 127, 127)

DIM x1!, y1!, size1% ' circle 1 x,y coordinates, radius
DIM x2!, y2!, size2% ' circle 2 x,y coordinates, radius
DIM x3!, y3!, size3% ' circle 3 x,y coordinates, radius
DIM x4!, y4!, size4% ' circle 4 x,y coordinates, radius
DIM x5!, y5!, size5% ' circle 5 x,y coordinates, radius
DIM xdir1!, ydir1! '          x,y direction of circle 1
DIM xdir2!, ydir2! '          x,y direction of circle 2
DIM xdir3!, ydir3! '          x,y direction of circle 3
DIM xdir4!, ydir4! '          x,y direction of circle 4
DIM xdir5!, ydir5! '          x,y direction of circle 5

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '                  enter graphics screen
RANDOMIZE TIMER '                                 seed number generator
size1% = INT(RND(1) * 20) + 20 '                  random circle 1 size
size2% = INT(RND(1) * 20) + 20 '                  random circle 2 size
size3% = INT(RND(1) * 20) + 20 '                  random circle 3 size
size4% = INT(RND(1) * 20) + 20 '                  random circle 4 size
size5% = INT(RND(1) * 20) + 20 '                  random circle 5 size
x1! = INT(RND(1) * (639 - size1% * 2)) + size1% ' random circle 1 x coordinate
x2! = INT(RND(1) * (639 - size2% * 2)) + size2% ' random circle 2 x coordinate
x3! = INT(RND(1) * (639 - size3% * 2)) + size3% ' random circle 3 x coordinate
x4! = INT(RND(1) * (639 - size4% * 2)) + size4% ' random circle 4 x coordinate
x5! = INT(RND(1) * (639 - size5% * 2)) + size5% ' random circle 5 x coordinate
y1! = INT(RND(1) * (479 - size1% * 2)) + size1% ' random circle 1 y coordinate
y2! = INT(RND(1) * (479 - size2% * 2)) + size2% ' random circle 2 y coordinate
y3! = INT(RND(1) * (479 - size3% * 2)) + size3% ' random circle 3 y coordinate
y4! = INT(RND(1) * (479 - size4% * 2)) + size4% ' random circle 4 y coordinate
y5! = INT(RND(1) * (479 - size5% * 2)) + size5% ' random circle 5 y coordinate
DO
    xdir1! = RND(1) - RND(1) '                    random circle 1 x direction
LOOP UNTIL xdir1! <> 0 '                          loop back if it's 0
DO
    xdir2! = RND(1) - RND(1) '                    random circle 2 x direction
LOOP UNTIL xdir2! <> 0 '                          loop back if it's 0
DO
    xdir3! = RND(1) - RND(1) '                    random circle 3 x direction
LOOP UNTIL xdir3! <> 0 '                          loop back if it's 0
DO
    xdir4! = RND(1) - RND(1) '                    random circle 4 x direction
LOOP UNTIL xdir4! <> 0 '                          loop back if it's 0
DO
    xdir5! = RND(1) - RND(1) '                    random circle 5 x direction
LOOP UNTIL xdir5! <> 0 '                          loop back if it's 0
DO
    ydir1! = RND(1) - RND(1) '                    random circle 1 y direction
LOOP UNTIL ydir1! <> 0 '                          loop back if it's 0
DO
    ydir2! = RND(1) - RND(1) '                    random circle 2 y direction
LOOP UNTIL ydir2! <> 0 '                          loop back if it's 0
DO
    ydir3! = RND(1) - RND(1) '                    random circle 3 y direction
LOOP UNTIL ydir3! <> 0 '                          loop back if it's 0
DO
    ydir4! = RND(1) - RND(1) '                    random circle 4 y direction
LOOP UNTIL ydir4! <> 0 '                          loop back if it's 0
DO
    ydir5! = RND(1) - RND(1) '                    random circle 5 y direction
LOOP UNTIL ydir5! <> 0 '                          loop back if it's 0

DO '                                              begin main program loop
    CLS '                                         clear the screen
    _LIMIT 240
    x1! = x1! + xdir1! '                          change circle 1 x location
    IF x1! < size1% OR x1! > 639 - size1% THEN '  did circle 1 hit side of screen?
        xdir1! = -xdir1! '                        yes, reverse circle 1 x direction
    END IF
    x2! = x2! + xdir2! '                          change circle 2 x location
    IF x2! < size2% OR x2! > 639 - size2% THEN '  did circle 2 hit side of screen?
        xdir2! = -xdir2! '                        yes, reverse circle 2 x direction
    END IF
    x3! = x3! + xdir3! '                          change circle 3 x location
    IF x3! < size3% OR x3! > 639 - size3% THEN '  did circle 3 hit side of screen?
        xdir3! = -xdir3! '                        yes, reverse circle 3 x direction
    END IF
    x4! = x4! + xdir4! '                          change circle 4 x location
    IF x4! < size4% OR x4! > 639 - size4% THEN '  did circle 4 hit side of screen?
        xdir4! = -xdir4! '                        yes, reverse circle 4 x direction
    END IF
    x5! = x5! + xdir5! '                          change circle 5 x location
    IF x5! < size5% OR x5! > 639 - size5% THEN '  did circle hit side of screen?
        xdir5! = -xdir5! '                        yes, reverse circle 5 x direction
    END IF
    y1! = y1! + ydir1! '                          change circle 1 y location
    IF y1! < size1% OR y1! > 479 - size1% THEN '  did circle 1 hit side of screen?
        ydir1! = -ydir1! '                        yes, reverse circle 1 y direction
    END IF
    y2! = y2! + ydir2! '                          change circle 2 y location
    IF y2! < size2% OR y2! > 479 - size2% THEN '  did circle 2 hit side of screen?
        ydir2! = -ydir2! '                        yes, reverse circle 2 y direction
    END IF
    y3! = y3! + ydir3! '                          change circle 3 y location
    IF y13 < size3% OR y3! > 479 - size3% THEN '  did circle 3 hit side of screen?
        ydir3! = -ydir3! '                        yes, reverse circle 3 y direction
    END IF
    y4! = y4! + ydir4! '                          change circle 4 y location
    IF y4! < size4% OR y4! > 479 - size4% THEN '  did circle 4 hit side of screen?
        ydir4! = -ydir4! '                        yes, reverse circle 4 y direction
    END IF
    y5! = y5! + ydir5! '                          change circle 5 y location
    IF y5! < size5% OR y5! > 479 - size5% THEN '  did circle 5 hit side of screen?
        ydir5! = -ydir5! '                        yes, reverse circle 5 y direction
    END IF
    CIRCLE (x1!, y1!), size1%, RED '              draw circle 1
    PAINT (x1!, y1!), RED, RED '                  paint circle 1
    CIRCLE (x2!, y2!), size2%, GREEN '            draw circle 2
    PAINT (x2!, y2!), GREEN, GREEN '              paint circle 2
    CIRCLE (x3!, y3!), size3%, BLUE '             draw circle 3
    PAINT (x3!, y3!), BLUE, BLUE '                paint circle 3
    CIRCLE (x4!, y4!), size4%, PURPLE '           draw circle 4
    PAINT (x4!, y4!), PURPLE, PURPLE '            paint circle 4
    CIRCLE (x5!, y5!), size5%, CYAN '             draw circle 5
    PAINT (x5!, y5!), CYAN, CYAN '                paint circle 5
    _DISPLAY '                                    update screen with changes
LOOP UNTIL _KEYDOWN(27) '                         leave loop when ESC key pressed
SYSTEM '                                          return to Windows



























