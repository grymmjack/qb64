' ===========
' BINVIEW.BAS
' ===========
' Views and Edits Binary files.
' View/edit ANY file up to 2 gigabytes in size.
' Uses POKE instead of PRINT to view all characters safely.

' Coded by Dav
'==========================================================

' ABOUT:
' ~~~~~
' BINVIEW can view and edit any file, EXE, ZIP - whatever.
' It's not a Text Viewer. but text files can also be viewed
' in binary mode. I use it for peeking inside EXE files and
' reading the text they contained or changing some bytes.

'============================================================

' HOW TO USE:
' ~~~~~~~~~~
' Just specify the file you want to view. The file is opened
' in VIEW mode. Use the Arrows, PageUp/Down, Home and End key
' to scroll through the file. To enter into EDIT mode press E.

' Press M for the menu of controls.

'============================================================

' MORE CONTROLS:
' ~~~~~~~~~~~~~
'
' E = Enter EDIT MODE. While in this mode, the displayed bytes
' can be edited. Use the arrow keys to move cursor to a desired
' location to begin typeing over the bytes. The current byte
' value is shown top-right in HEX and ASC values. All 256 ASCII
' characters can be entered using the numpad. Press ESC to save
' or cancel changes and to Exit EDIT MODE.
'
' S = SEARCHES for a string starting at the current byte.
' A Match-Case option is available. A high beep alerts
' when a match is found. A Low beep sounds when EOF reached.
' Searches about 5 MB's a second on my P-III-300.
'
' N = Find-NEXT-Match (after a string-search)
'
' F = Toggles FILTERING of all non-standard-text characters.
' A flashing "F" is at the top-left corner when filtering is ON.
'
' G = GOTO a specified Byte location in file.
'
' ESC = Quits the program. 
'
'=============================================================
' ADDITIONAL INFO:
' ~~~~~~~~~~~~~~~~
' This program uses POKE instead of PRINT to display every byte
' on the screen. This insures all ASCII characters can be
' viewed safely and without filtering.
'
'==============================================================
'

DEFINT A-Z
DECLARE SUB BINVIEW (File$)

'IF COMMAND$ = "" THEN
    PRINT
    LINE INPUT "FILE TO VIEW> ", File$
    IF File$ <> "" THEN BINVIEW File$: CLS
'ELSE
' BINVIEW COMMAND$
'END IF

END

DEFSNG A-Z
SUB BINVIEW (File$)

'=== OPEN the file
OPEN File$ FOR BINARY AS 7

'=== Check to see if it was there
IF LOF(7) = 0 THEN
    CLOSE 7: KILL File$
    EXIT SUB
END IF

'=== Set screen and define segment for pokeing
SCREEN 0: WIDTH 80, 25: DEF SEG = &HB800
  
'=== Set color for screen - turn cursor off
COLOR 15, 1: CLS : LOCATE 1, 1, 0
  
BC& = 1 'Current Byte count (position). SEEK will use it
  
'=== Buffer size. 79 colums * 24 rows = 1894 bytes per page to load.
Buff% = (79 * 24)
  
'=== If file size is lower than buff%, adjust buffer to suit
IF Buff% > LOF(7) THEN Buff% = LOF(7)

'======================
' MAIN DISPLAY ROUTINE
'======================
  
