REM The Piano
REM \CHAP11\CH11_12.BAS

SCREEN 7, 0, 1, 0

dur% = 1000
recordingflag% = 0
songloadedflag% = 0

DIM song$(1000)
DIM wholekey%(300)
DIM leftkey%(300)
DIM midkey%(300)
DIM rightkey%(300)
DIM sharpkey%(450)
DIM midsharpkey%(450)

'Drawing Both Keyboards
movekeys% = 0
colorkeys% = 10
FOR drawkeys% = 1 TO 2
FOR x% = (20 + movekeys%) TO (70 + movekeys%) STEP 16
        LINE (10 + x%, 30)-((10 + x%) + 12, 100), colorkeys%, BF
NEXT x%
FOR x% = (53 + movekeys%) TO (80 + movekeys%) STEP 17
        LINE (x%, 30)-((x%) + 13, 70), 0, BF
NEXT x%
movekeys% = 100
colorkeys% = 15
NEXT drawkeys%
LINE (56, 30)-(64, 69), 10, BF
LINE (156, 30)-(164, 69), 8, BF

'GetKeys
GET (130, 30)-(142, 100), wholekey%
GET (146, 30)-(158, 100), leftkey%
GET (162, 30)-(174, 100), midkey%
GET (178, 30)-(190, 100), rightkey%
GET (156, 30)-(164, 69), sharpkey%
GET (156, 30)-(163, 69), midsharpkey%

CLS 0

SCREEN 1, 0, 0, 0

'IntroScreen
LOCATE 8, 14: PRINT "The Piano"
LOCATE 19, 12: PRINT "(c)G.J.Butler"
FOR counter = 12 TO 24
LOCATE 6, counter: PRINT CHR$(1)
LOCATE 10, counter: PRINT CHR$(1)
NEXT counter
y = 12
FOR countertwo = 1 TO 2
FOR counter = 7 TO 9
LOCATE counter, y: PRINT CHR$(1)
NEXT counter
y = 24
NEXT countertwo
FOR counter% = 1 TO 10
note = INT(RND * 2735) + 500
duration = INT(RND * 3) + 1
SOUND note, duration
NEXT counter%
PLAY "MS"
WHILE INKEY$ = "": WEND

CLS 0
SCREEN 7, 0, 0, 2

'Drawing Whole Keyboard
PUT (30, 30), wholekey%
x% = 45
FOR counter% = 1 TO 2
    PUT (x%, 30), leftkey%
    PUT (x% + 15, 30), midkey%
    PUT (x% + 30, 30), midkey%
    PUT (x% + 45, 30), rightkey%
    PUT (x% + 60, 30), leftkey%
    PUT (x% + 75, 30), midkey%
    PUT (x% + 90, 30), rightkey%
x% = 150
NEXT counter%
PUT (255, 30), wholekey%

x% = 0
FOR counter% = 1 TO 2
    PUT (54 + x%, 30), sharpkey%, OR
    PUT (70 + x%, 30), midsharpkey%, OR
    PUT (85 + x%, 30), sharpkey%, OR
    PUT (114 + x%, 30), sharpkey%, OR
    PUT (130 + x%, 30), sharpkey%, OR
x% = 105
NEXT counter%

'Print Keyboard Keys
LOCATE 3, 8
PRINT "S D F  H J   3 4 5  7 8"
LOCATE 14, 4
PRINT "| Z X C V B N M W E R T Y U I O"
LOCATE 18, 14
PRINT "Note:"
LOCATE 24, 1: PRINT "F1 - Menu";
LOCATE 24, 31: PRINT "Q - Quit";

SCREEN 7, 0, 0, 0

'GetNote
GetKey:
playingsonflag% = 0
a$ = UCASE$(INKEY$)
SELECT CASE a$
CASE CHR$(0) + CHR$(61)
        IF recordingflag% = 0 THEN GOTO GetKey
        PCOPY 0, 1
        COLOR 3
        GOSUB drawbigmenu
        COLOR 10
        LOCATE 8, 13: PRINT "Are You Sure You"
        LOCATE 9, 13: PRINT "Want To Cancel.?"
        LOCATE 12, 15: PRINT "Yes or No"
