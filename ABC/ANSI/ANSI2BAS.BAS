$SCREENHIDE
$CONSOLE
_DEST _CONSOLE
'ANSI2BAS v3.1 was written by Aaron Lapikas of BCData Inc.  This program is
'designed to make the annoying job of creating graphical screens in screen
'mode 0 much easier.  This program is in public domain, and no fee is
'required to use it.  You can use it wherever you want, just maybe give me a
'little credit, like mentioning my name or something like that.  :)
 
'To use the program, either complile it into an EXE, or modify the COMMAND$.
'If the program is started with no parameters, then the help screen is
'displayed.  I hope that you find this program helpful, and please, give me
'any comments about this program and let me know of any bugs (if there are
'any <gasp>).
 
DECLARE SUB ANSIDriver (ANSICode$)
 
DIM SHARED PosOfSC%(4), Color$(5), CColor%(1), Col%(1), RowA%(1), Attribute$(1)
DIM SHARED Blink$(1)
 
DEFINT A-Z
 
 
ON ERROR GOTO HandleError
 
 
IF COMMAND$ = "" THEN
  COLOR 7, 0
  PRINT
  PRINT "ANSI2BAS v3.1 by BCData Inc.  Released on May 31, 1992"
  PRINT
  PRINT
  PRINT "Converts ANSI source code files to QuickBASIC version 4.5 ";
  PRINT "format.  Supports the"
 
  PRINT "use of ansy ANSI files, as well as ASCII files."
  PRINT
  PRINT
  PRINT "USAGE:  ANSI2BAS InputFile.Ext OutputFile.Ext[/A]"
  PRINT
  PRINT
  PRINT "NOTE :  Extensions, as well as the output filename are optional, ";
  PRINT "and are not"
  PRINT "        needed in order for the program to run correctly.  If ";
  PRINT "no extension is"
  PRINT "        given, ANSI2BAS uses the default extension .ANS forthe ";
  PRINT "ANSI source"
  PRINT "        file, and .BAS for the QuickBASIC output file.  If no ";
  PRINT "output filename"
  PRINT "        is given, then ANSI2BAS names the output file the same ";
  PRINT "as the ANSI"
  PRINT "        filename, but with a .BAS extension.  The /A parameter ";
  PRINT "allows the ANSI"
  PRINT "        file to be displayed while being converted.  Note the ";
  PRINT "examples below:"
  PRINT
  PRINT
  PRINT "ANSI2BAS FILE.BAS  ->  Converts the ANSI file FILE.ANS to FILE.BAS"
  PRINT "ANSI2BAS FILE/A    -> Converts and displays the ANSI file FILE.ANS ";
  PRINT "to FILE.BAS"
 
  END
END IF
 
 
Parameter$ = RIGHT$(COMMAND$, 2)
 
IF UCASE$(Parameter$) = "/A" THEN
  LET ANSIView$ = "ON"
  LET Command2$ = LEFT$(COMMAND$, LEN(COMMAND$) - 2)
ELSE
  LET Command2$ = COMMAND$
END IF
 
FOR y = 1 TO LEN(Command2$)
  IF MID$(Command2$, y, 1) = " " THEN EXIT FOR
NEXT y
 
 
FOR x = y TO 1 STEP -1
  IF MID$(Command2$, x, 1) = "\" THEN EXIT FOR
NEXT x
 
IF x < LEN(Command2$) = 1 AND x < y THEN
  LET FILE$ = UCASE$(MID$(Command2$, x + 1, LEN(Command2$) - y + 3))
ELSE
  LET FILE$ = LEFT$(Command2$, y - 1)
END IF
 
LET FullFile$ = UCASE$(LEFT$(Command2$, y - 1))
 
IF LEN(FILE$) > 4 THEN
  IF MID$(FILE$, LEN(FILE$) - 3, 1) <> "." THEN
    LET FILE$ = FILE$ + ".ANS"
    LET FullFile$ = FullFile$ + ".ANS"
  END IF
ELSE
  LET FILE$ = FILE$ + ".ANS"
  LET FullFile$ = FullFile$ + ".ANS"
