REM Program DCLOCK
REM \CHAP8\CH8_10.BAS 

 DECLARE SUB Cloc (Min$)
 SCREEN 9: 'EGA mode
 DO
     CLS
     Min$ = MID$(TIME$, 4, 2) 'Get the current minutes
     Cloc Min$
     DO
         LOCATE 10, 37
         PRINT TIME$
         Test$ = INKEY$
     LOOP WHILE Min$ = MID$(TIME$, 4, 2) AND Test$ = ""
 LOOP WHILE Test$ = ""
 END

 SUB Cloc (Min$) STATIC
 LOCATE 23, 30
 PRINT "Press any key!"
 LOCATE 6, 40: PRINT "12"
 LOCATE 19, 41: PRINT "6"
 LOCATE 13, 25: PRINT "9"
 LOCATE 13, 57: PRINT "3"
 CIRCLE (320, 170), 150
 'Translate strings into number
 Hr = VAL(TIME$)
 Min = VAL(Min$)
 'Translate numbers into angles
 Little = 360 - (30 * Hr + Min / 2)
 Big = 360 - (6 * Min)
 'Drawing of hands
 DRAW "TA=" + VARPTR$(Little) + "NU50"
 DRAW "TA=" + VARPTR$(Big) + "NU75"
 END SUB