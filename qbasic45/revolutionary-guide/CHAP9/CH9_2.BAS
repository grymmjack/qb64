REM LOGO graphics for QBasic
REM \CHAP9\CH9_2.BAS

DECLARE SUB DOT (Xc!, Yc!)
DECLARE SUB letq (H!)
DECLARE SUB LT (Q!)
DECLARE SUB RT (Q!)
DECLARE SUB SETH (Head!)
DECLARE SUB CS ()
DECLARE SUB FD (L!)
DECLARE SUB BK (L!)
COMMON SHARED Col, HD, PS, Mx, My, Xcor, Ycor, X0, Y0

'This is LOGO-programm:
'********************************************************
'Three letters "q"
X0 = 320: Y0 = 175
   SCREEN 9: CS
'1st
   DOT -150, 0
   SETH 40
   letq 20
'2nd
   DOT 0, 0
   SETH -10
   letq 30
'3rd
   DOT 100, 10
   SETH -130
   letq 10
F$ = INPUT$(1)
'*******************************************************

SUB BK (L)
'Back in distance L
  FD -L
END SUB

SUB CS
'Clear screen and initializing
  CLS       'Clear screen
  HD = 0    'Set heading = 0
  Xcor = 0  'Set Xcor = 0
  Ycor = 0  'Set Ycor = 0
  PS = 0    'Set pen status 0 (pen down)
  Col = 15  'Color Col = 15
  Mx = 1    'Set scale Msx = 1
  My = 1    'Set scale Msy = 1
  PRESET (X0, Y0) 'Initial start point
END SUB

SUB DOT (Xc, Yc)
'Set point in position (Xc,Yc)
  Xcor = Mx * Xc
  Ycor = My * Yc
  IF PS = 0 THEN PSET (X0 + Xcor, Y0 - Ycor)
END SUB

SUB FD (L)
  'Forward in  distance L
  PI = 3.141593
  HDR = HD * PI / 180
  Xnew = Xcor + L * Mx * COS(HDR)
  Ynew = Ycor + L * My * SIN(HDR)
  IF PS = 0 THEN LINE -(320 + Xnew, 175 - Ynew), Col
  Xcor = Xnew
  Ycor = Ynew
END SUB

SUB letq (H)
  LT 90
  FD 2 * H
  LT 45
  FD H
  LT 45
  FD H
  LT 45
  FD H
  LT 45
  FD 2 * H
  LT 45
  FD H
  LT 45
  FD H
  LT 45
  FD H
  LT 45
  BK 3 * H
  RT 30
  FD H
END SUB

SUB LT (Q)
'Left rotate in Q deg.
  HD = HD + Q
END SUB

SUB RT (Q)
'Right rotate in Q deg.
  HD = HD - Q
END SUB

SUB SETH (Q)
'Set heading in Q
  HD = Q
END SUB

SUB SETPOS (Xc, Yc)
'Drawing line in position (Xc, Yc)
  Xcor = Xc
  Ycor = Yc
  IF PS = 0 THEN LINE -(X0 + Xcor, Y0 - Ycor)
END SUB

