DECLARE SUB Intro ()
DECLARE SUB CenterText (YLINE!, TEXT$, CLR!)
DECLARE FUNCTION OverLapped! (X!, Y!, piecenum!, ROT!)
DECLARE FUNCTION Settled! (X!, Y!, piecenum!, ROT!)
DECLARE SUB AppendBoard (X!, Y!, piecenum!, ROT!)
DECLARE SUB CheckRows ()
DECLARE SUB PSETPIC (COL!, ROW!, PICNUM!)
DECLARE SUB InitRealBoard ()
DECLARE SUB DrawRealBoard ()
DECLARE SUB DrawBoard (BOARD!)
DECLARE SUB InitBoard (BOARD!)
DECLARE FUNCTION BLOCKEDTOLEFT! (X!, Y!, piecenum!, ROT)
DECLARE FUNCTION BLOCKEDTORIGHT! (X, Y, piecenum!, ROT)
DECLARE SUB DoCommand (D$)
DECLARE SUB XORPIC (COL!, ROW!, PICNUM!)
DECLARE SUB ERASEPIECE (X!, Y!, piecenum!, ROT!)
DECLARE FUNCTION KeyPressed! (D$)
DECLARE FUNCTION AlreadyThere! (PUTLIST!, PICNUM!)
DECLARE SUB DrawPicture (X!, Y!)
DECLARE FUNCTION TOPLEFTY! (ROW!)
DECLARE SUB DRAWPIECE (X!, Y!, piecenum!, ROT!)
DECLARE FUNCTION TOPLEFTX! (COL!)
DECLARE SUB GetPicture (X!, Y!, PICNUM!)
DECLARE SUB PUTPIC (X!, Y!, PICNUM!)

CONST DRIVE = "C:\"
CONST DIRECTORY = "BASICG~1\BLOCKM~1\"
CONST DELAYTIME = 50
CONST MAXLEVELS = 10
CONST MOVEDIST = 3
CONST NUMCOLS = 27
CONST NUMROWS = 23
CONST NUMPICS = 12
CONST REALROWS = 19
CONST REALCOLS = 10
CONST XDIF = 9
CONST YDIF = 1
CONST NEXTX = 4, NEXTY = 4
DIM SHARED PUTLIST(0 TO NUMPICS)
DIM SHARED BLUE%(1 TO 200)
DIM SHARED RED%(1 TO 500)
DIM SHARED CYAN%(1 TO 500)
DIM SHARED PURPLE%(1 TO 500)
DIM SHARED GREEN%(1 TO 500)
DIM SHARED BRICK%(1 TO 500)
DIM SHARED STEEL%(1 TO 500)
DIM SHARED DELUSION1%(1 TO 490)
DIM SHARED DELUSION2%(1 TO 590)
DIM SHARED DELUSION3%(1 TO 590)
DIM SHARED DELUSION4%(1 TO 590)
DIM SHARED BOARD(1 TO NUMCOLS, 1 TO NUMROWS)
DIM SHARED REALBOARD(1 TO REALCOLS, 1 TO REALROWS)
'INITIALIZE VARIABLES'
RANDOMIZE TIMER
SCREEN 12
X = 14: Y = 2
piecenum = INT(RND * 7) + 1
NEXTNUM = INT(RND * 7) + 1
PUTLIST(0) = 1
ROT = 1
'INTRO'
CALL Intro
'MAIN BLOCK'
CALL InitBoard(BOARD)
CALL DrawBoard(BOARD)
CALL DrawRealBoard
CALL DrawRealBoard
CALL DRAWPIECE(NEXTX, NEXTY, NEXTNUM, 1)
WHILE GAMEOVER = 0
  IF Settled(X, Y, piecenum, ROT) = 1 THEN
    CALL AppendBoard(X, Y, piecenum, ROT)
    CALL CheckRows
    CALL ERASEPIECE(NEXTX, NEXTY, NEXTNUM, 1)
    Y = 2: piecenum = NEXTNUM: NEXTNUM = INT(RND * 7) + 1: ROT = 1: X = 14
    CALL DRAWPIECE(NEXTX, NEXTY, NEXTNUM, 1)
    IF OverLapped(X, Y, piecenum, ROT) = 1 THEN GAMEOVER = 1
  ELSE
    CALL DoCommand(D$)
  END IF
  IF GAMEOVER = 0 THEN
    D$ = ""
    CALL DRAWPIECE(X, Y, piecenum, ROT)
    FOR STALL = 1 TO DELAYTIME * MAXLEVELS - (LEVEL * DELAYTIME) + 1
      IF KeyPressed(D$) = 0 THEN D$ = INKEY$: D$ = UCASE$(D$):  ELSE EXIT FOR
    NEXT STALL
    IF Settled(X, Y, piecenum, ROT) = 0 THEN
      CALL ERASEPIECE(X, Y, piecenum, ROT)
    END IF
    IF D$ = "Q" THEN GAMEOVER = 1
  END IF
  IF LINECOUNT > 10 THEN
    LEVEL = LEVEL + 1
    LINECOUNT = 0
  END IF
WEND
CALL CenterText(13, "****GAME OVER****", 15)

FUNCTION AlreadyThere (PUTLIST, PICNUM)
AlreadyThere = PUTLIST(PICNUM)
END FUNCTION

