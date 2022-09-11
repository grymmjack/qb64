'  HANGMAN.BAS by Antonio & Alfonso De Pasquale
'  Copyright (C) 1993, 1994 DOS Resource Guide
'  Published in Issue #14, March 1994

DECLARE SUB BOX (R1!, C1!, R2!, C2!)
DECLARE SUB CENTER (M$)

MAIN:
	 CLS : CLEAR : BOX 1, 1, 5, 79: COLOR 9
	 LOCATE 2, 31: CENTER "**  PC Hangman  **"
	 LOCATE 3, 39: CENTER "By"
	 LOCATE 4, 26: CENTER "Antonio & Alfonso De Pasquale"
	 COLOR 7: GOSUB DRAWGALLOWS: BOX 9, 1, 20, 42
	 LOCATE 11, 4: PRINT "Please select one of the following:"
	 LOCATE 13, 7: PRINT "<P>lay with default words"
	 LOCATE 14, 7: PRINT "<L>oad words from text file"
	 LOCATE 15, 7: PRINT "<Q>uit game"
	 LOCATE 17, 4: PRINT "Your Choice: "

	 K$ = ""
	 DO WHILE K$ <> "P" AND K$ <> "L" AND K$ <> "Q"
	K$ = UCASE$(INKEY$)
	 LOOP

	 IF K$ = "Q" THEN CLS : END
	 IF K$ = "L" THEN GOSUB USEFILE
	 IF K$ = "P" THEN
	NUMWORDS = 40
	DIM WORD$(NUMWORDS)
	FOR X = 1 TO NUMWORDS: READ WORD$(X): NEXT X
	 END IF

	 T1 = VAL(LEFT$(TIME$, 2)): T2 = VAL(MID$(TIME$, 3, 2))
	 T3 = VAL(RIGHT$(TIME$, 2)): TT = T1 + T2 + T3
	 RANDOMIZE (TT + TT * 100)
	 DIM LETTER$(26): GOSUB PLAYGAME: GOTO MAIN: END

PLAYGAME:
	 FOR X = 6 TO 23: LOCATE X, 1: PRINT SPACE$(79): NEXT X
	 BOX 7, 1, 11, 42: GOSUB DRAWGALLOWS
	 X = INT(RND * NUMWORDS) + 1
	 SECRET$ = WORD$(X): WLN = LEN(SECRET$): HP1 = INT(21 - WLN / 2)
	 LOCATE 9, HP1
	
	 FOR X = 1 TO 26: LETTER$(X) = "": NEXT X
	 STRIKE = 0: SCORE = 0: CANCEL = 0: NUMLET = 1: UL = 12
	
	 FOR X = 1 TO WLN
	IF MID$(SECRET$, X, 1) <> " " THEN
		 PRINT "-";
	ELSE
		 PRINT "/";
	END IF
 
	IF MID$(SECRET$, X, 1) = " " THEN
		 SCORE = SCORE + 1
	END IF
	 NEXT X

	 GOSUB PRINTRULES: GOSUB GETLETTERS
	 IF CANCEL = 1 THEN RETURN
	 GOTO PLAYGAME

PRINTRULES:
	 BOX 12, 1, 16, 42
	 LOCATE 13, 3: PRINT "Type in letters that you believe are"
	 LOCATE 14, 3: PRINT "in the word. You may make as many as"
	 LOCATE 15, 3: PRINT "six wrong guesses. Press Esc to exit."
	 BOX 17, 1, 19, 42
	 BOX 20, 1, 23, 42
	 LOCATE 18, 3: PRINT "Letters:"
	 RETURN