cancel:
        b$ = UCASE$(INKEY$)
        IF b$ = "" THEN GOTO cancel
        IF b$ = "N" THEN
                PCOPY 1, 0: SCREEN 7, 0, 0, 0
                COLOR 15
                GOTO GetKey
        END IF
        IF b$ = "Y" THEN
                recordingflag% = 0
                notecount% = 0
                PCOPY 1, 0: SCREEN 7, 0, 0, 0
                COLOR 15
                GOTO GetKey
        ELSE
                PCOPY 1, 0: SCREEN 7, 0, 0, 0
                GOTO GetKey
        END IF
CASE CHR$(0) + CHR$(60)
        IF recordingflag% = 0 THEN GOTO GetKey
        GOTO savesong
CASE CHR$(0) + CHR$(59)
        GOTO menu
CASE "Q"
        GOTO quits
CASE " ", "\", "Z", "X", "C", "V", "B", "N", "M", "W", "E", "R", "T", "Y", "U", "I", "O", "S", "D", "F", "H", "J", "3", "4", "5", "7", "8"
        GOTO notes
CASE ELSE
GOTO GetKey
END SELECT

notes:
PLAY "MF"
SELECT CASE a$
CASE "\"
        note$ = "MFO1E"
        PAINT (30, 100), 10, 0
        LOCATE 18, 20: PRINT "E"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (30, 100), 15, 0
CASE "Z"
        note$ = "MFO1F"
        PAINT (45, 100), 10, 0
        LOCATE 18, 20: PRINT "F"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (45, 100), 15, 0
CASE "X"
        note$ = "MFO1G"
        PAINT (60, 100), 10, 0
        LOCATE 18, 20: PRINT "G"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (60, 100), 15, 0
CASE "C"
        note$ = "MFO1A"
        PAINT (75, 100), 10, 0
        LOCATE 18, 20: PRINT "A"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (75, 100), 15, 0
CASE "V"
        note$ = "MFO1B"
        PAINT (90, 100), 10, 0
        LOCATE 18, 20: PRINT "B"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (90, 100), 15, 0
CASE "B"
        note$ = "MFO2C"
        PAINT (105, 100), 10, 0
        LOCATE 18, 20: PRINT "C"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (105, 100), 15, 0
CASE "N"
        note$ = "MFO2D"
        PAINT (120, 100), 10, 0
        LOCATE 18, 20: PRINT "D"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (120, 100), 15, 0
CASE "M"
        note$ = "MFO2E"
        PAINT (135, 100), 10, 0
        LOCATE 18, 20: PRINT "E"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (135, 100), 15, 0
CASE "W"
        note$ = "MFO2F"
        PAINT (150, 100), 10, 0
        LOCATE 18, 20: PRINT "F"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (150, 100), 15, 0
CASE "E"
        note$ = "MFO2G"
        PAINT (165, 100), 10, 0
        LOCATE 18, 20: PRINT "G"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (165, 100), 15, 0
CASE "R"
        note$ = "MFO2A"
        PAINT (180, 100), 10, 0
        LOCATE 18, 20: PRINT "A"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (180, 100), 15, 0
CASE "T"
        note$ = "MFO2B"
        PAINT (195, 100), 10, 0
        LOCATE 18, 20: PRINT "B"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (195, 100), 15, 0
CASE "Y"
        note$ = "MFO3C"
        PAINT (210, 100), 10, 0
        LOCATE 18, 20: PRINT "C"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (210, 100), 15, 0
CASE "U"
        note$ = "MFO3D"
        PAINT (225, 100), 10, 0
        LOCATE 18, 20: PRINT "D"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (225, 100), 15, 0
CASE "I"
        note$ = "MFO3E"
        PAINT (240, 100), 10, 0
        LOCATE 18, 20: PRINT "E"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (240, 100), 15, 0
CASE "O"
        note$ = "MFO3F"
        PAINT (255, 100), 10, 0
        LOCATE 18, 20: PRINT "F"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (255, 100), 15, 0
CASE "S"
        note$ = "MFO1F#"
        PAINT (54, 30), 10, 0
        LOCATE 18, 20: PRINT "F#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (54, 30), 8, 0
CASE "D"
        note$ = "MFO1G#"
        PAINT (70, 30), 10, 0
        LOCATE 18, 20: PRINT "G#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (70, 30), 8, 0
CASE "F"
        note$ = "MFO1A#"
        PAINT (85, 30), 10, 0
        LOCATE 18, 20: PRINT "A#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (85, 30), 8, 0
CASE "H"
        note$ = "MFO2C#"
        PAINT (114, 30), 10, 0
        LOCATE 18, 20: PRINT "C#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (114, 30), 8, 0
