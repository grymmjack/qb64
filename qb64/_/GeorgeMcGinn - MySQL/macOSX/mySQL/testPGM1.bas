IF _FILEEXISTS("sqlTemp.txt") THEN
    f1% = FREEFILE: rows = 0
    OPEN "sqlTemp.txt" FOR INPUT AS #f1%
    DO UNTIL EOF(f1%)
        LINE INPUT #f1%, qString$
        PRINT "QB64: "; qString$
        rows = rows + 1
    LOOP
    CLOSE #f1%
    PRINT "QB64: Number of tables found ="; rows
ELSE
    PRINT "QB64: sqlTemp.txt file not found. Please check and run again."
    SYSTEM 99
END IF

