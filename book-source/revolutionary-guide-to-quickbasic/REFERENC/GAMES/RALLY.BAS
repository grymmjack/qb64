   REM SUPER RALLY
   REM For QBASIC
   REM (c) 1992
   REM
   PRINT "PLEASE WAIT"
   DIM X(3000), Y(3000)
   FOR a% = 1 TO 2000: X(a%) = 90: Y(a%) = 90: NEXT a%
   SCREEN 9: CLS
    a$ = "SUPER RALLY"
    COLOR 2
    LOCATE 2, (80 - LEN(a$)) / 2: PRINT a$
    COLOR 10
    COLOR 10: LOCATE 5, 1: PRINT "   This game lets you take control of a rally car in a cross country rally race.The main objective is to stay on the road and to avoid all obstacles until you"
    PRINT "cross the finish line. Everything is explained on the menu screen before the    game starts."
    RAND = 0
    LOCATE 20, 33: COLOR 12: PRINT "Press any key"
    a$ = ""
    WHILE a$ = "": a$ = INKEY$: RAND = RAND + .1: WEND
    RAND = RAND - VAL(RIGHT$(TIME$, 2))
    RANDOMIZE RAND
    ' menu screen
    CLS
    GOSUB definecourse
    LOCATE 2, 30: COLOR 12: PRINT "CROSS COUNTRY RALLY"
    COLOR 3: LOCATE 5, 5: PRINT "Car control keys are : Q and P"
    COLOR 14: LOCATE 20, 5: PRINT "COURSE :": COLOR 15: LOCATE 20, 14: PRINT COURSE$
    LOCATE 23, 35: COLOR 5: PRINT "Press a key"
    WHILE INKEY$ = "": WEND
    ' initialisation
    CLS
    CARX = 39: DX = 39: CAR$ = "oлo"
    X = 20: Y = 60
    a$ = "": a = 0

gamestart: 
    ' game loop
    DO: a$ = INKEY$
    a = a + 1: IF a = 1000 THEN GOTO win
    COLOR 15: LOCATE 10, CARX: PRINT CAR$
    IF a > 15 THEN IF X(a - 14) <> 90 THEN IF CARX < X(a - 14) + 1 OR CARX > Y(a - 14) THEN GOTO crash
    LOCATE 9, DX: PRINT "   "
    IF X(a) = 90 THEN X(a) = X(a - 1) + RND * 2 - RND * 2: IF X(a) < 2 THEN X(a) = 2 ELSE IF X(a) > 50 THEN X(a) = 50
    IF Y(a) = 90 THEN Y(a) = Y(a - 1) + RND * 2 - RND * 2: IF Y(a) < 30 THEN Y(a) = 30 ELSE IF Y(a) > 78 THEN Y(a) = 78
    IF Y(a) - X(a) < 10 AND a > 20 THEN X(a) = X(a) - 1: Y(a) = Y(a) + 1
    IF Y(a) - X(a) > 25 AND a > 20 THEN X(a) = X(a) + 1: Y(a) = Y(a) - 1
    COLOR 4: LOCATE 24, X(a) - 1: PRINT "лл";
    LOCATE 24, Y(a): PRINT "лл";
    PRINT CHR$(13);
    DX = CARX
    LOOP UNTIL a$ <> ""
    DX = CARX
    IF a$ = "Q" THEN CARX = CARX - 2
    IF a$ = "P" THEN CARX = CARX + 2
    GOTO gamestart

crash:
    REM The Crash routine & screen
    FOR B = 1 TO 5000: NEXT B
    WHILE INKEY$ = "": WEND
    FOR B = 1 TO 13: LOCATE B, 1: PRINT SPACE$(80); : LOCATE 25 - B, 1: PRINT SPACE$(79); : NEXT B
    COLOR 12: LOCATE 2, 32: PRINT "You Have Crashed"
    COLOR 10: LOCATE 5, 5: PRINT "You completed "; INT(a / 50); " miles before wrecking your vehicle."
    COLOR 15: LOCATE 20, 5: PRINT "Press Any key"
    WHILE INKEY$ = "": WEND
    FOR B = 1 TO 5000: NEXT B
    GOTO menu

win:
    REM Won the Race
    CLS
    FOR a% = 1 TO 500: COLOR RND * 13 + 1: LOCATE RND * 23 + 1, RND * 78 + 1: PRINT CHR$(RND * 40 + 160); : NEXT a%
    FOR a = 10 TO 15: LOCATE a, 30: PRINT SPACE$(20): NEXT a
    COLOR 15: LOCATE 11, 36: PRINT "CHAMPION"
    COLOR 9: LOCATE 14, 35: PRINT "Press a key"
    WHILE INKEY$ = "": WEND
    GOTO menu:

