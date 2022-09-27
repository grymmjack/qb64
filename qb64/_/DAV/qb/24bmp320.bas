'============
'24BMP320.BAS
'============
'Loads a 24-bit, 320x200 BMP.
'For uncompressed, RGB encoded BMP's only.

'Coded by Dav

'==========================================================
'NOTE: The correct BMP format is assumed and NOT checked.
' I posted this only to give an example of loading 24-bit
' images in an 8-bit screen mode with not-so-bad results.
'==========================================================

DEFINT A-Z

INPUT "24-BIT BMP to view --> ", File$
IF File$ = "" THEN END

OPEN File$ FOR BINARY AS 1
IF LOF(1) = 0 THEN
   CLOSE 1: KILL File$
   PRINT File$; " not found!": END
END IF

'=== Now a quick peek at the BMP.
'=== This doesn't check the format, just sees
'=== if the file is big enough for a valid BMP,
'=== and if ID marker (BM) is there.

IF INPUT$(2, 1) <> "BM" OR LOF(1) < 192054 THEN
   PRINT "Invalid BMP format."
   CLOSE : END
END IF

SCREEN 13

'=== First, set the pallette.
'=== This tries to emulate 24-bit using
'=== into 256 well-represented colors.
'=== Most 24-bit images look OK with this.

clr% = 0
FOR red% = 0 TO 63 STEP 9
  FOR grn% = 0 TO 63 STEP 9
   FOR blu% = 0 TO 63 STEP 21
     OUT &H3C8, clr%
     OUT &H3C9, red%
     OUT &H3C9, grn%
     OUT &H3C9, blu%
     clr% = clr% + 1
   NEXT
  NEXT
NEXT

'=== Skip header - go directly to the data.

SEEK 1, 55

'=== Now display the image data.
'=== BMP's are saved upside down, so
'=== we start at the bottom row first.

FOR y% = 199 TO 0 STEP -1
  
   '=== Grab data in rows for speed.
   '=== There's 320 pixels a row, and there's
   '=== 3 bytes per pixel - that makes it 320 * 3
  
   Row$ = INPUT$(320 * 3, 1)
  
   '=== Plot the row of pixels...
  
   FOR x% = 0 TO 319
     blu% = ASC(MID$(Row$, 3 * x% + 1, 1)) \ 64
     grn% = ASC(MID$(Row$, 3 * x% + 2, 1)) \ 32
     red% = ASC(MID$(Row$, 3 * x% + 3, 1)) \ 32
     clr% = red% * 32 + grn% * 4 + blu%
     PSET (x%, y%), clr%
   NEXT
NEXT

CLOSE 1

Pause$ = INPUT$(1)

END