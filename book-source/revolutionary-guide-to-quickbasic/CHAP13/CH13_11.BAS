REM Entering Data in Tables
REM \CHAP13\CH13_11.BAS

DEFINT A-Z

'Sub and function declarations
DECLARE SUB answer (X0%, Y0%, LX%, MaxLText%, Text$, NumberText$)
DECLARE SUB Box (Row1%, Col1%, row2%, col2%)
DECLARE SUB Center (Row%, Text$)
DECLARE SUB EditTabRecords ()
DECLARE SUB LoadBase ()
DECLARE SUB PopUpWindow (Row1%, Coll1%, row2%, Coll2%)
DECLARE SUB PrintHelpLine (Help$)
DECLARE SUB SaveBase ()
DECLARE SUB TextHelp ()
DECLARE FUNCTION Number% (T$)

'm - number of records to allocate on the screen (rows of table)
'n - number of fields in each record (columns of table)
CONST m = 16
CONST n = 7

CONST TRUE = -1
CONST FALSE = NOT TRUE

TYPE RecordType
    Year       AS STRING * 4
    Liner      AS STRING * 20
    Direct     AS STRING * 4
    Days       AS INTEGER
    Hours      AS INTEGER
    Minutes    AS INTEGER
    Velocity   AS SINGLE
END TYPE

DIM SHARED Record(1 TO m)  AS RecordType      'Stores the m Record
DIM SHARED TextWin$(15)                       'text of help
DIM SHARED Color1, Color2, Color3, Color4
DIM SHARED Color5, Color6
DIM SHARED L$

ON KEY(1) GOSUB F1help                 'F1-invoke pop-up help window
KEY(1) ON
Color1 = 1
Color2 = 15
Color3 = 3
Color4 = 0
Color5 = 14
Color6 = 7


    OPEN "Records.dbf" FOR RANDOM AS #1 LEN = LEN(Record(1))
    LoadBase                         'Reading data from file
    EditTabRecords                 'Entering and editing data
    SaveBase                         'Writing data in file
    CLOSE #1
    END

'The procedure performs popping up a help window with
'storing information under the window
F1help:
    PopUpWindow 11, 20, 21, 60
    RETURN

SUB answer (X0, Y0, LX, MaxLText, Text$, NumberText$)
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
DO
  DO
    L$ = INKEY$
  LOOP WHILE L$ = ""
  SELECT CASE L$
  CASE CHR$(0) + CHR$(82)           'Ins
    GOSUB Insert
  CASE CHR$(0) + CHR$(83)           'Del
    GOSUB Delete
  CASE CHR$(0) + CHR$(75)           'Cursor-left
    GOSUB CursorLeft
  CASE CHR$(0) + CHR$(77)           'Cursor-right
    GOSUB CursorRight
  CASE CHR$(0) + CHR$(71)           'Home
    GOSUB Home
  CASE CHR$(0) + CHR$(79)           'End
    GOSUB End1
  CASE CHR$(8)                      'BackSpace
    GOSUB BackSpace
  CASE CHR$(32) TO CHR$(255)        'Characters
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
    CASE TRUE                               'insertion mode
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
    CASE FALSE        ', True                     'replacement mode
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
  CASE "right"                         'move cursor right
    IF PointerC < LX THEN
      PointerC = PointerC + 1
    ELSE
      IF PointerB + PointerC - 1 < MaxLText THEN
        PointerB = PointerB + 1
      ELSE
        IF PointerC = LX THEN
          '*** cursor at the end of word Text$ ***
        DoExit = TRUE                'end of field
        L$ = CHR$(0) + CHR$(77) 'cursor' direction - to the right
        ELSE
          BEEP
        END IF
      END IF
    END IF
  CASE "left"                         'move cursor left
    IF PointerC > 1 THEN
      PointerC = PointerC - 1
    ELSE
      IF PointerB > 1 THEN
        PointerB = PointerB - 1
      ELSE                         'cursor at the beginning of the word Text$

        DoExit = TRUE                'end of field at the left
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
    PRINT "Ú"; STRING$(BoxWidth - 2, "Ä"); "¿";

    FOR a = Row1 + 1 TO row2 - 1
        LOCATE a, Col1
        PRINT "³"; SPACE$(BoxWidth - 2); "³";
    NEXT a

    LOCATE row2, Col1
    PRINT "À"; STRING$(BoxWidth - 2, "Ä"); "Ù";

END SUB

'  Center text on the given row.
SUB Center (Row, Text$)
    LOCATE Row, 41 - LEN(Text$) \ 2
    PRINT Text$;
