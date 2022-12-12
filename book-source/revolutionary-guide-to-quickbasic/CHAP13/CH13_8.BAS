REM Data Input     
REM Demonstration Program
REM \CHAP13\CH13_8.BAS

DECLARE SUB Answer (X0!, Y0!, LX!, MaxLText!, Text$, NumberText$)
DECLARE FUNCTION Number! (Txt$)
DECLARE SUB Box (X1!, Y1!, X2!, Y2!, Version!, Clr1!, Clr2!)
DECLARE SUB NumberOrText (L$)

CONST False = 0
CONST True = NOT False

SCREEN 0
CALL NumberOrText(L$)
WIDTH 40
COLOR 15, 7: CLS
CALL Box(1, 1, 25, 40, 4, 8, 7)
CALL Box(4, 9, 6, 31, 2, 8, 7)
CALL Box(9, 3, 11, 38, 3, 8, 7)
CALL Box(19, 3, 21, 38, 1, 8, 7)
COLOR 15, 7: LOCATE 5, 10
PRINT "Demonstration program"
COLOR 4, 7: LOCATE 17, 14
PRINT "R e s u l t :"
COLOR 15, 7: LOCATE 10, 4
IF L$ = "N" THEN
	PRINT "Enter a number:"
	CALL Answer(10, 29, 8, 34, T$, "Number")
	Nmbr = VAL(T$)
	COLOR 15, 4: LOCATE 20, 4
	PRINT Nmbr
ELSE
	PRINT "Enter a text:"
	CALL Answer(10, 18, 20, 34, T$, "Text")
	COLOR 15, 4: LOCATE 20, 4
	PRINT T$
END IF
L$ = INPUT$(1)
END
'-----------------------------------------------------------
DataBox:
DATA Ú, Ä, ¿, ³, À, Ù
DATA É, Í, », º, È, ¼
DATA Õ, Í, ¸, ³, Ô, ¾
DATA Û, Û, Û, Û, Û, Û
'===========================================================

SUB Answer (X0, Y0, LX, MaxLText, Text$, NumberText$)
' **********************************************
' * Input of a number or of a character string *
' **********************************************
' NumberText$ = "Number" - input of a number
' NumberText$ = "Text" - input of character string
' X0, Y0 - coordinates of the beginning of the input zone
' LX - length of input zone   ( LX <= MaxLText )
' MaxLText - maximal length of a string to enter
' Text$ - result of input

CI = 14           'foreground color
CB = 1            'background color
GOSUB Init
GOSUB OnScreen
DO
	DO
		L$ = INKEY$
	LOOP WHILE L$ = ""
	SELECT CASE L$
	CASE CHR$(0) + CHR$(82)    'Ins
		GOSUB Insert
	CASE CHR$(0) + CHR$(83)    'Del
		GOSUB Delete
	CASE CHR$(0) + CHR$(75)    'Cursor-left
		GOSUB CursorLeft
	CASE CHR$(0) + CHR$(77)    'Cursor-right
		GOSUB CursorRight
	CASE CHR$(0) + CHR$(71)    'Home
		GOSUB Home
	CASE CHR$(0) + CHR$(79)    'End
		GOSUB End1
	CASE CHR$(8)               'BackSpace
		GOSUB BackSpace
	CASE CHR$(13)              'Enter
		IF NumberText$ = "Text" THEN
			Text$ = RTRIM$(Text$)
			LOCATE , , , 7
			EXIT DO
		ELSE
			GOSUB EnterNumber
			IF Number(Text$) = True THEN
	LOCATE , , , 7
	EXIT DO
			END IF
		END IF
	CASE CHR$(32) TO CHR$(255)     'Characters
		GOSUB AddSymbol
	CASE ELSE
		BEEP
	END SELECT
LOOP
EXIT SUB
'===========================================================
Init:
' *** Initialization of procedure ***
	COLOR CI, CB
	LOCATE X0, Y0
	Text$ = SPACE$(MaxLText)
	PointerB = 1
	PointerC = 1
	Ins = False
RETURN
'===========================================================
AddSymbol:
' *** Add a character to string Text$ ***
	NL = PointerB + PointerC - 1
	SELECT CASE Ins
		CASE True            'insertion mode
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
		CASE False             'replacement mode
			IF PointerC <= LX THEN
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
	CASE "right"       'move cursor right
		IF PointerC < LX THEN
			PointerC = PointerC + 1
		ELSE
			IF PointerB + PointerC - 1 < MaxLText THEN
	PointerB = PointerB + 1
			ELSE
	IF PointerC = LX THEN
		'*** cursor at the end of word Text$ ***
		PointerC = PointerC + 1
	ELSE
		BEEP
	END IF
			END IF
		END IF
	CASE "left"      'move cursor left
		IF PointerC > 1 THEN
			PointerC = PointerC - 1
		ELSE
			IF PointerB > 1 THEN
	PointerB = PointerB - 1
			ELSE       'cursor at the beginning of word Text$
	BEEP
			END IF
		END IF
