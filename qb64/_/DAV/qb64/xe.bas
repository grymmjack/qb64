
'============
'XE.BAS v1.10
'============
'A simple Binary File (HEX) editor.
'Coded by Dav on AUG 25, 2011 using QB64.
'Visit my website for more sourcecode at:
'http://www.qbasicnews.com/dav
'
'==========================================================================
'* * * *          USE THIS PROGRAM AT YOUR OWN RISK ONLY!!          * * * *
'==========================================================================
'
' New in XE v1.10:
' ~~~~~~~~~~~~~~~
'
' * ADDED: Now can View/Edit files in TWO modes - HEX (default) or ASCII.
'          ASCII mode allows for faster browsing through the file.
'          Toggle between HEX/ASCII mode by pressing ENTER while viewing.
' * ADDED: Shows Usage information when starting, added help in source.
' * ADDED: Now shows currently opened file in the TITLE menu (full name).
'          Short filename (8.3) is shown at top left line, after FILE:
' * ADDED: Now Uses Win API to test for file instead of using TEMP files.
' * ADDED: Can open file on READ-ONLY medium like CD's (because of above).
' * FIXED: Fixed error in FILTER that prevented letters from showing.
' * FIXED: Fixed several display bugs, and tweaked the layout more.
'
' THINGS TO DO:
'                  Add HEX Searching too.
'                  EAdd TEXT view for reading text files?
'                  Add a Create File option?
'                  Add (I) Info - Display File Information
'                  Add a File Copy to location...
'                  Highlight found text when searching
'
'==========================================================================
'
' ABOUT:
' ~~~~~
'
' XE is a simple Binary File Editor (also called a HEX editor) that lets
' you view and edit raw data bytes of a file.  With XE you can peek inside
' EXE/DLL files and see what information they may contain.  XE also has the
' capacity to change bytes by either typing in ASCII characters or entering 
' the HEX value for each byte.
'
' Since the very nature of XE is to alter file data you should always use 
' EXTREME caution when editing file - AND ALWAYS MAKE BACKUPS FIRST!
'
'==========================================================================
'
' HOW TO USE:
' ~~~~~~~~~~
'
' XE accepts command line arguments.  You can drag/drop a file onto XE or
' specify a file to load from the command prompt, like "XE.EXE file.ext".
' If you don't specify a filename on startup, XE will ask you for one.
'
' There are TWO ways to View & Edit files - in HEX (default) or ASCII mode.
'
' Files are first opened in HEX mode displaying 2 windows of data.  The
' right window shows the charaters while the larger left window shows HEX 
' values for them. HEX mode is best for patching and is the only way to
' edit the HEX values of bytes.
'
'
' Pressing ENTER switches to ASCII (non-HEX) mode, showing a larger page
' of raw data bytes - the ASCII chracter data only.  This mode is best for
' skimming through files faster.  ENTER toggles view mode back and forth.
' 
' While viewing a file you can browse through the file using the ARROWS, 
' PAGEUP/DOWN, HOME and the END key to scroll up and down.  
'
' The currently opened filename is shown with full path in the title bar,
' and its short filename (8.3) is displayed in the FILE: area just below.
' 
' While viewing a file, press E to enter into EDIT mode and begin editing
' bytes at the current position. If you're in HEX mode (2 windows), you can
' edit bytes either by typing characters on the right side or entering HEX
' values on the left window.  Press TAB to switch windows to edit in. 
' Press ESC to save or disgard changes and to exit editing mode. 
'
' Press M for a complete MENU listing all of the Key COMMANDS.
'
'==========================================================================
'
' COMMAND:
' ~~~~~~~~
'
'         E  =  Enters EDIT MODE. Only the displayed bytes can be edited.
'
'       TAB  =  Switchs panes (the cursor) while editing in HEX mode.
'
'         S  =  Searches file for a string starting at the current byte.
'               A Match-Case option is available.  A high beep alerts you
'               when match is found. A Low beep sounds when EOF reached.
'
'         N  =  Finds NEXT Match after a do a string search.
'
'         F  =  Toggles FILTERING of all non-standard-text characters.
'               A flashing "F" is at the top-left corner when FILTER ON.
'
'         G  =  GOTO a certain byte position (number) in the file.
'
'         L  =  GOTO a specified location (Hex value) of the file.
'
'     ENTER  =  Toggles HEX and ASCII view modes.  The ASCII mode lets
'               you browse more data per page.  You can EDIT in both
'               modes but can only enter in HEX vaules in HEX mode.
'
'       ESC  =  EXITS out of editing mode, and also EXITS the program.
'
' ALT+ENTER  =  Toggle FULLSCREEN/WINDOWED mode of the XE program.
'
'==========================================================================
'==========================================================================

