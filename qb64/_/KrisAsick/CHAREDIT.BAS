DECLARE SUB putcolour (X&, y&, forecolor&, backcolor&, page&)
DECLARE SUB putcharonly (X&, y&, Char&, page&)
DECLARE SUB RenderGlyph (renderchar AS LONG, cursorx AS LONG, cursory AS LONG)
DECLARE SUB EditCharTable (firstchar AS LONG, numchars AS LONG, fontstring AS STRING)
DECLARE FUNCTION GetCharTable$ ()
DECLARE SUB putchar (X&, y&, Char&, forecolor&, backcolor&, page&)
'$INCLUDE: 'QB.BI'
DEFLNG A-Z
RANDOMIZE TIMER
DIM SHARED activefont$
DIM SHARED defaultfont$
DIM SHARED loadfont$
SCREEN 0, , 1, 0: WIDTH 80, 25: COLOR 15, 0

hexvals$ = "0123456789ABCDEF"
activefont$ = GetCharTable
defaultfont$ = activefont$
copyglyph$ = STRING$(16, 0)
filename$ = "unnamed.chr"
ac = ASC("&")
ecx = 0: ecy = 0
cmode = 0
modified = 0

1 CLS
LOCATE 1, 1: COLOR 14, 1: PRINT " ASCII Character Editor v1.02                      Copyright (C)2018 Kris Asick ";
LOCATE 25, 1: COLOR 14, 1: PRINT " F2:New Set  F3:Save  F4:Load  F5:Clear        Z:Plot  X:Erase  C:Copy  V:Paste ";
LOCATE 4, 1: COLOR 9, 0: PRINT "          Character H__  (@)                         0123456789ABCDEF           ";
LOCATE 5, 1: COLOR 9, 0: PRINT "          +----------------+                        +----------------+          ";
LOCATE 6, 1: COLOR 9, 0: PRINT "          |                |                     00 |                |          ";
LOCATE 7, 1: COLOR 9, 0: PRINT "          |                |                     10 |                |          ";
LOCATE 8, 1: COLOR 9, 0: PRINT "          |                |                     20 |                |          ";
LOCATE 9, 1: COLOR 9, 0: PRINT "          |                |                     30 |                |          ";
LOCATE 10, 1: COLOR 9, 0: PRINT "          |                |                     40 |                |          ";
LOCATE 11, 1: COLOR 9, 0: PRINT "          |                |                     50 |                |          ";
LOCATE 12, 1: COLOR 9, 0: PRINT "          |                |                     60 |                |          ";
LOCATE 13, 1: COLOR 9, 0: PRINT "          |                |                     70 |                |          ";
LOCATE 14, 1: COLOR 9, 0: PRINT "          |                |                     80 |                |          ";
LOCATE 15, 1: COLOR 9, 0: PRINT "          |                |                     90 |                |          ";
LOCATE 16, 1: COLOR 9, 0: PRINT "          |                |                     A0 |                |          ";
LOCATE 17, 1: COLOR 9, 0: PRINT "          |                |                     B0 |                |          ";
LOCATE 18, 1: COLOR 9, 0: PRINT "          |                |                     C0 |                |          ";
LOCATE 19, 1: COLOR 9, 0: PRINT "          |                |                     D0 |                |          ";
LOCATE 20, 1: COLOR 9, 0: PRINT "          |                |                     E0 |                |          ";
LOCATE 21, 1: COLOR 9, 0: PRINT "          |                |                     F0 |                |          ";
LOCATE 22, 1: COLOR 9, 0: PRINT "          +----------------+                        +----------------+          ";
FOR y = 0 TO 15
	FOR X = 0 TO 15
		putchar 53 + X, 5 + y, y * 16 + X, 7, 0, 1
	NEXT X
NEXT y
2 LOCATE 4, 11: COLOR 15, 0
IF ac >= 16 THEN
	PRINT "Character H"; HEX$(ac); "  ( )";
ELSE
	PRINT "Character H0"; HEX$(ac); "  ( )";
END IF
putchar 26, 3, ac, 15, 0, 1
LOCATE 22, 11: COLOR 9, 0: PRINT "+----------------+"
IF cmode = 1 THEN
	LOCATE 22, 13: COLOR 10, 0: PRINT "PLOT";
ELSEIF cmode = 2 THEN
	LOCATE 22, 22: COLOR 12, 0: PRINT "ERASE";
END IF
FOR Z = 0 TO 15
	putchar 50, 5 + Z, ASC("0"), 7, 0, 1
	putchar 49, 5 + Z, ASC(MID$(hexvals$, Z + 1, 1)), 7, 0, 1
	putchar 53 + Z, 3, ASC(MID$(hexvals$, Z + 1, 1)), 7, 0, 1
