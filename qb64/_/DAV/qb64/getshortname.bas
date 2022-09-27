'================
'GETSHORTNAME.BAS
'================
'Gets File/Path Short name (8.3).
'Can also use as a FileExist routine.
'Coded by Dav. Uses Win API.

DECLARE LIBRARY
    FUNCTION GetShortPathNameA (lpszLongPath AS STRING, lpszShortPath AS STRING, BYVAL cchBuffer AS LONG)
END DECLARE

FileOrPath$ = "c:\qb64\SDL_image.dll"

ShortPathName$ = SPACE$(260)
Result = GetShortPathNameA(FileOrPath$ + CHR$(0), ShortPathName$, LEN(ShortPathName$))

IF Result > 0 THEN
    PRINT "Yes, it's there. Here's the short name: "; ShortPathName$
ELSE
    PRINT "No, it's not there."
END IF

