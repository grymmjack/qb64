REM Program "Music for IBM PC"
REM QBasic version V.P. Djakonov
REM \CHAP11\CH11_11.BAS

L1:  'Print title and playing V.Mozart "Turkish March"
     SCREEN 1: CLS
     LOCATE 5, 19, 0: PRINT "IBM"
     PLAY "T120 ML L16 o2 b a g# a > c4 d c < b >  c e4"
     LOCATE 7, 12: PRINT "Personal Computer": LOCATE 10, 9
     PLAY "    o3 f e d# e b a g# a b a g# a > c4"
     PRINT CHR$(213) + STRING$(21, 205) + CHR$(184)
     LOCATE 11, 9
     PRINT CHR$(179) + "        MUSIC        " + CHR$(179)
     LOCATE 12, 9: PRINT CHR$(179) + STRING$(21, 32) + CHR$(179)
     LOCATE 13, 9
     PRINT CHR$(179) + "    Version 1.10     " + CHR$(179)
     LOCATE 14, 9: PRINT CHR$(212) + STRING$(21, 205) + CHR$(190)
     PLAY "L8  o3 a b > c < b a g# a e f d c4 < b4 a4"
     LOCATE 17, 11: PRINT "QBasic version 1994"
     PLAY "    o3 a b > c#4 < a b > c# < b a g# f# g# a b g# e"
     PLAY "    o3 a b > c#4 < a b > c# < b a g# f# b g# e a. p16"
     PLAY "    o3 a b > c#4 < a b > c# < b a g# f# g# a b g# e "
     PLAY "    o3 a b > c#4 < a b > c# < b a g# f# b g# e a4"
     LOCATE 23, 7: PRINT "Press space bar to continue"
L2:  IF INKEY$ <> "" THEN GOTO L2:
L3: CMD$ = INKEY$
     IF CMD$ = "" THEN GOTO L3:
     IF CMD$ = CHR$(27) THEN GOTO L16:
     IF CMD$ <> " " THEN GOTO L3:
     ON ERROR GOTO L4:
     PLAY "mf": GOTO L5
L4: RESUME L5

L5: 'in menu
     ON ERROR GOTO 0
     SCREEN 1: COLOR 0: CLS : DEFINT A-Z
     LOCATE 15, 7: PRINT " ------- selections -------"
     LOCATE 16, 7: PRINT " A-MARCH  E-HUMOR  I-SAKURA"
     LOCATE 17, 7: PRINT " B-STARS  F-BUG    J-BLUE  "
     LOCATE 18, 7: PRINT " C-FORTY  G-POP    K-SCALES"
     LOCATE 19, 7: PRINT " D-HAT    H-DANDY  ESC-EXIT"

     'Drawing keyboard
     FOR I = 0 TO 15
       FOR J = 0 TO 8
         LOCATE 5 + J, 5 + I * 2: PRINT CHR$(219); CHR$(124);
       NEXT
     NEXT
     FOR I = 0 TO 12
       FOR J = 0 TO 4
         IF I = 2 OR I = 6 OR I = 9 OR I = 13 THEN GOTO L6:
         LOCATE 5 + J, 8 + I * 2: PRINT CHR$(32); CHR$(124);
L6:    NEXT
     NEXT
     FOR J = 0 TO 9
       LOCATE 4 + J, 4: PRINT CHR$(221); : LOCATE 4 + J, 36
      PRINT CHR$(221); : PRINT CHR$(221);
     NEXT
     FOR I = 5 TO 9
       LOCATE I, 12: PRINT " "
       LOCATE I, 20: PRINT " "
       LOCATE I, 26: PRINT " "
       LOCATE I, 34: PRINT " "
     NEXT I
     FOR I = 4 TO 13
       LOCATE I, 4: PRINT " "
     NEXT I
     FOR I = 4 TO 13
       LOCATE I, 36: PRINT "  "
     NEXT I
     LOCATE 4, 5
     FOR I = 0 TO 30: PRINT CHR$(219); : NEXT
     DIM M(88), O(70)
     FOR I = 7 TO 88
       M(I) = 36.8 * (2 ^ (1 / 12)) ^ (I - 6)
     NEXT
     FOR I = 0 TO 6: M(I) = 32767: NEXT
     O(0) = 0: O(39) = 5: O(40) = 7: O(41) = 8: O(42) = 9
     O(43) = 10: O(44) = 11: O(45) = 13: O(46) = 14
     O(47) = 15: O(48) = 16: O(49) = 17: O(50) = 18
     O(51) = 19: O(52) = 21: O(53) = 22: O(54) = 23
     O(55) = 24: O(56) = 25: O(57) = 27: O(58) = 28
     O(59) = 29: O(60) = 30: O(61) = 31: O(62) = 32
     O(63) = 33: O(64) = 35: O(65) = 36: O(66) = 37
     O(67) = 38: O(68) = 39: O(69) = 40: O(70) = 42
     GOTO L11

