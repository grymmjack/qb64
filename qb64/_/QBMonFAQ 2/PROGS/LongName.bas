'***************************************************************************
' LONGNAME.BAS = Handling Window's Long Filenames with QB
' ============   Unterstuetzung fuer Lange Dateinamen und Ordnernamen in QB
'
' Dieses Q(uick)Basic-Programm enthaelt einen Satz von Routinen, die den
' Zugriff auf lange Datei-, -Pfad- und Ordnernamen (LFN = Long File Names)
' unter Windows ab Version 95 ermoeglichen.
'
' Das Programm stammt aus dem ABC-Archiv und verwendet den CALL ABSOLUTE -
' Befehl. Daher muss QuickBASIC mit der Option "/L" aufgerufen werden, z.B.
' mit  QB.EXE /L LONGNAME.BAS . Bei QBasic ist dies nicht erforderlich.
'
'===========================================================================
' Subject: WINDOW'S LONG FILENAMES Date: 11-24-95 (00:00)
' Author: Mark K. Kim Code: QB, QBasic, PDS
' Origin: members.aol.com/vindaci/ Packet: DOS.ABC
'===========================================================================
'#iab.compatibility.version.1a
'LFN version 1.0 beta1 -- Long filename functions
'Copyright (c)1996 Mark K. Kim
'markkkim*aol.com
'http://members.aol.com/markkkim/
'http://members.aol.com/vinDaci/
'* Freely distributed. May be used in other programs with proper notice of
' credit.
'* This program is provided "as-is".
'* In QBASIC, no modification is necessary
'* In QuickBASIC, QuickBASIC PDS, or VisualBASIC for DOS, run with the
' "/L" option, like so:
'
' QB /L
' QBX /L
' VBDOS /L
'
' Also, do not include the QB.BI, QBX.BI, or VBDOS.BI files. If you do,
' modify them so that the line "DECLARE ABSOLUTE..." is gone.
' * In QuickBASIC PDS and VisualBASIC, change all the lines in the format
'   "VARSEG(any.string.variable$)" to "SSEG(any.string.variable$)".
' * CREDIT: Ralf Brown's interrupt list was used to get interrupt for the
'   function. Microsoft DOS's Debug was used to convert Assembly code to
'   machine code. Microsoft is a Registered Trademark of Microsoft Corp.
' * NOTE: Works only under operating systems that support Windows95 LFN
'   or LFN emulation programs.
'
'Read the header of each function to find out their usage. These functions
'are designed to work with most other routines as it does not interfere
'with any other routines.
'***************************************************************************
'
'the following line exists for compatibility reasons:
DECLARE SUB absolute (var1%, var2%, var3%, var4%, var5%, var6%, var7%, var8%, var9%, offset%)
'
'#----- begin declaration
'File attribute constants -- used to do file search
CONST ATT.ALL = &HFF
CONST ATT.SHARE = &H80
CONST ATT.ARC = &H20
CONST ATT.DIR = &H10
CONST ATT.VOL = &H8
CONST ATT.SYS = &H4
CONST ATT.HID = &H2
CONST ATT.RDO = &H1
CONST ATT.NONE = &H0
'
'Value set to error code if an error occurs
DIM SHARED errval AS INTEGER
'
'Procedures
DECLARE SUB lfn.mkdir (dirname$)         'make LFN directory
DECLARE SUB lfn.rmdir (dirname$)         'remove LFN directory
DECLARE SUB lfn.chdir (dirname$)         'change to a LFN directory
DECLARE SUB lfn.del (filename$)          'delete a LFN file
DECLARE SUB lfn.ren (oldname$, newname$) 'rename file
DECLARE FUNCTION lfn.cwd$ (drive%)       'get current working directory
DECLARE FUNCTION lfn.l2s$ (longname$)    'long name to short name
DECLARE FUNCTION lfn.s2l$ (shortname$)   'short name to long name
DECLARE FUNCTION lfn.findfirst$ (filespec$, findattrib%, mustattrib%)
DECLARE FUNCTION lfn.findnext$ ()
DECLARE SUB lfn.findclose ()
'#end declarations
'
'
'#------start example program
CLS
'
longfilename$ = "long filename entry.tmp"
longdirname$ = "long directory name entry"
'
'make a LFN file by first opening a SFN file, then renaming it to LFN:
'first create SFN
OPEN "sfn.tmp" FOR OUTPUT AS #1
PRINT #1, "La la la! This is a SFN entry!"
CLOSE #1
'rename SFN to LFN
lfn.ren "sfn.tmp", longfilename$
IF errval THEN PRINT "Error while renaming!" ELSE PRINT "LFN Created"
'
'display all files in the current directory
'file search -- allow any/all attributes and limit no attribute
filename$ = lfn.findfirst$("*.*", ATT.ALL, ATT.NONE)
'
'display result
IF errval THEN
  PRINT "Error during file search!"
