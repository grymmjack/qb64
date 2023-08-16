'******************************************************************************
'  xDIR.bas - Shows the file list of a directory using interrupts calls
' ========= - Inhalt eines Verzeichnisses auflisten - per Interrupt-Calls
'
' Deutsche Beschreibung (von Thomas Antoni; 29.8.02 - 2.3.04)
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Dies Programm enthaelt die FUNCTION xDIR, die den Inhalt eines
' Verzeichnisses auflistet und laut Meinung des  Programmautors besser ist
' als die DIR$-Funktion von QuickBasic 7.1.
' Die FUNCTION xDIR wird beispielhaft aufgerufen zum Anzeigen des
' Stammverzeichnisses C:\ .
'
' ACHTUNG: Dies Programm verwendet CALL INTERRUPT ist daher nur unter
' ~~~~~~~~ QuickBasic, nicht unter QBasic ablauffaehig. QuickBasic 4.5
'          muss mit "QB.EXE /L xdir.bas" gestartet werden"
'
' English Description
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' This file contains a DIR function to retrieve files and Directories
' This is a much better function than QB7.1's DIR$ function
' It can also retrieve Directories, and you can also Retrieve the FileSize
' CreateTime, Attributes, AccessTime, AccessDate of the File/Directory
' This is done via Interrupt Calls to DOS functions.
'
' ATTENTION: This program can not be run under QBasic because it uses
' ~~~~~~~~~~ the CALL INTERRUPT statement. So you have to start QuickBasic
'            4.5 or QBX with the /L option
'
' 1 problem:
' The File/Dir information are retrieved as a DTAStructure TYPE
' I only have trouble to decode Accesstime and AccessDate
' they are returned as Integers, but I want to convert them in a notation
' like 14:00, 1-1-2000.
' That's why I only show FileName, Type and FileSize
' If anyone knows how to Convert AccessTime and Accessdate please mail me!
'
' If you're using my DIR function, I would appreciate it if you credit me!
' I hope you find much use in this Function!
'
' (c) Peter Jonk
'     Rush Soft
'     e-mail: peterjonk*usa.net
'
'==============================================================================
REM $INCLUDE: 'QB.BI'
DECLARE SUB ShowHeader ()
DECLARE SUB WriteFileInfo (LineNumber%)
DECLARE FUNCTION DirX% (Dirspec$, Filter%, SearchType%)
'
CONST ALLENTRIES = 0, FILESONLY = 1, DIRSONLY = 2
CONST FALSE = 0, TRUE = NOT FALSE
CONST FINDFIRST = &H4E00, FINDNEXT = &H4F00
CONST NOTMOREFOUND = 0, ENTRYNOTMATCHEDFILTER = 1, ENTRYFOUND = 2
TYPE DTAStructure
DOS AS STRING * 19
CreateTime AS STRING * 1
Attributes AS INTEGER
AccessTime AS INTEGER
AccessDate AS INTEGER
FileSize AS LONG
Filename AS STRING * 13
END TYPE
DIM SHARED Registers AS RegTypeX
DIM SHARED DTA AS DTAStructure
'-----------------------------------
'
CLS
LOCATE 1, 1: PRINT "This example retries All files and Directories from your C drive in the root."
LOCATE 2, 1: PRINT "The Returned Files/Dir are put in the Variabele DTA which has the Structure"
LOCATE 3, 1: PRINT " DOS AS STRING * 19"
LOCATE 4, 1: PRINT " CreateTime AS STRING * 1"
LOCATE 5, 1: PRINT " Attributes AS INTEGER"
LOCATE 6, 1: PRINT " AccessTime AS INTEGER"
LOCATE 7, 1: PRINT " AccessDate AS INTEGER"
LOCATE 8, 1: PRINT " FileSize AS LONG"
LOCATE 9, 1: PRINT " Filename AS STRING * 13"
LOCATE 11, 1: PRINT "<Press any key to start>"
SLEEP
'
ShowHeader
CurrLine% = 3
Found% = DirX%("C:\*.*", ALLENTRIES, FINDFIRST)
DO WHILE Found% <> NOTMOREFOUND
IF Found% = ENTRYFOUND THEN
WriteFileInfo CurrLine%
END IF
'
' Search Next entry
Found% = DirX%("C:\*.*", ALLENTRIES, FINDNEXT)
LOOP
'
CLS
PRINT "That was it."
PRINT "Having problems or found bugs in this function? Mail me at Peterjonk*usa.net"
PRINT "Also visit the Rush site where I'm member from at: http://welcome.to/Rush"

