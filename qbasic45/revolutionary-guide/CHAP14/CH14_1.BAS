REM Spreadsheet
REM \CHAP14\CH14_1.BAS

'=============================================================
' Author: S. E. Emelchenkov (Smolensk, 1994)
'=============================================================

DECLARE SUB Title ()
DECLARE SUB EditString (S$, X%, Y%, Color1%, Color2%, MaxLen%)
DECLARE SUB PrintName ()
DECLARE SUB OpenWindow (WindowName$, Row1%, Col1%, Row2%, Col2%, Color1%, Color2%)
DECLARE SUB CloseWindow ()
DECLARE SUB PrintCell ()
DECLARE SUB CursorOff ()
DECLARE SUB Box (Row1%, Col1%, Row2%, Col2%, Border%, Color1%, Color2%)
DECLARE SUB Menu ()
DECLARE SUB New ()
DECLARE SUB ProgramExit ()
DECLARE SUB Errors (ErRow%, ErCol%)
DECLARE SUB SAItem (F$, ItemValue!, Sign%)
DECLARE SUB SATerm (F$, TermValue!, Sign%)
DECLARE SUB SAFormula (F$, FormulaValue!, Sign%)
DECLARE SUB SyntaxAnalysis (Cell$, CellType$, CellValue!)
DECLARE SUB HelpWindow ()
DECLARE SUB Save ()
DECLARE SUB Load ()
DECLARE SUB EditCell ()
DECLARE SUB PrintInputLine ()
DECLARE SUB Recalculate ()
DECLARE SUB PrintSpreadsheet ()
DECLARE SUB CursorOn ()
DECLARE SUB InitEnvironment ()
DECLARE SUB RunSpreadsheet ()
DECLARE SUB InitSpreadsheet ()
DECLARE FUNCTION DelSpaces$ (S$)

DEFINT A-Z
CONST ColumnNumber = 26        'number of columns of Electronic Table (ET)
CONST RowNumber = 100          'number of rows in ET
CONST VColumn = 5              'number of columns on the screen
CONST VRow = 16                'number of rows on the screen
CONST CellSize = 13            'size of cell
CONST False = 0
CONST True = NOT (False)
DIM SHARED Column, Row, LastColumn, LastRow, FirstRow
DIM SHARED FirstColumn, Name$, EditField$, SyntaxError
DIM SHARED CalcMode, AnyChange, LastButton
DIM SHARED MenuItem, ActiveMenu, MenuNumber
DIM SHARED InputLineLen, WindowLevel, HelpContext
DIM SHARED Table$(RowNumber, ColumnNumber)
DIM SHARED CellType(RowNumber, ColumnNumber) AS STRING * 1
DIM SHARED Value(RowNumber, ColumnNumber) AS SINGLE
DIM SHARED C(21)                'color array
ON ERROR GOTO RunTimeError
CALL Title
CALL InitEnvironment
CALL New
CALL RunSpreadsheet
END
'===========================================================
RunTimeError:
  SyntaxError = 11
RESUME NEXT
'===========================================================
DataBox:
' *** Data for Box procedure ***
DATA Ú, Ä, ¿, ³, À, Ù
DATA É, Í, », º, È, ¼
DATA Õ, Í, ¸, ³, Ô, ¾
DATA ±, ±, ±, ±, ±, ±
'===========================================================
Colors:
' *** Set of Colors ***
DATA 15,1,0,7,15,0,4,8,15,3,10,13,3,11,6,0,7,14,4,0,2
'===========================================================

SUB Box (Row1, Col1, Row2, Col2, Border, Color1, Color2)
' ******************
' * Draw framework *
' ******************
' Row1, Col1 - coordinates of left upper corner of framework
' Row2, Col2 - coordinates of right lower corner of framework
' Border - view of framework
' Color1, Color2 - fore- and background colors of framework

  REDIM B$(4, 6)
  RESTORE DataBox
  FOR I = 1 TO 4
    FOR j = 1 TO 6
      READ B$(I, j)
    NEXT j
  NEXT I
  COLOR Color1, Color2
  LOCATE Row1, Col1
  PRINT B$(Border, 1);
  PRINT STRING$(Col2 - Col1 - 1, B$(Border, 2));
  PRINT B$(Border, 3);
  FOR X = Row1 + 1 TO Row2 - 1
    LOCATE X, Col1
    PRINT B$(Border, 4); SPACE$(Col2 - Col1 - 1); B$(Border, 4);
  NEXT X
  LOCATE Row2, Col1
  PRINT B$(Border, 5);
  PRINT STRING$(Col2 - Col1 - 1, B$(Border, 2));
  PRINT B$(Border, 6);
END SUB

SUB CloseWindow
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Close a current window
  PCOPY WindowLevel, 0
  WindowLevel = WindowLevel - 1
END SUB

SUB CursorOff
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
'  Remove cursor
  COLOR C(1), C(2)
  CALL PrintCell
END SUB

SUB CursorOn
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
'  Set cursor
  COLOR C(11), C(12)
  CALL PrintCell
END SUB

FUNCTION DelSpaces$ (S$)
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Delete all blanks from string S$
  Result$ = "": Rest$ = S$
  DO UNTIL Rest$ = ""
    C$ = LEFT$(Rest$, 1)
    IF C$ <> " " THEN Result$ = Result$ + C$
    Rest$ = MID$(Rest$, 2)
  LOOP
  DelSpaces$ = Result$
END FUNCTION

SUB EditCell
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Editing a field

  HelpContext = 2
  IF LastButton = 13 THEN                     'F4 or Enter
    'No operation
  ELSE
    EditField$ = CHR$(LastButton)
  END IF
  DO
    CALL EditString(EditField$, 23, 8, C(1), C(2), InputLineLen)
    IF LastButton = 27 THEN                   'Esc
      CALL PrintInputLine
      EXIT SUB
    ELSE                                      'Enter
      CALL SyntaxAnalysis((EditField$), CellType$, CellValue!)
      IF SyntaxError THEN
        CALL Errors(Row, Column)
      ELSE
        AnyChange = 1
        IF Row > LastRow THEN LastRow = Row
        IF Column > LastColumn THEN LastColumn = Column
        EXIT DO
      END IF
    END IF
  LOOP
  CellType(Row, Column) = CellType$
  IF CellType$ = "S" THEN
    Table$(Row, Column) = MID$(EditField$, 2)
  ELSE
    Table$(Row, Column) = UCASE$(DelSpaces$(EditField$))
  END IF
  Value(Row, Column) = CellValue!
  CALL CursorOn
  IF CalcMode = 1 THEN                'Auto recalculation
    Recalculate
    PrintSpreadsheet
  END IF