ELSE
  PRINT "File search result: "
  'display filename and continue search
  DO
    PRINT " "; filename$
    filename$ = lfn.findnext$
  LOOP UNTIL errval
  'terminate search -- must be called
  lfn.findclose
END IF
'
'delete previously created LFN file
lfn.del longfilename$
IF errval THEN PRINT "Error while deleting LFN!" ELSE PRINT "LFN deleted"
'
'create LFN directory
lfn.mkdir longdirname$
IF errval THEN PRINT "Error while creating LFN directory!" ELSE PRINT "LFN directory created"
'
'display LFN directory's SFN equivalent
PRINT "LFN entry's SFN equivalent is: "; lfn.l2s(longdirname$)
'
'change current directory to LFN
'first display current directory
PRINT "Current directory: "; lfn.cwd$(-1)
'next change directory
lfn.chdir longdirname$
IF errval THEN PRINT "Error changing directory" ELSE PRINT "Directory changed"
'display directory
PRINT "Directory after change: "; lfn.cwd$(-1)
'change back
lfn.chdir ".."
IF errval THEN PRINT "Error changing directory" ELSE PRINT "Back to original directory"
'
'remove LFN directory
lfn.rmdir longdirname$
IF errval THEN PRINT "Error removing LFN directory" ELSE PRINT "LFN directory removed"
'

'------ lfn.chdir -- Change Directory
'INPUT:
' dirname$ - Name of the directory to change to.
'SUCCESS:
' * Working directory changed to specified directory.
' * Global variable errval set to zero.
'FAIL:
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
SUB lfn.chdir (dirname$)
'
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H1E) 'PUSH DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H17) 'MOV DX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H1F) 'MOV DS,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H3B) + CHR$(&H71) 'MOV AX,713B
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H1F) 'POP DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.dirname$ = dirname$ + CHR$(0)
lfn.dirnameseg% = VARSEG(lfn.dirname$)
lfn.dirnameoff% = SADD(lfn.dirname$)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, lfn.dirnameseg%, lfn.dirnameoff%, SADD(asm$))
DEF SEG
'
iserror% = lfn.dirnameseg%
errorcode% = lfn.dirnameoff%
'
IF iserror% THEN
  errval = errorcode%
ELSE
  errval = 0
END IF
'
END SUB

'------ lfn.cwd$ -- Return current directory
'INPUT:
' drive% - Number of the drive to get the current directory of.
' 0 = A:, 1 = B:, 2 = C:, etc. -1 if current drive.
'SUCCESS:
' * Return current directory of the specified drive.
' * Global variable errval set to zero.
'FAIL:
' * Return "".
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
FUNCTION lfn.cwd$ (drive%)
'
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H56) 'PUSH SI
asm$ = asm$ + CHR$(&H1E) 'PUSH DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8A) + CHR$(&H17) 'MOV DL,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H37) 'MOV SI,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H1F) 'MOV DS,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H47) + CHR$(&H71) 'MOV AX,7147
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H8C) + CHR$(&HDA) 'MOV DX,DS
asm$ = asm$ + CHR$(&H1F) 'POP DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5E) 'POP SI
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.drive% = drive% + 1
'
lfn.path$ = SPACE$(1024)
lfn.pathseg% = VARSEG(lfn.path$)
lfn.pathoff% = SADD(lfn.path$)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, lfn.pathseg%, lfn.pathoff%, lfn.drive%, SADD(asm$))
DEF SEG
'
'convert returned data
iserror% = lfn.pathseg%
errorcode% = lfn.pathoff%
'
IF iserror% THEN
  errval = errorcode%
