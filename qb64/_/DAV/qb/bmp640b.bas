'=============
' BMP-640B.BAS
'=============
'
' Coded by Dav
'
' A *FAST* Qbasic 640x480, 256 color BMP Viewer by Dav
' Uses ASM routines to set video, switch banks and copy data.
' THIS PROGRAM WILL LOAD A 640x480, 256 COLOR BMP INSTANTLY!
'
'=============================================================
' NOTE:  This views only uncompressed, 640x480, 256 color BMP's.
'        The correct BMP format is assumed and NOT checked for.
'        A VESA ready video card is required and IS checked for.
'
'        QuickBasic users should start QB like:  QB /L /AH
'==============================================================
DEFINT A-Z

'=-=-=-=-=-=-=-=-=-=-
' Ask user for the BMP
'=-=-=-=-=-=-=-=-=-=-

  INPUT "BMP to view> ", BMP$               'get the file name

  IF BMP$ = "" THEN END                     'if none given, end

  OPEN BMP$ FOR BINARY AS #1                'open up the file

  IF LOF(1) = 0 THEN                        'if it was just created
    PRINT UCASE$(BMP$); " not found."       'say that it wasn't there,
    CLOSE 1: KILL BMP$: END                 'close it, kill it, end.
  END IF

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
' Now a quick check the of BMP.  This doesn't check format, just sees
' if the file is big enough for a valid BMP, and if ID mark IS there.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

  IF INPUT$(2, 1) <> "BM" OR LOF(1) < 308278 THEN   'Is the BM id there?
    PRINT "Invalid BMP format."                     'is it big enough bmp?
    CLOSE : END                                     'No?  close and end.
  END IF

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
' INFO:  Qbasic and QB have no built-in support for using VESA modes
'        so we must make our own routines. We will make ASM routines
'        here and use CALL Absolute to execute them.  Ok, four ASM
'        routines will be needed.  One to check for a VESA ready card,
'        one to enter into VESA mode, another to switch banks, and
'        the MemCopy routine that shoves the pixel data all at once
'        to the video memory, thus making this a super FAST viewer.
'        If you're using QB, be sure you started with the /L command.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

'=-=-=-=-=-=-=-=-=-=-=-             
' Detect for VESA first!          
'=-=-=-=-=-=-=-=-=-=-=-
                                                    'Make the asm routine
  VesaTest$ = ""
  VesaTest$ = VesaTest$ + CHR$(85)                         'push   bp
  VesaTest$ = VesaTest$ + CHR$(137) + CHR$(229)            'mov    bp, sp
  VesaTest$ = VesaTest$ + CHR$(184) + CHR$(3) + CHR$(79)   'mov    ax, 04f03h
  VesaTest$ = VesaTest$ + CHR$(205) + CHR$(16)             'int    10h
  VesaTest$ = VesaTest$ + CHR$(139) + CHR$(94) + CHR$(6)   'mov    bx, [bp+06]
  VesaTest$ = VesaTest$ + CHR$(137) + CHR$(7)              'mov    [bx], ax
  VesaTest$ = VesaTest$ + CHR$(93)                         'pop    bp
  VesaTest$ = VesaTest$ + CHR$(202) + CHR$(2) + CHR$(0)    'retf   2

  '=-=-= Now Call the Routine

  DEF SEG = VARSEG(VesaTest$)                         'point to routine
     CALL ABSOLUTE(huh%, SADD(VesaTest$))             'Call vesa routine
  DEF SEG : VesaTest$ = ""                            'clear up string

  IF huh% MOD 256 <> 79 THEN                          'if no vesa (79)
     PRINT "VESA not found."                          'then say so and end.
     CLOSE 1: END
  END IF

