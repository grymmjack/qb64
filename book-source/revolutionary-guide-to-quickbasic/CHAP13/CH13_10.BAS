REM Data Entry Panels
REM \CHAP13\CH13_10.BAS

DEFINT A-Z

'Sub and function declarations
DECLARE SUB Answer (X0, Y0, LX, MaxLText, Text$, NumberText$)
DECLARE SUB Box (Row1%, Col1%, row2%, col2%)
DECLARE SUB Center (Row%, Text$)
DECLARE SUB EditRecords ()
DECLARE SUB LoadBase ()
DECLARE SUB PrintHelpLine (Help$)
DECLARE SUB PopUpWindow (Row1%, Coll1%, row2%, Coll2%)
DECLARE SUB SaveBase ()
DECLARE SUB TextHelp ()
DECLARE FUNCTION MaxLen% (Array$(), MaxCol%)
DECLARE FUNCTION Number% (T$)
DECLARE FUNCTION PosChoise% (Names$(), Max%, Row1%, Col1%, CurrentKey%)

CONST m = 7                                'number of records to edit
CONST n = 6                                'number of fields in a record
CONST TRUE = -1
CONST FALSE = NOT TRUE

TYPE RecordType
    Liner             AS STRING * 20
    YearOfLaunch      AS STRING * 4
    Dockyard          AS STRING * 20
    Country           AS STRING * 16
    Town              AS STRING * 15
    ShipOwningCo      AS STRING * 20
END TYPE

DIM SHARED record(1 TO m)  AS RecordType   'Stores the m Record
DIM SHARED TextWin$(15)                    'help menu
DIM SHARED Color1, Color2, Color3, Color4
DIM SHARED Color5, Color6

'shared variables for entry panel and pop-up help window
DIM SHARED edit$(n), Row(n)
DIM SHARED L$, CountryWind
DIM SHARED NumField, Col, Text$, FinishWin

'F1-pop-up help window
ON KEY(1) GOSUB F1help
KEY(1) ON

Color1 = 1
Color2 = 15
Color3 = 3
Color4 = 0
Color5 = 14
Color6 = 7

    OPEN "Liners.dbf" FOR RANDOM AS #1 LEN = LEN(record(1))
    LoadBase            'Read data from file into array of records
    EditRecords         'Edit data
    SaveBase            'Write data in file
    CLS
    CLOSE #1
    END

'Pop-up menu for the fourth field, "Country"
F1help:
       IF NumField = 4 THEN
	   PopUpWindow 13, 41, 22, 68
       END IF
       RETURN

SUB Answer (X0, Y0, LX, MaxLText, Text$, NumberText$)
' ********************************************
' * Editing a number or a character string   *
' ********************************************
' NumberText$ = "Number" - editing a number
' NumberText$ = "Text" - editing a character string
' X0, Y0 - coordinates of the start of the editing area
' LX - length of editing zone ( LX <= MaxLText )
' MaxLText - maximal length of the string being edited
' Text$ - result of the editing
GOSUB Init
GOSUB OnScreen
DoExit = FALSE
u$ = Text$
CountryWind = FALSE
DO
  DO
    IF CountryWind = TRUE THEN
       Text$ = edit$(4)
       CountryWind = FALSE
    END IF
    L$ = INKEY$
  LOOP WHILE L$ = ""
  SELECT CASE L$
  CASE CHR$(0) + CHR$(82)          'Ins
    GOSUB Insert
  CASE CHR$(0) + CHR$(83)          'Del
    GOSUB Delete
  CASE CHR$(0) + CHR$(75)          'Cursor-left
    GOSUB CursorLeft
  CASE CHR$(0) + CHR$(77)          'Cursor-right
    GOSUB CursorRight
  CASE CHR$(0) + CHR$(71)          'Home
    GOSUB Home
  CASE CHR$(0) + CHR$(79)          'End
    GOSUB End1
  CASE CHR$(8)                     'BackSpace
    GOSUB BackSpace
  CASE CHR$(32) TO CHR$(255)       'Characters
    GOSUB AddSymbol
   CASE ELSE
   DoExit = TRUE
  END SELECT
  IF DoExit = TRUE THEN
    IF NumberText$ = "Number" THEN
      Text$ = RTRIM$(Text$)
      IF Number(Text$) = TRUE THEN
	 GOSUB EnterNumber
	 EXIT DO
      ELSE
	 DoExit = FALSE
      END IF
   ELSE
      EXIT DO
  END IF
 END IF
