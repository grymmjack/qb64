REM Paint Basic
REM \CHAP8\CH8_23.BAS



'              *************************
'              *       PaintBasic      *
'              *************************
'=============================================================
'       Author: V.E. Emelchenkov (Smolensk, 1995)
'       Sprite Creation and Musical Integration:
'          Adrian M. Sill and Graham J. Butler
'                (c)1995 Wrox Press Ltd.
'=============================================================
DECLARE SUB Help ()
DECLARE SUB Colors ()
DECLARE SUB Quit ()
DECLARE SUB SavePicture ()
DECLARE SUB LoadPicture ()
DECLARE SUB SaveLoadError ()
DECLARE FUNCTION Bytes! (x1!, y1!, x2!, y2!)
DECLARE SUB MoveCursor (flag!, DLeft!, DDown!)
DECLARE SUB Circles ()
DECLARE SUB Lines (Mode%, KXMin!, KYMin!, KXMax!, KYMax!)
DECLARE SUB MovePart ()
DECLARE SUB Fill ()
DECLARE SUB MoveCCursor (MA1!, MB1!, MDB!, Clr!)
DECLARE SUB MakeCCursor ()
DECLARE SUB Displacement (KeyC$, flag!)
DECLARE SUB InputText (x1!, y1!, LAnswer!, Answer$, flag!)
DECLARE SUB MakeCursor ()
DECLARE SUB InitHotKeys ()
DECLARE SUB Title ()
DECLARE SUB CaseAction ()
DECLARE SUB QuickCursor ()
DECLARE SUB SlowCursor ()
DECLARE SUB Sprite (KXMin!, KYMin!, KXMax!, KYMax!)
DECLARE SUB BigSprite ()
DECLARE SUB SaveSprite ()

'=============================================================
COMMON SHARED KX1, KY1           'Coordinates of current point
COMMON SHARED a%(), CCursor()    'Arrays for pointers
COMMON SHARED E%()               'Array for storing screen area
COMMON SHARED CColor             'Current color
COMMON SHARED StepX, StepY       'Step of graphics pointer
COMMON SHARED KeyC$, Key$
COMMON SHARED DX, DY, flag, Flag1
COMMON SHARED size%       'Size of sprite Array
COMMON SHARED image%      'Sprite Array
COMMON SHARED maxsizeofarray%

maxsizeofarray% = 8000
DIM SHARED image%(maxsizeofarray%)

'=============================================================
CONST graphmode% = 12                      'Screen mode
CONST CNeedleX = 1, CNeedleY = 1
CONST WNeedle = 14, LNeedle = 21           'Size of pointer
CONST MaxX = 640, MaxY = 480               'Screen dimensions
CONST MaxInt = 32767         'Max number of elements in array

'=============================================================
CALL Title                    'Title page
CALL InitHotKeys              'Initializing hot keys
SCREEN graphmode%, 1          'Determining screen mode
screenmode = graphmode%
CALL MakeCCursor              'Creating a pointer for colors menu
CALL MakeCursor               'Creating graphics cursor
StepX = 8: StepY = 6          'Step of graphics cursor
KX1 = CNeedleX: KY1 = CNeedleY'Coordinates of current point
CColor = 15                   'initializing display color
DO
   Key$ = INKEY$
   IF Key$ <> "" THEN
   CALL CaseAction
  END IF
LOOP
END

'=============================================================
Cursor:
' Data defining contour of graphics pointer
' Pair -1,-1 indicates end of data
DATA 1,1, 2,1, 1,2, 1,3, 1,4, 1,5, 1,6, 1,7, 1,8, 1,9, 1,10
DATA 1,11, 1,12, 3,2, 4,3, 5,4, 6,5, 7,6, 8,7, 9,8, 10,9
DATA 11,10, 12,11, 13,12, 1,13, 1,14, 1,15, 1,16, 2,16, 3,15
DATA 4,14, 5,13, 6,14, 6,15, 7,16, 7,17, 8,18, 8,19, 9,20
DATA 10,20, 11,20, 11,20, 11,19, 10,18, 10,17, 9,16, 9,15
DATA 8,14, 8,13, 9,13, 10,13, 11,13, 12,13, 13,13, -1,-1
'Coordinates of internal point of graphics pointer
DATA 2,3