ELSE
  errval = 0
  'return current directory
  path$ = ""
  FOR i% = 1 TO 1025
    ch$ = MID$(lfn.path$, i%, 1)
    IF ch$ <> CHR$(0) THEN
      path$ = path$ + ch$
    ELSE
      EXIT FOR
    END IF
  NEXT
  lfn.cwd$ = path$
END IF
'
END FUNCTION

'------ lfn.del -- Delete a file
'INPUT:
' filename$ - Name of the file to delete
'SUCCESS:
' * File deleted
' * Global variable errval set to zero.
'FAIL:
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
SUB lfn.del (filename$)
'
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H56) 'PUSH SI
asm$ = asm$ + CHR$(&H1E) 'PUSH DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H17) 'MOV DX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H1F) 'MOV DS,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H41) + CHR$(&H71) 'MOV AX,7141
asm$ = asm$ + CHR$(&HB9) + CHR$(&H0) + CHR$(&H0) 'MOV CX,0000
asm$ = asm$ + CHR$(&HBE) + CHR$(&H1) + CHR$(&H0) 'MOV SI,0001
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H1F) 'POP DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5E) 'POP SI
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.filename$ = filename$ + CHR$(0)
lfn.filenameseg% = VARSEG(lfn.filename$)
lfn.filenameoff% = SADD(lfn.filename$)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, lfn.filenameseg%, lfn.filenameoff%, SADD(asm$))
DEF SEG
'
iserror% = lfn.filenameseg%
errorcode% = lfn.filenameoff%
'
IF iserror% THEN
  errval = errorcode%
ELSE
  errval = 0
END IF
'
END SUB

'------ lfn.close -- Stop file search
'INPUT:
' None
'SUCCESS:
' * Global variable errval set to zero.
'FAIL:
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
SUB lfn.findclose
'
SHARED lfn.filefindhandle%
'
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H1F) 'MOV BX,
asm$ = asm$ + CHR$(&HB8) + CHR$(&HA1) + CHR$(&H71) 'MOV AX,71A1
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, iserror%, errorcode%, lfn.filefindhandle%, SADD(asm$))
DEF SEG
'
IF iserror% THEN
  errval = errorcode%
ELSE
  errval = 0
END IF
'
END SUB

'------ lfn.findfirst$ -- Find file, initialization call
'INPUT:
' filespec$ - File name type to look for. IE - "C:\*.*"
' findattrib% - Files with these attributes are returned. Any files with
' lesser attributes are also returned. Files with more than these
' attributes are not returned. Used in conjunction with mustattrib%.
' Use ATT.* constants provided in declaration.
' mustattrib% - Files without these attributes are not returned. Used in
' conjunction with findattrib%. Use ATT.* constants provided in
' declaration.
'SUCCESS:
' * Return name of the first file matching the createria.
' * Global variable errval set to zero.
'FAIL:
' * Return "".
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
FUNCTION lfn.findfirst$ (filespec$, findattrib%, mustattrib%)
'
SHARED lfn.filefindhandle%
SHARED lfn.finddata AS STRING * 320
lfn.finddata = SPACE$(320)
'
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H57) 'PUSH DI
asm$ = asm$ + CHR$(&H6) 'PUSH ES
asm$ = asm$ + CHR$(&H56) 'PUSH SI
asm$ = asm$ + CHR$(&H1E) 'PUSH DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H3F) 'MOV DI,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H7) 'MOV ES,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H17) 'MOV DX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HE) 'MOV BX,
asm$ = asm$ + CHR$(&H8A) + CHR$(&H2F) 'MOV CH,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H10) 'MOV BX,
asm$ = asm$ + CHR$(&H8A) + CHR$(&HF) 'MOV CL,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H1F) 'MOV DS,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H4E) + CHR$(&H71) 'MOV AX,714E
asm$ = asm$ + CHR$(&HBE) + CHR$(&H1) + CHR$(&H0) 'MOV SI,0001
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H1F) 'POP DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5E) 'POP SI
asm$ = asm$ + CHR$(&H7) 'POP ES
asm$ = asm$ + CHR$(&H5F) 'POP DI
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.filespec$ = filespec$ + CHR$(0)