'=-=-=-=-=-=-=-=-=-=-        
' Set VESA Mode  101h      
' (640x480, 256 color)
'=-=-=-=-=-=-=-=-=-=-             'Make the routine that
                                  'enters into vesa mode 101h (640x480x8)
  Vesa101h$ = ""
  Vesa101h$ = Vesa101h$ + CHR$(184) + CHR$(2) + CHR$(79)    'mov   ax, 4f02h
  Vesa101h$ = Vesa101h$ + CHR$(187) + MKI$(&H101)           'mov   bx, 101h
  Vesa101h$ = Vesa101h$ + CHR$(205) + CHR$(16)              'INT   10h
  Vesa101h$ = Vesa101h$ + CHR$(203)                         'retf

  '=-=-= Now call the routine...

  DEF SEG = VARSEG(Vesa101h$)                    'point to routine
     CALL ABSOLUTE(SADD(Vesa101h$))              'call routine
  DEF SEG : Vesa101h$ = ""                       'clear string

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-              'make routine that
'Make the Bank switching routine               'switches banks.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

  Bank$ = ""
  Bank$ = Bank$ + CHR$(85)                            'push  bp
  Bank$ = Bank$ + CHR$(137) + CHR$(229)               'mov   bp, sp
  Bank$ = Bank$ + CHR$(184) + CHR$(5) + CHR$(79)      'mov   ax, 4f05h
  Bank$ = Bank$ + CHR$(187) + CHR$(0) + CHR$(0)       'mov   bx, 0
  Bank$ = Bank$ + CHR$(139) + CHR$(86) + CHR$(6)      'mov   dx, [bp+6]
  Bank$ = Bank$ + CHR$(205) + CHR$(16)                'int   10h
  Bank$ = Bank$ + CHR$(93)                            'pop   bp
  Bank$ = Bank$ + CHR$(202) + CHR$(2) + CHR$(0)       'retf  2

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-       'make the routine that
'Make the MemCopy routine               'gives this viewer SPEED!
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

  Mem$ = ""
  Mem$ = Mem$ + CHR$(85)                           'push   bp
  Mem$ = Mem$ + CHR$(137) + CHR$(229)              'mov    bp, sp
  Mem$ = Mem$ + CHR$(30)                           'push   ds
  Mem$ = Mem$ + CHR$(6)                            'push   es
  Mem$ = Mem$ + CHR$(86)                           'push   si
  Mem$ = Mem$ + CHR$(87)                           'push   di
  Mem$ = Mem$ + CHR$(139) + CHR$(70) + CHR$(10)    'mov    ax, [BP+0A]
  Mem$ = Mem$ + CHR$(142) + CHR$(192)              'mov    es, ax
  Mem$ = Mem$ + CHR$(139) + CHR$(70) + CHR$(14)    'mov    ax, [BP+0E]
  Mem$ = Mem$ + CHR$(142) + CHR$(216)              'mov    ds, ax
  Mem$ = Mem$ + CHR$(139) + CHR$(118) + CHR$(12)   'mov    si, [BP+0C]
  Mem$ = Mem$ + CHR$(139) + CHR$(126) + CHR$(8)    'mov    di, [BP+08]
  Mem$ = Mem$ + CHR$(139) + CHR$(78) + CHR$(6)     'mov    cx, [BP+06]
  Mem$ = Mem$ + CHR$(243) + CHR$(164)              'repe   movsb
  Mem$ = Mem$ + CHR$(95)                           'pop    di
  Mem$ = Mem$ + CHR$(94)                           'pop    si
  Mem$ = Mem$ + CHR$(7)                            'pop    es
  Mem$ = Mem$ + CHR$(31)                           'pop    ds
  Mem$ = Mem$ + CHR$(93)                           'pop    bp
  Mem$ = Mem$ + CHR$(202) + CHR$(10) + CHR$(0)     'retf   10

