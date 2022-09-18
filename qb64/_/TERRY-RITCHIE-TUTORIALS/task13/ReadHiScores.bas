DIM HSname$(3) '  high score player names
DIM HScore%(3) '  high scores
DIM Count% '      generic counter

IF _FILEEXISTS("HISCORES.TXT") THEN '                  does high score file exist?
    OPEN "HISCORES.TXT" FOR INPUT AS #1 '              yes, open sequential file
    PRINT "----------------------"
    PRINT "-- High Score Table --" '                   print high score table header
    PRINT "----------------------"
    FOR Count% = 1 TO 3 '                              get 3 names and values
        INPUT #1, HSname$(Count%) '                    get name from file
        INPUT #1, HScore%(Count%) '                    get score from file
        PRINT HSname$(Count%), " -"; HScore%(Count%) ' print the name and score
    NEXT Count%
    CLOSE #1 '                                         close the file
ELSE '                                                 no, the file does not exist
    PRINT "High score file not found!" '               inform player of the error
END IF

