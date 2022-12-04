REM Demonstration of full-screen
REM Items are selected using graphic pointer
REM \CHAP13\CH13_3.BAS

DECLARE SUB Pointer (X!, Y AS INTEGER)
DECLARE SUB Triangle2 ()
DECLARE SUB Triangle3 ()
DECLARE SUB Triangle1 ()
DECLARE SUB Menu (X0!, Y0!, IM$, NT%)
DECLARE SUB Triangles ()
DECLARE SUB Circle1 ()
DECLARE SUB Trapesium ()
DECLARE SUB Rectangle ()
'------------------------------------------------------------
COMMON SHARED A%()
SCREEN 9, 1, 0
CALL Pointer(1, 1)
SCREEN 0, , 0, 1
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
Cursor:
DATA 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0
DATA 0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1
DATA 0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
DATA 0,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1
DATA 1,0,0,0,0,0,1,0,0,0,0,1,1,1,1,1,1,0
DATA 1,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,0
DATA 1,0,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0
DATA 1,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0
DATA 1,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0
DATA 1,0,0,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0
DATA 1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0
DATA 1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0
DATA 1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0
DATA 0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0
DATA 0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
'============================================================

SUB Circle1
'   **********************************
'   *  Calculation of area of circle *
'   **********************************
SCREEN 2
CLS
CIRCLE (70, 40), 50
LINE (70, 20)-(70, 60), , , &HAAAA
LOCATE 6, 8
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
'   ********************************************
'   *                  Menu                    *
'   *   Options are selected using a pointer   *
'   ********************************************
' X0, Y0 - coordinates of upper left corner of menu
' IM$ - Selection of data block for menu
' NT% - number of chosen item

SCREEN 9
CLS
'WIDTH 40
Wide% = 80        'screen width
SELECT CASE IM$
CASE "Main"
	RESTORE DataMenuMain
CASE "Triangles"
	RESTORE DataMenuTriangles
END SELECT
READ N%, Title$   'number of menu items and a title

' *** Centering and outputting title ***
T = (Wide% - LEN(Title$)) / 2
LOCATE X0 - 2, T
PRINT Title$

' *** Outputting menu onto screen ***
FOR I = 1 TO N%
	READ B$
	LOCATE X0 + I - 1, Y0
	PRINT B$
NEXT I

' *** Selection of option ***
X = X0: Y = Y0 - 3 'current position of pointer
NT% = 1
DO
	PUT (Y * 8 - 10, (X - 1) * 14 + 3), A%, XOR
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
	PUT (Y * 8 - 10, (X - 1) * 14 + 3), A%, XOR
	X = X0 + NT% - 1
LOOP
END SUB

SUB Pointer (X, Y AS INTEGER)
'   ************************************
'   *  Definition of graphic pointer   *
'   ************************************

' *** Defining form of graphic pointer ***
RESTORE Cursor
FOR I = 1 TO 16
	FOR J = 1 TO 18
		READ C
		IF C = 1 THEN PSET (J, I)
	NEXT J
NEXT I

' *** Determining number of bytes to store pointer ***
L = 4 + INT(((18 + 1) + 7) / 8) * 4 * (16 + 1)

' *** Storing pointer in array A%() ***
DIM A%(L)
GET (X, Y)-(X + 18, Y + 16), A%
END SUB

SUB Rectangle
'   ****************************************
'   *   Calculation of area of rectangle   *
'   ****************************************
SCREEN 2
CLS
LINE (20, 20)-(190, 60), , B
LOCATE 2, 14
PRINT "a"
LOCATE 5, 26
PRINT "b"
LOCATE 12, 1
PRINT "Enter  parameters:"
PRINT
INPUT "a = ", A
INPUT "b = ", B
S = A * B
PRINT
PRINT "S ="; S
Pause$ = INPUT$(1)
END SUB

SUB Trapesium
'   ****************************************
'   *   Calculation of area of trapesium   *
'   ****************************************
SCREEN 2
CLS
LINE (50, 20)-(180, 20)
LINE -(240, 60)
LINE -(20, 60)
LINE -(50, 20)
LINE (50, 20)-(50, 60), , , &HAAAA
LOCATE 2, 14
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
'   ******************************************************
'   *   Calculation of area of triangle by three sides   *
'   ******************************************************
SCREEN 2
CLS
LINE (50, 20)-(240, 60)
LINE -(20, 60)
LINE -(50, 20)
LOCATE 5, 19
PRINT "c"
LOCATE 9, 14
PRINT "a"
LOCATE 5, 4
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
'   **********************************************************
'   *   Calculation of area of triangle by base and height   *
'   **********************************************************
SCREEN 2
CLS
LINE (50, 20)-(240, 60)
LINE -(20, 60)
LINE -(50, 20)
LINE (50, 20)-(50, 60), , , &HAAAA
LOCATE 9, 14
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
'   ******************************************
'   *   Calculation of area of triangle by   *
'   *    two sides and angle between them    *
'   ******************************************
SCREEN 2
CLS
LINE (50, 20)-(240, 60)
LINE -(20, 60)
LINE -(50, 20)
LOCATE 9, 14
PRINT "a"
LOCATE 5, 4
PRINT "b"
LOCATE 7, 6
PRINT "C"
LOCATE 12, 1
PRINT "Enter parameters:"
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
' ************************************************
' *   Selection of source data for calculation   *
' *              of area of triangle             *
' *      Demonstration of second-level menu      *
' ************************************************
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

