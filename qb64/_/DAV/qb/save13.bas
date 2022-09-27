'==========
'SAVE13.BAS
'==========
'Saves SCREEN 13 as an image or self-displaying COM executable.

'FORMATS: RAW, BSV, BMP/DIB (windows or OS2), CLP image, PBM, TGA
'         TIF, PCX, GIF, RAS, WMF, COM self-displaying executable.

'NOTE: I've thrown these together in one SUB.  Most I figured out
'      by saving an image an analyzing it, or by doc's, and a few
'      such as PBM and GIF I adapted from public domain sources.
'      I didn't care to document it well, 'cause I never intended
'      to release it.  I made it to use in my FLI frames ripper.
'      Just use it too if you want.

'MORE NOTES:
'      You can't *legaly* use a GIF maker in your compiled programs
'      without a license - so I hear.  I just added the code here for
'      information purposes.  Um...I'm not telling you to use it. :)

'=========
' CREDITS
'========
' This program uses Rich Geldreich's GIF saving routine which is in
' public domain and can be found in the ABC packets.

'=======================================================================
'                      HOW TO USE THE SAVE13 SUB
'=======================================================================

'Saves the currently displayed screen as a Image or .COM executable.
'It's designed for SCREEN 13 only and creates 320x200 256 color images.

'You CALL the SAVE13 SUB like this:   CALL SAVE13 filename$, ImageType%

'Filename$  = This is the name of the file to create.
'ImageType% = The type of file to create.  Choose from below:

'                                    
'   1 = RAW  Image data, NO pallette.              |  (64000 bytes)
'   2 = RAW  Image data WITH pallette.             |  (768 + 64000)
'   3 = BSV  BLOADable file, no pallette           |  (64008)
'   4 = BSV  BLOADable file WITH pallette on end   |  (64008 + 768)
'   5 = BMP  Standard 320x200 256 color BMP/DIB    |  (65078)
'   6 = BMP  RLE-compressed 256 color BMP          |  (various)
'   7 = CLP  Windows clipboard image file          |  (65078)
'   8 = PBM  Portable Bitmap                       |
'   9 = TGA  320x200 256 color uncompressed TGA    |
'  10 = PCX  Standard PCX format, Version 5        |  (various)
'  11 = GIF  Standard GIF87a                       |  (various)
'  12 = BMP  OS/2 Bitmap 320x200, 256 colors       |
'  13 = RAS  Sun Raster image file                 |
'  14 = WMF  Windows Meta File                     |
'  15 = TIF  Tagged Image format - uncompressed    |
'  16 = COM  A self-displaying COM executable!     |  (64814)
'            When executed it sets the screen, the pallette,
'            displays the image, waits for a key-press then
'            restores the screen to mode 0.
'-----------------------------------------------------------------------
'  NOTE:     The COM files created are stand-alone programs
'            containing all the image & pallette data.  They
'            can be compressed and display VERY fast.  These
'            files can make a good intros or ads for programs.
'=======================================================================

DEFINT A-Z
DECLARE SUB SAVE13 (filename$, ImageType%)

SCREEN 13                '<--- Make sure you're in SCREEN 13 1st!

'SAVE13 "DIR.PCX", 10    'Capture screen as a PCX image file

END

SUB SAVE13 (filename$, ImageType%)

'ONLY CALL THIS SUB WHILE IN SCREEN 13!!    <------ IMPORTANT!!

IF ImageType% < 1 OR ImageType% > 16 THEN EXIT SUB

OPEN filename$ FOR OUTPUT AS 5          'Name of file to create

OUT 967, 0: Pal$ = ""
FOR c% = 1 TO 768                       'Grab pallette
  Pal$ = Pal$ + CHR$(INP(969))          'Hold it as Pal$
NEXT

