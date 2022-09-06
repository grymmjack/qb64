'--------------------------------          ********************************************************
'- Variable Declaration Section -          * Simple hidden password demo highlighting some of the *
'--------------------------------          * string manipulation commands available in QB64.      *
'                                          *                                                      *
DIM Login$ '    login name user supplies   * LEN() - returns the length of a string               *
DIM Password$ ' password user supplies     * ASC() - returns the ASCII value of string character  *
'                                          * LEFT$() - returns left # of characters of a string   *
'----------------------------              * STRING$() - returns a string of same characters      *
'- Main Program Begins Here -              ********************************************************
'----------------------------

PRINT
PRINT " ------------------------"
PRINT " - Ritchie's Web Server -"
PRINT " ------------------------"
PRINT
PRINT " Welcome to my web server!"
PRINT
PRINT " Before you can begin, you must create an account."
DO '                                                                       begin login loop
    PRINT '                                                                blank line
    PRINT " Create a login name between 6 and 16 characters in length ." ' prompt user
    LINE INPUT " Login    > ", Login$ '                                    get login name
LOOP UNTIL LEN(Login$) > 5 AND LEN(Login$) < 17 '                          continue if length ok
DO '                                                                       begin password loop
    Password$ = "" '                                                       clear current password
    DO '                                                                   begin pwd length loop
        PRINT " Enter a password that is at least 8 characters long." '    prompt user
        Password$ = GetPassword$ '                                         get password from user
    LOOP UNTIL LEN(Password$) > 7 '                                        continue if length ok
    PRINT " Please verify the password by typing it in again." '           prompt user
LOOP UNTIL Password$ = GetPassword$ '                                      continue if same pwd
PRINT '                                                                    blank line
PRINT " Remember for your records:" '                                      inform user
PRINT '                                                                    blank line
PRINT " Login    > "; Login$ '                                             display login name
PRINT " Password > "; Password$ '                                          display password
END '                                                                      end program

'-----------------------------------
'- Function and Subroutine section -
'-----------------------------------

'--------------------------------------------------------------------------------------------------

FUNCTION GetPassword$ ()

    '**************************************************************************************************
    '* Prompts the user for a password. As user types in password the keystrokes are displayed as     *
    '* asterisks. The back space key is recognized. When the user presses the ENTER key the password  *
    '* entered by the user is sent back to the calling routine.                                       *
    '**************************************************************************************************

    '---------------------------
    '- Declare local variables -
    '---------------------------

    DIM Cursorline% ' current Y location of cursor
    DIM CursorPos% '  current X location of cursor
    DIM Password$ '   password created by user
    DIM KeyPress$ '   records key presses of user

    '------------------------
    '- Function begins here -
    '------------------------

    PRINT " Password > "; '                                    prompt user for input
    Cursorline% = CSRLIN '                                     save cursor Y position
    CursorPos% = POS(0) '                                      save cursor X location
    DO '                                                       begin main loop
        DO '                                                   begin key press loop
            _LIMIT 30 '                                        limit to 30 loops per sec
            KeyPress$ = INKEY$ '                               get key user presses
        LOOP UNTIL KeyPress$ <> "" '                           loop back if no key pressed
        IF ASC(KeyPress$) > 31 THEN '                          was key pressed printable?
            Password$ = Password$ + KeyPress$ '                yes, add it to password string
        ELSEIF ASC(KeyPress$) = 8 THEN '                       no, was it the back space key?
            Password$ = LEFT$(Password$, LEN(Password$) - 1) ' yes, remove rightmost character
        END IF
        LOCATE Cursorline%, CursorPos% '                       position cursor on screen
        PRINT STRING$(LEN(Password$), "*"); " "; '             print string of asterisks
    LOOP UNTIL KeyPress$ = CHR$(13) '                          end main loop if ENTER pressed
    PRINT '                                                    move cursor from end of asterisks
    GetPassword$ = Password$ '                                 return the password user supplied

END FUNCTION

'--------------------------------------------------------------------------------------------------






