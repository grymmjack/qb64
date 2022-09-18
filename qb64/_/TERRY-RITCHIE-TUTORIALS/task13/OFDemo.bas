REDIM HSname$(0) '  high score player names
REDIM HScore%(0) '  high scores
DIM Count% '        index counter

IF _FILEEXISTS("HISCORES.TXT") THEN '                  does high score file exist?
    OPEN "HISCORES.TXT" FOR INPUT AS #1 '              yes, open sequential file
    PRINT "----------------------"
    PRINT "-- High Score Table --" '                   print high scores to screen
    PRINT "----------------------"
    Count% = 0 '                                       initialize index counter
    WHILE NOT EOF(1) '                                 at end of file?
        Count% = Count% + 1 '                          no, increment index counter
        REDIM _PRESERVE HSname$(Count%) '              increase size of name array
        REDIM _PRESERVE HScore%(Count%) '              increase size of score array
        INPUT #1, HSname$(Count%) '                    get name from file
        INPUT #1, HScore%(Count%) '                    get score from file
        PRINT HSname$(Count%); " -"; HScore%(Count%) ' print the name and score
    WEND '                                             loop back to WHILE
    CLOSE #1 '                                         close the file
ELSE '                                                 no, the file does not exist
    PRINT "High score file not found!" '               inform player of the error
END IF

