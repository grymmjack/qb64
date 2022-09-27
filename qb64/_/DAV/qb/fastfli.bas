'================
'FASTFLI.BAS v1.0
'================
'Updated Qbasic FLI viewer by Dav.
'
'This is an improved FLI player based one the ones found in the
'ABC Archives. Speed is increased by loading pack data at once,
'not byte-by-byte, and by using a popular ASM MemCopy routine.
'
'Below are benchmarks using FASTFLI and 3 other popular FLI players
'to view a large animation on a P-III 300mhz computer. All 4 programs
'were tested un-compiled and no delay routines were used. The FLI used
'is called BRIDGFLY.FLI, size is 5,023,002 bytes, 401 frames.
'
'______________________________________________________________________
'.......... ........... ....... 
'FLIPLAY.BAS by Carl Gorringe.......... 143.62 secs ( 2.79 frames/sec)
'OPENFLIC.BAS by Yousuf Philips (YPI).... 66.35 secs ( 6.04 frames/sec)
'VIEWFLI2.BAS by Denis Boyles............ 57.24 secs ( 7.00 frames/sec)
'FASTFLI.BAS by Dav..................... 23.28 secs (17.22 frames/sec)
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'
'=======================================================================
'I'd like to thank Carl Gorringe, Denis Boyles and Yousuf Philips for
'releasing your FLI players, and William Yu, creator of the ABC packets
'for the great service you've provided programmers other the years.
'And to Buff and Walt for continuing the ABC Archives. Thanks people.
'=======================================================================

DEFINT A-Z
DECLARE SUB PLAYFLI (file$)

'$DYNAMIC

'IF COMMAND$ = "" THEN
   PRINT : INPUT "FLI to play> ", FLI$
   IF FLI$ <> "" THEN PLAYFLI FLI$
'ELSE
' PLAYFLI COMMAND$
'END IF

REM $STATIC
SUB PLAYFLI (file$)

OPEN file$ FOR BINARY AS #1
IF LOF(1) = 0 THEN
   CLOSE 1: KILL file$
   EXIT SUB
END IF

HDR$ = INPUT$(128, 1)
FlicID% = CVI(MID$(HDR$, 5, 2))
frames% = CVI(MID$(HDR$, 7, 2))
FWidth% = CVI(MID$(HDR$, 9, 2))
FHeight% = CVI(MID$(HDR$, 11, 2))
Ticks% = CVI(MID$(HDR$, 17, 2))
HDR$ = ""

IF FlicID% <> &HAF11 OR FWidth% <> 320 THEN
   CLOSE 1: EXIT SUB
END IF

'Make the asm routine
ASM$ = ""
ASM$ = ASM$ + CHR$(85) 'PUSH BP
ASM$ = ASM$ + CHR$(137) + CHR$(229) 'MOV BP, SP
ASM$ = ASM$ + CHR$(30) 'PUSH DS
ASM$ = ASM$ + CHR$(6) 'PUSH ES
ASM$ = ASM$ + CHR$(86) 'PUSH SI
ASM$ = ASM$ + CHR$(87) 'PUSH DI
ASM$ = ASM$ + CHR$(139) + CHR$(70) + CHR$(10) 'MOV AX, [BP+0A]
ASM$ = ASM$ + CHR$(142) + CHR$(192) 'MOV ES, AX
ASM$ = ASM$ + CHR$(139) + CHR$(70) + CHR$(14) 'MOV AX, [BP+0E]
ASM$ = ASM$ + CHR$(142) + CHR$(216) 'MOV DS, AX
ASM$ = ASM$ + CHR$(139) + CHR$(118) + CHR$(12) 'MOV SI, [BP+0C]
ASM$ = ASM$ + CHR$(139) + CHR$(126) + CHR$(8) 'MOV DI, [BP+08]
ASM$ = ASM$ + CHR$(139) + CHR$(78) + CHR$(6) 'MOV CX, [BP+06]
ASM$ = ASM$ + CHR$(243) + CHR$(164) 'REPE MOVSB
ASM$ = ASM$ + CHR$(95) 'POP DI
ASM$ = ASM$ + CHR$(94) 'POP SI
ASM$ = ASM$ + CHR$(7) 'POP ES
ASM$ = ASM$ + CHR$(31) 'POP DS
ASM$ = ASM$ + CHR$(93) 'POP BP
ASM$ = ASM$ + CHR$(202) + CHR$(10) + CHR$(0) 'RETF 10

SCREEN 13

