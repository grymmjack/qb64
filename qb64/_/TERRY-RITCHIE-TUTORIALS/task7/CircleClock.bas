'-------------------------------------------------------
'Description: Draws a functioning clock using circles
'Author     : Terry Ritchie
'Date       : 11/12/13
'Updated    : 04/09/20
'Version    : 2.1
'Rights     : Open source, free to modify and distribute
'Terms      : Original author's name must remain intact
'-------------------------------------------------------

'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST GRAY = _RGB32(127, 127, 127) '    define colors
CONST DARKGRAY = _RGB32(63, 63, 63)
CONST LIGHTGRAY = _RGB32(191, 191, 191)
CONST BLACK = _RGB32(0, 0, 0)
CONST WHITE = _RGB32(255, 255, 255)
CONST RED = _RGB32(127, 0, 0)
CONST YELLOW = _RGB32(255, 255, 0)

DIM Clock!(60) ' 60 radian points around circle
DIM Tick% '      counter to keep track of tick marks
DIM Tc~& '       tick mark color
DIM Radian! '    FOR...NEXT radian counter
DIM h% '         value of hour extracted from TIME$
DIM m% '         value of minute extracted from TIME$
DIM s% '         value of second extracted from TIME$
DIM Tm$ '        current TIME$ value

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '                                      initiate graphics screen
Tick% = 15 '                                                          first position is 15 seconds
FOR Radian! = 6.2831852 TO 0 STEP -.10471975 '                        clockwise from 2*Pi in steps of -60ths
    Clock!(Tick%) = Radian! '                                         save circle radian seconds position
    Tick% = Tick% + 1 '                                               move to next seconds position
    IF Tick% = 60 THEN Tick% = 0 '                                    reset to 0 seconds position if needed
NEXT Radian!
DO '                                                                  begin main loop
    CLS '                                                             clear the screen
    _LIMIT 5 '                                                        5 updates per second
    CIRCLE (319, 239), 120, GRAY '                                    draw outer circle of clock
    PAINT (319, 239), DARKGRAY, GRAY '                                paint circle dark gray
    CIRCLE (319, 239), 110, BLACK '                                   draw inner circle of clock
    PAINT (319, 239), WHITE, BLACK '                                  paint face bright white
    FOR Tick% = 0 TO 59 '                                             cycle through radian seconds positions
        IF Tick% MOD 5 = 0 THEN Tc~& = BLACK ELSE Tc~& = LIGHTGRAY '  5 second ticks are black in color
        CIRCLE (319, 239), 109, Tc~&, -Clock!(Tick%), Clock!(Tick%) ' draw radian line from center of circle
    NEXT Tick%
    CIRCLE (319, 239), 102, DARKGRAY '                                draw circle to cut off radian lines
    PAINT (319, 239), WHITE, DARKGRAY '                               paint face again to remove radian lines
    CIRCLE (319, 239), 102, WHITE '                                   fill in cut off circle
    CIRCLE (319, 239), 4, BLACK '                                     draw small black circle in center
    PAINT (319, 239), 0, BLACK '                                      paint small black circle
    Tm$ = TIME$ '                                                     get current time from TIME$
    s% = VAL(RIGHT$(Tm$, 2)) '                                        get numeric value of seconds
    m% = VAL(MID$(Tm$, 4, 2)) '                                       get numeric value of minutes
    h% = VAL(LEFT$(Tm$, 2)) '                                         get numeric value of hours
    IF h% >= 12 THEN h% = h% - 12 '                                   convert from military time
    COLOR BLACK, WHITE '                                              black text on bright white background
    LOCATE 19, 37 '                                                   position cursor on screen
    PRINT RIGHT$("0" + LTRIM$(STR$(h%)), 2) + RIGHT$(Tm$, 6) '        print current time in face of clock
    COLOR GRAY, BLACK '                                               white text on black background
    Tick% = (h% * 5) + (m% \ 12) '                                    calculate which hour hand radian to use
    CIRCLE (319, 239), 80, BLACK, -Clock(Tick%), Clock(Tick%) '       display hour hand
    h% = h% + 6 '                                                     move to opposite hour on clock face
    IF h% >= 12 THEN h% = h% - 12 '                                   adjust hour if necessary
    Tick% = (h% * 5) + (m% \ 12) '                                    calculate which hour hand radian to use
    CIRCLE (319, 239), 15, BLACK, -Clock(Tick%), Clock(Tick%) '       display small opposite tail of hour hand
    CIRCLE (319, 239), 95, BLACK, -Clock(m%), Clock(m%) '             display minute hand
    m% = m% + 30 '                                                    move to opposite minute on clock face
    IF m% > 59 THEN m% = m% - 60 '                                    adjust minute if necessary
    CIRCLE (319, 239), 15, BLACK, -Clock(m%), Clock(m%) '             display small opposite tail of min hand
    CIRCLE (319, 239), 2, RED '                                       draw small red circle in center
    PAINT (319, 239), RED, RED '                                      paint small red circle
    CIRCLE (319, 239), 100, RED, -Clock(s%), Clock(s%) '              draw second hand
    s% = s% + 30 '                                                    move to opposite second on clock face
    IF s% > 59 THEN s% = s% - 60 '                                    adjust second if necessary
    CIRCLE (319, 239), 25, RED, -Clock(s%), Clock(s%) '               display small opposite tail of sec hand
    CIRCLE (319, 239), 1, YELLOW '                                    draw small yellow circle in center
    PSET (319, 239), YELLOW '                                         fill in small yellow circle
    _DISPLAY '                                                        update screen with loop's changes
LOOP UNTIL INKEY$ <> "" '                                             end program when key pressed
SYSTEM '                                                              return to Windows