END SUB

SUB EditString (S$, X, Y, Color1, Color2, MaxLen)
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Edit string S$ in position (x,y)
' Color1, Color2 - color of text and background
' MaxLen - maximal length of string
' X, Y - graphic coordinates of first character of string
  OldString$ = S$
  CursorPos = LEN(S$) + 1
  COLOR Color1, Color2
  LOCATE X, Y
  PRINT S$ + SPACE$(MaxLen - LEN(S$))
  GOSUB ShowCursor
  DO
    Key$ = ""
    WHILE Key$ = ""
      Key$ = INKEY$
    WEND
    LastButton = ASC(Key$)
    SELECT CASE Key$
    CASE CHR$(32) TO CHR$(255)                     ' Symbol key
      IF LEN(S$) < MaxLen THEN
        GOSUB HideCursor
        IF CursorPos > LEN(S$) THEN
          S$ = S$ + Key$
        ELSE
          S$ = LEFT$(S$, CursorPos - 1) + Key$ + MID$(S$, CursorPos)
        END IF
        CursorPos = CursorPos + 1
        LOCATE X, Y
        PRINT S$
        GOSUB ShowCursor
      ELSE
        BEEP
      END IF
    CASE CHR$(0) + CHR$(75)                       ' Left
      IF CursorPos > 1 THEN
        GOSUB HideCursor
        CursorPos = CursorPos - 1
        GOSUB ShowCursor
      END IF
    CASE CHR$(0) + CHR$(77)                       ' Right
      IF CursorPos <= LEN(S$) THEN
        GOSUB HideCursor
        CursorPos = CursorPos + 1
        GOSUB ShowCursor
      END IF
    CASE CHR$(8)                                  ' Backspace
      IF CursorPos > 1 THEN
        GOSUB HideCursor
        S$ = LEFT$(S$, CursorPos - 2) + MID$(S$, CursorPos)
        CursorPos = CursorPos - 1
        LOCATE X, Y
        PRINT S$ + " "
        GOSUB ShowCursor
      END IF
    CASE CHR$(0) + CHR$(83)                       ' Delete
      IF CursorPos <= LEN(S$) THEN
        GOSUB HideCursor
        LOCATE X, Y
        S$ = LEFT$(S$, CursorPos - 1) + MID$(S$, CursorPos + 1)
        PRINT S$ + " "
        GOSUB ShowCursor
      END IF
    CASE CHR$(13)                                 ' Enter
      GOSUB HideCursor
      EXIT SUB
    CASE CHR$(27)                                 ' Esc
      GOSUB HideCursor
      S$ = OldString$
      LOCATE X, Y
      PRINT S$ + SPACE$(MaxLen - LEN(S$))
      EXIT SUB
    CASE CHR$(0) + CHR$(71)                        ' Home
      GOSUB HideCursor
      CursorPos = 1
      GOSUB ShowCursor
    CASE CHR$(0) + CHR$(79)                        ' End
      GOSUB HideCursor
      CursorPos = LEN(S$) + 1
      GOSUB ShowCursor
    CASE CHR$(0) + CHR$(59)                        ' F1
      CALL HelpWindow
      COLOR Color1, Color2
    CASE ELSE                                      ' Another key
      ' No operation
    END SELECT
  LOOP
'=============================================================
ShowCursor:
  COLOR Color2, Color1
  GOSUB HideCursor
  COLOR Color1, Color2
  RETURN
'=============================================================
HideCursor:
  LOCATE X, Y + CursorPos - 1
  IF CursorPos > LEN(S$) THEN
    PRINT " "
  ELSE
    PRINT MID$(S$, CursorPos, 1);
  END IF
  RETURN
'=============================================================
END SUB

SUB Errors (ErRow, ErCol)
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Error window
  CALL OpenWindow(" Error ", 7, 25, 13, 54, C(18), C(19))
  SELECT CASE SyntaxError
    CASE 1
      S$ = "     Operaion expected    "
    CASE 2
      S$ = "   Error in expression    "
    CASE 3
      S$ = "       ')' expected       "
    CASE 4
      S$ = "       '(' expected       "
    CASE 5
      S$ = " Bad number or cell index "
    CASE 6
      S$ = "       ':' expected       "
    CASE 7
      S$ = "     Too large number     "
    CASE 11
      S$ = "  Division by zero in " + CHR$(64 + ErCol) + MID$(STR$(ErRow), 2)
    CASE 20
      S$ = "       Bad file name      "
    CASE ELSE
      S$ = "     Overflow in " + CHR$(64 + ErCol) + MID$(STR$(ErRow), 2)
  END SELECT
  SyntaxError = 0
  LOCATE 10, 27
  COLOR C(18), C(19)
  PRINT S$
  LOCATE 12, 37
  COLOR C(1), C(19)
  PRINT "< Ok >"
  DO
    Key$ = ""
    WHILE Key$ = ""
      Key$ = INKEY$
    WEND
  LOOP UNTIL Key$ = CHR$(13) OR Key$ = CHR$(27)    'Enter or Esc
  CloseWindow
END SUB

