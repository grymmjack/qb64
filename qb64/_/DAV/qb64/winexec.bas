'===========
'WinExec.bas
'===========
'Uses Kernel32 WinAPI to execute a program in a QB64 program
'A SHELL Alternative...
'Coded by Dav

DECLARE LIBRARY
    Function WinExec (lpCmdLine As String, ByVal nCmdShow As Long)
END DECLARE

Way% = 1

'0 = Hides the window and activates another window.
'1 = Activates and displays a window. 
'2 = Activates the window and displays it as a minimized window.
'3 = Activates the window and displays it as a maximized window.

'NOTE: If you do 0 (hide), you'll have to Kill the process using your TaskManager...

'=== Open notepad and load samples.txt in the QB64 directory
Filename$ = "WinExec2.exe"

'NOTE: EXE filename must be a NULL terminates..CHR$(0)...


x = WinExec(Filename$ + CHR$(0), Way%)


'=== Show results if you want...

IF x = 0 THEN
   PRINT "System out of memory or resources."
ELSEIF x = 2 THEN
   PRINT "The specified file was not found."
ELSEIF x = 3 THEN
   PRINT "The specified path was not found."
ELSEIF x = 11 THEN
   PRINT "The file is invalid (non-Win32 .EXE or error in .EXE image)."
ELSEIF x > 31 THEN
   PRINT "Program opened normally."
ELSE
   PRINT "Unknown error: "; x
END IF