DECLARE LIBRARY
    FUNCTION GetShortPathNameA (lpszLongPath AS STRING, lpszShortPath AS STRING, BYVAL cchBuffer AS LONG)
END DECLARE

_TITLE "XE v1.10"

IF COMMAND$ = "" THEN
    PRINT
    PRINT " ============"
    PRINT " XE.EXE v1.10"
    PRINT " ============"
    PRINT " A Simple Binary File (HEX) Editor."
    PRINT " Coded by Dav AUG 25th, 2011 using QB64"
    PRINT " Website: http://www.qbasicnews.com/dav"
    PRINT
    PRINT " USAGE: Drag & Drop a file on the XE program to open it."
    PRINT "        Or feed XE a file from the command prompt: XE.EXE filename.ext"
    PRINT "        You can also specify the file below (you must give full path)."
    PRINT "        Read XE.TXT or the XE.BAS Source for detailed help."
    PRINT
    LINE INPUT " FILE TO OPEN> ", File$
    IF File$ = "" THEN END
ELSE
    File$ = COMMAND$
END IF

ShortFileName$ = SPACE$(260)
Result = GetShortPathNameA(File$ + CHR$(0), ShortFileName$, LEN(ShortFileName$))

IF Result = 0 THEN
    PRINT " File not found!"
    END
END IF

'=== trim off any spaces...
ShortFileName$ = LTRIM$(RTRIM$(ShortFileName$))

'=== Just get the 8.3 name, removing any path name
ts$ = ""
FOR q = LEN(ShortFileName$) TO 1 STEP -1
    t$ = MID$(ShortFileName$, q, 1)
    IF t$ = "/" OR t$ = "\" THEN EXIT FOR
    ts$ = t$ + ts$
NEXT
ShortFileName$ = ts$


OPEN File$ FOR BINARY AS 7

_TITLE "XE v1.10 - " + File$

DisplayView% = 1 'Default to 2-PANE view

SCREEN 0: WIDTH 80, 25: DEF SEG = &HB800

COLOR 15, 1: CLS: LOCATE 1, 1, 0

BC& = 1

IF DisplayView% = 1 THEN
    Buff% = (16 * 24)
ELSE
    Buff% = (79 * 24)
END IF

IF Buff% > LOF(7) THEN Buff% = LOF(7)

'======================
' MAIN DISPLAY ROUTINE
'======================