SUB HelpWindow
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Global help
SELECT CASE HelpContext
  CASE 1                        'navigation about the table
    CALL OpenWindow(" Help ", 7, 24, 20, 55, C(20), C(21))
    COLOR C(20), C(21)
    LOCATE 8, 26
    PRINT "Cursor movement commands:"
    LOCATE 9, 26
    PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    LOCATE 10, 28
    PRINT "Cell left     Left arrow"
    LOCATE 11, 28
    PRINT "Cell right    Right arrow"
    LOCATE 12, 28
    PRINT "Cell up       Up arrow"
    LOCATE 13, 28
    PRINT "Cell down     Down arrow"
    LOCATE 14, 28
    PRINT "Page up       PgUp"
    LOCATE 15, 28
    PRINT "Page down     PgDn"
    LOCATE 16, 28
    PRINT "Into cell A1  Home "
    LOCATE 17, 26
    PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    LOCATE 18, 26
    PRINT "Exit to menu:   Alt"
    COLOR C(1), C(21)
    LOCATE 19, 36
    PRINT "< Ok >"
  CASE 2                        'editing a cell of table
    CALL OpenWindow(" Help ", 3, 24, 23, 63, C(20), C(21))
    COLOR C(20), C(21)
    LOCATE 4, 26
    PRINT "Text editor commands:"
    LOCATE 5, 26
    PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    LOCATE 6, 28
    PRINT "Cursor left            Left arrow"
    LOCATE 7, 28
    PRINT "Cursor right           Right arrow"
    LOCATE 8, 28
    PRINT "Left of line           Home"
    LOCATE 9, 28
    PRINT "Right of line          End"
    LOCATE 10, 28
    PRINT "Delete character left  Backspace"
    LOCATE 11, 28
    PRINT "Delete character       Del"
    LOCATE 13, 26
    PRINT "Function:"
    LOCATE 14, 26
    PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    LOCATE 15, 28
    PRINT "SIN(x)     sine of x radians"
    LOCATE 16, 28
    PRINT "COS(x)     cosine of x radians"
    LOCATE 17, 28
    PRINT "LOG(x)     natural logarithm of x"
    LOCATE 18, 28
    PRINT "EXP(x)     eraised to the power x"
    LOCATE 19, 28
    PRINT "SQR(x)     square root of x"
    LOCATE 20, 28
    PRINT "SUM(X:Y)   sum of values from"
    LOCATE 21, 39
    PRINT "range X:Y"
    COLOR C(1), C(21)
    LOCATE 22, 41
    PRINT "< Ok >"
  CASE 3                        'Entering filename
    CALL OpenWindow(" Help ", 7, 20, 21, 67, C(20), C(21))
    COLOR C(20), C(21)
    LOCATE 9, 24
    PRINT "Save"
    LOCATE 10, 21
    PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    LOCATE 11, 21
    PRINT "   If you attempt to save a NONAME  work file,"
    LOCATE 12, 21
    PRINT "you are  prompted to  rename it  first. If you"
    LOCATE 13, 21
    PRINT "just press Enter, file will be saved under the"
    LOCATE 14, 21
    PRINT "name NONAME."
    LOCATE 16, 24
    PRINT "Load"
    LOCATE 17, 21
    PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    LOCATE 18, 21
    PRINT "   At the prompt you can  enter any legal file"
    LOCATE 19, 21
    PRINT "name."
    COLOR C(1), C(21)
    LOCATE 20, 41
    PRINT "< Ok >"
  END SELECT
  DO
    Key$ = ""
    WHILE Key$ = ""
    Key$ = INKEY$
  WEND
  LOOP UNTIL Key$ = CHR$(13) OR Key$ = CHR$(27)  'Enter or Esc
  CloseWindow
END SUB

SUB InitEnvironment
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
'  Open main window
' ********************************
' *   Initialize data for menu   *
' ********************************
' C(1), C(2) - color of text and background of main screen
' C(3), C(4) - color of text and background of menu
' C(5), C(6) - color of text and background of current menu option
' C(7) - color of background of warning message
' C(8) - color of shadow of pull-down menu
' C(9), C(10) - color of text and background of information message
' C(11), C(12) - color of text and background of current cell
' C(13) - color of framework of electronic table
' C(14) - index of cell
' C(15) - color of border
' C(16), C(17) - color of text and background of information window
' C(18), C(19) - color of text and background of error window
' C(20), C(21) - color of text and background of help window
'----------------------------------------------------------
' *** Selection of Color Set ***
  PALETTE 6, 63
  RESTORE Colors
  FOR I = 1 TO 21
    READ C(I)
  NEXT I
'----------------------------------------------------------
  SCREEN 0
  MenuNumber = 2       'number of menu options
  MenuItem = 1         'number of current option in main menu
  ActiveMenu = False   'not activate menu
  Menu
  ActiveMenu = True
  InputLineLen = 70    'length of entry string
  WindowLevel = 0      'number of windows on the screen
  HelpContext = 1      'context for help
END SUB

SUB InitSpreadsheet
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
'  Initialization of electronic table
  ' Spreadsheet name
  Box 2, 1, 24, 80, 2, C(15), C(2)
  CALL PrintName
  'Border
  COLOR C(13), C(2)
  LOCATE 3, 2
  PRINT ("ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿");
  LOCATE 4, 2
  PRINT ("³      ³             ³             ³             ³             ³             ³");
  LOCATE 5, 2
  PRINT ("ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´");
  FOR I = 1 TO VRow
  LOCATE I + 5, 2
  PRINT ("³      ³             ³             ³             ³             ³             ³");
  NEXT I
  LOCATE 22, 2
  PRINT ("ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ");
  'Cursor position
  AnyChange = 0
  Row = 1
  Column = 1
  FirstRow = 1
  FirstColumn = 1
  CALL PrintSpreadsheet
 END SUB

SUB Load
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Load table
  HelpContext = 3
  CALL OpenWindow(" Load ", 7, 25, 13, 54, C(16), C(17))
  LOCATE 10, 28
  COLOR C(16), C(17)
  PRINT "File Name :"
  OldName$ = Name$
  DO
    DO
      TrueName = 0
      CALL EditString(NewName$, 10, 41, C(16), C(17), 8)
      IF LastButton = 27 THEN                      'Esc
        Name$ = OldName$
        CALL CloseWindow
        EXIT SUB
      END IF
      GOSUB NewFileName
    LOOP UNTIL TrueName
    OPEN NewName$ + ".tab" FOR INPUT AS #1
    INPUT #1, C$
    IF C$ <> "ü" OR ERR THEN
      SyntaxError = 20
      CALL Errors(Row, Column)
    ELSE
      EXIT DO
    END IF
  LOOP
  ' Load file
  Name$ = NewName$
  INPUT #1, LastRow
  INPUT #1, LastColumn
  FOR I = 1 TO LastRow
    FOR j = 1 TO LastColumn
      INPUT #1, S$
      IF S$ = "" THEN
        CellType(I, j) = ""
        Table$(I, j) = ""
        Value(I, j) = 0
      ELSEIF LEFT$(S$, 1) = "ü" THEN
        CellType(I, j) = "S"
        Table$(I, j) = MID$(S$, 2)
        Value(I, j) = 0
      ELSE
        CellType(I, j) = "F"
        Table$(I, j) = S$
        CALL SyntaxAnalysis((S$), "F", Value(I, j))
      END IF
    NEXT j
  NEXT I
  CLOSE #1
  CALL CloseWindow
  CALL InitSpreadsheet
  EXIT SUB
