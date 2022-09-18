'-------------------------------------------------------
'Description: Displays an LED scrolling sign calendar
'Author     : Terry Ritchie
'Date       : 11/13/13
'Version    : 1.0
'Rights     : Open source, free to modify and distribute
'Terms      : Original author's name must remain intact
'-------------------------------------------------------

'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST ROUND = 0 '    use to make round LEDs
CONST SQUARE = 1 '   use to make square LEDs

TYPE LED
    Screen AS LONG ' the LED screen to show on screen
    Image AS LONG '  the LED image to work on in the background
    Mask AS LONG '   the LED mask to place over the LED image
END TYPE

DIM LED AS LED '     structure variable to hold images
DIM Days$(6) '       days of the week names
DIM Months$(12) '    months of the year names
DIM Message$ '       scrolling message
DIM Mpos% '          current position of scrolling message
DIM Tm$ '            current time
DIM Dt$ '            current date
DIM Hours% '         hour value extracted
DIM Minutes% '       minute value extracted
DIM Seconds% '       second value extracted
DIM Month% '         month value extracted
DIM Day% '           day value extracted
DIM Year% '          year value extracted
DIM Suffix$ '        day suffix
DIM AmPm$ '          AM or PM
DIM Salute$ '        message salutation

'----------------------------
'- Main Program Begins Here -
'----------------------------

