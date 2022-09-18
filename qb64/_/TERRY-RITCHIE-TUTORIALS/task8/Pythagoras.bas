'-------------------------------------------------------
'Description: Solves graphically the Pythagorean Theorem
'Author     : Terry Ritchie
'Date       : 11/02/13
'Update     : 04/12/20
'Version    : 1.1
'Rights     : Open source, free to modify and distribute
'Terms      : Original author's name must remain intact
'-------------------------------------------------------

'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST WHITE = _RGB32(255, 255, 255)
CONST GRAY = _RGB32(127, 127, 127)
CONST YELLOW = _RGB32(255, 255, 0)
CONST BRIGHTRED = _RGB32(255, 0, 0)
CONST BRIGHTGREEN = _RGB32(0, 255, 0)

DIM a!, b!, c! ' the lengths of the sides of the triangle
DIM Answer! '    the answer to the problem presented by the user
DIM KeyPress$ '  any key that the user presses when asked to execute program again

'----------------------------
'- Main Program Begins Here -
'----------------------------

_TITLE "Solve Pythagorean Theorem" '                               give window a title
SCREEN _NEWIMAGE(640, 480, 32) '                                   enter a graphics screen
DO '                                                               begin main program loop here
    CLS '                                                          clear the screen
    LOCATE 2, 9 '                                                  position text cursor
    COLOR GRAY '                                                   set text color to gray
    PRINT "This program will solve the Pythagorean Theorem "; '    inform user of program purpose
    PRINT "(A"; CHR$(253); " + B"; CHR$(253); " = C"; CHR$(253); ")" ' character 253 in ASCII is power of 2 symbol
    COLOR WHITE '                                                  set text color to bright white
    LOCATE 9, 28 '                                                 position text cursor
    PRINT "c =" '                                                  print text
    COLOR YELLOW '                                                 set text color to yellow
    LOCATE 10, 55 '                                                position text cursor
    PRINT "b =" '                                                  print text
    COLOR BRIGHTRED '                                              set text color to bright red
    LOCATE 17, 37 '                                                position text cursor
    PRINT "a =" '                                                  print text
    LINE (219, 250)-(419, 50), WHITE '                             draw triangle's bright white hypotenuse
    LINE -(419, 250), YELLOW '                                     draw triangle's yellow leg
    LINE -(219, 250), BRIGHTRED '                                  draw trianlge's bright red leg
    LINE (409, 250)-(409, 240), BRIGHTRED '                        draw 90 degree indicator
    LINE -(419, 240), YELLOW '                                     draw 90 degree indicator
    COLOR GRAY '                                                   set text color to gray
    LOCATE 19, 24 '                                                position text cursor
    PRINT "Enter the values for a, b and c." '                     inform user of what to do
    LOCATE 20, 24 '                                                position text cursor
    PRINT "Enter 0 to solve for that length." '                    print more information for user
    a! = AskFor!(22, 27, "a", BRIGHTRED, 17, 40) '                 ask user for value of side a leg
    b! = AskFor!(23, 27, "b", YELLOW, 10, 58) '                    ask user for value of side b leg
    c! = AskFor!(24, 27, "c", WHITE, 9, 31) '                      ask user for value of side c hypotenuse
    Answer! = SolvePythagoras!(a!, b!, c!) '                       solve for Pathagorean Theorem
    IF Answer! = -1 THEN '                                         is the solution -1?
        LOCATE 26, 16 '                                            yes, unsolvable, position text cursor
        COLOR WHITE '                                              set text color to bright white
        PRINT "ERROR: Triangle not possible with values provided" 'inform user that problem can't be solved
    ELSEIF Answer! = 0 THEN '                                      is the solution 0?
        LOCATE 26, 22 '                                            yes, unsolvable, position text cursor
        COLOR WHITE '                                              set text color to bright white
        PRINT "ERROR: Unsolvable! Too many unkowns!" '             inform user that problem can't be solved
    ELSEIF a! = 0 THEN '                                           was side a to be solved for?
        LOCATE 17, 40 '                                            yes, position text cursor
        COLOR BRIGHTRED '                                          set text color to bright red
        PRINT Answer! '                                            print value of side a
    ELSEIF b! = 0 THEN '                                           no, was side b to be solved for?
        LOCATE 10, 58 '                                            yes, position text cursor
        COLOR YELLOW '                                             set text color to yellow
        PRINT Answer! '                                            print value of side b
    ELSE '                                                         no, side c is to be solved for
        LOCATE 9, 31 '                                             position text cursor
        COLOR WHITE '                                              set text color to bright white
        PRINT Answer! '                                            print value of side c
    END IF
    COLOR BRIGHTGREEN '                                            set text color to bright green
    LOCATE 28, 16 '                                                position text cursor
    PRINT "Press ESC key to exit or any key to solve again." '     give user instructions
    DO '                                                           begin keyboard loop here
        KeyPress$ = INKEY$ '                                       save any keystroke pressed
        _LIMIT 5 '                                                 limit to 5 loops per second
    LOOP UNTIL KeyPress$ <> "" '                                   stop loop when a key was pressed