DO
    SEEK #7, BC&
    PG$ = INPUT$(Buff%, 7)

    IF DisplayView% = 1 THEN
        IF LEN(PG$) < (16 * 24) THEN
            Pflag% = 1: Plimit% = LEN(PG$)
            PG$ = PG$ + STRING$(16 * 24 - LEN(PG$), CHR$(0))
        END IF

        '=== right window
        y% = 2: x% = 63
        FOR c% = 1 TO LEN(PG$)
            tb% = ASC(MID$(PG$, c%, 1))
            '=== show . instead of a null
            IF tb% = 0 THEN tb% = 46
            IF Filter% = 1 THEN
                SELECT CASE tb%
                    CASE 0 TO 31, 123 TO 255: tb% = 32
                END SELECT
            END IF
            POKE (y% - 1) * 160 + (x% - 1) * 2, tb%
            x% = x% + 1: IF x% = 79 THEN x% = 63: y% = y% + 1
        NEXT

        '=== show left side
        y% = 2: x% = 15
        FOR c% = 1 TO LEN(PG$)
            tb% = ASC(MID$(PG$, c%, 1))
            tb$ = HEX$(tb%): IF LEN(tb$) = 1 THEN tb$ = "0" + tb$
            LOCATE y%, x%: PRINT tb$; " ";
            x% = x% + 3: IF x% >= 62 THEN x% = 15: y% = y% + 1
        NEXT

    ELSE

        '...DisplayView% = 0, Full view...

        IF LEN(PG$) < (79 * 24) THEN 'Enough to fill screen?
            Pflag% = 1: Plimit% = LEN(PG$) 'No? Mark this and pad
            PG$ = PG$ + SPACE$(79 * 24 - LEN(PG$)) 'data with spaces.
        END IF
        y% = 2: x% = 1 'Screen location where data begins displaying
        FOR c% = 1 TO LEN(PG$) 'Show all the bytes.
            tb% = ASC(MID$(PG$, c%, 1)) 'Check the ASCII value.
            IF Filter% = 1 THEN 'If Filter is turned on,
                SELECT CASE tb% 'changes these values to spaces
                    CASE 0 TO 32, 123 TO 255: tb% = 32
                END SELECT
            END IF
            POKE (y% - 1) * 160 + (x% - 1) * 2, tb% 'Poke bytes on screen
            'This line calculates when to go to next row.
            x% = x% + 1: IF x% = 80 THEN x% = 1: y% = y% + 1
        NEXT

    END IF

    GOSUB DrawTopBar

    '=== Get user input
    DO
        DO UNTIL L$ <> "": L$ = INKEY$: LOOP
        K$ = L$: L$ = ""
        GOSUB DrawTopBar
        SELECT CASE UCASE$(K$)
            CASE CHR$(27): EXIT DO
            CASE "M": GOSUB Menu:
            CASE "N"
                IF s$ <> "" THEN
                    GOSUB Search
                    GOSUB DrawTopBar
                END IF
            CASE "E"
                IF DisplayView% = 1 THEN
                    GOSUB EditBIN
                ELSE
                    GOSUB EditBin3
                END IF
                GOSUB DrawTopBar
            CASE "F"
                IF Filter% = 0 THEN Filter% = 1 ELSE Filter% = 0
            CASE "G"
                LOCATE 1, 1: PRINT STRING$(80 * 3, 32);
                LOCATE 1, 3: PRINT "TOTAL BYTES>"; LOF(7)
                INPUT "  GOTO BYTE# > ", GB$
                IF GB$ <> "" THEN
                    TMP$ = ""
                    FOR m% = 1 TO LEN(GB$)
                        G$ = MID$(GB$, m%, 1) 'to numerical vales
                        SELECT CASE ASC(G$)
                            CASE 48 TO 57: TMP$ = TMP$ + G$
                        END SELECT
                    NEXT: GB$ = TMP$
                    IF VAL(GB$) < 1 THEN GB$ = "1"
                    IF VAL(GB$) > LOF(7) THEN GB$ = STR$(LOF(7))
                    IF GB$ <> "" THEN BC& = 0 + VAL(GB$)
                END IF
            CASE "L"
                LOCATE 1, 1: PRINT STRING$(80 * 3, 32);
                LOCATE 1, 3: 'PRINT "TOTAL BYTES>"; LOF(7)
                INPUT "  GOTO HEX LOCATION-> ", GB$
                IF GB$ <> "" THEN
                    GB$ = "&H" + GB$
                    IF VAL(GB$) < 1 THEN GB$ = "1"
                    IF VAL(GB$) > LOF(7) THEN GB$ = STR$(LOF(7))
                    IF GB$ <> "" THEN BC& = 0 + VAL(GB$)
                END IF
            CASE "S": s$ = ""
                LOCATE 1, 1: PRINT STRING$(80 * 3, 32);
                LOCATE 1, 3: INPUT "Search for> ", s$
                IF s$ <> "" THEN
                    PRINT "  CASE sensitive (Y/N)? ";
                    I$ = INPUT$(1): I$ = UCASE$(I$)
                    IF I$ = "Y" THEN CaseOn% = 1 ELSE CaseOn% = 0
                    GOSUB Search
                END IF
                GOSUB DrawTopBar
            CASE CHR$(13)
                IF DisplayView% = 1 THEN
                    DisplayView% = 0
                    Buff% = (79 * 24)
                ELSE
                    DisplayView% = 1
                    Buff% = (16 * 24)
                END IF
                GOSUB DrawTopBar
            CASE CHR$(0) + CHR$(72)
                IF DisplayView% = 1 THEN
                    IF BC& > 15 THEN BC& = BC& - 16
                ELSE
                    IF BC& > 78 THEN BC& = BC& - 79
                END IF
            CASE CHR$(0) + CHR$(80)
                IF DisplayView% = 1 THEN
                    IF BC& < LOF(7) - 15 THEN BC& = BC& + 16
                ELSE
                    IF BC& < LOF(7) - 78 THEN BC& = BC& + 79
                END IF
            CASE CHR$(0) + CHR$(73): BC& = BC& - Buff%: IF BC& < 1 THEN BC& = 1
            CASE CHR$(0) + CHR$(81): IF BC& < LOF(7) - Buff% THEN BC& = BC& + Buff%
            CASE CHR$(0) + CHR$(71): BC& = 1
            CASE CHR$(0) + CHR$(79): IF NOT EOF(7) THEN BC& = LOF(7) - Buff%
        END SELECT
    LOOP UNTIL K$ <> ""