LOOP
	LOCATE , , , 7

EXIT SUB
'===========================================================
Init:
' *** Initialization of procedure ***
  COLOR Color5, Color1
  LOCATE X0, Y0
  PointerB = 1
  PointerC = 1
  Ins = FALSE
RETURN
'===========================================================
AddSymbol:
' *** Add character to string Text$ ***
  NL = PointerB + PointerC - 1
  SELECT CASE Ins
    CASE TRUE                          'insertion mode
      IF RIGHT$(Text$, 1) <> " " THEN
	BEEP
       PointerC = PointerC - 1
      ELSE
	IF NL = MaxLText THEN
	  MID$(Text$, NL) = L$
	ELSE
	  TL$ = LEFT$(Text$, NL - 1)
	  TR$ = MID$(Text$, NL, MaxLText - NL)
	  Text$ = LEFT$(TL$ + L$ + TR$, MaxLText)
	END IF
      END IF
    CASE FALSE  ', True                     'replacement mode
      IF PointerC <= LX AND LEN(Text$) >= NL THEN
	MID$(Text$, NL) = L$
      ELSE
	BEEP
      END IF
  END SELECT
  GOSUB CursorRight
  GOSUB OnScreen
RETURN
'===========================================================
Cursor:
' *** Change position of cursor ***
SELECT CASE Crsr$
  CASE "right"                   'move cursot right
    IF PointerC < LX THEN
      PointerC = PointerC + 1
    ELSE
      IF PointerB + PointerC - 1 < MaxLText THEN
	PointerB = PointerB + 1
      ELSE
	IF PointerC = LX THEN
	  '*** cursor at the end of word Text$ ***
	DoExit = TRUE           'end of field
	L$ = CHR$(0) + CHR$(77) 'cursor' direction - to the right
	ELSE
	  BEEP
	END IF
      END IF
    END IF
  CASE "left"                    'move cursor left
    IF PointerC > 1 THEN
      PointerC = PointerC - 1
    ELSE
      IF PointerB > 1 THEN
	PointerB = PointerB - 1
      ELSE                       'cursor at the beginning of the word Text$

	DoExit = TRUE           'end of field at the left
	L$ = CHR$(0) + CHR$(75) 'cursor's direction - to the left
      END IF
    END IF
END SELECT
RETURN
'==========================================================
OnScreen:
' *** Output text fragment and cursor onto screen ***
  LOCATE X0, Y0
  PRINT Text$
  IF PointerC <= LX THEN
    NL = PointerB + PointerC - 1
    LOCATE X0, Y0 + PointerC - 1, 1
  ELSE
    LOCATE , , 0             'hide cursor
  END IF
RETURN
'===========================================================
Insert:
' *** Change value of Ins and the form of cursor ***
  IF Ins = TRUE THEN
    Ins = FALSE
    LOCATE X0, Y0, , 7
  ELSE
    Ins = TRUE
    LOCATE X0, Y0, , 0, 7
  END IF
  GOSUB OnScreen
RETURN
'===========================================================
CursorLeft:
' *** move cursor left ***
  Crsr$ = "left"
  GOSUB Cursor
  GOSUB OnScreen
RETURN
'===========================================================
CursorRight:
' *** Move cursor right ***
  Crsr$ = "right"
  GOSUB Cursor
  GOSUB OnScreen
  RETURN
'===========================================================
BackSpace:
' *** Delete character at the left of cursor ***
  NL = PointerB + PointerC - 1
  IF NL > 1 THEN
    TL$ = LEFT$(Text$, NL - 2)
    TR$ = RIGHT$(Text$, MaxLText - NL + 1)
    Text$ = TL$ + TR$ + " "
    GOSUB CursorLeft
    GOSUB OnScreen
  ELSE
    BEEP
  END IF
