'****************************************************************
' TEXTWIN.BAS = Text editor - editings text in a windows
' ===========   Texteditor - Text in einem Fenster editieren
'
' Deutsche Beschreibung
' ---------------------
' (von Thomas Antoni, 14.3.2006)
' Dieses Q(uick)Basic-Programm ermoeglicht es, Text in einem
' Eingabefenster einzugeben und zu editieren. Folgende Editier-
' Tasten werden unterstuetzt: Entf, BackSpace, alle 4 Cursor-
' Tasten, Einfg, Pos1, Ende
'
' English description
' ---------------------
' This Sample program shows how to use TextWindow -- a function
' that allows a user to enter a window of text
'
' (c) unknown author, delivered by BRIAN MCLAUGHLIN, Dec. 2, 1993
'****************************************************************
'
DEFINT A-Z
DECLARE FUNCTION TextWindow (Buffer$, Lines, Columns, x, y)
DECLARE SUB MakeBox (x, y, Lines, Columns)
CLS
LOCATE 15, 1: PRINT "Here are the results: "
'declare Text Window size
TextLines = 10: TextCols = 64
Xwindow = 3: Ywindow = 10
'declare buffer area to hold text
Buffer$ = SPACE$(TextLines * TextCols)
' call text window
ExitOK = TextWindow(Buffer$, TextLines, TextCols, Xwindow, Ywindow)
IF ExitOK THEN
 PRINT Buffer$
ELSE
 PRINT "Window not Saved"
END IF
SLEEP
END
'
SUB MakeBox (x, y, Lines, Columns)
' Draw a single line box beginning at X,Y
' box is Lines tall by Columns wide
DEFINT A-Z
' top row
LOCATE x, y, 0
PRINT CHR$(218);
PRINT STRING$(Columns - 2, CHR$(196));
PRINT CHR$(191)
'bottom row
LOCATE x + Lines - 1, y, 0
PRINT CHR$(192);
PRINT STRING$(Columns - 2, CHR$(196));
PRINT CHR$(217)
'sides
FOR I = 1 TO Lines - 2
   LOCATE x + I, y, 0: PRINT CHR$(179)
   LOCATE x + I, y + Columns - 1, 0
   PRINT CHR$(179)
NEXT I
END SUB
'
FUNCTION TextWindow (Buffer$, Lines, Columns, Xwindow, Ywindow)
' This function allows the user to key in a window
' of text the input area will be Lines by Columns
' in size.  xwindow and ywindow are the upper left
' corner coordinates of text entry window
' The text is placed in Buffer$
' returns TRUE if user saves with Ctrl-End,
' FALSE on Esc
'save cursor position
SaveX = CSRLIN: SaveY = POS(0)
' Scan codes for current valid user key-strokes
ScanKeyhome = 71
ScanKeyend = 79
ScanKeyup = 72
ScanKeyleft = 75
ScanKeyright = 77
ScanKeydown = 80
ScanKeyctrlleft = 115
ScanKeyctrlright = 116
ScanKeyinsert = 82
ScanKeydelete = 83
ScanKeyctrlend = 117
ScanKeyenter = 13
ScanKeyescape = 27
ScanKeybackspace = 8
'Start with insert mode turned off
FALSE = 0
TRUE = NOT FALSE
inserton = FALSE
' Draw box around text, display marquis
CALL MakeBox(Xwindow - 1, Ywindow - 1, Lines + 3, Columns + 2)
LOCATE Xwindow + Lines, Ywindow + 1, 0
PRINT "[Esc] to Abort,[Ctrl-End] to Save"
'Current X,Y Coordinates of cursor within window
XCoord = Xwindow: YCoord = Ywindow
'start taking text in top left corner
LOCATE XCoord, YCoord, 1
'main user input loop
'
DO
  UserKey$ = INKEY$
  SELECT CASE LEN(UserKey$)
    CASE 2 'two-byte scan codes
      SELECT CASE ASC(RIGHT$(UserKey$, 1))
        CASE ScanKeyhome
          XCoord = Xwindow: YCoord = Ywindow
        CASE ScanKeyend
          XCoord = Xwindow + Lines - 1
          YCoord = Ywindow + Columns - 1
        CASE ScanKeyup
          IF XCoord > Xwindow THEN
            XCoord = XCoord - 1
          END IF
        CASE ScanKeyleft
          IF YCoord > Ywindow THEN
            YCoord = YCoord - 1
          END IF
        CASE ScanKeyright
          IF YCoord < Ywindow + Columns - 1 THEN
            YCoord = YCoord + 1
          END IF
        CASE ScanKeydown
          IF XCoord < Xwindow + Lines - 1 THEN
            XCoord = XCoord + 1
          END IF
        CASE ScanKeyctrlleft
          GOSUB LeftWord
        CASE ScanKeyctrlright
          GOSUB RightWord
        CASE ScanKeyinsert
          inserton = NOT inserton
          LOCATE 25, 50, 0
          IF inserton THEN
            PRINT "Insert mode";
          ELSE
            PRINT SPACE$(11);
          END IF
        CASE ScanKeydelete
          GOSUB MoveLeft
        CASE ScanKeyctrlend
          TextWindow = TRUE
          EXIT DO
        CASE ELSE
          PRINT ASC(RIGHT$(UserKey$, 1))
      END SELECT
      LOCATE XCoord, YCoord, 1
    CASE 1 'single-character scan codes
      SELECT CASE ASC(UserKey$)
        CASE ScanKeyenter
          IF XCoord < Lines + Xwindow - 1 THEN
            XCoord = XCoord + 1
          END IF
          YCoord = Ywindow
          LOCATE XCoord, YCoord, 1
        CASE ScanKeyescape
          TextWindow = FALSE
          EXIT DO
        CASE ScanKeybackspace
          IF YCoord > Ywindow THEN
            YCoord = YCoord - 1
            GOSUB MoveLeft
          END IF
          LOCATE XCoord, YCoord, 1
        CASE ELSE
          IF inserton THEN
            GOSUB MoveRight
          END IF
          GOSUB UpdateBuffer
          LOCATE XCoord, YCoord, 1
          PRINT UserKey$;
          IF YCoord < Columns + Ywindow - 1 THEN
            YCoord = YCoord + 1
          END IF
      END SELECT
    END SELECT
