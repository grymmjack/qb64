'*****************************************************
' COMMAND.BAS - Komandozeilen-Interpreter ("Fake OS")
' ===========
' Ablauffaehig nur unter QuickBASIC 7.1
' (Wegen des DIR$ - Befehls)
' Die QB 7.1 Entwicklungsumgebung muss
' mit "QBX /L COMMAND.BAS" gestartet werden.
' wegen der Verwendung des CALL ABSOLUTE-Befehls
'
' von Sebastian Mate ("CEB"), 6.2002
' www.sm-gimi.de --  sebmate*arcor.de
'*****************************************************
'
DEFINT A-Z
DECLARE SUB EXEC (DOSCOM$, COMTAIL$, CF AS INTEGER)
DECLARE SUB InterruptX2 (IntNum%, regsx AS ANY)
'
ON ERROR GOTO FATAL:
'
TYPE RegTypeX
AX AS INTEGER
BX AS INTEGER
cx AS INTEGER
DX AS INTEGER
bp AS INTEGER
si AS INTEGER
di AS INTEGER
flags AS INTEGER
ds AS INTEGER
es AS INTEGER
END TYPE
DIM SHARED regsx AS RegTypeX
'
'^INT 21,4B - EXEC/Load and Execute Program
'
' AH = 4B
' AL = 00 to load and execute program
' = 01 (Undocumented) create program segment prefix and load
' program, but don't execute. The CS:IP and SS:SP of the
' program is placed in parameter block. Used by debuggers
' = 03 load program only
' = 04 called by MSC spawn() when P_NOWAIT is specified
' DS:DX = pointer to an ASCIIZ filename
' ES:BX = pointer to a parameter block
'
'
' on return:
' AX = error code if CF set (see ~DOS ERROR CODES~)
' ES:BX = when AL=1, pointer to parameter block similar to:
'
DO
LOGON:
CLS
PRINT "GIMI SYSTEM SHELL 1.00, (C) 2002 The GIMI Team"
PRINT "(DOS compatible. Type 'help' for Help.)"
PRINT
INPUT "Logon: ", USRNAME$
IF USRNAME$ = "" THEN
PRINT
PRINT "NOT A USER NAME"
PRINT
SLEEP 1
END IF
LOOP UNTIL USRNAME$ <> ""
PRINT
'
DO
'
PRINT CURDIR$;
INPUT ">", COMM$
OK% = 0
'
IF LEN(COMM$) = 2 THEN
IF MID$(UCASE$(COMM$), 2, 1) = ":" THEN
COMM$ = MID$(UCASE$(COMM$), 1, 1)
A$ = COMM$ + CHR$(0)
B$ = ""
regsx.AX = &HE00
regsx.DX = ASC(COMM$) - 65
CALL InterruptX2(&H21, regsx)
OK% = 1
END IF
END IF
'
IF COMM$ = "" THEN OK% = 1
'
isopt% = INSTR(COMM$, " ")
OPT$ = ""
IF isopt% > 0 THEN OPT$ = MID$(COMM$, isopt% + 1, LEN(COMM$) - isopt%): COMM$ = MID$(COMM$, 1, isopt% - 1)
'
IF UCASE$(COMM$) = "HELP" THEN
PRINT "Available commands:"
PRINT ""
PRINT "user logout"
PRINT "help exit"
PRINT "ver halt"
PRINT "mem cls"
PRINT "time date"
PRINT "cd dir"
PRINT "ls"
PRINT ""
PRINT "To run an executable (EXE or COM), you must type the whole filename"
PRINT "with it's extension!"
PRINT
END IF
'
'
IF UCASE$(COMM$) = "USER" THEN
PRINT "User is "; USRNAME$
PRINT
OK% = 1
END IF
'
IF UCASE$(COMM$) = "LOGOUT" THEN GOTO LOGON:
'
IF UCASE$(COMM$) = "TIME" THEN PRINT TIME$: PRINT : OK% = 1
IF UCASE$(COMM$) = "DATE" THEN PRINT DATE$: PRINT : OK% = 1
'
'
'
IF UCASE$(COMM$) = "VER" THEN
PRINT "GIMI SYSTEM SHELL 1.00"
PRINT
OK% = 1
END IF
'
IF UCASE$(COMM$) = "MEM" THEN
PRINT FRE(-1), "free DOS memory"
PRINT FRE(-2), "free stack space"
PRINT
OK% = 1
END IF
'
IF LEN(COMM$) >= 2 THEN
IF MID$(UCASE$(COMM$), 1, 2) = "CD" THEN
IF isopt% = 0 THEN
PRINT CURDIR$
OK% = 1
END IF
'
IF isopt% > 0 THEN
' --------D-213B-------------------------------
' INT 21 - DOS 2+ - "CHDIR" - SET CURRENT DIRECTORY
' AH = 3Bh
' DS:DX -> ASCIZ pathname to become current directory (max 64 bytes)
' Return: CF clear if successful
' AX destroyed
' CF set on error
' AX = error code (03h) (see #1545 at AH=59h/BX=0000h)
' Notes: if new directory name includes a drive letter, the default drive is
' not changed, only the current directory on that drive
' changing the current directory also changes the directory in which
' FCB file calls operate
' under the FlashTek X-32 DOS extender, the pointer is in DS:EDX
' SeeAlso: AH=47h,AX=713Bh,INT 2F/AX=1105h
CHDIR OPT$
OK% = 1
END IF
END IF
END IF
'
IF UCASE$(COMM$) = "EXIT" THEN PRINT "EXIT": END
'
IF UCASE$(COMM$) = "HALT" THEN
PRINT "System halted"
SOUND 500, 1
DO: LOOP
END IF
'
IF UCASE$(COMM$) = "CLS" THEN CLS : OK% = 1
'
IF UCASE$(COMM$) = "DIR" THEN
IF OPT$ = "" THEN OPT$ = "*.*"
A$ = DIR$(OPT$)
IF A$ = "" THEN PRINT "File not found.": PRINT
IF A$ <> "" THEN
PRINT A$
DO
N$ = DIR$
PRINT N$
LOOP UNTIL N$ = ""
END IF
OK% = 1
END IF
'
IF UCASE$(COMM$) = "LS" THEN
IF OPT$ = "" THEN OPT$ = "*.*"
A$ = DIR$(OPT$)
IF A$ = "" THEN PRINT "File not found.": PRINT
IF A$ <> "" THEN
PRINT A$,
DO
N$ = DIR$
PRINT N$,
LOOP UNTIL N$ = ""
PRINT
END IF
OK% = 1
END IF
'
IF OK% = 0 AND COMM$ <> "" AND DIR$(COMM$) <> "" THEN
IF INSTR(UCASE$(COMM$), "COM") > 0 OR INSTR(UCASE$(COMM$), "EXE") > 0 THEN
CALL EXEC(COMM$, OPT$, 0)
ELSE
PRINT COMM$; " is not a COM or EXE file."
END IF
OK% = 1
PRINT
END IF
'
IF OK% = 0 THEN PRINT "Command or file not found.": PRINT : OK% = 0
'
LOOP
'
'
'hex data for interrupt routines
DATA &H55, &H8B, &HEC, &H83, &HEC, &H08, &H56, &H57, &H1E, &H55, &H8B, &H5E
DATA &H06, &H8B, &H47, &H10, &H3D, &HFF, &HFF, &H75, &H04, &H1E, &H8F, &H47
DATA &H10, &H8B, &H47, &H12, &H3D, &HFF, &HFF, &H75, &H04, &H1E, &H8F, &H47
DATA &H12, &H8B, &H47, &H08, &H89, &H46, &HF8, &H8B, &H07, &H8B, &H4F, &H04
DATA &H8B, &H57, &H06, &H8B, &H77, &H0A, &H8B, &H7F, &H0C, &HFF, &H77, &H12
DATA &H07, &HFF, &H77, &H02, &H1E, &H8F, &H46, &HFA, &HFF, &H77, &H10, &H1F
DATA &H8B, &H6E, &HF8, &H5B, &HCD, &H21, &H55, &H8B, &HEC, &H8B, &H6E, &H02
DATA &H89, &H5E, &HFC, &H8B, &H5E, &H06, &H1E, &H8F, &H46, &HFE, &HFF, &H76
DATA &HFA, &H1F, &H89, &H07, &H8B, &H46, &HFC, &H89, &H47, &H02, &H89, &H4F
DATA &H04, &H89, &H57, &H06, &H58, &H89, &H47, &H08, &H89, &H77, &H0A, &H89
DATA &H7F, &H0C, &H9C, &H8F, &H47, &H0E, &H06, &H8F, &H47, &H12, &H8B, &H46
DATA &HFE, &H89, &H47, &H10, &H5A, &H1F, &H5F, &H5E, &H8B, &HE5, &H5D, &HCA
DATA &H02, &H00
'
FATAL:
RESUME FATAL2:
FATAL2:
CLS
PRINT "FATAL SYSTEM ERROR"
PRINT "SYSTEM HALTED"
SOUND 500, 1
DO
SOUND 500, 1
LOOP