lfn.filespecseg% = VARSEG(lfn.filespec$)
lfn.filespecoff% = SADD(lfn.filespec$)
lfn.finddataseg% = VARSEG(lfn.finddata)
lfn.finddataoff% = VARPTR(lfn.finddata)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, findattrib%, mustattrib%, lfn.filespecseg%, lfn.filespecoff%, lfn.finddataseg%, lfn.finddataoff%, SADD(asm$))
DEF SEG
'
iserror% = lfn.filespecseg%
retcode% = lfn.filespecoff%
'
IF iserror% THEN
  errval = retcode%
ELSE
  errval = 0
  lfn.filefindhandle% = retcode%
  filename$ = ""
  DEF SEG = VARSEG(lfn.finddata)
  FOR i% = 0 TO 259
    ch$ = CHR$(PEEK(VARPTR(lfn.finddata) + &H2C + i%))
    IF ch$ <> CHR$(0) THEN
      filename$ = filename$ + ch$
    ELSE
      EXIT FOR
    END IF
  NEXT
  lfn.findfirst$ = filename$
END IF
'
END FUNCTION

'------ lfn.findnext$ -- Find file, continuation call
'INPUT:
' None. Same values used to call LFN.FINDFIRST$ are automatically used.
'SUCCESS:
' * Return name of the next file matching the createria.
' * Global variable errval set to zero.
'FAIL:
' * Return "".
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully. This includes a case when there
' is no more a file matching the createria.
FUNCTION lfn.findnext$
'
SHARED lfn.filefindhandle%
SHARED lfn.finddata AS STRING * 320
'
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H56) 'PUSH SI
asm$ = asm$ + CHR$(&H6) 'PUSH ES
asm$ = asm$ + CHR$(&H57) 'PUSH DI
asm$ = asm$ + CHR$(&HBE) + CHR$(&H1) + CHR$(&H0) 'MOV SI,0001
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H3F) 'MOV DI,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H7) 'MOV ES,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H1F) 'MOV BX,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H4F) + CHR$(&H71) 'MOV AX,714F
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5F) 'POP DI
asm$ = asm$ + CHR$(&H7) 'POP ES
asm$ = asm$ + CHR$(&H5E) 'POP SI
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.finddataseg% = VARSEG(lfn.finddata)
lfn.finddataoff% = VARPTR(lfn.finddata)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, lfn.filefindhandle%, lfn.finddataseg%, lfn.finddataoff%, SADD(asm$))
DEF SEG
'
iserror% = lfn.finddataseg%
errorcode% = lfn.finddataoff%
'
IF iserror% THEN
errval = errorcode%
ELSE
errval = 0
filename$ = ""
DEF SEG = VARSEG(lfn.finddata)
FOR i% = 0 TO 259
ch$ = CHR$(PEEK(VARPTR(lfn.finddata) + &H2C + i%))
IF ch$ <> CHR$(0) THEN
filename$ = filename$ + ch$
ELSE
EXIT FOR
END IF
NEXT
lfn.findnext$ = filename$
END IF
'
END FUNCTION

'------ lfn.l2s$ -- Convert long filename to short filename
'INPUT:
' longname$ - Long filename to convert to short filename.
'SUCCESS:
' * Return short filename version of the long filename.
' * Global variable errval set to zero.
'FAIL:
' * Return "".
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
FUNCTION lfn.l2s$ (longname$)
'
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H57) 'PUSH DI
asm$ = asm$ + CHR$(&H6) 'PUSH ES
asm$ = asm$ + CHR$(&H56) 'PUSH SI
asm$ = asm$ + CHR$(&H1E) 'PUSH DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H3F) 'MOV DI,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H7) 'MOV ES,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H37) 'MOV SI,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H1F) 'MOV DS,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H60) + CHR$(&H71) 'MOV AX,7160
asm$ = asm$ + CHR$(&HB9) + CHR$(&H1) + CHR$(&H0) 'MOV CX,0001
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H1F) 'POP DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5E) 'POP SI
asm$ = asm$ + CHR$(&H7) 'POP ES
asm$ = asm$ + CHR$(&H5F) 'POP DI
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.longname$ = longname$ + CHR$(0)
lfn.shortname$ = SPACE$(67)
'
lfn.longnameseg% = VARSEG(lfn.longname$)
lfn.longnameoff% = SADD(lfn.longname$)
lfn.shortnameseg% = VARSEG(lfn.shortname$)
lfn.shortnameoff% = SADD(lfn.shortname$)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, lfn.longnameseg%, lfn.longnameoff%, lfn.shortnameseg%, lfn.shortnameoff%, SADD(asm$))
DEF SEG
'
iserror% = lfn.longnameseg%
errorcode% = lfn.longnameoff%
'
IF iserror% THEN
  errval = errorcode%
