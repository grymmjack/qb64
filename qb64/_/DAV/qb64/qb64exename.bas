'===============
'QB64EXENAME.BAS v1.1
'===============
'Coded by Dav for QB64
'August 29th, 2011

' UPDATED FOR CURRENT COMPILER

'Scans QB64 compiled EXE's to read the original EXE name.
'The EXE name is right before the first occurrence of "InputMethod_GetCurrentChar"
'placed between CHR$(0) charaters.  This program locates that 
'marker and builds the EXE name (reading it backwards...).

DEFINT A-Z

PRINT
PRINT "==========="
PRINT "QB64EXENAME"
PRINT "==========="
PRINT
PRINT "Scans QB64 EXE's for original EXE name."
PRINT

INPUT "Name of QB64 compiled EXE to scan -> ", EXE$

'=== OPEN EXE...

IF EXE$ = "" THEN END
OPEN EXE$ FOR BINARY AS #1
IF LOF(1) = 0 THEN
    PRINT "ERROR: " + EXE$ + " NOT FOUND!"
    CLOSE: KILL EXE$: END
END IF

'=== Deep scan EXE for first "InputMethod_GetCurrentChar"

FOR place& = 1 TO LOF(1)
    '=== grab a byte...
    SEEK #1, place&
    A$ = INPUT$(1, 1)
    PRINT "Scanning: " + STR$(CINT(place& / LOF(1) * 100)) + "%"
    LOCATE CSRLIN - 1, 1
    '=== nibble for an I
    IF A$ = "I" THEN
        A2$ = INPUT$(25, 1)
        '=== If I then nibble for rest
        IF A2$ = "nputMethod_GetCurrentChar" THEN
            '=== found? Go back 2 bytes before where it's found
            SEEK #1, place& - 2
            '=== Read file backwards until CHR$(0) found, rebuild name.
            c$ = ""
            FOR t = 1 TO 256
                d$ = INPUT$(1, 1)
                IF d$ = CHR$(0) THEN EXIT FOR
                c$ = d$ + c$
                hmm& = SEEK(1)
                SEEK #1, hmm& - 2
            NEXT
            PRINT: PRINT "Original EXE name: "; c$
            EXIT FOR
        END IF
    END IF
    IF INKEY$ <> "" THEN PRINT "CANCELLED!": EXIT FOR
NEXT

IF c$ = "" THEN
    PRINT
    PRINT "Doesn't look like it's there, or not a QB64 EXE..."
END IF

CLOSE: END

 