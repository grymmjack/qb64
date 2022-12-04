REM Demonstration of a Separated segment in a pie chart
REM \CHAP14\CH14_9.BAS
   
 SCREEN 7: CLS : COLOR 15, 0:         
 DIM M(20), T$(20), X(20), Y(20)
 PI = 3.141592: PI2 = 2 * PI
 DEF FNWIN (X) = .02 * PI * X
 A = 0: F = 1.745329E-02
 MX = 160: MY = 100: RADIUS = 90: ASPECT = 5 / 6

'Input the number of sectors and accept data from the user
 INPUT "INPUT Nsectors="; N
 FOR I = 1 TO N
   PRINT "INPUT M"; I; "  Text"; I; : INPUT M(I), T$(I)
 NEXT I

'Input text labels
 INPUT "INPUT Nlabel="; WB
 FOR I = 1 TO N
   T = T + M(I)
 NEXT I
 CLS

'DATA conversion
    FOR I = 1 TO N
      M(I) = M(I) * 100 / T
    NEXT I: A = 0

'Drawing N sectors
 FOR I = 1 TO N
   V = FNWIN(M(I))
   IF A + V > PI2 THEN A = PI2 - V
     WIN = (A + A + V) / 2: X(I) = RADIUS * .2 * COS(WIN)
     Y(I) = -(RADIUS * .2 * SIN(WIN) * ASPECT): A = A + V
   NEXT I
   A = .000001
   FOR I = 1 TO N
     IF I = WB THEN
       XT = X(I): YT = Y(I)
     ELSE XT = 0: YT = 0
     END IF
     V = FNWIN(M(I)): COL = I
     IF A + V > PI2 THEN A = PI2 - V
       CIRCLE (MX + XT, MY + YT), RADIUS, COL, -A, -(A + V)
       WIN = (A + A + V) / 2: X = MX + RADIUS * .5 * COS(WIN)
       Y = MY + RADIUS * .5 * SIN(WIN) * ASPECT
       PAINT (X + XT, 200 - (Y - YT)), COL, COL
       A = A + V
   NEXT I

'Printing character labels with automatic positioning
 A = 0
 FOR I = 1 TO N
   IF I = WB THEN XT = X(I): YT = Y(I) ELSE XT = 0: YT = 0
     V = FNWIN(M(I)): IF A + V > PI2 THEN A = PI2 - V
     WIN = (A + A + V) / 2: X = MX + RADIUS * .8 * COS(WIN)
     Y = MY + RADIUS * .8 * SIN(WIN) * ASPECT
     LOCATE 1 + (200 - (Y - YT)) / 8, 1 + (X + XT) / 8
     IF (X + XT) < MX THEN PRINT STRING$(LEN(T$(I)), 29);
     PRINT T$(I); : A = A + V
 NEXT I: T = 0
 LINE (10, 0)-(309, 199), 3, B
 M$ = INPUT$(1)

