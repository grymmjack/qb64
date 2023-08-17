'********** MOUSE.BAS - demonstrates accessing the various mouse services

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

'---- assembly language functions and subroutines
DECLARE FUNCTION PeekWord% (BYVAL Segment, BYVAL Address)
DECLARE SUB MouseInt (MouseRegs AS ANY)


'---- BASIC functions and subprograms
DECLARE FUNCTION Bin2Hex% (Binary$)
DECLARE FUNCTION MouseThere% ()
DECLARE FUNCTION WaitButton% ()
DECLARE SUB CursorShape (HotX, HotY, Shape())
DECLARE SUB HideCursor ()
DECLARE SUB MouseTrap (ULRow, ULCol, LRRow, LRCol)
DECLARE SUB MoveCursor (X, Y)
DECLARE SUB ReadCursor (X, Y, Buttons)
DECLARE SUB ShowCursor ()
DECLARE SUB TextCursor (FG, BG)

DECLARE SUB Prompt (Message$)   'used for this demo only


TYPE MouseType                  'similar to DOS Registers
  AX      AS INTEGER
  BX      AS INTEGER
  CX      AS INTEGER
  DX      AS INTEGER
  Segment AS INTEGER
END TYPE

DIM SHARED MouseRegs AS MouseType 'so all the subs can get at them
DIM SHARED MousePresent
REDIM Cursor(1 TO 32)           'holds the cursor shape definition

IF NOT MouseThere% THEN         'ensure that a mouse is present
  PRINT "No mouse is installed" '  and initialize it if so
  END
END IF
CLS


DEF SEG = 0                     'see what type of monitor
IF PEEK(&H463) <> &HB4 THEN     'if it's color
  ColorMon = -1                 'remember that for later
  SCREEN 12                     'this requires a VGA
  LINE (0, 0)-(639, 460), 1, BF 'paint a blue background
END IF


DIM Choice$(1 TO 5)             'display some choices on the screen,
LOCATE 1, 1                     '  so we'll have something to point at
FOR X = 1 TO 5
  READ Choice$(X)
  PRINT Choice$(X);
  LOCATE , X * 12
NEXT
DATA "Choice 1", "Choice 2", "Choice 3", "Choice 4", "Choice 5"


IF NOT ColorMon THEN            'if it's not color
  CALL TextCursor(-2, -2)       'select a text cursor
END IF


CALL ShowCursor
CALL Prompt("Point the cursor at a choice, and press a button.")


DO                              'wait for a button press
  CALL ReadCursor(X, Y, Button)
LOOP UNTIL Button
IF Button AND 4 THEN Button = 3 'for three-button mice

CALL Prompt("You pressed button" + STR$(Button) + " and the cursor was at location" + STR$(X) + "," + STR$(Y) + " - press a button.")

IF ColorMon THEN                'if it is a color monitor
  RESTORE Arrow                 '  load a custom arrow
  GOSUB DefineCursor
END IF
Dummy = WaitButton%



IF ColorMon THEN                'the hardware can do it
  RESTORE CrossHairs            'set a cross-hairs cursor
  GOSUB DefineCursor
  CALL Prompt("Now the cursor is a cross-hairs, press a button.")
  Dummy% = WaitButton%
END IF



IF ColorMon THEN                'now set an hour glass
  RESTORE HourGlass
  GOSUB DefineCursor
END IF


CALL Prompt("Now notice how the cursor range is restricted.  Press a button to end.")
CALL MouseTrap(50, 50, 100, 100)
Dummy = WaitButton%

IF ColorMon THEN                'restore to 640 x 350
  CALL MouseTrap(0, 0, 349, 639)
ELSE                            'use CGA coordinates for mono!
  CALL MouseTrap(0, 0, 199, 639)
END IF

Dummy = InitMouse%              'reset the mouse driver
CALL HideCursor                 'and turn off the cursor
SCREEN 0                        'revert to text mode
END



DefineCursor:

FOR X = 1 TO 32                 'read 32 words of data
  READ Dat$                     'read the data
  Cursor(X) = Bin2Hex%(Dat$)    'convert to integer
NEXT
CALL CursorShape(Zero, Zero, Cursor())
RETURN



Arrow:

NOTES:
'The first group of binary data is the screen mask.
'The second group of binary data is the cursor mask.
'The cursor color is black where both masks are 0.
'The cursor color is XORed where both masks are 1.
'The color is clear where the screen mask is 1 and the cursor mask is 0.
'The color is white where the screen mask is 0 and the cursor mask is 1.
'
'--- this is the screen mask
DATA "1110011111111111"
DATA "1110001111111111"
DATA "1110000111111111"
DATA "1110000011111111"
DATA "1110000001111111"
DATA "1110000000111111"
DATA "1110000000011111"
DATA "1110000000001111"
DATA "1110000000000111"
DATA "1110000000000011"
DATA "1110000000000001"
DATA "1110000000011111"
DATA "1110001000011111"
DATA "1111111100001111"
DATA "1111111100001111"
DATA "1111111110001111"

'---- this is the cursor mask
DATA "0001100000000000"
DATA "0001010000000000"
DATA "0001001000000000"
DATA "0001000100000000"
DATA "0001000010000000"
DATA "0001000001000000"
DATA "0001000000100000"
DATA "0001000000010000"
DATA "0001000000001000"
DATA "0001000000000100"
DATA "0001000000111110"
DATA "0001001100100000"
DATA "0001110100100000"
DATA "0000000010010000"
DATA "0000000010010000"
DATA "0000000001110000"



CrossHairs:

DATA "1111111101111111"
DATA "1111111101111111"
DATA "1111111101111111"
DATA "1111000000000111"
DATA "1111011101110111"
DATA "1111011101110111"
DATA "1111011111110111"
DATA "1000000111000000"
DATA "1111011111110111"
DATA "1111011101110111"
DATA "1111011101110111"
DATA "1111000000000111"
DATA "1111111101111111"
DATA "1111111101111111"
DATA "1111111101111111"
DATA "1111111111111111"

DATA "0000000010000000"
DATA "0000000010000000"
DATA "0000000010000000"
DATA "0000111111111000"
DATA "0000100010001000"
DATA "0000100010001000"
DATA "0000100000001000"
DATA "0111111000111111"
DATA "0000100000001000"
DATA "0000100010001000"
DATA "0000100010001000"
DATA "0000111111111000"
DATA "0000000010000000"
DATA "0000000010000000"
DATA "0000000010000000"
DATA "0000000000000000"



HourGlass:

DATA "1100000000000111"
DATA "1100000000000111"
DATA "1100000000000111"
DATA "1110000000001111"
DATA "1110000000001111"
DATA "1111000000011111"
DATA "1111100000111111"
DATA "1111110001111111"
DATA "1111110001111111"
DATA "1111100000111111"
DATA "1111000000011111"
DATA "1110000000001111"
DATA "1110000000001111"
DATA "1100000000000111"
DATA "1100000000000111"
DATA "1100000000000111"

DATA "0000000000000000"
DATA "0001111111110000"
DATA "0000000000000000"
DATA "0000111111100000"
DATA "0000100110100000"
DATA "0000010001000000"
DATA "0000001010000000"
DATA "0000000100000000"
DATA "0000000100000000"
DATA "0000001010000000"
DATA "0000011111000000"
DATA "0000110001100000"
DATA "0000100000100000"
DATA "0000000000000000"
DATA "0001111111110000"
DATA "0000000000000000"

FUNCTION Bin2Hex% (Binary$) STATIC  'binary to integer

  Temp& = 0
  Count = 0

  FOR X = LEN(Binary$) TO 1 STEP -1
    IF MID$(Binary$, X, 1) = "1" THEN
      Temp& = Temp& + 2 ^ Count
    END IF
    Count = Count + 1
  NEXT

  IF Temp& > 32767 THEN Temp& = Temp& - 65536
  Bin2Hex% = Temp&

END FUNCTION

SUB CursorShape (HotX, HotY, Shape()) STATIC
 
  IF NOT MousePresent THEN EXIT SUB

  MouseRegs.AX = 9
  MouseRegs.BX = HotX
  MouseRegs.CX = HotY
  MouseRegs.DX = VARPTR(Shape(1))
  MouseRegs.Segment = VARSEG(Shape(1))

  CALL MouseInt(MouseRegs)

END SUB