LOOP UNTIL K$ = CHR$(27) 'OR K$ = CHR$(13)

CLOSE 7
DEF SEG

SYSTEM

'==============================================================================
'                                GOSUB ROUTINES
'==============================================================================

'=============
Search:
'=============

'==== A work-a-round for the EOF bug
'CLOSE 7
'OPEN File$ FOR BINARY AS #7
'SEEK 7, BC&
'===================================

IF NOT EOF(7) THEN
    DO
        B$ = INPUT$(Buff%, 7): BC& = BC& + Buff%
        IF CaseOn% = 0 THEN B$ = UCASE$(B$): s$ = UCASE$(s$)
        d$ = INKEY$: IF d$ <> "" THEN EXIT DO
        IF INSTR(1, B$, s$) THEN SOUND 4000, .5: EXIT DO
    LOOP UNTIL INSTR(1, B$, s$) OR EOF(7)
    IF EOF(7) THEN SOUND 2000, 1: SOUND 1000, 1
    BC& = BC& - LEN(s$)
END IF
RETURN


'=============
EditBIN:
'=============

Pane% = 1

x% = 63: IF rightx% THEN y% = CSRLIN ELSE y% = 2
leftx% = 15

test% = POS(0)

IF test% = 15 OR test% = 16 THEN x% = 63: leftx% = 15
IF test% = 18 OR test% = 19 THEN x% = 64: leftx% = 18
IF test% = 21 OR test% = 22 THEN x% = 65: leftx% = 21
IF test% = 24 OR test% = 25 THEN x% = 66: leftx% = 24
IF test% = 27 OR test% = 28 THEN x% = 67: leftx% = 27
IF test% = 30 OR test% = 31 THEN x% = 68: leftx% = 30
IF test% = 33 OR test% = 34 THEN x% = 69: leftx% = 33
IF test% = 36 OR test% = 37 THEN x% = 70: leftx% = 36
IF test% = 39 OR test% = 40 THEN x% = 71: leftx% = 39
IF test% = 42 OR test% = 43 THEN x% = 72: leftx% = 42
IF test% = 45 OR test% = 46 THEN x% = 73: leftx% = 45
IF test% = 48 OR test% = 49 THEN x% = 74: leftx% = 48
IF test% = 51 OR test% = 52 THEN x% = 75: leftx% = 51
IF test% = 54 OR test% = 55 THEN x% = 76: leftx% = 54
IF test% = 57 OR test% = 58 THEN x% = 77: leftx% = 57
IF test% = 60 OR test% = 61 THEN x% = 78: leftx% = 60