L7:  'Read datas for melodies
     READ J, K
     CMD$ = INKEY$: IF CMD$ = "" THEN GOTO L8:
     IF CMD$ = CHR$(27) THEN RETURN
L8: IF J = -1 THEN RETURN
    Q = O(J)
    IF J > 64 OR J < 39 THEN GOTO L9:
    IF SCREEN(5, Q) <> 32 THEN
       LOCATE 11, Q: PRINT CHR$(14): GOTO L9
    END IF
    LOCATE 7, Q: PRINT CHR$(14);

L9: 'Play selected melodies
    SOUND M(J), K
    IF J = 0 AND K = 1 THEN GOTO L10:
    'Skip next for stacatto
    SOUND 32767, 1
L10: IF J > 64 OR J < 39 THEN GOTO L7:
    IF SCREEN(5, Q) = 32 THEN LOCATE 7, Q: PRINT CHR$(32); : GOTO L7
    LOCATE 11, Q: PRINT CHR$(219); : GOTO L7

L11: 'Select melodies
     LOCATE 21, 5
     PRINT "                                ";
L12: LOCATE 21, 8: PRINT "ENTER SELECTION ==>";
L13: IF INKEY$ <> "" THEN GOTO L13:
L14: CMD$ = UCASE$(INKEY$)
     SELECT CASE CMD$
       CASE "": GOTO L14:
       CASE CHR$(27): GOTO L16:
       CASE "A": S$ = "MARCH ": RESTORE L23: GOTO L15
       CASE "B": S$ = "STARS ": RESTORE L24: GOTO L15
       CASE "C": S$ = "FORTY ": RESTORE L21: GOTO L15
       CASE "D": S$ = "HAT   ": RESTORE L25: GOTO L15
       CASE "E": S$ = "HUMOR ": RESTORE L19: GOTO L15
       CASE "F": S$ = "BUG   ": RESTORE L17: GOTO L15
       CASE "G": S$ = "POP   ": RESTORE L20: GOTO L15
       CASE "H": S$ = "DANDY ": RESTORE L22: GOTO L15
       CASE "I": S$ = "SAKURA": RESTORE L27: GOTO L15
       CASE "J": S$ = "BLUE  ": RESTORE L18: GOTO L15
       CASE "K": S$ = "SCALES": RESTORE L26: GOTO L15
     END SELECT
     GOTO L12

L15: 'Displaing keyboard
     PRINT " "; CMD$; "-"; S$
     READ D: READ S$
     LOCATE 23, 1 + (40.5 - LEN(S$)) / 2
     PRINT S$; : GOSUB L7
     S$ = STRING$(39, " ")
     LOCATE 23, 1: PRINT S$: GOTO L11:
     END
L16: IF SAMPLES$ = "YES" THEN CHAIN "SAMPLES"
     CLS : END

'Date for music (11 melodies)
L17: DATA -2,"La Cucaracha - Mexican Folk Song"
     DATA 42,1,0,1,42,1,0,1,42,1,0,1,47,1,0
     DATA 5,51,1,0,3,42,1,0,1,42,1,0,1
     DATA 42,1,0,1,47,1,0,5,51,1,0,5,30,1
     DATA 0,1,30,1,0,1,35,1,0,3,47,1,0,1
     DATA 47,1,0,1,46,1,0,1,46,1,0,1,44,1
     DATA 0,1,44,1,0,1,42,8,0,2,42,1,0,1
     DATA 42,1,0,1,42,1,0,1,46,1,0,5,49,1
     DATA 0,3,42,1,0,1,42,1,0,1,42,1,0,1
     DATA 46,1,0,5,49,1,0,5,37,1,0,1,37,1
     DATA 0,1,30,1,0,3,54,2,56,2,54,2,52,2
     DATA 51,2,49,2,47,8
     DATA -1,-1
