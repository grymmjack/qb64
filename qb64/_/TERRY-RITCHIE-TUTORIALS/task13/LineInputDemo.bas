OPEN "HISCORES.TXT" FOR INPUT AS #1
WHILE NOT EOF(1)
    LINE INPUT #1, a$
    PRINT a$
WEND
CLOSE #1


