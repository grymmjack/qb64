 
TYPE POINTAPI
    x AS LONG
    y AS LONG
END TYPE
DIM apixy AS POINTAPI 'mouse x/y for the GetCursorPos function
 
DECLARE DYNAMIC LIBRARY "user32"
    'get current mouse x/y position
    'http://allapi.mentalis.org/apilist/GetCursorPos.shtml
    FUNCTION GetCursorPos% (lpPoint AS POINTAPI)
END DECLARE
 
 
SCREEN 12
 
DO
 
    'poll mouse x/y
    tmp = GetCursorPos(apixy)
    ax = apixy.x: ay = apixy.y
 
    sx = _SCREENX: sy = _SCREENY
 
    CLS: PRINT "MOUSE IN"
    IF ax - sx < 0 THEN CLS: PRINT "MOUSE OUT"
    IF ax - sx > _WIDTH THEN CLS: PRINT "MOUSE OUT"
    IF ay - sy < 0 THEN CLS: PRINT "MOUSE OUT"
    IF ay - sy > _HEIGHT THEN CLS: PRINT "MOUSE OUT"
    _DISPLAY
 
LOOP
 