L18: DATA -2,"Blue Danube Waltz by J.S.Strauss"
     DATA 42,4,46,4,49,4,49,4,0,4,61,2,0,2,61,2,0
     DATA 6,58,2,0,2,58,2,0,6,42,4,42,4,46,4,49,4
     DATA 49,4,0,4,61,2,0,2,61,2,0,6,59,2,0,2
     DATA 59,2,0,6,41,4,41,4,44,4,51,4,51,4
     DATA 0,4,63,2,0,2,63,2,0,6,59,2,0,2
     DATA 59,2,0,6,41,4,41,4,44,4,51,4,51,4,0
     DATA 4,63,2,0,2,63,2,0,6,58,2,0,2,58,2
     DATA 0,6,42,4,42,4,46,4,49,4,54,4,0,4,66
     DATA 2,0,2,66,2,0,6,61,2,0,2,61,2,0,6,42
     DATA 4,42,4,46,4,49,4,54,4,0,4,66,2,0,2
     DATA 66,2,0,6,63,2,0,2,63,2,0,6,44,4
     DATA 44,4,47,4,51,2,0,2,51,14,0,2,48,4
     DATA 49,4,58,16,54,4,46,4,46,8,44,4,51,8
     DATA 49,4,42,4,0,2,42,2,42,4,0,8,49,2,0,2,47
     DATA 2,0,6,49,2,0,2,47,2,0,6,49,4,58,16,56,4
     DATA 49,2,0,2,46,2,0,6,49,2,0,2,46,2,0,6,49,4
     DATA 56,16,54,4,49,2,0,2,47,2,0,6,49,2,0,2,47
     DATA 2,0,6,49,4,58,16,56,4,49,4,54,4,56,4,58,4
     DATA 61,8,59,4,58,2,58,2,58,4,56,2,0,2,54,4,0,8
     DATA -1,-1
L19: DATA -2,"Humoresque by Dvorak"
     DATA 47,3,0,2,49,1,47,3,0,2,49,1,51,3,0,2,54,1,56
     DATA 3,0,2,54,1,59,3,0,2,58,1,61,3,0,2,59,1,58,3
     DATA 0,2,61,1,59,3,0,2,56,1,54,3,0,2,54,1,56,3,0
     DATA 2,54,1,59,3,0,2,56,1,54,3,0,2,51,1
     DATA 49,24,47,3,0,2,49,1,47,3,0,2,49,1,51
     DATA 3,0,2,54,1,56,3,0,2,54,1,56,3,0,2,58,1,61,3
     DATA 0,2,59,1,58,3,0,2,61,1,59,3,0,2,56,1
     DATA 54,3,0,2,54,1,59,3,0,2,47,1,49,6,54,6,47,18
     DATA -1,-1
L20: DATA -2,"Pop! Goes the Weasle - Anonymous"
     DATA +47,2,0,2,47,2,49,2,0,2,49,2,51,2,54,2,51,2,47
     DATA 2,0,2,42,2,47,2,0,2,47,2,49,2,0,2,49,2,51,6,47
     DATA 2,0,2,42,2,47,2,0,2,47,2,49,2,0,2,49,2,51,2,54
     DATA 2,51,2,47,2,0,4,56,2,0,4,49,2,0,2,52,2,51,6,47,2
     DATA 0,4,59,2,0,2,59,2,56,2,0,2,59,2,58,2,61,2,58,2
     DATA 54,2,0,4,59,2,0,2,59,2,56,2,0,2,59,2,58,6,54,2
     DATA 0,2,51,2,52,2,0,2,51,2,52,2,0,2,54,2,56,2,0,2
     DATA 58,2,59,2,0,4,56,2,0,4,49,2,0,2,52,2,51,6,47,2
     DATA -1,-1
L21: DATA -2,"Symphony #40 by Mozart"
     DATA 55,2,54,2,54,4,55,2,54,2,54,4,55,2,54,2,54,4,62
     DATA 4,0,4,62,2,61,2,59,4,59,2,57,2,55,4,55,2,54,2
     DATA 52,4,52,4,0,4,54,2,52,2,52,4,54,2,52,2,52,4,54
     DATA 2,52,2,52,4,61,4,0,4,61,2,59,2,58,4,58,2,55,2
     DATA 54,4,54,2,52,2,50,4,50,4,0,4,62,2,61,2,61,4,64
     DATA 4,58,4,61,4,59,4,54,4,0,4,62,2,61,2,61,4,64,4,58,4
     DATA 61,4,59,4,62,4,61,2,59,2,57,2,55,2,54,4,46,4,47,4
     DATA 49,4,50,4,52,2,50,2,49,4,47,4,54,4,0,4,64,8,65,2,0
     DATA 6,64,8,65,2,0,6,64,8,65,4,64,4,65,4,64,4,65,4
     DATA -1,-1
L22: DATA -2,"Yankee Doodle - Anonymous "
     DATA 50,3,50,3,52,3,54,3,50,3,54,3,52,3,45,3,50,3,50,3
     DATA 52,3,54,3,50,6,49,3,0,3,50,3,50,3,52,3,54,3,55,3
     DATA 54,3,52,3,50,3,49,3,45,3,47,3,49,3,50,6,50,3,0,3
     DATA 47,5,49,1,47,3,45,3,47,3,49,3,50,3,0,3,45,5,47
     DATA 1,45,3,43,3,42,6,45,3,0,3,47,5,49,1,47,3,45,3
     DATA 47,3,49,3,50,3,47,3,45,3,50,3,49,3,52,3,50,6,50,6
     DATA -1,-1
