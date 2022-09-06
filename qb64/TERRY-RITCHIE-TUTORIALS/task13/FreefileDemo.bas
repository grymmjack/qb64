DIM FileHandle& ' file handle value
DIM MyData$ '     data retrieved from file

IF _FILEEXISTS("HISCORES.TXT") THEN '               file exist?
    FileHandle& = FREEFILE '                        yes, get a file handle
    OPEN "HISCORES.TXT" FOR INPUT AS #FileHandle& ' open file using handle
    WHILE NOT EOF(FileHandle&) '                    end of file?
        INPUT #FileHandle&, MyData$ '               no, get data from file
        PRINT MyData$ '                             print data to screen
    WEND
    CLOSE #FileHandle& '                            close file
END IF




