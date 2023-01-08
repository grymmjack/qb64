''
' ROUNDED-RECT.BAS
' =============================================================================
' Creates a rounded rectangle.
' 
' Two versions:
' 
' rounded_rectangle - Does not exceed width or height and radius is clamped so
'                     that the most rounded corners turn into a full circle
'
' rounded_rectangle_radius_size - Can exceed width and height and radius is not
'                                 clamped so it never turns into a circle.
'
' @uses CIRCLES.BI (see below) for fixed circles in QB64
' @author Rick Christy <grymmjack@gmail.com>
'

DIM AS INTEGER cw, ch : cw% = 640 : ch% = 480
DIM CANVAS AS LONG : CANVAS& = _NEWIMAGE(cw%, ch%, 32) : SCREEN CANVAS&
_SETALPHA 0, _RGB32(0, 0, 0) : CLS, _RGB32(0, 0 ,0)

DIM AS INTEGER x, y, w, h, r, a
DIM AS _UNSIGNED LONG lc, fc
DIM img AS LONG

x%   = 10                  ' x position
y%   = 10                  ' y position
w%   = 50                  ' width
h%   = 50                  ' height
r%   = 0                   ' corner radius
a%   = 1                   ' adjust amount
lc~& = _RGB32(255, 255, 0) ' line color
fc~& = _RGB32(0, 128, 255) ' fill color
img& = _NEWIMAGE(cw%, ch%, 32)


DIM AS STRING k, status
DO:
    _LIMIT 30

    k$ = INKEY$

    ' Use lowercase varname to decrement integers 
    ' Use uppercase varname to increment integers
    IF k$ = "r" THEN r% = r% - a%
    IF k$ = "R" THEN r% = r% + a%
    IF k$ = "w" THEN w% = w% - a%
    IF k$ = "W" THEN w% = w% + a%
    IF k$ = "h" THEN h% = h% - a%
    IF k$ = "H" THEN h% = h% + a%
    IF k$ = "x" THEN x% = x% - a%
    IF k$ = "X" THEN x% = x% + a%
    IF k$ = "y" THEN y% = y% - a%
    IF k$ = "Y" THEN y% = y% + a%
    IF k$ = "+" THEN a% = a% + 1
    IF k$ = "-" THEN a% = a% - 1

    ' Clamps
    ' Radius
    IF r% > w% - (w% \ 4) THEN r% = w% - (w% \ 4)
    if r% > h% - (h% \ 4) THEN r% = h% - (h% \ 4)
    IF r% < 0 THEN r% = 0
    ' X position
    IF x% < 0 THEN x% = 0
    IF x% + w% >= cw% THEN x% = cw% - (x% + w%)
    ' Y position
    IF y% < 0 THEN y% = 0
    IF y% + h% >= ch% THEN y% = ch% - (y% + h%)
    ' Width
    IF w% + x% < 0 THEN w% = 0
    IF w% + x% >= cw% THEN w% = cw% - (x% + w%)
    ' Height
    IF h% + y% < 1 THEN h% = 0
    IF h% + y% >= ch% THEN h% = ch% - (y% + h%)
    ' Size fail-safes
    IF w% <= 0 THEN w% = 2
    IF h% <= 0 THEN h% = 2

    ' Exit on ESC
    IF k$ = CHR$(27) THEN SYSTEM

    ' Wait for a key to be pressed
    DO: k$ = INKEY$: LOOP UNTIL k$ = ""    
    
    ' Draw filled rounded rectangle
    _DEST img& : CLS
    rounded_rectangle w%, h%, r%, lc~&, fc~&, img&

    ' Put filled rounded rectangle to screen
    _SOURCE img& : _DEST CANVAS& : CLS : _PUTIMAGE (x%, y%)

    ' Print status
    _PRINTSTRING(0, ch% - 60), "Use [KEY(-/+)]s to adjust and +/- to change adjustment"
    status$ =  "[wW]:" + n$(w%) + " [hH]:" + n$(h%) _
            + " [xX]:" + n$(x%) + " [yY]:" + n$(y%) _
            + " [rR]:" + n$(r%) + " [+-]:" + n$(a%)
    _PRINTSTRING(0, ch% - 40), status$
    status$ = "SCREEN GEOM: W=" + n$(x% + w%) + " H=" + n$(y% + h%)
    _PRINTSTRING(0, ch% - 20), status$

    _DISPLAY
LOOP UNTIL _KEYHIT=27 ' Exit on ESC



''
' Returns trimmed string representation of integer
' @param INTEGER i
' @return STRING
' 
FUNCTION n$ (i%)
    n = _TRIM$(STR$(i%))
END FUNCTION


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
    DIM AS INTEGER max_r
    old_dest& = _DEST
    _DEST img&
    ' calc max radius
    IF w% > h% THEN max_r% = h% \ 2 ELSE max_r% = w% \ 2
    IF r% > max_r% THEN r% = max_r%
    ' tl corner
    CIRCLES r%, r%, r%, lc~&, _D2R(90), _D2R(180), 1
    ' top line
    LINE (x% + r%, y%)-(x% + w% - r%, y%), lc~&
    ' tr corner
    CIRCLES x% + w% - r%, r%, r%, lc~&, _D2R(0), _D2R(90), 1
    ' left line
    LINE (x%, r%)-(x%, y% + h% - r%), lc~&
    ' bl corner
    CIRCLES r%, y% + h% - r%, r%, lc~&, _D2R(180), _D2R(270), 1
    ' bot line
    LINE (x% + r%, y% + h%)-(x% + w% - r%, y% + h%), lc~&
    ' br corner 
    CIRCLES x% + w% - r%, y% + h% - r%, r%, lc~&, _D2R(270), _D2R(0), 1
    ' r line
    LINE (x% + w%, r%)-(x% + w%, h% - r%), lc~&
    ' fill if needed
    IF fc~& >= _RGB32(0, 0, 0) THEN 
        PAINT (r% + 1, r% + 1), fc~&, lc~&
    END IF
    _DEST old_dest&
END SUB


''
' Creates a rounded rectangle shape incorrectly (growing/shrinking with radius)
' @param INTEGER w width
' @param INTEGER h height
' @param INTEGER r radius
' @param _UNSIGNED LONG lc line color
' @param _UNSIGNED LONG fc fill color (does not fill if 0)
' @param LONG img handle to paint on
' 
SUB rounded_rectangle_radius_size (w%, h%, r%, lc~&, fc~&, img&)
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