'=============================================================
NewFileName:
  DO
    IF NewName$ = "" THEN
      TrueName = 0
      BEEP
      RETURN
    ELSEIF LEFT$(NewName$, 1) = " " THEN
      NewName$ = MID$(NewName$, 2)
    ELSE
      EXIT DO
    END IF
  LOOP
  FOR I = 1 TO LEN(NewName$)
    C = ASC(MID$(NewName$, I, 1))
    SELECT CASE C
      CASE 48 TO 57, 65 TO 90, 95, 97 TO 122  'Letters or digits
        'No operation
      CASE ELSE
        SyntaxError = 20
        CALL Errors(Row, Column)
        TrueName = 0
        RETURN
    END SELECT
  NEXT I
  TrueName = 1
  RETURN
'=============================================================
END SUB

SUB Menu
' Pop-down menu
'-------------------------------------------------------------
' MenuNumber - number of options in main menu
' MenuItem - number of an option in main menu
' SubMenuItem - number of option in submenu
' ActiveMenu = False - output menu onto screen and exit from Menu
'-------------------------------------------------------------
  VIEW PRINT      'text view field - whole screen
  CurrentItem = 0 'number of item in main menu
  SV = 0          'number of item in submenu
  DIM TextMM$(MenuNumber), Help$(MenuNumber)
  DIM MRow(MenuNumber), MCol(MenuNumber), NV(MenuNumber)
  GOSUB InitTextMainMenu
  GOSUB MainMenuOnScreen
  IF ActiveMenu = False THEN EXIT SUB   'exit from menu
  PCOPY 0, 1
  CurrentItem = MenuItem
  GOSUB MainMenuOnScreen
  GOSUB SelectMenuItem
  IF LastButton <> 27 THEN GOSUB Action          'Not Esc
EXIT SUB
'=============================================================
CursorOff:
' *** Restore screen and remove cursor in main menu ***
  PCOPY 1, 0
  CurrentItem = 0
  GOSUB MainMenuOnScreen
RETURN
'=============================================================
Down:
' *** Processing Down key***
  SELECT CASE NV(CurrentItem)
  CASE 0, 1
    IF SV = 0 THEN
      SV = 1
      GOSUB SubMenuOnScreen
    END IF
  CASE ELSE
    IF SV = 0 THEN
      SV = 1
      GOSUB SubMenuOnScreen
    ELSE
      SV = SV MOD NV(CurrentItem) + 1
      GOSUB TextSubMenuOnScreen
    END IF
  END SELECT
RETURN
'=============================================================
InitTextMainMenu:
' *** Initialize data for main menu ***
' TextMM$(I) - text of I-st item in main menu
' MRow(I), MCol(I) - coordinates of the I-st item of main menu
' Help$(I) - message for I-st item of main menu
' NV(I) - number of items in a submenu of the I-st item of main menu
' *** ’¥ªáâ ¬¥­î ***
  TextMM$(1) = " File "
  TextMM$(2) = " Calculation "

' *** Arrangement of menu items ***
  MRow(1) = 1: MCol(1) = 4
  MRow(2) = 1: MCol(2) = 11

' *** Information messages ***
  Help$(0) = " <F1=Help> <F2=Save> <F3=Load> <F4=Edit> "
  Help$(0) = Help$(0) + "<F5=Calculate>" + SPACE$(24)
  Help$(1) = "Enter=Display Menu   Esc=Cancel   Arrow=Next Item"
  Help$(2) = Help$(1)

' *** Number of items in submenu ***
  NV(0) = 0
  NV(1) = 4
  NV(2) = 2

RETURN
'=============================================================
InitTextSubMenu:
' ************************************************
' *   Initializing data for pull-down submenu    *
' *    of CurrentItem item of main menu          *
' ************************************************
' WSM - width of text of submenu
' SMCol - position of left column of submenu
' SText$(I) - text of I-st item of submenu
' SHelp$(I) - message for I-st item of submenu

REDIM SText$(NV(CurrentItem)), SHelp$(NV(CurrentItem))
SELECT CASE CurrentItem
CASE 1                            '*** File ***
  SMCol = 4: WSM = 6
  ' *** Text submenu ***
  SText$(1) = " New"
  SText$(2) = " Save"
  SText$(3) = " Load"
  SText$(4) = " Exit"
  ' *** Information messages ***
  SHelp$(1) = "Removes currently loaded spreadsheet from memory"
  SHelp$(2) = "Saves current spreadsheet"
  SHelp$(3) = "Loads new spreadsheet into memory"
  SHelp$(4) = "Returns to DOS"
CASE 2                            '*** Calculation ***
  SMCol = 11: WSM = 13
  ' *** Text of submenu ***
  SText$(1) = " ( )  Auto"
  SText$(2) = " ( )  Manual"
  IF CalcMode = 0 THEN
    MID$(SText$(2), 3) = "û"
    MID$(SText$(1), 3) = " "
  ELSE
    MID$(SText$(1), 3) = "û"
    MID$(SText$(2), 3) = " "
  END IF
  ' *** Information messages ***
  SHelp$(1) = "Auto recalculation"
  SHelp$(2) = "Manual recalculation"
END SELECT
RETURN
'=============================================================
MainMenuOnScreen:
' *** Output of main menu onto screen ***
COLOR C(3), C(4)
LOCATE 1, 1
PRINT SPACE$(80);
FOR I = 1 TO MenuNumber
  LOCATE MRow(I), MCol(I)
  IF I <> CurrentItem THEN
    PRINT TextMM$(I);
  ELSE
    COLOR C(5), C(6)
    PRINT TextMM$(I);
    COLOR C(3), C(4)
  END IF
NEXT I
IF SV = 0 OR NV(CurrentItem) = 0 THEN
  COLOR C(9), C(10)
  Hlp$ = Help$(CurrentItem)
  GOSUB ShowInformation
END IF
RETURN
'=============================================================
MenuOnScreen:
' *** Output of menu on screen ***
  IF SV = 0 THEN
    GOSUB MainMenuOnScreen
  ELSE
    PCOPY 1, 0
    GOSUB MainMenuOnScreen
    SV = 1
    GOSUB SubMenuOnScreen
  END IF