SUB HideCursor STATIC       'turns off the mouse cursor

  IF NOT MousePresent THEN EXIT SUB

  MouseRegs.AX = 2
  CALL MouseInt(MouseRegs)

END SUB

FUNCTION MouseThere% STATIC     'reports if a mouse is present

  MouseThere% = 0               'assume there is no mouse
  IF PeekWord%(Zero, (4 * &H33) + 2) = 0 THEN 'if segment = 0
    EXIT FUNCTION                             '  then there's no mouse
  END IF

  MouseRegs.AX = 0
  CALL MouseInt(MouseRegs)
  MouseThere% = MouseRegs.AX
  IF MouseRegs.AX THEN MousePresent = -1

END FUNCTION

SUB MouseTrap (ULRow, ULColumn, LRRow, LRColumn) STATIC

  IF NOT MousePresent THEN EXIT SUB

  MouseRegs.AX = 7      'restrict horizontal movement
  MouseRegs.CX = ULColumn
  MouseRegs.DX = LRColumn
  CALL MouseInt(MouseRegs)

  MouseRegs.AX = 8      'restrict vertical movement
  MouseRegs.CX = ULRow
  MouseRegs.DX = LRRow
  CALL MouseInt(MouseRegs)

END SUB

SUB MoveCursor (X, Y) STATIC    'positions the mouse cursor

  IF NOT MousePresent THEN EXIT SUB

  MouseRegs.AX = 4
  MouseRegs.CX = X
  MouseRegs.DX = Y
  CALL MouseInt(MouseRegs)

END SUB

SUB Prompt (Message$) STATIC    'prints prompt message

    V = CSRLIN                  'save current cursor position
    H = POS(0)
    LOCATE 30, 1                'use 25 for SCREEN 9
    CALL HideCursor             'this is very important!
    PRINT LEFT$(Message$, 79); TAB(80);
    CALL ShowCursor             'and so is this
    LOCATE V, H                 'restore the cursor

END SUB

SUB ReadCursor (X, Y, Buttons)  'returns cursor and button information

  IF NOT MousePresent THEN EXIT SUB

  MouseRegs.AX = 3
  CALL MouseInt(MouseRegs)
 
  Buttons = MouseRegs.BX AND 7
  X = MouseRegs.CX
  Y = MouseRegs.DX

END SUB

SUB ShowCursor STATIC           'turns on the mouse cursor

  IF NOT MousePresent THEN EXIT SUB

  MouseRegs.AX = 1
  CALL MouseInt(MouseRegs)

END SUB

SUB TextCursor (FG, BG) STATIC

  IF NOT MousePresent THEN EXIT SUB

  MouseRegs.AX = 10
  MouseRegs.BX = 0
  MouseRegs.CX = &HFF
  MouseRegs.DX = 0

  IF FG = -1 THEN                       'maintain FG as the cursor moves?
    MouseRegs.CX = MouseRegs.CX OR &HF00
  ELSEIF FG = -2 THEN                   'invert FG as the cursor moves?
    MouseRegs.CX = MouseRegs.CX OR &H700
    MouseRegs.DX = &H700
  ELSE
    MouseRegs.DX = 256 * (FG AND &HFF)  'use the specified color
  END IF

  IF BG = -1 THEN                       'maintain BG as the cursor moves?
    MouseRegs.CX = MouseRegs.CX OR &HF000
  ELSEIF BG = -2 THEN                   'invert BG as the cursor moves?
    MouseRegs.CX = MouseRegs.CX OR &H7000
    MouseRegs.DX = MouseRegs.DX OR &H7000
  ELSE
    Temp = (BG AND 7) * 16 * 256
    MouseRegs.DX = MouseRegs.DX OR Temp 'use the specified color
  END IF

  CALL MouseInt(MouseRegs)

END SUB

FUNCTION WaitButton% STATIC     'waits for a button press

  IF NOT MousePresent THEN EXIT FUNCTION

  X! = TIMER                    'pause to allow releasing
  WHILE X! + .2 > TIMER         '  the button
  WEND

  DO                            'wait for a button press
    CALL ReadCursor(X, Y, Button)
  LOOP UNTIL Button

  IF Button AND 4 THEN Button = 3 'for three-button mice
  WaitButton% = Button            'assign the function

END FUNCTION
