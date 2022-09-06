'** Line Intersection Collision Detection Demo #6

CONST RED = _RGB32(255, 0, 0) '     define colors
CONST GREEN = _RGB32(0, 255, 0)
CONST YELLOW = _RGB32(255, 255, 0)

TYPE POINTTYPE '                    X,Y point definition
    x AS INTEGER '                  X coordinate location
    y AS INTEGER '                  Y coordinate location
END TYPE

TYPE LINETYPE '                     line segment definition
    x1 AS INTEGER '                 start X coordinate (from)
    y1 AS INTEGER '                 start Y coordinate
    x2 AS INTEGER '                 end X coordinate   (to)
    y2 AS INTEGER '                 end Y coordinate
END TYPE

DIM Line1 AS LINETYPE '             green line
DIM Line2 AS LINETYPE '             red line
DIM Plot(359) AS POINTTYPE '        360 degree plotted coordinates
DIM c! '                            sine wave counter
DIM c1%, c2% '                      counters
DIM clr~& '                         green line color

FOR c1% = 0 TO 359 '                                        plot 360 points
    Plot(c1%).x = 319 + 100 * COS(c!) '                     from screen center X radius 100
    Plot(c1%).y = 239 + 100 * -SIN(c!) '                    from screen center Y radius 100
    c! = c! + 6.2831852 / 360 '                             360 increments
NEXT c1%

SCREEN _NEWIMAGE(640, 480, 32) '                            enter graphics screen
_MOUSEHIDE '                                                hide mouse pointer
c1% = 0 '                                                   set green line start counter
c2% = 179 '                                                 set green line end counter
DO '                                                        begin main loop
    _LIMIT 30 '                                             30 frames per second
    CLS '                                                   clear the screen
    WHILE _MOUSEINPUT: WEND '                               get latest mouse information
    Line2.x1 = _MOUSEX - 50 '                               set red line coordinates
    Line2.x2 = Line2.x1 + 100
    Line2.y1 = _MOUSEY
    Line2.y2 = Line2.y1
    Line1.x1 = Plot(c1%).x '                                set green line coordinates
    Line1.y1 = Plot(c1%).y
    Line1.x2 = Plot(c2%).x
    Line1.y2 = Plot(c2%).y
    IF LineCollide(Line2, Line1) THEN '                     line collision?
        LOCATE 2, 36 '                                      yes, locate cursor
        PRINT "COLLISION!" '                                report coillision
        clr~& = YELLOW '                                    green line becomes yellow
    ELSE '                                                  no collision
        clr~& = GREEN '                                     green line is green
    END IF
    LINE (Line1.x1, Line1.y1)-(Line1.x2, Line1.y2), clr~& ' draw green line
    LINE (Line2.x1, Line2.y1)-(Line2.x2, Line2.y2), RED '   draw red line
    c1% = c1% + 1 '                                         increment green line start counter
    IF c1% = 360 THEN c1% = 0 '                             keep within limits
    c2% = c2% + 1 '                                         increment green line end counter
    IF c2% = 360 THEN c2% = 0 '                             keep within limits
    _DISPLAY '                                              update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                   leave when ESC key pressed
SYSTEM '                                                    return to operating system

