'** Particle Effects Demo #2 - Gravity Sparks
'** Simulated Gravity Added

CONST SPARKNUM = 10 '      number of sparks to create at each location (don't go too high!)
CONST SPARKLIFE = 60 '     number of frames for sparks to live (don't go too high!)             * changed

TYPE SPARK '               spark definition
    life AS INTEGER '      lifespan of spark (frames)
    x AS SINGLE '          X coordinate of spark
    y AS SINGLE '          Y coordinate of spark
    xdir AS SINGLE '       X vector of spark
    ydir AS SINGLE '       Y vector of spark
    xspeed AS SINGLE '     X vector speed of spark                                              * changed
    yspeed AS SINGLE '     Y vector speed of spark                                              * added
    fade AS INTEGER '      RGB intensity of spark
END TYPE

REDIM Sparks(0) AS SPARK ' dynamic spark array

SCREEN _NEWIMAGE(640, 480, 32) '                          enter graphics screen
RANDOMIZE TIMER '                                         seed random number generator
DO '                                                      begin main loop
    _LIMIT 30 '                                           30 frames per second                  * changed
    CLS '                                                 clear screen
    IF _KEYDOWN(32) THEN '                                space bar pressed?
        MakeSparks INT(RND(1) * 640), INT(RND(1) * 480) ' yes, make sparks fly
    END IF
    UpdateSparks '                                        update any sparks with life remaining
    _DISPLAY '                                            update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                 leave when ESC key pressed
SYSTEM '                                                  return to operating system

'------------------------------------------------------------------------------------------------------------
SUB MakeSparks (x%, y%)
    '--------------------------------------------------------------------------------------------------------
    '- Adds sparks to the sparks array.                            -
    '-                                                             -
    '- x%, y% - the location on screen to create the sparks        -
    '---------------------------------------------------------------
    '- DO...LOOPs used here for speed. Much faster than FOR...NEXT -
    '---------------------------------------------------------------

    SHARED Sparks() AS SPARK ' need access to the sparks array

    DIM cleanup% '  -1 (TRUE) if no more live sparks
    DIM count& '    spark counter
    DIM topspark& ' highest index value in Sparks array

    cleanup% = -1 '                                             assume no more live sparks
    count& = 0 '                                                reset spark counter
    DO '                                                        loop through Sparks array
        IF Sparks(count&).life <> 0 THEN '                      is this spark still alive?
            cleanup% = 0 '                                      yes, array cleaning can't be done
        END IF
        count& = count& + 1 '                                   increment spark counter
    LOOP UNTIL count& = UBOUND(Sparks) + 1 OR cleanup% = 0 '    leave when array checked or cleaning not possible
    IF cleanup% THEN REDIM Sparks(0) AS SPARK '                 reset array if no live sparks found
    topspark& = UBOUND(sparks) '                                get highest index in Sparks array
    REDIM _PRESERVE Sparks(topspark& + SPARKNUM + 1) AS SPARK ' increase array to add new sparks
    count& = 0 '                                                reset spark counter
    DO '                                                        loop through new indexes in Sparks array
        count& = count& + 1 '                                   increment spark counter
        Sparks(topspark& + count&).life = SPARKLIFE '           set spark life time
        Sparks(topspark& + count&).x = x% '                     set spark X location coordinate
        Sparks(topspark& + count&).y = y% '                     set spark Y location coordinate
        Sparks(topspark& + count&).fade = 255 '                 set spark fade value
        Sparks(topspark& + count&).xspeed = INT(RND(1) * 6) + 9 'set vector speed of spark      * changed
        Sparks(topspark& + count&).yspeed = INT(RND(1) * 6) + 6 'set vector speed of spark      * added
        Sparks(topspark& + count&).xdir = RND(1) - RND(1) '     create X vector for spark
        Sparks(topspark& + count&).ydir = RND(1) - RND(1) '     create Y vector for spark
    LOOP UNTIL count& = SPARKNUM '                              leave when all new sparks created

END SUB

'------------------------------------------------------------------------------------------------------------
SUB UpdateSparks ()
    '--------------------------------------------------------------------------------------------------------
    '- Maintains/updates any sparks found in the Sparks array. -
    '-----------------------------------------------------------

    SHARED Sparks() AS SPARK ' need access to the Sparks array

    DIM count& '   spark counter
    DIM fade1% '   main spark RGB intensity
    DIM fade2% '   surrounding area of spark RGB intensity
    DIM cleanup% ' -1 (TRUE) if all sparks dead

    IF UBOUND(Sparks) = 0 THEN EXIT SUB '       leave if array empty
    count& = 0 '                                reset spark counter
    cleanup% = -1 '                             assume array needs reset
    DO '                                        cycle through all sparks in array
        count& = count& + 1 '                   increment spark counter
        IF Sparks(count&).life > 0 THEN '       is this spark alive?
            cleanup% = 0 '                      yes, array can't be reset
            fade1% = Sparks(count&).fade / 2 '  calculate RGB intensity of center pixel
            fade2% = Sparks(count&).fade / 4 '  calculate RGB intensity of outer pixels

            '** draw pixels

            PSET (Sparks(count&).x, Sparks(count&).y),_
                 _RGB(Sparks(count&).fade, Sparks(count&).fade, Sparks(count&).fade)
            PSET (Sparks(count&).x + 1, Sparks(count&).y), _RGB(fade1%, fade1%, fade1%)
            PSET (Sparks(count&).x - 1, Sparks(count&).y), _RGB(fade1%, fade1%, fade1%)
            PSET (Sparks(count&).x, Sparks(count&).y + 1), _RGB(fade1%, fade1%, fade1%)
            PSET (Sparks(count&).x, Sparks(count&).y - 1), _RGB(fade1%, fade1%, fade1%)
            PSET (Sparks(count&).x + 1, Sparks(count&).y + 1), _RGB(fade2%, fade2%, fade2%)
            PSET (Sparks(count&).x - 1, Sparks(count&).y - 1), _RGB(fade2%, fade2%, fade2%)
            PSET (Sparks(count&).x - 1, Sparks(count&).y + 1), _RGB(fade2%, fade2%, fade2%)
            PSET (Sparks(count&).x + 1, Sparks(count&).y - 1), _RGB(fade2%, fade2%, fade2%)

            Sparks(count&).fade = Sparks(count&).fade - 4 '        decrement RGB intensity      * changed

            '** update spark position

            Sparks(count&).x = Sparks(count&).x + Sparks(count&).xdir * Sparks(count&).xspeed ' * changed
            Sparks(count&).y = Sparks(count&).y + Sparks(count&).ydir * Sparks(count&).yspeed ' * chnaged

            Sparks(count&).xspeed = Sparks(count&).xspeed * .9 '   decrease spark X speed       * changed
            Sparks(count&).yspeed = Sparks(count&).yspeed * 1.03 ' increase spark Y speed       * added
            Sparks(count&).ydir = Sparks(count&).ydir + .04 '      slowly increase Y vector     * added
            Sparks(count&).life = Sparks(count&).life - 1 '        decrement spark life
        END IF
    LOOP UNTIL count& = UBOUND(sparks) '                           leave when all sparks updated
    IF cleanup% THEN REDIM Sparks(0) AS SPARK '                    reset array if no live sparks found

END SUB