'=============================================================
Hlp: 'Data for  Help procedure
DATA "  Point            P  ", "  Line             L  "
DATA "  Rectangle        R  ", "  Circle           C  "
DATA "  Fill             F  ", "  Copy             M  "
DATA "  Quick            +  ", "  Slow             -  "
DATA "  Color           F2  ", "  Save            F3  "
DATA "  Load            F4  ", "  Quit             Q  "
DATA "  Sprite           S  ", "                      "
DATA "  Escape - Exit Help  "

'=============================================================
HelpS:
PLAY "L24MNMBO1CDEFG"
    CALL Help
PLAY "L24MNMBO1GFEDC"
RETURN

'=============================================================
Clrs:
' ***  Selecting display color  ***
PLAY "L24MNMBO1CDEFG"
    CALL Colors
PLAY "L24MNMBO1GFEDC"
RETURN

'=============================================================
SaveScr:
' ***  Saving screen in file ***
PLAY "L24MNMBO1CDEFG"
    CALL SavePicture
PLAY "L24MNMBO1GFEDC"
RETURN

'=============================================================
LoadScr:
' ***  Reading screen from file   ****
PLAY "L24MNMBO1CDEFG"
    CALL LoadPicture
PLAY "L24MNMBO1GFEDC"
RETURN

'=============================================================
SaveLoadErr:
' ***  Processing reading and saving errors         ***
CALL SaveLoadError
IF ERR = 71 AND Flag1 < 1 THEN
  ' One attempt is granted for error correction
  flag = 0
  Flag1 = Flag1 + 1
  RESUME
ELSE
  RESUME NEXT
END IF

SUB BigSprite
'PUT (KX1, KY1), a%, XOR  'Remove cursor
SDY = INT(MaxY / 10)
SY = SDY
L% = Bytes(0, 0, MaxX - 1, SDY)
REDIM SC%(L%)
QX1 = 140: QY1 = 200
QX2 = 530: QY2 = 230
QL = Bytes(QX1, QY1, QX2, QY2)
REDIM QE%(QL)
GET (QX1, QY1)-(QX2, QY2), QE%
LINE (QX1, QY1)-(QX2, QY2), 0, BF
LINE (QX1, QY1)-(QX2, QY2), 15, B
LINE (QX1 + 2, QY1 + 2)-(QX2 - 2, QY2 - 2), 15, B
LOCATE 14, 20
PLAY "L24MNMBO1CDEFG"
PRINT "       Sprite Too Big....Try Again";
WHILE INKEY$ = "": WEND
PLAY "L24MNMBO1GFEDC"
PUT (QX1, QY1), QE%, PSET  'Restore screen section
ON ERROR GOTO 0              'Disable error handling
PUT (KX1, KY1), a%, XOR      'Restore graphics pointer

END SUB

FUNCTION Bytes (x1, y1, x2, y2)
'************************************************************
'*  Calculating size of array for storing screen area       *
'************************************************************
  BPP = 1: NP = 4
Bts = INT(((ABS(x2 - x1) + 1) * BPP + 7) / 8)
Bytes = 2 + INT(Bts * NP * (ABS(y2 - y1) + 1) / 2 + .5)
END FUNCTION

SUB CaseAction
'   *********************
'   * Action Selection  *
'   *********************
CALL MoveCursor(flag, WNeedle, LNeedle)
IF flag = 0 THEN
  SELECT CASE Key$
  CASE "C", "c"           'Drawing a circle
    CALL Circles
  CASE "R", "r"           'Drawing a rectangular
    CALL Lines(2, KXMin, KYMin, KXMax, KYMax)
  CASE "L", "l"           'Drawing a line section
    CALL Lines(1, KXMin, KYMin, KXMax, KYMax)
  CASE "P", "p"           'Drawing a point
    PSET (KX1, KY1 - 1), CColor
  CASE "M", "m"           'Copying a screen section
    CALL MovePart
  CASE "F", "f"           'Filling a closed area
    CALL Fill
  CASE "+", "="           'Speed up Cursor
    CALL QuickCursor
  CASE "-", "_"           'Slow down Cursor
    CALL SlowCursor
  CASE "S", "s"           'Capture Sprite
    CALL Sprite(KXMin, KYMin, KXMax, KYMax)
  CASE "Q", "q"           'Quit
    CALL Quit
  END SELECT
END IF
END SUB

SUB Circles
'     ****************************
'     *  Drawing a circle        *
'     *  in  Rubber Band Mode    *
'     ****************************
' KX1, KY1 - центр окружности

