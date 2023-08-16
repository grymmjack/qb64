'***************************************************************************
' MOUSEINT.BAS = Mouse routines for QBasic using interrupts
' ============   Mausroutinen fuer QBasic mit Interrupts
'
' MOUSE.BAS - demonstrates mouse usage in QBasic, utilizing code from
' Brent Ashley's QBasic Toolbox. The text screen SCREEN 0 is used.
' INT-DEMO.BAS - shows how to use interrupts. Ralf Brown's interrupt list
' is probably the most comprehensive in existence, and it's *very* big.
' Available from SimTel and other sites.
'
'  Also includes scanword$(x,y), a function which returns the word under
'  the cursor.
'
'  Plus DIR$, a function which returns matching file names. *Very* useful.
'  Contributed by Ian Musgrave.
'
'  To use these routines with QB4/QB4.5 follow these instructions :-
'  Rename Regs to InRegs in the declaration section.
'  Define another variable of type RegTypeX as OutRegs
'  Change 'interrupt &H33, Regs' to 'CALL interrupt (&H33, InRegs, OutRegs)'
'  Rename Regs to InRegs for parameters passed to the interrupt, and rename
'  Regs to OutRegs for values returned from the interrupt.
'  Delete SUB Interrupt () and the DATA statements.
'
'  Feel free to modify and improve this code, and keep my name out of it!
'  Enjoy, Douggie
'
' (c) Douggie Green ( douggie*blissinx.demon.co.uk ), 1995
'****************************************************************************
DECLARE SUB GetMousePos (xp%, yp%)
DECLARE FUNCTION ButtonStatus% (b$)
DECLARE FUNCTION buttonrelease% (b$)
DECLARE SUB pause ()
DECLARE SUB SetMousePos (xmpos%, ympos%)
DECLARE FUNCTION InitMouse% ()
DECLARE SUB showmouse ()
DECLARE SUB hidemouse ()
DECLARE FUNCTION scanword$ (x%, y%)
'
DEFINT A-Z
'
TYPE RegTypeX
  AX    AS INTEGER
  bx    AS INTEGER
  CX    AS INTEGER
  DX    AS INTEGER
  BP    AS INTEGER
  SI    AS INTEGER
  DI    AS INTEGER
  Flags AS INTEGER
  DS    AS INTEGER
  ES    AS INTEGER
END TYPE
DIM SHARED Regs AS RegTypeX
DECLARE SUB INTERRUPT (IntNum%, Regs AS RegTypeX)

DECLARE FUNCTION DIR$ (FileSpec$)
     
'-----  Some constants that DIR$ uses
CONST DOS = &H21                'Interupt &H21
CONST SetDTA = &H1A00, FindFirst = &H4E00, FindNext = &H4F00
DIM FileArray$(1 TO 500)        'This is only set to 500 files, there
                                'can be more, to find the number of files
                                'to exactly dimension the array requires
                                'calling DIR$ twice. (once to count, once
                                'to put into the array
'
CLS
                          
mousebuttons = InitMouse  '' This will usually return 2, even with 3 button
                          '' mice <dg>
'
IF mousebuttons = 0 THEN
  PRINT "Mouse not present"
  END
  END IF
'
PRINT mousebuttons; " button mouse detected"
CALL SetMousePos(30, 10)              '' x,y format, based on 80x25 screen
' 
showmouse
LOCATE 12, 1
PRINT "Click on a word (any word). Press any key to move on."
       
DO                                ''end when any key is pressed <dg>
  CALL GetMousePos(xmpos, ympos)
  LOCATE 1, 1: PRINT "                                "
  LOCATE 1, 1: PRINT "mouse is at "; xmpos, ympos
  button = ButtonStatus("l")
  LOCATE 2, 1: PRINT "                                "
  LOCATE 2, 1: PRINT "Button status "; button
'
''-------------------------------scanword example code----------------

  button = buttonrelease("l")
  IF button = 1 THEN
    comm$ = scanword$((xmpos), (ympos)) ''We don't want to change xmpos
    LOCATE 15, 30
    PRINT "                          ";
    LOCATE 15, 30
    PRINT comm$
  END IF