GETLETTERS:
	 K$ = ""
	 DO WHILE K$ = ""
	K$ = INKEY$
	 LOOP
	
	 K$ = UCASE$(K$): K = ASC(K$)
	 IF K$ = CHR$(27) THEN CANCEL = 1: RETURN
	 IF K < 65 OR K > 90 THEN GOTO GETLETTERS
  
	 USED = 0
	 IF NUMLET = 1 THEN LETTER$(NUMLET) = K$
	 IF NUMLET > 1 THEN
	LETTER$(NUMLET) = K$
	FOR X = 1 TO NUMLET - 1
		 IF K$ = LETTER$(X) THEN USED = 1
	NEXT X
	 END IF
	 IF USED = 1 THEN GOTO GETLETTERS
	 NUMLET = NUMLET + 1
	 HP2 = HP1: FOUND = 0:
	 LOCATE 18, UL: PRINT K$: UL = UL + 1
  
	 FOR X = 1 TO WLN
	IF K$ = MID$(SECRET$, X, 1) THEN
		 LOCATE 9, HP2
		 PRINT K$
		 FOUND = 1
		 SCORE = SCORE + 1
	END IF
	HP2 = HP2 + 1
	 NEXT X
	
	 IF SCORE >= WLN THEN GOSUB WIN: RETURN
	 IF FOUND = 0 THEN
	SOUND 50, 4
	STRIKE = STRIKE + 1
	SELECT CASE STRIKE
		 CASE 1
		GOSUB DRAWHEAD
		 CASE 2
		GOSUB DRAWBODY
		 CASE 3
		GOSUB DRAWLEFTARM
		 CASE 4
		GOSUB DRAWRIGHTARM
		 CASE 5
		GOSUB DRAWLEFTLEG
		 CASE 6
		GOSUB DRAWRIGHTLEG
		GOSUB LOSE
		RETURN
	END SELECT
	 END IF
	 GOTO GETLETTERS

DRAWGALLOWS:
	 BOX 7, 46, 23, 79: CH$ = CHR$(177)
	 COLOR 6: LOCATE 8, 58
	 FOR X = 1 TO 16: PRINT CH$; : NEXT X
	 LOCATE 9, 58: PRINT CH$; CH$
	 FOR X = 9 TO 21: LOCATE X, 71: PRINT CH$; CH$; CH$: NEXT X
	 LOCATE 22, 50: FOR X = 1 TO 26: PRINT CH$; : NEXT X
	 COLOR 7: RETURN

DRAWHEAD:
	 COLOR 10
	 FOR X = 10 TO 12
	 LOCATE X, 56: FOR Y = 1 TO 6: PRINT CH$; : NEXT Y: NEXT X
	 COLOR 7: RETURN

DRAWBODY:
	 COLOR 10
	 FOR X = 13 TO 18: LOCATE X, 58: PRINT CH$; CH$: NEXT X
	 COLOR 7: RETURN

DRAWLEFTARM:
	 COLOR 10
	 LOCATE 14, 52: PRINT CH$; CH$; CH$; CH$; CH$; CH$
	 LOCATE 15, 52: PRINT CH$; CH$
	 COLOR 7: RETURN

DRAWRIGHTARM:
	 COLOR 10
	 LOCATE 14, 60: PRINT CH$; CH$; CH$; CH$; CH$; CH$
	 LOCATE 15, 64: PRINT CH$; CH$
	 COLOR 7: RETURN

DRAWLEFTLEG:
	 COLOR 10
	 LOCATE 18, 54: FOR X = 1 TO 5: PRINT CH$; : NEXT X
	 LOCATE 19, 54: PRINT CH$; CH$
	 LOCATE 20, 54: PRINT CH$; CH$
	 COLOR 7: RETURN

DRAWRIGHTLEG:
	 COLOR 10
	 LOCATE 18, 59: FOR X = 1 TO 5: PRINT CH$; : NEXT X
	 LOCATE 19, 62: PRINT CH$; CH$
	 LOCATE 20, 62: PRINT CH$; CH$
	 COLOR 7: RETURN

LOSE:
	 COLOR 4: LOCATE 21, 5: PRINT "Sorry! You didn't guess the word."
	 LOCATE 22, 5: PRINT "Press Enter to play again or exit."
	 LOCATE 9, HP1: PRINT SECRET$: COLOR 7
	 PLAY "P4 O1 C3 C3 C8 C3 E-4 D8 D4 C8 C4 O0 B8 O1 C2"
	 DO: LOOP UNTIL INKEY$ = CHR$(13): RETURN