PUT (KX1, KY1), a%, XOR      'Remove graphics pointer
REDIM E%(10)                 'Array for storing screen section
GET (KX1, KY1)-(KX1, KY1), E%    'Screen section is stored
DO
  DO 'Waiting for a key pressing
    KeyC$ = INKEY$
  LOOP WHILE KeyC$ = ""

  SELECT CASE KeyC$
  CASE CHR$(0) + CHR$(72) 'Up
    DY = StepY
    flag = 1
  CASE CHR$(0) + CHR$(80) 'Down
    DY = -StepY
    flag = 1
  CASE ELSE
    flag = 0
  END SELECT

  IF flag = 1 THEN
    R1 = R + DY
    A1 = (KY1 - R1 >= 0) AND (KX1 - R1 >= 0)
    A2 = (KY1 + R1 <= MaxY) AND (KX1 + R1 <= MaxX)
    L1 = Bytes(KX1 - R1, KY1 - R1, KX1 + R1, KY1 + R1)
    A3 = L1 <= MaxInt
    IF (R1 >= 0) AND A1 AND A2 AND A3 THEN
      PUT (KX1 - R, KY1 - R), E%, PSET
      REDIM E%(L1)
      R = R1
      GET (KX1 - R, KY1 - R)-(KX1 + R, KY1 + R), E%
      CIRCLE (KX1, KY1), R, CColor
    END IF
  END IF
LOOP UNTIL KeyC$ = CHR$(13) OR KeyC$ = CHR$(27)

IF KeyC$ = CHR$(27) THEN 'Not execute command
  PUT (KX1 - R, KY1 - R), E%, PSET
END IF
PUT (KX1, KY1), a%, XOR  'Restore pointer
END SUB

SUB Colors
'   *****************************
'   *  Changing current color   *
'   *****************************
' CColor - current color
  A1 = MaxX - 51
  B1 = 7
  A2 = A1 + 36
  DB = INT((MaxY - 15) / 16)
  B2 = B1 + DB * 16 + 6
  L1 = Bytes(A1, B1, A2, B2)
  REDIM Clrs%(L1)
  GET (A1, B1)-(A2, B2), Clrs% ' Store screen section
' Double framework
  LINE (A1 + 1, B1 + 1)-(A2 - 1, B2 - 1), 15, BF
  LINE (A1 + 2, B1 + 2)-(A2 - 2, B2 - 2), 0, BF
' Colors menu
  B3 = B1 + 3
  FOR I = 0 TO 15
    DBI = B3 + I * DB
    LINE (A1 + 3, DBI)-(A2 - 3, DBI + DB), 15, B
    PAINT (A1 + 4, DBI + 1), I, 15
  NEXT I
  CALL MoveCCursor(A1, B1, DB, Clr)
  IF KeyC$ = CHR$(13) THEN
    CColor = Clr
  END IF
  PUT (A1, B1), Clrs%, PSET 'Restore screen section
END SUB

SUB Displacement (KeyC$, flag)
'   ****************************************
'   * Processing cursor movement keys      *
'   ****************************************
' KeyC$ - key pressed
' Flag = 1, if a cursor movement key is pressed
' Flag = 0, otherwise

  DX = 0: DY = 0
  flag = 1
  SELECT CASE KeyC$
  CASE CHR$(0) + CHR$(80)    'Down
    DY = StepY
  CASE CHR$(0) + CHR$(72)    'Up
    DY = -StepY
  CASE CHR$(0) + CHR$(77)    'Right
    DX = StepX
  CASE CHR$(0) + CHR$(75)    'Left
    DX = -StepX
  CASE CHR$(0) + CHR$(73)    'Up  and right
    DX = StepX: DY = -StepY
  CASE CHR$(0) + CHR$(81)    'Down and right
    DX = StepX: DY = StepY
  CASE CHR$(0) + CHR$(79)    'Down and left
    DX = -StepX: DY = StepY
  CASE CHR$(0) + CHR$(71)    'Up and left
    DX = -StepX: DY = -StepY
  CASE ELSE
    flag = 0
END SELECT
END SUB

SUB Fill
'   *********************************************
'   * Filling a closed area with a current color*
'   *********************************************
PUT (KX1, KY1), a%, XOR  'Remove graphics cursor
Border = 20
FX = KX1: FY = KY1
FPic = POINT(FX, FY)
' *** Detecting color of the bound of closed area***
' ***  to the left of graphics cusor             ***
DO WHILE Border = 20 AND FX > 1
  FX = FX - 1
  IF POINT(FX, FY) <> FPic THEN Border = POINT(FX, FY)