''----------------------------end of scanword example-----------------
  a$ = INKEY$
LOOP WHILE a$ = ""
'
hidemouse
'
pause
'
END
'
''hex data for interrupt routines
'
DATA  &H55, &H8B, &HEC, &H83, &HEC, &H08, &H56, &H57, &H1E, &H55, &H8B, &H5E
DATA  &H06, &H8B, &H47, &H10, &H3D, &HFF, &HFF, &H75, &H04, &H1E, &H8F, &H47
DATA  &H10, &H8B, &H47, &H12, &H3D, &HFF, &HFF, &H75, &H04, &H1E, &H8F, &H47
DATA  &H12, &H8B, &H47, &H08, &H89, &H46, &HF8, &H8B, &H07, &H8B, &H4F, &H04
DATA  &H8B, &H57, &H06, &H8B, &H77, &H0A, &H8B, &H7F, &H0C, &HFF, &H77, &H12
DATA  &H07, &HFF, &H77, &H02, &H1E, &H8F, &H46, &HFA, &HFF, &H77, &H10, &H1F
DATA  &H8B, &H6E, &HF8, &H5B, &HCD, &H21, &H55, &H8B, &HEC, &H8B, &H6E, &H02
DATA  &H89, &H5E, &HFC, &H8B, &H5E, &H06, &H1E, &H8F, &H46, &HFE, &HFF, &H76
DATA  &HFA, &H1F, &H89, &H07, &H8B, &H46, &HFC, &H89, &H47, &H02, &H89, &H4F
DATA  &H04, &H89, &H57, &H06, &H58, &H89, &H47, &H08, &H89, &H77, &H0A, &H89
DATA  &H7F, &H0C, &H9C, &H8F, &H47, &H0E, &H06, &H8F, &H47, &H12, &H8B, &H46
DATA  &HFE, &H89, &H47, &H10, &H5A, &H1F, &H5F, &H5E, &H8B, &HE5, &H5D, &HCA
DATA  &H02, &H00                                 
'
'------------------------------end INTMOUSE.BAS-----------------------
'Douggie Green (douggie*blissinx.demon.co.uk)
FUNCTION buttonrelease (b$)
Regs.AX = &H6
 IF LEFT$(UCASE$(b$), 1) = "L" THEN Regs.bx = 0 ELSE Regs.bx = 1
INTERRUPT &H33, Regs
'
buttonrelease = Regs.bx  '' Count of releases, reset to 0 each call.
END FUNCTION
'
FUNCTION ButtonStatus (b$)
''  b$ should be either "l" or "r". When called once, will return the
''  number of times the specified button has been pressed since the last
''  call. When used in a loop, as in this demo prog, it works like INKEY$
''  Could be split into ButtonDown() and ButtonCount()  <dg>
'
  Regs.AX = &H5
  IF LEFT$(UCASE$(b$), 1) = "L" THEN Regs.bx = 0 ELSE Regs.bx = 1
  INTERRUPT &H33, Regs
' 
  ButtonStatus = Regs.bx  '' Count of presses, reset to 0 each call.
' 
  IF Regs.AX > 0 THEN ButtonStatus = Regs.AX  '' Is a button down?
                                              ''if so, return which button
END FUNCTION
'
FUNCTION DIR$ (FileSpec$) STATIC
'
'' Contributed by Ian Musgrave - Ian.Musgrave*med.monash.edu.au
'
DIM DTA AS STRING * 44 ', Regs AS RegTypeX
Null$ = CHR$(0)
     
'-----  Set up our own DTA so we don't destroy COMMAND$
Regs.AX = SetDTA                    'Set DTA function
Regs.DX = VARPTR(DTA)               'DS:DX points to our DTA
Regs.DS = -1                        'Use current value for DS
INTERRUPT DOS, Regs                 'Do the interrupt
'     
'-----  Check to see if this is First or Next
IF LEN(FileSpec$) THEN              'FileSpec$ isn't null, so
              'FindFirst
   FileSpecZ$ = FileSpec$ + Null$   'Make FileSpec$ into an ASCIIZ
              'string
   Regs.AX = FindFirst              'Perform a FindFirst
   Regs.CX = 0                      'Only look for normal files
   Regs.DX = SADD(FileSpecZ$)       'DS:DX points to ASCIIZ file
   Regs.DS = -1                     'Use current DS