LOOP
'End of main user input loop
'restore cursor position
LOCATE SaveX, SaveY, 1
EXIT FUNCTION
UpdateBuffer:
' put the character typed into the string buffer
   GOSUB ComputeBufPosn
   MID$(Buffer$, BufPosn, 1) = UserKey$
RETURN
MoveLeft:
' move characters left on delete or backspace
   SaveYCoord = YCoord
   FOR YCoord = SaveYCoord + 1 TO Ywindow + Columns - 1 STEP 1
      GOSUB ComputeBufPosn
      OldChar$ = MID$(Buffer$, BufPosn, 1)
      LOCATE XCoord, YCoord - 1, 0
      PRINT OldChar$;
      MID$(Buffer$, BufPosn - 1, 1) = OldChar$
   NEXT YCoord
   MID$(Buffer$, BufPosn, 1) = " "
   LOCATE XCoord, YCoord - 1, 1
   PRINT " "
   YCoord = SaveYCoord
   GOSUB ComputeBufPosn
RETURN
'
MoveRight:
' move characters right on insert

   SaveYCoord = YCoord
   FOR YCoord = Ywindow + Columns - 2 TO YCoord STEP -1
      GOSUB ComputeBufPosn
      OldChar$ = MID$(Buffer$, BufPosn, 1)
      LOCATE XCoord, YCoord + 1, 0
      PRINT OldChar$;
      MID$(Buffer$, BufPosn + 1, 1) = OldChar$
   NEXT YCoord
   YCoord = SaveYCoord
   GOSUB ComputeBufPosn
   MID$(Buffer$, BufPosn, 1) = " "
   LOCATE XCoord, YCoord, 1
   PRINT " ";
RETURN
'
LeftWord:
'Find the next word to the left

   GOSUB ComputeBufPosn
   IF BufPosn > 1 THEN BufPosn = BufPosn - 1
   CharsSeen = FALSE
   WordFound = FALSE
   DO
      ThisChar$ = MID$(Buffer$, BufPosn, 1)
      CharsSeen = CharsSeen OR (ThisChar$ <> " ")
      IF CharsSeen AND (ThisChar$ = " ") THEN
         WordFound = TRUE
      ELSE
         BufPosn = BufPosn - 1
      END IF
   LOOP UNTIL WordFound OR BufPosn = 0
   GOSUB ComputeCoords
   LOCATE XCoord, YCoord, 1
RETURN
'
RightWord:
'Find the next word to the right
'
   GOSUB ComputeBufPosn
   SpacesSeen = FALSE
   WordFound = FALSE
   DO
      ThisChar$ = MID$(Buffer$, BufPosn, 1)
      SpacesSeen = SpacesSeen OR (ThisChar$ = " ")
      IF SpacesSeen AND (ThisChar$ <> " ") THEN
         WordFound = TRUE
      ELSE
         IF BufPosn < Lines * Columns THEN BufPosn = BufPosn + 1
      END IF
   LOOP UNTIL WordFound OR BufPosn = Lines * Columns
   BufPosn = BufPosn - 1
   GOSUB ComputeCoords
   LOCATE XCoord, YCoord, 1
RETURN
'
ComputeBufPosn:
' Compute current position within buffer

   BufPosn = ((XCoord - Xwindow) * Columns) + YCoord - Ywindow + 1
RETURN
'
ComputeCoords:
'Compute screen Coordinates of relative BufPosn
'
   XCoord = Xwindow + INT(BufPosn / Columns)
   YCoord = Ywindow + (BufPosn MOD Columns)
RETURN
'
END FUNCTION

