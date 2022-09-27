'===========
'QB64FLI.BAS
'QB64 FLI viewer
'for Qbasic too!
'Coded by Dav 2008
'=================

DEFINT A-Z
DECLARE SUB PLAYFLI (file$)

PRINT
INPUT " FLI to play> ", FLI$
IF FLI$ <> "" THEN PLAYFLI FLI$

END

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
                 FOR g% = 0 TO p% - 1
                    PSET (x% + g%, y%), ASC(MID$(Row$, g% + 1, 1))
                 NEXT
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
                 FOR g% = 0 TO p% - 1
                    PSET (x% + g%, y%), ASC(MID$(Row$, g% + 1, 1))
                 NEXT
               END IF
               x% = x% + p%
             NEXT
             x% = 0: SEEK #1, ppos& + m% - 1: C$ = ""
           NEXT
         CASE 16 'Copy raw image
           x% = 0
           FOR y% = 0 TO 199
             Row$ = INPUT$(320, 1): p% = 320
             FOR g% = 0 TO p% - 1
                PSET (x% + g%, y%), ASC(MID$(Row$, g% + 1, 1))
             NEXT
           NEXT
         CASE ELSE: CLOSE 1: EXIT SUB 'Invalid chunks?
       END SELECT
       SEEK #1, Fpos&
     NEXT
     SEEK 1, FF& + FrameSize&

     'Delay Routine ... 
     FOR u% = 1 TO Ticks%
       WAIT &H3DA, 8
       WAIT &H3DA, 8, 8
     NEXT

   NEXT
LOOP

CLOSE 1

END SUB
