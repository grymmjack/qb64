Option _Explicit
 
' Include layout utility declarations
'$include: './layoutUtils.bi'
 
' Create two off‐screen buffers (800×600, 32‐bit) for text and graphics
screen _NewImage(800, 600, 32)
dim as single textDest, grafDest
textDest = _NewImage(800, 600, 32)
grafDest = _NewImage(800, 600, 32)
 
'=====================================================================
' Define first screen layout (User Information) using DATA statements
'=====================================================================
LAYOUT1:
    DATA "                                                                            "
    DATA "   +-----------------------------------------------------------------------+"
    DATA "   |                          User Information                       <&pg> |"
    DATA "   +-----------------------------------------------------------------------+"
    DATA "   |                                                                       |"
    DATA "   |    Last Name          <&lastName.................................>    |"
    DATA "   |    First Name         <&firstName................................>    |"
    DATA "   |                                                                       |"
    DATA "   |  Address:                                                             |"
    DATA "   |                                                                       |"
    DATA "   |    Street Address     <&streetAddress......................>          |"
    DATA "   |    Apartment / Suite  <&apartmentSuite...................>            |"
    DATA "   |    City               <&city...............................>          |"
    DATA "   |    State / Province   <&stateProvince.....................>           |"
    DATA "   |    ZIP / Postal       <&zipPostal.........................>           |" 
    DATA "   |    Country            <&country...........................>           |"
    DATA "   |                                                                       |"
    DATA "   +-----------------------------------------------------------------------+"
    DATA "                                        [L:list] [N:next] [P:prev] [Q:quit] "
 
'==================================================================
' Define second screen layout (User List) using DATA statements
'==================================================================
LAYOUT2:
    DATA "                                                                               "
    DATA " +----------------------------------------------------------------------------+"
    DATA " |                                 User List                                  |"
    DATA " +------------------+------------------+--------------------+-----------------+"
    DATA " | Last Name        | First Name       | City               | State           |"
    DATA " +------------------+------------------+--------------------+-----------------+"
    DATA " | <&last1........> | <&first1.......> | <&city1..........> | <&state1......> |"
    DATA " | <&last2........> | <&first2.......> | <&city2..........> | <&state2......> |"
    DATA " | <&last3........> | <&first3.......> | <&city3..........> | <&state3......> |"
    DATA " +------------------+------------------+--------------------+-----------------+"
    DATA "                                                           [R:return] [Q:quit] "
 
'==================================================================
' Load screen layouts into memory using layoutUtils library
'==================================================================
dim m1%, m2%
restore layout1
m1% = layoutUtils_loadData ("user", 19)   ' Load 19 lines for layout1 under name "user"
restore layout2
m2% = layoutUtils_loadData ("list", 11)   ' Load 11 lines for layout2 under name "list"
 
'==================================================================
' Define sample database entries (3 users, each with 9 fields)
'==================================================================
TEST1:
    DATA "1/3","Smith","John","123 Maple Street","Apt. 4B","Springfield","Illinois","62704","United States"
    DATA "2/3","Doe","Jane","456 Oak Avenue","Suite 12","Madison","Wisconsin","53703","United States"
    DATA "3/3","Brown","Charlie","789 Pine Road","Unit 5","Portland","Oregon","97205","United States"
 
' Initialize the in‐memory database array and fill it from TEST1
dim db$(1 To 3, 0 To 8)
restore TEST1
dim i%, j%
for i% = 1 to 3
    for j% = 0 to 8
        read db$(i%, j%)
    next j%
next i%
 
'==================================================================
' Main loop showing the User Information screen
'==================================================================
dim k$, user%
user% = 1   ' Start with the first user
 
SCREEN1:
    ' Populate the layout placeholders for the current user
    populateLayout1 m1%, db$(), user%
    ' Render text layer into off‐screen buffer
    refreshDestWithLayout "user", textDest
 
    do
        _limit 60           ' Cap frame rate to ~60 FPS
        _dest grafDest      ' Draw graphics into grafDest
        cls                 ' Clear graphics buffer
        drawCircle          ' Draw animated circle behind text
        _putimage , textDest, grafDest  ' Blit text buffer over graphics
        _dest 0             ' Set drawing back to actual screen
        _putimage , grafDest, 0          ' Present final composed image
 
        select case _keyhit   ' Handle key input
            case 81 or 113   ' Q or q to quit
                system
            case 78 or 110   ' N or n to go to next user
                if user% < 3 then
                    user% = user% + 1
                    exit do
                end if
            case 80 or 112   ' P or p to go to previous user
                if user% > 1 then
                    user% = user% - 1
                    exit do
                end if
            case 76 or 108   ' L or l to show user list
                gosub screen2
                exit do
        end select
    loop
 
    goto SCREEN1
 
'==================================================================
' Subroutine to display the User List screen
'==================================================================
SCREEN2:
    ' Fill in the list layout with all database entries
    populateLayout2 "list", db$()
    refreshDestWithLayout "list", textDest
 
    do
        _limit 60
        _dest grafDest
        cls
        drawTriangle    ' Draw rotating triangle graphic
        _putimage , textDest, grafDest
        _dest 0
        _putimage , grafDest, 0
 
        select case _keyhit
            case 81 or 113   ' Q or q to quit
                system
            case 82 or 114   ' R or r to return to info screen
                exit do
        end select
    loop
 
    return   ' Return back to SCREEN1 loop
 