WIN:
	 COLOR 2: LOCATE 21, 5: PRINT "Well Done! You guessed the word!"
	 LOCATE 22, 5: PRINT "Press Enter to play again or exit."
	 COLOR 14: LOCATE 9, HP1: PRINT SECRET$: COLOR 7
	 PLAY "P4 O2 F+8 E8 F+8 G4 O1 G4 B4 O2 D2"
	 DO: LOOP UNTIL INKEY$ = CHR$(13): RETURN

USEFILE:
	 FOR X = 9 TO 20: LOCATE X, 1: PRINT SPACE$(42): NEXT X
	 BOX 10, 1, 20, 42
	 LOCATE 12, 4: PRINT "Type in the name of the file that"
	 LOCATE 13, 4: PRINT "contains the words you wish to use"
	 LOCATE 15, 4: PRINT "["; SPACE$(34); "]"
	 LOCATE 15, 5: INPUT "", NAME$
	 IF NAME$ = "" THEN GOTO MAIN

	 ON ERROR GOTO NOFILE
	 OPEN NAME$ FOR INPUT AS #1
	 LOCATE 17, 5: PRINT "Now reading file. Please wait..."
  
	 DIM WORD$(750): PASS = 1
	 DO WHILE (NOT EOF(1)) AND (PASS < 750)
	LINE INPUT #1, LINE$
	TWORD$ = ""

	FOR X = 1 TO LEN(LINE$)
		 CHAR$ = UCASE$(MID$(LINE$, X, 1))
		 IF ASC(CHAR$) > 64 AND ASC(CHAR$) < 91 THEN
		TWORD$ = TWORD$ + CHAR$
		 ELSE
		IF LEN(TWORD$) > 4 THEN
			 WORD$(PASS) = UCASE$(TWORD$)
			 PASS = PASS + 1
		END IF
		TWORD$ = ""
		 END IF
	NEXT X

	 LOOP
	 CLOSE #1: NUMWORDS = PASS: RETURN

NOFILE:
	 SOUND 600, 4
	 LOCATE 17, 5: PRINT "The filename you supplied does"
	 LOCATE 18, 5: PRINT "not exist. Press Enter"
	 DO UNTIL INKEY$ = CHR$(13): LOOP: GOTO MAIN

DATASECTION:
	 DATA AUTOGRAPH, SCIENCE FICTION, SUBMARINE, MAGAZINE, FANTASY, ALIEN
	 DATA MONSTER, COMMANDER, CALENDAR, COMIC BOOK, SIGNATURE, PROGRAM
	 DATA FLOPPY DISK, MOUSE, JOYSTICK, COMPACT DISC, JAZZ, TELEVISION SET
	 DATA LOTTERY, SOCIAL SECURITY, BATMAN AND ROBIN, AUTUMN, DILEMMA
	 DATA SPLENDID, RECEPTIONIST, MORPHOLOGY, DISHONEST, TWILIGHT ZONE
	 DATA CLINT EASTWOOD, SEAN CONNERY, STAR TREK, I LOVE LUCY, POSTCARD
	 DATA GONE WITH THE WIND, WAR AND PEACE, DUKE ELLINGTON, BILL COSBY
	 DATA KIRK DOUGLAS, KIRK AND SPOCK, MILES DAVIS

				END

SUB BOX (R1, C1, R2, C2)
  
	 LOCATE R1, C1
	 PRINT CHR$(218);
	 FOR X = (C1 + 1) TO (C2 - 1)
	PRINT CHR$(196);
	 NEXT X
	 PRINT CHR$(191)

	 FOR X = (R1 + 1) TO (R2 - 1)
	LOCATE X, C1
	PRINT CHR$(179); SPACE$(C2 - C1 - 1); CHR$(179)
	 NEXT X

	 LOCATE R2, C1
	 PRINT CHR$(192);
	 FOR X = (C1 + 1) TO (C2 - 1)
	PRINT CHR$(196);
	 NEXT X
	 PRINT CHR$(217)

END SUB

SUB CENTER (M$)

	 LN = LEN(M$)
	 PRINT TAB(40 - LN / 2); M$

END SUB