SUB AppendBoard (X, Y, piecenum, ROT) : SHARED BOARD, REALBOARD
    SELECT CASE piecenum
      CASE 1
        IF ROT = 1 THEN
          BOARD(X, Y) = 1
          BOARD(X, Y - 1) = 1
          BOARD(X, Y + 1) = 1
          BOARD(X, Y + 2) = 1
        ELSE
          BOARD(X, Y) = 1
          BOARD(X - 1, Y) = 1
          BOARD(X + 1, Y) = 1
          BOARD(X + 2, Y) = 1
        END IF
      CASE 2
        BOARD(X, Y) = 2
        BOARD(X + 1, Y) = 2
        BOARD(X, Y + 1) = 2
        BOARD(X + 1, Y + 1) = 2
      CASE 3
        IF ROT = 1 THEN
          BOARD(X, Y) = 3
          BOARD(X - 1, Y) = 3
          BOARD(X, Y + 1) = 3
          BOARD(X + 1, Y + 1) = 3
        ELSE
          BOARD(X, Y) = 3
          BOARD(X, Y - 1) = 3
          BOARD(X - 1, Y) = 3
          BOARD(X - 1, Y + 1) = 3
        END IF
      CASE 4
        IF ROT = 1 THEN
          BOARD(X, Y) = 4
          BOARD(X + 1, Y) = 4
          BOARD(X - 1, Y + 1) = 4
          BOARD(X, Y + 1) = 4
        ELSE
          BOARD(X, Y) = 4
          BOARD(X - 1, Y) = 4
          BOARD(X - 1, Y - 1) = 4
          BOARD(X, Y + 1) = 4
        END IF
      CASE 5
        SELECT CASE ROT
          CASE 1
            BOARD(X, Y) = 5
            BOARD(X, Y - 1) = 5
            BOARD(X, Y + 1) = 5
            BOARD(X + 1, Y - 1) = 5
          CASE 2
            BOARD(X, Y) = 5
            BOARD(X - 1, Y) = 5
            BOARD(X - 1, Y - 1) = 5
            BOARD(X + 1, Y) = 5
          CASE 3
            BOARD(X, Y) = 5
            BOARD(X, Y + 1) = 5
            BOARD(X, Y - 1) = 5
            BOARD(X - 1, Y + 1) = 5
          CASE 4
            BOARD(X, Y) = 5
            BOARD(X - 1, Y) = 5
            BOARD(X + 1, Y) = 5
            BOARD(X + 1, Y + 1) = 5
        END SELECT
      CASE 6
        SELECT CASE ROT
          CASE 1
            BOARD(X, Y) = 5
            BOARD(X, Y - 1) = 5
            BOARD(X, Y + 1) = 5
            BOARD(X - 1, Y - 1) = 5
          CASE 2
            BOARD(X, Y) = 5
            BOARD(X + 1, Y) = 5
            BOARD(X - 1, Y) = 5
            BOARD(X - 1, Y + 1) = 5
          CASE 3
            BOARD(X, Y) = 5
            BOARD(X, Y - 1) = 5
            BOARD(X, Y + 1) = 5
            BOARD(X + 1, Y + 1) = 5
          CASE 4
            BOARD(X, Y) = 5
            BOARD(X - 1, Y) = 5
            BOARD(X + 1, Y) = 5
            BOARD(X + 1, Y - 1) = 5
        END SELECT
      CASE 7
        SELECT CASE ROT
          CASE 1
            BOARD(X, Y) = 1
            BOARD(X, Y - 1) = 1
            BOARD(X + 1, Y) = 1
            BOARD(X - 1, Y) = 1
          CASE 2
            BOARD(X, Y) = 1
            BOARD(X, Y - 1) = 1
            BOARD(X, Y + 1) = 1
            BOARD(X + 1, Y) = 1
          CASE 3
            BOARD(X, Y) = 1
            BOARD(X - 1, Y) = 1
            BOARD(X + 1, Y) = 1
            BOARD(X, Y + 1) = 1
          CASE 4
            BOARD(X, Y) = 1
            BOARD(X, Y - 1) = 1
            BOARD(X, Y + 1) = 1
            BOARD(X - 1, Y) = 1
        END SELECT
    END SELECT
END SUB

FUNCTION BLOCKEDTOLEFT (X, Y, piecenum, ROT) : SHARED BOARD
SELECT CASE piecenum
CASE 1
  IF ROT = 1 THEN
    IF BOARD(X - 1, Y - 1) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 OR BOARD(X - 1, Y + 2) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  ELSE
    IF BOARD(X - 2, Y) >= 1 THEN BLOCKEDTOLEFT = 1:  ELSE BLOCKEDTOLEFT = 0
  END IF
CASE 2
  IF BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 THEN
    BLOCKEDTOLEFT = 1
  ELSE
    BLOCKEDTOLEFT = 0
  END IF