RETURN
'===========================================================
Delete:
' *** Delete character at cursor ***
  NL = PointerB + PointerC - 1
  IF PointerC <= LX THEN
    TL$ = LEFT$(Text$, NL - 1)
    TR$ = RIGHT$(Text$, MaxLText - NL)
    Text$ = TL$ + TR$ + " "
    GOSUB OnScreen
  ELSE
    BEEP
  END IF
RETURN
'===========================================================
Home:
' *** Move cursor to start of line ***
  PointerB = 1
  PointerC = 1
  GOSUB OnScreen
RETURN
'===========================================================
End1:
' *** Move cursor to end of line ***
  LTxt = LEN(RTRIM$(Text$))
  SELECT CASE LTxt
  CASE IS < LX
    PointerB = 1
    PointerC = LTxt + 1
  CASE IS = MaxLText
    PointerB = MaxLText - LX + 1
    PointerC = LX
  CASE IS >= LX
    PointerB = LTxt - LX + 2
    PointerC = LX
  END SELECT
  GOSUB OnScreen
RETURN
'===========================================================
EnterNumber:
' *** Finish entering number ***
  IF Number(Text$) = FALSE THEN
    GOSUB OnScreen
  ELSE
      u$ = RTRIM$(LTRIM$(Text$))
      IF u$ = "0" THEN u$ = " "
      Text$ = SPACE$(LX - LEN(u$)) + u$
      LOCATE X0, Y0
      PRINT Text$
  END IF
RETURN
'===========================================================

END SUB

'Draw a box on the screen between the given coordinates.
SUB Box (Row1, Col1, row2, col2) STATIC

    BoxWidth = col2 - Col1 + 1

    LOCATE Row1, Col1
    PRINT "┌"; STRING$(BoxWidth - 2, "─"); "┐";

    FOR a = Row1 + 1 TO row2 - 1
	LOCATE a, Col1
	PRINT "│"; SPACE$(BoxWidth - 2); "│";
    NEXT a

    LOCATE row2, Col1
    PRINT "└"; STRING$(BoxWidth - 2, "─"); "┘";

END SUB

'  Center text on the given row.
SUB Center (Row, Text$)
    LOCATE Row, 41 - LEN(Text$) / 2
    PRINT Text$;
END SUB

SUB EditRecords

  'names of fields and their length
  REDIM Help$(n), Vis(n)

  'initial values of variables
  GOSUB InitVar
  'Draw the screen
  GOSUB DrawScreen

  'Loop until F2 or <ESC> is pressed
  Finished = FALSE
  'Initial number of record for array edit()
  NumRec = 1
  DO

    'Transfer record to one-dimensional array edit()
    GOSUB EditRecordsLoadData
    GOSUB PrintEdit

    'Editing fields of record
    'edit$(NumField) - field to edit
    'NumField - number of field
    NumField = 1
    FinishDo = FALSE
    DO
	'VN - length of field,  RN,Col -location of field on the screen
	VN = Vis(NumField)
	RN = Row(NumField)
	'editing field edit$()
	Answer RN, Col, VN, VN, edit$(NumField), "Text"
	'analyze control key pressing
	GOSUB Control
    LOOP UNTIL FinishDo OR Finished

    'record m is followed by record 1
    IF NumRec > m THEN NumRec = 1
    IF NumRec < 1 THEN NumRec = m

    IF Finished THEN
       EXIT SUB
    END IF
  LOOP

    Finished = TRUE
    Save = TRUE

EXIT SUB

EditRecordsHideCursor:
    COLOR Color4, Color6
    LOCATE Row(NumField), Col
    PRINT LEFT$(edit$(NumField), Vis(NumField));
    RETURN