GOSUB DrawEditBar:

LOCATE y%, x%, 1, 1, 30

DO
    DO
        E$ = INKEY$
        IF E$ <> "" THEN
            SELECT CASE E$
                CASE CHR$(9)
                    IF Pane% = 1 THEN
                        Pane% = 2: GOTO EditBin2
                    ELSE
                        Pane% = 1: GOTO EditBIN
                    END IF
                CASE CHR$(27): EXIT DO
                CASE CHR$(0) + CHR$(72): IF y% > 2 THEN y% = y% - 1
                CASE CHR$(0) + CHR$(80): IF y% < 25 THEN y% = y% + 1
                CASE CHR$(0) + CHR$(75): IF x% > 63 THEN x% = x% - 1: leftx% = leftx% - 3
                CASE CHR$(0) + CHR$(77): IF x% < 78 THEN x% = x% + 1: leftx% = leftx% + 3
                CASE CHR$(0) + CHR$(73), CHR$(0) + CHR$(71): y% = 2
                CASE CHR$(0) + CHR$(81), CHR$(0) + CHR$(79): y% = 25
                CASE ELSE
                    'IF (BC& + (y% - 2) * 16 + x% - 1) <= LOF(7) AND E$ <> CHR$(8) THEN
                    IF (BC& + ((y% - 2) * 16 + x% - 1) - 62) <= LOF(7) AND E$ <> CHR$(8) THEN
                        changes% = 1

                        '=== new color for changed bytes...
                        COLOR 1, 15: LOCATE y%, x%: PRINT " ";
                        LOCATE y%, leftx%
                        tb$ = HEX$(ASC(E$)): IF LEN(tb$) = 1 THEN tb$ = "0" + tb$
                        PRINT tb$;

                        POKE (y% - 1) * 160 + (x% - 1) * 2, ASC(E$)
                        MID$(PG$, ((y% - 2) * 16 + x% * 1) - 62) = E$
                        IF x% < 78 THEN x% = x% + 1: leftx% = leftx% + 3 'skip space
                    END IF
            END SELECT
        END IF
    LOOP UNTIL E$ <> ""
    LOCATE y%, x%
LOOP UNTIL E$ = CHR$(27)

'===========
SaveChanges:
'===========

IF changes% = 1 THEN
    SOUND 4500, .2: COLOR 15, 4: LOCATE , , 0
    LOCATE 10, 29: PRINT CHR$(201); STRING$(21, 205); CHR$(187);
    LOCATE 11, 29: PRINT CHR$(186); " Save Changes (Y/N)? "; CHR$(186);
    LOCATE 12, 29: PRINT CHR$(200); STRING$(21, 205); CHR$(188);
    N$ = INPUT$(1): COLOR 15, 1
    IF UCASE$(N$) = "Y" THEN
        IF Pflag% = 1 THEN PG$ = LEFT$(PG$, Plimit%)
        PUT #7, BC&, PG$:
    END IF
END IF
COLOR 15, 1: CLS: LOCATE 1, 1, 0
RETURN

'===========
EditBin2:
'===========

COLOR 1, 7
x% = 15: 'y% = 2
rightx% = 63

