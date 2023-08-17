'*********** DOS.BAS - demonstrates manipulating files directly using DOS

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION ErrMessage$ (ErrNumber)
DECLARE FUNCTION LocFile& (Handle)
DECLARE FUNCTION LofFile& (Handle)
DECLARE FUNCTION PeekWord% (BYVAL Segment, BYVAL Address)

DECLARE SUB ClipFile (Handle, NewLength&)
DECLARE SUB CloseFile (Handle)
DECLARE SUB FlushFile (Handle)
DECLARE SUB KillFile (FileName$)
DECLARE SUB LockFile (Handle, Location&, NumBytes&, Action)
DECLARE SUB OpenFile (FileName$, OpenMethod, Handle)
DECLARE SUB ReadFile (Handle, Segment, Address, NumBytes)
DECLARE SUB SeekFile (Handle, Location&, SeekMethod)
DECLARE SUB WriteFile (Handle, Segment, Address, NumBytes)


'$INCLUDE: 'REGTYPE.BI'

DIM SHARED Registers AS RegType 'so all can access it
DIM SHARED ErrCode              'ditto for the ErrCode
CRLF$ = CHR$(13) + CHR$(10)     'define this once now

COLOR 15, 1                     'this makes the DOS
CLS                             'messages high-intensity
COLOR 7, 1


'---- Open the test file we will use.
FileName$ = "C:\MYFILE.DAT"     'specify the file name
OpenMethod = 2                  'read/write non-shared
CALL OpenFile(FileName$, OpenMethod, Handle)
GOSUB HandleErr
PRINT FileName$; " successfully opened, handle:"; Handle


'---- Write a test message string to the file.
Msg$ = "This is a test message." + CRLF$
Segment = SSEG(Msg$)             'use this with BASIC PDS
'Segment = VARSEG(Msg$)          'use this with QuickBASIC
Address = SADD(Msg$)
NumBytes = LEN(Msg$)
CALL WriteFile(Handle, Segment, Address, NumBytes)
GOSUB HandleErr
PRINT "The test message was successfully written."


'---- Show how to write a numeric value.
IntData = 1234
Segment = VARSEG(IntData)
Address = VARPTR(IntData)
NumBytes = 2
CALL WriteFile(Handle, Segment, Address, NumBytes)
GOSUB HandleErr
PRINT "The integer variable was successfully written."


'---- See how large the file is now.
Length& = LofFile&(Handle)
GOSUB HandleErr
PRINT "The file is now"; Length&; "bytes long."


'---- Seek back to the beginning of the file.
Location& = 1                   'specify file offset 1
SeekMethod = 0                  'relative to beginning
CALL SeekFile(Handle, Location&, SeekMethod)
GOSUB HandleErr
PRINT "We successfully seeked back to the beginning."


'---- Ensure that the Seek worked by seeing where we are.
CurSeek& = LocFile&(Handle)
GOSUB HandleErr
PRINT "The DOS file pointer is now at location"; CurSeek&


'---- Read the test message back in again.
Buffer$ = SPACE$(23)            'the length of Msg$
Segment = SSEG(Buffer$)         'use this with BASIC PDS
'Segment = VARSEG(Buffer$)      'use this with QuickBASIC
Address = SADD(Buffer$)
NumBytes = LEN(Buffer$)
CALL ReadFile(Handle, Segment, Address, NumBytes)
GOSUB HandleErr
PRINT "Here is the test message: "; Buffer$


'---- Skip over the CRLF by reading it as an integer.
Address = VARPTR(Temp)          'read the CRLF into Temp
Segment = VARSEG(Temp)
NumBytes = 2
CALL ReadFile(Handle, Segment, Address, NumBytes)
GOSUB HandleErr


'---- Read the integer written earlier, also into Temp.
Address = VARPTR(Temp)
Segment = VARSEG(Temp)
NumBytes = 2
CALL ReadFile(Handle, Segment, Address, NumBytes)
GOSUB HandleErr
PRINT "The integer value just read is:"; Temp


'---- Append a new string at the end of the file.
Msg$ = "This is appended to the end of the file." + CRLF$
Segment = SSEG(Msg$)            'use this with BASIC PDS
'Segment = VARSEG(Msg$)         'use this with QuickBASIC
Address = SADD(Msg$)
NumBytes = LEN(Msg$)
CALL WriteFile(Handle, Segment, Address, NumBytes)
GOSUB HandleErr
PRINT "The appended message has been written, ";
PRINT "but it's still in the DOS file buffer."


'---- Flush the file's DOS buffer to disk.
CALL FlushFile(Handle)
GOSUB HandleErr
PRINT "Now the buffer has been flushed to disk.  ";
PRINT "Here's the file contents:"
SHELL "TYPE " + FileName$


