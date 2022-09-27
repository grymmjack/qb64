'============
'24BMP640.BAS
'============
'A 24-bit, 640x480 BMP Viewer.
'Coded by Dav 
'=========================================================
'NOTE: Views only uncompressed, 640x480, 24-bit BMP's.
' The correct BMP format is assumed and NOT checked for.
' A VESA ready video card is required and IS checked for.
' QuickBasic users should start QB like: QB /L /AH
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
  
IF INPUT$(2, 1) <> "BM" OR LOF(1) < 921654 THEN
   PRINT "Invalid BMP format."
   CLOSE : END
END IF

'==============================================================
'INFO: Qbasic and QB have no built-in support for using VESA,
' so we must make our own routines. We will make ASM routines
' here and use CALL Absolute to execute them. Three ASM
' routines will be needed. One to check for a VESA ready card,
' and one to enter into VESA mode, and another to switch banks.
' If you're using QB, be sure you started with the /L command.
'==============================================================

'=== Detect for VESA first! 

VesaTest$ = ""
VesaTest$ = VesaTest$ + CHR$(85) 'push bp
VesaTest$ = VesaTest$ + CHR$(137) + CHR$(229) 'mov bp, sp
VesaTest$ = VesaTest$ + CHR$(184) + CHR$(3) + CHR$(79) 'mov ax, 04f03h
VesaTest$ = VesaTest$ + CHR$(205) + CHR$(16) 'int 10h
VesaTest$ = VesaTest$ + CHR$(139) + CHR$(94) + CHR$(6) 'mov bx, [bp+06]
VesaTest$ = VesaTest$ + CHR$(137) + CHR$(7) 'mov [bx], ax
VesaTest$ = VesaTest$ + CHR$(93) 'pop bp
VesaTest$ = VesaTest$ + CHR$(202) + CHR$(2) + CHR$(0) 'retf 2

'=== Now Call the Routine

DEF SEG = VARSEG(VesaTest$)
   CALL ABSOLUTE(huh%, SADD(VesaTest$))
DEF SEG : VesaTest$ = ""

IF huh% MOD 256 <> 79 THEN
   PRINT "VESA not found."
   CLOSE 1: END
END IF

'=== Set VESA Mode 101h (640x480, 256 color)

Vesa101h$ = ""
Vesa101h$ = Vesa101h$ + CHR$(184) + CHR$(2) + CHR$(79) 'mov ax, 4f02h
Vesa101h$ = Vesa101h$ + CHR$(187) + MKI$(&H101) 'mov bx, 101h
Vesa101h$ = Vesa101h$ + CHR$(205) + CHR$(16) 'INT 10h
Vesa101h$ = Vesa101h$ + CHR$(203) 'retf

'=== Now call the routine...

DEF SEG = VARSEG(Vesa101h$)
   CALL ABSOLUTE(SADD(Vesa101h$))
DEF SEG : Vesa101h$ = ""

'=== Make the Bank switching routine 

Bank$ = ""
Bank$ = Bank$ + CHR$(85) 'push bp
Bank$ = Bank$ + CHR$(137) + CHR$(229) 'mov bp, sp
Bank$ = Bank$ + CHR$(184) + CHR$(5) + CHR$(79) 'mov ax, 4f05h
Bank$ = Bank$ + CHR$(187) + CHR$(0) + CHR$(0) 'mov bx, 0
Bank$ = Bank$ + CHR$(139) + CHR$(86) + CHR$(6) 'mov dx, [bp+6]
Bank$ = Bank$ + CHR$(205) + CHR$(16) 'int 10h 
Bank$ = Bank$ + CHR$(93) 'pop bp
Bank$ = Bank$ + CHR$(202) + CHR$(2) + CHR$(0) 'retf 2

'== Now, make a 3-2-2 pallette.
'== This tries to stuff 16-mill colors
'== into 256 well-represented colors.
'== Most images look well with this.

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

'==== Skip header to image data, and display it

SEEK #1, 55

DEF SEG = &HA000
  
FOR y% = 479 TO 0 STEP -1
   A$ = INPUT$(640 * 3, 1)
   FOR x% = 0 TO 639
     Offset& = y% * 640& + x%
     NewBank& = Offset& AND -65536
     IF NewBank& <> Bank& THEN
        DEF SEG = VARSEG(Bank$)
        CALL ABSOLUTE(BYVAL NewBank& \ 65536, SADD(Bank$))
        DEF SEG = &HA000
        Bank& = NewBank&
     END IF
     blu% = ASC(MID$(A$, 3 * x% + 1, 1)) \ 64
     grn% = ASC(MID$(A$, 3 * x% + 2, 1)) \ 32
     red% = ASC(MID$(A$, 3 * x% + 3, 1)) \ 32
     clr% = red% * 32 + grn% * 4 + blu%
     POKE Offset& AND 65535, clr%
   NEXT
   IF INKEY$ <> "" THEN EXIT FOR
NEXT

CLOSE 1
  
Pause$ = INPUT$(1)
                                          
SCREEN 7: SCREEN 0: WIDTH 80, 25

END
