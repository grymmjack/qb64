'
'***** A game by Trojan Software... ******************************************
'
'*********************** The Mysteries Of Lagon ******************************
'************************* by Gareth Williams ********************************
'
'  { DEMO VERSION }
'    To register, send œ5 to      Gareth Williams,
'                                 34 South View Rd.
'                                 Little Dawley,
'                                 Telford, Shropshire
'                                 TF4 3HS
'                                 U.K.
'
' Because I'm a nice kind'a guy, I won't tell you the cheats! - But if
' you search for the word "inputcheat:", and look at the screen for
' the variables "A$" and "B$", you might find some cheats there!

intro:
CLS
COLOR 13
LOCATE 10, 20
PRINT "Trojan Software presents..."
PLAY "MSO1L16CC<BB>CC<BBBB>CCC<BBBB>C<BB>CC<D"
CLS
COLOR 14
LOCATE 10, 18
PRINT "...A game by Gareth Williams..."
PLAY "O1L16AABBAABBBBAAABBABBAAA"
CLS
LOCATE 10, 22
COLOR 10
PRINT "The Mysteries Of Lagon"
PLAY "O2DDDDDCCCC<BBBBB>CCCC<BA01<AAA"
DO
LOOP WHILE INKEY$ = ""
points = 0
lives = 3
GOTO menu

menu:
COLOR 10
CLS
PRINT "Welcome to 'The Mysteries Of Lagon' - *** Demo Version ***"
LOCATE 3, 3
PRINT "Please make a choice:"
LOCATE 5, 6
PRINT "I=Instructions"
LOCATE 6, 6
PRINT "G=Game"
LOCATE 7, 6
PRINT "C=Input cheat"
DO
M$ = INKEY$
LOOP WHILE M$ = ""
IF M$ = "I" OR M$ = "i" THEN GOTO ins
IF M$ = "c" OR M$ = "C" THEN GOTO inputcheat
GOTO game

ins:
CLS
COLOR 7
LOCATE 3, 1
PRINT "This is a game of skill, speed and quick reactions. If you"
PRINT "do not meet all these requirements, you will soon find"
PRINT "yourself not doing very well at all."
LOCATE 7, 1
PRINT "To complete the three demo levels, you must get to the object,"
PRINT "or thing, at the end of the level. In a moment, you will be"
PRINT "asked to input your skill level. Beginners should start on the"
PRINT "'Baby Speed' setting while more experienced players should try"
PRINT "'Moderate' or 'Fast'. The 'Zooming' level is not really playable"
PRINT "but it is there if you fancy a challenge. The colour input is"
PRINT "asking you to choose the colour that will represent your little"
PRINT "character."
DO
LOOP WHILE INKEY$ = ""
CLS
LOCATE 3, 1
PRINT "Controls:"
LOCATE 5, 6
PRINT "'q' = Move up"
LOCATE 6, 6
PRINT "'a' = Move down"
LOCATE 8, 1
PRINT "Depending on the skill level that you selected, you will"
PRINT "automatically move right along the screen at the relevant"
PRINT "speed."
DO
LOOP WHILE INKEY$ = ""
CLS
LOCATE 3, 1
PRINT "Objects you may find:"
LOCATE 6, 1
COLOR 4
PRINT CHR$(3)
LOCATE 6, 3
COLOR 7
PRINT "= Extra Life"
LOCATE 8, 1
COLOR 10
PRINT CHR$(6)
LOCATE 8, 3
COLOR 7
PRINT "= 500 points"
LOCATE 10, 1
COLOR 14
PRINT CHR$(157)
LOCATE 10, 3
COLOR 7
PRINT "= 100 points"
DO
LOOP WHILE INKEY$ = ""
GOTO game

inputcheat:
CLS
COLOR 4
LOCATE 3, 3
PRINT "{ Remember - Cheaters NEVER prosper }"
LOCATE 5, 1
COLOR 15
INPUT "So what's the cheat then "; cheat$
A$ = "whatawimp"
B$ = "manypoints"
IF cheat$ = A$ THEN lives = 100: PRINT "You now have 100 lives!"
IF cheat$ = B$ THEN points = 1000: PRINT "Your score is now 1000!"
IF cheat$ <> A$ AND cheat$ <> B$ THEN PRINT "CHEAT NOT ACCEPTED": BEEP: BEEP: BEEP
DO
LOOP WHILE INKEY$ = ""
GOTO menu

