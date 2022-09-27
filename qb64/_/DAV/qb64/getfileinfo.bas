'===============
'GETFILEINFO.BAS
'===============
'Gets File & Dir Attributes (and FileExist)
'Uses a built-in function to get the info.
'Doesn't use SHELL and creates NO TEMP files.
'Requires QB64 V0.923 or greater.
'============================================


DECLARE LIBRARY
    FUNCTION GetFileAttributes (filename AS STRING)
END DECLARE

DECLARE FUNCTION GETFILEINFO%(FileName$)


'=== Example code, Check if a file/dir exists.

file$ = "c:\qb64\qb64.exe"
Result% = GETFILEINFO(file$)
IF Result% = 0 THEN
    PRINT file$ + " NOT found!"
ELSE
    PRINT file$ + " found!"
END IF


'=== Report Attributes of file/Dir found

IF Result% > 0 THEN
    PRINT "Attributes: ";
    SELECT CASE Result%
        '(file, Dir)
        CASE 1, 17: PRINT "(R)"
        CASE 2, 18: PRINT "(H)"
        CASE 3, 19: PRINT "(R+H)"
        CASE 4, 20: PRINT "(S)"
        CASE 5, 21: PRINT "(R+S)"
        CASE 6, 22: PRINT "(H+S)"
        CASE 32, 48: PRINT "(A)"
        CASE 33, 49: PRINT "(A+R)"
        CASE 34, 50: PRINT "(A+H)"
        CASE 35, 51: PRINT "(A+R+H)"
        CASE 36, 52: PRINT "(A+S)"
        CASE 37, 53: PRINT "(A+R+S)"
        CASE 39, 55: PRINT "(A+R+S+H)"
        CASE 128, 16: PRINT "(No Attributes set)"
        CASE ELSE: PRINT Result%
    END SELECT
END IF

'=================================================
FUNCTION GETFILEINFO% (FileName$)
IF FileName$ = "" THEN
    GETFILEINFO% = 0
ELSE
    GETFILEINFO% = GetFileAttributes(FileName$)
END IF
END FUNCTION
'=================================================