'------------------------------------------------------------------------------------------------------------
FUNCTION LineCollide (Line1 AS LINETYPE, Line2 AS LINETYPE)
    '--------------------------------------------------------------------------------------------------------
    '- Returns TRUE if line segments Seg1 and Seg2 intersect.                    -
    '-                                                                           -
    '- This function was created from example code found at:                     -
    '- https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/ -
    '-----------------------------------------------------------------------------

    DIM p1 AS POINTTYPE ' line 1 coordinate X,Y pairs
    DIM q1 AS POINTTYPE
    DIM p2 AS POINTTYPE ' line 2 coordinate X,Y pairs
    DIM q2 AS POINTTYPE
    DIM o1 AS INTEGER '   four orientations
    DIM o2 AS INTEGER
    DIM o3 AS INTEGER
    DIM o4 AS INTEGER

    p1.x = Line1.x1: p1.y = Line1.y1 '  line 1 start X,Y
    q1.x = Line1.x2: q1.y = Line1.y2 '  line 1 end X,Y
    p2.x = Line2.x1: p2.y = Line2.y1 '  line 2 start X,Y
    q2.x = Line2.x2: q2.y = Line2.y2 '  line 2 end X,Y
    o1 = Orientation(p1, q1, p2) '      get the four orientations needed for general and special cases
    o2 = Orientation(p1, q1, q2)
    o3 = Orientation(p2, q2, p1)
    o4 = Orientation(p2, q2, q1)
    IF o1 <> o2 THEN
        IF o3 <> o4 THEN '              general case
            LineCollide = -1
            EXIT FUNCTION
        END IF
    END IF
    IF o1 = 0 THEN
        IF onSegment(p1, p2, q1) THEN ' p1, q1, and p2 are colinear and p2 lies on segment p1q1
            LineCollide = -1
            EXIT FUNCTION
        END IF
    END IF
    IF o2 = 0 THEN
        IF onSegment(p1, q2, q1) THEN ' p1, q1, and q2 are colinear and q2 lies on segment p1q1
            LineCollide = -1
            EXIT FUNCTION
        END IF
    END IF
    IF o3 = 0 THEN
        IF onSegment(p2, p1, q2) THEN ' p2, q2, and p1 are colinear and p1 lies on segment p2q2
            LineCollide = -1
            EXIT FUNCTION
        END IF
    END IF
    IF o4 = 0 THEN
        IF onSegment(p2, q1, q2) THEN ' p2, q2, and q1 are colinear and q1 lies on segment p2q2
            LineCollide = -1
            EXIT FUNCTION
        END IF
    END IF
    LineCollide = 0 '                  doesn't fall into any of the above cases

END FUNCTION

'------------------------------------------------------------------------------------------------------------
FUNCTION Orientation (p AS POINTTYPE, q AS POINTTYPE, r AS POINTTYPE)
    '--------------------------------------------------------------------------------------------------------
    '- Returns the orientation of ordered triplet p, q, r.                       -
    '- 0 = p, q, r are colinear                                                  -
    '- 1 = clockwise orientation                                                 -
    '- 2 = counter clockwise orientation                                         -
    '-                                                                           -
    '- This function was created from example code found at:                     -
    '- https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/ -
    '-----------------------------------------------------------------------------

    DIM Value AS SINGLE ' triplet orientation

    Value = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y) ' calculate orientation
    IF Value = 0 THEN '                                             colinear
        Orientation = 0
    ELSEIF Value > 0 THEN '                                         clockwise
        Orientation = 1
    ELSE '                                                          counter clockwise
        Orientation = 2
    END IF

END FUNCTION

'------------------------------------------------------------------------------------------------------------
FUNCTION onSegment (p AS POINTTYPE, q AS POINTTYPE, r AS POINTTYPE)
    '--------------------------------------------------------------------------------------------------------
    '- Given 3 colinear points p, q, r, the function checks if point q lies on line segment pr. -
    '-                                                                                          -
    '- p, q, r - three colinear X,Y points                                                      -
    '-                                                                                          -
    '- This function was created from example code found at:                                    -
    '- https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/                -
    '--------------------------------------------------------------------------------------------

    IF q.x <= Max(p.x, r.x) THEN
        IF q.x >= Min(p.x, r.x) THEN
            IF q.y <= Max(p.y, r.y) THEN
                IF q.y >= Min(p.y, r.y) THEN
                    onSegment = -1
                END IF
            END IF
        END IF
    END IF

END FUNCTION

'------------------------------------------------------------------------------------------------------------
FUNCTION Max (n1 AS INTEGER, n2 AS INTEGER)
    '--------------------------------------------------------------------------------------------------------
    '- Returns the maximum of two numbers provided. -
    '-                                              -
    '- n1, n2 - the numbers to be compared          -
    '------------------------------------------------

    IF n1 > n2 THEN Max = n1 ELSE Max = n2 ' return largest number

END FUNCTION

'------------------------------------------------------------------------------------------------------------
FUNCTION Min (n1 AS INTEGER, n2 AS INTEGER)
    '--------------------------------------------------------------------------------------------------------
    '- Returns the minimum of two numbers provided. -
    '-                                              -
    '- n1, n2 - the numbers to be compared          -
    '------------------------------------------------

    IF n1 < n2 THEN Min = n1 ELSE Min = n2 ' return smallest number

END FUNCTION