CASE 3
  IF ROT = 1 THEN
    IF BOARD(X - 2, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  ELSE
    IF BOARD(X - 2, Y) >= 1 OR BOARD(X - 1, Y - 1) >= 1 OR BOARD(X - 2, Y + 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  END IF
CASE 4
  IF ROT = 1 THEN
    IF BOARD(X - 1, Y) >= 1 OR BOARD(X - 2, Y + 1) THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  ELSE
    IF BOARD(X - 2, Y - 1) >= 1 OR BOARD(X - 2, Y) >= 1 OR BOARD(X - 1, Y + 1) THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  END IF
CASE 5
  SELECT CASE ROT
  CASE 1
    IF BOARD(X - 1, Y - 1) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  CASE 2
    IF BOARD(X - 2, Y) >= 1 OR BOARD(X - 2, Y + 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  CASE 3
    IF BOARD(X - 1, Y - 1) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X - 2, Y + 1) THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  CASE 4
    IF BOARD(X - 2, Y) >= 1 OR BOARD(X, Y + 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  END SELECT
CASE 6
  SELECT CASE ROT
  CASE 1
    IF BOARD(X - 2, Y - 1) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  CASE 2
    IF BOARD(X - 2, Y) >= 1 OR BOARD(X - 2, Y + 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  CASE 3
    IF BOARD(X - 1, Y - 1) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y + 1) THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  CASE 4
    IF BOARD(X - 2, Y) >= 1 OR BOARD(X, Y - 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  END SELECT
CASE 7
  SELECT CASE ROT
  CASE 1
    IF BOARD(X - 2, Y) >= 1 OR BOARD(X - 1, Y - 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  CASE 2
    IF BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 OR BOARD(X - 1, Y - 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  CASE 3
    IF BOARD(X - 2, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  CASE 4
    IF BOARD(X - 2, Y) >= 1 OR BOARD(X - 1, Y - 1) >= 1 OR BOARD(X - 1, Y + 1) >= 1 THEN
      BLOCKEDTOLEFT = 1
    ELSE
      BLOCKEDTOLEFT = 0
    END IF
  END SELECT
END SELECT
END FUNCTION

FUNCTION BLOCKEDTORIGHT (X, Y, piecenum, ROT) : SHARED BOARD
SELECT CASE piecenum
CASE 1
  IF ROT = 1 THEN
    IF BOARD(X + 1, Y - 1) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X + 1, Y + 1) >= 1 OR BOARD(X + 1, Y + 2) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  ELSE
    IF BOARD(X + 3, Y) >= 1 THEN BLOCKEDTORIGHT = 1:  ELSE BLOCKEDTORIGHT = 0
  END IF
CASE 2
  IF BOARD(X + 2, Y) >= 1 OR BOARD(X + 2, Y + 1) >= 1 THEN
    BLOCKEDTORIGHT = 1
  ELSE
    BLOCKEDTORIGHT = 0
  END IF
CASE 3
  IF ROT = 1 THEN
    IF BOARD(X + 1, Y) >= 1 OR BOARD(X + 2, Y + 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  ELSE
    IF BOARD(X + 1, Y) >= 1 OR BOARD(X + 1, Y - 1) >= 1 OR BOARD(X, Y + 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  END IF
CASE 4
  IF ROT = 1 THEN
    IF BOARD(X + 2, Y) >= 1 OR BOARD(X + 1, Y + 1) THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  ELSE
    IF BOARD(X, Y - 1) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X + 1, Y + 1) THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  END IF
CASE 5
  SELECT CASE ROT
  CASE 1
    IF BOARD(X + 2, Y - 1) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X + 1, Y + 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  CASE 2
    IF BOARD(X + 2, Y) >= 1 OR BOARD(X, Y + 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  CASE 3
    IF BOARD(X + 1, Y - 1) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X + 1, Y + 1) THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  CASE 4
    IF BOARD(X + 2, Y) >= 1 OR BOARD(X + 2, Y + 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  END SELECT
CASE 6
  SELECT CASE ROT
  CASE 1
    IF BOARD(X + 1, Y - 1) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X + 1, Y + 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  CASE 2
    IF BOARD(X + 2, Y) >= 1 OR BOARD(X, Y + 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  CASE 3
    IF BOARD(X + 1, Y - 1) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X + 2, Y + 1) THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  CASE 4
    IF BOARD(X + 2, Y) >= 1 OR BOARD(X + 2, Y - 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  END SELECT
CASE 7
  SELECT CASE ROT
  CASE 1
    IF BOARD(X + 2, Y) >= 1 OR BOARD(X + 1, Y - 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  CASE 2
    IF BOARD(X + 2, Y) >= 1 OR BOARD(X + 1, Y + 1) >= 1 OR BOARD(X + 1, Y - 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  CASE 3
    IF BOARD(X + 2, Y) >= 1 OR BOARD(X + 1, Y + 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  CASE 4
    IF BOARD(X + 1, Y) >= 1 OR BOARD(X + 1, Y - 1) >= 1 OR BOARD(X + 1, Y + 1) >= 1 THEN
      BLOCKEDTORIGHT = 1
    ELSE
      BLOCKEDTORIGHT = 0
    END IF
  END SELECT
END SELECT
END FUNCTION

SUB CenterText (YLINE, TEXT$, CLR)
LOCATE YLINE, 40 - (LEN(TEXT$) / 2)
COLOR CLR
PRINT TEXT$
END SUB

SUB CheckRows : SHARED BOARD, REALBOARD, LINECOUNT, TOTALLINES
CALL InitRealBoard
FOR R = 1 TO REALROWS
  BLANKFOUND = 0
  FOR C = 1 TO REALCOLS
    IF REALBOARD(C, R) = 0 THEN BLANKFOUND = 1
  NEXT C
  IF BLANKFOUND = 0 THEN
    LINECOUNT = LINECOUNT + 1
    LOCATE 17, 12: COLOR 10: PRINT "Lines"
    LOCATE 18, 10: PRINT "Completed"
    TOTALLINES = TOTALLINES + 1
    LOCATE 20, 10: COLOR 15: PRINT TOTALLINES; "    "
    FOR R2 = R TO 2 STEP -1
      FOR C2 = 1 TO REALCOLS
        REALBOARD(C2, R2) = REALBOARD(C2, R2 - 1)
        BOARD(C2 + XDIF, R2 + YDIF) = REALBOARD(C2, R2 - 1)
      NEXT C2
    NEXT R2
    CALL DrawRealBoard
  END IF
  BLANKFOUND = 0
NEXT R
END SUB

SUB DoCommand (D$) : SHARED piecenum, ROT, X, Y, MOVETIME, BOARD
SELECT CASE D$
  CASE "4"
    IF BLOCKEDTOLEFT(X, Y, piecenum, ROT) = 0 THEN X = X - 1
    SELECT CASE MOVETIME
      CASE 0: MOVETIME = 3
      CASE 1: IF Settled(X, Y, piecenum, ROT) = 0 THEN Y = Y + 1: MOVETIME = 0
      CASE IS > 1: MOVETIME = MOVETIME - 1
    END SELECT
  CASE "6"
    IF BLOCKEDTORIGHT(X, Y, piecenum, ROT) = 0 THEN X = X + 1
    SELECT CASE MOVETIME
      CASE 0: MOVETIME = 3
      CASE 1: IF Settled(X, Y, piecenum, ROT) = 0 THEN Y = Y + 1: MOVETIME = 0
      CASE IS > 1: MOVETIME = MOVETIME - 1
    END SELECT
  CASE "2"
    Y = Y + 1
  CASE "5"
    SELECT CASE piecenum
      CASE 1, 3, 4
        IF ROT = 1 THEN TEMPROT = 2:  ELSE TEMPROT = 1
      CASE 5, 6, 7
        IF ROT > 0 THEN TEMPROT = ROT + 1: IF TEMPROT > 4 THEN TEMPROT = 1
    END SELECT
    IF OverLapped(X, Y, piecenum, TEMPROT) = 0 THEN ROT = TEMPROT
    SELECT CASE MOVETIME
      CASE 0: MOVETIME = 3
      CASE 1: Y = Y + 1: MOVETIME = 0
      CASE IS > 1: MOVETIME = MOVETIME - 1
    END SELECT
  CASE "": IF Settled(X, Y, piecenum, ROT) = 0 THEN Y = Y + 1
END SELECT
END SUB

SUB DrawBoard (BOARD)
FOR ROW = 1 TO NUMROWS STEP 3.2
  FOR COL = 1 TO NUMCOLS STEP 3.5
    CALL PSETPIC(COL, ROW, 8)
    CALL PSETPIC(COL, ROW + 1.6, 9)
    CALL PSETPIC(COL + 1.8, ROW + 1.6, 10)
    CALL PSETPIC(COL + 1.8, ROW, 11)
  NEXT COL
NEXT ROW
FOR ROW = 1 TO NUMROWS
  FOR COL = 1 TO NUMCOLS
    SELECT CASE BOARD(COL, ROW)
      CASE 1: CALL PSETPIC(COL, ROW, 1)
      CASE 2: CALL PSETPIC(COL, ROW, 2)
      CASE 3: CALL PSETPIC(COL, ROW, 3)
      CASE 4: CALL PSETPIC(COL, ROW, 4)
      CASE 5: CALL PSETPIC(COL, ROW, 5)
      CASE 6: CALL PSETPIC(COL, ROW, 6)
      CASE 7: CALL PSETPIC(COL, ROW, 7)
    END SELECT
  NEXT COL
NEXT ROW

FOR ROW = 3 TO 6
  FOR COL = 3 TO 6
    CALL PSETPIC(ROW, COL, 0)
  NEXT COL
NEXT ROW
FOR ROW = 3 TO 6
  FOR COL = 13 TO 16
    CALL PSETPIC(ROW, COL, 0)
  NEXT COL
NEXT ROW
LOCATE 17, 12: COLOR 10: PRINT "Lines"
LOCATE 18, 10: PRINT "Completed"
LOCATE 20, 10: COLOR 15: PRINT " 0"
END SUB

SUB DrawPicture (X, Y)
STARTPOINT = 0: CURLINE = 0: ENDPOINT = 0
WHILE NOT EOF(1)
  INPUT #1, CLR, LINELEN
  IF CLR >= 0 THEN
    ENDPOINT = STARTPOINT + LINELEN
    LINE (X + STARTPOINT, Y + CURLINE)-(X + ENDPOINT, Y + CURLINE), CLR
    STARTPOINT = ENDPOINT + 1
  ELSE
    CURLINE = CURLINE + 1: STARTPOINT = 0: ENDPOINT = 0
  END IF
WEND
END SUB

SUB DRAWPIECE (X, Y, piecenum, ROT)
    SELECT CASE piecenum
      CASE 1
        IF ROT = 1 THEN
          CALL PUTPIC(X, Y, 1)
          CALL PUTPIC(X, Y - 1, 1)
          CALL PUTPIC(X, Y + 1, 1)
          CALL PUTPIC(X, Y + 2, 1)
        ELSE
          CALL PUTPIC(X, Y, 1)
          CALL PUTPIC(X - 1, Y, 1)
          CALL PUTPIC(X + 1, Y, 1)
          CALL PUTPIC(X + 2, Y, 1)
        END IF
      CASE 2
        CALL PUTPIC(X, Y, 2)
        CALL PUTPIC(X + 1, Y, 2)
        CALL PUTPIC(X, Y + 1, 2)
        CALL PUTPIC(X + 1, Y + 1, 2)
      CASE 3
        IF ROT = 1 THEN
          CALL PUTPIC(X, Y, 3)
          CALL PUTPIC(X - 1, Y, 3)
          CALL PUTPIC(X, Y + 1, 3)
          CALL PUTPIC(X + 1, Y + 1, 3)
        ELSE
          CALL PUTPIC(X, Y, 3)
          CALL PUTPIC(X, Y - 1, 3)
          CALL PUTPIC(X - 1, Y, 3)
          CALL PUTPIC(X - 1, Y + 1, 3)
        END IF
      CASE 4
        IF ROT = 1 THEN
          CALL PUTPIC(X, Y, 4)
          CALL PUTPIC(X + 1, Y, 4)
          CALL PUTPIC(X - 1, Y + 1, 4)
          CALL PUTPIC(X, Y + 1, 4)
        ELSE
          CALL PUTPIC(X, Y, 4)
          CALL PUTPIC(X - 1, Y, 4)
          CALL PUTPIC(X - 1, Y - 1, 4)
          CALL PUTPIC(X, Y + 1, 4)
        END IF
      CASE 5
        SELECT CASE ROT
          CASE 1
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X, Y - 1, 5)
            CALL PUTPIC(X, Y + 1, 5)
            CALL PUTPIC(X + 1, Y - 1, 5)
          CASE 2
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X - 1, Y, 5)
            CALL PUTPIC(X - 1, Y - 1, 5)
            CALL PUTPIC(X + 1, Y, 5)
          CASE 3
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X, Y + 1, 5)
            CALL PUTPIC(X, Y - 1, 5)
            CALL PUTPIC(X - 1, Y + 1, 5)
          CASE 4
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X - 1, Y, 5)
            CALL PUTPIC(X + 1, Y, 5)
            CALL PUTPIC(X + 1, Y + 1, 5)
        END SELECT
      CASE 6
        SELECT CASE ROT
          CASE 1
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X, Y - 1, 5)
            CALL PUTPIC(X, Y + 1, 5)
            CALL PUTPIC(X - 1, Y - 1, 5)
          CASE 2
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X + 1, Y, 5)
            CALL PUTPIC(X - 1, Y, 5)
            CALL PUTPIC(X - 1, Y + 1, 5)
          CASE 3
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X, Y - 1, 5)
            CALL PUTPIC(X, Y + 1, 5)
            CALL PUTPIC(X + 1, Y + 1, 5)
          CASE 4
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X - 1, Y, 5)
            CALL PUTPIC(X + 1, Y, 5)
            CALL PUTPIC(X + 1, Y - 1, 5)
        END SELECT
      CASE 7
        SELECT CASE ROT
          CASE 1
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X, Y - 1, 5)
            CALL PUTPIC(X + 1, Y, 5)
            CALL PUTPIC(X - 1, Y, 5)
          CASE 2
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X, Y - 1, 5)
            CALL PUTPIC(X, Y + 1, 5)
            CALL PUTPIC(X + 1, Y, 5)
          CASE 3
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X - 1, Y, 5)
            CALL PUTPIC(X + 1, Y, 5)
            CALL PUTPIC(X, Y + 1, 5)
          CASE 4
            CALL PUTPIC(X, Y, 5)
            CALL PUTPIC(X, Y - 1, 5)
            CALL PUTPIC(X, Y + 1, 5)
            CALL PUTPIC(X - 1, Y, 5)
        END SELECT
    END SELECT
END SUB

SUB DrawRealBoard
FOR ROW = 1 TO REALROWS
  FOR COL = 1 TO REALCOLS
    RC = COL + XDIF: RR = ROW + YDIF
    SELECT CASE REALBOARD(RC - XDIF, RR - YDIF)
      CASE 0: CALL PSETPIC(RC, RR, 0)
      CASE 1: CALL PSETPIC(RC, RR, 1)
      CASE 2: CALL PSETPIC(RC, RR, 2)
      CASE 3: CALL PSETPIC(RC, RR, 3)
      CASE 4: CALL PSETPIC(RC, RR, 4)
      CASE 5: CALL PSETPIC(RC, RR, 5)
      CASE 6: CALL PSETPIC(RC, RR, 6)
      CASE 7: CALL PSETPIC(RC, RR, 7)
    END SELECT
  NEXT COL
NEXT ROW
END SUB

SUB ERASEPIECE (X, Y, piecenum, ROT)
    SELECT CASE piecenum
      CASE 1
        IF ROT = 1 THEN
          CALL XORPIC(X, Y, 1)
          CALL XORPIC(X, Y - 1, 1)
          CALL XORPIC(X, Y + 1, 1)
          CALL XORPIC(X, Y + 2, 1)
        ELSE
          CALL XORPIC(X, Y, 1)
          CALL XORPIC(X - 1, Y, 1)
          CALL XORPIC(X + 1, Y, 1)
          CALL XORPIC(X + 2, Y, 1)
        END IF
      CASE 2
        CALL XORPIC(X, Y, 2)
        CALL XORPIC(X + 1, Y, 2)
        CALL XORPIC(X, Y + 1, 2)
        CALL XORPIC(X + 1, Y + 1, 2)
      CASE 3
        IF ROT = 1 THEN
          CALL XORPIC(X, Y, 3)
          CALL XORPIC(X - 1, Y, 3)
          CALL XORPIC(X, Y + 1, 3)
          CALL XORPIC(X + 1, Y + 1, 3)
        ELSE
          CALL XORPIC(X, Y, 3)
          CALL XORPIC(X, Y - 1, 3)
          CALL XORPIC(X - 1, Y, 3)
          CALL XORPIC(X - 1, Y + 1, 3)
        END IF
      CASE 4
        IF ROT = 1 THEN
          CALL XORPIC(X, Y, 4)
          CALL XORPIC(X + 1, Y, 4)
          CALL XORPIC(X - 1, Y + 1, 4)
          CALL XORPIC(X, Y + 1, 4)
        ELSE
          CALL XORPIC(X, Y, 4)
          CALL XORPIC(X - 1, Y, 4)
          CALL XORPIC(X - 1, Y - 1, 4)
          CALL XORPIC(X, Y + 1, 4)
        END IF
      CASE 5
        SELECT CASE ROT
          CASE 1
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X, Y - 1, 5)
            CALL XORPIC(X, Y + 1, 5)
            CALL XORPIC(X + 1, Y - 1, 5)
          CASE 2
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X - 1, Y, 5)
            CALL XORPIC(X - 1, Y - 1, 5)
            CALL XORPIC(X + 1, Y, 5)
          CASE 3
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X, Y + 1, 5)
            CALL XORPIC(X, Y - 1, 5)
            CALL XORPIC(X - 1, Y + 1, 5)
          CASE 4
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X - 1, Y, 5)
            CALL XORPIC(X + 1, Y, 5)
            CALL XORPIC(X + 1, Y + 1, 5)
        END SELECT
      CASE 6
        SELECT CASE ROT
          CASE 1
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X, Y - 1, 5)
            CALL XORPIC(X, Y + 1, 5)
            CALL XORPIC(X - 1, Y - 1, 5)
          CASE 2
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X + 1, Y, 5)
            CALL XORPIC(X - 1, Y, 5)
            CALL XORPIC(X - 1, Y + 1, 5)
          CASE 3
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X, Y - 1, 5)
            CALL XORPIC(X, Y + 1, 5)
            CALL XORPIC(X + 1, Y + 1, 5)
          CASE 4
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X - 1, Y, 5)
            CALL XORPIC(X + 1, Y, 5)
            CALL XORPIC(X + 1, Y - 1, 5)
        END SELECT
      CASE 7
        SELECT CASE ROT
          CASE 1
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X, Y - 1, 5)
            CALL XORPIC(X + 1, Y, 5)
            CALL XORPIC(X - 1, Y, 5)
          CASE 2
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X, Y - 1, 5)
            CALL XORPIC(X, Y + 1, 5)
            CALL XORPIC(X + 1, Y, 5)
          CASE 3
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X - 1, Y, 5)
            CALL XORPIC(X + 1, Y, 5)
            CALL XORPIC(X, Y + 1, 5)
          CASE 4
            CALL XORPIC(X, Y, 5)
            CALL XORPIC(X, Y - 1, 5)
            CALL XORPIC(X, Y + 1, 5)
            CALL XORPIC(X - 1, Y, 5)
        END SELECT
    END SELECT