END SUB

SUB EditTabRecords
'Full screen editing array of records. Number of records m <= 16,
'corresponds to the number of screen lines to edit.
'Source data:
'Record() - source array of records,
'm - number of records in Record().
'n - number of fields of one record equals to number of screen columns.
'Target data:
'Record() - edited array of records.

    REDIM Help$(n), col(n), Vis(n), edit$(m, n)
    'TextHelp variables
    GOSUB InitVar

    'Send records to two-dimensional array edit$()
    GOSUB EditTabRecordsLoadData

    'Draw the screen
    GOSUB DrawScreen

    'Start of full-screen editing a two-dimensional array
    'of string elements edit$(CurrRow,CurrCol).
    'CurrRow, CurrCol - parameters of main cycle
    CurrRow = 1 'initial number of string to edit
    CurrCol = 1 'initial number of field to edit
    PrintHelpLine Help$(CurrCol)
    Finished = FALSE

    'Loop until F2 or <ESC> is pressed
    DO
        GOSUB EditTabRecordsShowCursor                      'Show Cursor
        Ro1 = CurrRow + 4
        Co1 = col(CurrCol)
        Vi = Vis(CurrCol)

       'Editing one field on screen (text or number)
       IF CurrCol = 1 OR CurrCol = 2 OR CurrCol = 3 THEN
         answer Ro1, Co1, Vi, Vi, edit$(CurrRow, CurrCol), "Text"
       ELSE
         answer Ro1, Co1, Vi, Vi, edit$(CurrRow, CurrCol), "Number"
       END IF

        'Analyze of  control key pressing, which completed
        'field editing
 GOSUB Control
    LOOP UNTIL Finished

    IF Save THEN
        GOSUB EditTabRecordsSaveData
    END IF
    EXIT SUB

DrawScreen:
    'Draw the screen
    COLOR Color2, Color1
    Box 2, 1, m + 5, 80
    LOCATE 2, 4: PRINT "Â"
    LOCATE 2, 11: PRINT "Â"
    LOCATE 2, 32: PRINT "Â"
    LOCATE 2, 43: PRINT "Â"
    LOCATE 2, 52: PRINT "Â"
    LOCATE 2, 61: PRINT "Â"
    LOCATE 2, 70: PRINT "Â"
    LOCATE m + 5, 4: PRINT "Á"
    LOCATE m + 5, 11: PRINT "Á"
    LOCATE m + 5, 32: PRINT "Á"
    LOCATE m + 5, 43: PRINT "Á"
    LOCATE m + 5, 52: PRINT "Á"
    LOCATE m + 5, 61: PRINT "Á"
    LOCATE m + 5, 70: PRINT "Á"

    COLOR Color5, Color1
    LOCATE 1, 1: PRINT SPACE$(80)
    LOCATE 1, 4: PRINT "Editor";
    LOCATE 1, 27: PRINT "Records of Holders of the Blue Ribbon of the Atlantic"
    COLOR Color2, Color1

    LOCATE 3, 2:  PRINT "No³ Year ³    Liner           ³Direction ³  Days  ³ Hours  ³ Minutes³Velocity"
    LOCATE 4, 1: PRINT "ÃÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ´"
                   u$ = "##³ \  \ ³\                  \³   \  \   ³" '   \\   ³   \\   ³   \\   ³  \   \"
                   u1$ = "   \\   ³   \\   ³   \\   ³  \   \"
    FOR a = 5 TO m + 4
        LOCATE a, 2
        x = a - 4
        PRINT USING u$; x; edit$(x, 1); edit$(x, 2); edit$(x, 3);
        LOCATE a, 44
        PRINT USING u1$; edit$(x, 4); edit$(x, 5); edit$(x, 6); edit$(x, 7);
    NEXT a
    RETURN

InitVar:
    'TextHelp variables
    Help$(1) = "  Year of record               | <F1=Help> <F2=Save and Exit> <Escape=Abort>"
    Help$(2) = "  Name of liner                | <F1=Help> <F2=Save and Exit> <Escape=Abort>"
    Help$(3) = "  Direction : West,East        | <F1=Help> <F2=Save and Exit> <Escape=Abort>"
    Help$(4) = "  Time of passage (days )      | <F1=Help> <F2=Save and Exit> <Escape=Abort>"
    Help$(5) = "  Time of passage (hours)      | <F1=Help> <F2=Save and Exit> <Escape=Abort>"
    Help$(6) = "  Time of passage (minutes)    | <F1=Help> <F2=Save and Exit> <Escape=Abort>"
    Help$(7) = "  Velocity (in knots )         | <F1=Help> <F2=Save and Exit> <Escape=Abort>"

    'initial positions of columns and their length
    col(1) = 6: col(2) = 12: col(3) = 36: col(4) = 47
    Vis(1) = 4: Vis(2) = 20: Vis(3) = 4:  Vis(4) = 2

    col(5) = 56: col(6) = 65: col(7) = 73
    Vis(5) = 2: Vis(6) = 2: Vis(7) = 5
    RETURN

