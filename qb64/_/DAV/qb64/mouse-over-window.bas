TYPE POINTAPI
    x AS LONG
    y AS LONG
END TYPE
DIM apixy AS POINTAPI 'mouse x/y for the GetCursorPos function
DIM CaptionHeight AS INTEGER
DIM BorderHeight AS INTEGER
DIM BoderWidth AS INTEGER
DECLARE DYNAMIC LIBRARY "user32"
    'get current mouse x/y position
    'http://allapi.mentalis.org/apilist/GetCursorPos.shtml
    FUNCTION GetCursorPos% (lpPoint AS POINTAPI)
    'system window metrics in pixels
    'https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getsystemmetrics
    FUNCTION GetSystemMetrics% (BYVAL nIndex AS INTEGER)
END DECLARE

SCREEN 12
DO
    CaptionHeight = GetSystemMetrics(4) ' caption (title bar) height in pixels
    BorderWidth = GetSystemMetrics(5) '   width of window border in pixels
    BorderHeight = GetSystemMetrics(6) '  height of window border in pixels
    'poll mouse x/y
    tmp = GetCursorPos(apixy)
    ax = apixy.x - BorderWidth
    ay = apixy.y - CaptionHeight - BorderHeight
    sx = _SCREENX
    sy = _SCREENY
    CLS: PRINT "MOUSE IN"
    IF ax - sx < 0 THEN CLS: PRINT "MOUSE OUT"
    IF ax - sx > _WIDTH THEN CLS: PRINT "MOUSE OUT"
    IF ay - sy < 0 THEN CLS: PRINT "MOUSE OUT"
    IF ay - sy > _HEIGHT THEN CLS: PRINT "MOUSE OUT"
    LOCATE 2, 2: PRINT "CaptionHeight:"; CaptionHeight
    LOCATE 3, 2: PRINT "BorderWidth  :"; BorderWidth
    LOCATE 4, 2: PRINT "BorderHeight :"; BorderHeight
    _DISPLAY
LOOP