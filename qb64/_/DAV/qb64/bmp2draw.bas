'============
'BMP2DRAW.BAS
'============
'Coded by Dav

'BMP2DRAW is a utility to convert a 320x200, 256 BMP image to
'a BAS program containing DRAW statements that, when run, will
'recreate the image on screen exactly as the BMP image. Pallette
'data is also converted and is saved in the BAS code.

'(This is just a BMP loader combined with the DRAWCAP routine)

'===========================================================
' NOTE: Only accepts 320x200, 256 color, uncompressed BMP's
'===========================================================

'I use this often to put images in my compiled programs without
'having to distribute the BMP file along with the compiled EXE.

'Some helpful info...

'The resulting BAS code is often very large - too large most times
'to put in your main code, so to overcome that you should load the
'BAS code as a module and easily call the SUB that draws the image.
'By using this method you could have many images inside your EXE.

'Oh yeah, this utility is used for SCREEN 13 only.


DEFINT A-Z
DECLARE SUB DRAWCAP (x1%, y1%, x2%, y2%, file$)

'=== Ask user for the BMP

   LINE INPUT "Name of BMP to use -> ", BMP$
   IF BMP$ = "" THEN END

'=== Ask user for name of BAS to create

   LINE INPUT "BAS file to create -> ", BAS$
   IF BAS$ = "" THEN END

'=== check if BMP file exists
   OPEN BMP$ FOR BINARY AS #2
  
   IF LOF(2) = 0 THEN
     PRINT UCASE$(BMP$); " not found."
     CLOSE 2: KILL BMP$: END
   END IF

'=== check BMP format...
   
    IF INPUT$(2, 2) <> "BM" OR LOF(2) <> 65078 THEN
      PRINT "Invalid BMP or format not accepted."
      CLOSE 2: END
    END IF

'=== Now load Pallette data from BMP
   
    SCREEN 13: SEEK 2, 55: OUT 968, 0
    FOR c% = 1 TO 256: b$ = INPUT$(4, 2)
       OUT 969, ASC(MID$(b$, 3, 1)) \ 4
       OUT 969, ASC(MID$(b$, 2, 1)) \ 4
       OUT 969, ASC(MID$(b$, 1, 1)) \ 4
    NEXT

'=== Now load image data to screen
   
    FOR y% = 199 TO 0 STEP -1
      Row$ = INPUT$(320, 2)
      FOR x% = 0 TO 319
         PSET (x%, y%), ASC(MID$(Row$, x% + 1, 1))
      NEXT
    NEXT
    CLOSE 2

'=== Now, call the DRAWCAP sub to save image to a BAS file.
'=== We'll save entire screen image (0,0 - 310,199).

    DRAWCAP 0, 0, 319, 199, BAS$

'=== Show the user something has happened
   
    SCREEN 0: WIDTH 80, 25
    PRINT UCASE$(BAS$); " saved."

'=== All good things must come to an end.
'=== (I wish bad ones did too.)

END

SUB DRAWCAP (x1%, y1%, x2%, y2%, file$)

'=== This is the new DRAWCAP routine posted earlier - Version 2
'=== It saves the given area of screen to a BAS code containing
'=== DRAW statements that recreates the same screen when it's run.

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