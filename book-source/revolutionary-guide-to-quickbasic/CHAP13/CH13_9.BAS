REM Demonstration  program         
REM A sample selection of answer      
REM with the use of vertical scrolling
REM \CHAP13\CH13_9.BAS

DECLARE SUB Result (V!)
DECLARE SUB ChoiceExample (X0!, Y0!, LH!, LW!, Variant!)
DECLARE SUB Title ()
DECLARE SUB Box (X1!, Y1!, X2!, Y2!, Version!, Clr1!, Clr2!)

SCREEN 0
COLOR 15, 1
CLS
LOCATE 3, 23, 0
PRINT "DEMONSTRATION OF VERTICAL SCROLLING"
LOCATE 4, 30
PRINT "AT A SAMPLE SELECTION"
LOCATE 5, 36
PRINT "OF ANSWER"
CALL ChoiceExample(8, 21, 5, 38, V)
CALL Result(V)
L$ = INPUT$(1)

'-----------------------------------------------------------
DataBox:
' *** Data for procedure Box ***
DATA Ú, Ä, ¿, ³, À, Ù
DATA É, Í, », º, È, ¼
DATA Õ, Í, ¸, ³, Ô, ¾
DATA Û, Û, Û, Û, Û, Û
'-----------------------------------------------------------
Text:
' *** Data for procedure ChoiceExample ***
DATA 12, "1. Murphy's law", "2. Bouguer's law"
DATA "3. Law of conservation of energy", "4. Law of an aircraft"
DATA "5. 1-st Jibble's law of unreliability"
DATA "6. 3-rd Jibble's law of unreliability"
DATA "7. 1-st Golub's law of PC world"
DATA "8. IBM principle", "9. Law of proportionality"
DATA "10. Schmidt's law", "11. Maximain's law"
DATA "12. Kann's axiom"
'-----------------------------------------------------------
' *** Data for procedure Result ***
1 :
  DATA 1, "If a trouble can happen, it will."
2 :
  DATA 2, "Even  a  small  practics  worths  a  big"
  DATA "theory."
3 :
  DATA 1, "Don't  be  fussy."
4 :
  DATA 3, "When  your  plane  is  late, the  plane,"
  DATA "for which you  wished to change  departs"
  DATA "at the proper time."
5 :
  DATA 2, "Computers are unreliable, but people are"
  DATA "even more unreliable."
6 :
  DATA 4, "The  number of  errors  that  can not be"
  DATA "detected  is  infinite,  contrary to the"
  DATA "number  of  those  that are possible to"
  DATA "detect: it is finite by definition."
7 :
  DATA 4, "   An  inaccurately   prepared   program"
  DATA "requires 3 times  more time, than it was"
  DATA "assumed; a carefully prepared one - only"
  DATA "two times more"
8 :
  DATA 1, "A  machine  must  work, a human - think."
9 :
  DATA 2, "The  more a program  is  necessary,  the"
  DATA "more errors it has."
10 :
  DATA 2, "If a machine is spoiled  rather long, it"
  DATA "will break."
11 :
  DATA 3, "One has  always not  enough time to do a"
  DATA "work properly, but he will always find a"
  DATA "lot, to do it anew."
12 :
  DATA 2, "If there is nothing  more to help, read,"
  DATA "at last, the instruction."
'-----------------------------------------------------------
END

SUB Box (X1, Y1, X2, Y2, Version, Clr1, Clr2)
' ********************
' * Draw a framework *
' ********************
' X1, Y1 - coordinates of upper left corner of framework
' X2, Y2 - coordinates of right lower corner of framework
' Version - form of framework
' Clr1, Clr2 - fore- and background color of framework

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

SUB ChoiceExample (X0, Y0, LH, LW, Variant)
' **************************************
' *    A sample selection of answer    *
' * with the use of vertical scrolling *
' **************************************

