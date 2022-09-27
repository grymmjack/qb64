'==================
' PCX640.BAS v1.0
'==================
' Coded by Dav
' Views a 640x480x256 PCX image under Qbasic/QB45
'
' This is a PCX viewer. It's made in QBasic but it works with QB too.
' It'll view 640x480, 256 color PCX images in 101h VESA mode, and uses
' several ASM routines to accomplish this. There's one to detect VESA
' extensions, one that sets the VESA screen mode of 101h (640x480x256),
' and a third one for the bank switching necessary for plotting pixels
' in 101h screen mode.
'
' This viewer accepts Version 5 PCX, 256 color images only. And you
' you got to have a VESA ready video card. You probably do. If you
' don't, the program won't work unless you load a VESA driver first.
'
' NOTE: QuickBasic users have to start QB like: QB /L /AH
'=====================================================================

DEFINT A-Z
DECLARE SUB ViewPCX (file$)

'=== Put your own PCX filename below.

ViewPCX "dream.pcx"

END

SUB ViewPCX (file$)

'=== Open file

PCX = FREEFILE
OPEN file$ FOR BINARY AS PCX

'=== Quick check of PCX Format

IF ASC(INPUT$(1, PCX)) <> 10 THEN CLOSE PCX: EXIT SUB
IF ASC(INPUT$(1, PCX)) <> 5 THEN CLOSE PCX: EXIT SUB
IF ASC(INPUT$(1, PCX)) <> 1 THEN CLOSE PCX: EXIT SUB

'=== Check if < 256 colors

IF ASC(INPUT$(1, PCX)) > 8 THEN CLOSE PCX: EXIT SUB

'=== Get PCX size

MinX% = CVI(INPUT$(2, PCX))
MinY% = CVI(INPUT$(2, PCX))
MaxX% = CVI(INPUT$(2, PCX))
MaxY% = CVI(INPUT$(2, PCX))

TotalX% = MaxX% + 1: IF TotalX% > 640 THEN TotalX% = 640
TotalY% = MaxY% + 1: IF TotalY% > 480 THEN TotalY% = 480

ViewPortY% = TotalY%

'=== Detect for VESA capable Video Card first! 
  
VesaTest$ = ""
VesaTest$ = VesaTest$ + CHR$(85) 'push bp
VesaTest$ = VesaTest$ + CHR$(137) + CHR$(229) 'mov bp, sp
VesaTest$ = VesaTest$ + CHR$(184) + CHR$(3) + CHR$(79) 'mov ax, 04f03h
VesaTest$ = VesaTest$ + CHR$(205) + CHR$(16) 'int 10h
VesaTest$ = VesaTest$ + CHR$(139) + CHR$(94) + CHR$(6) 'mov bx, [bp+06]
VesaTest$ = VesaTest$ + CHR$(137) + CHR$(7) 'mov [bx], ax
VesaTest$ = VesaTest$ + CHR$(93) 'pop bp
VesaTest$ = VesaTest$ + CHR$(202) + CHR$(2) + CHR$(0) 'retf 2

DEF SEG = VARSEG(VesaTest$)
    CALL ABSOLUTE(huh%, SADD(VesaTest$))
DEF SEG : VesaTest$ = ""
  
IF huh% MOD 256 <> 79 THEN
    'PRINT "VESA not found." 'STOP if no VESA extensions found!
    CLOSE PCX: EXIT SUB
END IF

'=== Set Vesa Mode 101h (640x480, 256 color)

Vesa101h$ = ""
Vesa101h$ = Vesa101h$ + CHR$(184) + CHR$(2) + CHR$(79) 'mov ax, 4f02h
Vesa101h$ = Vesa101h$ + CHR$(187) + MKI$(&H101) 'mov bx, 101h
Vesa101h$ = Vesa101h$ + CHR$(205) + CHR$(16) 'INT 10h
Vesa101h$ = Vesa101h$ + CHR$(203) 'retf
  
DEF SEG = VARSEG(Vesa101h$) 'point to routine
    CALL ABSOLUTE(SADD(Vesa101h$)) 'call routine
DEF SEG : Vesa101h$ = "" 'clear string
     
'=== Make the Bank switching routine.
     