NEXT Z
3 RenderGlyph ac, ecx, ecy
putcolour ac MOD 16 + 53, ac \ 16 + 5, 15, 1, 1
putcolour ac MOD 16 + 53, 3, 15, 1, 1
putcolour 49, ac \ 16 + 5, 15, 1, 1
putcolour 50, ac \ 16 + 5, 15, 1, 1
PCOPY 1, 0
4 DO: a$ = INKEY$: LOOP WHILE a$ = ""
IF a$ = " " THEN
	cmode = 0
	Z = ASC(MID$(activefont$, ac * 16 + ecy + 1, 1))
	zz = 2 ^ (7 - ecx)
	zzz = Z XOR zz
	MID$(activefont$, ac * 16 + ecy + 1, 1) = CHR$(zzz)
	EditCharTable ac, 1, activefont$
	modified = 1
	GOTO 2
END IF
IF MID$(a$, 2, 1) = "H" THEN
	ecy = ecy - 1
	IF ecy < 0 THEN ecy = ecy + 16
	IF cmode = 1 THEN
		GOSUB PlotPoint
		GOTO 2
	ELSEIF cmode = 2 THEN
		GOSUB ErasePoint
		GOTO 2
	END IF
	GOTO 3
END IF
IF MID$(a$, 2, 1) = "P" THEN
	ecy = ecy + 1
	IF ecy >= 16 THEN ecy = ecy - 16
	IF cmode = 1 THEN
		GOSUB PlotPoint
		GOTO 2
	ELSEIF cmode = 2 THEN
		GOSUB ErasePoint
		GOTO 2
	END IF
	GOTO 3
END IF
IF MID$(a$, 2, 1) = "K" THEN
	ecx = ecx - 1
	IF ecx < 0 THEN ecx = ecx + 8
	IF cmode = 1 THEN
		GOSUB PlotPoint
		GOTO 2
	ELSEIF cmode = 2 THEN
		GOSUB ErasePoint
		GOTO 2
	END IF
	GOTO 3
END IF
IF MID$(a$, 2, 1) = "M" THEN
	ecx = ecx + 1
	IF ecx >= 8 THEN ecx = ecx - 8
	IF cmode = 1 THEN
		GOSUB PlotPoint
		GOTO 2
	ELSEIF cmode = 2 THEN
		GOSUB ErasePoint
		GOTO 2
	END IF
	GOTO 3
END IF
IF a$ = "8" THEN
	cmode = 0
	putcolour ac MOD 16 + 53, ac \ 16 + 5, 7, 0, 1
	ac = ac - 16
	IF ac < 0 THEN ac = ac + 256
	GOTO 2
END IF
IF a$ = "2" THEN
	cmode = 0
	putcolour ac MOD 16 + 53, ac \ 16 + 5, 7, 0, 1
	ac = ac + 16
	IF ac >= 256 THEN ac = ac - 256
	GOTO 2
END IF
IF a$ = "4" THEN
	cmode = 0
	putcolour ac MOD 16 + 53, ac \ 16 + 5, 7, 0, 1
	ac = ac - 1
	IF ac < 0 THEN ac = ac + 256
	GOTO 2
END IF
IF a$ = "6" THEN
	cmode = 0
	putcolour ac MOD 16 + 53, ac \ 16 + 5, 7, 0, 1
	ac = ac + 1
	IF ac >= 256 THEN ac = ac - 256
	GOTO 2
END IF
IF MID$(a$, 2, 1) = "<" THEN
	cmode = 0
	IF modified THEN
		LOCATE 23, 1: COLOR 12, 0: PRINT "                    Current font modified! Create new? (y/N)";
		PCOPY 1, 0
		DO: a$ = INKEY$: LOOP WHILE a$ = ""
		LOCATE 23, 1: PRINT "                                                            ";
		IF UCASE$(a$) <> "Y" THEN GOTO 2
		modified = 0
	END IF
	activefont$ = defaultfont$
	EditCharTable 0, 256, activefont$
	GOTO 2
