' ===========
' FIXCMD$.BAS
' ===========
' Coded by Dav

' Patches QuickBASIC 4.5 files QB.EXE and BCOM45.LIB
' to make COMMAND$ to return true command-line switches.
' With this fix COMMAND$ will preseve upper & lower case.
'
' ======================================================
' NOTE: This patch is ONLY for the files that came with
' QuickBASIC 4.5, and WILL NOT work on other versions!!
' ======================================================

' USE AT YOUR OWN RISK - AND MAKE BACKUPS BEFORE USING!!

DEFINT A-Z

PRINT
PRINT "============================================================="
PRINT " This program will patch the QB.EXE and BCOM45.LIB files and "
PRINT " permanently make COMMAND$ to return the true command-line. "
PRINT " Have you first made backups, and now want to continue? (Y/N)"
PRINT "============================================================="
PRINT

A$ = UCASE$(INPUT$(1))
IF A$ <> "Y" THEN PRINT "Aborted.": END

'=== First, attempt to patch QB.EXE.
'=== QB.EXE file size should be 278,804 bytes

'=== Make the fixed data to replace original.
'=== This data will be used for both files.

Fix$ = CHR$(144) + CHR$(144)

OPEN "QB.EXE" FOR BINARY AS 1
SELECT CASE LOF(1)
    CASE IS = 0
       PRINT "QB.EXE not found."
       CLOSE 1
       KILL "QB.EXE"
    CASE IS = 278804
       PRINT "Patching QB.EXE...";
       PUT #1, 155068, Fix$
       PRINT "Done!"
    CASE ELSE
       PRINT "QB.EXE NOT patched. Wrong file size."
END SELECT
CLOSE 1

'=== Now, attempt to patch BCOM45.LIB
'=== BCOM45.LIB file size should be 220,919 bytes

Fix$ = CHR$(144) + CHR$(144)
OPEN "BCOM45.LIB" FOR BINARY AS 1
SELECT CASE LOF(1)
    CASE IS = 0
       PRINT "BCOM45.LIB not found."
       CLOSE 1
       KILL "BCOM45.LIB"
    CASE IS = 220919
       PRINT "Patching BCOM45.LIB...";
       PUT #1, 32593, Fix$
       PRINT "Done!"
    CASE ELSE
       PRINT "BCOM45.LIB NOT patched. Wrong file size."
END SELECT
CLOSE 1

END