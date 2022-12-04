REM LOGO graphics for QBasic
REM \CHAP9\CH9_1.BAS

DECLARE SUB DOT (Xc!, Yc!)
DECLARE SUB LT (Q!)
DECLARE SUB RT (Q!)
DECLARE SUB SETPOS (Xc!, Yc!)
DECLARE SUB PD ()
DECLARE SUB SETPC (C!)
DECLARE SUB SETH (Head!)
DECLARE SUB CS ()
DECLARE SUB FD (L!)
DECLARE SUB BK (L!)
DECLARE SUB SETX (Xc!)
DECLARE SUB SETY (Yc!)
DECLARE SUB SETSCR (Msx!, Msy!)
COMMON SHARED Col, HD, PS, Mx, My, Xcor, Ycor, X0, Y0

'This is LOGO-programm:
'********************************************************
X0 = 320: Y0 = 175 'Set center point coordinate
SCREEN 9           'Set EGA mode
CS                 'Clear screen, initial
PD                 'Pen down
SETSCR 1.5, 1      'Set screen Mx=2, My=1
DOT 0, 0           'Set point (0,0)
DOT -10, -10       'Set point (-10,-10)
SETX 20:  SETY 20  'Drawing quadrat
SETX -20: SETY -20

DOT -50, 35        'Set position (-50,35)
SETPC 14           'Set pen color Col=14
FD 100             'Forward in distance 100
SETH 60            'Set head HD=60 deg.
BK 100             'Back in distance 100
SETH -60           'Set head HD=-60 deg.
BK 100             'Back in 100 distance

DOT 95, -20        'Set point (95,-20)
SETH 90            'Set head HD=90 deg.
SETPC 12           'Set pen color Col=13
  FOR I = 1 TO 10  '10 cicles
    FD 62          'Forward in distance 62
    LT 36          'Rotate left in 36 deg.
  NEXT             'End cicles
f$ = INPUT$(1)     'Stop programm
'*******************************************************

SUB BK (L)
'Back in distance L
  FD -L
END SUB

SUB CS
'Clearing screen and initializing
  CLS       'Clear screen
  HD = 0    'Set heading = 0
  Xcor = 0  'Set Xcor = 0
  Ycor = 0  'Set Ycor = 0
  PS = 0    'Set pen status 0 (pen down)
  Col = 15  'Color Col = 15
  Mx = 1    'Set scale Msx = 1
  My = 1    'Set scale Msy = 1
  PRESET (X0, Y0)  'Initial start point
END SUB

SUB DOT (Xc, Yc)
'Set point in position (Xc,Yc)
  Xcor = Xc * Mx
  Ycor = Yc * My
  IF PS = 0 THEN PSET (X0 + Xcor, Y0 - Ycor), Col
END SUB

SUB FD (L)
  'Forward in  distance L
  PI = 3.141593
  HDR = HD * PI / 180
  Xnew = Xcor + L * Mx * COS(HDR)
  Ynew = Ycor + L * My * SIN(HDR)
  IF PS = 0 THEN LINE -(X0 + Xnew, Y0 - Ynew), Col
  Xcor = Xnew
  Ycor = Ynew
END SUB

SUB LT (Q)
'Left rotate in Q deg.
  HD = HD + Q
END SUB

SUB PD
'Set pen down
  PS = 0
END SUB

SUB PU
'Set pen up
  PS = 1
END SUB

SUB RT (Q)
'Right rotate in Q deg.
  HD = HD - Q
END SUB

SUB SETH (Q)
'Set heading in Q
  HD = Q
END SUB

SUB SETPC (C)
'Set pen color Col
  Col = C
END SUB

SUB SETPOS (Xc, Yc)
'Drawing in position (Mx*Xc,My*Yc)
  Xcor = Mx * Xc
  Ycor = My * Yc
  IF PS = 0 THEN LINE -(X0 + Xcor, Y0 - Ycor)
END SUB

SUB SETSCR (Sx, Sy)
'Set scale coefficients Mx and My
  Mx = Sx
  My = Sy
END SUB

SUB SETX (Xc)
'Horizontal movement in distance Mx * Xc
  Xnew = Xcor + Mx * Xc
  IF PS = 0 THEN LINE -(X0 + Xnew, Y0 - Ycor), Col
  Xcor = Xnew
END SUB

SUB SETY (Yc)
'Vertical movement in distance My * Yc
  Ynew = Ycor + My * Yc
  IF PS = 0 THEN LINE -(X0 + Xcor, Y0 - Ynew), Col
  Ycor = Ynew
END SUB

