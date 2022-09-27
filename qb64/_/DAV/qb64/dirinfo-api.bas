'====================
'DIRINFO-API.BAS
'====================
'Get some Directory Information using KERNEL32 WIN API
'Adapted by Dav from various info found on the net.
'Requires QB64 V0.923 or greater.
'=====================================================

DECLARE LIBRARY
    '=====================
    'KERNEL32 DIR FUNCTIONS
    '=====================
    FUNCTION GetWindowsDirectory ALIAS GetWindowsDirectoryA (lpBuffer AS STRING, BYVAL nSize AS LONG)
    FUNCTION GetSystemDirectory ALIAS GetSystemDirectoryA (lpBuffer AS STRING, BYVAL nSize AS LONG)
    FUNCTION GetCurrentDirectory ALIAS GetCurrentDirectoryA (BYVAL nBufferLength AS LONG, lpBuffer AS STRING)
    FUNCTION GetTempPath ALIAS GetTempPathA (BYVAL nBufferLength AS LONG, lpBuffer AS STRING)
    '========================================================================================
END DECLARE

'=== SHOW WINDOWS DIRECTORY

WinDir$ = SPACE$(144)
Result = GetWindowsDirectory(WinDir$, LEN(WinDir$))
IF Result THEN
    PRINT "WINDOWS DIRECTORY: "; RTRIM$(LTRIM$(WinDir$))
END IF

'=== SHOW SYSTEM DIRECTORY

SysDir$ = SPACE$(144)
Result = GetSystemDirectory(SysDir$, LEN(SysDir$))
IF Result THEN
    PRINT "SYSTEM DIRECTORY : "; RTRIM$(LTRIM$(SysDir$))
END IF

'=== SHOW CURRENT DIRECTORY

CurDir$ = SPACE$(255)
Result = GetCurrentDirectory(LEN(CurDir$), CurDir$)
IF Result THEN
    PRINT "CURRENT DIRECTORY: "; RTRIM$(LTRIM$(CurDir$))
END IF

'=== SHOW TEMP DIRECTORY

TempDir$ = SPACE$(100)
Result = GetTempPath(LEN(TempDir$), TempDir$)
IF Result THEN
    PRINT "TEMP DIRECTORY   : "; RTRIM$(LTRIM$(TempDir$))
END IF