RETURN
'=============================================================
SelectMenuItem:
' *** Choosing a menu item ***
  DO
    DO
      Kbd$ = INKEY$
    LOOP UNTIL Kbd$ <> ""
    LastButton = ASC(Kbd$)
    SELECT CASE Kbd$
    CASE CHR$(0) + CHR$(75)       '*** Left ***
      CurrentItem = (MenuNumber + CurrentItem - 2) MOD MenuNumber + 1
      GOSUB MenuOnScreen
    CASE CHR$(0) + CHR$(77)       '*** Right ***
      CurrentItem = CurrentItem MOD MenuNumber + 1
      GOSUB MenuOnScreen
    CASE CHR$(0) + CHR$(72)       '*** Up ***
      GOSUB Up
    CASE CHR$(0) + CHR$(80)       '*** Down ***
      GOSUB Down
    CASE CHR$(27)                 '*** Escape ***
      IF SV = 0 OR NV(CurrentItem) = 0 THEN
        'Exit from menu without choosing a new item
        GOSUB CursorOff
        EXIT DO
      ELSE
        'Exit from submenu to main one
        SV = 0
        PCOPY 1, 0
        GOSUB MainMenuOnScreen
      END IF
    CASE CHR$(13)                 '*** Enter ***
      SELECT CASE NV(CurrentItem)
      CASE 0
        SubMenuItem = 0
        MenuItem = CurrentItem
        GOSUB CursorOff
        EXIT DO
      CASE ELSE
        IF SV = 0 THEN
          SV = 1
          PCOPY 0, 1
          GOSUB MenuOnScreen
        ELSE
          SubMenuItem = SV
          MenuItem = CurrentItem
          GOSUB CursorOff
          EXIT DO
        END IF
      END SELECT
    END SELECT
  LOOP
RETURN
'=============================================================
ShowInformation:
' *** Output of text Hlp$ in the middle of the last line ***
  LOCATE 25, 1
  PRINT SPACE$(80);
  LOCATE 25, 41 - LEN(Hlp$) / 2
  PRINT Hlp$;
RETURN
'=============================================================
SubMenuOnScreen:
' *** Output of submenu onto screen ***
  IF SV <> 0 AND NV(CurrentItem) <> 0 THEN
    PCOPY 1, 0
    GOSUB MainMenuOnScreen
    SV = 1
    GOSUB InitTextSubMenu
    SMenuNumber = NV(CurrentItem)
    Box 3, SMCol, 4 + SMenuNumber, SMCol + WSM + 1, 4, C(8), C(8)
    Box 2, SMCol - 1, 3 + SMenuNumber, SMCol + WSM, 1, C(3), C(4)
    GOSUB TextSubMenuOnScreen
  END IF
RETURN
'=============================================================
TextSubMenuOnScreen:
' *** Output of submenu text onto screen ***
  COLOR C(3), C(4)
  FOR I = 1 TO NV(CurrentItem)
    LOCATE 2 + I, SMCol
    ST$ = SText$(I) + SPACE$(WSM - LEN(SText$(I)))
    IF I <> SV THEN
      PRINT ST$
    ELSE
      COLOR C(5), C(6)
      PRINT ST$
      COLOR C(9), C(10)
      Hlp$ = SHelp$(SV)
      GOSUB ShowInformation
      COLOR C(3), C(4)
    END IF
  NEXT I
RETURN
'=============================================================
Up:
' *** Processing Up key ***
  SELECT CASE NV(CurrentItem)
  CASE 0, 1
    IF SV = 0 THEN
      SV = 1
      GOSUB SubMenuOnScreen
    END IF
  CASE ELSE
    IF SV = 0 THEN
      SV = 1
      GOSUB SubMenuOnScreen
    ELSE
      IF SV <> 0 AND NV(CurrentItem) > 1 THEN
        SV = (NV(CurrentItem) + SV - 2) MOD NV(CurrentItem) + 1
        GOSUB TextSubMenuOnScreen
      END IF
    END IF
  END SELECT
RETURN
'=============================================================
Action:
  SELECT CASE MenuItem
    CASE 1                             'File
      SELECT CASE SubMenuItem
        CASE 1                          'New
          CALL New
        CASE 2                          'Save
          CALL Save
        CASE 3                          'Load
          CALL Load
        CASE 4                          'Exit
          CALL ProgramExit
      END SELECT
    CASE 2                              'Calculation
      SELECT CASE SubMenuItem
        CASE 1                          'Auto
          CalcMode = 1
          Recalculate
          PrintSpreadsheet
        CASE 2                          'Manual
          CalcMode = 0
      END SELECT
  END SELECT
RETURN
'=============================================================
END SUB

SUB New
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Open new electronic table
  ERASE Table$, CellType, Value
  Name$ = "NONAME"
  LastRow = 0
  LastColumn = 0
  CalcMode = 0      '1 - auto recalculation, 0 - manual recalculation
  CALL InitSpreadsheet
END SUB

SUB OpenWindow (WindowName$, Row1, Col1, Row2, Col2, Color1, Color2)
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Open a window with shadow
' WindowName$ - header of window
' Row1, Col1 - coordinates of left upper corner of window
' Row2, Col2 - coordinates of right lower corner of window
' Color1, Color2 - color of framework and background
 WindowLevel = WindowLevel + 1
 PCOPY 0, WindowLevel
 CALL Box(Row1 + 1, Col1 + 1, Row2 + 1, Col2 + 1, 4, C(8), C(8))
 CALL Box(Row1, Col1, Row2, Col2, 1, Color1, Color2)
 LOCATE Row1, (Col1 + Col2 - LEN(WindowName$)) / 2
 COLOR Color1, Color2
 PRINT WindowName$
END SUB

SUB PrintCell
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Output a curent cell of electronic table on the screen
  X = (Row - FirstRow) + 6
  Y = (Column - FirstColumn) * (CellSize + 1) + 10
  LOCATE X, Y
  SELECT CASE CellType(Row, Column)
    CASE "F"                                     ' Formula
      S$ = STR$(Value(Row, Column))
    CASE "S"                                     ' String
      S$ = Table$(Row, Column)
  END SELECT
  IF LEN(S$) > CellSize THEN
    PRINT LEFT$(S$, CellSize);
  ELSE
    PRINT S$ + SPACE$(CellSize - LEN(S$))
  END IF
