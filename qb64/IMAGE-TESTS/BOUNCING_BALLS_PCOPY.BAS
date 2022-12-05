_FULLSCREEN _SQUAREPIXELS
SCREEN 7, 0, 1, 0
DIM x(10), y(10), dx(10), dy(10)
FOR a = 1 TO 10
    x(a) = INT(RND * 320) + 1
    y(a) = INT(RND * 200) + 1
    dx(a) = (RND * 2) - 1
    dy(a) = (RND * 2) - 1
NEXT
DO
    PCOPY 1, 0                           'place image on the visible page 0
    CLS
    _LIMIT 100                           'regulates speed of balls in QB64
    FOR a = 1 TO 10     
        CIRCLE(x(a), y(a)), 5, 15          'all erasing and drawing is done on page 1
        x(a) = x(a) + dx(a)
        y(a) = y(a) + dy(a)
        IF x(a) > 320 THEN dx(a) = -dx(a): x(a) = x(a) - 1
        IF x(a) < 0 THEN dx(a) = -dx(a): x(a) = x(a) + 1
        IF y(a) > 200 THEN dy(a) = -dy(a): y(a) = y(a) - 1
        IF y(a) < 0 THEN dy(a) = -dy(a): y(a) = y(a) + 1
    NEXT
LOOP UNTIL INKEY$ = CHR$(27) ' escape exit
