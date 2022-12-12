REM Demonstration of full-screen menu  
REM Items are selected by cursor    
REM \CHAP13\CH13_4.BAS

DECLARE SUB Triangle2 ()
DECLARE SUB Triangle3 ()
DECLARE SUB Triangle1 ()
DECLARE SUB Menu (X0!, Y0!, IM$, NT%)
DECLARE SUB Triangles ()
DECLARE SUB Circle1 ()
DECLARE SUB Trapesium ()
DECLARE SUB Rectangle ()
'------------------------------------------------------------
CONST CharSizeX = 8, CharSizeY = 14
DO
	CALL Menu(10, 35, "Main", MNT%)
	SELECT CASE MNT%
	CASE 1
		CALL Rectangle
	CASE 2
		CALL Trapesium
	CASE 3
		CALL Triangles
	CASE 4
		CALL Circle1
	CASE 5
		SCREEN 0
		CLS
		WIDTH 40
		LOCATE 10, 13
		PRINT "G O O D - B Y E"
	END SELECT
LOOP UNTIL MNT% = 5
END
'------------------------------------------------------------
DataMenuMain:
DATA 5, " A R E A S ", Rectangle, Trapesium, Triangle
DATA Circle, Exit
'------------------------------------------------------------
DataMenuTriangles:
DATA 4, "D A T A :", "Three sides", "Base and height"
DATA "Two sides and angle", "Main menu"
'------------------------------------------------------------

SUB Circle1
'   **********************************
'   * Calculation of area of circle  *
'   **********************************
CLS
CIRCLE (70, 100), 50
LINE (70, 63)-(70, 137), , , &HAAAA
LOCATE 8, 8
PRINT "D"
LOCATE 12, 1
PRINT "Enter parameter:"
PRINT
INPUT "D = ", D
S = D ^ 2 * 3.141593 / 4
PRINT
PRINT "S ="; S
Pause$ = INPUT$(1)
END SUB

SUB Menu (X0, Y0, IM$, NT%)
'   **********************************************
'   *                   Menu                     *
'   *   Items are selected by pointer (cursor)   *
'   **********************************************
' X0, Y0 - coordinates of upper left corner of menu
' IM$ - selection of data block for menu
' NT% - number selected option

SCREEN 9, , 0, 0
CLS 0
Wide% = 80    'screen width
SELECT CASE IM$
CASE "Main"
	RESTORE DataMenuMain
CASE "Triangles"
	RESTORE DataMenuTriangles
END SELECT
READ N%, Title$   'number of menu items and a title

' *** Centering and output of title ***
T = (Wide% - LEN(Title$)) / 2
LOCATE X0 - 2, T
PRINT Title$

' *** Display  of menu onto screen and ***
' *** reading menu items into array B$ ***
DIM B$(N%)
FOR I = 1 TO N%
	READ B$(I)
	LOCATE X0 + I - 1, Y0
	PRINT B$(I)
NEXT I
SCREEN 9, , 1, 0
LINE (1, 1)-(300, CharSizeY), 15, BF
SCREEN 9, , 0, 0

' *** Selection of option ***
X = X0: Y = Y0 - 3 'current position of pointer
NT% = 1
DO
	' *** Determining a number of bytes to store pointer ***
	L = 4 + INT(((LEN(B$(NT%)) * CharSizeX) + 7) / 8) * 4 * (CharSizeY)

	' *** Store pointer in array A%() ***
	REDIM A%(L)
	SCREEN 9, , 1, 0
	GET (1, 1)-(LEN(B$(NT%)) * CharSizeX, CharSizeY), A%
	SCREEN 9, , 0, 0
	PUT ((Y + 2) * CharSizeX, (X - 1) * CharSizeY), A%, XOR
	DO
		Key$ = INKEY$
	LOOP WHILE Key$ = ""
	SELECT CASE Key$
		CASE CHR$(0) + CHR$(72)   'Up
			NT% = NT% - 1
			IF NT% < 1 THEN NT% = N%
		CASE CHR$(0) + CHR$(80)   'Down
			NT% = NT% + 1
			IF NT% > N% THEN NT% = 1
		CASE CHR$(13)       'Enter
			EXIT DO
	END SELECT
	PUT ((Y + 2) * CharSizeX, (X - 1) * CharSizeY), A%, XOR
	X = X0 + NT% - 1
LOOP
END SUB