END IF
IF MID$(a$, 2, 1) = "=" THEN
	cmode = 0
	done = 0
	LOCATE 23, 11, 1: COLOR 10, 0: PRINT "SAVE FILE > "; filename$;
	DO
		PCOPY 1, 0
		DO: a$ = INKEY$: LOOP WHILE a$ = ""
		SELECT CASE a$
			CASE CHR$(27)
				done = 2
			CASE CHR$(13)
				done = 1
			CASE CHR$(8)
				IF LEN(filename$) > 0 THEN
					filename$ = LEFT$(filename$, LEN(filename$) - 1)
					LOCATE , POS(0) - 1, 1: PRINT " "; : LOCATE , POS(0) - 1, 1
				END IF
			CASE ELSE
				IF ASC(LEFT$(a$, 1)) >= 32 THEN
					filename$ = filename$ + LEFT$(a$, 1)
					PRINT LEFT$(a$, 1);
				END IF
		END SELECT
	LOOP WHILE done = 0
	LOCATE 23, 11, 0: COLOR 10, 0: PRINT "                                              ";
	IF done = 1 THEN
		ON ERROR GOTO saveerror
		OPEN filename$ FOR BINARY AS #1
			PUT #1, , activefont$
		CLOSE #1
		ON ERROR GOTO 0
		modified = 0
	END IF
	GOTO 2
END IF
IF MID$(a$, 2, 1) = ">" THEN
	cmode = 0
	IF modified THEN
		LOCATE 23, 1: COLOR 12, 0: PRINT "                  Current font modified! Load existing?  (y/N)";
		PCOPY 1, 0
		DO: a$ = INKEY$: LOOP WHILE a$ = ""
		LOCATE 23, 1: PRINT "                                                              ";
		IF UCASE$(a$) <> "Y" THEN GOTO 2
	END IF
	done = 0
	LOCATE 23, 11, 1: COLOR 10, 0: PRINT "LOAD FILE > "; filename$;
	DO
		PCOPY 1, 0
		DO: a$ = INKEY$: LOOP WHILE a$ = ""
		SELECT CASE a$
			CASE CHR$(27)
				done = 2
			CASE CHR$(13)
				done = 1
			CASE CHR$(8)
				IF LEN(filename$) > 0 THEN
					filename$ = LEFT$(filename$, LEN(filename$) - 1)
					LOCATE , POS(0) - 1, 1: PRINT " "; : LOCATE , POS(0) - 1, 1
				END IF
			CASE ELSE
				IF ASC(LEFT$(a$, 1)) >= 32 THEN
					filename$ = filename$ + LEFT$(a$, 1)
					PRINT LEFT$(a$, 1);
				END IF
		END SELECT
	LOOP WHILE done = 0
	LOCATE 23, 11, 0: COLOR 10, 0: PRINT "                                              ";
	IF done = 1 THEN
		ON ERROR GOTO loaderror
		OPEN filename$ FOR INPUT AS #1
		CLOSE #1
		OPEN filename$ FOR BINARY AS #1
			loadfont$ = STRING$(4096, " ")
			GET #1, , loadfont$
		CLOSE #1
		ON ERROR GOTO 0
		modified = 0
		activefont$ = loadfont$
		EditCharTable 0, 256, activefont$
	END IF
	GOTO 2
END IF
IF MID$(a$, 2, 1) = "?" THEN
	cmode = 0
	FOR Z = 0 TO 15
		MID$(activefont$, ac * 16 + Z + 1, 1) = CHR$(0)
	NEXT Z
	EditCharTable ac, 1, activefont$
	modified = 1
	GOTO 2
END IF
IF UCASE$(a$) = "Z" THEN
	IF cmode <> 1 THEN
		cmode = 1
		GOSUB PlotPoint
	ELSE
		cmode = 0
	END IF
	GOTO 2
END IF
IF UCASE$(a$) = "X" THEN
	IF cmode <> 2 THEN
		cmode = 2
		GOSUB ErasePoint
	ELSE
		cmode = 0
	END IF
	GOTO 2
END IF
IF UCASE$(a$) = "C" THEN
	copyglyph$ = MID$(activefont$, ac * 16 + 1, 16)
	SCREEN , , 0, 0
	LOCATE 23, 34: COLOR 14, 0: PRINT "Glyph Copied";
	SCREEN , , 1, 0
	GOTO 4
END IF
IF UCASE$(a$) = "V" THEN
	MID$(activefont$, ac * 16 + 1, 16) = copyglyph$
	EditCharTable ac, 1, activefont$
	GOTO 2
END IF
IF a$ <> CHR$(27) THEN GOTO 4
5 IF modified THEN
	LOCATE 23, 1: COLOR 12, 0: PRINT "                   Current font modified! Really quit?  (y/N)";
	PCOPY 1, 0
	DO: a$ = INKEY$: LOOP WHILE a$ = ""
	LOCATE 23, 1: PRINT "                                                             ";
	IF UCASE$(a$) <> "Y" THEN GOTO 2
END IF
SCREEN , , 0, 0: WIDTH 40: WIDTH 80
END