END SUB

SUB PrintInputLine
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
'  Output editing string
  SELECT CASE CellType(Row, Column)
    CASE "F"                                    'Formula
         EditField$ = Table$(Row, Column)
    CASE "S"                                    'String
         EditField$ = CHR$(34) + Table$(Row, Column)
    CASE ELSE                                   'Nothing
         EditField$ = ""
  END SELECT
  COLOR C(14), C(2)
  LOCATE 23, 4
  PRINT Row;
  LOCATE 23, 4
  PRINT CHR$(64 + Column)
  COLOR C(1), C(2)
  LOCATE 23, 8
  PRINT EditField$ + SPACE$(InputLineLen - LEN(EditField$))
END SUB

SUB PrintName
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
'  Output title of table
  COLOR C(1), C(2)
  LOCATE 2, 34
  PRINT "ÍÍÍÍÍÍÍÍÍÍÍÍ"
  LOCATE 2, (80 - LEN(Name$)) / 2 - 1
  COLOR C(2), C(15)
  PRINT " "; Name$; " "
END SUB

SUB PrintSpreadsheet
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
'  Draw electronic table

  ' Row numbers
  COLOR C(14), C(2)
  X = 6
  FOR I = FirstRow TO FirstRow + VRow - 1
    LOCATE X, 4
    PRINT USING "###"; I
    X = X + 1
  NEXT I

  ' Letters
  Y = 16
  FOR I = FirstColumn TO FirstColumn + VColumn - 1
    LOCATE 4, Y
    PRINT (CHR$(I + 64));
    Y = Y + CellSize + 1
  NEXT I

  ' Cells
  COLOR C(1), C(2)
  NowRow = Row: NowColumn = Column
  FOR Row = FirstRow TO FirstRow + VRow - 1
    FOR Column = FirstColumn TO FirstColumn + VColumn - 1
      CALL PrintCell
    NEXT Column
  NEXT Row
  Row = NowRow: Column = NowColumn

  CALL CursorOn
  CALL PrintInputLine
END SUB

SUB ProgramExit
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Exit from program
  CALL OpenWindow(" Exit ", 7, 25, 13, 54, C(16), C(17))
  COLOR C(16), C(17)
  LOCATE 10, 30
  PRINT "Do you want to quit?"
  Quit = False
  GOSUB PrintButtons
  GOSUB GetAnswer
  IF Quit THEN
      CLS
      END
  ELSE
      CloseWindow
  END IF
  EXIT SUB
'=============================================================
PrintButtons:
  LOCATE 12, 32
  IF Quit THEN
    COLOR C(1), C(17)
  ELSE
    COLOR C(16), C(17)
  END IF
  PRINT "< Yes >"
  LOCATE 12, 41
  IF Quit THEN
    COLOR C(16), C(17)
  ELSE
    COLOR C(1), C(17)
  END IF
  PRINT "< No >"
  RETURN
'=============================================================
GetAnswer:
  DO
    Key$ = ""
    WHILE Key$ = ""
      Key$ = INKEY$
    WEND
    SELECT CASE Key$
      CASE CHR$(13)                                 'Enter
        EXIT DO
      CASE CHR$(27), "N", "n"                       'Esc or "N"
        Quit = False
        EXIT DO
      CASE "Y", "y"                                 '"Y"
        Quit = True
        EXIT DO
      CASE CHR$(0) + CHR$(75), CHR$(0) + CHR$(77)   'Left or Right
        Quit = NOT (Quit)
        GOSUB PrintButtons
    END SELECT
  LOOP
  RETURN
'=============================================================
END SUB

SUB Recalculate
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Recalculate values of cells of whole ET
  FOR I = 1 TO LastRow
    FOR j = 1 TO LastColumn
      IF CellType(I, j) = "F" THEN            'Formula
        CALL SAFormula((Table$(I, j)), Value(I, j), 1)
        IF SyntaxError THEN
          CALL Errors(I, j)
        END IF
      END IF
    NEXT j
  NEXT I
END SUB

SUB RunSpreadsheet
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Control of ET
DO
  HelpContext = 1
  Key$ = ""
  ScanCode = 0
  WHILE Key$ = "" AND ScanCode <> &H38
    Key$ = INKEY$
    IF (INP(&H61) AND 128) = 0 THEN
      ScanCode = INP(&H60)
    END IF
  WEND
  IF ScanCode = &H38 THEN                 ' Alt
    CALL Menu
  ELSE
    SELECT CASE Key$
    CASE CHR$(32) TO CHR$(255)            ' Symbol
      LastButton = ASC(Key$)
      CALL EditCell
      CASE CHR$(0) + CHR$(71)             ' Cursor Home
      CursorOff
      FirstRow = 1
      FirstColumn = 1
      Row = 1
      Column = 1
      PrintSpreadsheet
    CASE CHR$(0) + CHR$(72)               ' Cursor Up
      IF Row > FirstRow THEN
        CursorOff
        Row = Row - 1
        CursorOn
        PrintInputLine
      ELSEIF FirstRow > 1 THEN
        CursorOff
        FirstRow = FirstRow - 1
        Row = Row - 1
        PrintSpreadsheet
      END IF
    CASE CHR$(0) + CHR$(73)               ' Cursor PageUp
      IF Row > FirstRow THEN
        CursorOff
        Row = FirstRow
        CursorOn
        PrintInputLine
      ELSEIF FirstRow > VRow THEN
        CursorOff
        FirstRow = FirstRow - VRow
        Row = Row - VRow
        PrintSpreadsheet
      ELSEIF FirstRow > 1 THEN
        CursorOff
        FirstRow = 1
        Row = 1
        PrintSpreadsheet
      END IF
    CASE CHR$(0) + CHR$(75)               ' Cursor Left
      IF Column > FirstColumn THEN
        CursorOff
        Column = Column - 1
        CursorOn
        PrintInputLine
      ELSEIF FirstColumn > 1 THEN
        CursorOff
        FirstColumn = FirstColumn - 1
        Column = Column - 1
        PrintSpreadsheet
      END IF
    CASE CHR$(0) + CHR$(77)               ' Cursor Right
      IF Column < FirstColumn + VColumn - 1 THEN
        CursorOff
        Column = Column + 1
        CursorOn
        PrintInputLine
      ELSEIF FirstColumn + VColumn - 1 < ColumnNumber THEN
        CursorOff
        FirstColumn = FirstColumn + 1
        Column = Column + 1
        PrintSpreadsheet
      END IF
    CASE CHR$(0) + CHR$(80)               ' Cursor Down
      IF Row < FirstRow + VRow - 1 THEN
        CursorOff
        Row = Row + 1
        CursorOn
        PrintInputLine
      ELSEIF FirstRow + VRow - 1 < RowNumber THEN
        CursorOff
        FirstRow = FirstRow + 1
        Row = Row + 1
        PrintSpreadsheet
      ELSE
        'No operation
      END IF
    CASE CHR$(0) + CHR$(81)               ' Cursor PageDown
      IF Row < FirstRow + VRow - 1 THEN
        CursorOff
        Row = FirstRow + VRow - 1
        CursorOn
        PrintInputLine
      ELSEIF FirstRow + VRow + VRow - 1 < RowNumber THEN
        CursorOff
        FirstRow = FirstRow + VRow
        Row = Row + VRow
        PrintSpreadsheet
      ELSEIF FirstRow + VRow - 1 < RowNumber THEN
        CursorOff
        FirstRow = RowNumber - VRow + 1
        Row = RowNumber
        PrintSpreadsheet
      END IF
    CASE CHR$(0) + CHR$(59)               ' F1
      CALL HelpWindow
    CASE CHR$(0) + CHR$(60)               ' F2
      CALL Save
    CASE CHR$(0) + CHR$(61)               ' F3
      CALL Load
    CASE CHR$(0) + CHR$(62), CHR$(13)     ' F4 or Enter
      LastButton = 13
      CALL EditCell
    CASE CHR$(0) + CHR$(63)               ' F5
      CALL Recalculate
      CALL PrintSpreadsheet
    END SELECT
  END IF
  LOOP
