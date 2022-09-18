TYPE HIGHSCORE '              type definition defining high scores
    Pname AS STRING * 15 '    player name
    Pscore AS INTEGER '       player score
END TYPE

REDIM Score(0) AS HIGHSCORE ' dynamic array to hold high scores

IF _FILEEXISTS("HISCORES.TXT") THEN '                           does high score file exist?
    OPEN "HISCORES.TXT" FOR INPUT AS #1 '                       yes, open sequential file
    PRINT "----------------------"
    PRINT "-- High Score Table --" '                            print high scores to screen
    PRINT "----------------------"
    WHILE NOT EOF(1) '                                          at end of file?
        REDIM _PRESERVE Score(UBOUND(Score) + 1) AS HIGHSCORE ' increase dynamic array index by one
        INPUT #1, Score(UBOUND(Score)).Pname, Score(UBOUND(Score)).Pscore ' get data from file
        PRINT Score(UBOUND(Score)).Pname; " -"; '               display player name
        PRINT Score(UBOUND(Score)).Pscore '                     display player score
    WEND '                                                      loop back to WHILE
    CLOSE #1 '                                                  close the file
    PRINT UBOUND(Score); " total scores found" '                display number of scores found
ELSE '                                                          no, the file does not exist
    PRINT "High score file not found!" '                        inform player of the error
END IF