LOOP
' *** Filling ***
IF Border = 20 THEN
  Border = CColor
END IF
PAINT (KX1, KY1), CColor, Border
PUT (KX1, KY1), a%, XOR    'Restore graphics cursor
END SUB

SUB Help
'           ***************************
'           *  Outputting Help        *
'           ***************************
  x1 = 224: y1 = 110
  x2 = 415: y2 = 395
  L = Bytes(x1, y1, x2, y2)
  REDIM Help1%(L)
  GET (x1, y1)-(x2, y2), Help1%
  LOCATE 8, 29: PRINT CHR$(201) + STRING$(22, 205) + CHR$(187)
  LOCATE 8, 38: PRINT "<Help>"
  RESTORE Hlp
  FOR I = 9 TO 23
    READ S$
    LOCATE I, 29: PRINT CHR$(186) + S$ + CHR$(186)
  NEXT I
  LOCATE 24, 29: PRINT CHR$(200) + STRING$(22, 205) + CHR$(188)
  Pause$ = INPUT$(1)
  PUT (x1, y1), Help1%, PSET
END SUB

SUB InitHotKeys
'    **********************************
'    *  Initializing hot keys         *
'    **********************************
ON KEY(1) GOSUB HelpS         'Call help
KEY(1) ON
ON KEY(2) GOSUB Clrs          'Change current color
KEY(2) ON
ON KEY(3) GOSUB SaveScr       'Store picture
KEY(3) ON
ON KEY(4) GOSUB LoadScr       'Load picture
KEY(4) ON
END SUB

SUB InputText (x1, y1, LAnswer, Answer$, flag)
'   *******************************************
'   *  Entering Answer$ of the length LAnswer *
'   *******************************************
' Flag = 27, if Esc is pressed
' Flag = 13, if Enter is pressed

  ' *** Event Tracking is enabled ***
  KEY(2) OFF
  KEY(3) OFF
  KEY(4) OFF
  KEY(15) OFF
  KEY(16) OFF
  CLOtv$ = SPACE$(LAnswer)
  LOCATE x1, y1
  PRINT CLOtv$
  LOCATE x1, y1
  Answer$ = ""
  DO
    DO 'Waiting for a key pressing
      Ch$ = INKEY$
    LOOP WHILE Ch$ = ""
    flag = 0
    L = LEN(Answer$)
    SELECT CASE Ch$
      CASE CHR$(13)      'Enter
        flag = 13
      CASE CHR$(27)      'Esc
        flag = 27
      CASE CHR$(8)       'BS
        IF L > 0 THEN
          Answer$ = LEFT$(Answer$, L - 1)
        END IF
      CASE ".", ":", "\", "0" TO "9", "A" TO "Z", "a" TO "z"
        IF L < LAnswer THEN
          Answer$ = Answer$ + Ch$
        END IF
      CASE ELSE
        flag = -1
    END SELECT
    IF flag = 0 THEN
      LOCATE x1, y1
      CO$ = LEFT$(Answer$ + CLOtv$, LAnswer)
      PRINT CO$
      LOCATE x1, y1 + LEN(Answer$)
    END IF
  LOOP UNTIL flag = 13 OR flag = 27
  
  KEY(2) ON
  KEY(3) ON
  KEY(4) ON
  KEY(15) ON
  KEY(16) ON
END SUB

SUB Lines (Mode%, KXMin, KYMin, KXMax, KYMax)
'     **********************************************
'     *  Prcedure draws line section (Mode% = 1) or*
'     *           framework (Mode% = 2)            *
'     *          in the rubber band mode           *
'     **********************************************
'
' Mode% - defines the view of drawing;
' KX1, KY1 - coordinates of current point before entering to procedure
' Exit:
' KXMin, KYMin - coordinates of upper left point of the area
'                to be stored in E%() array;
' KXMax, KYMax - coordinates of upper right point of the areaго
'                to be stored in E%() array;
'-------------------------------------------------------------
PUT (KX1, KY1), a%, XOR      'Remove cursor
REDIM E%(10)                 'Array for storing picture
GET (KX1, KY1)-(KX1, KY1), E%    'A screen area is stored
KX2 = KX1: KY2 = KY1
KXMin = KX1
KYMin = KY1
DO

  DO
    KeyC$ = INKEY$
  LOOP WHILE KeyC$ = ""
' *** Detecting cursor offset ***
  CALL Displacement(KeyC$, flag)