LOOP UNTIL KeyPress$ = CHR$(27) '                                  stop main loop if ESC key pressed
SYSTEM '                                                           return to Windows

'-----------------------------------
'- Function and Subroutine section -
'-----------------------------------

'--------------------------------------------------------------------------------------------------

FUNCTION AskFor! (x%, y%, L$, c~&, px%, py%)
    '
    '* asks for a value and returns the result *
    '* updates screen with answers given       *
    '
    'x%, y%   = text coordinate to place question at
    'L$       = the name of the letter to ask the value of
    'c%       = the color of the letter (line on triangle)
    'px%, py% = text coordinate to place value at

    DIM Value! ' the value the user supplies

    LOCATE x%, y% '                                   position text cursor on screen
    COLOR GRAY '                                      set text color to gray
    PRINT "Enter the value for "; '                   place text message on screen
    COLOR c~& '                                       set text color to color passed in
    PRINT L$; '                                       place letter on screen passed in
    COLOR GRAY '                                      set text color back to gray
    INPUT " > ", Value! '                             ask user for a value
    LOCATE px%, py% '                                 position text cursor on screen
    COLOR c~& '                                       set text color to color passed in
    IF Value! = 0 THEN PRINT " ?" ELSE PRINT Value! ' print value or ? depending on user input
    AskFor! = Value! '                                return to calling statement value user typed in

END FUNCTION

'--------------------------------------------------------------------------------------------------

FUNCTION SolvePythagoras! (SideA!, SideB!, SideC!)
    '
    '* Solves the Pythagorean Theorem given two of three triangle sides.    *
    '* This function will return a value of 0 if more than one side of the  *
    '* triangle is asked to be solved, which is impossible with Pythagoras. *
    '* A value of -1 will be returned if the problem is unsolvable due to   *
    '* impossible number pairs given for sides a&c or b&c.                  *
    '
    'SideA! = leg length of triangle        (value of 0 to solve)
    'SideB! = leg length of trinagle        (value of 0 to solve)
    'SideC! = hypotenuse length of triangle (value of 0 to solve)
    '
    IF SideA! = 0 THEN '                                          is side a to be solved?
        IF (SideB! <> 0) AND (SideC! <> 0) THEN '                 yes, is side a only side asked to solve?
            IF SideC! <= SideB! THEN '                            are numbers possible for right triangle?
                SolvePythagoras! = -1 '                           no, return the error
            ELSE '                                                no, these numbers are valid
                SolvePythagoras! = SQR(SideC! ^ 2 - SideB! ^ 2) ' return solution for side a
            END IF
        END IF
    ELSEIF SideB! = 0 THEN '                                      no, is side b to be solved?
        IF (SideA! <> 0) AND (SideC! <> 0) THEN '                 yes, is side b only side asked to solve?
            IF SideC! <= SideA! THEN '                            are numbers possible for a right triangle?
                SolvePythagoras! = -1 '                           no, return the error
            ELSE '                                                no, these numbers are valid
                SolvePythagoras! = SQR(SideC! ^ 2 - SideA! ^ 2) ' return solution for side b
            END IF
        END IF
    ELSEIF SideC! = 0 THEN '                                      no, is side c to be solved?
        IF (SideA! <> 0) AND (SideB! <> 0) THEN '                 yes, is side c only side asked to solve?
            SolvePythagoras! = SQR(SideA! ^ 2 + SideB! ^ 2) '     yes, return solution for side c
        END IF
    ELSE '                                                        no, user entered 0 for more than one side!
        SolvePythagoras! = 0 '                                    return 0 due to too many unknowns
    END IF

END FUNCTION

'--------------------------------------------------------------------------------------------------
