game:
CLS
INPUT "Which colour (1-15)"; col
IF col = 0 THEN col = 15
PRINT
PRINT "Difficulty level:"
PRINT "  1 = Baby Speed"
PRINT "  2 = Moderate"
PRINT "  3 = Fast"
PRINT "  4 = Zooming"
INPUT speed
IF speed = 1 THEN speed = 3000
IF speed = 2 THEN speed = 2000
IF speed = 3 THEN speed = 1000
IF speed = 4 THEN speed = 500 ELSE speed = 2000
1 CLS
CC = 7
DD = 3
COLOR 9
LOCATE 5, 10
qwe = 0
PRINT "Level 1 - Crystal Maze"
DO
LOOP WHILE INKEY$ = ""
50 CLS
COLOR 9
LOCATE 4, 40
PRINT "Lives ="; lives
LOCATE 4, 5
PRINT "Points ="; points
LOCATE 5, 1
COLOR 4
PRINT "***************************************************"
PRINT "*        *         *    *      *  *   * * *    *  *"
PRINT "*          *     *      *   * *   *  *  *  *  *   *"
PRINT "*        *        *         *   *      * *        *"
PRINT "***************************************************"
IF points0 = 222111 THEN GOTO 100.1
LOCATE 6, 38
COLOR 14
PRINT CHR$(157)
100.1 IF points1 = 666555 THEN GOTO 100.2
LOCATE 6, 17
COLOR 14
PRINT CHR$(157)
100.2  IF points01 = 654321 THEN GOTO 101
LOCATE 6, 45
COLOR 10
PRINT CHR$(6)
101 IF points2 = 555666 THEN GOTO 102
LOCATE 8, 31
COLOR 14
PRINT CHR$(157)
102 LOCATE 8, 18
IF heartt = 23456 THEN GOTO 200
COLOR 4
PRINT CHR$(3)
200 LOCATE 7, 48
COLOR 15
PRINT CHR$(15)
X$ = INKEY$
IF X$ = "q" THEN CC = CC - 1
IF X$ = "a" THEN CC = CC + 1
DD = DD + 1
LOCATE CC, DD
COLOR col
PRINT CHR$(2)
IF CC = 9 THEN GOSUB die
IF CC = 5 THEN GOSUB die
IF DD = 48 AND CC = 7 THEN points = points + 300: PLAY "O2L64EEEEDDDDCCCC": GOTO win
IF DD = 10 AND CC = 6 THEN GOSUB die
IF DD = 10 AND CC = 8 THEN GOSUB die
IF DD = 12 AND CC = 7 THEN GOSUB die
IF DD = 18 AND CC = 7 THEN GOSUB die
IF DD = 19 AND CC = 8 THEN GOSUB die
IF DD = 20 AND CC = 6 THEN GOSUB die
IF DD = 47 AND CC = 7 THEN GOSUB die
IF DD = 48 AND CC = 6 THEN GOSUB die
IF DD = 25 AND CC = 6 THEN GOSUB die
IF DD = 25 AND CC = 7 THEN GOSUB die
IF DD = 29 AND CC = 7 THEN GOSUB die
IF DD = 29 AND CC = 8 THEN GOSUB die
IF DD = 31 AND CC = 7 THEN GOSUB die
IF DD = 32 AND CC = 6 THEN GOSUB die
IF DD = 33 AND CC = 8 THEN GOSUB die
IF DD = 35 AND CC = 6 THEN GOSUB die
IF DD = 35 AND CC = 7 THEN GOSUB die
IF DD = 38 AND CC = 7 THEN GOSUB die
IF DD = 39 AND CC = 6 THEN GOSUB die
IF DD = 40 AND CC = 8 THEN GOSUB die
IF DD = 41 AND CC = 6 THEN GOSUB die
IF DD = 41 AND CC = 7 THEN GOSUB die
IF DD = 42 AND CC = 8 THEN GOSUB die
IF DD = 43 AND CC = 6 THEN GOSUB die
IF DD = 44 AND CC = 7 THEN GOSUB die
IF DD = 18 AND CC = 8 AND heartt <> 23456 THEN lives = lives + 1: heartt = 23456: PLAY "O4L64CCC"
IF DD = 17 AND CC = 6 AND points1 <> 666555 THEN points = points + 100: points1 = 666555: PLAY "O4L64ABA"
IF DD = 31 AND CC = 8 AND points2 <> 555666 THEN points = points + 100: points2 = 555666: PLAY "O4L64ABA"
IF DD = 38 AND CC = 6 AND points0 <> 222111 THEN points = points + 100: points0 = 222111: PLAY "O4L64ABA"
IF DD = 45 AND CC = 6 AND points01 <> 654321 THEN points = points + 500: points01 = 654321: PLAY "O2L64EDC"
IF DD = 51 THEN GOSUB die
IF DD = 1 THEN GOSUB die
IF qwe = 98765 THEN GOTO 1
LOCATE 4, 5
COLOR 9
PRINT "Points ="; points
PLAY "L64O1A"
FOR D = 1 TO speed
NEXT D
GOTO 50
 
