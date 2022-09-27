'==================
'QB64SHORTCUT.BAS
'==================
'How to create a desktop shortcut for a QB64 program.
'This example creates a shortcut for the QB64.EXE file.
'It just a website shortcut pointing to the local file.
'For the QB64 Compiler.  Coded by Dav on DEC 6, 2010.
'Tested and works for me in Win2k, XP-Pro & Windows7.
'======================================================

'=== The EXE file to make shortcut for.
'=== Change this to another if you want.

FILE$ = "c:\qb64\qb64.exe"

'=== First, get Current User setting from Environment.
'=== (below creates a shortcut for the current users desktop)

A$ = ENVIRON$("HOMEDRIVE")
B$ = ENVIRON$("HOMEPATH")
C$ = A$ + B$

'=== If that doesn't work, try doing for all users.
'=== So all users will have the shortcut on the desktop.

IF C$ = "" THEN
    C$ = ENVIRON$("ALLUSERSPROFILE")
END IF

'=== If both ways fail, then this program fails.
'=== Sorry - this program relies on those settings.

IF C$ = "" THEN
    PRINT "Environment settings not found. Shortcut program cut short."
    END
END IF

'=== Make a .url of the filename.  We have to strip out the path
'=== (if given) and just get the EXE name.  Read backwards and if
'=== a "\" is found then stop building. (making a qb64.url file)

URLFILE$ = ""
FOR t = LEN(FILE$) TO 1 STEP -1
    D$ = MID$(FILE$, t, 1)
    IF D$ = "\" THEN EXIT FOR
    URLFILE$ = D$ + URLFILE$
NEXT

'=== Remove ".EXE" from the end and replace with ".url"

URLFILE$ = LEFT$(URLFILE$, LEN(URLFILE$) - 4) + ".url"

'=== Now make the Shortcut filename for the desktop.

SHORTCUT$ = C$ + "\Desktop\" + URLFILE$

'=== See if a Shortcut file already exists...
'=== If there's already one there, don't overwrite it.

OPEN SHORTCUT$ FOR APPEND AS #1
'=== (if filesize NOT Zero...)
IF LOF(1) THEN
    PRINT "ERROR: Shortcut not created.  One already exists!"
    PRINT "FILE>: "; SHORTCUT$
    CLOSE 1
    END
END IF

'=== Must not exist yet, so let's make one.
'=== Save Shortcut file info.

Q$ = CHR$(34) '(my own little shortcut...)

PRINT #1, "[InternetShortcut]"
PRINT #1, "URL = " + Q$ + "file://" + FILE$ + Q$
PRINT #1, "IconFile = " + Q$ + FILE$ + Q$
PRINT #1, "IconIndex = " + Q$ + "0" + Q$
CLOSE #1

PRINT "DONE: Shortcut Created!"
PRINT "FILE: "; SHORTCUT$
PRINT
PRINT "Check your Desktop for the Shortcut."



'=== IF all went well, you should see a qb64 shortcut on your desktop.
'=== Click it and see what happens.

'=== NOTE:  The Shortcut won't have the QB64 icon because QB64 programs
'===        don't yet have windows recognizable icons embedded in them.
'===        You can change the icon to your taste by right clicking it.
'===        Or, you can assign an icon with this program by customizing
'===        the line: PRINT #1, "IconFile = " + Q$ + FILE$ + Q$.
'===        Example : PRINT #1, "IconFile = " + Q$ + "c:\qb64\icon.ico" + Q$

END
 