END SUB

SUB GetPicture (X, Y, PICNUM)

SELECT CASE PICNUM

CASE 1
OPEN "I", #1, DRIVE + DIRECTORY + "\BLUEbloc.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), BLUE%
CLOSE

CASE 2
OPEN "I", #1, DRIVE + DIRECTORY + "\REDbloc.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), RED%
CLOSE

CASE 3
OPEN "I", #1, DRIVE + DIRECTORY + "\CYANBLOC.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), CYAN%
CLOSE

CASE 4
OPEN "I", #1, DRIVE + DIRECTORY + "\PURPLEBL.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), PURPLE%
CLOSE

CASE 5
OPEN "I", #1, DRIVE + DIRECTORY + "\GREENblo.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), GREEN%
CLOSE

CASE 6
OPEN "I", #1, DRIVE + DIRECTORY + "\BG_BRICK.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), BRICK%
CLOSE

CASE 7
OPEN "I", #1, DRIVE + DIRECTORY + "\BG_STEEL.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), STEEL%
CLOSE

CASE 8
OPEN "I", #1, DRIVE + DIRECTORY + "DELDES.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), DELUSION1%
CLOSE
CASE 9
OPEN "I", #1, DRIVE + DIRECTORY + "DELDES2.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), DELUSION2%
CLOSE
CASE 10
OPEN "I", #1, DRIVE + DIRECTORY + "DELDES3.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), DELUSION3%
CLOSE
CASE 11
OPEN "I", #1, DRIVE + DIRECTORY + "DELDES4.SGA"
INPUT #1, HSIZE, VSIZE
CALL DrawPicture(X, Y)
GET (X, Y)-(X + HSIZE, Y + VSIZE), DELUSION4%
CLOSE
END SELECT
END SUB