END SELECT
RETURN
'==========================================================
OnScreen:
' *** Output a text fragment onto screen ***
	COLOR CI, CB
	LOCATE X0, Y0
	PRINT MID$(Text$, PointerB, LX);
	IF PointerC <= LX THEN
		NL = PointerB + PointerC - 1
		LOCATE X0, Y0 + PointerC - 1, 1
	ELSE
		LOCATE , , 0       'hide cursor
	END IF
RETURN
'===========================================================
Insert:
' *** Change value of  Ins and form of cursor ***
	IF Ins = True THEN
		Ins = False
		LOCATE X0, Y0, , 7
	ELSE
		Ins = True
		LOCATE X0, Y0, , 0, 7
	END IF
	GOSUB OnScreen
RETURN
'===========================================================
CursorLeft:
' *** Move cursor left ***
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
' *** Delete a character to the left from cursor ***
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
' *** Delete a character at cursor ***
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
' *** Move cursor to the beginning of string ***
	PointerB = 1
	PointerC = 1
	GOSUB OnScreen
RETURN
'===========================================================
End1:
' *** Move cursor to end of string ***
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
' *** Complete input of number ***
	IF Number(Text$) = False THEN
		PCOPY 0, 1
		X3 = 12: Y3 = 11
		CALL Box(X3 + 1, Y3 + 1, X3 + 4, Y3 + 19, 4, 0, 4)
		CALL Box(X3, Y3, X3 + 3, Y3 + 18, 2, 15, 5)
		CALL Box(X3 + 1, Y3 + 1, X3 + 2, Y3 + 17, 4, 5, 15)
		COLOR 31, 5
		LOCATE 13, 18
		PRINT "Error!"
		COLOR 15, 5
		LOCATE 14, 12
		PRINT " Enter a number! "
		L$ = INPUT$(1)
		PCOPY 1, 0
		GOSUB OnScreen
	ELSE
		Text$ = RTRIM$(Text$)
	END IF
RETURN
'===========================================================

END SUB

SUB Box (X1, Y1, X2, Y2, Version, Clr1, Clr2)
' ********************
' * Draw a framework *
' ********************
' X1, Y1 - coordinates of upper left corner of framework
' X2, Y2 - coordinates of right lower corner of framework
' Version - form of framework
' Clr1, Clr2 -framework's fore- and background colors

REDIM B$(4, 6)
RESTORE DataBox
FOR I = 1 TO 4
	FOR J = 1 TO 6
		READ B$(I, J)
	NEXT J
NEXT I
COLOR Clr1, Clr2
LOCATE X1, Y1
PRINT B$(Version, 1);
PRINT STRING$(Y2 - Y1 - 1, B$(Version, 2));
PRINT B$(Version, 3);
FOR X = X1 + 1 TO X2 - 1
	LOCATE X, Y1
	PRINT B$(Version, 4);
	LOCATE X, Y2
	PRINT B$(Version, 4);
NEXT X
LOCATE X2, Y1
PRINT B$(Version, 5);
PRINT STRING$(Y2 - Y1 - 1, B$(Version, 2));
PRINT B$(Version, 6);
END SUB

FUNCTION Number (Txt$)
' *************************
' * Txt$ - number or not? *
' *************************
T$ = Txt$
T$ = RTRIM$(T$)
T$ = LTRIM$(T$)
SELECT CASE LEN(T$)
CASE 0
	Flag = True
CASE 1
	IF T$ < "0" OR T$ > "9" THEN Flag = False ELSE Flag = True
CASE IS > 1
	Flag = False
	SELECT CASE LEFT$(T$, 1)
	CASE "+", "-", "0" TO "9"
		Flag = True
	CASE "."
		IF INSTR(2, T$, ".") = 0 THEN Flag = True
	END SELECT
END SELECT
IF Flag = True THEN
	FOR I = 2 TO LEN(RTRIM$(T$))
		SELECT CASE MID$(T$, I, 1)
		CASE "."
			IF INSTR(I + 1, T$, ".") <> 0 THEN Flag = False
		CASE IS < "0", IS > "9"
			Flag = False
		END SELECT
		IF Flag = False THEN EXIT FOR
	NEXT I
END IF
IF T$ = "+." OR T$ = "-." THEN Flag = False
Number = Flag
END FUNCTION

SUB NumberOrText (L$)
' **************************************
' * Selection of type of data to enter *
' **************************************
COLOR 15, 0: CLS
LOCATE 10, 18, 0
PRINT "Do you want to enter a number or a text? (";
COLOR 31: PRINT "N";
COLOR 15: PRINT "/";
COLOR 31: PRINT "T";
COLOR 15: PRINT ")";
DO
	L$ = INKEY$
LOOP UNTIL L$ = "N" OR L$ = "n" OR L$ = "T" OR L$ = "t"
L$ = UCASE$(L$)
END SUB

