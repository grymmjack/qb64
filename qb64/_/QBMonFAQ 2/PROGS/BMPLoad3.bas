'*****************************************************************************
' BMPLOAD3.BAS = BMP loader/maker
' ============   Anzeigeprogramm fuer BMP-Grafiken ("BMP-Loader")
'
' *** Deutsche Beschreibung
' Dieses Q(uick)Basic-Programm zeigt BMP-Grafiken an. Die BMP-Datei muss
' die Groesse 320 x 200 x 256 Farben haben. Zum Anzeigen anderer BMPs kann
' das Programm leicht angepasst werden. Das programm arbeitet sehr schnell
' und kommt ganz ohne Assemblerbefehle aus. es verwendet den Interrupt &h21.
' Weil der Befehl CALL INTERRUPTX verwendet wird, ist das Programm nur unter
' QuickBASIC, nicht unter QBasic lauffaehig, und QuickBASIC muss mit der
' Option "/L" gestartet werden, also z.B. mit "QB.EXE /L BMPLOAD3.BAS" .
'
' *** English-language description
' A little program that loads a BMP-file in less than 0.2 seconds, then
' you can save the image into a new BMP-file and that takes about 0.2s!!
' It doesn't use any assembler at all, instead it uses interrupts, so if
' you don't know what that is then don't try to modify the code.
'
' This program doesn't check the format of the BMP-file because I think
' it's alot easier to read and understand it if no format check is done.
' If you want that it's not hard to write it yourself.
' Because of this the BMP-file must be 320*200*256, there shouldn't be
' difficult to modify the code so that it opens all kinds of sizes.
' If I get the time the next few weeks (alot of homework, you know:) I will
' do that myself.
'
' The format of the BMP-files has been taken from a file called BMP.BAS,
' unfortunatly I have lost the authors name but I give all credits for the
' format of the headers to him (or her).
'
' If you use parts or the whole program or ideas based on this code please
' give me credits. This program may not be used in any kind of non-freeware
' programs without my knowledge (If you or anyone else earns money selling
' programs that uses parts or the whole program or ideas based on this code)
'
' It should be very easy to change this program so that you can open TGA or
' any other format saved like the BMP (64000 pixels in a row).
'
' If you have any questions or improvements on this code please send them to:
' thomas.nyberg*usa.net
'
' IMPORTANT!!
' This program is used at your own risc. I, Thomas Nyberg, does not take
' any responsibility if any information, data, files or any other kind
' of software or hardware is damaged or destroyed in any way.
' I can't garantee that this code is safe but I think it should be, therefore
' beginners should not try to modify or use this code in their programs.

' Please excuse my english, it's very late :)
'
' (c)  by Thomas Nyberg (thomas.nyberg*usa.net)
'*****************************************************************************
'
DECLARE SUB savebmp (filename$)
DECLARE SUB loadbmp (filename$)
'
'$INCLUDE: 'qb.bi' 'Needs QB.QLB/LIB to be loaded
'
'The header:
'
TYPE bmpinfo 'what it should say for a 320*200*256 bmp
  bm AS STRING * 2 'bm
  size AS LONG 'wid*hei+1078= 65078
  r1 AS INTEGER '0
  r2 AS INTEGER '0
  offsdata AS LONG '1078
  hsize AS LONG '40
  wid AS LONG '320
  hei AS LONG '200
  planes AS INTEGER '1
  bpp AS INTEGER '8
  comp AS LONG '0
  isize AS LONG '64000
  xpm AS LONG '3790
  ypm AS LONG '3780
  colus AS LONG '0
  impcol AS LONG '0
pal AS STRING * 1024 'blue, green, red, 0
END TYPE
'
DIM SHARED bmpheader AS bmpinfo
DIM SHARED regs AS RegTypeX
'
SCREEN 13
'
t = TIMER 'Time how long it takes
loadbmp "c:\tmp\thomas.bmp" 'loads a BMP-file
'savebmp "test.bmp" 'Saves a BMP-file
PRINT TIMER - t'If you can't figure this one out...

