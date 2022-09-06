'--------------------------------
'- Variable declaration section -
'--------------------------------

DIM Hour% ' the current hour of the day

'----------------------------
'- Main program begins here -
'----------------------------

Hour% = VAL(TIME$) '                get the current hour (military time 0-23)
IF Hour% < 12 THEN '                is current hour less than 12? (before noon)
    PRINT "Good Morning World!" '   yes, it must be morning
END IF
IF Hour% > 11 AND Hour% < 18 THEN ' is current hour 12 to 17? (noon to 5PM)
    PRINT "Good Afternoon World!" ' yes, it must be afternoon
END IF
IF Hour% > 17 THEN '                is current hour greater than 17? (after 5PM)
    PRINT "Good Evening World!" '   yes, it must be evening
END IF