Days$(0) = "Sunday, " '                                                    week day names
Days$(1) = "Monday, "
Days$(2) = "Tuesday, "
Days$(3) = "Wednesday, "
Days$(4) = "Thursday, "
Days$(5) = "Friday, "
Days$(6) = "Saturday, " '                                                  month names
Months$(1) = "January"
Months$(2) = "February"
Months$(3) = "March"
Months$(4) = "April"
Months$(5) = "May"
Months$(6) = "June"
Months$(7) = "July"
Months$(8) = "August"
Months$(9) = "September"
Months$(10) = "October"
Months$(11) = "November"
Months$(12) = "December"
LEDSCREEN 128, 16, 6, SQUARE '                                            create LED screen
_TITLE "And the time is ..." '                                             give window a title
Mpos% = 0 '                                                                reset message position pointer
DO '                                                                       begin main loop
    Tm$ = TIME$ '                                                          get current time
    Dt$ = DATE$ '                                                          get current date
    Hours% = VAL(LEFT$(Tm$, 2)) '                                          get value of current hour
    IF Hours% > 12 THEN '                                                  in military time?
        Hours% = Hours% - 12 '                                             yes, convert to civilian time
        AmPm$ = " PM " '                                                   it's the afternoon
    ELSE '                                                                 no
        AmPm$ = " AM " '                                                   it's the morning
    END IF
    Minutes% = VAL(MID$(Tm$, 4, 2)) '                                      get value of current minute
    Seconds% = VAL(RIGHT$(Tm$, 2)) '                                       get value of current second
    Month% = VAL(LEFT$(Dt$, 2)) '                                          get value of current month
    Day% = VAL(MID$(Dt$, 4, 2)) '                                          get value of current day
    Year% = VAL(RIGHT$(Dt$, 4)) '                                          get value of current year
    SELECT CASE Day% '                                                     which day is it?
        CASE 1, 21, 31 '                                                   1, 21 or 31?
            Suffix$ = "st," '                                              yes, date ends in "st"
        CASE 2, 22 '                                                       2 or 22?
            Suffix$ = "nd," '                                              yes, date ends in "nd"
        CASE 3, 23 '                                                       3 or 23?
            Suffix$ = "rd," '                                              yes, date ends in "rd"
        CASE ELSE '                                                        no, some other date
            Suffix$ = "th," '                                              must end in "th" then
    END SELECT
    SELECT CASE Month% '                                                   which month is it?
        CASE 1 '                                                           create holiday/special day salute
            IF Day% = 1 THEN Salute$ = "Happy New Year! " '                based on month and day
            IF Day% = 2 THEN Salute$ = "Martin Luther King Day. "
        CASE 2
            IF Day% = 2 THEN Salute$ = "Groundhog Day. "
            IF Day% = 14 THEN Salute$ = "Happy Valentine's Day! "
            IF Day% = 18 THEN Salute$ = "President's Day (George Washington's Birthday). "
        CASE 3
            IF Day% = 10 THEN Salute$ = "Daylight Savings Time Begins. "
            IF Day% = 17 THEN Salute$ = "Happy Saint Patrick's Day! "
            IF Day% = 20 THEN Salute$ = "Today is the Spring Equinox. "
        CASE 4
            IF Day% = 15 THEN Salute$ = "Did you get your taxes filed? "
        CASE 5
            IF Day% = 12 THEN Salute$ = "Happy Mother's day! "
        CASE 6
            IF Day% = 6 THEN Salute$ = "Remember D-Day. "
            IF Day% = 14 THEN Salute$ = "Flag Day. "
            IF Day% = 16 THEN Salute$ = "Happy Father's day! "
            IF Day% = 21 THEN Salute$ = "The longest day of the year. "
        CASE 7
            IF Day% = 4 THEN Salute$ = "Happy Independance Day! "
        CASE 8
            IF Day% = 19 THEN Salute$ = "National Aviation Day. "
        CASE 9
            IF Day% = 2 THEN Salute$ = "Labor Day. "
            IF Day% = 8 THEN Salute$ = "Happy Grandparent's Day! "
            IF Day% = 22 THEN Salute$ = "Today is the Fall equinox. "
        CASE 10
            IF Day% = 14 THEN Salute$ = "Columbus Day. "
            IF Day% = 31 THEN Salute$ = "Happy Halloween! "
        CASE 11
            IF Day% = 3 THEN Salute$ = "Daylight Savings Time Ends. "
            IF Day% = 11 THEN Salute$ = "Veteran's Day. "
            IF Day% = 28 THEN Salute$ = "Happy Thanksgiving! "
        CASE 12
            IF Day% = 7 THEN Salute$ = "Remember Pearl Harbor. "
            IF Day% = 25 THEN Salute$ = "Merry Christmas! "
            IF Day% = 31 THEN Salute$ = "The Programmer's Birthday! "
        CASE ELSE
            Salute$ = ""
    END SELECT
    Message$ = "                " + Days$(WeekDay%(Month%, Day%, Year%)) ' add day name to message
    Message$ = Message$ + Months$(Month%) + STR$(Day%) + Suffix$ '         add month and day to message
    Message$ = Message$ + STR$(Year%) + "                " '               add year to message
    Message$ = Message$ + RIGHT$("0" + LTRIM$(STR$(Hours%)), 2) '          add hour to message
    Message$ = Message$ + RIGHT$(Tm$, 6) + AmPm$ '                         add minutes, seconds and AM/PM
    IF Salute$ <> "" THEN '                                                is this a special day?
        Message$ = Message$ + "                " + Salute$ '               yes, add special day to message
    END IF
    _DEST LED.Image '                                                      set small image as destination
    COLOR _RGB32(255, 255, 0) '                                            set text color to yellow
    Mpos% = Mpos% + 1 '                                                    increment message pointer
    IF Mpos% > LEN(Message$) THEN Mpos% = 1 '                              reset pointer at end of message
    LOCATE 1, 1 '                                                          position cursor
    PRINT MID$(Message$, Mpos%, 16); '                                     display portion of message
    _DEST 0 '                                                              set LED screen back to destination
    _PUTIMAGE , LED.Image '                                                stretch the small image across screen
    _PUTIMAGE , LED.Mask '                                                 place LED mask over image
    _LIMIT 4 '                                                             4 frames per second
    _DISPLAY '                                                             viola', the screen looks pixelized
LOOP UNTIL INKEY$ <> "" '                                                  end loop when key pressed
SYSTEM '                                                                   return to Windows

'-----------------------------------
'- Subroutine and Function Section -
'-----------------------------------

'------------------------------------------------------------------------------------------------------------