SELECT CASE ImageType%
  CASE 1, 2                         'Make a RAW image
    IF ImageType% = 2 THEN PRINT #5, Pal$;       'Add Pal$
    GOSUB GetRawImage
  CASE 3, 4                         'Make a BLOADable file
    BH$ = "FD00A0000000FA"          'Save a BSAVE header 1st
    FOR I = 1 TO LEN(BH$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(BH$, I, 2)));
    NEXT
   
    'I know...just BSAVE it. Right?  Nope.  I didn't want to put any
    'DEF SEG's in this SUB.  That's why there's no POKEing either.
    'You can add this SUB to your programs without DEF SEG worries.

    GOSUB GetRawImage
    IF ImageType% = 4 THEN PRINT #5, Pal$;   'Add Pal$
  CASE 5, 7               'Make a BMP/DIB/CLP
    IF ImageType% = 7 THEN          'CLP header
      A$ = "50C30100080028FE00000E0000002800000040010000C800000001000800"
      A$ = A$ + "0000000000FA000000000000000000000001000000010000"
    ELSE                            'BMP/DIB header
      A$ = "424D36FE000000000000360400002800000040010000C800000001000"
      A$ = A$ + "800000000000000000000000000000000000000000000000000"
    END IF
    FOR I% = 1 TO LEN(A$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(A$, I%, 2)));
    NEXT
    FOR A% = 0 TO 255: OUT 967, A%     'Grab and save the pallette
      R$ = CHR$(INP(969) * 4)          'Red
      G$ = CHR$(INP(969) * 4)          'Green
      B$ = CHR$(INP(969) * 4)          'Blue
      PRINT #5, B$; G$; R$; CHR$(0);   'Save'em all
    NEXT
    FOR y% = 199 TO 0 STEP -1
      FOR x% = 0 TO 319
        PRINT #5, CHR$(POINT(x%, y%));
      NEXT: LINE (0, y%)-(319, y%), 0
    NEXT
  CASE 6
    A$ = "424D0000000000000000360400002800000040010000C800000001000800"
    A$ = A$ + "010000000000000000000000000000000000000000000000"
    FOR I% = 1 TO LEN(A$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(A$, I%, 2)));
    NEXT
    FOR A% = 0 TO 255: OUT 967, A%
      R$ = CHR$(INP(969) * 4)
      G$ = CHR$(INP(969) * 4)
      B$ = CHR$(INP(969) * 4)
      PRINT #5, B$; G$; R$; CHR$(0);
    NEXT
    FOR y% = 199 TO 0 STEP -1
      FOR x% = 0 TO 319
        Clr% = POINT(x%, y%)
        IF Clr% = POINT(x% + 1, y%) THEN
          c% = 2: x% = x% + 2
          DO WHILE POINT(x%, y%) = Clr%
            c% = c% + 1: x% = x% + 1
            IF x% = 319 THEN EXIT DO
            IF c% = 255 THEN EXIT DO
          LOOP: PRINT #5, CHR$(c%); CHR$(Clr%);
          x% = x% - 1
        ELSE
          PRINT #5, CHR$(1); CHR$(Clr%);
        END IF
      NEXT: LINE (0, y%)-(319, y%), 0
      PRINT #5, CHR$(0); CHR$(0);
    NEXT: PRINT #5, CHR$(0); CHR$(1);
  CASE 8                          'PBM Portable Bitmap
                                  'This is adapted public domain code.
                                  'the author was unknown. I tweaked it.
    REDIM SHT(8) AS LONG
    FOR A = 0 TO 7: SHT(A) = 2 ^ A: NEXT
    PBM$ = "50340A23200A333230203230300A"        'PBM Header
    FOR p% = 1 TO LEN(PBM$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(PBM$, p%, 2)));
    NEXT
    FOR y% = 0 TO 199
      FOR x% = 0 TO 319
        c% = POINT(x%, y%): PSET (x%, y%), 0
        B% = SHT(7 - I%)
        IF c% THEN IF (A% AND B%) = 0 THEN A% = A% + B%
        I% = I% + 1
        IF I% > 7 THEN
           A% = 255 - A%: PRINT #5, CHR$(A%);
           A% = 0: I% = 0
        END IF
      NEXT: A% = 255 - A%
      PRINT #5, CHR$(A%); : A% = 0: I% = 0
    NEXT
  CASE 9                                'Make TGA
    TH$ = "0001010000000118000000004001C8000800"    'TGA Header
    FOR I = 1 TO LEN(TH$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(TH$, I, 2)));
    NEXT
    FOR A% = 0 TO 255: OUT 967, A%     'Grab and save the pallette
      R$ = CHR$(INP(969) * 4)
      G$ = CHR$(INP(969) * 4)
      B$ = CHR$(INP(969) * 4)
      PRINT #5, B$; G$; R$;
    NEXT
    FOR y% = 199 TO 0 STEP -1
      FOR x% = 0 TO 319
        PRINT #5, CHR$(POINT(x%, y%));
      NEXT: LINE (0, y%)-(319, y%), 0
    NEXT
  CASE 10             'Make a PCX, save PCX header first..
    A$ = "0A050108000000003F01C7004001C800000000D89838787404706C04ECAC"
    A$ = A$ + "4CF8C480402424242814F8BC68D4909C3C24247470087874087C78083430"
    A$ = A$ + "04F0C4880001400100000000000000000000000000000000000000000000"
    A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
    A$ = A$ + "0000000000000000"
    FOR I% = 1 TO LEN(A$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(A$, I%, 2)));
    NEXT: A$ = ""
    FOR y% = 0 TO 199: x% = 0
      WHILE x% < 320: c% = POINT(x%, y%)
         IF POINT(x% + 1, y%) = c% THEN
            x% = x% + 2: cv% = 2
            DO WHILE POINT(x%, y%) = c%
               x% = x% + 1: cv% = cv% + 1
               IF cv% = 63 THEN EXIT DO
            LOOP: PRINT #5, CHR$(cv% + 192) + CHR$(c%);
         ELSE
            IF c% > 191 THEN PRINT #5, CHR$(193);
            PRINT #5, CHR$(c%); : x% = x% + 1
         END IF
      WEND: LINE (0, y%)-(319, y%), 0
    NEXT: PRINT #5, CHR$(12);
    FOR A% = 0 TO 255: OUT 967, A%     'Grab and save the pallette
      R$ = CHR$(INP(969) * 4)          'Red
      G$ = CHR$(INP(969) * 4)          'Green
      B$ = CHR$(INP(969) * 4)          'Blue
      PRINT #5, R$; G$; B$;            'Save'em all
    NEXT
  CASE 11                               'Make a GIF87a
    '==============================================================
    'Yep. This is Rich's * famous * code. You can find the original
    'source in the public domain ABC packets.  I condensed it here.
    '==============================================================
    DIM PF(7176), SF(7176), GC(7176), SHT(7) AS LONG
    x% = 1: y% = 0: cb% = 0
    c& = 0: mc% = 512: cs% = 9: nc% = 258
    FOR A = 0 TO 7: SHT(A) = 2 ^ A: NEXT
    HDR$ = "4749463837614001C800D70000"           'GIF Header
    FOR I = 1 TO LEN(HDR$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(HDR$, I, 2)));
    NEXT: OUT 967, 0
    FOR A = 1 TO 768                              'Save Pallette
      PRINT #5, CHR$((INP(969) * 4));
    NEXT: ID$ = "2C000000004001C8000708"          'GIF ID
    FOR I = 1 TO LEN(ID$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(ID$, I, 2)));
    NEXT
    FOR A% = 0 TO 7176
      PF(A%) = -1: SF(A%) = -1: GC(A%) = -1
    NEXT: A = 256: GOSUB PutGIF
    PF = POINT(0, 0): PSET (0, 0), 0              'Get First Pixel
    DO
      DO
        SF = POINT(x%, y%): PSET (x%, y%), 0
        x% = x% + 1: IF x% > 319 THEN : x% = 0: y% = y% + 1
        Idx% = ((PF * 256&) XOR SF) MOD 7177
        IF Idx% = 0 THEN os% = 1 ELSE os% = 7177 - Idx%
        DO
          IF GC(Idx%) = -1 THEN fd% = 0: EXIT DO
          IF PF(Idx%) = PF AND SF(Idx%) = SF THEN fd% = 1: EXIT DO
          Idx% = Idx% - os%: IF Idx% < 0 THEN Idx% = Idx% + 7177
        LOOP
        IF fd% = 1 THEN PF = GC(Idx%)
        IF y% > 199 THEN
          A = PF: GOSUB PutGIF: A = 257: GOSUB PutGIF
          IF cb% <> 0 THEN A = 0: GOSUB PutGIF
          bl% = bl% - 1: IF bl% <= 0 THEN bl% = 255: PRINT #5, CHR$(255);
          PRINT #5, CHR$(0); : CLOSE #5: EXIT SUB
        END IF
      LOOP WHILE fd%
      A = PF: GOSUB PutGIF: PF(Idx%) = PF: SF(Idx%) = SF
      GC(Idx%) = nc%: PF = SF: nc% = nc% + 1
      IF nc% = mc% + 1 THEN
        mc% = mc% * 2
        IF cs% = 12 THEN
          A = 256: GOSUB PutGIF
          FOR A% = 0 TO 7176
            PF(A%) = -1: SF(A%) = -1: GC(A%) = -1
          NEXT: nc% = 258: cs% = 9: mc% = 512
        ELSE
          cs% = cs% + 1
        END IF
      END IF
    LOOP: EXIT SUB
  CASE 12                       'Make OS2 BMP Header
     A$ = "424D1AFD0000000000001A0300000C0000004001C80001000800"
     FOR I% = 1 TO LEN(A$) STEP 2
        PRINT #5, CHR$(VAL("&H" + MID$(A$, I%, 2)));
     NEXT
     FOR A% = 0 TO 255: OUT 967, A%
        R$ = CHR$(INP(969) * 4)           'Almost like BMP...
        G$ = CHR$(INP(969) * 4)
        B$ = CHR$(INP(969) * 4)
        PRINT #5, B$; G$; R$;             'No CHR$(0) at end.
     NEXT
     FOR y% = 199 TO 0 STEP -1
        FOR x% = 0 TO 319
           PRINT #5, CHR$(POINT(x%, y%));
        NEXT: LINE (0, y%)-(319, y%), 0
     NEXT
  CASE 13                        'RAS Sun Raster Image file
     A$ = "59A66A9500000140000000C8000000080000FA"
     A$ = A$ + "00000000010000000100000300"
     FOR I% = 1 TO LEN(A$) STEP 2
        PRINT #5, CHR$(VAL("&H" + MID$(A$, I%, 2)));
     NEXT
     FOR t% = 1 TO 3                   'Change RAW Pal$ data
        FOR U% = 1 TO LEN(Pal$) STEP 3
           PRINT #5, CHR$(ASC(MID$(Pal$, U%, 1)) * 4);
        NEXT
     NEXT
     GOSUB GetRawImage
  CASE 14                           'WMF 1st Header
    A$ = "D7CDC69A0000000000004001C800600000000000F9560100090000034881"
    A$ = A$ + "00000100227F000000000400000003010800050000000B02000000000500"
    A$ = A$ + "00000C022D15E12105020000F70000030001"
    FOR I = 1 TO LEN(A$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(A$, I, 2)));
    NEXT
    FOR A% = 0 TO 255: OUT 967, A%     'Grab and save the pallette
      R$ = CHR$(INP(969) * 4)          'Red
      G$ = CHR$(INP(969) * 4)          'Green
      B$ = CHR$(INP(969) * 4)          'Blue
      PRINT #5, B$; G$; R$; CHR$(0);   'Save'em all
    NEXT                           'WMF 2nd header
    A$ = "0400000034020000030000003500227F0000430F2000CC000000C8004001"
    A$ = A$ + "000000002D15E121000000002800000040010000C8000000010008000000"
    A$ = A$ + "000000FA000000000000000000000001000000010000"
    FOR I = 1 TO LEN(A$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(A$, I, 2)));
    NEXT
    FOR A% = 0 TO 255: OUT 967, A%     'Grab and save the pallette
      R$ = CHR$(INP(969) * 4)          'Red
      G$ = CHR$(INP(969) * 4)          'Green
      B$ = CHR$(INP(969) * 4)          'Blue
      PRINT #5, B$; G$; R$; CHR$(0);   'Save'em all
    NEXT
    FOR y% = 199 TO 0 STEP -1
      FOR x% = 0 TO 319
        PRINT #5, CHR$(POINT(x%, y%));
      NEXT: LINE (0, y%)-(319, y%), 0
    NEXT                    'WMF Tailer
    A$ = "030000000000"
    FOR I = 1 TO LEN(A$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(A$, I, 2)));
    NEXT
  CASE 15                 'TIFF Header #1
    A$ = "49492A00080000000F00FE00040001000000000000000001030001000000"
    A$ = A$ + "400100000101030001000000C80000000201030001000000080000000301"
    A$ = A$ + "030001000000010000000601030001000000030000001101040001000000"
    A$ = A$ + "D20700001501030001000000010000001601030001000000C80000001701"
    A$ = A$ + "04000100000000FA00001A01050001000000C20000001B01050001000000"
    A$ = A$ + "CA0000002801030001000000020000004001030000030000D20000004986"
    A$ = A$ + "010000010000D20600000000000080FC0A001027000080FC0A0010270000"
    A$ = A$ + ""
    FOR I% = 1 TO LEN(A$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(A$, I%, 2)));
    NEXT                                       'Raw (*4)
    OUT 967, 0: Pal$ = ""
    FOR c% = 1 TO 768                       'Grab pallette
      Pal$ = Pal$ + CHR$(INP(969) * 4)        'Hold it as Pal$
    NEXT
    FOR t% = 1 TO LEN(Pal$) STEP 3
      A$ = MID$(Pal$, t%, 2): B$ = B$ + A$
    NEXT: PRINT #5, B$; B$; B$;                 'TIFF header #2
    A$ = "3842494D03ED000000000010004800000001000100480000000100013842"
    A$ = A$ + "494D03F300000000000700000000000000003842494D03F5000000000048"
    A$ = A$ + "002F66660001006C66660006000000000000002F6666000100A1999A0006"
    A$ = A$ + "000000000000003200000001005A00000006000000000000003500000001"
    A$ = A$ + "002D000000060000000000003842494D03F80000000000700000FFFFFFFF"
    A$ = A$ + "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF03E800000000FFFFFFFFFFFF"
    A$ = A$ + "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF03E800000000FFFFFFFFFFFFFFFF"
    A$ = A$ + "FFFFFFFFFFFFFFFFFFFFFFFFFFFF03E800000000FFFFFFFFFFFFFFFFFFFF"
    A$ = A$ + "FFFFFFFFFFFFFFFFFFFFFFFF03E80000"
    FOR I% = 1 TO LEN(A$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(A$, I%, 2)));
    NEXT
    GOSUB GetRawImage
  CASE 16                          'COM file, write COM data
    A$ = "B81300CD10B81210BB0000B90001BA2E01CD10FCBE2E04"
    A$ = A$ + "2BFFB800A08EC0B9007DF3A5B400CD16B80300CD10CD20"
    FOR I% = 1 TO LEN(A$) STEP 2
      PRINT #5, CHR$(VAL("&H" + MID$(A$, I%, 2)));
    NEXT
    PRINT #5, Pal$;
    GOSUB GetRawImage
END SELECT

CLOSE #5

EXIT SUB


'=============================================================
'Several ImageType% use this routine.

GetRawImage:
  FOR y% = 0 TO 199              'Save Screen, pixel by pixel
    FOR x% = 0 TO 319
        PRINT #5, CHR$(POINT(x%, y%)); 'Save the pixel
    NEXT: LINE (0, y%)-(319, y%), 0
  NEXT
RETURN

'==============================================================
'This is for the GIF routine
PutGIF:
  c& = c& + A * SHT(cb%): cb% = cb% + cs%
  DO WHILE cb% > 7: bl% = bl% - 1
     IF bl% <= 0 THEN bl% = 255: PRINT #5, CHR$(255);
     PRINT #5, CHR$(c& AND 255);
     c& = c& \ 256: cb% = cb% - 8
  LOOP
RETURN

END SUB