'
SUB EXEC (DOSCOM$, COMTAIL$, CF AS INTEGER)
'
DIM PRMBLK(1 TO 7) AS INTEGER, BYTES AS LONG, SMP AS INTEGER, OSP AS INTEGER
DIM SMCOM AS INTEGER, OSCOM AS INTEGER, I AS INTEGER, L AS INTEGER
DIM SMTAIL AS INTEGER, OSTAIL AS INTEGER, EXECCODE(1 TO 25) AS INTEGER
DIM OSC AS INTEGER, OSPHIGH AS INTEGER, OSPLOW AS INTEGER, SMPHIGH AS INTEGER
DIM SMPLOW AS INTEGER, SMHIGH AS INTEGER, SMLOW AS INTEGER, OSHIGH AS INTEGER
DIM OSLOW AS INTEGER, AX AS INTEGER, BX AS INTEGER
'
' Get parameters for system call.
'
SMP = VARSEG(PRMBLK(1))
OSP = VARPTR(PRMBLK(1))
'
' Put DOSCOM$ in array as ASCIIZ string. (Just creating an ASCIIZ string
' from DOSCOM$ and using VARSEG and SADD doesn't work!)
'
L = LEN(DOSCOM$) + 1
DIM DOSC(1 TO INT(CSNG(L + 1) / 2)) AS INTEGER
SMCOM = VARSEG(DOSC(1)): OSCOM = VARPTR(DOSC(1))
DEF SEG = SMCOM
FOR I = 0 TO L - 2
POKE OSCOM + I, ASC(MID$(DOSCOM$, I + 1, 1))
NEXT I
POKE OSCOM + L - 1, 0
'
' Put command-tail in array.
'
L = LEN(COMTAIL$) + 3
DIM TAIL(1 TO INT(CSNG(L + 1) / 2)) AS INTEGER
SMTAIL = VARSEG(TAIL(1))
OSTAIL = VARPTR(TAIL(1))
DEF SEG = SMTAIL
POKE OSTAIL, L - 2
POKE OSTAIL + 1, 32
IF L - 3 > 0 THEN
FOR I = 1 TO L - 3
A$ = MID$(COMTAIL$, I, 1)
POKE OSTAIL + I + 1, ASC(A$)
NEXT I
END IF
POKE OSTAIL + L - 1, 13
'
' Set up parameter block.
'
PRMBLK(1) = 0
PRMBLK(2) = OSTAIL
PRMBLK(3) = SMTAIL
'
' Elements 4 - 7, which refer to FCB parameters, don't need to be defined
' because DOS versions past 1 (and programs written for them) don't
' generally use File Control Blocks--but the space for these parameters
' in the parameter block still has to be set aside.
'
' Set up machine code.
'
DEF SEG = VARSEG(EXECCODE(1))
OSC = VARPTR(EXECCODE(1))
POKE OSC, &H55 'PUSH BP
POKE OSC + 1, &H1E 'PUSH DS
POKE OSC + 2, 6 'PUSH ES
POKE OSC + 3, &H54 'PUSH SP
POKE OSC + 4, &H16 'PUSH SS
POKE OSC + 5, &H89: POKE OSC + 6, &HE5 'MOV BP,SP
POKE OSC + 7, &HB8: POKE OSC + 8, 0: POKE OSC + 9, &H4B 'MOV AX,4B00
OSPLOW = OSP AND &HFF: OSPHIGH = (OSP AND &HFF00&) / 256
POKE OSC + 10, &HBB: POKE OSC + 11, OSPLOW: POKE OSC + 12, OSPHIGH'MOV BX,[OSP]
SMPLOW = SMP AND &HFF: SMPHIGH = (SMP AND &HFF00&) / 256
POKE OSC + 13, &HBA: POKE OSC + 14, SMPLOW: POKE OSC + 15, SMPHIGH'MOV DX,[SMP]
POKE OSC + 16, &H8E: POKE OSC + 17, &HC2 'MOV ES,DX
SMLOW = SMCOM AND &HFF: SMHIGH = (SMCOM AND &HFF00&) / 256
POKE OSC + 18, &HBA: POKE OSC + 19, SMLOW: POKE OSC + 20, SMHIGH'MOV DX,[SMCOM]
POKE OSC + 21, &H8E: POKE OSC + 22, &HDA 'MOV DS,DX
OSLOW = OSCOM AND &HFF: OSHIGH = (OSCOM AND &HFF00&) / 256
POKE OSC + 23, &HBA: POKE OSC + 24, OSLOW: POKE OSC + 25, OSHIGH'MOV DX,[OSCOM]
POKE OSC + 26, &HCD: POKE OSC + 27, &H21 'INT 21
POKE OSC + 28, &H89: POKE OSC + 29, &HC3 'MOV BX,AX
POKE OSC + 30, &H9F 'LAHF
POKE OSC + 31, &H8B: POKE OSC + 32, &H7E: POKE OSC + 33, 6 'MOV DI,[BP+6]
POKE OSC + 34, &H89: POKE OSC + 35, &H1D 'MOV [DI],BX
POKE OSC + 36, &H8B: POKE OSC + 37, &H7E: POKE OSC + 38, 8 'MOV DI,[BP+8]
POKE OSC + 39, &H89: POKE OSC + 40, 5 'MOV [DI],AX
POKE OS + 41, &H17 'POP SS
POKE OS + 42, &H5C 'POP SP
POKE OSC + 43, 7 'POP ES
POKE OSC + 44, &H1F 'POP DS
POKE OSC + 45, &H5D 'POP BP
POKE OSC + 46, &HCA: POKE OSC + 47, 4: POKE OSC + 48, 0 'RETF 4
'
' Ordinarily, I wouldn't reset the memory pointer until after ABSOLUTE is
' called. However, SETMEM requires it. (It is set back to the machine
' code routine after SETMEM is used to reclaim memory.)
'
DEF SEG
'
' Free as much memory as possible and make interrupt call.
'
BYTES = SETMEM(0)
X = SETMEM(-BYTES)
DEF SEG = VARSEG(EXECCODE(1))
CALL ABSOLUTE(AX, BX, OSC)
'
' Just as SETMEM needed this the first time, I suspect it needs it now.
'
DEF SEG
'
' Restore memory.
'
X = SETMEM(BYTES)
'
' Check error codes (get carry flag) and print out appropriate message.
'
AX = (AX AND &HFF00&) / 256
CF = AX AND 1
IF CF <> 0 THEN
'
' Not all of the error codes are processed here, just the more likely
' ones.
'
IF BX = 2 THEN PRINT DOSCOM$; " not found."
IF BX = 3 THEN PRINT "Path not found."
IF BX = 5 THEN PRINT "Access denied."
IF BX = 7 THEN PRINT "Memory control block destroyed."
IF BX = 8 THEN PRINT "Insufficient memory."
IF BX = 4 OR BX = 6 THEN PRINT "Unavailable or invalid handle."
IF BX < 2 AND BX > 8 THEN PRINT "Unspecified error."
'
' Reset CF to be the value of BX in case user wants to make own
' evaluation of returned error code.
'
CF = BX
END IF
'
END SUB

'
'[IM, from code by DG]
SUB InterruptX2 (IntNum, regsx AS RegTypeX) STATIC
'
STATIC FileNum, IntOffset, Loaded
'
' use fixed-length string to fix its position in memory
' and so we don't mess up string pool before routine
' gets its pointers from caller
DIM IntCode AS STRING * 200
IF NOT Loaded THEN ' loaded will be 0 first time
'
FOR k = 0 TO 145 'bit of a bodge, this, but it works <dg>
READ h% 'if anyone fixes it, or explains it, let me know :) <dg>
Icode$ = Icode$ + CHR$(h%)
NEXT 'end of bodge <dg>
'
IntCode = Icode$ ' load routine and determine
IntOffset = INSTR(IntCode$, CHR$(&HCD) + CHR$(&H21)) + 1 ' int # offset
Loaded = -1
END IF
'
DEF SEG = VARSEG(IntCode) ' poke interrupt number into
POKE VARPTR(IntCode) * 1& + IntOffset - 1, IntNum' code block
CALL ABSOLUTE(regsx, VARPTR(IntCode$)) ' call routine
DEF SEG
'
END SUB

