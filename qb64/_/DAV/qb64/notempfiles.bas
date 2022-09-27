
' ===============
' NoTempFiles.bas v1.1
' ===============
' Coded by Dav/2010

' This QB64 program will patch the libmn.a file to prevent
' compiled QB64 programs from creating the stderr.txt & stdout.txt
' temp files. This fix is needed if you plan on running QB64 programs
' from read-only medium such as a CD/DVD or locked SD card.

' You'll have to recompile your programs after running this patch
' for them to be fixed an not create the temp files when running.

' THIS IS A QB64 HACK AND IS NOT SUPPORTED BY THE QB64 PROJECT.
' RUN THIS PROGRAM IN THE SAME DIRECTORY AS QB64.EXE IS LOCATED.

' MAKE A BACKUP OF LIBMN.A YOURSELF.

DEFINT A-Z

CLS

PRINT
PRINT "======================"
PRINT "Patch libmn.a for QB64"
PRINT "======================"
PRINT

PRINT "Loading file............";
OPEN "internal\c\l\libmn.a" FOR BINARY AS #1

IF LOF(1) = 0 THEN
PRINT "Not found!"
PRINT "Please run from within the QB64.EXE directory."
CLOSE 1: KILL File$
END
ELSE
PRINT "OK!"
END IF

PRINT "Checking filesize.......";
IF LOF(1) <> 207032 THEN
PRINT "ABORTED: Invalid libmn.a filesize."
CLOSE
END
ELSE
PRINT "OK!"
END IF


PRINT "Continue with Patch? (Y/N)"
DO
   HUH$ = UCASE$(INPUT$(1))
   IF HUH$ ="N" THEN 
     PRINT "Cancelled!": END
   END IF
   IF HUH$ = "Y" THEN EXIT DO
LOOP


Old$ = SPACE$(11)
New$ = STRING$(11, CHR$(0))

GET #1, 204604, Old$

IF Old$ = "/stdout.txt" THEN
PRINT "Patching 1st location...";
PUT #1, 204604, New$
PRINT "OK!"
ELSE
PRINT
PRINT "ABORTED: Data not found, or the file's already patched."
CLOSE
END
END IF

GET #1, 204618, Old$

IF Old$ = "/stderr.txt" THEN
PRINT "Patching 2nd location...";
PUT #1, 204618, New$
PRINT "OK!"
ELSE
PRINT
PRINT "ABORTED: Data not found, or the file's already patched."
CLOSE
END
END IF

CLOSE

PRINT
PRINT "Done!"

END