'---- Display the current length of the file again.
PRINT "Before calling ClipFile the file is now";
Length& = LofFile&(Handle)
GOSUB HandleErr
PRINT Length&; "bytes long."


'---- Clip the file to be 2 bytes shorter.
NewLength& = LofFile&(Handle) - 2
CALL ClipFile(Handle, NewLength&)
PRINT "The file has been clipped successfully.  ";


'---- Prove that the clipping worked successfully.
Length& = LofFile&(Handle)
GOSUB HandleErr
PRINT "It is now"; Length&; "bytes long."


'---- Close the file.
CALL CloseFile(Handle)
GOSUB HandleErr
PRINT "The file was successfully closed."


'---- Open the file again, this time for shared access.
OpenMethod = 66                 'full sharing, read/write
CALL OpenFile(FileName$, OpenMethod, Handle)
GOSUB HandleErr
PRINT FileName$; " successfully opened in shared mode";
PRINT ", handle:"; Handle


'---- Lock bytes 50 through 59.
Start& = 50
Length& = 10
Action = 0                      'specify locking
CALL LockFile(Handle, Start&, Length&, Action)
GOSUB HandleErr
PRINT "File bytes 50 through 59 are successfully locked."


'---- Prove that it is locked by asking DOS to copy it.
PRINT "DOS (another process) fails to access the file:"
SHELL "COPY " + FileName$ + " NUL"


'---- Unlock the same range of bytes (mandatory).
Start& = 50
Length& = 10
Action = 1                      'specify unlocking
CALL LockFile(Handle, Start&, Length&, Action)
GOSUB HandleErr
PRINT "File bytes 50 through 59 successfully unlocked."


'---- Prove the unlocking worked by having DOS copy it.
PRINT "Once unlocked DOS can access the file:";
SHELL "COPY " + FileName$ + " NUL"


CloseIt:
'---- Close the file
CALL CloseFile(Handle)
GOSUB HandleErr
PRINT "The file was successfully closed, ";


'---- Kill the file to be polite
CALL KillFile(FileName$)
GOSUB HandleErr
PRINT "and then successfully deleted."

END


'=======================================
'  Error handler
'=======================================

HandleErr:
TempErr = DOSError%             'call DOSError only once
IF TempErr = 0 THEN RETURN      'return if no errors
PRINT ErrMessage$(TempErr)      'else print the message
IF TempErr = 1 THEN             'we failed trying to lock
  COLOR 7 + 16
  PRINT "SHARE must be installed to continue."
  COLOR 7
  RETURN CloseIt
ELSE                            'otherwise end
  END
END IF

SUB ClipFile (Handle, Length&) STATIC
  '-- Use SeekFile to seek there, and then call WriteFile
  '   specifying zero bytes to truncate it at that point.
  '   Length& + 1 is needed because we need to seek just
  '   PAST the point where the file is to be truncated.
  CALL SeekFile(Handle, Length& + 1, Zero)
  IF ErrCode THEN EXIT SUB    'exit if an error occurred
  CALL WriteFile(Handle, Dummy, Dummy, Zero)
END SUB

SUB CloseFile (Handle) STATIC
  ErrCode = 0                   'assume no errors
  Registers.AX = &H3E00         'close file service
  Registers.BX = Handle         'using this handle
  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN ErrCode = Registers.AX
END SUB

FUNCTION DOSError% STATIC

  DOSError% = ErrCode

END FUNCTION

FUNCTION ErrMessage$ (ErrNumber) STATIC
  SELECT CASE ErrNumber
    CASE 2
      ErrMessage$ = "File not found"
    CASE 3
      ErrMessage$ = "Path not found"
    CASE 4
      ErrMessage$ = "Too many files"
    CASE 5
      ErrMessage$ = "Access denied"
    CASE 6
      ErrMessage$ = "Invalid handle"
    CASE 61
      ErrMessage$ = "Disk full"
    CASE ELSE
      ErrMessage$ = "Undefined error: " + STR$(ErrNumber)
  END SELECT
END FUNCTION

SUB FlushFile (Handle) STATIC
  ErrCode = 0                   'assume no errors
  Registers.AX = &H4500         'create duplicate handle
  Registers.BX = Handle         'based on this handle
 
  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN 'an error, assign it
    ErrCode = Registers.AX
  ELSE                          'no error, so closing the
    TempHandle = Registers.AX   'dupe flushes the data
    CALL CloseFile(TempHandle)
  END IF
END SUB

SUB KillFile (FileName$) STATIC
  ErrCode = 0                      'assume no errors
  LocalName$ = FileName$ + CHR$(0) 'make an ASCIIZ string

  Registers.AX = &H4100            'delete file service
  Registers.DX = SADD(LocalName$)  'using this handle
  Registers.DS = SSEG(LocalName$)  'use this with PDS
 'Registers.DS = -1                'use this with QB

  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN ErrCode = Registers.AX

