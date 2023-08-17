'********** FILESORT.BAS - indexed multi-key sort for random access files

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

DECLARE FUNCTION Compare3% (BYVAL Seg1, BYVAL Adr1, BYVAL Seg2, BYVAL Adr2, NumBytes)
DECLARE FUNCTION Exist% (FileSpec$)
DECLARE SUB DOSInt (Registers AS ANY)
DECLARE SUB FileSort (FileName$, NDXName$, RecLength, Offset, KeySize)
DECLARE SUB LoadFile (FileNum, Segment, Address, Bytes&)
DECLARE SUB SaveFile (FileNum, Segment, Address, Bytes&)
DECLARE SUB SwapMem (BYVAL Seg1, BYVAL Adr1, BYVAL Seg2, BYVAL Adr2, BYVAL Length)
DECLARE SUB TypeISort (Segment, Address, ElSize, Offset, KeySize, NumEls, Index())

RANDOMIZE TIMER                 'create new data each run
DEF FnRand% = INT(RND * 10 + 1) 'returns RND from 1 to 10

TYPE RegType                    'used by DOSInt
  AX AS INTEGER
  BX AS INTEGER
  CX AS INTEGER
  DX AS INTEGER
  BP AS INTEGER
  SI AS INTEGER
  DI AS INTEGER
  FL AS INTEGER
  DS AS INTEGER
  ES AS INTEGER
END TYPE

DIM SHARED Registers AS RegType 'share among all subs
REDIM LastNames$(1 TO 10)       'we'll select names at
REDIM FirstNames$(1 TO 10)      '  random from these

NumRecords = 2988           'how many test records to use
FileName$ = "TEST.DAT"      'really original, eh?
NDXName$ = "TEST.NDX"       'this is the index file name

TYPE RecType
  LastName  AS STRING * 11
  FirstName AS STRING * 10
  Dollars   AS STRING * 6
  Cents     AS STRING * 2
  AnyNumber AS LONG         'just to show that only key
  OtherNum  AS LONG         '  information must be ASCII
END TYPE

FOR X = 1 TO 10             'read the possible last names
  READ LastNames$(X)
NEXT

FOR X = 1 TO 10             'and the possible first names
  READ FirstNames$(X)
NEXT

DIM RecordVar AS RecType    'to create the sample file
RecLength = LEN(RecordVar)  'the length of each record
CLS
PRINT "Creating a test file..."

IF Exist%(FileName$) THEN   'if there's an existing file
  KILL FileName$            'kill the old data from prior
END IF                      '  runs to start fresh

IF Exist%(NDXName$) THEN    'same for any old index file
  KILL NDXName$
END IF


'---- Create some test data and write it to the file
OPEN FileName$ FOR RANDOM AS #1 LEN = RecLength
  FOR X = 1 TO NumRecords
    RecordVar.LastName = LastNames$(FnRand%)
    RecordVar.FirstName = FirstNames$(FnRand%)
    Amount$ = STR$(RND * 10000)
    Dot = INSTR(Amount$, ".")
    IF Dot THEN
      RSET RecordVar.Dollars = LEFT$(Amount$, Dot - 1)
      RecordVar.Cents = LEFT$(MID$(Amount$, Dot + 1) + "00", 2)
    ELSE
      RSET RecordVar.Dollars = Amount$
      RecordVar.Cents = "00"
    END IF
    RecordVar.AnyNumber = X
    PUT #1, , RecordVar
  NEXT
CLOSE

'----- Created a sorted index based on the main data file
Offset = 1                  'start sorting with LastName
KeySize = 29                'sort based on first 4 fields
PRINT "Sorting..."
CALL FileSort(FileName$, NDXName$, RecLength, Offset, KeySize)


'----- Display the results
CLS
VIEW PRINT 1 TO 24
LOCATE 25, 1
COLOR 15
PRINT "Press any key to pause/resume";
COLOR 7
LOCATE 1, 1

OPEN FileName$ FOR RANDOM AS #1 LEN = RecLength
OPEN NDXName$ FOR BINARY AS #2
  FOR X = 1 TO NumRecords
    GET #2, , ThisRecord        'get next record number
    GET #1, ThisRecord, RecordVar   'then the actual data

    PRINT RecordVar.LastName;       'print each field
    PRINT RecordVar.FirstName;
    PRINT RecordVar.Dollars; ".";
    PRINT RecordVar.Cents

    IF LEN(INKEY$) THEN             'pause on a keypress
      WHILE LEN(INKEY$) = 0: WEND
    END IF
  NEXT
CLOSE

VIEW PRINT 1 TO 24                  'restore the screen
END

