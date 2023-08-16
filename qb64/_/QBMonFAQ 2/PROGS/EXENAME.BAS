'********************************************************************
' EXENAME.BAS - Example for determining the own name and path
' ===========   Zeigt wie ein Programm seinen eigenen Namen und Pfad
'               ermitteln kann   
'
' This program shows how to figure out the path from which your
' program has been run. This is useful when you need to open a data
' file, but your program may have been run by adding the path
' explicitly and thus you can't count on that being the current 
' directory. So even your program was run using C:\PATH\PROGRAM you
' can still determine what "PATH" is and also if your program was
' renamed. Note that when run in the BASIC editor, it is the editor
' whose name is reported!
'
' Attentention: This programm cannot be run with QBasic but unly with
' ~~~~~~~~~~~~  QuickBASIC 4.5 and 7.1. The reason ist the use of the
'               CALL INTERRUPT statement.
'
' (c) Ethan Winer
'********************************************************************
'
DEFINT A-Z
DECLARE FUNCTION ExeName$ ()
'$INCLUDE: 'QB.BI'   'use QBX.BI with BASIC 7, or VBDOS.BI with VB/DOS
		     'needed for CALL Interrupt used inside ExeName
MyName$ = ExeName$

'---- isolate the path and file names
'
CLS
FOR X = LEN(MyName$) TO 1 STEP -1
  Char = ASC(MID$(MyName$, X, 1))
  IF Char = 58 OR Char = 92 THEN  ' ":" or "\"
    Path$ = LEFT$(MyName$, X)
    File$ = MID$(MyName$, X + 1)
    EXIT FOR
  END IF
NEXT
'
PRINT "The path name is: "; Path$
PRINT "The file name is: "; File$
'
FUNCTION ExeName$
'ExeName returns the name of the currently running program.
'It requires DOS 3.0 or later.
DIM Regs AS RegType   'for CALL Interrupt
'
'Int 21h function 62h returns the PSP segment in BX.
Regs.ax = &H6200
CALL Interrupt(&H21, Regs, Regs)
'
'The environment segment is at address 44/45 in the PSP segment.
DEF SEG = Regs.bx
DEF SEG = PEEK(44) + PEEK(45) * 256
'
'Search the environment segment for two zero bytes in a row.  The
'program name follows the two bytes that follow the two zeros.
Byte = 0
DO
  IF PEEK(Byte) = 0 THEN       'this is zero
    IF PEEK(Byte + 1) = 0 THEN 'this is too
      Byte = Byte + 2          'so skip both
      EXIT DO                  'we be done
    END IF
  END IF                       'else,
  Byte = Byte + 1              'keep looking
LOOP

IF PEEK(Byte) = 1 THEN         'if this byte = 1
  Byte = Byte + 2              'the name follows
  DO WHILE PEEK(Byte)          'up to another zero
    Temp$ = Temp$ + CHR$(PEEK(Byte))
    Byte = Byte + 1
  LOOP
  ExeName$ = Temp$             'assign the function output
END IF
DEF SEG                        'restore default
END FUNCTION
