'**********************************************************************
' DIRLIST.BAS = Reads filenames from a directory (e.g. DIR *.bas)
' ===========   Listet die Dateien in einem Verzeichnis auf, z.B. *.BAS
'
' English Description:
' This Q(uick)Basic programm generates a list of the files in a
' directory. A "*" can be specifies as wildcard in the filename
' specification in front of the dot. This program works similar as
' the QuickBASIC 7.1 DIR$() statement.
'
' Deutsche beschreibung:
' Dieses Q(uick)Basic-programm listet die Dateien in einem Verzeichnis
' auf. Dabei kann als Dateiename vor dem Punkt der Platzhalter "*"
' angegeben werden. *.BAS listete z.B- alle .BAS-Dateien auf. Das
' Programm arbeitet aehnlich wie der DIR$()-Befehl in QuickBASIC 7.1
'
' (c) Douggie Green ( douggie*blissinx.demon.co.uk ), 1995
'***********************************************************************
'
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
'    
DECLARE SUB INTERRUPT (IntNum%, Regs AS RegTypeX)
DECLARE FUNCTION DIR$ (FileSpec$)
'
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
PRINT "DIR$ demo. Change FileSpec$ to whatever you're looking for."
PRINT "Press a key to go on."
PRINT
DO: LOOP UNTIL INKEY$ <> ""
'
FileSpec$ = "*.bas"   'adjust this as appropriate
'
PRINT "Looking for "; FileSpec$
Found$ = DIR$(FileSpec$)      'check for the first file
'
'' Call DIR$ with a file name to initialise the routine.
'' Subsequent calls should be with a null string.
'
Count = 0
DO WHILE LEN(Found$)
  Count = Count + 1
  FileArray$(Count) = Found$  'Put the files into an array
  PRINT "Matching file is "; Found$
  IF Count MOD 23 = 0 THEN  'Simple "more" like pager
    Row = CSRLIN
    LOCATE 25, 1: PRINT "Press any key to continue";
    DO: LOOP UNTIL LEN(INKEY$)
    LOCATE Row + 1, 1
  END IF
  Found$ = DIR$("")  '' Notice the null filespec.

LOOP
                 'How many files do we have? 
PRINT : PRINT "Found "; Count; " matching files"
                 'Show a portion of the array, redundant
                 'because of the PRINT command above, but
                 'demonstrates that you can do it both ways
PRINT
FOR i = 5 TO 10
    IF FileArray$(i) <> "" THEN PRINT FileArray$(i)
NEXT
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
FUNCTION DIR$ (FileSpec$) STATIC
'
' Contributed by Ian Musgrave - Ian.Musgrave*med.monash.edu.au
'
DIM DTA AS STRING * 44 ', Regs AS RegTypeX
Null$ = CHR$(0)
'   
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
    
END FUNCTION

'
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