EditTabRecordsShowCursor:
    COLOR Color4, Color6
    LOCATE CurrRow + 4, col(CurrCol)
    PRINT LEFT$(edit$(CurrRow, CurrCol), Vis(CurrCol));
    RETURN

Control:
'Analyze pressed control key which completed
'field editing
SELECT CASE L$
    CASE CHR$(0) + "H"                               'Up Arrow
         GOSUB EditTabRecordsHideCursor        'Hide Cursor so it can move
         CurrRow = (CurrRow + m - 2) MOD m + 1
    CASE CHR$(0) + "P"                               'Down Arrow
         GOSUB EditTabRecordsHideCursor        'Hide Cursor so it can move
         CurrRow = (CurrRow) MOD m + 1
    CASE CHR$(0) + "K"                               'Left
         IF CurrCol > 1 THEN                       'to previous field
           GOSUB EditTabRecordsHideCursor      'Hide Cursor so it can move
           CurrCol = CurrCol - 1
           PrintHelpLine Help$(CurrCol)
         END IF
    CASE CHR$(0) + "M"                               'to right bound of field
         GOSUB EditTabRecordsHideCursor        'Hide Cursor so it can move
         IF CurrCol = n THEN
           CurrRow = (CurrRow) MOD m + 1
         END IF
         CurrCol = (CurrCol) MOD n + 1
         PrintHelpLine Help$(CurrCol)
    CASE CHR$(9), CHR$(13)                       'Tab or Enter
         GOSUB EditTabRecordsHideCursor        'Hide Cursor so it can move
         IF CurrCol = n THEN
           CurrRow = (CurrRow) MOD m + 1
         END IF
         CurrCol = (CurrCol) MOD n + 1
         PrintHelpLine Help$(CurrCol)
    CASE CHR$(0) + "<"                               'F2
         Finished = TRUE
         Save = TRUE
    CASE CHR$(27)                               'Esc
         Finished = TRUE
         Save = FALSE
    CASE ELSE
         BEEP
END SELECT
RETURN

EditTabRecordsHideCursor:
    IF CurrCol <> 2 AND CurrCol <> 3 THEN
      u$ = edit$(CurrRow, CurrCol)
      u1$ = RTRIM$(u$)
      edit$(CurrRow, CurrCol) = SPACE$(LEN(u$) - LEN(u1$)) + u1$
    END IF
    COLOR Color2, Color1
    LOCATE CurrRow + 4, col(CurrCol)
    PRINT LEFT$(edit$(CurrRow, CurrCol), Vis(CurrCol));
    RETURN


EditTabRecordsLoadData:
    'Transfer array of records into on-screen editable
    'two-dimensional array  edit() of string variables
    FOR a = 1 TO m
        edit$(a, 1) = Record(a).Year
        edit$(a, 2) = Record(a).Liner
        edit$(a, 3) = Record(a).Direct
        edit$(a, 4) = STR$(Record(a).Days)
        edit$(a, 5) = STR$(Record(a).Hours)
        edit$(a, 6) = STR$(Record(a).Minutes)
        edit$(a, 7) = STR$(Record(a).Velocity)
        'formatting fields containing numbers, to a desired length
        FOR b = 1 TO n
          SELECT CASE b
            CASE 4, 5, 6, 7
              u$ = RTRIM$(LTRIM$(edit$(a, b)))
              IF u$ = "0" THEN u$ = " "
              edit$(a, b) = SPACE$(Vis(b) - LEN(u$)) + u$
          END SELECT
        NEXT b
    NEXT a
    RETURN


EditTabRecordsSaveData:
    'Transfer the on-screen edited two-dimensional array
    'of string variables into array of records
    FOR a = 1 TO m
        Record(a).Year = edit$(a, 1)
        Record(a).Liner = edit$(a, 2)
        Record(a).Direct = edit$(a, 3)
        Record(a).Days = VAL(edit$(a, 4))
        Record(a).Hours = VAL(edit$(a, 5))
        Record(a).Minutes = VAL(edit$(a, 6))
        Record(a).Velocity = VAL(edit$(a, 7))
    NEXT a
    RETURN

