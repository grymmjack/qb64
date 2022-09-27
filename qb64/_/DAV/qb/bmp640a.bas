'=============
'BMP-640A.BAS
'=============
' A 640x480, 256 color uncompressed BMP Viewer - VERSION A
' Coded by Dav 
'==========================================================

' NOTE: This views only uncompressed, 640x480, 256 color BMP's.
' The correct BMP format is assumed and NOT checked for.
' A VESA ready video card is required and IS checked for.
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
' Now a quick check the of BMP. This doesn't check format, just sees
' if the file is big enough for a valid BMP, and if ID mark IS there.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

   IF INPUT$(2, 1) <> "BM" OR LOF(1) < 308278 THEN 'Is the BM id there?
     PRINT "Invalid BMP format." 'is it big enough bmp?
     CLOSE : END 'No? close and end.
   END IF

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
' INFO: Qbasic and QB have no built-in support for using VESA modes
' so we must make our own routines. We will make ASM routines
' here and use CALL Absolute to execute them. Three ASM
' routines will be needed. One to check for a VESA ready card,
' one to enter into VESA mode, and another to switch banks.
' If you're using QB, be sure you started with the /L command.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

'=-=-=-=-=-=-=-=-=-=-=- 
' Detect for VESA first! 
'=-=-=-=-=-=-=-=-=-=-=-
                                                     'Make the asm routine
   VesaTest$ = ""
   VesaTest$ = VesaTest$ + CHR$(85) 'push bp
   VesaTest$ = VesaTest$ + CHR$(137) + CHR$(229) 'mov bp, sp
   VesaTest$ = VesaTest$ + CHR$(184) + CHR$(3) + CHR$(79) 'mov ax, 04f03h
   VesaTest$ = VesaTest$ + CHR$(205) + CHR$(16) 'int 10h
   VesaTest$ = VesaTest$ + CHR$(139) + CHR$(94) + CHR$(6) 'mov bx, [bp+06]
   VesaTest$ = VesaTest$ + CHR$(137) + CHR$(7) 'mov [bx], ax
   VesaTest$ = VesaTest$ + CHR$(93) 'pop bp
   VesaTest$ = VesaTest$ + CHR$(202) + CHR$(2) + CHR$(0) 'retf 2

   '=-=-= Now Call the Routine

   DEF SEG = VARSEG(VesaTest$) 'point to routine
      CALL ABSOLUTE(huh%, SADD(VesaTest$)) 'Call vesa routine
   DEF SEG : VesaTest$ = "" 'clear up string

   IF huh% MOD 256 <> 79 THEN 'if no vesa (79)
      PRINT "VESA not found." 'then say so and end.
      CLOSE 1: END
   END IF

'=-=-=-=-=-=-=-=-=-=- 
' Set VESA Mode 101h 
' (640x480, 256 color)
'=-=-=-=-=-=-=-=-=-=- 'Make the routine that
                                   'enters into vesa mode 101h (640x480x8)
   Vesa101h$ = ""
   Vesa101h$ = Vesa101h$ + CHR$(184) + CHR$(2) + CHR$(79) 'mov ax, 4f02h
   Vesa101h$ = Vesa101h$ + CHR$(187) + MKI$(&H101) 'mov bx, 101h
   Vesa101h$ = Vesa101h$ + CHR$(205) + CHR$(16) 'INT 10h
   Vesa101h$ = Vesa101h$ + CHR$(203) 'retf

   '=-=-= Now call the routine...

   DEF SEG = VARSEG(Vesa101h$) 'point to routine
      CALL ABSOLUTE(SADD(Vesa101h$)) 'call routine
   DEF SEG : Vesa101h$ = "" 'clear string

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 'make routine that
'Make the Bank switching routine 'switches banks.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

   Bank$ = ""
   Bank$ = Bank$ + CHR$(85) 'push bp
   Bank$ = Bank$ + CHR$(137) + CHR$(229) 'mov bp, sp
   Bank$ = Bank$ + CHR$(184) + CHR$(5) + CHR$(79) 'mov ax, 4f05h
   Bank$ = Bank$ + CHR$(187) + CHR$(0) + CHR$(0) 'mov bx, 0
   Bank$ = Bank$ + CHR$(139) + CHR$(86) + CHR$(6) 'mov dx, [bp+6]
   Bank$ = Bank$ + CHR$(205) + CHR$(16) 'int 10h 
   Bank$ = Bank$ + CHR$(93) 'pop bp
   Bank$ = Bank$ + CHR$(202) + CHR$(2) + CHR$(0) 'retf 2

'=-=-=-=-=-=-=-=-=-=-=-=
' Now we display the BMP
'=-=-=-=-=-=-=-=-=-=-=-=

   SEEK #1, 55 'skip header to pallette data

   OUT 968, 0
   FOR c% = 1 TO 256 'load & out pallette to screen
     A$ = INPUT$(4, 1)
     OUT 969, ASC(MID$(A$, 3, 1)) \ 4
     OUT 969, ASC(MID$(A$, 2, 1)) \ 4
     OUT 969, ASC(MID$(A$, 1, 1)) \ 4
   NEXT

   DEF SEG = &HA000 'point here for pokeing pixels

   FOR y% = 479 TO 0 STEP -1 'do 480 rows
      A$ = INPUT$(640, 1) 'load a row of 640 pixels.
      FOR x% = 0 TO 639
         Offset& = y% * 640& + x% 'calculate pixel position
         NewBank& = Offset& AND -65536 'check on bank...
         IF NewBank& <> Bank& THEN 'if switching to new one..
            DEF SEG = VARSEG(Bank$) 'point to and call bank routine.
              CALL ABSOLUTE(BYVAL NewBank& \ 65536, SADD(Bank$))
            DEF SEG = &HA000 're-point to here for pokeing
            Bank& = NewBank&
         END IF
         POKE Offset& AND 65535, ASC(MID$(A$, x% + 1, 1)) 'plot pixel
      NEXT
      IF INKEY$ <> "" THEN EXIT FOR 'if key press, stop loading
   NEXT

   CLOSE 1 'close'er up, doc.
  
   A$ = INPUT$(1) 'a pause for the cause
                                          
   SCREEN 7: SCREEN 0: WIDTH 80, 25 'back to normal text screen

   END 'that's all, folks

'=-=-=-=-=-
' END CODE
'=-=-=-=-=-

