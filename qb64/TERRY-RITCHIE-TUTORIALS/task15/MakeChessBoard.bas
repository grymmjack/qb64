'*
'* Chess Board Creator
'*

DIM ChessBoard& ' the chess board image

SCREEN _NEWIMAGE(800, 700, 32) '       create graphics screen
CLS '                                  clear the screen
_DELAY .5 '                            slight delay before moving screen to middle
_SCREENMOVE _MIDDLE '                  move screen to middle of desktop
DO '                                   begin main loop
    MakeChessBoard '                   make a new chess board
    _PUTIMAGE (103, 53), ChessBoard& ' display the chess board
    LOCATE 2, 22 '                     prnt directions
    PRINT "Press any key to make another chess board or ESC to exit."
    SLEEP '                            wait for key stroke
LOOP UNTIL _KEYDOWN(27) '              leave when ESC key pressed
_FREEIMAGE ChessBoard& '               remove image from memory
SYSTEM '                               return to operating system

'------------------------------------------------------------------------------------------------------------
SUB MakeChessBoard ()
    '--------------------------------------------------------------------------------------------------------
    '- Creates a random chess board in the ChessBoard& image handle -
    '----------------------------------------------------------------

    SHARED ChessBoard& ' need to share the global variable

    '** Declare local variables

    DIM ChessImage& '    the image supplied by the art department
    DIM WhiteTile&(3) '  4 white tiles
    DIM BlackTile&(3) '  4 black tiles
    DIM Count% '         generic counter
    DIM Toggle% '        toggles between 0 and 1
    DIM Flip% '          random number between 1 and 4
    DIM NextTile& '      next tile placed on board
    DIM x%, y% '         board square counters
    DIM tx%, ty% '       tile coordinate on chess board

    RANDOMIZE TIMER '                                               seed the random number generator

    '** Create chess board image if needed

    IF ChessBoard& = 0 THEN '                                       does chess board image already exist?
        ChessBoard& = _NEWIMAGE(592, 592, 32) '                     no, create the chess board image
    END IF

    '** Load the master graphic and parse out the individual images

    ChessImage& = _LOADIMAGE(".\tutorial\task15\chess.png", 32) '   load the master graphics file
    _PUTIMAGE , ChessImage&, ChessBoard&, (0, 70)-(591, 660) '      extract the wood board
    FOR Count% = 0 TO 3 '                                           cycle through 4 tiles
        WhiteTile&(Count%) = _NEWIMAGE(69, 69, 32) '                create white tile image
        BlackTile&(Count%) = _NEWIMAGE(69, 69, 32) '                create black tile image
        _PUTIMAGE , ChessImage&, WhiteTile&(Count%), (69 * Count%, 0)-(69 * Count% + 68, 68) '        extract
        _PUTIMAGE , ChessImage&, BlackTile&(Count%), (276 + 69 * Count%, 0)-(344 + 69 * Count%, 68) ' tiles
    NEXT Count%

    '** Draw the chess board

    Toggle% = INT(RND(1) * 2) '                                     start with random tile color
    FOR y% = 0 TO 7 '                                               cycle through 8 rows
        Toggle% = 1 - Toggle% '                                     new row opposite tile from last
        FOR x% = 0 TO 7 '                                           cycle through 8 columns
            Toggle% = 1 - Toggle% '                                 select next tile color
            IF Toggle% = 0 THEN '                                   0 for white tile
                NextTile& = WhiteTile&(INT(RND(1) * 4)) '           get random white tile
            ELSE '                                                  1 for black tile
                NextTile& = BlackTile&(INT(RND(1) * 4)) '           get random black tile
            END IF
            tx% = 20 + x% * 69 '                                    calculate next tile upper left x
            ty% = 20 + y% * 69 '                                    calculate next tile upper left y
            Flip% = INT(RND(1) * 4) + 1 '                           get random tile flip method
            SELECT CASE Flip% '                                     how should tile be flipped?
                CASE 1 '                                            normal, no flip
                    _PUTIMAGE (tx%, ty%), NextTile&, ChessBoard&
                CASE 2 '                                            flip vertically
                    _PUTIMAGE (tx% + 68, ty% + 68)-(tx%, ty%), NextTile&, ChessBoard&
                CASE 3 '                                            flip horizontally
                    _PUTIMAGE (tx% + 68, ty%)-(tx%, ty% + 68), NextTile&, ChessBoard&
                CASE 4 '                                            flip both
                    _PUTIMAGE (tx%, ty% + 68)-(tx% + 68, ty%), NextTile&, ChessBoard&
            END SELECT
        NEXT x%
    NEXT y%

    '** Perform memory cleanup (must be done or memory will fill up!)

    FOR Count% = 0 TO 3 '                                           cycle through 4 tiles
        _FREEIMAGE WhiteTile&(Count%) '                             remove white tile from memory
        _FREEIMAGE BlackTile&(Count%) '                             remove black tile from memory
    NEXT Count%
    _FREEIMAGE ChessImage& '                                        remove master graphics file from memory

END SUB

