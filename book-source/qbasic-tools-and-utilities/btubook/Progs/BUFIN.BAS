'********* BUFIN.BAS - fast LINE INPUT replacement

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE FUNCTION BufIn$ (FileName$, Done)

LINE INPUT "Enter a file name: ", FileName$

Start! = TIMER
DO
   This$ = BufIn$(FileName$, Done)
LOOP UNTIL Done
Done! = TIMER
PRINT "Buffered input: "; Done! - Start!

Start! = TIMER
OPEN FileName$ FOR INPUT AS #1
DO
   LINE INPUT #1, This$
LOOP UNTIL EOF(1)
Done! = TIMER
PRINT " BASIC's INPUT: "; Done! - Start!
CLOSE
END

FUNCTION BufIn$ (FileName$, Done) STATIC

IF NOT Reading THEN            'if the first time through
  Reading = -1                 'show that we're now reading
  Done = 0                     'clear Done just in case
  CR = 0                       'no Return found yet
  CR$ = CHR$(13)               'define for speed later

  FileNum = FREEFILE           'open the file
  OPEN FileName$ FOR BINARY AS #FileNum
  Remaining& = LOF(FileNum)    'byte count to be read

  BufSize = 4096               'bytes to read each pass
  Buffer$ = SPACE$(BufSize)    'assume BufSize bytes
END IF

'---- This is the main outer loop.
DO WHILE Remaining&              'while more in the file

  IF CR = 0 THEN                 'if no Return was found
    IF Remaining& < BufSize THEN 'read only what remains
      BufSize = Remaining&       'resize the buffer
      IF BufSize < 1 THEN EXIT DO'possible only if EOF 26
      Buffer$ = SPACE$(BufSize)  'create the file buffer
    END IF
    GET #FileNum, , Buffer$      'read a block
    BufPos = 1                   'start at the beginning
  END IF                         '  of that block
 
  DO                                 'walk through buffer
    CR = INSTR(BufPos, Buffer$, CR$) 'look for a Return
    IF CR THEN                       'we found one
      SaveCR = CR                    'save where
      BufIn$ = MID$(Buffer$, BufPos, CR - BufPos)
      BufPos = CR + 2                'skip inevitable LF
      EXIT FUNCTION                  'all done for now
    ELSE                             'back up in the file
      '---- If we reached the end of the file and no 13
      '     was found, return what remains in the string.
      IF SEEK(FileNum) >= LOF(FileNum) THEN
        Output$ = MID$(Buffer$, SaveCR + 2)
        '---- Trap a trailing CHR$(26) EOF marker.
        IF RIGHT$(Output$, 1) = CHR$(26) THEN
          Output$ = LEFT$(Output$, LEN(Output$) - 1)
        END IF
        BufIn$ = Output$             'assign the function
        Remaining& = BufSize         'set to fall out
        EXIT DO                      'and exit now
      END IF
      Slop = BufSize - SaveCR - 1    'calc buffer excess
      Remaining& = Remaining& + Slop 'calc file excess
      SEEK #FileNum, SEEK(FileNum) - Slop  'seek to start
    END IF

  LOOP WHILE CR                'while more in buffer
  Remaining& = Remaining& - BufSize

LOOP

Reading = 0                    'we're not reading anymore
Done = -1                      'show that we're all done
CLOSE #FileNum                 'final cleanup

END FUNCTION
