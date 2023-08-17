'*********** CHAP11-6.BAS - demonstrates testing if a file exists

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
'$INCLUDE: 'REGTYPE.BI'

DIM Registers AS RegType

TYPE DTA                         'used by DOS services
  Reserved  AS STRING * 21       'reserved for use by DOS
  Attribute AS STRING * 1        'the file's attribute
  FileTime  AS STRING * 2        'the file's time
  FileDate  AS STRING * 2        'the file's date
  FileSize  AS LONG              'the file's size
  FileName  AS STRING * 13       'the file's name
END TYPE
DIM DTAData AS DTA


DEF FnFileExist% (Spec$)
  FnFileExist% = -1              'assume the file exists

  Registers.DX = VARPTR(DTAData) 'set a new DOS DTA
  Registers.DS = VARSEG(DTAData)
  Registers.AX = &H1A00
  CALL InterruptX(&H21, Registers, Registers)

  Spec$ = Spec$ + CHR$(0)        'DOS needs ASCIIZ string
  Registers.AX = &H4E00          'find file name service
  Registers.CX = 39              'attribute for any file
  Registers.DX = SADD(Spec$)     'show where the spec is
  Registers.DS = SSEG(Spec$)     'use this with PDS
 'Registers.DS = VARSEG(Spec$)   'use this with QB

  CALL InterruptX(&H21, Registers, Registers)
  IF Registers.Flags AND 1 THEN FnFileExist% = 0
END DEF


INPUT "Enter a file name or specification: ", FileSpec$
IF FnFileExist%(FileSpec$) THEN
   PRINT FileSpec$; " does exist"
ELSE
   PRINT "Sorry, no files match "; FileSpec$
END IF
