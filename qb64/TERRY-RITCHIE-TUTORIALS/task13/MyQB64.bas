CONST WHITE = _RGB32(255, 255, 255) '   define white
DIM NextValue% '                        next command value
DIM Handle& '                           free file handle
DIM sx%, sy%, x%, y% '                  polygon coordinate pairs
DIM r%, g%, b% '                        color attributes
DIM Count% '                            polygon point counter

SCREEN _NEWIMAGE(640, 480, 32)
IF _FILEEXISTS("POINTDATA.XYP") THEN '            does data file exist?
    Handle& = FREEFILE '                                            yes, get a free file handle
    OPEN "POINTDATA.XYP" FOR INPUT AS #Handle& '  open the data file
    DO '                                                            main program loop
        INPUT #Handle&, NextValue% '                                get next command value
        IF NextValue% > 0 THEN '                                    end of data?
            INPUT #Handle&, sx%, sy% '                              no, get start coordinate of polygon
            PSET (sx%, sy%), WHITE '                                set the start point
            FOR Count% = 1 TO NextValue% - 1 '                      cycle through remaining coordinates
                INPUT #Handle&, x%, y% '                            get next polygon coordinate
                LINE -(x%, y%), WHITE '                             draw line from previous coordinate
            NEXT Count% '
            LINE -(sx%, sy%), WHITE '                               close the polygon
        ELSEIF NextValue% = -1 THEN '                               perform paint command?
            INPUT #Handle&, x%, y%, r%, g%, b% '                    yes, get coordinate and color attributes
            PAINT (x%, y%), _RGB32(r%, g%, b%), WHITE '             paint the polygon
        ELSE '                                                      must be 0 meaning end of data
            CLOSE #Handle& '                                        close the data file
            SLEEP '                                                 wait for keystroke
            SYSTEM '                                                return to operating system
        END IF
    LOOP
END IF