END SUB

SUB SAFormula (F$, FormulaValue!, Sign)
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Syntax analysis of formula F$
  CALL SAItem(F$, ItemValue!, Sign)
  IF SyntaxError THEN EXIT SUB
  FormulaValue! = ItemValue!
  DO WHILE F$ <> "" AND SyntaxError = 0
    C$ = LEFT$(F$, 1)
    IF C$ = ")" THEN
      SyntaxError = 4
      EXIT DO
    END IF
    IF C$ = "+" OR C$ = "-" THEN
      F$ = MID$(F$, 2)
      CALL SAItem(F$, ItemValue!, 0)
      IF SyntaxError THEN EXIT DO
      SELECT CASE C$
        CASE "+"
          FormulaValue! = FormulaValue! + ItemValue!
        CASE "-"
          FormulaValue! = FormulaValue! - ItemValue!
      END SELECT
    ELSE
      SyntaxError = 1
    END IF
  LOOP
END SUB

SUB SAItem (F$, ItemValue!, Sign)
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Syntax analysis of summand F$
  CALL SATerm(F$, TermValue!, Sign)
  IF SyntaxError THEN EXIT SUB
  ItemValue! = TermValue!
  DO WHILE F$ <> "" AND SyntaxError = 0
    C$ = LEFT$(F$, 1)
    IF C$ = "*" OR C$ = "/" THEN
      F$ = MID$(F$, 2)
      CALL SATerm(F$, TermValue!, 0)
      IF SyntaxError THEN EXIT DO
      SELECT CASE C$
        CASE "*"
          ItemValue! = ItemValue! * TermValue!
        CASE "/"
          ItemValue! = ItemValue! / TermValue!
      END SELECT
    ELSE
      EXIT DO
    END IF
  LOOP
END SUB

SUB SATerm (F$, TermValue!, Sign)
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Syntax analysis of term F$
  IF F$ = "" THEN
    SyntaxError = 2
    EXIT SUB
  END IF
  C$ = LEFT$(F$, 1)
  IF Sign AND (C$ = "+" OR C$ = "-") THEN        'Signed term
    F$ = MID$(F$, 2)
    CALL SATerm(F$, TermValue!, 0)
    IF SyntaxError THEN EXIT SUB
    IF C$ = "-" THEN TermValue! = -TermValue!
  ELSE                                           'Unsigned term
    IF C$ = "(" THEN                             'Formula
      GOSUB FormulaSub
    ELSEIF "0" <= C$ AND C$ <= "9" OR C$ = "." THEN 'Number
      GOSUB NumberSub
    ELSE                               'Function or cell index
      CCC$ = LEFT$(F$, 3)
      SELECT CASE CCC$
        CASE "SIN"
          F$ = MID$(F$, 4)
          GOSUB FormulaSub
          TermValue! = SIN(TermValue!)
        CASE "COS"
          F$ = MID$(F$, 4)
          GOSUB FormulaSub
          TermValue! = COS(TermValue!)
        CASE "EXP"
          F$ = MID$(F$, 4)
          GOSUB FormulaSub
          TermValue! = EXP(TermValue!)
        CASE "LOG"
          F$ = MID$(F$, 4)
          GOSUB FormulaSub
          TermValue! = LOG(TermValue!)
        CASE "SQR"
          F$ = MID$(F$, 4)
          GOSUB FormulaSub
          TermValue! = SQR(TermValue!)
        CASE "SUM"
          F$ = MID$(F$, 4)
          GOSUB SumSub
        CASE ELSE                                'Cell index
          GOSUB CellIndexSub
          TermValue! = Value(Index, ASC(Letter$) - 64)
      END SELECT
    END IF
  END IF
EXIT SUB
'============================================================
FormulaSub:
  F$ = MID$(F$, 2)
  Brackets = 0
  I = 0
  DO WHILE I < LEN(F$) AND Brackets >= 0
    I = I + 1
    C1$ = MID$(F$, I, 1)
    SELECT CASE C1$
    CASE "("
      Brackets = Brackets + 1
    CASE ")"
      Brackets = Brackets - 1
    END SELECT
  LOOP
  IF Brackets >= 0 THEN
    SyntaxError = 3
    EXIT SUB
  END IF
  F1$ = LEFT$(F$, I - 1)
  F$ = MID$(F$, I + 1)
  CALL SAFormula(F1$, TermValue!, 1)
  IF SyntaxError THEN EXIT SUB