SUB InitBoard (BOARD)
FOR ROW = 2 TO NUMROWS - 2
  BOARD(9, ROW) = 7
  BOARD(NUMCOLS - 7, ROW) = 7
NEXT ROW
FOR COL = 9 TO NUMCOLS - 7
  BOARD(COL, NUMROWS - 2) = 7
NEXT COL
FOR COL = 2 TO 7
  FOR ROW = 2 TO 7
    BOARD(COL, ROW) = 7
  NEXT ROW
NEXT COL
FOR COL = 2 TO 7
  FOR ROW = 12 TO 17
    BOARD(COL, ROW) = 7
  NEXT ROW
NEXT COL
END SUB

SUB InitRealBoard : SHARED REALBOARD, BOARD
FOR RR = 1 TO REALROWS
  FOR RC = 1 TO REALCOLS
    REALBOARD(RC, RR) = BOARD(RC + XDIF, RR + YDIF)
  NEXT RC
NEXT RR
END SUB

SUB Intro
COLOR 15
PRINT "                            Q-BASIC BLOCKMASTER"
COLOR 3
PRINT
PRINT "Here it is, Q-BASIC BLOCKMASTER by Mike Merchant! "
PRINT "If you like this program, REGISTER IT!"
PRINT
PRINT "For those who do register there is a great big bag of goodies:"
COLOR 14
PRINT "         1.  The Hawiian Style version of Q-BASIC BLOCKMASTER"
PRINT
PRINT "         2.  Gorgeous delusion design wallpapers for Windows"
PRINT "             (like the one in the background of this program)"
PRINT
PRINT "         3.  Customize your own blocks and backgrounds with the"
PRINT "             Graphic Artist, a SGA(stacked graphic array) graphic"
PRINT "             designer used to make the blocks and backgrounds of"
PRINT "             Q-BASIC BLOCKMASTER."
PRINT
PRINT "         4.  Updates on new programs by Mike Merchant (like The"
PRINT "             Invisible Man and Starbase Exaliber)"
PRINT
COLOR 3
PRINT "There is no form to fill out. "
PRINT "Simply send your name, CompuServe address, and $5.00 to:"
COLOR 15
PRINT ""
PRINT "                         Mike Merchant"
PRINT "                         BLOCKMASTER"
PRINT "                         2333 Glenstone Ave."
PRINT "                         Hacienda Heights, CA  91745"
PRINT
COLOR 3
PRINT "                         Press any key to continue...."
dummy$ = INPUT$(1)
CLS
COLOR 15
PRINT "                            Q-BASIC BLOCKMASTER"
COLOR 3
PRINT
PRINT "    To play BLOCKMASTER use the keyboard number pad.  NUMLOCK MUST BE ON!"
PRINT
PRINT "To flip a piece use the 5 key.  The speed will slowly increase as you complete "
PRINT
PRINT "more lines.  To end the game prematurely press Q.  Have fun!"
COLOR 3
PRINT : PRINT : PRINT : PRINT : PRINT
PRINT "                         Press any key to continue...."
dummy$ = INPUT$(1)
CLS
END SUB

