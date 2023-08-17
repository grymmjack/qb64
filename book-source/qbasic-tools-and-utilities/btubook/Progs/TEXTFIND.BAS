'*********** TEXTFIND.BAS - finds text in a group of files

'Copyright (c) 1992 by Ethan Winer

'If you are using QBX version 7.1 beware of a nasty bug: After running this
'program QBX will hang if you cut and then paste any text.  To prove the bug
'is in QBX and not in this program, do the following:
'
'  1. Load this program and QBX.QLB using QBX TEXTFIND /L.
'  2. Press F10 once to Execute to the first DIM statement.
'  3. Go to line 53 and delete the code FNMax% = Value1.
'  4. Go to the end of the line above and press Enter.
'  5. Press the space bar twice, and then press Ctrl-Insert.
'  6. Press the down arrow key once and then Delete; QBX is now hung!

DEFINT A-Z

TYPE RegTypeX                   'used by CALL INTERRUPTX
  AX    AS INTEGER
  BX    AS INTEGER
  CX    AS INTEGER
  DX    AS INTEGER
  BP    AS INTEGER
  SI    AS INTEGER
  DI    AS INTEGER
  Flags AS INTEGER
  DS    AS INTEGER
  ES    AS INTEGER
END TYPE
DIM Registers AS RegTypeX       'holds the CPU registers

TYPE DTA                        'used by DOS services
  Reserved  AS STRING * 21      'reserved for use by DOS
  Attribute AS STRING * 1       'the file's attribute
  FileTime  AS STRING * 2       'the file's time
  FileDate  AS STRING * 2       'the file's date
  FileSize  AS LONG             'the file's size
  FileName  AS STRING * 13      'the file's name
END TYPE
DIM DTAData AS DTA

DECLARE SUB InterruptX (IntNumber, InRegs AS RegTypeX, OutRegs AS RegTypeX)

CONST MaxFiles% = 1000
CONST BufMax% = 4096

REDIM Array$(1 TO MaxFiles%)    'holds the file names
Zero$ = CHR$(0)                 'do this once for speed

'----- This function returns the larger of two integers.
DEF FNMax% (Value1, Value2)
  FNMax% = Value1
  IF Value2 > Value1 THEN FNMax% = Value2
END DEF

'----- This function loads a group of file names.
DEF FNLoadNames%

  STATIC Count

  '---- define a new Data Transfer Area for DOS
  Registers.DX = VARPTR(DTAData)
  Registers.DS = VARSEG(DTAData)
  Registers.AX = &H1A00
  CALL InterruptX(&H21, Registers, Registers)

  Count = 0                  'zero the file counter
  Spec$ = Spec$ + Zero$      'DOS needs ASCIIZ strings
  Registers.DX = SADD(Spec$) 'show where the spec is
  Registers.DS = SSEG(Spec$)    'use this with PDS
 'Registers.DS = VARSEG(Spec$)  'use this with QB
  Registers.CX = 39          'the attribute for any file
  Registers.AX = &H4E00      'find file name service

  '---- Read the file names that match the search
  '     specification.  The Flags registers indicates
  '     when no more matching files are found.  Copy
  '     each file name to the string array.  Service
  '     &H4F is used to continue the search started
  '     with service &H4E using the same file spec.
  DO
    CALL InterruptX(&H21, Registers, Registers)
    IF Registers.Flags AND 1 THEN EXIT DO
    Count = Count + 1
    Array$(Count) = DTAData.FileName
    Registers.AX = &H4F00
  LOOP WHILE Count < MaxFiles%

  FNLoadNames% = Count       'return the number of files

END DEF

'----- The main body of the program begins here.
PRINT "TEXTFIND Copyright (c) 1991, Ziff-Davis Press."
PRINT

'---- Get the file specification,or prompt for one
'     if it wasn't given.
Spec$ = COMMAND$
IF LEN(Spec$) = 0 THEN
  PRINT "Enter a file specification: ";
  INPUT "", Spec$
END IF

'----- Ask for the search string to find.
PRINT "    Enter the text to find: ";
INPUT Find$
PRINT

Find$ = UCASE$(Find$)        'ignore capitalization
FindLength = LEN(Find$)      'see how long Find$ is
IF FindLength = 0 THEN END

Count = FNLoadNames%         'load the file names
IF Count = 0 THEN
  PRINT "No matching files"
  END
END IF

'----- Isolate the drive and path if given by searching
'      for the ASCII values 58 and 92.
FOR X = LEN(Spec$) TO 1 STEP -1
  Char = ASC(MID$(Spec$, X))
  IF Char = 58 OR Char = 92 THEN
    Path$ = LEFT$(UCASE$(Spec$), X)
    EXIT FOR
  END IF
NEXT

FOR X = 1 TO Count           'for each matching file
  Array$(X) = LEFT$(Array$(X), INSTR(Array$(X), Zero$) - 1)
  PRINT "Reading "; Path$; Array$(X)
  OPEN Path$ + Array$(X) FOR BINARY AS #1
  Length& = LOF(1)           'get and save its length
  IF Length& < FindLength GOTO NextFile
   
  BufSize = BufMax%          'assume a 4K text buffer
  IF BufSize > Length& THEN BufSize = Length&
  Buffer$ = SPACE$(BufSize)  'create the file buffer

  LastSeek& = 1              'seed the SEEK location
  BaseAddr& = 1              'and the starting offset
  Bytes = 0                  'how many bytes to search

  DO                         'the file read loop
     BaseAddr& = BaseAddr& + Bytes 'track block start
     IF Length& - LastSeek& + 1 >= BufSize THEN
       Bytes = BufSize       'at least BufSize bytes left
     ELSE                    'get just what remains
       Bytes = Length& - LastSeek& + 1
       Buffer$ = SPACE$(Bytes) 'adjust the buffer size
     END IF

     SEEK #1, LastSeek&      'seek back in the file
     GET #1, , Buffer$       'read a chunk of the file

     Start = 1               'this is the INSTR loop for
     DO                      'searching within the buffer
       Found = INSTR(Start, UCASE$(Buffer$), Find$)
       IF Found THEN         'print it in context
         Start = Found + 1   'to resume using INSTR later
         PRINT               'add a blank line for clarity
         PRINT MID$(Buffer$, FNMax%(1, Found - 20), FindLength + 40)
         PRINT
           
         PRINT "Continue searching "; Array$(X);
         PRINT "? (Yes/No/Skip): ";
         WHILE INKEY$ <> "": WEND   'clear kbrd buffer
         DO
           KeyHit$ = UCASE$(INKEY$) 'then get a response
         LOOP UNTIL KeyHit$ = "Y" OR KeyHit$ = "N" OR KeyHit$ = "S"
         PRINT KeyHit$              'echo the letter
         PRINT

         IF KeyHit$ = "N" THEN      '"No"
           END                      'end the program
         ELSEIF KeyHit$ = "S" THEN  '"Skip"
           GOTO NextFile            'go to the next file
         END IF

       END IF
                                    'search for multiple hits
     LOOP WHILE Found               'within the file buffer

     IF Bytes = BufSize THEN        'still more file to examine
       '---- Back up a bit in case Find$ is there but
       '     straddling the buffer boundary.  Then update
       '     the internal SEEK pointer.
       BaseAddr& = BaseAddr& - FindLength
       LastSeek& = BaseAddr& + Bytes
     END IF

  LOOP WHILE Bytes = BufSize AND BufSize = BufMax%

NextFile:
  CLOSE #1
  Buffer$ = ""               'clear the buffer for later

NEXT

