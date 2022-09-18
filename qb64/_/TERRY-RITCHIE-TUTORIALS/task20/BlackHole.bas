'** Particle Effects Demo - Black Hole

CONST MAXPARTICLES = 32000 ' maximum number of particles on screen (do not exceed 32760!)
CONST PI2 = 6.2831852 '      2 * Pi (radians)

TYPE PARTICLE '              particle definition
    x AS SINGLE '            X coordinate of particle
    y AS SINGLE '            Y coordinate of particle
    radius AS SINGLE '       radius from center
    radian AS SINGLE '       current particle radian
    speed AS SINGLE '        particle speed
    clr AS _UNSIGNED LONG '  particle color
END TYPE

DIM Particles(MAXPARTICLES) AS PARTICLE ' set up array of particles
DIM Count% '                              particle counter

RANDOMIZE TIMER '                                                       seed random number generator
FOR Count% = 0 TO MAXPARTICLES '                                        cycle through all particles
    Particles(Count%).radian = RND(1) * PI2 '                           random particle radian
    Particles(Count%).radius = INT(RND(1) * 235) + 20 '                 random distance from center
NEXT Count%
SCREEN _NEWIMAGE(640, 480, 32) '                                        enter graphics screen
DO '                                                                    begin main loop
    _LIMIT 60 '                                                         60 frames per second
    CLS '                                                               clear screen
    Count% = 0 '                                                        reset particle counter
    DO '                                                                cycle through particles
        Particles(Count%).radius = Particles(Count%).radius - 1 '       decrement radius
        IF Particles(Count%).radius < 20 THEN '                         too small?
            Particles(Count%).radius = 255 '                            yes, increase radius
        END IF
        Particles(Count%).speed = 2 / Particles(Count%).radius '        calculate particle speed
        Particles(Count%).radian = Particles(Count%).radian + Particles(Count%).speed ' update radian
        IF Particles(Count%).radian >= PI2 THEN '                       radian too large?
            Particles(Count%).radian = Particles(Count%).radian - PI2 ' yes, reset radian
        END IF
        Particles(Count%).x = 319 + Particles(Count%).radius * COS(Particles(Count%).radian) '  update X and Y
        Particles(Count%).y = 239 + Particles(Count%).radius * -SIN(Particles(Count%).radian) ' locations
        Particles(Count%).clr = _RGB32(255 - Particles(Count%).radius, 0, 0) '   calculate particle color
        PSET (Particles(Count%).x, Particles(Count%).y), Particles(Count%).clr ' draw particle

        '** REM out the PSET line above, set the MAXPARTICLES constant to 500, then remove
        '** the REMs from the 3 lines below to see another effect

        'CIRCLE (Particles(Count%).x, Particles(Count%).y), 30, _RGB32(1, 1, 1)
        'PAINT (Particles(Count%).x, Particles(Count%).y), Particles(Count%).clr, _RGB32(1, 1, 1)
        'CIRCLE (Particles(Count%).x, Particles(Count%).y), 30, Particles(Count%).clr
        Count% = Count% + 1 '                                           increment particle counter
    LOOP UNTIL Count% > MAXPARTICLES '                                  leave when all particles updated
    _DISPLAY '                                                          update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                               leave when ESC key pressed
SYSTEM '                                                                return to operating system