END SUB

FUNCTION LocFile& (Handle) STATIC
  ErrCode = 0               'assume no errors

  Registers.AX = &H4201     'seek to where we are now
  Registers.BX = Handle     'using this handle
  Registers.CX = 0          'move zero bytes from here
  Registers.DX = 0

  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN    'an error occurred
    ErrCode = Registers.AX
  ELSE                             'adjust to one-based
    LocFile& = (Registers.AX + (65536 * Registers.DX)) + 1
  END IF
END FUNCTION

SUB LockFile (Handle, Location&, NumBytes&, Action) STATIC
  ErrCode = 0                     'assume no errors
  LocalLoc& = Location& - 1       'adjust to zero-based

  Registers.AX = Action + (256 * &H5C)  'lock/unlock
  Registers.BX = Handle
  Registers.CX = PeekWord%(VARSEG(LocalLoc&), VARPTR(LocalLoc&) + 2)
  Registers.DX = PeekWord%(VARSEG(LocalLoc&), VARPTR(LocalLoc&))
  Registers.SI = PeekWord%(VARSEG(NumBytes&), VARPTR(NumBytes&) + 2)
  Registers.DI = PeekWord%(VARSEG(NumBytes&), VARPTR(NumBytes&))

  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN ErrCode = Registers.AX
END SUB

FUNCTION LofFile& (Handle)
  '---- first get and save the current file location
  CurLoc& = LocFile&(Handle) 'LocFile also clears ErrCode
  IF ErrCode THEN EXIT FUNCTION

  Registers.AX = &H4202      'seek to the end of the file
  Registers.BX = Handle      'using this handle
  Registers.CX = 0           'move zero bytes from there
  Registers.DX = 0

  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN  'an error occurred
    ErrCode = Registers.AX
    EXIT FUNCTION
  ELSE                           'assign where we are
    LofFile& = Registers.AX + (65536 * Registers.DX)
  END IF

  Registers.AX = &H4200     'seek to where we were before
  Registers.BX = Handle     'using this handle
  Registers.CX = PeekWord%(VARSEG(CurLoc&), VARPTR(CurLoc&) + 2)
  Registers.DX = PeekWord%(VARSEG(CurLoc&), VARPTR(CurLoc&))

  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN ErrCode = Registers.AX
END FUNCTION

SUB OpenFile (FileName$, Method, Handle) STATIC
 
  ErrCode = 0                      'assume no errors
  Registers.AX = Method + (256 * &H3D) 'open file service
  LocalName$ = FileName$ + CHR$(0) 'make an ASCIIZ string

DO
  Registers.DX = SADD(LocalName$)  'point to the name
  Registers.DS = SSEG(LocalName$)  'use this with PDS
 'Registers.DS = -1                'use this w/QuickBASIC

  CALL DOSInt(Registers)              'call DOS
  IF (Registers.Flags AND 1) = 0 THEN 'no errors
    Handle = Registers.AX             'assign the handle
    EXIT SUB                          'and we're all done
  END IF

  IF Registers.AX = 2 THEN         'File not found error
    Registers.AX = &H3C00          'so create it!
  ELSE
    ErrCode = Registers.AX         'read the code from AX
    EXIT SUB
  END IF
LOOP

END SUB

SUB ReadFile (Handle, Segment, Address, NumBytes) STATIC
  ErrCode = 0                   'assume no errors

  Registers.AX = &H3F00         'read from file service
  Registers.BX = Handle         'using this handle
  Registers.CX = NumBytes       'and this many bytes
  Registers.DX = Address        'read to this address
  Registers.DS = Segment        'and this segment

  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN ErrCode = Registers.AX
END SUB

SUB SeekFile (Handle, Location&, Method) STATIC
  ErrCode = 0                      'assume no errors
  LocalLoc& = Location& - 1        'adjust to zero-based

  Registers.AX = Method + (256 * &H42)
  Registers.BX = Handle
  Registers.CX = PeekWord%(VARSEG(LocalLoc&), VARPTR(LocalLoc&) + 2)
  Registers.DX = PeekWord%(VARSEG(LocalLoc&), VARPTR(LocalLoc&))

  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN ErrCode = Registers.AX
END SUB

SUB WriteFile (Handle, Segment, Address, NumBytes) STATIC
  ErrCode = 0                      'assume no errors
 
  Registers.AX = &H4000
  Registers.BX = Handle
  Registers.CX = NumBytes
  Registers.DX = Address
  Registers.DS = Segment

  CALL DOSInt(Registers)
  IF Registers.Flags AND 1 THEN
    ErrCode = Registers.AX
  ELSEIF Registers.AX <> Registers.CX THEN
    ErrCode = 61
  END IF
END SUB