' *** Responce on  a key pressed ***
  IF flag = 1 THEN
    KX3 = KX2 + DX
    KY3 = KY2 + DY
    A1 = (KY3 >= 0) AND (KX3 >= 0)
    A2 = (KY3 <= MaxY) AND (KX3 <= MaxX)
    L1 = Bytes(KX1, KY1, KX3, KY3)
    A3 = L1 <= MaxInt
    IF A1 AND A2 AND A3 THEN
      PUT (KXMin, KYMin), E%, PSET
      REDIM E%(L1)
      KX2 = KX3: KY2 = KY3
      IF KX1 < KX2 THEN
        KXMin = KX1: KXMax = KX2
      ELSE
        KXMin = KX2: KXMax = KX1
      END IF
      IF KY1 < KY2 THEN
        KYMin = KY1: KYMax = KY2
      ELSE
        KYMin = KY2: KYMax = KY1
      END IF
      GET (KXMin, KYMin)-(KXMax, KYMax), E%
      IF Mode% = 1 THEN
        LINE (KX1, KY1)-(KX2, KY2), CColor
      ELSE
        LINE (KX1, KY1)-(KX2, KY2), CColor, B
      END IF
    ELSE
      BEEP: BEEP
    END IF
  END IF
LOOP UNTIL KeyC$ = CHR$(13) OR KeyC$ = CHR$(27)

IF KeyC$ = CHR$(27) THEN 'No command execution
  PUT (KXMin, KYMin), E%, PSET
END IF

PUT (KX1, KY1), a%, XOR  'Restore cursor
END SUB

SUB LoadPicture
'   ******************************
'   *  Loading screen from file  *
'   ******************************
PUT (KX1, KY1), a%, XOR
SDY = INT(MaxY / 10)
SY = SDY
L% = Bytes(0, 0, MaxX - 1, SDY)
REDIM SC%(L%)
QX1 = 140: QY1 = 200
QX2 = 530: QY2 = 230
QL = Bytes(QX1, QY1, QX2, QY2)
REDIM QE%(QL)
GET (QX1, QY1)-(QX2, QY2), QE%
LINE (QX1, QY1)-(QX2, QY2), 0, BF
LINE (QX1, QY1)-(QX2, QY2), 15, B
LINE (QX1 + 2, QY1 + 2)-(QX2 - 2, QY2 - 2), 15, B
LOCATE 14, 20
PRINT "Enter file name:";
CALL InputText(14, 37, 30, filename$, flag)
IF flag = 27 THEN
  PUT (QX1, QY1), QE%, PSET
  PUT (KX1, KY1), a%, XOR
  EXIT SUB
END IF
ON ERROR GOTO SaveLoadErr    'Enable error processing
flag = 0
OPEN filename$ FOR INPUT AS #1
ON ERROR GOTO 0              'Disable error processing
IF flag = 0 THEN
  FOR SY = 0 TO MaxY - 1 STEP SDY
    FOR I = 0 TO L%
      INPUT #1, SC%(I)
    NEXT I
    PUT (0, SY), SC%, PSET   'Output part of drawing onto the screen
  NEXT SY
  CLOSE #1
ELSE
  PUT (QX1, QY1), QE%, PSET  'Restore screen area
END IF
PUT (KX1, KY1), a%, XOR
END SUB

SUB MakeCCursor
'  *** Graphics pointer for colors menu  ***
LINE (1, 1)-(13, 11), 15, BF
L = Bytes(1, 1, 13, 11)
REDIM CCursor(L)
GET (1, 1)-(13, 11), CCursor
PUT (1, 1), CCursor, XOR
END SUB

SUB MakeCursor
RESTORE Cursor
READ XC, YC
DO
  PSET (XC, YC), 15
  READ XC, YC
LOOP UNTIL XC = -1 AND YC = -1
READ XC, YC
PAINT (XC, YC), 4, 15

' *** Determining number of bytes to store pointer ***
L = Bytes(CNeedleX, CNeedleY, WNeedle, LNeedle)

' *** Storing pointer in A%() array ***
DIM a%(L)
GET (CNeedleX, CNeedleY)-(WNeedle, LNeedle), a%
END SUB

