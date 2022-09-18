'--------------------------------
'- Variable declaration section -
'--------------------------------

DIM Hour% ' the current hour of the day

'----------------------------
'- Main program begins here -
'----------------------------

Hour% = VAL(TIME$) '                    get the current hour
SELECT CASE Hour% '                     what is the current hour?
    CASE IS < 12 '                      is it less than 12?
        PRINT "Good Morning World!" '   yes, it must be morning
    CASE 12 TO 17 '                     is it 12 to 17?
        PRINT "Good Afternoon World!" ' yes, it must be afternoon
    CASE IS > 17 '                      is it greater than 17?
        PRINT "Good Evening World!" '   yes, it must be evening
END SELECT



