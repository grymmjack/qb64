$DEBUG
$CONSOLE:ONLY

IF _COMMANDCOUNT = 0 THEN
    PRINT
    PRINT "INCDEC: Increments or decrements a number in a text file."
    PRINT
    PRINT "USAGE: INCDEC FILENAME [INC]|DEC {AMOUNT}"
    PRINT
    PRINT "WHERE:"
    PRINT "  FILENAME       the absolute path to text file"
    PRINT
    PRINT "  [INC]|DEC      operation to perform:"
    PRINT "                     INC(rement): Add to existing number"
    PRINT "                     DEC(rement): Subtract from existing number"
    PRINT
    PRINT "  {AMOUNT}       (optional) is the amount to (inc|dec)rement"
    PRINT
    PRINT "EXAMPLES:"
    PRINT
    PRINT "INCDEC C:\PATH_TO\number.txt DEC 1"
    PRINT "INCDEC C:\PATH_TO\number.txt INC 10"
    PRINT
    PRINT "NOTES:"
    PRINT "If the file does not exist, the program does nothing."
    PRINT "If the file exists but is empty the new number will be 1."
    PRINT "If the decrement operation would be negative or 0, number will be 1."
    PRINT


ELSE
    DIM AS STRING TEXTFILE, NUMBER, OPERATION
    DIM AS INTEGER NEW_NUMBER, AMOUNT

    ' Parse command line: FILENAME
    TEXTFILE$ = COMMAND$(1)
    IF NOT _FILEEXISTS(TEXTFILE$) THEN
        PRINT "INCDEC: Error - FILENAME: " + TEXTFILE$ + " does not exist!"
        PRINT "Aborting..."
        SYSTEM
    END IF

    ' Parse command line: OPERATION
    IF _COMMANDCOUNT >= 2 THEN
        OPERATION$ = UCASE$(COMMAND$(2))
        IF OPERATION$ <> "INC" AND OPERATION$ <> "DEC" THEN
            OPERATION$ = "INC"
        END IF
    ELSE
        OPERATION$ = "INC"
    END IF

    ' Parse command line: AMOUNT
    IF _COMMANDCOUNT = 3 THEN
        AMOUNT% = VAL(COMMAND$(3))
    ELSE
        AMOUNT% = 1
    END IF

    ' Get existing number from FILENAME
    OPEN TEXTFILE$ FOR INPUT AS #1
        WHILE NOT EOF(1)
            LINE INPUT #1, NUMBER$
        WEND
    CLOSE #1

    ' Operate on number
    SELECT CASE OPERATION$
        CASE "INC":
            ' Increment number
            NEW_NUMBER% = VAL(NUMBER$)
            NEW_NUMBER% = NEW_NUMBER% + AMOUNT%
        CASE "DEC":
            ' Decrement number
            NEW_NUMBER% = VAL(NUMBER$)
            IF NEW_NUMBER% - AMOUNT% > 0 THEN
                NEW_NUMBER% = NEW_NUMBER% - AMOUNT%
            ELSE
                NEW_NUMBER% = 1
            END IF
    END SELECT

    ' Store new number to FILENAME
    OPEN TEXTFILE$ FOR OUTPUT AS #1
        PRINT #1, _TRIM$(STR$(NEW_NUMBER%))
    CLOSE #1
END IF

SYSTEM