win:
LOCATE 4, 5
COLOR 9
PRINT "Points ="; points
LOCATE 10, 5
COLOR col
PRINT "Well done, you got the crystal!"
DO
LOOP WHILE INKEY$ = ""
GOTO level2

level2:
qwe = 0
CLS
LOCATE 5, 10
PRINT "Level 2 - Save the Alien!"
DO
LOOP WHILE INKEY$ = ""
CC = 7
DD = 3
2 CLS
COLOR 9
LOCATE 4, 40
PRINT "Lives ="; lives
LOCATE 4, 5
PRINT "Points ="; points
LOCATE 5, 1
COLOR 1
PRINT "*******************************************************************"
PRINT "*        *     *  *        *    *     *   * * *   *   * *      *  *"
PRINT "*        *  *  *     **  *   *  *  *    *   *   *   *   *   *  *  *"
PRINT "*           *     *   *    *       *    *     *   * * *     *     *"
PRINT "*******************************************************************"
IF points03 = 444555 THEN GOTO 103.1
LOCATE 8, 5
COLOR 10
PRINT CHR$(6)
103.1 IF points3 = 999888 THEN GOTO 103.2
LOCATE 6, 18
COLOR 10
PRINT CHR$(6)
103.2 IF points04 = 111222 THEN GOTO 104
LOCATE 8, 25
COLOR 14
PRINT CHR$(157)
104 IF points4 = 777666 THEN GOTO 105
LOCATE 6, 53
COLOR 14
PRINT CHR$(157)
105 COLOR 2
LOCATE 6, 66
PRINT CHR$(234)
IF hea = 12345 THEN GOTO 100
COLOR 4
LOCATE 6, 44
PRINT CHR$(3)
100 X$ = INKEY$
IF X$ = "q" THEN CC = CC - 1
IF X$ = "a" THEN CC = CC + 1
DD = DD + 1
LOCATE CC, DD
COLOR col
PRINT CHR$(2)
IF CC = 9 THEN GOSUB die
IF CC = 5 THEN GOSUB die
IF DD = 10 AND CC = 6 THEN GOSUB die
IF DD = 10 AND CC = 7 THEN GOSUB die
IF DD = 13 AND CC = 7 THEN GOSUB die
IF DD = 13 AND CC = 8 THEN GOSUB die
IF DD = 16 AND CC = 6 THEN GOSUB die
IF DD = 16 AND CC = 7 THEN GOSUB die
IF DD = 19 AND CC = 6 THEN GOSUB die
IF DD = 19 AND CC = 8 THEN GOSUB die
IF DD = 22 AND CC = 7 THEN GOSUB die
IF DD = 23 AND CC = 7 THEN GOSUB die
IF DD = 23 AND CC = 8 THEN GOSUB die
IF DD = 26 AND CC = 7 THEN GOSUB die
IF DD = 28 AND CC = 6 THEN GOSUB die
IF DD = 28 AND CC = 8 THEN GOSUB die
IF DD = 30 AND CC = 7 THEN GOSUB die
IF DD = 33 AND CC = 6 THEN GOSUB die
IF DD = 33 AND CC = 7 THEN GOSUB die
IF DD = 36 AND CC = 7 THEN GOSUB die
IF DD = 36 AND CC = 8 THEN GOSUB die
IF DD = 39 AND CC = 6 THEN GOSUB die
IF DD = 41 AND CC = 7 THEN GOSUB die
IF DD = 41 AND CC = 8 THEN GOSUB die
IF DD = 43 AND CC = 6 THEN GOSUB die
IF DD = 45 AND CC = 6 THEN GOSUB die
IF DD = 45 AND CC = 7 THEN GOSUB die
IF DD = 47 AND CC = 6 THEN GOSUB die
IF DD = 47 AND CC = 8 THEN GOSUB die
IF DD = 49 AND CC = 7 THEN GOSUB die
IF DD = 51 AND CC = 6 THEN GOSUB die
IF DD = 51 AND CC = 8 THEN GOSUB die
IF DD = 53 AND CC = 7 THEN GOSUB die
IF DD = 53 AND CC = 8 THEN GOSUB die
IF DD = 55 AND CC = 6 THEN GOSUB die
IF DD = 55 AND CC = 8 THEN GOSUB die
IF DD = 57 AND CC = 6 THEN GOSUB die
IF DD = 57 AND CC = 7 THEN GOSUB die
IF DD = 61 AND CC = 7 THEN GOSUB die
IF DD = 61 AND CC = 8 THEN GOSUB die
IF DD = 64 AND CC = 6 THEN GOSUB die
IF DD = 64 AND CC = 7 THEN GOSUB die
IF DD = 66 AND CC = 6 THEN points = points + 300: PLAY "O4L64EEEEDDDDCCCC": GOTO win2
IF DD = 44 AND CC = 6 AND hea <> 12345 THEN lives = lives + 1: hea = 12345: PLAY "O2L64CCC"
IF DD = 18 AND CC = 6 AND points3 <> 999888 THEN points = points + 500: points3 = 999888: PLAY "O2L64EDC"
IF DD = 53 AND CC = 6 AND points4 <> 777666 THEN points = points + 100: points4 = 777666: PLAY "O2L64ABA"
IF DD = 5 AND CC = 8 AND points03 <> 444555 THEN points = points + 500: points03 = 444555: PLAY "O2L64EDC"
IF DD = 25 AND CC = 8 AND points04 <> 111222 THEN points = points + 100: points04 = 111222: PLAY "O2L64ABA"
IF DD = 67 THEN GOSUB die
IF DD = 1 THEN GOSUB die
IF qwe = 98765 THEN GOTO level2
LOCATE 4, 5
COLOR 9
PRINT "Points ="; points
PLAY "L64O1A"
FOR D = 1 TO speed
NEXT D
GOTO 2

