'*********** CHAP6-9.BAS - shows how to open more than 15 files

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB INTERRUPT (IntNum, InRegs AS ANY, OutRegs AS ANY)
DECLARE SUB MoreFiles (NumFiles)
DECLARE FUNCTION DOSVer% ()

'NOTE: DOS uses file handles 0 through 4 for its own use.  Therefore, when
'increasing the available number of files the extra five must be accounted
'for.  This is handled in the code where +5 is used in two places.  Also,
'DOS has to allocate memory to hold the additional file handle information,
'so that's why SETMEM is used in the MoreFiles subprogram.

TYPE RegType
  AX     AS INTEGER
  BX     AS INTEGER
  CX     AS INTEGER
  DX     AS INTEGER
  BP     AS INTEGER
  SI     AS INTEGER
  DI     AS INTEGER
  Flags  AS INTEGER
END TYPE
DIM SHARED InRegs AS RegType, OutRegs AS RegType

ComSpec$ = ENVIRON$("COMSPEC")
BootDrive$ = LEFT$(ComSpec$, 2)
OPEN BootDrive$ + "\CONFIG.SYS" FOR INPUT AS #1
  DO WHILE NOT EOF(1)
    LINE INPUT #1, Work$
    Work$ = UCASE$(Work$)
    IF LEFT$(Work$, 6) = "FILES=" THEN
      FilesVal = VAL(MID$(Work$, 7))
      EXIT DO
    END IF
  LOOP
CLOSE

INPUT "How many files? ", NumFiles
IF NumFiles + 5 > FilesVal THEN
  PRINT "Increase the FILES= setting in CONFIG.SYS"
  END
END IF

IF DOSVer% >= 330 THEN
  CALL MoreFiles(NumFiles)
ELSE
  PRINT "Sorry, DOS 3.3 or later is required."
END IF

FOR X = 1 TO NumFiles
  OPEN "FTEST" + LTRIM$(STR$(X)) FOR RANDOM AS #X
NEXT
CLOSE
KILL "FTEST*."

FUNCTION DOSVer% STATIC
  InRegs.AX = &H3000
  CALL INTERRUPT(&H21, InRegs, OutRegs)
  Major = OutRegs.AX AND &HFF
  Minor = OutRegs.AX \ &H100
  DOSVer% = Minor + 100 * Major
END FUNCTION

SUB MoreFiles (NumFiles) STATIC
  Dummy& = SETMEM(-1000)
  InRegs.AX = &H6700
  InRegs.BX = NumFiles + 5
  CALL INTERRUPT(&H21, InRegs, OutRegs)
  Dummy& = SETMEM(1000)
END SUB