'=-=-=-=-=-=-=-=-=-=-=-=
' Now we display the BMP
'=-=-=-=-=-=-=-=-=-=-=-=

  SEEK #1, 55                            'skip header to pallette data

  OUT 968, 0
  FOR c% = 1 TO 256                      'load & out pallette to screen
    A$ = INPUT$(4, 1)
    OUT 969, ASC(MID$(A$, 3, 1)) \ 4
    OUT 969, ASC(MID$(A$, 2, 1)) \ 4
    OUT 969, ASC(MID$(A$, 1, 1)) \ 4
  NEXT

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
' INFO:  Hmm..how do I explain this?  This is coded by "brute force".
'        It's hard coded just for this screen mode and 640x480 BMP size.
'        The 101h video mode is broken up into 5 banks (or screen areas).
'        There are five banks making up the screen - numbered 0 to 4.
'        Because BMP's are saved upsided down (first loaded row goes on
'        the bottom of the screen, etc.) we start at the bottom banks.
'        But, BMP rows are 640 pixels wide, and we have to "chop" them
'        up to MemCopy them to the right banks.  I worked this out the
'        hard way.  I'll just let you study my notes below about what
'        pixel position to switch banks.  The BMP format is a real pain.
'        Remember now, this is only for a 640x480 size BMP.
'= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
'  (Bank)                              (pixels in bank)
'                                          
'--------------------------
'BANK 0                                     |64000
'                             65536         |+1280
'               ...........             
'    256       /     384                    |64000
'-------------'               65536         | +640
'BANK 1                                 
'                    .........          
'   512             /   128                 |64000
'------------------'          65536         |+1280
'BANK 2                                 
'            .................
'   128     /           512                 |64000
'----------'                                | +640
'BANK 3                       65536
'                 ............
'    384         /     256                  |44800      (70 * 640)
'---------------'
'BANK 4                       45056
'
'-----------------------------------------------------

'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
' I know, that made no sense, did it?  Hey, I'm learning.  Ok?
' So let's just continue and you'll see what I was thinking.
'=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

'========================
'BANK 4      
'=======

   'Switch to bank 4
   DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 4, SADD(Bank$))

   'Do 70 rows of 640  (44800 bytes)
   REDIM row(69) AS STRING * 640
   DL& = 0
   Sp& = 45056               'Start position -- bottom of bank
   FOR y% = 69 TO 0 STEP -1
      GET #1, , row(y%)
      DL& = DL& + 640
      Sp& = Sp& - 640
   NEXT
   Length = CVI(MID$(MKL$(DL&), 1, 2))     'make values CALL will take
   Startpos = CVI(MID$(MKL$(Sp&), 1, 2))
   DEF SEG = VARSEG(Mem$)
   CALL ABSOLUTE(BYVAL VARSEG(row(0)), BYVAL VARPTR(row(0)), BYVAL &HA000, BYVAL Startpos, BYVAL Length, SADD(Mem$))
   ERASE row
    
   'That did 70 rows (409 to 479).
   'The next row is broken up in two banks, 3 and 4.
  
   'Do first 384 bytes in bank 3 (bottom)
   DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 3, SADD(Bank$))
   A$ = INPUT$(384, 1)
   Startpos = CVI(MID$(MKL$(65536 - 384), 1, 2))    'bottom of bank
   DEF SEG = VARSEG(Mem$)
   CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL Startpos, BYVAL LEN(A$), SADD(Mem$))
     
   'Do last 256 bytes in bank 4  (top)
   DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 4, SADD(Bank$))
   A$ = INPUT$(256, 1)
   DEF SEG = VARSEG(Mem$)
   CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL 0, BYVAL LEN(A$), SADD(Mem$))
 
'=====================
'BANK 3
'=======
     
      'Switch to bank 3
      DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 3, SADD(Bank$))

      'Do 64640 bytes  (101 rows of 640 bytes)
      REDIM row(100) AS STRING * 640            'Make room
      DL& = 0
      Sp& = 65536 - 384
      FOR y% = 100 TO 0 STEP -1                 'Do all 70
         GET #1, , row(y%)
         DL& = DL& + 640                       'add 640 per row
         Sp& = Sp& - 640
      NEXT
      Length = CVI(MID$(MKL$(DL&), 1, 2))     'make a value CALL will take
      Startpos = CVI(MID$(MKL$(Sp&), 1, 2))
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(row(0)), BYVAL VARPTR(row(0)), BYVAL &HA000, BYVAL Startpos, BYVAL Length, SADD(Mem$))
      ERASE row

      'Now the next line in borken in banks 2 and 3
   'Do first 128 bytes in bank 2 (bottom)
   DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 2, SADD(Bank$))
   A$ = INPUT$(128, 1)
   Startpos = CVI(MID$(MKL$(65536 - 128), 1, 2))    'bottom of bank
   DEF SEG = VARSEG(Mem$)
   CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL Startpos, BYVAL LEN(A$), SADD(Mem$))
   'Do 512 bytes in bank 3 top
   DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 3, SADD(Bank$))
   A$ = INPUT$(512, 1)
   DEF SEG = VARSEG(Mem$)
   CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL 0, BYVAL LEN(A$), SADD(Mem$))
     
