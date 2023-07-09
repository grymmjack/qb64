 
'by mnrvovrfc 6-July-2023
OPTION _EXPLICIT
 
DIM AS INTEGER c, lsubj, j, plu
DIM prefx$, afile$, launchprog$, comd$, asubj$, ayear$, entry$
DIM fe AS LONG
 
prefx$ = "helparchorg-"
afile$ = prefx$ + "browser.txt"
IF NOT _FILEEXISTS(afile$) THEN
    PRINT "The web browser wasn't found! Aborting."
    END
END IF
 
fe = FREEFILE
OPEN afile$ FOR INPUT AS fe
DO UNTIL EOF(fe)
    LINE INPUT #fe, entry$
    entry$ = _TRIM$(entry$)
    IF entry$ <> "" AND launchprog$ = "" THEN
        launchprog$ = entry$
        EXIT DO
    END IF
LOOP
CLOSE fe
 
IF NOT _FILEEXISTS(launchprog$) THEN
    PRINT "The web browser wasn't found! Aborting."
    END
END IF
 
PRINT "Discovered web browser executable called:"
PRINT launchprog$
 
afile$ = prefx$ + "subject.txt"
IF NOT _FILEEXISTS(afile$) THEN
    afile$ = prefx$ + "category.txt"
END IF
IF _FILEEXISTS(afile$) THEN
    fe = FREEFILE
    OPEN afile$ FOR INPUT AS fe
    DO UNTIL EOF(fe)
        LINE INPUT #fe, entry$
        entry$ = _TRIM$(entry$)
        IF entry$ <> "" THEN lsubj = lsubj + 1
    LOOP
    CLOSE fe
    IF lsubj < 1 THEN
        PRINT "At least one entry required from input file!"
        END
    END IF
    REDIM subj(1 TO lsubj) AS STRING
    c = 0
    fe = FREEFILE
    OPEN afile$ FOR INPUT AS fe
    DO UNTIL EOF(fe)
        LINE INPUT #fe, entry$
        entry$ = _TRIM$(entry$)
        IF entry$ <> "" THEN
            c = c + 1
            subj(c) = entry$
        END IF
    LOOP
    CLOSE fe
ELSE
    lsubj = 1
    REDIM subj(1 TO lsubj) AS STRING
    subj(lsubj) = "electronic"
END IF
 
PRINT "*** archive-dot-org helper ***"
IF lsubj = 1 THEN
    PRINT: PRINT "There's only one category available: "; subj(1)
    asubj$ = subj(1)
ELSE
    PRINT: PRINT "Please choose your category."
    FOR j = 1 TO lsubj
        PRINT USING "(##)"; j;
        PRINT " "; subj(j)
    NEXT
    LINE INPUT entry$
    entry$ = _TRIM$(entry$)
    IF entry$ = "" THEN SYSTEM
    c = VAL(entry$)
    IF c > 0 AND c <= lsubj THEN
        asubj$ = subj(c)
    ELSE
        PRINT "Incorrect input given! Aborting."
        END
    END IF
END IF
 
PRINT: PRINT "Please choose the year of release."
FOR j = 2013 TO 2023
    PRINT USING "(####)"; j - 2012;
    PRINT " "; j
NEXT
LINE INPUT entry$
entry$ = _TRIM$(entry$)
IF entry$ = "" THEN SYSTEM
c = VAL(entry$)
IF c > 0 AND c < 12 THEN
    ayear$ = _TRIM$(STR$(c + 2012))
ELSE
    PRINT "Incorrect input given! Aborting."
    END
END IF
 
comd$ = CHR$(34) + launchprog$ + CHR$(34) + " https://archive.org/details/audio?and[]=year%3A%22" + ayear$ + _
"%22&and[]=mediatype%3A%22audio%22&and[]=subject%3A%22"
plu = INSTR(asubj$, "+")
IF plu > 0 THEN
    comd$ = comd$ + LEFT$(asubj$, plu - 1) + "%22&and[]=subject%3A%22" + MID$(asubj$, plu + 1) + "%22"
ELSE
    comd$ = comd$ + asubj$ + "%22"
END IF
PRINT launchprog$
PRINT comd$
SLEEP
SHELL _HIDE _DONTWAIT comd$
SYSTEM