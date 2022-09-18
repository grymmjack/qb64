TYPE HIGHSCORE '           type definition defining high scores
    Pname AS STRING * 15 ' player name
    Pscore AS INTEGER '    player score
END TYPE

DIM Score AS HIGHSCORE '   a score line from CSV file
DIM NewName$ '             name of new player to add to high score list
DIM NewScore% '            new player's score to add to high score list

NewName$ = "Edgar Mitchell" '                           new player's name
NewScore% = 5500 '                                      new player's score
IF _FILEEXISTS("HISCORES.TXT") THEN '                   high score file exist?
    OPEN "HISCORES.TXT" FOR INPUT AS #1 '               yes, open high score file for INPUT
    OPEN "TEMP.TXT" FOR OUTPUT AS #2 '                  open temporary file for OUTPUT
    WHILE NOT EOF(1) '                                  end of high score file?
        INPUT #1, Score.Pname, Score.Pscore '           no, read a line from file
        IF Score.Pscore <= NewScore% THEN '             is this score less than the new score?
            WRITE #2, NewName$, NewScore% '             yes, insert the new player here
            PRINT NewName$, NewScore%; " <-- Insert"
            NewScore% = 0 '                             reset new score so IF can't happen again
        END IF
        WRITE #2, _TRIM$(Score.Pname), Score.Pscore '   write the original file's score line
        PRINT Score.Pname, Score.Pscore
    WEND
    CLOSE #2, #1 '                                      close both files
    KILL "HISCORES.TXT" '                               delete the original file
    NAME "TEMP.TXT" AS "HISCORES.TXT" '                 rename the temp file to the original name
ELSE '                                                  no, high score file not present
    PRINT "High score file not found!" '                inform player
END IF