'=============================
'BANK 2
'=======
     
      'Switch to bank 2
      DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 2, SADD(Bank$))

      'Do 64640 bytes  (101 rows of 640 bytes)
      REDIM row(100) AS STRING * 640            'Make room
      DL& = 0
      Sp& = 65536 - 128
      FOR y% = 100 TO 0 STEP -1                 'Do all 70
         GET #1, , row(y%)
         DL& = DL& + 640                       'add 640 per row
         Sp& = Sp& - 640
      NEXT
      Length = CVI(MID$(MKL$(DL&), 1, 2))     'make a value CALL will take
      Startpos = CVI(MID$(MKL$(Sp&), 1, 2))
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(row(0)), BYVAL VARPTR(row(0)), BYVAL &HA000, BYVAL Startpos, BYVAL Length, SADD(Mem$))
      ERASE row

      'Do another row
      A$ = INPUT$(640, 1)
      Startpos = 128
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL Startpos, BYVAL LEN(A$), SADD(Mem$))

      'Next line is broker in bank 1 and 2
      'Do 512 bytes in bottome of bank 1 first
      DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 1, SADD(Bank$))
      A$ = INPUT$(512, 1)
      Startpos = CVI(MID$(MKL$(65536 - 512), 1, 2))    'bottom of bank
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL Startpos, BYVAL LEN(A$), SADD(Mem$))
     
      'Now do 128 bytes at top of bank 2
      DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 2, SADD(Bank$))
      A$ = INPUT$(128, 1)
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL 0, BYVAL LEN(A$), SADD(Mem$))

'====================
'BANK 1
'======
     
      'Switch to bank 1
      DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 1, SADD(Bank$))

      'Do 64640 bytes  (101 rows of 640 bytes)
      REDIM row(100) AS STRING * 640            'Make room
      DL& = 0
      Sp& = 65536 - 512
      FOR y% = 100 TO 0 STEP -1                 'Do all 70
         GET #1, , row(y%)
         DL& = DL& + 640                       'add 640 per row
         Sp& = Sp& - 640
      NEXT
      Length = CVI(MID$(MKL$(DL&), 1, 2))     'make a value CALL will take
      Startpos = CVI(MID$(MKL$(Sp&), 1, 2))
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(row(0)), BYVAL VARPTR(row(0)), BYVAL &HA000, BYVAL Startpos, BYVAL Length, SADD(Mem$))
      ERASE row

      'Next line is broken in banks 0 and 1
      'Do 256 bytes in bottome of bank 0 first
      DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 0, SADD(Bank$))
      A$ = INPUT$(256, 1)
      Startpos = CVI(MID$(MKL$(65536 - 256), 1, 2))    'bottom of bank
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL Startpos, BYVAL LEN(A$), SADD(Mem$))

      'Now do 384 bytes at top of bank 1
      DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 1, SADD(Bank$))
      A$ = INPUT$(384, 1)
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL 0, BYVAL LEN(A$), SADD(Mem$))

'==================
'BANK 0
'======
      'Switch to bank 0
      DEF SEG = VARSEG(Bank$): CALL ABSOLUTE(BYVAL 0, SADD(Bank$))

      'Do 64640 bytes  (101 rows of 640 bytes)
      REDIM row(100) AS STRING * 640            'Make room
      DL& = 0
      Sp& = 65536 - 256
      FOR y% = 100 TO 0 STEP -1                 'Do all 70
         GET #1, , row(y%)
         DL& = DL& + 640                       'add 640 per row
         Sp& = Sp& - 640
      NEXT
      Length = CVI(MID$(MKL$(DL&), 1, 2))     'make a value CALL will take
      Startpos = CVI(MID$(MKL$(Sp&), 1, 2))
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(row(0)), BYVAL VARPTR(row(0)), BYVAL &HA000, BYVAL Startpos, BYVAL Length, SADD(Mem$))
      ERASE row

      'One line left....
      A$ = INPUT$(640, 1)
      DEF SEG = VARSEG(Mem$)
      CALL ABSOLUTE(BYVAL VARSEG(A$), BYVAL SADD(A$), BYVAL &HA000, BYVAL 0, BYVAL LEN(A$), SADD(Mem$))


A$ = INPUT$(1)  'Pause to look at it...

SCREEN 7
SCREEN 0: WIDTH 80, 25

