REM Demonstration of a Separated segment in a pie chart
REM \CHAP14\CH14_9.BAS
   
$Resize:Smooth
_Title "Pie Chart Demo"

 Screen 7: Cls : Color 15, 0:         
    _AllowFullScreen _SquarePixels , _Smooth
 Dim M(20), T$(20), X(20), Y(20)
 PI = 3.141592: PI2 = 2 * PI

 A = 0: F = 1.745329E-02
 MX = 160: MY = 100: RADIUS = 90: ASPECT = 5 / 6

'Input the number of sectors and accept data from the user
 Input "Input Nsectors="; N
 For I = 1 TO N
   Print "Input M"; I; "  Text"; I; : Input M(I), T$(I)
 Next I

'Input text labels
 Input "Input Nlabel="; WB
 For I = 1 TO N
   T = T + M(I)
 Next I
 Cls

'Data conversion
    For I = 1 TO N
      M(I) = M(I) * 100 / T
    Next I: A = 0

'Drawing N sectors
 For I = 1 TO N
   V = FNWIN(M(I))
   If A + V > PI2 Then A = PI2 - V
     WIN = (A + A + V) / 2: X(I) = RADIUS * .2 * Cos(WIN)
     Y(I) = -(RADIUS * .2 * Sin(WIN) * ASPECT): A = A + V
   Next I
   A = .000001
   For I = 1 TO N
     If I = WB Then
       XT = X(I): YT = Y(I)
     Else XT = 0: YT = 0
     End If
     V = FNWIN(M(I)): COL = I
     If A + V > PI2 Then A = PI2 - V
       Circle (MX + XT, MY + YT), RADIUS, COL, -A, -(A + V)
       WIN = (A + A + V) / 2: X = MX + RADIUS * .5 * Cos(WIN)
       Y = MY + RADIUS * .5 * Sin(WIN) * ASPECT
       Paint (X + XT, 200 - (Y - YT)), COL, COL
       A = A + V
   Next I

'Printing character labels with automatic positioning
 A = 0
 For I = 1 TO N
   If I = WB Then XT = X(I): YT = Y(I) Else XT = 0: YT = 0
     V = FNWIN(M(I)): If A + V > PI2 Then A = PI2 - V
     WIN = (A + A + V) / 2: X = MX + RADIUS * .8 * Cos(WIN)
     Y = MY + RADIUS * .8 * Sin(WIN) * ASPECT
     Locate 1 + (200 - (Y - YT)) / 8, 1 + (X + XT) / 8
     If (X + XT) < MX Then Print STRING$(Len(T$(I)), 29);
     Print T$(I); : A = A + V
 Next I: T = 0
 Line (10, 0)-(309, 199), 3, B
 M$ = Inkey$

Function FNWIN (X)
    FNWIN = .02 * PI * X
End Function