RETURN
'============================================================
NumberSub:
  IF LEFT$(F$, 1) = "." THEN
    F$ = MID$(F$, 2)
    GOSUB DigitsSub
    TermValue! = VAL("." + Digits$)
    IF ERR THEN
      SyntaxError = 7
      EXIT SUB
    END IF
    RETURN
  END IF
  GOSUB DigitsSub
  IF LEFT$(F$, 1) <> "." THEN
    TermValue! = VAL(Digits$)
    IF ERR THEN
      SyntaxError = 7
      EXIT SUB
    END IF
    RETURN
  END IF
  Digits1$ = Digits$
  F$ = MID$(F$, 2)
  GOSUB DigitsSub
  TermValue! = VAL(Digits1$ + "." + Digits$)
  IF ERR THEN
    SyntaxError = 7
    EXIT SUB
  END IF
RETURN
'============================================================
CellIndexSub:
  Letter$ = LEFT$(F$, 1)
  IF "A" > Letter$ OR Letter$ > "Z" THEN
    SyntaxError = 2
    EXIT SUB
  END IF
  F$ = MID$(F$, 2)
  GOSUB DigitsSub
  Index = VAL(Digits$)
  IF Index <= 0 OR Index > RowNumber THEN
    SyntaxError = 5
    EXIT SUB
  END IF
RETURN
'============================================================
DigitsSub:
  Digit$ = LEFT$(F$, 1)
  IF F$ = "" OR "0" > Digit$ OR Digit$ > "9" THEN
    SyntaxError = 5
    EXIT SUB
  ELSE
    I = 2
    DO
      Digit$ = MID$(F$, I, 1)
      IF "0" > Digit$ OR Digit$ > "9" THEN EXIT DO
      I = I + 1
    LOOP
    Digits$ = LEFT$(F$, I - 1)
    F$ = MID$(F$, I)
  END IF
RETURN
'============================================================
SumSub:
  IF LEFT$(F$, 1) <> "(" THEN
    SyntaxError = 4
    EXIT SUB
  END IF
  F$ = MID$(F$, 2)
  GOSUB CellIndexSub
  Letter1$ = Letter$
  Index1 = Index
  IF LEFT$(F$, 1) <> ":" THEN
    SyntaxError = 6
    EXIT SUB
  END IF
  F$ = MID$(F$, 2)
  GOSUB CellIndexSub
  IF LEFT$(F$, 1) <> ")" THEN
    SyntaxError = 3
    EXIT SUB
  END IF
  F$ = MID$(F$, 2)
  IF Letter1$ > Letter$ THEN SWAP Letter1$, Letter$
  IF Index1$ > Index$ THEN SWAP Index1$, Index$
  TermValue! = 0
  FOR I = Index1 TO Index
    FOR j = ASC(Letter1$) TO ASC(Letter$)
       TermValue! = TermValue! + Value(I, j - 64)
    NEXT j
  NEXT I
RETURN
'============================================================
END SUB

SUB Save
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Write table on disk
  HelpContext = 3
  CALL OpenWindow(" Save ", 7, 25, 13, 54, C(16), C(17))
  LOCATE 10, 28
  COLOR C(16), C(17)
  PRINT "File Name :"
  OldName$ = Name$
  DO
    TrueName = 0
    CALL EditString(Name$, 10, 41, C(16), C(17), 8)
    IF LastButton = 27 THEN                      'Esc
      Name$ = OldName$
      CALL CloseWindow
      EXIT SUB
    END IF
    GOSUB FileName
  LOOP UNTIL TrueName
  ' Save file
  OPEN Name$ + ".tab" FOR OUTPUT AS #1
  PRINT #1, "ü"
  PRINT #1, LastRow
  PRINT #1, LastColumn
  FOR I = 1 TO LastRow
    FOR j = 1 TO LastColumn
      IF CellType(I, j) = "S" THEN
        PRINT #1, "ü" + Table$(I, j)
      ELSE
        PRINT #1, Table$(I, j)
      END IF
    NEXT j
  NEXT I
  CLOSE #1
  CALL CloseWindow
  CALL PrintName
  EXIT SUB
'=============================================================
FileName:
  FOR I = 1 TO LEN(Name$)
    C = ASC(MID$(Name$, I, 1))
    SELECT CASE C
      CASE 48 TO 57, 65 TO 90, 95, 97 TO 122  'Letters or digits
        'No operation
      CASE ELSE
        SyntaxError = 20
        CALL Errors(Row, Column)
        TrueName = 0
        RETURN
    END SELECT
  NEXT I
  TrueName = 1
RETURN
'=============================================================
END SUB

SUB SyntaxAnalysis (Cell$, CellType$, CellValue!)
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
' Syntax analysis of table's cell
  SyntaxError = 0
  IF Cell$ = "" THEN                              'Empty cell
     CellType$ = ""
     CellValue! = 0
  ELSEIF LEFT$(Cell$, 1) = CHR$(34) THEN          'String
     CellType$ = "S"
     CellValue! = 0
  ELSE                                            'Formula
     CellType$ = "F"
     Formula$ = UCASE$(DelSpaces$(Cell$))
     CALL SAFormula((Formula$), CellValue!, 1)
  END IF
END SUB

DEFSNG A-Z
SUB Title
SCREEN 9
PALETTE 10, 1
COLOR 10, 15
DEFINT X-Y
LOCATE 25, 1
PRINT "S P R E A D S H E E T";
COLOR 1, 1
FOR X = 0 TO 170
  X1 = 2 * X
  FOR Y = 0 TO 11
    Z = POINT(X, 349 - Y)
    IF Z <> 0 THEN
      Y1 = 2 * Y
      PSET (160 + X1, 120 - Y1), 15
    END IF
  NEXT
NEXT
LOCATE 25, 1
PRINT STRING$(70, " ");
LOCATE 25, 1
PRINT "E A S Y C A L C";
FOR X = 0 TO 160
  X1 = 3 * X
  FOR Y = 0 TO 11
    Z = POINT(X, 349 - Y)
    IF Z <> 0 THEN
      Y1 = 4 * Y
      CIRCLE (150 + X1, 190 - Y1), 3, 15
    END IF
  NEXT
NEXT
COLOR 15, 1
LOCATE 22, 34
PRINT "S.E.Emelchenkov"
LOCATE 23, 33
PRINT "Russia,  Smolensk";
F$ = INPUT$(1)
END SUB