ELSE
  errval = 0
  shortname$ = ""
    FOR i% = 1 TO 67
      ch$ = MID$(lfn.shortname$, i%, 1)
      IF ch$ <> CHR$(0) THEN
        shortname$ = shortname$ + ch$
      ELSE
        EXIT FOR
      END IF
    NEXT
  lfn.l2s$ = shortname$
END IF
'
END FUNCTION

'------ lfn.mkdir -- Create/Make Directory
'INPUT:
' dirname$ - Name of the directory to create.
'SUCCESS:
' * New directory created
' * Global variable errval set to zero.
'FAIL:
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
SUB lfn.mkdir (dirname$)
'
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H1E) 'PUSH DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H17) 'MOV DX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H1F) 'MOV DS,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H39) + CHR$(&H71) 'MOV AX,7139
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H1F) 'POP DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.dirname$ = dirname$ + CHR$(0)
lfn.dirnameseg% = VARSEG(lfn.dirname$)
lfn.dirnameoff% = SADD(lfn.dirname$)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, lfn.dirnameseg%, lfn.dirnameoff%, SADD(asm$))
DEF SEG
'
iserror% = lfn.dirnameseg%
errorcode% = lfn.dirnameoff%
'
IF iserror% THEN
  errval = errorcode%
ELSE
  errval = 0
END IF
'
END SUB

'------ lfn.ren -- Rename file/directory
'INPUT:
' oldname$ - Name of the file/directory to change.
' newname$ - Name of the new file/directory name.
'SUCCESS:
' * Specified file/directory name changed to the specified name.
' * Global variable errval set to zero.
'FAIL:
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
SUB lfn.ren (oldname$, newname$)
'
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H57) 'PUSH DI
asm$ = asm$ + CHR$(&H6) 'PUSH ES
asm$ = asm$ + CHR$(&H1E) 'PUSH DS
asm$ = asm$ + CHR$(&HB8) + CHR$(&H56) + CHR$(&H71) 'MOV AX,7156
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H3F) 'MOV DI,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H7) 'MOV ES,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H17) 'MOV DX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H1F) 'MOV DS,
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H1F) 'POP DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H7) 'POP ES
asm$ = asm$ + CHR$(&H5F) 'POP DI
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.oldname$ = oldname$ + CHR$(0)
lfn.newname$ = newname$ + CHR$(0)
'
lfn.oldnameseg% = VARSEG(lfn.oldname$)
lfn.oldnameoff% = SADD(lfn.oldname$)
lfn.newnameseg% = VARSEG(lfn.newname$)
lfn.newnameoff% = SADD(lfn.newname$)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, lfn.oldnameseg%, lfn.oldnameoff%, lfn.newnameseg%, lfn.newnameoff%, SADD(asm$))
DEF SEG
'
iserror% = lfn.newnameseg%
errorcode% = lfn.newnameoff%
'
IF iserror% THEN
  errval = errorcode%
ELSE
  errval = 0
END IF
'
END SUB