SUB MoveCCursor (MA1, MB1, MDB, Clr)
'   *************************************************
'   * Moving cursor while selecting current color   *
'   *************************************************
MA = MA1 + 12
MB = MB1 + INT(MDB / 2) - 2
Clr = CColor
Y = MB + Clr * MDB
PUT (MA, Y), CCursor, XOR
DO
  KeyC$ = INKEY$
  k = 0
  SELECT CASE KeyC$
  CASE CHR$(0) + CHR$(80)       'Down
    SOUND 50, 1
    k = 1
  CASE CHR$(0) + CHR$(72)        'Up
    SOUND 75, 1
    k = -1
  END SELECT
  IF k <> 0 THEN
    Y = MB + Clr * MDB
    PUT (MA, Y), CCursor, XOR
    Clr = (Clr + k + 16) MOD 16
    Y = MB + Clr * MDB
    PUT (MA, Y), CCursor, XOR
  END IF
LOOP UNTIL (KeyC$ = CHR$(13)) OR (KeyC$ = CHR$(27))
END SUB

SUB MoveCursor (flag, DLeft, DDown)
' KX1, KY1 - coordinates of current point
CALL Displacement(Key$, flag)
IF flag = 1 THEN
PUT (KX1, KY1), a%, XOR
KX2 = KX1 + DX: KY2 = KY1 + DY
IF KX2 >= 0 THEN KX1 = KX2
IF KX2 < 0 THEN KX1 = MaxX - DLeft
IF KX2 > MaxX - DLeft THEN KX1 = 0
IF KY2 >= 0 THEN KY1 = KY2
IF KY2 < 0 THEN KY1 = MaxY - DDown
IF KY2 > MaxY - DDown THEN KY1 = 0
PUT (KX1, KY1), a%, XOR
END IF
END SUB

SUB MovePart
'   ********************************
'   *  Copying screen area         *
'   ********************************

  CALL Lines(2, KXMin, KYMin, KXMax, KYMax)  'Mark area
  IF KeyC$ = CHR$(27) THEN
    EXIT SUB
  END IF
  PUT (KX1, KY1), a%, XOR      'Remove graphics pointer
  PUT (KXMin, KYMin), E%, PSET 'Remove screen area marking
  PUT (KX1, KY1), a%, XOR      'Restore pointer

' ***  Cursor moving        ***
  DO
    DO
      Key$ = INKEY$
    LOOP WHILE Key$ = ""
    CALL MoveCursor(flag, KXMax - KXMin + 1, KYMax - KYMin + 1)
  LOOP UNTIL Key$ = CHR$(13) OR Key$ = CHR$(27)
  IF Key$ = CHR$(27) THEN
    EXIT SUB
  END IF

  PUT (KX1, KY1), a%, XOR
  PUT (KX1, KY1), E%, PSET
  PUT (KX1, KY1), a%, XOR
END SUB

SUB QuickCursor

QuickCursor:
' ***  Speeding up pointer movement  ***
  StepX = 8
  StepY = 6

END SUB

SUB Quit
'   ************************
'   *  Exit from program   *
'   ************************
QX1 = 140: QY1 = 200
QX2 = 530: QY2 = 230
QL = Bytes(QX1, QY1, QX2, QY2)
REDIM QE%(QL)                 'Array for storing screen picture
GET (QX1, QY1)-(QX2, QY2), QE%    'Screen section is captured
LINE (QX1, QY1)-(QX2, QY2), 0, BF
LINE (QX1, QY1)-(QX2, QY2), 15, B
LINE (QX1 + 2, QY1 + 2)-(QX2 - 2, QY2 - 2), 15, B
'COLOR 15, 0
LOCATE 14, 20
PLAY "O1L16MBMLDCL4D"
PRINT "Do you want to quit the Graphics Editor (Y/N)?"
DO
  Key$ = INKEY$
  QC1 = Key$ = "Y" OR Key$ = "y"
  QC2 = Key$ = "N" OR Key$ = "n"
LOOP UNTIL QC1 OR QC2
IF QC2 THEN
  PLAY "L24MNMBO1GFEDC"
  PUT (QX1, QY1), QE%, PSET  'Restore screen section
ELSE
    PLAY "L8MNMBO1GAL6FP10O0FP10O1L4C"
    END
END IF
END SUB

 SUB SaveLoadError