CASE "J"
        note$ = "MFO2D#"
        PAINT (130, 30), 10, 0
        LOCATE 18, 20: PRINT "D#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (130, 30), 8, 0
CASE "3"
        note$ = "MFO2F#"
        PAINT (159, 30), 10, 0
        LOCATE 18, 20: PRINT "F#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (159, 30), 8, 0
CASE "4"
        note$ = "MFO2G#"
        PAINT (175, 30), 10, 0
        LOCATE 18, 20: PRINT "G#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (175, 30), 8, 0
CASE "5"
        note$ = "MFO2A#"
        PAINT (190, 30), 10, 0
        LOCATE 18, 20: PRINT "A#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (190, 30), 8, 0
CASE "7"
        note$ = "MFO3C#"
        PAINT (219, 30), 10, 0
        LOCATE 18, 20: PRINT "C#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (219, 30), 8, 0
CASE "8"
        note$ = "MFO3D#"
        PAINT (235, 30), 10, 0
        LOCATE 18, 20: PRINT "D#"
        PLAY note$
        FOR n = 1 TO dur%
        NEXT n
        LOCATE 18, 20: PRINT "  "
        PAINT (235, 30), 8, 0
CASE ""
        note$ = "Rest"
        LOCATE 18, 20: PRINT note$
        PLAY "N0"
        FOR n = 1 TO dur%
        NEXT n
        note$ = "0000N0"
        LOCATE 18, 20: PRINT "    "
CASE " "
        note$ = "Rest"
        LOCATE 18, 20: PRINT note$
        FOR n = 1 TO dur%
        NEXT n
        note$ = "0000N0"
        LOCATE 18, 20: PRINT "    "

END SELECT
IF playingsongflag% = 1 THEN
        GOTO playsongloop
END IF
length% = LEN(note$)
actualnote$ = RIGHT$(note$, length% - 4)
IF recordingflag% = 1 THEN
        notecount% = notecount% + 2
        IF note$ = "0000N0" THEN note$ = "N0"
        song$(position%) = a$
        position% = position% + 1
        song$(position%) = note$
        position% = position% + 1
END IF
GOTO GetKey

quits:
LOCATE 24, 30: PRINT "Sure? Y/N";
b$ = UCASE$(INKEY$)
IF b$ = "" THEN GOTO quits
SELECT CASE b$
CASE "N"
        LOCATE 24, 30: PRINT " Q - Quit";
CASE "Y"
        CLS
        END
CASE ELSE
        LOCATE 24, 30: PRINT " Q - Quit";
END SELECT
GOTO GetKey

'Draw Menu Box
menu:
PCOPY 0, 1
COLOR 3
GOSUB drawbigmenu
COLOR 10
LOCATE 7, 14: PRINT "R - Record Song"
LOCATE 8, 14: PRINT "L - Load Song"
LOCATE 9, 14: PRINT "P - Play Song"
LOCATE 14, 14: PRINT "X - Exit Menu"
GetMenuKey:
b$ = UCASE$(INKEY$)
SELECT CASE b$
CASE "R"
        GOTO record
CASE "L"
        GOTO load
CASE "X"
        GOTO exitmenu
CASE "P"
        GOTO playsong
CASE ELSE
        GOTO GetMenuKey
END SELECT
exitmenu:
PCOPY 1, 0: SCREEN 7, 0, 0, 0
COLOR 15
GOTO GetKey

record:
LOCATE 7, 13: PRINT "Type in the full"
LOCATE 8, 14: PRINT "path & name of"
LOCATE 9, 13: PRINT "your song below:"
LOCATE 11, 12: PRINT "eg C:\SONGS\BOPPY"
COLOR 3
GOSUB drawsmallmenu
tryagainrecord:
COLOR 10
LOCATE 18, 7: INPUT ; name$
IF name$ = "" THEN GOTO tryagainrecord
PCOPY 1, 0: SCREEN 7, 0, 0, 0
PCOPY 0, 1
COLOR 3
GOSUB drawbigmenu
COLOR 10
LOCATE 7, 12: PRINT "Press F2 when you"
LOCATE 8, 13: PRINT "are finished or"
LOCATE 9, 13: PRINT "F3 to cancel at"
LOCATE 10, 13: PRINT "any time......."
LOCATE 13, 14: PRINT "Press Any Key"
LOCATE 14, 16: PRINT "to Start"
recordingflag% = 1
notecount% = 0
position% = 1
WHILE INKEY$ = "": WEND
GOTO exitmenu

