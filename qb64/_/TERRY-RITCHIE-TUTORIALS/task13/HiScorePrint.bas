OPEN "HISCORES.TXT" FOR OUTPUT AS #1 ' open sequential file for writing
PRINT #1, "Fred Haise" '               write individual lines of data to file
PRINT #1, 10000
PRINT #1, "Jim Lovell"
PRINT #1, 9000
PRINT #1, "John Swigert"
PRINT #1, 8000
CLOSE #1 '                             close the sequential file