'   **********************
'   *  Error processing  *
'   **********************
  flag = 1
  EX1 = 140: EY1 = 250
  EX2 = 530: EY2 = 280
  EL = Bytes(EX1, EY1, EX2, EY2)
  REDIM EE%(EL)
  GET (EX1, EY1)-(EX2, EY2), EE%
  LINE (EX1, EY1)-(EX2, EY2), 0, BF
  LINE (EX1, EY1)-(EX2, EY2), 15, B
  LINE (EX1 + 2, EY1 + 2)-(EX2 - 2, EY2 - 2), 15, B
  LOCATE 17, 35
  SELECT CASE ERR
  CASE 52, 64
    PRINT "Bad file name"
  CASE 53
    PRINT "File not found"
  CASE 68
    LOCATE 17, 33
    PRINT "Device unavailable"
  CASE 71
    PRINT "Disk not ready"
  CASE 76
    PRINT "Path not found"
  CASE ELSE
    LOCATE 17, 34
    PRINT "Unrecognizable error"
  END SELECT
  Pause$ = INPUT$(1)
  PUT (EX1, EY1), EE%, PSET
END SUB

SUB SavePicture
'   ***************************
'   * Saving screen in a file *
'   ***************************
PUT (KX1, KY1), a%, XOR  'Remove cursor
SDY = INT(MaxY / 10)
SY = SDY
L% = Bytes(0, 0, MaxX - 1, SDY)
REDIM SC%(L%)
QX1 = 140: QY1 = 200
QX2 = 530: QY2 = 230
QL = Bytes(QX1, QY1, QX2, QY2)
REDIM QE%(QL)
GET (QX1, QY1)-(QX2, QY2), QE%
LINE (QX1, QY1)-(QX2, QY2), 0, BF
LINE (QX1, QY1)-(QX2, QY2), 15, B
LINE (QX1 + 2, QY1 + 2)-(QX2 - 2, QY2 - 2), 15, B
'COLOR 15, 0
LOCATE 14, 20
PRINT "Enter file name:";
CALL InputText(14, 37, 30, filename$, flag)
IF flag = 27 THEN
  PUT (QX1, QY1), QE%, PSET
  PUT (KX1, KY1), a%, XOR
  EXIT SUB
END IF
ON ERROR GOTO SaveLoadErr              'Enable error handling
flag = 0
Flag1 = 0               'Counting attempts of correcting error No71
OPEN filename$ FOR OUTPUT AS #1

IF flag = 0 THEN 'Save in file
  PUT (QX1, QY1), QE%, PSET  'Restore screen section
  FOR SY = 0 TO MaxY - 1 STEP SDY
    GET (0, SY)-(MaxX - 1, SY + SDY - 1), SC%
    FOR I = 0 TO L%
       PRINT #1, SC%(I)
    NEXT I
  NEXT SY
  CLOSE #1
ELSE
  PUT (QX1, QY1), QE%, PSET  'Restore screen section
END IF
'ON ERROR GOTO 0              'Disable error handling
PUT (KX1, KY1), a%, XOR      'Restore graphics pointer
END SUB

SUB SaveSprite
'   ***************************
'   * Saving Sprite to a file *
'   ***************************
SDY = INT(MaxY / 10)
SY = SDY
L% = Bytes(0, 0, MaxX - 1, SDY)
REDIM SC%(L%)
QX1 = 140: QY1 = 200
QX2 = 530: QY2 = 230
QL = Bytes(QX1, QY1, QX2, QY2)
REDIM QE%(QL)
GET (QX1, QY1)-(QX2, QY2), QE%
LINE (QX1, QY1)-(QX2, QY2), 0, BF
LINE (QX1, QY1)-(QX2, QY2), 15, B
LINE (QX1 + 2, QY1 + 2)-(QX2 - 2, QY2 - 2), 15, B
LOCATE 14, 20
PRINT "Enter filename: ";
PLAY "L24MNMBO1CDEFG"
CALL InputText(14, 36, 30, filename$, flag)
IF flag = 27 THEN
    PUT (QX1, QY1), QE%, PSET
    PUT (KX1, KY1), a%, XOR
    EXIT SUB
END IF
flag = 0
Flag1 = 0               'Counting attempts of correcting error No71

IF flag = 0 THEN 'Save in file
PUT (QX1, QY1), QE%, PSET  'Restore screen section

'write file
datas% = 0
IF filename$ = "" THEN GOTO nosave
OPEN filename$ FOR OUTPUT AS #1
nextline:

PRINT #1, "REM Sprite Viewer : Automated from PaintBasic"
PRINT #1, "REM (c). Wrox Press Ltd."
PRINT #1, ""
PRINT #1, "SCREEN "; graphmode%
PRINT #1, ""
PRINT #1, "DATA ";

linecheck = 0
FOR n = 0 TO size%
        datas% = datas% + 1
        linecheck = linecheck + 1
        temp = 4 - LEN(HEX$(image%(n)))
        PRINT #1, "&H"; STRING$(temp, "0"); HEX$(image%(n));
        IF linecheck > 7 THEN
                linecheck = 0
                PRINT #1, : PRINT #1, "DATA ";
        ELSE
        PRINT #1, ",";
        END IF