system   ' Exit the program
 
'==================================================================
' Subroutine: populateLayout1
' Fills placeholders in the User Information layout
'==================================================================
sub populateLayout1 (layoutId as integer, database() as string, user as integer)
    layoutUtils_resetIndex layoutId
    layoutUtils_populateIndex layoutId, "pg", database(user, 0)
    layoutUtils_populateIndex layoutId, "lastName", database(user, 1)
    layoutUtils_populateIndex layoutId, "firstName", database(user, 2)
    layoutUtils_populateIndex layoutId, "streetAddress", database(user, 3)
    layoutUtils_populateIndex layoutId, "apartmentSuite", database(user, 4)
    layoutUtils_populateIndex layoutId, "city", database(user, 5)
    layoutUtils_populateIndex layoutId, "stateProvince", database(user, 6)
    layoutUtils_populateIndex layoutId, "zipPostal", database(user, 7)
    layoutUtils_populateIndex layoutId, "country", database(user, 8)
end sub
 
'==================================================================
' Subroutine: populateLayout2
' Fills placeholders in the User List layout
'==================================================================
sub populateLayout2 (layoutName as string, database() as string)
    layoutUtils_reset layoutName
    layoutUtils_populate layoutName, "last1", database(1, 1)
    layoutUtils_populate layoutName, "first1", database(1, 2)
    layoutUtils_populate layoutName, "city1", database(1, 5)
    layoutUtils_populate layoutName, "state1", database(1, 6)
    layoutUtils_populate layoutName, "last2", database(2, 1)
    layoutUtils_populate layoutName, "first2", database(2, 2)
    layoutUtils_populate layoutName, "city2", database(2, 5)
    layoutUtils_populate layoutName, "state2", database(2, 6)
    layoutUtils_populate layoutName, "last3", database(3, 1)
    layoutUtils_populate layoutName, "first3", database(3, 2)
    layoutUtils_populate layoutName, "city3", database(3, 5)
    layoutUtils_populate layoutName, "state3", database(3, 6)
end sub
 
'==================================================================
' Subroutine: refreshDestWithLayout
' Renders a populated layout into the specified destination buffer
'==================================================================
sub refreshDestWithLayout (layoutName as string, destination as double)
    dim prevDestination 
    prevDestination = _dest         ' Remember previous drawing target
    _dest destination               ' Switch to the off‐screen buffer
    cls , _rgba(0,0,0,0)            ' Clear with fully transparent background
    _printmode _KEEPBACKGROUND      ' Preserve any background pixels
    print layoutUtils_getPopulated(layoutName)   ' Print layout text
    _dest prevDestination           ' Restore the original drawing target
end sub
 
'==================================================================
' Subroutine: drawCircle
' Draws an animated pulsing circle at the center of the screen
'==================================================================
sub drawCircle ()
    static growing as integer
    static rFactor as single
    dim cx%, cy%, r%
 
    cx% = _width / 2
    cy% = _height / 2
 
    ' Initialize animation parameters on first run
    if rFactor = 0 then
        rFactor = 0.10
        growing = 1
    end if
 
    ' Pulse the radius factor up and down
    if growing then
        rFactor = rFactor + 0.001
        if rFactor >= 0.48 then growing = 0
    else
        rFactor = rFactor - 0.001
        if rFactor <= 0.10 then growing = 1
    end if
 
    r% = rFactor * _min(_width, _height)
    circle (cx%, cy%), r%, _rgba(255,255,0,100)
end sub
 
'==================================================================
' Subroutine: drawTriangle
' Draws a continuously rotating semi‐transparent triangle
'==================================================================
sub drawTriangle ()
    static angleOffset#
    angleOffset# = angleOffset# - _pi / 180   ' Decrease rotation by 1° each frame
 
    dim cx%, cy%, r%
    cx% = _width / 2
    cy% = _height / 2
    r% = 0.48 * _min(_width, _height)
 
    ' Calculate the three vertex angles
    dim angle1#, angle2#, angle3#
    angle1# = angleOffset#
    angle2# = angleOffset# + 2 * _pi / 3
    angle3# = angleOffset# + 4 * _pi / 3
 
    ' Compute vertex coordinates
    dim x1%, y1%, x2%, y2%, x3%, y3%
    x1% = cx% + r% * cos(angle1#)
    y1% = cy% - r% * sin(angle1#)
    x2% = cx% + r% * cos(angle2#)
    y2% = cy% - r% * sin(angle2#)
    x3% = cx% + r% * cos(angle3#)
    y3% = cy% - r% * sin(angle3#)
 
    ' Draw triangle edges
    line (x1%, y1%)-(x2%, y2%), _rgba(0,255,0,100)
    line (x2%, y2%)-(x3%, y3%), _rgba(0,255,0,100)
    line (x3%, y3%)-(x1%, y1%), _rgba(0,255,0,100)
end sub
 
' Include the binary module for layoutUtils implementation
'$include: './layoutUtils.bm'