InitVar:
    'TextHelp variables
    Help$(1) = "  Name of liner  " + CHR$(16)
    Help$(2) = "  Year of launch  " + CHR$(16)
    Help$(3) = "  Dockyard  " + CHR$(16)
    Help$(4) = "  Country <F1=Help>  " + CHR$(16)
    Help$(5) = "  Town	" + CHR$(16)
    Help$(6) = "  Ship Owning Co  " + CHR$(16)
    Help1$ = " <PgDn=Forward> < PgUp = Back >"
    Help2$ = " <F2=Save and Exit> < Esc = Abort > "
    Help1$ = Help1$ + Help2$

    'initial positions of the fields to edit and their length
    Col = 38
    Row(1) = 4: Row(2) = 7: Row(3) = 10: Row(4) = 13
    Vis(1) = 20: Vis(2) = 4: Vis(3) = 20:  Vis(4) = 16
    Row(5) = 16: Row(6) = 19
    Vis(5) = 15: Vis(6) = 20
    RETURN

EditRecordsLoadData:
    'Transfer of the next record of array into a one-dimensional
    'array of string variables to edit
    edit$(1) = record(NumRec).Liner
    edit$(2) = record(NumRec).YearOfLaunch
    edit$(3) = record(NumRec).Dockyard
    edit$(4) = record(NumRec).Country
    edit$(5) = record(NumRec).Town
    edit$(6) = record(NumRec).ShipOwningCo
    RETURN

DrawScreen:
    COLOR Color6, Color3
    CLS
    LOCATE 1, 69
    PRINT "Editor"
    COLOR Color4, Color4
    Box 3, 7, 22, 76
    COLOR Color1, Color2
    Box 2, 5, 21, 74
    COLOR Color2, Color1
    LOCATE 2, 18: PRINT " Holders of the Blue Ribbon of the Atlantic "
    FOR a = 1 TO n
	COLOR Color1, Color2
	LOCATE Row(a), 10
	PRINT Help$(a)
	'pамки полей
	Box Row(a) - 1, Col - 1, Row(a) + 1, Col + Vis(a) + 1
    NEXT a
    PrintHelpLine Help1$
    RETURN

PrintEdit:
    COLOR Color2, Color1
    LOCATE 2, 6: PRINT NumRec
    COLOR Color4, Color6
    FOR a = 1 TO n
	LOCATE Row(a), Col
	PRINT edit$(a)
    NEXT a
    RETURN


Control:
	SELECT CASE L$
	    CASE CHR$(0) + "I"                   'to previous page
	    IF NumRec > 1 THEN
		    GOSUB EditRecordsSaveData
		    NumRec = NumRec - 1
		    FinishDo = TRUE
		END IF
	    CASE CHR$(0) + "Q"                   'to  next page
		GOSUB EditRecordsSaveData
		NumRec = NumRec + 1
		FinishDo = TRUE
	    CASE CHR$(0) + "H"                   'Up Arrow
		GOSUB EditRecordsHideCursor      'Hide Cursor so it can move
		IF NumField > 1 THEN
		    NumField = NumField - 1
		ELSE
		    GOSUB EditRecordsSaveData
		    NumRec = NumRec - 1
		    FinishDo = TRUE
		END IF
	    CASE CHR$(0) + "P"                   'Down Arrow
		GOSUB EditRecordsHideCursor      'Hide Cursor so it can move
		IF NumField < n THEN
		    NumField = NumField + 1
		ELSE
		    GOSUB EditRecordsSaveData
		    NumRec = NumRec + 1
		    FinishDo = TRUE
		END IF
	    CASE CHR$(0) + "M"                   'to first bound of the field
		GOSUB EditRecordsHideCursor      'Hide Cursor so it can move
		IF NumField = n THEN
		    GOSUB EditRecordsSaveData
		    NumRec = NumRec + 1
		    FinishDo = TRUE
		END IF
		NumField = (NumField) MOD (n) + 1
	    CASE CHR$(9), CHR$(13)                 'Tab or Enter
		GOSUB EditRecordsHideCursor        'Hide Cursor so it can move
		IF NumField = n THEN
		    GOSUB EditRecordsSaveData
		    NumRec = NumRec + 1
		    FinishDo = TRUE
		ELSE
		    NumField = NumField + 1
		END IF
	    CASE CHR$(0) + "<"                      'F2
		GOSUB EditRecordsSaveData
		FinishDo = TRUE
		Finished = TRUE
		Save = TRUE
	    CASE CHR$(27)                           'Esc
		FinishDo = TRUE
		Finished = TRUE
		Save = FALSE
	    CASE ELSE
		BEEP
	END SELECT
	RETURN