DATA Smith, Cramer, Malin, Munro, Passarelli
DATA Bly, Osborn, Pagliaro, Garcia, Winer

DATA John, Phil, Paul, Anne, Jacki
DATA Patricia, Ethan, Donald, Tami, Elli

FUNCTION Exist% (Spec$) STATIC  'reports if a file exists

DIM DTA AS STRING * 44          'the work area for DOS
DIM LocalSpec AS STRING * 60    'guarantee the spec is in
LocalSpec$ = Spec$ + CHR$(0)    '  DGROUP for BASIC PDS

Exist% = -1                     'assume true for now

Registers.AX = &H1A00           'assign DTA service
Registers.DX = VARPTR(DTA)      'show DOS where to place it
Registers.DS = VARSEG(DTA)
CALL DOSInt(Registers)

Registers.AX = &H4E00           'find first matching file
Registers.CX = 39               'any file attribute okay
Registers.DX = VARPTR(LocalSpec)
Registers.DS = VARSEG(LocalSpec)
CALL DOSInt(Registers)          'see if there's a match
 
IF Registers.FL AND 1 THEN      'if the Carry flag is set
  Exist% = 0                    '  there were no matches
END IF

END FUNCTION

SUB FileSort (FileName$, NDXName$, RecLength, Displace, KeySize) STATIC

CONST BufSize% = 32767  'holds the data being sorted
Offset = Displace - 1   'make zero-based for speed later

'----- Open the main data file
FileNum = FREEFILE
OPEN FileName$ FOR BINARY AS #FileNum

'----- Calculate the important values we'll need
NumRecords = LOF(FileNum) \ RecLength
RecsPerPass = BufSize% \ RecLength
IF RecsPerPass > NumRecords THEN RecsPerPass = NumRecords

NumPasses = (NumRecords \ RecsPerPass) - ((NumRecords MOD RecsPerPass) <> 0)
IF NumPasses = 1 THEN
  RecsLastPass = RecsPerPass
ELSE
  RecsLastPass = NumRecords MOD RecsPerPass
END IF

'----- Create the buffer and index sorting arrays
REDIM Buffer(1 TO 1) AS STRING * BufSize
REDIM Index(1 TO RecsPerPass)
IndexAdjust = 1


'----- Process all of the records in manageable groups
FOR X = 1 TO NumPasses

  IF X < NumPasses THEN         'if not the last pass
    RecsThisPass = RecsPerPass  'do the full complement
  ELSE                          'the last pass may have
    RecsThisPass = RecsLastPass '  fewer records to do
  END IF

  FOR Y = 1 TO RecsThisPass     'initialize the index
    Index(Y) = Y - 1            'starting with value of 0
  NEXT

  '----- Load a portion of the main data file
  Segment = VARSEG(Buffer(1))   'show where the buffer is
  CALL LoadFile(FileNum, Segment, Zero, RecsThisPass * CLNG(RecLength))
  CALL TypeISort(Segment, Zero, RecLength, Displace, KeySize, RecsThisPass, Index())

  '----- Adjust the zero-based index to record numbers
  FOR Y = 1 TO RecsThisPass
    Index(Y) = Index(Y) + IndexAdjust
  NEXT
 
  '----- Save the index file for this pass
  TempNum = FREEFILE
  OPEN "$$PASS." + LTRIM$(STR$(X)) FOR OUTPUT AS #TempNum
  CALL SaveFile(TempNum, VARSEG(Index(1)), Zero, RecsThisPass * 2&)
  CLOSE #TempNum
 
  '----- The next group of record numbers start this much higher
  IndexAdjust = IndexAdjust + RecsThisPass

NEXT

ERASE Buffer, Index             'free up the memory