DO 'Main loop begins here
   SEEK 1, 129 'Skip the FLI header
   FOR f% = 1 TO frames% 'Do all frames
     FF& = SEEK(1) 'Save file pointer (frame)
     FRM$ = INPUT$(16, 1) 'Load frame header
     FrameSize& = CVL(MID$(FRM$, 1, 4)) 'Size of this frame
     chunks% = CVI(MID$(FRM$, 7, 2)) 'How many chunks in frame
     d$ = INKEY$: IF d$ <> "" THEN EXIT DO 'Keypress quits playback
     FOR C% = 1 TO chunks% 'Do all chunks
       Fpos& = SEEK(1) 'save file pointer (chunk)
       CD$ = INPUT$(6, 1) 'Get chunk header
       ChunkSize& = CVL(MID$(CD$, 1, 4)) 'Size of chunk
       ChunkType% = CVI(MID$(CD$, 5, 2)) 'Type of chunk
       Fpos& = Fpos& + ChunkSize& 'Calculate new position (frame)
       SELECT CASE ChunkType% 'Do the chunk type
         CASE 11 'Set the palette (64)
           Clr% = 0
           paks% = ASC(INPUT$(2, 1))
           FOR d% = 1 TO paks%
             skip% = ASC(INPUT$(1, 1))
             change% = ASC(INPUT$(1, 1))
             IF change% = 0 THEN change% = 256
             Clr% = Clr% + skip%
             FOR s% = 1 TO change%
               OUT &H3C8, Clr%
               OUT &H3C9, ASC(INPUT$(1, 1))
               OUT &H3C9, ASC(INPUT$(1, 1))
               OUT &H3C9, ASC(INPUT$(1, 1))
               Clr% = Clr% + 1
             NEXT
           NEXT
         CASE 12 'Line Compressed Chunk (LC)
           skip% = CVI(INPUT$(2, 1))
           change% = CVI(INPUT$(2, 1))
           FOR y% = skip% TO change% + (skip% - 1)
             ppos& = SEEK(1) 'Save position (pack)
             C$ = INPUT$(500, 1): m% = 1 'Load all pack data
             paks% = ASC(MID$(C$, m%, 1)): m% = m% + 1: x% = 0
             FOR d% = 1 TO paks%
               s% = ASC(MID$(C$, m%, 1))
               p% = ASC(MID$(C$, m% + 1, 1))
               m% = m% + 2: x% = x% + s%
               IF p% > 127 THEN
                 p% = (256 - p%)
                 LINE (x%, y%)-STEP(p% - 1, 0), ASC(MID$(C$, m%, 1))
                 x% = x% + p%: m% = m% + 1
               ELSE
                 Row$ = MID$(C$, m%, p%)
                 m% = m% + p%
                 GOSUB OUTROW
                 x% = x% + p%
               END IF
             NEXT
           SEEK #1, ppos& + m% - 1: C$ = ""
         NEXT
         CASE 13: CLS 'Clear screen (BLACK)
         CASE 15 'BRUN compressed chunk
           x% = 0
           FOR y% = 0 TO 199
             ppos& = SEEK(1) 'Save position (pack)
             C$ = INPUT$(500, 1): m% = 1 'Load all pack data
             paks% = ASC(MID$(C$, m%, 1)) 'Number of packs in line
             m% = m% + 1 'INC m% for MID$ usage
             FOR d% = 1 TO paks% 'Do all packs
               p% = ASC(MID$(C$, m%, 1)): m% = m% + 1
               IF p% < 128 THEN
                 LINE (x%, y%)-STEP(p% - 1, 0), ASC(MID$(C$, m%, 1))
                 m% = m% + 1
               ELSE
                 p% = (256 - p%)
                 Row$ = MID$(C$, m%, p%)
                 m% = m% + p%
                 GOSUB OUTROW
               END IF
               x% = x% + p%
             NEXT
             x% = 0: SEEK #1, ppos& + m% - 1: C$ = ""
           NEXT
         CASE 16 'Copy raw image
           x% = 0
           FOR y% = 0 TO 199
             Row$ = INPUT$(320, 1): p% = 320
             GOSUB OUTROW
           NEXT
         CASE ELSE: CLOSE 1: EXIT SUB 'Invalid chunks?
       END SELECT
       SEEK #1, Fpos&
     NEXT
     SEEK 1, FF& + FrameSize&
     '=========================================
     'Delay Routine here...Change this to suit
     FOR u% = 1 TO Ticks% * 18
       WAIT &H3DA, 8
     NEXT
     '=========================================
   NEXT
LOOP
CLOSE 1
EXIT SUB

'This routine out's the data to the screen
OUTROW:
    SP = CVI(MID$(MKL$(x% + y% * 320&), 1, 2))
    DEF SEG = VARSEG(ASM$)
    CALL Absolute(BYVAL VARSEG(Row$), BYVAL SADD(Row$), BYVAL &HA000, BYVAL SP, BYVAL p%, SADD(ASM$))
    Row$ = ""
RETURN
END SUB