EditRecordsSaveData:
    'Transfer of the edited one-dimensional array
    'of character variables into the record of the array
    record(NumRec).Liner = edit$(1)
    record(NumRec).YearOfLaunch = edit$(2)
    record(NumRec).Dockyard = edit$(3)
    record(NumRec).Country = edit$(4)
    record(NumRec).Town = edit$(5)
    record(NumRec).ShipOwningCo = edit$(6)
    RETURN


END SUB

SUB LoadBase
'reading data from file #1
    FOR x = 1 TO m
	GET #1, x, record(x)
    NEXT x
END SUB

FUNCTION MaxLen% (Array$(), MaxCol%)
'returns a maximal length of element (from 0 to MaxCol%) of  Array$()
'Array$ - array of string fields
'MaxCol - number of fields to view
'MaxLen - maximal length of field

XMaxlen% = LEN(Array$(0))
FOR i = 1 TO MaxCol% - 1
    IF LEN(Array$(i)) > XMaxlen% THEN
	XMaxlen% = LEN(Array$(i))
    END IF
NEXT
MaxLen% = XMaxlen%

END FUNCTION

FUNCTION Number (T$)
' ***********************
' * T$ - number or not? *
' ***********************
T$ = RTRIM$(LTRIM$(T$))
SELECT CASE LEN(T$)
CASE 0
  CountryWind = TRUE  'FALSE
CASE 1
  IF T$ < "0" OR T$ > "9" THEN CountryWind = FALSE ELSE CountryWind = TRUE
CASE IS > 1
  CountryWind = FALSE
  SELECT CASE LEFT$(T$, 1)
  CASE "+", "-", " ", "0" TO "9"
    CountryWind = TRUE
  CASE "."
    IF INSTR(2, T$, ".") = 0 THEN CountryWind = TRUE
  END SELECT
END SELECT
IF CountryWind = TRUE THEN
  FOR i = 2 TO LEN(RTRIM$(T$))
    SELECT CASE MID$(T$, i, 1)
    CASE "."
      IF INSTR(i + 1, T$, ".") <> 0 THEN CountryWind = FALSE
    CASE IS < "0", IS > "9"
      CountryWind = FALSE
    END SELECT
    IF CountryWind = FALSE THEN EXIT FOR
  NEXT i
END IF
Number = CountryWind

END FUNCTION

SUB PopUpWindow (Row1, Col1, row2, col2)
'Activation of pop-up help window
'Row1,Col1,Row2,Col2 - coordinates of the pop-up help window
'Т$() - text of help

'Store cursor's position
CurRow = CSRLIN
CurCol = POS(0)

'Reserve memory to store the window
LenW = col2 - Col1                  'width of window
HigW = row2 - Row1                  'height of window
DIM a(HigW, LenW * 2)

'Setting parameters of underscreen area to store
DEF SEG = 0
'offset of active page in screen area
PagOff = PEEK(&H44E) + PEEK(&H44F) * 256
'lengh of Screen - байт
LenScr = (PEEK(&H44A) + PEEK(&H44B) * 256) * 2
DEF SEG

'Storing information under the window
'initial segment of display memory
DEF SEG = &HB800
FOR i = 0 TO HigW
  FOR j = 0 TO LenW * 2
    a(i, j) = PEEK(PagOff + 2 * Col1 + (i + Row1) * LenScr + j)
  NEXT
NEXT

'Choosing a pop-up menu from the list of countries
TextHelp                                    'list of countries
'invoking Country menu and choosing a necessary item
Position = PosChoise%(TextWin$(), 7, Row1 + 1, Col1 + 1, 1)
IF FinishWin = FALSE THEN
    'changing and outputting edit field onto the panel
    edit$(4) = TextWin$(Position)
    CountryWind = TRUE
    COLOR Color2, Color1
    LOCATE Row(4), Col
    PRINT edit$(4)
