SCREEN _NEWIMAGE(320,200, 32)
_FULLSCREEN _SQUAREPIXELS

LineThick 0, 0, 120, 100,   &HFFFFFFFF, 5 ' \
LineThick 0, 100, 120, 0,   &HFFFFFFFF, 5 ' /
LineThick 0, 48, 120, 48,   &HFFFFFFFF, 4 ' -
LineThick 60, 0, 60, 100,   &HFFFFFFFF, 4 ' |

LineThick 30, 0, 90, 100,   &HFFFFFFFF, 5 ' \
LineThick 30, 100, 90, 0,   &HFFFFFFFF, 5 ' /

LineThick 0, 30, 120, 70,   &HFFFFFFFF, 5 ' \
LineThick 0, 70, 120, 30,   &HFFFFFFFF, 5 ' / 

SUB LineThick (startX%, startY%, endX%, endY%, lineColor&, thickness%)
    FOR i% = 0 TO thickness%
        IF startY% = endY% THEN ' Drawing a horizontal line
            LINE (startX%, startY% + i%)-(endX%, endY% + i%), lineColor&
        ELSE ' X based drawing required for thickness
            LINE (startX% + i%, startY%)-(endX% + i%, endY%), lineColor&
        END IF
    NEXT i%
END SUB