DO
   SEEK #7, BC& 'Go to the current byte.
   PG$ = INPUT$(Buff%, 7) 'Load page data to view.
   IF LEN(PG$) < (79 * 24) THEN 'Enough to fill screen?
     Pflag% = 1: Plimit% = LEN(PG$) 'No? Mark this and pad
     PG$ = PG$ + SPACE$(79 * 24 - LEN(PG$)) 'data with spaces.
   END IF
   y% = 2: x% = 1 'Screen location where data begins displaying
   FOR c% = 1 TO LEN(PG$) 'Show all the bytes.
     tb% = ASC(MID$(PG$, c%, 1)) 'Check the ASCII value.
     IF Filter% = 1 THEN 'If Filter is turned on,
       SELECT CASE tb% 'changes these values to spaces
         CASE 0 TO 32, 122 TO 255: tb% = 32
       END SELECT
     END IF
     POKE (y% - 1) * 160 + (x% - 1) * 2, tb% 'Poke bytes on screen
     'This line calculates when to go to next row.
     x% = x% + 1: IF x% = 80 THEN x% = 1: y% = y% + 1
   NEXT
   GOSUB DrawTopBar 'Show the top bar info
   '============= Get user input.....
   DO
     DO UNTIL L$ <> "": L$ = INKEY$: LOOP 'Wait for a keypress
     K$ = L$: L$ = "" 'Make copy, erase L$
     GOSUB DrawTopBar 'Show top bar info
     SELECT CASE UCASE$(K$) 'What did you press?
       CASE CHR$(27): EXIT DO 'ESC quits.
       CASE "M": GOSUB Menu: 'Do the menu
       CASE "N" 'Find next match if string has been given.
         IF s$ <> "" THEN
           GOSUB Search 'already been given.
           GOSUB DrawTopBar 'Update top bar info
         END IF
       CASE "E" 'Enter EDIT mode and
         GOSUB EditBIN: GOSUB DrawTopBar 'Update top bar info.
       CASE "F" 'Toggle filter ON/OFF
         IF Filter% = 0 THEN Filter% = 1 ELSE Filter% = 0
       CASE "G" 'Goto a certain byte.
         LOCATE 1, 1: PRINT STRING$(80 * 3, 32); 'Clear some space
         LOCATE 1, 1: PRINT "TOTAL BYTES>"; LOF(7) 'to use and...
         INPUT "GOTO BYTE #> ", GB$ 'ask user where.
         IF GB$ <> "" THEN 'Was data entered?
           TMP$ = "" 'Hard to explain this,
           FOR m% = 1 TO LEN(GB$) 'but change user data
             G$ = MID$(GB$, m%, 1) 'to numerical vales
             SELECT CASE ASC(G$)
               CASE 48 TO 57: TMP$ = TMP$ + G$
             END SELECT
           NEXT: GB$ = TMP$
           IF VAL(GB$) < 1 THEN GB$ = "1"
           IF VAL(GB$) > LOF(7) THEN GB$ = STR$(LOF(7))
           IF GB$ <> "" THEN BC& = 0 + VAL(GB$)
         END IF
       CASE "S": s$ = ""
         LOCATE 1, 1: PRINT STRING$(80 * 3, 32);
         LOCATE 1, 1: INPUT "Search for> ", s$
         IF s$ <> "" THEN
           PRINT "CASE sensitive (Y/N)? ";
           I$ = INPUT$(1): I$ = UCASE$(I$)
           IF I$ = "Y" THEN CaseOn% = 1 ELSE CaseOn% = 0
           GOSUB Search
         END IF
         GOSUB DrawTopBar
       CASE CHR$(0) + CHR$(72): IF BC& > 78 THEN BC& = BC& - 79
       CASE CHR$(0) + CHR$(80): IF BC& < LOF(7) - 78 THEN BC& = BC& + 79
       CASE CHR$(0) + CHR$(73): BC& = BC& - Buff%: IF BC& < 1 THEN BC& = 1
       CASE CHR$(0) + CHR$(81): IF BC& < LOF(7) - Buff% THEN BC& = BC& + Buff%
       CASE CHR$(0) + CHR$(71): BC& = 1
       CASE CHR$(0) + CHR$(79): IF NOT EOF(7) THEN BC& = LOF(7) - Buff%
     END SELECT
   LOOP UNTIL K$ <> ""
LOOP UNTIL K$ = CHR$(27) 'OR K$ = CHR$(13)

CLOSE 7
DEF SEG
  
EXIT SUB
Search:

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

EditBIN:

