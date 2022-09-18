'--------------------------------
'- Variable declaration section -
'--------------------------------

DIM Cstep% '    FOR...NEXT step value
DIM Count% '    FOR...NEXT count value
DIM NextStep$ ' user input for next step

'----------------------------
'- Main program begins here -
'----------------------------

FOR Cstep% = 1 TO 4
    CLS
    PRINT "Counting from 0 to 12 by steps of"; Cstep%
    PRINT
    FOR Count% = 0 TO 12 STEP Cstep%
        PRINT Count%
    NEXT Count%
    PRINT
    IF Cstep% < 4 THEN
        INPUT "Press ENTER for the next STEP value", NextStep$
    END IF
NEXT Cstep%