DEFINT A-Z
'
SUB loadbmp (filename$)
'
'Load the header
OPEN filename$ FOR BINARY AS #1
GET #1, , bmpheader 'read it
CLOSE #1
'
'Load the palette
OUT &H3C8, 0
FOR I = 1 TO 1024 STEP 4
 b% = ASC(MID$(bmpheader.pal, I, 1)) \ 4 'blue
 g% = ASC(MID$(bmpheader.pal, I + 1, 1)) \ 4 'green
 r% = ASC(MID$(bmpheader.pal, I + 2, 1)) \ 4 'red
 OUT &H3C9, r%
 OUT &H3C9, g%
 OUT &H3C9, b%
NEXT
'
filename$ = filename$ + CHR$(0) 'filename must be ASCIIZ (zero terminated)
'
'open the file
regs.ax = &H3D00
regs.ds = VARSEG(filename$) 'segment of name
regs.dx = SADD(filename$) 'offset of name
CALL INTERRUPTX(&H21, regs, regs)
regs.bx = regs.ax 'filehandle
'
'move filepointer to &h436 in the file
regs.ax = &H4200
regs.cx = 0
regs.dx = &H436
CALL INTERRUPTX(&H21, regs, regs)
'
'Read and display the file
FOR y = bmpheader.hei - 1 TO 0 STEP -1
  regs.ax = &H3F00
  regs.cx = 320 'widht of the file
  regs.ds = &HA000 'screen 13's segment
  regs.dx = VAL("&H" + HEX$(y * 320&)) 'Has to do wiht QB integers
CALL INTERRUPTX(&H21, regs, regs)
NEXT
'
'close it
regs.ax = &H3E00
CALL INTERRUPTX(&H21, regs, regs)
filename$ = LEFT$(filename$, LEN(filename$) - 1) 'resore the filename
END SUB

'
SUB savebmp (filename$)
'read the palette
OUT &H3C7, 0
FOR I% = 0 TO 255
  r% = INP(&H3C9) * 4
  g% = INP(&H3C9) * 4
  b% = INP(&H3C9) * 4
  a$ = a$ + CHR$(b%) + CHR$(g%) + CHR$(r%) + CHR$(0)
NEXT
'
'create the header
bmpheader.bm = "BM"
bmpheader.size = 65078
bmpheader.r1 = 0
bmpheader.r2 = 0
bmpheader.offsdata = 1078
bmpheader.hsize = 40
bmpheader.wid = 320
bmpheader.hei = 200
bmpheader.planes = 1
bmpheader.bpp = 8
bmpheader.comp = 0
bmpheader.isize = 64000
bmpheader.xpm = 3790
bmpheader.ypm = 3780
bmpheader.colus = 0
bmpheader.impcol = 0
bmpheader.pal = a$
'
'save the header
OPEN filename$ FOR BINARY AS #1
IF LOF(1) > 0 THEN 'file already exist
CLOSE #1
KILL filename$ 'delete the file and reopen it
OPEN filename$ FOR BINARY AS #1
END IF
PUT #1, , bmpheader 'write the header
CLOSE #1
'
filename$ = filename$ + CHR$(0) 'filename must be ASCIIZ (zero terminated)
'
'opens the file
regs.ax = &H3D01
regs.ds = VARSEG(filename$) 'segment of filename
regs.dx = SADD(filename$) 'offset of filename
CALL INTERRUPTX(&H21, regs, regs)
regs.bx = regs.ax 'filehandle
'
'move the filepointer
regs.ax = &H4200
regs.cx = 0
regs.dx = &H436
CALL INTERRUPTX(&H21, regs, regs)
'
'saves the screen into the file
FOR y% = 199 TO 0 STEP -1
  regs.ax = &H4000
  regs.cx = 320 'number of bytes to write
  regs.ds = &HA000 'screen 13's segment
  regs.dx = VAL("&H" + HEX$(y% * 320&)) 'Has to do with QB integers
  CALL INTERRUPTX(&H21, regs, regs)
NEXT
'
'close the file
regs.ax = &H3E00
CALL INTERRUPTX(&H21, regs, regs)
'
filename$ = LEFT$(filename$, LEN(filename$) - 1) 'restore the filename
END SUB

