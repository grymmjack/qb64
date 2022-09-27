'===========
'EXENAME.BAS
'===========
'Uses a WinAPI to get name of running EXE.
'Coded by Dav for QB64

DECLARE LIBRARY
    FUNCTION GetModuleFileNameA (BYVAL hModule AS LONG, lpFileName AS STRING, BYVAL nSize AS LONG)
END DECLARE

DIM FileName AS STRING * 256

Ret = GetModuleFileNameA(0, FileName, LEN(FileName))

'====  NOTE: If Ret > 0 then it was succesful, and Ret vale now holds the
'====        number of characters in the FileName buffer (length of FileName).

IF Ret > 0 THEN
    ExeName$ = LEFT$(FileName$, Ret)
    PRINT "Currently running EXE name: " + ExeName$
END IF

SLEEP