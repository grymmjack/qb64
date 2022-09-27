'=============
' BMP320A.BAS
'=============
' A Tiny 320x200, 256 color uncompressed BMP Viewer - VERSION A
' Coded by Dav
'==============================================================

' NOTE: This views only uncompressed, 320x200, 256 color BMP's.
' The correct BMP format is assumed and NOT checked for.
'

DEFINT A-Z

'=-=-=-=-=-=-=-=-=-=-
' Ask user for the BMP
'=-=-=-=-=-=-=-=-=-=-

   INPUT "BMP to view> ", BMP$ 'get the file name
   IF BMP$ = "" THEN END 'if none given, end

   OPEN BMP$ FOR BINARY AS #1 'open up the file

   IF LOF(1) = 0 THEN 'if it was just created
     PRINT UCASE$(BMP$); " not found." 'say that it wasn't there,
     CLOSE 1: KILL BMP$: END 'close it, kill it, end.
   END IF

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
' Now a quick check the of BMP. This just checks for the ID marker.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

   IF INPUT$(2, 1) <> "BM" THEN 'Is the BM id there?
     PRINT "Not a BMP." 'is it big enough bmp?
     CLOSE : END 'No? close and end.
   END IF

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
' Set screen and Load Pallette
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

   SCREEN 13: SEEK 1, 55: OUT 968, 0
   FOR c% = 1 TO 256: B$ = INPUT$(4, 1)
      OUT 969, ASC(MID$(B$, 3, 1)) \ 4
      OUT 969, ASC(MID$(B$, 2, 1)) \ 4
      OUT 969, ASC(MID$(B$, 1, 1)) \ 4
   NEXT

'===============================
'Load the image Data, row by row
'===============================

   FOR y% = 199 TO 0 STEP -1
     B$ = INPUT$(320, 1)
     FOR x% = 0 TO 319
       PSET (x%, y%), ASC(MID$(B$, x% + 1, 1))
     NEXT
   NEXT

   CLOSE 1

   SLEEP

'=-=-=-=-=
' END CODE
'=-=-=-=-=

