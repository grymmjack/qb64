FileName$ = "HISCORES.TXT"
Search$ = "5000"

IF _FILEEXISTS(FileName$) THEN '                does file exist?
    SearchFile% = FREEFILE '                    yes, get a free handle number
    OPEN FileName$ FOR BINARY AS #SearchFile% ' open the file for binary input
    Contents$ = SPACE$(LOF(SearchFile%)) '      create a record the same length as file
    GET #SearchFile%, , Contents$ '             get the record (the entire file!)
    CLOSE #SearchFile% '                        close the file
    IF INSTR(Contents$, Search$) THEN '         was search term found?
        Inspect% = -1 '                         yes, return true
        PRINT "Found!"
    END IF
END IF

