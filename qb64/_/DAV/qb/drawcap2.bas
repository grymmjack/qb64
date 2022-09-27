' ============
' DRAWCAP2.BAS
' ============
' Coded by Dav

' ** PALLETTE data is now saved **

' This utility SUB captures an area of the screen as a BAS file
' containing DRAW statements that, when run, will recreate the area
' exactly as before. Pallette data is also saved.

' This program is useful if you have a small image you want to be
' included in the program. Just load your image and call DRAWCAP with
' the area to save and file to save as, then add the resulting file
' of BAS code to your program.

' The saved BAS code is often very large - usually too large to have
' in your main code. So, I recommend load the resulting BAS as a module
' instead. This way you can use many such BAS images in your programs.

' =========================================================
' NOTE: This demo creates a file called DRAW.BAS in current
' directory if ran without alteration.
' =========================================================

DEFINT A-Z
DECLARE SUB DRAWCAP (x1%, y1%, x2%, y2%, file$)

SCREEN 13

'=== DEMO BEGINS

'=== Let's create something to save...

FOR d% = 1 TO 100
    LOCATE RND * 24 + 1, RND * 39 + 1
    COLOR RND * 255
    PRINT "*";
NEXT

'=== Now we'll capture the WHOLE screen to file.
'=== You don't have to save the whole screen...
'=== just specify below what you want to saved.

DRAWCAP 0, 0, 319, 199, "DRAW.BAS"

'=== DEMO ENDS

END

SUB DRAWCAP (x1%, y1%, x2%, y2%, file$)

'=== This is a new DRAWCAP routine - Version 2
'=== It saves the given area of screen to a BAS code containing
'=== DRAW statements that recreates the same screen when it's run.
'=== The Pallette data is also captured and save to the BAS code.

'=== Open output file

    OPEN file$ FOR OUTPUT AS 1
  
    PRINT #1, "SCREEN 13"

'=== Grab and save current pallette

    PRINT #1, "A$="; CHR$(34); CHR$(34); ":";
    PRINT #1, "A$="; CHR$(34);

    OUT 967, 0: b% = 0
    FOR c% = 1 TO 768
      Pal$ = CHR$(INP(969)): b% = b% + 1
      PRINT #1, RIGHT$("0" + HEX$(ASC(Pal$)), 2);
      IF b% = 30 THEN
        PRINT #1, : PRINT #1, "A$ = A$+"; CHR$(34);
        b% = 0
      END IF
    NEXT: PRINT #1,

'=== Write routine that loads saved pallette
  
    PRINT #1, "c% = 0"
    PRINT #1, "FOR i%=1 TO LEN(A$) STEP 6"
    PRINT #1, " OUT 968, c%:c% = c% +1"
    PRINT #1, " OUT 969, VAL("; CHR$(34); "&H"; CHR$(34); "+MID$(A$,i%,2))"
    PRINT #1, " OUT 969, VAL("; CHR$(34); "&H"; CHR$(34); "+MID$(A$,i%+2,2))"
    PRINT #1, " OUT 969, VAL("; CHR$(34); "&H"; CHR$(34); "+MID$(A$,i%+4,2))"
    PRINT #1, "NEXT:A$="; CHR$(34); CHR$(34)

'=== Capture the given area as DRAW statements.

FOR y% = y1% TO y2%
      SL% = 1
      PRINT #1, "PSET("; LTRIM$(RTRIM$(STR$(x1%))); ",";
      PRINT #1, LTRIM$(RTRIM$(STR$(y%))); "):";
      PRINT #1, "DRAW"; CHR$(34);
      FOR x% = x1% TO x2%
         Clr% = POINT(x%, y%)
         IF Clr% = POINT(x% + 1, y%) THEN
            c% = 2: x% = x% + 2
            DO WHILE POINT(x%, y%) = Clr%
               c% = c% + 1: x% = x% + 1
               IF x% = x2% THEN EXIT DO
               IF c% = y2% THEN EXIT DO
            LOOP
            PRINT #1, "C"; LTRIM$(RTRIM$(STR$(Clr%))); "R"; LTRIM$(RTRIM$(STR$(c%)));
            x% = x% - 1
         ELSE
            PRINT #1, "C"; LTRIM$(RTRIM$(STR$(Clr%))); "R1";
         END IF
         SL% = SL% + 1
         IF SL% = 15 AND x% < x2% THEN
            PRINT #1, CHR$(32)
            PRINT #1, "DRAW"; CHR$(34);
            SL% = 1
         END IF
      NEXT
      PRINT #1, CHR$(34)
      '=== erase what was saved (for show)
      LINE (x1%, y%)-(x2%, y%), 0
NEXT

CLOSE 1

END SUB