SUB LEDSCREEN (w%, h%, p%, s%)

    '******************************************************************************
    '**                                                                           *
    '** Creates an LED screen                                                     *
    '**                                                                           *
    '** w% - number of horizontal LEDs                                            *
    '** h% - number of vertical LEDs                                              *
    '** p% - size in pizels of each LED                                           *
    '** s% - shape of pixel (0 = round, 1 = square)                               *
    '**                                                                           *
    '** Resulting size of LED screen is computed by multiplying number of v/h     *
    '** LEDs by LED pixel size.                                                   *
    '**                                                                           *
    '******************************************************************************

    SHARED LED AS LED '  need access to LED screen properties

    DIM LEDPixel& '      temporary image to hold single LED pixel
    DIM TempScreen& '    temporary screen when switching between LED screens

    IF LED.Screen THEN '                                               does an LED screen already exist?
        TempScreen& = _NEWIMAGE(1, 1, 32) '                            yes, create a temporary screen
        SCREEN TempScreen& '                                           switch to the temporary screen
        _FREEIMAGE LED.Screen '                                        remove LED screen image from memory
        _FREEIMAGE LED.Image '                                         remove LED working image from memory
        _FREEIMAGE LED.Mask '                                          remove LED mask image from memory
    END IF
    LED.Screen = _NEWIMAGE(w% * p%, h% * p%, 32) '                     create LED screen image holder
    SCREEN LED.Screen '                                                switch to the LED screen
    _SCREENMOVE _MIDDLE '                                              center screen on desktop
    IF TempScreen& THEN _FREEIMAGE TempScreen& '                       remove the temporary screen if it exists
    LED.Image = _NEWIMAGE(w%, h%, 32) '                                create LED work image
    LED.Mask = _COPYIMAGE(LED.Screen) '                                create LED matrix image mask
    LEDPixel& = _NEWIMAGE(p%, p%, 32) '                                create LED pixel
    _DEST LEDPixel& '                                                  set LED pixel as destination image
    CLS '                                                              remove 0,0,0 alpha transparency
    LINE (0, 0)-(p% - 1, p% - 1), _RGB32(10, 10, 10), BF '             set background color
    SELECT CASE s% '                                                   which pixel shape should be created?
        CASE ROUND '                                                   round pixels
            CIRCLE (p% \ 2, p% \ 2), p% \ 2 - 2, _RGB32(0, 0, 1) '     create round pixel in center of image
            PAINT (p% \ 2, p% \ 2), _RGB32(0, 0, 1), _RGB32(0, 0, 1) ' fill the pixel in
        CASE SQUARE '                                                  square pixels
            LINE (2, 2)-(p% - 2, p% - 2), _RGB32(0, 0, 1), BF '        create square pixel in center of image
    END SELECT
    _DEST LED.Mask '                                                   set LED mask as destination image
    CLS '                                                              remove 0,0,0 alpha transparency
    FOR x% = 0 TO w% * p% - 1 STEP p% '                                cycle through horizontal pixel positions
        FOR y% = 0 TO h% * p% - 1 STEP p% '                            cycle through vertical pixel positions
            _PUTIMAGE (x%, y%), LEDPixel& '                            place a pixel image
        NEXT y%
    NEXT x%
    _FREEIMAGE LEDPixel& '                                             removel pixel image from memory
    FOR x% = 0 TO w% * p% - 1 STEP p% * 8 '                            cycle every 8 horizontal LEDs
        LINE (x%, 0)-(x%, h% * p% - 1), _RGB32(0, 0, 0) '              draw a divider line
    NEXT x%
    FOR y% = 0 TO h% * p% - 1 STEP p% * 8 '                            cycle every 8 vertical LEDs
        LINE (0, y%)-(w% * p% - 1, y%), _RGB32(0, 0, 0) '              draw a divider line
    NEXT y%
    _SETALPHA 0, _RGB32(0, 0, 1) '                                     set transparency color of mask

END SUB

'------------------------------------------------------------------------------------------------------------

FUNCTION WeekDay% (m%, d%, y%)

    '**********************************************************************
    '**                                                                   *
    '** Calculates the week day and returns the result as an integer from *
    '** 0 (Sunday) to 6 (Saturday).                                       *
    '**                                                                   *
    '**********************************************************************

    DIM c% '      current century
    DIM s1% '     century leap
    DIM s2% '     leap year
    DIM s3% '     days in current month
    DIM WkDay% '  current week day number
    DIM Month% '  current month
    DIM Day% '    current day
    DIM Year% '   current year

    Month% = m% '                             get month value passed in
    Day% = d% '                               get day value passed in
    Year% = y% '                              get year value passed in
    IF Month% < 3 THEN '                      is month Jan or Feb?
        Month% = Month% + 12 '                yes, add 12 to Jan-Feb month
        Year% = Year% - 1 '                   subtract 1 year
    END IF
    c% = Year% \ 100 '                        split century number
    Year% = Year% MOD 100 '                   split year number
    s1% = (c% \ 4) - (2 * c%) - 1 '           calculate century leap
    s2% = (5 * Year%) \ 4 '                   calculate 4 year leap
    s3% = 26 * (Month% + 1) \ 10 '            days in months
    WkDay% = (s1% + s2% + s3% + Day%) MOD 7 ' mod weekday totals (0 to 6)
    IF WkDay% < 0 THEN WkDay% = WkDay% + 7 '  adjust if necessary
    WeekDay% = WkDay% '                       return result

END FUNCTION

'------------------------------------------------------------------------------------------------------------

















