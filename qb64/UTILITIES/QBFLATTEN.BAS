$DEBUG
$CONSOLE:ONLY

CONST MAX_INCLUDES = 10000

TYPE INCLUDE_FILE
    file              AS STRING
    fileNum           AS INTEGER
    fileExists        AS INTEGER
    includedByFile    AS STRING
    includedOnLineNum AS INTEGER
    hasBeenFlattened  AS INTEGER
END TYPE

DIM SHARED INCLUDES(1 TO MAX_INCLUDES) AS INCLUDE_FILE
DIM SHARED AS STRING sourceFile, flatFile, sourceLine
DIM SHARED AS INTEGER fileNum, lineNum, includeNum

IF _COMMANDCOUNT = 0 THEN
    PRINT
    PRINT "QBFLATTEN: Flatten a QB64 includes into one file."
    PRINT
    PRINT "USAGE: QBFLATTEN FILENAME.BAS"
    PRINT
    PRINT "WHERE:"
    PRINT "  FILENAME is the absolute path to bas file"
    PRINT
    PRINT "EXAMPLE:"
    PRINT "QBFLATTEN C:\PATH_TO\project.bas"
    PRINT
    PRINT "Will examine project.bas, find all '$INCLUDE:' directives, and"
    PRINT "comment out the '$INCLUDE:' and dump the contents of the file it"
    PRINT "points to under it. It will do this recursively using the BAS file"
    PRINT "as a starting point until it finishes evaluating the entirety of all"
    PRINT "include files. "
    PRINT
    PRINT "NOTES:"
    PRINT "- This works with files included that include other includes."
    PRINT "- This honors $IF directive guards to prevent include more than once."
    PRINT "- If the file does not exist, the program does nothing."
    PRINT "- If the file is not a QB64 source file, the program does nothing."
    PRINT
ELSE   
    ' Parse command line: FILENAME
    sourceFile$ = COMMAND$(1)
    IF NOT _FILEEXISTS(sourceFile$) THEN
        PRINT "QBFLATTEN: Error - FILENAME: " + sourceFile$ + " does not exist!"
        PRINT "Aborting..."
        SYSTEM
    END IF

    ' Parse the sourceFile
    OPEN sourceFile$ FOR INPUT AS #1
    WHILE NOT EOF(1)
        LINE INPUT #1, sourceLine$
        'IF INSTR("'$INCLUDE:", sourceLine$) THEN
    WEND

    ' Open file for output
    OPEN flatFile$ FOR OUTPUT AS #2
    
    CLOSE #1 : CLOSE #2
END IF
SYSTEM


''
' Pushes an include onto the INCLUDES array
' @param INTEGER includeNum% the include array index
' @param STRING file$ name of include file
' @param INTEGER fileNum% the number of the file found
' @param INTEGER fileExists% does the file exist?
' @param STRING includedByFile$ which file included this file?
' @param INTEGER includedOnLineNum% on which line number was it included?
' 
SUB INCLUDE_push (includeNum%, file$, fileNum%, fileExists%, includedByFile$, _
                  includedOnLineNum%, hasBeenFlattened%)
    IF includeNum% = 0 THEN 
        includeNum% = 1
    ELSEIF includeNum% > MAX_INCLUDES THEN 
        PRINT "MAX_INCLUDES REACHED! "; MAX_INCLUDES; ". ABORTING!"
        PRINT STRING$(80, "-")
        PRINT "FILE: "; file$
        PRINT "FILE #: "; fileNum%
        PRINT "FILE EXISTS: "; fileExists%
        PRINT "INCLUDED BY: "; includedByFile$
        PRINT "INCLUDED ON LINE #: "; includedOnLineNum%
        SYSTEM
    ELSE
        INCLUDES(includeNum%).file$ = file$
        INCLUDES(includeNum%).fileNum% = fileNum%
        INCLUDES(includeNum%).fileExists% = fileExists%
        INCLUDES(includeNum%).includedByFile$ = includedByFile$
        INCLUDES(includeNum%).includedOnLineNum% = includedOnLineNum%
        INCLUDES(includeNum%).hasBeenFlattened% = hasBeenFlattened%
    END IF
END SUB


''
' Returns an included file as a string
' @param INTEGER includeNum% from the INCLUDES array
' @return STRING
' 
FUNCTION INCLUDE$ (includeNum%)
    DIM inc AS INCLUDE_FILE
    IF includeNum% > 0 AND includeNum% <= MAX_INCLUDES THEN
        inc = INCLUDES(includeNum%)
        DIM s as STRING
        s$  = "INCLUDE(" + _TRIM$(STR$(includeNum%)) _
            +  inc.file$ + "," _
            +  _TRIM$(STR$(inc.fileNum%)) + "," _
            +  _TRIM$(STR$(inc.fileExists%)) + "," _
            +  inc.includedByFile$ + "," _
            +  _TRIM$(STR$(inc.includedOnLineNum%)) + "," _
            +  _TRIM$(STR$(inc.hasBeenFlattened%)) + ","
        INCLUDE$ = s$
    END IF
END FUNCTION
