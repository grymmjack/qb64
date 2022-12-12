REM Menu with multialternative selection
REM \CHAP13\CH13_5.BAS

DECLARE SUB Menu (X0!, Y0!)
DECLARE SUB Result ()
DECLARE SUB DrawButton (X0!, Y0!, S$, Colors!, Press!)

COMMON SHARED Button(), MenuPoint$(), Num
CONST CharSizeY = 14, CharSizeX = 8
CONST ButtonCollor = 7, Border = 0
CONST False = 1, True = 0

SCREEN 9
PAINT (1, 1), 7
CALL Menu(10, 39)

TextMenu:
DATA 4, Text attributes, Bold, UnderLine, Italic, Shadow

SUB DrawButton (X0, Y0, S$, Colors, Press)
' *************************
' *   Display of button   *
' *************************
' X0, Y0 - coordinates of button
' S$ - text on button
' Press - sign of a button pressing

	Lx = (Y0 - 1) * CharSizeX - 8
	Ly = (X0 - 1) * CharSizeY - 5
	Rx = (Y0 + LEN(S$) - 1) * CharSizeX + 8
	Ry = X0 * CharSizeY + 5
	LINE (Lx, Ly)-(Rx, Ry), Border, B
	PAINT (Lx + 1, Ly + 1), ButtonCollor, Border
	LOCATE X0, Y0
	COLOR Colors, 7
	PRINT S$
	LINE (Lx + 2, Ly + 2)-(Rx - 2, Ry - 2), Border, B
	LINE (Rx, Ly)-(Rx - 2, Ly + 2), Border
	LINE (Lx, Ry)-(Lx + 2, Ry - 2), Border
	IF Press = 1 THEN
		PAINT (Rx - 1, Ry - 2), 8, Border
		PAINT (Lx + 1, Ly + 2), 15, Border
	ELSE
		PAINT (Lx + 2, Ly + 1), 8, Border
		PAINT (Rx - 2, Ry - 1), 15, Border
	END IF
END SUB

SUB Menu (X0, Y0)
' ****************************
' *   Display of menu text   *
' *            +             *
' * Selection of a menu item *
' ****************************
' X0 - number of first line of menu
' Y0 - number of left column of menu
' Button() - array of selected menu items

' *** Initialization of variables ***
	RESTORE TextMenu
	READ Num
	READ Title$
	DIM MenuPoint$(Num)
	DIM Button(Num)
	FOR I = 1 TO Num
		READ MenuPoint$(I)
		Button(I) = False
	NEXT I

' *** Ouput of menu text ***
	LOCATE X0 - 2, (81 - LEN(Title$)) / 2 'centering title
	COLOR 8, 7
	PRINT Title$
	FOR I = 0 TO Num - 1
		LOCATE X0 + I * 2, Y0: PRINT MenuPoint$(I + 1)
		DrawButton X0 + I * 2, Y0 - 5, "Off", 8, False
	NEXT I
	LOCATE X0, Y0
	COLOR 14, 7: PRINT MenuPoint$(1)
	LINE (10, 310)-(630, 310), 8
	LOCATE 24, 25
	COLOR 8, 7: PRINT "Press Space to change an option";

' *** Selection of a menu item ***
	CurrentPoint = 1
	DO
		Key$ = INKEY$
		SELECT CASE Key$
		CASE CHR$(0) + CHR$(80):           'Cursor Down
			Clr = 8: GOSUB Str
			IF CurrentPoint = Num THEN
	CurrentPoint = 1
			ELSE
	CurrentPoint = CurrentPoint + 1
			END IF
			Clr = 14: GOSUB Str
		CASE CHR$(0) + CHR$(72):           'Cursor Up
			Clr = 8: GOSUB Str
			IF CurrentPoint = 1 THEN
	CurrentPoint = Num
			ELSE
	CurrentPoint = CurrentPoint - 1
			END IF
			Clr = 14: GOSUB Str
		CASE CHR$(32):                      'Space
			X1 = X0 + (CurrentPoint - 1) * 2
			Y1 = Y0 - 5
			IF Button(CurrentPoint) = False THEN
	DrawButton X1, Y1, "On ", 8, True
	Button(CurrentPoint) = True
			ELSE
	DrawButton X1, Y1, "Off", 8, False
	Button(CurrentPoint) = False
			END IF
		CASE CHR$(13):                      'Enter
			Result
			B$ = INPUT$(1)
		END SELECT
	LOOP UNTIL Key$ = CHR$(13)
	EXIT SUB
Str:
		LOCATE X0 + (CurrentPoint - 1) * 2, Y0
		COLOR Clr, 7: PRINT MenuPoint$(CurrentPoint)
	RETURN
END SUB

SUB Result
' **************************************
' *  Display of results of selection   *
' **************************************
	CLS 0
	LOCATE 8, 32
	COLOR 1, 7
	PRINT "Selected points:"
	PRINT
	FOR I = 1 TO Num
		IF Button(I) = True THEN
			PRINT TAB(35); MenuPoint$(I)
		END IF
	NEXT I
END SUB