' X0, Y0 - coordinates of upper left corner of selection window
' LH - number of rows in window line (height of window)
' LW - number of columns in window (width of window)
' Variant - ­®¬¥à ¢ë¡à ­­®£® ¢ à¨ ­â 
'
' Cursor - pointer of cursor position
' Top - number of first line in window
' CP - foreground color
' CB - background color
' CPBox - color of framework
' CBBox - Framework's background color

  GOSUB Init
  CALL Box(X0 - 1, Y0 - 1, X0 + LH, Y0 + LW, 2, CPBox, CBBox)
  GOSUB OnScreen
  DO
    DO
      Key$ = INKEY$
    LOOP UNTIL Key$ <> ""
    SELECT CASE Key$
    CASE CHR$(0) + CHR$(72)                 'Up
      IF Cursor = Top AND Top > 1 THEN Top = Top - 1
      IF Cursor > 1 THEN Cursor = Cursor - 1
      GOSUB OnScreen
    CASE CHR$(0) + CHR$(80)                 'Down
      IF Cursor = Top + LH - 1 THEN   'cursor at bottom of window
        IF Top <= Num - LH THEN Top = Top + 1
      END IF
      IF Cursor < Num THEN Cursor = Cursor + 1
      GOSUB OnScreen
    CASE CHR$(0) + CHR$(73)                  'Page Up
      Top = Top - LH
      IF Top < 1 THEN Top = 1
      Cursor = Cursor - LH
      IF Cursor < 1 THEN Cursor = 1
      GOSUB OnScreen
    CASE CHR$(0) + CHR$(81)                  'Page Down
      Top = Top + LH
      IF Top > Num - LH THEN Top = Num - LH + 1
      Cursor = Cursor + LH
      IF Cursor > Num THEN Cursor = Num
      GOSUB OnScreen
    CASE CHR$(27)                            'Esc
      Variant = 0
      EXIT DO
    CASE CHR$(13)                            'Enter
      Variant = Cursor
      EXIT DO
    END SELECT
  LOOP
  EXIT SUB
'-----------------------------------------------------------
Init:
' ***  Initialization of variables  ***
' ***              and              ***
' *** data for selecting an option  ***
  CP = 0
  CB = 7
  CPBox = 0
  CBBox = 7
  CPCursor = 15
  CBCursor = 4

  RESTORE Text
  READ Num
  DIM Text$(Num)
  FOR I = 1 TO Num
    READ Text$(I)
    Text$(I) = LEFT$(Text$(I) + SPACE$(80), LW)
  NEXT I
  Top = 1
  Cursor = 1
RETURN
'-----------------------------------------------------------
OnScreen:
' *** Displaying selection options and cursor ***
' Cursor - pointer of cursor's position
' Top - number of first line in selection window
  FOR I = 1 TO LH
    LOCATE X0 + I - 1, Y0
    IF Cursor = I + Top - 1 THEN
      COLOR CPCursor, CBCursor
    ELSE
      COLOR 15, 0
      COLOR CP, CB
    END IF
    PRINT Text$(Top + I - 1)
  NEXT I
RETURN
'-----------------------------------------------------------
END SUB

SUB Result (V)
' ************************************
' *   Output of result onto screen   *
' ************************************
IF V = 0 THEN
  CALL Box(16, 32, 18, 48, 4, 0, 0)
  CALL Box(15, 31, 17, 47, 1, 15, 3)
  LOCATE 16, 32
  PRINT "Choice not made"
  EXIT SUB
END IF
LOCATE 15, 25
COLOR 15, 1
PRINT "You have selected item number"; V
SELECT CASE V        'Selection of data block
CASE 1
  RESTORE 1
CASE 2
  RESTORE 2
CASE 3
  RESTORE 3
CASE 4
  RESTORE 4
CASE 5
  RESTORE 5
CASE 6
  RESTORE 6
CASE 7
  RESTORE 7
CASE 8
  RESTORE 8
CASE 9
  RESTORE 9
CASE 10
  RESTORE 10
CASE 11
  RESTORE 11
CASE 12
  RESTORE 12
END SELECT
READ N
X3 = 17
X4 = 20
COLOR 15, 1
LOCATE X3, X4 - 1
  PRINT STRING$(42, "Ü")
COLOR 15, 3
FOR I = 1 TO N
  READ S$
  S$ = S$ + STRING$(40 - LEN(S$), " ")
  LOCATE X3 + I, X4 - 1
  PRINT "Ý"; S$; "Þ"
NEXT I
COLOR 15, 0
LOCATE , X4 - 1
  PRINT STRING$(42, "ß")
END SUB