SUB Rectangle
'   **************************************
'   *  Calculation of area of rectangle  *
'   **************************************
CLS
LINE (20, 60)-(190, 100), , B
LOCATE 4, 14
PRINT "a"
LOCATE 6, 26
PRINT "b"
LOCATE 12, 1
PRINT "Enter parameters:"
PRINT
INPUT "a = ", A
INPUT "b = ", B
S = A * B
PRINT
PRINT "S ="; S
Pause$ = INPUT$(1)
END SUB

SUB Trapesium
'   **************************************
'   *  Calculation of area of trapesium  *
'   **************************************
CLS
LINE (50, 60)-(180, 60)
LINE -(240, 100)
LINE -(20, 100)
LINE -(50, 60)
LINE (50, 60)-(50, 100), , , &HAAAA
LOCATE 4, 14
PRINT "a"
LOCATE 9, 14
PRINT "b"
LOCATE 6, 8
PRINT "h"
LOCATE 12, 1
PRINT "Enter parameters:"
PRINT
INPUT "a = ", A
INPUT "b = ", B
INPUT "h = ", H
S = (A + B) / 2 * H
PRINT
PRINT "S ="; S
Pause$ = INPUT$(1)
END SUB

SUB Triangle1
'   ****************************************************
'   *  Calculation of area of triangle by three sides  *
'   ****************************************************
CLS
LINE (50, 65)-(240, 105)
LINE -(20, 105)
LINE -(50, 65)
LOCATE 6, 19
PRINT "c"
LOCATE 9, 14
PRINT "a"
LOCATE 6, 4
PRINT "b"
LOCATE 12, 1
PRINT "Enter parameters:"
PRINT
INPUT "a = ", A
INPUT "b = ", B
INPUT "c = ", C
ABC = A > 0 AND B > 0 AND C > 0
IF A < B + C AND B < A + C AND C < A + B AND ABC THEN
	P = (A + B + C) / 2
	S = SQR((P - A) * (P - B) * (P - C) * P)
	S = CLNG(S * 100) / 100    'rounding off to 0.01
	PRINT
	PRINT "S ="; S
ELSE
	PRINT
	PRINT "Such a triangle does not exist!"
END IF
END SUB

SUB Triangle2
'   ********************************************************
'   *  Calculation of area of triangle by base and height  *
'   ********************************************************
CLS
LINE (50, 55)-(240, 95)
LINE -(20, 95)
LINE -(50, 55)
LINE (50, 55)-(50, 95), , , &HAAAA
LOCATE 8, 14
PRINT "a"
LOCATE 6, 8
PRINT "h"
LOCATE 12, 1
PRINT "Enter parameters:"
PRINT
INPUT "a = ", A
INPUT "h = ", H
IF A > 0 AND H > 0 THEN
	S = A * H / 2
	PRINT
	PRINT "S ="; S
ELSE
	PRINT
	PRINT "Such a triangle does not exist!"
END IF
END SUB

SUB Triangle3
'   *****************************************
'   *    Calculation of area of triangle    *
'   *  by two sides and angle between them  *
'   *****************************************
CLS
LINE (50, 50)-(240, 92)
LINE -(20, 92)
LINE -(50, 50)
LOCATE 8, 14
PRINT "a"
LOCATE 5, 4
PRINT "b"
LOCATE 6, 6
PRINT "C"
LOCATE 12, 1
PRINT "Enter values of parametrs:"
PRINT
INPUT "a = ", A
INPUT "b = ", B
INPUT "C = ", C
IF A > 0 AND B > 0 AND C > 0 AND C < 180 THEN
	Pi = 3.141593
	S = A * B / 2 * SIN(C * Pi / 180)
	S = CLNG(S * 100) / 100    'rounding off to 0.01
	PRINT
	PRINT "S ="; S
ELSE
	PRINT
	PRINT "Such a triangle does not exist!"
END IF
END SUB

SUB Triangles
' **********************************************
' *  Selection of source data for calculation  *
' *            of area of triangle             *
' * Demonstration of  use of second-level menu *
' **********************************************
DO
	CALL Menu(10, 33, "Triangles", NT1%)
	SELECT CASE NT1%
	CASE 1
		CALL Triangle1
	CASE 2
		CALL Triangle2
	CASE 3
		CALL Triangle3
	CASE 4
		EXIT DO
	END SELECT
	Pause$ = INPUT$(1)
LOOP
END SUB

