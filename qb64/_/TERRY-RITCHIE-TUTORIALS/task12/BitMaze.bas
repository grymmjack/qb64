'*
'* Bitwise math demonstration
'*
'* Draws a simple map and allows player to move circle within map
'*

'--------------------------------
'- Variable Declaration Section -
'--------------------------------

TYPE MAP '             set up map cell structure
    x AS INTEGER '     upper left x coordinate of cell
    y AS INTEGER '     upper left y coordinate of cell
    walls AS INTEGER ' identifies cell walls
END TYPE

DIM MAP(4, 4) AS MAP ' create the map array
DIM cx% '              current x cell coordinate of player
DIM cy% '              current y cell coordinate of player
DIM KeyPress$ '        player key presses

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(250, 250, 32) '                                  create 250x250 32bit screen
_TITLE "Simple Map" '                                             give window a title
CLS '                                                             clear the screen
DRAWMAP '                                                         draw the map
DO '                                                              MAIN LOOP begins here
    PCOPY 1, 0 '                                                  copy page 1 to current screen
    CIRCLE (MAP(cx%, cy%).x + 24, MAP(cx%, cy%).y + 24), 20, _RGB32(255, 0, 0) ' draw player
    PAINT (MAP(cx%, cy%).x + 24, MAP(cx%, cy%).y + 24), _RGB32(128, 0, 0), _RGB32(255, 0, 0)
    _DISPLAY '                                                    update the screen without flicker
    DO '                                                          KEY INPUT LOOP begins here
        KeyPress$ = INKEY$ '                                      get a key (if any) that player pressed
        _LIMIT 120 '                                              limit loop to 120 times per second
    LOOP UNTIL KeyPress$ <> "" '                                  KEY INPUT LOOP back if no key
    SELECT CASE KeyPress$ '                                       which key was pressed?
        CASE CHR$(27) '                                           the ESC key
            SYSTEM '                                              return to Windows
        CASE CHR$(0) + CHR$(72) '                                 the UP ARROW key
            IF NOT MAP(cx%, cy%).walls AND 1 THEN cy% = cy% - 1 ' move player up if no wall present
        CASE CHR$(0) + CHR$(77) '                                 the RIGHT ARROW key
            IF NOT MAP(cx%, cy%).walls AND 2 THEN cx% = cx% + 1 ' move player right if no wall present
        CASE CHR$(0) + CHR$(80) '                                 the DOWN ARROW key
            IF NOT MAP(cx%, cy%).walls AND 4 THEN cy% = cy% + 1 ' move player down if no wall present
        CASE CHR$(0) + CHR$(75) '                                 the LEFT ARROW key
            IF NOT MAP(cx%, cy%).walls AND 8 THEN cx% = cx% - 1 ' move player left if no wall present
    END SELECT
LOOP '                                                            MAIN LOOP back

'-----------------------------------
'- Function and Subroutine section -
'-----------------------------------

SUB DRAWMAP ()

    '*
    '* draws a map based on the value of each map cell
    '*

    SHARED MAP() AS MAP ' need access to map array

    DIM x%, y% '          x,y map coordinates

    FOR y% = 0 TO 4 '                                                 cycle through map rows
        FOR x% = 0 TO 4 '                                             cycle through map columns
            READ MAP(x%, y%).walls '                                  read wall DATA
            MAP(x%, y%).x = x% * 50 '                                 compute upper left x coordinate of cell
            MAP(x%, y%).y = y% * 50 '                                 compute upper left y coordinate of cell
            IF MAP(x%, y%).walls AND 1 THEN '                         is NORTH wall present?
                LINE (MAP(x%, y%).x, MAP(x%, y%).y)-_
                     (MAP(x%, y%).x + 49, MAP(x%, y%).y), _RGB32(255, 255, 255) '      yes, draw it
            END IF
            IF MAP(x%, y%).walls AND 2 THEN '                         is EAST wall present?
                LINE (MAP(x%, y%).x + 49, MAP(x%, y%).y)-_
                     (MAP(x%, y%).x + 49, MAP(x%, y%).y + 49), _RGB32(255, 255, 255) ' yes, draw it
            END IF
            IF MAP(x%, y%).walls AND 4 THEN '                         is SOUTH wall present?
                LINE (MAP(x%, y%).x, MAP(x%, y%).y + 49)-_
                     (MAP(x%, y%).x + 49, MAP(x%, y%).y + 49), _RGB32(255, 255, 255) ' yes, draw it
            END IF
            IF MAP(x%, y%).walls AND 8 THEN '                         is WEST wall present?
                LINE (MAP(x%, y%).x, MAP(x%, y%).y)-_
                (MAP(x%, y%).x, MAP(x%, y%).y + 49), _RGB32(255, 255, 255) '           yes, draw it
            END IF
        NEXT x%
    NEXT y%
    PCOPY 0, 1 '                                                      save a copy of the map

END SUB

'------------------------
'- Program DATA section -
'------------------------

'*
'* Map cell values
'*

DATA 11,15,15,11,15,12,5,5,4,3,15,15,15,15,10,11,15,9,5,6,12,5,6,15,15