test% = POS(0)
IF test% = 63 THEN x% = 15: rightx% = 63
IF test% = 64 THEN x% = 18: rightx% = 64
IF test% = 65 THEN x% = 21: rightx% = 65
IF test% = 66 THEN x% = 24: rightx% = 66
IF test% = 67 THEN x% = 27: rightx% = 67
IF test% = 68 THEN x% = 30: rightx% = 68
IF test% = 69 THEN x% = 33: rightx% = 69
IF test% = 70 THEN x% = 36: rightx% = 70
IF test% = 71 THEN x% = 39: rightx% = 71
IF test% = 72 THEN x% = 42: rightx% = 72
IF test% = 73 THEN x% = 45: rightx% = 73
IF test% = 74 THEN x% = 48: rightx% = 74
IF test% = 75 THEN x% = 51: rightx% = 75
IF test% = 76 THEN x% = 54: rightx% = 76
IF test% = 77 THEN x% = 57: rightx% = 77
IF test% = 78 THEN x% = 60: rightx% = 78

GOSUB DrawEditBar:

LOCATE y%, x%, 1, 1, 30

DO
    DO
        E$ = INKEY$
        IF E$ <> "" THEN
            SELECT CASE E$
                CASE CHR$(9)
                    IF Pane% = 1 THEN
                        Pane% = 2: GOTO EditBin2
                    ELSE
                        Pane% = 1: GOTO EditBIN
                    END IF
                CASE CHR$(27): EXIT DO
                CASE CHR$(0) + CHR$(72): IF y% > 2 THEN y% = y% - 1
                CASE CHR$(0) + CHR$(80): IF y% < 25 THEN y% = y% + 1
                CASE CHR$(0) + CHR$(75) 'right arrow....
                    IF x% > 15 THEN
                        SELECT CASE x%
                            CASE 17, 18, 20, 21, 23, 24, 26, 27, 29, 30, 32, 33, 35, 36, 38, 39, 41, 42, 44, 45, 47, 48, 50, 51, 53, 54, 56, 57, 59, 60, 62, 63
                                x% = x% - 2
                                rightx% = rightx% - 1
                            CASE ELSE: x% = x% - 1
                        END SELECT
                    END IF
                    'IF rightx% > 63 THEN rightx% = rightx% - 1
                CASE CHR$(0) + CHR$(77)
                    IF x% < 61 THEN
                        SELECT CASE x%
                            CASE 16, 17, 19, 20, 22, 23, 25, 26, 28, 29, 31, 32, 34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 49, 50, 52, 53, 55, 56, 58, 59, 61, 62
                                x% = x% + 2
                                rightx% = rightx% + 1
                            CASE ELSE: x% = x% + 1
                        END SELECT
                    END IF
                    'IF rightx% < 78 THEN rightx% = rightx% + 1
                CASE CHR$(0) + CHR$(73), CHR$(0) + CHR$(71): y% = 2
                CASE CHR$(0) + CHR$(81), CHR$(0) + CHR$(79): y% = 25
                CASE ELSE
                    IF (BC& + ((y% - 2) * 16 + rightx% - 1) - 62) <= LOF(7) AND E$ <> CHR$(8) THEN
                        SELECT CASE UCASE$(E$)
                            CASE "A", "B", "C", "D", "E", "F", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
                                E$ = UCASE$(E$)
                                changes% = 1
                                COLOR 1, 15: LOCATE y%, x%: PRINT " ";
                                POKE (y% - 1) * 160 + (x% - 1) * 2, ASC(E$)
                                IF x% < 62 THEN

                                    SELECT CASE x%
                                        CASE 16, 17, 19, 20, 22, 23, 25, 26, 28, 29, 31, 32, 34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 49, 50, 52, 53, 55, 56, 58, 59, 61, 62
                                            e2$ = CHR$(VAL("&H" + CHR$(SCREEN(y%, x% - 1)) + CHR$(SCREEN(y%, x%))))
                                            'locate 1,1 : print e2$
                                            '===== reflect changes on right panel
                                            COLOR 1, 15: LOCATE y%, rightx%: PRINT " ";
                                            POKE (y% - 1) * 160 + (rightx% - 1) * 2, ASC(e2$)
                                            MID$(PG$, ((y% - 2) * 16 + rightx% * 1) - 62) = e2$
                                            '=== dont advance cursor if at last place
                                            IF x% < 61 THEN
                                                rightx% = rightx% + 1
                                                x% = x% + 2
                                            END IF
                                        CASE ELSE: x% = x% + 1
                                    END SELECT
                                END IF
                        END SELECT

                    END IF
            END SELECT
        END IF
    LOOP UNTIL E$ <> ""
    LOCATE y%, x%