'
FUNCTION DirX% (Dirspec$, Filter%, SearchType%)
'
'-------------------------------------------------
'FUNCTION DirX% (Dirspec$, Filter%, SearchType%)
'
'Action:
' Searches a File/Dir that matches a given up Specification
' Similair to the DOS DIR Command you can also include Wildcard chards
' Like * ? in your DirSpecification
'
'Parameters:
' DirSpec$: The DIR Specification for example C:\*.BAT or C:\*.???
' Filter% : If you only want Directories and not Files
' you can apply a filter on your Query
' Use these Constants: ALLENTRIES, FILESONLY, DIRSONLY
' SearchType%: The TYPE of search Findfirst or Findnext
' The first time you search you'll have yo Use FindFirst
' otherwise FindNext.
' Use these Constants: ALLENTRIES, FILESONLY, DIRSONLY
' FINDFIRST, FINDNEXT
'
'Function Result:
' The result of the function can be:
' NOTMOREFOUND: No more matches on your Query found
' ENTRYNOTMATCHEDFILTER: Found a match, but the Match didn't match
' your given up Filter
' If for example a Directory is found and you've
' given up FILESONLY as Filter the function
' returns this status
' ENTRYFOUND: An entry was found that matches your specification
'-----------------------------------------------------------------------
'
IF SearchType% <> FINDFIRST AND SearchType% <> FINDNEXT THEN EXIT FUNCTION
IF SearchType% = FINDFIRST THEN
' SETDTA
Registers.ax = &H1A00
Registers.ds = VARSEG(DTA)
Registers.dx = VARPTR(DTA)
CALL INTERRUPTX(&H21, Registers, Registers)
END IF
'
' Find FIRST or NEXT entry
Dirspec$ = Dirspec$ + CHR$(0)
Registers.ax = SearchType%
Registers.cx = 22
Registers.ds = VARSEG(Dirspec$)
Registers.dx = SADD(Dirspec$)
CALL INTERRUPTX(&H21, Registers, Registers)
'
' Look after the INT21H call if matches are found
IF Registers.flags AND 1 THEN 'is CF set?
DirX% = NOTMOREFOUND
EXIT FUNCTION
END IF
'
' Do we have to apply a filter?
Result% = TRUE
SELECT CASE Filter%
CASE FILESONLY
IF DTA.Attributes% = 4096 THEN Result% = FALSE
CASE DIRSONLY
IF DTA.Attributes% <> 4096 THEN Result% = FALSE
END SELECT
'
IF Result% = TRUE THEN
' Remove the 0 byte that ends up the String in DTA.Filename
NullByte% = INSTR(DTA.Filename, CHR$(0))
IF NullByte% > 0 THEN
DTA.Filename = LEFT$(DTA.Filename, NullByte% - 1) + SPACE$(14 - NullByte%)
END IF
DirX% = ENTRYFOUND
ELSE
DirX% = ENTRYNOTMATCHEDFILTER
END IF
'
END FUNCTION

'
SUB ShowHeader
'
CLS
LOCATE 1, 1: PRINT "Name Type FileSize"
LOCATE 2, 1: PRINT "--------------------------------"
'
END SUB

'
SUB WriteFileInfo (LineNumber%)
'
LOCATE LineNumber%, 1: PRINT DTA.Filename
IF DTA.Attributes = 4096 THEN
LOCATE LineNumber%, 15: PRINT "<DIR>"
END IF
LOCATE LineNumber%, 24: PRINT DTA.FileSize
LineNumber% = LineNumber% + 1
'
IF LineNumber% = 23 THEN
LOCATE 23, 1: PRINT "<Press a key>": SLEEP
ShowHeader
LineNumber% = 3
END IF
'
END SUB

