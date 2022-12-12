REM Demonstration program   
REM Input of numeric values  
REM \CHAP13\CH13_7.BAS

DECLARE SUB NumberAnswer (X0!, Y0!, LAns!, Number!)
SCREEN 0
WIDTH 40
COLOR 15, 0
CLS 0
COLOR 0, 7
LOCATE 4, 7, 0: PRINT " Demonstration program "
COLOR 15, 0
LOCATE 8, 7: PRINT "Input number:";
CALL NumberAnswer(8, 22, 8, Number)
COLOR 15, 0
LOCATE 11, 7: PRINT "Result:";
COLOR 15, 1
LOCATE 11, 22: PRINT Number;
A$ = INPUT$(1)
END

SUB NumberAnswer (X0, Y0, LAns, Number)
' *********************
' *  Input of number  *
' *********************
' X0, Y0 - coordinates of left border of entry field
' LAns - maximal number of characters in a number to enter
' Number - result of input

CI = 15         'foreground color
C = 4           'background color
CC = CI + 16    'color of cursor
COLOR CI, CB
Nmbr$ = ""
GOSUB OnScreen
DO
	DO
		L$ = INKEY$
	LOOP WHILE L$ = ""
	SELECT CASE L$
	CASE CHR$(8)         'BackSpace
		GOSUB BackSpace
	CASE CHR$(13)        'Enter
		GOSUB Enter
		Condition = (Nmbr$ = "") OR (Nmbr$ = "-") OR (Nmbr$ = ".")
		Condition = Condition OR (Nmbr$ = "-.")
		IF Condition THEN
			BEEP
			GOSUB Cursor
		ELSE
			EXIT DO
		END IF
	CASE "."
		GOSUB FullStop
	CASE "-"
		GOSUB Minus
	CASE "0" TO "9"      'figures
		GOSUB AddSymbol
	CASE ELSE
		BEEP
	END SELECT
LOOP
EXIT SUB

'===========================================================
AddSymbol:
	IF LEN(Nmbr$) < LAns THEN
		Nmbr$ = Nmbr$ + L$
		GOSUB OnScreen
	ELSE
		BEEP
	END IF
RETURN
'===========================================================
OnScreen:
	Nmbr1$ = Nmbr$ + SPACE$(LAns - LEN(Nmbr$))
	LOCATE X0, Y0
	PRINT Nmbr1$;
	GOSUB Cursor
RETURN
'===========================================================
Cursor:
	LN = LEN(Nmbr$)
	IF LN < LAns THEN
		COLOR CC
		LOCATE X0, Y0 + LN
		PRINT "Û"
		COLOR CI
	END IF
RETURN
'===========================================================
Enter:
	Number = VAL(Nmbr$)
	LN = LEN(Nmbr$)
	IF LN < LAns THEN
		COLOR CI
		LOCATE X0, Y0 + LN
		PRINT " "
	END IF
RETURN
'===========================================================
Minus:
	IF LEN(Nmbr$) = 0 THEN
		GOSUB AddSymbol
	ELSE
		BEEP
	END IF
RETURN
'===========================================================
FullStop:
	IF INSTR(Nmbr$, ".") = 0 THEN
		GOSUB AddSymbol
	ELSE
		BEEP
	END IF
RETURN
'===========================================================
BackSpace:
	LN = LEN(Nmbr$)
	IF LN > 0 THEN
		Nmbr$ = LEFT$(Nmbr$, LN - 1)
		GOSUB OnScreen
	ELSE
		BEEP
	END IF
RETURN
'===========================================================
END SUB

