'============
'4BMP640.BAS
'============
'A 16 color, 640x480 BMP Viewer for Qbasic.
'Coded by Dav 

'=========================================================
'NOTE: Views only uncompressed, 640x480, 16 color BMP's.
' The correct BMP format is assumed and NOT checked for.
'=========================================================

DEFINT A-Z

'=== Ask user for the BMP

INPUT "BMP to view> ", BMP$
  IF BMP$ = "" THEN END

OPEN BMP$ FOR BINARY AS #1

' === Check for file..

IF LOF(1) = 0 THEN
   PRINT UCASE$(BMP$); " not found."
   CLOSE 1: KILL BMP$: END
END IF

' === Now a quick check the of BMP. This doesn't check format, it sees
' === if the file is big enough for a valid BMP, and if ID mark IS there.

IF INPUT$(2, 1) <> "BM" OR LOF(1) < 153718 THEN
   PRINT "Invalid BMP format."
   CLOSE : END
END IF

'=== Set the screen mode for a 640x480, 16 color BMP

SCREEN 12

'=== Skip header, go to pallette data

SEEK 1, 55

'=== Load Pallette

Pal$ = INPUT$(64, 1) '4 * 16
OUT &H3C8, 0
FOR x% = 1 TO LEN(Pal$) STEP 4
   OUT &H3C9, ASC(MID$(Pal$, x% + 2, 1)) \ 4
   OUT &H3C9, ASC(MID$(Pal$, x% + 1, 1)) \ 4
   OUT &H3C9, ASC(MID$(Pal$, x%, 1)) \ 4
NEXT

'=== Plot rows, pixel by pixel.

FOR y% = 479 TO 0 STEP -1
    Row$ = INPUT$(320, 1)
    FOR x% = 0 TO 639 STEP 2
      clr% = ASC(MID$(Row$, x% \ 2 + 1, 1))
      PSET (x%, y%), (clr% AND 240) \ 16
      PSET (x% + 1, y%), clr% AND 15
    NEXT
NEXT

CLOSE 1

A$ = INPUT$(1)

END