END SUB

SUB LoadBase
    'Read data from file #1
    FOR x = 1 TO m
        GET #1, x, Record(x)
    NEXT x
END SUB

FUNCTION Number (T$)
' ***********************
' * T$ - number or not? *
' ***********************
T$ = RTRIM$(LTRIM$(T$))
SELECT CASE LEN(T$)
CASE 0
  Flag = TRUE  'FALSE
CASE 1
  IF T$ < "0" OR T$ > "9" THEN Flag = FALSE ELSE Flag = TRUE
CASE IS > 1
  Flag = FALSE
  SELECT CASE LEFT$(T$, 1)
  CASE "+", "-", " ", "0" TO "9"
    Flag = TRUE
  CASE "."
    IF INSTR(2, T$, ".") = 0 THEN Flag = TRUE
  END SELECT
END SELECT
IF Flag = TRUE THEN
  FOR i = 2 TO LEN(RTRIM$(T$))
    SELECT CASE MID$(T$, i, 1)
    CASE "."
      IF INSTR(i + 1, T$, ".") <> 0 THEN Flag = FALSE
    CASE IS < "0", IS > "9"
      Flag = FALSE
    END SELECT
    IF Flag = FALSE THEN EXIT FOR
  NEXT i
END IF
Number = Flag

END FUNCTION

SUB PopUpWindow (Row1, Col1, row2, col2)
'Activation of pop-up help window
'Row1,Col1,Row2,Col2 - coordinates of pop-up help window
'’$() - text of help

'Store position of cursor
CurRow = CSRLIN
CurCol = POS(0)

'Reserving memory to store window
LenW = col2 - Col1                    'width of window
HigW = row2 - Row1                    'height of window
DIM a(HigW, LenW * 2)

'Setting parameters of the under-window screen area to store
DEF SEG = 0
'offset of active page in screen area
PagOff = PEEK(&H44E) + PEEK(&H44F) * 256
'lengh of Screen - ¡ ©â
LenScr = (PEEK(&H44A) + PEEK(&H44B) * 256) * 2
DEF SEG

'Storing information under window
'initial segment of display memory
DEF SEG = &HB800
FOR i = 0 TO HigW
  FOR j = 0 TO LenW * 2
    a(i, j) = PEEK(PagOff + 2 * Col1 + (i + Row1) * LenScr + j)
  NEXT
NEXT

'Drawing framework
Box Row1 + 1, Col1 + 1, Row1 + HigW + 1, Col1 + LenW
LOCATE Row1 + 1, Col1 + (LenW + 1 - LEN(TextWin$(0))) / 2
'text of help
TextHelp          'TextHelp program
PRINT TextWin$(0);    'title of window
'Output  help text
FOR i = 1 TO HigW + 1 - 2
    LOCATE Row1 + 1 + i, Col1 + 2
    PRINT TextWin$(i);
NEXT

'Waits a key pressing
WHILE LEN(INKEY$) < 1
WEND



'Restore text under window
DEF SEG = &HB800
FOR i = 0 TO HigW
  FOR j = 0 TO 2 * LenW
    POKE PagOff + 2 * Col1 + (i + Row1) * LenScr + j, a(i, j)
  NEXT
NEXT
DEF SEG

'Restore cursor in main entry-edit panel
LOCATE CurRow, CurCol

END SUB

SUB PrintHelpLine (Help$)

    COLOR Color5, Color1
    Box 22, 1, 24, 80
    Center 23, Help$

END SUB

SUB SaveBase
    'Save data in file #1
    FOR x = 1 TO m
        PUT #1, x, Record(x)
    NEXT x
END SUB

SUB TextHelp

'Text of help popping up on pressing F1.
u$ = CHR$(24) + " , " + CHR$(25) + " , " + CHR$(27)
TextWin$(0) = "Help"
TextWin$(1) = " "
TextWin$(2) = " Cursor field: ENTER, TAB ," + u$
TextWin$(3) = "         char: " + CHR$(26) + " , " + CHR$(27)
TextWin$(4) = "                                      "
TextWin$(5) = " Delete        char: DEL, SPACE, <="
TextWin$(6) = "                                      "
TextWin$(7) = " Insert        char: INS"
TextWin$(8) = "                                      "
TextWin$(9) = "    Press any key to continue "

END SUB