END IF
 
IF y <> LEN(Command2$) + 1 THEN
  LET OUTPUT$ = MID$(Command2$, y + 1, LEN(Command2$) - y + 1)
 
  IF LEN(OUTPUT$) < 5 THEN
    LET OUTPUT$ = OUTPUT$ + ".BAS"
  ELSEIF MID$(OUTPUT$, LEN(OUTPUT$) - 3, 1) <> "." THEN
    LET OUTPUT$ = OUTPUT$ + ".BAS"
  END IF
 
ELSE
  LET OUTPUT$ = MID$(FILE$, 1, LEN(FILE$) - 4) + ".BAS"
END IF
 
CLS
COLOR 7, 0
 
PRINT "ANSI2BAS v3.1 - Released on May 31, 1992 by BCData Inc."
PRINT
PRINT
PRINT "ANSI Source File [.ANS]: "; UCASE$(FullFile$)
PRINT "QB45 Output File [.BAS]: "; UCASE$(OUTPUT$)
PRINT
PRINT
 
 
OPEN FullFile$ FOR INPUT AS 1
OPEN OUTPUT$ FOR OUTPUT AS 2
 
PRINT "Accessing ANSI code...Please wait."
 
 
IF ANSIView$ = "ON" THEN
  FOR x! = 1 TO 7000
  NEXT x!
 
  CLS
ELSE
  SCREEN , , 1, 0
END IF
 