L23: DATA -2,"FUNERAL MARCH OF A MARIONETTE - GOUNOD"
     DATA 37,1,0,2,30,1,0,5,42,3,42,3,41,3,39,3,41,3,0,3,42
     DATA 3,44,3,0,3,37,1,0,2,30,1,0,5,42,3,42,3,41,3,39,3
     DATA 41,3,0,3,42,3,44,3,0,3,37,3,42,3,0,3,45,3
     DATA 49,6,47,3,45,3,0,3,49,3,52,6,50,3,49,3,0,3
     DATA 53,3,56,6,54,3,53,3,50,3,49,3,47,3,45,3,44,3
     DATA 30,1,0,5,42,3,42,3,41,3,39,3,41,3,0,3,42,3,44,3
     DATA 0,3,37,1,0,2,30,1,0,5,42,3,42,3,41,3,39,3,41,3
     DATA 0,3,42,3,44,3,0,3,37,3,45,3,0,3,49,3,52,6,50,3
     DATA 49,3,47,3,45,3,43,3,47,3,50,3,42,3
     DATA 41,3,42,3,44,3,0,3,45,1,0,2,44,9,42,1
     DATA -1,-1
L24: DATA -2,"STARS AND STRIPES FOREVER - SOUSA "
     DATA 54,6,54,6,52,3,51,3,51,6,50,3,51,3,51,16,0,2,50,3
     DATA 51,3,51,6,50,3,51,3,54,6,51,3,54,3,52,12,49,6,0
     DATA 3,49,3,49,6,48,3,49,3,49,6,48,3,49,3,52,16,0,2,51
     DATA 3,49,3,51,3,54,9,56,9,56,3,49,16,0,2,54,6
     DATA 54,6,52,3,51,3,51,6,50,3,51,3,51,16,0,2,50,3
     DATA 51,3,51,6,50,3 ,51,3,52,3,51,3,49,5,46,1,49,12
     DATA 47,6,0,3,47,3,47,6,46,3,47,3,50,6,49,3,47,3
     DATA 59,15,0,3,47,3,49,3,51,3,54,1,0,2,47,3,49,3,51
     DATA 3,54,1,0,2,42,3,44,5,51,1,49,12,47,1
     DATA -1,-1
L25: DATA -2,"Mexican Hat Dance - Traditional "
     DATA 52,2,57,2,0,2,52,2,57,2,0,2,52,2,57,6,0,4,52,2
     DATA 57,2,59,2,57,2,56,4,57,2,59,2,0,8,52,2,56,2,0,2
     DATA 52,2,56,2,0,2,52,2,56,6,0,4,52,2,56,2,57,2,56,2
     DATA 54,4,56,2,57,2,0,6,64,2,63,2,64,2,61,2,60,2,61,2
     DATA 57,2,56,2,57,2,52,2,0,4,49,2,50,2,52,2,54,2,56
     DATA 2,57,2,59,2,61,2,62,2,59,2,0,4,62,2,61,2,62,2
     DATA 59,2,58,2,59,2,56,2,55,2,56,2,52,2
     DATA 0,4,64,2,63,2,64,2,66,2,64,2,62,2,61,2,59,2,57,2
     DATA -1,-1
L26: DATA -2,"SCALES                          "
     DATA 38,1,39,1,40,1,41,1,42,1,43,1,44,1,45,1,46,1,47,1
     DATA 48,1,49,1,50,1,51,1,52,1,53,1,54,1,55,1,56,1
     DATA 57,1,58,1,59,1,60,1,61,1,62,1,63,1,64,1,65,8,0,4
     DATA 65,8,64,1,63,1,62,1,61,1,60,1,59,1,58,1,57,1
     DATA 56,1,55,1,54,1,53,1,52,1,51,1,50,1,49,1,48,1
     DATA 47,1,46,1,45,1,44,1,43,1,42,1,41,1,40,1,39,1,38,8
     DATA -1,-1
L27: DATA -2,"Sakura - Japanese Folk Melody "
     DATA 49,8,49,8,51,12,0,4,49,8,49,8,51,12,0,4,49,8,51,8
     DATA 52,8,51,8,49,8,51,4,49,4,45,16,44,8,40,8,44,8,45,8
     DATA 44,8,44,4,40,4,39,16,49,8,49,8,51,12,0,4,49,8,49,8,51
     DATA 12,0,4,40,8,44,8,45,8,49,8,51,4,49,4,45,8,44,16
     DATA -1,-1