definecourse:
    REM course details
    COURSE$ = "Milosinni Cross Challenge"
    FOR a = 1 TO 319
    READ X(a), Y(a)
    NEXT a
    DATA 2,78,2,78,3,77,4,76,5,75,6,74,7,73,8,72,9,71,10,70,11,69
    DATA 12,68,13,67,14,66,15,65,16,64,17,63,18,62,19,61,20,60,21,59,22,58
    DATA 23,57,24,56,25,55,26,54,27,53,28,52,29,51,30,50,31,49,32,48,33,47
    DATA 31,49,29,51,27,53,26,54,26,54,25,55,24,56,23,57,22,58,21,59,20,60
    DATA 20,60,20,60,20,60,20,60,20,60,20,60,20,60,20,60,19,61,21,59,22,58
    DATA 22,58,22,58,23,57,24,56,23,57,24,58,24,58,24,58,24,58,23,58,22,58
    DATA 22,58,22,58,22,58,22,58,22,58,22,58,23,57,24,56,24,56,24,56,24,56
    DATA 24,56,24,56,25,55,26,54,26,54,26,54,26,54,26,54,27,53,28,52,29,51
    DATA 30,50,30,50,30,50,30,50,30,50,30,50,30,50,30,50,31,49,32,48,33,47
    DATA 34,46,35,45,36,44,35,45,34,46,33,47,33,47,33,47,33,47,34,47,34,47
    DATA 35,47,36,47,37,47,36,48,35,49,36,50,37,51,38,52,39,53,40,53,41,52
    DATA 41,52,41,50,41,52,41,52,41,52,41,52,41,52,41,52,41,52,41,52,41,52
    DATA 40,51,39,50,38,49,37,48,36,47,35,46,34,45,33,45,32,46,31,46,30,47
    DATA 31,47,31,47,31,47,31,47,31,47,31,47,31,47,32,48,32,48,34,50,36,52
    DATA 37,53,38,54,39,55,40,56,40,56,40,56,40,56,40,56,40,56,40,56,40,56
    DATA 39,54,38,52,38,52,38,52,38,52,38,52,38,52,38,52,38,52,39,53,39,53
    DATA 40,54,40,54,40,54,40,54,40,54,40,54,40,54,40,54,40,54,40,54,40,54
    DATA 41,55,42,56,42,56,42,56,42,56,42,56,40,54,40,54,40,54,40,54,40,54
    DATA 40,54,40,54,40,54,41,55,42,56,43,57,44,58,45,59,46,60,46,60,46,60
    DATA 47,61,47,62,48,63,49,64,50,65,51,66,52,67,53,68,54,69,55,70,56,71
    DATA 57,72,58,73,59,74,60,75,60,75,60,75,60,75,60,75,60,75,60,75,60,75
    DATA 59,74,59,74,59,74,60,75,60,75,60,75,59,74,58,73,57,72,56,71,55,70
    DATA 54,69,53,68,52,67,51,66,50,65,49,64,48,63,47,62,46,61,45,60,44,59
    DATA 43,58,42,57,41,56,40,55,39,54,38,53,37,52,36,51,35,50,34,49,33,48
     DATA 32,47,31,46,30,45,29,44,28,43,27,42,26,41,25,40,24,39,23,38,22,37
     DATA 21,36,20,35,19,34,18,33,17,32,16,31,15,30,14,29,13,28,12,27,11,26
     DATA 10,25,11,26,12,27,13,28,14,29,15,30,16,31,15,30,14,29,13,28,12,27
     DATA 11,26,10,25,9,24,8,23,7,22,6,21,5,20,4,19,4,19,4,19,4,19
     DATA 4,19,4,19,5,20,5,20,5,20,5,21,7,22,9,24,11,26,13,28,12,27
     DATA 10,25,8,23,7,22,5,20,4,19,4,19,4,19,4,19,4,19,4,19,4,19
     RETURN

menu:
     REM ********* RETURN TO MENU POSER
     CLS
     COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
     LOCATE 3, 26: COLOR 7: PRINT "1"
     LOCATE 4, 26: PRINT "2"
     a$ = ""
     WHILE a$ = "": a$ = INKEY$: WEND
     IF a$ = "1" THEN CLEAR : RUN
     IF a$ = "2" THEN CLS : SYSTEM
     GOTO menu

