'*********** CHAP11-8.BAS - demonstrates reading file names to an array

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB LoadNames (FileSpec$, Array$(), Attribute%)

'$INCLUDE: 'REGTYPE.BI'

TYPE DTA                        'used by find first/next
  Reserved  AS STRING * 21      'reserved for use by DOS
  Attribute AS STRING * 1       'the file's attribute
  FileTime  AS STRING * 2       'the file's time
  FileDate  AS STRING * 2       'the file's date
  FileSize  AS LONG             'the file's size
  FileName  AS STRING * 13      'the file's name
END TYPE

DIM SHARED DTAData AS DTA       'shared so LoadNames can
DIM SHARED Registers AS RegType '  access them too


DEF FnFileCount% (Spec$, Attribute)

  STATIC Count                   'make this private

  Registers.DX = VARPTR(DTAData) 'set new DTA address
  Registers.DS = -1              'the DTA is in DGROUP
  Registers.AX = &H1A00          'specify service 1Ah
  CALL DOSInt(Registers)         'DOS set DTA service

  Count = 0                      'clear the counter
  Spec$ = Spec$ + CHR$(0)        'make an ASCIIZ string
  IF Attribute AND 16 THEN       'find directory names?
    DirFlag = -1                 'yes
  ELSE
    DirFlag = 0                  'no
  END IF

  Registers.DX = SADD(Spec$)     'the file spec address
  Registers.DS = SSEG(Spec$)     'this is for BASIC PDS
 'Registers.DS = -1              'this is for QuickBASIC
  Registers.CX = Attribute       'assign the attribute
  Registers.AX = &H4E00          'find first matching name

  DO
    CALL DOSInt(Registers)                        'see if there's a match
    IF Registers.Flags AND 1 THEN EXIT DO         'no more
    IF DirFlag THEN                               'do they want directories?
      IF ASC(DTAData.Attribute) AND 16 THEN       'is it a directory?
        IF LEFT$(DTAData.FileName, 1) <> "." THEN 'filter "." and ".."
          Count = Count + 1                       'increment the counter
        END IF
      END IF
    ELSE
      Count = Count + 1                           'they want regular files
    END IF

    Registers.AX = &H4F00        'find next name
  LOOP

  FnFileCount% = Count           'assign the function

END DEF


REDIM Names$(1 TO 1)             'create a dynamic arrray
Attribute = 19                   'this matches directories only
Attribute = 39                   'this matches all files

INPUT "Enter a file specification: ", Spec$
CALL LoadNames(Spec$, Names$(), Attribute)

FOR X = LEN(Spec$) TO 1 STEP -1  'isolate the drive/path
  Temp = ASC(MID$(Spec$, X, 1))
  IF Temp = 58 OR Temp = 92 THEN '":" or "\"
    Path$ = LEFT$(Spec$, X)      'keep what precedes that
    EXIT FOR                     'and we're all done
  END IF
NEXT

FOR X = 1 TO UBOUND(Names$)      'print the names
  PRINT Path$; Names$(X)
NEXT

PRINT
IF LEN(Names$(1)) THEN           'if any were found
  PRINT UBOUND(Names$); "matching file(s)"
ELSE
  PRINT "No files matched "; Spec$
END IF

SUB LoadNames (FileSpec$, Array$(), Attribute) STATIC

  Spec$ = FileSpec$ + CHR$(0)               'make an ASCIIZ string
  NumFiles = FnFileCount%(Spec$, Attribute) 'count the names
  IF NumFiles = 0 THEN EXIT SUB             'exit if none
  REDIM Array$(1 TO NumFiles)    'dimension the array

  IF Attribute AND 16 THEN       'find directory names?
    DirFlag = -1                 'yes
  ELSE
    DirFlag = 0                  'no
  END IF
 
  '---- The following code isn't strictly necessary because we
  '     know that FnFileCount already set the DTA address.
 'Registers.DX = VARPTR(DTAData) 'set new DTA address
 'Registers.DS = -1              'the DTA in DGROUP
 'Registers.AX = &H1A00          'specify service 1Ah
 'CALL DOSInt(Registers)         'DOS set DTA service

  Registers.DX = SADD(Spec$)     'the file spec address
  Registers.DS = SSEG(Spec$)     'this is for BASIC PDS
 'Registers.DS = -1              'this is for QuickBASIC
  Registers.CX = Attribute       'assign the attribute
  Registers.AX = &H4E00          'find first matching name
  Count = 0                      'clear the counter
 
  DO
    CALL DOSInt(Registers)                        'see if there's a match
    IF Registers.Flags AND 1 THEN EXIT DO         'no more
    Valid = 0                                     'assume invalid
    IF DirFlag THEN                               'do they want directories?
      IF ASC(DTAData.Attribute) AND 16 THEN       'is it a directory?
        IF LEFT$(DTAData.FileName, 1) <> "." THEN 'filter "." and ".."
          Valid = -1                              'this name is valid
        END IF
      END IF
    ELSE
      Valid = -1                                  'they want regular files
    END IF

    IF Valid THEN                                 'process the file if it
      Count = Count + 1                           '  passed all the tests
      Zero = INSTR(DTAData.FileName, CHR$(0))           'find the zero byte
      Array$(Count) = LEFT$(DTAData.FileName, Zero - 1) 'assign the name
    END IF
    Registers.AX = &H4F00        'find next matching name service
  LOOP

END SUB