die:
LOCATE 10, 5
PLAY "O1L32AAAAAAAAA"
PRINT "Ow, that hurt!"
DO
LOOP WHILE INKEY$ = ""
lives = lives - 1
IF lives <= 0 THEN GOTO badend
qwe = 98765
RETURN

win2:
LOCATE 4, 5
COLOR 9
PRINT "Points ="; points
LOCATE 10, 5
COLOR col
PRINT "Well done, you saved the alien!"
DO
LOOP WHILE INKEY$ = ""
GOTO level3

level3:
qwe = 0
CLS
LOCATE 5, 10
PRINT "Level 3 - Journey Through Heaven!"
DO
LOOP WHILE INKEY$ = ""
CC = 7
DD = 3
3 CLS
COLOR 9
LOCATE 4, 40
PRINT "Lives ="; lives
LOCATE 4, 5
PRINT "Points ="; points
COLOR 15
LOCATE 5, 1
PRINT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
PRINT "~         *      *   *      *  *   *   *  *      ~"
PRINT "~        *  *  *    * *    *  * *  *   * * *     ~"
PRINT "~         * *    *      *    *   *   *  *    *   ~"
PRINT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
IF points05 = 456456 THEN GOTO 105.1
LOCATE 8, 17
COLOR 14
PRINT CHR$(157)
105.1 IF points5 = 222333 THEN GOTO 105.2
LOCATE 6, 31
COLOR 14
PRINT CHR$(157)
105.2 IF points06 = 345345 THEN GOTO 106
LOCATE 8, 26
COLOR 10
PRINT CHR$(6)
106 IF points6 = 333222 THEN GOTO 107
LOCATE 6, 42
COLOR 14
PRINT CHR$(157)
107 LOCATE 7, 48
COLOR 1
PRINT CHR$(21)
IF hear = 34567 THEN GOTO 300
COLOR 4
LOCATE 7, 22
PRINT CHR$(3)
300 X$ = INKEY$
IF X$ = "q" THEN CC = CC - 1
IF X$ = "a" THEN CC = CC + 1
DD = DD + 1
LOCATE CC, DD
COLOR col
PRINT CHR$(2)
IF CC = 9 THEN GOSUB die
IF CC = 5 THEN GOSUB die
IF DD = 10 AND CC = 7 THEN GOSUB die
IF DD = 11 AND CC = 6 THEN GOSUB die
IF DD = 11 AND CC = 8 THEN GOSUB die
IF DD = 13 AND CC = 7 THEN GOSUB die
IF DD = 13 AND CC = 8 THEN GOSUB die
IF DD = 16 AND CC = 7 THEN GOSUB die
IF DD = 18 AND CC = 6 THEN GOSUB die
IF DD = 18 AND CC = 8 THEN GOSUB die
IF DD = 21 AND CC = 7 THEN GOSUB die
IF DD = 22 AND CC = 6 THEN GOSUB die
IF DD = 23 AND CC = 7 THEN GOSUB die
IF DD = 25 AND CC = 8 THEN GOSUB die
IF DD = 28 AND CC = 7 THEN GOSUB die
IF DD = 29 AND CC = 6 THEN GOSUB die
IF DD = 30 AND CC = 8 THEN GOSUB die
IF DD = 31 AND CC = 7 THEN GOSUB die
IF DD = 32 AND CC = 6 THEN GOSUB die
IF DD = 33 AND CC = 7 THEN GOSUB die
IF DD = 34 AND CC = 8 THEN GOSUB die
IF DD = 36 AND CC = 6 THEN GOSUB die
IF DD = 36 AND CC = 7 THEN GOSUB die
IF DD = 38 AND CC = 8 THEN GOSUB die
IF DD = 40 AND CC = 6 THEN GOSUB die
IF DD = 40 AND CC = 7 THEN GOSUB die
IF DD = 41 AND CC = 8 THEN GOSUB die
IF DD = 42 AND CC = 7 THEN GOSUB die
IF DD = 43 AND CC = 6 THEN GOSUB die
IF DD = 44 AND CC = 7 THEN GOSUB die
IF DD = 46 AND CC = 8 THEN GOSUB die
IF DD = 48 AND CC = 7 THEN points = points + 300: PLAY "O4L64EEEEDDDDCCCC": GOTO win3
IF DD = 22 AND CC = 7 AND hear <> 34567 THEN lives = lives + 1: hear = 34567: PLAY "O4L64CCC"
IF DD = 31 AND CC = 6 AND points5 <> 222333 THEN points = points + 100: points5 = 222333: PLAY "O4L64ABA"
IF DD = 42 AND CC = 6 AND points6 <> 333222 THEN points = points + 100: points6 = 333222: PLAY "O4L64ABA"
IF DD = 17 AND CC = 8 AND points05 <> 456456 THEN points = points + 100: points05 = 456456: PLAY "O4L64ABA"
IF DD = 26 AND CC = 8 AND points06 <> 345345 THEN points = points + 500: points06 = 345345: PLAY "O4L64EDC"
IF DD = 1 THEN GOSUB die
IF DD = 50 THEN GOSUB die
IF qwe = 98765 THEN GOTO level3
LOCATE 4, 5
COLOR 9
PRINT "Points ="; points
PLAY "L64O1A"
FOR D = 1 TO speed
NEXT D
GOTO 3

win3:
LOCATE 4, 5
COLOR 9
PRINT "Points ="; points
COLOR col
DO
G = INT(RND(1) * 20 + 1)
H = INT(RND(1) * 30 + 1)
hum = INT(RND(1) * 15 + 1)
LOCATE G, H
COLOR hum
PRINT "Well done, you have made it to the portal!"
FOR D = 1 TO 2000
NEXT D
LOOP UNTIL INKEY$ <> ""
SYSTEM

badend:
DO
LOOP WHILE INKEY$ = ""
CLS
LOCATE 10, 13
PRINT "You have died!  Thankyou for playing!"
PLAY "O2L7CCCCP10D#DDCC<B>L4C"
DO
LOOP WHILE INKEY$ = ""
SYSTEM