FUNCTION KeyPressed (D$)
SELECT CASE D$
CASE "2", "4", "6", "5", "Q"
  KeyPressed = 1
CASE ELSE
  KeyPressed = 0: D$ = ""
END SELECT
END FUNCTION

FUNCTION OverLapped (X, Y, piecenum, ROT) : SHARED BOARD
    SELECT CASE piecenum
      CASE 1
        IF ROT = 1 THEN
          IF BOARD(X, Y) = 1 OR BOARD(X, Y - 1) = 1 OR BOARD(X, Y + 1) = 1 OR BOARD(X, Y + 2) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
        ELSE
          IF BOARD(X, Y) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X + 2, Y) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
        END IF
      CASE 2
        IF BOARD(X, Y) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X, Y + 1) >= 1 OR BOARD(X + 1, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
      CASE 3
        IF ROT = 1 THEN
          IF BOARD(X, Y) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X, Y + 1) >= 1 OR BOARD(X + 1, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
        ELSE
          IF BOARD(X, Y) >= 1 OR BOARD(X, Y - 1) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
        END IF
      CASE 4
        IF ROT = 1 THEN
          IF BOARD(X, Y) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 OR BOARD(X, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
        ELSE
          IF BOARD(X, Y) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y - 1) >= 1 OR BOARD(X, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
        END IF
      CASE 5
        SELECT CASE ROT
          CASE 1
            IF BOARD(X, Y) >= 1 OR BOARD(X, Y - 1) >= 1 OR BOARD(X, Y + 1) >= 1 OR BOARD(X + 1, Y - 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
          CASE 2
            IF BOARD(X, Y) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y - 1) >= 1 OR BOARD(X + 1, Y) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
          CASE 3
            IF BOARD(X, Y) >= 1 OR BOARD(X, Y + 1) >= 1 OR BOARD(X, Y - 1) >= 1 OR BOARD(X - 1, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
          CASE 4
            IF BOARD(X, Y) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X + 1, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
        END SELECT
      CASE 6
        SELECT CASE ROT
          CASE 1
            IF BOARD(X, Y) >= 1 OR BOARD(X, Y - 1) >= 1 OR BOARD(X, Y + 1) >= 1 OR BOARD(X - 1, Y - 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
          CASE 2
            IF BOARD(X, Y) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X - 1, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
          CASE 3
            IF BOARD(X, Y) >= 1 OR BOARD(X, Y - 1) >= 1 OR BOARD(X, Y + 1) >= 1 OR BOARD(X + 1, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
          CASE 4
            IF BOARD(X, Y) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X + 1, Y - 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
        END SELECT
      CASE 7
        SELECT CASE ROT
          CASE 1
            IF BOARD(X, Y) >= 1 OR BOARD(X, Y - 1) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X - 1, Y) >= 1 THEN OverLapped = 1:   ELSE OverLapped = 0
          CASE 2
            IF BOARD(X, Y) >= 1 OR BOARD(X, Y - 1) >= 1 OR BOARD(X, Y + 1) >= 1 OR BOARD(X + 1, Y) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
          CASE 3
            IF BOARD(X, Y) >= 1 OR BOARD(X - 1, Y) >= 1 OR BOARD(X + 1, Y) >= 1 OR BOARD(X, Y + 1) >= 1 THEN OverLapped = 1:  ELSE OverLapped = 0
          CASE 4
            IF BOARD(X, Y) >= 1 OR BOARD(X, Y - 1) >= 1 OR BOARD(X, Y + 1) >= 1 OR BOARD(X - 1, Y) >= 1 THEN OverLapped = 1:   ELSE OverLapped = 0
        END SELECT
    END SELECT
END FUNCTION

SUB PSETPIC (COL, ROW, PICNUM) : SHARED PICLIST
X = TOPLEFTX(COL)
Y = TOPLEFTY(ROW)
IF AlreadyThere(PUTLIST, PICNUM) = 1 THEN
SELECT CASE PICNUM
  CASE 0: LINE (X, Y)-(X + 20, Y + 20), 0, BF
  CASE 1: PUT (X, Y), BLUE%, PSET
  CASE 2: PUT (X, Y), RED%, PSET
  CASE 3: PUT (X, Y), CYAN%, PSET
  CASE 4: PUT (X, Y), PURPLE%, PSET
  CASE 5: PUT (X, Y), GREEN%, PSET
  CASE 6: PUT (X, Y), BRICK%, PSET
  CASE 7: PUT (X, Y), STEEL%, PSET
  CASE 8: PUT (X, Y), DELUSION1%, PSET
  CASE 9: PUT (X, Y), DELUSION2%, PSET
  CASE 10: PUT (X, Y), DELUSION3%, PSET
  CASE 11: PUT (X, Y), DELUSION4%, PSET
END SELECT
ELSE
  CALL GetPicture(X, Y, PICNUM)
  PUTLIST(PICNUM) = 1
END IF
END SUB

SUB PUTPIC (COL, ROW, PICNUM) : SHARED PICLIST
X = TOPLEFTX(COL)
Y = TOPLEFTY(ROW)
IF AlreadyThere(PUTLIST, PICNUM) = 1 THEN
SELECT CASE PICNUM
  CASE 1: PUT (X, Y), BLUE%
  CASE 2: PUT (X, Y), RED%
  CASE 3: PUT (X, Y), CYAN%
  CASE 4: PUT (X, Y), PURPLE%
  CASE 5: PUT (X, Y), GREEN%
  CASE 6: PUT (X, Y), BRICK%
  CASE 7: PUT (X, Y), STEEL%
  CASE 8: PUT (X, Y), DELUSION1%
  CASE 9: PUT (X, Y), DELUSION2%
  CASE 10: PUT (X, Y), DELUSION3%
  CASE 11: PUT (X, Y), DELUSION4%
END SELECT
ELSE
  CALL GetPicture(X, Y, PICNUM)
  PUTLIST(PICNUM) = 1
END IF
END SUB

FUNCTION Settled (X, Y, piecenum, ROT) : SHARED BOARD, MOVETIME
IF OverLapped(X, Y + 1, piecenum, ROT) = 1 THEN
  Settled = 1
ELSE
  Settled = 0
END IF
END FUNCTION

FUNCTION TOPLEFTX (COL)
  TOPLEFTX = COL * 21
END FUNCTION

FUNCTION TOPLEFTY (ROW)
TOPLEFTY = (ROW - 1) * 21
END FUNCTION

SUB XORPIC (COL, ROW, PICNUM)
  X = TOPLEFTX(COL)
  Y = TOPLEFTY(ROW)
  SELECT CASE PICNUM
    CASE 1: PUT (X, Y), BLUE%, XOR
    CASE 2: PUT (X, Y), RED%, XOR
    CASE 3: PUT (X, Y), CYAN%, XOR
    CASE 4: PUT (X, Y), PURPLE%, XOR
    CASE 5: PUT (X, Y), GREEN%, XOR
  END SELECT
END SUB