PRINT #2, "' "; UCASE$(OUTPUT$) + " - Prepared by ANSI2BAS v3.1 by BCData Inc."
PRINT #2, "' Released on May 31, 1992 by BCData Inc."
PRINT #2, ""
PRINT #2, ""
COLOR 7, 0
LET CColor%(1) = 7
 
 
DO
 
 
  IF Flag = 1 THEN
    LET Flag = 0
    GOTO SecondChar
  END IF
 
  IF LOC(1) < 1 THEN
 
    a = 0
 
    DO
      a = a + 1
    LOOP UNTIL a = 100 OR LOC(1) > 0
 
    IF a = 100 THEN END
 
  END IF
 
  IF Flag <> 31 THEN
    a$ = INPUT$(1, #1)
  ELSE
    LET Flag = 0
    LET a$ = CHR$(27)
  END IF
 
  IF a$ = CHR$(27) THEN
 
 
SecondChar:
 
    a = 0
 
    DO
      a = a + 1
    LOOP UNTIL a = 100 OR LOC(1) > 0
 
    IF a = 100 THEN END
 
    B$ = INPUT$(1, #1)
    IF B$ = "[" THEN
 
       LET ANSICode$ = ""
 
       DO
 
         a = 0
 
         DO
            a = a + 1
         LOOP UNTIL a = 100 OR LOC(1) > 0
         IF a = 100 THEN END
 
         C$ = INPUT$(1, #1)
 
         ANSICode$ = ANSICode$ + C$
         IF ANSICode$ = "M" THEN
 
           DO
             IF LOC(1) > 1 THEN
               D$ = INPUT$(1, #1)
               LET ANSICode$ = ANSICode$ + D$
             END IF
           LOOP UNTIL D$ = CHR$(14)
 
         END IF
         SELECT CASE C$
            CASE "H", "A", "B", "C", "D", "f", "m", "s", "u", "k", "J", "M"
                 EXIT DO
         END SELECT
         ''IF C$ = "H" OR C$ = "A" OR C$ = "B" OR C$ = "C" OR C$ = "D" OR C$ = "f" OR C$ = "m" OR C$ = "s" OR C$ = "u" OR C$ = "k" OR C$ = "J" OR C$ = "M" THEN EXIT DO
 
       LOOP
 
 
       LET ANSICode$ = CHR$(27) + "[" + ANSICode$
       ANSIDriver ANSICode$
 
 
    ELSEIF B$ <> CHR$(13) THEN
 
      PRINT B$;
      PRINT #2, "PRINT " + CHR$(34) + B$ + CHR$(34) + ";"
      PRINT #2, ""
 
 
    ELSEIF B$ = CHR$(13) THEN
      LOCATE , 1
      PRINT #2, "LOCATE ,1"
    END IF
 
 
  ELSE
 
    LET PRINT$ = ""
 
    DO UNTIL EOF(1)
 
      IF a$ = CHR$(13) OR a$ = CHR$(10) OR a$ = CHR$(27) THEN EXIT DO
      LET PRINT$ = PRINT$ + a$
 
      a$ = INPUT$(1, #1)
 
    LOOP
 
    IF LEN(PRINT$) + POS(x) > 80 THEN
      LET Print1$ = ""
      LET Print2$ = ""
 
      LET a = 81 - POS(x)
      LET Print1$ = LEFT$(PRINT$, a)
      PRINT #2, "PRINT " + CHR$(34) + Print1$ + CHR$(34)
 
      PRINT Print1$
 
      LET Print2$ = RIGHT$(PRINT$, LEN(PRINT$) - a)
      PRINT #2, "PRINT " + CHR$(34) + Print2$ + CHR$(34) + ";"
      PRINT #2, ""
 
      PRINT Print2$;
    ELSE
      PRINT Print$;
      PRINT #2, "PRINT " + CHR$(34) + PRINT$ + CHR$(34) + ";"
      PRINT #2, ""
    END IF
 
    IF a$ = CHR$(13) THEN
      LOCATE , 1
      PRINT #2, "LOCATE ,1"
    ELSEIF a$ = CHR$(10) THEN
      PRINT
      PRINT #2, "PRINT"
    ELSEIF a$ = CHR$(27) THEN
      LET Flag = 31
    END IF
  END IF
LOOP UNTIL EOF(1)
 
IF ANSIView$ <> "ON" THEN
  SCREEN , , 0
  LOCATE 8, 1
  COLOR 7, 0
  PRINT "Conversion complete.  QuickBASIC source "; OUTPUT$;
  PRINT " has been created."
ELSE
  COLOR 7, 0
  PRINT
  PRINT "Conversion complete.  QuickBASIC source "; OUTPUT$;
  PRINT " has been created."
END IF
 
COLOR 7, 0
 
PRINT #2, ""
PRINT #2, "COLOR 7,0"
 
END
 
 
HandleError:
 
IF ERR = 76 THEN
  LOCATE 8, 1
  COLOR 7, 0
  BEEP
 
  PRINT "Path not found.  Exiting program."
  PRINT
  END
ELSEIF ERR = 53 THEN
  BEEP
  LOCATE 8, 1
  COLOR 7, 0
 
  PRINT "File not found or invalid parameters.  Exiting program."
  PRINT
  END
END IF
 
RESUME
 
'
SUB ANSIDriver (ANSICode$)
 
 
IF RIGHT$(ANSICode$, 1) = "m" THEN
    NumOfSC = 0
 
    FOR x = 1 TO LEN(ANSICode$)
      IF MID$(ANSICode$, x, 1) = ";" THEN
        LET NumOfSC = NumOfSC + 1
        LET PosOfSC(NumOfSC) = x
      END IF
    NEXT x
 
    IF NumOfSC = 0 THEN
      LET Color$(1) = MID$(ANSICode$, 3, LEN(ANSICode$) - 3)
      LET Color$(2) = ""
      LET Color$(3) = ""
      LET Color$(4) = ""
      LET SC = 1
    ELSEIF NumOfSC = 1 THEN
      LET Color$(1) = MID$(ANSICode$, 3, PosOfSC%(1) - 3)
      LET Color$(2) = MID$(ANSICode$, PosOfSC%(1) + 1, LEN(ANSICode$) - (PosOfSC%(1) + 1))
      LET Color$(3) = ""
      LET Color$(4) = ""
      LET SC = 2
    ELSEIF NumOfSC = 2 THEN
      LET Color$(1) = MID$(ANSICode$, 3, (PosOfSC%(1) - 3))
      LET Color$(2) = MID$(ANSICode$, PosOfSC%(1) + 1, PosOfSC%(2) - (PosOfSC%(1) + 1))
      LET Color$(3) = MID$(ANSICode$, PosOfSC(2) + 1, LEN(ANSICode$) - (PosOfSC%(2) + 1))
      LET Color$(4) = ""
      LET SC = 3
    ELSEIF NumOfSC = 3 THEN
      LET Color$(1) = MID$(ANSICode$, 3, PosOfSC%(1) - 3)
      LET Color$(2) = MID$(ANSICode$, PosOfSC%(1) + 1, PosOfSC(2) - (PosOfSC%(1) + 1))
      LET Color$(3) = MID$(ANSICode$, PosOfSC(2) + 1, PosOfSC(3) - (PosOfSC(2) + 1))
      LET Color$(4) = MID$(ANSICode$, PosOfSC(3) + 1, LEN(ANSICode$) - (PosOfSC(3) + 1))
      LET SC = 4
    ELSE
      GOTO ExitDriver
    END IF
 
 
    IF ANSICode$ = CHR$(27) + "[0m" THEN
      LET Attribute$(1) = "OFF"
      LET Blink$(1) = "OFF"
 
      COLOR 7, 0
      PRINT #2, "COLOR 7,0"
 
      LET CColor%(1) = 7
 
    ELSEIF ANSICode$ = CHR$(27) + "[1m" THEN
      LET Attribute$(1) = "ON"
 
      IF CColor%(1) < 8 THEN
        COLOR CColor%(1) + 8
        PRINT #2, "COLOR "; CColor%(1) + 8
 
        LET CColor%(1) = CColor%(1) + 8
      END IF
    END IF
 
    Span = SC \ 2
 
    DO WHILE (Span > 0)
      FOR I = Span TO SC - 1
        j = I - Span + 1
 
        FOR j = (I - Span + 1) TO 1 STEP -Span
          IF Color$(j) <= Color$(j + Span) THEN EXIT FOR
 
          SWAP Color$(j), Color$(j + Span)
 
        NEXT j
      NEXT I
      Span = Span \ 2
 
    LOOP
 
 
    FOR w = 1 TO SC
 
      IF Color$(w) = "0" THEN
        LET Attribute$(1) = "OFF"
        LET Blink$(1) = "OFF"
 
        COLOR , 0
        PRINT #2, "COLOR ,0"
          LET CColor%(1) = 0
        ELSE
          COLOR 8
          PRINT #2, "COLOR 8"
 
          LET CColor%(1) = 8
        END IF
        IF Color$(w) = "31" THEN
        IF Attribute$(1) = "OFF" THEN
          COLOR 4
          PRINT #2, "COLOR 4"
          LET CColor%(1) = 4
        ELSE
          COLOR 12
          PRINT #2, "COLOR 12"
 
          LET CColor%(1) = 12
        END IF
      ELSEIF Color$(w) = "32" THEN
        IF Attribute$(1) = "OFF" THEN
          COLOR 2
          PRINT #2, "COLOR 2"
 
          LET CColor%(1) = 2
        ELSE
          COLOR 10
          PRINT #2, "COLOR 10"
 
          LET CColor%(1) = 10
        END IF
      ELSEIF Color$(w) = "33" THEN
        IF Attribute$(1) = "OFF" THEN
          COLOR 6
          PRINT #2, "COLOR 6"
 
          LET CColor%(1) = 6
        ELSE
          COLOR 14
          PRINT #2, "COLOR 14"
 
          LET CColor%(1) = 14
        END IF
      ELSEIF Color$(w) = "34" THEN
        IF Attribute$(1) = "OFF" THEN
          COLOR 1
          PRINT #2, "COLOR 1"
 
          LET CColor%(1) = 1
        ELSE
          COLOR 9
          PRINT #2, "COLOR 9"
 
          LET CColor%(1) = 9
        END IF
      ELSEIF Color$(w) = "35" THEN
        IF Attribute$(1) = "OFF" THEN
          COLOR 5
          PRINT #2, "COLOR 5"
 
          LET CColor%(1) = 5
        ELSE
          COLOR 13
          PRINT #2, "COLOR 13"
 
          LET CColor%(1) = 13
        END IF
      ELSEIF Color$(w) = "36" THEN
        IF Attribute$(1) = "OFF" THEN
          COLOR 3
          PRINT #2, "COLOR 3"
 
          LET CColor%(1) = 3
        ELSE
          COLOR 11
          PRINT #2, "COLOR 11"
 
         LET CColor%(1) = 11
        END IF
      ELSEIF Color$(w) = "37" THEN
        IF Attribute$(1) = "OFF" THEN
          COLOR 7
          PRINT #2, "COLOR 7"
 
          LET CColor%(1) = 7
        ELSE
          COLOR 15
          PRINT #2, "COLOR 15"
 
          LET CColor%(1) = 15
        END IF
      ELSEIF Color$(w) = "40" THEN
        COLOR , 0
        PRINT #2, "COLOR ,0"
 
      ELSEIF Color$(w) = "41" THEN
        COLOR , 4
        PRINT #2, "COLOR ,4"
 
      ELSEIF Color$(w) = "42" THEN
        COLOR , 2
 
        PRINT #2, "COLOR ,2"
 
      ELSEIF Color$(w) = "43" THEN
        COLOR , 6
        PRINT #2, "COLOR ,6"
 
      ELSEIF Color$(w) = "44" THEN
        COLOR , 1
        PRINT #2, "COLOR ,1"
 
      ELSEIF Color$(w) = "45" THEN
        COLOR , 5
        PRINT #2, "COLOR ,5"
 
      ELSEIF Color$(w) = "46" THEN
        COLOR , 3
        PRINT #2, "COLOR ,3"
 
      ELSEIF Color$(w) = "47" THEN
        COLOR , 7
        PRINT #2, "COLOR ,7"
      END IF
    NEXT w
 
    IF Blink$(1) = "ON" THEN
      COLOR CColor%(1) + 16
      PRINT #2, "COLOR "; CColor%(1) + 16
    END IF
 
 
ELSEIF RIGHT$(ANSICode$, 1) = "J" THEN
  CLS 2
  LOCATE 1, 1
  PRINT #2, "CLS 2"
  PRINT #2, "LOCATE 1,1"
  PRINT #2, ""
ELSEIF RIGHT$(ANSICode$, 1) = "K" THEN
  Row = CSRLIN
  Column = POS(x)
 
  NumOfSpace = 81 - POS(x)
  PRINT SPACE$(NumOfSpace)
  PRINT #2, "SPACE$("; NumOfSpace; ")"
  LOCATE Row, Column
  PRINT #2, "LOCATE"; Row; ","; Column; ""
 
ELSEIF RIGHT$(ANSICode$, 1) = "H" OR RIGHT$(ANSICode$, 1) = "f" THEN
 
  IF ANSICode$ = CHR$(27) + "[H" THEN
    PRINT #2, "LOCATE 1,1"
    LOCATE 1, 1
 
    GOTO ExitDriver
  END IF
 
  FOR x = 1 TO LEN(ANSICode$)
    IF MID$(ANSICode$, x, 1) = ";" THEN EXIT FOR
  NEXT x
 
  IF x = LEN(ANSICode$) + 1 THEN
    LET HRow$ = MID$(ANSICode$, 3, LEN(ANSICode$) - 3)
 
    LET HRow = VAL(HRow$)
    LOCATE HRow, 1
 
    PRINT #2, "LOCATE "; HRow; ",1"
 
  ELSEIF x = 3 THEN
    LET HCol$ = MID$(ANSICode$, 4, LEN(ANSICode$) - 4)
 
    LET HCol = VAL(HCol$)
    LOCATE 1, HCol
 
    PRINT #2, "LOCATE 1,"; HCol
 
  ELSEIF x = LEN(ANSICode$) - 1 THEN
    HRow$ = MID$(ANSICode$, 3, LEN(ANSICode$) - 4)
 
    LET HRow = VAL(HRow$)
    LOCATE HRow, 1
 
    PRINT #2, "LOCATE "; HRow; ",1"
 
  ELSE
    HColumn$ = RIGHT$(ANSICode$, LEN(ANSICode$) - x)
    HColumn$ = LEFT$(HColumn$, LEN(HColumn$) - 1)
    HRow$ = LEFT$(ANSICode$, x - 1)
    HRow$ = RIGHT$(HRow$, LEN(HRow$) - 2)
 
    HRow = VAL(HRow$)
    HColumn = VAL(HColumn$)
 
    IF HRow > 25 THEN LET HRow = 25
 
    LOCATE HRow, HColumn
    PRINT #2, "LOCATE"; HRow; ","; HColumn
  END IF
 
ELSEIF RIGHT$(ANSICode$, 1) = "C" THEN
  IF LEN(ANSICode$) = 3 THEN
    PRINT #2, "LOCATE ,"; POS(x) + 1
    LOCATE , POS(x) + 1
  END IF
 
  Column$ = MID$(ANSICode$, 3, LEN(ANSICode$) - 3)
  LET Column = VAL(Column$)
 
  IF POS(x) + Column < 81 THEN
    PRINT #2, "LOCATE,"; POS(x) + Column
    LOCATE , POS(x) + Column
  END IF
 
ELSEIF RIGHT$(ANSICode$, 1) = "D" THEN
  IF LEN(ANSICode$) = 3 AND POS(x) <> 1 THEN
    PRINT #2, "LOCATE,"; POS(x) - 1
    LOCATE , POS(x) - 1
  ELSE
 
    Back$ = MID$(ANSICode$, 3, LEN(ANSICode$) - 3)
    Back = VAL(Back$)
 
    IF POS(x) > 1 AND Back < 80 THEN
      PRINT #2, "LOCATE,"; POS(x) - Back
      LOCATE , POS(x) - Back
    END IF
  END IF
 
ELSEIF RIGHT$(ANSICode$, 1) = "A" THEN
  IF LEN(ANSICode$) = 3 THEN
 
    PRINT #2, "LOCATE"; CSRLIN - 1; ","; POS(x)
    LOCATE CSRLIN - 1, POS(x)
  END IF
 
  Up$ = MID$(ANSICode$, 3, LEN(ANSICode$) - 3)
  Up = VAL(Up$)
 
  IF CSRLIN > 1 THEN
    PRINT #2, "LOCATE"; CSRLIN - Up; ","; POS(x)
    LOCATE CSRLIN - Up, POS(x)
  ELSE
    PRINT #2, "LOCATE 1,"; POS(x)
    LOCATE 1, POS(x)
  END IF
 
ELSEIF RIGHT$(ANSICode$, 1) = "B" THEN
  IF LEN(ANSICode$) = 3 THEN
    PRINT #2, "LOCATE"; CSRLIN + 1; ","; POS(x)
    LOCATE CSRLIN + 1, POS(x)
  END IF
 
  Down$ = MID$(ANSICode$, 3, LEN(ANSICode$) - 3)
  Down = VAL(Down$)
 
  IF CSRLIN >= 24 THEN
    PRINT #2, "LOCATE 24,"; POS(x)
    LOCATE 24, POS(x)
  ELSE
    PRINT #2, "LOCATE"; CSRLIN + Down; ","; POS(x)
    LOCATE CSRLIN + Down, POS(x)
  END IF
 
ELSEIF RIGHT$(ANSICode$, 1) = "s" THEN
  LET Col%(1) = POS(x)
  LET RowA%(1) = CSRLIN
 
ELSEIF RIGHT$(ANSICode$, 1) = "u" THEN
  LOCATE RowA%(1), Col%(1)
  PRINT #2, "LOCATE"; RowA%(1); ","; Col%(1)
 
ELSEIF RIGHT$(ANSICode$, 1) = CHR$(14) THEN
  LET ANSIMusic$ = MID$(ANSICode$, 3, (LEN(ANSICode$) - 3))
  PLAY ANSIMusic$
  LET ANSIMusic$ = ""
END IF
 
ExitDriver:
END SUB