PlotPoint:
Z = ASC(MID$(activefont$, ac * 16 + ecy + 1, 1))
zz = 2 ^ (7 - ecx)
zzz = Z OR zz
MID$(activefont$, ac * 16 + ecy + 1, 1) = CHR$(zzz)
EditCharTable ac, 1, activefont$
modified = 1
RETURN

ErasePoint:
Z = ASC(MID$(activefont$, ac * 16 + ecy + 1, 1))
zz = 255 - (2 ^ (7 - ecx))
zzz = Z AND zz
MID$(activefont$, ac * 16 + ecy + 1, 1) = CHR$(zzz)
EditCharTable ac, 1, activefont$
modified = 1
RETURN

errorrecover:
ON ERROR GOTO 0
GOTO 2

saveerror:
LOCATE 23, 11: COLOR 12, 0: PRINT "SAVE ERROR! (Error #"; LTRIM$(RTRIM$(STR$(ERR))); ") Press any key";
PCOPY 1, 0
DO: a$ = INKEY$: LOOP WHILE a$ = ""
LOCATE 23, 11, 0: COLOR 10, 0: PRINT "                                                       ";
RESUME errorrecover

loaderror:
LOCATE 23, 11: COLOR 12, 0: PRINT "LOAD ERROR! (Error #"; LTRIM$(RTRIM$(STR$(ERR))); ") Press any key";
PCOPY 1, 0
DO: a$ = INKEY$: LOOP WHILE a$ = ""
LOCATE 23, 11, 0: COLOR 10, 0: PRINT "                                                       ";
RESUME errorrecover

SUB EditCharTable (firstchar AS LONG, numchars AS LONG, fontstring AS STRING)
DIM regin AS RegType
DIM regout AS RegType
regin.ax = &H1100             ' High = H11, Low = Subservice (H00 Here)
regin.bx = &H1000             ' High = Bytes per Char, Low = Font Block
regin.cx = numchars           ' Number of characters to change
regin.dx = firstchar          ' First character to change
'regin.es = VARSEG(fontstring)
regin.bp = SADD(fontstring) + (firstchar * 16)  ' Memory address of font data
CALL INTERRUPT(&H10, regin, regout)
END SUB

FUNCTION GetCharTable$
DIM reginx AS RegTypeX
DIM regoutx AS RegTypeX
fontstring$ = ""
reginx.ax = &H1130
reginx.bx = &H600
CALL INTERRUPTX(&H10, reginx, regoutx)
DEF SEG = regoutx.es
FOR Z = 0 TO 4095
	fontstring$ = fontstring$ + CHR$(PEEK(regoutx.bp + Z))
NEXT Z
DEF SEG
GetCharTable$ = fontstring$
END FUNCTION

SUB putchar (X, y, Char, forecolor, backcolor, page)
DEF SEG = &HB800
POKE (y * 160) + (X * 2) + (page * 4096), Char
POKE ((y * 160) + (X * 2)) + (page * 4096) + 1, forecolor + (backcolor * 16)
DEF SEG
END SUB

SUB putcharonly (X, y, Char, page)
DEF SEG = &HB800
POKE (y * 160) + (X * 2) + (page * 4096), Char
DEF SEG
END SUB

SUB putcolour (X, y, forecolor, backcolor, page)
DEF SEG = &HB800
POKE ((y * 160) + (X * 2)) + (page * 4096) + 1, forecolor + (backcolor * 16)
DEF SEG
END SUB

SUB RenderGlyph (renderchar AS LONG, cursorx AS LONG, cursory AS LONG)
DIM bit(0 TO 7) AS LONG
FOR Z = 0 TO 15
	zz = ASC(MID$(activefont$, renderchar * 16 + Z + 1, 1))
	bit(0) = zz AND 128
	bit(1) = zz AND 64
	bit(2) = zz AND 32
	bit(3) = zz AND 16
	bit(4) = zz AND 8
	bit(5) = zz AND 4
	bit(6) = zz AND 2
	bit(7) = zz AND 1
	FOR zz = 0 TO 7
		IF bit(zz) <> 0 THEN
			putchar zz * 2 + 11, 5 + Z, 32, 15, 7, 1
			putchar zz * 2 + 12, 5 + Z, 32, 15, 7, 1
		ELSE
			putchar zz * 2 + 11, 5 + Z, 32, 15, 0, 1
			putchar zz * 2 + 12, 5 + Z, 32, 15, 0, 1
		END IF
	NEXT zz
NEXT Z
putcharonly cursorx * 2 + 11, cursory + 5, ASC(":"), 1
putcharonly cursorx * 2 + 12, cursory + 5, ASC(":"), 1
END SUB