END IF

'Restore text under window
DEF SEG = &HB800
FOR i = 0 TO HigW
  FOR j = 0 TO 2 * LenW
    POKE PagOff + 2 * Col1 + (i + Row1) * LenScr + j, a(i, j)
  NEXT
NEXT
DEF SEG

'Restoring the cursor of the main entry-edit panel
LOCATE CurRow, CurCol

END SUB

FUNCTION PosChoise% (Names$(), Max%, Row1%, Col1%, CurrentKey%)
'Creating a one-alternative selection menu
'Names$ - total list of names of fields
'Max% - number of fields to display
'row1%, Col1% - coordinates of the left upper corner of framework
'CurrentKey% - initial position of the selection cursor
'row2%, Col2% - coordinates of the right lower corner of framework

FinishWin = FALSE
Color1 = Color1
Color2 = Color2
Color3 = 3 'Color(4)
row2% = Row1% + Max% + 1
'col2 = Col1% + 15 + 3
col2% = Col1% + MaxLen(Names$(), Max%) + 8 '3

'тень
COLOR Color4, Color4
Box Row1% + 1, Col1% + 2, row2% + 1, col2% + 2
'pамка
COLOR Color1, Color2
Box Row1%, Col1%, row2%, col2%

'output of selection items
FOR i% = 1 TO Max%
    IF i% = CurrentKey% THEN
	 GOSUB PrintColor2
    ELSE
	 GOSUB PrintNoColor2
    END IF
NEXT
i% = CurrentKey%

'выбоp
DO
    LOCATE Row1% + i%, Col1% + 2, 1
    DO
      Key$ = INKEY$
    LOOP UNTIL Key$ <> ""
    SELECT CASE Key$
	CASE CHR$(0) + "H"
	    GOSUB PrintNoColor2
	    IF i% > 1 THEN
		i% = i% - 1
	    ELSE
		i% = Max%
	    END IF
	    GOSUB PrintColor2
	CASE CHR$(0) + "P"
	    GOSUB PrintNoColor2
	    IF i% < Max% THEN
		i% = i% + 1
	    ELSE
		i% = 1
	    END IF
	    GOSUB PrintColor2
	CASE CHR$(13)
	    EXIT DO
	CASE CHR$(27)
	    FinishWin = TRUE
	    EXIT DO
	CASE ELSE
	    BEEP
    END SELECT
LOOP

PosChoise% = i% - 1
COLOR Color2, Color3
FOR i% = Row1% TO row2% + 1
    LOCATE i%, Col1%
    PRINT STRING$((col2% + 3 - Col1%), " ")
NEXT
COLOR Color1, Color2
EXIT FUNCTION

PrintColor2:
    COLOR Color2, Color1
    LOCATE Row1% + i%, Col1% + 2
    PRINT Names$(i% - 1) + STRING$(col2% - Col1% - LEN(Names$(i% - 1)) - 3, " ")
RETURN

PrintNoColor2:
    COLOR Color1, Color2
    LOCATE Row1% + i%, Col1% + 2
    PRINT Names$(i% - 1) + STRING$(col2% - Col1% - LEN(Names$(i% - 1)) - 3, " ")
RETURN

END FUNCTION

SUB PrintHelpLine (Help$)
    COLOR Color5, Color1
    Center 24, Help$
END SUB

SUB SaveBase
'запись данных в файл #1
    FOR x = 1 TO m
	PUT #1, x, record(x)
    NEXT x
END SUB

SUB TextHelp

'Text of the help menu popping up on pressing F1
TextWin$(0) = " ..	       "
TextWin$(1) = "France	       "
TextWin$(2) = "Germany	       "
TextWin$(3) = "Great	Britain"
TextWin$(4) = "Spain	       "
TextWin$(5) = "Sweden	       "
TextWin$(6) = "U S A	       "

END SUB