NEXT n

finish:
PRINT #1, "*** End of "; name$; " ("; (datas% - 1); ") statements ***"
PRINT #1, ""
PRINT #1, "DIM SHARED sprite%("; (datas% - 1); ")"
PRINT #1, ""
PRINT #1, "FOR loopcounter%= 0 TO "; (datas% - 1) - 1
PRINT #1, "    READ sprite%(loopcounter%)"
PRINT #1, "NEXT loopcounter%"
PRINT #1, ""
PRINT #1, "PUT (50,50), sprite%"
PRINT #1, ""
PRINT #1, "END"
            
CLOSE #1
nosave:
PLAY "L24MNMBO1GFEDC"
ELSE
  PUT (QX1, QY1), QE%, PSET  'Restore screen section
END IF
ON ERROR GOTO 0              'Disable error handling
PUT (KX1, KY1), a%, XOR      'Restore graphics pointer

END SUB

SUB SlowCursor
SlowCursor:
' ***  Slowing down pointer movement  ***
    StepX = 1
    StepY = 1

END SUB

SUB Sprite (KXMin, KYMin, KXMax, KYMax)

BEEP: BEEP: BEEP
PUT (KX1, KY1), a%, XOR      'Remove cursor
REDIM E%(10)                 'Array for storing picture
GET (KX1, KY1)-(KX1, KY1), E%    'A screen area is stored
KX2 = KX1: KY2 = KY1
KXMin = KX1
KYMin = KY1
DO

  DO
    KeyC$ = INKEY$
  LOOP WHILE KeyC$ = ""
' *** Detecting cursor offset ***
  CALL Displacement(KeyC$, flag)
' *** Responce on a key pressed ***
  IF flag = 1 THEN
    KX3 = KX2 + DX
    KY3 = KY2 + DY
    A1 = (KY3 >= 0) AND (KX3 >= 0)
    A2 = (KY3 <= MaxY) AND (KX3 <= MaxX)
    L1 = Bytes(KX1, KY1, KX3, KY3)
    A3 = L1 <= MaxInt
    IF A1 AND A2 AND A3 THEN
      PUT (KXMin, KYMin), E%, PSET
      REDIM E%(L1)
      KX2 = KX3: KY2 = KY3
      IF KX1 < KX2 THEN
        KXMin = KX1: KXMax = KX2
      ELSE
        KXMin = KX2: KXMax = KX1
      END IF
      IF KY1 < KY2 THEN
        KYMin = KY1: KYMax = KY2
      ELSE
        KYMin = KY2: KYMax = KY1
      END IF
      GET (KXMin, KYMin)-(KXMax, KYMax), E%
      LINE (KX1, KY1)-(KX2, KY2), CColor, B
      ELSE
      BEEP: BEEP
    END IF
  END IF
LOOP UNTIL KeyC$ = CHR$(13) OR KeyC$ = CHR$(27)

IF KeyC$ = CHR$(27) THEN 'No command execution
  PUT (KXMin, KYMin), E%, PSET
END IF

LINE (KX1, KY1)-(KX2, KY2), 0, B

'Check for sprite > maxsizeofarray
IF (KX2 - KX1) * (KY2 - KY1) > maxsizeofarray% THEN
 CALL BigSprite
ELSE
 GET (KX1, KY1)-(KX2, KY2), image%
 'Equation for calculating array size
 planes% = 4
 size% = 4 + (INT(((KX2 - KX1 + 1) + 7) / 8) * planes% * (KY2 - KY1 + 1))
 CALL SaveSprite
END IF

END SUB

SUB Title
SCREEN 9: CLS 0
PLAY "L8MNMBO1GAL6FP10O0FP10O1L4C"
LOCATE 12, 28: PRINT CHR$(201) + STRING$(23, 205) + CHR$(187)
LOCATE 13, 28: PRINT CHR$(186) + "       PaintBasic      " + CHR$(186)
LOCATE 14, 28: PRINT CHR$(200) + STRING$(23, 205) + CHR$(188)
LOCATE 23, 33: PRINT "V.E. Emelchenkov"
LOCATE 24, 33: PRINT "Russia, Smolensk"
LOCATE 25, 30: PRINT "(c)1995 Wrox Press Ltd."
Pause$ = INPUT$(1)
CLS 0
END SUB

