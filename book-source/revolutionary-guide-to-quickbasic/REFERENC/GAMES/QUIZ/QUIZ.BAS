10 REM THE QUIZ
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 DIM R%(3), W%(3)
70 DIM X$(250), Y$(250), U(250)
80 SCREEN 9: CLS
90 A$ = "THE QUIZ"
100 COLOR 2
110 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
120 COLOR 10
130 COLOR 10: LOCATE 5, 1: PRINT "   This rather larger program is a quiz. The difference is that many topics can be used in this quiz."
140 PRINT "   The questions are asked at random, and a score and evaluation is given at theend of the quiz. At the start you are given the option of loading a different"
150 PRINT "data file. This disk contains some example quiz files ready to use, just pick   the one you want.   Also on this disk is a quiz generator for use with this     program."
160 RAND = 0
170 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
180 A$ = ""
190 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 190
200 RAND = RAND - VAL(RIGHT$(TIME$, 2))
210 RANDOMIZE RAND
220 REM ++++++++++ OPENING SCREEN
230 CLS
240 COLOR 6: LOCATE 2, 36: PRINT "THE QUIZ"
250 COLOR 4: LOCATE 3, 36: PRINT "--------"
260 COLOR 14
270 COLOR 10: LOCATE 5, 10: PRINT "CAPITALS - Capital cities of the world."
280 LOCATE 6, 10: PRINT "PROVERBS - Complete the proverb."
281 LOCATE 7, 10: PRINT "MONEY - Currencies."
282 LOCATE 8, 10: PRINT "GENERAL - General knowledge."
290 PRINT : COLOR 10: PRINT TAB(5); "Enter filename of quiz wanted :"; : COLOR 15: INPUT FILENAME$
300 IF FILENAME$ <> "GENERAL" AND FILENAME$ <> "MONEY" AND FILENAME$ <> "CAPITALS" AND FILENAME$ <> "PROVERBS" THEN GOTO 220
310 OPEN FILENAME$ + ".QIZ" FOR INPUT AS #1
320 INPUT #1, QUESTION$
330 INPUT #1, N: FOR A = 1 TO N: INPUT #1, X$(A): INPUT #1, Y$(A): NEXT A
340 CLOSE
350 PRINT : COLOR 10: PRINT "     Enter number of participants (1-3) :"; : COLOR 15: INPUT PAR%
360 IF PAR% < 1 OR PAR% > 3 THEN 350
370 PRINT
380 FOR A = 1 TO PAR%: COLOR 10: PRINT "     Enter name of participant :"; : COLOR 15: INPUT PAR$(A): NEXT A
390 IF PAR% = 1 THEN A = N ELSE A = N / PAR%
400 IF PAR% = 1 THEN PRINT : COLOR 10: PRINT "     You can be asked a maximum of"; : COLOR 15: PRINT A; : COLOR 10: PRINT "questions."
410 IF PAR% > 1 THEN PRINT : COLOR 10: PRINT "     You can be asked a maximum of"; : COLOR 15: PRINT (A MOD N) - 1; : COLOR 10: PRINT "questions each."
420 IF PAR% = 1 THEN NOO = N ELSE NOO = (A MOD N) - 1
430 PRINT : COLOR 10: PRINT "     How many do you want to be asked "; : COLOR 15: INPUT NO
440 IF NO < 1 OR NO > NOO THEN 390
450 COLOR 7: LOCATE 20, 35: PRINT "PLEASE WAIT"
460 FOR A = 1 TO N
470 B = INT(RND * (N - 1)) + 1
480 FOR C = 2 TO A
490 IF B = U(C) THEN 470
500 NEXT C
510 U(A) = B
520 NEXT A
530 PLA% = 0: ROU% = 1
540 FOR A = 1 TO NO * PAR%
550 PLA% = PLA% + 1: IF PLA% = PAR% + 1 THEN PLA% = 1: ROU% = ROU% + 1
560 REM ++++++++++ GAME SECTION
570 CLS
580 COLOR 6: LOCATE 2, 36: PRINT "THE QUIZ"
590 COLOR 4: LOCATE 3, 36: PRINT "--------"
600 COLOR 14: LOCATE 5, 5: PRINT FILENAME$
610 LOCATE 5, 78 - LEN(PAR$(PLA%)): PRINT PAR$(PLA%)
620 LOCATE 5, 35: PRINT ROU%; " from"; NO
630 COLOR 12: LOCATE 8, 5: PRINT QUESTION$; " "; X$(U(A)); " "
640 LOCATE 10, 15: COLOR 15: INPUT Z$
650 IF Y$(U(A)) = Z$ THEN R%(PLA%) = R%(PLA%) + 1: COLOR 3: LOCATE 15, 37: PRINT "CORRECT"
660 IF Y$(U(A)) <> Z$ THEN W%(PLA%) = W%(PLA%) + 1: COLOR 3: LOCATE 15, 26: PRINT "WRONG IT WAS : "; Y$(U(A))
670 FOR B = 1 TO 5000: NEXT B
680 NEXT A
690 REM ++++++++++ END OF GAME RESULTS SECTION
700 LINE (1, 38)-(639, 349), 0, BF
710 COLOR 14: LOCATE 5, 5: PRINT "You completed"; A - 1; "questions of the "; FILENAME$; " quiz file."
720 FOR A = 1 TO PAR%
730 PRINT : COLOR 15: PRINT "     "; PAR$(A)
740 COLOR 14: PRINT "     Correct "; R%(A)
750 PRINT "     Wrong    "; W%(A)
760 PRINT "     Percentage correct "; R%(A) / (R%(A) + W%(A)) * 100; "%"
770 NEXT A
780 COLOR 15: LOCATE 22, 5: PRINT "Press Print Screen for a printout or any OTHER key to continue"
790 WHILE INKEY$ = "": WEND
800 REM ********* RETURN TO MENU POSER
810 CLS
820 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
830 LOCATE 3, 26: COLOR 7: PRINT "1"
840 LOCATE 4, 26: PRINT "2"
850 A$ = INKEY$: IF A$ = "" THEN GOTO 850
860 IF A$ = "1" THEN CLEAR : RUN
870 IF A$ = "2" THEN CLS : SYSTEM
880 GOTO 850

