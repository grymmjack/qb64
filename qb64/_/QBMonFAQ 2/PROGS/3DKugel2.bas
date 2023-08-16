'**************************************************************************
' 3DKUGEL2.BAS = Zeigt 3D-Kugeln an
' ============
' Dieses GW-BASIC / QBasic-Programm zeigt 5
' dreidimensionale Kugeln als Drahtgittermodell an.
'
' Das Programm stammt aus dem GW-BASIC-Handbuch
'**************************************************************************
10 'This will draw 5 spheres
20 GOTO 160
50 IF VERT GOTO 100
60 CIRCLE (X, Y), R, C, , , .07
70 FOR I = 1 TO 5
80 CIRCLE (X, Y), R, C, , , I * .2: NEXT I
90 IF VERT THEN RETURN
100 CIRCLE (X, Y), R, C, , , 1.3
110 CIRCLE (X, Y), R, C, , , 1.9
120 CIRCLE (X, Y), R, C, , , 3.6
130 CIRCLE (X, Y), R, C, , , 9.8
140 IF VERT GOTO 60
150 RETURN
160 CLS : SCREEN 1: COLOR 0, 1: KEY OFF: VERT = 0
170 X = 160: Y = 100: C = 1: R = 50: GOSUB 50
180 X = 30: Y = 30: C = 2: R = 30: GOSUB 50
190 X = 30: Y = 169: GOSUB 50
200 X = 289: Y = 30: GOSUB 50
210 X = 289: Y = 169: GOSUB 50
220 LINE (30, 30)-(289, 169), 1
230 LINE (30, 169)-(289, 30), 1
240 LINE (30, 169)-(289, 30), 1, B
250 Z$ = INKEY$: IF Z$ = "" THEN 250