LOOP UNTIL E$ = CHR$(27)

GOTO SaveChanges:


'===========
EditBin3:
'===========

COLOR 1, 7
x% = 1: y% = 2
changes% = 0

GOSUB DrawEditBar

LOCATE 2, 1, 1, 1, 30

DO
    DO
        E$ = INKEY$
        IF E$ <> "" THEN
            SELECT CASE E$
                CASE CHR$(27): EXIT DO
                CASE CHR$(0) + CHR$(72): IF y% > 2 THEN y% = y% - 1
                CASE CHR$(0) + CHR$(80): IF y% < 25 THEN y% = y% + 1
                CASE CHR$(0) + CHR$(75): IF x% > 1 THEN x% = x% - 1
                CASE CHR$(0) + CHR$(77): IF x% < 79 THEN x% = x% + 1
                CASE CHR$(0) + CHR$(73), CHR$(0) + CHR$(71): y% = 2
                CASE CHR$(0) + CHR$(81), CHR$(0) + CHR$(79): y% = 25
                CASE ELSE
                    IF (BC& + (y% - 2) * 79 + x% - 1) <= LOF(7) AND E$ <> CHR$(8) THEN
                        changes% = 1
                        '=== new color for changed bytes
                        COLOR 1, 15: LOCATE y%, x%: PRINT " ";
                        LOCATE y%, x%

                        POKE (y% - 1) * 160 + (x% - 1) * 2, ASC(E$)
                        MID$(PG$, (y% - 2) * 79 + x% * 1) = E$
                        IF x% < 79 THEN x% = x% + 1
                    END IF
            END SELECT
        END IF
    LOOP UNTIL E$ <> ""
    GOSUB DrawEditBar
    LOCATE y%, x%
LOOP UNTIL E$ = CHR$(27)

GOTO SaveChanges:

'===========
DrawEditBar:
'===========

IF DisplayView% = 1 THEN
    LOCATE 1, 1:
    COLOR 31, 4: PRINT "  EDIT MODE: ";
    COLOR 15, 4
    PRINT " Press TAB to switch editing sides "; CHR$(179); " Arrows move cursor "; CHR$(179); " ESC=Exit ";
ELSE
    LOCATE 1, 1
    COLOR 31, 4: PRINT " EDIT MODE ";
    COLOR 15, 4
    PRINT CHR$(179); " Arrows move cursor "; CHR$(179); " ESC=Exit "; CHR$(179);
    LOCATE 1, 45: PRINT STRING$(35, " ");

    LOCATE 1, 46
    CurrentByte& = BC& + (y% - 2) * 79 + x% - 1
    CurrentValue% = ASC(MID$(PG$, (y% - 2) * 79 + x% * 1, 1))
    IF CurrentByte& > LOF(7) THEN
        PRINT SPACE$(9); "PAST END OF FILE";
    ELSE
        PRINT "Byte:"; LTRIM$(STR$(CurrentByte&));
        PRINT ", ASC:"; LTRIM$(STR$(CurrentValue%));
        PRINT ", HEX:"; RTRIM$(HEX$(CurrentValue%));
    END IF
END IF

RETURN


'============
DrawTopBar:
'============

