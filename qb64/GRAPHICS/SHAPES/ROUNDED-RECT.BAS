DIM CANVAS AS LONG : CANVAS& = _NEWIMAGE(320, 200, 32) : SCREEN CANVAS&
_SETALPHA 0, _RGB32(0, 0, 0) : CLS, _RGB32(0, 0 ,0)

DIM AS INTEGER x, y, w, h, r
DIM AS _UNSIGNED LONG lc, fc
DIM img AS LONG

x%   = 0                   ' x position
y%   = 0                   ' y position
w%   = 50                  ' width
h%   = 50                  ' height
r%   = 15                  ' corner radius
lc~& = _RGB32(255, 255, 0) ' line color
fc~& = _RGB32(0, 128, 255) ' fill color
img& = _NEWIMAGE(320, 200, 32)


' Draw filled rounded rectangle
_DEST img& : CLS
rounded_rectangle w%, h%, r%, lc~&, fc~&, img&
_SOURCE img& : _DEST CANVAS& : _PUTIMAGE (x%, y%)

' Draw unfilled rounded rectangle
_DEST img& : CLS, _RGB32(0, 0, 0) : _SETALPHA 0, _RGB32(0, 0, 0)
rounded_rectangle w%, h%, 5, _RGB32(255, 0, 0), 0, img&
_SOURCE img& : _DEST CANVAS& : _PUTIMAGE (x%+40, y%+50)

''
' Creates a rounded rectangle shape
' @param INTEGER w width
' @param INTEGER h height
' @param INTEGER r radius
' @param _UNSIGNED LONG lc line color
' @param _UNSIGNED LONG fc fill color (does not fill if 0)
' @param LONG img handle to paint on
' 
SUB rounded_rectangle (w%, h%, r%, lc~&, fc~&, img&)
    DIM AS LONG old_dest
    old_dest& = _DEST
    _DEST img&
    ' tl corner
    CIRCLES r%, r%, r%, lc~&, _D2R(90), _D2R(180), 1
    ' top line
    LINE (r%, 0)-(r% + w%, 0), lc~&
    ' tr corner
    CIRCLES r% + w%, r%, r%, lc~&, _D2R(0), _D2R(90), 1
    ' left line
    LINE (0, r%)-(0, r% + h%), lc~&
    ' bl corner
    CIRCLES r%, h% + r%, r%, lc~&, _D2R(180), _D2R(270), 1
    ' bot line
    LINE (r%, r% + r% + h%)-(r% + w%, r% + r% + h%), lc~&
    ' br corner 
    CIRCLES r% + w%, h% + r%, r%, lc~&, _D2R(270), _D2R(0), 1
    ' r line
    LINE (r% + r% + w%, r%)-(r% + r% + w%, r% + h%), lc~&
    ' fill if needed
    IF fc~& >= _RGB32(0, 0, 0) THEN 
        PAINT (r% + 1, r% + 1), fc~&, lc~&
    END IF
    _DEST old_dest&
END SUB


'CIRCLE.BI
'**
'** QB64 replacement CIRCLE command.
'**
'** The CIRCLE command in QB64 has a few issues:
'**
'** - radian end points are not calculate properly when creating arcs
'** - center line to radian end points do not close properly due to previous bug listed
'**
'** This circle command replacement works very similiarly to the native CIRCLE command:
'**
'** SYNTAX: CIRCLES x%, y%, radius!, color~&, start_radian!, end_radian!, aspect_ratio!
'**
'**   x%            - center X coordinate of circle
'**   y%            - center Y coordinate of circle
'**   radius!       - the radius of the circle
'**   color~&       - the circle's color
'**   start_radian! - the radian on circle curcunference to begin drawing at
'**   end_radian!   - the radian on circle circumference to end drawing at
'**   aspect_ratio! - the aspect ratio of the circle
'**
'** **NOTE: unlike the native CIRCLE command, all arguments MUST be supplied.** For example,
'**       with the native command this will draw a perfect circle with the default color,
'**       start radian, end radian and aspect ratio:
'**
'**       CIRCLE (319, 239), 100
'**
'**       To do the same thing with this replacement command you must supply everything:
'**
'**       CIRCLES 319, 239, 100, _RGB32(255, 255, 255), 0, 0, 0
'**
'** ACKNOWLEGEMENTS: The FOR/NEXT step formula was was written by Codeguy for Unseen
'**                  Machine's Visual library EllipseXS command. Specifically:
'**                         MinStep! = 1 / (2 * 3.1415926535 * Radius!)
'**
'**
'** Includes performance tweaks made by SMcNeill on 02/02/13 - specifically removing a few redundant * -1
'** statements and converting the FOR/NEXT loop to a DO loop for a ~3% increase in performance.
'**
'** Corrected bug in which variables being passed in were being modified and passed back - 02/02/13
'**
'**

SUB CIRCLES (cx%, cy%, r!, c~&, s!, e!, a!)
    DIM s%, e%, nx%, ny%, xr!, yr!, st!, en!, asp! '     local variables used

    st! = s! '                                           copy start radian to local variable
    en! = e! '                                           copy end radian to local variable
    asp! = a! '                                          copy aspect ratio to local variable
    IF asp! <= 0 THEN asp! = 1 '                         keep aspect ratio between 0 and 4
    IF asp! > 4 THEN asp! = 4
    IF asp! < 1 THEN xr! = r! * asp! * 4 ELSE xr! = r! ' calculate x/y radius based on aspect ratio
    IF asp! > 1 THEN yr! = r! * asp! ELSE yr! = r!
    IF st! < 0 THEN s% = -1: st! = -st! '                remember if line needs drawn from center to start radian
    IF en! < 0 THEN e% = -1: en! = -en! '                remember if line needs drawn from center to end radian
    IF s% THEN '                                         draw line from center to start radian?
        nx% = cx% + xr! * COS(st!) '                     yes, compute starting point on circle's circumference
        ny% = cy% + yr! * -SIN(st!)
        LINE (cx%, cy%)-(nx%, ny%), c~& '                draw line from center to radian
    END IF
    IF en! <= st! THEN en! = en! + 6.2831852 '           come back around to proper location (draw counterclockwise)
    stepp! = 0.159154945806 / r!
    c! = st! '                                           cycle from start radian to end radian
    DO
        nx% = cx% + xr! * COS(c!) '                      compute next point on circle's circumfrerence
        ny% = cy% + yr! * -SIN(c!)
        PSET (nx%, ny%), c~& '                           draw the point
        c! = c! + stepp!
    LOOP UNTIL c! >= en!
    IF e% THEN LINE -(cx%, cy%), c~& '                   draw line from center to end radian if needed
END SUB