'------ lfn.rmdir -- Remove Directory
'INPUT:
' dirname$ - Name of the directory to remove.
'SUCCESS:
' * Specified directory removed.
' * Global variable errval set to zero.
'FAIL:
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
SUB lfn.rmdir (dirname$)
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H1E) 'PUSH DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H17) 'MOV DX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H1F) 'MOV DS,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H3A) + CHR$(&H71) 'MOV AX,713A
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H1F) 'POP DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.dirname$ = dirname$ + CHR$(0)
lfn.dirnameseg% = VARSEG(lfn.dirname$)
lfn.dirnameoff% = SADD(lfn.dirname$)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, dummy%, lfn.dirnameseg%, lfn.dirnameoff%, SADD(asm$))
DEF SEG
'
iserror% = lfn.dirnameseg%
errorcode% = lfn.dirnameoff%
'
IF iserror% THEN
  errval = errorcode%
ELSE
  errval = 0
END IF
'
END SUB

'------ lfn.s2l$ -- Convert short filename to long filename
'INPUT:
' shortname$ - Short filename to convert to long filename.
'SUCCESS:
' * Return long filename version of the short filename.
' * Global variable errval set to zero.
'FAIL:
' * Return "".
' * Global variable errval set to &h7100 if function is not supported.
' (probably does not support LFN)
' * Global variable errval set to non-zero if an error occurs and the task
' could not be completed successfully.
FUNCTION lfn.s2l$ (shortname$)
'
asm$ = ""
asm$ = asm$ + CHR$(&H55) 'PUSH BP
asm$ = asm$ + CHR$(&H89) + CHR$(&HE5) 'MOV BP,SP
asm$ = asm$ + CHR$(&H57) 'PUSH DI
asm$ = asm$ + CHR$(&H6) 'PUSH ES
asm$ = asm$ + CHR$(&H56) 'PUSH SI
asm$ = asm$ + CHR$(&H1E) 'PUSH DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H3F) 'MOV DI,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H7) 'MOV ES,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H37) 'MOV SI,
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC) 'MOV BX,
asm$ = asm$ + CHR$(&H8E) + CHR$(&H1F) 'MOV DS,
asm$ = asm$ + CHR$(&HB8) + CHR$(&H60) + CHR$(&H71) 'MOV AX,7160
asm$ = asm$ + CHR$(&HB9) + CHR$(&H2) + CHR$(&H0) 'MOV CX,0002
asm$ = asm$ + CHR$(&HCD) + CHR$(&H21) 'INT 21
asm$ = asm$ + CHR$(&H1F) 'POP DS
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&HB8) + CHR$(&H0) + CHR$(&H0) 'MOV AX,0000
asm$ = asm$ + CHR$(&H15) + CHR$(&H0) + CHR$(&H0) 'ADC AX,0000
asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC) 'MOV BX,
asm$ = asm$ + CHR$(&H89) + CHR$(&H7) 'MOV ,AX
asm$ = asm$ + CHR$(&H5E) 'POP SI
asm$ = asm$ + CHR$(&H7) 'POP ES
asm$ = asm$ + CHR$(&H5F) 'POP DI
asm$ = asm$ + CHR$(&H5D) 'POP BP
asm$ = asm$ + CHR$(&HCA) + CHR$(&H12) + CHR$(&H0) 'RETF 0012
'
lfn.shortname$ = shortname$ + CHR$(0)
lfn.longname$ = SPACE$(261)
'
lfn.shortnameseg% = VARSEG(lfn.shortname$)
lfn.shortnameoff% = SADD(lfn.shortname$)
lfn.longnameseg% = VARSEG(lfn.longname$)
lfn.longnameoff% = SADD(lfn.longname$)
'
DEF SEG = VARSEG(asm$)
CALL absolute(dummy%, dummy%, dummy%, dummy%, dummy%, lfn.shortnameseg%, lfn.shortnameoff%, lfn.longnameseg%, lfn.longnameoff%, SADD(asm$))
DEF SEG
'
iserror% = lfn.shortnameseg%
errorcode% = lfn.shortnameoff%
'
IF iserror% THEN
errval = errorcode%
ELSE
errval = 0
longname$ = ""
FOR i% = 1 TO 261
ch$ = MID$(lfn.longname$, i%, 1)
IF ch$ <> CHR$(0) THEN
longname$ = longname$ + ch$
ELSE
EXIT FOR
END IF
NEXT
lfn.s2l$ = longname$
END IF
'
END FUNCTION

