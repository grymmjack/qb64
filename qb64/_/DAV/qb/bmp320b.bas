'=============
' BMP-320B.BAS
'=============
' A FAST 320x200, 256 color uncompressed BMP Viewer - VERSION B
' Coded by Dav
'==============================================================

' NOTE: This views only uncompressed, 320x200, 256 color BMP's.
' The correct BMP format is assumed and NOT checked for.
'
' QuickBasic users should start QB like: QB /L /AH

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
' Make the ASM MemCopy routine.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  
   Mem$ = ""
   Mem$ = Mem$ + CHR$(85) 'push bp
   Mem$ = Mem$ + CHR$(137) + CHR$(229) 'mov bp, sp
   Mem$ = Mem$ + CHR$(30) 'push ds
   Mem$ = Mem$ + CHR$(6) 'push es
   Mem$ = Mem$ + CHR$(86) 'push si
   Mem$ = Mem$ + CHR$(87) 'push di
   Mem$ = Mem$ + CHR$(139) + CHR$(70) + CHR$(10) 'mov ax, [BP+0A]
   Mem$ = Mem$ + CHR$(142) + CHR$(192) 'mov es, ax
   Mem$ = Mem$ + CHR$(139) + CHR$(70) + CHR$(14) 'mov ax, [BP+0E]
   Mem$ = Mem$ + CHR$(142) + CHR$(216) 'mov ds, ax
   Mem$ = Mem$ + CHR$(139) + CHR$(118) + CHR$(12) 'mov si, [BP+0C]
   Mem$ = Mem$ + CHR$(139) + CHR$(126) + CHR$(8) 'mov di, [BP+08]
   Mem$ = Mem$ + CHR$(139) + CHR$(78) + CHR$(6) 'mov cx, [BP+06]
   Mem$ = Mem$ + CHR$(243) + CHR$(164) 'repe movsb
   Mem$ = Mem$ + CHR$(95) 'pop di
   Mem$ = Mem$ + CHR$(94) 'pop si
   Mem$ = Mem$ + CHR$(7) 'pop es
   Mem$ = Mem$ + CHR$(31) 'pop ds
   Mem$ = Mem$ + CHR$(93) 'pop bp
   Mem$ = Mem$ + CHR$(202) + CHR$(10) + CHR$(0) 'retf 10

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
' Set screen and Load Pallette
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

SCREEN 13: SEEK 1, 55: OUT 968, 0
FOR c% = 1 TO 256: B$ = INPUT$(4, 1)
   OUT 969, ASC(MID$(B$, 3, 1)) \ 4
   OUT 969, ASC(MID$(B$, 2, 1)) \ 4
   OUT 969, ASC(MID$(B$, 1, 1)) \ 4
NEXT

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
' Now load the BMP rows, and MemCopy them to screen.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

   DIM ROW(200) AS STRING * 320 'Make Room for 200 rows of 320 pixels.

   FOR Y = 199 TO 0 STEP -1 'Get all the rows into ROW array...
     GET #1, , ROW(Y)
   NEXT
                                   'Now call the routine...
   DEF SEG = VARSEG(Mem$)
     CALL Absolute(BYVAL VARSEG(ROW(0)), BYVAL VARPTR(ROW(0)), BYVAL &HA000, BYVAL 0, BYVAL &HFA00, SADD(Mem$))
   DEF SEG

   CLOSE 1

   SLEEP

'=-=-=-=-=
' END CODE
'=-=-=-=-=