ELSE                                'We have a null FileSpec$,
   Regs.AX = FindNext               'so FindNext
END IF
'     
INTERRUPT DOS, Regs                 'Do the interrupt
'     
'-----  Return file name or null
IF Regs.Flags AND 1 THEN            'No files found
   DIR$ = ""                        'Return null string
ELSE
   Null = INSTR(31, DTA, Null$)     'Get the filename found
   DIR$ = MID$(DTA, 31, Null - 30)  'It's an ASCIIZ string starting
END IF                              'at offset 30 of the DTA
'     
END FUNCTION
'
SUB GetMousePos (xp, yp)
  Regs.AX = &H3
  INTERRUPT &H33, Regs
  xp = Regs.CX / 8   '' These values may need changing depending on
  yp = Regs.DX / 8   '' your screen mode <dg>
END SUB
'
SUB hidemouse
  Regs.AX = &H2
  INTERRUPT &H33, Regs
END SUB
'
FUNCTION InitMouse
  Regs.AX = &H0
  INTERRUPT &H33, Regs
  IF Regs.AX <> 0 THEN InitMouse = Regs.bx ELSE InitMouse = 0
END FUNCTION
'
SUB INTERRUPT (IntNum, Regs AS RegTypeX) STATIC
  STATIC FileNum, IntOffset, Loaded
'  
  ' use fixed-length string to fix its position in memory
  ' and so we don't mess up string pool before routine
  ' gets its pointers from caller
  DIM IntCode AS STRING * 200
  IF NOT Loaded THEN                     ' loaded will be 0 first time
'   
   FOR k = 1 TO 145
      READ h%
      MID$(IntCode, k, 1) = CHR$(h%)
   NEXT
'
              ''  determine address of interrupt no. offset in IntCode
   IntOffset = INSTR(IntCode$, CHR$(&HCD) + CHR$(&H21)) + 1
   Loaded = -1
  END IF
SELECT CASE IntNum
    CASE &H25, &H26, IS > 255               ' ignore these interrupts
    CASE ELSE
      DEF SEG = VARSEG(IntCode)             ' poke interrupt number into
      POKE VARPTR(IntCode) * 1& + IntOffset - 1, IntNum     ' code block
      CALL Absolute(Regs, VARPTR(IntCode$))               ' call routine
  END SELECT
END SUB

SUB pause
WHILE a$ = ""
a$ = INKEY$
WEND
END SUB
'
FUNCTION scanword$ (x, y)
y = y + 1: x = x + 1 '' need to adjust because the mouse routines return
                     '' values >= 0, and LOCATE and SCREEN need >=1
hidemouse

c = SCREEN(y, x)             ''Get the character under the mouse cursor
                             ''and check it's alphanumeric, or punctuation
IF c > 39 AND c < 123 THEN   ''We're over a word so...
  LOCATE y, x

    DO                       ''Find the start of the word
      c = SCREEN(y, x)
      x = x - 1
    LOOP UNTIL c < 39 OR c > 123 OR x = 0
   
    IF x > 0 THEN x = x + 2  ''We end up at the x position *before* the
                             ''word, so adjust again.
    IF x = 0 THEN x = 1      ''SCREEN and LOCATE need this, just in case.
   
    DO                       ''Read the word
      c = SCREEN(y, x)
      w$ = w$ + CHR$(c)
      x = x + 1
    LOOP UNTIL c < 39 OR c > 123 OR x = 0

  w$ = LEFT$(w$, LEN(w$) - 1)  ''We end up past the word, so trim it.
END IF
'
scanword$ = w$
showmouse
END FUNCTION
'
SUB SetMousePos (xmpos, ympos)
  Regs.AX = &H4
  Regs.CX = xmpos * 8 '' These values may need changing depending on
  Regs.DX = ympos * 8 '' your screen mode <dg>
  INTERRUPT &H33, Regs
END SUB
'
SUB showmouse
  Regs.AX = &H1
  INTERRUPT &H33, Regs
END SUB