savesong:
OPEN name$ FOR OUTPUT AS #1
PRINT #1, notecount%
FOR counter% = 1 TO notecount%
        PRINT #1, song$(counter%)
NEXT counter%
CLOSE #1
PCOPY 0, 1
COLOR 3
GOSUB drawsmallmenu
COLOR 10
LOCATE 18, 7: PRINT "Song saved as "; name$;
recordingflag% = 0
position% = 0
notecount% = 0
WHILE INKEY$ = "": WEND
GOTO exitmenu

load:
COLOR 3
GOSUB drawbigmenu
COLOR 10
LOCATE 7, 13: PRINT "Type in the full"
LOCATE 8, 14: PRINT "path & name of"
LOCATE 9, 13: PRINT "your song below:"
LOCATE 11, 12: PRINT "eg C:\SONGS\BOPPY"
COLOR 3
GOSUB drawsmallmenu
tryagainload:
COLOR 10
LOCATE 18, 7: INPUT ; name$
IF name$ = "" THEN GOTO tryagainload
OPEN name$ FOR INPUT AS #1
notecount% = 0
INPUT #1, notecount%
FOR counter% = 0 TO notecount% - 1
        INPUT #1, song$(counter%)
NEXT counter%
CLOSE #1
PCOPY 1, 0: SCREEN 7, 0, 0, 0
PCOPY 0, 1
COLOR 3
GOSUB drawbigmenu
COLOR 10
LOCATE 7, 15: PRINT "Song loaded"
LOCATE 9, 13: PRINT "To play the song"
LOCATE 10, 13: PRINT "select Play from"
LOCATE 11, 14: PRINT "the main menu."
LOCATE 14, 14: PRINT "Press Any Key"
songloadedflag% = 1
WHILE INKEY$ = "": WEND
PCOPY 1, 0: SCREEN 7, 0, 0, 0
COLOR 15
GOTO menu

playsong:
IF songloadedflag% = 0 THEN
        COLOR 3
        GOSUB drawsmallmenu
        COLOR 10
        LOCATE 18, 7: PRINT "No Song Loaded...Press A Key"
        COLOR 15
        WHILE INKEY$ = "": WEND
        PCOPY 1, 0: SCREEN 7, 0, 0, 0
        COLOR 15
        GOTO menu
END IF
COLOR 3
GOSUB drawbigmenu
COLOR 10
LOCATE 8, 14: PRINT "Press Any Key"
LOCATE 9, 15: PRINT "to Play Song"
COLOR 3
GOSUB drawsmallmenu
COLOR 10
LOCATE 18, 7: PRINT ; name$
WHILE INKEY$ = "": WEND
PCOPY 1, 0: SCREEN 7, 0, 0, 0
COLOR 15
playingsongflag% = 1
FOR counter% = 0 TO notecount% - 1 STEP 2
        a$ = song$(counter%)
        GOTO notes
playsongloop:
NEXT counter%
playingsongflag% = 0
GOTO GetKey
            
END

drawbigmenu:
COLOR 3
LOCATE 5, 30: PRINT CHR$(187): LOCATE 5, 10: PRINT CHR$(201)
FOR box% = 11 TO 29: LOCATE 5, box%: PRINT CHR$(205): NEXT box%
FOR box% = 6 TO 15
LOCATE box%, 10: PRINT CHR$(186): LOCATE box%, 30: PRINT CHR$(186)
NEXT box%
LOCATE 16, 10: PRINT CHR$(200): LOCATE 16, 30: PRINT CHR$(188)
FOR box% = 11 TO 29: LOCATE 16, box%: PRINT CHR$(205): NEXT box%
FOR box% = 6 TO 15: LOCATE box%, 11: PRINT "                   ": NEXT box%
RETURN

drawsmallmenu:
LOCATE 14, 14: PRINT "             "
LOCATE 17, 4: PRINT CHR$(201): LOCATE 17, 36: PRINT CHR$(187)
FOR box% = 5 TO 35: LOCATE 17, box%: PRINT CHR$(205): NEXT box%
LOCATE 18, 4: PRINT CHR$(186): LOCATE 18, 36: PRINT CHR$(186)
LOCATE 19, 4: PRINT CHR$(200): LOCATE 19, 36: PRINT CHR$(188)
FOR box% = 5 TO 35: LOCATE 19, box%: PRINT CHR$(205): NEXT box%
LOCATE 18, 14: PRINT "       "
RETURN