'----- Do a final merge pass if necessary
IF NumPasses > 1 THEN

  NDXNumber = FREEFILE
  OPEN NDXName$ FOR BINARY AS #NDXNumber
  REDIM FileNums(NumPasses)             'this holds the file numbers
  REDIM RecordNums(NumPasses)           'and this holds the record numbers

  REDIM MainRec$(1 TO NumPasses)        'this holds the main record data
  REDIM Remaining(1 TO NumPasses)       'this tracks reading the index files
 
  '----- Open the files and seed the first round of data
  FOR X = 1 TO NumPasses
    FileNums(X) = FREEFILE
    OPEN "$$PASS." + LTRIM$(STR$(X)) FOR BINARY AS #FileNums(X)
    Remaining(X) = LOF(FileNums(X))     'this is what remains
    MainRec$(X) = SPACE$(RecLength)     'load the main data records here

    GET #FileNums(X), , RecordNums(X)   'get the next record number
    RecOffset& = (RecordNums(X) - 1) * CLNG(RecLength) + 1
    GET #FileNum, RecOffset&, MainRec$(X) 'and then get the actual data
  NEXT

  FOR X = 1 TO NumRecords

    Lowest = 1                  'assume this is the "lowest" data in the group
    WHILE Remaining(Lowest) = 0 'Lowest can't refer to a dead index
      Lowest = Lowest + 1       'so seek to the next higher active index
    WEND

    FOR Y = 2 TO NumPasses      'now seek out the truly lowest element
      IF Remaining(Y) THEN      'consider only active indexes
        IF Compare3%(SSEG(MainRec$(Y)), SADD(MainRec$(Y)) + Offset, SSEG(MainRec$(Lowest)), SADD(MainRec$(Lowest)) + Offset, KeySize) = -1 THEN
          Lowest = Y ' ^ ------ use VARSEG here with QuickBASIC ------^
        END IF
      END IF
    NEXT

    PUT #NDXNumber, , RecordNums(Lowest)        'write to master index file
     
    Remaining(Lowest) = Remaining(Lowest) - 2   'this much less remains
    IF Remaining(Lowest) THEN                       'if index is still active
      GET #FileNums(Lowest), , RecordNums(Lowest)   'get the record number
      RecOffset& = (RecordNums(Lowest) - 1) * CLNG(RecLength) + 1
      GET #FileNum, RecOffset&, MainRec$(Lowest)    'then get the actual data
    END IF

  NEXT
 
ELSE
  '----- Only one pass was needed so simply rename the index file
  NAME "$$PASS.1" AS NDXName$
END IF

CLOSE                                   'close all open files

IF Exist%("$$PASS.*") THEN              'ensure there's something to kill
  KILL "$$PASS.*"                       'kill the work files
END IF

ERASE FileNums, RecordNums              'erase the work arrays
ERASE MainRec$, Remaining

END SUB

SUB LoadFile (FileNum, Segment, Address, Bytes&) STATIC

  IF Bytes& > 32767 THEN Bytes& = Bytes& - 65536

  Registers.AX = &H3F00         'read from file service
  Registers.BX = FILEATTR(FileNum, 2) 'get the DOS handle
  Registers.CX = Bytes&         'how many bytes to load
  Registers.DX = Address        'and at what address
  Registers.DS = Segment        'and at what segment

  CALL DOSInt(Registers)

END SUB

SUB SaveFile (FileNum, Segment, Address, Bytes&) STATIC

  IF Bytes& > 32767 THEN Bytes& = Bytes& - 65536

  Registers.AX = &H4000         'write to file service
  Registers.BX = FILEATTR(FileNum, 2) 'get the DOS handle
  Registers.CX = Bytes&         'how many bytes to load
  Registers.DX = Address        'and at what address
  Registers.DS = Segment        'and at what segment

  CALL DOSInt(Registers)

END SUB

SUB TypeISort (Segment, Address, ElSize, Displace, KeySize, NumEls, Index()) STATIC

REDIM QStack(NumEls \ 5 + 10)   'create a stack

First = 1                       'initialize working variables
Last = NumEls
Offset = Displace - 1           'make zero-based now for speed later

DO
  DO
    Temp = (Last + First) \ 2   'seek midpoint
    I = First
    J = Last

    DO          'change -1 to 1 and 1 to -1 below to sort descending
      WHILE Compare3%(Segment, Address + Offset + (Index(I) * ElSize), Segment, Address + Offset + (Index(Temp) * ElSize), KeySize) = -1
        I = I + 1
      WEND
      WHILE Compare3%(Segment, Address + Offset + (Index(J) * ElSize), Segment, Address + Offset + (Index(Temp) * ElSize), KeySize) = 1
        J = J - 1
      WEND
      IF I > J THEN EXIT DO
      IF I < J THEN
        SWAP Index(I), Index(J)
        IF Temp = I THEN
          Temp = J
        ELSEIF Temp = J THEN
          Temp = I
        END IF
      END IF
      I = I + 1
      J = J - 1
    LOOP WHILE I <= J

    IF I < Last THEN
      QStack(StackPtr) = I             'Push I
      QStack(StackPtr + 1) = Last      'Push Last
      StackPtr = StackPtr + 2
    END IF

    Last = J
  LOOP WHILE First < Last

  IF StackPtr = 0 THEN EXIT DO          'Done
  StackPtr = StackPtr - 2
  First = QStack(StackPtr)              'Pop First
  Last = QStack(StackPtr + 1)           'Pop Last
LOOP

ERASE QStack                    'delete the stack array

END SUB