Bank$ = ""
Bank$ = Bank$ + CHR$(85) 'push bp
Bank$ = Bank$ + CHR$(137) + CHR$(229) 'mov bp, sp
Bank$ = Bank$ + CHR$(184) + CHR$(5) + CHR$(79) 'mov ax, 4f05h
Bank$ = Bank$ + CHR$(187) + CHR$(0) + CHR$(0) 'mov bx, 0
Bank$ = Bank$ + CHR$(139) + CHR$(86) + CHR$(6) 'mov dx, [bp+6]
Bank$ = Bank$ + CHR$(205) + CHR$(16) 'int 10h
Bank$ = Bank$ + CHR$(93) 'pop bp
Bank$ = Bank$ + CHR$(202) + CHR$(2) + CHR$(0) 'retf 2

'=== Now Display the PCX....
  
DEF SEG = &HA000 'Using POKE, not PSET, so we got to have this

'=== Load the Pallette
  
SEEK PCX, LOF(PCX) - 767 'Skip to Pallette Data
Pal$ = INPUT$(768, PCX) 'Load it up

OUT 968, 0 'Prepare..
FOR I% = 1 TO LEN(Pal$)
    OUT 969, ASC(MID$(Pal$, I%, 1)) \ 4 'OUT it goes...
NEXT

'=== Load the Image Data
  
SEEK PCX, 129
  
x% = MinX%: y% = MinY%

'=================================================================
' NOTE: It's faster loading data in Chunks of bytes, instead of
' one byte at a time. So, we'll grab'em to Chunk$ string, and use
' MID$ to get to each byte in the string. The variable m% will be
' used as the byte pointer - that is, what byte position in the
' Chunk$ we're at. We'll start at the 1'st byte, so m% = 1.
'=================================================================
  
Chunk$ = SPACE$(5000) 'make room for 5000 bytes
  
GET PCX, , Chunk$: m% = 1 'Grab it.

'=== Now display the PCX image...finally!
  
DO
    a$ = MID$(Chunk$, m%, 1): m% = m% + 1 'get a byte, increase m%
    IF m% > 5000 THEN 'if we're at end of Chunk$,
       GET PCX, , Chunk$: m% = 1 'grab more, reset m%
    END IF
   
    IF INKEY$ <> "" THEN EXIT DO 'if a keypress, stop it all.
    IF (ASC(a$) AND &HC0) = &HC0 THEN
       Count% = ASC(a$) AND &H3F
       a$ = MID$(Chunk$, m%, 1): m% = m% + 1 'get a byte, increase m%
       IF m% > 5000 THEN 'if we're at end of Chunk$,
          GET PCX, , Chunk$: m% = 1 'grab more, reset m%
       END IF
       FOR I% = Count% TO 1 STEP -1 'do the pixels.
          Offset& = y% * 640& + x% 'calculate position.
          NewBank& = Offset& AND -65536 'check bank.
          IF NewBank& <> Bank& THEN 'time for a new bank?
             DEF SEG = VARSEG(Bank$) 'switch it.
                CALL ABSOLUTE(BYVAL NewBank& \ 65536, SADD(Bank$))
             DEF SEG = &HA000
             Bank& = NewBank&
          END IF
          POKE Offset& AND 65535, ASC(a$) 'plot the pixel.
          x% = x% + 1
          IF x% = MaxX% + 1 THEN x% = 0: y% = y% + 1
       NEXT
    ELSE
       Offset& = y% * 640& + x% 'same stuff here...
       NewBank& = Offset& AND -65536
       IF NewBank& <> Bank& THEN
          DEF SEG = VARSEG(Bank$)
             CALL ABSOLUTE(BYVAL NewBank& \ 65536, SADD(Bank$))
          DEF SEG = &HA000
          Bank& = NewBank&
       END IF
       POKE Offset& AND 65535, ASC(a$)
       x% = x% + 1
       IF x% = MaxX% + 1 THEN x% = 0: y% = y% + 1
    END IF
    IF y% >= MaxY% THEN EXIT DO
    IF y% > ViewPortY% THEN EXIT DO
LOOP UNTIL EOF(PCX)

'=== Close the file.

CLOSE PCX: DEF SEG

'=== Pause for the cause

WHILE INKEY$ = "": WEND

'=== Reset screen mode...

'==================================================================
' NOTE: Giving SCREEN 7 first is important because SCREEN 0 doesn't
' always reset correctly from Vesa modes -- so don't remove it.
'==================================================================

SCREEN 7: SCREEN 0: WIDTH 80, 25 'back to normal text screen

END SUB