COLOR 1, 7
x% = 1: y% = 2
changes% = 0
LOCATE 1, 1: PRINT " Arrows move cursor "; CHR$(179); " ESC=Exit ";
COLOR 31, 0: PRINT " EDIT MODE ";
'COLOR 1, 7: PRINT " ";
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

IF changes% = 1 THEN
   SOUND 2500, 1: COLOR 15, 0: LOCATE , , 0
   LOCATE 10, 29: PRINT CHR$(201); STRING$(21, 205); CHR$(187);
   LOCATE 11, 29: PRINT CHR$(186); " Save Changes (Y/N)? "; CHR$(186);
   LOCATE 12, 29: PRINT CHR$(200); STRING$(21, 205); CHR$(188);
   N$ = INPUT$(1): COLOR 15, 1
   IF UCASE$(N$) = "Y" THEN
     IF Pflag% = 1 THEN PG$ = LEFT$(PG$, Plimit%)
     PUT #7, BC&, PG$:
   END IF
END IF
COLOR 15, 1: CLS : LOCATE 1, 1, 0
RETURN

DrawTopBar:

LOCATE 1, 1: COLOR 1, 15: PRINT STRING$(80, 32);
LOCATE 1, 1
IF Filter% = 1 THEN
   COLOR 30, 4: PRINT "F"; : COLOR 1, 15
ELSE
   PRINT " ";
END IF
PRINT "FILE: ";
IF LEN(File$) > 12 THEN
   PRINT RIGHT$(File$, 12);
ELSE
   PRINT File$;
END IF
PRINT " "; CHR$(179); " Bytes:"; LOF(7);
EC& = BC& + Buff%: IF EC& > LOF(7) THEN EC& = LOF(7)
PRINT CHR$(179); " Viewing:"; RTRIM$(STR$(BC&)); "-"; LTRIM$(STR$(EC&));
LOCATE 1, 70: PRINT CHR$(179); " M = Menu";
COLOR 15, 1
'== Draw bar on right side of screen
FOR d% = 2 TO 25
   LOCATE d%, 80: PRINT CHR$(176);
NEXT
Marker% = CINT(BC& / LOF(7) * 23)
LOCATE Marker% + 2, 80: PRINT CHR$(178);
RETURN

DrawEditBar:

CurrentByte& = BC& + (y% - 2) * 79 + x% - 1
CurrentValue% = ASC(MID$(PG$, (y% - 2) * 79 + x% * 1, 1))
COLOR 1, 7: LOCATE 1, 43: PRINT STRING$(38, " ");
LOCATE 1, 44
IF CurrentByte& > LOF(7) THEN
   PRINT SPACE$(9); "PAST END OF FILE";
ELSE
   PRINT "Byte:"; CurrentByte&;
   PRINT "Value:"; RTRIM$(STR$(CurrentValue%));
   PRINT ",&H"; RTRIM$(HEX$(CurrentValue%));
END IF
RETURN

Menu:
SOUND 2500, 1: COLOR 15, 0: LOCATE , , 0
LOCATE 7, 24: PRINT CHR$(201); STRING$(34, 205); CHR$(187);
FOR m = 8 TO 17
   LOCATE m, 24: PRINT CHR$(186); SPACE$(34); CHR$(186);
NEXT
LOCATE 18, 24: PRINT CHR$(200); STRING$(34, 205); CHR$(188);
LOCATE 8, 26: PRINT "Use the arrow keys, page up/down";
LOCATE 9, 26: PRINT "and Home/End keys to navigate.";
LOCATE 11, 26: PRINT "F = Toggles the filter ON or OFF";
LOCATE 12, 26: PRINT "G = Goto a certain byte position";
LOCATE 13, 26: PRINT "S = Searches for string in file";
LOCATE 14, 26: PRINT "N = Find next match after search";
LOCATE 15, 26: PRINT "E = Enter into file editing mode";
LOCATE 17, 30: PRINT "ESC = Exits this program";
Pause$ = INPUT$(1)
COLOR 15, 1: CLS : LOCATE 1, 1, 0
RETURN
END SUB