LOCATE 1, 1: COLOR 1, 15: PRINT STRING$(80, 32);
LOCATE 1, 1
IF Filter% = 1 THEN
    COLOR 30, 4: PRINT "F";: COLOR 1, 15
ELSE
    PRINT " ";
END IF

PRINT "FILE: "; ShortFileName$;

PRINT " "; CHR$(179); " Bytes:"; LOF(7);
EC& = BC& + Buff%: IF EC& > LOF(7) THEN EC& = LOF(7)
PRINT CHR$(179); " Viewing:"; RTRIM$(STR$(BC&)); "-"; LTRIM$(STR$(EC&));
LOCATE 1, 70: PRINT CHR$(179); " M = Menu";
COLOR 15, 1
'== Draw bar on right side of screen
FOR d% = 2 TO 25
    LOCATE d%, 80: PRINT CHR$(176);
NEXT

IF DisplayView% = 1 THEN
    '== Draw lines down screen
    FOR d% = 2 TO 25
        LOCATE d%, 79: PRINT CHR$(179);
        LOCATE d%, 62: PRINT CHR$(179);
        'add space around numbers...
        '(full screen messes it...)
        LOCATE d%, 13: PRINT " " + CHR$(179);
        LOCATE d%, 1: PRINT CHR$(179) + " ";
    NEXT

    '=== Draw location
    FOR d% = 2 TO 25
        LOCATE d%, 3
        nm$ = HEX$(BC& - 32 + (d% * 16))
        IF LEN(nm$) = 9 THEN nm$ = "0" + nm$
        IF LEN(nm$) = 8 THEN nm$ = "00" + nm$
        IF LEN(nm$) = 7 THEN nm$ = "000" + nm$
        IF LEN(nm$) = 6 THEN nm$ = "0000" + nm$
        IF LEN(nm$) = 5 THEN nm$ = "00000" + nm$
        IF LEN(nm$) = 4 THEN nm$ = "000000" + nm$
        IF LEN(nm$) = 3 THEN nm$ = "0000000" + nm$
        IF LEN(nm$) = 2 THEN nm$ = "00000000" + nm$
        IF LEN(nm$) = 1 THEN nm$ = "000000000" + nm$
        PRINT nm$;
    NEXT
END IF

Marker% = CINT(BC& / LOF(7) * 23)
LOCATE Marker% + 2, 80: PRINT CHR$(178);
RETURN

'========
Menu:
'========

SOUND 4500, .2: COLOR 15, 0: LOCATE , , 0
LOCATE 5, 24: PRINT CHR$(201); STRING$(34, 205); CHR$(187);
FOR m = 6 TO 20
    LOCATE m, 24: PRINT CHR$(186); SPACE$(34); CHR$(186);
NEXT
LOCATE 21, 24: PRINT CHR$(200); STRING$(34, 205); CHR$(188);

LOCATE 6, 26: PRINT "Use the arrow keys, page up/down";
LOCATE 7, 26: PRINT "and Home/End keys to navigate.";
LOCATE 9, 26: PRINT "E = Enter into file editing mode";
LOCATE 10, 26: PRINT "F = Toggles the filter ON or OFF";
LOCATE 11, 26: PRINT "G = Goto a certain byte position";
LOCATE 12, 26: PRINT "L = Goto a certain HEX location";
LOCATE 13, 26: PRINT "S = Searches for string in file";
LOCATE 14, 26: PRINT "N = Find next match after search";
LOCATE 16, 26: PRINT "ENTER = Toggle HEX/ASCII modes";
LOCATE 17, 26: PRINT "TAB   = switch window (HEX mode)";
LOCATE 18, 26: PRINT "ESC   = EXITS this program";
LOCATE 20, 26: PRINT "ALT+ENTER for full screen window";
Pause$ = INPUT$(1)
COLOR 15, 1: CLS: LOCATE 1, 1, 0
RETURN

