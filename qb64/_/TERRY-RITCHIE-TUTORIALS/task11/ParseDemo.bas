'--------------------------------
'- Variable Declaration Section -
'--------------------------------

DIM MonthName$(12) ' array storing the names of the months
DIM Hours% '         numeric value of hour
DIM Month% '         numeric value of month
DIM Day% '           numeric value of day
DIM Year% '          numeric value of year
DIM Suffix$ '        day suffix
DIM AmPm$ '          AM or PM

'----------------------------
'- Main Program Begins Here -
'----------------------------

MonthName$(1) = "January" '                                                store the month names
MonthName$(2) = "February"
MonthName$(3) = "March"
MonthName$(4) = "April"
MonthName$(5) = "May"
MonthName$(6) = "June"
MonthName$(7) = "July"
MonthName$(8) = "August"
MonthName$(9) = "September"
MonthName$(10) = "October"
MonthName$(11) = "November"
MonthName$(12) = "December"
DO '                                                                       begin main loop
    Month% = VAL(LEFT$(DATE$, 2)) '                                        extract value of month
    Day% = VAL(MID$(DATE$, 4, 2)) '                                        extract value of day
    Year% = VAL(RIGHT$(DATE$, 4)) '                                        extract value of year
    Hours% = VAL(LEFT$(TIME$, 2)) '                                        extract value of hours
    IF Hours% > 12 THEN '                                                  military time?
        Hours% = Hours% - 12 '                                             yes, convert to civilian
        AmPm$ = "PM" '                                                     it's the afternoon
    ELSE '                                                                 no
        AmPm$ = "AM" '                                                     it's the morning
    END IF
    IF Day% = 1 OR Day% = 21 OR Day% = 31 THEN '                           one of these days?
        Suffix$ = "st," '                                                  yes, day ends in st
    ELSEIF Day% = 2 OR Day% = 22 THEN '                                    no, one of these days?
        Suffix$ = "nd," '                                                  yes, day ends in nd
    ELSEIF Day% = 3 OR Day% = 23 THEN '                                    no, one of these days?
        Suffix$ = "rd," '                                                  yes, days ends in rd
    ELSE '                                                                 no
        Suffix$ = "th," '                                                  day must end in th then
    END IF
    LOCATE 2, 2 '                                                          position cursor
    Dt$ = "The current date is " + MonthName$(Month%) '                    build new date string
    Dt$ = Dt$ + STR$(Day%) + Suffix$ + STR$(Year%) + "  "
    PRINT Dt$ '                                                            display date string
    LOCATE 4, 2 '                                                          position cursor
    Tm$ = "The current time is " + RIGHT$("0" + LTRIM$(STR$(Hours%)), 2) ' build new time string
    Tm$ = Tm$ + " Hours, " + MID$(TIME$, 4, 2) + " Minutes and "
    Tm$ = Tm$ + RIGHT$(TIME$, 2) + " Seconds " + AmPm$
    PRINT Tm$ '                                                            display time string
LOOP UNTIL INKEY$ <> "" '                                                  end loop if key pressed
SYSTEM '                                                                   return to Windows




