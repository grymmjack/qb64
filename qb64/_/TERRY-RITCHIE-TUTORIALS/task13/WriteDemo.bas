DIM Ok$ ' response from user asking to overwrite file

IF _FILEEXISTS("HISCORES.TXT") THEN '               does file already exist?
    PRINT '                                         yes, ask permission to overwrite
    PRINT " HISCORES.TXT already exists!"
    PRINT
    LINE INPUT " Ok to overwrite? (yes/no): ", Ok$
    PRINT
END IF
IF UCASE$(LEFT$(Ok$, 1)) = "Y" THEN '               OK to overwrite?
    OPEN "HISCORES.TXT" FOR OUTPUT AS #1 '          yes, open sequential file for writing
    WRITE #1, "Fred Haise", 10000 '                 create CSV file entires
    WRITE #1, "Jim Lovell", 9000
    WRITE #1, "John Swigert", 8000
    WRITE #1, "Neil Armstrong", 7000
    WRITE #1, "Buzz Aldrin", 6000
    WRITE #1, "Gus Grissom", 5000
    WRITE #1, "Michael Collins", 4000
    WRITE #1, "Alan Shepard", 3000
    WRITE #1, "Ken Mattingly", 2000
    WRITE #1, "Edward White", 1000
    CLOSE #1 '                                      close the sequential file
    PRINT " New HISCORES.TXT file created." '       inform user
ELSE '                                              no
    PRINT " Original HISCORES.TXT file retained." ' inform user
END IF


