'********** CHAP10-1.BAS - demonstrates various low memory access

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE FUNCTION Bin% (Bit$)
DECLARE FUNCTION PeekWord% (BYVAL Segment, BYVAL Address)
DECLARE SUB PokeWord (BYVAL Segment, BYVAL Address, BYVAL Value)

CLS
READ NumTests
FOR X = 1 TO NumTests
  READ TestTitle$
  LOCATE X + 5, 20, 1
  PRINT X; TestTitle$
NEXT
DATA 9
DATA Swap serial ports, Swap parallel ports, Test for coprocessor
DATA Count diskette drives, Count serial and parallel ports
DATA Test keyboard flags, Toggle CapsLock, Examine keyboard
DATA Extend drive motor duration

PRINT : PRINT TAB(20); "Which test do you want? (Q to Quit): ";

DO
  Choice$ = UCASE$(INPUT$(1))
  IF Choice$ = "Q" THEN END
  Choice = VAL(Choice$)
LOOP WHILE Choice = 0 OR Choice > NumTests
PRINT : PRINT : PRINT
ON Choice GOTO Test1, Test2, Test3, Test4, Test5, Test6, Test7, Test8, Test9


Test1:
'----- exchange COM1 and COM3
Com1 = PeekWord%(0, &H400)
Com3 = PeekWord%(0, &H404)
CALL PokeWord(0, &H400, Com3)
CALL PokeWord(0, &H404, Com1)

OPEN "Com1:1200,n,8,1,rs,ds" FOR RANDOM AS #1
PRINT #1, "ATDT 1-555-1212"
CLOSE

CALL PokeWord(0, &H400, Com1)
CALL PokeWord(0, &H404, Com3)
END



Test2:
'----- exchange LPT1 and LPT2

Lpt1 = PeekWord%(0, &H408)
Lpt2 = PeekWord%(0, &H40A)
CALL PokeWord(0, &H408, Lpt2)
CALL PokeWord(0, &H40A, Lpt1)

LPRINT "This is printed on LPT2:"

CALL PokeWord(0, &H408, Lpt1)
CALL PokeWord(0, &H40A, Lpt2)

LPRINT "And now we're back to LPT1:"
END



Test3:
'----- see if a coprocessor is installed

IF PeekWord%(0, &H410) AND 2 THEN
  PRINT "A coprocessor is installed."
ELSE
  PRINT "Sorry, no coprocessor detected."
END IF
END



Test4:
'----- See how many floppy drives there are

Equipment = PeekWord%(0, &H410)
Floppies = 1 + (Equipment AND Bin%("11000000")) \ 64
PRINT Floppies; "floppy drive(s) installed"
END



Test5:
'----- See how many serial and parallel ports there are

Equipment = PeekWord%(0, &H410)
Serial = (Equipment AND Bin%("11000000000")) \ 512
PRINT Serial; "serial port(s) installed"

IF Equipment AND Bin%("1000000000000000") THEN
  HiBitSet = -1
END IF
Parallel = (Equipment AND Bin%("0100000000000000")) \ 16384
IF HiBitSet THEN Parallel = Parallel + 2
PRINT Parallel; "parallel port(s) installed"

TotalMem = PeekWord%(0, &H413)
PRINT TotalMem; "KBytes are present"
END



Test6:
CLS
LOCATE , , 0
PRINT "Press the various Shift and Lock keys, ";
PRINT "then press Escape to end this madness."
COLOR 0, 7

DO
  Status = PeekWord%(0, &H417)

  LOCATE 10, 1
  IF Status AND 1 THEN
    PRINT "RightShift"
  ELSE
    GOSUB ClearIt
  END IF

  LOCATE 10, 11
  IF Status AND 2 THEN
    PRINT "Left Shift"
  ELSE
    GOSUB ClearIt
  END IF
   
  LOCATE 10, 21
  IF Status AND 4 THEN
    PRINT "Ctrl key"
  ELSE
    GOSUB ClearIt
  END IF

  LOCATE 10, 31
  IF Status AND 8 THEN
    PRINT "Alt key"
  ELSE
    GOSUB ClearIt
  END IF
  
  LOCATE 10, 41
  IF Status AND 16 THEN
    PRINT "ScrollLock"
  ELSE
    GOSUB ClearIt
  END IF

  LOCATE 10, 51
  IF Status AND 32 THEN
    PRINT "Num Lock"
  ELSE
    GOSUB ClearIt
  END IF

  LOCATE 10, 61
  IF Status AND 64 THEN
    PRINT "Caps Lock"
  ELSE
    GOSUB ClearIt
  END IF
   
  LOCATE 10, 71
  IF Status AND 128 THEN
    PRINT "Insert"
  ELSE
    GOSUB ClearIt
  END IF

LOOP UNTIL INKEY$ = CHR$(27)
COLOR 7, 0
END

ClearIt:
  COLOR 7, 0
  PRINT SPACE$(10);
  COLOR 0, 7
  RETURN



Test7:
CurStatus = PeekWord%(0, &H417)             'get current status
NewStatus = CurStatus OR Bin%("1000000")    'turn on CapsLock
CALL PokeWord(0, &H417, NewStatus)          'update the status
PRINT "Press a key to turn off CapsLock"

WHILE INKEY$ = "": WEND
NewStatus = NewStatus AND Bin%("10111111")  'turn off CapsLock
CALL PokeWord(0, &H417, NewStatus)
END



Test8:
CLS
PRINT "You have two seconds to press a few keys..."
Pause! = TIMER
WHILE Pause! + 2 > TIMER: WEND

BufferHead = PeekWord%(0, &H41A)
BufferTail = PeekWord%(0, &H41C)

NumKeys = (BufferTail - BufferHead) \ 2
IF NumKeys < 0 THEN NumKeys = NumKeys + 16
PRINT "There are"; NumKeys; "keys pending in the buffer."

PRINT "The next key waiting to be read is ";
NextKey = PeekWord%(&H40, BufferHead)
IF NextKey AND &HFF THEN
  PRINT CHR$(34); CHR$(NextKey AND &HFF); CHR$(34)
ELSE
  PRINT "Extended key scan code"; NextKey \ 256
END IF
END



Test9:
CLS
PRINT "Place a diskette in drive A and press a key ";
WHILE INKEY$ = "": WEND
LOCATE , , 0

FILES "A:*.*"

DEF SEG = 0
POKE &H440, 91  'force drive motor on for five seconds

DO
  LOCATE 10, 1
  PRINT PEEK(&H43F),
  PRINT PEEK(&H440)
LOOP WHILE PEEK(&H440)

BEEP            'watch the diskette light go out when
                '  you hear the beep

FUNCTION Bin% (Bit$) STATIC
  Temp& = 0
  Length = LEN(Bit$)
  FOR X = 1 TO Length
    IF MID$(Bit$, Length - X + 1, 1) = "1" THEN
      Temp& = Temp& + 2 ^ (X - 1)
    END IF
  NEXT
  IF Temp& > 32767 THEN
    Bin% = Temp& - 65536
  ELSE
    Bin% = Temp&
  END IF
END FUNCTION
